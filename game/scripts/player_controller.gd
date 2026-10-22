extends CharacterBody3D

@export var move_speed: float = 4.5
@export var mouse_sensitivity: float = 0.0025

const PHO_BO_TAI_RECIPE = preload("res://data/recipes/pho_bo.tres")
const PHO_BO_CHIN_RECIPE = preload("res://data/recipes/pho_bo_chin.tres")

var active_recipe: RecipeData = PHO_BO_TAI_RECIPE

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var placement_zone: PlacementZone = $"../PlacementZone"
@onready var inventory: InventoryService = $"../Inventory"
@onready var crosshair_label: Label = $HUD/Center/Crosshair
@onready var prompt_label: Label = $HUD/Center/Prompt
@onready var status_label: Label = $HUD/Center/Status
@onready var order_ticket_label: Label = $HUD/OrderTicket
@onready var order_manager: OrderManager = $"../OrderManager"
@onready var serving_service: ServingService = $"../ServingService"
@onready var service_bowl: InteractiveBowl = $"../Bowl"

var held_bowl: InteractiveBowl
var current_order_id: StringName = &"order-001"
var current_table_id: StringName = &"table-1"
var _stations: Array[KitchenStation] = []


func _ready() -> void:
	_stations = [get_node("../NoodlesStation") as KitchenStation, get_node("../BeefStation") as KitchenStation, get_node("../CookedBeefStation") as KitchenStation, get_node("../BrothStation") as KitchenStation]
	_set_placement_zone_active(false)
	if not OS.has_feature("headless"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var created_order := order_manager.create_order(current_order_id, active_recipe.recipe_id, current_table_id)
	if not bool(created_order.get("ok", false)):
		status_label.text = String(created_order.get("message", "Không thể tạo đơn đầu tiên."))
	order_manager.order_changed.connect(_on_order_changed)
	_refresh_order_ticket()
	status_label.text = "Nhắm vào bát để cầm. Hoàn thành phiếu, đặt bát rồi giao tại vùng cạnh bàn."


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

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_V:
		var current_order := order_manager.get_order(current_order_id)
		if not current_order.is_empty() and int(current_order.get("status", -1)) != OrderManager.OrderStatus.SERVED and int(current_order.get("status", -1)) != OrderManager.OrderStatus.CANCELLED:
			status_label.text = "Hoàn thành phiếu hiện tại trước khi đổi món."
			return
		if held_bowl != null and is_instance_valid(held_bowl) and held_bowl.prepared_recipe_id != &"":
			status_label.text = "Bát này đã bắt đầu theo phiếu " + String(held_bowl.prepared_recipe_id) + ". Hãy hoàn thành hoặc hủy bát trước khi đổi phiếu."
			return
		active_recipe = PHO_BO_CHIN_RECIPE if active_recipe == PHO_BO_TAI_RECIPE else PHO_BO_TAI_RECIPE
		status_label.text = "Đã chọn phiếu: " + active_recipe.display_name + ". Chọn đúng khay thịt theo công thức."
		return

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
			var result: Dictionary = station.apply_to_bowl(held_bowl, active_recipe, inventory)
			status_label.text = String(result.get("message", "Thao tác chưa thực hiện."))
		elif target is PlacementZone and held_bowl.try_place(target as Node):
			var placed_bowl := held_bowl
			held_bowl = null
			_set_placement_zone_active(false)
			if placed_bowl.is_ready_to_serve():
				var order := order_manager.get_order(current_order_id)
				if int(order.get("status", -1)) == OrderManager.OrderStatus.PREPARING:
					order_manager.transition_order(current_order_id, OrderManager.OrderStatus.READY)
			status_label.text = "Đã đặt bát đúng vùng trên bàn."
		else:
			status_label.text = "Vị trí không hợp lệ. Bát vẫn đang được giữ."
		return

	if target is Area3D and target.name == "DeliveryZone":
		var result := serving_service.serve_order(service_bowl, order_manager, current_order_id, current_table_id)
		status_label.text = String(result.get("message", "Không thể giao món."))
		_refresh_order_ticket()
	elif target is InteractiveBowl:
		var bowl: InteractiveBowl = target as InteractiveBowl
		if bowl.set_held():
			held_bowl = bowl
			var order := order_manager.get_order(current_order_id)
			if int(order.get("status", -1)) == OrderManager.OrderStatus.ACCEPTED:
				order_manager.transition_order(current_order_id, OrderManager.OrderStatus.PREPARING)
			_set_placement_zone_active(true)
			status_label.text = "Đã cầm bát. Cho bánh phở, thêm thịt đúng trạng thái theo phiếu, rồi chan nước dùng cuối cùng."
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
			var preview: Dictionary = station.preview_action(held_bowl, active_recipe, inventory)
			prompt_label.text = String(preview.get("message", "E / Click: thao tác tại trạm"))
			var prompt_color: Color = Color(0.35, 1.0, 0.55) if bool(preview.get("ok", false)) else Color(1.0, 0.72, 0.28)
			prompt_label.modulate = prompt_color
			crosshair_label.modulate = prompt_color
		elif target is PlacementZone:
			prompt_label.text = "E / Click: đặt bát vào vùng xanh"
			prompt_label.modulate = Color(0.35, 1.0, 0.55)
			crosshair_label.modulate = Color(0.35, 1.0, 0.55)
		else:
			prompt_label.text = "Mang bát tới: bánh phở → thịt đúng trạng thái → chan nước dùng cuối cùng · Q: hủy bát"
			prompt_label.modulate = Color(1.0, 0.72, 0.28)
			crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	elif target is Area3D and target.name == "DeliveryZone":
		prompt_label.text = "E / Click: giao món · kiểm tra đúng phiếu và bàn"
		prompt_label.modulate = Color(0.35, 1.0, 0.55)
		crosshair_label.modulate = Color(0.35, 1.0, 0.55)
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
		prompt_label.text = "WASD di chuyển · Chuột nhìn · E / Click tương tác · V đổi phở tái/chín"
		prompt_label.modulate = Color(1.0, 1.0, 1.0)
		crosshair_label.modulate = Color(1.0, 1.0, 1.0)


func _set_placement_zone_active(active: bool) -> void:
	placement_zone.collision_layer = 2 if active else 0


func _on_order_changed(_order_id: StringName, _order: Dictionary) -> void:
	_refresh_order_ticket()


func _refresh_order_ticket() -> void:
	var order := order_manager.get_order(current_order_id)
	if order.is_empty():
		order_ticket_label.text = "PHIẾU MÓN\nChưa có đơn"
		return
	var status_names := {
		OrderManager.OrderStatus.ACCEPTED: "MỚI",
		OrderManager.OrderStatus.PREPARING: "ĐANG NẤU",
		OrderManager.OrderStatus.READY: "CHỜ GIAO",
		OrderManager.OrderStatus.SERVED: "ĐÃ PHỤC VỤ",
		OrderManager.OrderStatus.CANCELLED: "ĐÃ HỦY",
	}
	var recipe_name := active_recipe.display_name
	order_ticket_label.text = "PHIẾU #001  ·  BÀN 1\n%s\nTrạng thái: %s\nĐã thu: %d đơn" % [recipe_name, status_names.get(int(order.get("status", -1)), "KHÔNG RÕ"), serving_service.payment_event_count]
