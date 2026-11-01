"""Make a separate lighter tea-glass GLB, retaining the ice and materials."""

import sys
from pathlib import Path

import bpy


source, output = (Path(value).resolve() for value in sys.argv[sys.argv.index("--") + 1 :])
if source == output or output.exists():
    raise SystemExit("Output must be new and distinct from source")

bpy.ops.object.select_all(action="SELECT")
bpy.ops.object.delete(use_global=False)
bpy.ops.import_scene.gltf(filepath=str(source))

before = sum(len(obj.data.polygons) for obj in bpy.data.objects if obj.type == "MESH")
for obj in bpy.data.objects:
    if obj.type != "MESH":
        continue
    name = obj.name.upper()
    ratio = 0.40 if "GLASS" in name else 0.60 if "TEA_LIQUID" in name else 1.0
    if ratio == 1.0:
        continue
    modifier = obj.modifiers.new("Tea glass game LOD", "DECIMATE")
    modifier.ratio = ratio
    modifier.use_collapse_triangulate = True
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=modifier.name)

after = sum(len(obj.data.polygons) for obj in bpy.data.objects if obj.type == "MESH")
output.parent.mkdir(parents=True, exist_ok=True)
bpy.ops.export_scene.gltf(filepath=str(output), export_format="GLB", export_normals=False)
print(f"TEA_CANDIDATE polygons {before} -> {after}; output={output}")
