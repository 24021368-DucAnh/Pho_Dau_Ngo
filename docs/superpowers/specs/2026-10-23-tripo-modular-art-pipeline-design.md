# PHỞ ĐẦU NGÕ — Tripo AI Modular Art Pipeline Design

**Status:** Proposed design — awaiting owner review  
**Date:** 2026-10-23  
**Decision requested:** Approve or revise this design before a detailed implementation plan is written  
**Scope:** Art asset production and Godot integration for the current vertical slice; no gameplay-system rewrite

## 1. Context and problem

The current art showcase at `game/scripts/art/stylized_vertical_slice.gd` explicitly builds its environment and props from Godot primitive meshes. This was useful as a dependency-free blockout, but the resulting bowl, food, utensils and cart read as geometric placeholders rather than a lived-in Hanoi pho stall. The existing `docs/art/VISUAL_BIBLE.md` calls for grounded stylized realism, a readable first-person workstation, selective wear, warm morning light and a hierarchy in which gameplay-critical props remain the clearest objects.

The existing production scene and the art showcase are distinct. This work must not silently replace the production entry scene or couple visual nodes to economy/recipe logic.

## 2. Goals

1. Replace the most visible primitive food props with authored, coherent 3D assets, in the order **pho bowl → cooking utensils → pho cart**.
2. Use **Tripo AI as the primary model-generation tool**; use Blender or another suitable local editor only when cleanup is needed; use Godot for import, material tuning, scene assembly, interaction/collision integration and runtime evaluation.
3. Preserve modularity so bowl contents can reflect recipe progress instead of forcing the game to swap a single finished-bowl model.
4. Establish consistent scale, pivots, naming, materials, file organization and provenance records.
5. Keep the first-person gameplay readable and the vertical slice performant on the project's desktop target.
6. Require visual evidence and owner review; passing CI alone is not visual acceptance.

## 3. Non-goals

- No change to recipe rules, bowl ownership transitions, inventory, serving, Ledger, orders, day progression or economy.
- No wholesale environment rebuild before the hero-prop pipeline is proven.
- No automatic assumption that Tripo output is clean, optimized, commercially cleared, or ready to ship without inspection.
- No download/reuse of reference models unless the exact source, license and attribution obligations are recorded and compatible with intended use.
- No claim that the current Godot runtime has been manually validated until a real run and screenshot are captured.

## 4. Chosen production approach

### Approved direction: Tripo-first hybrid pipeline

- **Tripo AI:** generate the initial 3D shape for hero props and selected components using the agreed prompts and consistent visual references.
- **Blender/post-processing (conditional):** fix scale/orientation, pivot, normals, obvious mesh defects, excessive geometry, unwanted floating/interior surfaces, and separate meshes when practical. Do not require Blender edits if the export already passes all checks.
- **Godot 4:** own the runtime scene hierarchy, materials where practical, collision, interaction anchors, ingredient visibility/state, lighting and gameplay camera review.
- **Manual/procedural geometry:** allowed for invisible collision, simple hidden supports, broth surface/level, small placement anchors and lightweight garnish decal/instances. It must not be used as a substitute for hero models in a way that recreates the current boxy look.

### Alternatives considered

- Generate every part as an independent Tripo model: potentially flexible, but likely inconsistent in style, scale and mesh density, and wasteful for tiny ingredients.
- Continue procedural primitives only: efficient and deterministic, but does not solve the current visual-quality problem.
- Import a complete pho bowl as one indivisible model: fast for a static beauty shot, but prevents recipe-driven ingredient changes and conflicts with modular gameplay requirements.

## 5. Art direction constraints

Follow `docs/art/VISUAL_BIBLE.md`:

- **Style:** grounded stylized realism, believable proportions, simplified details that survive gameplay distance.
- **Palette anchors:** ceramic/enamel warm ivory; broth amber (`#B97A2B`); herbs restrained natural greens; beef warm muted red; inox (`#AEB3AA`) with broad, soft highlights; cart glazed green (`#4D6658`); worn timber (`#75513A`).
- **Wear:** selective and story-driven—outer pot surfaces, contact edges, handles and cart corners. Food-contact surfaces and food itself remain clean and appetizing.
- **Lighting:** diffuse early-morning daylight and readable shadows; avoid white clipping, mirror chrome, neon orange broth and excessive bloom.
- **Readability:** bowl rim, broth line, noodle mass, beef slices and garnish must remain distinguishable from the normal first-person interaction distance. Small surface details are secondary to silhouette and value grouping.

The palette remains provisional until evaluated in the real game camera and display conditions.

## 6. Asset production sequence

### Phase A — modular pho bowl (first proof of pipeline)

Create or source the following project-owned outputs:

| Stable ID | Proposed file stem | Role | Runtime strategy |
|---|---|---|---|
| FOOD-PHO-001 | `FOOD_pho_bowl_ceramic` | Empty ceramic/enamel bowl, recognizable rim and interior | Base mesh with a simple collision shape; remains present across preparation states |
| FOOD-PHO-002 | `FOOD_pho_noodles_flat_rice` | White flat rice noodles as a compact, layered mass | Separate child mesh/scene, shown after noodle preparation step |
| FOOD-PHO-003 | `FOOD_pho_broth_surface` | Amber broth surface; not a full opaque cylinder filling the bowl | Thin mesh/disc or suitable surface, adjustable height/material; visible only after broth step |
| FOOD-PHO-004 | `FOOD_pho_beef_slice_a` | One or two distinct thin rare-beef slice variants | Instance and arrange several slices; do not generate five near-identical complete models |
| FOOD-PHO-005 | `FOOD_pho_herb_garnish` | Scallion/cilantro/chili garnish cluster or alpha decal | Lightweight mesh or transparent decal/texture if depth and lighting remain acceptable |

Bowl assembly scene proposal: `game/scenes/art/food/pho_bowl_modular.tscn` with a root scene and named visual children. The exact integration path may change after the existing bowl scene and recipe action contract are checked during planning.

Rules:
- Keep the existing `InteractiveBowl` gameplay node/API and its collision/ownership behavior intact.
- Prefer a visual child under the gameplay node or a scene composition that preserves its script and collision contract.
- Visual state changes must be driven by existing successful recipe-step transitions, not by duplicate gameplay rules in the art scene.
- Keep the base bowl collider simple and stable; ingredient meshes should not become independent interaction targets.
- Cancel/reset behavior must clear visual ingredients consistently with the domain state. This integration detail must be confirmed against current controller signals before coding.
- Evaluate both empty-bowl and completed-bowl states, plus the intermediate state where noodles are present but toppings are not.

**Phase A gate:** one imported bowl and its modular ingredient layers are visible in Godot at gameplay scale, all layers align without clipping, ingredient states follow the existing recipe lifecycle, and an owner-review screenshot is accepted. Do not start the cart replacement before this gate passes.

### Phase B — cooking utensils

| Stable ID | Proposed file stem | Key requirements |
|---|---|---|
| PROP-KITCHEN-001 | `PROP_stock_pot_aged_aluminum` | Large stockpot, rolled rim, thick readable wall, side handles, brushed aluminum with restrained soot/heat discoloration outside the food-contact area |
| PROP-KITCHEN-002 | `PROP_soup_ladle_stainless` | Long handle, deep scoop, believable thickness and a stable grip/interaction anchor |
| PROP-KITCHEN-003 | `PROP_noodle_strainer_mesh` | Deep mesh basket and long handle; mesh may be simplified if fine holes do not read at gameplay distance |
| PROP-KITCHEN-004 | `PROP_ingredient_tray_inox` | Clean shallow tray for beef/herbs, readable rim and soft steel response |

Keep the stockpot and utensils separate. Add interaction anchors only where the gameplay system needs them. If the pot is a visual replacement for the existing showcase prop, do not assume it is the same node as the production kitchen station; confirm scene ownership and intended usage first.

**Phase B gate:** silhouettes and material response are clear at gameplay distance; scale matches the counter and bowl; no oversized triangle count or noisy mesh detail; collision/interaction behavior is unchanged.

### Phase C — pho cart

| Stable ID | Proposed file stem | Key requirements |
|---|---|---|
| ENV-CART-001 | `ENV_pho_cart_body` | Compact Vietnamese street-food cart, aged green enamel/aluminum panels, sensible doors and repaired edges |
| ENV-CART-002 | `ENV_pho_cart_worktop` | Brushed inox top with two clearly separated pot cutouts only if the final workstation layout requires both |
| ENV-CART-003 | `ENV_pho_cart_glass_case` | Glass display cabinet and shelves/trays; glass must not obscure interactable items |
| ENV-CART-004 | `ENV_pho_cart_wheels_shelf` | Wheels, lower shelf and structural supports, separate only when that helps assembly or reuse |

Cart construction can be one optimized model or a few modular submodels, based on Tripo output quality and required runtime interactions. The final arrangement must match actual gameplay stations, reachable targets, and counter height rather than blindly following a concept image.

**Phase C gate:** the cart replaces the dominant blocky silhouette in the showcase scene, has clear workstation affordances, preserves the player path and target readability, and is reviewed in the real camera.

## 7. Proposed folder and naming structure

Keep source files out of runtime folders unless the engine needs them.

```text
art/
  source/
    food/
    props/
    environment/
  exports/
    glb/
    textures/
  references/
    README.md
game/
  assets/
    models/
      food/
      props/
      environment/
    materials/
    textures/
  scenes/
    art/
      food/
      props/
      environment/
docs/
  art/
    ASSET_REGISTER.md
    TRIPO_ART_PIPELINE.md
    asset-evidence/
```

This is a proposed layout, not an instruction to create empty directories now. Use `.glb` as the default Godot interchange format unless a specific Tripo export constraint requires another supported format. Preserve original exports in `art/exports/`; commit only source/export files appropriate for the repo's size and licensing policy. Large working files or alternate generations should not be added without checking repository policy.

Naming convention:
- Follow Visual Bible prefixes: `FOOD_`, `PROP_`, `ENV_`, `MAT_`, `TEX_`.
- Use descriptive snake_case and stable IDs in Asset Register.
- Version reviewed source/export pairs together; never silently overwrite an accepted asset.

## 8. Tripo generation and post-processing checklist

For each model, record the prompt, generation date, model/version if exposed, chosen output, and any cleanup.

1. Generate against the same Visual Bible palette/material direction; prefer a three-quarter reference view with a neutral background.
2. Ask for a clean, isolated asset with realistic proportions, no text/logos/watermarks, no background, and no unnecessary detached accessories.
3. Inspect silhouette, bottom/base, interior surfaces, rim thickness, floating geometry, non-manifold or self-intersecting surfaces, texture seams and obvious AI artifacts.
4. Export the best supported format for Godot (prefer GLB/glTF).
5. Normalize scale/orientation and set a meaningful pivot. Proposed convention: 1 Godot unit = 1 metre; validate against the current cart/counter dimensions before finalizing.
6. Check normals, material slots, UVs and texture references. Repack missing external textures if required and permitted.
7. Reduce geometry only when needed; preserve silhouette and avoid destructive decimation of thin noodles, beef slices, handles or glass edges.
8. Make collision separately in Godot using primitive or low-complexity shapes.
9. Import into Godot and inspect from both a neutral showcase view and the actual first-person camera.
10. Record final file hash/version, dependencies, known limitations, source and rights review in Asset Register.

Tripo subscription/plan terms and commercial-use rights can vary. Before shipping generated assets, record the applicable terms for the actual account and generation date; do not treat generation alone as legal clearance.

## 9. Technical import and runtime constraints

- Target engine is the current Godot 4 project configuration; confirm exact version from project/workflow before implementation.
- Default interchange: GLB/glTF; avoid formats requiring a proprietary runtime plugin.
- Materials should use engine-compatible PBR channels and conservative texture sizes. Initial target is 1K or lower for small props; allow higher resolution only when close-up evidence demonstrates a need.
- Avoid transparent alpha surfaces where an opaque material or a simple mesh is more stable. For garnish, compare a lightweight mesh cluster with an alpha decal during the prototype.
- Avoid very thin, dense mesh strands that shimmer or disappear at first-person distance.
- Render mesh and collision mesh are separate concerns. Do not use full-detail food meshes as physics collision.
- Imported visual nodes must not own recipe, inventory, economy or order state.
- Keep art showcase scene separate from production gameplay scene until the vertical-slice integration gate is explicitly passed.

Triangle, texture-memory and draw-call budgets will be set after the first Tripo exports are inspected; guessing a strict budget before seeing generated assets would create false precision. The implementation plan must define measurable provisional budgets based on the actual desktop target and CI/export constraints.

## 10. Asset provenance and licensing

Every acquired/generated asset must have a register row containing:
- Stable ID and asset name.
- Original prompt or source URL and creator/service.
- Generation/access date and applicable terms/license.
- Intended usage and any attribution/redistribution requirements.
- Original export, processed export and version relationship.
- Cleanup actions and known limitations.
- Status: `reference` → `proxy` → `first-art-pass` → `final` → `integrated` → `QA`.
- Runtime/import evidence and reviewer.

NoAI-labeled reference models remain reference-only unless their terms explicitly permit the intended use. Third-party CC assets require exact source and attribution. Do not copy trademarks or reproduce identifiable private individuals. Assets with unclear rights remain blocked from shipping.

## 11. Verification and acceptance

### Automated/technical checks
- Godot import/parse and existing contract tests pass.
- The project exports successfully for currently supported desktop targets.
- No missing resource paths, import errors, script errors or accidental scene-entry-point changes.
- Scene references remain stable; bowl gameplay contract tests continue to pass.
- Asset register links to the exact imported files and source records.

### Manual visual checks
- Capture empty, noodles-only, and completed pho bowl states.
- Capture pot/ladle/strainer in workstation context.
- Capture the cart in the first-person gameplay camera and the art showcase camera.
- Check normal interaction distance, object focus/readability, clipping, scale, lighting, material response, aliasing and frame stability.
- Compare screenshots against Visual Bible; CI success does not substitute for these checks.
- Owner explicitly accepts each phase gate before work moves to the next phase.

### Evidence format
Store dated screenshots or short clips under `docs/art/asset-evidence/` or another approved evidence location, with a short note naming the commit, scene, camera/view, asset IDs and test state. Do not mark an asset `QA` without evidence.

## 12. Risks and mitigations

| Risk | Mitigation |
|---|---|
| Tripo output looks photorealistic or stylistically inconsistent | Use Visual Bible references and a shared prompt template; review all assets together before integration |
| AI mesh is too dense or malformed | Inspect before import; conditional Blender cleanup; do not proceed to the next phase until the hero asset passes |
| Bowl visuals desync from recipe state | Preserve existing gameplay contract; bind visuals to successful state transitions and test cancel/reset |
| Asset files inflate repository/build size | Keep only selected exports and required textures; record size; avoid committing every generation |
| Model license or AI-service terms are unclear | Keep blocked/reference-only until exact terms and intended commercial use are documented |
| Model looks good in isolation but fails in first-person | Require real-camera screenshots at interaction distance for every phase gate |
| Cart asset blocks interaction targets or player movement | Validate placement zones, reach, collision and clear walk path before integration |
| CI passes while the art still looks wrong | Separate technical checks from owner-reviewed runtime visual acceptance |

## 13. Decisions required at design review

This document recommends the following defaults unless the owner requests changes:

1. **Workflow:** Tripo-first hybrid; Blender is conditional cleanup, Godot is runtime integration.
2. **Order:** modular bowl → utensils → cart.
3. **First proof:** empty bowl + noodle layer + broth surface + beef + garnish, shown through the existing preparation lifecycle.
4. **File exchange:** GLB/glTF by default.
5. **Integration safety:** art scenes stay separate from the production entry scene until acceptance.
6. **Rights:** no asset enters release-ready status without provenance and applicable terms recorded.
7. **Gate policy:** owner reviews visual evidence after each phase.

**Approval gate:** Review this design before creating the implementation plan or modifying gameplay/art scene files. After approval, write a task-by-task plan with exact paths, dependencies, tests, acceptance evidence and rollback points.
