extends Resource
class_name RecipeData

@export var recipe_id: StringName = &"pho_bo"
@export var display_name: String = "Phở bò"
@export var steps: Array[Dictionary] = [
	{
		"action_id": &"add_broth",
		"ingredient_id": &"broth",
		"amount": 1,
		"label": "Chan nước dùng",
		"ingredient_label": "nước dùng",
	},
	{
		"action_id": &"add_noodles",
		"ingredient_id": &"noodles",
		"amount": 1,
		"label": "Thêm bánh phở",
		"ingredient_label": "bánh phở",
	},
	{
		"action_id": &"add_beef",
		"ingredient_id": &"beef",
		"amount": 1,
		"label": "Thêm thịt bò",
		"ingredient_label": "thịt bò",
	},
]


func step_at(index: int) -> Dictionary:
	if index < 0 or index >= steps.size():
		return {}
	return steps[index].duplicate(true)


func is_complete(next_step_index: int) -> bool:
	return next_step_index >= steps.size()
