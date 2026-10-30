extends Area3D
class_name PaymentZone

@export var table_id: StringName = &""

func _ready() -> void:
	collision_layer = 0
	collision_mask = 0
