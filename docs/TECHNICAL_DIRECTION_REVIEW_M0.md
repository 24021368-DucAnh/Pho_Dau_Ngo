# M0 Technical Direction Review — PHỞ ĐẦU NGÕ

**Status:** Updated after the Godot M0 probe; still a recommendation for owner review, not an engine approval.  
**Gate:** The owner approved and ran the narrow Godot probe on 2026-10-21. Do not begin engine-dependent gameplay until the owner explicitly selects the production engine and approves the engine-specific implementation plan.

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

## 4. DUC-48 Godot M0 spike — results and remaining decision

**Question tested:** Can Godot 4 support the intended first-person movement and bowl/table interactions with low implementation complexity and a reliable desktop build?

### Tested scope
- One graybox room and table; no final art assets.
- First-person camera, WASD movement, mouse look, and floor/wall collision.
- Look-at focus feedback and interaction using E or left click.
- Pick up and carry one bowl, place it in the valid zone, and reject invalid placement without changing the held state.
- Automated interaction-contract checks and Linux desktop export.

### Evidence
- **Automated CI:** [Run 39639633957](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39639633957) passed project import/parse, interaction contract tests, Linux desktop export, and artifact upload. Artifact: `pho-dau-ngo-linux-debug`.
- **Manual PC result — owner-reported 2026-10-21:** 12/12 checks PASS, including startup, WASD, mouse-look, collision, focus feedback, both pickup inputs, held-bowl movement, valid placement, invalid-placement rejection, repeated pick/place without loss or duplication, and Esc release/capture. Detailed record: [`godot_spike/TEST_PLAN.md`](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/blob/spike/godot4-m0/godot_spike/TEST_PLAN.md).
- **Evidence limitation:** no runtime screenshot or short recording is attached to the repository yet. The manual result is recorded from the owner's report; it has not been independently reviewed from a runtime capture.
- **Integration status:** PR #1 remains draft. The spike branch is 19 commits ahead and 2 behind `main`; GitHub currently reports it mergeable, but integration review and a fresh CI run on the latest head remain required before merge.

### Interpretation
The reported manual pass plus the successful automated run make Godot 4 the leading candidate for the current first-person 3D vertical slice. This reduces the principal movement/interactions/export risk, but it is not a final engine selection. Unity remains a reasonable alternative if a concrete requirement favors C# or its asset ecosystem. Phaser remains a poor foundation for the current 3D target; Unreal appears unnecessarily complex for the current compact scope unless visual-fidelity requirements change.

### Owner decision required
Choose exactly one:
1. **Approve Godot 4** as the implementation engine and request the full-game architecture/file-by-file implementation plan.
2. **Request one bounded follow-up experiment**, naming the uncertainty or acceptance criterion that remains unresolved.
3. **Reject Godot 4** and request a focused comparison with another engine.

Do not start engine-dependent gameplay before the owner makes this choice and approves the engine-specific implementation plan.

## 5. Remaining technical uncertainties

- Final first-person camera height, FOV, interaction reach, and workstation dimensions should be measured in the accepted graybox.
- Target resolution and target PC specification still need to be named before performance budgets are locked.
- The spike validates one bowl/table interaction path only; it does not validate kitchen stations, customers, order flow, economy, saving, or production architecture.
- Reuse from the legacy Phaser prototype should be limited to domain concepts and acceptance rules until each candidate module is inspected; do not assume direct code portability.

These uncertainties do not invalidate the reported M0 result, but they must be addressed in the engine-specific implementation plan. No full gameplay production is authorized by this review.
