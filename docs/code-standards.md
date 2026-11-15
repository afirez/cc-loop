# Code hard rules and acceptance criteria

## Code hard rules

These rules come from lessons promoted after repeated incidents. Every change is checked against each one.

1. **A change that was not actually run must not be merged.** Run the verification commands below; a change whose checks cannot be shown to have run is unverified.
2. **Checks that were not run must be marked `Not run`.** "Looks fine" is not a substitute for actual verification.
3. **A merge records the reviewed head and the merged result.** Write the record in `.claude/skills/cc-loop/references/pr-review-record.md`; merge the reviewed head onto current `main` locally and run the checks on the merged result; merge at that head with `--match-head-commit`. A merge with no record of what was run cannot be checked afterwards.

## Acceptance criteria (what counts as a real run)

Every item must be demonstrated before merging or releasing. Anything not run is written as `Not run`, never omitted.

1. **Skill validation**: `claude plugin validate .claude/skills` passes.
2. **Frontmatter**: `name` matches the directory, `description` is within limits, and only allowed fields are used.
3. **Reference integrity**: every path that `SKILL.md` and `AGENTS.md` instruct the agent to read exists; explicit prohibitions ("do not create X") are exempt. No reference points to an invented upstream file.
4. **Promotion judgment**: a candidate must have `Seen >= 3` and 3 distinct dates; the night-audit agent reads `LESSONS.md`, moves the rule into `docs/code-standards.md`, and marks it promoted. No script is required.
5. **Source provenance**: each verbatim source block matches its cited screenshot; operational English is clearly separated from the verbatim block.
6. **No runtime state**: `.omc/`, `.memsearch/`, `.omb/`, and local editor/OS files are not committed.
7. **Record**: the change/PR states what was run, at which commit, and what was not run.
8. **Package lint**: `sh .claude/skills/cc-loop/scripts/lint-package.sh` passes, and `.github/workflows/lint-package.yml` runs it on push/PR. This is a package lint, not a substitute for a target project's test suite.
9. **Review record / merge gate**: a merge uses `references/pr-review-record.md`, runs the checks on the reviewed head merged onto current `main`, and uses `--match-head-commit`; a review with no record is not a merge.
10. **Release gate**: if this repo tags/releases, the tagged head had a green verification run; record what was run and do not move an older release to Latest.

## Product decisions (human-owned)

- **Do not reverse deliberate decisions.** The verbatim source prompts and their citations are immutable unless a newer upstream source is found; the English operational sections may evolve. A change to a source block needs evidence, not taste.
- The skill stays tool-agnostic: no vendor (Jev, GitHub, Discord, X) is a hard dependency; fallbacks are documented.

## Human gates

- **Security/harm**: see `docs/contributors.md`; a harm-stop waits for the maintainer.
- **Physical environment**: the human sets up real machines/accounts; a check that cannot run is `Not run`.
- **UI/UX**: the human owns taste; the agent proposes.

## Release gate

- Tag/release only after the verification run at the tagged commit is green; a run cancelled by the next push is not a pass.
- Record what was run at the tagged head; do not move an older release to Latest.
- If the project has no release process, say so; do not invent one.

## Maintenance

- New rules may only be promoted by the night audit (Loop 3) under the "three strikes" rule, with the source `LESSONS.md` entry and evidence.
- Keep the acceptance criteria current with the repo; remove checks that no longer apply.
