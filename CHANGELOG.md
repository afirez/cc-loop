# Changelog

## Unreleased

- Release gate: require `vX.Y.Z` on `main`, reject an existing release, serialize release runs, and mark Latest only when no higher release exists.
- CI: add concurrency so main test runs finish and a PR's older run is cancelled by its next push.
- Docs: post the PR review record as a PR comment instead of writing it into the template.
- Tests: check the workflow and review-record gates.

## v0.1.0 — 2026-11-15

- Initial `cc-loop` skill: routing, lessons format, code standards, contributors/subsystems templates, PR review record, runtime/connectors/verification contracts.
- Verbatim Chinese source prompts for the three loops, with provenance; English operational versions.
- Package lint, fixture test suite, 3-OS CI, and a tag-triggered release workflow.
- Dogfooded on this repository: `CLAUDE.md`, `AGENTS.md`, `LESSONS.md`, `docs/`.
