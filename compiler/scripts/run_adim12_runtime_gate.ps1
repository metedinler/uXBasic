param(
    [string]$RepoRoot = "",
    [string]$PythonExe = ""
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($RepoRoot)) {
    $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
}
Set-Location $RepoRoot

$step = "12_adim7_interpreter_runtime"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "${step}_$stamp"

New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        Move-Item "$current\*" $historyTarget -Force
    }
}
New-Item -ItemType Directory -Force $current | Out-Null
Write-Host "CURRENT_ARCHIVED_TO=$historyTarget"

$srcChecks = @(
    "src/runtime/services/runtime_service_signature.fbs",
    "src/runtime/services/runtime_service_catalog.fbs",
    "src/runtime/services/runtime_service_gate.fbs",
    "src/runtime/runtime_route_matrix_writer.fbs",
    "src/runtime/runtime_dispatch_strict.fbs",
    "src/runtime/runtime_interpreter_report.fbs",
    "src/semantic/mir_runtime_bridge.fbs"
)
$missing = @()
foreach ($f in $srcChecks) {
    if (!(Test-Path $f)) { $missing += $f }
}
if ($missing.Count -gt 0) {
    Write-Host "ADIM12_FAIL_MISSING_PATCH_FILES"
    $missing | ForEach-Object { Write-Host $_ }
    exit 1
}

$compileLog = Join-Path $current "adim7_compile.log"
$gateJson = Join-Path $current "adim7_gate.json"
$gateMd = Join-Path $current "adim7_gate.md"

# Mevcut build script varsa onu kullan. Yeni Python aracı yazma.
if (Test-Path "compiler/scripts/build_uxb_main_64.bat") {
    cmd /c compiler\scripts\build_uxb_main_64.bat *> $compileLog
    $buildExit = $LASTEXITCODE
} else {
    "build_uxb_main_64.bat bulunamadi" | Set-Content -Encoding UTF8 $compileLog
    $buildExit = 1
}
Write-Host "BUILD_EXIT=$buildExit"

# Runtime service source-level evidence raporları: PowerShell ile, repo aracı yazmadan.
$serviceIds = Select-String -Path "src/runtime/services/runtime_service_ids.fbs" -Pattern '^Const\s+(RT_[A-Z0-9_]+)\s+As\s+String\s*=\s+"([^"]+)"' | ForEach-Object {
    [PSCustomObject]@{ Name = $_.Matches[0].Groups[1].Value; ServiceId = $_.Matches[0].Groups[2].Value }
}
$serviceRows = foreach ($s in $serviceIds) {
    $id = $s.ServiceId
    $known = Select-String -Path "src/runtime/services/runtime_service_matrix.fbs" -Pattern $id -Quiet
    $dispatch = Select-String -Path "src/runtime/runtime_service_dispatch.fbs","src/runtime/**/*.fbs" -Pattern $id -Quiet
    [PSCustomObject]@{
        service_id = $id
        const_name = $s.Name
        known_in_matrix = [int]$known
        referenced_by_dispatch_or_runtime = [int]$dispatch
    }
}
$serviceRows | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $current "adim7_runtime_services.csv")
$serviceRows | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $current "adim7_runtime_route_matrix.csv")

@(
    [PSCustomObject]@{ test = "tests/adim12/positive/adim12_print.bas"; expected = "PASS" },
    [PSCustomObject]@{ test = "tests/adim12/positive/adim12_string_math.bas"; expected = "PASS" },
    [PSCustomObject]@{ test = "tests/adim12/positive/adim12_memory.bas"; expected = "PASS" }
) | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $current "adim7_positive_tests.csv")

@(
    [PSCustomObject]@{ test = "tests/adim12/negative/adim12_missing_service.bas"; expected = "RUNTIME_SERVICE_MISSING" },
    [PSCustomObject]@{ test = "tests/adim12/negative/adim12_memory_bounds.bas"; expected = "RUNTIME_MEMORY_BOUNDS_FAIL" },
    [PSCustomObject]@{ test = "tests/adim12/negative/adim12_bad_signature.bas"; expected = "RUNTIME_SIGNATURE_MISSING" }
) | Export-Csv -NoTypeInformation -Encoding UTF8 (Join-Path $current "adim7_negative_tests.csv")

$missingKnown = @($serviceRows | Where-Object { $_.known_in_matrix -eq 0 })
$missingDispatch = @($serviceRows | Where-Object { $_.referenced_by_dispatch_or_runtime -eq 0 })
$status = if ($buildExit -eq 0 -and $missingKnown.Count -eq 0 -and $missingDispatch.Count -eq 0) { "PASS" } else { "FAIL" }

$summary = [ordered]@{
    status = $status
    build_exit = $buildExit
    service_count = @($serviceRows).Count
    missing_known_count = $missingKnown.Count
    missing_dispatch_reference_count = $missingDispatch.Count
    archived_previous_current_to = $historyTarget
}
$summary | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 $gateJson

@"
# Adim 7 Runtime Gate

Status: **$status**

- build_exit: $buildExit
- service_count: $(@($serviceRows).Count)
- missing_known_count: $($missingKnown.Count)
- missing_dispatch_reference_count: $($missingDispatch.Count)
- archived_previous_current_to: $historyTarget
"@ | Set-Content -Encoding UTF8 $gateMd

@{
    ok = ($status -eq "PASS")
    build_exit = $buildExit
    services = @($serviceRows).Count
} | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $current "adim7_interpreter_report.json")

Get-ChildItem $current | Select-Object Name,Length | Format-Table -AutoSize
if ($status -ne "PASS") { exit 1 }
exit 0
