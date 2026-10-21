# Decision Log — PHỞ ĐẦU NGÕ

Record decisions and assumptions here. A proposal is not an approved decision unless the owner explicitly approves it.

## Decision register — approved decisions and open items

| ID | Topic | Current position | Status | Next action |
|---|---|---|---|---|
| D-001 | Product format | GDD v1.2 approved as the working baseline: first-person 3D PC/Steam, core loop, narrative premise, and 100-day campaign | Owner-approved working baseline (2026-10-21); unmeasured economy values remain provisional | Use as product scope for the Godot 4 spike; revisit only through explicit change control |
| D-002 | Existing Phaser prototype | Existing prototype is TypeScript + Phaser 3 + Vite, 2D browser-based; reuse value is unknown | Open | Complete DUC-47 assessment |
| D-003 | Engine choice | Godot 4 is the official engine for the first-person 3D vertical slice | **Owner-approved (2026-10-22)** after 12/12 reported manual PC checks and passing automated CI; applies to the vertical slice, not an unlimited feature commitment | Use Godot 4 for the production project; maintain the approved vertical-slice scope and verify each deliverable in runtime |
| D-004 | Room rent | 500,000 VND per 10-day game month | Balancing assumption | Review with economy model in DUC-49 |
| D-005 | Stall rent | Approximately 833,333 VND per game month | Balancing assumption | Review with economy model in DUC-49 |
| D-006 | Normal day duration | 15–25 minutes | Playtest target, not locked | Measure during M7 playtest |
| D-007 | Debt schedule | 18,000,000 VND principal; nine payments of 2,000,000 VND at the ends of game months 2–10; no automatic interest | Owner-approved design rule (2026-10-21); affordability still requires simulation | Preserve schedule; validate cash-flow in DUC-49 and baseline in DUC-46 |
| D-008 | Optional waiter | Excluded from the initial vertical slice | Working scope boundary | Revisit only if owner changes scope |
| D-009 | Repayment-month sales target | 20 bowls/day average target from first repayment month; 17 bowls/day stress case | Owner-approved provisional playtest targets (2026-10-21), not guaranteed sales or locked balance | Validate with deterministic economy simulation and playtests |
| D-010 | Shop expansion | Optional; opening requires opening cost plus 1,500,000 VND reserve remaining available | Owner-approved provisional gate (2026-10-21) | Simulate cumulative cash and cost shocks before implementing unlock |
| D-011 | Opening stock | Opening inventory is valued at 300,000 VND, but exact ingredients/quantities and first-day replenishment are not defined | Open | Define stock composition and supplier-order timing in DUC-49 |
| D-012 | Month-boundary payments | Rent/utilities and debt installment timing/order and player warnings are not fully specified | Open | Define deterministic transaction order and low-cash warning in DUC-49 |
| D-013 | Day duration and customer curve | 15–25 minutes/day and customer volumes are targets/hypotheses, not measured outcomes | Open for playtesting | Measure 10/15/20 bowl day variants in M7; do not guarantee sales volume |
| D-014 | Engine validation | Godot 4 M0 spike validated the first-person movement, focus, bowl pickup/placement and desktop export path | Owner-reported manual 12/12 PASS plus passing CI (2026-10-21); integrated after engine decision | Keep the spike as a technical baseline, not as production gameplay architecture |
| D-015 | Production approach | Build a representative vertical slice and validate the complete player experience before scaling production | Owner-approved decision (2026-10-21) | Use the slice as the production quality gate; do not scale content before acceptance |
| D-016 | Production scope strategy | Preserve the full 100-day campaign as the design target, but produce in small approved slices rather than building every system/content upfront | Owner-approved decision (2026-10-21) | Detail the first production slice only after the pipeline specification is approved |
| D-017 | Visual direction | Grounded stylized realism: old Hanoi collective-housing alley, worn materials, restrained cinematic lighting, believable food/props, humor through character and situation | Owner-approved direction (2026-10-21); detailed palette/references remain to be documented | Establish a representative art benchmark before mass asset production |

## Owner-approved provisional economy decisions — 2026-10-21

- Retain the principal debt of 18,000,000 VND and the nine 2,000,000 VND installments at the ends of game months 2–10; do not add automatic interest.
- Use 20 bowls/day as a provisional average sales target to test from the first repayment month, and 17 bowls/day as a stress case. These are playtest targets, not a guarantee that customers will buy this volume and not values to hard-code as forced sales.
- Keep shop expansion optional. The player must be able to cover the opening cost and retain a 1,500,000 VND reserve after the decision.
- On 2026-10-21, the owner also approved GDD v1.2 as the working product baseline and separately approved the narrow Godot 4 technical spike. These approvals do not lock unmeasured economy assumptions, select the final engine, or authorize full gameplay production.

## Confirmed workflow constraints

- A game month contains 10 game days; the planned campaign spans 100 game days.
- The working product baseline and Godot 4 as the official vertical-slice engine are owner-approved. The M0 spike is a validated technical baseline, not a substitute for production architecture; do not expand it into full gameplay without the planned milestones.
- Godot 4 is the owner-selected engine for the vertical slice (2026-10-22). Before engine-dependent gameplay expands beyond the M0 probe, complete the Godot-specific architecture/file-by-file implementation plan and proceed through the approved milestone sequence.
- Payment, item ownership, ingredient consumption, debt scheduling, and save/load must have deterministic tests.

## Change protocol

1. State the problem and evidence.
2. Describe the proposed change and impact on scope, schedule, architecture, and economy.
3. Mark the proposal as open until the owner approves it.
4. Update this log, the baseline document, and relevant Linear issues after approval.


## Owner engine decision — 2026-10-22

The owner explicitly selected **Godot 4 as the official engine for the PHỞ ĐẦU NGÕ vertical slice** after reporting all 12 manual M0 checks as PASS and after the Godot spike's automated CI passed. This supersedes the earlier "candidate / final engine undecided" wording in D-003 and D-014.

Scope of the decision:
- Applies to the current first-person 3D PC vertical slice.
- Authorizes a production Godot project scaffold, graybox environment, and the approved milestone sequence.
- Does not authorize expanding the vertical slice into the full 100-day campaign before the slice is tested and accepted.
- Does not claim the runtime screenshot/video exists; the manual checklist is the current recorded owner evidence.
- Keep economy assumptions provisional and preserve deterministic tests for payments, item ownership, ingredient consumption, debt schedule, and any future save/load work.

Next implementation gate: complete the Godot-specific architecture and project scaffold, then deliver a runnable graybox build for owner testing before adding the full order/customer/economy loop.
