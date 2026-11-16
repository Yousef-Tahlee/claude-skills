# upload-export.ps1  -  Put the claude.ai "Export data" files into Claude-archive/claude-ai-export and push.
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Yousef-Tahlee/claude-skills/main/tools/upload-export.ps1 | iex"
# Before running: open each export link in the browser (logged in to claude.ai) so the 6 zips land in Downloads:
#   light_metadata-000.zip projects-000.zip memories-000.zip frames-000.zip claude_code_cloud-000.zip conversations-000.zip
$ErrorActionPreference = "Continue"
function Say($m, $c = "Cyan") { Write-Host $m -ForegroundColor $c }
$names = "light_metadata","projects","memories","frames","claude_code_cloud","conversations"
$dl = Join-Path $env:USERPROFILE "Downloads"
$zips = Get-ChildItem $dl -Filter "*.zip" | Where-Object { $n = $_.BaseName; $names | Where-Object { $n -like "$_*" } }
if (-not $zips) { Say "No export zips found in $dl. Download them from the links first." Red; Read-Host "Enter to close"; return }
Say "Found: $($zips.Name -join ', ')" Green

git config --global core.longpaths true 2>$null
$work = Join-Path $env:USERPROFILE "claude-archive-backup"
if (Test-Path (Join-Path $work ".git")) { git -C $work pull --rebase --autostash } else { git clone --depth 1 https://github.com/Yousef-Tahlee/Claude-archive.git $work }
$dst = Join-Path $work "claude-ai-export"
foreach ($z in $zips) {
  $cat = ($names | Where-Object { $z.BaseName -like "$_*" } | Select-Object -First 1)
  $to = Join-Path $dst "$cat\$($z.BaseName)"
  New-Item -ItemType Directory -Force $to | Out-Null
  Expand-Archive -Path $z.FullName -DestinationPath $to -Force
  Say "[ok] $($z.Name) -> claude-ai-export/$cat" Green
}
Push-Location $work
git lfs install 2>$null | Out-Null
Get-ChildItem $dst -Recurse -File | Where-Object { $_.Length -gt 95MB } | ForEach-Object {
  $rel = $_.FullName.Substring($work.Length + 1) -replace "\\","/"; git lfs track "$rel" | Out-Null }
git config core.longpaths true
git config user.email "Yousef-Tahlee@users.noreply.github.com"
git add -A -- claude-ai-export .gitattributes
git commit -q -m "claude.ai data export ($((Get-Date).ToString('yyyy-MM-dd')))"
git push origin HEAD
$onGit = (git ls-tree -r --name-only origin/HEAD -- claude-ai-export | Measure-Object).Count
$local = (Get-ChildItem $dst -Recurse -File | Measure-Object).Count
Pop-Location
Say "Check: $onGit of $local files are on GitHub." Yellow
Read-Host "Press Enter to close"
