param(
    [string[]]$Executables = @(),
    [int]$Repeat = 5,
    [int]$TimeoutSeconds = 30,
    [string]$OutputCsv = "reports/runtime_memory_benchmark.csv",
    [switch]$UseAllRunExe,
    [switch]$FailOnError
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

if ($Repeat -lt 1) {
    throw "Repeat must be >= 1."
}

if ($TimeoutSeconds -lt 1) {
    throw "TimeoutSeconds must be >= 1."
}

function Resolve-ExecutablePath {
    param([string]$PathValue)

    $candidate = $PathValue
    if (-not [System.IO.Path]::IsPathRooted($candidate)) {
        $candidate = Join-Path $repoRoot $candidate
    }

    if (-not (Test-Path -LiteralPath $candidate -PathType Leaf)) {
        throw "Executable not found: $PathValue"
    }

    return (Resolve-Path -LiteralPath $candidate).Path
}

function Get-ExecutableTargets {
    $normalizedExecutables = @()
    foreach ($item in $Executables) {
        if ([string]::IsNullOrWhiteSpace($item)) {
            continue
        }

        foreach ($part in ($item -split ',')) {
            $trimmed = $part.Trim()
            if (-not [string]::IsNullOrWhiteSpace($trimmed)) {
                $normalizedExecutables += $trimmed
            }
        }
    }

    if ($normalizedExecutables.Count -gt 0) {
        $resolved = foreach ($item in $normalizedExecutables) {
            $fullPath = Resolve-ExecutablePath -PathValue $item
            Get-Item -LiteralPath $fullPath
        }
        return $resolved | Sort-Object FullName -Unique
    }

    $testsDir = Join-Path $repoRoot 'tests'
    if (-not (Test-Path -LiteralPath $testsDir -PathType Container)) {
        throw "Tests directory not found: $testsDir"
    }

    if ($UseAllRunExe) {
        $targets = Get-ChildItem -LiteralPath $testsDir -File -Filter 'run_*.exe' |
            Where-Object { $_.Name -notlike 'tmp_*' }
    } else {
        $targets = Get-ChildItem -LiteralPath $testsDir -File -Filter 'run_*_64.exe' |
            Where-Object { $_.Name -notlike 'tmp_*' }

        if ($targets.Count -eq 0) {
            $targets = Get-ChildItem -LiteralPath $testsDir -File -Filter 'run_*.exe' |
                Where-Object { $_.Name -notlike 'tmp_*' }
        }
    }

    if ($targets.Count -eq 0) {
        throw "No executable targets found. Build test executables first or pass -Executables explicitly."
    }

    return $targets | Sort-Object Name
}

function Get-PercentileValue {
    param(
        [double[]]$Values,
        [double]$Percentile
    )

    if ($null -eq $Values -or $Values.Count -eq 0) {
        return $null
    }

    $sorted = $Values | Sort-Object
    if ($sorted.Count -eq 1) {
        return [double]$sorted[0]
    }

    $index = [Math]::Ceiling(($Percentile / 100.0) * $sorted.Count) - 1
    if ($index -lt 0) { $index = 0 }
    if ($index -ge $sorted.Count) { $index = $sorted.Count - 1 }

    return [double]$sorted[$index]
}

function Update-Peaks {
    param(
        [System.Diagnostics.Process]$Process,
        [ref]$PeakWorkingSet,
        [ref]$PeakPrivateBytes
    )

    try {
        $Process.Refresh()
        $ws = [int64]$Process.WorkingSet64
        $pb = [int64]$Process.PrivateMemorySize64

        if ($ws -gt [int64]$PeakWorkingSet.Value) {
            $PeakWorkingSet.Value = $ws
        }

        if ($pb -gt [int64]$PeakPrivateBytes.Value) {
            $PeakPrivateBytes.Value = $pb
        }
    } catch {
        # ignore transient refresh/read failures
    }
}

$sampleIntervalMs = 25
$targets = Get-ExecutableTargets
$summaryRows = @()
$runRows = @()

Write-Host "[INFO] Targets: $($targets.Count), Repeat: $Repeat, TimeoutSeconds: $TimeoutSeconds, SampleIntervalMs: $sampleIntervalMs"

foreach ($target in $targets) {
    Write-Host "[TARGET] $($target.Name)"

    $allWorkingSetPeaksMb = @()
    $allPrivatePeaksMb = @()
    $allDurations = @()

    $passWorkingSetPeaksMb = @()
    $passPrivatePeaksMb = @()
    $passDurations = @()

    $successRuns = 0
    $failedRuns = 0
    $timeoutRuns = 0

    for ($runIndex = 1; $runIndex -le $Repeat; $runIndex++) {
        $peakWorkingSet = 0L
        $peakPrivateBytes = 0L

        $proc = Start-Process -FilePath $target.FullName -WorkingDirectory $repoRoot -NoNewWindow -PassThru
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $timedOut = $false

        # Sample process memory until exit or timeout to capture realistic peaks.
        Update-Peaks -Process $proc -PeakWorkingSet ([ref]$peakWorkingSet) -PeakPrivateBytes ([ref]$peakPrivateBytes)
        while (-not $proc.HasExited) {
            Update-Peaks -Process $proc -PeakWorkingSet ([ref]$peakWorkingSet) -PeakPrivateBytes ([ref]$peakPrivateBytes)

            if ($sw.Elapsed.TotalSeconds -ge $TimeoutSeconds) {
                $timedOut = $true
                try {
                    $proc.Kill()
                } catch {
                    # ignore cleanup failures
                }
                break
            }

            Start-Sleep -Milliseconds $sampleIntervalMs
        }

        try {
            $proc.WaitForExit(1000) | Out-Null
        } catch {
            # ignore wait failures
        }

        Update-Peaks -Process $proc -PeakWorkingSet ([ref]$peakWorkingSet) -PeakPrivateBytes ([ref]$peakPrivateBytes)

        $sw.Stop()
        $elapsedMs = [Math]::Round($sw.Elapsed.TotalMilliseconds, 3)
        $peakWorkingSetMb = [Math]::Round(($peakWorkingSet / 1MB), 3)
        $peakPrivateBytesMb = [Math]::Round(($peakPrivateBytes / 1MB), 3)

        $allWorkingSetPeaksMb += [double]$peakWorkingSetMb
        $allPrivatePeaksMb += [double]$peakPrivateBytesMb
        $allDurations += [double]$elapsedMs

        if ($timedOut) {
            $status = 'timeout'
            $exitCode = 124
            $timeoutRuns++
            $failedRuns++
        } else {
            $exitCode = [int]$proc.ExitCode
            if ($exitCode -eq 0) {
                $status = 'pass'
                $successRuns++
                $passWorkingSetPeaksMb += [double]$peakWorkingSetMb
                $passPrivatePeaksMb += [double]$peakPrivateBytesMb
                $passDurations += [double]$elapsedMs
            } else {
                $status = 'fail'
                $failedRuns++
            }
        }

        Write-Host ("  [RUN {0}/{1}] status={2} exit={3} duration_ms={4} peak_ws_mb={5} peak_private_mb={6}" -f $runIndex, $Repeat, $status, $exitCode, $elapsedMs, $peakWorkingSetMb, $peakPrivateBytesMb)

        $runRows += [pscustomobject]@{
            executable              = $target.Name
            executable_path         = $target.FullName
            run_index               = $runIndex
            status                  = $status
            exit_code               = $exitCode
            duration_ms             = $elapsedMs
            peak_working_set_bytes  = $peakWorkingSet
            peak_private_bytes      = $peakPrivateBytes
            peak_working_set_mb     = $peakWorkingSetMb
            peak_private_memory_mb  = $peakPrivateBytesMb
            timeout_seconds         = $TimeoutSeconds
            sample_interval_ms      = $sampleIntervalMs
        }
    }

    $wsSource = if ($passWorkingSetPeaksMb.Count -gt 0) { $passWorkingSetPeaksMb } else { $allWorkingSetPeaksMb }
    $privateSource = if ($passPrivatePeaksMb.Count -gt 0) { $passPrivatePeaksMb } else { $allPrivatePeaksMb }
    $durationSource = if ($passDurations.Count -gt 0) { $passDurations } else { $allDurations }

    $summaryRows += [pscustomobject]@{
        executable                   = $target.Name
        repeats                      = $Repeat
        success_runs                 = $successRuns
        failed_runs                  = $failedRuns
        timeout_runs                 = $timeoutRuns
        min_peak_working_set_mb      = if ($wsSource.Count -gt 0) { [Math]::Round(($wsSource | Measure-Object -Minimum).Minimum, 3) } else { $null }
        avg_peak_working_set_mb      = if ($wsSource.Count -gt 0) { [Math]::Round(($wsSource | Measure-Object -Average).Average, 3) } else { $null }
        p95_peak_working_set_mb      = if ($wsSource.Count -gt 0) { [Math]::Round((Get-PercentileValue -Values $wsSource -Percentile 95), 3) } else { $null }
        max_peak_working_set_mb      = if ($wsSource.Count -gt 0) { [Math]::Round(($wsSource | Measure-Object -Maximum).Maximum, 3) } else { $null }
        min_peak_private_memory_mb   = if ($privateSource.Count -gt 0) { [Math]::Round(($privateSource | Measure-Object -Minimum).Minimum, 3) } else { $null }
        avg_peak_private_memory_mb   = if ($privateSource.Count -gt 0) { [Math]::Round(($privateSource | Measure-Object -Average).Average, 3) } else { $null }
        p95_peak_private_memory_mb   = if ($privateSource.Count -gt 0) { [Math]::Round((Get-PercentileValue -Values $privateSource -Percentile 95), 3) } else { $null }
        max_peak_private_memory_mb   = if ($privateSource.Count -gt 0) { [Math]::Round(($privateSource | Measure-Object -Maximum).Maximum, 3) } else { $null }
        min_duration_ms              = if ($durationSource.Count -gt 0) { [Math]::Round(($durationSource | Measure-Object -Minimum).Minimum, 3) } else { $null }
        avg_duration_ms              = if ($durationSource.Count -gt 0) { [Math]::Round(($durationSource | Measure-Object -Average).Average, 3) } else { $null }
        p95_duration_ms              = if ($durationSource.Count -gt 0) { [Math]::Round((Get-PercentileValue -Values $durationSource -Percentile 95), 3) } else { $null }
        max_duration_ms              = if ($durationSource.Count -gt 0) { [Math]::Round(($durationSource | Measure-Object -Maximum).Maximum, 3) } else { $null }
        total_duration_ms            = if ($allDurations.Count -gt 0) { [Math]::Round(($allDurations | Measure-Object -Sum).Sum, 3) } else { $null }
    }
}

$outputPath = if ([System.IO.Path]::IsPathRooted($OutputCsv)) {
    $OutputCsv
} else {
    Join-Path $repoRoot $OutputCsv
}

$outputDir = Split-Path -Parent $outputPath
if (-not (Test-Path -LiteralPath $outputDir -PathType Container)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

$runOutputPath = Join-Path $outputDir ("{0}.runs.csv" -f [System.IO.Path]::GetFileNameWithoutExtension($outputPath))

$summaryRows | Export-Csv -LiteralPath $outputPath -NoTypeInformation -Encoding UTF8
$runRows | Export-Csv -LiteralPath $runOutputPath -NoTypeInformation -Encoding UTF8

Write-Host "[SUMMARY]"
$summaryRows | Sort-Object executable | Format-Table executable, success_runs, failed_runs, timeout_runs, avg_peak_working_set_mb, avg_peak_private_memory_mb, avg_duration_ms -AutoSize
Write-Host "[WRITE] summary=$outputPath"
Write-Host "[WRITE] runs=$runOutputPath"

$hasRunErrors = ($summaryRows | Where-Object { $_.failed_runs -gt 0 -or $_.timeout_runs -gt 0 }).Count -gt 0
if ($hasRunErrors -and $FailOnError) {
    Write-Host "[FAIL] One or more runs failed or timed out."
    exit 1
}

exit 0