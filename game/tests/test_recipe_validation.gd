# Recipe and transaction regression coverage for both beef variants, station ordering, stock conservation, recipe locking, and cancellation.
extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var tai := load("res://data/recipes/pho_bo.tres") as RecipeData
	var chin := load("res://data/recipes/pho_bo_chin.tres") as RecipeData
	_check(tai != null and tai.is_valid_recipe(), "tai recipe valid")
	_check(chin != null and chin.is_valid_recipe(), "chin recipe valid")
	if tai != null and chin != null:
		_check(tai.step_at(1).get("action_id") == &"add_raw_beef", "tai uses raw sliced beef action")
		_check(tai.step_at(1).get("ingredient_id") == &"raw_sliced_beef", "tai requires raw sliced beef")
		_check(chin.step_at(1).get("action_id") == &"add_cooked_beef", "chin uses cooked beef action")
		_check(chin.step_at(1).get("ingredient_id") == &"cooked_sliced_beef", "chin requires cooked sliced beef")
		_check(tai.step_at(2).get("action_id") == &"add_broth", "broth finishes tai")
		_check(chin.step_at(2).get("action_id") == &"add_broth", "broth finishes chin")
	# Station/inventory transaction contracts: invalid order and missing stock must not mutate state.
	var inventory := InventoryService.new()
	root.add_child(inventory)
	await process_frame
	var bowl := InteractiveBowl.new()
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	collision.shape = CylinderShape3D.new()
	bowl.add_child(collision)
	root.add_child(bowl)
	_check(bowl.set_held(), "transaction fixture bowl can be held")

	var noodle_station := KitchenStation.new()
	noodle_station.action_id = &"add_noodles"
	noodle_station.ingredient_id = &"noodles"
	root.add_child(noodle_station)
	var broth_station := KitchenStation.new()
	broth_station.action_id = &"add_broth"
	broth_station.ingredient_id = &"broth"
	root.add_child(broth_station)
	await process_frame

	var noodles_before := inventory.get_stock(&"noodles")
	var broth_before := inventory.get_stock(&"broth")
	var invalid_order := broth_station.apply_to_bowl(bowl, tai, inventory)
	_check(not bool(invalid_order.get("ok", false)), "broth before noodles is rejected")
	_check(inventory.get_stock(&"noodles") == noodles_before and inventory.get_stock(&"broth") == broth_before, "invalid order preserves all inventory")
	_check(int(bowl.get("recipe_step_index")) == 0, "invalid order preserves bowl recipe step")

	var valid_noodles := noodle_station.apply_to_bowl(bowl, tai, inventory)
	_check(bool(valid_noodles.get("ok", false)), "expected noodle step succeeds")
	_check(inventory.get_stock(&"noodles") == noodles_before - 1, "successful step consumes one noodle stock")
	var repeated_noodles := noodle_station.apply_to_bowl(bowl, tai, inventory)
	_check(not bool(repeated_noodles.get("ok", false)), "repeating an already-completed station step is rejected")
	_check(inventory.get_stock(&"noodles") == noodles_before - 1, "repeated station activation does not consume twice")

	# A bowl's recipe identity is locked after the first successful preparation step.
	var cooked_station := KitchenStation.new()
	cooked_station.action_id = &"add_cooked_beef"
	cooked_station.ingredient_id = &"cooked_sliced_beef"
	root.add_child(cooked_station)
	await process_frame
	var cooked_before := inventory.get_stock(&"cooked_sliced_beef")
	var recipe_switch := cooked_station.apply_to_bowl(bowl, chin, inventory)
	_check(not bool(recipe_switch.get("ok", false)), "switching tai bowl to chin after preparation starts is rejected")
	_check(inventory.get_stock(&"cooked_sliced_beef") == cooked_before, "rejected recipe switch preserves cooked beef stock")
	_check(int(bowl.get("recipe_step_index")) == 1, "rejected recipe switch preserves current recipe progress")

	# Cancellation records the consumed ingredient as waste exactly once and resets the bowl.
	var cancellation := bowl.cancel_preparation()
	_check(bool(cancellation.get("ok", false)), "in-progress bowl can be cancelled")
	var wasted: Array = cancellation.get("wasted", [])
	_check(wasted.size() == 1 and StringName(wasted[0].get("ingredient_id", &"")) == &"noodles", "cancellation reports consumed noodles as waste")
	_check(int(bowl.get("recipe_step_index")) == 0, "cancellation resets recipe progress")
	_check(StringName(bowl.get("prepared_recipe_id")) == &"", "cancellation clears locked recipe identity")
	var repeated_cancellation := bowl.cancel_preparation()
	_check(not bool(repeated_cancellation.get("ok", false)), "cancellation cannot record the same waste twice")

	var empty_inventory := InventoryService.new()
	empty_inventory.starting_stock = {&"noodles": 0, &"broth": 1}
	root.add_child(empty_inventory)
	await process_frame
	var empty_bowl := InteractiveBowl.new()
	var empty_collision := CollisionShape3D.new()
	empty_collision.name = "CollisionShape3D"
	empty_collision.shape = CylinderShape3D.new()
	empty_bowl.add_child(empty_collision)
	root.add_child(empty_bowl)
	_check(empty_bowl.set_held(), "empty-stock fixture bowl can be held")
	var empty_noodle_station := KitchenStation.new()
	empty_noodle_station.action_id = &"add_noodles"
	empty_noodle_station.ingredient_id = &"noodles"
	root.add_child(empty_noodle_station)
	await process_frame
	var missing_stock := empty_noodle_station.apply_to_bowl(empty_bowl, tai, empty_inventory)
	_check(not bool(missing_stock.get("ok", false)), "missing ingredient stock is rejected")
	_check(empty_inventory.get_stock(&"noodles") == 0, "missing stock never becomes negative")
	_check(int(empty_bowl.get("recipe_step_index")) == 0, "missing stock preserves bowl state")

	inventory.queue_free()
	empty_inventory.queue_free()
	bowl.queue_free()
	empty_bowl.queue_free()
	noodle_station.queue_free()
	broth_station.queue_free()
	cooked_station.queue_free()
	empty_noodle_station.queue_free()
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
		print("RECIPE_VALIDATION_TESTS: PASS")
		quit(0)
	else:
		push_error("RECIPE_VALIDATION_TESTS: %d failure(s)" % failures)
		quit(1)
