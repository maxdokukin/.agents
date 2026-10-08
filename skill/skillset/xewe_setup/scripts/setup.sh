#!/usr/bin/env sh
# xewe_setup: create a fresh .agents/ in a project from this reference design.
# Usage: setup.sh [target-project-dir] [--name <project-name>] [--source <reference-.agents>]
# Defaults: target = current directory, name = basename of target, source = the .agents this script lives in.
set -eu
here=$(cd "$(dirname "$0")" && pwd)
source=$(cd "$here/../../../.." && pwd)
target=""; name=""
while [ $# -gt 0 ]; do
  case "$1" in
    --name) name=$2; shift 2 ;;
    --source) source=$(cd "$2" && pwd); shift 2 ;;
    -h|--help) sed -n '2,4p' "$0" | sed 's/^# //'; exit 0 ;;
    -*) echo "FAIL: unknown option $1"; exit 2 ;;
    *) target=$1; shift ;;
  esac
done
[ -n "$target" ] || target=$PWD
[ -d "$target" ] || { echo "FAIL: $target is not a directory"; exit 1; }
target=$(cd "$target" && pwd)
[ -n "$name" ] || name=$(basename "$target")

# Refusals: wrong source, target inside the reference, target already set up.
[ -f "$source/AGENTS.md" ] && [ -f "$source/RULES.md" ] && [ -d "$source/handoffs/handoffs" ] \
  || { echo "FAIL: $source is not an .agents reference (missing AGENTS.md, RULES.md or handoffs/handoffs)"; exit 1; }
case "$target/" in "$source"/*) echo "FAIL: target $target is inside the reference .agents"; exit 1 ;; esac
[ "$target" = "$(dirname "$source")" ] && { echo "FAIL: $target already holds the reference .agents itself"; exit 1; }
[ -e "$target/.agents" ] && { echo "FAIL: $target/.agents already exists; run check.sh on it instead (nothing overwritten)"; exit 1; }

echo "source: $source"
echo "target: $target/.agents"
echo "name:   $name"

# 1. Copy the folder, without any git metadata.
cp -R "$source" "$target/.agents"
rm -rf "$target/.agents/.git"
dest="$target/.agents"

# 2. Reset handoffs to the zero-entry state: keep only the template.
for f in "$dest/handoffs/handoffs"/*; do
  [ "$(basename "$f")" = "yyyy-mm-dd-hh-mm-ss.md" ] || rm -f "$f"
done
ts=$(date -u +"%Y-%m-%d %H:%M:%S")
cat > "$dest/handoffs/HANDOFF.md" <<HEAD
Updated $ts UTC by xewe_setup setup. Read and written only by the xewe_handoff skill (R-04, R-05).

# HANDOFF

Head node of the handoff directory. It points at the newest entry and states the directory's
status. It holds no session content; that lives in the entry files.

## Head

- **HEAD:** none
- **HEAD timestamp:** none
- **Entries:** 0
- **Last writer:** none
- **Integrity:** consistent — HEAD is the newest entry file; entry count equals file count; every index row exists on disk. Validated at last write.
- **Status:** empty — no entries yet; the first handoff creates HEAD.

## Index (newest first)

(no entries)

## Template

- \`handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md\` — blank entry; copy it, never edit it (R-07).
HEAD

# 3. Fill the project name in AGENTS.md.
sed "s|<project>|$name|g" "$dest/AGENTS.md" > "$dest/AGENTS.md.tmp" && mv "$dest/AGENTS.md.tmp" "$dest/AGENTS.md"

# 4. Verify the result.
echo "---"
sh "$here/check.sh" "$dest"
echo "---"
echo "Done. Review $dest/PREFERENCES.md now: these defaults are yours to change (R-15). RULES.md stays as shipped."
echo "Point the agent at $dest/AGENTS.md. Its first action is the pickup procedure of xewe_handoff."
