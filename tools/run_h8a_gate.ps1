param(
    [string]$CompilerPath = ".\uxbasic.exe",
    [switch]$RunNativeExe
)

$ErrorActionPreference = "Stop"

function Resolve-CompilerPath {
    param([string]$PathIn)

    if (Test-Path -LiteralPath $PathIn) {
        return (Resolve-Path -LiteralPath $PathIn).Path
    }

    if (Test-Path -LiteralPath ".\uxbasic.exe") {
        return (Resolve-Path -LiteralPath ".\uxbasic.exe").Path
    }

    throw "Compiler not found. Build it first or pass -CompilerPath."
}

function Invoke-Step {
    param(
        [string]$StepName,
        [string]$LogPath,
        [scriptblock]$Body
    )

    $started = Get-Date
    try {
        $global:LASTEXITCODE = 0
        $output = & $Body 2>&1
        $exit = $LASTEXITCODE
        if ($null -eq $exit) { $exit = 0 }
        $output | Out-File -FilePath $LogPath -Encoding utf8
        return [PSCustomObject]@{
            step = $StepName
            exit = [int]$exit
            ok = ([int]$exit -eq 0)
            ms = [int]((Get-Date) - $started).TotalMilliseconds
            log = $LogPath
        }
    } catch {
        $_ | Out-File -FilePath $LogPath -Encoding utf8
        return [PSCustomObject]@{
            step = $StepName
            exit = -9999
            ok = $false
            ms = [int]((Get-Date) - $started).TotalMilliseconds
            log = $LogPath
        }
    }
}

$compiler = Resolve-CompilerPath $CompilerPath
$root = Resolve-Path -LiteralPath "."
$tests = @(
    "80_h8a_operator_numeric_parity.bas",
    "81_h8a_field_store_load_parity.bas",
    "82_h8a_f80_arithmetic_diagnostic.bas",
    "83_h8a_f64_print_parity.bas",
    "84_h8a_f80_field_store_print.bas",
    "85_h8a_builtin_float_return_parity.bas",
    "86_h8a_function_return_float_parity.bas",
    "87_h8a_print_float_string_parity.bas"
)

Write-Host "Running h8a gate tests against compiler: $compiler"

$outRoot = Join-Path $root "tests\basicCodeTests\out_h8a"
New-Item -ItemType Directory -Force -Path $outRoot | Out-Null

$rows = @()
foreach ($t in $tests) {
    $srcPath = Join-Path $root ("tests\basicCodeTests\" + $t)
    if (-not (Test-Path -LiteralPath $srcPath)) {
        Write-Host "MISSING: $t"
        $rows += [PSCustomObject]@{ name = $t; missing = $true }
        continue
    }

    $caseName = [IO.Path]::GetFileNameWithoutExtension($t)
    $caseOut = Join-Path $outRoot $caseName
    New-Item -ItemType Directory -Force -Path $caseOut | Out-Null

    $steps = @()
    $steps += Invoke-Step "json" (Join-Path $caseOut "json.log") { & $compiler $srcPath --ast-json-out (Join-Path $caseOut "ast.json") --inventory-json-out (Join-Path $caseOut "inventory.json") --pipeline-json-out (Join-Path $caseOut "pipeline.json") }
    $steps += Invoke-Step "semantic" (Join-Path $caseOut "semantic.log") { & $compiler $srcPath --semantic }
    $steps += Invoke-Step "ast_run" (Join-Path $caseOut "exec_ast.log") { & $compiler $srcPath --execmem }
    $steps += Invoke-Step "mir_run" (Join-Path $caseOut "exec_mir.log") { & $compiler $srcPath --execmem --interpreter-backend MIR }

    $x64Out = Join-Path $caseOut "x64build"
    $buildStep = Invoke-Step "x64_build" (Join-Path $caseOut "build_x64.log") { & $compiler $srcPath --build-x64 --build-x64-out $x64Out }
    $steps += $buildStep

    # For test 82 we expect x64 build to FAIL (diagnostic). Other tests expected to build OK.
    $expectedBuildOk = $true
    if ($caseName -eq "82_h8a_f80_arithmetic_diagnostic") { $expectedBuildOk = $false }

    $buildOk = $buildStep.ok
    if ($buildOk -ne $expectedBuildOk) {
        Write-Host "[GATE] Unexpected x64_build status for $t : got $([string]$buildOk) expected $([string]$expectedBuildOk)"
    }

    # Optionally run native exe for safe tests
    $nativeRunStatus = "SKIP"
    if ($RunNativeExe -and $buildOk) {
        $exePath = Join-Path $x64Out "program.exe"
        if (Test-Path -LiteralPath $exePath) {
            $runStep = Invoke-Step "x64_run" (Join-Path $caseOut "run_x64.log") { & $exePath }
            $steps += $runStep
            $nativeRunStatus = $(if ($runStep.ok) { "OK" } else { "RAN_EXIT_" + $runStep.exit })
        } else {
            $nativeRunStatus = "MISSING"
        }
    }

    $row = [PSCustomObject]@{
        name = $t
        json = $(if (($steps | Where-Object step -eq "json").ok) { "OK" } else { "FAIL" })
        semantic = $(if (($steps | Where-Object step -eq "semantic").ok) { "OK" } else { "FAIL" })
        ast_run = $(if (($steps | Where-Object step -eq "ast_run").ok) { "OK" } else { "FAIL" })
        mir_run = $(if (($steps | Where-Object step -eq "mir_run").ok) { "OK" } else { "FAIL" })
        x64_build = $(if ($buildOk) { "OK" } else { "FAIL" })
        x64_run = $nativeRunStatus
        out_dir = $caseOut
    }
    $rows += $row
}

$csv = Join-Path $outRoot "matrix.csv"
$rows | Export-Csv -NoTypeInformation -Encoding utf8 -Path $csv

Write-Host "Gate matrix written to: $csv"

$hasFailure = $false
foreach ($r in $rows) {
    if ($r.json -eq "FAIL" -or $r.semantic -eq "FAIL" -or $r.ast_run -eq "FAIL" -or $r.mir_run -eq "FAIL") { $hasFailure = $true }
    # For 82 expect x64_build to be FAIL
    if ($r.name -like "82_*") {
        if ($r.x64_build -eq "OK") { $hasFailure = $true }
    } else {
        if ($r.x64_build -eq "FAIL") { $hasFailure = $true }
    }
}

if ($hasFailure) { exit 1 }
exit 0
