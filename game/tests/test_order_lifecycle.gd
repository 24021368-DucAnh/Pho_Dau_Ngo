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
	var serving := ServingService.new()
	root.add_child(serving)
	var incomplete := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(not bool(incomplete.get("ok", false)), "incomplete bowl cannot be served")
	_check(order_manager.get_order(order_id).get("status") == OrderManager.OrderStatus.READY, "incomplete bowl rejection preserves order")
	_check(bool(broth.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "serving fixture finishes bowl with broth")
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
	var served := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(bool(served.get("ok", false)), "completed bowl serves matching order")
	_check(int(served.get("payment_events", 0)) == 1, "successful service records one payment event")
	var duplicate := serving.serve_order(bowl, order_manager, order_id, &"table-1")
	_check(not bool(duplicate.get("ok", false)), "repeated service action is rejected")
	_check(int(duplicate.get("payment_events", 0)) == 0, "repeated service records no additional payment")
	_check(int(serving.get("payment_event_count")) == 1, "payment remains exactly once")

	order_manager.queue_free()
	inventory.queue_free()
	bowl.queue_free()
	noodle.queue_free()
	beef.queue_free()
	broth.queue_free()
	serving.queue_free()
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
