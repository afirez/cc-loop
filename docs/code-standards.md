# Code hard rules and acceptance criteria

## Code hard rules

These rules come from lessons promoted after repeated incidents. Every change is checked against each one.

1. **A change that was not actually run must not be merged.** Run the verification commands below; a change whose checks cannot be shown to have run is unverified.
2. **Checks that were not run must be marked `Not run`.** "Looks fine" is not a substitute for actual verification.

## Acceptance criteria (what counts as a real run)

Every item must be demonstrated before merging or releasing. Anything not run is written as `Not run`, never omitted.

1. **Skill validation**: `claude plugin validate .claude/skills` passes.
2. **Frontmatter**: `name` matches the directory, `description` is within limits, and only allowed fields are used.
3. **Reference integrity**: every path that `SKILL.md` and `AGENTS.md` instruct the agent to read exists; explicit prohibitions ("do not create X") are exempt. No reference points to an invented upstream file.
4. **Script behavior**: the promotion scanner hits 3-distinct-date entries, ignores same-day duplicates and 2-date entries, parses full-width punctuation, exits 2 on a missing file, and is read-only.
5. **Source provenance**: each verbatim source block matches its cited screenshot; operational English is clearly separated from the verbatim block.
6. **No runtime state**: `.omc/`, `.memsearch/`, `.omb/`, and local editor/OS files are not committed.
7. **Record**: the change/PR states what was run, at which commit, and what was not run.

## Product decisions (human-owned)

- **Do not reverse deliberate decisions.** The verbatim source prompts and their citations are immutable unless a newer upstream source is found; the English operational sections may evolve. A change to a source block needs evidence, not taste.
- The skill stays tool-agnostic: no vendor (Jev, GitHub, Discord, X) is a hard dependency; fallbacks are documented.

## Maintenance

- New rules may only be promoted by the night audit (Loop 3) under the "three strikes" rule, with the source `LESSONS.md` entry and evidence.
- Keep the acceptance criteria current with the repo; remove checks that no longer apply.
