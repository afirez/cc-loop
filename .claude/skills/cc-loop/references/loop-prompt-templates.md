# Loop prompt templates

These are copy-paste templates for Claude Code `/loop`. They are derived from the English operational versions; they are **not** the verbatim upstream prompts. The verbatim Chinese sources are in `loop-github.md`, `loop-social.md`, and `loop-night-audit.md` and must not be edited.

Replace every `<...>` placeholder before starting. A human or an agent starts the loop; `/loop` repeats the prompt. If a placeholder cannot be filled, remove that surface or mark it `Not run`; never invent it.

## Loop 1 — GitHub + Discord

```text
/loop Act as the <project> maintainer for GitHub and Discord. Each round:
1. Scan new and updated issues and PRs; decide which are worth fixing or implementing.
2. For each PR: read the code and logic line by line; pull it locally; merge the reviewed head onto current main locally; run <test command> and the acceptance checks on the merged result; do the red check (old code back, the new test must fail). Do not merge if it fails, cannot be shown to have run, or the falsification fails.
3. After fixing or implementing an issue, release with <release command> and reply to the reporter.
4. Reply to every issue/PR; if it is not worth doing, say why.
5. Scan every channel in <Discord server>; reply with a real @; fix or add features for valuable feedback.
6. For relay-service ads, reply with <preset reply>; never add a third-party relay.

Record what was run, at which head, and what was not run. Mark a missing surface Not run.
```

## Loop 2 — X/Twitter

```text
/loop Watch X/Twitter for feedback about <project>. Each round:
1. Collect tweets about <project>.
2. Filter with <cheap filter> (or a keyword/embedding fallback) before the main model: is it about <project>? Does it contain a reproducible bug, a concrete suggestion, or a concrete request? If either answer is no, drop it.
3. For survivors: fix reproducible bugs or implement concrete suggestions; after shipping, reply to the original tweet.
4. Do not process or reply to pure emotional posts or posts with no substance.

Never send the full stream to the main model. Mark a missing surface Not run.
```

## Loop 3 — Night audit

```text
/loop Act as the <project> night auditor. Each round:
1. Collect the last 24 hours with native commands: git log, tags, and merged PRs (gh). Mark PRs Not run if gh is unavailable.
2. Review for three classes: work that was reverted or reopened, work that should not have merged, and verification that was too thin.
3. Write each lesson to LESSONS.md: rule, why, evidence, Seen N× with dates. Do not double-count the same day.
4. If a rule has Seen >= 3 on 3 distinct dates, move it to docs/code-standards.md and mark it promoted. Read the file and count; no script.
5. Clean low-quality or malicious code; record repeat low-quality contributors in docs/contributors.md.

Record what was run. Mark missing tools Not run.
```

## Placeholders

| Placeholder | Fill with |
|---|---|
| `<project>` | project name and one-line description |
| `<test command>` | the project's real test command |
| `<release command>` | the project's real release/tag command |
| `<Discord server>` | the Discord server name or ID |
| `<preset reply>` | the project's approved reply to relay-service ads |
| `<cheap filter>` | Jev, a small local model, a keyword rule, or an embedding filter |
