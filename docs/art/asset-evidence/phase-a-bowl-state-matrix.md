# Phase A — bowl state matrix (v003, staging)

> Update 2026-10-26 (PR #53): the staging matrix below is still accurate, but two "Known gaps" are now resolved (Godot screenshots taken; GLBs committed), and a gameplay-integration section is appended. The staging gaps are kept below as history with their resolutions noted.

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

## Known gaps at v003 (status 2026-10-26)

- ~~In-game Godot import screenshot has NOT been taken yet.~~ RESOLVED for the modular scene: the owner viewed the modular scene in Godot on 2026-10-25 00:39–00:41 (bowl upright, blue rim pattern visible, noodles filling the bowl, chili visible, chopsticks across the top, no missing-texture errors) and temporarily closed Phase A the same day at 00:52. Blender renders are still not a substitute for the Phase A gate — and first-person gameplay verification of the integrated visuals (next section) is still open.
- ~~The GLB files listed in the scene are binary and were NOT pushed through the GitHub connector in this PR.~~ RESOLVED: all 7 layer GLBs were committed to `game/assets/models/food/` via PR #44 (`main` `1e2541fa`, later merges) with Godot `.import`/`.uid` files. The connector binary limitation still applies to future binary pushes; it no longer blocks this scene.
- No `InteractiveBowl` gameplay node, collider, or recipe logic was changed by the original staging PR. That statement is superseded by the gameplay integration below, which adds a visuals-only sync and instances the scene under gameplay `Bowl` without changing any gameplay contract.

## Gameplay integration (PR #53, branch `phase-a/modular-bowl-gameplay`, base `main` `a9793d5`)

- Gameplay `Bowl` instances the modular scene as `BowlVisuals` with local offset Y −0.06 m, so the modular base sits on the 0.50 m tabletop. The old cylinder `MeshInstance3D` visual was removed.
- Unchanged: gameplay `Bowl` node position, `CollisionShape3D` (cylinder r 0.24 m, h 0.12 m), `PlacementZone`/marker, node names used by `player_controller`, and all recipe, inventory, Ledger and serving logic.
- Driver: `InteractiveBowl._sync_visuals()` pushes authoritative `consumed_ingredients` to `PhoBowlVisuals.apply_state()` after each successful recipe step and after a successful cancel. Bowls created from script alone have no `BowlVisuals` child, so the sync is a no-op there. Visuals never mutate gameplay state.
- The visibility matrix above applies unchanged in gameplay: pickup and placement do not change the state row; visuals follow the `Bowl` node transform (held: camera offset; placed: placement-marker snap).
- Evidence (headless, Godot 4.4.1 — NOT first-person acceptance): new test `game/tests/test_bowl_visuals_integration.gd` (`BOWL_VISUALS_TESTS: PASS`, covering clean state, rejected-step no-change, each step revealing exactly its layer, ready-state garnish + chopsticks, and cancel reset); all 5 pre-existing domain suites still PASS; editor import clean; headless scene run clean.
- Still open at integration time: first-person verification of layer switching, readability and held-bowl framing; visual height was 0.249 m vs collider height 0.12 m — resolved 2026-10-26 by rescaling to real size (BowlVisuals 0.44 → visual 0.22 × 0.11 m, collider r 0.11 m; chopsticks separately to 0.22 m), so visual and collider now match and the old depth decision is closed; v004 contrast pass sent but never re-tested in Godot; blue pattern still the simplified original, not intricate scrollwork; bowl source provenance/rights still unverified; formal Phase A acceptance still open (the 2026-10-25 temp-close is explicitly not final). This matrix is not an `integrated` or `QA` claim.
