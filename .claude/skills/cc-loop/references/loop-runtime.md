# Loop runtime: scheduling, tools, and failure behavior

The three loop files are prompts. This file describes how to run them and what to do when a tool is missing.

Magpie's own repository does **not** contain the scheduler, the night-audit trigger, the agent choice, or the tool connectors. The source analysis says so explicitly; the `LESSONS.md` update times are irregular and no workflow runs the audit. Do not pretend a loop ran when it did not.

## Native commands first

Use the agent's own tools before adding a wrapper:

- Night-audit input: `git log --since="24 hours ago" --date=short --pretty=format:'- %h %ad %s'`, `git for-each-ref ...`, `gh pr list --state merged --limit 50 ...`.
- Reviewed-head merge: `gh pr view <pr> --json headRefOid`, then `gh pr merge <pr> --match-head-commit <sha>`.
- Package lint: `scripts/lint-package.sh` — a package check, not the target project's test suite.

The skill ships no `collect-day` or `merge-reviewed` wrappers; those jobs are one native command each.

## Scheduling

| Option | How | Notes |
|---|---|---|
| Claude Code `/loop` | `/loop <prompt>`; no interval lets the model choose (Codex default ~1h in one test) | Best for an interactive workstation |
| cron / Task Scheduler | e.g. `0 * * * *` | Needs a headless agent entrypoint |
| CI scheduled workflow | `on: schedule: cron` | Clean environment; scope credentials carefully |
| Manual | Run the prompt at the start/end of a session | Always valid |

Night audit: choose one of the options above and record which one you use. A nightly audit is not a fact unless the record exists.

## Tool contract per loop

| Loop | Needs | If missing |
|---|---|---|
| 1 GitHub + Discord | `git`, GitHub access (`gh`/MCP), Discord access, a local run environment | Mark the missing surface `Not run`; do not merge a PR you could not run |
| 2 X/Twitter | X search/collection, a cheap filter (Jev or a fallback), a way to reply | Mark `Not run`; do not send unfiltered traffic to the main model |
| 3 Night audit | Git history, PR/issue access, `LESSONS.md` write access, the promotion scanner | Mark `Not run`; do not invent lessons or `Seen` counts |

## Least privilege

- Use a token/bot with the minimum scopes; never commit tokens.
- Run unreviewed PR code in a sandbox HOME/container, not on a machine with live credentials.
- Keep `Not run` explicit in the review record.

## Human gates

- Product decisions: `docs/code-standards.md` ("Don't reverse deliberate decisions").
- Security/harm: `docs/contributors.md`.
- Physical environment: real machines/accounts; the human sets them up.
- UI/UX taste: human-owned; the agent proposes, the human decides.

## Release gate

- Tag/release only after the verification run at the tagged commit is green; a run cancelled by the next push is not a pass.
- Record what was run at the tagged head; do not move an older release to Latest.
- If the project has no release process, state that; do not invent one.
