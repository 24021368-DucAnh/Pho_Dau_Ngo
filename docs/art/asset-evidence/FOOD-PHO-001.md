# FOOD-PHO-001 — Empty Pho Bowl Intake Record

**Record status:** Intake incomplete; not production-ready  
**Last updated:** 2026-10-24  
**Repository baseline inspected:** `main` at `55fc09d28cf23b8828ee1ec09cfc04f083378c77`  
**Asset status:** `proxy` (candidate reported in prior conversation; binary not available in the active workspace)

## 1. Known candidate history

The user has an existing empty-bowl model and previously supplied `ceramic bowl 3d model.3mf`. A prior session reports that a conversion candidate named `ceramic_bowl_candidate.glb` was produced. The source and converted binary are not currently present in the repository tree or attached to this active conversation, so these files have not been re-opened or re-verified during this intake pass.

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

Do not promote this candidate to `first-art-pass`, `final`, `integrated`, or `QA` until the following are evidenced:

- [ ] Recover the original `.3mf` and the reported `.glb` candidate into the active workspace.
- [ ] Re-measure dimensions and establish target scale in metres for Godot.
- [ ] Inspect the bowl opening, inner wall, rim thickness, base, normals, manifold/watertight status, disconnected/floating geometry and pivot/origin.
- [ ] Inspect material slots, textures, embedded/external dependencies and visual quality under neutral lighting.
- [ ] Record applicable provenance and rights terms.
- [ ] Copy the untouched source to `art/source/food/FOOD-PHO-001_v001_source.3mf` only after repository size and provenance checks.
- [ ] Create a reviewed GLB export at `art/exports/glb/FOOD-PHO-001_v001.glb`.
- [ ] Promote a validated runtime copy to `game/assets/models/food/FOOD_pho_bowl_ceramic.glb`.
- [ ] Import/parse the asset in Godot 4.4.1 and capture an actual runtime screenshot.
- [ ] Confirm the bowl visual is attached without changing the production `InteractiveBowl` root, collision shape, ownership transitions or recipe API.

## 4. Current integration decision

**Blocked before binary intake.** The current repo has no committed bowl model at the planned runtime path. Do not create a fake placeholder GLB, do not add a broken scene resource reference, and do not claim runtime acceptance. The next implementation step is to recover and inspect the existing candidate, not spend more Tripo credits or regenerate the bowl.
