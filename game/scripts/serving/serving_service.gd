extends Node
class_name ServingService

signal payment_recorded(order_id: StringName, recipe_id: StringName, table_id: StringName)
signal order_delivered(order_id: StringName, table_id: StringName)

var payment_event_count: int = 0
var _paid_order_ids: Dictionary = {}
var _ledger: Node
var _ledger_day_id: StringName = &""


func configure_ledger(ledger: Node, day_id: StringName) -> Dictionary:
	if ledger == null or not is_instance_valid(ledger):
		return {"ok": false, "message": "Ledger chưa sẵn sàng."}
	if not ledger.has_method("record_transaction") or not ledger.has_method("get_day_totals"):
		return {"ok": false, "message": "Đối tượng được cung cấp không phải Ledger hợp lệ."}
	if day_id.is_empty():
		return {"ok": false, "message": "Mã ngày bán hàng không được để trống."}
	_ledger = ledger
	_ledger_day_id = day_id
	return {"ok": true}

func deliver_order(bowl: InteractiveBowl, orders: OrderManager, order_id: StringName, table_id: StringName) -> Dictionary:
	if bowl == null or orders == null or not is_instance_valid(bowl):
		return {"ok": false, "message": "Thiếu bát hoặc hệ thống đơn."}
	var order := orders.get_order(order_id)
	if order.is_empty() or int(order.get("status", -1)) != OrderManager.OrderStatus.READY:
		return {"ok": false, "message": "Đơn chưa sẵn sàng giao."}
	if bowl.state != InteractiveBowl.BowlState.PLACED or not bowl.is_ready_to_serve():
		return {"ok": false, "message": "Bát chưa đặt đúng hoặc chưa hoàn thành."}
	if StringName(order.get("recipe_id", &"")) != bowl.prepared_recipe_id or StringName(order.get("table_id", &"")) != table_id:
		return {"ok": false, "message": "Sai món hoặc sai bàn."}
	var moved := orders.transition_order(order_id, OrderManager.OrderStatus.SERVED)
	if not bool(moved.get("ok", false)):
		return moved
	bowl.mark_in_service()
	order_delivered.emit(order_id, table_id)
	return {"ok": true, "message": "Đã giao món. Chờ khách ăn xong rồi thanh toán."}

func settle_order(orders: OrderManager, order_id: StringName, sale_amount: int) -> Dictionary:
	if orders == null or _ledger == null or sale_amount <= 0:
		return {"ok": false, "message": "Thiếu đơn, Ledger hoặc giá bán hợp lệ."}
	if _paid_order_ids.has(order_id):
		return {"ok": false, "message": "Đơn đã thanh toán."}
	var order := orders.get_order(order_id)
	if order.is_empty() or int(order.get("payment_status", -1)) != OrderManager.PaymentStatus.PAYMENT_PENDING:
		return {"ok": false, "message": "Khách chưa ăn xong hoặc đơn đã thanh toán."}
	var posted: Dictionary = _ledger.record_transaction(StringName("sale:%s" % String(order_id)), _ledger_day_id, &"sale_revenue", sale_amount, order_id)
	if not bool(posted.get("ok", false)):
		return {"ok": false, "message": "Không ghi được tiền: %s" % String(posted.get("reason", "lỗi"))}
	var paid := orders.set_paid(order_id)
	if not bool(paid.get("ok", false)):
		return paid
	_paid_order_ids[order_id] = true
	payment_event_count += 1
	payment_recorded.emit(order_id, StringName(order.get("recipe_id", &"")), StringName(order.get("table_id", &"")))
	return {"ok": true, "message": "Đã thu tiền một lần.", "payment_events": 1}


func serve_order(
	bowl: InteractiveBowl,
	order_manager: OrderManager,
	order_id: StringName,
	delivery_table_id: StringName,
	sale_amount: int = -1
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
	if bowl.state != InteractiveBowl.BowlState.PLACED:
		return {"ok": false, "message": "Đặt bát vào vùng bàn trước khi giao món."}
	if not bowl.is_ready_to_serve():
		return {"ok": false, "message": "Bát chưa hoàn thành, chưa thể phục vụ."}
	if StringName(order.get("recipe_id", &"")) != bowl.prepared_recipe_id:
		return {"ok": false, "message": "Bát không khớp công thức của đơn."}
	if StringName(order.get("table_id", &"")) != delivery_table_id:
		return {"ok": false, "message": "Sai bàn nhận món."}

	# The first slice has no approved price catalogue yet. Require the caller to
	# provide an explicit positive integer price whenever a Ledger is configured.
	# Stable transaction IDs let a retry after a partial interruption replay safely.
	if _ledger != null:
		if not is_instance_valid(_ledger):
			return {"ok": false, "message": "Ledger không còn hợp lệ."}
		if sale_amount <= 0:
			return {"ok": false, "message": "Giá bán phải là số nguyên dương khi ghi Ledger."}
		var transaction_id := StringName("sale:%s" % String(order_id))
		var posted: Dictionary = _ledger.record_transaction(
			transaction_id,
			_ledger_day_id,
			&"sale_revenue",
			sale_amount,
			order_id
		)
		if not bool(posted.get("ok", false)):
			return {
				"ok": false,
				"message": "Không thể ghi doanh thu vào Ledger: %s" % String(posted.get("reason", "lỗi không xác định")),
				"payment_events": 0
			}

	var transition := order_manager.transition_order(order_id, OrderManager.OrderStatus.SERVED)
	if not bool(transition.get("ok", false)):
		return {"ok": false, "message": String(transition.get("message", "Không thể hoàn tất đơn.")), "payment_events": 0}
	# A served bowl is used: it becomes dirty and must be washed before it
	# can be cooked or served again. This is what makes the multi-order loop
	# close — serve → dirty → wash → next order — instead of reusing a bowl
	# that still looks ready.
	bowl.mark_served_dirty()
	order_manager.set_payment_pending(order_id)
	order_manager.set_paid(order_id)
	_paid_order_ids[order_id] = true
	payment_event_count += 1
	payment_recorded.emit(order_id, StringName(order.get("recipe_id", &"")), delivery_table_id)
	return {"ok": true, "message": "Đã phục vụ đúng đơn và ghi nhận thanh toán.", "payment_events": 1}
