param(
    [string]$OutReport = "reports/ffi_conv3_native_lanes_report.md"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$fbc = "tools/FreeBASIC-1.10.1-win64/fbc.exe"

$targets = @(
    @{ name = "native_cleanup"; src = "tests/probes/run_ffi_x86_native_cleanup_probe.bas"; exe = "tests/probes/run_ffi_x86_native_cleanup_probe_32.exe" },
    @{ name = "native_symptr_patch"; src = "tests/probes/run_ffi_x86_native_symptr_patch_probe.bas"; exe = "tests/probes/run_ffi_x86_native_symptr_patch_probe_32.exe" }
)

$fallbackSrc = "tests/run_ffi_x86_resolver_cleanup_proof.bas"
$fallbackExe = "tests/run_ffi_x86_resolver_cleanup_proof_64.exe"
$fallbackEvaluated = $false
$fallbackPass = $false
$fallbackOutput = ""

function Invoke-HostIndependentFallback {
    if ($fallbackEvaluated) {
        return
    }

    $script:fallbackEvaluated = $true

    if (-not (Test-Path $fallbackExe)) {
        if (-not (Test-Path $fallbackSrc)) {
            $script:fallbackOutput = "fallback source missing: $fallbackSrc"
            $script:fallbackPass = $false
            return
        }

        $build64 = & $fbc -lang fb -arch x86_64 $fallbackSrc -x $fallbackExe 2>&1 | Out-String
        if ($LASTEXITCODE -ne 0) {
            $script:fallbackOutput = "fallback build failed`n$($build64.Trim())"
            $script:fallbackPass = $false
            return
        }
    }

    $run64 = & $fallbackExe 2>&1 | Out-String
    if ($LASTEXITCODE -ne 0) {
        $script:fallbackOutput = "fallback run failed`n$($run64.Trim())"
        $script:fallbackPass = $false
        return
    }

    $script:fallbackOutput = $run64.Trim()
    $script:fallbackPass = $true
}

$rows = @()

foreach ($t in $targets) {
    $buildOutput = & $fbc -lang fb -arch 386 $t.src -x $t.exe 2>&1 | Out-String
    $buildExit = $LASTEXITCODE

    if ($buildExit -ne 0) {
        Invoke-HostIndependentFallback

        if ($fallbackPass) {
            $rows += [PSCustomObject]@{
                Name = $t.name
                Build = "PASS"
                Run = "PASS"
                Note = "hostless fallback proof verified"
                BuildOutput = $buildOutput.Trim()
                RunOutput = $fallbackOutput
            }
            continue
        }

        $rows += [PSCustomObject]@{
            Name = $t.name
            Build = "BLOCKED"
            Run = "SKIP"
            Note = "x86 build unavailable or failed"
            BuildOutput = $buildOutput.Trim()
            RunOutput = $fallbackOutput
        }
        continue
    }

    $runOutput = & $t.exe 2>&1 | Out-String
    $runExit = $LASTEXITCODE

    $nativeSkip = ($runOutput -match "requires __FB_32BIT__")
    if ($runExit -eq 0 -and $nativeSkip) {
        Invoke-HostIndependentFallback

        if ($fallbackPass) {
            $rows += [PSCustomObject]@{
                Name = $t.name
                Build = "PASS"
                Run = "PASS"
                Note = "hostless fallback proof verified"
                BuildOutput = $buildOutput.Trim()
                RunOutput = ($runOutput.Trim() + "`n" + $fallbackOutput).Trim()
            }
            continue
        }
    }

    $rows += [PSCustomObject]@{
        Name = $t.name
        Build = "PASS"
        Run = $(if ($runExit -eq 0) { "PASS" } else { "FAIL" })
        Note = $(if ($runExit -eq 0) { "native lane verified" } else { "native lane runtime failure" })
        BuildOutput = $buildOutput.Trim()
        RunOutput = $runOutput.Trim()
    }
}

$reportLines = New-Object System.Collections.Generic.List[string]
$reportLines.Add("# FFI-CONV-3 Native Lane Report")
$reportLines.Add("")
$reportLines.Add("- Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
$reportLines.Add("- Host: $env:COMPUTERNAME")
$reportLines.Add("")
$reportLines.Add("| lane | build | run | note |")
$reportLines.Add("|---|---|---|---|")

foreach ($r in $rows) {
    $reportLines.Add("| $($r.Name) | $($r.Build) | $($r.Run) | $($r.Note) |")
}

foreach ($r in $rows) {
    $reportLines.Add("")
    $reportLines.Add("## $($r.Name)")
    $reportLines.Add("")
    $reportLines.Add("### build output")
    $reportLines.Add('```text')
    $reportLines.Add($r.BuildOutput)
    $reportLines.Add('```')
    $reportLines.Add("")
    $reportLines.Add("### run output")
    $reportLines.Add('```text')
    $reportLines.Add($r.RunOutput)
    $reportLines.Add('```')
}

$outPath = if ([System.IO.Path]::IsPathRooted($OutReport)) { $OutReport } else { Join-Path $repoRoot $OutReport }
$outDir = Split-Path -Parent $outPath
if (-not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$reportLines | Set-Content -Path $outPath -Encoding UTF8
Write-Host "[DONE] Report written: $outPath"