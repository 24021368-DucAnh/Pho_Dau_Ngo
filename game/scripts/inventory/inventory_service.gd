extends Node
class_name InventoryService

signal stock_changed(ingredient_id: StringName, amount: int)

@export var starting_stock: Dictionary = {
	&"broth": 3,
	&"noodles": 3,
	&"raw_sliced_beef": 3,
	&"cooked_sliced_beef": 3,
}

var _stock: Dictionary = {}


func _ready() -> void:
	_stock.clear()
	for raw_id in starting_stock.keys():
		_stock[StringName(raw_id)] = maxi(0, int(starting_stock[raw_id]))


func get_stock(ingredient_id: StringName) -> int:
	return int(_stock.get(StringName(ingredient_id), 0))


func can_consume(ingredient_id: StringName, amount: int = 1) -> bool:
	return amount > 0 and get_stock(ingredient_id) >= amount


func try_consume(ingredient_id: StringName, amount: int = 1) -> bool:
	if not can_consume(ingredient_id, amount):
		return false
	var normalized_id := StringName(ingredient_id)
	_stock[normalized_id] = get_stock(normalized_id) - amount
	stock_changed.emit(normalized_id, get_stock(normalized_id))
	return true


func add_stock(ingredient_id: StringName, amount: int = 1) -> bool:
	if amount <= 0:
		return false
	var normalized_id := StringName(ingredient_id)
	_stock[normalized_id] = get_stock(normalized_id) + amount
	stock_changed.emit(normalized_id, get_stock(normalized_id))
	return true


func snapshot() -> Dictionary:
	return _stock.duplicate(true)
