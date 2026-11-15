# Loop 1: GitHub + Discord maintenance

> **Provenance**: The source prompt below was recovered verbatim from the screenshot "yetone 分享的第一条 loop 提示词" in the AI智见录 article 《比取代 CC Switch 更恐怖的，是 Magpie 这套全自动 AI 工作流》 (2026-11-12); the same prompt is mirrored in the cnblogs article "自己写代码、自己审 PR、自己发版" (image 7). The article reproduces yetone's X screenshots; the original X post `x.com/yetone/status/2109855710444237018` is now protected. The core merge rules are also documented in `docs/code-standards.md`, and the community-PR rules in `docs/contributors.md`; the English section is the operational version of the same loop.

## Source prompt (verbatim, Chinese, from yetone's X screenshot)

> /loop 盯一下 GitHub issues，仔细分析，看看哪些是值得修复和实现的，修复或者实现后记得发版和回复，如果不值得修复或者实现也要回复，如果是中转站的广告商，就统一回复：感谢关注，日后会出相关合作方案，敬请期待。而不能一股脑地把第三方中转站直接加到我们产品里面。也要盯一下GitHub的PR，然后你要认真的去review PR的每行代码、每个逻辑，你要把代码拉下来实际跑一下，验证一下是否没有bug。因为我怕有的人提的PR，是无脑用Coding Agent乱写的，自己都没测过。所以你要看一下他这个PR，是否有问题，确保一切都没有问题，且实际验证过之后也没有问题的话，你才能够去合并，否则你就去回复一下这个PR或者关掉 PR。另外还要监控一下 Magpie Discord Server 里用户的反馈，实时的加入讨论，如果有有价值的反馈和建议，就去做修复跟添加新的功能。如果值得进一步讨论，那就继续讨论。记得查看 Magpie Discord Server 里所有的channel，一个都不能漏掉！记得在 Discord 里要真实地 at 人，而不是只叫名字，不然对方收不到你的消息！

Source: screenshot "yetone 分享的第一条 loop 提示词" in the AI智见录 article; mirror: `https://img2024.cnblogs.com/blog/3550045/202610/3550045-20261013205010288-1766422712.png`; original X post: `https://x.com/yetone/status/2109855710444237018` (now protected).

## Preconditions (hard)

- `docs/code-standards.md` must exist, and its Acceptance criteria must define "what counts as a real run". Without acceptance criteria, this Loop must not start merging PRs.
- A PR whose tests were not actually run must not be merged; treat it as unverified, reply with the reason, and close it.
- Checks that were not run must be marked `Not run`; "looks fine" is not a substitute for actual verification.
- If GitHub, Discord, or the local run environment is unavailable, mark that surface `Not run`; do not merge a PR you could not run. See `references/loop-runtime.md`.

## Each round

1. Scan new and updated GitHub issues and PRs. Judge whether each is worth fixing or implementing: directly related to the project goal, and reproducible or verifiable.
2. For each PR:
   - Read the code and logic line by line, and check it against every rule in `docs/code-standards.md`.
   - The source prompt's concern: a PR may be written blindly by a coding agent and never tested by its author. Assume nothing; verify everything.
   - Pull the branch locally and run it in a real environment according to the Acceptance criteria in `docs/code-standards.md` (and the verification commands in the subsystem docs).
   - Merge the reviewed head onto current `main` locally and run the checks on the merged result, not only on the PR head. Record the base and the result.
   - Do the physical falsification: put the old code back and run the new test. The test must actually fail, proving that it covers the fix. If it does not fail, the verification is invalid and the PR must not be merged.
   - Do not merge a PR that fails, cannot be shown to have been tested, or fails the falsification check; reply with the reason and close it.
3. After fixing or implementing an issue, release and reply to the reporter. Merge passing PRs and trigger the release pipeline.
4. Reply to every issue/PR from users, whether or not it is acted on. If it is not worth doing, say why.
5. Scan every Discord channel; do not miss any. Join discussions in real time; for valuable feedback or suggestions, fix or add the requested feature, and continue worthwhile discussions. When replying on Discord, actually @ the person, not just write their name.
6. For "relay service" advertising, reply with the project's preset message (“感谢关注，日后会出相关合作方案，敬请期待” in the source prompt); never add a third-party relay to the product.

## Record

Before merging, write the review record from `references/pr-review-record.md`: reviewed head, harm check, what was run, Red check, Break check, and `Not run`. Merge at that head with `scripts/merge-reviewed.sh <pr> <sha>` (requires `gh`) or `gh pr merge --match-head-commit <sha>`.

At the end of each round, record what was handled and the evidence (links, run-output summary). If a lesson is involved, write it into `LESSONS.md` using the format in this Skill's `references/lessons-format.md`.
