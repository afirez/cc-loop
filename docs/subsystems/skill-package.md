# Skill package

## Responsibilities and boundaries

- `SKILL.md` routes Claude Code to the reference it needs; it does not duplicate the references.
- `references/` holds the templates, the three loop prompts (verbatim Chinese source + English operational version), the review record, and the runtime contract.
- `scripts/check-lessons-promotion.sh` scans a `LESSONS.md` and prints promotion candidates; `verify.sh` runs the package acceptance checks; `collect-day.sh` gathers night-audit input; `merge-reviewed.sh` merges only at the reviewed head.
- `.github/workflows/verify.yml` runs `verify.sh` on push/PR.
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
- Candidate scanning: `scripts/check-lessons-promotion.sh`.
- Executable gate: `scripts/verify.sh`; CI: `.github/workflows/verify.yml`.
- Provenance and design record: `Handoff.md` §6.

## Runtime path

1. Claude Code discovers `.claude/skills/cc-loop/SKILL.md`.
2. `SKILL.md` sends the agent to one reference on demand.
3. The agent creates the project skeleton (`CLAUDE.md`, `AGENTS.md`, `LESSONS.md`, `docs/...`) from the templates.
4. The agent runs the loops and the scanner when the user's toolchain provides the required access.
5. Before a change is pushed, `scripts/verify.sh` runs the package checks; CI runs the same script on push/PR.

## State

- No persistent state in the package. `LESSONS.md` and `docs/` live in the target project, not here.
- This repository is dogfooded: the root `LESSONS.md` and `docs/` are the method applied to this project.

## Verification commands

- `sh .claude/skills/cc-loop/scripts/verify.sh`
- `claude plugin validate .claude/skills` (verify.sh runs it when `claude` is available; otherwise `Not run`)
- `sh .claude/skills/cc-loop/scripts/check-lessons-promotion.sh LESSONS.md`
- `sh .claude/skills/cc-loop/scripts/collect-day.sh "24 hours ago"`
- `sh .claude/skills/cc-loop/scripts/merge-reviewed.sh <pr> <reviewed-sha>` (requires `gh`)
- Frontmatter check: `name` matches the directory; `description` within limits.
- Reference integrity: every path in `SKILL.md` / `AGENTS.md` exists.

## Constraints

- `SKILL.md` stays under 500 lines and routes only; references are one level deep.
- Verbatim source blocks are immutable; operational English is separate.
- No secrets and no runtime state (`.omc/`, `.memsearch/`, `.omb/`) in the repo.
- A merge uses `references/pr-review-record.md` and `--match-head-commit` (or `scripts/merge-reviewed.sh`).

## Failure behavior

- Missing reference: `verify.sh` fails; the skill must report it, not silently invent a path.
- Missing `claude`: `verify.sh` marks the validation `Not run`; the rest of the checks still run.
- Missing `gh`: `collect-day.sh` marks PRs `Not run`; `merge-reviewed.sh` exits 2; do not invent PR data or merge.
- No network/tool access: mark the check `Not run`; do not claim the loop ran.

## Upstream sources

The provenance matrix and links are in `Handoff.md` §6.5. The three loop prompts were recovered verbatim from yetone's X screenshots reproduced by AI智见录 (2026-11-12); the original X post is protected.
