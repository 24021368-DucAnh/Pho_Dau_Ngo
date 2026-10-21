# PHỞ ĐẦU NGÕ — Godot Vertical Slice Architecture v0.1

**Decision:** Godot 4 selected by owner on 2026-10-22.  
**Status:** Initial production architecture and scaffold; runtime test required before expanding gameplay.

## Goals
- Keep production project separate from the M0 spike.
- Keep the first slice small, testable and deterministic.
- Use explicit ownership: world objects own their physical state; controllers own interactions; future order/economy services own their domain state; UI only presents snapshots and emits commands.
- Build in dependency order and avoid implementing the full 100-day campaign before the slice is accepted.

## Project layout
- `game/project.godot` — official Godot project settings and main scene.
- `game/scenes/main.tscn` — initial graybox world and player composition.
- `game/scripts/player_controller.gd` — first-person input, raycast focus, pickup/place command handling and prompt presentation.
- `game/scripts/interactive_bowl.gd` — authoritative bowl state (AVAILABLE, HELD, PLACED) and placement validation.
- `game/scripts/placement_zone.gd` — authoritative target marker transform.
- `game/tests/test_interaction_contract.gd` — deterministic contract tests for scene composition and bowl-state transitions.
- `godot_spike/` — preserved M0 technical probe and historical evidence; not the production project root.

## Ownership contracts
1. Player controller may request pickup/place, but bowl state is mutated only by the bowl's API.
2. Placement zone provides a target transform; it does not decide economy/order effects.
3. Invalid placement must preserve the held state, transform and reference.
4. UI is a view only. It must not change money, inventory, recipe, order or ledger state directly.
5. Future domain systems must be separate from presentation scenes and communicate through typed methods/signals.
6. Future payment, ingredient consumption, item ownership and ledger operations require deterministic tests and exactly-once semantics.

## Current scaffold boundary
Included: Godot project, graybox floor/wall/table/bowl/placement zone, first-person movement/collision, focus feedback, pickup/carry/place, invalid-placement rejection, test runner and Linux export CI.

Not included yet: full alley art, customers, recipes, kitchen workflow, orders, serving/payment, stock/economy, day controller, ledger summary, saving, campaign calendar, debt simulation, suppliers, expansion or waiter.

## Implementation order
1. Scaffold and validate this project in CI and on owner PC.
2. Expand graybox to a compact old-Hanoi alley/stall footprint and verify camera/workstation dimensions.
3. Add station interactions and recipe state.
4. Add order/customer/serving flow with exactly-once payment.
5. Add inventory and transaction ledger with deterministic tests.
6. Add ledger-backed end-of-day summary.
7. Integrate first art pass, then final assets, polish, QA and packaging.

## Acceptance gates
- CI imports/parses project, runs interaction tests and exports a desktop artifact.
- Owner verifies runtime movement, collisions, bowl interaction and placement in the production project (not only the M0 spike).
- Before expanding gameplay, review the first production graybox and verify the 1280×720 UI assumptions.
- Do not add deferred campaign systems until the first slice reaches the end-of-day summary and is accepted.
