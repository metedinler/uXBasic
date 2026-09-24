param(
    [string]$RepoRoot = (Resolve-Path "$PSScriptRoot\..\..").Path,
    [string]$Python = "python"
)

$ErrorActionPreference = "Stop"
Set-Location $RepoRoot

$step = "10_adim5_semantic_type_hir_layout"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "${step}_${stamp}"

New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $hasFiles = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($hasFiles) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        Move-Item "$current\*" $historyTarget -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
Write-Output "CURRENT_ARCHIVED_TO=$historyTarget"

if (Test-Path "compiler/scripts/run_step3_semantic_type_layout_gate.bat") {
    cmd /c compiler\scripts\run_step3_semantic_type_layout_gate.bat
    Write-Output "STEP3_GATE_EXIT=$LASTEXITCODE"
} else {
    Write-Output "MISSING compiler/scripts/run_step3_semantic_type_layout_gate.bat"
}

$compiler = Join-Path $RepoRoot "bin\uxb.exe"
$buildScript = Join-Path $RepoRoot "compiler\scripts\build_uxb_main_64.ps1"
if (!(Test-Path $compiler)) {
    & powershell -NoProfile -ExecutionPolicy Bypass -File $buildScript -Root $RepoRoot -Release -SkipX86
    Write-Output "CANONICAL_FBC_EXIT=$LASTEXITCODE"
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

if (!(Test-Path $compiler)) {
    Write-Output "CANONICAL_COMPILER_NOT_FOUND"
    exit 3
} else {
    $pos = @(
        "tests/adim10/positive/adim10_scope_type.bas",
        "tests/adim10/positive/adim10_class_layout.bas"
    )
    foreach ($p in $pos) {
        & $compiler $p --mode=min --check --hir-json-out "reports/control/current/$([IO.Path]::GetFileNameWithoutExtension($p)).hir.json"
        Write-Output "POS_TEST $p EXIT=$LASTEXITCODE"
        if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    }

    $neg = @(
        "tests/adim10/negative/adim10_undefined_symbol.bas",
        "tests/adim10/negative/adim10_type_mismatch.bas"
    )
    foreach ($n in $neg) {
        & $compiler $n --mode=min --check
        Write-Output "NEG_TEST $n EXIT=$LASTEXITCODE"
        if ($LASTEXITCODE -eq 0) {
            Write-Output "NEGATIVE_TEST_UNEXPECTED_PASS $n"
            exit 2
        }
    }
}

$required = @(
    "reports/control/current/adim5_gate.json",
    "reports/control/current/adim5_gate.md",
    "reports/control/current/adim5_type_table.csv",
    "reports/control/current/adim5_layout_report.csv"
)
$missing = @()
foreach ($f in $required) {
    if (!(Test-Path $f)) { $missing += $f }
}
if ($missing.Count -gt 0) {
    Write-Output "ADIM10_MISSING_EXPECTED_REPORTS"
    $missing | ForEach-Object { Write-Output $_ }
} else {
    Write-Output "ADIM10_EXPECTED_REPORTS_EXIST"
}

git status --short -- reports/control/current reports/control/history src/symbols src/semantic tests/adim10 compiler/scripts/run_adim10_semantic_step5_gate.ps1
