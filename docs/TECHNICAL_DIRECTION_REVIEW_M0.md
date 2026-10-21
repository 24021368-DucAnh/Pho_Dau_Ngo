# M0 Technical Direction Review — PHỞ ĐẦU NGÕ

**Status:** Decision recorded — Godot 4 selected by the owner on 2026-10-22 for the vertical slice.  
**Gate:** Proceed with the Godot-specific production scaffold and approved milestones; keep gameplay expansion behind architecture, graybox and runtime-test gates.

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

## 3. Decision and rationale

**Owner decision (2026-10-22): Godot 4 is the official engine for the PHỞ ĐẦU NGÕ vertical slice.** The owner reported 12/12 manual PC checks PASS, and automated CI passed project import/parse, interaction contract tests, Linux desktop export and artifact upload.

The spike demonstrated the required basic movement, camera, collision, focus and bowl placement path on the owner's PC. This is sufficient evidence to stop comparing engines for the current slice. Reopen the choice only if a concrete technical blocker emerges or the scope changes materially.

Do not migrate the legacy Phaser code line by line; reuse only portable domain rules, acceptance cases and content where genuinely useful. The M0 spike is a technical reference, not final production architecture.

## 4. DUC-48 M0 spike — completed evidence

**Question tested:** Can Godot 4 support the intended first-person movement and bowl/table interactions with low implementation complexity and a reliable desktop build?

### Tested scope and results

- One graybox room, table, bowl and valid placement zone.
- First-person camera, WASD movement, mouse look, and floor/wall collision.
- Raycast focus feedback; pickup with E or left click; held bowl follows camera.
- Valid placement snaps to marker; invalid placement is rejected without changing held state; repeated pick/place preserves one authoritative bowl.
- Owner-reported manual PC result: **12/12 checks PASS** (2026-10-21), recorded in [`godot_spike/TEST_PLAN.md`](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/blob/main/godot_spike/TEST_PLAN.md).
- Automated CI [run 39639633957](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39639633957) passed import/parse, interaction contract tests, Linux desktop export and artifact upload (`pho-dau-ngo-linux-debug`).
- The checklist is based on the owner's report; no runtime screenshot/recording is attached.

### M0 scope boundary

The spike did not validate customers, recipes, order generation, inventory/economy, debt, saving, story events, finished art, audio, or production architecture. These remain future milestones and must be tested separately. No additional engine comparison is needed absent a concrete blocker.

## 5. Production gates and remaining technical uncertainties

- Confirm the GDD's first-person 3D PC/Steam target as the working product direction.
- Keep 15–25 minutes/day as a test target, not a locked requirement.
- Keep room rent and shop rent marked as balance assumptions until the cash-flow model is complete.
- Define exact opening inventory and first-day purchase timing.
- Define the deterministic order and player warning for rent/utilities and debt at the month boundary.
- Confirm the optional waiter remains outside the initial vertical slice.

Next steps follow Implementation Plan v0.2: complete the Godot-specific architecture/file-by-file plan, establish the official project scaffold, build/review graybox, then add gameplay in dependency order. Target resolution/hardware, camera height/FOV, interaction reach, workstation dimensions and performance budgets remain to be measured in the graybox. Economy assumptions remain provisional until DUC-49 simulation/playtests. Do not scale final asset production before the in-engine First Art Pass is owner-reviewed.
