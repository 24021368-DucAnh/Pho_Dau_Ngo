# PROJECT_P — Session Handoff (refreshed 2026-10-23)

**Purpose:** Durable continuation point for Game Director work. Revalidate live GitHub state before acting; this document is a snapshot, not a substitute for live checks.

## 1. Current verified repository state

Repository: [24021368-DucAnh/Pho_Dau_Ngo](https://github.com/24021368-DucAnh/Pho_Dau_Ngo) (private)  
Default branch: `main`  
Snapshot checked: 2026-10-23, approximately 08:32 ICT.

- `main` HEAD: `0e159599a3b5c6010ffb8ad155d8a1312fa87f1a` — merge commit for PR #28.
- PR #28 [Ledger transaction contract](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/28): **merged** at `0e159599a3b5c6010ffb8ad155d8a1312fa87f1a`.
- PR #29 [Ledger contract tests](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/29): **open, draft**. Head `test/ledger-contract`, SHA `244baca94e991c88bff28fe79073cf3e1d1e51b9`; base `main`. It adds `game/tests/test_ledger_contract.gd` and a CI step.
- PR #32 [Ledger implementation](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/32): **open, draft**. Head `feat/ledger-implementation`, SHA `535f95064a14a5ba1d743445f6b2804ceff30b11`; base is PR #29's branch at `244baca94e991c88bff28fe79073cf3e1d1e51b9`. This is a stacked PR; preserve the dependency until an intentional integration decision is made.
- No PR was merged as part of this handoff refresh. Do not merge #29 or #32 without explicit owner approval.

## 2. CI evidence — do not mislabel cancellation as green

### Run #94 — valid clean RED evidence

[Run #94](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39839772923), branch `test/ledger-contract`, head `244baca94e991c88bff28fe79073cf3e1d1e51b9), conclusion **failure**.

Verified job steps:
- Godot 4.4.1 setup: passed.
- Import/parse production project: passed.
- Ledger contract tests: failed.
- Interaction, recipe, order/serving tests and exports: skipped after the expected failure.

The test branch intentionally failed because the production script `res://scripts/economy/ledger.gd` did not yet exist. This is the expected failing-first RED. Preserve this evidence; **do not rerun clean RED just to recreate the same failure**. Use run #94 as the historical RED reference.

### Run #95 — implementation candidate is not verified green

[Run #95](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39839955978), branch `feat/ledger-implementation`, head `535f95064a14a5ba1d743445f6b2804ceff30b11), conclusion **cancelled** (not success).

Verified steps:
- Import/parse: passed.
- Ledger contract tests: passed.
- Interaction contract tests: cancelled.
- Recipe validation, order/serving tests, Linux/Windows exports and artifact upload: skipped.

The run was cancelled; available run metadata does not establish why. Do not infer that the interaction tests failed or passed. Next verification should run the full workflow on the current implementation head, or a newer head after code changes. Preserve the passing import and ledger-test evidence while requiring the incomplete gates to run.

## 3. Source-of-truth document map

Read these documents before any substantial implementation or scope decision:

1. [GDD v1.2](PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md) — product fantasy, story, core loop and scope.
2. [Decision Log](DECISION_LOG.md) and [Audit Decision Log v1.2](PHO_DAU_NGO_AUDIT_DECISION_LOG_v1_2_Tieng_Viet.md) — owner-approved decisions and change protocol.
3. [Vertical Slice, Art & UI Production Specification](VERTICAL_SLICE_AND_ART_UI_PIPELINE_SPEC.md) — production/acceptance workflow.
4. [Ledger transaction contract](economy/LEDGER_TRANSACTION_CONTRACT.md) — ledger invariants and API expectations.
5. [Workflow acceptance checklist](design/pho-workflow-acceptance-checklist.md) — current automated/domain acceptance and open manual gates.
6. [Visual Bible](art/VISUAL_BIBLE.md) — grounded stylized realism; current document is still a draft for owner review, with palette and runtime benchmark provisional.
7. [Implementation Roadmap](IMPLEMENTATION_ROADMAP.md) and the detailed [vertical-slice implementation plan](superpowers/plans/2026-10-21-pho-dau-ngo-vertical-slice.md).

**Repository discrepancy found:** at `main` HEAD `0e159599...`, `docs/PROJECT_P_SESSION_HANDOFF.md` did not exist, so it could not be read as the prompt requested. This refreshed handoff is intended to establish that missing durable continuation file. The repo tree contains `docs/design/pho-workflow-acceptance-checklist.md`, but no clearly named standalone acceptance-matrix or playtest-template file was found in the checked tree. Do not claim either is present; create/locate them as separate follow-up work if required by the production spec.

**Stale-doc conflict to keep visible:** the production specification still has older wording that calls Godot a candidate and says engine selection remains open. The Decision Log and Implementation Roadmap record the owner's later explicit selection of Godot 4 for the vertical slice on 2026-10-22. Use the later owner decision and roadmap for current engine status; update stale wording through a documentation PR rather than silently changing the decision.

## 4. Ledger implementation review — current known boundary

PR #32 adds `game/scripts/economy/ledger.gd` (125 lines). From the PR patch, it currently implements:
- Typed opening cash, sale revenue and ingredient purchase records.
- In-memory append-only records, ID-based replay protection, payload-conflict rejection and detached read copies.
- One opening-cash entry per day, basic sign/type validation, day totals and idempotent day close.
- Rejection of new transactions after close and incomplete status for days without opening cash.

This is **not yet sufficient to claim production acceptance**:
- Run #95 is cancelled before interaction and downstream tests complete.
- Ledger state is in memory; persistence is not part of the first-day contract, but restart/durability must not be implied.
- ServingService in `game/scripts/serving/serving_service.gd` currently maintains its own in-memory `_paid_order_ids`, increments `payment_event_count`, and emits `payment_recorded`; it does **not** post to Ledger.
- Exactly-once payment is currently local to the ServingService instance. It is not yet proven end-to-end against the authoritative Ledger.
- The current ledger API accepts a caller-supplied transaction ID; integration must deterministically derive a stable sale transaction ID from the order ID (for example, a single documented prefix plus order ID) and use the order ID as source/reference. Same ID + same payload must replay safely; same ID + conflicting amount/day/type must fail without mutating totals.
- Day controller and end-of-day reconciliation are not verified as implemented. Do not infer they exist from ledger's `close_day` alone.

## 5. Required next execution sequence

1. Re-read live `main`, PR #29/#32 metadata, branch SHAs and newest Actions runs before touching code.
2. Review the full ledger contract and implementation diff. Check that contract tests exercise required invariants and identify missing assertions before extending implementation.
3. Preserve run #94 as clean RED. Do not recreate it.
4. Continue TDD for ServingService → Ledger:
   - Failure before successful serving creates no revenue.
   - Successful service posts one `sale_revenue` transaction with stable transaction ID derived from order ID.
   - Repeated serve/payment callback cannot post duplicate revenue.
   - Conflicting replay does not overwrite the original transaction or totals.
   - Failure to post ledger revenue must not leave order/payment state in a partially committed state; define and test ordering/rollback behavior.
   - Test a repeated signal/call and repeated service instance if feasible, not only one in-memory guard.
5. Add a day controller only after integration semantics are explicit. Define day ID, opening-cash initialization, open/closing states, order admission cutoff and failure handling.
6. Add end-of-day reconciliation derived from Ledger transactions and relevant inventory snapshot. It must report incomplete/mismatched state rather than silently correcting it.
7. Run full CI after meaningful changes. CI green is necessary but does not replace manual playtest.
8. Complete vertical-slice acceptance: prepare → open → serve representative orders → close → summary, with a real Godot desktop build and recorded owner/manual playtest evidence.
9. Keep PRs open pending owner approval. If stack dependencies are changed, document the branch/base SHA implications and revalidate all affected checks.

## 6. Engineering / Superpowers workflow guardrails

- Follow the repository's approved Superpowers-oriented workflow: clarify constraints and design, write a plan for non-trivial work, use failing tests before implementation, diagnose the actual failure, implement the smallest coherent change, run relevant tests, review the diff, and report evidence.
- Do not skip discovery/review to jump directly to code. For a task that changes behavior, state acceptance criteria before implementation.
- Do not call a test green based on partial steps, a cancelled run, a stale SHA, or an earlier branch.
- Separate **automated CI**, **local/runtime verification**, and **manual playtest** evidence.
- Do not mark a task done merely because code exists. Use statuses consistently:
  - **DONE & VERIFIED** — acceptance criteria passed with current-SHA evidence.
  - **IMPLEMENTED BUT NOT VERIFIED** — implementation exists; required checks incomplete.
  - **IN PROGRESS** — active work with a concrete next action.
  - **BLOCKED** — external dependency or decision prevents progress.
  - **NOT STARTED** — no implementation/evidence.
  - **STALE — NEEDS REVALIDATION** — prior evidence exists but does not cover the current head or has aged out.
- Every work report includes current SHA, PR, test/run links, changed files, result, known risks, next action and owner/manual action required.
- Never merge without explicit owner approval. Never fabricate local execution or manual evidence.

## 7. Current status table

| Work item | Status | Evidence / reason |
|---|---|---|
| Ledger contract documented | DONE & VERIFIED (documentation merged) | PR #28 merged at `0e159599...` |
| Ledger contract test authored | IMPLEMENTED BUT NOT VERIFIED as an integrated gate | PR #29 head `244baca...`; run #94 confirms expected RED before implementation |
| Ledger implementation authored | IMPLEMENTED BUT NOT VERIFIED | PR #32 head `535f950...`; run #95 ledger test passed but workflow cancelled before downstream checks |
| ServingService → Ledger integration | NOT STARTED / NOT VERIFIED | Current ServingService has only local paid-order guard and signal |
| Day controller | NOT STARTED / NOT VERIFIED | No verified implementation evidence |
| End-of-day reconciliation | NOT STARTED / NOT VERIFIED | Ledger totals exist; no verified end-to-end reconciliation |
| Manual vertical-slice playtest for this gate | NOT STARTED / NOT VERIFIED | CI cannot establish input feel, UI clarity or end-to-end usability |

## 8. Owner actions

- Review the implementation and test evidence when requested; explicitly approve any merge.
- Perform or authorize a manual PC playtest when a runnable build is available; record build SHA, platform, scenario, results and defects.
- Approve changes to game scope, economy assumptions, or design decisions through the Decision Log protocol.



## 9. Live continuation update — 2026-10-23 (supersedes affected status rows above)

This addendum was checked against live GitHub metadata after the initial handoff snapshot. Re-read live PRs/runs before future actions.

### Live repository / PR snapshot
- `main` remains at `0e159599a3b5c6010ffb8ad155d8a1312fa87f1a` (PR #28 merge); no merge was performed during this update.
- PR #29 remains open/draft at `244baca94e991c88bff28fe79073cf3e1d1e51b9`.
- PR #32 remains open/draft at `535f95064a14a5ba1d743445f6b2804ceff30b11`.
- PR #33 remains open/draft at `739f2f8e2bdaccbfc37d81a0c8e440acaa98bc0a` before this documentation update.
- PR #34 [ServingService → Ledger integration](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/34) remains open/draft, head `0ce28d33c4bbf131d35907f42b8c59f1e6317e1c`, base PR #32 head `535f95064a14a5ba1d743445f6b2804ceff30b11`. It adds a stable `sale:<order_id>` transaction ID, caller-supplied positive sale amount, Ledger posting, and order lifecycle assertions. Do not merge the stack without explicit owner approval.

### Run #96 diagnosis — evidence narrows the failure, but does not prove root cause
- [Run #96](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39892936199) uses workflow `.github/workflows/godot-production.yml` at head `0ce28d33c4bbf131d35907f42b8c59f1e6317e1c`.
- Attempt 1 job [120216659859](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39892936199/job/120216659859) and attempt 2 job [120221726186](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39892936199/job/120221726186) both report `completed / failure`, `steps: []`, `runner_id: 0`, blank runner name, and only about two seconds between job start and completion.
- Job-log retrieval returns Azure `BlobNotFound`; the run exposes no artifacts. By contrast, run #94 has a real runner ID, step records, and took about 32 seconds.
- This is strong evidence that run #96 failed before normal runner step execution/step reporting. **It is not enough to identify the underlying cause** (e.g. GitHub Actions scheduling, cancellation/runner infrastructure, or another platform-level failure); do not label it a GDScript/test failure and do not claim an infrastructure root cause as proven.
- One retry of failed jobs was already performed; attempt 2 reproduced the same no-runner/no-steps signature. Do not repeatedly rerun without new evidence.
- The workflow file itself has the expected checkout → setup Godot 4.4.1 → import/parse → ledger test → interaction test → recipe test → order/serving test → desktop exports. No workflow edit is justified by current evidence alone.
- Links: [attempt 1 job](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39892936199/job/120216659859), [attempt 2 job](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39892936199/job/120221726186).

### Updated implementation review
- PR #34 is **IMPLEMENTED BUT NOT VERIFIED**. The lifecycle test now expects a successful serve to create one revenue transaction and a total of two ledger records including opening cash. This has not passed CI because run #96 did not execute/report any steps.
- Concrete review gap: `game/tests/test_order_lifecycle.gd` calls `serving.configure_ledger(ledger, &"day-01")` without asserting its returned `ok` flag. The later revenue assertion would likely detect a failed configuration indirectly, but an explicit assertion would make the setup failure local and diagnostic. Treat this as a small test-quality follow-up, not the cause of run #96.
- Known transactional risk remains: Ledger posting occurs before OrderManager transitions to SERVED. If that transition fails after the sale record is accepted, Ledger and order state can diverge. Do not invent rollback/compensation semantics; first define a deliberate contract and test the failure path.
- The ledger remains in-memory. Do not claim persistence or cross-process exactly-once behavior.
- PR #34 still needs full CI evidence for import/parse, Ledger contract, interaction, recipe validation, order lifecycle/serving, Linux/Windows export and artifact upload. Manual desktop playtest is a separate later gate.

### Corrected current status
| Work item | Status | Evidence |
|---|---|---|
| Ledger contract docs | DONE & VERIFIED as merged docs | PR #28 at `0e159599...` |
| Ledger test-first RED | DONE & VERIFIED as historical RED evidence | Run #94: setup/import passed; Ledger test failed as expected because implementation was absent |
| Ledger implementation | IMPLEMENTED BUT NOT VERIFIED end-to-end | PR #32; run #95 ledger test passed, workflow cancelled before downstream gates |
| ServingService → Ledger integration | IMPLEMENTED BUT NOT VERIFIED | PR #34 head `0ce28d3...`; run #96 never reported steps |
| Run #96 failure cause | BLOCKED / root cause unknown | Two attempts, both no runner/steps; logs BlobNotFound |
| Atomicity/recovery contract | IN PROGRESS | Sale is posted before order transition; no failure-path contract/test yet |
| Day controller and end-of-day reconciliation | NOT STARTED / NOT VERIFIED | No current evidence of implementation |
| Manual vertical-slice playtest | NOT STARTED | No verified runnable artifact from this gate |

### Next execution gate
1. Preserve run #94; do not recreate the clean RED.
2. Do not make code changes to “fix” run #96 without a runner/step-level failure signal.
3. Resume TDD work only on independently grounded gaps: explicitly assert Ledger configuration in the lifecycle test, then add tests for Ledger rejection/no order transition and duplicate/conflicting replay. Before implementing recovery, agree on the order/Ledger atomicity contract.
4. Obtain a usable current-head Actions run (with real runner and steps) before claiming CI green. If GitHub again reports no runner and no steps, collect run/check-suite metadata and use GitHub Actions service diagnostics rather than changing game code speculatively.
5. Keep all PRs open pending owner approval; no merge/reset/delete/deploy has been performed.

### Owner action clarity
- **No approval is needed for this documentation-only update.**
- Owner approval is still required before merging any PR.
- No manual Godot/playtest action is requested yet because a current verified build artifact is not available.


## 10. Continuation update — 2026-10-23, after test commit on PR #34

### Test change committed
- Commit: [`7852061235c78469bb0a660d488c6233ed6ab848`](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/commit/7852061235c78469bb0a660d488c6233ed6ab848)
- PR #34 head is now `7852061235c78469bb0a660d488c6233ed6ab848`; base remains PR #32 head `535f95064a14a5ba1d743445f6b2804ceff30b11`.
- `game/tests/test_order_lifecycle.gd` now explicitly asserts `configure_ledger(...).ok`.
- Added a closed-day rejection scenario using an isolated Ledger/ServingService fixture. Assertions cover: serving is rejected; order remains READY; no payment event is counted; transaction count remains one opening-cash record, proving no sale was added.
- The test change is committed and diff-reviewed. It has **not** been verified by Godot runtime because the associated CI run did not execute any workflow steps.

### Run #97 confirms the same CI symptom
- [Run #97](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39899338387), head `7852061235c78469bb0a660d488c6233ed6ab848`, failed in about two seconds.
- Job [120237016684](https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39899338387/job/120237016684) reports `steps: []`, `runner_id: 0`, blank runner name, and no output summary. This reproduces the same failure signature seen in both attempts of run #96.
- Therefore the newly added GDScript assertions are **not evidenced as the cause**: no runner/step was recorded. Root cause remains unknown. The pattern now spans runs #96 and #97 (including a retry of #96); do not keep rerunning blindly. Seek GitHub Actions service/runner diagnostics or a separate authorized execution environment before changing workflow configuration.
- No Godot test result can be inferred from this run.

### Current statuses after this continuation
| Item | Status | Evidence |
|---|---|---|
| Closed-day serving rejection test | COMMITTED; DIFF REVIEWED; RUNTIME NOT VERIFIED | Commit `7852061...`, PR #34 |
| PR #34 CI | BLOCKED — no runner/steps | Run #97; same signature as #96 |
| Ledger integration end-to-end | IMPLEMENTED BUT NOT VERIFIED | No current successful complete workflow |
| Atomicity if order transition fails after Ledger post | OPEN DESIGN/TEST GAP | Ledger post precedes order transition |
| CI root cause | UNKNOWN / BLOCKED | Three failed executions across runs #96/#97 without runner steps; one retry already used |
| Merge / deployment | NOT DONE | No merge, reset, deletion, or deployment performed |

### Next action
1. Do not rerun CI again without a new diagnostic hypothesis or platform-side evidence.
2. Inspect check-run annotations and GitHub Actions service/runner details if connector/API access permits; if not, record that limitation rather than guessing.
3. Continue only with code-reviewable, contract-backed tests. Before implementation of recovery/compensation, define the desired atomicity semantics.
4. Revalidate all live PR heads before future changes.

### Owner action
- No manual action is required right now.
- No PR approval/merge requested. Owner approval remains required before any merge.
- Manual playtest remains blocked until a build artifact is successfully produced and verified.
