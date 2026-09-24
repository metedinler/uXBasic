param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..\..").Path,
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
Set-Location $Root

$step = "08_adim3_parser"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$history = "reports/control/history/${step}_$stamp"
New-Item -ItemType Directory -Force "reports/control/history" | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $history | Out-Null
        Move-Item "$current\*" $history -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null

$exe = "dist/uxb_main_64.exe"
if (!(Test-Path $exe)) {
    $exe = "uxb_main_64.exe"
}

$rows = @()
$tests = Get-ChildItem "tests/adim08" -Recurse -Filter "*.bas" -ErrorAction SilentlyContinue
foreach ($t in $tests) {
    $astOut = Join-Path $current ($t.BaseName + ".ast.json")
    $errOut = Join-Path $current ($t.BaseName + ".parser_errors.json")
    $status = "SKIPPED_NO_EXE"
    $exitCode = 999
    if (Test-Path $exe) {
        & $exe $t.FullName --ast-json-out $astOut --parser-errors-json-out $errOut
        $exitCode = $LASTEXITCODE
        if ($t.FullName -match "negative") {
            if ($exitCode -ne 0) { $status = "PASS_NEGATIVE" } else { $status = "FAIL_NEGATIVE_ACCEPTED" }
        } else {
            if ($exitCode -eq 0 -and (Test-Path $astOut)) { $status = "PASS" } else { $status = "FAIL" }
        }
    }
    $rows += [pscustomobject]@{ test=$t.FullName; status=$status; exit_code=$exitCode; ast_json=$astOut; errors_json=$errOut }
}

$rows | Export-Csv "$current/adim3_positive_negative_tests.csv" -NoTypeInformation -Encoding UTF8

$passCount = ($rows | Where-Object { $_.status -like "PASS*" }).Count
$failCount = ($rows | Where-Object { $_.status -like "FAIL*" }).Count
$skippedCount = ($rows | Where-Object { $_.status -like "SKIPPED*" }).Count
$gateStatus = if ($failCount -eq 0 -and $skippedCount -eq 0) { "PASS" } elseif ($failCount -eq 0) { "SKIP_TOOLCHAIN" } else { "FAIL" }

$gate = [ordered]@{
  step = "08_ADIM3_PARSER"
  status = $gateStatus
  pass_count = $passCount
  fail_count = $failCount
  skipped_count = $skippedCount
  history_archived_to = $history
}
$gate | ConvertTo-Json -Depth 5 | Set-Content "$current/adim3_gate.json" -Encoding UTF8

$md = @()
$md += "# Adim 08 / Adim3 Parser Gate"
$md += ""
$md += "- status: $gateStatus"
$md += "- pass_count: $passCount"
$md += "- fail_count: $failCount"
$md += "- skipped_count: $skippedCount"
$md += "- history_archived_to: $history"
$md -join "`n" | Set-Content "$current/adim3_gate.md" -Encoding UTF8

Get-Content "$current/adim3_gate.json"
