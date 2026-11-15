# LESSONS.md entry format

Every lesson must be actionable and traceable. Use one entry per `##` heading:

## Rule: <one actionable rule>

**Why**: <why this lesson exists, 1–2 sentences>

**Evidence**: <related commit/issue/PR numbers, one or more>

**Seen N×** (<date1>, <date2>, ...)

**Scope**: <where this rule applies>

## Promotion rule

When the same rule is observed in reviews on **3 different dates** (`Seen 3×` with distinct dates), move it into `docs/code-standards.md` and mark it as promoted in `LESSONS.md`.

- Repeated observations on the same day do not count toward `Seen`.
- Dates must be written as `YYYY-MM-DD` (the promotion script counts only this format; other formats are ignored).
- A lesson without evidence (commit/PR/issue number) must not be promoted.
- Promotion is done by the night audit (Loop 3); keep a marker on the original entry for traceability:

```markdown
> Promoted to `docs/code-standards.md` (<date>)
```

- Promotion is done by the night-audit agent: read `LESSONS.md`, count `Seen` and distinct dates, move the entry into `docs/code-standards.md`, and mark it promoted. No script is required.
