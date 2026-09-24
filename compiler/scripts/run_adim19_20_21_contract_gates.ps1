param(
    [string]$Root = ".",
    [switch]$NoRepair,
    [switch]$Strict
)
$ErrorActionPreference = "Stop"
Set-Location $Root
New-Item -ItemType Directory -Force "reports/control/current" | Out-Null
$py = if (Test-Path "..\.venv\Scripts\python.exe") { "..\.venv\Scripts\python.exe" } else { "python" }

$results = @()

if ($Strict) {
    & $py "tools/control/uxb_surface_route_matrix_contract_gate.py" --root . --strict
} else {
    & $py "tools/control/uxb_surface_route_matrix_contract_gate.py" --root .
}
$results += @{ gate="adim19"; exit=$LASTEXITCODE }

if ($Strict) {
    & $py "tools/control/uxb_layer_output_contract_gate.py" --root . --strict
} else {
    & $py "tools/control/uxb_layer_output_contract_gate.py" --root .
}
$results += @{ gate="adim20"; exit=$LASTEXITCODE }

if ($Strict) {
    & $py "tools/control/uxb_copilot_task_boundary_gate.py" --root . --task-doc "19_20_21_CONTRACT_GATES" --step "19-20-21" --strict
} else {
    & $py "tools/control/uxb_copilot_task_boundary_gate.py" --root . --task-doc "19_20_21_CONTRACT_GATES" --step "19-20-21"
}
$results += @{ gate="adim21"; exit=$LASTEXITCODE }

$ok = $true
foreach ($r in $results) { if ($r.exit -ne 0) { $ok = $false } }

$summary = @{
  status = $(if ($ok) { "PASS" } else { "FAIL" })
  ok = $ok
  gates = $results
} | ConvertTo-Json -Depth 5

$summary | Set-Content -Encoding UTF8 "reports/control/current/adim19_20_21_contract_gates.json"

if ($ok) { exit 0 } else { exit 1 }
