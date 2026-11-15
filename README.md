# cc-loop

A Claude Code skill that applies Magpie's negative-feedback maintenance loop to any repository: a routing table, a lessons file, and three `/loop` workflows.

`cc-loop` is a **playbook + templates + one read-only scanner**, not an autonomous daemon. It tells Claude Code how to route work, review PRs, accumulate lessons, and run the three loops; scheduling and external connectors stay in your toolchain.

This repository also dogfoods the method on itself: `CLAUDE.md`, `AGENTS.md`, `LESSONS.md`, and `docs/` are the method applied to `cc-loop`.

## What's inside

```text
.
├── .claude/skills/cc-loop/
│   ├── SKILL.md                     # routes to references on demand
│   ├── references/
│   │   ├── agents-template.md       # AGENTS.md + two-line CLAUDE.md
│   │   ├── lessons-format.md        # LESSONS.md format + promotion rule
│   │   ├── code-standards-template.md
│   │   ├── contributors-template.md # community PR harm/close/blocklist
│   │   ├── subsystems-template.md   # subsystem reference + verification
│   │   ├── pr-review-record.md      # reviewed head / Red check / Not run
│   │   ├── loop-runtime.md          # scheduling + tool contract
│   │   ├── loop-github.md           # Loop 1: GitHub + Discord
│   │   ├── loop-social.md           # Loop 2: X/Twitter
│   │   └── loop-night-audit.md      # Loop 3: night audit
│   └── scripts/
│       ├── check-lessons-promotion.sh
│       ├── verify.sh                # executable acceptance gate
│       ├── collect-day.sh           # night-audit input collector
│       └── merge-reviewed.sh        # reviewed-head merge gate
├── .github/workflows/verify.yml     # CI runs verify.sh
├── CLAUDE.md                        # dogfood: @AGENTS.md + @LESSONS.md
├── AGENTS.md                        # dogfood: task routing
├── LESSONS.md                       # dogfood: real lessons from this repo
├── docs/                            # dogfood: standards, contributors, reviews
└── Handoff.md                       # design record + source provenance
```

Each Loop file contains the **verbatim Chinese source prompt** recovered from yetone's X screenshots, plus an **English operational version** and its provenance.

The three helper scripts are cc-loop implementations, not files copied from Magpie. Magpie's analogs are its CI workflow (`test.yml`), `make test` / `make test-ui`, `build/race-shards.sh`, and the documented `gh pr merge --match-head-commit` command; its night-audit collection is not in the repository.

## Install

The skill directory must end up at `<project>/.claude/skills/cc-loop/` (project scope) or `~/.claude/skills/cc-loop/` (personal scope).

### Option A — copy into a project (recommended)

```bash
git clone https://github.com/afirez/cc-loop.git
mkdir -p /path/to/your-project/.claude/skills
cp -R cc-loop/.claude/skills/cc-loop /path/to/your-project/.claude/skills/cc-loop
```

PowerShell:

```powershell
git clone https://github.com/afirez/cc-loop.git
$Project = "C:\path\to\your-project"
New-Item -ItemType Directory -Force "$Project\.claude\skills" | Out-Null
Copy-Item -Recurse .\cc-loop\.claude\skills\cc-loop "$Project\.claude\skills\cc-loop"
```

### Option B — install for all projects (personal)

```bash
mkdir -p ~/.claude/skills
cp -R cc-loop/.claude/skills/cc-loop ~/.claude/skills/cc-loop
```

### Option C — keep it as a submodule or sibling

```bash
git submodule add https://github.com/afirez/cc-loop.git cc-loop
claude --add-dir cc-loop        # or run /add-dir cc-loop inside a session
```

A submodule at `cc-loop/` does **not** put the skill into the parent project's `.claude/skills/`. Use `--add-dir` / `/add-dir`, or copy the skill directory as in Option A. Starting Claude Code inside the `cc-loop` directory also works, because the skill lives at that repo root.

### Verify

```bash
claude plugin validate .claude/skills   # run from the project or repo root, v2.1.233+
```

In a Claude Code session, run `/skills` or ask "What skills are available?" and look for `cc-loop`.

## Use

1. Start Claude Code in the target project.
2. Invoke `/cc-loop`, or ask: **"Use cc-loop to initialize this project in Magpie mode."**
3. The skill creates:
   - `CLAUDE.md` with `@AGENTS.md` + `@LESSONS.md`
   - `AGENTS.md` with the task routing table
   - `LESSONS.md`
   - `docs/code-standards.md` with hard rules, Acceptance criteria, and the product-decision rule
   - `docs/contributors.md` from `contributors-template.md`
   - `docs/subsystems/README.md` plus the first subsystem page from `subsystems-template.md`
4. Configure the three Loops. Load only the file you need:
   - `.claude/skills/cc-loop/references/loop-github.md`
   - `.claude/skills/cc-loop/references/loop-social.md`
   - `.claude/skills/cc-loop/references/loop-night-audit.md`
   - `.claude/skills/cc-loop/references/loop-runtime.md` (scheduling and tool contract)
5. Schedule a loop with Claude Code `/loop`, cron, or CI. Example shape:

   ```text
   /loop <paste the prompt from references/loop-github.md, translated if you prefer>
   ```

   The source prompts have no time interval; `/loop` lets the model choose one. The skill does not install a scheduler.
6. Scan promotion candidates at any time:

   ```bash
   sh .claude/skills/cc-loop/scripts/check-lessons-promotion.sh LESSONS.md
   ```

   The scan is read-only. It prints entries with `Seen >= 3` and at least 3 distinct dates; a missing file exits with code 2.

7. Run the executable gate and the review helpers:

   ```bash
   sh .claude/skills/cc-loop/scripts/verify.sh
   sh .claude/skills/cc-loop/scripts/collect-day.sh "24 hours ago"
   sh .claude/skills/cc-loop/scripts/merge-reviewed.sh <pr> <reviewed-sha>
   ```

   `verify.sh` runs the package checks; `.github/workflows/verify.yml` runs it on push/PR. `collect-day.sh` gathers night-audit input and marks PRs `Not run` without `gh`. `merge-reviewed.sh` refuses if the PR head moved.

## The three Loops

| Loop | What it does | Prompt |
|---|---|---|
| 1 — GitHub + Discord | Judges issues/PRs, pulls PRs locally and runs them, requires the red check, replies to reporters, rejects relay-service ads, watches every Discord channel with real @ mentions | `.claude/skills/cc-loop/references/loop-github.md` |
| 2 — X/Twitter | Collects feedback, filters with a cheap classifier first, fixes reproducible bugs, replies after shipping | `.claude/skills/cc-loop/references/loop-social.md` |
| 3 — Night audit | Cleans low-quality/malicious code, reviews the day's merges, writes `LESSONS.md`, records repeat low-quality contributors, promotes rules after 3 distinct days | `.claude/skills/cc-loop/references/loop-night-audit.md` |

`Jev` in Loop 2 is only the example in the source prompt. `references/loop-social.md` documents keyword, small-local-model, cheapest-hosted-model, embedding, two-stage, and batch-review fallbacks.

## What counts as a real run

The method's gate is in `docs/code-standards.md`:

- put the old code back and run the new test; it must actually fail;
- merge the reviewed head onto current `main` locally and run the checks on the merged result;
- run the change locally in a real environment before merging;
- mark every check that was not run as `Not run`;
- record what was run, at which head, and what was not run.

The skill **instructs** this, and the skill package's own gate is executable:

- `sh .claude/skills/cc-loop/scripts/verify.sh` (also run by `.github/workflows/verify.yml`)
- `scripts/merge-reviewed.sh` or `--match-head-commit` for the merge.

Target-project CI and hooks remain yours to wire. The skill does not enforce another project's verification.

## Requirements

- Claude Code with Agent Skills support; `claude plugin validate` needs v2.1.233+.
- `sh` + POSIX `awk` for the scanner (Git Bash on Windows).
- Optional, for actual loop execution: `gh` or an MCP GitHub server, a Discord bot, an X API/collector, and a cheap classifier (or a keyword/embedding fallback). `collect-day.sh` and `merge-reviewed.sh` use `gh` when available and mark `Not run` otherwise.

No Node or Python runtime is required by the skill itself.

## Provenance

- The three loop prompts were recovered **verbatim** from yetone's X screenshots reproduced by AI智见录 (2026-11-12). The original X post is now protected.
- The repo rules (routing, `LESSONS.md`, `Seen N×`, 3-day promotion, red check, `Not run`, `docs/contributors.md`, `Don't reverse deliberate decisions`) come from `yetone/magpie` `main`; the full source matrix is in `Handoff.md` §6.5.
- The English sections are operational generalizations, not literal translations. The verbatim Chinese blocks are the source of truth.

## Status and limitations

- Skill validation passes; `verify.sh` and the CI workflow run the package gate; the promotion scanner has fixture tests and is read-only.
- **Not included:** a scheduler, GitHub/Discord/X connectors, target-project CI/hooks, and plugin/marketplace packaging.
- The Loops are executed by Claude Code when invoked; they are not a background service.

## License

MIT — see [LICENSE](LICENSE).

## Contributing

Read `docs/contributors.md` before reviewing a PR. Run the Acceptance criteria in `docs/code-standards.md` before opening one. Do not commit secrets or agent-runtime state (`.omc/`, `.memsearch/`, `.omb/`).
