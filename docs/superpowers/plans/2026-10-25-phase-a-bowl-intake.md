# Phase A Bowl Intake and Modular Visuals — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Validate the existing user-provided bowl candidate in Godot before spending more generation credits or implementing modular ingredient visuals.

> **Reconciliation 2026-10-26 (PR #52 revision):** Tasks 1–3 below are DONE in substance on `main` at `7f64796` (evidence noted per task). Task 4's scene and script are built; only gameplay integration and visual-state tests remain. Task 5 is temporarily closed by the owner (2026-10-25), not finally accepted. Do not re-run Tasks 1–3; the remaining work is Task 4 integration + Task 5 final acceptance.

**Architecture:** Keep the candidate out of the production scene while checking geometry, provenance, scale and materials in isolation. Only after owner acceptance, integrate the bowl as a visual child of the existing gameplay root and derive ingredient visibility from authoritative bowl state.

**Tech Stack:** Godot 4.4.1 Standard, GLB/glTF, Blender only for documented mesh repairs, existing GDScript tests and CI workflow.

**Spec:** `docs/superpowers/specs/2026-10-23-tripo-modular-art-pipeline-design.md`; workflow details in `docs/art/TRIPO_ART_PIPELINE.md`.

## Global Constraints

- Preserve `InteractiveBowl`, existing collision, ownership, placement, cancellation, recipe, inventory, Ledger and order contracts.
- Current gameplay recipe order is noodles → beef → broth; garnish remains presentation-only.
- Do not treat the conversation-uploaded binaries as repository assets until they are committed intentionally.
- Do not infer provenance or commercial-use rights from the 3MF extension or from AI-like appearance.
- Godot import/export CI is not proof of visual quality or manual runtime acceptance.
- Do not start formal Phase B utensils or Phase C cart phases before final Phase A owner acceptance. (Note 2026-10-26: the owner has since directed individual Phase B/C-adjacent items — pot, ladle, table, trays, tissue box — which are on `main`; those item waivers do not equal formal phase acceptance.)

## Review Focus

1. Bowl shape, interior, rim and foot may look acceptable in a preview but fail at first-person distance.
2. 500 × 500 × 249 mm reported dimensions may be incorrect for intended in-game proportions or coordinate orientation.
3. Non-watertight topology and degenerate triangles may create shading or import artifacts.
4. Material appearance may be only a flat color rather than a usable ceramic glaze.
5. Candidate provenance/rights are unresolved. (Superseded in part 2026-10-26: binaries ARE tracked in the repo since PR #44; provenance/rights remain unresolved.)

---

### Task 1: Inspect and decide the source candidate

**Files:**
- Read/update: `docs/art/asset-evidence/FOOD-PHO-001.md`
- Update: `docs/art/ASSET_REGISTER.md`
- User files: `ceramic bowl 3d model.3mf`, `ceramic_bowl_candidate.glb` (conversation workspace only)

**Interfaces:**
- Consumes: user-supplied 3MF and conversion candidate.
- Produces: a documented pass / repair / reject decision with measured evidence.

- [x] Open both files in Blender or a comparable mesh editor.
- [x] Verify dimensions, orientation, origin/pivot, normals, interior, wall thickness, rim and foot.
- [x] Inspect disconnected geometry, degenerate faces and non-manifold areas; distinguish visible/rendering issues from topology warnings that do not affect a static prop.
- [x] Verify material slots, embedded textures and missing external dependencies.
- [ ] Record source author/provenance and applicable terms; if unknown, explicitly keep rights unresolved. (Still open 2026-10-26: provenance/rights unverified.)
- [x] Decide one: accept for isolated import, repair into a new version, or reject. Do not regenerate without owner approval.

**Verification:** evidence record contains measured dimensions, actual file hashes/paths where available, a concrete decision and known limitations. No unsupported QA claim.

**Outcome (2026-10-26):** DONE. Decision was accept + repair into v003 (decimated 60,215 triangles / 4.9 MB, original blue pattern layer, dimensions unchanged). No Tripo regeneration was used.

### Task 2: Isolated Godot import and visual review

**Files:**
- Create temporary/test scene outside production entry path, e.g. `game/scenes/art/food/pho_bowl_intake_test.tscn` only after Task 1 passes.
- Update: `docs/art/asset-evidence/FOOD-PHO-001.md`

**Interfaces:**
- Consumes: candidate that passed initial geometry/provenance review.
- Produces: Godot 4.4.1 import evidence and owner review screenshots.

- [x] Import GLB in a disposable Godot 4.4.1 project/scene without changing `game/scenes/main.tscn`.
- [x] Record actual import warnings, material/texture behavior, scale, pivot and orientation.
- [x] Compare against existing production bowl and counter proportions in the actual first-person camera.
- [x] Capture neutral close-up and gameplay-camera screenshots; record the commit SHA and candidate version.
- [x] Ask owner to accept/reject the isolated bowl. If unavailable, leave the gate blocked.

**Verification:** the model loads without broken references, silhouette and proportions are readable, and evidence is reproducible. No gameplay integration yet.

**Outcome (2026-10-26):** DONE in substance. Import was into the modular scene (`game/scenes/art/food/pho_bowl_modular.tscn`, production-adjacent rather than disposable) plus owner Godot screenshots 2026-10-25 00:39–00:41. Owner response was a temporary close ("tạm chốt", 2026-10-25 00:52), NOT final acceptance; gameplay integration is still open (see Task 4).

### Task 3: Add a reviewed runtime bowl asset

**Files:**
- Source: `art/source/food/FOOD-PHO-001_v001_source.3mf` only if rights and repository policy allow it.
- Export: `art/exports/glb/FOOD-PHO-001_v001.glb`
- Runtime: `game/assets/models/food/FOOD_pho_bowl_ceramic.glb`
- Evidence: `docs/art/asset-evidence/FOOD-PHO-001.md`
- Register: `docs/art/ASSET_REGISTER.md`

**Interfaces:**
- Consumes: owner-accepted candidate and verified provenance/rights.
- Produces: version-paired source/runtime asset and auditable evidence.

- [x] Preserve the original source unchanged; save any repaired file as a new version.
- [x] Include only binaries allowed by provenance, size and repository policy.
- [x] Verify resource paths, texture dependencies and actual file size after adding.
- [x] Update evidence and register with measured dimensions, triangle count, hashes, import result and known defects.

**Verification:** source/export pairing is clear; no unresolved rights claim is represented as cleared; GLB imports on a clean checkout.

**Outcome (2026-10-26):** DONE, with path differences noted: the original `.3mf` was preserved outside the repo (not under `art/source/food/`); the 7 runtime GLBs live at `game/assets/models/food/` (committed via PR #44), not under `art/exports/glb/`. Provenance is still recorded as unresolved, not cleared.

### Task 4: Build modular visuals after bowl acceptance

**Files:**
- Create: `game/scenes/art/food/pho_bowl_modular.tscn`
- Create: `game/scripts/art/pho_bowl_visuals.gd`
- Tests: follow the existing Godot test conventions; record exact test path after inspecting the repository.
- Evidence: `docs/art/asset-evidence/phase-a-bowl-state-matrix.md`

**Interfaces:**
- Consumes: accepted bowl model and authoritative `InteractiveBowl` state.
- Produces: render-only layers for bowl, noodles, beef, broth and optional garnish.

- [ ] Write failing tests for clean state, each successfully consumed ingredient, rejected step, cancellation/reset and bowl reuse.
- [ ] Confirm new tests fail for missing visual behavior before implementation.
- [x] Implement visuals that derive from authoritative `consumed_ingredients` and preparation state; do not duplicate recipe validation.
- [x] Keep all ingredient meshes free of extra colliders/interactable targets; preserve existing root and collision behavior.
- [x] Keep garnish visual-only and do not mutate inventory, recipe progress or Ledger.
- [ ] Run focused tests, full CI commands and Godot import/export checks; record actual output.

**Verification:** state matrix passes; rejected steps do not alter visuals; cancellation resets visuals; all existing gameplay contracts remain unchanged.

**Outcome (2026-10-26):** PARTIALLY DONE. Scene `game/scenes/art/food/pho_bowl_modular.tscn` and script `game/scripts/art/pho_bowl_visuals.gd` exist on `main` (visuals-only, driven by `consumed_ingredients`; garnish + chopsticks only when all three ingredients are present; no extra colliders). Remaining: visual-state tests for gameplay, and instancing the scene into gameplay `main.tscn` (gameplay Bowl is still a cylinder visual). Domain tests for bowl state pass; visual-layer switching in gameplay is untested.

### Task 5: Phase A acceptance gate

- [x] Capture clean, intermediate and completed-bowl screenshots in the actual first-person camera.
- [x] Record actual asset dimensions, triangle count, file size, texture dimensions and import warnings.
- [ ] Confirm rights/provenance review and owner approval.
- [x] Update the register only to the state supported by the evidence.
- [ ] Stop for owner review before Phase B utensils or Phase C cart.

**Verification:** automated tests, import/export checks and manual visual evidence are separate, explicit records; owner acceptance is recorded before advancing.

**Outcome (2026-10-26):** PARTIALLY DONE. Owner screenshots exist and the register was updated (this PR revision); rights/provenance review is still open, and owner approval so far is a temporary close (2026-10-25 00:52), NOT final acceptance. Formal Phase B/C phases still need that final acceptance plus an explicit owner call — individual pot/ladle/table/tray items already on `main` do not close this gate.
