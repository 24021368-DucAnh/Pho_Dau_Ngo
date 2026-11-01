extends CharacterBody3D

@export var move_speed: float = 4.5
@export var mouse_sensitivity: float = 0.0025

const PHO_BO_TAI_RECIPE = preload("res://data/recipes/pho_bo.tres")
const PHO_BO_CHIN_RECIPE = preload("res://data/recipes/pho_bo_chin.tres")

# M6 provisional slice values. These are NOT an approved price catalogue:
# DUC-49 economy review is still open, and the values below only reuse the
# numbers already used by the domain tests (opening cash 100,000 and sale
# 45,000) so that in-game serving posts the same Ledger movement the tests
# prove. They must be labelled provisional in any UI or summary text and
# replaced once the economy review approves real values.
const PROVISIONAL_DAY_ID: StringName = &"day-01"
const PROVISIONAL_OPENING_CASH: int = 100000
const PROVISIONAL_SALE_PRICE: int = 45000

var active_recipe: RecipeData = PHO_BO_TAI_RECIPE

@onready var camera: Camera3D = $Camera3D
@onready var raycast: RayCast3D = $Camera3D/RayCast3D
@onready var placement_zone: PlacementZone = $"../PlacementZone"
@onready var ship_zone: PlacementZone = $"../ShipZone"
@onready var inventory: InventoryService = $"../Inventory"
@onready var crosshair_label: Label = $HUD/Center/Crosshair
@onready var prompt_label: Label = $HUD/Center/Prompt
@onready var status_label: Label = $HUD/Center/Status
@onready var order_ticket_label: Label = $HUD/OrderTicket
@onready var cash_label: Label = $HUD/CashHUD
@onready var order_manager: OrderManager = $"../OrderManager"
@onready var serving_service: ServingService = $"../ServingService"
@onready var ledger: Ledger = $"../Ledger"
@onready var day_controller: DayController = $"../DayController"
@onready var shift_coordinator: ShiftCoordinator = $"../ShiftCoordinator"
@onready var table_service: TableService = $"../TableService"
@onready var customer_director: CustomerDirector = $"../CustomerDirector"
@onready var cooking_coordinator: CookingCoordinator = $"../CookingCoordinator"
@onready var tray_controller: TrayController = $"../TrayController"
@onready var meal_service: MealService = $"../MealService"
@onready var wash_batch: WashBatchService = $"../WashBatchService"
@onready var tray_slot_1: PlacementZone = $"../TraySlot1"
@onready var tray_base: MeshInstance3D = $"../ShipTable/TrayBase"

var held_bowl: InteractiveBowl
var current_order_id: StringName = &"order-001"
var current_table_id: StringName = &"table-1"
var _table_zones: Array[PlacementZone] = []
var _stations: Array[KitchenStation] = []
var _tray_home: Array[Transform3D] = []


func _ready() -> void:
	_stations = [get_node("../NoodlesStation") as KitchenStation, get_node("../BeefStation") as KitchenStation, get_node("../CookedBeefStation") as KitchenStation, get_node("../BrothStation") as KitchenStation]
	_table_zones = [placement_zone, get_node("../Table2Zone") as PlacementZone, get_node("../Table3Zone") as PlacementZone]
	_tray_home = [tray_base.global_transform, ship_zone.global_transform, tray_slot_1.global_transform]
	_set_placement_zone_active(false)
	if not OS.has_feature("headless"):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	order_manager.order_changed.connect(_on_order_changed)
	cooking_coordinator.configure(order_manager)
	meal_service.configure(order_manager)
	meal_service.meal_finished.connect(_on_meal_finished)
	wash_batch.configure([get_node("../Bowl") as InteractiveBowl, get_node("../Bowl2") as InteractiveBowl])
	wash_batch.wash_finished.connect(_on_wash_finished)
	table_service.table_changed.connect(_on_table_changed)
	_refresh_order_ticket()
	status_label.text = "Nhắm vào bát để cầm. Hoàn thành phiếu, mang bát lên bàn giao món bên phải rồi bấm E để ship."
	# M6 wiring: open the day with the Ledger, then point ServingService at
	# the same Ledger and day. If wiring fails, the game keeps the previous
	# behaviour (serving without a Ledger movement) instead of crashing, and
	# the failure is shown in the status label (this block runs last so the
	# default status above does not overwrite a wiring failure).
	var configured := day_controller.configure(ledger, inventory)
	if bool(configured.get("ok", false)):
		var shift_configured := shift_coordinator.configure(order_manager, serving_service, day_controller, inventory)
		var started := shift_coordinator.open_shift(PROVISIONAL_DAY_ID, PROVISIONAL_OPENING_CASH) if bool(shift_configured.get("ok", false)) else shift_configured
		if bool(started.get("ok", false)):
			serving_service.configure_ledger(ledger, PROVISIONAL_DAY_ID)
			serving_service.payment_recorded.connect(_on_payment_recorded)
			_refresh_cash_hud()
			var setup := customer_director.configure(table_service, order_manager, load("res://data/day01_customers.tres"))
			if bool(setup.get("ok", false)):
				customer_director.start_shift()
				_select_order(&"order-001")
			else:
				status_label.text = String(setup.get("message", "Không nạp được khách."))
		else:
			status_label.text = "Không mở được ngày bán hàng: " + String(started.get("message", ""))
	else:
		status_label.text = "Không cấu hình được Ledger/DayController: " + String(configured.get("message", ""))
	day_controller.day_closed.connect(_on_day_closed)
	shift_coordinator.shift_phase_changed.connect(_on_shift_phase_changed)


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

	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_T:
		_toggle_tray()
		return

	if event.is_action_pressed("cancel_preparation"):
		_cancel_preparation()
		return

	if event.is_action_pressed("close_day"):
		_close_day()
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
	if tray_controller.is_carried():
		_update_carried_tray()
	_refresh_prompt()


func _interact() -> void:
	raycast.force_raycast_update()
	var target: Object = raycast.get_collider() if raycast.is_colliding() else null
	if target is PaymentZone:
		_collect_payment(target as PaymentZone)
		return
	if tray_controller.is_carried() and target is PlacementZone and target.table_id != &"":
		_deliver_from_tray(target as PlacementZone)
		return

	if held_bowl != null:
		if target is KitchenStation:
			var station: KitchenStation = target as KitchenStation
			var bound_order := cooking_coordinator.lookup_bowl_order(held_bowl.bowl_id)
			if bound_order != &"" and bound_order != current_order_id:
				status_label.text = "Bát này thuộc phiếu %s. Nhấn V để chọn đúng phiếu." % String(bound_order)
				return
			if bound_order == &"" and bool(station.preview_action(held_bowl, active_recipe, inventory).get("ok", false)):
				var binding := cooking_coordinator.bind_bowl_to_order(held_bowl.bowl_id, current_order_id)
				if not bool(binding.get("ok", false)):
					status_label.text = String(binding.get("message", "Không gắn được bát với phiếu."))
					return
			var result: Dictionary = station.apply_to_bowl(held_bowl, active_recipe, inventory)
			status_label.text = String(result.get("message", "Thao tác chưa thực hiện."))
			if bool(result.get("ok", false)):
				var active_order := order_manager.get_order(current_order_id)
				if int(active_order.get("status", -1)) == OrderManager.OrderStatus.ACCEPTED:
					order_manager.transition_order(current_order_id, OrderManager.OrderStatus.PREPARING)
		elif target is Area3D and target.name == "WashZone":
			var wash_result: Dictionary = wash_batch.enqueue(held_bowl.bowl_id)
			status_label.text = String(wash_result.get("message", "Không rửa được bát."))
			if bool(wash_result.get("ok", false)):
				var rack_state: Dictionary = wash_batch.get_state()
				var rack_index: int = int(rack_state.get("queued_count", 0)) + int(rack_state.get("washing_count", 0)) + int(rack_state.get("clean_count", 0)) - 1
				held_bowl.global_position = Vector3(-1.37 + float(rack_index % 2) * 0.34, 0.82, -0.42 + float(rack_index / 2) * 0.22)
				held_bowl.global_rotation = Vector3.ZERO
				held_bowl = null
				_set_placement_zone_active(false)
			_refresh_order_ticket()
		elif target is PlacementZone:
			var zone := target as PlacementZone
			if zone.tray_slot_index >= 0:
				if not held_bowl.is_ready_to_serve() or cooking_coordinator.lookup_bowl_order(held_bowl.bowl_id) == &"":
					status_label.text = "Khay chỉ nhận bát đã nấu và có phiếu."
					return
				var inserted := tray_controller.try_insert(held_bowl.bowl_id, zone.tray_slot_index)
				if not bool(inserted.get("ok", false)):
					status_label.text = String(inserted.get("message", "Vị trí khay đã đầy."))
					return
			if held_bowl.is_ready_to_serve() and zone.table_id != &"" and not table_service.can_deliver(zone.table_id, current_order_id):
				status_label.text = "Sai bàn nhận món. Xem số bàn trên phiếu."
				return
			if held_bowl.is_ready_to_serve() and zone.table_id != &"":
				var waiting := order_manager.get_open_orders()
				if waiting.is_empty() or StringName(waiting[0].get("order_id", &"")) != current_order_id:
					status_label.text = "Khách đến trước đang chờ. Hãy giao phiếu đầu tiên."
					return
			if not held_bowl.try_place(zone):
				if zone.tray_slot_index >= 0:
					tray_controller.try_remove(zone.tray_slot_index)
				status_label.text = "Không đặt được bát vào vùng này."
				return
			var placed_bowl := held_bowl
			held_bowl = null
			_set_placement_zone_active(false)
			if placed_bowl.is_ready_to_serve():
				var order := order_manager.get_order(current_order_id)
				if int(order.get("status", -1)) == OrderManager.OrderStatus.PREPARING:
					order_manager.transition_order(current_order_id, OrderManager.OrderStatus.READY)
			if zone.table_id != &"" and placed_bowl.is_ready_to_serve():
				var ship_result := serving_service.deliver_order(placed_bowl, order_manager, current_order_id, zone.table_id)
				status_label.text = String(ship_result.get("message", "Không thể giao món."))
				if bool(ship_result.get("ok", false)):
					meal_service.start_meal(current_order_id, table_service.get_customer(zone.table_id))
					var remaining := order_manager.get_open_orders()
					if not remaining.is_empty():
						_select_order(StringName(remaining[0].get("order_id", &"")))
				_refresh_order_ticket()
			elif placed_bowl.is_ready_to_serve():
				status_label.text = "Bát đã sẵn sàng. Mang tới đúng bàn trên phiếu để giao."
				if zone.tray_slot_index >= 0:
					_select_next_order()
			else:
				status_label.text = "Đã đặt bát đúng vùng trên bàn, nhưng bát chưa đủ bước. Cầm lại bát để làm tiếp."
		else:
			status_label.text = "Vị trí không hợp lệ. Bát vẫn đang được giữ."
		return

	if target is InteractiveBowl:
		var bowl: InteractiveBowl = target as InteractiveBowl
		if _try_pick_up_bowl(bowl):
			var bound_order := cooking_coordinator.lookup_bowl_order(bowl.bowl_id)
			if bound_order != &"":
				_select_order(bound_order)
			var order := order_manager.get_order(current_order_id)
			if int(order.get("status", -1)) == OrderManager.OrderStatus.ACCEPTED:
				order_manager.transition_order(current_order_id, OrderManager.OrderStatus.PREPARING)
			status_label.text = "Đã cầm bát. Cho bánh phở, thêm thịt đúng trạng thái theo phiếu, rồi chan nước dùng cuối cùng."
		else:
			status_label.text = "Bát đang được giữ hoặc người chơi đã cầm một bát."
	elif target is KitchenStation:
		status_label.text = "Cầm bát trước khi thao tác tại trạm."
	elif target is PlacementZone:
		status_label.text = "Cần cầm bát trước khi đặt."
	elif target is Area3D and target.name == "WashZone":
		var result := wash_batch.start_batch()
		status_label.text = String(result.get("message", "Không thể bắt đầu rửa."))
	else:
		status_label.text = "Chưa nhắm vào vật có thể tương tác."


func _cancel_preparation() -> void:
	if held_bowl == null or not is_instance_valid(held_bowl):
		status_label.text = "Cần cầm bát để hủy phần đang chế biến."
		return
	var result: Dictionary = held_bowl.cancel_preparation()
	status_label.text = String(result.get("message", "Không thể hủy bát."))


func _close_day() -> void:
	var confirming_early_close := shift_coordinator.phase == ShiftCoordinator.Phase.CLOSING
	var result: Dictionary = shift_coordinator.request_close()
	if not bool(result.get("ok", false)):
		status_label.text = "Không đóng được ngày: " + String(result.get("message", ""))
		return
	if bool(result.get("already_closed", false)):
		_show_day_summary(Dictionary(result.get("summary", {})))
		return
	if int(result.get("outstanding_orders", 0)) > 0 and not confirming_early_close:
		status_label.text = "Còn %d đơn chưa phục vụ. Nhấn C lần nữa để đóng sớm." % int(result.get("outstanding_orders", 0))
		return
	result = shift_coordinator.finish_close()
	if not bool(result.get("ok", false)):
		status_label.text = "Không đóng được ngày: " + String(result.get("message", ""))
		return
	_show_day_summary(Dictionary(result.get("summary", {})))

func _on_shift_phase_changed(phase: int) -> void:
	if phase != ShiftCoordinator.Phase.OPEN:
		customer_director.stop_arrivals()

func _on_meal_finished(order_id: StringName) -> void:
	var order := order_manager.get_order(order_id)
	var table_id := StringName(order.get("table_id", &""))
	for table_zone in _table_zones:
		if table_zone.table_id == table_id:
			table_zone.collision_layer = 0
	var zone := _payment_zone_for_table(table_id)
	if zone != null:
		zone.collision_layer = 2
	status_label.text = "Khách ở %s ăn xong. Đến bàn nhấn E để thu tiền." % String(table_id)

func _on_wash_finished(bowl_ids: Array) -> void:
	for bowl_id in bowl_ids:
		if cooking_coordinator.lookup_bowl_order(StringName(bowl_id)) != &"":
			cooking_coordinator.release_after_wash(StringName(bowl_id))
	status_label.text = "Đã rửa xong %d bát. Lấy bát sạch trên giá để dùng tiếp." % bowl_ids.size()

func _payment_zone_for_table(table_id: StringName) -> PaymentZone:
	for index in range(1, 4):
		var zone := get_node("../PaymentZone%d" % index) as PaymentZone
		if zone.table_id == table_id:
			return zone
	return null

func _collect_payment(zone: PaymentZone) -> void:
	if held_bowl != null:
		status_label.text = "Đặt bát xuống trước khi thu tiền."
		return
	for order in order_manager.get_orders():
		if StringName(order.get("table_id", &"")) != zone.table_id or int(order.get("payment_status", -1)) != OrderManager.PaymentStatus.PAYMENT_PENDING:
			continue
		var order_id := StringName(order.get("order_id", &""))
		var result := serving_service.settle_order(order_manager, order_id, PROVISIONAL_SALE_PRICE)
		status_label.text = String(result.get("message", "Không thu được tiền."))
		if bool(result.get("ok", false)):
			zone.collision_layer = 0
			var bowl := _get_bowl_by_order(order_id)
			if bowl != null:
				bowl.finish_consumption()
			table_service.release_table(zone.table_id)
		return
	status_label.text = "Bàn này chưa chờ thanh toán."

func _get_bowl_by_order(order_id: StringName) -> InteractiveBowl:
	for bowl in [get_node("../Bowl") as InteractiveBowl, get_node("../Bowl2") as InteractiveBowl]:
		if cooking_coordinator.lookup_bowl_order(bowl.bowl_id) == order_id:
			return bowl
	return null

func _on_table_changed(table_id: StringName, customer_id: StringName) -> void:
	var proxy_names := {&"table-1": "CustomerProxy1", &"table-2": "CustomerProxy2", &"table-3": "CustomerProxy3"}
	if proxy_names.has(table_id):
		get_node("../" + String(proxy_names[table_id])).visible = customer_id != &""


func _on_day_closed(summary: Dictionary) -> void:
	_show_day_summary(summary)


func _show_day_summary(summary: Dictionary) -> void:
	if summary.is_empty():
		return
	# All money shown here is provisional until DUC-49 approves real values.
	status_label.text = "Đã đóng ngày %s (tạm tính). Doanh thu: %d. Tiền cuối ngày: %d. Số giao dịch: %d." % [
		String(summary.get("day_id", "")),
		int(summary.get("revenue", 0)),
		int(summary.get("closing_cash", 0)),
		int(summary.get("transaction_count", 0)),
	]


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
		elif target is Area3D and target.name == "WashZone":
			if held_bowl.is_dirty():
				prompt_label.text = "E / Click: đặt bát bẩn lên giá"
				prompt_label.modulate = Color(0.35, 1.0, 0.55)
				crosshair_label.modulate = Color(0.35, 1.0, 0.55)
			else:
				prompt_label.text = "Chậu rửa — bát này không bẩn"
				prompt_label.modulate = Color(1.0, 0.72, 0.28)
				crosshair_label.modulate = Color(1.0, 0.72, 0.28)
		elif target is PlacementZone:
			if target.table_id != &"":
				prompt_label.text = "E / Click: giao tại " + String(target.table_id)
			else:
				prompt_label.text = "E / Click: đặt bát tạm"
			prompt_label.modulate = Color(0.35, 1.0, 0.55)
			crosshair_label.modulate = Color(0.35, 1.0, 0.55)
		else:
			prompt_label.text = "Mang bát tới: bánh phở → thịt đúng trạng thái → chan nước dùng cuối cùng · Q: hủy bát"
			prompt_label.modulate = Color(1.0, 0.72, 0.28)
			crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	elif target is Area3D and target.name == "WashZone":
		prompt_label.text = "E / Click: bắt đầu rửa bát trên giá"
		prompt_label.modulate = Color(1.0, 0.72, 0.28)
		crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	elif target is PaymentZone:
		prompt_label.text = "E / Click: thu tiền tại " + String(target.table_id)
		prompt_label.modulate = Color(0.35, 1.0, 0.55)
		crosshair_label.modulate = Color(0.35, 1.0, 0.55)
	elif target is InteractiveBowl:
		var prompt_bowl := target as InteractiveBowl
		if int(prompt_bowl.state) == InteractiveBowl.BowlState.PLACED and prompt_bowl.is_ready_to_serve():
			prompt_label.text = "E / Click: cầm bát tới đúng bàn"
		elif prompt_bowl.is_dirty():
			prompt_label.text = "E / Click: cầm bát bẩn đi rửa"
		else:
			prompt_label.text = "E / Click: cầm bát"
		prompt_label.modulate = Color(0.35, 1.0, 0.55)
		crosshair_label.modulate = Color(0.35, 1.0, 0.55)
	elif target is KitchenStation:
		var station: KitchenStation = target as KitchenStation
		prompt_label.text = "Cầm bát trước khi dùng: " + station.station_label
		prompt_label.modulate = Color(1.0, 0.72, 0.28)
		crosshair_label.modulate = Color(1.0, 0.72, 0.28)
	elif target is PlacementZone and tray_controller.is_carried() and target.table_id != &"":
		prompt_label.text = "E / Click: giao bát trên khay tại " + String(target.table_id)
		prompt_label.modulate = Color(0.35, 1.0, 0.55)
		crosshair_label.modulate = Color(0.35, 1.0, 0.55)
	else:
		prompt_label.text = "WASD di chuyển · E / Click tương tác · T bưng/đặt khay · Q hủy bát"
		prompt_label.modulate = Color(1.0, 1.0, 1.0)
		crosshair_label.modulate = Color(1.0, 1.0, 1.0)


func _set_placement_zone_active(active: bool) -> void:
	for zone in _table_zones:
		var payment_waiting := false
		for order in order_manager.get_unpaid_delivered_orders():
			if StringName(order.get("table_id", &"")) == zone.table_id and int(order.get("payment_status", -1)) == OrderManager.PaymentStatus.PAYMENT_PENDING:
				payment_waiting = true
				break
		zone.collision_layer = 0 if payment_waiting else (2 if active or tray_controller.is_carried() else 0)
	ship_zone.collision_layer = 2 if active and not tray_controller.is_carried() else 0
	tray_slot_1.collision_layer = 2 if active and not tray_controller.is_carried() else 0


func _on_order_changed(_order_id: StringName, _order: Dictionary) -> void:
	_refresh_order_ticket()

func _on_payment_recorded(_order_id: StringName, _recipe_id: StringName, _table_id: StringName) -> void:
	_refresh_cash_hud()

func _refresh_cash_hud() -> void:
	var totals := ledger.get_day_totals(PROVISIONAL_DAY_ID)
	cash_label.text = "Tiền hiện có: %d đ  ·  Doanh thu: %d đ (tạm tính)" % [int(totals.get("closing_cash", 0)), int(totals.get("revenue", 0))]


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
	var recipe_name := PHO_BO_CHIN_RECIPE.display_name if StringName(order.get("recipe_id", &"")) == PHO_BO_CHIN_RECIPE.recipe_id else PHO_BO_TAI_RECIPE.display_name
	var order_no := String(order.get("order_id", "")).replace("order-", "")
	var table_no := String(order.get("table_id", "")).replace("table-", "")
	order_ticket_label.text = "PHIẾU #%s  ·  BÀN %s\n%s\nTrạng thái: %s\nĐã thu: %d đơn" % [order_no, table_no, recipe_name, status_names.get(int(order.get("status", -1)), "KHÔNG RÕ"), serving_service.payment_event_count]


func _select_order(order_id: StringName) -> void:
	var order := order_manager.get_order(order_id)
	if order.is_empty():
		return
	current_order_id = order_id
	current_table_id = StringName(order.get("table_id", &""))
	active_recipe = PHO_BO_CHIN_RECIPE if StringName(order.get("recipe_id", &"")) == PHO_BO_CHIN_RECIPE.recipe_id else PHO_BO_TAI_RECIPE
	_refresh_order_ticket()
	status_label.text = "Đã chọn phiếu %s, %s. Nấu đúng công thức rồi mang tới %s." % [String(order_id), active_recipe.display_name, String(current_table_id)]

func _select_next_order() -> void:
	var open_orders := order_manager.get_open_orders()
	if open_orders.is_empty():
		status_label.text = "Không còn đơn cần nấu."
		return
	for index in open_orders.size():
		if StringName(open_orders[index].get("order_id", &"")) == current_order_id and index + 1 < open_orders.size():
			_select_order(StringName(open_orders[index + 1].get("order_id", &"")))
			return

func _toggle_tray() -> void:
	if held_bowl != null:
		status_label.text = "Đặt bát xuống trước khi bưng khay."
		return
	if tray_controller.is_carried():
		tray_controller.end_carry()
		for index in _tray_home.size():
			[tray_base, ship_zone, tray_slot_1][index].global_transform = _tray_home[index]
		_update_tray_bowls()
		for bowl_id in tray_controller.get_slots():
			var tray_bowl := _get_bowl_by_id(StringName(bowl_id))
			if tray_bowl != null:
				tray_bowl.collision_layer = 2
		_set_placement_zone_active(false)
		status_label.text = "Đã đặt khay về bàn chuẩn bị."
		return
	if global_position.distance_to(get_node("../ShipTable").global_position) > 2.5:
		status_label.text = "Lại gần bàn đặt khay để bưng."
		return
	tray_controller.begin_carry()
	_set_placement_zone_active(false)
	_update_carried_tray()
	status_label.text = "Đang bưng khay. Nhắm đúng bàn và bấm E để giao bát trên khay; T đặt khay về bàn."

func _update_carried_tray() -> void:
	var center := camera.global_position + camera.global_basis * Vector3(0.0, -0.43, -0.88)
	var basis_yaw := global_basis
	tray_base.global_transform = Transform3D(basis_yaw, center)
	ship_zone.global_transform = Transform3D(basis_yaw, center + basis_yaw * Vector3(0, 0.04, -0.09))
	tray_slot_1.global_transform = Transform3D(basis_yaw, center + basis_yaw * Vector3(0, 0.04, 0.09))
	_update_tray_bowls()

func _update_tray_bowls() -> void:
	var slots := tray_controller.get_slots()
	for index in slots.size():
		var bowl := _get_bowl_by_id(StringName(slots[index]))
		if bowl != null:
			bowl.global_transform = (ship_zone if index == 0 else tray_slot_1).get_placement_transform()
			if tray_controller.is_carried():
				bowl.collision_layer = 0

func _get_bowl_by_id(bowl_id: StringName) -> InteractiveBowl:
	for bowl in [get_node("../Bowl") as InteractiveBowl, get_node("../Bowl2") as InteractiveBowl]:
		if bowl.bowl_id == bowl_id:
			return bowl
	return null

func _deliver_from_tray(zone: PlacementZone) -> void:
	var slots := tray_controller.get_slots()
	for index in slots.size():
		var bowl := _get_bowl_by_id(StringName(slots[index]))
		if bowl == null:
			continue
		var order_id := cooking_coordinator.lookup_bowl_order(bowl.bowl_id)
		var order := order_manager.get_order(order_id)
		if StringName(order.get("table_id", &"")) != zone.table_id:
			continue
		var waiting := order_manager.get_open_orders()
		if waiting.is_empty() or StringName(waiting[0].get("order_id", &"")) != order_id:
			status_label.text = "Khách đến trước đang chờ. Hãy giao phiếu đầu tiên."
			return
		if not bowl.is_ready_to_serve():
			status_label.text = "Bát trên khay chưa nấu xong."
			return
		tray_controller.try_remove(index)
		bowl.set_held()
		bowl.try_place(zone)
		if int(order.get("status", -1)) == OrderManager.OrderStatus.PREPARING:
			order_manager.transition_order(order_id, OrderManager.OrderStatus.READY)
		var served := serving_service.deliver_order(bowl, order_manager, order_id, zone.table_id)
		status_label.text = String(served.get("message", "Không thể giao món."))
		if bool(served.get("ok", false)):
			meal_service.start_meal(order_id, table_service.get_customer(zone.table_id))
			var remaining := order_manager.get_open_orders()
			if not remaining.is_empty():
				_select_order(StringName(remaining[0].get("order_id", &"")))
		_refresh_order_ticket()
		return
	status_label.text = "Trên khay không có bát cho bàn này."


func _try_pick_up_bowl(bowl: InteractiveBowl) -> bool:
	if bowl == null or not is_instance_valid(bowl):
		return false
	if held_bowl != null and is_instance_valid(held_bowl):
		return false
	var was_on_rack := bowl.bowl_owner == InteractiveBowl.Owner.RACK
	var tray_slot := bowl.last_tray_slot_index
	if tray_slot >= 0:
		var removed := tray_controller.try_remove(tray_slot)
		if not bool(removed.get("ok", false)) or StringName(removed.get("bowl_id", &"")) != bowl.bowl_id:
			return false
	if not bowl.set_held():
		if tray_slot >= 0:
			tray_controller.try_insert(bowl.bowl_id, tray_slot)
		return false
	if was_on_rack:
		wash_batch.take_clean(bowl.bowl_id)
	held_bowl = bowl
	_set_placement_zone_active(true)
	return true
