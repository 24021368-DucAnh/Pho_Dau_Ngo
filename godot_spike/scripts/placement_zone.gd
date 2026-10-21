extends Area3D
class_name PlacementZone

@onready var placement_marker: Marker3D = $PlacementMarker


func _ready() -> void:
	collision_mask = 0
	monitoring = true
	monitorable = true


func get_placement_transform() -> Transform3D:
	return placement_marker.global_transform
