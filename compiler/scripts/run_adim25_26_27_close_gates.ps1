param([switch]$NoRepair)
$ErrorActionPreference = "Stop"
$repo = Get-Location
while ($repo -and !(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
    $parent = Split-Path $repo -Parent
    if ($parent -eq $repo) { break }
    $repo = $parent
}
if (!(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
    Write-Error "Repo root bulunamadi: uxb/src/main.bas yok."
    exit 1
}
Set-Location $repo
$current = "uxb/reports/control/current"
$histRoot = "uxb/reports/control/history"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
if (Test-Path $current) {
    $has = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($has) {
        $dest = Join-Path $histRoot "adim25_26_27_$stamp"
        New-Item -ItemType Directory -Force $dest | Out-Null
        Move-Item "$current/*" $dest -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
$buildLog = Join-Path $current "adim25_26_27_compile.log"
$gateJson = Join-Path $current "adim25_26_27_gate.json"
cmd /c build_64.bat > $buildLog 2>&1
$rc = $LASTEXITCODE
$okText = if ($rc -eq 0) { "true" } else { "false" }
@"
{
  "step": "ADIM25_26_27",
  "ok": $okText,
  "build_exit_code": $rc,
  "compile_log": "uxb/reports/control/current/adim25_26_27_compile.log",
  "expected_reports": [
    "adim25_ast_mir_coverage.csv",
    "adim25_ast_mir_coverage.json",
    "adim26_js_opcode_coverage.csv",
    "adim26_wasm_opcode_coverage.csv",
    "adim27_cli_route_close.csv"
  ]
}
"@ | Set-Content -Encoding UTF8 $gateJson
if ($rc -ne 0) { exit $rc }
exit 0
