---
name: cc-loop
description: Keep a project continuously maintained by Claude Code through Magpie's negative-feedback loop. Use when the user asks to "maintain this project in Magpie mode", "set up a routing table / lessons file / Loop workflow", or "have AI review PRs and accumulate lessons". Triggers: cc-loop, Magpie, harness, 错题本, 夜审, 路由表, AI 自主维护.
---

# cc-loop

Use an external constraint system — a routing table, a lessons file, and three Loops — to let AI maintain a project continuously inside explicit boundaries.

This file only routes. Load files under `references/` on demand; do not read them all at once.

All three source prompts are recovered verbatim from yetone's X screenshots reproduced in the AI智见录 article (2026-11-12); each Loop file contains the Chinese source prompt and an English operational version, with its exact provenance.

## Core principles

- **Route, don't pile up rules**: before working, the agent reads only the documents the current task needs.
- **Physical falsification**: when reviewing a PR, put the old code back and run the new test; the test must actually fail. Mark checks that were not run as `Not run`.
- **Lessons grow from incidents**: a lesson becomes a hard rule only after it appears in reviews on 3 different days.
- **Cheap filtering comes first**: listening tasks are filtered by a classifier before they reach the main model.
- **Human boundary**: product direction, UI/UX taste, and the physical setup of the verification environment are the human's responsibility.

## Initialize a user project

1. Read `references/agents-template.md` and create `AGENTS.md` plus a two-line `CLAUDE.md` at the repository root.
2. Read `references/lessons-format.md` and create the `LESSONS.md` skeleton.
3. Read `references/code-standards-template.md` and create `docs/code-standards.md`: start with 1–2 non-negotiable hard rules, and spell out the Acceptance criteria (what counts as a real run) and the product-decision rule.
4. Read `references/contributors-template.md` and create `docs/contributors.md`; read `references/subsystems-template.md` and create `docs/subsystems/README.md` plus the first subsystem page. If they exist, update rather than overwrite; confirm with the user before creating skeletons.
5. Magpie has no separate product or verification documents; do not create them. Product decisions and acceptance criteria live in `docs/code-standards.md`.

## Configure the three Loops

Load the relevant file on demand; do not read all of them at once:

- GitHub + Discord maintenance: `references/loop-github.md`
- X/Twitter listening (see the provenance note in the file): `references/loop-social.md`
- Night audit and lesson promotion: `references/loop-night-audit.md`
- Runtime, scheduling, and required tools: `references/loop-runtime.md`
- Connectors and tool contract: `references/connectors.md`
- Real surfaces to record: `references/verification-matrix.md`
- Copy-paste `/loop` templates: `references/loop-prompt-templates.md`

## Optional tools

- `scripts/lint-package.sh`: package-level lint (frontmatter, reference integrity, no runtime state, optional `claude plugin validate`). This is not Magpie's verification; the target project's test suite/CI remains the verification. Run it before every change.

Promotion is agent work: read `LESSONS.md`, count `Seen` and distinct dates, and move a rule into `docs/code-standards.md` once it has `Seen >= 3` on 3 distinct dates. No script is required.

## Verification environment (set up before the agent starts)

Write down "what counts as a real run" in the Acceptance criteria of `docs/code-standards.md`: how to start, how to run tests, and which checks must actually be executed. Record the surfaces actually run in `references/verification-matrix.md`; a surface not run is `Not run`. Without acceptance criteria, do not let Loop 1 start merging PRs.

## Review gate

Before merging, write the record in `references/pr-review-record.md`: reviewed head, harm check, what was run, Red check, Break check, and `Not run`. Check the head with `gh pr view <pr> --json headRefOid`, then merge with `gh pr merge <pr> --match-head-commit <sha>`.

## Human boundary

Product direction, UI/UX taste, and the physical setup of the verification environment are the human's responsibility. The agent executes and evolves rules inside those boundaries.
