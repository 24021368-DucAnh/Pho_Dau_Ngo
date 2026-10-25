# PHỞ ĐẦU NGÕ — Godot Vertical Slice

This is the official Godot 4 project for the first vertical slice. The M0 probe remains preserved separately in `godot_spike/`.

## Open

Open `game/project.godot` in Godot 4.4.1 Standard. Press F5 to run the project.

On a fresh checkout, run the editor import once first so global class names register before running test scripts headless:

```bash
godot --headless --editor --path game --quit
```

Without this step, headless test scripts may fail to resolve `class_name` types. That is a cache issue, not a code error.

## Controls

- WASD: move relative to the camera.
- Mouse: look.
- E or left click: pick up/place the bowl, activate the focused kitchen station, or serve.
- Q: cancel preparation of the held bowl. Ingredients already used are treated as waste and are not refunded.
- V: switch the test order's recipe (phở bò tái / phở bò chín).
- C: close the day and show the ledger-derived summary in the HUD.
- Esc: release/capture the mouse.

## Current playable scope

- First-person movement and collision. Player capsule is 1.7 m tall (radius 0.25 m, height 1.2 m); standing eye height is about 1.50 m.
- One fixed test order (`order-001`, `table-1`, default phở bò tái; V switches recipe). Order status flow: MỚI (ACCEPTED) → ĐANG NẤU (PREPARING) → CHỜ GIAO (READY) → ĐÃ PHỤC VỤ (SERVED).
- Kitchen stations on the cart counter: broth pot, noodles tray, raw beef tray, cooked beef tray. Recipe order is **noodles → beef → broth** (see `game/scripts/kitchen/recipe_data.gd`). Garnish and chopsticks are presentation-only, never recipe steps.
- A minimal ingredient inventory with guarded consumption. Out-of-order stations, missing stock and repeated activation are rejected without corrupting bowl state or taking stock below zero.
- Cancelling a partly prepared bowl resets preparation but does not refund consumed ingredients.
- Gameplay bowl renders the modular bowl scene (`game/scenes/art/food/pho_bowl_modular.tscn`): visual layers follow the bowl's real `consumed_ingredients` (noodles, beef, broth; garnish + chopsticks only when all three are present). The old cylinder bowl visual is gone. Bowl collision is unchanged (cylinder r 0.24 m, h 0.12 m); the bowl visual is 0.5 × 0.5 × 0.249 m, so a visual/collider height mismatch is noted in `docs/art/asset-evidence/phase-a-bowl-state-matrix.md` and the depth decision is still open.
- Serving: place a ready bowl on the customer table and aim at it to serve, or use the ShipTable: aiming at its green ShipZone while carrying a ready bowl places **and** serves in one action. Duplicate serves pay once (`sale:<order_id>`, Ledger idempotency).
- Economy: append-only `Ledger` plus `DayController`, wired into the scene and HUD. **Provisional values, not an approved price catalogue (DUC-49 open):** opening cash 100,000; sale price 45,000 per correct serve. Press C to close the day; closing twice changes nothing.
- Real props in the scene (not greybox): customer table v009, broth pot v1 (O-tolab, CC0), ladle v2, tissue box v7, stainless trays on the three food stations (Silver Shield, CC Attribution). The stool file is present but under license review (free for use, do not redistribute as-is) and is flagged for removal from the repo.

## Automated checks

From the `game/` directory, after the one-time editor import above:

```bash
godot --headless --path . -s tests/test_ledger_contract.gd
godot --headless --path . -s tests/test_day_controller.gd
godot --headless --path . -s tests/test_order_lifecycle.gd
godot --headless --path . -s tests/test_recipe_validation.gd
godot --headless --path . -s tests/test_interaction_contract.gd
godot --headless --path . -s tests/test_bowl_visuals_integration.gd
```

CI is configured to export self-contained Linux and Windows desktop artifacts. The last verified CI run (#107) is on an older commit; rerun CI after the recent code changes.

## Known gaps — not in this slice

- M7 manual playtest has not been recorded; gates G5/G6 are not accepted. Headless/domain tests are not a substitute for it.
- Used-bowl handling after serving: a served bowl stays on the ShipTable.
- Save/load, the 100-day campaign, debt schedule, suppliers, spoilage, NPC customers and additional orders.
- Formal Phase A acceptance is still open (the 2026-10-25 temporary close is not final). Still open: v004 contrast re-check in Godot, the intricate scroll pattern, the bowl-depth decision, and bowl source provenance/rights.
- Stool license cleanup is pending (see above).

## Next acceptance gate

M7 manual playtest on `main`: at least 10 bowl cycles including invalid, duplicate and cancelled actions; duplicate serve pays once; C shows revenue = 45,000 × correct serves and a second C changes nothing; props, bowl layers and held-bowl framing reviewed in first person. Record results in `docs/qa/PLAYTEST_RESULTS.md`, fix defects, then owner accepts gates G5/G6. Procedure and gate checklist: `docs/qa/VERTICAL_SLICE_ACCEPTANCE.md` §3 and §5.
