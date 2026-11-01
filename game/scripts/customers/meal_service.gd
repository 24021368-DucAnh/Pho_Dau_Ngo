extends Node
class_name MealService

signal meal_finished(order_id: StringName)

@export var meal_seconds: float = 8.0

var _orders: OrderManager
var _meals: Dictionary = {}

func configure(orders: OrderManager) -> Dictionary:
	if orders == null:
		return {"ok": false, "message": "Thiếu hệ thống đơn."}
	_orders = orders
	return {"ok": true}

func start_meal(order_id: StringName, customer_id: StringName) -> Dictionary:
	if _orders == null or customer_id == &"" or _meals.has(order_id):
		return {"ok": false, "message": "Bữa ăn không hợp lệ hoặc đã bắt đầu."}
	var order := _orders.get_order(order_id)
	if order.is_empty() or int(order.get("status", -1)) != OrderManager.OrderStatus.SERVED:
		return {"ok": false, "message": "Đơn chưa được giao."}
	_meals[order_id] = {"customer_id": customer_id, "remaining": maxf(meal_seconds, 0.01)}
	return {"ok": true}

func _process(delta: float) -> void:
	if get_tree().paused or _meals.is_empty():
		return
	for order_id in _meals.keys():
		var meal: Dictionary = _meals[order_id]
		meal["remaining"] = float(meal["remaining"]) - delta
		if float(meal["remaining"]) > 0.0:
			_meals[order_id] = meal
			continue
		_meals.erase(order_id)
		var result := _orders.set_payment_pending(order_id)
		if bool(result.get("ok", false)):
			meal_finished.emit(order_id)
