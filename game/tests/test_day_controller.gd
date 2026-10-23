extends SceneTree

var failures := 0


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var ledger := Ledger.new()
	root.add_child(ledger)
	var inventory := InventoryService.new()
	root.add_child(inventory)
	var controller := DayController.new()
	root.add_child(controller)
	await process_frame

	_check(bool(controller.configure(ledger, inventory).get("ok", false)), "controller accepts valid Ledger and Inventory services")
	_check(not bool(controller.start_day(&"day-controller-01", 0).get("ok", false)), "day cannot start with zero opening cash")
	_check(ledger.get_transactions(&"day-controller-01").is_empty(), "invalid start does not write an opening transaction")

	var started: Dictionary = controller.start_day(&"day-controller-01", 100000)
	_check(bool(started.get("ok", false)), "day starts with explicit opening cash")
	_check(int(ledger.get_day_totals(&"day-controller-01").get("opening_cash", -1)) == 100000, "opening cash comes from the caller, not a hard-coded balance")
	_check(not bool(controller.start_day(&"day-controller-02", 200000).get("ok", false)), "controller rejects a second active day")

	var sale: Dictionary = ledger.record_transaction(&"sale:day-controller-order-01", &"day-controller-01", &"sale_revenue", 45000, &"order-01")
	_check(bool(sale.get("ok", false)), "ledger records sale during the active day")

	var closed: Dictionary = controller.close_day()
	_check(bool(closed.get("ok", false)), "active day closes successfully")
	var summary: Dictionary = closed.get("summary", {})
	_check(bool(summary.get("complete", false)), "summary marks a day with opening cash complete")
	_check(bool(summary.get("closed", false)), "summary reports the closed state")
	_check(int(summary.get("revenue", -1)) == 45000, "summary revenue is derived from Ledger")
	_check(int(summary.get("closing_cash", -1)) == 145000, "summary closing cash reconciles opening cash and revenue")
	_check(summary.get("inventory_snapshot", {}) == inventory.snapshot(), "summary includes a read-only inventory snapshot")
	_check(int(summary.get("transaction_count", -1)) == 2, "summary counts opening and sale transactions without posting a close transaction")

	var summary_inventory: Dictionary = summary.get("inventory_snapshot", {})
	summary_inventory[&"noodles"] = 999
	var repeated_close: Dictionary = controller.close_day()
	_check(bool(repeated_close.get("ok", false)), "repeated close returns the stored summary")
	_check(bool(repeated_close.get("already_closed", false)), "repeated close is identified as idempotent")
	_check(int(repeated_close.get("summary", {}).get("inventory_snapshot", {}).get(&"noodles", -1)) == inventory.get_stock(&"noodles"), "mutating a returned summary cannot mutate the stored snapshot")
	_check(not bool(controller.start_day(&"day-controller-01", 100000).get("ok", false)), "a closed day cannot be reopened")

	controller.queue_free()
	inventory.queue_free()
	ledger.queue_free()
	await process_frame
	_finish()


func _check(condition: bool, message: String) -> void:
	if condition:
		print("PASS: " + message)
	else:
		failures += 1
		push_error("FAIL: " + message)


func _finish() -> void:
	if failures == 0:
		print("DAY_CONTROLLER_TESTS: PASS")
		quit(0)
	else:
		push_error("DAY_CONTROLLER_TESTS: %d failure(s)" % failures)
		quit(1)
