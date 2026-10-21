# Project Baseline — PHỞ ĐẦU NGÕ

**Status:** Working baseline for owner review  
**Version:** Bootstrap snapshot derived from GDD v1.2 planning  
**Important:** This is a concise repository baseline, not a replacement for the complete GDD v1.2 source document. The baseline and open decisions must be approved before implementation.

## 1. Product direction

- **Format:** First-person 3D PC/Steam simulation.
- **Setting:** An old Hanoi collective-apartment neighborhood and a small phở stall.
- **Player character:** Minh, trying to rebuild his life and repay debt after a gambling problem.
- **Design priority:** A small, complete, believable loop with tactile interactions and consistent money/inventory state.

## 2. Core gameplay loop

1. Prepare the stall and ingredients.
2. Receive customer orders, including order-specific requests.
3. Assemble/cook each bowl through station interactions.
4. Carry the finished bowl and deliver it to the correct table.
5. Credit payment exactly once.
6. Collect dirty bowls and wash them in batches.
7. Close the day and reconcile the ledger.

The optional waiter feature is out of the initial vertical-slice scope.

## 3. Campaign and debt assumptions

- A game month contains **10 game days**.
- The planned campaign spans **100 game days**.
- Principal debt is **18,000,000 VND**.
- The intended repayment schedule is **nine principal payments of 2,000,000 VND**, due at the ends of game months 2–10.
- No automatic interest is added to the principal under this schedule.
- Story premise: debt collectors demand 36,000,000 VND based on abusive interest; ông Năm helps mediate, and ông Lâm mentors Minh and lends the cart/equipment.

These are design rules to preserve unless the owner explicitly changes them.

## 4. Values requiring review before implementation

The following are balancing assumptions, not approved final values:

- Room rent: 500,000 VND per 10-day game month.
- Stall rent: approximately 833,333 VND per game month.
- Normal day duration: test target of 15–25 minutes.
- Starting capital, ingredient costs, recipe margins, customer arrival rate, waste, and repayment affordability must be reviewed together.

Do not hard-code these values before the economy review issue is resolved.

## 5. Major technical risk

The earlier repository prototype uses TypeScript, Phaser 3, and Vite, and is a 2D browser prototype. The current product target is a first-person 3D PC/Steam game. This is a material architecture mismatch, not a minor refactor.

Before choosing an engine, compare at least:

- Player movement and first-person camera.
- Interaction and item-handling ergonomics.
- Desktop packaging and iteration speed.
- Testability of gameplay/economy rules.
- Asset workflow and expected scope.
- Reuse value, if any, of the Phaser prototype.

## 6. Quality invariants

- A completed order cannot be paid twice.
- A bowl/item has one clear owner/location at a time.
- A bowl must be delivered to the correct table.
- Ingredient consumption follows the recipe and occurs at a clearly defined gameplay step.
- Ledger totals reconcile with individual transactions.
- A debt installment is charged once, on the correct game-month boundary.
- Save/load must not duplicate cash, inventory, payments, or debt installments.
- Failed/invalid interactions provide visible feedback and do not silently corrupt state.

## 7. Approval gates

- **M0:** Approve GDD baseline and resolve open economy assumptions.
- **M0 technical:** Decide whether to retire/reuse Phaser and select the implementation engine.
- **Implementation planning:** Produce an engine-specific, file-by-file plan with interfaces, tests, and acceptance criteria.
- **Owner review:** Review and approve that plan before product code begins.

## Source documents

- [Canonical GDD v1.2 — Vietnamese](PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md)
- [GDD v1.2 audit and decision log — original](PHO_DAU_NGO_AUDIT_DECISION_LOG_v1_2_Tieng_Viet.md)
- [Current decision register](DECISION_LOG.md)
- [M0 economy review](ECONOMY_REVIEW_M0.md)

## 8. Related work

- [Linear project and milestones](https://linear.app/ducanh/project/pho-djau-ngo-vertical-slice-098596fd5d5a)
- [Linear implementation roadmap](https://linear.app/ducanh/document/pho-djau-ngo-vertical-slice-implementation-roadmap-v01-d4a7ae75bb49)
- [Superpowers planning checklist](Superpowers_Plan_v0.1.md)
