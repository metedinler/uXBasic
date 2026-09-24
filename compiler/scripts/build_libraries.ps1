param(
    [ValidateSet("minimal","core","all")][string]$Set = "core",
    [string[]]$Library = @(),
    [switch]$FetchDeps,
    [switch]$Clean,
    [switch]$StrictAll,
    [switch]$StrictRuntime,
    [switch]$BuildCompiler,
    [switch]$AuditOnly,
    [switch]$DeployOnly,
    [string]$Root = ""
)
$ErrorActionPreference = "Stop"
function Find-UxbRoot([string]$Start) {
    if ([string]::IsNullOrWhiteSpace($Start)) { $Start = $PSScriptRoot }
    $p = (Resolve-Path $Start).Path
    while ($true) {
        if ((Test-Path (Join-Path $p "src")) -and (Test-Path (Join-Path $p "runtime_ext")) -and (Test-Path (Join-Path $p "libsx"))) { return $p }
        if ((Test-Path (Join-Path $p "uxb\src")) -and (Test-Path (Join-Path $p "uxb\runtime_ext"))) { return (Join-Path $p "uxb") }
        $parent = Split-Path $p -Parent
        if ($parent -eq $p) { throw "uXBasic root bulunamadi: $Start" }
        $p = $parent
    }
}
$uxbRoot = Find-UxbRoot $Root
$python = Get-Command python -ErrorAction SilentlyContinue
if (-not $python) { $python = Get-Command py -ErrorAction SilentlyContinue }
if (-not $python) { throw "Python 3 bulunamadi" }
$tool = Join-Path $uxbRoot "tools\library_tools\uxb_library_build.py"
if (!(Test-Path $tool)) { throw "Library build tool bulunamadi: $tool" }
$argsList = @($tool, "--root", $uxbRoot, "--set", $Set)
foreach ($name in $Library) { $argsList += @("--library", $name) }
if ($FetchDeps) { $argsList += "--fetch-deps" }
if ($Clean) { $argsList += "--clean" }
if ($StrictAll) { $argsList += "--strict-all" }
if ($StrictRuntime) { $argsList += "--strict-runtime" }
if ($BuildCompiler) { $argsList += "--build-compiler" }
if ($AuditOnly) { $argsList += "--audit-only" }
if ($DeployOnly) { $argsList += "--deploy-only" }
Push-Location $uxbRoot
try {
    & $python.Source @argsList
    exit $LASTEXITCODE
} finally { Pop-Location }
