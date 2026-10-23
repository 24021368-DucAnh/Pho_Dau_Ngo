# Vertical Slice Playtest Results

Status: **Template — no runtime playtest recorded yet**

Do not mark this document as a successful playtest until a person runs the build and records observations. CI success is not a substitute for manual gameplay acceptance.

## Session metadata

- Date/time:
- Tester:
- Commit SHA / PR:
- Build artifact:
- OS / CPU / GPU / RAM:
- Display resolution / window mode:
- Godot version:
- Session type: first play / regression / art review
- Duration:

## Build and startup

| Check | Result (Pass / Fail / Not run) | Evidence / notes |
|---|---|---|
| Clean checkout imports without errors | Not run | |
| Game launches to production main scene | Not run | |
| Input works and mouse capture can be released | Not run | |
| No missing resources or unexpected console errors | Not run | |

## Core interaction and kitchen loop

| Check | Result (Pass / Fail / Not run) | Evidence / notes |
|---|---|---|
| Player can move and collide with environment | Not run | |
| Kitchen stations can be focused at intended range | Not run | |
| Correct recipe sequence succeeds | Not run | |
| Wrong sequence is rejected without changing bowl state | Not run | |
| Missing ingredient is rejected without negative stock | Not run | |
| Repeated activation does not consume ingredients twice | Not run | |
| Cancelled preparation does not refund consumed ingredients | Not run | |
| Bowl ownership/location remains valid through pickup and placement | Not run | |

## Order, serving and economy loop

| Check | Result (Pass / Fail / Not run) | Evidence / notes |
|---|---|---|
| Order appears with the correct recipe and destination | Not run | |
| Correct bowl delivered to correct table completes the order | Not run | |
| Incomplete bowl cannot be served | Not run | |
| Wrong table delivery does not complete or pay the order | Not run | |
| Repeated serve action records revenue exactly once | Not run | |
| Day summary reconciles to ledger and inventory | Not run | |
| Closing day twice does not alter totals | Not run | |

Mark tests as **Not run** when the corresponding feature is not yet integrated; do not treat absence of the feature as a pass.

## Visual and interaction readability

| Viewpoint / check | Result (Pass / Fail / Not run) | Evidence / notes |
|---|---|---|
| Standing at the entrance / first arrival | Not run | |
| Looking across the counter and stock pot | Not run | |
| Focusing each cooking station | Not run | |
| Carrying bowl from station to table | Not run | |
| Placing bowl on target table | Not run | |
| Steam does not obscure interactable targets | Not run | |
| Materials, lighting and prop scale match Visual Bible intent | Not run | |
| UI remains readable at target resolution | Not run | |

## Defect log

For each issue, create one row. Link a GitHub issue when available.

| ID | Severity | Reproduction steps | Expected | Actual | Evidence | Owner / status |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

Severity guidance:
- **Blocker:** prevents startup, progress, correct serving, or data integrity.
- **Major:** core action is unreliable, state can be corrupted, or UI prevents understanding.
- **Minor:** visible polish/readability issue with a usable workaround.
- **Trivial:** cosmetic issue with no meaningful effect on play.

## Session outcome

- Core loop completed end to end: Not assessed
- Number of orders attempted:
- Number served correctly:
- Wrong-table attempts / rejected:
- Duplicate-payment attempts / rejected:
- Inventory or cash reconciliation discrepancy:
- Stuck or abandoned orders:
- Startup/runtime errors:
- Top three issues:
  1.
  2.
  3.
- Recommendation: Continue testing / Fix blockers / Ready for owner review
- Tester sign-off:
- Owner decision: Pending

## Evidence checklist

- [ ] Build artifact or reproducible commit recorded
- [ ] CI run linked separately from this manual report
- [ ] Screenshots or short capture attached for visual defects
- [ ] Defects filed with reproduction steps
- [ ] No untested feature marked as passed
- [ ] Owner acceptance recorded separately
