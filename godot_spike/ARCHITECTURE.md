# Spike Architecture

## Scene ownership

- **Main** composes the graybox world and exactly one bowl plus one placement zone.
- **Player** owns first-person input, mouse look, movement, raycast focus feedback, and the currently held bowl reference.
- **InteractiveBowl** owns the authoritative bowl state and its collision availability.
- **PlacementZone** owns the placement marker transform; it does not decide whether placement is allowed.
- **HUD** reports the current interaction prompt and the last action result.

## Interaction contract

The bowl state is one of AVAILABLE, HELD, or PLACED.

1. The raycast sees the bowl on collision layer 2 when the bowl is not held.
2. Picking up the bowl moves it to HELD and disables its collision.
3. While carrying the bowl, the player enables the placement zone on collision layer 2 so the zone is raycast-visible.
4. A valid placement is accepted only when the target is a PlacementZone. The bowl snaps to its marker, becomes PLACED, and restores collision.
5. An invalid target returns false without changing the bowl's state, transform, or held reference.
6. After a successful placement, the placement zone is removed from the raycast layer; the placed bowl can be picked up again.

The interaction controller is intentionally small. There is no order, inventory, cash, debt, save/load, customer AI, or production-ready gameplay architecture in this spike.

## Verification

- TEST_PLAN.md records automated and manual acceptance.
- tests/test_interaction_contract.gd verifies scene composition, placement-zone raycast gating, state transitions, invalid-placement invariants, collision toggling, and repeated pick/place.
- .github/workflows/godot-spike.yml imports the project, runs the contract test, exports a Linux debug build, and uploads the artifact.
