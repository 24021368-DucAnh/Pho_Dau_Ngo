extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var orders := OrderManager.new()
	var cooking := CookingCoordinator.new()
	var tray := TrayController.new()
	for service in [orders, cooking, tray]:
		root.add_child(service)
	await process_frame
	orders.create_order(&"order-001", &"pho_bo_tai", &"table-1")
	orders.create_order(&"order-002", &"pho_bo_chin", &"table-2")
	_check(bool(cooking.configure(orders).get("ok", false)), "coordinator configured")
	_check(bool(cooking.bind_bowl_to_order(&"bowl-1", &"order-001").get("ok", false)), "first bowl bound")
	_check(not bool(cooking.bind_bowl_to_order(&"bowl-1", &"order-002").get("ok", false)), "bowl cannot change order")
	_check(not bool(cooking.bind_bowl_to_order(&"bowl-2", &"order-001").get("ok", false)), "order cannot own two bowls")
	_check(bool(cooking.bind_bowl_to_order(&"bowl-2", &"order-002").get("ok", false)), "second bowl bound")
	_check(bool(tray.try_insert(&"bowl-1", 0).get("ok", false)), "first slot filled")
	_check(bool(tray.try_insert(&"bowl-2", 1).get("ok", false)), "second slot filled")
	_check(not bool(tray.try_insert(&"bowl-1", 1).get("ok", false)), "duplicate bowl rejected")
	_check(not bool(tray.try_insert(&"bowl-3", 1).get("ok", false)), "occupied slot rejected")
	_check(not bool(tray.try_insert(&"bowl-3", 2).get("ok", false)), "invalid slot rejected")
	_check(tray.get_slots() == [&"bowl-1", &"bowl-2"], "tray keeps two exact bowls")
	_check(StringName(tray.try_remove(0).get("bowl_id", &"")) == &"bowl-1", "first bowl removed")
	_check(bool(tray.try_insert(&"bowl-1", 0).get("ok", false)), "first bowl can return")
	_check(bool(tray.begin_carry().get("ok", false)) and tray.is_carried(), "filled tray can be carried")
	_check(not bool(tray.begin_carry().get("ok", false)), "tray cannot be picked up twice")
	_check(bool(tray.end_carry().get("ok", false)) and not tray.is_carried(), "tray can be put down")
	var main := (load("res://scenes/main.tscn") as PackedScene).instantiate()
	root.add_child(main)
	await process_frame
	_check((main.get_node("Bowl") as InteractiveBowl).bowl_id == &"bowl-1", "scene first bowl id")
	_check((main.get_node("Bowl2") as InteractiveBowl).bowl_id == &"bowl-2", "scene second bowl id")
	_check((main.get_node("ShipZone") as PlacementZone).tray_slot_index == 0, "scene first tray slot")
	_check((main.get_node("TraySlot1") as PlacementZone).tray_slot_index == 1, "scene second tray slot")
	_check((main.get_node("TrayController") as TrayController).get_slots() == [&"", &""], "scene tray starts empty")
	main.queue_free()
	for service in [orders, cooking, tray]:
		service.queue_free()
	print("TRAY_BINDING_TESTS: %s" % ("PASS" if failures == 0 else "FAIL"))
	quit(0 if failures == 0 else 1)

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
