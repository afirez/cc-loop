# Lessons from merged work

This is the Magpie-style method applied to `cc-loop` itself: each change is reviewed for what had to be fixed again, what should not have merged, and what was verified too thinly. Each lesson is a rule, then why, then the evidence. "Seen" counts the days a review found it. A lesson seen on 3 or more separate days moves into `docs/code-standards.md`.

## Rule: Do not add an upstream file path to a template unless the upstream repository actually has it.

**Why**: The handoff added `docs/product.md` and `docs/verification.md`; Magpie has neither, so the skill routed to files users would never create.

**Evidence**: Handoff §6.4; Magpie `docs/` listing on 2026-11-15, main `3f09b9ffc6b1`; the paths were removed from `SKILL.md`, `agents-template.md`, and `loop-github.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any skill or reference derived from an upstream project.

## Rule: Treat a third-party article as a lead, not a primary source; recover the verbatim source or mark the text as a reconstruction.

**Why**: The three loop prompts were first marked unsourced because the X account is protected. The AI智见录 article's text was a paraphrase, but its screenshots contained the verbatim prompts. The distinction matters: a paraphrase must not be presented as the original.

**Evidence**: Handoff §6.2/§6.4; the Source prompt blocks in `loop-github.md`, `loop-social.md`, `loop-night-audit.md`; dotey tweet `2110084393255514268`; cnblogs image 7.

**Seen 1×** (2026-11-15)

**Scope**: Provenance work for any imported prompt, prompt fragment, or workflow.

## Rule: Keep verbatim source blocks immutable; put operational generalizations in a separate section.

**Why**: Editing a quoted source silently turns it into a paraphrase. The English sections may evolve for other projects; the Chinese source blocks may only change when a newer upstream source is found.

**Evidence**: The `Source prompt (verbatim, Chinese)` sections and the English sections in the three `loop-*.md` files; Handoff §6.5.

**Seen 1×** (2026-11-15)

**Scope**: Any reference file that quotes an upstream prompt.

## Rule: Do not commit agent-runtime state; ignore it at the repository root.

**Why**: `.omc/` appeared inside `cc-loop/` during the session. Committing it would leak operational state and make the repo noisy.

**Evidence**: `.gitignore`; commit `9d3f45a` contains no `.omc/`; the pushed tree was verified.

**Seen 1×** (2026-11-15)

**Scope**: Every repository managed by an agent harness.

## Rule: When adding an existing repository as a submodule, absorb its git directory.

**Why**: `git submodule add` on an existing nested repository left a full `.git` directory. `git submodule absorbgitdirs` makes it a standard submodule and avoids nested-repository surprises.

**Evidence**: Parent commit `a060d35`; `git submodule absorbgitdirs cc-loop`; `cc-loop/.git` is now a `gitdir:` file.

**Seen 1×** (2026-11-15)

**Scope**: Parent repositories that add an existing checkout as a submodule.

## Rule: Re-run the acceptance checks after a language or format change; cached numbers go stale.

**Why**: Translating the skill changed the frontmatter description from 148 to 324 characters, while the review record and Handoff still said 148. The checks passed, but the recorded evidence no longer matched the tree.

**Evidence**: `SKILL.md` description; `docs/reviews/2026-11-15-loop1.md`; Handoff §6.3.

**Seen 1×** (2026-11-15)

**Scope**: Any change that can alter metadata, generated text, or measured values.

## Rule: A skill that routes to a document it does not template is incomplete.

**Why**: `SKILL.md` and `AGENTS.md` routed to `docs/contributors.md` and `docs/subsystems/`, but the skill package had no templates for either. A target project would be told to create files it had no model for.

**Evidence**: `.claude/skills/cc-loop/references/contributors-template.md` and `subsystems-template.md` added; `SKILL.md` initialization step updated.

**Seen 1×** (2026-11-15)

**Scope**: Any skill whose routing table points outside the skill package.

## Rule: A documented acceptance criterion without an executable check is not a gate.

**Why**: The first version of `docs/code-standards.md` listed checks in prose only. Nothing stopped a broken reference or a stale frontmatter from being pushed. Magpie's behavior chain has CI and merge gates; the skill had text.

**Evidence**: `.claude/skills/cc-loop/scripts/verify.sh`; `.github/workflows/verify.yml`; acceptance criteria 8–9; `docs/reviews/2026-11-15-loop1.md` second pass.

**Seen 1×** (2026-11-15)

**Scope**: Any method that claims a verification gate.

## Rule: A runtime contract is part of the method; prompts alone do not schedule or connect.

**Why**: The three loop prompts say what to do, but not how often, with which tools, or what happens when a tool is missing. Magpie's night-audit trigger and connectors are not in its repo; the skill must state that boundary.

**Evidence**: `.claude/skills/cc-loop/references/loop-runtime.md`; `loop-night-audit.md` scheduling section; `loop-github.md` preconditions.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that describes scheduled or externally connected work.

## Rule: A missing optional tool degrades to `Not run`, never to a silent pass.

**Why**: `verify.sh` may run without the Claude CLI; `collect-day.sh` and `merge-reviewed.sh` may run without `gh`. A silent pass would turn an unverified surface into a false green.

**Evidence**: `verify.sh` prints `NOT RUN claude plugin validate`; `collect-day.sh` prints `Not run: gh not found`; `merge-reviewed.sh` exits 2.

**Seen 1×** (2026-11-15)

**Scope**: Any check that depends on an optional external tool.

## Rule: Review the merged result, not only the PR head.

**Why**: Magpie's code standards merge the reviewed head onto current `main` and run the checks on the result. Running only the PR head can miss a conflict or a base change that breaks the merged tree. The first cc-loop loop file said "pull and run" without the local merge step.

**Evidence**: Magpie `docs/code-standards.md` ("A PR is merged only after a maintainer has pulled it, merged it onto current main and run the checks above on the result"); `loop-github.md` step 2 and `pr-review-record.md` updated during the alignment audit.

**Seen 1×** (2026-11-15)

**Scope**: Any PR review gate.
