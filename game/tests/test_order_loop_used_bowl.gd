extends SceneTree

# Multi-order loop: serve -> bowl dirty -> wash -> next order -> serve again.
# A served bowl must never cook or serve again until washed, and washing is
# what opens the next order (in-game the player controller creates it on a
# successful wash; here the order side is exercised directly).

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var order_manager := OrderManager.new()
	root.add_child(order_manager)
	await process_frame
	var inventory := InventoryService.new()
	root.add_child(inventory)
	var bowl := InteractiveBowl.new()
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	collision.shape = CylinderShape3D.new()
	bowl.add_child(collision)
	root.add_child(bowl)
	await process_frame
	var noodle := KitchenStation.new()
	noodle.action_id = &"add_noodles"
	noodle.ingredient_id = &"noodles"
	root.add_child(noodle)
	var raw_beef := KitchenStation.new()
	raw_beef.action_id = &"add_raw_beef"
	raw_beef.ingredient_id = &"raw_sliced_beef"
	root.add_child(raw_beef)
	var cooked_beef := KitchenStation.new()
	cooked_beef.action_id = &"add_cooked_beef"
	cooked_beef.ingredient_id = &"cooked_sliced_beef"
	root.add_child(cooked_beef)
	var broth := KitchenStation.new()
	broth.action_id = &"add_broth"
	broth.ingredient_id = &"broth"
	root.add_child(broth)
	var placement := PlacementZone.new()
	var marker := Marker3D.new()
	marker.name = "PlacementMarker"
	placement.add_child(marker)
	root.add_child(placement)
	await process_frame
	var ledger := Ledger.new()
	root.add_child(ledger)
	await process_frame
	_check(bool(ledger.record_transaction(&"opening-day-01", &"day-01", &"opening_cash", 100000, &"day-start").get("ok", false)), "loop fixture initializes opening cash")
	var serving := ServingService.new()
	_check(bool(serving.configure_ledger(ledger, &"day-01").get("ok", false)), "loop serving configures with ledger")
	root.add_child(serving)

	var tai := load("res://data/recipes/pho_bo.tres") as RecipeData
	var chin := load("res://data/recipes/pho_bo_chin.tres") as RecipeData
	_check(inventory.get_stock(&"noodles") == 10, "slice-day stock starts at 10 noodles")

	# First loop: cook tai, serve order-001.
	_check(bool(order_manager.create_order(&"order-001", tai.recipe_id, &"table-1").get("ok", false)), "first loop order can be created")
	_check(bool(order_manager.transition_order(&"order-001", OrderManager.OrderStatus.PREPARING).get("ok", false)), "first order moves to preparing")
	_check(bool(order_manager.transition_order(&"order-001", OrderManager.OrderStatus.READY).get("ok", false)), "first order moves to ready")
	_check(bool(bowl.set_held()), "loop bowl can be held")
	_check(bool(noodle.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "first loop adds noodles")
	_check(bool(raw_beef.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "first loop adds tai beef")
	_check(bool(broth.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "first loop finishes with broth")
	_check(bool(bowl.try_place(placement)), "first loop bowl can be placed")
	var served := serving.serve_order(bowl, order_manager, &"order-001", &"table-1", 45000)
	_check(bool(served.get("ok", false)), "first loop serves matching order")
	_check(int(serving.get("payment_event_count")) == 1, "first loop records one payment")
	_check(order_manager.get_order(&"order-001").get("status") == OrderManager.OrderStatus.SERVED, "first order is served")

	# Served bowl is dirty: leftovers stay visible, it cannot cook or serve.
	_check(bowl.is_dirty(), "served bowl becomes dirty")
	_check(not bowl.is_ready_to_serve(), "dirty bowl is not ready to serve")
	_check(bowl.consumed_ingredients.size() == 3, "dirty bowl keeps its leftovers until washed")
	var duplicate := serving.serve_order(bowl, order_manager, &"order-001", &"table-1", 45000)
	_check(not bool(duplicate.get("ok", false)), "dirty bowl cannot be served again")
	_check(int(serving.get("payment_event_count")) == 1, "duplicate serve records no extra payment")
	var noodles_before := inventory.get_stock(&"noodles")
	_check(bool(bowl.set_held()), "dirty bowl can be picked up again")
	_check(not bool(noodle.apply_to_bowl(bowl, tai, inventory).get("ok", false)), "dirty bowl rejects further cooking")
	_check(inventory.get_stock(&"noodles") == noodles_before, "rejected dirty-bowl step consumes no stock")
	_check(not bowl.can_apply_recipe_step(&"add_noodles", tai), "dirty bowl fails the recipe-step guard directly")

	# Washing requires holding the bowl and resets it to clean.
	var placed_bowl := InteractiveBowl.new()
	var placed_collision := CollisionShape3D.new()
	placed_collision.name = "CollisionShape3D"
	placed_collision.shape = CylinderShape3D.new()
	placed_bowl.add_child(placed_collision)
	root.add_child(placed_bowl)
	await process_frame
	placed_bowl.state = InteractiveBowl.BowlState.PLACED
	placed_bowl.preparation_state = InteractiveBowl.PreparationState.DIRTY
	_check(not bool(placed_bowl.wash().get("ok", false)), "bowl cannot be washed while placed")
	var washed := bowl.wash()
	_check(bool(washed.get("ok", false)), "held dirty bowl washes clean")
	_check(not bowl.is_dirty(), "washed bowl is no longer dirty")
	_check(bowl.consumed_ingredients.is_empty(), "washed bowl has no ingredients left")
	_check(bowl.recipe_step_index == 0, "washed bowl resets its step index")
	_check(bowl.prepared_recipe_id == &"", "washed bowl forgets its recipe")
	_check(not bool(bowl.wash().get("ok", false)), "clean bowl cannot be washed again")

	# Second loop: new order, switched recipe, same bowl, same stations.
	_check(bool(order_manager.create_order(&"order-002", chin.recipe_id, &"table-1").get("ok", false)), "second loop order can be created")
	_check(bool(order_manager.transition_order(&"order-002", OrderManager.OrderStatus.PREPARING).get("ok", false)), "second order moves to preparing")
	_check(bool(order_manager.transition_order(&"order-002", OrderManager.OrderStatus.READY).get("ok", false)), "second order moves to ready")
	_check(bool(noodle.apply_to_bowl(bowl, chin, inventory).get("ok", false)), "second loop adds noodles")
	_check(bool(cooked_beef.apply_to_bowl(bowl, chin, inventory).get("ok", false)), "second loop adds cooked beef")
	_check(bool(broth.apply_to_bowl(bowl, chin, inventory).get("ok", false)), "second loop finishes with broth")
	_check(bool(bowl.try_place(placement)), "second loop bowl can be placed")
	var served2 := serving.serve_order(bowl, order_manager, &"order-002", &"table-1", 45000)
	_check(bool(served2.get("ok", false)), "second loop serves matching order")
	_check(int(serving.get("payment_event_count")) == 2, "second loop records a second payment")
	_check(bowl.is_dirty(), "second served bowl becomes dirty again")
	_check(inventory.get_stock(&"noodles") == 8, "two loops consume exactly two noodles from stock of 10")
	_check(order_manager.get_open_orders().size() == 0, "no open orders remain after both loops served")

	order_manager.queue_free()
	inventory.queue_free()
	bowl.queue_free()
	placed_bowl.queue_free()
	noodle.queue_free()
	raw_beef.queue_free()
	cooked_beef.queue_free()
	broth.queue_free()
	placement.queue_free()
	ledger.queue_free()
	serving.queue_free()
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
		print("ORDER_LOOP_USED_BOWL_TESTS: PASS")
		quit(0)
	else:
		push_error("ORDER_LOOP_USED_BOWL_TESTS: %d failure(s)" % failures)
		quit(1)
