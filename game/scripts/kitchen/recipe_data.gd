extends Resource
class_name RecipeData

@export var recipe_id: StringName = &"pho_bo"
@export var display_name: String = "Phở bò"
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
