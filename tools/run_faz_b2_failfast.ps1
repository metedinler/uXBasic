param(
    [switch]$SkipBuild
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Invoke-Step {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Write-Host "[STEP] $Name"
    & $Action
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[FAIL] $Name (exit=$LASTEXITCODE)"
        exit $LASTEXITCODE
    }
    Write-Host "[PASS] $Name"
}

$arg = @()
if ($SkipBuild) { $arg = @('-SkipBuild') }

Invoke-Step "Layout indexed fail-fast" { powershell -ExecutionPolicy Bypass -File .\tools\run_layout_indexed_failfast.ps1 @arg }
Invoke-Step "Memory width fail-fast" { powershell -ExecutionPolicy Bypass -File .\tools\run_memory_width_failfast.ps1 @arg }
Invoke-Step "Memory stride fail-fast" { powershell -ExecutionPolicy Bypass -File .\tools\run_memory_stride_failfast.ps1 @arg }

Write-Host "[DONE] Faz B.2 fail-fast suite passed."
exit 0
