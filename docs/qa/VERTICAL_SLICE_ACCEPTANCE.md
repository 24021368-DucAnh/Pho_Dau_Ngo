# PHỞ ĐẦU NGÕ — Vertical Slice Acceptance Matrix

**Status:** Working QA checklist; no complete-day acceptance claim yet.  
**Project:** Godot 4.4.1, `game/` production project.  
**Purpose:** Keep automated evidence, local runtime evidence, and owner acceptance separate so a passing import does not get mistaken for a playable vertical slice.

## 1. Evidence rules

- **Automated pass** means the named CI/test command completed successfully for the recorded commit.
- **Runtime pass** requires opening the project in Godot and observing the behavior in a running scene.
- **Owner accepted** means the owner reviewed the evidence and explicitly accepted the gate.
- Never mark an item complete from source inspection alone when its acceptance depends on feel, readability, visuals, collision, camera framing, or performance.
- Record commit SHA, Godot version, machine/OS for performance checks, and a screenshot or clip for visual/runtime findings.
- The current CI run is tracked separately: [Godot vertical-slice scaffold — run #89](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39835300143). Its last inspected state had import/parse passed while interaction tests were still in progress; later steps were pending. Do not treat that snapshot as a final result.

## 2. Current evidence snapshot

| Area | Evidence available | Status | Next action |
|---|---|---|---|
| Production project import/parse | CI run #89: step completed successfully | Automated pass for that step only | Read final run conclusion when available |
| Interaction contract | Existing `game/tests/test_interaction_contract.gd`; CI step had not completed in last inspection | Pending | Confirm test result; inspect logs if the runner exposes them |
| Recipe validation | Existing `game/tests/test_recipe_validation.gd` | Pending final CI evidence | Verify ordered actions, missing stock, recipe lock and cancellation |
| Order lifecycle / serving | Existing `game/tests/test_order_lifecycle.gd` | Pending final CI evidence | Verify wrong table/incomplete bowl rejection and exactly-once payment |
| Desktop exports | Workflow includes Linux and Windows export steps | Not verified for run #89 | Confirm both exports and artifacts |
| Aged-aluminum pot | First art pass in `game/scenes/stylized_vertical_slice.tscn` via `game/scripts/art/stylized_vertical_slice.gd` | Source present; runtime review open | Inspect from showcase camera and gameplay-relevant angles |
| Production gameplay scene | `game/scenes/main.tscn` remains the configured main scene | Existing graybox/prototype scope | Do not imply the art showcase is integrated into the gameplay scene |
| End-of-day ledger/summary | Not present in current production file inventory | Not implemented | Complete domain ledger/summary before end-to-end day acceptance |
| Owner visual approval | No runtime screenshot or owner approval attached here | Open | Capture evidence and review before advancing art maturity |

## 3. Manual gameplay smoke test

Run from a clean checkout using Godot 4.4.1 Standard.

1. Open `game/project.godot`; confirm the project imports without parser/runtime errors.
2. Press F5. Confirm the configured production main scene starts and the player is not stuck in geometry.
3. Test WASD movement, mouse look, collision with floor/walls, Esc release and mouse recapture.
4. Focus the bowl; pick it up once. Confirm it follows the player and cannot be picked up twice.
5. Focus each kitchen station from reachable positions. Verify only the recipe's next action is accepted.
6. Try an out-of-order station and a station with insufficient stock. Confirm the bowl step and stock remain unchanged.
7. Prepare a bowl, cancel with Q, and verify consumed ingredients are not refunded and waste is reported once.
8. Place the bowl in a valid placement zone. Try invalid placement elsewhere; confirm the bowl remains held after rejection.
9. When serving integration is available, test incomplete bowl, wrong table, wrong recipe, successful delivery and duplicate delivery. Exactly one payment event must be recorded.
10. Record each result as PASS / FAIL / BLOCKED with a short note and screenshot for visual or interaction issues.

## 4. Art showcase review

Run `res://scenes/stylized_vertical_slice.tscn` with F6; do not confuse this with F5 production gameplay.

- [ ] Pot silhouette reads as a practical, used aluminum stockpot at the showcase camera distance.
- [ ] Rim, broth surface, lid, handles and rivets do not visually intersect in an obvious way.
- [ ] Aluminum finish reads as dull metal rather than plastic or polished chrome.
- [ ] Steam is visible but does not obscure the rim, broth or interaction-critical silhouette.
- [ ] Pot does not compete with the bowl and service work area for visual attention.
- [ ] No parser/runtime errors; no obvious particle/material artifacts.
- [ ] Review standing and turning viewpoints in the eventual first-person scene before integration.

**Evidence required:** screenshot(s), commit SHA, Godot version, notes on any overlap/scale/material issue, and owner decision. Until then, status remains **First Art Pass — runtime review pending**.

## 5. Vertical-slice completion gate

Do not declare the first playable day accepted until all of the following are evidenced:

- [ ] Clean import, all automated tests, and both required desktop exports pass on the same recorded commit.
- [ ] One complete loop works: prepare → open/receive order → prepare correct bowl → carry to correct table → serve/pay once → collect/handle used bowl → close day → view ledger-derived summary.
- [ ] At least 10 bowl cycles are exercised in the bounded slice, including invalid actions and duplicate-action cases.
- [ ] UI values reconcile to authoritative inventory/economy/ledger state; no UI script mutates authoritative money or order state.
- [ ] Art and UI are reviewed in the running game, not only as source code or a separate showcase scene.
- [ ] Known limitations, provisional economy values, and any manual-only acceptance steps are documented.
- [ ] Owner explicitly accepts the gameplay, art, UI and desktop-build gates.

## 6. Defect record template

For each failure, record:

- **ID / date:**
- **Commit / Godot version / OS:**
- **Scene and reproduction steps:**
- **Expected vs actual:**
- **Severity:** blocker / major / minor
- **Evidence:** screenshot, clip, log excerpt, or failing test
- **Owner:** implementation / art / UI / environment
- **Resolution commit and retest result:**
