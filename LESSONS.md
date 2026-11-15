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

**Evidence**: `.claude/skills/cc-loop/scripts/lint-package.sh`; `.github/workflows/lint-package.yml`; acceptance criteria 8–9; `docs/reviews/2026-11-15-loop1.md` second pass.

**Seen 1×** (2026-11-15)

**Scope**: Any method that claims a verification gate.

## Rule: A runtime contract is part of the method; prompts alone do not schedule or connect.

**Why**: The three loop prompts say what to do, but not how often, with which tools, or what happens when a tool is missing. Magpie's night-audit trigger and connectors are not in its repo; the skill must state that boundary.

**Evidence**: `.claude/skills/cc-loop/references/loop-runtime.md`; `loop-night-audit.md` scheduling section; `loop-github.md` preconditions.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that describes scheduled or externally connected work.

## Rule: A missing optional tool degrades to `Not run`, never to a silent pass.

**Why**: `lint-package.sh` may run without the Claude CLI; native `gh` commands may fail when `gh` is missing or unauthenticated. A silent pass would turn an unverified surface into a false green.

**Evidence**: `lint-package.sh` prints `NOT RUN claude plugin validate`; the native `gh pr list` / `gh pr merge` commands are marked `Not run` when `gh` is unavailable.

**Seen 1×** (2026-11-15)

**Scope**: Any check that depends on an optional external tool.

## Rule: Review the merged result, not only the PR head.

**Why**: Magpie's code standards merge the reviewed head onto current `main` and run the checks on the result. Running only the PR head can miss a conflict or a base change that breaks the merged tree. The first cc-loop loop file said "pull and run" without the local merge step.

**Evidence**: Magpie `docs/code-standards.md` ("A PR is merged only after a maintainer has pulled it, merged it onto current main and run the checks above on the result"); `loop-github.md` step 2 and `pr-review-record.md` updated during the alignment audit.

**Seen 1×** (2026-11-15)

**Scope**: Any PR review gate.

## Rule: Label a reimplementation as a reimplementation; name the upstream analog.

**Why**: `lint-package.sh` was described as "internalized" but is not a file from Magpie. Magpie verifies through `test.yml` + `make test`/`make test-ui` + `build/race-shards.sh`, merges with a documented `gh pr merge --match-head-commit` command, and has no night-audit collection script.

**Evidence**: Magpie `test.yml`, `Makefile`, `build/race-shards.sh`, `docs/code-standards.md`; `lint-package.sh` header; README/Handoff notes.

**Seen 1×** (2026-11-15)

**Scope**: Any artifact that re-creates an upstream behavior.

## Rule: Prefer native commands over wrappers for one-command jobs.

**Why**: `collect-day.sh` and `merge-reviewed.sh` wrapped `git log` / `gh` commands that the agent can run directly. The wrappers added maintenance surface without adding verification. They were removed; the native commands live in `loop-runtime.md` and the loop files.

**Evidence**: `loop-runtime.md` "Native commands first"; the commit that removed the wrappers.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that wraps a single native command.

## Rule: Promotion is an agent judgment, not a script.

**Why**: Magpie's night-audit agent reads `LESSONS.md`, counts `Seen` and distinct dates, and edits `docs/code-standards.md`; the repo has no promotion script. The cc-loop scanner only listed candidates; it was a convenience, not the mechanism, and was removed.

**Evidence**: `LESSONS.md` header; Magpie commits `51247a55` and `d0a4e0be`; no `scripts/` directory; no workflow for lessons.

**Seen 1×** (2026-11-15)

**Scope**: Any rules-promotion mechanism.

## Rule: A checker's test suite needs broken fixtures, not only a valid one.

**Why**: The first valid fixture in `tests/run.sh` omitted `CLAUDE.md`/`LESSONS.md`, so `lint-package.sh` correctly failed; the test exposed the fixture's assumption rather than hiding it.

**Evidence**: `tests/run.sh`; the fixture fix.

**Seen 1×** (2026-11-15)

**Scope**: Any package lint or checker.

## Rule: A 3-OS matrix on a shell tool catches portability assumptions.

**Why**: `mktemp`, `sed -i`, `cp -R`, `awk`, and path handling differ across Git Bash, macOS, and Linux. The package tests/lint now run on ubuntu, macos, and windows.

**Evidence**: `.github/workflows/test.yml`; `tests/run.sh`.

**Seen 1×** (2026-11-15)

**Scope**: Shell scripts and CI that claim portability.

## Rule: A release workflow is a gate, not a tag button.

**Why**: `.github/workflows/release.yml` runs the tests and lint before packaging; a red tag produces no release. Magpie's release uses a separate signing/notarization repo; this is the skill-package equivalent.

**Evidence**: `.github/workflows/release.yml`; the Release gate in `docs/code-standards.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any tagged release process.

## Rule: A connector contract is not a connector.

**Why**: `references/connectors.md` documents the GitHub/Discord/X tool expectations, least privilege, and `Not run` behavior; it ships no credentials and calls no API. Actual access remains the user's toolchain.

**Evidence**: `references/connectors.md`; `loop-runtime.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any externally connected loop.

## Rule: A release workflow is only proven by a real tag.

**Why**: The workflow file existing is not evidence that tests, packaging, checksums, and the release API work. `v0.1.0` was created, the `release` workflow completed successfully, and all three assets passed `sha256sum -c`.

**Evidence**: `v0.1.0` release; `cc-loop-v0.1.0.tar.gz`, `.zip`, `SHA256SUMS`; run 43704652932.

**Seen 1×** (2026-11-15)

**Scope**: Any release automation.

## Rule: A copy-paste template is not the verbatim source.

**Why**: The `/loop` templates in `loop-prompt-templates.md` have placeholders and are editable; the source prompt blocks are immutable. Mixing them would turn the source into a paraphrase.

**Evidence**: `references/loop-prompt-templates.md`; the `Source prompt (verbatim)` blocks.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that offers copy-paste prompts.

## Rule: A skill should discover the project's native test command, not ship a universal runner.

**Why**: The test suite is project-specific (`Makefile`, `package.json`, `go test`, CI). A universal wrapper would hide the real command and drift. The skill's job is to find the native command, record it in the acceptance criteria, and run it with the agent's tools.

**Evidence**: `references/test-discovery.md`; `docs/code-standards.md` Acceptance criteria; `verification-matrix.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that claims to verify a target project.

## Rule: Keep review records where the review happens, not in a parallel docs tree.

**Why**: Magpie has no `docs/reviews/`; its records are PR comments and commit bodies. A solo repository can use PRs too; direct-to-main was a choice, not a constraint. cc-loop now uses the maintainer PR flow, and `docs/reviews/` is legacy.

**Evidence**: Magpie `docs/` listing; `docs/code-standards.md` ("Write on the PR what was run"); PR #1339; `docs/contributors.md`; `docs/reviews/README.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any review-record convention.

## Rule: Do not invent a preferences file; use the host memory and existing design docs.

**Why**: `docs/preferences.md` was a proposed path, but Magpie has no such file. Its mechanism is the host's memory system plus `docs/subsystems/` design docs and the product decisions in `docs/code-standards.md`. A new file would be another invented upstream path.

**Evidence**: Magpie `docs/` listing; `docs/preferences.md` probe 404; code-standards "Don't reverse deliberate decisions"; dotey/AI智见录 memory description.

**Seen 1×** (2026-11-15)

**Scope**: Any skill that captures human preferences.

## Rule: Templates align the behavior chain; execution waits for credentials or hardware.

**Why**: Tests, CI, connectors, and real machines can be described and templated before access exists. That is behavior-chain alignment, not execution. The surface stays `Not run` until a credential, account, or machine actually runs the command.

**Evidence**: `references/ci-template.md`, `connectors.md`, `verification-matrix.md`, `test-discovery.md`.

**Seen 1×** (2026-11-15)

**Scope**: Any externally connected or hardware-dependent behavior.
