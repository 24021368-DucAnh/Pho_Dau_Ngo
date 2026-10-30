extends Node
class_name CustomerDirector

signal customer_seated(customer_id: StringName, table_id: StringName, order_id: StringName)

var _tables: TableService
var _orders: OrderManager
var _scenario: CustomerScenario
var _next_index := 0
var _arrivals_open := false

func configure(tables: TableService, orders: OrderManager, scenario: Resource) -> Dictionary:
	if tables == null or orders == null or not scenario is CustomerScenario:
		return {"ok": false, "message": "Thiếu bàn, đơn hoặc kịch bản khách."}
	_tables = tables
	_orders = orders
	_scenario = scenario as CustomerScenario
	return {"ok": true}

func start_shift() -> void:
	_arrivals_open = true
	while _next_index < _scenario.recipes.size() and _tables.get_customer(TableService.TABLE_IDS[2]) == &"":
		if not bool(admit_next_customer().get("ok", false)):
			break

func stop_arrivals() -> void:
	_arrivals_open = false

func admit_next_customer() -> Dictionary:
	if not _arrivals_open:
		return {"ok": false, "message": "Ca không nhận thêm khách."}
	if _next_index >= _scenario.recipes.size():
		return {"ok": false, "message": "Hết khách trong kịch bản."}
	var number := _next_index + 1
	var customer_id := StringName("customer-%03d" % number)
	var order_id := StringName("order-%03d" % number)
	var reserved := _tables.reserve_table(customer_id)
	if not bool(reserved.get("ok", false)):
		return reserved
	var table_id: StringName = reserved["table_id"]
	var created := _orders.create_order(order_id, _scenario.recipes[_next_index], table_id)
	if not bool(created.get("ok", false)):
		_tables.release_table(table_id)
		return created
	_tables.assign_order(table_id, order_id)
	_next_index += 1
	customer_seated.emit(customer_id, table_id, order_id)
	return {"ok": true, "customer_id": customer_id, "table_id": table_id, "order_id": order_id}
