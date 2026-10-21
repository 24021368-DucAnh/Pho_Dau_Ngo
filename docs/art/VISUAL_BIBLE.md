# PHỞ ĐẦU NGÕ — Visual Bible v0.1

**Status:** Draft for owner review. The broad style family is owner-approved; exact palette, lighting, dimensions, and production budgets remain provisional until reviewed in a representative runtime scene.

## 1. North star

**Grounded stylized realism**: a compact, lived-in Hanoi collective-housing alley and a working pho cart. The place should feel familiar, functional and cared for by people who use it every day. Age comes from selective wear, repairs and material history—not a uniform layer of dirt. Humor comes from character, timing and situation, not exaggerated cartoon architecture.

- **Player fantasy:** personally operate a small pho stall, one bowl and one customer interaction at a time.
- **Primary emotional register:** early-morning warmth, modest dignity, neighborhood familiarity, earned progress.
- **Scale:** intimate and readable; not an open-world city.
- **Detail hierarchy:** gameplay-critical prop → workstation → immediate alley context → background life.
- **Hard rule:** bowl, pot, ingredients, order destination and valid placement area must remain legible from first-person camera.

## 2. Representative visual benchmark

Figma board: [PHỞ ĐẦU NGÕ — Visual Bible & Benchmark v0.1](https://www.figma.com/design/feHazau3AOstL7wtSlEIBk)

The board is a **2D/vector art-direction study**, not a game screenshot, 3D concept render or final asset. It tests silhouette, composition, broad value grouping and palette only. Revalidate all scale, camera, occlusion, collision and lighting in the chosen engine before treating it as an in-game benchmark.

## 3. Palette — provisional tokens

| Token | Hex | Intended use | Guardrail |
|---|---|---|---|
| Old limewash | `#D8CCB5` | Worn plaster, warm neutral surfaces | Avoid using one flat beige on every wall |
| Dark timber | `#75513A` | Cart edges, old wood, handles | Keep grain subtle at gameplay distance |
| Glazed green | `#4D6658` | Cart body, selected metal/painted props | Main identity accent; avoid full-scene green |
| Stool red | `#9C443C` | Red plastic stools and small accents | Reserve for familiar local objects and controlled accents |
| Broth amber | `#B97A2B` | Broth highlights, warm food accents | Must remain food-like, not neon orange |
| Alley shadow | `#35322D` | Deep recesses, dark outlines, occlusion | Preserve readable shadow detail |
| Concrete | `#898579` | Alley floor, steps, thresholds | Vary by exposure and wear |
| Inox | `#AEB3AA` | Pots, trays, steel work surfaces | Use restrained highlights, no mirror-like chrome |

These hex values are **design proposals**, not locked production colors. Confirm in the first art pass on a representative scene, with sRGB display and the intended PC brightness.

## 4. Lighting and color management

- Main mood: diffuse early-morning daylight, soft but directional shadows, readable recesses.
- Practical stall light may lean warm (roughly 2,800–3,200 K as a visual reference only); do not assume a physical temperature must be simulated exactly.
- Use light to separate the cart and food props from the alley background.
- Avoid global orange grading, saturated neon, strong bloom, horror-like contrast or crushed blacks.
- Steam and wet surfaces are accents. They must not hide focus feedback, bowl edges or valid-placement markers.
- Exposure, tone mapping, shadow quality and numerical performance budgets remain engine- and hardware-dependent.

## 5. Material language

| Material | Visual treatment | Where wear belongs |
|---|---|---|
| Limewash / painted plaster | Slightly uneven color, patched repairs, restrained edge wear | Corners, damp lower walls, around frequently touched openings |
| Concrete / terrazzo | Matte, small value variation, visible seams at scale | Walk paths, thresholds, drainage edges |
| Wood | Darkened touch points, simple grain, repair marks | Handles, cart rails, shelves |
| Stainless steel | Broad soft reflections, fine brushed direction | Pot rim, trays and work surfaces; keep food-contact surfaces clean |
| Ceramic / enamel | Clear silhouette and controlled gloss | Small chips only on safe exterior edges; no unsanitary food surfaces |
| Red plastic | Faded red, scuffs and simple molded shape | Stool seats and legs |
| Glass | Modest reflections, readable contents | Jars and windows; avoid expensive distortion for small props |

Wear must tell a story: hand contact, rain, sun, repairs and cleaning. Do not distribute grunge uniformly. The working kitchen should read as cleaned and functional even when old.

## 6. Composition and prop hierarchy

1. **Tier A — gameplay-critical:** bowl, soup pot, ingredient tray, interaction target, order ticket and table. High silhouette contrast; simple background behind them.
2. **Tier B — workstation:** cart, stove, shelves, clean-bowl storage and dirty-bowl collection area. Clear spatial affordances.
3. **Tier C — atmosphere:** windows, air conditioners, laundry, cables, plants, shopfront and neighbor details. Low contrast when near interactables.
4. **Tier D — background-only:** distant architecture and street silhouettes. No expensive detail before the slice proves it needs it.

The alley uses a compact T-junction composition. The pho cart is the visual anchor; the tea stall and neighborhood storefronts support the lived-in context. Keep routes from workstation to one customer table unobstructed in the first slice.

## 7. Camera/readability rules

- The player is first-person; evaluate every gameplay-critical prop from the actual eye height and normal interaction distance.
- Do not rely on tiny labels or texture detail to distinguish interactables.
- A focused object needs a stable, high-contrast prompt/state change; do not rely on color alone.
- The valid placement zone must be distinct from invalid surfaces and remain visible when carrying the bowl.
- No steam, props, shadows, high-contrast trim or decorative signage may occlude a target.
- Character silhouettes and background movement must not be mistaken for interaction targets.
- Final camera height, interaction reach, counter dimensions, FOV and target display resolution are to be measured in the accepted graybox, not fixed by this document.

## 8. Typography and signage

- UI typography: use a highly legible sans serif with Vietnamese diacritics. Inter is the initial UI study font; verify the final runtime font and redistribution license before shipping.
- UI copy is concise Vietnamese, with everyday language and no database-like terminology.
- Shop signs may use a restrained hand-painted or utilitarian lettering treatment. Keep fictional signage fictional; do not use real trademarks, phone numbers or identifiable private addresses.
- UI text must remain readable at the agreed PC resolution and viewing distance. No font size is final until runtime testing.

## 9. Asset scale, naming and technical standards

All values below are **provisional conventions** until the graybox is accepted.

- **World unit:** propose 1 engine unit = 1 metre; verify in the chosen engine.
- **Origin/pivot:** props use a meaningful base/contact pivot unless a station interaction explicitly needs a hand-grip or placement pivot. Document exceptions.
- **Forward axis:** follow the selected engine's standard; never silently rotate exported assets per scene.
- **Collision:** simple primitives or low-complexity collision meshes; do not use high-detail render meshes as default collision.
- **Naming:** `ENV_*` environment, `PROP_*` props, `FOOD_*` food, `CHAR_*` characters, `MAT_*` materials, `TEX_*` textures, `UI_*` UI assets. Use descriptive snake_case after the prefix, e.g. `PROP_pho_cart_body`.
- **Versions:** source file and exported asset share a stable asset ID and version; do not overwrite a reviewed final without a version note.
- **Modeling:** real-world proportions first, then simplify silhouette and hidden surfaces. No micro-detail that disappears at player distance.
- **Textures:** prioritize material readability; avoid unique high-resolution textures on tiny background props. Texture resolution and compression budgets are provisional until target hardware is identified.
- **UVs:** use only where the chosen material/shader needs them; avoid unwrapping as ceremony.
- **LOD/optimization:** apply only when profiling demonstrates need; do not invent FPS thresholds before a target PC is named.
- **Runtime check:** import, scale, pivot, collision, materials, clipping and occlusion must be checked in the actual game camera.

## 10. Asset maturity states

Every tracked item has exactly one primary state:

1. `reference` — inspiration only; never ship as an asset.
2. `proxy` — temporary graybox/primitive or placeholder.
3. `first-art-pass` — style/material benchmark for review.
4. `final` — produced and approved source/export, but not yet integrated.
5. `integrated` — checked in the target runtime scene.
6. `QA` — rights, technical import, readability and runtime checks recorded.

Do not move an item to `final` based only on a render or generated image. Integration and QA are separate states.

## 11. Provenance, copyright and AI-assisted content

- Record creator/author, original URL, license/terms, access date, intended use and attribution requirements for every third-party reference or asset.
- A reference image is for visual research unless its license and intended use explicitly allow incorporation.
- AI-generated material is not automatically release-ready. Record tool/source and human review; check for brand/logo, recognizable copyrighted character, likeness, text or accidental watermark before considering production use.
- Never remove a watermark, imply permission from a reference-only source, or copy an image into the game merely because it is publicly viewable.
- Prefer original modeled props, commissioned work, or assets with explicit compatible licenses for release use.
- Keep license evidence with the asset register; unresolved rights block release use.

## 12. Owner gates

- **G0 — direction:** owner reviews this visual family and reference plan.
- **G3 — first art pass:** owner accepts one representative in-engine corner before final asset production scales.
- **G5 — integrated art:** owner reviews the same area in the playable runtime, not only in Figma/Blender.
- Any palette, scale, style or asset-rights exception is recorded in the decision log before being treated as standard.

## 13. Open items

- Final palette and contrast after runtime evaluation.
- Exact first-person camera/FOV and prop dimensions after graybox acceptance.
- Target resolution, target hardware and measurable performance budget.
- Final UI font and licensing verification.
- Reference shortlist and asset-specific license verification.
- Whether source models/textures require Git LFS based on actual file size and repository policy.
