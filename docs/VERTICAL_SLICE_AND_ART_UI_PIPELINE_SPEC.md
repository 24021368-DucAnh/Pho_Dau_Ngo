# PHỞ ĐẦU NGÕ — Vertical Slice, Art & UI Production Specification

**Version:** 0.1  
**Date:** 2026-10-21  
**Status:** Draft for owner review — not an implementation plan and not authorization for full production  
**Product baseline:** [GDD v1.2](PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md)  
**Decision record:** [Decision Log](DECISION_LOG.md)  
**Technical constraint:** Godot 4 is only the first engine candidate; the final engine remains undecided until the approved technical spike is evaluated.

---

## 1. Purpose

This specification defines how PHỞ ĐẦU NGÕ moves from primitive graybox geometry to a coherent, polished playable game. It establishes the production approach, the visual direction, the separate 3D-art and UI/UX maturity tracks, the integration gates, and the acceptance rules that must be agreed before detailed implementation planning.

It does **not** replace GDD v1.2, settle open economy assumptions, select the final engine, or authorize full gameplay production.

## 2. Decisions captured by this specification

1. **Production approach — vertical slice first.** Prove a small, complete player experience, including gameplay, environment art, UI, feedback, and desktop build quality, before expanding content.
2. **Product scope — design for the full 100-day campaign, produce incrementally.** Preserve the campaign, narrative and core-loop intent in GDD v1.2, but do not build all days, characters, props, or management systems at once. The initial production slice is intentionally narrow.
3. **Visual direction — grounded stylized realism.** An old Hanoi collective-housing alley; worn plaster, concrete, aged wood and used metal; warm practical lighting and restrained cinematic atmosphere; believable food and objects; humor through character behavior and situations rather than exaggerated visual noise. Avoid both generic low-poly minimalism and near-photorealism that is disproportionate to the project's scope.
4. **Parallel production tracks.** Gameplay/technical work, 3D assets, and UI/UX can progress in parallel after shared constraints are established. They must integrate and be reviewed together in the running game.
5. **Quality is evidence-based.** An asset, screen, feature, or build is not considered complete because it has been created. It must pass the applicable acceptance criteria in the target gameplay context.

## 3. Relationship to the existing technical spike

The approved M0 Godot spike is a **technical probe**, not the production vertical slice. Its purpose is to test first-person movement, collision, focus/look-at interaction, picking up and placing one bowl, invalid-placement feedback, and a desktop export. It uses graybox assets only.

The final engine decision remains open until the spike evidence is reviewed. The art/UI pipeline described here is engine-agnostic; engine-specific implementation details belong in a later implementation plan.

After the engine is selected, the first **production vertical slice** should demonstrate one representative short service session with a coherent visual/UI finish. The exact day length and economy numbers remain test assumptions, not locked requirements.

## 4. Production maturity levels

### 4.1 Environment and 3D assets

The following levels define increasing maturity. They are quality gates, not a requirement to finish every asset in the game before moving on. A representative scene should prove each level before the team scales asset production.

| Level | Name | What exists | Exit criteria |
|---|---|---|---|
| 01 | Graybox | Primitive cubes, cylinders, planes and simple collision shapes | Basic movement, camera, interaction reach and the core spatial loop can be tested |
| 02 | Whitebox | Corrected dimensions, wall openings, counters, tables, routes and interaction zones | First-person scale, visibility, navigation and work flow are accepted |
| 03 | Proxy assets | Simple but recognizable temporary models for the stall, pot, bowl, table, chair and stations | Silhouette, affordance, object ownership and placement behavior are clear |
| 04 | First Art Pass | Initial materials, color palette, lighting and rough surface character | Owner accepts the visual direction on one representative scene |
| 05 | Final asset production | Approved models, UVs where needed, textures/materials, collision and LOD/optimization where justified | Individual assets meet visual, technical, scale, licensing and performance requirements |
| 06 | Final environment art pass | Final assets integrated with architectural details, set dressing, lighting and composition | Scene feels coherent in the actual first-person camera; focal points and readability are intentional |
| 07 | Polish | Steam/food effects, small animations, interaction feedback, ambient details and sound integration | Feedback is legible, transitions feel deliberate, and no polish effect harms gameplay readability or performance |
| 08 | QA / release quality | Clean desktop build, final checks, regression tests and rights verification | The slice can be played end-to-end without blocking defects and meets the agreed acceptance checklist |

**Important:** if a gate fails, return to the earliest failing level. Do not add texture detail to an object whose scale or placement is still wrong. Do not produce many final assets before the representative scene's art direction is accepted.

### 4.2 UI/UX maturity levels

UI is a parallel production track, not a task deferred until 3D art is complete.

| Level | Name | What exists | Exit criteria |
|---|---|---|---|
| UI-01 | Placeholder | Plain text, simple rectangles, temporary icons and labels | Player can complete the intended interaction flow |
| UI-02 | Wireframe | Screen structure, hierarchy, focus order, navigation and information grouping | Players can find the required information and actions without visual styling |
| UI-03 | Visual design | Typography, palette, spacing, iconography, component states and consistent visual language | Owner accepts the representative screens and reusable UI rules |
| UI-04 | Functional UI | Real game data, interactions, keyboard/mouse behavior, validation and error/empty states | Displayed values match authoritative game state; actions work reliably |
| UI-05 | UI polish | Focus/hover/pressed/disabled states, transitions, sound cues and accessibility/readability checks | UI remains readable and operable at the target PC resolution and during actual play |

Initial UI scope for the production slice:
- In-game HUD with a restrained interaction prompt and essential order/feedback information.
- One simple ledger or end-of-day summary screen showing transactions and totals from the game's authoritative data.
- Basic pause/settings entry points only where required for a usable test build.

Do not build the full inventory, economy dashboard, narrative menu tree, or every future screen before the slice proves which information the player needs.

### 4.3 Character, animation, audio and effects

These tracks follow the same rule: prototype the function first, then establish the approved style, then polish only what the slice needs.

- Characters can use temporary silhouettes/poses during blockout. Final character modeling, facial detail and animation are not prerequisites for proving bowl handling.
- Audio should begin with temporary cues where necessary, then replace them with licensed/created sounds after the interaction and scene rhythm are established.
- Steam, particles, rain, dust and other effects must serve atmosphere or feedback. They must not obscure interactable objects or reduce frame rate below the agreed target.
- All third-party or AI-assisted assets require source/license tracking and human review before release use.

## 5. Initial production vertical slice

The slice should be the smallest experience that proves the intended feel, not a miniature version of every system in the 100-day campaign.

### Environment
- One representative section of the old Hanoi alley and one pho-stall work area.
- A playable first-person route between the work counter and one customer table.
- A small set of recognizable props: stall/counter, soup pot, clean bowl, table and a few environmental details.
- A consistent first-pass-to-final visual treatment for the visible, gameplay-critical area.

### Gameplay
- Move and look around.
- Focus an interactable object and receive clear feedback.
- Pick up a bowl and place it at a valid target; invalid placement is rejected without corrupting object state.
- Demonstrate a representative order-to-serving path when the production slice is authorized.
- Payment must be applied exactly once when payment is included in the slice; no duplicate revenue.
- End the test session and inspect a simple summary when the corresponding data path is implemented.

### UI
- A minimal in-game interaction prompt.
- Clear order/target feedback for the serving test.
- One readable summary/ledger screen backed by actual test transactions.

### Explicitly excluded from the first production slice
- All 100 days of content and all narrative events.
- A complete final version of the whole alley or every interior.
- Optional waiter/employee automation.
- Full supplier, spoilage, expansion, save/load and debt systems unless a later approved slice specifically requires them.
- Near-photorealistic asset detail or expensive bespoke animation that does not improve the validated player experience.

The slice must use clearly labeled provisional economy values if any money UI is demonstrated. It must not silently turn unresolved economy assumptions into locked game rules.

## 6. Parallel workflow and integration

After the graybox and shared interaction constraints are accepted, work can split into three coordinated tracks:

1. **Gameplay/technical:** scene structure, input, collision, interaction contracts, authoritative object states, data flow and tests.
2. **3D art:** proxy models, material studies, approved asset production, scene dressing, lighting and optimization.
3. **UI/UX:** wireframes, visual design system, functional UI, state feedback and readability checks.

The tracks rejoin in the running build at each review gate. Blender renders and Figma mockups are useful design evidence but do not replace review inside the game camera and runtime.

Any change to object scale, collision, interaction target, camera framing, UI data contract or scene layout must be communicated to the other affected tracks before integration.

## 7. Review gates

| Gate | Required evidence | Decision |
|---|---|---|
| G0 — Product and art direction | Approved product baseline, style statement, references and scope boundary | Is the team solving the right problem in the right style? |
| G1 — Graybox/whitebox | Runnable scene, dimensions, camera and movement/interaction test | Is the space playable and correctly scaled? |
| G2 — Proxy and interaction | Recognizable proxies, interaction states and invalid-action tests | Are gameplay affordances and object behavior understandable? |
| G3 — First art pass | Representative screenshot/build showing palette, materials and lighting | Is the visual direction approved before scaling asset work? |
| G4 — UI design | Wireframes, screen hierarchy, typography/palette and component states | Is the UI understandable and visually coherent? |
| G5 — Integrated slice | Desktop build with environment, gameplay, UI and temporary/final feedback integrated | Does the complete slice work as one experience? |
| G6 — Polish and QA | Test results, defect list, performance notes, rights inventory and build evidence | Is the slice ready for owner acceptance? |

A gate is passed only when evidence is attached or linked and the reviewer records the decision. A visual approval does not imply technical approval; a passing unit test does not imply the scene is visually accepted.

## 8. Definition of done

### Asset
- Purpose, source/reference and owner are recorded.
- Style, scale, silhouette and material match the approved direction.
- Pivot/orientation, collision and interaction behavior are correct where applicable.
- Imported asset is checked in the running game, not only in the modeling tool.
- License/provenance is recorded; no unreviewed third-party or AI output is assumed release-safe.
- Performance cost is acceptable for the target scene.

### UI screen/component
- Purpose and player decision are documented.
- Typography, contrast, spacing and component states follow the shared UI rules.
- Data shown comes from the authoritative game state or is explicitly labeled as placeholder.
- Mouse/keyboard behavior, focus, error and empty states are tested.
- Screen is checked at the target PC resolution and in context of the game.

### Integrated feature/build
- Acceptance criteria are testable and results are recorded.
- No duplicate payment, lost/duplicated held object, invalid placement mutation or blocking progression defect remains in the tested scope.
- A clean desktop build is launched and the representative path is played end-to-end.
- Known limitations and unresolved assumptions are written down; no passing status is claimed without evidence.

## 9. Tool responsibilities

- **Figma:** moodboards, wireframes, UI kit and screen review.
- **Blender:** 3D modeling, UVs, materials and animation assets as needed.
- **Godot or the ultimately selected engine:** runtime scenes, lighting, interaction, UI behavior and desktop builds.
- **GitHub:** versioned source/design artifacts, pull requests, change history and CI evidence.
- **Linear:** tasks, dependencies, acceptance criteria, review gates and decisions.
- **Superpowers workflow:** clarify design, review alternatives, plan before implementation, test/debug, and review changes. It supports the process; it does not replace owner approval.

## 10. Risks and unresolved constraints

- The final engine is not selected; the Godot 4 spike must provide evidence before engine-specific implementation planning.
- The economy model and month-boundary transaction rules remain open. Any slice UI showing money must clearly separate test data from approved balance rules.
- Day length (15–25 minutes), sales volume and cost assumptions remain playtest hypotheses, not fixed requirements.
- The visual direction is now agreed at the style-family level, but detailed references, exact palette, typography, target resolution/performance budget and asset budgets still need to be documented in the detailed visual/UI system.
- Character art and animation cost may exceed the initial scope; the slice should prioritize first-person props and the stall environment.

## 11. Owner review requested

Please review this specification for:
1. Whether the three production decisions in Section 2 are accurate.
2. Whether the eight 3D maturity levels and five UI maturity levels describe the intended production process.
3. Whether the proposed first production vertical slice is the right minimum proof of quality.
4. Whether any exclusion or acceptance criterion conflicts with GDD v1.2.

**No detailed file-by-file implementation plan or full gameplay production should begin until this specification is approved.** After approval, the next artifact will be a detailed implementation plan broken down by task, file/scene, tests, dependencies, acceptance criteria and review owner. The current M0 technical spike remains a separate, already-approved probe.
