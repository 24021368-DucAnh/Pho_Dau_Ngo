# PHỞ ĐẦU NGÕ Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task after the owner approves this plan and selects the execution method. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver one complete, testable game day that proves the core service loop, visual direction, UI, and desktop build quality before scaling the 100-day campaign.

**Architecture:** Keep the existing Godot spike isolated as technical evidence. The owner selected Godot 4 on 2026-10-22. The clean production project is under `game/`, with separate scene, domain-state, UI and test responsibilities; use explicit state transitions and a single authoritative source for orders, inventory and ledger transactions. Build the 3D-art and UI/UX tracks in parallel, then review them in the running game rather than in Blender/Figma alone.

**Tech Stack:** Godot 4.4.1 + GDScript + GitHub Actions. Blender for 3D assets, Figma for visual/UI design, Linear for tasks and gates. Do not add a test framework or asset dependency without a documented reason.

**Spec:** `docs/VERTICAL_SLICE_AND_ART_UI_PIPELINE_SPEC.md`; product baseline: `docs/PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md`; decisions: `docs/DECISION_LOG.md`.

## Global Constraints

- The approved product baseline is first-person 3D PC/Steam with a 100-day campaign, but only one representative complete day is in the first production slice.
- Godot 4 is the owner-selected production engine (2026-10-22). The production scaffold passed the owner-reported 10/10 PC checklist; the current gate is the kitchen/recipe checkpoint.
- The M0 spike remains technical probe code under `godot_spike/`; do not extend it into full gameplay architecture.
- Visual direction: grounded stylized realism; old Hanoi collective-housing alley; worn plaster/concrete/wood/metal; restrained cinematic practical lighting; believable food props; humor through character and situations.
- 3D maturity gates: Graybox → Whitebox → Proxy Assets → First Art Pass → Final Assets → Final Environment Art Pass → Polish → QA.
- UI maturity gates: Placeholder → Wireframe → Visual Design → Functional UI → UI Polish.
- No mass production of final assets before owner acceptance of a representative visual benchmark.
- Money shown in the slice must come from authoritative test transactions and be labeled provisional where economy values remain open.
- The first slice does not require all 100 days, debt scheduling, save/load, supplier/spoilage simulation, shop expansion, optional waiter automation, all story events, or a complete alley.
- Payment is recorded exactly once; an item/bowl has one authoritative owner/location; invalid actions do not mutate state; inventory cannot silently go negative; UI must not invent or duplicate game state.
- Every completion claim must include the changed artifact/file list, the command or manual check performed, the observed result, and known limitations.

## Review Focus

1. **Invalid placement / item ownership:** invalid target, target disappearing, rapid repeated interaction, and re-pickup after placement must not lose, duplicate, teleport, or corrupt the bowl.
2. **Duplicate payment:** repeat the serve/confirm action or close the day after payment; revenue must remain exactly one transaction per completed order.
3. **Inventory conservation:** missing ingredient, canceled bowl, repeated station activation, and invalid recipe order must not create negative stock or consume the same ingredient twice.
4. **Order and destination mismatch:** a completed bowl delivered to the wrong table must not complete the order or trigger payment.
5. **UI/data consistency:** summary values must reconcile to the transaction ledger and inventory state; empty/error states must remain readable and actionable.
6. **Pause/close edge cases:** pausing stops customer timers; closing stops new orders and does not leave the player in an unfinishable state.
7. **Art/readability/performance:** high-detail props, steam and lighting must not hide interaction targets or cause unacceptable runtime performance; final thresholds must be agreed after identifying target hardware.

---

## Task 0: Close out the M0 technical spike and make an engine decision

**Files / evidence:**
- Existing: `godot_spike/project.godot`
- Existing: `godot_spike/scenes/main.tscn`
- Existing: `godot_spike/scripts/player_controller.gd`
- Existing: `godot_spike/scripts/interactive_bowl.gd`
- Existing: `godot_spike/scripts/placement_zone.gd`
- Existing: `godot_spike/tests/test_interaction_contract.gd`
- Existing: `godot_spike/TEST_PLAN.md`
- Update after actual manual run: `docs/TECHNICAL_DIRECTION_REVIEW_M0.md`, `docs/OWNER_REVIEW_M0.md`, Linear DUC-47 and DUC-48.

**Interfaces:**
- Consumes: current spike branch `spike/godot4-m0`, PR #1, CI run 39617160306.
- Produces: owner-readable evidence pack and an explicit engine recommendation; no production gameplay architecture.

- [ ] **Step 1: Confirm automated evidence**
  - Check the latest workflow run for `spike/godot4-m0`.
  - Current observed baseline on 2026-10-21: run 39617160306 succeeded; import/parse, interaction contract tests, Linux desktop export, and artifact upload all succeeded.
  - Artifact: `pho-dau-ngo-linux-debug` (run 39617160306). Do not interpret CI success as proof of mouse feel or visual usability.

- [ ] **Step 2: Run the manual checklist on the owner’s PC**
  - Open the artifact or project with Godot 4.4.1.
  - Follow every item in `godot_spike/TEST_PLAN.md`: startup, WASD, mouse look, collision, focus feedback, pickup, valid placement, invalid placement, repeated pick/place, Esc and mouse recapture.
  - Record pass/fail and capture at least one screenshot; if a check fails, create a reproducible defect before fixing it.
  - Expected: all listed interactions work without parser/runtime errors and the held bowl remains intact after invalid placement.

- [ ] **Step 3: Resolve PR #1 integration status**
  - Compare `spike/godot4-m0` with updated `main`; the art/UI specification changed `docs/DECISION_LOG.md` after the spike branch was created.
  - Resolve the decision-log divergence without dropping D-015–D-017 or overwriting spike code.
  - Re-run the workflow after resolution. Do not merge until PR is mergeable and checks pass.

- [ ] **Step 4: Complete DUC-47 comparison**
  - Compare (A) Phaser as a throwaway 2D gameplay reference, (B) Godot 4 for the intended 3D PC game, and (C) one credible alternative only if evidence suggests Godot is unsuitable.
  - Include testing ergonomics, desktop export, first-person interaction, asset pipeline, developer familiarity, maintenance and scope cost.
  - Do not compare based on preference alone.

- [ ] **Step 5: Present an owner decision**
  - Provide links to the CI run, downloadable artifact, screenshot/manual checklist, unresolved issues, and a concise recommendation.
  - Owner chooses: approve Godot for production, request a bounded follow-up probe, or reject it and compare another engine.
  - **Gate:** all product implementation tasks remain blocked until the owner records the engine decision.

---

## Task 1: Create the Visual Bible and asset production rules

**Files:**
- Create: `docs/art/VISUAL_BIBLE.md`
- Create: `docs/art/ASSET_REGISTER.md`
- Reference: `docs/VERTICAL_SLICE_AND_ART_UI_PIPELINE_SPEC.md`

**Interfaces:**
- Consumes: approved grounded-stylized-realism direction and GDD v1.2.
- Produces: visual rules and an asset register that 3D work can follow without guessing.

- [ ] **Step 1: Define the visual pillars**
  - Document old Hanoi collective-housing alley cues, materials, wear/dirt rules, color relationships, lighting mood, visual density, camera-distance readability and what must not look generic.
  - Separate fixed principles from open choices; do not claim historical accuracy without references.

- [ ] **Step 2: Build a reference board**
  - Group references into architecture, stall/kitchen, food/props, lighting/weather and typography/UI.
  - Record source URL, creator/source, intended use and rights/licensing status for each reference.
  - Use references as art direction, not as permission to copy a protected asset.

- [ ] **Step 3: Specify palette/material/lighting studies**
  - Define provisional palette swatches and material examples for aged plaster, concrete, wood, used metal, ceramic and food.
  - Define a small lighting test scene and intended focal hierarchy; do not lock performance budgets before target hardware is agreed.

- [ ] **Step 4: Define asset standards**
  - Specify naming, scale units, pivot/orientation, collision policy, texture/material conventions, LOD/optimization triggers, file formats, import checks and license/provenance fields.
  - Keep the asset register as the source of truth for status and provenance.

- [ ] **Step 5: Review**
  - Deliver one concise Visual Bible and one asset register.
  - **Gate G0:** owner approves the representative direction before final asset mass production.

---

## Task 2: Create the UI/UX wireframes and reusable UI rules

**Files:**
- Create: `docs/ui/UI_SPEC.md`
- Create: `docs/ui/UI_COMPONENTS.md`
- Design artifact: Figma moodboard/wireframes/UI kit (link recorded in the documents once created).

**Interfaces:**
- Consumes: the approved visual direction, the slice’s actual player decisions, and the data contracts from gameplay tasks.
- Produces: placeholder/wireframe and visual design rules; no fake game data.

- [ ] **Step 1: Map the minimum screens**
  - In-game interaction prompt/HUD.
  - Order/target feedback for the serving path.
  - One end-of-day summary/ledger screen backed by test transactions.
  - Pause/settings only to the extent needed for a usable test build.
  - Explicitly defer full inventory, deep settings, complete narrative menus and all future screens.

- [ ] **Step 2: Draw wireframes before visual styling**
  - Define information hierarchy, navigation, mouse/keyboard focus order, empty/error/success states and when the player can dismiss a panel.
  - **Test:** walk through the representative day using only wireframes; every required action and essential value must be findable.

- [ ] **Step 3: Define reusable visual components**
  - Typography roles, spacing, palette usage, panel styles, buttons, icons, focus/hover/pressed/disabled states and short Vietnamese copy rules.
  - Avoid decorative HUD elements that obscure interactable props.

- [ ] **Step 4: Review**
  - Deliver linked wireframes and UI rules.
  - **Gate G4:** owner approves the representative screens before full visual implementation.

---

## Task 3: Create the clean production project (conditional on engine selection)

**Completed:** Godot 4 was selected by the owner on 2026-10-22. The clean production scaffold is merged under `game/`; the M0 spike remains preserved under `godot_spike/`.

**Conditional Godot files:**
- Create: `game/project.godot`
- Create: `game/README.md`
- Create: `game/scenes/main/main.tscn`
- Create: `game/tests/run_all.gd`
- Create: `.github/workflows/game-ci.yml`

**Interfaces:**
- Consumes: approved engine decision and setup requirements.
- Produces: clean production project, separate from `godot_spike/`, with a reproducible import/test/build command.

- [ ] **Step 1: Write the project smoke test first**
  - Test the project can load its main scene and that the test runner exits nonzero on failure.
  - Expected before implementation: test fails because the production project/scene is absent.

- [ ] **Step 2: Create minimal project scaffold**
  - Set the selected engine version, main scene, input actions, renderer choice and ignore rules.
  - Keep spike code out of the production namespace; port only reviewed concepts, not files wholesale.

- [ ] **Step 3: Add CI**
  - Import/parse project, run the test harness, export the chosen desktop target, upload build artifact.
  - Use the same pinned engine version locally and in CI.

- [ ] **Step 4: Verify**
  - Run the exact commands recorded in `game/README.md`.
  - Expected: clean checkout can import, run tests and export; no untracked local dependency is required.

---

## Task 4: Build the graybox/whitebox and interaction foundation

**Conditional Godot files:**
- Create: `game/scenes/world/alley_graybox.tscn`
- Create: `game/scenes/player/player.tscn`
- Create: `game/scenes/stall/pho_stall.tscn`
- Create: `game/scenes/stations/bowl_station.tscn`
- Create: `game/scenes/tables/customer_table.tscn`
- Create: `game/scripts/player/player_controller.gd`
- Create: `game/scripts/interaction/interaction_controller.gd`
- Create: `game/tests/test_graybox_contract.gd`
- Create: `game/tests/test_interaction_contract.gd`

**Interfaces:**
- Player exposes a focused interactable and an interaction result; gameplay objects own their state.
- World scene composes the alley, player, stall, stations and one service table.

- [ ] **Step 1: Test the graybox contract**
  - Assert required stations/table exist, interaction targets are reachable, and the player scene is present.
  - Add explicit invalid-target and out-of-range cases.

- [ ] **Step 2: Implement primitive geometry**
  - Use cubes, cylinders, planes and simple collision only.
  - No final textures, decorative set dressing or high-detail modeling at this stage.

- [ ] **Step 3: Validate scale and movement**
  - Check counter height, aisle clearance, camera height, collision, reach and the carry path from station to table.
  - **Gate G1:** owner accepts the graybox/whitebox in first-person view before proxy/detail work expands.

- [ ] **Step 4: Add recognizable proxy assets**
  - Replace only gameplay-critical primitives with low-detail recognizable shapes: counter, soup pot, bowl, table and chair.
  - **Gate G2:** silhouettes and interaction affordances are understandable from the player camera.

---

## Task 5: Implement the authoritative bowl and kitchen state model

**Conditional Godot files:**
- Create: `game/scripts/items/bowl_state.gd`
- Create: `game/scripts/items/interactive_bowl.gd`
- Create: `game/scripts/kitchen/kitchen_station.gd`
- Create: `game/scripts/kitchen/recipe_data.gd`
- Create: `game/scenes/stations/broth_station.tscn`
- Create: `game/scenes/stations/ingredient_station.tscn`
- Create: `game/tests/test_bowl_state.gd`
- Create: `game/tests/test_recipe_validation.gd`

**Interfaces:**
- Bowl has one authoritative state/owner; station actions return explicit success/failure results.
- Recipe data is configuration, not duplicated in UI and station scripts.

- [ ] **Step 1: Write tests for legal transitions**
  - Cover clean/available → held/in-progress → completed/ready-to-serve → dirty.
  - Assert illegal transitions are rejected without mutating state or ownership.

- [ ] **Step 2: Implement bowl ownership and station contract**
  - One bowl cannot be owned by both player and station.
  - A second bowl cannot be picked up if the approved slice allows only one active bowl.

- [ ] **Step 3: Test and implement recipe order**
  - Test missing ingredient, wrong action order, canceled bowl and repeated station activation.
  - Ingredient consumption must be applied through one domain function and never produce negative stock.

- [ ] **Step 4: Verify**
  - Run the bowl and recipe test scripts in headless mode.
  - Expected: all valid transitions pass; invalid transitions preserve state and inventory.

---

## Task 6: Implement orders, customers and correct serving

**Conditional Godot files:**
- Create: `game/scripts/orders/order_data.gd`
- Create: `game/scripts/orders/order_manager.gd`
- Create: `game/scripts/customers/customer_controller.gd`
- Create: `game/scenes/customers/customer.tscn`
- Create: `game/scripts/serving/serving_service.gd`
- Create: `game/tests/test_order_lifecycle.gd`
- Create: `game/tests/test_correct_table_delivery.gd`
- Create: `game/tests/test_payment_once.gd`

**Interfaces:**
- Each order has a stable ID, a recipe/variant, a destination table and an explicit status.
- Serving service accepts a completed bowl and order/table identifiers; it returns success/failure and emits at most one payment event.

- [ ] **Step 1: Test order state transitions**
  - Cover accepted, preparing, ready, served/paid and cleared; reject invalid transitions.
  - Keep the first slice’s recipe/variant set deliberately small.

- [ ] **Step 2: Implement a bounded customer/table loop**
  - Spawn a small, capped group of customers with one order per table.
  - Pause stops waiting timers; closing stops new orders.

- [ ] **Step 3: Test correct and incorrect delivery**
  - Correct bowl to correct table succeeds.
  - Wrong table, incomplete bowl or stale order fails without payment or item loss.

- [ ] **Step 4: Test exactly-once payment**
  - Repeated serve/confirm calls, duplicate signals and day close must not duplicate revenue.
  - **Gate:** tests prove a completed order creates exactly one ledger event.

---

## Task 7: Implement minimal inventory, transaction ledger and end-of-day summary

**Conditional Godot files:**
- Create: `game/scripts/inventory/inventory_service.gd`
- Create: `game/scripts/economy/ledger.gd`
- Create: `game/scripts/economy/day_summary.gd`
- Create: `game/tests/test_inventory_conservation.gd`
- Create: `game/tests/test_ledger_reconciliation.gd`
- Create: `game/tests/test_day_summary.gd`

**Interfaces:**
- Inventory changes and ledger entries are written by domain services, not UI controls.
- The summary reads a snapshot of authoritative day transactions; closing the day does not re-book revenue already recorded.

- [ ] **Step 1: Define minimal test data**
  - Use a small, explicitly provisional starting stock and recipe costs for the slice.
  - Record values as test configuration; do not claim they are final balance values.

- [ ] **Step 2: Test inventory conservation**
  - Purchases add stock, recipe actions consume stock, cancellation/spoilage (only if included) records loss once.
  - Reject an action that would take stock below zero.

- [ ] **Step 3: Test ledger reconciliation**
  - Track opening cash, purchases, revenue and any included provisional operating cost.
  - Debt repayment, calendar, supplier simulation, deposits/prepaid rent, spoilage model and expansion remain out of the first slice unless separately approved.

- [ ] **Step 4: Implement end-of-day summary**
  - Show opening/closing cash, revenue, purchases, consumed stock and explicit unresolved/provisional assumptions.
  - **Test:** summary totals equal the transaction log and inventory snapshot; repeated close does not mutate totals.

---

## Task 8: Implement functional Vietnamese UI

**Conditional Godot files:**
- Create: `game/scenes/ui/hud.tscn`
- Create: `game/scenes/ui/order_ticket.tscn`
- Create: `game/scenes/ui/day_summary.tscn`
- Create: `game/scripts/ui/hud_controller.gd`
- Create: `game/scripts/ui/day_summary_controller.gd`
- Create: `game/tests/test_ui_state_binding.gd`

**Interfaces:**
- UI subscribes to interaction/order/day-summary state and never becomes the source of truth for money, stock or order completion.

- [ ] **Step 1: Implement placeholder HUD**
  - Show current interaction prompt, order/target feedback and concise success/failure messages in Vietnamese.
  - Test that no prompt appears for an out-of-range or blocked target.

- [ ] **Step 2: Implement order ticket**
  - Display only the approved recipe/variant and destination; update from order state.
  - Test that UI cannot mark an order served by itself.

- [ ] **Step 3: Implement ledger/summary screen**
  - Bind displayed numbers to the authoritative summary object.
  - Test a known transaction fixture and assert exact displayed totals.

- [ ] **Step 4: Apply visual design**
  - Use the approved Figma/UI specification; validate hierarchy, contrast, font size, keyboard/mouse navigation, focus/disabled/error states and target resolution.
  - **Gate G4:** owner accepts representative screens before polish.

---

## Task 9: First Art Pass, final asset set and environment integration

**Files / assets:**
- Create or maintain: `docs/art/ASSET_REGISTER.md`
- Create: `assets/environment/` (approved architecture pieces and set dressing)
- Create: `assets/props/` (counter, pot, bowl, table/chair, food props)
- Blender source files and exports are stored using the agreed repository/LFS policy.
- Conditional Godot scenes: `game/scenes/world/alley_final.tscn`, `game/scenes/stall/pho_stall.tscn`.

- [ ] **Step 1: Produce one First Art Pass**
  - Apply the approved palette, material family and lighting to the representative stall corner.
  - Keep the graybox available as a fallback branch/scene.
  - **Gate G3:** owner approves the in-game benchmark before producing the wider final asset set.

- [ ] **Step 2: Finalize gameplay-critical props first**
  - Counter, soup pot, bowl, table/chair and the few visible kitchen stations.
  - Check silhouette, scale, pivot, collision, material response and readability in first-person camera.
  - Do not finalize unseen alley districts or a full character cast in this task.

- [ ] **Step 3: Build final environment art pass**
  - Add only representative old-Hanoi architectural details and restrained set dressing.
  - Use lighting and composition to direct attention to the cooking/service loop.
  - Confirm all imported models and textures have a provenance/license record.

- [ ] **Step 4: Verify in runtime**
  - Review from standing, turning and carrying-bowl viewpoints; check clipping, z-fighting, collision, occlusion, material/lighting consistency and frame-time impact.
  - **Gate G5:** owner accepts the integrated art benchmark in the running game.

---

## Task 10: Polish, audio/feedback and accessibility/readability checks

**Conditional Godot files:**
- Create as needed: `game/scenes/effects/steam_effect.tscn`
- Create as needed: `game/scripts/ui/interaction_feedback.gd`
- Add approved audio under: `assets/audio/`
- Extend: relevant interaction/UI tests and `game/README.md`.

- [ ] **Step 1: Add only high-value feedback**
  - Minimal steam, bowl placement feedback, short interaction sounds and ambient alley bed.
  - Record the source/license for each audio/visual asset.
  - Effects must not hide the bowl, valid target or order prompt.

- [ ] **Step 2: Test readability and interaction**
  - Check all critical actions with keyboard and mouse; verify focus, success, failure, disabled and empty states.
  - Check UI at the agreed PC resolution and window mode.

- [ ] **Step 3: Verify performance**
  - Measure on an explicitly recorded development machine and scene state.
  - Agree the target FPS/quality budget with the owner before treating a numerical threshold as a release requirement.
  - Remove only demonstrated bottlenecks; do not add speculative optimization.

---

## Task 11: Integrate, test and accept one complete playable day

**Files:**
- Update: `game/README.md`
- Create: `game/tests/test_vertical_slice_acceptance.gd`
- Create: `docs/qa/VERTICAL_SLICE_ACCEPTANCE.md`
- Create: `docs/qa/PLAYTEST_RESULTS.md`
- CI workflow: `.github/workflows/game-ci.yml`

**Interfaces:**
- Consumes: completed gameplay, art, UI and ledger components from Tasks 4–10.
- Produces: reproducible desktop build, acceptance evidence, known-limitations list and owner decision.

- [ ] **Step 1: Write the end-to-end acceptance test**
  - Prepare → open → receive a bounded order → assemble the correct bowl → carry it to the correct table → pay once → collect dirty bowl → close shop → view end-of-day summary.
  - Test at least 10 bowls in the slice; do not require the complete 100-day campaign.
  - If the test harness cannot drive a visual interaction, document the manual step rather than pretending it is automated.

- [ ] **Step 2: Run all automated tests**
  - Run the documented headless import, test suite and desktop export commands from a clean checkout.
  - Expected: all tests pass; the build artifact uploads successfully; logs are retained.

- [ ] **Step 3: Manual playtest**
  - Run the complete day from start to summary.
  - Record duration, mis-deliveries, stuck orders, unnecessary actions, stock/cash reconciliation, readability issues and qualitative stress/flow.
  - The 15–25 minute duration is a hypothesis to measure, not a pass condition until the owner approves a target.

- [ ] **Step 4: Run final art/UI QA**
  - Check first-person clipping, collision, UI readability, visual consistency, audio levels, asset rights, missing textures, startup and closing behavior.
  - Every defect has severity, reproduction steps and an owner; blockers are fixed before acceptance.

- [ ] **Step 5: Owner acceptance gate**
  - Provide build/artifact link, commit/PR, CI run, test report, screenshot(s), playtest table and known limitations.
  - **Gate G6:** owner accepts the one-day slice or returns specific issues for revision.
  - Do not mark the whole game or the 100-day campaign complete based on this slice.

---

## Task Dependencies and Execution Order

1. **Task 0 (M0 spike evidence + engine decision)** gates all engine-specific production tasks.
2. **Tasks 1 and 2 (Visual Bible + UI specification)** can proceed in parallel with the manual spike review because they are engine-agnostic.
3. **Task 3 (project scaffold)** starts only after the owner selects the engine.
4. **Task 4 (graybox/whitebox)** precedes proxy assets and any final art production.
5. **Tasks 5–7 (bowl/kitchen, orders/serving, inventory/ledger)** are implemented test-first; Task 8 consumes their state contracts.
6. **Task 9 (final art pass)** depends on the graybox/whitebox and owner-approved First Art Pass.
7. **Task 10 (polish)** depends on integrated gameplay, UI and final art.
8. **Task 11 (acceptance)** depends on Tasks 5–10 and a reproducible desktop build.

## Linear Mapping

Existing issues should be reused rather than duplicated:
- M0: DUC-46 baseline, DUC-47 Phaser-vs-3D assessment, DUC-48 Godot spike, DUC-49 economy review.
- M1: DUC-50 foundation, DUC-51 player, DUC-52 interaction; move DUC-63 graybox/blockout to M1.
- M2: DUC-53 bowl ownership, DUC-54 kitchen/recipe.
- M3: DUC-55 orders, DUC-56 customers, DUC-57 serving/payment.
- M4: DUC-58 inventory, DUC-59 ledger.
- M5 calendar/debt/save issues (DUC-60–62) are later-campaign backlog and are not blockers for the first day slice unless the owner changes scope.
- M6: DUC-64 complete-day integration, DUC-65 functional Vietnamese UI; visual/UI foundation tasks are added under the new M0.5 milestone.
- M7: DUC-66 acceptance, DUC-67 playtest, DUC-68 performance/package; add explicit art QA/provenance tasks.

## Self-Review

- **Spec coverage:** the 3D maturity ladder, UI maturity ladder, parallel workstreams, one-day slice, review gates, asset rights, data correctness and release evidence all map to tasks above.
- **Engine uncertainty:** no production code task is authorized before Task 0 ends with an owner engine decision. Godot file paths are conditional, not a final engine selection.
- **Economy uncertainty:** debt/calendar/save, supplier/spoilage and expansion are deferred; slice money is test data and remains labeled provisional.
- **Test focus:** invalid placement/item ownership, wrong table, duplicate payment, inventory conservation, pause/close behavior, UI state binding and end-of-day reconciliation all have explicit tests.
- **Proportion:** the plan defines interfaces and checks but does not prescribe full implementations or add all 100-day content.
- **Owner review gate:** after review, the owner must select an execution method. No implementation begins before that review and the engine decision.

## Execution Handoff

This plan is ready for owner review, not execution. Once approved, choose:
- **Subagent-driven:** separate implementer/reviewer per task and a final whole-branch review.
- **Native:** one implementer follows the plan task-by-task, with a final independent review.

Recommended: **Subagent-driven** for production tasks because gameplay, UI and art integration have multiple failure modes and independent review is valuable. The initial M0 manual spike/engine decision should still be completed first.
