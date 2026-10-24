# Phase A Baseline — Tripo Modular Art Pipeline

**Baseline commit inspected:** `55fc09d28cf23b8828ee1ec09cfc04f083378c77` (main, 2026-10-24)  
**Purpose:** Record the current production contracts before introducing any modular food visuals.  
**Execution status:** Source inspection completed. This record does not claim a local Godot run or manual runtime validation.

## 1. Project and scene ownership

- Production project: `game/project.godot`
- Engine version declared in project features: Godot 4.4; `game/README.md` and `.github/workflows/godot-production.yml` specify Godot 4.4.1 Standard.
- Production entry scene: `game/scenes/main.tscn`
- Art showcase scene: `game/scenes/stylized_vertical_slice.tscn`
- Art showcase script: `game/scripts/art/stylized_vertical_slice.gd`
- Production bowl node: `Bowl` in `game/scenes/main.tscn`, scripted by `res://scripts/interactive_bowl.gd`.
- The production bowl is currently a `StaticBody3D` with a `CylinderMesh` visual and a `CylinderShape3D` collider. Its visual and collision are separate children.
- The stylized art showcase is a separate scene/script and currently builds its food/cart visuals from primitive meshes. Do not replace the production entry scene or change its gameplay ownership as part of the art showcase.

## 2. Authoritative bowl contract

Source: `game/scripts/interactive_bowl.gd`

- Bowl ownership states: `AVAILABLE`, `HELD`, `PLACED`.
- Preparation states: `CLEAN`, `IN_PROGRESS`, `READY_TO_SERVE`, `DIRTY`.
- Authoritative preparation fields: `preparation_state`, `recipe_step_index`, `prepared_recipe_id`, and `consumed_ingredients`.
- `apply_recipe_step(action, recipe)` returns false for an invalid step without mutating the recipe progress; on success it appends the consumed ingredient, increments `recipe_step_index`, and sets `IN_PROGRESS` or `READY_TO_SERVE`.
- `cancel_preparation()` is valid only for a held bowl in `IN_PROGRESS`; success returns the consumed ingredients as waste and resets step index, recipe identity, consumed ingredients, and preparation state to `CLEAN`.
- `set_held()` disables the existing collision shape deferred and sets collision layer to 0. `try_place()` restores placement and collision state. Keep the original root, collision child, and ownership transitions intact.

## 3. Recipe transition contract (verified from source)

Sources: `game/scripts/kitchen/kitchen_station.gd`, `game/scripts/kitchen/recipe_data.gd`, `game/data/recipes/pho_bo.tres`, `game/data/recipes/pho_bo_chin.tres`, and `game/tests/test_recipe_validation.gd`.

- `KitchenStation.apply_to_bowl()` calls `preview_action()`, checks inventory, consumes stock, calls `bowl.apply_recipe_step()`, and refunds stock if that call fails.
- The current `RecipeData` implementation and `test_recipe_validation.gd` define the active sequence as **noodles → beef → broth**, with the beef ingredient/action differing by variant (raw sliced beef for phở tái; cooked sliced beef for phở chín). This is a source-code baseline, not a claim that the order matches the physical serving sequence.
- The current gameplay recipes do not contain a garnish step. Garnish may be a presentation layer, but must not be represented as an authoritative consumed ingredient or an extra recipe action without a separate approved gameplay change.
- Consequently, visuals must derive from successful authoritative state/ingredient IDs, not from a hard-coded assumed visual order. The code currently adds noodles before broth; visual rendering must not duplicate recipe validation or treat garnish as consumed.

## 4. Relevant automated test files and exact CI commands

CI workflow: `.github/workflows/godot-production.yml`

It installs Godot 4.4.1 Standard and executes the following commands:

```bash
godot --headless --editor --path game --quit
(cd game && godot --headless --path . --script res://tests/test_ledger_contract.gd)
(cd game && godot --headless --path . --script res://tests/test_day_controller.gd)
(cd game && timeout --signal=TERM --kill-after=10s 120s godot --headless --path . --script res://tests/test_interaction_contract.gd)
(cd game && godot --headless --path . --script res://tests/test_recipe_validation.gd)
(cd game && godot --headless --path . --script res://tests/test_order_lifecycle.gd)
(cd game && godot --headless --path . --export-debug "Linux/X11" build/pho-dau-ngo.x86_64)
(cd game && godot --headless --path . --export-debug "Windows Desktop" build/pho-dau-ngo.exe)
```

Relevant existing regression coverage:
- `game/tests/test_interaction_contract.gd`: production scene, bowl root, collision, placement, ownership, station proxies and first-person interaction contracts.
- `game/tests/test_recipe_validation.gd`: recipe validity/order, inventory conservation, rejected steps, recipe locking, and cancellation/waste behavior.
- The workflow also runs ledger, day-controller and order/serving tests. All must remain green after art integration.

## 5. Current art constraints

Sources: `docs/art/VISUAL_BIBLE.md`, `docs/art/ASSET_REGISTER.md`, and `game/scripts/art/stylized_vertical_slice.gd`.

- Style: grounded stylized realism; food, bowl and valid interaction targets must be legible from the first-person camera.
- Palette/materials remain provisional. Inox should have broad soft highlights, not mirror chrome; ceramic/enamel should have a clear silhouette and controlled gloss.
- The showcase uses primitive meshes intentionally; the production scene has a distinct graybox bowl. The modular bowl should first be validated in an isolated art scene, then integrated as a visual child only after its node/transform contract is proven.
- The bowl's render layers must not introduce new collision shapes, physics targets, or interaction areas.
- Required manual checks: bowl/rim readability, broth line, ingredient clipping, transform stability while held/placed, and actual first-person scale.

## 6. Baseline execution and evidence limitations

- **Source inspection:** completed for the files listed above.
- **Local Godot tests/import/export:** not run from this connected GitHub inspection environment; do not mark them as passed based on this document.
- **Latest CI result:** not recorded here because the workflow-run lookup available during this step did not return a run. Verify the latest run directly before using it as a regression baseline.
- **Manual runtime screenshots:** not captured. Must be produced during Phase A acceptance on the actual project/runtime.
- **Asset generation:** none performed as part of this baseline.

## 7. Implementation guardrails

1. Preserve `InteractiveBowl` as the gameplay root and keep its existing collider and state transitions.
2. Reflect successful `consumed_ingredients` and preparation state; rejected actions must leave visuals unchanged.
3. On successful cancellation, reconcile visuals to a clean bowl.
4. Do not add garnish to recipe progression or inventory; garnish is presentation-only under the current contract.
5. Keep production scene and art showcase separate until a specific integration change is reviewed.
6. Record actual test commands/results, commit SHA and runtime screenshots; distinguish CI/export success from manual play validation.
