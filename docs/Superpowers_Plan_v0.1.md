# Superpowers Plan — PHỞ ĐẦU NGÕ

## Purpose

Deliver a coherent, playable vertical slice while keeping design decisions explicit and avoiding premature implementation in the wrong engine.

## Workflow

1. **Understand and review:** read the current GDD, project baseline, existing prototype, and Linear issues.
2. **Resolve open decisions:** review economy assumptions and the mismatch between the existing 2D Phaser prototype and the first-person 3D target.
3. **Brainstorm technical direction:** compare viable engines against first-person movement, item interaction, desktop packaging, testing, and scope.
4. **Write the detailed plan:** after an engine is chosen, create a file-by-file plan with interfaces, tests, exact commands, dependencies, acceptance criteria, and rollback notes.
5. **Owner review:** pause for explicit approval of the plan before product code is written.
6. **Implement in small steps:** follow the approved plan, test each meaningful change, review diffs, and report evidence rather than claiming completion without verification.

## Current gate: M0

- Review rent, starting capital, recipe costs/margins, customer throughput, and debt repayment affordability.
- Confirm the GDD baseline and identify unresolved assumptions.
- Assess whether the Phaser prototype has reuse value or should remain a reference prototype.
- Propose a minimal engine spike with explicit acceptance criteria; do not run it before owner approval.

## Non-negotiable gameplay invariants

- Payment is credited exactly once per completed order.
- Each bowl/item has one authoritative owner/location at any time.
- Delivery must match the order and destination table.
- Ingredient consumption and ledger entries are deterministic and auditable.
- Debt installments trigger once on the intended month boundary.
- Save/load does not duplicate money, inventory, orders, or debt charges.

## Scope discipline

- Initial target is a first-person 3D PC/Steam vertical slice.
- The optional waiter is excluded from the initial slice.
- Rent, starting cash, and normal-day duration remain balancing assumptions until reviewed.
- Do not introduce new systems unless they support the core service loop or a stated acceptance criterion.

## Completion evidence

Each issue should report: files changed, behavior added, tests run and results, known limitations, and links to relevant commits/PRs. Do not mark work complete based only on code being written.
