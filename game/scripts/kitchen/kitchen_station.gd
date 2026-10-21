extends Area3D
class_name KitchenStation

@export var action_id: StringName = &"add_broth"
@export var ingredient_id: StringName = &"broth"
@export var station_label: String = "Nồi nước dùng"
@export_range(0.0, 30.0, 0.25) var blanch_duration_seconds: float = 1.0

var _blanch_started_msec: Dictionary = {}


func preview_action(
	bowl: InteractiveBowl,
	recipe: RecipeData,
	inventory: InventoryService
) -> Dictionary:
	if bowl == null or not is_instance_valid(bowl):
		return {"ok": false, "message": "Cần có bát trước khi thao tác."}
	if bowl.state != InteractiveBowl.BowlState.HELD:
		return {"ok": false, "message": "Cầm bát lên trước khi thao tác tại trạm."}
	if recipe == null or not recipe.is_valid_recipe():
		return {"ok": false, "message": "Công thức chưa hợp lệ."}
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

	if action_id == &"add_beef":
		if not is_finite(blanch_duration_seconds) or blanch_duration_seconds < 0.0:
			return {"ok": false, "message": "Thời gian trụng của trạm chưa hợp lệ."}
		var key := bowl.get_instance_id()
		if not _blanch_started_msec.has(key):
			return {
				"ok": true,
				"message": "E / Click: bắt đầu trụng thịt (%s giây)." % _format_seconds(recipe.blanch_duration_seconds),
				"step": step,
				"starts_blanch": true,
			}
		var elapsed := float(Time.get_ticks_msec() - int(_blanch_started_msec[key])) / 1000.0
		var required := recipe.blanch_duration_seconds
		if elapsed < required:
			return {
				"ok": false,
				"message": "Đang trụng thịt: còn %s giây." % _format_seconds(required - elapsed),
			}
		if elapsed > required + 2.0:
			return {
				"ok": false,
				"message": "Thịt đã trụng quá lâu; hủy bát này và làm lại.",
				"overcooked": true,
			}

	if not inventory.can_consume(ingredient_id, int(step.get("amount", 1))):
		return {
			"ok": false,
			"message": "Thiếu nguyên liệu: " + String(step.get("ingredient_label", ingredient_id)),
		}
	return {"ok": true, "message": "E / Click: " + String(step.get("label", station_label)), "step": step}


func apply_to_bowl(
	bowl: InteractiveBowl,
	recipe: RecipeData,
	inventory: InventoryService
) -> Dictionary:
	var preview := preview_action(bowl, recipe, inventory)
	if not bool(preview.get("ok", false)):
		if bool(preview.get("overcooked", false)):
			_blanch_started_msec.erase(bowl.get_instance_id())
			bowl.cancel_preparation()
		return preview

	if bool(preview.get("starts_blanch", false)):
		_blanch_started_msec[bowl.get_instance_id()] = Time.get_ticks_msec()
		return {
			"ok": true,
			"message": "Đã bắt đầu trụng thịt. Chờ đủ thời gian rồi tương tác lại.",
			"blanching": true,
		}

	var step: Dictionary = preview["step"]
	var amount := int(step.get("amount", 1))
	if not inventory.try_consume(ingredient_id, amount):
		return {"ok": false, "message": "Không đủ nguyên liệu; bát chưa thay đổi."}

	if not bowl.apply_recipe_step(action_id, recipe):
		inventory.add_stock(ingredient_id, amount)
		return {"ok": false, "message": "Không thể thực hiện bước này; nguyên liệu đã được hoàn lại."}

	if action_id == &"add_beef":
		_blanch_started_msec.erase(bowl.get_instance_id())

	if bowl.preparation_state == InteractiveBowl.PreparationState.READY_TO_SERVE:
		return {"ok": true, "message": "Đã hoàn thành " + recipe.display_name + ", sẵn sàng phục vụ."}
	return {"ok": true, "message": "Đã thực hiện: " + String(step.get("label", station_label)) + "."}


func _format_seconds(seconds: float) -> String:
	return "%.1f" % maxf(0.0, seconds)


static func blanch_duration_is_acceptable(actual_seconds: float, required_seconds: float, tolerance_seconds: float = 2.0) -> bool:
	return (
		is_finite(actual_seconds)
		and is_finite(required_seconds)
		and is_finite(tolerance_seconds)
		and actual_seconds >= required_seconds
		and actual_seconds <= required_seconds + tolerance_seconds
	)
