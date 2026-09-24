param([switch]$NoRepair)

$ErrorActionPreference = "Stop"

function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src\main.bas")) -and (Test-Path (Join-Path $p "compiler\scripts"))) {
            return $p
        }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root not found" }
        $p = $parent
    }
}

$root = Find-UxbRoot
Set-Location $root

$current = "reports\control\current"
New-Item -ItemType Directory -Force -Path $current | Out-Null

$env:UXB_FORCE_REBUILD = "1"

$compileLog = Join-Path $current "adim32_force_rebuild_compile.log"

if (Test-Path "build_64.bat") {
    & cmd /c "build_64.bat" *> $compileLog
} elseif (Test-Path "compiler\scripts\build_uxb_main_64.bat") {
    & cmd /c "compiler\scripts\build_uxb_main_64.bat" *> $compileLog
} else {
    throw "No build script found"
}

$buildExit = $LASTEXITCODE
$compileText = ""
if (Test-Path $compileLog) {
    $compileText = Get-Content $compileLog -Raw -ErrorAction SilentlyContinue
}

$skipFound = $false
if ($compileText -match "Skipping rebuild") {
    $skipFound = $true
}

if ($buildExit -ne 0 -or $skipFound) {
    $obj = [ordered]@{
        step = "ADIM32_FORCE_REBUILD"
        ok = $false
        build_exit_code = $buildExit
        skipping_rebuild_found = $skipFound
        compile_log = "reports/control/current/adim32_force_rebuild_compile.log"
        adim30_rerun = "not_run"
    }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 (Join-Path $current "adim32_force_rebuild_gate.json")
    exit 1
}

powershell -NoProfile -ExecutionPolicy Bypass -File "compiler\scripts\run_adim30_10step_chain_suite.ps1" -NoRepair
$adim30Exit = $LASTEXITCODE

$obj = [ordered]@{
    step = "ADIM32_FORCE_REBUILD"
    ok = ($adim30Exit -eq 0)
    build_exit_code = $buildExit
    skipping_rebuild_found = $skipFound
    adim30_exit_code = $adim30Exit
    compile_log = "reports/control/current/adim32_force_rebuild_compile.log"
    gate = "reports/control/current/adim30_10step_gate.json"
    result_csv = "reports/control/current/adim30_10step_results.csv"
}
$obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 (Join-Path $current "adim32_force_rebuild_gate.json")

if ($adim30Exit -ne 0) {
    $firstFailLogs = Import-Csv "reports/control/current/adim30_10step_results.csv" |
        Where-Object { $_.result -eq "FAIL" } |
        Select-Object -First 20
    $outPath = Join-Path $current "adim32_first_fail_logs.txt"
    "" | Set-Content -Encoding UTF8 $outPath
    foreach ($f in $firstFailLogs) {
        Add-Content -Encoding UTF8 $outPath ("=== " + $f.test_id + " / " + $f.step_name + " ===")
        Add-Content -Encoding UTF8 $outPath ("LOG: " + $f.log_file)
        if (Test-Path $f.log_file) {
            Get-Content $f.log_file -TotalCount 80 | Add-Content -Encoding UTF8 $outPath
        } else {
            Add-Content -Encoding UTF8 $outPath "log missing"
        }
        Add-Content -Encoding UTF8 $outPath ""
    }
}

exit $adim30Exit

