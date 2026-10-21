extends StaticBody3D
class_name InteractiveBowl

enum BowlState {
	AVAILABLE,
	HELD,
	PLACED,
}

var state: int = BowlState.AVAILABLE

@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0


func set_held() -> bool:
	if state == BowlState.HELD:
		return false

	state = BowlState.HELD
	collision_layer = 0
	collision_shape.set_deferred("disabled", true)
	return true


func try_place(target: Node) -> bool:
	if state != BowlState.HELD:
		return false
	if not target is PlacementZone:
		return false

	var zone: PlacementZone = target as PlacementZone
	global_transform = zone.get_placement_transform()
	state = BowlState.PLACED
	collision_layer = 2
	collision_mask = 0
	collision_shape.set_deferred("disabled", false)
	return true
