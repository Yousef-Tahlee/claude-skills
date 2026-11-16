# upload-big-files.ps1  -  Upload every file listed in BIG-FILES.md to GitHub Releases of Yousef-Tahlee/Claude-archive.
#   powershell -NoProfile -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/Yousef-Tahlee/claude-skills/main/tools/upload-big-files.ps1 | iex"
# Releases accept files up to 2 GB each, with no total quota (unlike Git LFS's 1 GB). Private repo => private files.
# Files over 1.9 GB are split into .partNN pieces (rebuild with:  copy /b name.part01+name.part02 name ).
# Want only some files? Open BIG-FILES.md in Notepad, delete the lines you don't want, save, then run this.
$ErrorActionPreference = "Continue"
function Say($m, $c = "Cyan") { Write-Host $m -ForegroundColor $c }
$Repo = "Yousef-Tahlee/Claude-archive"
$pc   = "$env:COMPUTERNAME-$env:USERNAME"

# ---- find BIG-FILES.md (made by backup-all.ps1) ----
$list = Get-ChildItem (Join-Path $env:USERPROFILE "claude-archive-backup\devices") -Recurse -Filter BIG-FILES.md -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $list) { Say "BIG-FILES.md not found. Run backup-all.ps1 first." Red; Read-Host "Enter to close"; return }
Say "Using $($list.FullName)"
$paths = Get-Content $list.FullName -Encoding UTF8 | Where-Object { $_ -match '^\s*[\d,\.]+ MB\s{2}(.+)$' } | ForEach-Object { $matches[1].Trim() } |
         Where-Object { Test-Path -LiteralPath $_ } | Select-Object -Unique
Say "$($paths.Count) file(s) to upload." Green
if (-not $paths) { Read-Host "Enter to close"; return }

# ---- GitHub CLI ----
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  Say "Installing GitHub CLI..." Yellow
  winget install --id GitHub.cli -e --silent --accept-source-agreements --accept-package-agreements
  $env:Path = [Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [Environment]::GetEnvironmentVariable("Path","User")
}
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) { Say "Install https://cli.github.com then run again." Red; return }
gh auth status 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { Say "A browser window opens: sign in as Yousef-Tahlee." Yellow; gh auth login --hostname github.com --git-protocol https --web }

# ---- one release per computer ----
$tag = "big-files-" + ($pc -replace '[^A-Za-z0-9\-]','-')
gh release view $tag -R $Repo 2>$null | Out-Null
if ($LASTEXITCODE -ne 0) { gh release create $tag -R $Repo --title "Big files from $pc" --notes "Files > 25 MB from $pc. See MAP.txt for original paths." | Out-Null }
$existing = (gh release view $tag -R $Repo --json assets --jq ".assets[].name" 2>$null) -split "`n"

$tmp = Join-Path $env:TEMP "bigfiles-split"; New-Item -ItemType Directory -Force $tmp | Out-Null
$map = @(); $i = 0; $failed = @()
foreach ($p in $paths) {
  $i++
  $f = Get-Item -LiteralPath $p
  $base = ("{0:D3}-{1}" -f $i, ($f.Name -replace '[^A-Za-z0-9\.\-_]','_'))
  $map += "$base`t$p"
  $parts = @()
  if ($f.Length -gt 1.9GB) {
    Say "Splitting $($f.Name) ($([math]::Round($f.Length/1GB,2)) GB)..." Yellow
    $in = [IO.File]::OpenRead($f.FullName); $buf = New-Object byte[] (64MB); $n = 0
    while ($in.Position -lt $in.Length) {
      $n++; $pp = Join-Path $tmp ("$base.part{0:D2}" -f $n); $out = [IO.File]::Create($pp); $w = 0
      while ($w -lt 1.9GB -and ($r = $in.Read($buf, 0, $buf.Length)) -gt 0) { $out.Write($buf, 0, $r); $w += $r }
      $out.Close(); $parts += $pp
    }
    $in.Close()
  } else {
    $pp = Join-Path $tmp $base
    if (-not ($existing -contains $base)) { Copy-Item -LiteralPath $f.FullName $pp -Force }
    $parts += $pp
  }
  foreach ($part in $parts) {
    $name = Split-Path $part -Leaf
    if ($existing -contains $name) { Say "[skip] $name (already uploaded)" DarkGray; continue }
    Say "[$i/$($paths.Count)] uploading $name ..."
    gh release upload $tag $part -R $Repo --clobber
    if ($LASTEXITCODE -ne 0) { $failed += $p } else { Say "  ok" Green }
    Remove-Item $part -Force -ErrorAction SilentlyContinue
  }
}
$mapFile = Join-Path $tmp "MAP.txt"
("asset-name`toriginal-path`n" + ($map -join "`n")) | Set-Content $mapFile -Encoding UTF8
gh release upload $tag $mapFile -R $Repo --clobber | Out-Null

$count = (gh release view $tag -R $Repo --json assets --jq ".assets | length")
Say "`nRelease: https://github.com/$Repo/releases/tag/$tag  ($count assets incl. MAP.txt)" Cyan
if ($failed) { Say "Failed (run again to retry, done files are skipped): `n$($failed -join "`n")" Red } else { Say "All big files uploaded." Green }
Read-Host "Press Enter to close"
