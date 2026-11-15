# Loop 3: Night audit and lesson promotion

> **Provenance**: The source prompt below was recovered verbatim from the screenshot "yetone 分享的第三条 loop 提示词" in the AI智见录 article 《比取代 CC Switch 更恐怖的，是 Magpie 这套全自动 AI 工作流》 (2026-11-12). The article reproduces yetone's X screenshots; the original X post `x.com/yetone/status/2109855710444237018` is now protected. The behavior is also documented in `LESSONS.md` and `docs/code-standards.md`; the English section is the operational version of the same loop.

## Source prompt (verbatim, Chinese, from yetone's X screenshot)

> /loop 现在 magpie 完全是自动化更改代码和合并社区里的 PR，你要定时清理一下屎山代码和恶意代码防止项目变得难以维护以至于变废，并总结出经验教训，比如哪些是不应该合并的哪些是验证不缜密的等等放到经验中防止以后的 agent 犯同样的错误，以及要把老是提低质量代码的人拉入黑名单

Source: screenshot "yetone 分享的第三条 loop 提示词" — `https://mmbiz.qpic.cn/sz_mmbiz_png/VIP3SyzHHZ9iafX7DPib42E1nxfVkSYXlPrR152ytkGD1v7A5GhribDh9HGvVUPWf98pI0nMayClvKORbichVQnF21OqvMGr4VticeTGhg6jB7Do/0?wx_fmt=png`; original X post: `https://x.com/yetone/status/2109855710444237018` (now protected).

## Collect

Gather the day's input with native commands (read-only):

```sh
git log --since="24 hours ago" --date=short --pretty=format:'- %h %ad %s'
git for-each-ref --sort=-creatordate --count=20 --format='- %(refname:short) %(creatordate:short)' refs/tags
gh pr list --state merged --limit 50 --json number,title,headRefOid,mergedAt
```

If `gh` is missing, PRs are `Not run`; do not invent them.

## Each round

Context: the project is fully automated in changing code and merging community PRs. This loop is the brake.

Review every commit and merged PR from the past 24 hours, focusing on three classes:

1. Work that was reverted or reopened after merging;
2. Work that, in hindsight, should not have been merged;
3. Work whose verification was clearly too thin.

For each problem:

- Write the lesson into `LESSONS.md` using the format in `lessons-format.md`: rule + why + related commit/PR number + `Seen N×` (with dates), so future agents do not repeat the same mistake.
- If the lesson already exists, append today's date and increment `Seen`; repeated occurrences on the same day do not increment it.
- If a lesson reaches `Seen 3` and comes from reviews on 3 different dates, move it into `docs/code-standards.md` and mark it as promoted in `LESSONS.md`.
- Clean up clearly low-quality or malicious code so the project does not become unmaintainable or rot.
- Record contributors who repeatedly submit low-quality PRs on the blocklist (`docs/contributors.md`).

## Scheduling

Choose `/loop`, cron, CI, or manual. Magpie's own trigger is not in its repository, so there is no upstream schedule to copy. Record which one you use; see `references/loop-runtime.md`. Do not claim a nightly audit ran without a record.

## Promotion judgment (hard)

- Base promotion on real reviews from different dates; never double-count to reach the threshold.
- A lesson without evidence (commit/PR/issue number) must not be promoted.
- The agent counts `Seen` and distinct dates by reading `LESSONS.md`; no script is used. The final decision still comes from the actual review record.
