# M0 Technical Direction Review — PHỞ ĐẦU NGÕ

**Status:** Draft recommendation for owner review; not an engine approval.  
**Gate:** Do not run an engine spike or begin product implementation until the owner approves the probe and the engine-specific plan.

## 1. Current architecture mismatch

The current `Pho_Dau_Ngo` repository is the documentation/planning repository. The earlier prototype inspected during planning is a separate TypeScript + Phaser 3 + Vite 2D browser project.

The GDD target is a first-person 3D PC/Steam game. Phaser's official documentation describes Phaser as a 2D HTML5 framework and explicitly says it is not the right choice when the game must be fully 3D. Phaser can still be useful as a reference for gameplay rules or a temporary 2D mock, but it should not be treated as the default foundation for the target 3D build.

Source: [Phaser documentation — Welcome / What Phaser is and when it is not the right choice](https://docs.phaser.io/).

## 2. Candidate engine comparison

| Candidate | Strengths for this project | Main trade-offs | Assessment |
|---|---|---|---|
| **Godot 4** | Built for 2D/3D scenes, integrated editor and physics, direct desktop export, permissive MIT engine license; low friction for a compact first-person scene | Smaller commercial asset ecosystem than Unity/Unreal; must validate first-person item handling, desktop export and target-machine performance | **Preferred candidate for a small, controlled spike; not yet approved** |
| Unity | Mature 3D workflow, C# scripting, broad tutorials and asset ecosystem; Personal plan currently offers desktop publishing | Larger project/editor footprint and more package/configuration decisions; verify current plan eligibility before commercial release | Strong alternative if C# and asset availability become the deciding factors |
| Unreal Engine 5 | Strong built-in 3D presentation tools, C++ and Blueprint workflows, broad high-fidelity capabilities | Likely unnecessary complexity for one compact stall/alley and tactile interactions; standard license currently has 5% royalty on qualifying revenue above the first US$1M threshold | Not the first choice for the current scope unless visual fidelity becomes the dominant goal |
| Keep Phaser 3 | Reuses the existing TypeScript 2D prototype and web-oriented workflow | No built-in 3D rendering or 3D physics; would require a different rendering/physics stack or a major architectural workaround | **Do not recommend for the stated first-person 3D target** |

Sources:

- [Godot license](https://godotengine.org/license/) — MIT license and commercial-use terms.
- [Godot stable documentation — supported export platforms](https://docs.godotengine.org/en/stable/about/faq.html).
- [Unity Plans & Pricing](https://unity.com/products) — current Personal and Pro plan information.
- [Unreal Engine licensing](https://www.unrealengine.com/license) — current royalty and license terms.
- [Phaser documentation](https://docs.phaser.io/) — 2D HTML5 framework scope.

## 3. Recommendation

Use **Godot 4 as the first candidate to evaluate**, not as a final engine decision. It is a reasonable fit for a small first-person 3D vertical slice with one stall, a compact alley, interactable stations, and a limited number of objects. It avoids committing to a web-first 2D framework and does not require the high-fidelity production pipeline that Unreal is designed to support.

Keep the choice reversible until the spike proves that the interaction model and desktop build work. Do not migrate the old Phaser code line by line; extract only portable gameplay rules, acceptance cases, and domain concepts where they are genuinely reusable.

## 4. Proposed DUC-48 spike — approval required before execution

**Question:** Can Godot 4 support the intended first-person movement and bowl/table interactions with low implementation complexity and a reliable desktop build?

### Minimal scope

1. One graybox room/stall and one table; no final art assets.
2. First-person camera, mouse look, WASD movement, collision and sensible movement limits.
3. Raycast/look-at interaction with a visible focus state and an `E` interaction.
4. Pick up one bowl, hold it visibly, place it on a target table, and reject invalid placement with feedback.
5. Export and launch a desktop build from a clean project checkout.

### Acceptance criteria to approve

- A new tester can move, focus, pick up and place the bowl without reading source code.
- The bowl has one authoritative state/location; it cannot duplicate or disappear through repeated input.
- Invalid placement does not mutate the bowl state.
- The exported desktop build starts and completes the same interaction path.
- The test scene uses graybox assets only and can be built quickly enough to justify continued development.

### Explicitly out of scope

Customers, recipes, order generation, money, debt, saving, story events, finished art, audio, and performance optimization beyond checking that the spike is usable on the development machine.

**Approval gate:** The spike is only a proposal. Do not execute DUC-48 until the owner approves the question and acceptance criteria. After the spike, compare evidence against Unity only if Godot fails a meaningful criterion or a new constraint justifies a second spike.

## 5. Remaining baseline decisions

- Confirm the GDD's first-person 3D PC/Steam target as the working product direction.
- Keep 15–25 minutes/day as a test target, not a locked requirement.
- Keep room rent and shop rent marked as balance assumptions until the cash-flow model is complete.
- Define exact opening inventory and first-day purchase timing.
- Define the deterministic order and player warning for rent/utilities and debt at the month boundary.
- Confirm the optional waiter remains outside the initial vertical slice.

Until those items are reviewed, DUC-46 remains open. No product code has been written as part of this review.
