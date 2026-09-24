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

if (-not $SkipBuild) {
    Invoke-Step "Build run_memory_width_semantics_64" { cmd /c build_64.bat tests\run_memory_width_semantics.bas }
}
Invoke-Step "Run run_memory_width_semantics_64" { cmd /c tests\run_memory_width_semantics_64.exe }

Write-Host "[DONE] Memory width fail-fast passed."
exit 0
