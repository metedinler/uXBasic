param([switch]$NoRepair, [string]$RepoRoot = ".")

$ErrorActionPreference = "Stop"
$root = (Resolve-Path $RepoRoot).Path
Set-Location $root

$py = "tools\control\scan_adim44_remaining_status.py"
if (!(Test-Path $py)) { throw "scan_adim44_remaining_status.py not found" }

python $py --repo $root
exit $LASTEXITCODE
