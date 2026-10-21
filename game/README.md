# PHỞ ĐẦU NGÕ — Godot Vertical Slice

This is the official Godot 4 project for the first vertical slice. The M0 probe remains preserved separately in `godot_spike/`.

## Open
Open `game/project.godot` in Godot 4.4.1 Standard or a compatible Godot 4 release. Press F5 to run the project.

## Controls
- WASD: move relative to the camera.
- Mouse: look.
- E or left click: pick up/place the bowl.
- Esc: release/capture the mouse.

## Current scope
The current build is a graybox scaffold for movement, collision, focus feedback and one bowl-placement interaction. It is not yet the full pho-stall loop. The floor, wall, table, bowl and green placement area are proxies.

## Automated checks
From repository root:
```bash
godot --headless --editor --path game --quit
godot --headless --path game --script res://tests/test_interaction_contract.gd
```
The GitHub Actions workflow exports a Linux desktop build as `pho-dau-ngo-godot-linux`.

## Scope guardrail
No customers, recipes, money, debt, stock, saving, campaign calendar, suppliers, expansion or waiter are included yet. Next is owner PC verification of this separate production project, followed by graybox refinement.
