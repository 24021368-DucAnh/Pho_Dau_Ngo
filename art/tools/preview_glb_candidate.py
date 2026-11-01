"""Render a shape preview from the same fixed view for GLB comparison."""

import sys
from pathlib import Path

import bpy
from mathutils import Vector

args = sys.argv[sys.argv.index("--") + 1 :]
source, output = (Path(value).resolve() for value in args[:2])
reverse = len(args) > 2 and args[2] == "reverse"
bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
bpy.ops.import_scene.gltf(filepath=str(source))

scene = bpy.context.scene
scene.render.engine = "BLENDER_WORKBENCH"
scene.render.resolution_x = 512
scene.render.resolution_y = 512
scene.render.resolution_percentage = 100
scene.render.film_transparent = True
scene.display.shading.light = "STUDIO"
scene.display.shading.color_type = "MATERIAL"
scene.display.shading.show_shadows = True

camera_data = bpy.data.cameras.new("Comparison camera")
camera = bpy.data.objects.new("Comparison camera", camera_data)
scene.collection.objects.link(camera)
scene.camera = camera
camera_data.type = "ORTHO"
points = [obj.matrix_world @ Vector(corner) for obj in bpy.data.objects
          if obj.type == "MESH" for corner in obj.bound_box]
minimum = Vector(tuple(min(point[i] for point in points) for i in range(3)))
maximum = Vector(tuple(max(point[i] for point in points) for i in range(3)))
target = (minimum + maximum) * 0.5
extent = max(maximum[i] - minimum[i] for i in range(3))
camera_data.ortho_scale = extent * 1.65
camera.location = target + Vector((extent * 1.3, extent * 1.0, extent * (-1.7 if reverse else 1.7)))
camera.rotation_euler = (target - camera.location).to_track_quat("-Z", "Y").to_euler()

output.parent.mkdir(parents=True, exist_ok=True)
scene.render.filepath = str(output)
bpy.ops.render.render(write_still=True)
