extends Resource
class_name RecipeData

@export var recipe_id: StringName = &"pho_bo"
@export var display_name: String = "Phở bò"
@export_enum("tai", "chin") var beef_variant: String = "tai"
# Deprecated compatibility field; recipe semantics never use a beef blanch timer.
@export var blanch_duration_seconds: float = 0.0


func steps_for_recipe() -> Array[Dictionary]:
	var beef_action: StringName = &"add_raw_beef"
	var beef_ingredient: StringName = &"raw_sliced_beef"
	var beef_label := "Xếp thịt bò tái thái mỏng lên bánh phở"
	if beef_variant == "chin":
		beef_action = &"add_cooked_beef"
		beef_ingredient = &"cooked_sliced_beef"
		beef_label = "Xếp thịt bò đã nấu chín và thái lát lên bánh phở"
	return [
		{"action_id": &"add_noodles", "ingredient_id": &"noodles", "amount": 1, "label": "Trụng riêng bánh phở, để ráo rồi cho vào bát", "ingredient_label": "bánh phở"},
		{"action_id": beef_action, "ingredient_id": beef_ingredient, "amount": 1, "label": beef_label, "ingredient_label": "thịt bò đã sơ chế đúng trạng thái"},
		{"action_id": &"add_broth", "ingredient_id": &"broth", "amount": 1, "label": "Chan nước dùng nóng lên bát (bước cuối)", "ingredient_label": "nước dùng"},
	]


func step_at(index: int) -> Dictionary:
	var steps := steps_for_recipe()
	if index < 0 or index >= steps.size():
		return {}
	return steps[index].duplicate(true)


func is_complete(next_step_index: int) -> bool:
	return next_step_index >= steps_for_recipe().size()


func is_valid_recipe() -> bool:
	if recipe_id == &"" or display_name.strip_edges().is_empty():
		return false
	if beef_variant != "tai" and beef_variant != "chin":
		return false
	var steps := steps_for_recipe()
	return (
		steps.size() == 3
		and StringName(steps[0].get("action_id", &"")) == &"add_noodles"
		and StringName(steps[0].get("ingredient_id", &"")) == &"noodles"
		and StringName(steps[1].get("action_id", &"")) == (&"add_raw_beef" if beef_variant == "tai" else &"add_cooked_beef")
		and StringName(steps[1].get("ingredient_id", &"")) == (&"raw_sliced_beef" if beef_variant == "tai" else &"cooked_sliced_beef")
		and StringName(steps[2].get("action_id", &"")) == &"add_broth"
		and StringName(steps[2].get("ingredient_id", &"")) == &"broth"
		and int(steps[0].get("amount", 0)) > 0
		and int(steps[1].get("amount", 0)) > 0
		and int(steps[2].get("amount", 0)) > 0
	)
