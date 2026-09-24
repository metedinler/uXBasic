param([switch]$NoRepair)

$ErrorActionPreference = "Stop"

function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src")) -and (Test-Path (Join-Path $p "compiler"))) { return $p }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root not found" }
        $p = $parent
    }
}

$root = Find-UxbRoot
Set-Location $root

$current = "reports\control\current"
New-Item -ItemType Directory -Force -Path $current | Out-Null

$matrix = "docs\ADIM41_CLI_COMMAND_MATRIX.csv"
if (!(Test-Path $matrix)) {
    if (Test-Path "UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI\docs\ADIM41_CLI_COMMAND_MATRIX.csv") {
        $matrix = "UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI\docs\ADIM41_CLI_COMMAND_MATRIX.csv"
    } else {
        throw "ADIM41_CLI_COMMAND_MATRIX.csv not found"
    }
}

$py = "tools\control\uxb_cli_full_contract_gate.py"
if (!(Test-Path $py)) { throw "uxb_cli_full_contract_gate.py not found" }

$reportJson = Join-Path $current "adim41_cli_full_contract_gate.json"
$reportCsv  = Join-Path $current "adim41_cli_full_contract_results.csv"
$outdir     = Join-Path $current "adim41_cli_outputs"
New-Item -ItemType Directory -Force -Path $outdir | Out-Null

python $py `
  --matrix $matrix `
  --outdir $outdir `
  --report-json $reportJson `
  --report-csv $reportCsv `
  --dry-run

$code = $LASTEXITCODE

Write-Output "ADIM41 CLI full contract gate exit code: $code"
Write-Output "Report: $reportJson"
Write-Output "CSV: $reportCsv"

exit $code
