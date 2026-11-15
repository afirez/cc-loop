#!/usr/bin/env sh
# run.sh — package test suite for the cc-loop skill.
# Usage: sh tests/run.sh [repo-root]
# Runs lint-package.sh against good and broken fixtures.
# Exit codes: 0 all tests pass; 1 one or more tests failed.

set -u

ROOT=${1:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)}
SKILL="$ROOT/.claude/skills/cc-loop"
LINT="$SKILL/scripts/lint-package.sh"
PASS=0
FAIL=0

ok() { PASS=$((PASS + 1)); printf 'PASS %s\n' "$1"; }
bad() { FAIL=$((FAIL + 1)); printf 'FAIL %s\n' "$1"; }

fixture() {
  d=$(mktemp -d 2>/dev/null || mktemp -d -t cc-loop-test)
  mkdir -p "$d/.claude/skills"
  cp -R "$SKILL" "$d/.claude/skills/cc-loop"
  cp "$ROOT/AGENTS.md" "$d/AGENTS.md"
  cp "$ROOT/CLAUDE.md" "$d/CLAUDE.md"
  cp "$ROOT/LESSONS.md" "$d/LESSONS.md"
  cp "$ROOT/README.md" "$d/README.md"
  cp "$ROOT/LICENSE" "$d/LICENSE"
  cp -R "$ROOT/docs" "$d/docs"
  printf '%s\n' "$d"
}

run_lint() {
  LINT_SKIP_CLAUDE=1 sh "$LINT" "$1" 2>&1
}

# 1. A valid package passes.
d=$(fixture)
out=$(run_lint "$d"); code=$?
if [ "$code" -eq 0 ] && printf '%s\n' "$out" | grep -q 'RESULT: PASS'; then
  ok "valid package passes"
else
  bad "valid package passes (exit $code)"
  printf '%s\n' "$out" | tail -5
fi
rm -rf "$d"

# 2. A missing reference fails.
d=$(fixture)
rm "$d/.claude/skills/cc-loop/references/loop-runtime.md"
out=$(run_lint "$d"); code=$?
if [ "$code" -ne 0 ] && printf '%s\n' "$out" | grep -q 'FAIL missing references'; then
  ok "missing reference fails"
else
  bad "missing reference fails (exit $code)"
fi
rm -rf "$d"

# 3. A mismatched frontmatter name fails.
d=$(fixture)
f="$d/.claude/skills/cc-loop/SKILL.md"
sed 's/^name: cc-loop$/name: wrong/' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
out=$(run_lint "$d"); code=$?
if [ "$code" -ne 0 ] && printf '%s\n' "$out" | grep -q "FAIL frontmatter name 'wrong'"; then
  ok "wrong name fails"
else
  bad "wrong name fails (exit $code)"
fi
rm -rf "$d"

# 4. A missing source prompt provenance line fails.
d=$(fixture)
f="$d/.claude/skills/cc-loop/references/loop-social.md"
grep -v '^Source:.*http' "$f" > "$f.tmp" && mv "$f.tmp" "$f"
out=$(run_lint "$d"); code=$?
if [ "$code" -ne 0 ] && printf '%s\n' "$out" | grep -q 'FAIL source prompt: loop-social.md'; then
  ok "missing source provenance fails"
else
  bad "missing source provenance fails (exit $code)"
fi
rm -rf "$d"

# 5. A tracked .omc file fails.
d=$(fixture)
git -C "$d" init -q
mkdir -p "$d/.omc"
printf 'state\n' > "$d/.omc/state.json"
git -C "$d" add .omc/state.json
out=$(run_lint "$d"); code=$?
if [ "$code" -ne 0 ] && printf '%s\n' "$out" | grep -q 'FAIL tracked runtime state'; then
  ok "tracked runtime state fails"
else
  bad "tracked runtime state fails (exit $code)"
fi
rm -rf "$d"

# 6. Missing README/LICENSE is a Not run warning, not a failure.
d=$(fixture)
rm "$d/README.md" "$d/LICENSE"
out=$(run_lint "$d"); code=$?
if [ "$code" -eq 0 ] && printf '%s\n' "$out" | grep -q 'NOT RUN README missing'; then
  ok "missing README is Not run"
else
  bad "missing README is Not run (exit $code)"
fi
rm -rf "$d"

echo
if [ "$FAIL" -eq 0 ]; then
  echo "RESULT: PASS ($PASS tests)"
  exit 0
else
  echo "RESULT: FAIL ($FAIL failed, $PASS passed)"
  exit 1
fi
