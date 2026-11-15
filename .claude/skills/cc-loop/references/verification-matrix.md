# Verification matrix

Record the surfaces a change was actually run on. A surface not run is `Not run`.

| Surface | How to run | Evidence | If unavailable |
|---|---|---|---|
| macOS | the project's real command on a Mac | command, output, head | `Not run` |
| Windows | the project's real command on Windows | command, output, head | `Not run` |
| Linux / WSL | the project's real command on Linux or WSL | command, output, head | `Not run` |
| Real account / vendor | a real account, config, and vendor reply | account shape, request/response | `Not run` |
| Real hardware | the device or machine the bug was reported on | device, output, reproduction | `Not run` |

## Rules

- The human sets up the physical environment; the agent does not fake it.
- A mock-only run is not a real-use check.
- Record the command, the head, and the result.
- A check that was not run is written `Not run`, never omitted.
