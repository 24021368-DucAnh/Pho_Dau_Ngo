extends Node
class_name OrderManager

enum OrderStatus {
	ACCEPTED,
	PREPARING,
	READY,
	SERVED,
	CANCELLED,
}

signal order_changed(order_id: StringName, order: Dictionary)

var _orders: Dictionary = {}


func create_order(order_id: StringName, recipe_id: StringName, table_id: StringName) -> Dictionary:
	if order_id == &"" or recipe_id == &"" or table_id == &"":
		return {"ok": false, "message": "Mã đơn, công thức và bàn không được để trống."}
	if _orders.has(order_id):
		return {"ok": false, "message": "Mã đơn đã tồn tại."}
	var order := {
		"order_id": order_id,
		"recipe_id": recipe_id,
		"table_id": table_id,
		"status": OrderStatus.ACCEPTED,
	}
	_orders[order_id] = order
	order_changed.emit(order_id, order.duplicate(true))
	return {"ok": true, "message": "Đã nhận đơn.", "order_id": order_id}


func get_order(order_id: StringName) -> Dictionary:
	if not _orders.has(order_id):
		return {}
	return (_orders[order_id] as Dictionary).duplicate(true)


func get_orders() -> Array:
	var result: Array = []
	for order_id in _orders:
		result.append((_orders[order_id] as Dictionary).duplicate(true))
	return result


func get_orders_by_status(status: int) -> Array:
	var result: Array = []
	for order_id in _orders:
		var order: Dictionary = _orders[order_id]
		if int(order.get("status", -1)) == status:
			result.append(order.duplicate(true))
	return result


func get_open_orders() -> Array:
	var result: Array = []
	for order_id in _orders:
		var order: Dictionary = _orders[order_id]
		var status := int(order.get("status", -1))
		if status != OrderStatus.SERVED and status != OrderStatus.CANCELLED:
			result.append(order.duplicate(true))
	return result


func transition_order(order_id: StringName, next_status: int) -> Dictionary:
	if not _orders.has(order_id):
		return {"ok": false, "message": "Không tìm thấy đơn."}
	var order: Dictionary = _orders[order_id]
	var current_status := int(order.get("status", -1))
	var allowed := (
		(current_status == OrderStatus.ACCEPTED and next_status == OrderStatus.PREPARING)
		or (current_status == OrderStatus.PREPARING and next_status == OrderStatus.READY)
		or (current_status == OrderStatus.READY and next_status == OrderStatus.SERVED)
		or (current_status == OrderStatus.ACCEPTED and next_status == OrderStatus.CANCELLED)
		or (current_status == OrderStatus.PREPARING and next_status == OrderStatus.CANCELLED)
		or (current_status == OrderStatus.READY and next_status == OrderStatus.CANCELLED)
	)
	if not allowed:
		return {"ok": false, "message": "Trạng thái đơn không cho phép chuyển như vậy."}
	order["status"] = next_status
	_orders[order_id] = order
	order_changed.emit(order_id, order.duplicate(true))
	return {"ok": true, "message": "Đã cập nhật trạng thái đơn.", "order": order.duplicate(true)}
