extends Node
class_name TrayController

signal slots_changed(slots: Array)

var _slots: Array[StringName] = [&"", &""]
var _carried := false

func begin_carry() -> Dictionary:
	if _carried:
		return {"ok": false, "message": "Khay đang được bưng."}
	_carried = true
	return {"ok": true}

func end_carry() -> Dictionary:
	if not _carried:
		return {"ok": false, "message": "Khay không được bưng."}
	_carried = false
	return {"ok": true}

func is_carried() -> bool:
	return _carried

func try_insert(bowl_id: StringName, slot_index: int) -> Dictionary:
	if slot_index < 0 or slot_index >= _slots.size():
		return {"ok": false, "message": "Vị trí khay không hợp lệ."}
	if bowl_id == &"" or _slots.has(bowl_id):
		return {"ok": false, "message": "Bát thiếu mã hoặc đã ở trên khay."}
	if _slots[slot_index] != &"":
		return {"ok": false, "message": "Vị trí khay đã có bát."}
	_slots[slot_index] = bowl_id
	slots_changed.emit(get_slots())
	return {"ok": true}

func try_remove(slot_index: int) -> Dictionary:
	if slot_index < 0 or slot_index >= _slots.size() or _slots[slot_index] == &"":
		return {"ok": false, "message": "Vị trí khay trống hoặc không hợp lệ."}
	var bowl_id := _slots[slot_index]
	_slots[slot_index] = &""
	slots_changed.emit(get_slots())
	return {"ok": true, "bowl_id": bowl_id}

func get_slots() -> Array:
	return _slots.duplicate()

func find_bowl(bowl_id: StringName) -> int:
	return _slots.find(bowl_id)
