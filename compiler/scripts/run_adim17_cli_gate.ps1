param([switch]$NoRepair)

$ErrorActionPreference = 'Continue'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
Set-Location $root

$step = 'adim17_cli_3_harf'
$stamp = Get-Date -Format 'yyyyMMdd_HHmmss'
$current = 'reports/control/current'
$history = "reports/control/history/${step}_$stamp"
New-Item -ItemType Directory -Force 'reports/control/history' | Out-Null
if (Test-Path $current) {
    $existing = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($existing) {
        New-Item -ItemType Directory -Force $history | Out-Null
        Move-Item "$current\*" $history -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null

$status = 'PASS'
$errors = @()
function Add-Err([string]$Code, [string]$Message) {
    $script:status = 'FAIL'
    $script:errors += [pscustomobject]@{ code = $Code; message = $Message }
}

$required = @(
    'src/cli/cli_args.fbs',
    'src/cli/cli_response_file.fbs',
    'src/cli/cli_verb_dispatch.fbs',
    'src/cli/cli_help.fbs',
    'src/cli/cli_json_report.fbs',
    'src/cli/cli_route_matrix.fbs',
    'src/cli/cli_main_bridge.fbs'
)
foreach ($file in $required) {
    if (-not (Test-Path $file)) { Add-Err 'MISSING_FILE' $file }
}

# The canonical compiler is bin/uxb.exe. The old gate rebuilt a second legacy
# src/main.bas compiler and contained embedded control characters in its paths.
$exe = Join-Path $root 'bin\uxb.exe'
if (-not (Test-Path $exe)) {
    Add-Err 'EXE_MISSING' 'bin/uxb.exe'
}

$positive = @()
$negative = @()
function Run-Positive([string]$Name, [string[]]$Arguments, [string]$ExpectedFile = '') {
    if (-not (Test-Path $script:exe)) {
        $script:positive += [pscustomobject]@{ name = $Name; status = 'SKIP_NO_EXE'; exit_code = '' }
        return
    }
    $output = & $script:exe @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    $output | Set-Content -Encoding UTF8 "$current/$Name.log"
    $ok = $exitCode -eq 0
    if ($ExpectedFile -and -not (Test-Path $ExpectedFile)) { $ok = $false }
    if (-not $ok) { Add-Err 'POSITIVE_FAIL' $Name }
    $script:positive += [pscustomobject]@{
        name = $Name
        status = $(if ($ok) { 'PASS' } else { 'FAIL' })
        exit_code = $exitCode
    }
}
function Run-Negative([string]$Name, [string[]]$Arguments, [string]$Expected) {
    if (-not (Test-Path $script:exe)) {
        $script:negative += [pscustomobject]@{ name = $Name; status = 'SKIP_NO_EXE'; exit_code = ''; expected = $Expected }
        return
    }
    $output = & $script:exe @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    $output | Set-Content -Encoding UTF8 "$current/$Name.log"
    $ok = $exitCode -ne 0
    if (-not $ok) { Add-Err 'NEGATIVE_FAIL' $Name }
    $script:negative += [pscustomobject]@{
        name = $Name
        status = $(if ($ok) { 'PASS' } else { 'FAIL' })
        exit_code = $exitCode
        expected = $Expected
    }
}

Run-Positive 'hlp' @('hlp')
Run-Positive 'ver' @('ver')
Run-Positive 'lex' @('lex', 'tests\adim17\positive\adim17_hello.bas', '--json-out', 'reports\control\current\lex.json') 'reports/control/current/lex.json'
Run-Positive 'mir_response' @('mir', 'tests\adim17\positive\adim17_math.bas', '@tests\options\mir.uxcli')
Run-Positive 'x64' @('x64', 'tests\adim17\positive\adim17_hello.bas', '--emit-x64-nasm-out', 'dist\adim17\hello.asm', '--json-out', 'reports\control\current\x64.json') 'reports/control/current/x64.json'
Run-Negative 'unknown_option' @('lex', 'tests\adim17\positive\adim17_hello.bas', '--definitely-unknown-option') 'CLI_UNKNOWN_OPTION'
Run-Negative 'missing_response' @('mir', 'tests\adim17\positive\adim17_hello.bas', '@missing.uxcli') 'CLI_RESPONSE_FILE_NOT_FOUND'
Run-Negative 'json_write_fail' @('lex', 'tests\adim17\positive\adim17_hello.bas', '--json-out', 'Z:\no_such_dir\x.json') 'CLI_OUTPUT_WRITE_FAIL'

$positive | Export-Csv "$current/adim12_positive_tests.csv" -NoTypeInformation -Encoding UTF8
$negative | Export-Csv "$current/adim12_negative_tests.csv" -NoTypeInformation -Encoding UTF8
$errors | Export-Csv "$current/adim12_error_classification.csv" -NoTypeInformation -Encoding UTF8

[ordered]@{
    status = $status
    step = '17_ADIM12_CLI_3_HARF_KOMUT_ZINCIRI'
    no_repair = [bool]$NoRepair
    error_count = $errors.Count
    current_archived_to = $history
} | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 "$current/adim12_gate.json"

"# ADIM17 CLI Gate`n`nStatus: $status`n`nErrors: $($errors.Count)`n" |
    Set-Content -Encoding UTF8 "$current/adim12_gate.md"

if ($status -ne 'PASS') { exit 1 }
exit 0
