#!/usr/bin/env python3
"""Build SKILLS-GUIDE.md: every skill, a short Syrian-Arabic description (config/descriptions-ar.json,
English fallback), a direct zip download link and a link to its files. Run by sync_skills.py."""
import json
import re
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
GH = "https://github.com/Yousef-Tahlee/claude-skills"
RAW = f"{GH}/raw/main"

TITLES = {
    "my-skills": "الـ skills الشخصية", "engineering": "برمجة وهندسة", "data": "داتا وتحليل",
    "design": "تصميم", "marketing": "تسويق", "brand-voice": "أسلوب البراند", "zapier": "Zapier وأتمتة",
    "cowork-plugin-management": "صناعة الـ plugins", "document-skills": "ملفات ومستندات",
    "example-skills": "skills متنوعة من Anthropic", "system-tools": "أدوات النظام",
}


def short(s, n=160):
    s = re.sub(r"\s+", " ", s).replace("|", "\\|")
    return s if len(s) <= n else s[: n - 1] + "…"


def main():
    cat = json.loads((REPO / "catalog.json").read_text())
    ar = json.loads((REPO / "config" / "descriptions-ar.json").read_text())
    missing = []

    def desc(key, en):
        if key in ar:
            return ar[key]
        missing.append(key)
        return short(en)

    total = cat["total_skills"] + len(cat.get("builtin_only", {}))
    L = [
        "# 🧰 دليل كل الـ skills",
        "",
        f"**{total} skill**: منها {cat['total_skills']} فيك تنزّلها، و{len(cat.get('builtin_only', {}))} مدمجين أصلاً بـ Claude.",
        "",
        "## كيف بتنزّل skill؟",
        "",
        "**1. على claude.ai أو تطبيق Claude (أسهل طريقة):**",
        "كبس على رابط **⬇️ تحميل** جنب الـ skill، بينزل ملف zip.",
        "بعدين افتح Claude ← **Settings ← Capabilities ← Skills ← Upload skill** وارفع الملف متل ما هو (لا تفكّه).",
        "",
        "**2. على Claude Code (الأفضل للمبرمجين):** اكتب جوّا Claude Code:",
        "```",
        "/plugin marketplace add Yousef-Tahlee/claude-skills",
        "```",
        "وبعدين نزّل المجموعة يلي بدك ياها، مثلاً:",
        "```",
        "/plugin install engineering@claude-skills",
        "```",
        "",
        "**3. كلهم مرة وحدة:** "
        f"[⬇️ all-skills.zip]({RAW}/downloads/all-skills.zip). فكّه وحط المجلدات بـ `~/.claude/skills/`.",
        "",
        "---",
        "",
        "## الفهرس",
        "",
    ]
    for p in cat["plugins"]:
        L.append(f"- **{TITLES.get(p['dir'], p['dir'])}** (`{p['dir']}`): {len(p['skills'])} skill")
    if cat.get("builtin_only"):
        L.append(f"- **مدمجة بـ Claude**: {len(cat['builtin_only'])} skill")

    n = 0
    for p in cat["plugins"]:
        L += ["", f"## {TITLES.get(p['dir'], p['dir'])} — `{p['dir']}`", "",
              f"على Claude Code: `/plugin install {p['name']}@claude-skills`", "",
              "| # | الـ skill | شو بتعمل | تحميل | الملفات |", "|---|---|---|---|---|"]
        for s in p["skills"]:
            n += 1
            key = f"{p['dir']}/{s['folder']}"
            L.append(f"| {n} | **{s['name']}** | {desc(key, s['description'])} | "
                     f"[⬇️ zip]({RAW}/downloads/{p['dir']}--{s['folder']}.zip) | "
                     f"[📂 فتح]({GH}/tree/main/{s['path']}) |")
    if cat.get("builtin_only"):
        L += ["", "## مدمجة بـ Claude — ما بدها تنزيل", "",
              "هدول موجودين أصلاً عند أي حدا عنده Claude. رخصتهن ما بتسمح ينسخوا برّا Claude، لهيك ما في رابط تحميل.", "",
              "| # | الـ skill | شو بتعمل |", "|---|---|---|"]
        for k, v in cat["builtin_only"].items():
            n += 1
            L.append(f"| {n} | **{v['name']}** | {desc('builtin/' + k, v['description'])} |")
    L += ["", "---", "", f"المجموع: **{n} skill**. هاد الملف بيتحدّث لحاله مع كل sync."]
    (REPO / "SKILLS-GUIDE.md").write_text("\n".join(L) + "\n")
    print(f"SKILLS-GUIDE.md: {n} skills" + (f", missing Arabic: {missing}" if missing else ""))


if __name__ == "__main__":
    main()
