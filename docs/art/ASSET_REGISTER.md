# PHỞ ĐẦU NGÕ — Asset Register v0.1

**Status:** Initial register; owner review required.  
**Rule:** reference-only does not mean reusable or redistributable. No asset is release-ready until rights and runtime QA are recorded.

## Status vocabulary

`reference` → `proxy` → `first-art-pass` → `final` → `integrated` → `QA`

Use one primary status per row. Record a stable ID even when the asset is not yet created.

## Initial register

| Asset ID | Asset / purpose | Priority | Status | Source / creator | License / rights status | Planned action | Runtime / QA evidence |
|---|---|---:|---|---|---|---|---|
| REF-ENV-001 | Old Hanoi collective-housing facade, window/AC/laundry rhythm | High | reference | Figma art-direction board; original vector study | Original board authored for this project; reference only | Validate architectural cues against licensed/permissioned references | Not applicable; not a runtime asset |
| REF-ENV-002 | Narrow alley / T-junction / worn concrete | High | reference | Figma art-direction board; original vector study | Original board authored for this project; reference only | Keep the first scene compact; verify walk path in graybox | Not applicable |
| REF-STALL-001 | Pho cart, canopy, stove, pot and worktop | Critical | first-art-pass | Figma art-direction board; original vector study | Original board authored for this project; conceptual vector only, not a 3D asset | Model proxy after graybox scale is accepted | No runtime validation yet |
| REF-FOOD-001 | Clean bowl and broth silhouette | Critical | reference | Figma art-direction board; original vector study | Original board authored for this project; reference only | Create recognizable gameplay proxy with strong silhouette | No runtime validation yet |
| REF-PROP-001 | Red plastic stools and small tea station | Medium | reference | Figma art-direction board; original vector study | Original board authored for this project; reference only | Keep accents selective; avoid cluttering target zones | No runtime validation yet |
| REF-CHAR-001 | Generic owner/customer silhouettes | Medium | proxy | Figma art-direction board; original vector study | Original vector study; placeholder silhouette only, not character art | Replace only if character silhouettes improve the slice | No runtime validation yet |
| MAT-ENV-001 | Old limewash / patched plaster material | High | reference | Proposed token `#D8CCB5` | Original design proposal; not a texture file | Create material study during first art pass | No runtime validation yet |
| MAT-STEEL-001 | Brushed inox for pot/trays | High | reference | Proposed token `#AEB3AA` | Original design proposal; not a texture file | Use broad soft highlights and restrained roughness | No runtime validation yet |
| MAT-WOOD-001 | Dark worn timber | Medium | reference | Proposed token `#75513A` | Original design proposal; not a texture file | Add wear at contact points, not uniform dirt | No runtime validation yet |
| UI-REF-001 | UI typography and compact Vietnamese interaction prompt | High | reference | Visual Bible proposal; Inter candidate | Runtime font and redistribution terms not yet verified | Validate diacritics, readability and license before shipping | Not applicable until UI implementation |
| AUDIO-REF-001 | Early-morning alley ambience / stall sounds | Low | reference | No source selected | No asset acquired; rights open | Use original recording or explicit commercial-compatible license | Not applicable |

## Reference links to research and clear

These are discovery starting points, **not blanket permission to download or ship images**. Before adding any specific image to the game or a distributed pack, record the exact file page, creator, license, attribution requirement and date checked.

| Ref ID | Search / source | Intended research question | Rights handling |
|---|---|---|---|
| REF-SEARCH-001 | [Wikimedia Commons — Hanoi old alley / collective housing search](https://commons.wikimedia.org/wiki/Special:MediaSearch?type=image&search=Hanoi%20old%20alley%20collective%20housing) | Facade proportions, window/AC/laundry patterns, alley scale | Check each file's own license and attribution |
| REF-SEARCH-002 | [Wikimedia Commons — Vietnamese pho street food search](https://commons.wikimedia.org/wiki/Special:MediaSearch?type=image&search=Vietnamese%20pho%20street%20food) | Bowl, pot, garnish, serving arrangement | Check each file's own license; use as reference unless cleared for incorporation |
| REF-SEARCH-003 | [Unsplash — Hanoi alley search](https://unsplash.com/s/photos/hanoi-alley) | Light, color and street-life composition | Check current license and photo-specific restrictions; retain author/page details |
| REF-SEARCH-004 | [Unsplash — pho search](https://unsplash.com/s/photos/pho) | Food presentation and material reference | Check current license and photo-specific restrictions; retain author/page details |

## Required metadata for each acquired asset

- Stable asset ID and human-readable name
- File/source path and original source URL
- Creator/author and access date
- Exact license/terms and attribution requirements
- Intended uses: internal reference / public marketing / in-game / redistribution
- Original source file and export version
- Scale, pivot, forward axis, collision, material/texture dependencies
- State and reviewer
- Import/build check, screenshot or test evidence
- Known limitations and rights blockers

## Release gate

Any item with unknown source, unclear license, unreviewed AI output, watermark, real brand/logo, or unresolved likeness/copyright concern remains **reference-only or blocked**. Do not move it to `final`, `integrated` or `QA` until the issue is resolved and evidence is linked.
