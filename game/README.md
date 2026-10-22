# PHỞ ĐẦU NGÕ — Godot Vertical Slice

This is the official Godot 4 project for the first vertical slice. The M0 probe remains preserved separately in `godot_spike/`.

## Open
Open `game/project.godot` in Godot 4.4.1 Standard or a compatible Godot 4 release. Press F5 to run the production main scene.

For the separate runtime-built art showcase, open `res://scenes/stylized_vertical_slice.tscn` and press F6. The showcase is not the production main scene and has not yet passed owner runtime-art review.

## Controls
- WASD: move relative to the camera.
- Mouse: look.
- E or left click: pick up/place the bowl or activate the focused kitchen station.
- Q: cancel preparation of the held bowl. Ingredients already used are treated as waste and are not refunded.
- Esc: release/capture the mouse.

## Current implemented prototype scope
- First-person movement and collision in a graybox alley.
- One bowl with separate physical ownership and recipe-preparation state.
- Recipe configuration for phở bò tái and phở bò chín, each with three ordered actions: noodles → beef variant → broth.
- Kitchen station validation and minimal ingredient inventory with guarded consumption.
- Invalid station order, missing stock, recipe switching after preparation starts and repeated activation are rejected without corrupting bowl state or taking stock below zero.
- Cancelling a partly prepared bowl resets preparation but does not refund consumed ingredients.
- Domain-level order lifecycle and serving services exist, including wrong-table/incomplete-bowl rejection and duplicate-payment protection; they are not yet integrated into a complete customer-facing playable day.

The geometry and starting stock are test proxies. A full customer spawning/waiting loop, authoritative transaction ledger, inventory-to-ledger accounting, day controller, end-of-day summary, save/load and final integrated art/UI are not yet implemented. Do not treat the domain-level serving service as proof that the complete serving loop is playable.

## Automated checks
From repository root:
```bash
godot --headless --editor --path game --quit
godot --headless --path game --script res://tests/test_interaction_contract.gd
godot --headless --path game --script res://tests/test_recipe_validation.gd
godot --headless --path game --script res://tests/test_order_lifecycle.gd
```

CI is configured to run the interaction, recipe, and order/serving tests and export Linux and Windows desktop artifacts. Confirm the final status for the exact commit before calling the checks passed.

## Next implementation gate
1. Finish automated evidence and run the local first-person smoke checklist.
2. Add authoritative inventory transactions and a ledger with deterministic reconciliation tests.
3. Build an end-of-day summary as a read-only projection of ledger entries.
4. Integrate orders/serving into a complete bounded day and test exactly-once payment.
5. Review the art showcase and UI in runtime before expanding final asset production.

The acceptance checklist is tracked in `docs/qa/VERTICAL_SLICE_ACCEPTANCE.md`.