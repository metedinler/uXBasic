param(
    [switch]$NoRepair,
    [int]$MaxTests = 0,
    [string]$UxbExe = ""
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
$historyTarget = Join-Path $historyRoot "22_full_layer_expected_suite_$stamp"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        foreach ($it in $items) {
            Move-Item -LiteralPath $it.FullName -Destination $historyTarget -Force
        }
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
New-Item -ItemType Directory -Force "$current/adim22/layers" | Out-Null
New-Item -ItemType Directory -Force "$current/adim22/backend" | Out-Null
New-Item -ItemType Directory -Force "$current/adim22/browser" | Out-Null
New-Item -ItemType Directory -Force "$current/adim22/negative" | Out-Null
"CURRENT_ARCHIVED_TO=$historyTarget" | Tee-Object -FilePath "$current/adim22_run.log" -Append

$py = "python"
$venvPy1 = Join-Path (Split-Path $uxbRoot -Parent) ".venv\Scripts\python.exe"
$venvPy2 = Join-Path $uxbRoot ".venv\Scripts\python.exe"
if (Test-Path $venvPy1) { $py = $venvPy1 }
elseif (Test-Path $venvPy2) { $py = $venvPy2 }

$runner = "tools/control/uxb_run_layer_tests.py"
$compare = "tools/control/uxb_expected_actual_compare.py"
$plan = "tests/full_layer/expected/adim22_full_layer_test_plan.csv"
$expectedOutputs = "tests/full_layer/expected/adim22_expected_layer_outputs.csv"
$coverageMap = "tests/full_layer/expected/adim22_surface_coverage_map.csv"

$missingPrereq = @()
foreach ($p in @($runner,$compare,$plan,$expectedOutputs,$coverageMap)) {
    if (!(Test-Path $p)) { $missingPrereq += $p }
}
if ($missingPrereq.Count -gt 0) {
    $obj = [ordered]@{ schema="uxb-adim22-full-layer-gate-1"; status="FAIL"; reason="MISSING_PREREQUISITE"; missing=$missingPrereq; no_repair=[bool]$NoRepair }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 "$current/adim22_full_layer_gate.json"
    "# ADIM22 FULL LAYER GATE`n`nFAIL: missing prerequisite files.`n`n$($missingPrereq -join "`n")" | Set-Content -Encoding UTF8 "$current/adim22_full_layer_gate.md"
    exit 1
}

# Compile attempt: no repair, log only.
$compileLog = "$current/adim22_compile.log"
$buildCandidates = @("build_64.bat", "compiler/scripts/build_uxb_main_64.bat", "compiler/scripts/build_64.bat")
$buildExit = 9999
foreach ($b in $buildCandidates) {
    if (Test-Path $b) {
        "RUN_BUILD=$b" | Tee-Object -FilePath "$current/adim22_run.log" -Append
        $buildPath = (Resolve-Path $b).Path
        & cmd /c "`"$buildPath`"" *> $compileLog
        $buildExit = $LASTEXITCODE
        "BUILD_EXIT_CODE=$buildExit" | Tee-Object -FilePath "$current/adim22_run.log" -Append
        break
    }
}
if ($buildExit -eq 9999) { "BUILD_SCRIPT_NOT_FOUND" | Tee-Object -FilePath "$current/adim22_run.log" -Append }

$uxbExeArg = ""
if ($UxbExe -ne "") { $uxbExeArg = "--uxb-exe `"$UxbExe`"" }
$maxArg = ""
if ($MaxTests -gt 0) { $maxArg = "--max-tests $MaxTests" }

# Run existing test runner. It must not repair source code.
$cmd = "$py $runner --root . --plan $plan --out reports/control/current/adim22_test_results.csv $uxbExeArg $maxArg --strict"
"RUN_TESTS=$cmd" | Tee-Object -FilePath "$current/adim22_run.log" -Append
Invoke-Expression $cmd
$testExit = $LASTEXITCODE
"TEST_EXIT_CODE=$testExit" | Tee-Object -FilePath "$current/adim22_run.log" -Append

$cmd2 = "$py $compare --root . --results reports/control/current/adim22_test_results.csv --out reports/control/current/adim22_expected_actual.csv --strict"
"RUN_COMPARE=$cmd2" | Tee-Object -FilePath "$current/adim22_run.log" -Append
Invoke-Expression $cmd2
$compareExit = $LASTEXITCODE
"COMPARE_EXIT_CODE=$compareExit" | Tee-Object -FilePath "$current/adim22_run.log" -Append

# Layer output expected/actual check.
$missingOutputs = @()
$outputRows = Import-Csv $expectedOutputs
$outMatrix = @()
foreach ($row in $outputRows) {
    $exists = Test-Path $row.required_output
    if (($row.required -eq "YES") -and (-not $exists)) { $missingOutputs += $row.required_output }
    $outMatrix += [pscustomobject]@{
        test_id = $row.test_id
        layer = $row.layer
        required_output = $row.required_output
        required = $row.required
        exists = if ($exists) { "YES" } else { "NO" }
        notes = $row.notes
    }
}
$outMatrix | Export-Csv "$current/adim22_layer_output_expected_actual.csv" -NoTypeInformation -Encoding UTF8

# Coverage check: every surface must be assigned to a test id.
$coverage = Import-Csv $coverageMap
$unassigned = @($coverage | Where-Object { -not $_.assigned_test_id -or $_.assigned_test_id.Trim() -eq "" })
$coverage | Group-Object assigned_test_id | Select-Object Name,Count | Export-Csv "$current/adim22_surface_coverage_summary.csv" -NoTypeInformation -Encoding UTF8

$status = "PASS"
$reasons = @()
if ($testExit -ne 0) { $status = "FAIL"; $reasons += "TEST_RUNNER_FAIL" }
if ($compareExit -ne 0) { $status = "FAIL"; $reasons += "EXPECTED_ACTUAL_FAIL" }
if ($missingOutputs.Count -gt 0) { $status = "FAIL"; $reasons += "MISSING_LAYER_OUTPUTS" }
if ($unassigned.Count -gt 0) { $status = "FAIL"; $reasons += "UNASSIGNED_SURFACES" }

$gate = [ordered]@{
    schema = "uxb-adim22-full-layer-gate-1"
    status = $status
    no_repair = [bool]$NoRepair
    build_exit_code = $buildExit
    test_exit_code = $testExit
    compare_exit_code = $compareExit
    surface_coverage_count = $coverage.Count
    unassigned_surface_count = $unassigned.Count
    missing_layer_output_count = $missingOutputs.Count
    reasons = $reasons
    missing_layer_outputs = $missingOutputs
    reports = @(
        "reports/control/current/adim22_test_results.csv",
        "reports/control/current/adim22_expected_actual.csv",
        "reports/control/current/adim22_layer_output_expected_actual.csv",
        "reports/control/current/adim22_surface_coverage_summary.csv"
    )
}
$gate | ConvertTo-Json -Depth 8 | Set-Content -Encoding UTF8 "$current/adim22_full_layer_gate.json"

$md = @()
$md += "# ADIM22 Full Layer Expected Test Suite"
$md += ""
$md += "Status: **$status**"
$md += ""
$md += "- Build exit code: $buildExit"
$md += "- Test exit code: $testExit"
$md += "- Compare exit code: $compareExit"
$md += "- Surface coverage count: $($coverage.Count)"
$md += "- Missing layer outputs: $($missingOutputs.Count)"
$md += ""
if ($reasons.Count -gt 0) { $md += "## Reasons"; foreach ($r in $reasons) { $md += "- $r" } }
$md | Set-Content -Encoding UTF8 "$current/adim22_full_layer_gate.md"

if ($status -ne "PASS") { exit 1 }
exit 0
