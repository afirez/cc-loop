# PR review record

Post this as a PR comment (or in the review) before merging. A merge with no record of what was run cannot be checked afterwards.

## Reviewed head

- Reviewed commit: `<sha>`
- Base: `<sha>` / `main`
- Merge: `scripts/merge-reviewed.sh <pr> <reviewed sha>` or `gh pr merge --match-head-commit <reviewed sha>`

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
