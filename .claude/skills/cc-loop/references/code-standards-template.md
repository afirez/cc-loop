# Code hard rules and acceptance criteria

## Code hard rules

These rules come from lessons promoted after repeated incidents. Every PR review checks each one.

1. **A PR that was not actually run must not be merged.** The reviewer pulls the branch locally and runs it; a PR whose tests cannot be shown to have run is treated as unverified.
2. **Checks that were not run must be marked `Not run`.** "Looks fine" is not a substitute for actual verification.
3. **A merge records the reviewed head.** Write the record in `references/pr-review-record.md`; merge at that head with `--match-head-commit` (or `scripts/merge-reviewed.sh`). A merge with no record of what was run cannot be checked afterwards.

## Acceptance criteria (what counts as a real run)

Every item must be demonstrated before merging or releasing. Anything not run is written as `Not run`, never omitted.

1. **Red check**: put the old code back and run the new test; it must fail for the stated behavior. A compile error or a skipped test does not count.
2. **Real use**: when a change touches a vendor or runtime integration, verify with a real account, real config, and real API response. A feature that was not actually tried must not be built on, or described to users as working.
3. **Full suite and build**: run the full test suite and build, not only the packages you touched; cross-platform projects must cover the target platforms.
4. **Record**: the PR/commit states what was run, at which head, and what was not run.

## Product decisions (human-owned)

- **Do not reverse deliberate decisions.** Interaction, visuals, defaults, and other product decisions belong to the maintainer; a PR may propose, not change them.

## Human gates

- **Security/harm**: see `docs/contributors.md`; a harm-stop waits for the maintainer.
- **Physical environment**: the human sets up real machines/accounts; a check that cannot run is `Not run`.
- **UI/UX**: the human owns taste; the agent proposes.

## Release gate

- Tag/release only after the verification run at the tagged commit is green; a run cancelled by the next push is not a pass.
- Record what was run at the tagged head; do not move an older release to Latest.
- If the project has no release process, say so; do not invent one.

## Maintenance

- Start with the hard rules above; do not pile up rules in advance. Keep the acceptance criteria reasonably complete, because they define Loop 1's merge gate.
- New rules may only be promoted by the night audit (Loop 3) under the "three strikes" rule, with the source `LESSONS.md` entry and evidence.
- The "red check" and "Not run" items must never be removed.
