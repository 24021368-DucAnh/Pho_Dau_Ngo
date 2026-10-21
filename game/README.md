# PHỞ ĐẦU NGÕ — Godot Vertical Slice

This is the official Godot 4 project for the first vertical slice. The M0 probe remains preserved separately in `godot_spike/`.

## Open
Open `game/project.godot` in Godot 4.4.1 Standard or a compatible Godot 4 release. Press F5 to run the project.

## Controls
- WASD: move relative to the camera.
- Mouse: look.
- E or left click: pick up/place the bowl or activate the focused kitchen station.
- Q: cancel preparation of the held bowl. Ingredients already used are treated as waste and are not refunded.
- Esc: release/capture the mouse.

## Current playable scope
- First-person movement and collision.
- Graybox alley walls, pho cart, worktable and customer stool proxy.
- One bowl with separate physical ownership and recipe-preparation state.
- Three ordered kitchen actions for the provisional phở bò recipe: broth → noodles → beef.
- A minimal ingredient inventory with guarded consumption.
- Invalid station order, missing stock and repeated activation are rejected without corrupting bowl state or taking stock below zero.
- Cancelling a partly prepared bowl resets preparation but does not refund consumed ingredients.

The geometry and starting stock are test proxies. The economy, customer/order loop, serving/payment, ledger, day controller, save/load and final art are not implemented yet.

## Automated checks
From repository root:
```bash
godot --headless --editor --path game --quit
godot --headless --path game --script res://tests/test_interaction_contract.gd
godot --headless --path game --script res://tests/test_recipe_validation.gd
```
CI also exports self-contained Linux and Windows desktop artifacts.

## Next acceptance gate
Run the production project on PC and verify that all three stations can be focused and activated from first person, in the correct order, and that Q cancels a bowl without refunding ingredients. Then continue to customer/order/serving logic.
