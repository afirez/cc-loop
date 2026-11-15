#!/usr/bin/env sh
# lint-package.sh — package-level lint for the cc-loop skill package.
# Usage: sh lint-package.sh [repo-root]
# Exit codes: 0 all checks pass (Not run allowed); 1 one or more checks failed.
# This is a package lint, not Magpie's verification. Magpie verifies with
# .github/workflows/test.yml, `make test` / `make test-ui`, build/race-shards.sh,
# and real machines. This script is read-only except for a temporary file used
# by the optional `claude plugin validate` check.

set -u

ROOT=${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
SKILL="$ROOT/.claude/skills/cc-loop"
FAIL=0
NOTRUN=0

pass() { printf 'PASS %s\n' "$1"; }
fail() { printf 'FAIL %s\n' "$1"; FAIL=$((FAIL + 1)); }
notrun() { printf 'NOT RUN %s\n' "$1"; NOTRUN=$((NOTRUN + 1)); }

echo "== cc-loop package lint =="
echo "root: $ROOT"

# 1. Required files
for f in \
  SKILL.md \
  references/agents-template.md \
  references/lessons-format.md \
  references/code-standards-template.md \
  references/contributors-template.md \
  references/subsystems-template.md \
  references/pr-review-record.md \
  references/loop-runtime.md \
  references/connectors.md \
  references/verification-matrix.md \
  references/loop-prompt-templates.md \
  references/test-discovery.md \
  references/ci-template.md \
  references/loop-github.md \
  references/loop-social.md \
  references/loop-night-audit.md \
  scripts/lint-package.sh
do
  if [ -f "$SKILL/$f" ]; then pass "exists $f"; else fail "missing $f"; fi
done

# 2. Frontmatter
if [ -f "$SKILL/SKILL.md" ]; then
  if [ "$(sed -n '1p' "$SKILL/SKILL.md")" = "---" ]; then
    end=$(awk 'NR > 1 && $0 == "---" { print NR; exit }' "$SKILL/SKILL.md")
    if [ -n "$end" ]; then
      name=$(awk -v e="$end" 'NR > 1 && NR < e && $1 == "name:" { sub(/^name:[ \t]*/, ""); print; exit }' "$SKILL/SKILL.md")
      desc=$(awk -v e="$end" 'NR > 1 && NR < e && $1 == "description:" { sub(/^description:[ \t]*/, ""); print; exit }' "$SKILL/SKILL.md")
      dir=$(basename "$SKILL")
      if [ "$name" = "$dir" ]; then pass "frontmatter name matches directory"; else fail "frontmatter name '$name' != '$dir'"; fi
      dlen=$(printf '%s' "$desc" | wc -c | tr -d ' ')
      if [ "$dlen" -ge 1 ] && [ "$dlen" -le 1024 ]; then pass "description length ($dlen bytes)"; else fail "description length ($dlen bytes)"; fi
      bad=$(awk -v e="$end" 'NR > 1 && NR < e && /^[A-Za-z0-9_-]+:/ { k = $1; sub(/:.*/, "", k); if (k != "name" && k != "description" && k != "license" && k != "compatibility" && k != "metadata" && k != "allowed-tools") print k }' "$SKILL/SKILL.md")
      if [ -z "$bad" ]; then pass "frontmatter keys allowed"; else fail "unexpected frontmatter keys: $bad"; fi
    else
      fail "frontmatter closing --- not found"
    fi
  else
    fail "SKILL.md does not start with ---"
  fi
fi

# 3. Reference integrity: paths the files tell the agent to read
refs=$(
  awk '
    /has no|do not create|prohibition/ { next }
    {
      line = $0
      while (match(line, /`[^`]*`/)) {
        print substr(line, RSTART + 1, RLENGTH - 2)
        line = substr(line, RSTART + RLENGTH)
      }
    }
  ' "$SKILL/SKILL.md" 2>/dev/null
  if [ -f "$ROOT/AGENTS.md" ]; then
    awk '
      /has no|do not create|prohibition/ { next }
      {
        line = $0
        while (match(line, /`[^`]*`/)) {
          print substr(line, RSTART + 1, RLENGTH - 2)
          line = substr(line, RSTART + RLENGTH)
        }
      }
    ' "$ROOT/AGENTS.md"
  fi
)

ref_missing=
for p in $refs; do
  case "$p" in
    /*|*'<'*|*'>'*|*'*'*|*'~'*|*'$'*|*'...'*) continue ;;
  esac
  case "$p" in
    references/*|scripts/*) full="$SKILL/$p" ;;
    docs/*|.claude/*|LESSONS.md|CLAUDE.md|AGENTS.md) full="$ROOT/$p" ;;
    *) continue ;;
  esac
  if [ ! -e "$full" ]; then ref_missing="$ref_missing $p"; fi
done
if [ -z "$ref_missing" ]; then pass "reference integrity"; else fail "missing references:$ref_missing"; fi

# 4. No agent-runtime state in git
if git -C "$ROOT" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  tracked=$(git -C "$ROOT" ls-files | grep -E '^\.(omc|memsearch|omb)/' || true)
  if [ -z "$tracked" ]; then pass "no runtime state tracked"; else fail "tracked runtime state: $tracked"; fi
else
  notrun "runtime-state check (not a git repo)"
fi

# 5. Verbatim source prompt blocks
for f in loop-github.md loop-social.md loop-night-audit.md; do
  if grep -q '## Source prompt (verbatim' "$SKILL/references/$f" && grep -q 'Source:.*http' "$SKILL/references/$f"; then
    pass "source prompt: $f"
  else
    fail "source prompt: $f"
  fi
done

# 6. Optional Claude Code validation
tmp=$(mktemp -d 2>/dev/null || mktemp -d -t cc-loop-lint)
cleanup() { rm -rf "$tmp"; }
trap cleanup EXIT INT TERM

if [ "${LINT_SKIP_CLAUDE:-0}" = "1" ]; then
  notrun "claude plugin validate (skipped by LINT_SKIP_CLAUDE)"
elif command -v claude >/dev/null 2>&1; then
  if (cd "$ROOT" && claude plugin validate .claude/skills >"$tmp/claude.out" 2>&1); then
    pass "claude plugin validate"
  else
    fail "claude plugin validate"
    sed -n '1,20p' "$tmp/claude.out"
  fi
else
  notrun "claude plugin validate (claude not found)"
fi

# 7. Repository docs (warnings, not gates)
if [ -f "$ROOT/README.md" ]; then pass "README present"; else notrun "README missing"; fi
if [ -f "$ROOT/LICENSE" ]; then pass "LICENSE present"; else notrun "LICENSE missing"; fi

echo
if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS ($FAIL failed, $NOTRUN not run)"
  exit 0
else
  echo "RESULT: FAIL ($FAIL failed, $NOTRUN not run)"
  exit 1
fi
