# Project_P — Phở Đầu Ngõ: Handoff for the Next Chat

Updated: 2026-10-23 (Asia/Ho_Chi_Minh)

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

PRs are draft/open unless GitHub metadata says otherwise. Do not merge blindly; check base/head, CI, changed files, and conflicts first.

## Immediate technical state

- Aged aluminum stock-pot art implementation exists on branch/PR #26; visual approval is not yet established.
- Kitchen preparation, recipe validation, minimal inventory, order lifecycle and serving-domain tests exist.
- Serving and inventory are not yet wired into a complete authoritative cash/economy loop.
- Missing or not yet integrated: authoritative ledger, customer spawn/wait loop, day controller, end-of-day summary, save/load, final integrated UI/art.
- Manual gameplay/playtest evidence has not been recorded. Automated CI is not manual acceptance.
- No local Godot runtime is available in the ChatGPT tool session; use GitHub Actions for Godot runtime validation and report exact job/step evidence.

## TDD / CI incident and correction

The ledger test was added before production implementation. The first CI run failed at the test step, but not cleanly: the missing `Ledger` class caused cascading GDScript type-inference parse errors. This is **not** an acceptable clean RED result.

The ledger test was then changed to dynamically load `res://scripts/economy/ledger.gd`, with explicit types for values returned by the ledger. The expected pre-implementation failure is now a runtime assertion that the ledger script cannot be loaded. A new CI run must confirm this before production implementation is considered TDD-compliant.

The workflow was reordered so ledger tests run immediately after import/parse, before the slower interaction contract test. Because the workflow uses `cancel-in-progress: true`, a new commit can cancel an older run; always inspect the latest run for the current head SHA.

## Required next actions

1. Inspect the newest Actions run for PR #29 and verify the exact failing step/log. The clean RED must be the missing ledger script assertion, not syntax or import failure.
2. If the test itself fails to execute cleanly, fix the test first and rerun; do not write production code until RED is valid.
3. Implement `game/scripts/economy/ledger.gd` minimally to satisfy `game/tests/test_ledger_contract.gd`: append-only transactions; integer amounts; opening cash exactly once per day; sale revenue positive; ingredient purchases negative; transaction IDs idempotent for identical payloads and rejected for conflicting payloads; immutable/copy-on-read transaction dictionaries; day totals/reconciliation; idempotent close; reject transactions after close; mark missing opening cash incomplete.
4. Add a focused test for every bug discovered, run the ledger test, then all existing Godot tests and both desktop exports in CI. Never claim green based on a partial job.
5. Integrate ServingService with the ledger only after ledger contract tests pass. Prevent duplicate revenue by using a stable transaction ID derived from the served order ID. Do not charge revenue on incomplete/invalid service.
6. Add inventory purchase accounting only after the business rule is explicit; do not silently treat ingredient consumption as cash expense if it was already paid at purchase time.
7. Complete the day summary and its reconciliation tests. Then update README, acceptance matrix, and playtest template with verified outcomes.
8. Keep art work separate from economy logic. Request owner visual review for the stock pot and lighting; Visual Bible stays Draft until accepted.

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
