# AGENTS.md — task routing table

Before starting any work, read the documents that match the task type. The routing table only points the way; do not pile rules here.

| Task type | Required reading |
|---|---|
| Changing subsystem code | The matching design document under `docs/subsystems/` |
| Writing or reviewing code | `docs/code-standards.md` |
| Reviewing a community PR | `docs/contributors.md` |
| Deciding whether feedback is worth acting on / product boundary | The product-decision rule in `docs/code-standards.md` ("Don't reverse deliberate decisions") |
| Verifying a fix is complete | The Acceptance criteria in `docs/code-standards.md`, plus the verification commands in the matching `docs/subsystems/` page |
| After any rework or failure | `LESSONS.md` (lessons already learned) |

## Initialization instructions for the agent (do not write this section into AGENTS.md)

1. Write the title, introduction, and routing table above into `AGENTS.md` at the user's repository root.
2. Create `CLAUDE.md` at the repository root with only two references:

```markdown
@AGENTS.md
@LESSONS.md
```

3. Magpie has no separate product or verification documents; do not create them. Product decisions and acceptance criteria live in `docs/code-standards.md`.
4. If `docs/contributors.md` or `docs/subsystems/` is missing, confirm with the user before creating skeletons. Do not invent product decisions or verification procedures.
