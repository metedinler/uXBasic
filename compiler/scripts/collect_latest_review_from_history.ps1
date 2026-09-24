param(
    [switch]$NoCurrent,
    [string]$OutPrefix = "latest_review"
)

$ErrorActionPreference = "Stop"

function Find-UxbRoot {
    $p = (Get-Location).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src")) -and (Test-Path (Join-Path $p "reports\control"))) {
            return $p
        }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root not found" }
        $p = $parent
    }
}

function Read-GateSummary($path) {
    try {
        $j = Get-Content $path -Raw | ConvertFrom-Json
        $status = $null
        if ($null -ne $j.status) { $status = $j.status }
        elseif ($null -ne $j.ok) { if ($j.ok) { $status = "PASS" } else { $status = "FAIL" } }
        else { $status = "UNKNOWN" }

        $fail = ""
        if ($null -ne $j.fail_count) { $fail = [string]$j.fail_count }
        $missing = ""
        if ($null -ne $j.missing_output_count) { $missing = [string]$j.missing_output_count }
        $tests = ""
        if ($null -ne $j.test_case_count) { $tests = [string]$j.test_case_count }

        return [pscustomobject]@{
            path = $path
            name = Split-Path $path -Leaf
            status = $status
            fail_count = $fail
            missing_output_count = $missing
            test_case_count = $tests
            mtime = (Get-Item $path).LastWriteTime
            dir = Split-Path $path -Parent
        }
    } catch {
        return [pscustomobject]@{
            path = $path
            name = Split-Path $path -Leaf
            status = "BAD_JSON"
            fail_count = ""
            missing_output_count = ""
            test_case_count = ""
            mtime = (Get-Item $path).LastWriteTime
            dir = Split-Path $path -Parent
        }
    }
}

$root = Find-UxbRoot
Set-Location $root

$hist = Join-Path $root "reports\control\history"
if (!(Test-Path $hist)) { throw "history folder not found: $hist" }

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$dest = Join-Path $hist ($OutPrefix + "_" + $stamp)
New-Item -ItemType Directory -Force -Path $dest | Out-Null

$allGateFiles = Get-ChildItem $hist -Recurse -File -Filter "*.json" |
    Where-Object {
        $_.Name -match "^adim(30|32b|36).*gate\.json$" -or
        $_.Name -eq "adim38_second_wave_gate.json" -or
        $_.Name -eq "adim39_third_wave_gate.json"
    } |
    Where-Object {
        # Do not select prior collector/review bundles as source.
        $_.FullName -notmatch "\\latest_review_" -and
        $_.FullName -notmatch "\\latest_two_jobs_" -and
        $_.FullName -notmatch "\\adim40_latest_review_"
    }

$summary = @()
foreach ($g in $allGateFiles) { $summary += (Read-GateSummary $g.FullName) }

$summary |
    Sort-Object mtime -Descending |
    Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $dest "selected_gate_files_all.csv")

function Pick-LatestByName($regex) {
    return $summary |
        Where-Object { $_.name -match $regex } |
        Sort-Object mtime -Descending |
        Select-Object -First 1
}

$picks = @()
$picks += Pick-LatestByName "^adim36_full_surface_gate\.json$"
$picks += Pick-LatestByName "^adim32b_strict_gate\.json$"
$picks += Pick-LatestByName "^adim30_10step_gate\.json$"
$picks += Pick-LatestByName "^adim38_second_wave_gate\.json$"
$picks += Pick-LatestByName "^adim39_.*gate\.json$"

$picks = $picks | Where-Object { $null -ne $_ }

$picks | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $dest "selected_gate_files.csv")

$i = 1
$copied = @()
foreach ($p in $picks) {
    $leaf = Split-Path $p.dir -Leaf
    $jobName = "{0:00}_{1}_{2}" -f $i, ($p.name -replace "\.json$",""), $leaf
    $target = Join-Path $dest $jobName
    New-Item -ItemType Directory -Force -Path $target | Out-Null
    Copy-Item -Path (Join-Path $p.dir "*") -Destination $target -Recurse -Force
    $copied += [pscustomobject]@{
        gate = $p.path
        copied_to = $target
        status = $p.status
        fail_count = $p.fail_count
        missing_output_count = $p.missing_output_count
        test_case_count = $p.test_case_count
    }
    $i++
}

$copied | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $dest "copied_jobs.csv")

$manifest = [ordered]@{
    created_at = (Get-Date).ToString("s")
    rule = "reports/control/current is not used. Prior latest_review/latest_two_jobs bundles are excluded."
    root = $root
    history = $hist
    selected_count = $picks.Count
    copied = $copied
}
$manifest | ConvertTo-Json -Depth 10 | Set-Content -Encoding UTF8 (Join-Path $dest "manifest.json")

Write-Output $dest
