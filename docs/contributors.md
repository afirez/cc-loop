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

## Credit

Credit the reporter or author in the commit or PR when their case, patch, or reproduction is used.

## Blocked

- None yet. Record repeat low-quality submitters here with the evidence.
