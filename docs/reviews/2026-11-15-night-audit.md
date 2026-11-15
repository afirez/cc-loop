# Night audit — 2026-11-15

## Scope

- Repository: `afirez/cc-loop`, commit `9d3f45a` plus the dogfooding files added today.
- Reviewed: the initial skill package, the source-audit rework, the submodule setup, and the prompt recovery.

## Three classes

1. **Rework**: `docs/product.md` and `docs/verification.md` were invented, then removed; the three loop prompts were first marked unsourced, then recovered verbatim from screenshots; the skill routed to contributors/subsystems docs it did not template.
2. **Should not have merged**: none; the repository was created from a single reviewed commit.
3. **Thin verification**: the first acceptance criteria were prose-only and nothing executed them. `lint-package.sh` + `.github/workflows/lint-package.yml` now run the package lint. Real loop execution with a scheduler and external connectors is still `Not run`. The `collect-day.sh` / `merge-reviewed.sh` wrappers were removed in favor of native `git`/`gh` commands.

## Lessons written

`LESSONS.md`:

- Do not add an upstream file path without checking it exists upstream.
- Treat a third-party article as a lead, not a primary source.
- Keep verbatim source blocks immutable.
- Do not commit agent-runtime state.
- Absorb a submodule's git directory when adding an existing repo.
- Re-run acceptance checks after a language/format change; cached numbers go stale.
- A skill that routes to a document it does not template is incomplete.
- A documented acceptance criterion without an executable check is not a gate.
- A runtime contract is part of the method; prompts alone do not schedule or connect.
- A missing optional tool degrades to `Not run`, never to a silent pass.
- Review the merged result, not only the PR head.
- Label a reimplementation as a reimplementation; name the upstream analog.
- Prefer native commands over wrappers for one-command jobs.
- Promotion is an agent judgment, not a script.
- A checker's test suite needs broken fixtures, not only a valid one.
- A 3-OS matrix on a shell tool catches portability assumptions.
- A release workflow is a gate, not a tag button.
- A connector contract is not a connector.
- A release workflow is only proven by a real tag.
- A copy-paste template is not the verbatim source.

## Promotion

The agent reads `LESSONS.md` and counts `Seen` and distinct dates. All lessons are `Seen 1×` on one date, so none meet the 3-distinct-date rule. No script is used.

## Cleanup

- No malicious code.
- `.omc/` is ignored and not committed.

## Follow-ups

- ~~Add a README/install section~~ (done); ~~add contributors/subsystems templates and a package lint + CI~~ (done); ~~replace the two wrappers with native commands~~ (done).
- ~~Add a runtime contract~~ (done: `loop-runtime.md`).
- Decide whether to package as a plugin.
- Run a real end-to-end loop with a scheduler and connectors before claiming the loops are operational.
