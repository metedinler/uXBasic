param(
    [switch]$NoRepair,
    [int]$MaxTests = 0,
    [switch]$AllowSkips,
    [switch]$RequireBackendOutputs
)

$ErrorActionPreference = "Continue"

function Find-UxbRoot([string]$Start) {
    $p = Resolve-Path $Start
    $cur = Get-Item $p
    while ($cur) {
        if ((Test-Path (Join-Path $cur.FullName "src")) -and (Test-Path (Join-Path $cur.FullName "tools"))) { return $cur.FullName }
        if (Test-Path (Join-Path $cur.FullName "uxb\src")) { return (Join-Path $cur.FullName "uxb") }
        $cur = $cur.Parent
    }
    throw "uXBasic root not found"
}

$uxbRoot = Find-UxbRoot (Get-Location).Path
Set-Location $uxbRoot

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "18_adim13_test_suite_release_$stamp"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        Move-Item "$current\*" $historyTarget -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
"CURRENT_ARCHIVED_TO=$historyTarget" | Tee-Object -FilePath "$current/adim13_run.log" -Append

$py = "python"
$venvPy1 = Join-Path (Split-Path $uxbRoot -Parent) ".venv\Scripts\python.exe"
$venvPy2 = Join-Path $uxbRoot ".venv\Scripts\python.exe"
if (Test-Path $venvPy1) { $py = $venvPy1 }
elseif (Test-Path $venvPy2) { $py = $venvPy2 }

# Derleme denemesi: tamirat yok, sadece log.
$compileLog = "$current/adim13_compile.log"
$buildCandidates = @(
    "build_64.bat",
    "compiler/scripts/build_uxb_main_64.bat",
    "compiler/scripts/build_64.bat"
)
$compiled = $false
foreach ($b in $buildCandidates) {
    if (Test-Path $b) {
        "RUN_BUILD=$b" | Tee-Object -FilePath "$current/adim13_run.log" -Append
        & cmd /c $b *> $compileLog
        "BUILD_EXIT_CODE=$LASTEXITCODE" | Tee-Object -FilePath "$current/adim13_run.log" -Append
        $compiled = $true
        break
    }
}
if (-not $compiled) {
    "NO_BUILD_SCRIPT_FOUND" | Tee-Object -FilePath $compileLog
}

# Test plan üret.
$genArgs = @("tools/control/uxb_surface_test_generator.py", "--root", ".", "--strict")
if ($MaxTests -gt 0) { $genArgs += @("--max-rows", "$MaxTests") }
& $py @genArgs 2>&1 | Tee-Object -FilePath "$current/adim13_generator.log"
$genExit = $LASTEXITCODE

# Test koş.
$runArgs = @("tools/control/uxb_run_layer_tests.py", "--root", ".", "--strict")
if ($MaxTests -gt 0) { $runArgs += @("--max-tests", "$MaxTests") }
& $py @runArgs 2>&1 | Tee-Object -FilePath "$current/adim13_runner.log"
$runExit = $LASTEXITCODE

# Expected/actual.
& $py tools/control/uxb_expected_actual_compare.py --root . --strict 2>&1 | Tee-Object -FilePath "$current/adim13_expected_actual.log"
$cmpExit = $LASTEXITCODE

# Release gate.
$gateArgs = @("tools/release/uxb_release_gate.py", "--root", ".", "--strict")
if ($AllowSkips) { $gateArgs += "--allow-skips" }
if ($RequireBackendOutputs) { $gateArgs += "--require-backend-outputs" }
& $py @gateArgs 2>&1 | Tee-Object -FilePath "$current/adim13_release_gate.log"
$gateExit = $LASTEXITCODE

@"
generator_exit=$genExit
runner_exit=$runExit
compare_exit=$cmpExit
release_gate_exit=$gateExit
NoRepair=$NoRepair
"@ | Set-Content -Encoding UTF8 "$current/adim13_exit_codes.txt"

Get-ChildItem $current | Select-Object Name,Length | Format-Table -AutoSize
if (Test-Path "$current/adim13_release_gate.json") {
    Get-Content "$current/adim13_release_gate.json" -TotalCount 80
}

if ($gateExit -ne 0) { exit $gateExit }
exit 0
