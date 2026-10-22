class_name Ledger
extends Node

const TYPE_OPENING_CASH: StringName = &"opening_cash"
const TYPE_SALE_REVENUE: StringName = &"sale_revenue"
const TYPE_INGREDIENT_PURCHASE: StringName = &"ingredient_purchase"

var _transactions_by_id: Dictionary = {}
var _transaction_ids_by_day: Dictionary = {}
var _closed_days: Dictionary = {}
var _opening_transaction_by_day: Dictionary = {}

func record_transaction(
	transaction_id: StringName,
	day_id: StringName,
	transaction_type: StringName,
	amount: int,
	reference_id: StringName
) -> Dictionary:
	if transaction_id.is_empty() or day_id.is_empty() or reference_id.is_empty():
		return _failure("transaction_id, day_id and reference_id are required")

	var payload := {
		"transaction_id": transaction_id,
		"day_id": day_id,
		"type": transaction_type,
		"amount": amount,
		"reference_id": reference_id
	}

	# Idempotent retries are checked before the day-closed guard: retrying a
	# transaction already accepted must not create a second movement.
	if _transactions_by_id.has(transaction_id):
		var existing: Dictionary = _transactions_by_id[transaction_id]
		if existing == payload:
			return {"ok": true, "replayed": true, "transaction": existing.duplicate(true)}
		return _failure("transaction_id already exists with a different payload")

	if _closed_days.has(day_id):
		return _failure("day is closed")
	if amount == 0:
		return _failure("transaction amount must not be zero")

	match transaction_type:
		TYPE_OPENING_CASH:
			if amount < 0:
				return _failure("opening cash must be positive")
			if _opening_transaction_by_day.has(day_id):
				return _failure("opening cash already recorded for this day")
		TYPE_SALE_REVENUE:
			if amount < 0:
				return _failure("sale revenue must be a positive cash movement")
		TYPE_INGREDIENT_PURCHASE:
			if amount > 0:
				return _failure("ingredient purchase must be a negative cash movement")
		_:
			return _failure("unsupported transaction type")

	_transactions_by_id[transaction_id] = payload.duplicate(true)
	if not _transaction_ids_by_day.has(day_id):
		_transaction_ids_by_day[day_id] = []
	var day_ids: Array = _transaction_ids_by_day[day_id]
	day_ids.append(transaction_id)
	_transaction_ids_by_day[day_id] = day_ids
	if transaction_type == TYPE_OPENING_CASH:
		_opening_transaction_by_day[day_id] = transaction_id

	return {"ok": true, "replayed": false, "transaction": payload.duplicate(true)}

func get_transaction(transaction_id: StringName) -> Dictionary:
	if not _transactions_by_id.has(transaction_id):
		return {}
	return (_transactions_by_id[transaction_id] as Dictionary).duplicate(true)

func get_transactions(day_id: StringName) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	var day_ids: Array = _transaction_ids_by_day.get(day_id, [])
	for transaction_id in day_ids:
		result.append((_transactions_by_id[transaction_id] as Dictionary).duplicate(true))
	return result

func get_day_totals(day_id: StringName) -> Dictionary:
	var transactions := get_transactions(day_id)
	var has_opening := _opening_transaction_by_day.has(day_id)
	var opening_cash := 0
	var revenue := 0
	var purchases := 0
	var signed_movements := 0

	for transaction in transactions:
		var transaction_type: StringName = transaction["type"]
		var amount: int = transaction["amount"]
		match transaction_type:
			TYPE_OPENING_CASH:
				opening_cash = amount
			TYPE_SALE_REVENUE:
				revenue += amount
				signed_movements += amount
			TYPE_INGREDIENT_PURCHASE:
				purchases += abs(amount)
				signed_movements += amount

	return {
		"day_id": day_id,
		"complete": has_opening,
		"closed": _closed_days.has(day_id),
		"opening_cash": opening_cash,
		"revenue": revenue,
		"purchases": purchases,
		"closing_cash": opening_cash + signed_movements if has_opening else signed_movements,
		"transaction_count": transactions.size()
	}

func close_day(day_id: StringName) -> Dictionary:
	if day_id.is_empty():
		return _failure("day_id is required")
	if not _opening_transaction_by_day.has(day_id):
		return _failure("cannot close a day without opening cash")
	if _closed_days.has(day_id):
		return {"ok": true, "already_closed": true, "totals": get_day_totals(day_id)}
	_closed_days[day_id] = true
	return {"ok": true, "already_closed": false, "totals": get_day_totals(day_id)}

func _failure(reason: String) -> Dictionary:
	return {"ok": false, "reason": reason}
