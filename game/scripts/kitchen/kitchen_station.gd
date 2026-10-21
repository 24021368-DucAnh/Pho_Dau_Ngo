extends Area3D
class_name KitchenStation

@export var action_id: StringName = &"add_broth"
@export var ingredient_id: StringName = &"broth"
@export var station_label: String = "Nồi nước dùng"


func preview_action(
	bowl: InteractiveBowl,
	recipe: RecipeData,
	inventory: InventoryService
) -> Dictionary:
	if bowl == null or not is_instance_valid(bowl):
		return {"ok": false, "message": "Cần có bát trước khi thao tác."}
	if bowl.state != InteractiveBowl.BowlState.HELD:
		return {"ok": false, "message": "Cầm bát lên trước khi thao tác tại trạm."}
	if recipe == null:
		return {"ok": false, "message": "Chưa có dữ liệu công thức."}
	if inventory == null or not is_instance_valid(inventory):
		return {"ok": false, "message": "Kho nguyên liệu chưa sẵn sàng."}

	var step: Dictionary = recipe.step_at(bowl.recipe_step_index)
	if step.is_empty():
		return {"ok": false, "message": "Bát đã hoàn thành, sẵn sàng phục vụ."}

	var expected_action := StringName(step.get("action_id", &""))
	if action_id != expected_action:
		return {
			"ok": false,
			"message": "Bước tiếp theo: " + String(step.get("label", "tiếp tục công thức")),
		}

	var expected_ingredient := StringName(step.get("ingredient_id", &""))
	if ingredient_id != expected_ingredient:
		return {"ok": false, "message": "Trạm chưa được cấu hình đúng nguyên liệu."}

	var amount := int(step.get("amount", 1))
	if not inventory.can_consume(ingredient_id, amount):
		return {
			"ok": false,
			"message": "Thiếu nguyên liệu: " + String(step.get("ingredient_label", ingredient_id)),
		}

	return {
		"ok": true,
		"message": "E / Click: " + String(step.get("label", station_label)),
		"step": step,
	}


func apply_to_bowl(
	bowl: InteractiveBowl,
	recipe: RecipeData,
	inventory: InventoryService
) -> Dictionary:
	var preview := preview_action(bowl, recipe, inventory)
	if not bool(preview.get("ok", false)):
		return preview

	var step: Dictionary = preview["step"]
	var amount := int(step.get("amount", 1))
	if not inventory.try_consume(ingredient_id, amount):
		return {"ok": false, "message": "Không đủ nguyên liệu; bát chưa thay đổi."}

	if not bowl.apply_recipe_step(action_id, recipe):
		# Defensive rollback: a failed state transition must not consume stock.
		inventory.add_stock(ingredient_id, amount)
		return {"ok": false, "message": "Không thể thực hiện bước này; nguyên liệu đã được hoàn lại."}

	if bowl.preparation_state == InteractiveBowl.PreparationState.READY_TO_SERVE:
		return {
			"ok": true,
			"message": "Đã hoàn thành " + recipe.display_name + ", sẵn sàng phục vụ.",
		}
	return {"ok": true, "message": "Đã thực hiện: " + String(step.get("label", station_label)) + "."}
