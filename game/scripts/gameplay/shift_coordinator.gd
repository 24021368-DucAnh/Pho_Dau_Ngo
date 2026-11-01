extends Node
class_name ShiftCoordinator

signal shift_phase_changed(phase: int)
signal shift_summary_ready(summary: Dictionary)

enum Phase { PRE_OPEN, OPEN, CLOSING, CLOSED }

var phase: Phase = Phase.PRE_OPEN
var _orders: OrderManager
var _serving: ServingService
var _day: DayController
var _inventory: InventoryService
var _summary: Dictionary = {}


func configure(orders: OrderManager, serving: ServingService, day: DayController, inventory: InventoryService) -> Dictionary:
	if orders == null or serving == null or day == null or inventory == null:
		return {"ok": false, "message": "Thiếu dịch vụ để điều phối ca."}
	if phase != Phase.PRE_OPEN:
		return {"ok": false, "message": "Không thể đổi cấu hình sau khi mở ca."}
	_orders = orders
	_serving = serving
	_day = day
	_inventory = inventory
	return {"ok": true}


func open_shift(day_id: StringName, opening_cash: int) -> Dictionary:
	if phase != Phase.PRE_OPEN:
		return {"ok": false, "message": "Ca đã được mở."}
	if _day == null:
		return {"ok": false, "message": "Chưa cấu hình ca."}
	var result := _day.start_day(day_id, opening_cash)
	if bool(result.get("ok", false)):
		phase = Phase.OPEN
		shift_phase_changed.emit(phase)
	return result


func can_accept_arrivals() -> bool:
	return phase == Phase.OPEN


func request_close() -> Dictionary:
	if phase == Phase.CLOSED:
		return {"ok": true, "already_closed": true, "summary": _summary.duplicate(true)}
	if phase != Phase.OPEN and phase != Phase.CLOSING:
		return {"ok": false, "message": "Ca chưa mở."}
	if phase == Phase.OPEN:
		phase = Phase.CLOSING
		shift_phase_changed.emit(phase)
	return {"ok": true, "outstanding_orders": _orders.get_open_orders().size() + _orders.get_unpaid_delivered_orders().size()}


func finish_close() -> Dictionary:
	if phase == Phase.CLOSED:
		return {"ok": true, "already_closed": true, "summary": _summary.duplicate(true)}
	if phase != Phase.CLOSING:
		return {"ok": false, "message": "Hãy yêu cầu đóng ca trước."}
	if not _orders.get_unpaid_delivered_orders().is_empty():
		return {"ok": false, "message": "Còn khách đã ăn chưa thanh toán."}
	var result := _day.close_day()
	if bool(result.get("ok", false)):
		_summary = Dictionary(result.get("summary", {})).duplicate(true)
		phase = Phase.CLOSED
		shift_phase_changed.emit(phase)
		shift_summary_ready.emit(_summary.duplicate(true))
	return result
