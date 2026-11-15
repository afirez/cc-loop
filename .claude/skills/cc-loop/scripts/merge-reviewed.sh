#!/usr/bin/env sh
# merge-reviewed.sh — merge a PR only at the reviewed head.
# Usage: sh merge-reviewed.sh <pr-number> <reviewed-sha> [squash|merge|rebase]
# Requires gh. Refuses if the PR head no longer equals the reviewed SHA.
# This script changes the remote (it merges); use it deliberately.
# cc-loop wrapper, not a Magpie script. Magpie's rule is the
# `gh pr merge --match-head-commit <reviewed sha>` command in
# docs/code-standards.md.

set -u

PR=${1:-}
SHA=${2:-}
METHOD=${3:-squash}

if [ -z "$PR" ] || [ -z "$SHA" ]; then
  echo "usage: sh merge-reviewed.sh <pr-number> <reviewed-sha> [squash|merge|rebase]" >&2
  exit 64
fi
case "$METHOD" in
  squash|merge|rebase) ;;
  *) echo "bad method: $METHOD" >&2; exit 64 ;;
esac

if ! command -v gh >/dev/null 2>&1; then
  echo "Not run: gh not found" >&2
  exit 2
fi

head=$(gh pr view "$PR" --json headRefOid --jq .headRefOid 2>/dev/null) || {
  echo "Not run: gh pr view failed (not authenticated?)" >&2
  exit 2
}

if [ "$head" != "$SHA" ]; then
  echo "REFUSED: PR head is $head, reviewed SHA is $SHA" >&2
  exit 1
fi

gh pr merge "$PR" "--$METHOD" --match-head-commit "$SHA"
