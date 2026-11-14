# Code hard rules and acceptance criteria

## Code hard rules

These rules come from lessons promoted after repeated incidents. Every PR review checks each one.

1. **A PR that was not actually run must not be merged.** The reviewer pulls the branch locally and runs it; a PR whose tests cannot be shown to have run is treated as unverified.
2. **Checks that were not run must be marked `Not run`.** "Looks fine" is not a substitute for actual verification.

## Acceptance criteria (what counts as a real run)

Every item must be demonstrated before merging or releasing. Anything not run is written as `Not run`, never omitted.

1. **Red check**: put the old code back and run the new test; it must fail for the stated behavior. A compile error or a skipped test does not count.
2. **Real use**: when a change touches a vendor or runtime integration, verify with a real account, real config, and real API response. A feature that was not actually tried must not be built on, or described to users as working.
3. **Full suite and build**: run the full test suite and build, not only the packages you touched; cross-platform projects must cover the target platforms.
4. **Record**: the PR/commit states what was run, at which head, and what was not run.

## Product decisions (human-owned)

- **Do not reverse deliberate decisions.** Interaction, visuals, defaults, and other product decisions belong to the maintainer; a PR may propose, not change them.

## Maintenance

- Start with the hard rules above; do not pile up rules in advance. Keep the acceptance criteria reasonably complete, because they define Loop 1's merge gate.
- New rules may only be promoted by the night audit (Loop 3) under the "three strikes" rule, with the source `LESSONS.md` entry and evidence.
- The "red check" and "Not run" items must never be removed.
