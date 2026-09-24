param([switch]$NoRepair, [string]$RepoRoot = ".")
$ErrorActionPreference = "Stop"
function Find-UxbRoot { param([string]$Start)
    $p = (Resolve-Path $Start).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src\main.bas")) -or (Test-Path (Join-Path $p "main.bas"))) { return $p }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root/src not found" }
        $p = $parent
    }
}
$root = Find-UxbRoot $RepoRoot
Set-Location $root
$py = "tools\control\apply_adim43_src30_05_5_fixes.py"
if (!(Test-Path $py)) { if (Test-Path "src\tools\control\apply_adim43_src30_05_5_fixes.py") { $py = "src\tools\control\apply_adim43_src30_05_5_fixes.py" } }
if (!(Test-Path $py)) { throw "apply_adim43_src30_05_5_fixes.py not found" }
python $py --repo $root
exit $LASTEXITCODE
