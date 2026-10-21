# PHỞ ĐẦU NGÕ — Godot 4 M0 Spike

This is a deliberately small technical probe for the owner-approved M0 scope. It is **not** the full game and does not select Godot as the final engine.

## Requirements

- Godot 4.4.1 (the CI version) or a compatible Godot 4 release.
- Desktop input: keyboard and mouse.

## Run

From the repository root:

```bash
godot --path godot_spike
```

Or open `godot_spike/project.godot` in the Godot editor and press **F6** for the main scene or **F5** for the project.

## Controls

- **W / A / S / D** — move.
- **Mouse** — look around.
- **E** or **left click** — pick up the bowl or attempt to place it.
- **Esc** — release/capture the mouse.

The green translucent area on the table is the only valid placement zone. Trying to place the bowl elsewhere must leave it in the player's hands and show a rejection message.

## Automated checks

From the repository root:

```bash
godot --headless --editor --path godot_spike --quit
godot --headless --path godot_spike --script res://tests/test_interaction_contract.gd
```

The pull request workflow runs the same checks and attempts a Linux desktop debug export. If CI succeeds, its `pho-dau-ngo-linux-debug` artifact is the desktop build for manual review.

## Scope boundary

Included: one graybox room, first-person movement and collision, raycast focus feedback, one bowl, one valid placement zone, invalid-placement rejection, test runner, and Linux export attempt.

Excluded: customers, orders, recipes, inventory economy, debt, save/load, narrative events, final art/audio, optimization, and production architecture.
