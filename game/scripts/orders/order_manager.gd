extends Node
class_name OrderManager

enum OrderStatus {
	ACCEPTED,
	PREPARING,
	READY,
	SERVED,
	CANCELLED,
}

enum PaymentStatus { UNPAID, PAYMENT_PENDING, PAID }

signal order_changed(order_id: StringName, order: Dictionary)

var _orders: Dictionary = {}


func create_order(order_id: StringName, recipe_id: StringName, table_id: StringName) -> Dictionary:
	if order_id == &"" or recipe_id == &"" or table_id == &"":
		return {"ok": false, "message": "Mã đơn, công thức và bàn không được để trống."}
	if _orders.has(order_id):
		return {"ok": false, "message": "Mã đơn đã tồn tại."}
	for existing in get_open_orders():
		if StringName(existing.get("table_id", &"")) == table_id:
			return {"ok": false, "message": "Bàn này đã có đơn chưa hoàn tất."}
	var order := {
		"order_id": order_id,
		"recipe_id": recipe_id,
		"table_id": table_id,
		"status": OrderStatus.ACCEPTED,
		"payment_status": PaymentStatus.UNPAID,
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

func get_unpaid_delivered_orders() -> Array:
	var result: Array = []
	for order_id in _orders:
		var order: Dictionary = _orders[order_id]
		if int(order.get("status", -1)) == OrderStatus.SERVED and int(order.get("payment_status", PaymentStatus.UNPAID)) != PaymentStatus.PAID:
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

func set_payment_pending(order_id: StringName) -> Dictionary:
	var order := get_order(order_id)
	if order.is_empty() or int(order.get("status", -1)) != OrderStatus.SERVED:
		return {"ok": false, "message": "Đơn chưa được phục vụ."}
	if int(order.get("payment_status", -1)) != PaymentStatus.UNPAID:
		return {"ok": false, "message": "Đơn đã chờ hoặc đã thanh toán."}
	order["payment_status"] = PaymentStatus.PAYMENT_PENDING
	_orders[order_id] = order
	order_changed.emit(order_id, order.duplicate(true))
	return {"ok": true}

func set_paid(order_id: StringName) -> Dictionary:
	var order := get_order(order_id)
	if order.is_empty() or int(order.get("payment_status", -1)) != PaymentStatus.PAYMENT_PENDING:
		return {"ok": false, "message": "Đơn chưa chờ thanh toán."}
	order["payment_status"] = PaymentStatus.PAID
	_orders[order_id] = order
	order_changed.emit(order_id, order.duplicate(true))
	return {"ok": true}
