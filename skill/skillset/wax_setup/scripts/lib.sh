#!/usr/bin/env sh
# wax_setup: shell functions shared by setup.sh and publish.sh. Sourced, never run directly.

# wax_version <.agents-dir>: print the version token from AGENTS.md, e.g. "WAX 1.0".
wax_version() { grep -oE 'WAX [0-9][0-9.]*' "$1/AGENTS.md" 2>/dev/null | head -1; }

# seed_genesis <.agents-dir> <project-name>
# Reset handoffs/ to the genesis state: delete every entry but the template, write one
# genesis entry from assets/genesis.md under a fresh UTC stem, and write the matching
# HANDOFF.md in the same step (R-05). Only wax_setup may do this, and only on a new copy (R-04).
seed_genesis() {
  dest=$1; name=$2
  asset="$dest/skill/skillset/wax_setup/assets/genesis.md"
  [ -f "$asset" ] || { echo "FAIL: $asset is missing"; return 1; }
  version=$(wax_version "$dest")
  [ -n "$version" ] || { echo "FAIL: no 'WAX x.y' version token in $dest/AGENTS.md"; return 1; }
  for f in "$dest/handoffs/handoffs"/*; do
    [ "$(basename "$f")" = "yyyy-mm-dd-hh-mm-ss.md" ] || rm -f "$f"
  done
  stem=$(date -u +%Y-%m-%d-%H-%M-%S)
  ts=$(echo "$stem" | sed 's/^\(....-..-..\)-\(..\)-\(..\)-\(..\)$/\1 \2:\3:\4/')
  sed "s|<yyyy-mm-dd-hh-mm-ss>|$stem|g; s|<project>|$name|g; s|<version>|$version|g" "$asset" \
    > "$dest/handoffs/handoffs/$stem.md"
  cat > "$dest/handoffs/HANDOFF.md" <<HEAD
Updated $ts UTC by wax_setup setup. Read and written only by the wax_handoff skill (R-04, R-05).

# HANDOFF

Head node of the handoff directory. It points at the newest entry and states the directory's
status. It holds no session content; that lives in the entry files.

## Head

- **HEAD:** handoffs/handoffs/$stem.md
- **HEAD timestamp:** $ts UTC
- **Entries:** 1
- **Last writer:** wax_setup setup
- **Integrity:** consistent — HEAD is the newest entry file; entry count equals file count; every index row exists on disk. Validated at last write.
- **Status:** closed — resume with the pickup procedure of wax_handoff.

## Index (newest first)

- **$stem** — GENESIS: workspace installed, project not yet explored — complete — next: Explore the project briefly and report what you found to the human before doing any work.

## Template

- \`handoffs/handoffs/yyyy-mm-dd-hh-mm-ss.md\` — blank entry; copy it, never edit it (R-07).
HEAD
  echo "genesis entry: handoffs/handoffs/$stem.md ($version)"
}
