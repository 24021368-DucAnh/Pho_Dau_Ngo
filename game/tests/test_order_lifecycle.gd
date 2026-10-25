extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var order_manager := OrderManager.new()
	root.add_child(order_manager)
	await process_frame
	var created: Dictionary = order_manager.create_order(&"order-001", &"pho_bo_tai", &"table-1")
	_check(bool(created.get("ok", false)), "valid order can be created")
	var order_id := StringName(created.get("order_id", &""))
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.ACCEPTED, "new order starts accepted")
	_check(not bool(order_manager.create_order(&"order-001", &"pho_bo", &"table-2").get("ok", false)), "duplicate order ID is rejected")
	_check(bool(order_manager.transition_order(order_id, OrderManager.OrderStatus.PREPARING).get("ok", false)), "accepted order transitions to preparing")
	_check(bool(order_manager.transition_order(order_id, OrderManager.OrderStatus.READY).get("ok", false)), "preparing order transitions to ready")
	_check(not bool(order_manager.transition_order(order_id, OrderManager.OrderStatus.ACCEPTED).get("ok", false)), "illegal order transition is rejected")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "illegal transition preserves order state")

	# Multiple orders must remain independently addressable and filtered by lifecycle state.
	var second_created: Dictionary = order_manager.create_order(&"order-002", &"pho_bo_chin", &"table-2")
	_check(bool(second_created.get("ok", false)), "second order can be accepted while first is still open")
	_check(order_manager.get_orders().size() == 2, "order manager lists all accepted and active orders")
	_check(order_manager.get_open_orders().size() == 2, "open-order queue includes both active orders")
	_check(order_manager.get_orders_by_status(OrderManager.OrderStatus.READY).size() == 1, "status filter isolates ready orders")
	_check(bool(order_manager.transition_order(&"order-002", OrderManager.OrderStatus.CANCELLED).get("ok", false)), "second order can be cancelled independently")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "cancelling second order does not mutate first order")
	_check(order_manager.get_open_orders().size() == 1, "cancelled order is removed from open-order queue")
	var detached_snapshot: Dictionary = order_manager.get_order(order_id)
	detached_snapshot["status"] = OrderManager.OrderStatus.SERVED
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "mutating a returned order snapshot cannot mutate manager state")

	var tai := load("res://data/recipes/pho_bo.tres") as RecipeData
	var inventory := InventoryService.new()
	root.add_child(inventory)
	var bowl := InteractiveBowl.new()
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	collision.shape = CylinderShape3D.new()
	bowl.add_child(collision)
	root.add_child(bowl)
	await process_frame
	_check(bool(bowl.set_held()), "serving fixture bowl can be held")
	var noodle := KitchenStation.new()
	noodle.action_id = &"add_noodles"
	noodle.ingredient_id = &"noodles"
	root.add_child(noodle)
	var beef := KitchenStation.new()
	beef.action_id = &"add_raw_beef"
	beef.ingredient_id = &"raw_sliced_beef"
	root.add_child(beef)
	var broth := KitchenStation.new()
	broth.action_id = &"add_broth"
	broth.ingredient_id = &"broth"
	root.add_child(broth)
	await process_frame
	_check(bool(noodle.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "serving fixture adds noodles")
	_check(bool(beef.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "serving fixture adds tai beef")
	var ledger := Ledger.new()
	root.add_child(ledger)
	await process_frame
	_check(bool(ledger.record_transaction(&"opening-day-01", &"day-01", &"opening_cash", 100000, &"day-start").get("ok", false)), "ledger opening cash is initialized")
	var blocked_ledger := Ledger.new()
	root.add_child(blocked_ledger)
	await process_frame
	_check(bool(blocked_ledger.record_transaction(&"opening-closed-day", &"day-closed", &"opening_cash", 50000, &"day-start").get("ok", false)), "closed-day rejection fixture initializes opening cash")
	_check(bool(blocked_ledger.close_day(&"day-closed").get("ok", false)), "closed-day rejection fixture closes its day")
	var blocked_serving := ServingService.new()
	_check(bool(blocked_serving.configure_ledger(blocked_ledger, &"day-closed").get("ok", false)), "serving configures with a valid ledger")
	root.add_child(blocked_serving)
	var blocked_result := blocked_serving.serve_order(bowl, order_manager, order_id, &"table-1", 45000)
	_check(not bool(blocked_result.get("ok", false)), "serving is rejected when ledger day is closed")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "ledger rejection preserves ready order")
	_check(int(blocked_serving.get("payment_event_count")) == 0, "ledger rejection emits no payment event")
	_check(blocked_ledger.get_transactions(&"day-closed").size() == 1, "ledger rejection creates no sale transaction")

	var serving := ServingService.new()
	_check(bool(serving.configure_ledger(ledger, &"day-01").get("ok", false)), "serving configures with the active ledger")
	root.add_child(serving)
	var incomplete := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(not bool(incomplete.get("ok", false)), "incomplete bowl cannot be served")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "incomplete bowl rejection preserves order")
	_check(bool(broth.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "serving fixture finishes bowl with broth")
	var not_placed := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(not bool(not_placed.get("ok", false)), "completed bowl must be placed before delivery")
	_check(int(serving.get("payment_event_count")) == 0, "unplaced bowl records no payment")
	var placement := PlacementZone.new()
	var marker := Marker3D.new()
	marker.name = "PlacementMarker"
	placement.add_child(marker)
	root.add_child(placement)
	await process_frame
	_check(bool(bowl.try_place(placement)), "completed bowl can be placed before delivery")
	var wrong_table := serving.serve_order(bowl, order_manager, order_id, &"table-2")
	_check(not bool(wrong_table.get("ok", false)), "delivery to wrong table is rejected")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "wrong table rejection preserves order")
	var served := serving.serve_order(bowl, order_manager, order_id, &"table-1", 45000)
	_check(bool(served.get("ok", false)), "completed bowl serves matching order")
	_check(int(served.get("payment_events", 0)) == 1, "successful service records one payment event")
	var duplicate := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(not bool(duplicate.get("ok", false)), "repeated service action is rejected")
	_check(int(duplicate.get("payment_events", 0)) == 0, "repeated service records no additional payment")
	_check(int(serving.get("payment_event_count")) == 1, "payment remains exactly once")
	_check(int(ledger.get_day_totals(&"day-01").get("revenue", -1)) == 45000, "successful serving posts order revenue to ledger")
	_check(ledger.get_transactions(&"day-01").size() == 2, "one order creates one ledger sale transaction")

	# Recovery case: simulate a prior Ledger commit whose order transition was interrupted.
	var recovery_created: Dictionary = order_manager.create_order(&"order-003", &"pho_bo_tai", &"table-1")
	_check(bool(recovery_created.get("ok", false)), "recovery order can be created")
	_check(bool(order_manager.transition_order(&"order-003", OrderManager.OrderStatus.PREPARING).get("ok", false)), "recovery order transitions to preparing")
	_check(bool(order_manager.transition_order(&"order-003", OrderManager.OrderStatus.READY).get("ok", false)), "recovery order transitions to ready")
	_check(bool(ledger.record_transaction(&"sale:order-003", &"day-01", &"sale_revenue", 45000, &"order-003").get("ok", false)), "recovery fixture simulates an already committed sale")
	# The bowl served for order-001 is dirty now: wash and re-cook it before
	# it can serve another order, mirroring the in-game loop.
	_check(bool(bowl.set_held()), "served bowl can be picked up again once dirty")
	_check(bool(bowl.wash().get("ok", false)), "served bowl washes back to clean")
	_check(bool(noodle.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "recovery fixture re-adds noodles")
	_check(bool(beef.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "recovery fixture re-adds tai beef")
	_check(bool(broth.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "recovery fixture re-finishes bowl with broth")
	_check(bool(bowl.try_place(placement)), "re-cooked bowl can be placed before recovery delivery")
	var recovery_result := serving.serve_order(bowl, order_manager, &"order-003", &"table-1", 45000)
	_check(bool(recovery_result.get("ok", false)), "serving retry recovers from an existing identical Ledger transaction")
	_check(order_manager.get_order(&"order-003").get("status") == OrderManager.OrderStatus.SERVED, "recovered sale transitions the order to served")
	_check(ledger.get_transactions(&"day-01").size() == 3, "recovered sale does not append a duplicate Ledger transaction")
	_check(int(ledger.get_day_totals(&"day-01").get("revenue", -1)) == 90000, "recovery totals count each order once")

	# Conflict case: a stable transaction ID with a different amount must not serve the order.
	var conflict_created: Dictionary = order_manager.create_order(&"order-004", &"pho_bo_tai", &"table-1")
	_check(bool(conflict_created.get("ok", false)), "conflict order can be created")
	_check(bool(order_manager.transition_order(&"order-004", OrderManager.OrderStatus.PREPARING).get("ok", false)), "conflict order transitions to preparing")
	_check(bool(order_manager.transition_order(&"order-004", OrderManager.OrderStatus.READY).get("ok", false)), "conflict order transitions to ready")
	var conflict_ledger := Ledger.new()
	root.add_child(conflict_ledger)
	await process_frame
	_check(bool(conflict_ledger.record_transaction(&"opening-conflict-day", &"day-conflict", &"opening_cash", 100000, &"day-start").get("ok", false)), "conflict fixture initializes its ledger")
	_check(bool(conflict_ledger.record_transaction(&"sale:order-004", &"day-conflict", &"sale_revenue", 12345, &"order-004").get("ok", false)), "conflict fixture reserves the order transaction ID with another amount")
	var conflict_serving := ServingService.new()
	_check(bool(conflict_serving.configure_ledger(conflict_ledger, &"day-conflict").get("ok", false)), "conflict serving configures with its ledger")
	root.add_child(conflict_serving)
	# Same wash-and-recook for the conflict fixture, so the conflicting
	# transaction — not a dirty bowl — is what blocks this delivery.
	_check(bool(bowl.set_held()), "recovered bowl can be picked up again once dirty")
	_check(bool(bowl.wash().get("ok", false)), "recovered bowl washes back to clean")
	_check(bool(noodle.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "conflict fixture re-adds noodles")
	_check(bool(beef.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "conflict fixture re-adds tai beef")
	_check(bool(broth.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "conflict fixture re-finishes bowl with broth")
	_check(bool(bowl.try_place(placement)), "re-cooked bowl can be placed before conflict delivery")
	var conflict_result := conflict_serving.serve_order(bowl, order_manager, &"order-004", &"table-1", 45000)
	_check(not bool(conflict_result.get("ok", false)), "serving rejects a conflicting existing transaction payload")
	_check(order_manager.get_order(&"order-004").get("status") == OrderManager.OrderStatus.READY, "conflicting transaction preserves the ready order")
	_check(int(conflict_serving.get("payment_event_count")) == 0, "conflicting transaction emits no payment event")
	_check(conflict_ledger.get_transactions(&"day-conflict").size() == 2, "conflicting transaction adds no Ledger entry")
	_check(int(conflict_ledger.get_day_totals(&"day-conflict").get("revenue", -1)) == 12345, "conflicting transaction preserves the original amount")

	_check(order_manager.get_open_orders().size() == 1, "only the still-ready conflict order remains open")

	order_manager.queue_free()
	inventory.queue_free()
	bowl.queue_free()
	noodle.queue_free()
	beef.queue_free()
	broth.queue_free()
	serving.queue_free()
	blocked_serving.queue_free()
	blocked_ledger.queue_free()
	conflict_serving.queue_free()
	conflict_ledger.queue_free()
	ledger.queue_free()
	placement.queue_free()
	await process_frame
	_finish()

func _check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: " + message)
	else:
		failures += 1
		push_error("FAIL: " + message)

func _finish() -> void:
	if failures == 0:
		print("ORDER_LIFECYCLE_TESTS: PASS")
		quit(0)
	else:
		push_error("ORDER_LIFECYCLE_TESTS: %d failure(s)" % failures)
		quit(1)
