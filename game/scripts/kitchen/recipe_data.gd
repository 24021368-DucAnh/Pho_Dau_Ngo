extends Resource
class_name RecipeData

@export var recipe_id: StringName = &"pho_bo"
@export var display_name: String = "Phở bò"
@export_enum("tai", "chin") var beef_variant: String = "tai"
@export_range(0.0, 30.0, 0.25) var blanch_duration_seconds: float = 1.0
@export var steps: Array[Dictionary] = [
	{
		"action_id": &"add_noodles",
		"ingredient_id": &"noodles",
		"amount": 1,
		"label": "Cho bánh phở vào bát",
		"ingredient_label": "bánh phở",
	},
	{
		"action_id": &"add_beef",
		"ingredient_id": &"beef",
		"amount": 1,
		"label": "Xếp thịt bò lên bánh phở",
		"ingredient_label": "thịt bò",
	},
	{
		"action_id": &"add_broth",
		"ingredient_id": &"broth",
		"amount": 1,
		"label": "Chan nước dùng nóng (bước cuối)",
		"ingredient_label": "nước dùng",
	},
]


func step_at(index: int) -> Dictionary:
	if index < 0 or index >= steps.size():
		return {}
	return steps[index].duplicate(true)


func is_complete(next_step_index: int) -> bool:
	return next_step_index >= steps.size()


func is_valid_recipe() -> bool:
	if recipe_id == &"" or display_name.strip_edges().is_empty():
		return false
	if beef_variant != "tai" and beef_variant != "chin":
		return false
	if not is_finite(blanch_duration_seconds) or blanch_duration_seconds < 0.0:
		return false
	if steps.size() != 3:
		return false
	return (
		StringName(step_at(0).get("action_id", &"")) == &"add_noodles"
		and StringName(step_at(0).get("ingredient_id", &"")) == &"noodles"
		and int(step_at(0).get("amount", 0)) > 0
		and StringName(step_at(1).get("action_id", &"")) == &"add_beef"
		and StringName(step_at(1).get("ingredient_id", &"")) == &"beef"
		and int(step_at(1).get("amount", 0)) > 0
		and StringName(step_at(2).get("action_id", &"")) == &"add_broth"
		and StringName(step_at(2).get("ingredient_id", &"")) == &"broth"
		and int(step_at(2).get("amount", 0)) > 0
	)
