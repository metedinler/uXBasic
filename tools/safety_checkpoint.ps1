param(
    [string]$SourceRoot = "C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo",
    [string]$BackupRoot = "C:/Users/mete/Backups",
    [int]$KeepSnapshots = 10
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $SourceRoot)) {
    throw "SourceRoot not found: $SourceRoot"
}

New-Item -ItemType Directory -Path $BackupRoot -Force | Out-Null

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$snapshotDir = Join-Path $BackupRoot ("uXBasic_repo_fs_snapshot_" + $timestamp)
$mirrorDir = Join-Path $BackupRoot "uXBasic_repo_mirror.git"

New-Item -ItemType Directory -Path $snapshotDir -Force | Out-Null

Write-Host "[INFO] Creating filesystem snapshot..."
robocopy $SourceRoot $snapshotDir /E /R:1 /W:1 /NFL /NDL /NJH /NJS /NP /XD ".vs" "build" "release" "tmp"
if ($LASTEXITCODE -ge 8) {
    throw "robocopy failed with exit code $LASTEXITCODE"
}

Write-Host "[INFO] Refreshing bare git mirror..."
if (Test-Path $mirrorDir) {
    Remove-Item -Recurse -Force $mirrorDir
}

git clone --mirror $SourceRoot $mirrorDir
if ($LASTEXITCODE -ne 0) {
    throw "git mirror clone failed"
}

Write-Host "[INFO] Pruning old snapshots..."
$snapshots = Get-ChildItem -Path $BackupRoot -Directory -Filter "uXBasic_repo_fs_snapshot_*" |
    Sort-Object Name -Descending

if ($snapshots.Count -gt $KeepSnapshots) {
    $toDelete = $snapshots | Select-Object -Skip $KeepSnapshots
    foreach ($item in $toDelete) {
        Remove-Item -Recurse -Force $item.FullName
        Write-Host "[PRUNE] Removed old snapshot: $($item.FullName)"
    }
}

Write-Host "[DONE] Safety checkpoint completed"
Write-Host "SNAPSHOT=$snapshotDir"
Write-Host "MIRROR=$mirrorDir"
