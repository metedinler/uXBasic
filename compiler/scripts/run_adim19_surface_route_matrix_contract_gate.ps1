param(
    [string]$Root = ".",
    [switch]$NoRepair
)
$ErrorActionPreference = "Stop"
Set-Location $Root
New-Item -ItemType Directory -Force "reports/control/current" | Out-Null

$py = if (Test-Path "..\.venv\Scripts\python.exe") { "..\.venv\Scripts\python.exe" } else { "python" }
& $py "tools/control/uxb_surface_route_matrix_contract_gate.py" --root . --strict
exit $LASTEXITCODE
