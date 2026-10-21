# Decision Log — PHỞ ĐẦU NGÕ

Record decisions and assumptions here. A proposal is not an approved decision unless the owner explicitly approves it.

## Decision register — approved decisions and open items

| ID | Topic | Current position | Status | Next action |
|---|---|---|---|---|
| D-001 | Product format | GDD v1.2 approved as the working baseline: first-person 3D PC/Steam, core loop, narrative premise, and 100-day campaign | Owner-approved working baseline (2026-10-21); unmeasured economy values remain provisional | Use as product scope for the Godot 4 spike; revisit only through explicit change control |
| D-002 | Existing Phaser prototype | Existing prototype is TypeScript + Phaser 3 + Vite, 2D browser-based; reuse value is unknown | Open | Complete DUC-47 assessment |
| D-003 | Engine choice | Godot 4 is the first candidate for a reversible technical spike; final engine remains undecided | Spike scope owner-approved (2026-10-21); final engine selection open | Run the approved probe and decide from evidence |
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
| D-014 | Engine candidate | Godot 4 is the first candidate for a reversible technical spike; no final engine selection yet | Owner-approved spike scope (2026-10-21) | Execute DUC-48 and submit results for engine decision |

## Owner-approved provisional economy decisions — 2026-10-21

- Retain the principal debt of 18,000,000 VND and the nine 2,000,000 VND installments at the ends of game months 2–10; do not add automatic interest.
- Use 20 bowls/day as a provisional average sales target to test from the first repayment month, and 17 bowls/day as a stress case. These are playtest targets, not a guarantee that customers will buy this volume and not values to hard-code as forced sales.
- Keep shop expansion optional. The player must be able to cover the opening cost and retain a 1,500,000 VND reserve after the decision.
- On 2026-10-21, the owner also approved GDD v1.2 as the working product baseline and separately approved the narrow Godot 4 technical spike. These approvals do not lock unmeasured economy assumptions, select the final engine, or authorize full gameplay production.

## Confirmed workflow constraints

- A game month contains 10 game days; the planned campaign spans 100 game days.
- The working product baseline is approved. The Godot 4 spike is approved as a technical probe only; do not expand it into full gameplay production.
- After the spike, recommend an engine based on evidence. Before full gameplay production, create an engine-specific file-by-file implementation plan and obtain owner approval.
- Payment, item ownership, ingredient consumption, debt scheduling, and save/load must have deterministic tests.

## Change protocol

1. State the problem and evidence.
2. Describe the proposed change and impact on scope, schedule, architecture, and economy.
3. Mark the proposal as open until the owner approves it.
4. Update this log, the baseline document, and relevant Linear issues after approval.
