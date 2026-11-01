# GLB optimization candidates, 2026-11-01

Source GLBs remain in `game/assets/models/props/` under their `_GAME.glb` names. The scene uses separate `_OPT.glb` variants for two small table props.

| Asset | Source triangles | Optimized triangles | Source bytes | Optimized bytes | Blender decimate ratio |
| --- | ---: | ---: | ---: | ---: | ---: |
| Garlic vinegar jar | 116,248 | 41,091 | 2,146,132 | 2,000,776 | 0.30 |
| Chili paste jar | 69,252 | 40,383 | 6,579,712 | 5,743,104 | 0.45 |
| Chopstick holder (used 3 times) | 47,304 | 9,460 | 1,063,280 | 220,740 | 0.20 |
| Pho noodles (up to 2 visible) | 72,720 | 14,543 | 1,904,096 | 424,856 | 0.20 |
| Tea glass (placed once on table 1) | 27,056 | 13,806 | 769,548 | 224,956 | glass 0.40, tea 0.60 |

Method: Blender 5.2.4 import, per-object decimate for meshes with at least 1,500 faces, leave transparent material meshes intact, export standard GLB. The holder and noodle variants export normals; the two jar variants do not (matching their sources). No Draco or Meshopt extension is used because the local Godot 4.4.1 importer rejected Draco. The optimized files retain effectively the same bounding box, material count, embedded image count, and alpha material count as their sources.

The three holder instances save 113,532 triangles; the two noodle instances save up to 116,354. Together, these reduce the maximum placed GLB triangle total from 574,955 to 345,069 when both bowls show all ingredients. This is a static scene count, not a measured GPU draw count.

Verification: Godot 4.4.1 produced imported `.scn` files for the five `_OPT.glb` files and loaded the main scene. First editor imports printed `ERROR: Parameter "t" is null` despite creating those files; subsequent editor loads, game startup, and 12 headless game tests did not repeat it. The previews compare shape from a fixed camera. First-person material appearance and FPS have not yet been measured, so these variants remain reviewable and reversible.

The new `ENV_KTT_HANOI_HERO_BLOCK_2015_V007_G3_RESIDENT_LIFE.glb` is not placed in the gameplay scene. Its 31,476 triangles are modest, but it has 312 mesh primitives, 39 materials, 113 embedded images (95 unique) and a 53,513,316 byte file. It needs a separate environment placement, material/mesh consolidation and texture budget check before integration; the existing back wall would otherwise obscure it.
