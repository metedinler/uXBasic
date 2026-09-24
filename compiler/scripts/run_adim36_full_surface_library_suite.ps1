param(
    [switch]$NoRepair,
    [int]$MaxTests = 0,
    [string]$UxbExe = ""
)
$ErrorActionPreference = "Continue"
function Find-UxbRoot([string]$Start) {
    $p = Resolve-Path $Start
    $cur = Get-Item $p
    while ($cur) {
        if ((Test-Path (Join-Path $cur.FullName "src")) -and (Test-Path (Join-Path $cur.FullName "compiler"))) { return $cur.FullName }
        if (Test-Path (Join-Path $cur.FullName "uxb\src")) { return (Join-Path $cur.FullName "uxb") }
        $cur = $cur.Parent
    }
    throw "uXBasic root not found"
}
$uxbRoot = Find-UxbRoot (Get-Location).Path
Set-Location $uxbRoot
$current = "reports\control\current"

$rotateScript = "compiler\scripts\rotate_current_reports.ps1"
if (Test-Path $rotateScript) {
    powershell -NoProfile -ExecutionPolicy Bypass -File $rotateScript -StepName "adim36_full_surface"
}

New-Item -ItemType Directory -Force $current | Out-Null
$env:UXB_FORCE_REBUILD = "1"
$buildLog = "$current\adim36_build.log"
$buildExit = 9999
foreach ($b in @("build_64.bat", "compiler\scripts\build_uxb_main_64.bat")) {
    if (Test-Path $b) {
        $bp = (Resolve-Path $b).Path
        & cmd /c "`"$bp`"" *> $buildLog
        $buildExit = $LASTEXITCODE
        break
    }
}
$compileText = ""
if (Test-Path $buildLog) { $compileText = Get-Content $buildLog -Raw -ErrorAction SilentlyContinue }
$skipFound = $compileText -match "Skipping rebuild"
if ($buildExit -ne 0 -or $skipFound) {
    $obj = [ordered]@{ schema="uxb-adim36-full-surface-library-gate-1"; status="FAIL"; reason="BUILD_FAIL_OR_SKIPPED"; build_exit_code=$buildExit; skipping_rebuild_found=$skipFound; compile_log=$buildLog }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 "$current\adim36_full_surface_gate.json"
    exit 1
}
$py = "python"
$venvPy1 = Join-Path (Split-Path $uxbRoot -Parent) ".venv\Scripts\python.exe"
$venvPy2 = Join-Path $uxbRoot ".venv\Scripts\python.exe"
if (Test-Path $venvPy1) { $py = $venvPy1 } elseif (Test-Path $venvPy2) { $py = $venvPy2 }
$runner = "tools\control\uxb_adim36_full_surface_runner.py"
if (!(Test-Path $runner)) {
    $obj = [ordered]@{ schema="uxb-adim36-full-surface-library-gate-1"; status="FAIL"; reason="RUNNER_MISSING"; runner=$runner }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 "$current\adim36_full_surface_gate.json"
    exit 1
}
$argsList = @("--root",".")
if ($UxbExe -ne "") { $argsList += @("--uxb-exe",$UxbExe) }
if ($MaxTests -gt 0) { $argsList += @("--max-tests","$MaxTests") }
& $py $runner @argsList
exit $LASTEXITCODE
