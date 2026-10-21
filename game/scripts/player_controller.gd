extends CharacterBody3D

@export var move_speed: float = 4.5
@export var mouse_sensitivity: float = 0.0025

const PHO_BO_RECIPE = preload("res://data/recipes/pho_bo.tres")

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var placement_zone: PlacementZone = $"../PlacementZone"
@onready var inventory: InventoryService = $"../Inventory"
@onready var crosshair_label: Label = $HUD/Center/Crosshair
@onready var prompt_label: Label = $HUD/Center/Prompt
@onready var status_label: Label = $HUD/Center/Status

var held_bowl: InteractiveBowl


func _ready() -> void:
	_set_placement_zone_active(false)
	if not OS.has_feature("headless"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	status_label.text = "Nhắm vào bát để cầm. Công thức: bánh phở → thịt bò → chan nước dùng cuối cùng."


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return

	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		return

	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return

	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_x(-event.relative.y * mouse_sensitivity)
		camera.rotation.x = clampf(camera.rotation.x, deg_to_rad(-80.0), deg_to_rad(80.0))

	if event.is_action_pressed("cancel_preparation"):
		_cancel_preparation()
		return

	if event.is_action_pressed("interact") or event.is_action_pressed("primary_action"):
		_interact()


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_back"
	)
	var move_direction: Vector3 = (
		global_basis * Vector3(input_vector.x, 0.0, input_vector.y)
	).normalized()

	velocity.x = move_direction.x * move_speed
	velocity.z = move_direction.z * move_speed

	if not is_on_floor():
		velocity.y -= 9.8 * delta
	elif velocity.y < 0.0:
		velocity.y = 0.0

	move_and_slide()


func _process(_delta: float) -> void:
	if held_bowl != null and is_instance_valid(held_bowl):
		held_bowl.global_position = camera.global_position + camera.global_basis * Vector3(0.0, -0.28, -0.72)
		held_bowl.global_rotation = camera.global_rotation
	_refresh_prompt()


func _interact() -> void:
	raycast.force_raycast_update()
	var target: Object = raycast.get_collider() if raycast.is_colliding() else null

	if held_bowl != null:
		if target is KitchenStation:
			var station: KitchenStation = target as KitchenStation
			var result: Dictionary = station.apply_to_bowl(held_bowl, PHO_BO_RECIPE, inventory)
			status_label.text = String(result.get("message", "Thao tác chưa thực hiện."))
		elif target is PlacementZone and held_bowl.try_place(target as Node):
			held_bowl = null
			_set_placement_zone_active(false)
			status_label.text = "Đã đặt bát đúng vùng trên bàn."
		else:
			status_label.text = "Vị trí không hợp lệ. Bát vẫn đang được giữ."
		return

	if target is InteractiveBowl:
		var bowl: InteractiveBowl = target as InteractiveBowl
		if bowl.set_held():
			held_bowl = bowl
			_set_placement_zone_active(true)
			status_label.text = "Đã cầm bát. Cho bánh phở, xếp thịt bò, rồi chan nước dùng cuối cùng."
		else:
			status_label.text = "Bát đang được giữ."
	elif target is KitchenStation:
		status_label.text = "Cầm bát trước khi thao tác tại trạm."
	elif target is PlacementZone:
		status_label.text = "Cần cầm bát trước khi đặt."
	else:
		status_label.text = "Chưa nhắm vào vật có thể tương tác."


func _cancel_preparation() -> void:
	if held_bowl == null or not is_instance_valid(held_bowl):
		status_label.text = "Cần cầm bát để hủy phần đang chế biến."
		return
	var result: Dictionary = held_bowl.cancel_preparation()
	status_label.text = String(result.get("message", "Không thể hủy bát."))


func _refresh_prompt() -> void:
	var target: Object = raycast.get_collider() if raycast.is_colliding() else null

	if held_bowl != null:
		if target is KitchenStation:
			var station: KitchenStation = target as KitchenStation
			var preview: Dictionary = station.preview_action(held_bowl, PHO_BO_RECIPE, inventory)
			prompt_label.text = String(preview.get("message", "E / Click: thao tác tại trạm"))
			var prompt_color: Color = Color(0.35, 1.0, 0.55) if bool(preview.get("ok", false)) else Color(1.0, 0.72, 0.28)
			prompt_label.modulate = prompt_color
			crosshair_label.modulate = prompt_color
		elif target is PlacementZone:
			prompt_label.text = "E / Click: đặt bát vào vùng xanh"
			prompt_label.modulate = Color(0.35, 1.0, 0.55)
			crosshair_label.modulate = Color(0.35, 1.0, 0.55)
		else:
			prompt_label.text = "Mang bát tới: bánh phở → thịt bò → chan nước dùng cuối cùng · Q: hủy bát"
			prompt_label.modulate = Color(1.0, 0.72, 0.28)
			crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	elif target is InteractiveBowl:
		prompt_label.text = "E / Click: cầm bát"
		prompt_label.modulate = Color(0.35, 1.0, 0.55)
		crosshair_label.modulate = Color(0.35, 1.0, 0.55)
	elif target is KitchenStation:
		var station: KitchenStation = target as KitchenStation
		prompt_label.text = "Cầm bát trước khi dùng: " + station.station_label
		prompt_label.modulate = Color(1.0, 0.72, 0.28)
		crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	else:
		prompt_label.text = "WASD di chuyển · Chuột nhìn · E / Click tương tác"
		prompt_label.modulate = Color(1.0, 1.0, 1.0)
		crosshair_label.modulate = Color(1.0, 1.0, 1.0)


func _set_placement_zone_active(active: bool) -> void:
	placement_zone.collision_layer = 2 if active else 0
