extends SceneTree

var failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var recipe := load("res://data/recipes/pho_bo.tres") as RecipeData
	_check(recipe != null, "phở bò recipe data loads")
	if recipe == null:
		_finish()
		return

	_check(recipe.steps.size() == 3, "recipe has three ordered steps")
	_check(StringName(recipe.step_at(0).get("action_id", &"")) == &"add_broth", "broth is the first recipe step")
	_check(StringName(recipe.step_at(1).get("action_id", &"")) == &"add_noodles", "noodles are the second recipe step")
	_check(StringName(recipe.step_at(2).get("action_id", &"")) == &"add_beef", "beef is the final recipe step")
	_check(recipe.step_at(3).is_empty(), "recipe returns no step after completion")

	var inventory := InventoryService.new()
	inventory.starting_stock = {&"broth": 2, &"noodles": 2, &"beef": 2}
	root.add_child(inventory)
	await process_frame

	var broth_station := _make_station(&"add_broth", &"broth", "Nồi nước dùng")
	var noodles_station := _make_station(&"add_noodles", &"noodles", "Khay bánh phở")
	var beef_station := _make_station(&"add_beef", &"beef", "Khay thịt bò")
	root.add_child(broth_station)
	root.add_child(noodles_station)
	root.add_child(beef_station)
	await process_frame

	var bowl := _make_bowl()
	root.add_child(bowl)
	await process_frame
	_check(bowl.set_held(), "available bowl can be held for preparation")

	var beef_first: Dictionary = beef_station.apply_to_bowl(bowl, recipe, inventory)
	_check(not bool(beef_first.get("ok", false)), "wrong station order is rejected")
	_check(inventory.get_stock(&"beef") == 2, "wrong station order does not consume beef")
	_check(bowl.recipe_step_index == 0, "wrong station order does not advance recipe state")

	var broth_result: Dictionary = broth_station.apply_to_bowl(bowl, recipe, inventory)
	_check(bool(broth_result.get("ok", false)), "broth station accepts the first step")
	_check(inventory.get_stock(&"broth") == 1, "valid broth step consumes one broth unit")
	_check(bowl.recipe_step_index == 1, "valid broth step advances recipe state")

	var repeated_broth: Dictionary = broth_station.apply_to_bowl(bowl, recipe, inventory)
	_check(not bool(repeated_broth.get("ok", false)), "repeating a completed station action is rejected")
	_check(inventory.get_stock(&"broth") == 1, "repeated station action cannot double-consume broth")
	_check(bowl.consumed_ingredients.size() == 1, "repeated action does not duplicate bowl ingredient records")

	var noodles_result: Dictionary = noodles_station.apply_to_bowl(bowl, recipe, inventory)
	_check(bool(noodles_result.get("ok", false)), "noodle station accepts the second step")
	var beef_result: Dictionary = beef_station.apply_to_bowl(bowl, recipe, inventory)
	_check(bool(beef_result.get("ok", false)), "beef station accepts the final step")
	_check(bowl.preparation_state == InteractiveBowl.PreparationState.READY_TO_SERVE, "final recipe step marks bowl ready to serve")
	_check(bowl.recipe_step_index == recipe.steps.size(), "completed bowl has no remaining recipe steps")
	_check(inventory.get_stock(&"noodles") == 1 and inventory.get_stock(&"beef") == 1, "each ingredient is consumed exactly once")

	var complete_repeat: Dictionary = beef_station.apply_to_bowl(bowl, recipe, inventory)
	_check(not bool(complete_repeat.get("ok", false)), "completed recipe rejects additional station actions")
	_check(inventory.get_stock(&"beef") == 1, "completed recipe cannot consume extra beef")
	var completed_waste_count := bowl.consumed_ingredients.size()
	var cancel_completed: Dictionary = bowl.cancel_preparation()
	_check(not bool(cancel_completed.get("ok", false)), "completed bowl cannot be cancelled as an in-progress preparation")
	_check(bowl.preparation_state == InteractiveBowl.PreparationState.READY_TO_SERVE, "rejected cancellation preserves ready-to-serve state")
	_check(bowl.recipe_step_index == recipe.steps.size(), "rejected cancellation preserves completed recipe progress")
	_check(bowl.consumed_ingredients.size() == completed_waste_count, "rejected cancellation preserves completed ingredient records")
	_check(inventory.get_stock(&"beef") == 1, "rejected cancellation does not change stock")

	var cancel_inventory := InventoryService.new()
	cancel_inventory.starting_stock = {&"broth": 1, &"noodles": 1, &"beef": 1}
	root.add_child(cancel_inventory)
	await process_frame
	var cancel_bowl := _make_bowl()
	root.add_child(cancel_bowl)
	await process_frame
	_check(cancel_bowl.set_held(), "second bowl can be held for cancellation test")
	var cancel_step: Dictionary = broth_station.apply_to_bowl(cancel_bowl, recipe, cancel_inventory)
	_check(bool(cancel_step.get("ok", false)), "cancellation test consumes broth before cancellation")
	var stock_before_cancel := cancel_inventory.get_stock(&"broth")
	var cancel_result: Dictionary = cancel_bowl.cancel_preparation()
	_check(bool(cancel_result.get("ok", false)), "in-progress bowl can be cancelled")
	_check(cancel_bowl.preparation_state == InteractiveBowl.PreparationState.CLEAN, "cancel resets bowl preparation state")
	_check(cancel_bowl.recipe_step_index == 0, "cancel resets recipe progress")
	_check(cancel_inventory.get_stock(&"broth") == stock_before_cancel, "cancel does not refund already-used ingredients")
	_check(cancel_result.get("wasted", []).size() == 1, "cancel reports consumed ingredients as waste")

	var empty_inventory := InventoryService.new()
	empty_inventory.starting_stock = {&"broth": 0, &"noodles": 0, &"beef": 0}
	root.add_child(empty_inventory)
	await process_frame
	var empty_bowl := _make_bowl()
	root.add_child(empty_bowl)
	await process_frame
	_check(empty_bowl.set_held(), "bowl can be held for shortage test")
	var shortage: Dictionary = broth_station.apply_to_bowl(empty_bowl, recipe, empty_inventory)
	_check(not bool(shortage.get("ok", false)), "missing ingredient blocks recipe step")
	_check(empty_inventory.get_stock(&"broth") == 0, "missing ingredient never makes stock negative")
	_check(empty_bowl.recipe_step_index == 0, "missing ingredient leaves bowl state unchanged")
	_check(not empty_inventory.try_consume(&"broth", 1), "inventory rejects consumption below zero")

	_finish()


func _make_station(action: StringName, ingredient: StringName, label_text: String) -> KitchenStation:
	var station := KitchenStation.new()
	station.action_id = action
	station.ingredient_id = ingredient
	station.station_label = label_text
	return station


func _make_bowl() -> InteractiveBowl:
	var bowl := InteractiveBowl.new()
	var collision := CollisionShape3D.new()
	collision.name = "CollisionShape3D"
	var shape := CylinderShape3D.new()
	shape.radius = 0.24
	shape.height = 0.12
	collision.shape = shape
	bowl.add_child(collision)
	return bowl


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
