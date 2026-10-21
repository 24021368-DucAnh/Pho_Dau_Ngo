# PHỞ ĐẦU NGÕ — Godot Vertical Slice Architecture v0.2

**Decision:** Godot 4 selected by owner on 2026-10-22.  
**Status:** Production scaffold passed owner-reported PC verification (10/10). Kitchen station/recipe foundation is the current review checkpoint.

## Goals
- Keep production project separate from the M0 spike.
- Keep the first slice small, testable and deterministic.
- Use explicit ownership: world objects own their physical state; controllers request interactions; recipe data owns step order; inventory owns stock; future order/economy services own their domain state; UI only presents snapshots and emits commands.
- Build in dependency order and avoid implementing the full 100-day campaign before the slice is accepted.

## Project layout
- `game/project.godot` — official Godot project settings and main scene.
- `game/scenes/main.tscn` — graybox world, player, cart, customer stool proxy and three kitchen station targets.
- `game/scripts/player_controller.gd` — first-person input, focus, bowl handling, station commands and prompt presentation.
- `game/scripts/interactive_bowl.gd` — authoritative physical ownership state plus separate recipe preparation state.
- `game/scripts/kitchen/recipe_data.gd` and `game/data/recipes/pho_bo.tres` — ordered, data-driven recipe steps.
- `game/scripts/kitchen/kitchen_station.gd` — validates station/action order and delegates ingredient consumption.
- `game/scripts/inventory/inventory_service.gd` — authoritative stock counts and guarded consumption.
- `game/scripts/placement_zone.gd` — authoritative target marker transform.
- `game/tests/test_interaction_contract.gd` — scene composition and bowl physical-state contract.
- `game/tests/test_recipe_validation.gd` — recipe order, consumption, cancellation, repeated-action and shortage contract.
- `godot_spike/` — preserved M0 technical probe and historical evidence; not the production project root.

## Ownership contracts
1. Player controller may request pickup, place, cancel or station actions, but bowl state is mutated only through the bowl API.
2. Placement zone provides a target transform; it does not decide recipe/economy effects.
3. Invalid placement or station action must preserve bowl state and must not consume ingredients.
4. Recipe order lives in `RecipeData`; station scripts do not duplicate the recipe sequence.
5. Inventory is the sole authority for available ingredient counts. Consumption is positive-only and cannot make stock negative.
6. Cancelling a partially prepared bowl resets its preparation state but does not refund consumed ingredients; returned waste details are available for later ledger integration.
7. UI is a view only. It must not change money, inventory, recipe, order or ledger state directly.
8. Future payment, item ownership, ingredient consumption and ledger operations require deterministic tests and exactly-once semantics.

## Current scaffold boundary
Included: Godot project, graybox alley walls/cart/worktable/stool, first-person movement/collision, focus feedback, pickup/carry/place, three station interaction targets, one ordered provisional phở bò recipe, minimal stock service, cancel-preparation behavior, deterministic contract tests, CI import/test/Linux+Windows export.

Not included yet: customer/order loop, serving/payment, authoritative transaction ledger, day controller/summary, saving, campaign calendar, debt simulation, suppliers, expansion, waiter or final art.

## Implementation order
1. Production scaffold and owner PC movement/interaction verification — complete.
2. Kitchen stations and recipe preparation state — current review checkpoint.
3. Customers/orders/serving with correct destination and exactly-once payment.
4. Inventory and transaction ledger reconciliation.
5. Ledger-backed end-of-day summary.
6. First Art Pass, final gameplay-critical assets, polish, QA and packaging.

## Acceptance gates
- CI imports/parses project, runs interaction and recipe contract tests, and exports self-contained desktop artifacts.
- Owner has reported the production scaffold's 10 movement/interaction checks PASS.
- Owner must verify the new kitchen stations, recipe order, stock shortage and Q-cancel behavior on PC before order/customer/serving logic expands.
- Do not add deferred campaign systems until the first slice reaches the end-of-day summary and is accepted.
