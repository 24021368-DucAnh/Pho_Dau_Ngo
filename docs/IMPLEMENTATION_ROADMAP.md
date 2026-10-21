# Implementation Roadmap — PHỞ ĐẦU NGÕ

**Status:** Planning; all milestones remain gated by M0 and owner review.  
**Source of truth for task status:** [Linear project](https://linear.app/ducanh/project/pho-djau-ngo-vertical-slice-098596fd5d5a)

## Milestones

| Milestone | Outcome | Gate |
|---|---|---|
| M0 — Baseline & technical decisions | Review GDD/economy, assess 2D-vs-3D strategy, select engine | Owner approves baseline and technical probe |
| M1 — 3D foundation & player controls | Desktop build, first-person movement, collision, look-at interaction | Engine-specific implementation plan approved |
| M2 — Kitchen & cooking interactions | Bowl/item ownership, ingredient stations, broth/cooking states | Item-state invariants tested |
| M3 — Customers, orders & serving | Order tickets, customer wait, table delivery, one-time payment, dirty bowls | End-to-end service path works |
| M4 — Inventory & ledger | Recipe-based consumption and transaction reconciliation | Economy invariants tested |
| M5 — Calendar, debt & save | Ten-day game months, debt schedule, safe save/load | No duplicate charges or state duplication |
| M6 — Vertical-slice integration | Hanoi alley/stall blockout, full day loop, Vietnamese UI | A complete playable day is possible |
| M7 — QA, pacing & packaging | Acceptance tests, playtest metrics, performance and desktop package | Owner reviews evidence and release readiness |

## M0 work order

1. **DUC-49 — Economy review:** assess rent, starting capital, ingredient costs, margins, and ability to repay principal.
2. **DUC-46 — Baseline review:** approve GDD v1.2 and explicitly list any open assumptions.
3. **DUC-47 — Architecture assessment:** evaluate the current Phaser 2D prototype against the first-person 3D PC/Steam target.
4. **DUC-48 — Engine spike proposal:** propose a minimal, reversible test for first-person movement/interactions. Do not run the spike until the owner approves its question and acceptance criteria.

## Implementation rule

Do not begin product implementation just because the repository exists. After the engine decision, write a file-by-file implementation plan for that engine, including:

- Intended file/module changes.
- Public interfaces and ownership of state.
- Test cases and exact test commands.
- Acceptance criteria and failure cases.
- Risks, rollback strategy, and explicit out-of-scope items.

The owner reviews that plan before code begins. The Linear board contains the full issue breakdown and dependencies.
