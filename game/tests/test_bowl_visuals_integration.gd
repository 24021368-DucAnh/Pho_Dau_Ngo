extends SceneTree

# Integration contract: the gameplay Bowl renders the modular bowl scene and
# its layers follow ONLY the authoritative InteractiveBowl state. No recipe,
# inventory, Ledger or collision behavior is changed by this test's subject:
# visuals are driven by apply_recipe_step / cancel_preparation, never the
# other way around.

var failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _visible(visuals: Node, layer: String) -> bool:
	var node := visuals.get_node_or_null(layer) as Node3D
	return node != null and node.visible


func _run() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn") as PackedScene
	_check(main_scene != null, "main scene exists and can be loaded")
	if main_scene == null:
		_finish()
		return

	var recipe: RecipeData = load("res://data/recipes/pho_bo.tres") as RecipeData
	_check(recipe != null, "pho tai recipe resource exists")
	if recipe == null:
		_finish()
		return

	var scene1: Node = main_scene.instantiate()
	root.add_child(scene1)
	await process_frame
	var bowl1: InteractiveBowl = scene1.get_node_or_null("Bowl") as InteractiveBowl
	_check(bowl1 != null and bowl1 is StaticBody3D, "gameplay Bowl is still the physical InteractiveBowl root")
	var visuals1: Node = bowl1.get_node_or_null("BowlVisuals") if bowl1 != null else null
	_check(visuals1 != null, "gameplay Bowl instances the modular bowl scene as BowlVisuals")
	_check(bowl1.get_node_or_null("MeshInstance3D") == null, "old cylinder bowl visual is removed (no double bowl)")
	if visuals1 is Node3D:
		_check(absf((visuals1 as Node3D).position.y - (-0.04)) < 0.001, "modular bowl base sits on the tabletop (offset -0.04 from bowl centre)")
	var collision1: CollisionShape3D = bowl1.get_node_or_null("CollisionShape3D") as CollisionShape3D
	_check(collision1 != null and collision1.shape is CylinderShape3D, "gameplay Bowl keeps its original cylinder collision shape")

	if visuals1 == null:
		scene1.queue_free()
		_finish()
		return

	# Clean state: only the bowl base shows.
	_check(_visible(visuals1, "BowlBase"), "clean bowl shows its base")
	_check(not _visible(visuals1, "NoodlesLayer"), "clean bowl hides noodles")
	_check(not _visible(visuals1, "BeefLayer"), "clean bowl hides beef")
	_check(not _visible(visuals1, "BrothSurface"), "clean bowl hides broth")
	_check(not _visible(visuals1, "GarnishLayer"), "clean bowl hides garnish")
	_check(not _visible(visuals1, "ChopsticksExtra"), "clean bowl hides chopsticks")

	# Rejected step must not change visuals.
	_check(bool(bowl1.call("set_held")), "scene bowl can be picked up")
	_check(not bool(bowl1.call("apply_recipe_step", &"add_broth", recipe)), "out-of-order broth step is rejected")
	_check(not _visible(visuals1, "BrothSurface"), "rejected step leaves broth hidden")
	_check(not _visible(visuals1, "NoodlesLayer"), "rejected step leaves noodles hidden")

	# Successful steps reveal exactly their layers, in recipe order.
	_check(bool(bowl1.call("apply_recipe_step", &"add_noodles", recipe)), "noodles step applies")
	_check(_visible(visuals1, "NoodlesLayer"), "noodles step shows noodles")
	_check(not _visible(visuals1, "BeefLayer"), "noodles step does not show beef")
	_check(not _visible(visuals1, "GarnishLayer"), "incomplete bowl does not show garnish")
	_check(bool(bowl1.call("apply_recipe_step", &"add_raw_beef", recipe)), "raw beef step applies")
	_check(_visible(visuals1, "BeefLayer"), "beef step shows beef")
	_check(not _visible(visuals1, "BrothSurface"), "beef step does not show broth")
	_check(bool(bowl1.call("apply_recipe_step", &"add_broth", recipe)), "broth step applies")
	_check(_visible(visuals1, "BrothSurface"), "broth step shows broth")
	_check(_visible(visuals1, "GarnishLayer"), "ready bowl shows garnish")
	_check(_visible(visuals1, "ChopsticksExtra"), "ready bowl shows chopsticks")
	_check(bowl1.is_ready_to_serve(), "bowl is ready to serve after all three steps")

	scene1.queue_free()
	await process_frame

	# Cancellation resets visuals to a clean bowl.
	var scene2: Node = main_scene.instantiate()
	root.add_child(scene2)
	await process_frame
	var bowl2: InteractiveBowl = scene2.get_node_or_null("Bowl") as InteractiveBowl
	var visuals2: Node = bowl2.get_node_or_null("BowlVisuals") if bowl2 != null else null
	_check(visuals2 != null, "second scene bowl also has BowlVisuals")
	if visuals2 != null:
		_check(bool(bowl2.call("set_held")), "second bowl can be picked up")
		_check(bool(bowl2.call("apply_recipe_step", &"add_noodles", recipe)), "second bowl noodles step applies")
		_check(_visible(visuals2, "NoodlesLayer"), "second bowl shows noodles before cancel")
		var cancel_result: Dictionary = bowl2.call("cancel_preparation") as Dictionary
		_check(bool(cancel_result.get("ok", false)), "cancel succeeds while in progress")
		_check(not _visible(visuals2, "NoodlesLayer"), "cancel hides noodles again")
		_check(not _visible(visuals2, "BeefLayer"), "cancel leaves beef hidden")
		_check(not _visible(visuals2, "BrothSurface"), "cancel leaves broth hidden")
		_check(_visible(visuals2, "BowlBase"), "cancelled bowl still shows its base")
	scene2.queue_free()
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
		print("BOWL_VISUALS_TESTS: PASS")
		quit(0)
	else:
		push_error("BOWL_VISUALS_TESTS: %d failure(s)" % failures)
		quit(1)
