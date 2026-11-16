# backup-all.ps1  -  ONE command: upload EVERYTHING from this Windows PC into the private repo Yousef-Tahlee/Claude-archive.
#   Works from CMD or PowerShell:
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Yousef-Tahlee/claude-skills/main/tools/backup-all.ps1 | iex"
# Nothing is redacted (.env and secrets included) -> the target repo MUST stay PRIVATE.
# Uploads: ~/.claude (all local Claude Code chats, skills, settings), ~/.claude.json, Claude desktop config,
#          ~/.n8n (n8n database + encryption key) + n8n workflow export, every folder Claude Code worked in,
#          plus any extra folders you type (REVO brand, Remotion, n8n projects, website...).
# Skipped only: node_modules, .venv/venv, __pycache__, .next/cache (re-installable, often GBs).
# Each project's own .git history is saved as a .bundle file (full history, restorable).
# Files > 95 MB go through Git LFS (GitHub refuses > 100 MB without it).

$ErrorActionPreference = "Continue"
$Repo = "https://github.com/Yousef-Tahlee/Claude-archive.git"
function Say($m, $c = "Cyan") { Write-Host $m -ForegroundColor $c }

# ---- 0. Git + Git LFS -------------------------------------------------------
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Say "Installing Git..." Yellow
  winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements
  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}
if (-not (Get-Command git -ErrorAction SilentlyContinue)) { Say "Git is missing. Install https://git-scm.com/download/win then run again." Red; return }
git lfs install 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { winget install --id GitHub.GitLFS -e --silent --accept-source-agreements --accept-package-agreements; git lfs install | Out-Null }

$pc   = "$env:COMPUTERNAME-$env:USERNAME"
$work = Join-Path $env:USERPROFILE "claude-archive-backup"
Say "`n=== Full backup of $pc -> Claude-archive/devices/$pc ===`n"
$extra = $env:BACKUP_EXTRA   # optional; folders are discovered automatically (see step 5)

# ---- 1. Clone the archive repo (GitHub login window may open: sign in as Yousef-Tahlee) ----
git config --global core.longpaths true 2>$null
if (Test-Path $work) { Say "Cleaning previous attempt..." Yellow; cmd /c "rmdir /s /q `"$work`"" }
git -c core.longpaths=true clone --depth 1 $Repo $work
if (-not (Test-Path (Join-Path $work ".git"))) { Say "Could not clone. Sign in to GitHub with an account that has access to Claude-archive." Red; return }
$dst = Join-Path $work "devices\$pc"
New-Item -ItemType Directory -Force $dst | Out-Null
$XD = @("node_modules",".venv","venv","__pycache__",".git",".next","dist-electron","Cache","Code Cache","GPUCache")
$MaxBytes = 25MB   # GitHub free: no LFS needed, repo stays pushable. Bigger files go to BIG-FILES.md (copy them to Google Drive)
$big = New-Object System.Collections.ArrayList
function Copy-Tree($src, $to) {
  if (-not (Test-Path $src)) { return $false }
  robocopy $src $to /E /R:1 /W:1 /XD $XD /XJ /MAX:$MaxBytes /NFL /NDL /NJH /NJS /NP | Out-Null
  Get-ChildItem $src -Recurse -File -Force -ErrorAction SilentlyContinue | Where-Object { $_.Length -gt $MaxBytes -and $_.FullName -notmatch "\\(node_modules|\.git|\.venv)\\" } |
    ForEach-Object { [void]$big.Add(("{0,9:N0} MB  {1}" -f ($_.Length/1MB), $_.FullName)) }
  # keep each nested git repo's full history as a bundle
  Get-ChildItem $src -Directory -Recurse -Force -Filter ".git" -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch "node_modules" } | ForEach-Object {
      $repoDir = $_.Parent.FullName
      $rel = $repoDir.Substring($src.Length).Trim("\") -replace "[\\/:]","_"; if (-not $rel) { $rel = "root" }
      $bdir = Join-Path $to "_git-bundles"; New-Item -ItemType Directory -Force $bdir | Out-Null
      git -C $repoDir bundle create (Join-Path $bdir "$rel.bundle") --all 2>$null | Out-Null
    }
  return $true
}
function Safe($p) { ($p -replace '[:\\/ ]','_').Trim('_') }

# ---- 2. Claude Code ---------------------------------------------------------
$cc = Join-Path $env:USERPROFILE ".claude"
if (Copy-Tree $cc (Join-Path $dst "claude-code\dot-claude")) { Say "[ok] ~/.claude" Green }
$cj = Join-Path $env:USERPROFILE ".claude.json"; if (Test-Path $cj) { Copy-Item $cj (Join-Path $dst "claude-code\claude.json") -Force }

# ---- 3. Claude desktop app (config, extensions, local storage; no caches) ----
$cd = Join-Path $env:APPDATA "Claude"
if (Test-Path $cd) {
  robocopy $cd (Join-Path $dst "claude-desktop") /E /R:1 /W:1 /XD Cache "Code Cache" GPUCache DawnCache DawnGraphiteCache Crashpad blob_storage "Service Worker" logs /NFL /NDL /NJH /NJS /NP | Out-Null
  Say "[ok] Claude desktop" Green
}

# ---- 4. n8n (local install / desktop / docker volume copy) --------------------
$n8n = Join-Path $env:USERPROFILE ".n8n"
if (Copy-Tree $n8n (Join-Path $dst "n8n\dot-n8n")) { Say "[ok] ~/.n8n (database + config/encryption key)" Green }
if (Get-Command n8n -ErrorAction SilentlyContinue) {
  $wf = Join-Path $dst "n8n\export"; New-Item -ItemType Directory -Force $wf | Out-Null
  n8n export:workflow --all --separate --output="$wf\workflows" 2>$null | Out-Null
  n8n export:credentials --all --decrypted --separate --output="$wf\credentials" 2>$null | Out-Null
  Say "[ok] n8n workflows + credentials exported" Green
}
if (Get-Command docker -ErrorAction SilentlyContinue) {
  $cont = docker ps --format "{{.Names}} {{.Image}}" 2>$null | Where-Object { $_ -match "n8n" } | ForEach-Object { ($_ -split " ")[0] }
  foreach ($c in $cont) {
    $wf = Join-Path $dst "n8n\docker-$c"; New-Item -ItemType Directory -Force $wf | Out-Null
    docker exec $c n8n export:workflow --all --output=/tmp/wf.json 2>$null | Out-Null; docker cp "${c}:/tmp/wf.json" "$wf\workflows.json" 2>$null
    docker exec $c n8n export:credentials --all --decrypted --output=/tmp/cr.json 2>$null | Out-Null; docker cp "${c}:/tmp/cr.json" "$wf\credentials.json" 2>$null
    Say "[ok] n8n docker container $c exported" Green
  }
}

# ---- 5. Every folder Claude Code worked in + extra folders ------------------
$paths = @{}
Get-ChildItem (Join-Path $cc "projects") -Recurse -Filter *.jsonl -ErrorAction SilentlyContinue | ForEach-Object {
  Get-Content $_.FullName -TotalCount 60 | ForEach-Object { if ($_ -match '"cwd"\s*:\s*"([^"]+)"') { $paths[($matches[1] -replace '\\\\','\')] = 1 } }
}
if ($extra) { $extra.Split(";") | ForEach-Object { $p = $_.Trim().Trim('"'); if ($p) { $paths[$p] = 1 } } }

# Auto-discover every project folder on this PC (no need to know names):
# a folder is a project if it holds code/config/design work, or its name says revo / rekicks / n8n / remotion / claude.
Say "Searching this PC for project folders (Desktop, Documents, Downloads, user folder, all extra drives)..."
$markers = @(".git","package.json","docker-compose.yml","compose.yaml","requirements.txt","pyproject.toml",".env","CLAUDE.md",
             "remotion.config.ts","remotion.config.js","manage.py","next.config.js","next.config.ts","index.html","Makefile")
$markExt = @(".blend",".n8n",".prproj",".drp",".aep",".psd",".fig",".ai",".sketch")
$nameRx  = "(?i)revo|rekick|n8n|remotion|claude|automation|landing|brand|workflow"
$skipRx  = '(?i)\\(Windows|Program Files|Program Files \(x86\)|ProgramData|AppData|\$Recycle\.Bin|System Volume Information|node_modules|\.vscode|\.cursor|\.npm|\.nuget|\.cache|Recovery|PerfLogs|MSOCache|Intel|AMD|NVIDIA|Steam|SteamLibrary|Epic Games|Games|Adobe|Microsoft|Common Files|drivers|claude-archive-backup)(\\|$)'
$userRoots = @("Desktop","Documents","Downloads","source","Projects","OneDrive","Pictures","Videos","Music") | ForEach-Object { (Join-Path $env:USERPROFILE $_).ToLower() }
$roots = @()
foreach ($u in "Desktop","Documents","Downloads","source","Projects","OneDrive") { $roots += (Join-Path $env:USERPROFILE $u) }
$roots += $env:USERPROFILE
Get-PSDrive -PSProvider FileSystem | Where-Object { $_.Root -ne "$env:SystemDrive\" -and $_.Used -gt 0 } | ForEach-Object { $roots += $_.Root }
function Find-Projects($dir, $depth) {
  if ($depth -gt 4 -or $dir -match $skipRx) { return }
  $items = Get-ChildItem $dir -Force -ErrorAction SilentlyContinue
  $isProj = ($depth -ge 1) -and ($dir -ne $env:USERPROFILE) -and ($dir.Length -gt 3) -and ($userRoots -notcontains $dir.ToLower()) -and (
            ($items | Where-Object { $markers -contains $_.Name -or $markExt -contains $_.Extension.ToLower() }) -or
            ((Split-Path $dir -Leaf) -match $nameRx -and $depth -ge 1))
  if ($isProj) { $paths[$dir] = 1; return }
  foreach ($d in ($items | Where-Object { $_.PSIsContainer -and -not $_.Name.StartsWith(".") })) { Find-Projects $d.FullName ($depth + 1) }
}
foreach ($r in ($roots | Select-Object -Unique)) { if (Test-Path $r) { Find-Projects $r 0 } }
Say "Found $($paths.Count) folder(s)."
$copied = @()
foreach ($p in $paths.Keys) {
  if (-not (Test-Path $p) -or $p -eq $env:USERPROFILE -or $p.Length -le 3) { continue }
  if ($p -match $skipRx -or $userRoots -contains $p.ToLower()) { continue }
  if (Copy-Tree $p (Join-Path $dst ("folders\" + (Safe $p)))) { $copied += $p; Say "[ok] $p" Green }
}

# ---- 6. Manifest -------------------------------------------------------------
$files = Get-ChildItem $dst -Recurse -File -Force
$size  = "{0:N1} MB" -f (($files | Measure-Object Length -Sum).Sum / 1MB)
@"
# Full device backup: $pc
- Date: $(Get-Date -Format "yyyy-MM-dd HH:mm") · Files: $($files.Count) · Size: $size
- NOT redacted: contains .env files and secrets. Keep this repository PRIVATE.
- claude-code/dot-claude/projects/**/*.jsonl = every local Claude Code conversation
- n8n/ = n8n database, config (encryption key) and exported workflows/credentials (if n8n was found)
- folders/ = project folders (node_modules / venv skipped; each .git saved as folders/*/_git-bundles/*.bundle)
## Folders
$(($copied | ForEach-Object { "- ``$_``" }) -join "`n")
"@ | Set-Content (Join-Path $dst "MANIFEST.md") -Encoding UTF8

# ---- 7. Large files -> LFS, then commit & push in parts ---------------------
Push-Location $work
$bigTotal = 0; $big | ForEach-Object { $bigTotal += [double](($_ -split "MB")[0].Trim() -replace ",","") }
@"
# Big files NOT uploaded to GitHub (> 25 MB each): copy these to Google Drive / external disk
Total: $("{0:N0}" -f $bigTotal) MB in $($big.Count) files

``````
$($big -join "`n")
``````
"@ | Set-Content (Join-Path $dst "BIG-FILES.md") -Encoding UTF8
Say "$($big.Count) big files (> 25 MB, total $("{0:N0}" -f $bigTotal) MB) listed in BIG-FILES.md - copy them to Google Drive." Yellow
git config core.longpaths true          # Windows: allow paths > 260 chars (Claude chats have long names)
git config core.autocrlf false
git add .gitattributes 2>$null
git config user.name  "$env:USERNAME"
git config user.email "Yousef-Tahlee@users.noreply.github.com"
git config http.postBuffer 524288000
$failed = @()
foreach ($part in Get-ChildItem $dst -Force) {
  Say "Adding $($part.Name) ..."
  git add --ignore-errors -A -- "$($part.FullName)" 2>&1 | Select-String -Pattern "error|fatal|warning: could not" | Select-Object -First 5 | Out-Host
  git commit -q -m "Backup $pc : $($part.Name)" 2>$null
  # the other PC may push at the same time: get its commits, then push again (each PC writes its own folder, no conflicts)
  $ok = $false
  for ($i = 1; $i -le 6 -and -not $ok; $i++) {
    git push -q origin HEAD:main 2>$null
    if ($LASTEXITCODE -eq 0) { $ok = $true; Say "  pushed $($part.Name)" Green }
    else { Say "  other PC pushed meanwhile, syncing (try $i)..." Yellow
           git fetch -q --depth=1 origin main 2>$null; git rebase -q origin/main 2>$null
           if ($LASTEXITCODE -ne 0) { git rebase --abort 2>$null; git pull -q --rebase -X theirs origin main 2>$null }
           Start-Sleep -Seconds (3 * $i) }
  }
  if (-not $ok) { $failed += $part.Name }
}
git fetch -q --depth=1 origin main 2>$null
$onGit = (git ls-tree -r --name-only origin/main -- "devices/$pc" 2>$null | Measure-Object).Count
$local = (Get-ChildItem $dst -Recurse -File -Force | Measure-Object).Count
Say "Check: $onGit of $local files are on GitHub." Yellow
Pop-Location
if ($onGit -lt $local) { $failed += "some files ($($local - $onGit) missing) - run the same command again" }
if ($failed.Count) {
  Say "`nSome parts did not push: $($failed -join ', ')" Red
  Say "They are committed locally in $work. Run 'git -C `"$work`" push' again later, or zip that folder to Google Drive." Yellow
} else { Say "`nDONE: everything from $pc is in Claude-archive/devices/$pc ($size)" Green }
Read-Host "Press Enter to close"
