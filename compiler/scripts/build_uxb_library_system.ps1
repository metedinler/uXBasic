param(
    [ValidateSet("core","all")][string]$Set = "core",
    [switch]$SkipDependencyInstall,
    [switch]$SkipCompilerBuild,
    [switch]$SkipSmoke,
    [switch]$RequireMirX64,
    [switch]$StrictAll,
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

function Invoke-UxbChildScript([string]$ScriptPath, [string[]]$Arguments) {
    $powershellExe = (Get-Command powershell.exe -ErrorAction Stop).Source
    Write-Host "RUN: powershell.exe -File $ScriptPath $($Arguments -join ' ')"
    & $powershellExe -NoProfile -ExecutionPolicy Bypass -File $ScriptPath @Arguments
    $code = $LASTEXITCODE
    if ($code -ne 0) { throw "Alt betik basarisiz: $ScriptPath exit=$code" }
}

$uxbRoot = Find-UxbRoot $Root
$scriptRoot = Join-Path $uxbRoot "compiler\scripts"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$session = Join-Path $uxbRoot "reports\libraries\sessions\$stamp"
New-Item -ItemType Directory -Force $session | Out-Null
$transcript = Join-Path $session "build_transcript.txt"
Start-Transcript -Path $transcript -Force | Out-Null

try {
    Write-Host "UXB_ROOT=$uxbRoot"
    Write-Host "LIBRARY_SET=$Set"

    $toolchainArgs = @("-Root", $uxbRoot, "-RequireNative")
    if (-not $SkipCompilerBuild) { $toolchainArgs += "-RequireCompiler" }
    Invoke-UxbChildScript (Join-Path $scriptRoot "resolve_uxb_toolchain.ps1") $toolchainArgs

    Invoke-UxbChildScript (Join-Path $scriptRoot "organize_library_layout.ps1") @("-Root", $uxbRoot)

    $buildArgs = @("-Root", $uxbRoot, "-Set", $Set, "-StrictRuntime")
    if (-not $SkipDependencyInstall) { $buildArgs += "-FetchDeps" }
    if (-not $SkipCompilerBuild) { $buildArgs += "-BuildCompiler" }
    if ($StrictAll) { $buildArgs += "-StrictAll" }
    Invoke-UxbChildScript (Join-Path $scriptRoot "build_libraries.ps1") $buildArgs

    if (-not $SkipSmoke) {
        $smokeArgs = @("-Root", $uxbRoot, "-SkipBuild")
        if ($RequireMirX64) { $smokeArgs += "-RequireMirX64" }
        Invoke-UxbChildScript (Join-Path $scriptRoot "run_library_abi10_smoke.ps1") $smokeArgs
    }

    Invoke-UxbChildScript (Join-Path $scriptRoot "library_doctor.ps1") @("-Root", $uxbRoot)

    @{
        schema = "uxb.library_system_session.v1"
        status = "PASS"
        root = $uxbRoot
        set = $Set
        compiler_built = -not [bool]$SkipCompilerBuild
        dependencies_requested = -not [bool]$SkipDependencyInstall
        smoke_run = -not [bool]$SkipSmoke
        mir_x64_required = [bool]$RequireMirX64
        completed_at = (Get-Date).ToString("o")
    } | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $session "session_result.json") -Encoding UTF8

    Write-Host "PASS: uXBasic x64 compiler and library system completed"
    Write-Host "DLL_RUNTIME_DIR=$uxbRoot\bin"
    Write-Host "DLL_DISTRIBUTION_DIR=$uxbRoot\dist\libraries\bin"
    Write-Host "SESSION_REPORT=$session"
    exit 0
} catch {
    @{
        schema = "uxb.library_system_session.v1"
        status = "FAIL"
        root = $uxbRoot
        message = $_.Exception.Message
        completed_at = (Get-Date).ToString("o")
    } | ConvertTo-Json -Depth 5 | Set-Content (Join-Path $session "session_result.json") -Encoding UTF8
    Write-Error $_
    exit 1
} finally {
    try { Stop-Transcript | Out-Null } catch { }
}
