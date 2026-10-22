# Project_P — Phở Đầu Ngõ: Handoff for the Next Chat

Updated: 2026-10-23 (Asia/Ho_Chi_Minh; CI/PR state last checked during this session)

## Purpose

This file is the operational handoff for continuing work in a new ChatGPT conversation. Read it together with the current GDD, decision log, production pipeline spec, acceptance matrix, and open PRs. Do not treat this file as proof that runtime acceptance has passed.

## Current source of truth

- Repository: `24021368-DucAnh/Pho_Dau_Ngo`
- Production branch: `main`
- Godot version in CI: 4.4.1 Standard
- Production scene: `game/scenes/main.tscn`
- Art showcase scene: `game/scenes/stylized_vertical_slice.tscn`
- GDD: `docs/PHO_DAU_NGO_GDD_v1_2_Tieng_Viet.md`
- Decision log: `docs/PHO_DAU_NGO_AUDIT_DECISION_LOG_v1_2_Tieng_Viet.md` and `docs/DECISION_LOG.md`
- Production pipeline: `docs/VERTICAL_SLICE_AND_ART_UI_PIPELINE_SPEC.md`
- Visual Bible: `docs/art/VISUAL_BIBLE.md` (Draft; owner visual review still pending)
- Implementation plan: `docs/superpowers/plans/2026-10-21-pho-dau-ngo-vertical-slice.md`

## Current open pull requests

- PR #27: vertical-slice acceptance matrix and prototype scope in README — https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/27
- PR #28: ledger transaction contract — https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/28
- PR #29: ledger contract tests and CI — https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/29
- PR #30: manual playtest evidence template — https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/30
- PR #32: append-only cash ledger implementation, stacked on PR #29's test branch — https://github.com/24021368-DucAnh/Pho_Dau_Ngo/pull/32

PRs are draft/open unless GitHub metadata says otherwise. Do not merge blindly; check base/head, CI, changed files, and conflicts first.

## Immediate technical state

- Aged aluminum stock-pot art implementation exists on branch/PR #26; visual approval is not yet established.
- Kitchen preparation, recipe validation, minimal inventory, order lifecycle and serving-domain tests exist.
- Serving and inventory are not yet wired into a complete authoritative cash/economy loop.
- Ledger implementation candidate exists in PR #32 (`feat/ledger-implementation`, head `535f95064a14a5ba1d743445f6b2804ceff30b11`), stacked on PR #29. It is not considered validated until the current-head CI run finishes successfully.
- Missing or not yet integrated: ledger-to-serving/payment integration, customer spawn/wait loop, day controller, end-of-day summary, save/load, final integrated UI/art.
- Manual gameplay/playtest evidence has not been recorded. Automated CI is not manual acceptance.
- No local Godot runtime is available in the ChatGPT tool session; use GitHub Actions for Godot runtime validation and report exact job/step evidence.

## TDD / CI incident and current ledger gate

- PR #29 adds the ledger contract test before the production implementation. CI run #94 confirmed a clean RED: import/parse passed, then the ledger test failed because `res://scripts/economy/ledger.gd` did not exist. Run: https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39839772923
- An earlier run #93 failed due to invalid GDScript type inference in the test; this was fixed. Do not treat #93 as the valid RED.
- PR #32 implements `game/scripts/economy/ledger.gd`, with transaction validation, idempotent replay, copy-on-read, daily totals, and idempotent close. It is stacked on PR #29's branch so the test remains the contract.
- Current GREEN candidate CI run #95 is in progress for PR #32 head `535f95064a14a5ba1d743445f6b2804ceff30b11`: https://github.com/24021368-DucAnh/Pho_Dau_Ngo/actions/runs/39839955978
- At the latest inspection, import/parse had passed and the job was still running at **Run interaction contract tests**; ledger test step had already been passed according to the run's sequence, but the overall workflow is not green until interaction tests, kitchen recipe tests, order lifecycle/serving tests, Linux and Windows exports, and artifact upload finish successfully. Re-check the current run rather than relying on this snapshot.
- Workflow uses `cancel-in-progress: true`; new commits can cancel older runs. Always verify the latest run for the exact current head SHA.

## Required next actions

1. Poll CI run #95 and inspect every job step. If it fails, fetch logs and repair the smallest reproducible issue; add/adjust tests first for newly discovered defects.
2. If run #95 is fully green, review PR #32 diff and contract behavior. Then merge PR #29 before PR #32 only with owner approval; after #29 merges, update PR #32's base to `main` or rebase it, and rerun CI against the resulting commit. Do not merge PR #32 before its test contract is present on the target branch.
3. Review PR #28's ledger transaction contract against the implementation, especially closing-day behavior, sign conventions, idempotency and missing-opening-cash completeness.
4. After the ledger is green and integrated, add test-first ServingService → Ledger payment integration using a stable transaction ID derived from the served order ID. Invalid/incomplete service must not record revenue; duplicate service must not create duplicate revenue.
5. Add inventory purchase accounting only after the business rule is explicit; ingredient consumption is not a new cash expense if the stock was already paid for.
6. Implement a day controller/end-of-day summary with reconciliation tests. Then update acceptance matrix and playtest evidence based only on verified outcomes.
7. Keep visual work separate from economy logic. Stock-pot visual approval and Visual Bible owner review remain pending.

## How to continue in a new chat

Paste this request (or ask ChatGPT to read this file and the current repository state):

> Continue Project_P Game Director work on Phở Đầu Ngõ. First read the GDD v1.2, decision logs, production pipeline spec, this handoff, and inspect main plus all open PRs. Continue real implementation work, not just planning. Start with PR #29: inspect latest CI logs and establish a clean RED for the ledger contract test before writing production code. Use test-first workflow, verify changes in GitHub Actions, and work on independent tasks while CI runs. Keep the main branch protected from unverified work. Report concise but complete status: current gate, changes/commits/PR links, tests actually passed/failed, unverified items, next actions, and what I need to do manually.

## When should a new chat be opened?

Open a new chat when the current conversation becomes slow, loses important working context, or after a meaningful gate is completed (e.g. ledger implemented and green, economy integration green, or vertical-slice playtest accepted). Do not start a new chat merely because CI is running. Before switching, ensure this handoff is updated with exact branch names, commit SHAs, PR URLs, latest CI run URLs/results, and next gate.

## What the user must do manually

- Review/approve PRs and decide when to merge; do not assume approval.
- Run the game locally in Godot to evaluate feel, visuals, input, collision and end-to-end gameplay when a build is available.
- Record actual playtest outcomes and attach screenshots/video or notes.
- Give visual direction approval for art assets and the Visual Bible.
