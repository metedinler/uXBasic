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
        if ((Test-Path (Join-Path $cur.FullName "src")) -and (Test-Path (Join-Path $cur.FullName "tools"))) { return $cur.FullName }
        if (Test-Path (Join-Path $cur.FullName "uxb\src")) { return (Join-Path $cur.FullName "uxb") }
        $cur = $cur.Parent
    }
    throw "uXBasic root not found"
}

$uxbRoot = Find-UxbRoot (Get-Location).Path
Set-Location $uxbRoot

$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "30_10step_chain_$stamp"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
    $items = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
    if ($items) {
        New-Item -ItemType Directory -Force $historyTarget | Out-Null
        foreach ($it in $items) {
            $moved = $false
            for ($try = 0; $try -lt 3 -and -not $moved; $try++) {
                try {
                    Move-Item -LiteralPath $it.FullName -Destination $historyTarget -Force -ErrorAction Stop
                    $moved = $true
                } catch {
                    Start-Sleep -Milliseconds 250
                }
            }
            if (-not $moved) {
                try {
                    $dst = Join-Path $historyTarget $it.Name
                    Copy-Item -LiteralPath $it.FullName -Destination $dst -Recurse -Force -ErrorAction Stop
                } catch {
                    # Do not fail the whole gate run due to archival lock.
                }
            }
        }
    }
}
New-Item -ItemType Directory -Force $current | Out-Null

$log = "$current/adim30_build.log"
$buildExit = 9999
$buildCandidates = @("build_64.bat", "compiler/scripts/build_uxb_main_64.bat")
foreach ($b in $buildCandidates) {
    if (Test-Path $b) {
        $buildPath = (Resolve-Path $b).Path
        & cmd /c "`"$buildPath`"" *> $log
        $buildExit = $LASTEXITCODE
        break
    }
}

if ($buildExit -ne 0) {
    $obj = [ordered]@{
        schema="uxb-adim30-10step-chain-gate-1"
        status="FAIL"
        reason="BUILD_FAIL"
        build_exit_code=$buildExit
        compile_log=$log
        no_repair=[bool]$NoRepair
    }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 "$current/adim30_10step_gate.json"
    "# ADIM30 FAIL`n`nBuild failed. See $log" | Set-Content -Encoding UTF8 "$current/adim30_10step_gate.md"
    exit 1
}

$py = "python"
$venvPy1 = Join-Path (Split-Path $uxbRoot -Parent) ".venv\Scripts\python.exe"
$venvPy2 = Join-Path $uxbRoot ".venv\Scripts\python.exe"
if (Test-Path $venvPy1) { $py = $venvPy1 }
elseif (Test-Path $venvPy2) { $py = $venvPy2 }

$uxbExeArg = ""
if ($UxbExe -ne "") { $uxbExeArg = "--uxb-exe `"$UxbExe`"" }
$maxArg = ""
if ($MaxTests -gt 0) { $maxArg = "--max-tests $MaxTests" }

$runner = "tools/control/uxb_10step_chain_runner.py"
if (!(Test-Path $runner)) {
    $obj = [ordered]@{ schema="uxb-adim30-10step-chain-gate-1"; status="FAIL"; reason="RUNNER_MISSING"; runner=$runner }
    $obj | ConvertTo-Json -Depth 6 | Set-Content -Encoding UTF8 "$current/adim30_10step_gate.json"
    exit 1
}

$cmd = "$py $runner --root . $uxbExeArg $maxArg"
$cmd | Set-Content -Encoding UTF8 "$current/adim30_command.txt"
Invoke-Expression $cmd
$testExit = $LASTEXITCODE

if ($testExit -ne 0) { exit 1 }
exit 0
