#!/usr/bin/env python3
"""Build one .zip per skill in dist/ (flat names: <plugin>--<skill>.zip) plus
all-skills.zip. Each zip uploads directly on claude.ai (Settings -> Capabilities
-> Skills -> Upload) or unzips into ~/.claude/skills/.  Usage: python3 scripts/build_zips.py"""
import shutil
import zipfile
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
DIST = REPO / "downloads"
shutil.rmtree(DIST, ignore_errors=True)
DIST.mkdir()
n = 0


def add(z, f, arc):
    """Fixed timestamp + mode so the same files always give identical zip bytes."""
    info = zipfile.ZipInfo(arc, date_time=(1980, 1, 1, 0, 0, 0))
    info.compress_type = zipfile.ZIP_DEFLATED
    info.external_attr = (0o755 if f.stat().st_mode & 0o111 else 0o644) << 16
    z.writestr(info, f.read_bytes())


with zipfile.ZipFile(DIST / "all-skills.zip", "w", zipfile.ZIP_DEFLATED) as allz:
    for skill_md in sorted((REPO / "plugins").glob("*/skills/*/SKILL.md")):
        skill = skill_md.parent
        plugin = skill.parent.parent.name
        with zipfile.ZipFile(DIST / f"{plugin}--{skill.name}.zip", "w", zipfile.ZIP_DEFLATED) as z:
            for f in sorted(skill.rglob("*")):
                if f.is_file():
                    add(z, f, f"{skill.name}/{f.relative_to(skill)}")
                    add(allz, f, f"{plugin}/{skill.name}/{f.relative_to(skill)}")
        n += 1
print(f"Built {n} skill zips + all-skills.zip in {DIST}")
