#!/usr/bin/env python3
"""Check every skill has a SKILL.md with name + description, and the catalog is fresh."""
import json, subprocess, sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).parent))
from sync_skills import frontmatter, build_catalog, REPO  # noqa: E402

errors = []
for md in sorted((REPO / "plugins").glob("*/skills/*/SKILL.md")):
    fm = frontmatter(md)
    for key in ("name", "description"):
        if not fm.get(key):
            errors.append(f"{md.relative_to(REPO)}: missing '{key}' in front matter")
for pj in sorted((REPO / "plugins").glob("*/.claude-plugin/plugin.json")):
    try:
        json.loads(pj.read_text())
    except Exception as e:
        errors.append(f"{pj.relative_to(REPO)}: invalid JSON ({e})")
cat = build_catalog()
saved = json.loads((REPO / "catalog.json").read_text())
if saved["total_skills"] != cat["total_skills"]:
    errors.append("catalog.json is stale — run scripts/sync_skills.py")
for e in errors:
    print("ERROR", e)
print(f"{cat['total_skills']} skills checked, {len(errors)} error(s).")
sys.exit(1 if errors else 0)
