param([switch]$NoRepair, [string]$RepoRoot = ".")

$ErrorActionPreference = "Stop"
$root = (Resolve-Path $RepoRoot).Path
Set-Location $root

$py = "tools\control\apply_adim44_remaining_gaps.py"
if (!(Test-Path $py)) { throw "apply_adim44_remaining_gaps.py not found" }

python $py --repo $root --patch-root "patch_files"
exit $LASTEXITCODE
