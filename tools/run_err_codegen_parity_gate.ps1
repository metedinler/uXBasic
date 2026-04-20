param(
    [string]$OutReport = "reports/err_codegen_parity_gate_report.md"
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$fbc = "tools/FreeBASIC-1.10.1-win64/fbc.exe"

$targets = @(
    @{ lane = "err_semantic_pass"; src = "tests/run_err_semantic_pass.bas"; exe = "tests/run_err_semantic_pass_64.exe" },
    @{ lane = "err_mir_lowering"; src = "tests/run_err_mir_lowering.bas"; exe = "tests/run_err_mir_lowering_64.exe" },
    @{ lane = "err_backend_hooks"; src = "tests/run_err_backend_hooks.bas"; exe = "tests/run_err_backend_hooks_64.exe" },
    @{ lane = "err_codegen_parity_gate"; src = "tests/run_err_codegen_parity_gate.bas"; exe = "tests/run_err_codegen_parity_gate_64.exe" }
)

$rows = @()
$allPass = $true

foreach ($t in $targets) {
    $buildState = "PASS"
    $runState = "PASS"
    $note = ""
    $buildOutput = ""

    if (Test-Path $t.src) {
        $buildOutput = & $fbc -lang fb -arch x86_64 $t.src -x $t.exe 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) {
            $rows += [PSCustomObject]@{
                lane = $t.lane
                build = "FAIL"
                run = "SKIP"
                note = "source compile failed"
                buildOutput = $buildOutput.Trim()
                runOutput = ""
            }
            $allPass = $false
            continue
        }
    } elseif (-not (Test-Path $t.exe)) {
        $rows += [PSCustomObject]@{
            lane = $t.lane
            build = "BLOCKED"
            run = "SKIP"
            note = "missing source and executable"
            buildOutput = ""
            runOutput = ""
        }
        $allPass = $false
        continue
    } else {
        $buildState = "N/A"
        $note = "used prebuilt executable"
    }

    $runOutput = & $t.exe 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        $runState = "FAIL"
        if ($note -eq "") { $note = "runtime failed" }
        $allPass = $false
    } elseif ($note -eq "") {
        $note = "runtime parity lane passed"
    }

    $rows += [PSCustomObject]@{
        lane = $t.lane
        build = $buildState
        run = $runState
        note = $note
        buildOutput = $buildOutput.Trim()
        runOutput = $runOutput.Trim()
    }
}

$reportLines = New-Object System.Collections.Generic.List[string]
$reportLines.Add("# ERR Codegen Parity Gate Report")
$reportLines.Add("")
$reportLines.Add("- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$reportLines.Add("- Host: $env:COMPUTERNAME")
$reportLines.Add("")
$reportLines.Add("| lane | build | run | note |")
$reportLines.Add("|---|---|---|---|")

foreach ($r in $rows) {
    $reportLines.Add("| $($r.lane) | $($r.build) | $($r.run) | $($r.note) |")
}

foreach ($r in $rows) {
    $reportLines.Add("")
    $reportLines.Add("## $($r.lane)")
    $reportLines.Add("")
    $reportLines.Add("### build output")
    $reportLines.Add('```text')
    $reportLines.Add($r.buildOutput)
    $reportLines.Add('```')
    $reportLines.Add("")
    $reportLines.Add("### run output")
    $reportLines.Add('```text')
    $reportLines.Add($r.runOutput)
    $reportLines.Add('```')
}

$outPath = if ([System.IO.Path]::IsPathRooted($OutReport)) { $OutReport } else { Join-Path $repoRoot $OutReport }
$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$reportLines | Set-Content -Path $outPath -Encoding UTF8
Write-Host "[DONE] Report written: $outPath"

if (-not $allPass) {
    exit 1
}

Write-Output "ERR_CODEGEN_PARITY_GATE_OK"
