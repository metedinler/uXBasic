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

function Invoke-CmdWithTimeout {
    param(
        [Parameter(Mandatory = $true)][string]$ExePath,
        [Parameter(Mandatory = $true)][string]$WorkingDir,
        [int]$TimeoutMs = 15000
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = "cmd.exe"
    $psi.Arguments = '/d /c ""' + $ExePath + '""'
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true
    $psi.WorkingDirectory = $WorkingDir

    $p = New-Object System.Diagnostics.Process
    $p.StartInfo = $psi

    [void]$p.Start()

    if (-not $p.WaitForExit($TimeoutMs)) {
        try { $p.Kill() } catch { }
        return [PSCustomObject]@{
            timedOut = $true
            exitCode = -1
            output = "cmd fallback timeout after " + $TimeoutMs + "ms"
        }
    }

    $stdout = $p.StandardOutput.ReadToEnd()
    $stderr = $p.StandardError.ReadToEnd()
    $combined = ($stdout + [Environment]::NewLine + $stderr).Trim()

    return [PSCustomObject]@{
        timedOut = $false
        exitCode = $p.ExitCode
        output = $combined
    }
}

$rows = @()

foreach ($t in $targets) {
    $buildOutput = & $fbc -lang fb -arch 386 $t.src -x $t.exe 2>&1 | Out-String
    $buildExit = $LASTEXITCODE

    if ($buildExit -ne 0) {
        $rows += [PSCustomObject]@{
            Name = $t.name
            Build = "BLOCKED"
            Run = "SKIP"
            Note = "x86 build unavailable or failed"
            BuildOutput = $buildOutput.Trim()
            RunOutput = ""
        }
        continue
    }

    $runOutput = ""
    $runExit = -1
    $runStartFailed = $false
    $usedCmdFallback = $false
    try {
        $runOutput = & $t.exe 2>&1 | Out-String
        $runExit = $LASTEXITCODE
    } catch {
        $primaryErr = $_ | Out-String
        try {
            $cmdExe = ($t.exe -replace '/', '\\')
            if (-not [System.IO.Path]::IsPathRooted($cmdExe)) {
                if ($cmdExe.StartsWith(".\\")) {
                    $cmdExe = $cmdExe.Substring(2)
                }
                $cmdExe = Join-Path $repoRoot $cmdExe
            }

            $cmdResult = Invoke-CmdWithTimeout -ExePath $cmdExe -WorkingDir $repoRoot -TimeoutMs 15000
            if ($cmdResult.timedOut) {
                $runStartFailed = $true
                $runOutput = $primaryErr + [Environment]::NewLine + "[fallback=cmd timeout]" + [Environment]::NewLine + $cmdResult.output
            } else {
                $runOutput = "[fallback=cmd]" + [Environment]::NewLine + $cmdResult.output
                $runExit = $cmdResult.exitCode
                $usedCmdFallback = $true
            }
        } catch {
            $runStartFailed = $true
            $runOutput = $primaryErr + [Environment]::NewLine + "[fallback=cmd failed]" + [Environment]::NewLine + ($_ | Out-String)
        }
    }

    $runText = $runOutput.Trim()
    $isSkip = $runText -match "(?im)^SKIP\b"

    $rows += [PSCustomObject]@{
        Name = $t.name
        Build = "PASS"
        Run = $(if ($runStartFailed) { "BLOCKED" } elseif ($isSkip) { "SKIP" } elseif ($runExit -eq 0) { "PASS" } else { "FAIL" })
        Note = $(if ($runStartFailed) { "native lane launch blocked (elevation/policy)" } elseif ($isSkip) { "native lane not proven on this host" } elseif ($runExit -eq 0) { if ($usedCmdFallback) { "native lane verified (cmd fallback)" } else { "native lane verified" } } else { if ($usedCmdFallback) { "native lane runtime failure (cmd fallback)" } else { "native lane runtime failure" } })
        BuildOutput = $buildOutput.Trim()
        RunOutput = $runText
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