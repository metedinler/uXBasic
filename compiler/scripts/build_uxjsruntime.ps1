[CmdletBinding()]
param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [switch]$SkipFetch,
    [switch]$SkipBuild,
    [switch]$SkipNativeSmoke,
    [switch]$RunUxbSmoke
)

$ErrorActionPreference = "Stop"
function Invoke-NativeChecked {
    param([string]$FilePath, [string[]]$CommandArgs, [string]$LogPath)
    & $FilePath @CommandArgs *> $LogPath
    $code = $LASTEXITCODE
    Get-Content -LiteralPath $LogPath
    if ($code -ne 0) { throw "command failed exit=$code file=$FilePath" }
}

$Root = (Resolve-Path $Root).Path
$report = Join-Path $Root ("reports\uxjsruntime\{0}" -f (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Force -Path $report | Out-Null
$module = Join-Path $Root "runtime_ext\uxjsruntime"
Push-Location $Root
try {
    if (-not $SkipFetch) {
        & (Join-Path $module "fetch_quickjs.ps1") -Root $Root *>&1 | Tee-Object -FilePath (Join-Path $report "fetch.log")
    }
    if (-not $SkipBuild) {
        & (Join-Path $module "build_uxjsrt.ps1") -Root $Root -SkipFetch *>&1 | Tee-Object -FilePath (Join-Path $report "build.log")
    }
    if (-not $SkipNativeSmoke) {
        $python = (Get-Command python.exe -ErrorAction SilentlyContinue).Source
        if (-not $python) { $python = (Get-Command python -ErrorAction SilentlyContinue).Source }
        if (-not $python) { throw "Python not found for ctypes smoke" }
        Invoke-NativeChecked $python @((Join-Path $Root "tests\libraries\uxjsruntime\test_uxjsrt.py"), "--root", $Root) (Join-Path $report "native_smoke.log")
    }
    if ($RunUxbSmoke) {
        $uxb = Join-Path $Root "bin\uxb.exe"
        $smoke = Join-Path $Root "tests\libraries\uxjsruntime\uxjsruntime_smoke.uxb"
        if (-not (Test-Path $uxb)) { throw "bin\uxb.exe not found" }
        Invoke-NativeChecked $uxb @("ast", $smoke) (Join-Path $report "uxb_ast.log")
        Invoke-NativeChecked $uxb @("mir", $smoke) (Join-Path $report "uxb_mir.log")
    }
} finally {
    Pop-Location
}
Write-Host "[PASS] UXJSRT report: $report"
