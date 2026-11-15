# HANDOFF.md — cc-loop Skill 开发交接

## 0. 项目目标

构建一个 Claude Code Skill，名为 **`cc-loop`**，让用户可以在任意项目中复现 yetone 维护 Magpie 的“路由表 + 错题本 + 三 Loop”负反馈闭环。Skill 的核心哲学是 **progressive disclosure**：`SKILL.md` 只做路由，完整内容拆到 `references/` 下按需加载，避免把 SKILL.md 本身变成“超级 Prompt”。

**当前进度**：已落地 `.claude/skills/cc-loop/`（`SKILL.md`、6 个 `references/` 文件、`check-lessons-promotion.sh`）。frontmatter 校验、脚本 fixture 测试、Claude Code 实际发现信号均通过（2026-11-13）。来源已在 §6 考证；`docs/product.md` / `docs/verification.md` 两个自创路径已移除，功能合并回 `docs/code-standards.md`。Skill 包内文档与脚本使用英文；本交接稿保留中文作为设计记录，§3 的草稿为中文，实际落地以英文为准。

**命名约定**：Skill 名为 `cc-loop`，目录必须为 `.claude/skills/cc-loop/`，`SKILL.md` frontmatter 中的 `name` 必须与目录名完全一致（小写字母/数字/连字符）。所有文档中提及本 Skill 时统一使用 `cc-loop`，不要再出现 `magpie-harness`。

---

## 1. 已确认的核心设计（不可偏离）

### 1.1 路由表：CLAUDE.md → AGENTS.md + LESSONS.md

Magpie 的 `CLAUDE.md` 极简，只有两个引用：`AGENTS.md` 和 `LESSONS.md`。`AGENTS.md` 的主体是任务类型到文档路径的映射（实际文件还含项目自身的运维说明，不是纯路由表）。

**在 `cc-loop` 中**，不是在用户项目里直接复现 Magpie 的文件名，而是在 `SKILL.md` 中写入路由逻辑，让 Agent **初始化用户项目时生成**对应的 `CLAUDE.md` / `AGENTS.md` / `LESSONS.md` 骨架。路由表模板见 §3.2。

### 1.2 错题本：LESSONS.md + “事不过三”升格

每条教训格式：**规则 + 原因 + 证据（commit/issue 号）+ `Seen N×`（附带日期）**。

升格机制：同一条教训在 **3 个不同日子**的复盘中出现（`Seen 3×`，日期不同），移入 `docs/code-standards.md`，从经验性提醒升级为每个 PR 审查都必须逐条对照的硬规则。同一天重复出现不计入。

### 1.3 三 Loop

| Loop | 核心动作 | 关键约束 |
|---|---|---|
| **Loop 1：GitHub + Discord** | 判断 issue/PR 是否值得处理；PR **拉取到本地逐行审查并实际运行**后才合并；Discord 所有频道不遗漏，回复必须真 @ 到人；不值得做的也要回复说明原因 | 无法证明已实际测试的 PR 不得合并 |
| **Loop 2：X/推特** | 先用**廉价分类模型**过滤相关性，只把真正讨论本项目且含可操作反馈的内容交给主模型 | 不过滤直接丢给贵模型是成本浪费 |
| **Loop 3：夜审** | 扫描当日 commit/PR，聚焦“修完又返工”“压根不该合”“验证太糙”三类；写入 LESSONS.md 并计数；清理劣质代码；记录恶意贡献者 | 升格判断必须基于**不同日期**的真实复盘 |

**来源注记**：Loop 3 与 Loop 1 的核心动作有 Magpie 一手依据；Loop 2 的“廉价分类模型”与 Loop 1 的 Discord 细节属于设计增强，见 §6.4。

### 1.4 必须写进 Skill 的硬约束

- **物理证伪**：PR 审查时，把旧代码放回去运行新测试，测试必须**真挂**；未执行的检查标记为 `Not run`。
- **验证环境先于 Agent**：没有写进 `docs/code-standards.md` 的 Acceptance criteria（定义“什么算真实运行”），不要让 Loop 1 开始合并 PR。
- **人的边界**：产品方向、UI/UX 审美、真实执行环境的物理准备由人负责；Agent 在边界内执行和进化规则。

---

## 2. Skill 目录结构（待创建）

```text
.claude/skills/cc-loop/
├── SKILL.md                        # 路由 + 核心原则，< 5K tokens
├── references/
│   ├── agents-template.md          # AGENTS.md 路由表模板
│   ├── code-standards-template.md  # 初始硬规则模板（只放 1–2 条不可妥协的）
│   ├── lessons-format.md           # LESSONS.md 条目格式 + 升格规则
│   ├── loop-github.md              # Loop 1 完整 Prompt
│   ├── loop-social.md              # Loop 2 完整 Prompt（含廉价过滤层）
│   └── loop-night-audit.md         # Loop 3 完整 Prompt（夜审 + 升格）
└── scripts/
    └── check-lessons-promotion.sh  # 可选：扫描 Seen ≥ 3 的条目
```

**frontmatter 规范**（Claude Code 官方文档 + Agent Skills 规范，2026-11-13 核对）：

- `name`：Claude Code 侧**可选**，默认取目录名，且允许与目录名不一致（只限定禁止字符）。Agent Skills 规范侧（claude.ai 上传 / Skills API / `package_skill.py`）**必填**：1–64 字符，仅 `a-z`、`0-9`、`-`，不得以 `-` 开头或结尾，不得有连续 `--`，且必须与父目录名一致。本 Skill 显式写 `name: cc-loop` 并与目录名一致，同时满足两套规则。
- `description`：Claude Code 侧推荐；`description` + `when_to_use` 在技能列表中合计截断于 **1,536 字符**。Agent Skills 规范侧**必填** 1–1,024 字符。交接稿原写的 1,024 是规范侧限制，不是 Claude Code 的 listing 上限；本 Skill 的约 324 字符同时满足两侧。
- 只使用 `name` 和 `description` 即可；`context: fork`、`disable-model-invocation` 等字段按需添加。当前 Skill 是编排型，**不要**设置 fork；`disable-model-invocation` 保持默认 `false`（允许自动触发）。

---

## 3. 文件草稿

### 3.1 SKILL.md（可直接作为起点）

````markdown
---
name: cc-loop
description: 用 Magpie 的负反馈闭环让 Claude Code 持续维护项目。当用户要求“用 Magpie 模式维护项目”“建立路由表/错题本/Loop 工作流”“让 AI 自主审查 PR 并沉淀教训”时使用。触发词：cc-loop、Magpie、harness、错题本、夜审、路由表、AI 自主维护。
---

# cc-loop

用“路由表 + 错题本 + 三 Loop”的外部约束系统，让 AI 在明确边界内持续维护项目。

## 核心原则

- **路由，不堆规则**：Agent 干活前只读当前任务需要的文档。
- **物理证伪**：PR 审查必须把旧代码放回去运行新测试，测试必须真挂；未执行的检查标记为 `Not run`。
- **教训在事故中生长**：同一条教训在 3 个不同日子的复盘中出现，才升格为硬规则。
- **廉价过滤挡在前面**：监听类任务先用分类模型过滤，再交给主模型。

## 工作流

1. 读 `references/agents-template.md`，在用户仓库根目录建立 `CLAUDE.md` 和 `AGENTS.md`。
2. 读 `references/lessons-format.md`，建立 `LESSONS.md` 骨架。
3. 按需加载 `references/loop-github.md`、`loop-social.md`、`loop-night-audit.md`，配置三个 Loop。
4. 从 `references/code-standards-template.md` 建立初始硬规则（只放 1–2 条不可妥协的），并写清 Acceptance criteria（什么算真实运行）与产品决定规则。
5. 运行 `scripts/check-lessons-promotion.sh`（可选）辅助判断哪些教训达到升格条件。
6. Magpie 没有 `docs/product.md` / `docs/verification.md`；不要另建这两个文件，产品决定与验收标准都放在 `docs/code-standards.md`。

## 验证环境（必须先于 Agent 工作搭建）

在 `docs/code-standards.md` 的 Acceptance criteria 中写死“什么算真实运行”。没有验收标准，不要让 Loop 1 开始合并 PR。

## 人的边界

产品方向、UI/UX 审美、验证环境的物理准备，由人负责。Agent 在边界内执行和进化规则。
````

### 3.2 `references/agents-template.md` 草稿

````markdown
# AGENTS.md — 任务路由表

在开始任何工作前，先根据任务类型读取对应文档：

| 任务类型 | 必读文档 |
|---|---|
| 修改子系统代码 | `docs/subsystems/` 下对应的设计文档 |
| 编写或审查代码 | `docs/code-standards.md` |
| 审查社区 PR | `docs/contributors.md` |
| 判断反馈是否值得处理 / 产品边界 | `docs/code-standards.md` 的产品决定规则（“Don't reverse deliberate decisions”） |
| 验证修复是否完成 | `docs/code-standards.md` 的 Acceptance criteria，以及 `docs/subsystems/` 对应页面的验证命令 |
| 任何返工或失败发生后 | `LESSONS.md`（已发生过的教训） |
````

**给 Agent 的初始化指令**：在用户仓库根目录创建 `CLAUDE.md`，内容为：

```markdown
@AGENTS.md
@LESSONS.md
```

### 3.3 `references/lessons-format.md` 草稿

```markdown
# LESSONS.md 条目格式

## 规则：<一句可执行的规则>

**原因**：<为什么会出现这条教训，1–2 句>

**证据**：<关联的 commit/issue/PR 号，可多个>

**Seen N×**（<日期1>, <日期2>, ...）

**适用范围**：<这条规则在什么场景下适用>

## 升格规则

同一规则在 **3 个不同日期**的复盘中被观察到（`Seen 3×` 且日期互不相同），
将该条目移入 `docs/code-standards.md`，并在 LESSONS.md 中标记为“已升格”。

同一天重复出现不计入 Seen。
```

### 3.4 三个 Loop 的 Prompt 骨架（放入对应 references 文件）

**注**：以下三个 Prompt 是根据 Magpie 文档中的行为规则重构的，不是 Magpie 仓库原文；夜审的 prompt、触发方式、agent 配置都不在仓库里（文章已说明）。

**Loop 1（`loop-github.md`）**：

```text
你是项目的 GitHub 与 Discord 维护 Agent。每轮执行：
1. 扫描 GitHub 新增/更新的 issue 和 PR。判断标准：是否与项目目标直接相关、是否可复现或可验证。
2. 对每个 PR：逐行读代码和逻辑，然后将分支拉取到本地，在真实运行环境中执行。运行不通过或无法证明已实际测试的 PR，不得合并；回复说明原因后关闭。
3. 合并通过的 PR，触发发布流水线。
4. 对所有来自用户的 issue/PR，无论是否处理，都必须回复。不值得做的也要说明原因。
5. 扫描 Discord 所有频道，有价值的反馈转为任务，值得讨论的继续讨论。在 Discord 中回复时必须真正 @ 到人。
6. 遇到“中转站”类广告推销，统一回复预设话术，不得将第三方中转站加入产品。
```

**Loop 2（`loop-social.md`）**：

```text
你是项目的社交媒体反馈处理 Agent。
1. 抓取与本项目相关的推文。
2. 先用廉价分类模型判断：是否在讨论本项目？是否包含可操作的反馈（bug 或建议）？两项任一为否，直接丢弃，不进入主模型。
3. 对通过过滤的内容：可复现的 bug 或具体建议 → 创建任务并处理；上线后回复原推文。
4. 纯情绪表达或无实质信息的推文，不处理，不回复。
```

**Loop 3（`loop-night-audit.md`）**：

```text
你是项目的夜审 Agent。扫描过去 24 小时的所有 commit 和已合并 PR，聚焦三类问题：
1. 合并后又被 revert 或重新打开的；
2. 事后看根本不该合并的；
3. 验证流程存在明显漏洞的。

每条教训写入 LESSONS.md，格式：规则 + 原因 + 关联 commit/PR 号 + Seen N×。
如果某条教训的 Seen 计数达到 3（且来自 3 个不同日子的复盘），将其移入 docs/code-standards.md，并从 LESSONS.md 标记为已升格。
同时清理明显的劣质代码和恶意代码，将反复提交低质量 PR 的贡献者记录到黑名单。
```

### 3.5 `references/code-standards-template.md` 草稿

只放最基础、不可妥协的 1–2 条，其余留给夜审生长：

```markdown
# 代码硬规则与验收标准

## 代码硬规则

以下规则来自反复出现的教训升格，每个 PR 审查必须逐条对照。

1. **未实际运行验证的 PR 不得合并。** 审查者必须将分支拉取到本地运行；无法证明已测试的 PR 视同未验证。
2. **未执行的检查必须标记为 `Not run`。** 不得用“看起来没问题”替代实际验证。

## 验收标准（什么算真实运行）

合并或发版前必须逐条证明；没跑的要写 `Not run`，不能省略。

1. **回退测试**：把旧代码放回去，新写的测试必须真挂，且指出是哪个行为错了；编译不过或被跳过的测试不算。
2. **真实运行**：改到厂商/运行时接入时，用真账号、真配置、真接口返回验证；没实测过的功能不许在上面继续开发，也不许对用户说能用。
3. **完整套件与构建**：跑完整测试和构建，不只跑改动相关的包；跨平台项目要覆盖目标平台。
4. **结果记录**：PR/commit 写明运行了什么、在哪个 head 上运行、哪些没跑。

## 产品决定（由人负责）

- **不得反向修改维护者已拍板的产品决定。** 交互、视觉、默认值等由人决定；PR 只能提出建议，不能直接改。
```

---

## 4. 实施步骤（下一步按顺序执行）

1. **创建目录**：在项目根目录创建 `.claude/skills/cc-loop/` 及子目录 `references/`、`scripts/`。
2. **写入 SKILL.md**：使用 §3.1 的草稿，然后人工检查 frontmatter 的 `name` 是否为 `cc-loop`，且与目录名完全一致。
3. **写入 references/**：按 §3.2–§3.5 创建六个文件。
4. **（可选）写入 `scripts/check-lessons-promotion.sh`**：一个简单的 shell 脚本，扫描 `LESSONS.md` 中 `Seen 3×` 且日期数 ≥ 3 的条目并列出，辅助人工/Agent 判断升格。
5. **在 Claude Code 中测试发现信号**：输入“用 cc-loop 初始化这个项目”或“用 Magpie 模式维护这个项目”，确认 Skill 被正确触发，且 Agent 按 `SKILL.md` 的路由读取对应 `references/` 文件，而不是一次性加载所有内容。
6. **做一次干运行**：在一个测试仓库中走完“建立路由表 → 跑一次 Loop 1 审查 → 手动触发一次夜审 → 观察一条教训写入 LESSONS.md”的最小闭环。

---

## 5. 已知待决问题（留给下一个会话）

- **Skill 的 `disable-model-invocation`**：是否需要设为 `true` 强制用户显式调用？当前设计倾向 `false`（允许自动触发），但如果用户项目较多，自动触发可能产生噪音。建议在测试后根据实际体验决定。
- **`scripts/check-lessons-promotion.sh` 的语言**：shell 还是 Python？取决于目标用户环境。建议先写一个**只读、只打印候选条目**的最小 shell 版本，避免引入额外依赖。
- **Loop 2 的“廉价分类模型”在 Skill 中如何表达**：Skill 本身不能直接调用外部模型。建议在 `loop-social.md` 中写成**指令性约束**（“在进入主模型前，先用一个低成本分类步骤过滤”），把具体实现留给用户按自己的工具链决定，而不是在 Skill 中硬编码某个模型。
- **Skill 名称的触发词覆盖**：`cc-loop` 本身语义偏抽象，建议在 `description` 中同时保留“Magpie 模式”“错题本”“夜审”等具象触发词，避免用户想用时却想不起 `cc-loop` 这个名字。

---

## 6. 关键来源（2026-11-13 已考证）

### 6.1 一手来源：yetone/magpie（main 分支）

- 仓库：https://github.com/yetone/magpie
- `CLAUDE.md`：只有两行 `@AGENTS.md` / `@LESSONS.md`。
- `AGENTS.md`：任务路由（subsystems / code-standards / contributors / LESSONS），另含项目自身的运维说明（内置订阅迁移），**并非纯路由表**。
- `LESSONS.md`：
  - 首句 “magpie's code is written, reviewed, merged and released by agents.”
  - 夜审三类问题：“what had to be fixed again, what shouldn't have merged and what was verified too thinly.”
  - 教训格式：规则 + 原因/证据 + `Seen N× (YYYY-MM-DD, ...)`；同一教训在 3 个不同日子出现，移入 `docs/code-standards.md`。
  - 首个版本 commit `303819c5`（2026-10-06 03:10 +0800），同时引入 `AGENTS.md`、`CLAUDE.md`、`docs/code-standards.md`。
- `docs/code-standards.md`：
  - “A fix comes with a test that fails without it. The reviewer puts the old code back and runs the test, and the test must fail.”（物理证伪）
  - “A check that wasn't run is listed as not run, never left out.”（`Not run`）
  - 六条验收标准；“A PR is merged only after a maintainer has pulled it, merged it onto current main and run the checks above on the result.”（本地拉取并实际运行）
  - 合并命令带 `gh pr merge --match-head-commit <reviewed sha>`。
- `docs/contributors.md`：社区 PR 的危害拦截、直接关闭规则、惯犯黑名单。
- `docs/subsystems/README.md`：子系统设计、语义变更说明与评审规则。
- 社区来源：PR #889（Junjie Zhou，子系统文档与语义变更审查）、PR #1339 的 Red check / Break check / Not run 记录。

### 6.2 二手来源：解析文章

- 《yetone 的魔法：magpie 是怎么让 AI 自己维护项目的》
  https://www.jxxy.net/ai/articles/magpie-ai-self-maintain/
- 原作者 @WquGuru，原文 X 链接：https://x.com/wquguru/status/2109650264601117141
- 考证结果：文章的核心机制描述与一手文件一致；数字是 2026-10-11 前后的快照，可与 commit `7c632ad0` 精确对齐（LESSONS.md 479 行、6 条验收标准、4 个 workflow 均无定时夜审）。文章说的“8 条升格”在该快照中对应 8 条实际规则（另有 4 条 Done right / 漏项记录不算规则）。文章称 AGENTS.md“只做路由”是简化说法：当时它已包含内置订阅迁移说明。文章也明确承认：夜审的触发方式、提示词、使用的 agent 与并行配置都不在仓库里。

- 《比取代 CC Switch 更恐怖的，是 Magpie 这套全自动 AI 工作流：挂 3 个循环半夜还在自动修 Bug 发版！》（AI智见录，微信公众号，2026-11-12；Sogou 微信搜索缓存可读）
  - 明确描述三个 `/loop`：第一条盯 GitHub + Discord，第二条巡逻 X 反馈，第三条夜审。
  - 包含这些要求：“先调便宜的决策模型判断推文跟 Magpie 有没有关系，无关的内容直接过滤”“中转站广告礼貌回绝”“逐行审代码、拉到本地跑通验证才能合”“Discord 所有频道 + 回复时真实 @ 到人”“打 tag 前 CI 必须跑完且全绿（被下一次 push 取消的不算）”“同一条教训在 3 个不同日子出现才升格”“没跑的检查项写 Not run”“配齐 macOS + Windows/Linux VM 三端真机”。
  - 文章称工作流原文来自 yetone 的 X 帖：https://x.com/yetone/status/2109855710444237018（账号现已 protected，fxtwitter 返回 `PRIVATE_TWEET`）；软件设计思路：https://x.com/yetone/status/2110089344187056263（同样 protected）。
  - LINUX DO 转帖：https://linux.do/t/topic/3025235（直接访问被网络拦截；Bing RSS 摘要可见两条原文链接）。
  - 性质：文章正文是转述；但正文配图包含 yetone 的三张 prompt 截图，逐字原文已提取到三个 loop 文件。
  - 截图现状（2026-11-14）：**三条 `/loop` 的逐字 prompt 均已取得**。来源：AI智见录文章正文中的三张截图，alt 分别为“yetone 分享的第一/二/三条 loop 提示词”；Loop 1 另有 cnblogs 文章第 7 张图镜像。微信原文通过 Playwright + Sogou 跳转页成功加载，图片 URL 已记录在三个 loop 文件。原 X 帖仍 protected，但文章截图提供了逐字内容。

### 6.3 官方 Claude Code Skill 规范

- https://code.claude.com/docs/en/skills.md（等价：https://docs.claude.com/en/docs/claude-code/skills.md）
- https://agentskills.io/specification（Agent Skills 开放规范）
- 项目级路径：`.claude/skills/<skill-name>/SKILL.md`；嵌套目录的技能在 Claude 处理该目录文件时加载，或用 `/add-dir`。
- `name`：Claude Code 侧可选（默认目录名，允许不一致）；Agent Skills 规范侧必填、1–64 字符、仅 `a-z0-9-`、不得首尾连字符或连续 `--`、必须与父目录同名。本 Skill 同时满足。
- `description`：Claude Code 侧 `description` + `when_to_use` 在 listing 中合计截断于 1,536 字符；Agent Skills 规范侧必填 1–1,024 字符。本 Skill 约 324 字符，两侧都满足。
- `disable-model-invocation` 默认 `false`；`context: fork` 为可选字段。当前 Skill 两者都不设置，符合设计。
- Progressive disclosure：官方建议 metadata 约 100 tokens、SKILL.md 正文 < 5,000 tokens 且 < 500 行、references 只深一层。本 Skill 的 SKILL.md 为 46 行 / 约 2.6 KB，符合。
- 官方校验：`claude plugin validate .claude/skills`（v2.1.233+），本 Skill 已通过（2026-11-13）。`/skills`、`/reload-skills`、`/skill-doctor` 可查看加载状态与上下文开销。

### 6.4 设计增强与修正记录

- **三条 Loop 的逐字 prompt 均已取得**：来自 AI智见录文章正文的三张截图（2026-11-12），Loop 1 另有 cnblogs 第 7 张图镜像；原文已写入三个 `loop-*.md` 的 Source prompt 区块。英文段落是同一套指令的操作版翻译。原 X 帖仍 protected，但文章截图提供了逐字内容。使用前仍建议按项目实际调整，不要照搬 Magpie 的专有名词（Magpie / Discord Server 等）。
- ~~`docs/verification.md` 前置门~~：**已移除**。Magpie 没有该文件；验证规则在 `docs/code-standards.md` 的 Acceptance criteria 里。Skill 现在直接路由到 code-standards。
- ~~`docs/product.md`~~：**已移除**。Magpie 的产品决定规则是 `docs/code-standards.md` 里的 “Don't reverse deliberate decisions”；Skill 现在把产品规则写进 code-standards。
- Loop 2 的“廉价分类模型”：逐字 prompt 已取得（`loop-social.md` 的 Source prompt 区块），原文写的是“先用便宜的决策模型比如 jev 去判断推文是不是与 magpie 相关……不然太浪费 Token 了”。Magpie 的 “Intent routing” 是产品功能，不是这条维护 Loop。
- Loop 1 的“Discord 所有频道不遗漏”“回复必须真 @ 到人”“中转站预设话术”：已由第一条 prompt 截图逐字证实；英文操作版保留了这些要求，并把 Magpie 专有名词泛化。
- 人的边界中“真实执行环境的物理准备”：dotey 公开推文与 AI智见录文章明确描述了 macOS + Windows/Linux VM 三端真机，以及 Claude Code 记忆/设计文档；属于二手实证，不是纯粹外推。
- 教训模板中的“适用范围”字段：保留为设计增强；Magpie 实际格式为规则 + 原因/证据 + Done right + `Seen N×`。

### 6.5 逐文档溯源矩阵（复核于 2026-11-14，magpie main `3f09b9ffc6b1`）

| Skill 文档 / 行为链路 | 事实来源 | 性质 |
|---|---|---|
| `SKILL.md` 路由、progressive disclosure | Claude Code 官方 skills 文档；Magpie `CLAUDE.md` / `AGENTS.md` | 规范 + 一手结构 |
| `references/agents-template.md` | Magpie `AGENTS.md` 路由；`docs/code-standards.md` 产品决定；`docs/contributors.md`；`docs/subsystems/README.md` | 一手 + 泛化 |
| `references/lessons-format.md` | `LESSONS.md` 开头：rule / why / evidence / `Seen N×`；3 个不同日子 → `docs/code-standards.md` | 一手；模板为规范化 |
| `references/code-standards-template.md` | `docs/code-standards.md`：Red check / `Not run` / Acceptance criteria / “Don't reverse deliberate decisions” | 一手子集 + 泛化 |
| `references/loop-github.md` | yetone X 截图第一条（逐字）；`docs/code-standards.md`（本地拉取运行、red check、`Not run`、merge reviewed head）；`docs/contributors.md` | 逐字 + 一手 |
| `references/loop-social.md` | yetone X 截图第二条（逐字）；dotey 公开推文、AI智见录文字交叉验证 | 逐字 + 二手交叉验证 |
| `references/loop-night-audit.md` | yetone X 截图第三条（逐字）；`LESSONS.md`（夜间三类、Seen、升格）；`docs/contributors.md`（黑名单） | 逐字 + 一手 |
| `scripts/check-lessons-promotion.sh` | 由 `LESSONS.md` 的升格规则推导 | 本项目实现 |
| 验证环境 / Acceptance criteria | `docs/code-standards.md`；`docs/verification.md` 不存在（已移除） | 一手 |
| 产品决定 / 人的边界 | `docs/code-standards.md` 的 “Don't reverse deliberate decisions”；dotey / AI智见录 的三端真机与记忆/设计文档描述 | 一手 + 二手 |
| 三个 Loop 的编号与命名 | 本项目对 yetone 三条 `/loop` 的映射 | 本项目命名 |

**复核方法**：2026-11-14 重新拉取 magpie `main`（`3f09b9ffc6b1`）的 `CLAUDE.md`、`AGENTS.md`、`LESSONS.md`、`docs/code-standards.md`、`docs/contributors.md` 与 `docs/` 目录；关键句仍成立。X 工作流以 AI智见录 2026-11-12 文章中的三张截图为准，并与 dotey 2026-10-13 公开推文、cnblogs 第 7 张图交叉核对。

**溯源限制**：yetone 原 X 帖已 protected（fxtwitter 返回 `PRIVATE_TWEET`）；三张截图是第三方文章的复现，无法与受保护原帖做独立逐字比对。如后续取得原帖，应以原帖复核。仓库规则会随 `main` 变化；本矩阵固定在上面的 SHA。

### 6.6 Magpie 行为链路内化的偏差项（2026-11-15）

| Magpie 行为 | cc-loop 原先 | 已内化 |
|---|---|---|
| CI 三端矩阵 / PR 校验 | 无 | `scripts/lint-package.sh` + `.github/workflows/lint-package.yml`（package lint，不是工程测试套件） |
| PR 审查记录（Red check / Break check / Not run） | 只有 prompt | `references/pr-review-record.md`；原生 `gh pr merge --match-head-commit` |
| 审阅“合到当前 main 后的结果” | 只有 prompt | `loop-github.md` 增加本地合入 main 后跑检查；`pr-review-record.md` 记录 base/merged result |
| 社区 PR 危害/关闭/黑名单模板 | 路由到 `docs/contributors.md`，但无模板 | `references/contributors-template.md` |
| 子系统 reference / 验证命令模板 | 路由到 `docs/subsystems/`，但无模板 | `references/subsystems-template.md` |
| 夜审数据收集 | 只有 prompt | 原生 `git log` / `git for-each-ref` / `gh pr list`（无 collector 脚本） |
| 调度与工具契约 | 只有 prompt | `references/loop-runtime.md` |
| 发布门禁（tag 前 CI 绿、记录 head、Latest） | 未写 | `code-standards-template.md` 的 Release gate |
| 人的安全/物理/UI 闸门 | 部分写在原则 | `code-standards-template.md` 的 Human gates + `contributors-template.md` |

**仍未内化（需要在目标项目或用户工具链里接）**：`/loop`/cron/CI 调度器、GitHub/Discord/X 连接器、目标项目的 CI/hook、plugin/marketplace 打包、真实三端真机。`cc-loop` 现在有**可执行的包级验收门禁**，但没有 Magpie 那样的完整运行基础设施。

**脚本性质（AI-native 收口）**：只保留一个包级 lint `scripts/lint-package.sh`；它不是 Magpie 的验证，Magpie 用 `test.yml` + `make test`/`make test-ui` + `build/race-shards.sh` + 真机。夜审收集和合并是原生 `git`/`gh` 命令（见 `loop-runtime.md`），不包装成脚本；`collect-day.sh` 和 `merge-reviewed.sh` 已删除。

---

这份 `HANDOFF.md` 已把 Skill 名统一为 **`cc-loop`**，目录、frontmatter `name`、触发词和测试指令全部对齐。下一个 Claude Code 会话可以直接从 **§4 实施步骤**开始，第一步就是创建 `.claude/skills/cc-loop/` 并写入 `SKILL.md`。
