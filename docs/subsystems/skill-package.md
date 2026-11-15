# Skill package

## Responsibilities and boundaries

- `SKILL.md` routes Claude Code to the reference it needs; it does not duplicate the references.
- `references/` holds the templates, the three loop prompts (verbatim Chinese source + English operational version), the review record, and the runtime contract.
- `scripts/lint-package.sh` runs the package lint.
- Promotion is agent work: read `LESSONS.md`, count `Seen` and distinct dates, and edit `docs/code-standards.md`; no script is required.
- `tests/run.sh` tests the package lint against good and broken fixtures.
- `.github/workflows/test.yml` runs the tests and lint on Ubuntu, macOS, and Windows; `.github/workflows/release.yml` packages a tagged release.
- `.github/ISSUE_TEMPLATE/` holds the bug/feature intake forms.
- The package does not schedule loops, call GitHub/Discord/X APIs, or enforce another project's hooks. Those are the user's toolchain; the skill documents the requirements.

## Source of truth

- Routing: `SKILL.md`.
- Agent/project skeleton: `references/agents-template.md`.
- Lesson format and promotion: `references/lessons-format.md`.
- Verification and product rules: `references/code-standards-template.md`.
- Community PR rules: `references/contributors-template.md`.
- Subsystem references: `references/subsystems-template.md`.
- Review record / merge gate: `references/pr-review-record.md`.
- Scheduling and tool contract: `references/loop-runtime.md`.
- Loop prompts: `references/loop-github.md`, `loop-social.md`, `loop-night-audit.md`.
- Connectors and tool contract: `references/connectors.md`.
- Real surfaces: `references/verification-matrix.md`.
- Loop templates: `references/loop-prompt-templates.md`.
- Package tests: `tests/run.sh`; CI: `.github/workflows/test.yml`; release: `.github/workflows/release.yml`.
- Promotion: agent reads `LESSONS.md`; no script.
- Package lint: `scripts/lint-package.sh`; tests: `tests/run.sh`; CI: `.github/workflows/test.yml`.
- Provenance and design record: `Handoff.md` §6.

## Runtime path

1. Claude Code discovers `.claude/skills/cc-loop/SKILL.md`.
2. `SKILL.md` sends the agent to one reference on demand.
3. The agent creates the project skeleton (`CLAUDE.md`, `AGENTS.md`, `LESSONS.md`, `docs/...`) from the templates.
4. The agent runs the loops and the scanner when the user's toolchain provides the required access.
5. Before a change is pushed, `scripts/lint-package.sh` runs the package lint; `tests/run.sh` tests it; CI runs both on three OSes on push/PR.

## State

- No persistent state in the package. `LESSONS.md` and `docs/` live in the target project, not here.
- This repository is dogfooded: the root `LESSONS.md` and `docs/` are the method applied to this project.

## Verification commands

- `sh tests/run.sh`
- `sh .claude/skills/cc-loop/scripts/lint-package.sh` (package lint; not the target project's test suite)
- `claude plugin validate .claude/skills` (lint-package.sh runs it when `claude` is available; otherwise `Not run`)
- `grep -n "Seen" LESSONS.md` (agent counts candidates; no script)
- Native commands: `git log --since="24 hours ago" ...`; `gh pr list --state merged --limit 50 ...`; `gh pr view <pr> --json headRefOid`; `gh pr merge <pr> --match-head-commit <sha>`
- Frontmatter check: `name` matches the directory; `description` within limits.
- Reference integrity: every path in `SKILL.md` / `AGENTS.md` exists.

## Constraints

- `SKILL.md` stays under 500 lines and routes only; references are one level deep.
- Verbatim source blocks are immutable; operational English is separate.
- No secrets and no runtime state (`.omc/`, `.memsearch/`, `.omb/`) in the repo.
- A merge uses `references/pr-review-record.md` and `--match-head-commit`.

## Script provenance

- `lint-package.sh` is a cc-loop package lint, not Magpie's verification. Magpie's analogs are `.github/workflows/test.yml`, `make test`, `make test-ui`, `build/race-shards.sh`, and real machines.
- Night-audit collection and the reviewed-head merge are native `git` / `gh` commands; the skill ships no wrappers for them.
- Promotion is an agent judgment (read `LESSONS.md`, count `Seen`/dates, edit `code-standards.md`), not a script.

## Failure behavior

- Missing reference: `lint-package.sh` fails; the skill must report it, not silently invent a path.
- Missing `claude`: `lint-package.sh` marks the validation `Not run`; the rest of the checks still run.
- Missing `gh`: native PR commands fail or are skipped; mark them `Not run`; do not invent PR data or merge.
- No network/tool access: mark the check `Not run`; do not claim the loop ran.

## Upstream sources

The provenance matrix and links are in `Handoff.md` §6.5. The three loop prompts were recovered verbatim from yetone's X screenshots reproduced by AI智见录 (2026-11-12); the original X post is protected.
