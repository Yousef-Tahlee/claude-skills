#!/usr/bin/env python3
"""Build one .zip per skill in dist/ — ready to upload on claude.ai
(Settings -> Capabilities -> Skills -> Upload). Usage: python3 scripts/build_zips.py"""
import shutil
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DIST = REPO / "dist"
shutil.rmtree(DIST, ignore_errors=True)
n = 0
for skill_md in sorted((REPO / "plugins").glob("*/skills/*/SKILL.md")):
    skill = skill_md.parent
    plugin = skill.parent.parent.name
    out = DIST / plugin / skill.name
    out.parent.mkdir(parents=True, exist_ok=True)
    shutil.make_archive(str(out), "zip", root_dir=skill.parent, base_dir=skill.name)
    n += 1
print(f"Built {n} zips in {DIST}")
