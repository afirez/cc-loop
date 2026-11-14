# Skill package

## Responsibilities and boundaries

- `SKILL.md` routes Claude Code to the reference it needs; it does not duplicate the references.
- `references/` holds the templates and the three loop prompts (verbatim Chinese source + English operational version).
- `scripts/check-lessons-promotion.sh` scans a `LESSONS.md` and prints promotion candidates; it is read-only.
- The package does not schedule loops, call GitHub/Discord/X APIs, or enforce hooks. Those are the user's toolchain; the skill documents the requirements.

## Source of truth

- Routing: `SKILL.md`.
- Agent/project skeleton: `references/agents-template.md`.
- Lesson format and promotion: `references/lessons-format.md`.
- Verification and product rules: `references/code-standards-template.md`.
- Loop prompts: `references/loop-github.md`, `loop-social.md`, `loop-night-audit.md`.
- Candidate scanning: `scripts/check-lessons-promotion.sh`.
- Provenance and design record: `Handoff.md` §6.

## Runtime path

1. Claude Code discovers `.claude/skills/cc-loop/SKILL.md`.
2. `SKILL.md` sends the agent to one reference on demand.
3. The agent creates the project skeleton (`CLAUDE.md`, `AGENTS.md`, `LESSONS.md`, `docs/...`) from the templates.
4. The agent runs the loops and the scanner when the user's toolchain provides the required access.

## State

- No persistent state in the package. `LESSONS.md` and `docs/` live in the target project, not here.
- This repository is dogfooded: the root `LESSONS.md` and `docs/` are the method applied to this project.

## Verification commands

- `claude plugin validate .claude/skills`
- `sh .claude/skills/cc-loop/scripts/check-lessons-promotion.sh LESSONS.md`
- Frontmatter check: `name` matches the directory; `description` within limits.
- Reference integrity: every path in `SKILL.md` / `AGENTS.md` exists.

## Constraints

- `SKILL.md` stays under 500 lines and routes only; references are one level deep.
- Verbatim source blocks are immutable; operational English is separate.
- No secrets and no runtime state (`.omc/`, `.memsearch/`, `.omb/`) in the repo.

## Failure behavior

- Missing reference: the skill must report it, not silently invent a path.
- Missing script: the loop continues; the scanner is optional.
- No network/tool access: mark the check `Not run`; do not claim the loop ran.

## Upstream sources

The provenance matrix and links are in `Handoff.md` §6.5. The three loop prompts were recovered verbatim from yetone's X screenshots reproduced by AI智见录 (2026-11-12); the original X post is protected.
