extends SceneTree

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var ledger := Ledger.new()
	var inventory := InventoryService.new()
	var day := DayController.new()
	var orders := OrderManager.new()
	var serving := ServingService.new()
	var shift := ShiftCoordinator.new()
	for service in [ledger, inventory, day, orders, serving, shift]:
		root.add_child(service)
	await process_frame
	_check(bool(day.configure(ledger, inventory).get("ok", false)), "day configured")
	_check(bool(shift.configure(orders, serving, day, inventory).get("ok", false)), "shift configured")
	_check(bool(shift.open_shift(&"day-01", 100000).get("ok", false)), "shift opens")
	_check(shift.can_accept_arrivals(), "open shift accepts arrivals")
	_check(not bool(shift.open_shift(&"day-01", 100000).get("ok", false)), "shift cannot open twice")
	_check(bool(orders.create_order(&"order-001", &"pho-bo-tai", &"table-1").get("ok", false)), "open order created")
	var close_request := shift.request_close()
	_check(bool(close_request.get("ok", false)) and int(close_request.get("outstanding_orders", -1)) == 1, "close request reports open order")
	_check(not shift.can_accept_arrivals(), "closing shift stops arrivals")
	_check(bool(shift.finish_close().get("ok", false)), "shift closes")
	var repeated := shift.finish_close()
	_check(bool(repeated.get("ok", false)) and bool(repeated.get("already_closed", false)), "close replay is idempotent")
	_check(ledger.get_transactions(&"day-01").size() == 1, "close replay does not add ledger entries")
	for service in [ledger, inventory, day, orders, serving, shift]:
		service.queue_free()
	print("SHIFT_COORDINATOR_TESTS: %s" % ("PASS" if failures == 0 else "FAIL"))
	quit(0 if failures == 0 else 1)


func _check(condition: bool, description: String) -> void:
	if not condition:
		failures += 1
		push_error(description)
