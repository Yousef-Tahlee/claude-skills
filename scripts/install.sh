#!/usr/bin/env bash
# install.sh — copy every skill in this repo into ~/.claude/skills (Claude Code).
# Use this if you don't want the /plugin marketplace route.
#   bash scripts/install.sh            # install / update all
#   bash scripts/install.sh engineering data   # only these plugins
set -euo pipefail
REPO="$(cd "$(dirname "$0")/.." && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
mkdir -p "$DEST"
want=("$@")
count=0
for skill in "$REPO"/plugins/*/skills/*/; do
  skill="${skill%/}"; name="$(basename "$skill")"
  plugin="$(basename "$(dirname "$(dirname "$skill")")")"
  if [ ${#want[@]} -gt 0 ] && [[ ! " ${want[*]} " =~ " ${plugin} " ]]; then continue; fi
  target="$DEST/$name"
  # name clash with a skill from another plugin -> prefix with the plugin name
  if [ -f "$target/.claude-skills-origin" ] && [ "$(cat "$target/.claude-skills-origin")" != "$plugin" ]; then
    target="$DEST/$plugin-$name"
  fi
  rm -rf "$target"; cp -R "$skill" "$target"; echo "$plugin" > "$target/.claude-skills-origin"
  count=$((count+1))
done
echo "Installed $count skills into $DEST — restart Claude Code to load them."
