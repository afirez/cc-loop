# Night audit — 2026-11-15

## Scope

- Repository: `afirez/cc-loop`, commit `9d3f45a` plus the dogfooding files added today.
- Reviewed: the initial skill package, the source-audit rework, the submodule setup, and the prompt recovery.

## Three classes

1. **Rework**: `docs/product.md` and `docs/verification.md` were invented, then removed; the three loop prompts were first marked unsourced, then recovered verbatim from screenshots.
2. **Should not have merged**: none; the repository was created from a single reviewed commit.
3. **Thin verification**: no end-to-end loop run; no scheduler or external connectors. Marked `Not run`.

## Lessons written

`LESSONS.md`:

- Do not add an upstream file path without checking it exists upstream.
- Treat a third-party article as a lead, not a primary source.
- Keep verbatim source blocks immutable.
- Do not commit agent-runtime state.
- Absorb a submodule's git directory when adding an existing repo.
- Re-run acceptance checks after a language/format change; cached numbers go stale.

## Promotion

`sh .claude/skills/cc-loop/scripts/check-lessons-promotion.sh LESSONS.md`

Result: no candidates. All lessons are `Seen 1×` on one date; promotion needs 3 different dates.

## Cleanup

- No malicious code.
- `.omc/` is ignored and not committed.

## Follow-ups

- ~~Add a README/install section~~ (done); decide whether to package as a plugin.
- Run a real end-to-end loop with a scheduler and connectors before claiming the loops are operational.
