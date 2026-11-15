# PR review record

Post this as a PR comment (or in the review) before merging. A merge with no record of what was run cannot be checked afterwards.

## Reviewed head

- Reviewed commit: `<sha>`
- Base: `<sha>` / `main`
- Merged onto current `main` locally and checked: yes/no — result:
- Merge: `gh pr view <pr> --json headRefOid`, then `gh pr merge <pr> --match-head-commit <reviewed sha>`

## Harm check

- Files touched:
- Network / file / credential access:
- Third-party code or binaries:
- Decision: no harm / stopped for maintainer

## What was run

- `<command>` — pass/fail
- Red check: with the old code back, `<test>` fails with `<failure>`.
- Break check: `<behavior>` broken by hand; `<test>` fails.
- Sandbox: temporary HOME, pinned caches, no live agent config.
- Full suite / build:
- Real use (account / config / vendor):
- `Not run`: `<check>` — `<reason>`

## Decision

- Merge / close / request changes.
- Open issues filed:
