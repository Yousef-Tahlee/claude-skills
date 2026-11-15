# claude-skills
#

Every Claude skill I use, collected in one place and packaged as a **Claude Code plugin marketplace**.
It is kept in sync automatically from all my machines and my claude.ai account.

> **110 skills.** 103 downloadable in 11 plugins, plus 7 built into Claude.
> 📘 **[SKILLS-GUIDE.md](SKILLS-GUIDE.md)**: every skill with a short Arabic description and a direct download link.
> Technical index: [CATALOG.md](CATALOG.md). Both files are generated automatically.

---

## العربي — باختصار

- كل الـ skills يلي عندي (من حساب claude.ai، من البلَغنز، ومن `~/.claude/skills` على أي جهاز) موجودة هون ومقسّمة لـ plugins حسب المجال.
- **لصاحبي / أي جهاز جديد:** جوّا Claude Code بتكتب:
  ```
  /plugin marketplace add Yousef-Tahlee/claude-skills
  ```
  وبعدها بتنزّل يلي بدك ياه، مثلاً:
  ```
  /plugin install engineering@claude-skills
  /plugin install my-skills@claude-skills
  ```
  أو بتنزّلهم كلهم كملفات: `bash scripts/install.sh`
- **لـ claude.ai أو تطبيق الديسكتوب:** نزّل ملف الـ zip تبع الـ skill من [SKILLS-GUIDE.md](SKILLS-GUIDE.md) وارفعه من Settings ← Capabilities ← Skills.
- **التزامن التلقائي:** على كل جهاز شغّل مرة وحدة بس:
  ```
  bash setup/install-auto-sync.sh
  ```
  بعدها كل ما تفتح Claude Code بيرفع لحاله أي skill جديدة، وClaude عنده تعليمات دائمة يرفع أي skill بتضيفها.

---

## Layout

```
claude-skills/
├── .claude-plugin/marketplace.json   # marketplace manifest (generated)
├── plugins/
│   ├── my-skills/          personal  – my claude.ai account skills + ~/.claude/skills
│   ├── engineering/        engineering – code review, architecture, incidents, standups…
│   ├── data/               data – SQL, analysis, dashboards, visualization
│   ├── design/             design – critique, design system, UX copy, a11y
│   ├── marketing/          marketing – content, campaigns, SEO, email
│   ├── brand-voice/        marketing – brand discovery & guideline enforcement
│   ├── zapier/             automation – Zapier MCP onboarding & actions
│   ├── cowork-plugin-management/  tooling – build/customize plugins
│   ├── document-skills/    documents – docx, pdf, pptx, xlsx, file reading
│   ├── example-skills/     examples – skill-creator, mcp-builder, canvas-design…
│   └── system-tools/       tooling – playwright, desktop computer use
│       └── <plugin>/
│           ├── .claude-plugin/plugin.json
│           └── skills/<skill>/SKILL.md (+ scripts, references, assets)
├── scripts/
│   ├── sync_skills.py      # collect every skill on this machine → repo, regenerate catalog, push
│   ├── install.sh          # copy all skills into ~/.claude/skills
│   ├── build_zips.py       # one zip per skill → downloads/ (direct download links)
│   ├── build_guide.py      # SKILLS-GUIDE.md (Arabic descriptions from config/descriptions-ar.json)
│   └── validate.py         # front-matter + catalog checks (run in CI)
├── setup/
│   ├── install-auto-sync.sh  # one-time per machine: hook + CLAUDE.md standing instruction
│   └── CLAUDE.global.md      # the standing instruction text
├── config/extra-sources.txt  # extra folders to scan for skills
├── CATALOG.md / catalog.json # generated index
└── .github/workflows/validate.yml
```

## How sync works

`scripts/sync_skills.py` scans:

| Source | Goes to |
|---|---|
| `~/.claude/skills/*` and `~/.claude/skills/synced/*/*` (claude.ai account skills) | `plugins/my-skills/skills/` |
| `~/.claude/plugins/synced/*/*` (claude.ai plugins) | `plugins/<plugin-name>/` |
| `~/.claude/plugins/cache/*/*/*` (Claude Code `/plugin install`) | `plugins/<plugin-name>/` |
| `/mnt/skills/public`, `/mnt/skills/examples` (built-in) | `document-skills`, `example-skills` |
| paths in `config/extra-sources.txt` | `system-tools` |

Rules:
- **Add or update only, never delete.** The repo holds every skill from every machine.
- Content-compared: unchanged skills produce no commit.
- Runs `git pull --rebase` before pushing, so two machines don't collide.

```bash
python3 scripts/sync_skills.py          # dry: collect + regenerate
python3 scripts/sync_skills.py --push   # collect + commit + push
```

## Automatic upload of new skills

`setup/install-auto-sync.sh`, run once per machine:
1. clones the repo to `~/claude-skills`
2. adds a `SessionStart` hook in `~/.claude/settings.json`, which runs the sync in the background at the start of every Claude Code session
3. appends a standing instruction to `~/.claude/CLAUDE.md`: whenever a skill is added, Claude runs the sync and pushes it itself.

## Notes

- Third-party and Anthropic skills keep their original `LICENSE` files inside their folders.
  Keep this repo **private** unless you've checked each license allows redistribution.
- `.in_use`, caches, `.env` and credential files are never copied.
