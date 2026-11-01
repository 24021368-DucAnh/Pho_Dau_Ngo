"""Create a separate, conservative GLB candidate; never overwrite the source.

Usage (Blender background): blender -b --python this_file -- source.glb output.glb
"""

import sys
from pathlib import Path

import bpy


args = sys.argv[sys.argv.index("--") + 1 :]
source, output = (Path(value).resolve() for value in args[:2])
ratio = float(args[2]) if len(args) > 2 else 0.45
export_normals = len(args) > 3 and args[3].lower() == "normals"
if not 0.1 <= ratio <= 1.0:
    raise SystemExit("Ratio must be between 0.1 and 1.0")
if source == output or output.exists():
    raise SystemExit("Output must be a new path, distinct from source")

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
bpy.ops.import_scene.gltf(filepath=str(source))

before = 0
for obj in list(bpy.data.objects):
    if obj.type != "MESH":
        continue
    faces = len(obj.data.polygons)
    before += faces
    # Transparent jars/liquids, and small silhouette parts retain their shape.
    transparent = any(material and material.surface_render_method != "DITHERED"
                      for material in obj.data.materials)
    if faces < 1500 or transparent:
        continue
    modifier = obj.modifiers.new("Game LOD candidate", "DECIMATE")
    modifier.ratio = ratio
    modifier.use_collapse_triangulate = True
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=modifier.name)

after = sum(len(obj.data.polygons) for obj in bpy.data.objects if obj.type == "MESH")
output.parent.mkdir(parents=True, exist_ok=True)
bpy.ops.export_scene.gltf(
    filepath=str(output),
    export_format="GLB",
    export_apply=False,
    export_normals=export_normals,
)
print(f"CANDIDATE {source.name}: polygons {before} -> {after}; output={output}")
