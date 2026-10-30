extends Node
class_name WashBatchService

signal wash_started(bowl_ids: Array)
signal wash_finished(bowl_ids: Array)

@export var rack_capacity := 4
@export var batch_seconds := 6.0

var _bowls: Dictionary = {}
var _queued: Array[StringName] = []
var _washing: Array[StringName] = []
var _clean: Array[StringName] = []
var _remaining := 0.0

func configure(bowls: Array[InteractiveBowl]) -> void:
	_bowls.clear()
	for bowl in bowls:
		_bowls[bowl.bowl_id] = bowl

func enqueue(bowl_id: StringName) -> Dictionary:
	if not _bowls.has(bowl_id):
		return {"ok": false, "message": "Không tìm thấy bát."}
	if _queued.has(bowl_id) or _washing.has(bowl_id) or _clean.has(bowl_id):
		return {"ok": false, "message": "Bát đã ở giá rửa."}
	if _queued.size() + _washing.size() + _clean.size() >= rack_capacity:
		return {"ok": false, "message": "Giá rửa đã đầy."}
	var bowl := _bowls[bowl_id] as InteractiveBowl
	if bowl.in_service or bowl.state != InteractiveBowl.BowlState.HELD or not bowl.is_dirty():
		return {"ok": false, "message": "Chỉ đặt bát bẩn đang cầm lên giá."}
	if not bowl.put_in_rack():
		return {"ok": false, "message": "Không đặt được bát lên giá."}
	_queued.append(bowl_id)
	return {"ok": true, "message": "Đã đặt bát bẩn lên giá (%d/%d)." % [_queued.size(), rack_capacity]}

func start_batch() -> Dictionary:
	if not _washing.is_empty():
		return {"ok": false, "message": "Mẻ rửa đang chạy."}
	if _queued.is_empty():
		return {"ok": false, "message": "Giá chưa có bát bẩn."}
	_washing = _queued.duplicate()
	_queued.clear()
	_remaining = batch_seconds
	wash_started.emit(_washing.duplicate())
	return {"ok": true, "message": "Đã bắt đầu rửa %d bát." % _washing.size()}

func _process(delta: float) -> void:
	if get_tree().paused or _washing.is_empty():
		return
	_remaining -= delta
	if _remaining > 0.0:
		return
	var finished := _washing.duplicate()
	for bowl_id in finished:
		var bowl := _bowls[bowl_id] as InteractiveBowl
		if bowl.wash_after_batch():
			_clean.append(bowl_id)
	_washing.clear()
	_remaining = 0.0
	wash_finished.emit(finished)

func take_clean(bowl_id: StringName) -> bool:
	if not _clean.has(bowl_id):
		return false
	_clean.erase(bowl_id)
	return true

func get_state() -> Dictionary:
	return {"queued_count": _queued.size(), "washing_count": _washing.size(), "clean_count": _clean.size(), "remaining": _remaining}
