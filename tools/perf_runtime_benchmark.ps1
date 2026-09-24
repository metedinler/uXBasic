param(
    [string[]]$Executables = @(),
    [int]$Repeat = 5,
    [int]$TimeoutSeconds = 30,
    [string]$OutputCsv = "reports/runtime_perf_benchmark.csv",
    [switch]$UseAllRunExe,
    [switch]$FailOnError
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$invariantCulture = [System.Globalization.CultureInfo]::InvariantCulture
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

function Convert-ToInvariantNumberString {
    param(
        [AllowNull()]$Value,
        [string]$Format = '0.000'
    )

    if ($null -eq $Value) {
        return $null
    }

    try {
        $numericValue = [double]$Value
    } catch {
        return $null
    }

    return $numericValue.ToString($Format, $invariantCulture)
}

function Get-CompactErrorMessage {
    param(
        [System.Management.Automation.ErrorRecord]$ErrorRecord
    )

    if ($null -eq $ErrorRecord) {
        return $null
    }

    $message = $ErrorRecord.Exception.Message
    if ([string]::IsNullOrWhiteSpace($message)) {
        $message = $ErrorRecord.ToString()
    }

    return ($message -replace "\r?\n", ' ').Trim()
}

$targets = Get-ExecutableTargets
$summaryRows = @()
$runRows = @()

Write-Host "[INFO] Targets: $($targets.Count), Repeat: $Repeat, TimeoutSeconds: $TimeoutSeconds"

foreach ($target in $targets) {
    Write-Host "[TARGET] $($target.Name)"

    if (-not (Test-Path -LiteralPath $target.FullName -PathType Leaf)) {
        throw "Target disappeared during benchmark run: $($target.FullName)"
    }

    if ($target.Length -le 0) {
        Write-Warning "Target file is empty and may fail to execute: $($target.FullName)"
    }

    $passDurations = @()
    $allDurations = @()
    $successRuns = 0
    $failedRuns = 0
    $timeoutRuns = 0

    for ($runIndex = 1; $runIndex -le $Repeat; $runIndex++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $proc = $null
        $timedOut = $false
        $exitCode = -1
        $status = 'fail'
        $failureReason = $null

        try {
            $proc = Start-Process -FilePath $target.FullName -WorkingDirectory $repoRoot -NoNewWindow -PassThru -ErrorAction Stop
            $timedOut = -not $proc.WaitForExit($TimeoutSeconds * 1000)

            if ($timedOut) {
                $timeoutRuns++
                $exitCode = 124
                $status = 'timeout'
                $failureReason = "timeout after ${TimeoutSeconds}s"
            } else {
                $exitCode = [int]$proc.ExitCode
                if ($exitCode -eq 0) {
                    $status = 'pass'
                } else {
                    $status = 'fail'
                    $failureReason = "process exit code $exitCode"
                }
            }
        } catch {
            $exitCode = 125
            $status = 'fail'
            $failureReason = "process launch/wait error: $(Get-CompactErrorMessage -ErrorRecord $_)"
        } finally {
            if ($null -ne $proc) {
                try {
                    if (-not $proc.HasExited) {
                        try {
                            $proc.Kill()
                            $proc.WaitForExit(1000) | Out-Null
                        } catch {
                            # ignore cleanup failures
                        }
                    }
                } catch {
                    # ignore process state query failures
                }

                try {
                    $proc.Dispose()
                } catch {
                    # ignore dispose failures
                }
            }
        }

        $sw.Stop()
        $elapsedMs = [Math]::Round($sw.Elapsed.TotalMilliseconds, 3)
        $allDurations += [double]$elapsedMs

        if ($status -eq 'pass') {
            $successRuns++
            $passDurations += [double]$elapsedMs
        } else {
            $failedRuns++
        }

        $elapsedText = Convert-ToInvariantNumberString -Value $elapsedMs
        Write-Host ("  [RUN {0}/{1}] status={2} exit={3} duration_ms={4}" -f $runIndex, $Repeat, $status, $exitCode, $elapsedText)

        $runRows += [pscustomobject]@{
            executable      = $target.Name
            executable_path = $target.FullName
            run_index       = $runIndex
            status          = $status
            exit_code       = $exitCode
            duration_ms     = $elapsedMs
            timeout_seconds = $TimeoutSeconds
            failure_reason  = $failureReason
        }
    }

    if (($successRuns + $failedRuns) -ne $Repeat) {
        Write-Warning "Run accounting mismatch for $($target.Name): expected $Repeat, got $($successRuns + $failedRuns)."
    }

    $statSource = if ($passDurations.Count -gt 0) { $passDurations } else { $allDurations }
    $minMs = $null
    $avgMs = $null
    $p95Ms = $null
    $maxMs = $null
    $totalMs = $null

    if ($statSource.Count -gt 0) {
        $minMs = [Math]::Round(($statSource | Measure-Object -Minimum).Minimum, 3)
        $avgMs = [Math]::Round(($statSource | Measure-Object -Average).Average, 3)
        $p95Ms = [Math]::Round((Get-PercentileValue -Values $statSource -Percentile 95), 3)
        $maxMs = [Math]::Round(($statSource | Measure-Object -Maximum).Maximum, 3)
        $totalMs = [Math]::Round(($allDurations | Measure-Object -Sum).Sum, 3)
    }

    $summaryRows += [pscustomobject]@{
        executable   = $target.Name
        repeats      = $Repeat
        success_runs = $successRuns
        failed_runs  = $failedRuns
        timeout_runs = $timeoutRuns
        min_ms       = $minMs
        avg_ms       = $avgMs
        p95_ms       = $p95Ms
        max_ms       = $maxMs
        total_ms     = $totalMs
    }
}

$expectedRunRows = $targets.Count * $Repeat
if ($runRows.Count -ne $expectedRunRows) {
    Write-Warning "Collected run row count ($($runRows.Count)) does not match expected count ($expectedRunRows)."
}

if ($summaryRows.Count -ne $targets.Count) {
    Write-Warning "Collected summary row count ($($summaryRows.Count)) does not match target count ($($targets.Count))."
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

$summaryExportRows = foreach ($row in $summaryRows) {
    [pscustomobject]@{
        executable   = $row.executable
        repeats      = $row.repeats
        success_runs = $row.success_runs
        failed_runs  = $row.failed_runs
        timeout_runs = $row.timeout_runs
        min_ms       = Convert-ToInvariantNumberString -Value $row.min_ms
        avg_ms       = Convert-ToInvariantNumberString -Value $row.avg_ms
        p95_ms       = Convert-ToInvariantNumberString -Value $row.p95_ms
        max_ms       = Convert-ToInvariantNumberString -Value $row.max_ms
        total_ms     = Convert-ToInvariantNumberString -Value $row.total_ms
    }
}

$runExportRows = foreach ($row in $runRows) {
    [pscustomobject]@{
        executable      = $row.executable
        executable_path = $row.executable_path
        run_index       = $row.run_index
        status          = $row.status
        exit_code       = $row.exit_code
        duration_ms     = Convert-ToInvariantNumberString -Value $row.duration_ms
        timeout_seconds = $row.timeout_seconds
        failure_reason  = $row.failure_reason
    }
}

$summaryExportRows | Export-Csv -LiteralPath $outputPath -NoTypeInformation -Encoding UTF8
$runExportRows | Export-Csv -LiteralPath $runOutputPath -NoTypeInformation -Encoding UTF8

Write-Host "[SUMMARY]"
$summaryRows | Sort-Object executable | Format-Table executable, success_runs, failed_runs, timeout_runs, avg_ms, p95_ms, max_ms -AutoSize

$failureRows = $runRows | Where-Object { $_.status -ne 'pass' }
if ($failureRows.Count -gt 0) {
    Write-Host "[FAILURE_SUMMARY] failed_runs=$($failureRows.Count)"
    $failureRows |
        Sort-Object executable, run_index |
        Select-Object executable, run_index, status, exit_code, @{ Name = 'duration_ms'; Expression = { Convert-ToInvariantNumberString -Value $_.duration_ms } }, failure_reason |
        Format-Table -AutoSize
} else {
    Write-Host "[FAILURE_SUMMARY] failed_runs=0"
}

Write-Host "[WRITE] summary=$outputPath"
Write-Host "[WRITE] runs=$runOutputPath"

$hasRunErrors = ($summaryRows | Where-Object { $_.failed_runs -gt 0 -or $_.timeout_runs -gt 0 }).Count -gt 0
if ($hasRunErrors -and $FailOnError) {
    Write-Host "[FAIL] One or more runs failed or timed out."
    exit 1
}

exit 0
