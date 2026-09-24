param([string]$StepName = "run")
$ErrorActionPreference = "Stop"
function Find-UxbRoot {
  $p = (Get-Location).Path
  while ($true) {
    if ((Test-Path (Join-Path $p "src\main.bas")) -and (Test-Path (Join-Path $p "reports"))) { return $p }
    $parent = Split-Path $p -Parent
    if ($parent -eq $p) { throw "uXBasic root not found" }
    $p = $parent
  }
}
$root = Find-UxbRoot
$current = Join-Path $root "reports\control\current"
$history = Join-Path $root "reports\control\history"
New-Item -ItemType Directory -Force -Path $history | Out-Null
if (Test-Path $current) {
  $files = Get-ChildItem $current -Recurse -File -ErrorAction SilentlyContinue
  if ($files.Count -gt 0) {
    $stamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $safeStep = $StepName -replace '[^A-Za-z0-9_\-]','_'
    $dest = Join-Path $history ("${stamp}_${safeStep}")
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Get-ChildItem $current -Force | Move-Item -Destination $dest -Force
  }
}
New-Item -ItemType Directory -Force -Path $current | Out-Null
