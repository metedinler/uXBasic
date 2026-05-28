param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path,
    [string]$PythonExe = "python"
)
$ErrorActionPreference = "Stop"
Set-Location $RepoRoot
$step = "07_adim2_lexer_preprocessor"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "${step}_${stamp}"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $has = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($has) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        Move-Item "$current\*" $historyTarget -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
& $PythonExe tools/control/uxb_surface_lifecycle_matrix.py --root . --strict
$surfaceExit = $LASTEXITCODE
$summaryPath = Join-Path $current "surface_lifecycle_summary.json"
$summary = if (Test-Path $summaryPath) { Get-Content $summaryPath -Raw | ConvertFrom-Json } else { $null }
$gate = [ordered]@{
  step = "07_ADIM2_LEXER_PREPROCESSOR"
  archived_current_to = $historyTarget
  surface_lifecycle_exit_code = $surfaceExit
  surface_count = if ($summary) { $summary.surface_count } else { -1 }
  blocker_count = if ($summary) { $summary.blocker_count } else { -1 }
  backend_blocker_count = if ($summary) { $summary.backend_blocker_count } else { -1 }
  token_metadata_patch = $true
  preprocessor_route_patch = $true
  surface_contract_patch = $true
  status = if ($summary -and $summary.blocker_count -eq 0) { "PASS" } else { "FAIL" }
}
$gate | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $current "adim2_gate.json")
"# ADIM2 Lexer/Preprocessor Gate`n`n- status: ``$($gate.status)```n- archived_current_to: ``$historyTarget```n- surface_count: ``$($gate.surface_count)```n- blocker_count: ``$($gate.blocker_count)```n- backend_blocker_count: ``$($gate.backend_blocker_count)```n" | Set-Content -Encoding UTF8 (Join-Path $current "adim2_gate.md")
exit $surfaceExit
