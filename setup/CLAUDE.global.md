<!-- claude-skills:begin -->
## Skills repo auto-sync (Yousef-Tahlee/claude-skills)

All my Claude skills live in the GitHub repo `Yousef-Tahlee/claude-skills` (local clone: `~/claude-skills`).

**Standing task, in every conversation:** whenever I add, create, install, upload or edit a skill
(a `SKILL.md`, `/plugin install`, `npx skills add`, a skill uploaded on claude.ai, or one you made with
skill-creator), you must upload it to that repo yourself without being asked:

1. `cd ~/claude-skills` (clone `https://github.com/Yousef-Tahlee/claude-skills` there if it is missing)
2. `python3 scripts/sync_skills.py --push`
3. Tell me in one line which skills were added or updated.

If the skill lives somewhere the script does not scan, add that folder to
`config/extra-sources.txt` first, then run step 2. Never delete skills from the repo.
<!-- claude-skills:end -->
