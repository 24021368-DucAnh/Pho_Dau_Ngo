extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var tables := TableService.new()
	var orders := OrderManager.new()
	var director := CustomerDirector.new()
	var scenario := load("res://data/day01_customers.tres")
	for service in [tables, orders, director]:
		root.add_child(service)
	await process_frame
	_check(bool(director.configure(tables, orders, scenario).get("ok", false)), "scenario configured")
	director.start_shift()
	var open := orders.get_open_orders()
	_check(open.size() == 3, "three customers occupy three tables")
	_check(StringName(open[0].get("table_id", &"")) == &"table-1", "first customer gets first table")
	_check(StringName(open[1].get("recipe_id", &"")) == &"pho_bo_chin", "second customer orders cooked beef")
	_check(not bool(tables.reserve_table(&"overflow").get("ok", false)), "full tables reject customer")
	_check(not bool(orders.create_order(&"duplicate-table", &"pho_bo_tai", &"table-1").get("ok", false)), "table cannot have two open orders")
	_check(not tables.can_deliver(&"table-2", &"order-001"), "wrong table rejected")
	director.stop_arrivals()
	_check(not bool(director.admit_next_customer().get("ok", false)), "closing stops arrivals")
	var scene := load("res://scenes/main.tscn") as PackedScene
	var main := scene.instantiate()
	root.add_child(main)
	await process_frame
	_check((main.get_node("OrderManager") as OrderManager).get_open_orders().size() == 3, "game scene starts with three orders")
	for table_index in range(1, 4):
		var zone_name := "PlacementZone" if table_index == 1 else "Table%dZone" % table_index
		var zone := main.get_node(zone_name) as PlacementZone
		_check(zone.table_id == StringName("table-%d" % table_index), "scene zone has correct table id")
		_check(absf(zone.global_position.y - 0.5) < 0.01, "zone sits at table top")
	main.queue_free()
	for service in [tables, orders, director]:
		service.queue_free()
	print("CUSTOMER_TABLES_TESTS: %s" % ("PASS" if failures == 0 else "FAIL"))
	quit(0 if failures == 0 else 1)

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
