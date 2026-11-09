#!/usr/bin/env bash
# install-auto-sync.sh — run ONCE on each of your machines.
#  1. clones the repo to ~/claude-skills (or pulls it)
#  2. adds a SessionStart hook: every Claude Code session silently runs the sync and pushes new skills
#  3. adds the standing instruction to ~/.claude/CLAUDE.md so Claude uploads new skills itself
set -euo pipefail
REPO_URL="${CLAUDE_SKILLS_REPO:-https://github.com/Yousef-Tahlee/claude-skills.git}"
DIR="${CLAUDE_SKILLS_HOME:-$HOME/claude-skills}"
SRC="$(cd "$(dirname "$0")" && pwd)"

if [ -d "$DIR/.git" ]; then git -C "$DIR" pull -q --rebase --autostash || true
else git clone -q "$REPO_URL" "$DIR"; fi
mkdir -p "$HOME/.claude"

python3 - "$DIR" <<'PY'
import json, sys, pathlib
d = sys.argv[1]
p = pathlib.Path.home() / ".claude" / "settings.json"
s = json.loads(p.read_text()) if p.exists() and p.read_text().strip() else {}
cmd = f'(python3 "{d}/scripts/sync_skills.py" --push --quiet >/dev/null 2>&1 &)'
hooks = s.setdefault("hooks", {}).setdefault("SessionStart", [])
if not any("claude-skills" in h.get("command", "") or "sync_skills.py" in h.get("command", "")
           for g in hooks for h in g.get("hooks", [])):
    hooks.append({"hooks": [{"type": "command", "command": cmd}]})
    p.write_text(json.dumps(s, indent=2) + "\n")
    print("SessionStart hook added to", p)
else:
    print("SessionStart hook already present")
PY

MD="$HOME/.claude/CLAUDE.md"; touch "$MD"
if ! grep -q "claude-skills:begin" "$MD"; then
  printf '\n' >> "$MD"; cat "$SRC/CLAUDE.global.md" >> "$MD"; echo "Reminder added to $MD"
else echo "Reminder already in $MD"; fi

python3 "$DIR/scripts/sync_skills.py" --push
echo "Done. New skills on this machine will be pushed automatically."
