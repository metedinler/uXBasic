param([switch]$NoRepair)

$ErrorActionPreference = "Stop"
$repo = Get-Location
while ($repo -and !(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
    $parent = Split-Path $repo -Parent
    if ($parent -eq $repo) { break }
    $repo = $parent
}

if (!(Test-Path (Join-Path $repo "uxb/src/main.bas"))) {
    Write-Error "Repo root bulunamadi. uxb/src/main.bas yok."
    exit 1
}

Set-Location $repo

$script = "uxb/compiler/scripts/run_adim23_lifecycle_web_output_binding_gate.ps1"
if (!(Test-Path $script)) {
    Write-Error "ADIM23 gate script yok: $script"
    exit 1
}

powershell -NoProfile -ExecutionPolicy Bypass -File $script -NoRepair
exit $LASTEXITCODE
