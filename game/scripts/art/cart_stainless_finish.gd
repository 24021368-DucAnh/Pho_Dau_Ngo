extends Node3D

const STAINLESS_LIGHT := Color("#aeb7bb")
const STAINLESS_DARK := Color("#626b70")


func _ready() -> void:
	_apply_stainless_finish(self)


func _apply_stainless_finish(node: Node) -> void:
	if node is MeshInstance3D:
		var mesh_instance := node as MeshInstance3D
		if mesh_instance.mesh != null:
			for surface_index in range(mesh_instance.mesh.get_surface_count()):
				var source := mesh_instance.get_active_material(surface_index)
				if not source is StandardMaterial3D:
					continue
				var source_material := source as StandardMaterial3D
				var material_name := String(source_material.resource_name)
				if material_name != "Inox" and material_name != "InoxDark":
					continue
				var finish := source_material.duplicate() as StandardMaterial3D
				finish.albedo_color = STAINLESS_LIGHT if material_name == "Inox" else STAINLESS_DARK
				finish.metallic = 0.82 if material_name == "Inox" else 0.72
				finish.roughness = 0.27 if material_name == "Inox" else 0.38
				mesh_instance.set_surface_override_material(surface_index, finish)
	for child in node.get_children():
		_apply_stainless_finish(child)
