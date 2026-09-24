param([switch]$NoRepair)
$ErrorActionPreference = 'Stop'
function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p 'src\main.bas')) -and (Test-Path (Join-Path $p 'compiler\scripts'))) { return $p }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw 'uXBasic root not found' }
        $p = $parent
    }
}
$root = Find-UxbRoot
Set-Location $root
$current = Join-Path $root 'reports\control\current'
New-Item -ItemType Directory -Force -Path $current | Out-Null
$log = Join-Path $current 'adim31_after_patch_check.log'
$cmd = 'compiler\scripts\run_adim30_10step_chain_suite.ps1'
if (!(Test-Path $cmd)) { throw "Missing $cmd" }
powershell -NoProfile -ExecutionPolicy Bypass -File $cmd -NoRepair *> $log
$exit = $LASTEXITCODE
$gate = Join-Path $current 'adim30_10step_gate.json'
$result = [ordered]@{
    step = 'ADIM31_AFTER_PATCH_CHECK'
    adim30_exit_code = $exit
    gate = 'reports/control/current/adim30_10step_gate.json'
    result_csv = 'reports/control/current/adim30_10step_results.csv'
    placeholder_scan = 'not_run'
}
try {
    $rg = Get-Command rg -ErrorAction SilentlyContinue
    if ($rg) {
        $scan = & rg -n 'GENERATED_PLACEHOLDER|uxb-placeholder-artifact-1|placeholder artifact' reports/control/current 2>$null
        $result.placeholder_scan = if ($LASTEXITCODE -eq 0) { 'FOUND' } else { 'CLEAN' }
    }
} catch { $result.placeholder_scan = 'ERROR' }
$result | ConvertTo-Json -Depth 4 | Set-Content -Encoding UTF8 (Join-Path $current 'adim31_after_patch_check.json')
exit $exit
