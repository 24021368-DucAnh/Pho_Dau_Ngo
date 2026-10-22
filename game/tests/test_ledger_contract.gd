extends SceneTree

var failures := 0

func _initialize() -> void:
	call_deferred("_run")

func _run() -> void:
	var ledger := Ledger.new()
	root.add_child(ledger)
	await process_frame

	var opening := ledger.record_transaction(&"opening-day-01", &"day-01", &"opening_cash", 100000, &"day-start")
	_check(bool(opening.get("ok", false)), "valid opening cash is recorded")
	var sale := ledger.record_transaction(&"sale-order-01", &"day-01", &"sale_revenue", 45000, &"order-01")
	_check(bool(sale.get("ok", false)), "sale revenue is recorded")
	var purchase := ledger.record_transaction(&"purchase-01", &"day-01", &"ingredient_purchase", -12000, &"purchase-action-01")
	_check(bool(purchase.get("ok", false)), "ingredient purchase is recorded as a negative cash movement")

	var totals: Dictionary = ledger.get_day_totals(&"day-01")
	_check(int(totals.get("opening_cash", -1)) == 100000, "totals include opening cash")
	_check(int(totals.get("revenue", -1)) == 45000, "totals sum sale revenue")
	_check(int(totals.get("purchases", -1)) == 12000, "totals expose purchase spend as a positive reporting total")
	_check(int(totals.get("closing_cash", -1)) == 133000, "closing cash reconciles opening cash plus signed movements")

	var count_before_replay := ledger.get_transactions(&"day-01").size()
	var replay := ledger.record_transaction(&"sale-order-01", &"day-01", &"sale_revenue", 45000, &"order-01")
	_check(bool(replay.get("ok", false)), "same transaction payload is an idempotent replay")
	_check(ledger.get_transactions(&"day-01").size() == count_before_replay, "idempotent replay does not append another transaction")
	var conflicting_replay := ledger.record_transaction(&"sale-order-01", &"day-01", &"sale_revenue", 99999, &"order-01")
	_check(not bool(conflicting_replay.get("ok", false)), "same transaction ID with different payload is rejected")
	_check(int(ledger.get_day_totals(&"day-01").get("revenue", -1)) == 45000, "conflicting replay preserves original revenue")

	var detached: Dictionary = ledger.get_transaction(&"sale-order-01")
	detached["amount"] = 1
	_check(int(ledger.get_transaction(&"sale-order-01").get("amount", -1)) == 45000, "mutating returned transaction cannot mutate ledger state")

	var duplicate_opening := ledger.record_transaction(&"opening-day-01-duplicate", &"day-01", &"opening_cash", 200000, &"day-start-duplicate")
	_check(not bool(duplicate_opening.get("ok", false)), "a day cannot record opening cash twice")

	var close_first: Dictionary = ledger.close_day(&"day-01")
	_check(bool(close_first.get("ok", false)), "day can be closed")
	var closed_count := ledger.get_transactions(&"day-01").size()
	var close_second: Dictionary = ledger.close_day(&"day-01")
	_check(bool(close_second.get("ok", false)), "closing the same day twice is idempotent")
	_check(ledger.get_transactions(&"day-01").size() == closed_count, "repeated close does not append transactions")
	var after_close := ledger.record_transaction(&"sale-order-02", &"day-01", &"sale_revenue", 45000, &"order-02")
	_check(not bool(after_close.get("ok", false)), "closed day rejects new transactions")

	var invalid := ledger.record_transaction(&"bad-sign", &"day-02", &"ingredient_purchase", 12000, &"purchase-action-02")
	_check(not bool(invalid.get("ok", false)), "purchase with positive cash movement is rejected")
	_check(ledger.get_transactions(&"day-02").is_empty(), "rejected transaction leaves no ledger entry")

	var missing_opening: Dictionary = ledger.get_day_totals(&"day-03")
	_check(not bool(missing_opening.get("complete", true)), "day without opening cash is marked incomplete")

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
		print("LEDGER_CONTRACT_TESTS: PASS")
		quit(0)
	else:
		push_error("LEDGER_CONTRACT_TESTS: %d failure(s)" % failures)
		quit(1)
