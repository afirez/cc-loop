# Community PRs: what is closed unreviewed, who is credited, and who is blocked

## Stop the review for possible harm

Any one of these stops the review until the maintainer has looked:

- Adds a secret, token, credential, or network exfiltration.
- Makes the skill run destructive commands, bypass permission gates, or auto-approve tools.
- Removes or rewrites a verbatim source prompt without a newer cited source.
- Adds a dependency or external service without a stated need and fallback.
- Changes the product decisions in `docs/code-standards.md` without evidence.

## Close without a full review

- A resubmission of a PR closed for its idea, with nothing new.
- One of several near-identical PRs opened seconds apart.
- A change that only reformats or renames files without improving the skill.

## Maintainer PR flow (solo or team)

A single maintainer can use the same PR flow; there is no need for direct pushes.

1. Branch from current `main`.
2. Commit the change; run `sh tests/run.sh` and `sh .claude/skills/cc-loop/scripts/lint-package.sh`.
3. Open a PR.
4. Post the record from `.claude/skills/cc-loop/references/pr-review-record.md` as a PR comment: reviewed head, base, what was run, `Not run`.
5. Wait for the `test` workflow (Ubuntu, macOS, Windows).
6. Merge at the reviewed head: `gh pr merge --match-head-commit <reviewed sha>` or the GitHub API `sha` field.
7. Delete the branch.

The PR comment is the review record. `docs/reviews/` is legacy and must not receive new files.

## Credit

Credit the reporter or author in the commit or PR when their case, patch, or reproduction is used.

## Blocked

- None yet. Record repeat low-quality submitters here with the evidence.
