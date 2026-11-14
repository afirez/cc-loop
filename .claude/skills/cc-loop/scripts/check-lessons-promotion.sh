#!/usr/bin/env sh
# check-lessons-promotion.sh — read-only scan of LESSONS.md for promotion candidates.
# Usage: sh check-lessons-promotion.sh [path/to/LESSONS.md]
# Exit codes: 0 scan completed (there may be zero candidates); 2 file not found.
# This script does not modify any file.

set -u

usage() {
  cat <<'EOF'
Usage: check-lessons-promotion.sh [path/to/LESSONS.md]

Read-only scan of LESSONS.md listing entries that meet Seen >= 3 and come
from >= 3 distinct dates. No files are modified. Defaults to LESSONS.md in
the current directory.
EOF
}

case "${1:-}" in
  -h|--help)
    usage
    exit 0
    ;;
  "")
    file="LESSONS.md"
    ;;
  *)
    file="$1"
    ;;
esac

if [ ! -f "$file" ]; then
  echo "check-lessons-promotion: file not found: $file" >&2
  exit 2
fi

awk '
function trim(s) {
  sub(/^[ \t]+/, "", s)
  sub(/[ \t]+$/, "", s)
  return s
}

function report() {
  if (title == "") return

  work = title "\n" body
  # Normalize full-width punctuation so date lists written in Chinese also parse.
  gsub(/（/, "(", work)
  gsub(/）/, ")", work)
  gsub(/，/, ",", work)
  low = tolower(work)

  n = 0
  if (match(low, /seen[ \t]*[0-9]+/)) {
    s = substr(low, RSTART, RLENGTH)
    gsub(/[^0-9]/, "", s)
    n = s + 0
  }

  dcount = 0
  if (n > 0) {
    rest = substr(work, RSTART + RLENGTH)
    if (match(rest, /\([^)]*\)/)) {
      dates = substr(rest, RSTART + 1, RLENGTH - 2)
      m = split(dates, arr, ",")
      for (k in seen) delete seen[k]
      for (i = 1; i <= m; i++) {
        d = trim(arr[i])
        if (d ~ /^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$/ && !(d in seen)) {
          seen[d] = 1
          dcount++
        }
      }
    }
  }

  if (n >= 3 && dcount >= 3) {
    printf "Candidate: %s\n  Seen %d×, %d distinct date(s)\n", title, n, dcount
    found++
  }

  title = ""
  body = ""
}

substr($0, 1, 2) == "##" && substr($0, 3, 1) != "#" {
  report()
  title = trim(substr($0, 3))
  next
}

{
  if (title != "") body = body " " $0
}

END {
  report()
  if (found > 0) {
    printf "\n%d promotion candidate(s) (Seen >= 3 and >= 3 distinct dates).\n", found
  } else {
    print "No entry meets the promotion condition (Seen >= 3 and >= 3 distinct dates)."
  }
}
' "$file"
