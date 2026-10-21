# Decision Log — PHỞ ĐẦU NGÕ

Record decisions and assumptions here. A proposal is not an approved decision unless the owner explicitly approves it.

## Open decisions

| ID | Topic | Current position | Status | Next action |
|---|---|---|---|---|
| D-001 | Product format | First-person 3D PC/Steam is the working target in GDD v1.2 | Awaiting owner baseline approval | Review in M0 |
| D-002 | Existing Phaser prototype | Existing prototype is TypeScript + Phaser 3 + Vite, 2D browser-based; reuse value is unknown | Open | Complete DUC-47 assessment |
| D-003 | Engine choice | No engine selected for implementation | Open | Compare options, then propose a minimal technical spike |
| D-004 | Room rent | 500,000 VND per 10-day game month | Balancing assumption | Review with economy model in DUC-49 |
| D-005 | Stall rent | Approximately 833,333 VND per game month | Balancing assumption | Review with economy model in DUC-49 |
| D-006 | Normal day duration | 15–25 minutes | Playtest target, not locked | Measure during M7 playtest |
| D-007 | Debt schedule | 18,000,000 VND principal; nine payments of 2,000,000 VND at the ends of game months 2–10; no automatic interest | Owner-approved design rule (2026-10-21); affordability still requires simulation | Preserve schedule; validate cash-flow in DUC-49 and baseline in DUC-46 |
| D-008 | Optional waiter | Excluded from the initial vertical slice | Working scope boundary | Revisit only if owner changes scope |
| D-009 | Repayment-month sales target | 20 bowls/day average target from first repayment month; 17 bowls/day stress case | Owner-approved provisional playtest targets (2026-10-21), not guaranteed sales or locked balance | Validate with deterministic economy simulation and playtests |
| D-010 | Shop expansion | Optional; opening requires opening cost plus 1,500,000 VND reserve remaining available | Owner-approved provisional gate (2026-10-21) | Simulate cumulative cash and cost shocks before implementing unlock |

## Owner-approved provisional economy decisions — 2026-10-21

- Retain the principal debt of 18,000,000 VND and the nine 2,000,000 VND installments at the ends of game months 2–10; do not add automatic interest.
- Use 20 bowls/day as a provisional average sales target to test from the first repayment month, and 17 bowls/day as a stress case. These are playtest targets, not a guarantee that customers will buy this volume and not values to hard-code as forced sales.
- Keep shop expansion optional. The player must be able to cover the opening cost and retain a 1,500,000 VND reserve after the decision.
- These approvals resolve only the three economy decisions above. The complete GDD baseline, remaining economy details, and engine direction are still pending owner review.

## Confirmed workflow constraints

- A game month contains 10 game days; the planned campaign spans 100 game days.
- Do not start product code before the owner approves the baseline and technical direction.
- After engine selection, create an engine-specific file-by-file implementation plan and obtain owner approval before coding.
- Payment, item ownership, ingredient consumption, debt scheduling, and save/load must have deterministic tests.

## Change protocol

1. State the problem and evidence.
2. Describe the proposed change and impact on scope, schedule, architecture, and economy.
3. Mark the proposal as open until the owner approves it.
4. Update this log, the baseline document, and relevant Linear issues after approval.
