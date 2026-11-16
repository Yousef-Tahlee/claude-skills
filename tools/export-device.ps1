# export-device.ps1  -  Export everything Claude-related from THIS Windows computer.
# No Claude needed. Run in PowerShell:
#   irm https://raw.githubusercontent.com/Yousef-Tahlee/claude-skills/main/tools/export-device.ps1 | iex
#
# What it collects (into Desktop\claude-device-export\<COMPUTERNAME>\ and a .zip next to it):
#   1. claude-code\     ~/.claude: every local Claude Code conversation (projects\*.jsonl), skills, agents,
#                       commands, settings, CLAUDE.md, plugins list, plus ~/.claude.json (MCP servers)
#   2. claude-desktop\  Claude desktop app config (MCP servers) from %APPDATA%\Claude
#   3. project-folders\ every folder Claude Code ever worked in (read from the conversations' "cwd"),
#                       without node_modules / .git / build output / .env files / files > 50 MB
#   4. MANIFEST.md      what was found, folder sizes, and the list of projects
# Secrets (tokens, API keys, JWTs, passwords) are replaced by [REDACTED] in every text file.
# Optional at the end: push the result into the private repo Yousef-Tahlee/claude-archive (needs Git).

$ErrorActionPreference = "SilentlyContinue"
$name  = $env:COMPUTERNAME
$root  = Join-Path ([Environment]::GetFolderPath("Desktop")) "claude-device-export"
$out   = Join-Path $root $name
$home_ = $env:USERPROFILE
New-Item -ItemType Directory -Force $out | Out-Null
Write-Host "`n== Exporting Claude data from $name to $out ==`n" -ForegroundColor Cyan

# ---------- 1. Claude Code (~/.claude) ----------
$cc = Join-Path $home_ ".claude"
$ccOut = Join-Path $out "claude-code"
if (Test-Path $cc) {
  foreach ($d in "projects","skills","agents","commands","plugins","todos") {
    $src = Join-Path $cc $d
    if (Test-Path $src) {
      robocopy $src (Join-Path $ccOut $d) /E /XD cache marketplaces node_modules .git /MAX:52428800 /NFL /NDL /NJH /NJS /NP | Out-Null
    }
  }
  foreach ($f in "settings.json","settings.local.json","CLAUDE.md","keybindings.json") {
    $p = Join-Path $cc $f; if (Test-Path $p) { Copy-Item $p $ccOut -Force }
  }
  Write-Host "[1] Claude Code data copied" -ForegroundColor Green
} else { Write-Host "[1] No ~/.claude folder on this computer" -ForegroundColor Yellow }
$cj = Join-Path $home_ ".claude.json"; if (Test-Path $cj) { Copy-Item $cj (Join-Path $ccOut "claude.json") -Force }

# ---------- 2. Claude desktop app ----------
$cd = Join-Path $env:APPDATA "Claude"
if (Test-Path $cd) {
  $cdOut = Join-Path $out "claude-desktop"; New-Item -ItemType Directory -Force $cdOut | Out-Null
  Get-ChildItem $cd -File -Filter *.json | Copy-Item -Destination $cdOut -Force
  Write-Host "[2] Claude desktop config copied" -ForegroundColor Green
}

# ---------- 3. Project folders Claude worked in ----------
$cwds = @{}
Get-ChildItem (Join-Path $cc "projects") -Recurse -Filter *.jsonl | ForEach-Object {
  Get-Content $_.FullName -TotalCount 40 | ForEach-Object {
    if ($_ -match '"cwd"\s*:\s*"([^"]+)"') { $cwds[($matches[1] -replace '\\\\','\')] = 1 }
  }
}
$projOut = Join-Path $out "project-folders"
$projList = @()
foreach ($p in $cwds.Keys) {
  if (-not (Test-Path $p)) { continue }
  if ($p -eq $home_ -or $p.Length -le 3) { continue }             # never copy the whole home or a drive root
  $safe = ($p -replace '[:\\/ ]','_').Trim('_')
  robocopy $p (Join-Path $projOut $safe) /E /MAX:52428800 `
    /XD node_modules .git .next dist build out .venv venv __pycache__ .cache .turbo coverage `
    /XF .env .env.* *.pem *.key *.pfx id_rsa* *.sqlite *.db /NFL /NDL /NJH /NJS /NP | Out-Null
  $projList += $p
}
Write-Host "[3] $($projList.Count) project folder(s) copied" -ForegroundColor Green

# ---------- 4. Redact secrets in text files ----------
$patterns = @(
  @('eyJ[A-Za-z0-9_-]{10,}\.eyJ[A-Za-z0-9_-]{10,}\.[A-Za-z0-9_-]{10,}', '[REDACTED_JWT]'),
  @('sk-ant-[A-Za-z0-9_-]{20,}', '[REDACTED_ANTHROPIC_KEY]'),
  @('sk-(proj-)?[A-Za-z0-9]{32,}', '[REDACTED_OPENAI_KEY]'),
  @('gh[pousr]_[A-Za-z0-9]{30,}', '[REDACTED_GITHUB_TOKEN]'),
  @('github_pat_[A-Za-z0-9_]{40,}', '[REDACTED_GITHUB_TOKEN]'),
  @('AKIA[0-9A-Z]{16}', '[REDACTED_AWS_KEY]'),
  @('xox[abposr]-[A-Za-z0-9-]{10,}', '[REDACTED_SLACK_TOKEN]'),
  @('AIza[0-9A-Za-z_-]{35}', '[REDACTED_GOOGLE_KEY]'),
  @('\b\d{8,10}:AA[A-Za-z0-9_-]{30,}\b', '[REDACTED_TELEGRAM_TOKEN]'),
  @('(?i)("?(x-n8n-api-key|api[_-]?key|apikey|authorization|password|passwd|secret|token|access_token|refresh_token)"?\s*[:=]\s*"?)(Bearer\s+)?([A-Za-z0-9_\-\.]{16,})', '$1$3[REDACTED]')
)
$exts = ".json",".jsonl",".md",".txt",".js",".mjs",".cjs",".ts",".py",".ps1",".yml",".yaml",".toml",".ini",".html",".sql",".sh",".env"
$n = 0
Get-ChildItem $out -Recurse -File | Where-Object { $exts -contains $_.Extension.ToLower() -and $_.Length -lt 50MB } | ForEach-Object {
  $t = [IO.File]::ReadAllText($_.FullName); $o = $t
  foreach ($pp in $patterns) { $t = [regex]::Replace($t, $pp[0], $pp[1]) }
  if ($t -ne $o) { [IO.File]::WriteAllText($_.FullName, $t, (New-Object Text.UTF8Encoding $false)); $n++ }
}
Write-Host "[4] Secrets redacted in $n file(s)" -ForegroundColor Green

# ---------- 5. Manifest ----------
$sessions = (Get-ChildItem (Join-Path $ccOut "projects") -Recurse -Filter *.jsonl).Count
$size = "{0:N1} MB" -f ((Get-ChildItem $out -Recurse -File | Measure-Object Length -Sum).Sum / 1MB)
@"
# Device export: $name

- Exported: $(Get-Date -Format "yyyy-MM-dd HH:mm")
- User: $env:USERNAME
- Local Claude Code conversations: $sessions (claude-code/projects/**/*.jsonl, one file per session)
- Size: $size
- Secrets redacted in $n file(s). Excluded: node_modules, .git, build output, .env, keys, files > 50 MB.

## Project folders Claude worked in
$(($projList | ForEach-Object { "- ``$_``" }) -join "`n")
"@ | Set-Content (Join-Path $out "MANIFEST.md") -Encoding UTF8

$zip = "$out.zip"; Remove-Item $zip -Force
Compress-Archive -Path $out -DestinationPath $zip -Force
Write-Host "`nDONE: $out`nZIP : $zip  ($size)`n" -ForegroundColor Cyan

# ---------- 6. Optional: push into the private archive repo ----------
if (Get-Command git) {
  $ans = Read-Host "Push it now into github.com/Yousef-Tahlee/claude-archive under devices/$name ? (y/n)"
  if ($ans -eq "y") {
    $tmp = Join-Path $env:TEMP "claude-archive-push"
    Remove-Item $tmp -Recurse -Force
    git clone --depth 1 https://github.com/Yousef-Tahlee/claude-archive.git $tmp
    if (Test-Path $tmp) {
      $dst = Join-Path $tmp "devices\$name"
      robocopy $out $dst /E /NFL /NDL /NJH /NJS /NP | Out-Null
      Push-Location $tmp
      git add -A
      git -c user.name="$env:USERNAME" -c user.email="Yousef-Tahlee@users.noreply.github.com" commit -m "Device export: $name"
      git push origin HEAD
      Pop-Location
      Write-Host "Pushed to devices/$name" -ForegroundColor Green
    }
  }
} else {
  Write-Host "Git is not installed: send the ZIP to Yousef (Drive / WhatsApp / Telegram)." -ForegroundColor Yellow
}
Read-Host "Press Enter to close"
