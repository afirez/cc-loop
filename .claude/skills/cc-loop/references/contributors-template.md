# Community PRs: what is closed unreviewed, who is credited, and who is blocked

## Stop the review for possible harm

Any one of these stops the review until the maintainer has looked:

- Adds a secret, token, credential, or network exfiltration.
- Makes the project run destructive commands, bypass permission gates, or auto-approve tools.
- Removes or rewrites a verbatim source without a newer cited source.
- Adds a dependency or external service without a stated need and fallback.
- Changes the product decisions in `docs/code-standards.md` without evidence.

Say which line stopped it in the review. Do not run the PR's code on a machine with live credentials; use a sandbox HOME/container.

## Close without a full review

Close with a short reason, without running it, a PR that:

- Changes what the maintainer has ruled on (see "Don't reverse deliberate decisions" in code standards).
- Is a resubmission of a PR closed for its idea, with nothing new.
- Is one of several near-identical PRs opened seconds apart.

## Credit what a reporter gave

When a case, patch, or reproduction is used, credit the reporter or author in the commit or PR.

## Blocked

Record repeat low-quality submitters here with the evidence. A blocked author's new PRs are closed with a link to the entry.

- None yet.
