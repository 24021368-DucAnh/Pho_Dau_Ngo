extends StaticBody3D
class_name InteractiveBowl

enum Owner { AVAILABLE, PLAYER, TRAY, TABLE, RACK }

@export var bowl_id: StringName = &"bowl-1"
var bowl_owner: Owner = Owner.AVAILABLE
var last_tray_slot_index: int = -1

enum BowlState {
	AVAILABLE,
	HELD,
	PLACED,
}

enum PreparationState {
	CLEAN,
	IN_PROGRESS,
	READY_TO_SERVE,
	DIRTY,
}

var state: int = BowlState.AVAILABLE
var preparation_state: int = PreparationState.CLEAN
var recipe_step_index: int = 0
var prepared_recipe_id: StringName = &""
var consumed_ingredients: Array[Dictionary] = []
var in_service := false

@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 1


func set_held() -> bool:
	if state == BowlState.HELD or in_service or (bowl_owner == Owner.RACK and preparation_state == PreparationState.DIRTY):
		return false

	state = BowlState.HELD
	bowl_owner = Owner.PLAYER
	last_tray_slot_index = -1
	collision_layer = 0
	collision_shape.set_deferred("disabled", true)
	return true


func try_place(target: Node) -> bool:
	if state != BowlState.HELD:
		return false
	if not target is PlacementZone:
		return false

	var zone: PlacementZone = target as PlacementZone
	global_transform = zone.get_placement_transform()
	state = BowlState.PLACED
	bowl_owner = Owner.TRAY if zone.tray_slot_index >= 0 else Owner.TABLE
	last_tray_slot_index = zone.tray_slot_index
	collision_layer = 2
	collision_mask = 1
	collision_shape.set_deferred("disabled", false)
	return true


func can_apply_recipe_step(action: StringName, recipe: RecipeData) -> bool:
	if state != BowlState.HELD or recipe == null:
		return false
	if preparation_state == PreparationState.READY_TO_SERVE:
		return false
	if preparation_state == PreparationState.DIRTY:
		return false
	if prepared_recipe_id != &"" and prepared_recipe_id != recipe.recipe_id:
		return false

	var step: Dictionary = recipe.step_at(recipe_step_index)
	return not step.is_empty() and StringName(step.get("action_id", &"")) == action


func apply_recipe_step(action: StringName, recipe: RecipeData) -> bool:
	if not can_apply_recipe_step(action, recipe):
		return false

	var step: Dictionary = recipe.step_at(recipe_step_index)
	if prepared_recipe_id == &"":
		prepared_recipe_id = recipe.recipe_id
	consumed_ingredients.append({
		"ingredient_id": StringName(step.get("ingredient_id", &"")),
		"amount": int(step.get("amount", 1)),
	})
	recipe_step_index += 1
	if recipe.is_complete(recipe_step_index):
		preparation_state = PreparationState.READY_TO_SERVE
	else:
		preparation_state = PreparationState.IN_PROGRESS
	_sync_visuals()
	return true


func cancel_preparation() -> Dictionary:
	if state != BowlState.HELD or preparation_state != PreparationState.IN_PROGRESS:
		return {
			"ok": false,
			"message": "Chỉ có thể hủy bát đang chế biến dở.",
			"wasted": [],
		}

	var wasted: Array[Dictionary] = consumed_ingredients.duplicate(true)
	recipe_step_index = 0
	prepared_recipe_id = &""
	consumed_ingredients.clear()
	preparation_state = PreparationState.CLEAN
	_sync_visuals()
	return {
		"ok": true,
		"message": "Đã hủy bát. Nguyên liệu đã dùng không được hoàn lại.",
		"wasted": wasted,
	}


func is_dirty() -> bool:
	return preparation_state == PreparationState.DIRTY


# Called by ServingService after a successful serve. The bowl stays PLACED
# with its leftovers visible (ingredients are NOT cleared) until it is
# washed, so a served bowl can never be re-served or re-cooked as-is.
# Returns false unless the bowl was ready to serve.
func mark_served_dirty() -> bool:
	if preparation_state != PreparationState.READY_TO_SERVE:
		return false
	preparation_state = PreparationState.DIRTY
	return true

func mark_in_service() -> bool:
	if state != BowlState.PLACED or preparation_state != PreparationState.READY_TO_SERVE:
		return false
	in_service = true
	return true

func finish_consumption() -> bool:
	if not in_service:
		return false
	in_service = false
	return mark_served_dirty()


# Washing is the only way back from DIRTY. It requires the bowl to be HELD
# (the player carries it to the wash zone) and resets it to a clean bowl:
# no ingredients, no recipe, step index back to zero, visuals clean.
func wash() -> Dictionary:
	if state != BowlState.HELD or preparation_state != PreparationState.DIRTY:
		return {"ok": false, "message": "Chỉ rửa được bát bẩn đang cầm trên tay."}
	recipe_step_index = 0
	prepared_recipe_id = &""
	consumed_ingredients.clear()
	preparation_state = PreparationState.CLEAN
	_sync_visuals()
	return {"ok": true, "message": "Đã rửa sạch bát."}

func put_in_rack() -> bool:
	if state != BowlState.HELD or not is_dirty() or in_service:
		return false
	state = BowlState.PLACED
	bowl_owner = Owner.RACK
	last_tray_slot_index = -1
	collision_layer = 0
	return true

func wash_after_batch() -> bool:
	if bowl_owner != Owner.RACK or not is_dirty() or in_service:
		return false
	recipe_step_index = 0
	prepared_recipe_id = &""
	consumed_ingredients.clear()
	preparation_state = PreparationState.CLEAN
	collision_layer = 2
	collision_shape.set_deferred("disabled", false)
	_sync_visuals()
	return true


func is_ready_to_serve() -> bool:
	return preparation_state == PreparationState.READY_TO_SERVE


# Visuals-only sync: pushes the authoritative consumed_ingredients to the
# modular visual child when it exists (gameplay scene). Isolated bowls
# created from script alone have no BowlVisuals child, so this is a no-op
# there and never changes recipe, inventory, Ledger or collision state.
func _sync_visuals() -> void:
	var visuals := get_node_or_null("BowlVisuals") as PhoBowlVisuals
	if visuals != null:
		visuals.apply_state(consumed_ingredients)
