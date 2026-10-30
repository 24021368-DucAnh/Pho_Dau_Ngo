extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await process_frame
	var player := main.get_node("Player")
	var bowl := main.get_node("Bowl") as InteractiveBowl
	var orders := main.get_node("OrderManager") as OrderManager
	var cooking := main.get_node("CookingCoordinator") as CookingCoordinator
	var tray := main.get_node("TrayController") as TrayController
	var recipe := load("res://data/recipes/pho_bo.tres") as RecipeData
	_check(bool(cooking.bind_bowl_to_order(bowl.bowl_id, &"order-001").get("ok", false)), "bowl binds first order")
	_check(bowl.set_held(), "bowl picked up")
	for step in recipe.steps_for_recipe():
		_check(bowl.apply_recipe_step(StringName(step["action_id"]), recipe), "recipe step completed")
	orders.transition_order(&"order-001", OrderManager.OrderStatus.PREPARING)
	_check(bowl.try_place(main.get_node("ShipZone")), "bowl placed on tray slot")
	_check(bool(tray.try_insert(bowl.bowl_id, 0).get("ok", false)), "tray registers bowl")
	player.global_position = Vector3(2.5, 0.9, -1.6)
	player._toggle_tray()
	_check(tray.is_carried(), "player carries tray")
	_check(bowl.collision_layer == 0, "carried bowl does not block table raycast")
	player._deliver_from_tray(main.get_node("Table2Zone"))
	_check(tray.get_slots()[0] == &"bowl-1", "wrong table preserves tray bowl")
	player._deliver_from_tray(main.get_node("PlacementZone"))
	_check(tray.get_slots()[0] == &"", "correct table empties tray slot")
	_check(int(orders.get_order(&"order-001").get("status", -1)) == OrderManager.OrderStatus.SERVED, "correct table serves order")
	var serving := main.get_node("ServingService") as ServingService
	_check(serving.payment_event_count == 0, "delivery does not collect payment")
	_check(not bowl.is_dirty() and bowl.in_service, "customer uses bowl during meal")
	_check(not bowl.set_held(), "player cannot take bowl during meal")
	(main.get_node("MealService") as MealService)._process(9.0)
	_check(int(orders.get_order(&"order-001").get("payment_status", -1)) == OrderManager.PaymentStatus.PAYMENT_PENDING, "finished meal awaits payment")
	player._collect_payment(main.get_node("PaymentZone1"))
	_check(serving.payment_event_count == 1, "payment collected once")
	_check(bowl.is_dirty(), "paid meal leaves dirty bowl")
	player._collect_payment(main.get_node("PaymentZone1"))
	_check(serving.payment_event_count == 1, "payment cannot repeat")
	main.queue_free()
	print("TRAY_SCENE_DELIVERY_TESTS: %s" % ("PASS" if failures == 0 else "FAIL"))
	quit(0 if failures == 0 else 1)

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
