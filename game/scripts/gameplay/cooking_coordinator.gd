extends Node
class_name CookingCoordinator

var _orders: OrderManager
var _bowl_to_order: Dictionary = {}
var _order_to_bowl: Dictionary = {}

func configure(orders: OrderManager) -> Dictionary:
	if orders == null:
		return {"ok": false, "message": "Thiếu hệ thống đơn."}
	_orders = orders
	return {"ok": true}

func bind_bowl_to_order(bowl_id: StringName, order_id: StringName) -> Dictionary:
	if _orders == null or bowl_id == &"" or order_id == &"":
		return {"ok": false, "message": "Thiếu mã bát, đơn hoặc hệ thống đơn."}
	if _bowl_to_order.has(bowl_id) or _order_to_bowl.has(order_id):
		return {"ok": false, "message": "Bát hoặc đơn đã được gắn trước đó."}
	var order := _orders.get_order(order_id)
	if order.is_empty() or int(order.get("status", -1)) >= OrderManager.OrderStatus.SERVED:
		return {"ok": false, "message": "Đơn không còn nhận bát."}
	_bowl_to_order[bowl_id] = order_id
	_order_to_bowl[order_id] = bowl_id
	return {"ok": true, "order_id": order_id}

func lookup_bowl_order(bowl_id: StringName) -> StringName:
	return StringName(_bowl_to_order.get(bowl_id, &""))

func release_after_wash(bowl_id: StringName) -> Dictionary:
	if not _bowl_to_order.has(bowl_id):
		return {"ok": false, "message": "Bát chưa gắn đơn."}
	var order_id: StringName = _bowl_to_order[bowl_id]
	var order := _orders.get_order(order_id)
	if int(order.get("status", -1)) != OrderManager.OrderStatus.SERVED and int(order.get("status", -1)) != OrderManager.OrderStatus.CANCELLED:
		return {"ok": false, "message": "Đơn chưa kết thúc."}
	_bowl_to_order.erase(bowl_id)
	_order_to_bowl.erase(order_id)
	return {"ok": true}
