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
	_check(scene_instance.get_node_or_null("CustomerStoolProxy") is MeshInstance3D, "graybox has a customer stool proxy")
	_check(scene_instance.get_node_or_null("Bowl") is StaticBody3D, "scene has one physical bowl")
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
