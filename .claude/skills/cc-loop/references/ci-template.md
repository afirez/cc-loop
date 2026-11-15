# CI template: align the behavior chain, fill the project's commands

This is a template for a target project's CI. It is not a universal runner. Replace every `<...>` with the project's native command; do not invent a test suite.

```yaml
name: test

on:
  push:
    branches: [main]
  pull_request:
  workflow_dispatch:

# On main a run should finish; a newer push cancels a PR run, not the main run.
concurrency:
  group: test-${{ github.ref }}
  cancel-in-progress: ${{ github.ref != 'refs/heads/main' }}

permissions:
  contents: read

jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      # Replace with the project's setup step: setup-go, setup-node, setup-python, ...
      - run: <install command>
      # Replace with the project's real test command (the one CI or the Makefile runs).
      - run: <test command>
```

## Rules

- Use the project's existing commands; do not add a wrapper that hides them.
- A platform or command that cannot run is removed from the matrix and recorded as `Not run` in `references/verification-matrix.md`.
- Secrets go in the repository's secret store, never in the workflow or the skill.
- The release workflow must wait for this test to pass at the tagged head.
- If the project has no test command, ask the human; do not invent one.
