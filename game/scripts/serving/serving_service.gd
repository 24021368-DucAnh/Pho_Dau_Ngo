extends Node
class_name ServingService

signal payment_recorded(order_id: StringName, recipe_id: StringName, table_id: StringName)

var payment_event_count: int = 0
var _paid_order_ids: Dictionary = {}


func serve_order(
	bowl: InteractiveBowl,
	order_manager: OrderManager,
	order_id: StringName,
	delivery_table_id: StringName
) -> Dictionary:
	if bowl == null or not is_instance_valid(bowl):
		return {"ok": false, "message": "Không có bát hợp lệ."}
	if order_manager == null or not is_instance_valid(order_manager):
		return {"ok": false, "message": "Hệ thống đơn hàng chưa sẵn sàng."}
	if _paid_order_ids.has(order_id):
		return {"ok": false, "message": "Đơn này đã được thanh toán.", "payment_events": 0}
	var order := order_manager.get_order(order_id)
	if order.is_empty():
		return {"ok": false, "message": "Không tìm thấy đơn."}
	if int(order.get("status", -1)) != OrderManager.OrderStatus.READY:
		return {"ok": false, "message": "Đơn chưa ở trạng thái sẵn sàng nhận món."}
	if not bowl.is_ready_to_serve():
		return {"ok": false, "message": "Bát chưa hoàn thành, chưa thể phục vụ."}
	if StringName(order.get("recipe_id", &"")) != bowl.prepared_recipe_id:
		return {"ok": false, "message": "Bát không khớp công thức của đơn."}
	if StringName(order.get("table_id", &"")) != delivery_table_id:
		return {"ok": false, "message": "Sai bàn nhận món."}
	var transition := order_manager.transition_order(order_id, OrderManager.OrderStatus.SERVED)
	if not bool(transition.get("ok", false)):
		return {"ok": false, "message": String(transition.get("message", "Không thể hoàn tất đơn."))}
	_paid_order_ids[order_id] = true
	payment_event_count += 1
	payment_recorded.emit(order_id, StringName(order.get("recipe_id", &"")), delivery_table_id)
	return {"ok": true, "message": "Đã phục vụ đúng đơn và ghi nhận thanh toán.", "payment_events": 1}
