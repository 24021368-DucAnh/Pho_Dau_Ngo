# PHỞ ĐẦU NGÕ

A first-person Vietnamese phở-stall simulation set in an old Hanoi collective-apartment neighborhood. The current goal is a focused, testable vertical slice for PC/Steam.

## Project status

**Phase:** M1 — Godot production scaffold and graybox  
**Implementation status:** Godot 4 selected by owner; M0 spike merged. The official production project is under review in PR #10, with CI import/test/export running.  
**Canonical planning board:** [Linear — PHỞ ĐẦU NGÕ Vertical Slice](https://linear.app/ducanh/project/pho-djau-ngo-vertical-slice-098596fd5d5a)  
**Implementation roadmap:** [Linear roadmap document](https://linear.app/ducanh/document/pho-djau-ngo-vertical-slice-implementation-roadmap-v01-d4a7ae75bb49)

## Start here

- [Official Godot vertical-slice project](game/README.md) — open `game/project.godot` in Godot 4.4.1 Standard.
- [Godot vertical-slice architecture](docs/architecture/GODOT_VERTICAL_SLICE_ARCHITECTURE.md)
- [UI Specification](docs/ui/UI_SPEC.md)
- [UI Components](docs/ui/UI_COMPONENTS.md)

- [Canonical GDD v1.2 — Vietnamese](docs/PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md)
- [GDD v1.2 audit and decision log — original](docs/PHO_DAU_NGO_AUDIT_DECISION_LOG_v1_2_Tieng_Viet.md)
- [Project baseline](docs/PROJECT_BASELINE.md)
- [Open decision log](docs/DECISION_LOG.md)
- [M0 economy review](docs/ECONOMY_REVIEW_M0.md)
- [M0 technical direction review](docs/TECHNICAL_DIRECTION_REVIEW_M0.md)
- [M0 owner baseline review](docs/OWNER_REVIEW_M0.md)
- [Implementation roadmap and milestone gates](docs/IMPLEMENTATION_ROADMAP.md)
- [Superpowers execution plan](docs/Superpowers_Plan_v0.1.md)

> **Archival note:** The GDD and audit files above preserve the original v1.2 documents. The audit's final paragraph about repository write access describes the situation when that audit was written; it is historical, not the current repository status.

## Working rules

1. Treat unresolved economy and pacing values as assumptions until reviewed.
2. Godot 4 is the owner-selected engine for the vertical slice (2026-10-22); reopen the choice only if a concrete technical blocker appears.
3. Keep the first slice scoped to the end-of-day summary; do not build the full campaign before the slice is tested and accepted.
4. Keep gameplay rules deterministic and testable; avoid double payment, duplicated item ownership, and ambiguous save/load behavior.
5. Record meaningful scope and design changes in the decision log and Linear.

## Target core loop

Prepare the stall, receive orders, manually assemble/cook bowls, carry the correct bowl to the correct table, receive payment exactly once, collect dirty bowls, wash them in batches, and close the day’s ledger.

## Repository conventions

- docs/: product baseline, design decisions, and delivery plan.
- game/: official Godot production project.
- godot_spike/: preserved M0 technical probe and evidence.
- docs/: product baseline, decisions, architecture and UI/art specs.
