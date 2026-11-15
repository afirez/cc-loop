# Test discovery: use the project's native verification

The test suite belongs to the target project. Do not invent a universal test runner or a shell wrapper. Discover the project's own commands, record them, and run them with the agent's native tools.

## Where to look

- `Makefile`: `test`, `test-ui`, `check`, `lint`, `build` targets.
- `package.json`: `scripts.test`, `scripts.lint`, `scripts.build`, `scripts.e2e`.
- `go.mod`: `go test ./...`, `go vet ./...`, race and tags.
- `pyproject.toml`, `tox.ini`, `pytest.ini`: pytest/tox commands.
- CI workflows (`.github/workflows/*.yml`): the commands CI actually runs.
- `docs/subsystems/*.md`: existing verification commands.
- README: start/test instructions.

## What to record

- In `docs/code-standards.md` Acceptance criteria: the exact commands, environment, and what counts as a real run.
- In `docs/subsystems/<name>.md`: the subsystem's verification commands.
- In `references/verification-matrix.md`: which platform/account/hardware actually ran.
- In the PR review record: command, head, result, and `Not run`.

## Rules

- Prefer the project's existing CI commands over new ones.
- Run the full suite, not only the touched package, when the project's guards require it.
- A check that was not run is `Not run`; never infer a pass.
- If the project has no test command, ask the human; do not invent a test suite.
- The skill's own `tests/run.sh` tests the skill package, not the target project.
