param(
    [switch]$NoRepair
)

$ErrorActionPreference = "Continue"

$repo = Resolve-Path (Join-Path $PSScriptRoot "..\..")
Set-Location $repo

$step = "16_adim11_diagnostics_source_mapping_json"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "${step}_${stamp}"

New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        Move-Item "$current\*" $historyTarget -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null

$compileLog = Join-Path $current "adim11_compile.log"
$errorCsv = Join-Path $current "adim11_error_classification.csv"
$posCsv = Join-Path $current "adim11_positive_tests.csv"
$negCsv = Join-Path $current "adim11_negative_tests.csv"
$gateJson = Join-Path $current "adim11_gate.json"
$gateMd = Join-Path $current "adim11_gate.md"

"test,status,exit_code,notes" | Set-Content -Encoding UTF8 $posCsv
"test,status,exit_code,notes" | Set-Content -Encoding UTF8 $negCsv
"file,line,error_class,message" | Set-Content -Encoding UTF8 $errorCsv

function Add-ErrClass([string]$file,[string]$line,[string]$class,[string]$msg) {
    $safe = $msg.Replace('"','""')
    Add-Content -Encoding UTF8 $errorCsv "`"$file`",`"$line`",`"$class`",`"$safe`""
}

# Tool detection
$fbcCandidates = @(
    "tools/FreeBASIC-1.10.1-win64/fbc.exe",
    "../tools/FreeBASIC-1.10.1-win64/fbc.exe",
    "C:/FreeBASIC/fbc.exe"
)
$fbc = $null
foreach ($c in $fbcCandidates) {
    if (Test-Path $c) { $fbc = (Resolve-Path $c).Path; break }
}
if (-not $fbc) {
    $cmd = Get-Command fbc -ErrorAction SilentlyContinue
    if ($cmd) { $fbc = $cmd.Source }
}

if (-not $fbc) {
    Add-ErrClass "toolchain" "0" "FBC_NOT_FOUND" "FreeBASIC compiler not found"
    @{
        step="16_ADIM11_DIAGNOSTICS_SOURCE_MAPPING_JSON"; ok=$false; reason="FBC_NOT_FOUND"; no_repair=[bool]$NoRepair
    } | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $gateJson
    "# ADIM16 Gate`n`nstatus: FAIL`nreason: FBC_NOT_FOUND`n" | Set-Content -Encoding UTF8 $gateMd
    exit 1
}

# Compile common harness
$harness = "tests/adim16/harness/adim16_common_harness.bas"
$harnessExe = "tests/adim16/harness/adim16_common_harness.exe"
& $fbc $harness -x $harnessExe *> $compileLog
$compileExit = $LASTEXITCODE
if ($compileExit -ne 0) {
    Add-ErrClass $harness "0" "COMMON_HARNESS_COMPILE_FAIL" "common diagnostics harness failed to compile"
    Get-Content $compileLog -ErrorAction SilentlyContinue | Select-Object -First 80 | ForEach-Object {
        if ($_ -match "error") { Add-ErrClass $harness "0" "FBC_ERROR" $_ }
    }
    @{
        step="16_ADIM11_DIAGNOSTICS_SOURCE_MAPPING_JSON"; ok=$false; compile_exit=$compileExit; no_repair=[bool]$NoRepair
    } | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $gateJson
    "# ADIM16 Gate`n`nstatus: FAIL`ncompile_exit: $compileExit`nrepair: disabled`n" | Set-Content -Encoding UTF8 $gateMd
    exit 1
}

& $harnessExe *> (Join-Path $current "adim11_common_harness.run.log")
$runExit = $LASTEXITCODE
Add-Content -Encoding UTF8 $posCsv "common_harness,$(if($runExit -eq 0){'PASS'}else{'FAIL'}),$runExit,diagnostic/schema/source-map harness"

# Negative empty code must fail internally by printing pass and exit 0
$neg1 = "tests/adim16/harness/adim16_negative_empty_code.bas"
$neg1Exe = "tests/adim16/harness/adim16_negative_empty_code.exe"
& $fbc $neg1 -x $neg1Exe *> (Join-Path $current "adim11_negative_empty_code.compile.log")
$neg1Compile = $LASTEXITCODE
if ($neg1Compile -eq 0) {
    & $neg1Exe *> (Join-Path $current "adim11_negative_empty_code.run.log")
    $neg1Run = $LASTEXITCODE
    Add-Content -Encoding UTF8 $negCsv "empty_diagnostic_code,$(if($neg1Run -eq 0){'PASS'}else{'FAIL'}),$neg1Run,gate rejects empty code"
} else {
    Add-Content -Encoding UTF8 $negCsv "empty_diagnostic_code,FAIL,$neg1Compile,compile failed"
}

$neg2 = "tests/adim16/harness/adim16_negative_missing_location.bas"
$neg2Exe = "tests/adim16/harness/adim16_negative_missing_location.exe"
& $fbc $neg2 -x $neg2Exe *> (Join-Path $current "adim11_negative_missing_location.compile.log")
$neg2Compile = $LASTEXITCODE
if ($neg2Compile -eq 0) {
    & $neg2Exe *> (Join-Path $current "adim11_negative_missing_location.run.log")
    $neg2Run = $LASTEXITCODE
    Add-Content -Encoding UTF8 $negCsv "missing_source_location,$(if($neg2Run -eq 0){'PASS'}else{'FAIL'}),$neg2Run,gate rejects missing source location"
} else {
    Add-Content -Encoding UTF8 $negCsv "missing_source_location,FAIL,$neg2Compile,compile failed"
}

$required = @(
    "reports/control/current/adim11_diagnostic_schema.json",
    "reports/control/current/adim11_source_mapping_report.csv",
    "reports/control/current/adim11_json_schema_report.csv",
    "reports/control/current/adim11_gate.json",
    "reports/control/current/adim11_gate.md"
)
$missing = @()
foreach ($f in $required) { if (!(Test-Path $f)) { $missing += $f } }

$ok = ($runExit -eq 0 -and $neg1Compile -eq 0 -and $neg2Compile -eq 0 -and $missing.Count -eq 0)
if (-not $ok) {
    foreach ($m in $missing) { Add-ErrClass $m "0" "MISSING_OUTPUT" "expected output not produced" }
}

@{
    step="16_ADIM11_DIAGNOSTICS_SOURCE_MAPPING_JSON"
    ok=$ok
    common_harness_exit=$runExit
    no_repair=[bool]$NoRepair
    missing_outputs=$missing
    history_archived_to=$historyTarget
} | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 $gateJson

"# ADIM16 Gate`n`nstatus: $(if($ok){'PASS'}else{'FAIL'})`nhistory_archived_to: $historyTarget`nrepair: disabled`n" | Set-Content -Encoding UTF8 $gateMd

if ($ok) { exit 0 } else { exit 1 }
