param(
    [string]$Root = ".",
    [string]$TaskDoc = "",
    [string]$Step = "",
    [switch]$NoRepair
)
$ErrorActionPreference = "Stop"
Set-Location $Root
New-Item -ItemType Directory -Force "reports/control/current" | Out-Null
$py = if (Test-Path "..\.venv\Scripts\python.exe") { "..\.venv\Scripts\python.exe" } else { "python" }
& $py "tools/control/uxb_copilot_task_boundary_gate.py" --root . --task-doc "$TaskDoc" --step "$Step" --strict
exit $LASTEXITCODE
