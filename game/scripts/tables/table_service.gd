extends Node
class_name TableService

signal table_changed(table_id: StringName, customer_id: StringName)

const TABLE_IDS: Array[StringName] = [&"table-1", &"table-2", &"table-3"]
var _occupants: Dictionary = {}
var _order_ids: Dictionary = {}

func reserve_table(customer_id: StringName) -> Dictionary:
	if customer_id == &"":
		return {"ok": false, "message": "Mã khách không được để trống."}
	if _occupants.values().has(customer_id):
		return {"ok": false, "message": "Khách đã có bàn."}
	for table_id in TABLE_IDS:
		if not _occupants.has(table_id):
			_occupants[table_id] = customer_id
			table_changed.emit(table_id, customer_id)
			return {"ok": true, "table_id": table_id}
	return {"ok": false, "message": "Ba bàn đều đã có khách."}

func assign_order(table_id: StringName, order_id: StringName) -> Dictionary:
	if not _occupants.has(table_id) or _order_ids.has(table_id):
		return {"ok": false, "message": "Bàn không có khách hoặc đã có đơn."}
	_order_ids[table_id] = order_id
	return {"ok": true}

func release_table(table_id: StringName) -> Dictionary:
	if not _occupants.has(table_id):
		return {"ok": false, "message": "Bàn đang trống."}
	_occupants.erase(table_id)
	_order_ids.erase(table_id)
	table_changed.emit(table_id, &"")
	return {"ok": true}

func can_deliver(table_id: StringName, order_id: StringName) -> bool:
	return _occupants.has(table_id) and _order_ids.get(table_id, &"") == order_id

func get_customer(table_id: StringName) -> StringName:
	return StringName(_occupants.get(table_id, &""))
