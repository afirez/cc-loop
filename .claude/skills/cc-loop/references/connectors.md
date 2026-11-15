# Connectors and tool contract

Use native tools first. This file describes what each surface needs and how to mark missing tools. The skill ships no credentials and no wrappers.

## GitHub

- Access: `gh` or an MCP GitHub server.
- Loop 1: issues/PRs, review comments, merge at the reviewed head.
- Loop 3: merged PRs, issues, and the day's commits.
- Minimum: read issues/PRs; write comments; merge only when authorized.
- If unavailable: mark `Not run`; do not merge or invent PR data.

## Discord

- Access: a bot or an MCP Discord server.
- Loop 1: every channel, real @ mentions; read feedback and reply.
- Least privilege: read messages and send in allowed channels; no admin scope.
- If unavailable: `Not run`; do not claim channels were scanned.

## X/Twitter

- Access: an API client or a collector.
- Loop 2: collect, filter with a cheap model (Jev or a fallback), fix, reply after shipping.
- Never send the full stream to the main model.
- If unavailable: `Not run`.

## When credentials arrive

The contract is usable before any credential exists. When the human provides one:

1. Put it in the host's secret store or environment; never commit it.
2. Run a read-only smoke test first (`gh auth status`, a channel list, an account lookup).
3. Grant the minimum scope; do not add admin or write scopes before the loop needs them.
4. Record the first real run in `references/verification-matrix.md`; until then the surface is `Not run`.

## Credentials and permissions

- Use environment variables or a secret store; never commit tokens.
- Run unreviewed code in a sandbox with no live credentials.
- Record which surfaces ran; `Not run` for the rest.
