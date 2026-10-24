# Visuals-only script for the modular pho bowl.
# It must NOT decide whether a recipe step is valid, and must NOT mutate
# InteractiveBowl state. It only shows/hides visual children based on the
# authoritative consumed_ingredients array passed in after a successful step.
# Ingredient IDs verified from game/scripts/kitchen/recipe_data.gd:
#   noodles, raw_sliced_beef / cooked_sliced_beef, broth
# Order in code is noodles -> beef -> broth, but this script does NOT
# hard-code an order: it checks presence in consumed_ingredients.
# Garnish and chopsticks are presentation-only: they are shown only when
# all three consumed ingredients are present (ready state), never as a
# recipe step, and never as a consumed ingredient.
class_name PhoBowlVisuals
extends Node3D

@export var bowl_base_path: NodePath = NodePath("BowlBase")
@export var noodles_path: NodePath = NodePath("NoodlesLayer")
@export var broth_path: NodePath = NodePath("BrothSurface")
@export var beef_path: NodePath = NodePath("BeefLayer")
@export var garnish_path: NodePath = NodePath("GarnishLayer")
@export var chopsticks_path: NodePath = NodePath("ChopsticksExtra")

func _ready() -> void:
	apply_state([])

func apply_state(consumed_ingredients: Array) -> void:
	var ids: Array[String] = []
	for item in consumed_ingredients:
		if item is Dictionary and item.has("ingredient_id"):
			ids.append(str(item["ingredient_id"]))
	_set_visible(bowl_base_path, true)
	_set_visible(noodles_path, "noodles" in ids)
	_set_visible(beef_path, "raw_sliced_beef" in ids or "cooked_sliced_beef" in ids)
	_set_visible(broth_path, "broth" in ids)
	var ready := "noodles" in ids and "broth" in ids and ("raw_sliced_beef" in ids or "cooked_sliced_beef" in ids)
	_set_visible(garnish_path, ready)
	_set_visible(chopsticks_path, ready)

func reset_to_clean() -> void:
	apply_state([])

func _set_visible(path: NodePath, visible: bool) -> void:
	var node := get_node_or_null(path)
	if node is Node3D:
		node.visible = visible
