param([switch]$NoRepair)
$ErrorActionPreference = "Stop"
function Find-UxbRoot {
  $p = (Get-Location).Path
  while ($true) {
    if ((Test-Path (Join-Path $p "src\main.bas")) -and (Test-Path (Join-Path $p "compiler\scripts"))) { return $p }
    $parent = Split-Path $p -Parent
    if ($parent -eq $p) { throw "uXBasic root not found" }
    $p = $parent
  }
}
$root = Find-UxbRoot
Set-Location $root
if (Test-Path "compiler\scripts\rotate_current_reports.ps1") {
  powershell -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\rotate_current_reports.ps1" -StepName "adim38_second_wave"
}
$env:UXB_FORCE_REBUILD = "1"
powershell -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\run_adim36_full_surface_library_suite.ps1" -NoRepair
$adim36 = $LASTEXITCODE
powershell -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\run_adim32b_strict_pass.ps1" -NoRepair
$adim32b = $LASTEXITCODE
powershell -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\run_adim30_10step_chain_suite.ps1" -NoRepair
$adim30 = $LASTEXITCODE
$gate = [ordered]@{
  step = "ADIM38_SECOND_WAVE"
  adim36_exit_code = $adim36
  adim32b_exit_code = $adim32b
  adim30_exit_code = $adim30
  ok_core = (($adim32b -eq 0) -and ($adim30 -eq 0))
}
New-Item -ItemType Directory -Force -Path "reports\control\current" | Out-Null
$gate | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 "reports\control\current\adim38_second_wave_gate.json"
exit $adim36
