# FOOD-PHO-001 — Empty Pho Bowl Intake Record

**Record status:** Intake updated 2026-10-26 — runtime files committed; Phase A temporarily closed by owner, NOT final acceptance  
**Last updated:** 2026-10-26  
**Repository baseline inspected:** `main` at `7f64796` (PR #51 merge)  
**Asset status:** `first-art-pass` (committed to repo, viewed in Godot, owner temp-close 2026-10-25; NOT `integrated` — the modular scene is not yet instanced in gameplay `main.tscn` — and NOT `QA`)

## 1. Known candidate history

The user has an existing empty-bowl model and previously supplied `ceramic bowl 3d model.3mf`. A prior session reports that a conversion candidate named `ceramic_bowl_candidate.glb` was produced. The source and converted binary were not present in the repository tree at the time of the 2026-10-24 intake pass. That statement is superseded: the candidate was recovered and re-measured in the 2026-10-25 session (same figures as below), and runtime GLBs were committed to the repository via PR #44 (see section 6).

Previously reported inspection values (historical evidence; re-measure when the binary is recovered):

- Vertices: 250,898
- Triangles: 501,804
- Approximate dimensions: 500 × 500 × 249 mm
- Topology: reported non-watertight
- Converted GLB size: approximately 9 MB

These figures are not a claim that the model passes the production asset gate. In particular, the non-watertight result and 500 mm width suggest scale/topology inspection is required before Godot integration.

## 2. Provenance and rights

- Immediate source: user-provided `.3mf` file, according to prior conversation.
- Generator/source author and original license: not verified.
- Tripo generation metadata: not applicable unless the recovered source proves it came from a Tripo generation job.
- Commercial-use rights: unresolved; do not mark cleared based only on the file extension or the fact that the model exists.
- Preserve the original source unchanged. Do not overwrite it with a repaired export.

## 3. Intake gate

Do not promote this candidate to `final`, `integrated`, or `QA` until the remaining open items below are evidenced. Checked items are evidenced on `main` at `7f64796`; the unchecked items are the actual remaining gate.

- [x] Recover the original `.3mf` and the reported `.glb` candidate into the active workspace. (Done 2026-10-25: source re-supplied in conversation; original preserved outside the repo, not committed.)
- [x] Re-measure dimensions and establish target scale in metres for Godot. (Done: 250,898 vertices, 501,804 triangles, ~500 × 500 × 249 mm confirmed; bowl is upright in OBJ space, Z-up, base at Z 0.)
- [x] Inspect the bowl opening, inner wall, rim thickness, base, normals, manifold/watertight status, disconnected/floating geometry and pivot/origin. (Done in Blender: non-watertight/degenerate triangles noted and judged acceptable for a static prop; full-res export decimated to a 60,215-triangle / 4.9 MB runtime version with dimensions unchanged.)
- [x] Inspect material slots, textures, embedded/external dependencies and visual quality under neutral lighting. (Done: white ceramic body plus an original procedural blue pattern layer — 3 blue rings + 24 small motifs, traditional style only, not a copy of any commercial pattern. Owner feedback in Godot: everything reads too white/pale under flat lighting; a contrast pass (v004, darkened/saturated materials only) was sent but has NOT been re-tested in Godot.)
- [ ] Record applicable provenance and rights terms. (Still open: source creator, origin and license remain unverified. Do not mark cleared.)
- [ ] Copy the untouched source to `art/source/food/FOOD-PHO-001_v001_source.3mf` only after repository size and provenance checks. (Not done: source remains in the conversation workspace, not in the repo.)
- [ ] Create a reviewed GLB export at `art/exports/glb/FOOD-PHO-001_v001.glb`. (Not done as planned: the actual runtime files live at `game/assets/models/food/` — see section 6 — not under `art/exports/`.)
- [x] Promote a validated runtime copy to `game/assets/models/food/FOOD_pho_bowl_ceramic.glb`. (Done via PR #44: 7 GLBs committed — bowl, blue pattern, noodles, broth, beef, garnish, chopsticks — plus Godot `.import`/`.uid` files.)
- [x] Import/parse the asset in Godot 4.4.1 and capture an actual runtime screenshot. (Done: modular scene `game/scenes/art/food/pho_bowl_modular.tscn` imports; owner screenshots 2026-10-25 00:39–00:41 show the bowl upright, blue rim pattern visible, noodles filling the bowl, chili visible, chopsticks across the top, no missing-texture errors.)
- [ ] Confirm the bowl visual is attached without changing the production `InteractiveBowl` root, collision shape, ownership transitions or recipe API. (Open: the modular scene exists and its script is visuals-only, but it is NOT instanced in gameplay `main.tscn` — the gameplay Bowl is still a separate cylinder visual. Attachment is the remaining Task 4 work.)

## 4. Current integration decision

**Temporarily closed by the owner on 2026-10-25 ("tạm chốt"), NOT final acceptance.** Runtime files are committed and the modular scene is built, but do not claim `integrated` or `QA`. Remaining before final acceptance: formal owner acceptance, the v004 contrast re-check in Godot, the intricate blue scroll pattern (v003's pattern is a simplified original, not the photo's scrollwork), and the bowl-depth decision (bowl height 0.249 m vs gameplay proxy height 0.12 m — do not stretch the model; no final decision made). Do not spend Tripo credits on a replacement bowl; the existing candidate was recovered and used.


## 5. Re-inspection update — 2026-10-25

The user re-supplied the source file as `ceramic bowl 3d model.3mf` in the active conversation. A conversion candidate `ceramic_bowl_candidate.glb` was produced for inspection in the conversation workspace. These files are **not committed to this repository**; do not reference them as project resources or assume other contributors/CI can access them.

Reported measurements from this inspection session:
- Mesh present: approximately 250,898 vertices and 501,804 triangles.
- Dimensions reported by the 3MF package: approximately 500 × 500 × 249 mm; verify orientation and actual intended dimensions in a 3D editor before setting Godot scale.
- Topology check reported non-watertight, with degenerate triangles/edge irregularities noted; candidate is not production-ready.
- A GLB conversion was created and reopened by a reader, but this is conversion-level evidence only. No Godot import, in-engine camera inspection, texture/material acceptance, runtime test, or owner acceptance has been performed.
- The source's creator, origin, and license remain unverified. Do not assume it was generated by Tripo.

### Revised immediate gate

1. Preserve the user's original `.3mf` unchanged outside the repo until provenance/rights and repository-size policy are checked.
2. Inspect the bowl in Blender or another mesh editor: confirm opening/interior, wall thickness, rim, base, normals, disconnected pieces, scale/orientation and whether the topology defects matter for a static visual prop.
3. If visual shape is acceptable, create a cleaned **new version** rather than overwriting the source; record exact cleanup operations. Do not attempt to make it watertight automatically unless the actual defect requires that for the intended Godot material/rendering.
4. Import the candidate into a disposable Godot 4.4.1 test scene first. Check material import, scale, pivot, and the visual against the existing production bowl/counter. Keep the production scene unchanged until acceptance.
5. Capture neutral and first-person screenshots, record actual import warnings and measured values, then update the register based on evidence.
6. If shape fails review or provenance/rights cannot be resolved, keep this candidate blocked and ask the owner before spending Tripo credits on a replacement.

**Status at the end of the 2026-10-25 session: `proxy` / intake blocked.** A successful 3MF-to-GLB conversion alone does not promote the asset to `first-art-pass`, `integrated`, or `QA`. (This section is history; the 2026-10-26 status is in sections 3, 4 and 6.)

## 6. Reconciliation update — 2026-10-26 (PR #52 revision)

This section supersedes the stale statements in sections 1 and 5 ("binary not present", "no Godot evidence", "blocked before binary intake"). Those statements were true for the 2026-10-24 intake pass and are no longer true on `main` at `7f64796`:

- Runtime GLBs committed via PR #44 (`main` `1e2541fa`, later merges): `game/assets/models/food/FOOD_pho_bowl_ceramic.glb`, `FOOD_pho_bowl_pattern_blue.glb`, `FOOD_pho_noodles_flat_rice.glb`, `FOOD_pho_broth_surface.glb`, `FOOD_pho_beef_slice.glb`, `FOOD_pho_herb_garnish.glb`, `EXTRA_chopsticks.glb`.
- Runtime bowl version (v003): original blue pattern layer, broth disc radius 0.19 m lowered to Z 0.18 m, decimated from 501,793 triangles / 41 MB to 60,215 triangles / 4.9 MB, dimensions unchanged.
- Modular scene on `main`: `game/scenes/art/food/pho_bowl_modular.tscn` with script `game/scripts/art/pho_bowl_visuals.gd` (visuals-only, driven by `consumed_ingredients`; garnish + chopsticks show only when all three ingredients are present). Not yet instanced in gameplay `main.tscn`.
- Owner Godot viewing 2026-10-25 00:39–00:41 and temporary close 2026-10-25 00:52 (see section 4). A contrast pass v004 was sent but never re-tested in Godot.
- Provenance/rights for the user-provided `.3mf` remain unverified. Do not mark the bowl cleared on that basis.
