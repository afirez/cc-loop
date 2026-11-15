# Loop 2: X/Twitter listening

> **Provenance**: The source prompt below was recovered verbatim from the screenshot "yetone 分享的第二条 loop 提示词" in the AI智见录 article 《比取代 CC Switch 更恐怖的，是 Magpie 这套全自动 AI 工作流》 (2026-11-12). The article reproduces yetone's X screenshots; the original X post `x.com/yetone/status/2109855710444237018` is now protected. The English section is the operational version of the same loop. Magpie's "Intent routing" is a separate product feature (routing user turns to a small model), not this loop.

## Source prompt (verbatim, Chinese, from yetone's X screenshot)

> /loop 盯一下推特上关于 magpie 的反馈，如果是有价值的反馈，或者是真实可复现的 bug，那么就去做实现或者修复。完毕后记得上线，上线后记得回复推特
>
> 你应该先用便宜的决策模型比如 jev 去判断推文是不是与 magpie 相关，是不是 magpie 的反馈，如果不是直接忽略不要把内容转发给你，不然太浪费 Token 了

Source: screenshot "yetone 分享的第二条 loop 提示词" — `https://mmbiz.qpic.cn/mmbiz_png/VIP3SyzHHZ9enicyXrWxGRpS2K06iaFIBfakuG5xsLoWdicwEMYmumiciaic18KswLGN7OryiaiaW6xIgj9UdlcC9uMlay9ATvuibzbNCxC5giaxhTSk8/0?wx_fmt=png`; original X post: `https://x.com/yetone/status/2109855710444237018` (now protected).

## Each round

1. Collect tweets related to this project.
2. **Filter with a cheap classifier first.** Use what you have: a low-cost decision model (the source prompt uses `jev` as an example), a small local LLM, a keyword/embedding rule, or a two-stage filter. The requirement is the filter, not a specific vendor.
   - Is the tweet about this project (not just a same-name mention)?
   - Is it feedback about this project that contains a valuable suggestion, a reproducible bug, or a concrete request?
   - If either answer is no, drop it; it never reaches the main model.
3. For content that passes the filter: valuable feedback, a reproducible bug, or a concrete suggestion → create a task and handle it; reply to the original tweet after shipping.
4. Pure emotional posts or posts with no substantive information: do not process and do not reply.

## If you don't have Jev

Jev is only the example in the source prompt. Any of these replaces it:

- **Keyword / regex filter**: require the product name plus context terms (agent names, error words, model names) and exclude same-name noise (for "magpie", exclude the bird). Free and fast; good enough for a first pass.
- **Small local LLM**: a tiny model via Ollama or similar, asked for a strict yes/no or JSON verdict. No per-call cost.
- **Cheapest hosted model**: the smallest model in your provider, with a strict JSON schema.
- **Embedding classifier**: embed a few positive and negative examples; keep tweets above a similarity threshold.
- **Two-stage**: keyword/embedding filter first, cheap LLM only for borderline tweets, main model only for survivors.
- **Batch review**: if you have no filter at all, collect the day's tweets into one compact list and review them once. Do not stream every tweet to the main model.

Minimal classifier prompt:

```text
You are a relevance filter. The project is <name>: <one-line description>.
Given one tweet, answer only JSON:
{"about_project": true|false, "actionable_feedback": true|false}
"actionable_feedback" means a reproducible bug, a concrete suggestion, or a concrete request.
```

## Runtime

If X access or a filter is unavailable, mark the round `Not run`; see `references/loop-runtime.md`. Never send the full stream to the main model as a fallback.

## Constraints

- This Skill does not bind to a specific classifier model. Implement the filter layer with the user's own toolchain, but **never skip filtering and hand everything to the main model**.
- No classifier available? Use a keyword/embedding filter or batch review; do not fall back to sending the full stream to the main model.
- Skipping the filter is a cost waste and a failure mode of this Loop.
- Reply only to tweets with substantive feedback; do not send indiscriminate marketing-style replies.
