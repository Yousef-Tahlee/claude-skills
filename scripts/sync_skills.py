#!/usr/bin/env python3
"""
sync_skills.py — collect every Claude skill on this machine into this repo.

Sources scanned (whichever exist):
  ~/.claude/skills/<name>/SKILL.md              -> plugins/my-skills/skills/<name>
  ~/.claude/skills/synced/<id>/<name>/SKILL.md  -> plugins/my-skills/skills/<name>   (claude.ai account skills)
  ~/.claude/plugins/synced/<id>/<plugin>/       -> plugins/<plugin-name>/            (claude.ai plugins)
  ~/.claude/plugins/cache/<mkt>/<plugin>/<ver>/ -> plugins/<plugin-name>/            (Claude Code /plugin installs)
  /mnt/skills/public/<name>                     -> plugins/document-skills/skills/<name>
  /mnt/skills/examples/<name>                   -> plugins/example-skills/skills/<name>
  extra dirs in config/extra-sources.txt        -> plugins/system-tools/skills/<name>

Skills are only ever ADDED or UPDATED, never deleted: a skill that disappears from one
machine stays in the repo (the repo is the union of all machines).

Then it regenerates:
  .claude-plugin/marketplace.json   (so `/plugin marketplace add <owner>/claude-skills` works)
  plugins/<p>/.claude-plugin/plugin.json (when missing)
  CATALOG.md + catalog.json

Usage:
  python3 scripts/sync_skills.py            # collect + regenerate
  python3 scripts/sync_skills.py --push     # ... then git commit + push if anything changed
  python3 scripts/sync_skills.py --quiet --push   # for hooks
"""
from __future__ import annotations

import argparse
import datetime as dt
import filecmp
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
PLUGINS = REPO / "plugins"
HOME = Path.home()
MARKETPLACE_NAME = "claude-skills"
OWNER = {"name": "Yousef Tahlee"}

IGNORE = shutil.ignore_patterns(
    ".in_use", ".git", "__pycache__", "*.pyc", ".DS_Store", "node_modules",
    ".credentials*", "*.env", ".env*",
)

GROUP_META = {
    "my-skills": "Personal skills from my claude.ai account and ~/.claude/skills on my machines.",
    "document-skills": "Core Anthropic skills (docx, pdf, pptx, xlsx, file reading, frontend design...).",
    "example-skills": "Anthropic example skills available in Claude (skill-creator, mcp-builder, canvas-design...).",
    "system-tools": "Tooling skills that ship with the environment (playwright, desktop computer use...).",
}

CATEGORY_OF = {
    "my-skills": "personal", "document-skills": "documents", "example-skills": "examples",
    "system-tools": "tooling", "engineering": "engineering", "data": "data", "design": "design",
    "marketing": "marketing", "brand-voice": "marketing", "zapier": "automation",
    "cowork-plugin-management": "tooling",
}

log_quiet = False


def log(*a):
    if not log_quiet:
        print(*a)


# ---------------------------------------------------------------- helpers
def frontmatter(skill_md: Path) -> dict:
    """Tiny YAML front-matter reader (name/description, incl. folded blocks)."""
    try:
        text = skill_md.read_text(encoding="utf-8", errors="replace")
    except OSError:
        return {}
    m = re.match(r"^---\s*\n(.*?)\n---", text, re.S)
    if not m:
        return {}
    out, key, buf = {}, None, []
    for line in m.group(1).splitlines():
        km = re.match(r"^([A-Za-z0-9_-]+):\s*(.*)$", line)
        if km and not line.startswith(" "):
            if key:
                out[key] = " ".join(buf).strip()
            key, val = km.group(1), km.group(2).strip()
            buf = [] if val in (">", "|", ">-", "|-") else [val.strip("\"'")]
        elif key:
            buf.append(line.strip())
    if key:
        out[key] = " ".join(buf).strip()
    return out


def dirs_equal(a: Path, b: Path) -> bool:
    if not b.exists():
        return False
    cmp = filecmp.dircmp(a, b, ignore=[".in_use", "__pycache__", ".DS_Store"])
    if cmp.left_only or cmp.right_only or cmp.diff_files or cmp.funny_files:
        return False
    return all(dirs_equal(a / d, b / d) for d in cmp.common_dirs)


def copy_tree(src: Path, dst: Path, changes: list, label: str):
    if dirs_equal(src, dst):
        return
    existed = dst.exists()
    if existed:
        shutil.rmtree(dst)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copytree(src, dst, ignore=IGNORE, symlinks=False, dirs_exist_ok=True)
    changes.append(("updated" if existed else "added", label))


def plugin_name_of(plugin_dir: Path) -> str:
    pj = plugin_dir / ".claude-plugin" / "plugin.json"
    try:
        return json.loads(pj.read_text())["name"]
    except Exception:
        return plugin_dir.name


# ---------------------------------------------------------------- restricted
# Skills whose LICENSE forbids copying/distributing them outside Claude are never
# copied into the repo. They are only *listed* (config/builtin-only.json) as
# "built into Claude".
BUILTIN_ONLY_FILE = REPO / "config" / "builtin-only.json"
RESTRICTED: dict = {}


def is_restricted(skill_dir: Path) -> bool:
    for lic in skill_dir.glob("LICENSE*"):
        t = lic.read_text(errors="replace")
        if "All rights reserved" in t and ("may not" in t or "Distribute" in t):
            return True
    return False


def record_restricted(d: Path, group: str, changes: list):
    fm = frontmatter(d / "SKILL.md")
    RESTRICTED[d.name] = {"name": fm.get("name") or d.name, "group": group,
                          "description": fm.get("description", "")}
    dst = PLUGINS / group / "skills" / d.name
    if dst.exists():
        shutil.rmtree(dst)
        changes.append(("removed", f"{group}/{d.name} (license: built-in only)"))


def save_restricted():
    old = {}
    if BUILTIN_ONLY_FILE.exists():
        old = json.loads(BUILTIN_ONLY_FILE.read_text())
    for k, v in RESTRICTED.items():
        old.setdefault(k, v)
    BUILTIN_ONLY_FILE.write_text(json.dumps(dict(sorted(old.items())), indent=2, ensure_ascii=False) + "\n")
    return old


# ---------------------------------------------------------------- collectors
def collect_skill_dir(root: Path, group: str, changes: list, seen: dict):
    """Every child of `root` that contains SKILL.md becomes plugins/<group>/skills/<name>."""
    if not root.is_dir():
        return
    for d in sorted(root.iterdir()):
        if not (d / "SKILL.md").is_file():
            continue
        name = d.name
        if is_restricted(d):
            record_restricted(d, group, changes)
            continue
        dst = PLUGINS / group / "skills" / name
        key = (group, name)
        if key in seen and seen[key] != d:
            # same name from two sources in one run: keep both
            if dirs_equal(d, dst):
                continue
            dst = PLUGINS / group / "skills" / f"{name}-{d.parent.name[:8]}"
        seen[key] = d
        copy_tree(d, dst, changes, f"{group}/{dst.name}")


def collect_plugin(src: Path, changes: list):
    if not (src / "skills").is_dir() and not (src / ".claude-plugin").is_dir():
        return
    name = plugin_name_of(src)
    copy_tree(src, PLUGINS / name, changes, f"plugin {name}")


def collect_all() -> list:
    changes, seen = [], {}
    cl = HOME / ".claude"

    # 1) personal skills
    collect_skill_dir(cl / "skills", "my-skills", changes, seen)
    for sync_root in sorted(d for d in (cl / "skills" / "synced").glob("*") if d.is_dir()):
        collect_skill_dir(sync_root, "my-skills", changes, seen)

    # 2) claude.ai plugins
    for sync_root in sorted(d for d in (cl / "plugins" / "synced").glob("*") if d.is_dir()):
        for p in sorted(sync_root.iterdir()):
            if p.is_dir():
                collect_plugin(p, changes)

    # 3) Claude Code /plugin installs (cache/<marketplace>/<plugin>/<version>)
    for pj in sorted((cl / "plugins" / "cache").glob("*/*/*/.claude-plugin/plugin.json")):
        collect_plugin(pj.parent.parent, changes)
    # marketplace clones that contain plugins directly
    for pj in sorted((cl / "plugins" / "marketplaces").glob("*/plugins/*/.claude-plugin/plugin.json")):
        if MARKETPLACE_NAME in str(pj):  # don't re-import ourselves
            continue
        collect_plugin(pj.parent.parent, changes)

    # 4) built-in skills of the environment
    collect_skill_dir(Path("/mnt/skills/public"), "document-skills", changes, seen)
    collect_skill_dir(Path("/mnt/skills/examples"), "example-skills", changes, seen)

    # 5) extra sources (one path per line; each path is a folder of skills or a single skill)
    extra = REPO / "config" / "extra-sources.txt"
    if extra.exists():
        for line in extra.read_text().splitlines():
            line = os.path.expanduser(line.split("#", 1)[0].strip())
            if not line:
                continue
            p = Path(line)
            if (p / "SKILL.md").is_file():
                copy_tree(p, PLUGINS / "system-tools" / "skills" / p.name, changes, f"system-tools/{p.name}")
            else:
                collect_skill_dir(p, "system-tools", changes, seen)
    return changes


# ---------------------------------------------------------------- generators
def ensure_plugin_json(pdir: Path):
    pj = pdir / ".claude-plugin" / "plugin.json"
    if pj.exists():
        return
    pj.parent.mkdir(parents=True, exist_ok=True)
    pj.write_text(json.dumps({
        "name": pdir.name,
        "version": "1.0.0",
        "description": GROUP_META.get(pdir.name, f"{pdir.name} skills"),
        "author": OWNER,
    }, indent=2, ensure_ascii=False) + "\n")


def build_catalog() -> dict:
    plugins = []
    for pdir in sorted(p for p in PLUGINS.iterdir() if p.is_dir()):
        ensure_plugin_json(pdir)
        meta = json.loads((pdir / ".claude-plugin" / "plugin.json").read_text())
        skills = []
        for sk in sorted((pdir / "skills").glob("*/SKILL.md")):
            fm = frontmatter(sk)
            skills.append({
                "name": fm.get("name") or sk.parent.name,
                "folder": sk.parent.name,
                "path": str(sk.parent.relative_to(REPO)),
                "description": fm.get("description", ""),
            })
        plugins.append({
            "name": meta.get("name", pdir.name),
            "dir": pdir.name,
            "version": meta.get("version", "1.0.0"),
            "description": meta.get("description", ""),
            "author": meta.get("author", OWNER),
            "category": CATEGORY_OF.get(pdir.name, "other"),
            "skills": skills,
        })
    builtin = save_restricted()
    return {"total_skills": sum(len(p["skills"]) for p in plugins), "plugins": plugins,
            "builtin_only": builtin}


def write_marketplace(cat: dict):
    mp = {
        "name": MARKETPLACE_NAME,
        "owner": OWNER,
        "metadata": {"description": "Every Claude skill I use, in one marketplace.", "version": "1.0.0"},
        "plugins": [{
            "name": p["name"],
            "source": f"./plugins/{p['dir']}",
            "description": p["description"][:300],
            "version": p["version"],
            "author": p["author"] if isinstance(p["author"], dict) else OWNER,
            "category": p["category"],
        } for p in cat["plugins"]],
    }
    path = REPO / ".claude-plugin" / "marketplace.json"
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(mp, indent=2, ensure_ascii=False) + "\n")


def short(s: str, n=140) -> str:
    s = re.sub(r"\s+", " ", s).replace("|", "\\|")
    return s if len(s) <= n else s[: n - 1].rstrip() + "…"


def write_catalog_md(cat: dict):
    lines = [
        "# Skills Catalog",
        "",
        "> Auto-generated by `scripts/sync_skills.py` — do not edit by hand.",
        "",
        f"**{cat['total_skills']} skills** in **{len(cat['plugins'])} plugins**.",
        "",
        "| Plugin | Category | Skills |",
        "|---|---|---|",
    ]
    for p in cat["plugins"]:
        lines.append(f"| [`{p['name']}`](#{p['name']}) | {p['category']} | {len(p['skills'])} |")
    for p in cat["plugins"]:
        lines += ["", f"## {p['name']}", "", short(p["description"], 400), "",
                  f"Install: `/plugin install {p['name']}@{MARKETPLACE_NAME}`", "",
                  "| Skill | Description |", "|---|---|"]
        for s in p["skills"]:
            lines.append(f"| [`{s['name']}`]({s['path']}/SKILL.md) | {short(s['description'])} |")
    if cat.get("builtin_only"):
        lines += ["", "## Built into Claude (not redistributable)", "",
                  "Their license forbids copying them outside Claude, so only their names are listed.",
                  "Everyone with Claude already has them.", "", "| Skill | Description |", "|---|---|"]
        for k, v in cat["builtin_only"].items():
            lines.append(f"| `{v['name']}` | {short(v['description'])} |")
    (REPO / "CATALOG.md").write_text("\n".join(lines) + "\n")
    (REPO / "catalog.json").write_text(json.dumps(cat, indent=2, ensure_ascii=False) + "\n")


# ---------------------------------------------------------------- git
def git(*args, check=True) -> str:
    r = subprocess.run(["git", "-C", str(REPO), *args], capture_output=True, text=True)
    if check and r.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)}: {r.stderr.strip()}")
    return r.stdout.strip()


def commit_and_push(changes: list, push: bool):
    git("add", "-A")
    if not git("status", "--porcelain"):
        log("Nothing new — repo already up to date.")
        return
    added = [c[1] for c in changes if c[0] == "added"]
    updated = [c[1] for c in changes if c[0] == "updated"]
    title = (f"sync: add {len(added)}, update {len(updated)} skill(s)"
             if changes else "sync: regenerate catalog")
    body = "\n".join([*(f"+ {a}" for a in added), *(f"~ {u}" for u in updated)])
    host = os.uname().nodename if hasattr(os, "uname") else "unknown"
    msg = f"{title}\n\nfrom {host} at {dt.datetime.now().isoformat(timespec='seconds')}\n\n{body}".strip()
    git("commit", "-q", "-m", msg)
    log(f"Committed: {title}")
    if push:
        branch = git("rev-parse", "--abbrev-ref", "HEAD")
        git("pull", "-q", "--rebase", "origin", branch, check=False)
        git("push", "-q", "-u", "origin", branch)
        log(f"Pushed to origin/{branch}")


def main():
    global log_quiet
    ap = argparse.ArgumentParser()
    ap.add_argument("--push", action="store_true", help="commit and push when something changed")
    ap.add_argument("--commit", action="store_true", help="commit (no push)")
    ap.add_argument("--quiet", action="store_true")
    a = ap.parse_args()
    log_quiet = a.quiet

    if a.push:  # start from the latest remote so machines don't fight
        git("pull", "-q", "--rebase", "--autostash", check=False)

    changes = collect_all()
    for kind, label in changes:
        log(f"  {kind:8} {label}")
    cat = build_catalog()
    write_marketplace(cat)
    write_catalog_md(cat)
    log(f"Total: {cat['total_skills']} skills in {len(cat['plugins'])} plugins.")
    if a.push or a.commit:
        try:
            commit_and_push(changes, a.push)
        except RuntimeError as e:
            print(f"[claude-skills] {e}", file=sys.stderr)
            sys.exit(1)


if __name__ == "__main__":
    main()
