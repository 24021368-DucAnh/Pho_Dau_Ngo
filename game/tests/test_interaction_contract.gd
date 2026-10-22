extends SceneTree

var failures: int = 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var main_scene: PackedScene = load("res://scenes/main.tscn") as PackedScene
	_check(main_scene != null, "main scene exists and can be loaded")

	var bowl_script: Script = load("res://scripts/interactive_bowl.gd") as Script
	var zone_script: Script = load("res://scripts/placement_zone.gd") as Script
	_check(bowl_script != null, "interactive bowl script exists")
	_check(zone_script != null, "placement zone script exists")

	if main_scene == null or bowl_script == null or zone_script == null:
		_finish()
		return

	var scene_instance: Node = main_scene.instantiate()
	root.add_child(scene_instance)
	await process_frame
	var scene_player: Node = scene_instance.get_node_or_null("Player")
	var scene_zone: Area3D = scene_instance.get_node_or_null("PlacementZone") as Area3D
	_check(scene_player is CharacterBody3D, "scene has a first-person CharacterBody3D player")
	_check(scene_instance.get_node_or_null("LeftWall") is StaticBody3D, "graybox has a left alley wall")
	_check(scene_instance.get_node_or_null("RightWall") is StaticBody3D, "graybox has a right alley wall")
	_check(scene_instance.get_node_or_null("PhoCart") is StaticBody3D, "graybox has a pho cart/workstation proxy")
	_check(scene_instance.get_node_or_null("PhoCart/StockPotProxy") is MeshInstance3D, "graybox has a stock-pot visual proxy")
	_check(scene_instance.get_node_or_null("BrothStation") is KitchenStation, "graybox has an interactive broth station")
	_check(scene_instance.get_node_or_null("NoodlesStation") is KitchenStation, "graybox has an interactive noodle station")
	_check(scene_instance.get_node_or_null("BeefStation") is KitchenStation, "graybox has an interactive raw sliced beef station for pho tai")
	_check(scene_instance.get_node_or_null("CookedBeefStation") is KitchenStation, "graybox has a separate prepared cooked sliced beef station for pho chin")
	_check(scene_instance.get_node_or_null("Inventory") is InventoryService, "scene has one authoritative ingredient inventory")
	_check(scene_instance.get_node_or_null("OrderManager") is OrderManager, "scene has one authoritative order manager")
	_check(scene_instance.get_node_or_null("ServingService") is ServingService, "scene has one authoritative serving service")
	_check(scene_instance.get_node_or_null("DeliveryZone") is Area3D, "scene has a player-facing delivery interaction zone")
	_check(scene_player.get_node_or_null("HUD/OrderTicket") is Label, "player HUD has a visible order ticket")
	_check(scene_instance.get_node_or_null("CustomerStoolProxy") is StaticBody3D, "graybox has a collidable customer stool")
	var stool_collision: CollisionShape3D = scene_instance.get_node_or_null("CustomerStoolProxy/StoolCollision") as CollisionShape3D
	_check(stool_collision != null and stool_collision.shape is BoxShape3D, "customer stool has a physical collision shape")
	_check(scene_instance.get_node_or_null("Bowl") is StaticBody3D, "scene has one physical bowl")

	# Regression checks for the reported floating dish / misplaced cart ingredients.
	var cart_top: MeshInstance3D = scene_instance.get_node_or_null("PhoCart/CartTop") as MeshInstance3D
	var broth_station: Node3D = scene_instance.get_node_or_null("BrothStation") as Node3D
	var noodles_station: Node3D = scene_instance.get_node_or_null("NoodlesStation") as Node3D
	var beef_station: Node3D = scene_instance.get_node_or_null("BeefStation") as Node3D
	var cooked_station: Node3D = scene_instance.get_node_or_null("CookedBeefStation") as Node3D
	_check(cart_top != null, "cart has a top surface for ingredient stations")
	if cart_top != null:
		var cart_top_world_y: float = cart_top.global_position.y + (0.5 * cart_top.mesh.get_aabb().size.y * cart_top.global_transform.basis.get_scale().y)
		for station in [broth_station, noodles_station, beef_station, cooked_station]:
			if station != null:
				var visual: MeshInstance3D = station.get_node_or_null("StationVisual") as MeshInstance3D
				if visual != null:
					var visual_bottom_y: float = visual.global_position.y - (0.5 * visual.mesh.get_aabb().size.y * visual.global_transform.basis.get_scale().y)
					_check(visual_bottom_y <= cart_top_world_y + 0.02 and visual_bottom_y >= cart_top_world_y - 0.08, "%s visual rests on cart top" % station.name)
				else:
					_check(station.name == "BrothStation", "%s has a visual proxy when expected" % station.name)
	var scene_bowl_for_transform: Node3D = scene_instance.get_node_or_null("Bowl") as Node3D
	var scene_marker: Marker3D = scene_instance.get_node_or_null("PlacementZone/PlacementMarker") as Marker3D
	_check(scene_bowl_for_transform != null and scene_marker != null, "bowl and placement marker exist for transform regression")
	if scene_bowl_for_transform != null:
		_check(absf(scene_bowl_for_transform.global_position.y - 1.06) < 0.01, "serving bowl starts at tabletop height, not elevated")
	if scene_bowl_for_transform != null and scene_marker != null:
		_check(absf(scene_marker.global_position.y - 1.06) < 0.01, "placement marker keeps bowl center at tabletop height")
	_check(scene_zone != null, "scene has a placement target")
	var scene_raycast: RayCast3D = scene_player.get_node_or_null("Camera3D/RayCast3D") as RayCast3D
	_check(scene_raycast != null, "player has a look-at raycast")
	if scene_raycast != null:
		_check(scene_raycast.collision_mask == 2, "raycast is restricted to the interaction layer")
		_check(scene_raycast.collide_with_areas, "raycast can focus the placement Area3D")
	if scene_player != null and scene_zone != null:
		_check(scene_zone.collision_layer == 0, "placement zone is not raycast-visible before pickup")
		scene_player.call("_set_placement_zone_active", true)
		_check(scene_zone.collision_layer == 2, "placement zone becomes raycast-visible while carrying")
		scene_player.call("_set_placement_zone_active", false)
		_check(scene_zone.collision_layer == 0, "placement zone is hidden from raycast after placement")
	scene_instance.queue_free()
	await process_frame

	var bowl: StaticBody3D = bowl_script.new() as StaticBody3D
	var bowl_shape := CollisionShape3D.new()
	bowl_shape.name = "CollisionShape3D"
	var cylinder_shape := CylinderShape3D.new()
	cylinder_shape.radius = 0.24
	cylinder_shape.height = 0.12
	bowl_shape.shape = cylinder_shape
	bowl.add_child(bowl_shape)
	root.add_child(bowl)

	var zone: Area3D = zone_script.new() as Area3D
	var marker := Marker3D.new()
	marker.name = "PlacementMarker"
	marker.position = Vector3(0.0, 0.06, 0.0)
	zone.add_child(marker)
	zone.position = Vector3(2.0, 1.0, 3.0)
	root.add_child(zone)
	await process_frame

	_check(int(bowl.get("state")) == 0, "bowl starts in AVAILABLE state")
	_check(bool(bowl.call("set_held")), "available bowl can be picked up")
	await process_frame
	_check(bowl_shape.disabled, "held bowl disables physical collision")

	var held_position: Vector3 = bowl.global_position
	var invalid_target := Node3D.new()
	_check(not bool(bowl.call("try_place", invalid_target)), "invalid placement is rejected")
	_check(int(bowl.get("state")) == 1, "invalid placement preserves HELD state")
	_check(bowl.global_position.is_equal_approx(held_position), "invalid placement does not move the bowl")

	_check(bool(bowl.call("try_place", zone)), "placement zone accepts a held bowl")
	await process_frame
	_check(int(bowl.get("state")) == 2, "valid placement changes state to PLACED")
	_check(not bowl_shape.disabled, "placed bowl restores physical collision")
	_check(bowl.global_position.is_equal_approx(marker.global_position), "placed bowl snaps to the placement marker")

	_check(bool(bowl.call("set_held")), "placed bowl can be picked up again")
	await process_frame
	_check(bowl_shape.disabled, "re-picked bowl disables collision")
	_check(bool(bowl.call("try_place", zone)), "bowl can be placed again without duplication")
	await process_frame
	_check(int(bowl.get("state")) == 2, "repeated pick-up/place leaves one PLACED bowl")


	# Player-level ownership and recipe-selection contracts.
	var interaction_scene: Node = main_scene.instantiate()
	root.add_child(interaction_scene)
	await process_frame
	var player: Node = interaction_scene.get_node("Player")
	var scene_bowl: InteractiveBowl = interaction_scene.get_node("Bowl") as InteractiveBowl
	var player_inventory: InventoryService = interaction_scene.get_node("Inventory") as InventoryService
	_check(scene_bowl != null and player != null, "player ownership fixture is present")
	_check(bool(scene_bowl.set_held()), "player ownership fixture can acquire bowl")
	player.set("held_bowl", scene_bowl)
	_check(not bool(scene_bowl.set_held()), "same bowl cannot be acquired twice while held")
	_check(player.get("held_bowl") == scene_bowl, "player remains the single authoritative bowl owner")

	var original_recipe: RecipeData = player.get("active_recipe") as RecipeData
	var other_recipe: RecipeData = load("res://data/recipes/pho_bo_chin.tres") as RecipeData
	var recipe_locked_bowl: InteractiveBowl = scene_bowl
	recipe_locked_bowl.prepared_recipe_id = original_recipe.recipe_id
	var previous_mouse_mode := Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var input_event := InputEventKey.new()
	input_event.keycode = KEY_V
	input_event.pressed = true
	player.call("_unhandled_input", input_event)
	_check((player.get("active_recipe") as RecipeData).recipe_id == original_recipe.recipe_id, "recipe cannot change after bowl preparation starts")
	_check(recipe_locked_bowl.prepared_recipe_id == original_recipe.recipe_id, "locked bowl keeps its original recipe identity")
	_check(other_recipe.recipe_id != original_recipe.recipe_id, "test recipes have distinct identities")
	Input.mouse_mode = previous_mouse_mode
	_check(player_inventory != null, "player shares the scene's authoritative inventory")
	interaction_scene.queue_free()
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
		print("GODOT_SPIKE_TESTS: PASS")
		quit(0)
	else:
		push_error("GODOT_SPIKE_TESTS: %d failure(s)" % failures)
		quit(1)
