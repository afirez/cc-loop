#!/usr/bin/env sh
# collect-day.sh — read-only night-audit input collector.
# Usage: sh collect-day.sh [since] [repo-root]
# Default since: "24 hours ago". Prints commits, recent tags, merged PRs
# (if gh is available), and a checklist. Does not modify any file.
# cc-loop implementation, not a Magpie script. Magpie's night-audit
# collection/trigger is not in its repository; this gathers the input.

set -u

SINCE=${1:-24 hours ago}
ROOT=${2:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}

echo "# Night audit input"
echo
echo "Repository: $ROOT"
echo "Since: $SINCE"
echo
echo "## Commits"
git -C "$ROOT" log --since="$SINCE" --date=short --pretty=format:'- %h %ad %s' 2>/dev/null || echo "Not run: git log failed"
echo
echo
echo "## Recent tags"
git -C "$ROOT" for-each-ref --sort=-creatordate --count=20 --format='- %(refname:short) %(creatordate:short)' refs/tags 2>/dev/null || echo "Not run: git for-each-ref failed"
echo
echo
echo "## Merged pull requests (last 50)"
if command -v gh >/dev/null 2>&1; then
  if gh pr list --state merged --limit 50 --json number,title,headRefOid,mergedAt \
    --template '{{range .}}- #{{.number}} {{.title}} ({{.headRefOid}}, {{.mergedAt}}){{"\n"}}{{end}}' 2>/dev/null; then
    :
  else
    echo "Not run: gh pr list failed or not authenticated"
  fi
else
  echo "Not run: gh not found"
fi
echo
echo "## Checklist"
echo "- [ ] Which fixes were reworked?"
echo "- [ ] Which changes should not have merged?"
echo "- [ ] Which verification was too thin?"
echo "- [ ] Write lessons to LESSONS.md (rule / why / evidence / Seen N×)"
echo "- [ ] Run check-lessons-promotion.sh"
