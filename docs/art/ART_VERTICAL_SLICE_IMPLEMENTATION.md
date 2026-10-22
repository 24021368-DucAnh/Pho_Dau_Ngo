# Stylized 3D Art Slice — Implementation v0.1

**Direction:** owner-approved Stylized 3D; production priority balances quality and delivery speed.  
**Scope:** a runtime-built, dependency-free art slice that can be opened in Godot 4.4.1 without downloading models or textures.

## Run it

1. Open `game/project.godot` in Godot 4.4.1 Standard.
2. In the FileSystem dock, open `res://scenes/stylized_vertical_slice.tscn`.
3. Press **F6** to run the current scene. F5 still launches the production gameplay scene, `res://scenes/main.tscn`.

## What is in this pass

- Warm morning lighting, soft directional shadows, and a restrained ambient fill.
- Hanoi alley massing: limewashed walls, concrete ground, selective repair patches and a drain channel.
- Enamel-green pho cart with timber rails, steel worktop, lower shelf and wheels.
- Aged aluminum stock pot with a dull finish, rolled rim, worn bands, side handles, offset lid and subtle steam; amber broth, noodle basin, beef tray, bowl of pho, herb jar and red plastic stools.
- A fictional shuttered shopfront and restrained red/cream awning.
- All geometry and materials are generated from built-in Godot primitive meshes in `scripts/art/stylized_vertical_slice.gd`; no external art dependencies.

## Intentional limitations

This is an **art/runtime slice**, not a replacement for the playable first-person production scene. The existing gameplay scene remains the F5 entry point while art direction is evaluated independently. Current props are deliberately low-poly proxies. The stock pot is a first art pass made from built-in meshes; its final silhouette, steam readability and material response still need review in the Godot runtime before it is marked approved or integrated into `main.tscn`.

## Acceptance checks

- Godot editor import/parse succeeds.
- The scene opens and renders from its showcase camera.
- No external asset dependencies are required.
- Visual acceptance still requires an actual Godot runtime screenshot and owner review; CI import alone does not prove visual quality or camera composition.
