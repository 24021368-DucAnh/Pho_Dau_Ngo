# Tripo AI Asset Pipeline — Phase A First Pass

**Status:** Pipeline proposal for the first art pass. No asset is considered generated, rights-cleared, imported, or accepted until its evidence record exists.

## 1. Source-of-truth rules

- Tripo AI is the primary mesh-generation tool for original game props.
- Blender is optional repair tooling, not a required modeling stage. Use it only when an inspected export has a concrete issue (scale, pivot, normals, mesh separation, topology, material setup or unwanted geometry).
- Godot is authoritative for runtime composition, visibility, collision, interaction and gameplay-camera evaluation.
- Preserve the original generated download. Never overwrite the only source with a cleaned file.
- Runtime assets are separate from source/provenance. A generated mesh does not become production-ready merely because Tripo exports it successfully.
- Do not invent or infer a license from AI generation. Record the applicable Tripo account/plan terms and current terms page at the time of generation, and check the result for logos, text, watermarks, recognizable protected designs and likeness concerns.

## 2. Phase A stable asset IDs

| Asset ID | Intended content | Source file convention | Runtime export convention | Current state |
|---|---|---|---|---|
| FOOD-PHO-001 | Empty ceramic/enamel pho bowl | `art/source/food/FOOD-PHO-001_v001_source.*` | `game/assets/models/food/FOOD_pho_bowl_ceramic.glb` | planned / not acquired |
| FOOD-PHO-002 | Separate flat rice-noodle mass | `art/source/food/FOOD-PHO-002_v001_source.*` | `game/assets/models/food/FOOD_pho_noodles.glb` | planned / not acquired |
| FOOD-PHO-003 | Broth surface volume/surface | `art/source/food/FOOD-PHO-003_v001_source.*` | `game/assets/models/food/FOOD_pho_broth_surface.glb` | planned / not acquired |
| FOOD-PHO-004 | Thin, overlapping beef slices | `art/source/food/FOOD-PHO-004_v001_source.*` | `game/assets/models/food/FOOD_pho_beef_slices.glb` | planned / not acquired |
| FOOD-PHO-005 | Herb/onion garnish cluster | `art/source/food/FOOD-PHO-005_v001_source.*` | `game/assets/models/food/FOOD_pho_garnish.glb` | planned / not acquired |

The source extension depends on what Tripo actually provides. Keep original downloads unchanged; the runtime export should be GLB/glTF when supported and validated.

## 3. Prompt templates

These prompts specify original, isolated assets and the project's grounded stylized-realism direction. They are starting prompts, not evidence that an asset exists. Save the exact prompt used alongside each generated candidate and record all regeneration changes.

### FOOD-PHO-001 — empty bowl

> Create one original empty Vietnamese pho serving bowl as a standalone 3D game asset. Medium-wide ceramic/enamel bowl with a stable flat foot, gently tapered rounded body, clearly visible thick rim and a readable empty interior. Grounded stylized realism, believable everyday street-food proportions, warm off-white glazed ceramic with subtle controlled gloss and only restrained exterior wear. No food, no utensils, no hands, no table, no environment, no lettering, no logo, no watermark. Isolated on a neutral plain background, full object visible, centered, clean silhouette, practical real-world proportions, suitable for a first-person PC cooking game. Avoid mirror reflections, razor-thin rim, warped circular opening, floating geometry and exaggerated cartoon proportions.

### FOOD-PHO-002 — noodles

> Create one separate compact nest of flat Vietnamese rice noodles for a modular pho bowl 3D game asset. Soft ivory rice noodles with a few distinct flat strands and a natural folded mass, sized to sit inside a medium-wide pho bowl without crossing its rim. Grounded stylized realism, readable from a first-person gameplay camera, no bowl, no broth, no beef, no garnish, no chopsticks, no hands, no table, no environment, no text, no logo, no watermark. Isolated on a neutral plain background, centered, full object visible. Avoid spaghetti-like round strands, tangled spikes, excessive translucency, floating strands and tiny details that disappear at gameplay distance.

### FOOD-PHO-003 — broth surface

> Create one standalone shallow pho broth surface volume for a modular bowl asset, shaped as a low, gently domed circular liquid surface that can sit just below a ceramic bowl's inner rim. Clear warm amber-brown beef broth, restrained oily highlights, subtle low-contrast variation, grounded stylized realism. The asset must be a simple, closed, game-friendly surface/volume with a clean circular boundary and no container. No bowl, no noodles, no meat, no garnish, no steam, no ladle, no hands, no table, no environment, no text, no logo, no watermark. Isolated on a neutral plain background, full shape visible. Avoid opaque orange plastic appearance, high-gloss mirror reflections, exaggerated waves, thin floating edges and noisy micro-detail.

### FOOD-PHO-004 — beef slices

> Create a small cluster of 5–7 thin, overlapping Vietnamese pho beef slices as one separate modular 3D game asset. Natural irregular oval slices with subtle folds, muted fresh beef reds and restrained lighter fat marbling; thin enough to lie over noodles and broth without looking like thick steak. Grounded stylized realism, readable from a first-person PC cooking camera. No bowl, no broth, no noodles, no garnish, no plate, no utensils, no hands, no table, no environment, no text, no logo, no watermark. Isolated on a neutral plain background, centered, full cluster visible. Avoid raw gore, blood pools, uniform coin shapes, rigid flat cards, exaggerated marbling and floating detached fragments.

### FOOD-PHO-005 — garnish

> Create one separate small garnish cluster for a Vietnamese pho bowl: sliced green onion, a few cilantro leaves and a modest amount of thin onion slivers, arranged as a compact natural mound. Fresh muted greens and pale onion tones, grounded stylized realism, designed to sit above the broth and beef without obscuring the bowl silhouette. No bowl, no broth, no noodles, no beef, no chopsticks, no hands, no table, no environment, no text, no logo, no watermark. Isolated on a neutral plain background, centered, full object visible. Avoid huge leafy salad, neon greens, oversized stems, tiny noisy leaf fragments and excessive height.

## 4. Generation and intake checklist

For each candidate:

1. Record stable asset ID, candidate/version, generation date, Tripo model/tool and account/plan context when visible, exact prompt, source download name, and applicable current terms URL or saved evidence.
2. Keep original source under `art/source/food/`; do not overwrite it during cleanup.
3. Inspect geometry and materials before runtime use: orientation, dimensions, scale, pivot, normals, manifold/holes, floating parts, mesh/material separation, texture references, texture resolution and file size.
4. Check that the intended modular pieces are truly separate assets; do not accept a single combined bowl/food mesh where gameplay needs visibility changes.
5. Use Blender only for a documented correction. Record the operation and save a new version.
6. Export to GLB/glTF where supported. Reimport into Godot and inspect for missing textures/materials and import warnings.
7. Compare against the current bowl/counter dimensions and first-person camera. Do not lock dimensions or performance budgets before measuring the actual export and graybox.
8. Run a rights/brand/watermark/likeness check. Keep blocked candidates out of production.
9. Capture neutral inspection and in-engine evidence. Record exact commit SHA, dimensions, file size, approximate triangle count and known defects.
10. Update Asset Register only to the state supported by evidence.

## 5. Runtime assembly contract

- Existing `InteractiveBowl` remains the gameplay root and owns the existing collision shape and recipe state.
- Visual layer scene may contain `BowlBase`, `NoodlesLayer`, `BrothSurface`, `BeefLayer`, and `GarnishLayer`, but those children must not become physics/interactable targets.
- The current gameplay recipes use broth → noodles → beef. Reconcile layer visibility from successful `consumed_ingredients` and preparation state; do not hard-code an assumed order.
- Garnish is presentation-only under the current recipe contract; it must not mutate inventory, recipe progress or the Ledger.
- Successful cancellation returns visuals to a clean bowl. A rejected action must not change the visible layers.
- Test held/placed transforms, collision state and visual alignment in the actual gameplay camera.

## 6. Intake evidence template

For each asset, create `docs/art/asset-evidence/<ASSET-ID>.md` with:

- ID, name, candidate/version and current status
- Exact prompt and generation metadata
- Source file path/hash and runtime export path/hash
- Tool/account context and terms/license evidence
- Human review: logo/text/watermark/likeness and visual defects
- Dimensions, scale, pivot, forward axis, file size, triangle count estimate
- Material slots, texture dependencies and import result
- Blender cleanup operations (or “none”)
- Screenshot paths and commit SHA
- Known limitations, reviewer and next decision

## 7. Current blockers

- No Tripo candidates have been generated or inspected in this repository.
- Tripo account/plan rights terms have not been recorded for a specific generation.
- Runtime model scale/pivot and performance budgets remain unmeasured.
- Phase B utensils and Phase C cart remain blocked until Phase A is accepted by the owner in-engine.
