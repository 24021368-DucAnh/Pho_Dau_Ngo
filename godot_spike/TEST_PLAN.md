# Godot 4 M0 Spike — Test Plan

## Automated contract checks

Run in Godot 4.4.1 headless mode through GitHub Actions:

1. Import and parse the project.
2. Load the main scene and assert it contains a CharacterBody3D player, one StaticBody3D bowl, and one Area3D placement zone.
3. Verify bowl state transitions: AVAILABLE → HELD → PLACED.
4. Verify an invalid target is rejected, the bowl stays HELD, and its transform is unchanged.
5. Verify valid placement snaps to the placement marker and restores collision.
6. Verify the same bowl can be picked up and placed again without duplication.
7. Export a Linux desktop debug build and upload it as a workflow artifact.

## Manual acceptance checklist

After downloading the CI artifact or opening the project in Godot, verify:

- [ ] Project starts in a visible graybox scene without parser/runtime errors.
- [ ] WASD moves in the direction the camera is facing.
- [ ] Mouse look is smooth and pitch is clamped.
- [ ] The player cannot walk through the floor or back wall.
- [ ] Looking at the bowl changes the prompt/crosshair to the focus color.
- [ ] E and left click both pick up the bowl.
- [ ] The bowl visibly follows the camera while held.
- [ ] Looking at the green placement area changes the prompt to valid-placement feedback.
- [ ] Placing while aimed at the green area snaps the bowl to the marker.
- [ ] Attempting placement away from the green area is rejected; the bowl remains held.
- [ ] Repeated pick/place does not duplicate, delete, or lose the bowl.
- [ ] Esc releases the mouse; clicking captures it again.

## Evidence to attach to DUC-48

- CI run URL and job conclusion.
- Linux export artifact link, if the export succeeds.
- One screenshot showing the graybox and target zone.
- One short recording or manual checklist with pass/fail results.
- Known limitations and recommendation: continue with Godot, run a bounded follow-up, or compare another engine.

## Important limit

Headless CI can validate project parsing, state transitions, and export. It cannot prove that mouse feel, visual placement, or collision feel are good on the owner's PC; those still require a short manual run.
