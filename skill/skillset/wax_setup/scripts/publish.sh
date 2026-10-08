#!/usr/bin/env sh
# wax_setup: export this reference design into a clone of the public repository. Maintainers only.
# Usage: publish.sh <public-clone-dir> [--source <reference-.agents>]
# Copies everything but .git and handoff entries, reseeds the genesis entry, runs check.sh, never commits.
set -eu
here=$(cd "$(dirname "$0")" && pwd -P)
. "$here/lib.sh"
source=$(cd "$here/../../../.." && pwd)
target=""
while [ $# -gt 0 ]; do
  case "$1" in
    --source) source=$(cd "$2" && pwd); shift 2 ;;
    -h|--help) sed -n '2,4p' "$0" | sed 's/^# //'; exit 0 ;;
    -*) echo "FAIL: unknown option $1"; exit 2 ;;
    *) target=$1; shift ;;
  esac
done
[ -n "$target" ] || { echo "FAIL: give the public clone directory"; exit 2; }
[ -d "$target" ] || { echo "FAIL: $target is not a directory"; exit 1; }
target=$(cd "$target" && pwd)
[ -d "$target/.git" ] && [ -f "$target/AGENTS.md" ] && [ -d "$target/handoffs/handoffs" ] \
  || { echo "FAIL: $target is not a git clone of the reference (missing .git, AGENTS.md or handoffs/handoffs)"; exit 1; }
[ "$target" = "$source" ] && { echo "FAIL: target is the source itself"; exit 1; }
command -v rsync >/dev/null || { echo "FAIL: rsync is required"; exit 1; }

echo "source: $source"
echo "target: $target"

# 1. Mirror the tree. Handoff entries are left out on both sides; the genesis step replaces them.
rsync -a --delete --exclude '/.git' --exclude '/handoffs/handoffs/[0-9]*.md' "$source/" "$target/"

# 2. Public copies ship the <project> placeholder and one genesis entry.
seed_genesis "$target" "<project>"

# 3. Verify, then hand the result to the human. Nothing is committed (P-09).
echo "---"
sh "$here/check.sh" "$target"
echo "---"
git -C "$target" status --short
echo "Review the diff above, then commit and push from $target yourself."
