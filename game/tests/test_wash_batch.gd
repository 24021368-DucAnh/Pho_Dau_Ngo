extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var service := WashBatchService.new()
	root.add_child(service)
	var bowls: Array[InteractiveBowl] = []
	for index in 4:
		var bowl := InteractiveBowl.new()
		bowl.bowl_id = StringName("wash-%d" % index)
		var collision := CollisionShape3D.new()
		collision.name = "CollisionShape3D"
		collision.shape = CylinderShape3D.new()
		bowl.add_child(collision)
		root.add_child(bowl)
		bowls.append(bowl)
	await process_frame
	service.configure(bowls)
	service.rack_capacity = 3
	_check(not service.enqueue(&"missing").ok, "unknown bowl rejected")
	_check(not service.enqueue(bowls[3].bowl_id).ok, "clean bowl rejected")
	bowls[3].preparation_state = InteractiveBowl.PreparationState.IN_PROGRESS
	bowls[3].set_held()
	_check(not service.enqueue(bowls[3].bowl_id).ok, "cooking bowl rejected")
	bowls[3].preparation_state = InteractiveBowl.PreparationState.DIRTY
	bowls[3].in_service = true
	_check(not service.enqueue(bowls[3].bowl_id).ok, "in-service bowl rejected")
	bowls[3].in_service = false
	for index in 3:
		bowls[index].preparation_state = InteractiveBowl.PreparationState.DIRTY
		bowls[index].set_held()
		_check(service.enqueue(bowls[index].bowl_id).ok, "dirty bowl queued")
	_check(not service.enqueue(bowls[0].bowl_id).ok, "duplicate rejected")
	_check(not service.enqueue(bowls[3].bowl_id).ok, "full rack rejects dirty bowl")
	_check(bowls[3].state == InteractiveBowl.BowlState.HELD, "full rack preserves bowl")
	_check(service.start_batch().ok, "batch started")
	_check(not service.start_batch().ok, "batch cannot restart")
	paused = true
	service._process(10.0)
	_check(service.get_state().washing_count == 3, "pause freezes wash")
	paused = false
	service._process(6.1)
	_check(service.get_state().clean_count == 3, "three bowls clean once")
	for index in 3:
		_check(bowls[index].preparation_state == InteractiveBowl.PreparationState.CLEAN, "washed bowl clean")
	_check(not service.start_batch().ok, "empty batch rejected")
	_check(service.take_clean(bowls[0].bowl_id), "clean bowl leaves rack inventory")
	_check(not service.take_clean(bowls[0].bowl_id), "clean bowl cannot be taken twice")
	for bowl in bowls:
		bowl.queue_free()
	service.queue_free()
	print("WASH_BATCH_TESTS: %s" % ("PASS" if failures == 0 else "FAIL"))
	quit(0 if failures == 0 else 1)

func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
