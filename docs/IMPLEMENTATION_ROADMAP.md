# Implementation Roadmap — PHỞ ĐẦU NGÕ

**Status:** Implementation Plan v0.2 approved by owner on 2026-10-22; execution mode is subagent-driven. Godot 4 is the selected vertical-slice engine.  
**Sources of truth:** [Linear project](https://linear.app/ducanh/project/pho-djau-ngo-vertical-slice-098596fd5d5a), [production specification](VERTICAL_SLICE_AND_ART_UI_PIPELINE_SPEC.md), and [detailed implementation plan](superpowers/plans/2026-10-21-pho-dau-ngo-vertical-slice.md).

## Approved production decisions

- Build one representative vertical slice first.
- Preserve the full 100-day campaign as the design target, but produce content incrementally.
- Use grounded stylized realism: old Hanoi collective-housing alley, worn materials, restrained cinematic lighting and believable food/props.
- 3D maturity: Graybox → Whitebox → Proxy Assets → First Art Pass → Final Assets → Final Environment Art Pass → Polish → QA.
- UI/UX maturity: Placeholder → Wireframe → Visual Design → Functional UI → UI Polish.

## Milestones

| Milestone | Outcome | Gate |
|---|---|---|
| M0 — Baseline & technical decisions | GDD baseline, Phaser-vs-3D assessment, Godot spike evidence and economy review | Owner selects engine from evidence |
| M0.5 — Visual Bible & UI foundations | Visual Bible, asset/provenance rules, UI wireframes and UI Kit | Owner accepts visual/UI direction |
| M1 — 3D foundation & player controls | Clean production project (after engine selection), graybox/whitebox, FPS movement and interaction | Engine-specific plan approved; scale/navigation accepted |
| M1.5 — Proxy assets & First Art Pass | Recognizable proxy props and one representative in-game art benchmark | Owner accepts First Art Pass before final asset scale |
| M2 — Kitchen & cooking interactions | Bowl ownership, ingredient stations and recipe/cooking states | State invariants and ingredient consumption tested |
| M3 — Customers, orders & serving | Order tickets, customer wait, correct-table delivery, exactly-once payment, dirty bowls | End-to-end service path works |
| M4 — Inventory & ledger | Recipe-based consumption and transaction reconciliation | Money/inventory invariants tested |
| M5 — Campaign backlog | Ten-day game months, debt schedule and save/load | Not required for first complete-day slice; implement only after scope approval |
| M6 — Vertical-slice integration | One complete playable day, functional Vietnamese UI and final gameplay-critical props | Preparation → service → close → day summary works |
| M7 — QA, pacing & packaging | Acceptance tests, playtest metrics, visual/asset rights review, performance and desktop package | Owner reviews evidence and accepts the slice |

## Current M0 status

- **DUC-46 — Baseline:** Done. GDD v1.2 is the working product baseline; unmeasured economy assumptions remain provisional.
- **DUC-47 — Phaser-vs-3D assessment:** engine comparison gate resolved by the owner’s explicit Godot 4 selection on 2026-10-22.
- **DUC-48 — Godot 4 technical spike:** closed for engine selection. M0 spike and production scaffold are merged; owner reports 10/10 production PC checks PASS. CI passed import, interaction tests and Linux/Windows export. No screenshot/video is claimed.
- **DUC-49 — Economy review:** still open; rent, starting inventory, supplier timing, month-boundary transaction order and affordability require reconciliation.

## Implementation rules

1. The M0 spike is a technical probe, not the production project.
2. Godot 4 is selected for the vertical slice; the production project lives under `game/`.
3. The owner-approved Implementation Plan v0.2 governs the task order and gates.
4. Build a graybox/whitebox before proxy assets; approve a First Art Pass benchmark before final asset mass production.
5. The first slice ends at the day summary. Calendar progression, debt scheduling, save/load, supplier/spoilage, expansion, optional waiter and all 100 days remain later-campaign scope unless the owner changes it.
6. Every task records artifacts changed, tests/checks run, evidence, known limitations and reviewer decision.
7. Current checkpoint: kitchen station/recipe foundation. Do not expand to customer/order/serving logic until the owner verifies the new station interaction build on PC.
