extends Node
class_name DayController

signal day_started(day_id: StringName)
signal day_closed(summary: Dictionary)

var _ledger: Node
var _inventory: Node
var _day_id: StringName = &""
var _active: bool = false
var _last_summary: Dictionary = {}


func configure(ledger: Node, inventory: Node) -> Dictionary:
	if ledger == null or not is_instance_valid(ledger):
		return {"ok": false, "message": "Ledger chưa sẵn sàng."}
	if not ledger.has_method("record_transaction") or not ledger.has_method("get_day_totals") or not ledger.has_method("close_day"):
		return {"ok": false, "message": "Ledger không đáp ứng hợp đồng cần thiết."}
	if inventory == null or not is_instance_valid(inventory) or not inventory.has_method("snapshot"):
		return {"ok": false, "message": "Inventory chưa sẵn sàng hoặc không hỗ trợ snapshot."}
	if _active:
		return {"ok": false, "message": "Không thể đổi cấu hình khi ngày bán hàng đang hoạt động."}
	_ledger = ledger
	_inventory = inventory
	return {"ok": true}


func start_day(day_id: StringName, opening_cash: int) -> Dictionary:
	if _active:
		return {"ok": false, "message": "Một ngày bán hàng đang hoạt động."}
	if _ledger == null or not is_instance_valid(_ledger) or _inventory == null or not is_instance_valid(_inventory):
		return {"ok": false, "message": "Hãy cấu hình Ledger và Inventory trước khi mở ngày."}
	if day_id.is_empty():
		return {"ok": false, "message": "Mã ngày không được để trống."}
	if opening_cash <= 0:
		return {"ok": false, "message": "Tiền đầu ngày phải là số nguyên dương."}

	var existing_totals: Dictionary = _ledger.get_day_totals(day_id)
	if bool(existing_totals.get("closed", false)):
		return {"ok": false, "message": "Ngày này đã đóng, không thể mở lại."}

	var opening: Dictionary = _ledger.record_transaction(
		StringName("opening:%s" % String(day_id)),
		day_id,
		&"opening_cash",
		opening_cash,
		StringName("day-start:%s" % String(day_id))
	)
	if not bool(opening.get("ok", false)):
		return {"ok": false, "message": "Không thể ghi tiền đầu ngày: %s" % String(opening.get("reason", "lỗi không xác định"))}

	_day_id = day_id
	_active = true
	_last_summary.clear()
	day_started.emit(_day_id)
	return {"ok": true, "day_id": _day_id, "opening_cash": opening_cash, "replayed": bool(opening.get("replayed", false))}


func close_day() -> Dictionary:
	if not _last_summary.is_empty() and not _active:
		return {"ok": true, "already_closed": true, "summary": _last_summary.duplicate(true)}
	if not _active:
		return {"ok": false, "message": "Không có ngày bán hàng đang hoạt động."}
	if _ledger == null or not is_instance_valid(_ledger) or _inventory == null or not is_instance_valid(_inventory):
		return {"ok": false, "message": "Ledger hoặc Inventory không còn hợp lệ."}

	var close_result: Dictionary = _ledger.close_day(_day_id)
	if not bool(close_result.get("ok", false)):
		return {"ok": false, "message": "Không thể đóng ngày: %s" % String(close_result.get("reason", "lỗi không xác định"))}

	var totals: Dictionary = _ledger.get_day_totals(_day_id)
	var inventory_snapshot: Dictionary = _inventory.snapshot()
	var summary := {
		"day_id": _day_id,
		"complete": bool(totals.get("complete", false)),
		"closed": bool(totals.get("closed", false)),
		"opening_cash": int(totals.get("opening_cash", 0)),
		"revenue": int(totals.get("revenue", 0)),
		"purchases": int(totals.get("purchases", 0)),
		"closing_cash": int(totals.get("closing_cash", 0)),
		"transaction_count": int(totals.get("transaction_count", 0)),
		"inventory_snapshot": inventory_snapshot.duplicate(true)
	}
	_last_summary = summary.duplicate(true)
	_active = false
	day_closed.emit(summary.duplicate(true))
	return {"ok": true, "already_closed": bool(close_result.get("already_closed", false)), "summary": summary.duplicate(true)}
