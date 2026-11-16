# restore.ps1  -  Restore Yousef's Claude workspace on a new Windows computer / new account. No Claude needed.
#   irm https://raw.githubusercontent.com/Yousef-Tahlee/claude-skills/main/tools/restore.ps1 | iex
# Needs Git (https://git-scm.com). The private archive asks you to sign in to GitHub once.
$ErrorActionPreference = "Continue"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Write-Host "Install Git first: https://git-scm.com/download/win" -ForegroundColor Red; return }
$ws = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "claude-workspace"
New-Item -ItemType Directory -Force $ws | Out-Null
foreach ($r in "claude-skills","Claude-archive") {
  $d = Join-Path $ws $r
  if (Test-Path (Join-Path $d ".git")) { git -C $d pull } else { git clone "https://github.com/Yousef-Tahlee/$r.git" $d }
}
# Install every skill (public library + private archive skills) into ~/.claude/skills
$skills = Join-Path $env:USERPROFILE ".claude\skills"; New-Item -ItemType Directory -Force $skills | Out-Null
$n = 0
Get-ChildItem (Join-Path $ws "claude-skills\plugins\*\skills\*"), (Join-Path $ws "Claude-archive\skills\*") -Directory -ErrorAction SilentlyContinue | ForEach-Object {
  if (Test-Path (Join-Path $_.FullName "SKILL.md")) {
    $dst = Join-Path $skills $_.Name
    if (Test-Path $dst) { $dst = Join-Path $skills ($_.Parent.Parent.Name + "-" + $_.Name) }
    Copy-Item $_.FullName $dst -Recurse -Force; $n++
  }
}
# Global CLAUDE.md pointing at the archive
$md = Join-Path $env:USERPROFILE ".claude\CLAUDE.md"
if (-not (Select-String -Path $md -Pattern "claude-archive:begin" -Quiet -ErrorAction SilentlyContinue)) {
@"

<!-- claude-archive:begin -->
## My workspace
Everything about me, my projects and how I work is in $ws\Claude-archive.
Before any task, read AI_CONTEXT.md there. Reply in Syrian Arabic. Explain first, then build step by step.
Treat client work as costly: stop and ask when anything is unclear. Keep progress in .md files inside the project repo.
<!-- claude-archive:end -->
"@ | Add-Content $md -Encoding UTF8
}
Write-Host "`nDone. Repos in $ws, $n skills installed, CLAUDE.md updated." -ForegroundColor Green
Write-Host "Next: open Claude Code in $ws\Claude-archive and paste the prompt from START-HERE.md" -ForegroundColor Cyan
