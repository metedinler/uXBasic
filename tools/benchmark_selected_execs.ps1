param(
    [int]$Iterations = 30,
    [string]$OutCsv = "reports/perf_selected_execs.csv"
)

$ErrorActionPreference = 'Stop'

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$targets = @(
    "tests/run_class_method_dispatch_exec_ast_64.exe",
    "tests/run_collection_engine_exec_64.exe",
    "tests/run_percent_preprocess_exec_64.exe"
)

function Get-P95 {
    param([double[]]$Values)

    if (-not $Values -or $Values.Count -eq 0) {
        return 0.0
    }

    $sorted = $Values | Sort-Object
    $idx = [Math]::Ceiling(0.95 * $sorted.Count) - 1
    if ($idx -lt 0) {
        $idx = 0
    }
    return [double]$sorted[$idx]
}

function Run-One {
    param([string]$ExePath)

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $proc = Start-Process -FilePath $ExePath -WorkingDirectory $repoRoot -NoNewWindow -PassThru

    $maxWorkingSet = 0.0
    while (-not $proc.HasExited) {
        try {
            $proc.Refresh()
            if ($proc.WorkingSet64 -gt 0 -and $proc.WorkingSet64 -gt $maxWorkingSet) {
                $maxWorkingSet = [double]$proc.WorkingSet64
            }
        } catch {
            # Process can end between refresh and read.
        }
        Start-Sleep -Milliseconds 2
    }

    $proc.WaitForExit()
    $sw.Stop()

    $proc.Refresh()
    if ($proc.PeakWorkingSet64 -gt $maxWorkingSet) {
        $maxWorkingSet = [double]$proc.PeakWorkingSet64
    }
    $peakKb = [Math]::Round(($maxWorkingSet / 1KB), 2)

    [PSCustomObject]@{
        DurationMs = [Math]::Round($sw.Elapsed.TotalMilliseconds, 3)
        PeakMemoryKB = $peakKb
        ExitCode = [int]$proc.ExitCode
    }
}

$rows = @()

foreach ($target in $targets) {
    if (-not (Test-Path $target)) {
        $rows += [PSCustomObject]@{
            Test = $target
            AvgMs = 0
            P95Ms = 0
            PeakMemoryKB = 0
            Note = "missing executable"
        }
        continue
    }

    $durations = New-Object System.Collections.Generic.List[double]
    $memories = New-Object System.Collections.Generic.List[double]
    $failCount = 0
    $exitCodes = New-Object System.Collections.Generic.List[int]

    for ($i = 1; $i -le $Iterations; $i++) {
        $result = Run-One -ExePath $target
        $durations.Add([double]$result.DurationMs)
        $memories.Add([double]$result.PeakMemoryKB)

        if ([int]$result.ExitCode -ne 0) {
            $failCount++
            $exitCodes.Add([int]$result.ExitCode)
        }
    }

    $avgMs = [Math]::Round((($durations | Measure-Object -Average).Average), 3)
    $p95Ms = [Math]::Round((Get-P95 -Values $durations.ToArray()), 3)
    $peakMemory = [Math]::Round((($memories | Measure-Object -Maximum).Maximum), 2)

    $note = "ok"
    if ($failCount -gt 0) {
        $uniqCodes = ($exitCodes | Sort-Object -Unique) -join ','
        $note = "failures=${failCount}/${Iterations}; exit=${uniqCodes}"
    }

    $rows += [PSCustomObject]@{
        Test = $target
        AvgMs = $avgMs
        P95Ms = $p95Ms
        PeakMemoryKB = $peakMemory
        Note = $note
    }
}

$outDir = Split-Path -Parent $OutCsv
if ($outDir -and -not (Test-Path $outDir)) {
    New-Item -ItemType Directory -Path $outDir -Force | Out-Null
}

$rows | Export-Csv -Path $OutCsv -NoTypeInformation -Encoding UTF8
$rows | Format-Table -AutoSize

Write-Host "Saved CSV: $OutCsv"