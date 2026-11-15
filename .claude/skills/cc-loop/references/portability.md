# Portability: Claude Code, Codex, OpenCode

This skill is packaged as a Claude Code Agent Skill. The method files are plain Markdown and portable; discovery and `/loop` are not.

| Tool | Discovery | Loop start | Status |
|---|---|---|---|
| Claude Code | `.claude/skills/cc-loop/SKILL.md`; `/cc-loop` | `/loop <prompt>` | native |
| Codex | reads `AGENTS.md`; does not discover `.claude/skills` | `/loop` is reported by dotey's thread; otherwise manual/cron | method docs portable; `/loop` claim is secondary, not verified here |
| OpenCode | reads `AGENTS.md`; uses its own agent/command configuration; no `.claude/skills` | manual/cron; no verified `/loop` | method docs portable; not verified |

## What is portable

- `AGENTS.md` routing, `LESSONS.md`, `docs/code-standards.md`, `docs/contributors.md`, `docs/subsystems/`.
- The three loop prompts and `loop-prompt-templates.md`.
- `tests/run.sh` and `lint-package.sh` (POSIX shell).
- `connectors.md`, `verification-matrix.md`, `test-discovery.md`, `ci-template.md`.

## What is Claude Code-only

- `.claude/skills/cc-loop` discovery and `/cc-loop`.
- `SKILL.md` frontmatter and `claude plugin validate`.
- `/loop` (Claude Code; Codex reported by a secondary source; OpenCode not verified).

## How to use in Codex

1. Initialize the project once with Claude Code, or copy the method templates.
2. Codex reads `AGENTS.md` and the routed docs.
3. Start the loop with a prompt template; if `/loop` is unavailable, run it manually or via cron.
4. Keep the review record on the PR; use native `gh`.

## How to use in OpenCode

1. Initialize or copy the same method files.
2. Wire `AGENTS.md` into OpenCode's agent/command configuration.
3. Start the loop manually or via cron; do not assume `/loop`.
4. Keep the review record on the PR; use native `gh`.

## Not claimed

- Native Codex or OpenCode skill discovery.
- Verified `/loop` behavior in Codex or OpenCode.
