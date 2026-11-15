# Review records (cc-loop dogfood only)

Magpie has **no** `docs/reviews/` directory. Its review records live in PR comments and commit bodies; `docs/code-standards.md` says to write on the PR what was run, at which head, and what was not run (see PR #1339).

This directory is a cc-loop dogfood addition for a single-author repository without a PR process. Do not treat it as an upstream convention. The skill's `pr-review-record.md` still says to post the record on the PR; a target project should use the PR comment/commit body, not invent a parallel `docs/reviews/` tree.
