param(
    [string]$OutJson = "reports/system_health_report.json",
    [switch]$SkipBuild,
    [switch]$FailFast
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$fbc = "tools/FreeBASIC-1.10.1-win64/fbc.exe"
$mainExe = "src/main_64.exe"
$validateDir = "dist/validate_all"
$smokeSourcePath = "$validateDir/health_smoke.uxb"

function Format-TrimmedOutput {
    param([string]$Text)
    if ($null -eq $Text) { return "" }
    $s = $Text.Trim()
    if ($s.Length -le 4000) { return $s }
    return "...<trimmed>..." + [Environment]::NewLine + $s.Substring($s.Length - 4000)
}

function Invoke-ExternalStep {
    param(
        [string]$Layer,
        [string]$Name,
        [scriptblock]$Action,
        [string[]]$Artifacts = @()
    )

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $output = ""
    $exitCode = 0

    try {
        $global:LASTEXITCODE = 0
        $output = (& $Action 2>&1 | Out-String)
        if ($null -ne $LASTEXITCODE) {
            $exitCode = [int]$LASTEXITCODE
        } elseif ($?) {
            $exitCode = 0
        } else {
            $exitCode = 1
        }
    } catch {
        $exitCode = 1
        $output = ($output + [Environment]::NewLine + ($_ | Out-String))
    }

    $sw.Stop()

    return [PSCustomObject]@{
        layer = $Layer
        name = $Name
        status = $(if ($exitCode -eq 0) { "PASS" } else { "FAIL" })
        exitCode = $exitCode
        durationMs = [int]$sw.ElapsedMilliseconds
        output = (Format-TrimmedOutput $output)
        artifacts = $Artifacts
    }
}

function Invoke-BasTest {
    param(
        [string]$Layer,
        [string]$TestBase
    )

    $results = New-Object System.Collections.Generic.List[object]
    $src = "tests/$TestBase.bas"
    $exe = "tests/${TestBase}_64.exe"

    if (-not (Test-Path $src)) {
        $results.Add([PSCustomObject]@{
            layer = $Layer
            name = "$TestBase source"
            status = "FAIL"
            exitCode = 1
            durationMs = 0
            output = "missing source: $src"
            artifacts = @($src)
        })
        return $results
    }

    if ((-not $SkipBuild) -or (-not (Test-Path $exe))) {
        $buildResult = Invoke-ExternalStep -Layer $Layer -Name "$TestBase build" -Artifacts @($src, $exe) -Action {
            & $fbc -lang fb -arch x86_64 $src -x $exe
        }
        $results.Add($buildResult)
        if ($buildResult.status -ne "PASS") {
            return $results
        }
    }

    if (-not (Test-Path $exe)) {
        $results.Add([PSCustomObject]@{
            layer = $Layer
            name = "$TestBase run"
            status = "FAIL"
            exitCode = 1
            durationMs = 0
            output = "missing executable: $exe"
            artifacts = @($exe)
        })
        return $results
    }

    $runResult = Invoke-ExternalStep -Layer $Layer -Name "$TestBase run" -Artifacts @($exe) -Action {
        & "./$exe"
    }
    $results.Add($runResult)

    return $results
}

$checks = New-Object System.Collections.Generic.List[object]
$gateStarted = Get-Date

$checks.Add((Invoke-ExternalStep -Layer "INFRA" -Name "main_exe_ready" -Artifacts @("src/main.bas", $mainExe) -Action {
    if (-not $SkipBuild) {
        cmd /c build_64.bat src\main.bas
    }

    if (-not (Test-Path $mainExe)) {
        Write-Error "missing main executable: $mainExe"
        $global:LASTEXITCODE = 1
        return
    }

    Write-Output "main executable ready: $mainExe"
    $global:LASTEXITCODE = 0
}))

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $checks.Add((Invoke-ExternalStep -Layer "INFRA" -Name "prepare_validate_smoke_source" -Artifacts @($smokeSourcePath) -Action {
        New-Item -ItemType Directory -Force -Path $validateDir | Out-Null
        $smokeText = @"
a = 1
b = a + 2
PRINT b
"@
        $smokeText | Set-Content -Path $smokeSourcePath -Encoding Ascii
        Write-Output "smoke source written: $smokeSourcePath"
        $global:LASTEXITCODE = 0
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $checks.Add((Invoke-ExternalStep -Layer "AST" -Name "main_exec_ast_smoke" -Artifacts @($smokeSourcePath) -Action {
        & "./$mainExe" $smokeSourcePath "--execmem" "--interpreter-backend" "AST"
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $checks.Add((Invoke-ExternalStep -Layer "AST" -Name "run_if_exec_ast_harness" -Artifacts @("tests/run_if_exec_ast.bas", "tests/run_if_exec_ast_64.exe") -Action {
        & $fbc -lang fb -arch x86_64 "tests/run_if_exec_ast.bas" -x "tests/run_if_exec_ast_64.exe"
        if ($LASTEXITCODE -ne 0) { return }
        & "./tests/run_if_exec_ast_64.exe"
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $checks.Add((Invoke-ExternalStep -Layer "MIR" -Name "main_exec_mir_smoke" -Artifacts @($smokeSourcePath) -Action {
        & "./$mainExe" $smokeSourcePath "--execmem" "--interpreter-backend" "MIR"
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $mirSurfacePath = "dist/validate_all/mir_surface.json"
    $checks.Add((Invoke-ExternalStep -Layer "MIR" -Name "main_exec_mir_surface" -Artifacts @($smokeSourcePath, $mirSurfacePath) -Action {
        New-Item -ItemType Directory -Force -Path $validateDir | Out-Null
        & "./$mainExe" $smokeSourcePath "--execmem" "--interpreter-backend" "MIR" "--mir-opcodes-json-out" $mirSurfacePath
    }))

    if ((Test-Path $mirSurfacePath) -and (($checks[-1]).status -eq "PASS")) {
        $checks.Add((Invoke-ExternalStep -Layer "MIR" -Name "mir_surface_contains_float_ops" -Artifacts @($mirSurfacePath) -Action {
            $txt = Get-Content $mirSurfacePath -Raw
            if ($txt -notmatch '"FADD"' -or $txt -notmatch '"FDIV"' -or $txt -notmatch '"FNEG"') {
                Write-Error "MIR surface is missing expected float opcodes"
                $global:LASTEXITCODE = 1
                return
            }
            Write-Output "MIR float opcodes present"
            $global:LASTEXITCODE = 0
        }))
    }
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    foreach ($r in (Invoke-BasTest -Layer "MIR" -TestBase "run_memory_exec_mir")) {
        $checks.Add($r)
    }
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    foreach ($r in (Invoke-BasTest -Layer "NATIVE" -TestBase "run_x64_codegen_emit")) {
        $checks.Add($r)
    }
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    foreach ($r in (Invoke-BasTest -Layer "NATIVE" -TestBase "run_x64_codegen_memory_emit")) {
        $checks.Add($r)
    }
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    foreach ($r in (Invoke-BasTest -Layer "NATIVE" -TestBase "run_x64_codegen_operator_numeric_emit")) {
        $checks.Add($r)
    }
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $astOutDir = "dist/validate_all/native_ast"
    $astProgramPath = Join-Path $astOutDir "program.exe"
    $checks.Add((Invoke-ExternalStep -Layer "NATIVE" -Name "main_build_x64_ast_route" -Artifacts @($smokeSourcePath, $astOutDir) -Action {
        New-Item -ItemType Directory -Force -Path $astOutDir | Out-Null
        & "./$mainExe" $smokeSourcePath "--build-x64" "--codegen-source" "AST" "--build-x64-out" $astOutDir
    }))

    $checks.Add((Invoke-ExternalStep -Layer "NATIVE" -Name "main_run_x64_ast_route" -Artifacts @($astProgramPath) -Action {
        if (-not (Test-Path $astProgramPath)) {
            Write-Error "missing native AST artifact: $astProgramPath"
            $global:LASTEXITCODE = 1
            return
        }
        & $astProgramPath
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $mirOutDir = "dist/validate_all/native_mir"
    $mirProgramPath = Join-Path $mirOutDir "program.exe"
    $checks.Add((Invoke-ExternalStep -Layer "NATIVE" -Name "main_build_x64_mir_route" -Artifacts @($smokeSourcePath, $mirOutDir) -Action {
        New-Item -ItemType Directory -Force -Path $mirOutDir | Out-Null
        & "./$mainExe" $smokeSourcePath "--build-x64" "--codegen-source" "MIR" "--build-x64-out" $mirOutDir
    }))

    $checks.Add((Invoke-ExternalStep -Layer "NATIVE" -Name "main_run_x64_mir_route" -Artifacts @($mirProgramPath) -Action {
        if (-not (Test-Path $mirProgramPath)) {
            Write-Error "missing native MIR artifact: $mirProgramPath"
            $global:LASTEXITCODE = 1
            return
        }
        & $mirProgramPath
    }))
}

if (-not $FailFast -or $checks[-1].status -eq "PASS") {
    $checks.Add((Invoke-ExternalStep -Layer "NATIVE" -Name "err_codegen_parity_gate" -Artifacts @("reports/err_codegen_parity_gate_report.md") -Action {
        & "./tools/run_err_codegen_parity_gate.ps1" -OutReport "reports/err_codegen_parity_gate_report.md"
    }))
}

$layerSummaries = @()
$grouped = $checks | Group-Object layer
foreach ($g in $grouped) {
    $total = [int]$g.Count
    $passed = @($g.Group | Where-Object { $_.status -eq "PASS" }).Count
    $failed = $total - $passed
    $layerSummaries += [PSCustomObject]@{
        layer = $g.Name
        status = $(if ($failed -eq 0) { "PASS" } else { "FAIL" })
        total = $total
        passed = $passed
        failed = $failed
    }
}

$totalChecks = $checks.Count
$passedChecks = ($checks | Where-Object { $_.status -eq "PASS" }).Count
$failedChecks = $totalChecks - $passedChecks
$overall = if ($failedChecks -eq 0) { "PASS" } else { "FAIL" }

$report = [PSCustomObject]@{
    schema = "uxbasic-system-health-v1"
    command = "--validate-all"
    generatedAtUtc = (Get-Date).ToUniversalTime().ToString("o")
    host = $env:COMPUTERNAME
    repoRoot = $repoRoot
    overall = $overall
    summary = [PSCustomObject]@{
        totalChecks = $totalChecks
        passedChecks = $passedChecks
        failedChecks = $failedChecks
        elapsedMs = [int]((Get-Date) - $gateStarted).TotalMilliseconds
    }
    layers = $layerSummaries
    checks = $checks
}

$outPath = if ([System.IO.Path]::IsPathRooted($OutJson)) {
    $OutJson
} else {
    Join-Path $repoRoot $OutJson
}

$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$report | ConvertTo-Json -Depth 8 | Set-Content -Path $outPath -Encoding UTF8
Write-Host "[DONE] System health report written: $outPath"
Write-Host "[RESULT] overall=$overall passed=$passedChecks failed=$failedChecks"

if ($overall -ne "PASS") {
    exit 1
}

exit 0
