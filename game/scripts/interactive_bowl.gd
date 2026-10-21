extends StaticBody3D
class_name InteractiveBowl

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

@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0


func set_held() -> bool:
	if state == BowlState.HELD:
		return false

	state = BowlState.HELD
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
	collision_layer = 2
	collision_mask = 0
	collision_shape.set_deferred("disabled", false)
	return true


func can_apply_recipe_step(action: StringName, recipe: RecipeData) -> bool:
	if state != BowlState.HELD or recipe == null:
		return false
	if preparation_state == PreparationState.READY_TO_SERVE:
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
	return {
		"ok": true,
		"message": "Đã hủy bát. Nguyên liệu đã dùng không được hoàn lại.",
		"wasted": wasted,
	}


func is_ready_to_serve() -> bool:
	return preparation_state == PreparationState.READY_TO_SERVE
