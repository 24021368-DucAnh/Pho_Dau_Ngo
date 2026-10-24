# Tripo Modular Art Pipeline Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Prove a repeatable Tripo-first asset pipeline by integrating a modular pho bowl in Godot without changing recipe, inventory, interaction, or economy behavior, then use the accepted workflow for utensils and the pho cart.

**Architecture:** Tripo AI produces the initial hero meshes; Blender is optional and used only to repair scale, pivots, normals, topology, materials, or mesh separation; Godot owns runtime scene composition, ingredient visibility, collision, and camera-based evaluation. Phase A (the bowl) is the proof gate. Phase B (utensils) and Phase C (cart) must not begin until the bowl's in-engine visual and behavior evidence is accepted.

**Tech Stack:** Godot 4 (confirm exact project version from CI/project metadata before implementation), Tripo AI, Blender only if needed, GLB/glTF, existing GDScript and current CI/export workflow.

**Spec:** `docs/superpowers/specs/2026-10-23-tripo-modular-art-pipeline-design.md`

## Global Constraints

- Preserve the existing `InteractiveBowl` class and its state/recipe API in `game/scripts/interactive_bowl.gd`.
- Visuals must reflect successful existing recipe-step transitions; the art scene must not implement duplicate recipe rules.
- Preserve bowl ownership, collision, placement, cancellation/reset, serving, inventory, Ledger, order, and day-progression behavior.
- Keep the art showcase separate from the production entry/gameplay scene until the owner explicitly accepts integration.
- Prefer GLB/glTF; retain original Tripo exports and prompts/provenance under `art/` and keep runtime-ready models under `game/assets/models/`.
- Use Visual Bible palette as provisional: broth `#B97A2B`, inox `#AEB3AA`, cart green `#4D6658`, worn timber `#75513A`; verify in the actual gameplay camera before locking.
- Use simple collision shapes separate from render meshes; ingredient meshes must not become separate interaction targets.
- Do not commit generated files with unclear provenance, watermarks, unreviewed trademarks/logos, or unresolved commercial-use rights.
- Do not claim runtime/visual acceptance from CI alone. Attach real Godot screenshots and a manual test record.
- Avoid setting arbitrary triangle/FPS budgets before inspecting the first exports and identifying the target PC; record provisional measured budgets at the first-art-pass gate.

## Review Focus

1. Recipe state and visible ingredient layers can diverge after a rejected step, cancellation, reset, or bowl reuse.
2. Bowl visuals can shift or detach when the existing gameplay node is held, placed, or transformed.
3. Imported Tripo meshes can contain bad scale/pivot, inverted normals, floating parts, material/texture dependencies, or hidden geometry.
4. Transparent garnish/steam and broth surfaces can sort incorrectly, clip through the bowl, or become unreadable at first-person distance.
5. Art showcase changes can accidentally alter the production scene or gameplay contracts despite passing an export build.

---

### Task 1: Capture the current contracts and baseline before changing assets

**Files:**
- Read: `game/scripts/interactive_bowl.gd`
- Read: `game/scripts/art/stylized_vertical_slice.gd`
- Read: current bowl scene/resource and recipe-action/controller implementation found by tracing references to `InteractiveBowl`, `apply_recipe_step`, and `cancel_preparation`
- Read: current CI workflow and the existing automated test runner/test locations
- Create: `docs/art/asset-evidence/phase-a-baseline.md`

**Interfaces:**
- Consumes: existing `InteractiveBowl` state and recipe lifecycle; current project entry scene and art showcase entry point.
- Produces: a documented baseline of exact scene/script paths, signals/call sites that indicate successful recipe transitions, cancellation/reset behavior, Godot version, CI test/export commands, and current showcase limitations.

- [ ] **Step 1: Trace bowl lifecycle call sites.** Record where `apply_recipe_step` and `cancel_preparation` are invoked and which existing state values/ingredient IDs distinguish noodle, broth, beef, and garnish steps. Do not add a new signal or API until the current contract is understood.
- [ ] **Step 2: Record current automated test commands.** Read the workflow and test harness; copy the exact commands into the baseline note rather than inventing a new runner.
- [ ] **Step 3: Capture baseline.** Run the existing test suite and relevant Godot import/export check. Record command, commit SHA, pass/fail result, and any pre-existing warning.
- [ ] **Step 4: Record scene ownership.** Confirm the art showcase entry point and the production entry scene are distinct; document the current bowl visual and collider paths.
- [ ] **Step 5: Commit.** `git add docs/art/asset-evidence/phase-a-baseline.md && git commit -m "docs: record art pipeline baseline"`

**Verification:** baseline note names real paths and exact commands; existing tests are run before any implementation edits. A failure is recorded as baseline, not silently repaired as part of this task.

### Task 2: Establish asset folders, provenance metadata, and repeatable Tripo prompts

**Files:**
- Create: `art/source/food/README.md`
- Create: `art/exports/README.md`
- Create: `docs/art/TRIPO_ART_PIPELINE.md`
- Modify: `docs/art/ASSET_REGISTER.md`
- Evidence: `docs/art/asset-evidence/phase-a-baseline.md`

**Interfaces:**
- Consumes: Visual Bible, Asset Register status vocabulary, the Phase A stable IDs from the design spec.
- Produces: one reproducible generation/cleanup checklist and a provenance record for each generated candidate.

- [ ] **Step 1: Define the Phase A source/export convention.** Record stable IDs `FOOD-PHO-001` through `FOOD-PHO-005`, source and export naming, version pairing, prompt storage, generation date/tool/model when exposed, rights review, and review status.
- [ ] **Step 2: Record prompts for five bowl components.** Separate prompts for the empty ceramic/enamel bowl, flat rice noodle mass, broth surface, beef slice variants, and herb garnish. Each prompt requires isolated asset, neutral background, no text/logo/watermark, grounded stylized realism, and a readable silhouette.
- [ ] **Step 3: Define an export intake checklist.** Require GLB/glTF where supported, inspect scale/orientation/pivot, normals, material slots, external texture dependencies, floating geometry, clipping, topology, and file size before copying into runtime folders.
- [ ] **Step 4: Update the register without falsely marking ungenerated assets as final.** Use `reference` or `first-art-pass` only when the corresponding evidence exists; ungenerated assets remain planned/not acquired.
- [ ] **Step 5: Commit.** `git add art/source/food/README.md art/exports/README.md docs/art/TRIPO_ART_PIPELINE.md docs/art/ASSET_REGISTER.md && git commit -m "docs: define Tripo asset intake pipeline"`

**Verification:** no model is represented as generated or cleared without an actual file and provenance; every candidate has a stable ID and a documented rights gate.

### Task 3: Generate and intake the empty bowl hero asset

**Files:**
- Create source/export files under: `art/source/food/` and `art/exports/glb/`
- Create runtime asset: `game/assets/models/food/FOOD_pho_bowl_ceramic.glb`
- Create evidence: `docs/art/asset-evidence/FOOD-PHO-001.md`
- Modify: `docs/art/ASSET_REGISTER.md`

**Interfaces:**
- Consumes: Task 2 intake rules and `FOOD-PHO-001` prompt.
- Produces: one inspected, project-owned bowl model with documented scale, pivot, material dependencies, source/export versions, and known limitations.

- [ ] **Step 1: Generate candidate(s) in Tripo AI.** Save the exact prompt and generation metadata; do not treat prompt text as evidence that a model exists.
- [ ] **Step 2: Select one candidate against the Visual Bible.** Reject obvious AI artifacts, logos, watermarks, unstable rim thickness, bad interior surfaces, or unrealistic bowl proportions.
- [ ] **Step 3: Clean only if required.** Use Blender only for documented defects (scale, pivot, normals, unwanted geometry, mesh/material separation). Keep a source copy and note every destructive operation.
- [ ] **Step 4: Import into Godot.** Verify material/texture dependencies and a meaningful base/contact pivot; compare bowl dimensions with the existing counter and bowl placement transform.
- [ ] **Step 5: Capture neutral and gameplay-camera evidence.** Record import success, dimensions, file size, approximate triangle count, and any visible artifacts.
- [ ] **Step 6: Commit.** Add only reviewed source/export files allowed by repository size policy, evidence, and register update. Use commit message `art: add first pho bowl model`.

**Verification:** imported bowl is not stretched or rotated unexpectedly, rim and interior read clearly at gameplay distance, no missing textures/watermarks are present, and evidence links to the exact model/version.

### Task 4: Build the modular bowl visual scene without owning gameplay state

**Files:**
- Create: `game/scenes/art/food/pho_bowl_modular.tscn`
- Create: `game/scripts/art/pho_bowl_visuals.gd`
- Modify: the existing bowl scene only after Task 1 identifies its actual path and confirms a visual-child integration preserves the existing root/script/collider
- Test: add tests in the repository's existing test harness and conventions, with cases named for the behaviors below
- Evidence: `docs/art/asset-evidence/phase-a-bowl-state-matrix.md`

**Interfaces:**
- Consumes: existing `InteractiveBowl` and recipe lifecycle; model IDs `FOOD-PHO-001` through `FOOD-PHO-005`.
- Produces: a visuals-only scene/script with named child layers for bowl, noodles, broth, beef, and garnish. It must not mutate `InteractiveBowl` state or decide whether a recipe step is valid.

- [ ] **Step 1: Write failing behavior tests.** Cover: clean bowl shows base only; successful noodle step shows noodles; broth step shows broth; beef step shows beef; garnish step shows garnish; rejected step leaves visuals unchanged; cancellation returns to clean visuals; READY_TO_SERVE shows the complete bowl; visual children do not add collision/interactable targets.
- [ ] **Step 2: Run tests and confirm the new assertions fail** for the missing visual behavior, using the existing project test runner identified in Task 1.
- [ ] **Step 3: Implement the visuals-only scene.** Use stable child names `BowlBase`, `NoodlesLayer`, `BrothSurface`, `BeefLayer`, `GarnishLayer`; keep all ingredient visuals under one visual root and hide unprepared layers by default.
- [ ] **Step 4: Bind visuals to the authoritative successful state transition.** Prefer a signal emitted only after `apply_recipe_step` succeeds if an existing signal/call site can supply the state safely. If a new signal is needed, add it at the domain transition boundary and document it; do not infer progress from button presses or duplicate recipe order in the art script.
- [ ] **Step 5: Handle cancellation/reset and bowl reuse.** Reconcile visual state from authoritative bowl fields after a successful cancellation/reset; rejected actions must not change visuals.
- [ ] **Step 6: Keep gameplay ownership stable.** Confirm `InteractiveBowl` remains the gameplay root and the original collider, held/placed transforms, and collision-layer behavior are unchanged. Visual ingredient meshes must not become physics targets.
- [ ] **Step 7: Run focused tests, full tests, and Godot import/export checks.** Record commands and outputs.
- [ ] **Step 8: Commit.** `git add game/scenes/art/food/pho_bowl_modular.tscn game/scripts/art/pho_bowl_visuals.gd <verified-existing-bowl-scene> <verified-test-files> docs/art/asset-evidence/phase-a-bowl-state-matrix.md && git commit -m "feat: add modular pho bowl visuals"`

**Verification:** all state-matrix tests pass; rejected actions leave visuals unchanged; cancel returns the bowl to clean visuals; bowl interaction/placement and all existing gameplay tests remain unchanged; the art showcase still loads.

### Task 5: Phase A owner gate and performance/readability review

**Files:**
- Create/update: `docs/art/asset-evidence/phase-a-bowl-state-matrix.md`
- Modify: `docs/art/ASSET_REGISTER.md`
- Modify: `docs/art/TRIPO_ART_PIPELINE.md` only if the proven workflow needs a documented correction

**Interfaces:**
- Consumes: integrated bowl scene, state-matrix tests, model provenance.
- Produces: an explicit Phase A acceptance record; Phase B remains blocked until owner approval.

- [ ] **Step 1: Run the actual Godot project and inspect the normal first-person camera.** If local runtime execution is unavailable, mark this check blocked; do not substitute CI export success.
- [ ] **Step 2: Capture screenshots** of clean bowl, noodles-only intermediate state, and completed bowl at gameplay scale; include one neutral close-up only as supporting evidence.
- [ ] **Step 3: Review readability and defects.** Check broth line, rim, noodle mass, beef slices, garnish, clipping, transparency sorting, target readability, and whether the visual matches the grounded stylized-realism direction.
- [ ] **Step 4: Record measured provisional asset budgets** from the actual export (file size, triangle count, texture dimensions, dependencies) and any performance observations; do not invent a target FPS or hardware baseline.
- [ ] **Step 5: Update asset state only with evidence.** Use `integrated` when integrated; use `QA` only when import, rights, readability, and runtime checks are all recorded.
- [ ] **Step 6: Stop for owner review.** Do not begin Phase B or Phase C until the owner explicitly accepts the in-game evidence.

**Verification:** evidence has real screenshots and exact commit SHA; all automated tests pass; any unavailable manual check is explicitly marked blocked; owner acceptance is recorded before the next phase.

### Task 6: Phase B — cooking utensils, after Phase A acceptance

**Files:**
- Create models/scenes under `art/source/props/`, `art/exports/glb/`, `game/assets/models/props/`, and `game/scenes/art/props/`
- Modify: `docs/art/ASSET_REGISTER.md`
- Evidence: `docs/art/asset-evidence/phase-b-utensils.md`

**Interfaces:**
- Consumes: accepted Phase A style/scale/material workflow.
- Produces: separate stockpot, ladle, noodle strainer, and ingredient tray assets: `PROP_stock_pot_aged_aluminum`, `PROP_soup_ladle_stainless`, `PROP_noodle_strainer_mesh`, `PROP_ingredient_tray_inox`.

- [ ] **Step 1: Generate and document each Tripo candidate** using the same style references and provenance checklist.
- [ ] **Step 2: Inspect/clean/export/import** each asset; simplify fine mesh details that disappear or shimmer at gameplay distance.
- [ ] **Step 3: Integrate as visuals only** into the art showcase or confirmed workstation scene; add interaction anchors only if the existing gameplay contract needs them.
- [ ] **Step 4: Run the relevant gameplay tests and import/export workflow.** Confirm interaction behavior and production station ownership are unchanged.
- [ ] **Step 5: Capture gameplay-camera evidence** and update register states.
- [ ] **Step 6: Commit.** `git commit -m "art: add pho workstation utensils"`

**Verification:** silhouettes and material response read at gameplay distance; scale matches counter and bowl; no new gameplay behavior or interaction targets are introduced accidentally.

### Task 7: Phase C — pho cart, after Phase B review

**Files:**
- Create models/scenes under `art/source/environment/`, `art/exports/glb/`, `game/assets/models/environment/`, and `game/scenes/art/environment/`
- Modify: `docs/art/ASSET_REGISTER.md`
- Evidence: `docs/art/asset-evidence/phase-c-cart.md`

**Interfaces:**
- Consumes: accepted bowl/utensil asset pipeline and verified graybox dimensions.
- Produces: cart body, worktop, glass case, wheels/shelf, using `ENV_pho_cart_body`, `ENV_pho_cart_worktop`, `ENV_pho_cart_glass_case`, and `ENV_pho_cart_wheels_shelf` or a justified optimized assembly.

- [ ] **Step 1: Measure the current cart/workstation footprint** and interaction target positions from the accepted scene; use those dimensions to guide Tripo prompts and Godot placement.
- [ ] **Step 2: Generate, clean, export, import and document** the cart asset(s). Use separate parts only where assembly, reuse, or interaction requires them.
- [ ] **Step 3: Replace only the art-showcase cart first.** Do not silently replace the production entry scene or move gameplay nodes as part of the visual swap.
- [ ] **Step 4: Verify player path, reachability, glass transparency, target visibility, and counter height** in the actual first-person camera.
- [ ] **Step 5: Run full tests and platform export checks; capture runtime screenshots.**
- [ ] **Step 6: Commit.** `git commit -m "art: replace blockout pho cart"`

**Verification:** dominant blocky cart silhouette is replaced, workstation affordances remain readable, player path is unobstructed, gameplay targets remain reachable, and all rights/runtime evidence is recorded.

### Task 8: Final pipeline handoff and review

**Files:**
- Modify: `docs/art/TRIPO_ART_PIPELINE.md`
- Modify: `docs/art/ASSET_REGISTER.md`
- Create/update: `docs/art/asset-evidence/pipeline-acceptance.md`

- [ ] **Step 1: Audit all asset IDs** for source/export pairing, prompt and generation metadata, provenance, license/terms, current state, and evidence links.
- [ ] **Step 2: Run the full existing test suite and configured Godot exports** on the final implementation commit.
- [ ] **Step 3: Confirm no recipe/economy/order/Ledger behavior changed** and no showcase-only scene was unintentionally promoted to the production entry scene.
- [ ] **Step 4: Prepare a review summary** with changed files, commit SHAs, CI links, evidence screenshots, known limitations, and any blocked manual checks.
- [ ] **Step 5: Request a fresh review before merge.** Do not merge merely because the build passes.

**Final acceptance:** automated tests and exports pass; all generated assets have provenance/rights records; in-engine camera evidence exists; bowl state visuals follow authoritative recipe transitions; Phase A/B/C owner gates were respected; no unverified runtime claim is made.
