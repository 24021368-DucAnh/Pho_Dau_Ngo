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
