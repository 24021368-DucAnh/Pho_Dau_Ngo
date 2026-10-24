# Phase A — bowl state matrix (v003, staging)

Visuals-only scene: `game/scenes/art/food/pho_bowl_modular.tscn`
Script: `game/scripts/art/pho_bowl_visuals.gd`

The script never decides recipe validity and never mutates `InteractiveBowl`.
It only shows/hides visual children from the authoritative `consumed_ingredients`
array, after a successful step. Ingredient IDs are verified from
`game/scripts/kitchen/recipe_data.gd`: `noodles`, `raw_sliced_beef` /
`cooked_sliced_beef`, `broth`. No order is hard-coded in the script.

| State | BowlBase | NoodlesLayer | BeefLayer | BrothSurface | GarnishLayer | ChopsticksExtra |
|---|---|---|---|---|---|---|
| Clean (no ingredients) | visible | hidden | hidden | hidden | hidden | hidden |
| Noodles only | visible | visible | hidden | hidden | hidden | hidden |
| Noodles + beef | visible | visible | visible | hidden | hidden | hidden |
| Noodles + beef + broth (ready) | visible | visible | visible | visible | visible | visible |
| Rejected step | unchanged | unchanged | unchanged | unchanged | unchanged | unchanged |
| Cancel / reset | visible | hidden | hidden | hidden | hidden | hidden |

Garnish and chopsticks are presentation-only. They appear only at ready
state, are never a recipe step, and are never counted as consumed ingredients.
Chopsticks and lime were explicitly kept by the owner at the v002 checkpoint.

## v003 measurements (Blender, local staging, not yet in-game verified)

- Bowl (decimated runtime candidate): 60,215 tris, 4.9 MB GLB, 0.5 x 0.5 x 0.249 m.
  Full-resolution bowl: 501,793 tris, 41 MB GLB. Decimation did not change
  dimensions (within 0.06 mm).
- Noodles: 36 flat ribbon strands, 36,432 tris, 1.9 MB GLB.
- Broth: disc radius 0.19 m at Z 0.18 m, so noodles cover its edge.
- Beef: 4 oval slices with pale marbling streaks.
- Garnish: oval basil leaves, chopped herbs, 3 red chili rings, 1 lime slice.
- Bowl pattern: original procedural blue bands and 24 small motifs around
  the rim. This is NOT yet the intricate scroll pattern in the owner's
  reference photo; detailed pattern work is deferred by owner decision.
- Bowl depth: 0.249 m, about twice the current gameplay proxy height
  (0.12 m in `main.tscn`). Do NOT stretch the bowl to fit the proxy without
  owner approval. The owner chose to keep v003 as-is temporarily and return
  to details later.

## Known gaps at v003

- In-game Godot import screenshot has NOT been taken yet. Blender renders
  are not a substitute for the Phase A gate.
- The GLB files listed in the scene are binary and were NOT pushed through
  the GitHub connector in this PR, because the connector's file tools treat
  content as text and its snapshot push explicitly does not support binary
  contents. The text files in this PR (scene, script, this matrix) are
  complete, but the PR must NOT be merged until the GLB files are added
  by a route that preserves binary contents (GitHub web upload, or a local
  git push from a machine with push credentials), and the scene is verified
  in Godot.
- No `InteractiveBowl` gameplay node, collider, or recipe logic is changed
  by this PR.
