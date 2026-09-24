param(
    [string]$Root = (Resolve-Path (Join-Path $PSScriptRoot "..\..")),
    [string]$Python = "python",
    [switch]$SkipCompilerBuild,
    [switch]$SkipLibraryBuild,
    [switch]$SkipNativeX64,
    [switch]$SkipQuickJsGeneratedE2E
)
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$Root = (Resolve-Path $Root).Path
$ReportDir = Join-Path $Root ("reports\post_quickjs_ffi\" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
$env:PATH = "$Root\bin;C:\msys64\ucrt64\bin;$env:PATH"

function Invoke-NativeChecked {
    param(
        [string]$FilePath,
        [string[]]$UxbArguments,
        [string]$LogPath,
        [int]$TimeoutSeconds = 180,
        [string]$WorkingDirectory = $Root
    )
    $stdout = "$LogPath.stdout.log"
    $stderr = "$LogPath.stderr.log"
    $process = Start-Process -FilePath $FilePath -ArgumentList $UxbArguments -WorkingDirectory $WorkingDirectory -NoNewWindow -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
    if (-not $process.WaitForExit($TimeoutSeconds * 1000)) {
        try { $process.Kill() } catch {}
        throw "TIMEOUT: $FilePath $($UxbArguments -join ' ')"
    }
    $combined = @()
    if (Test-Path $stdout) { $combined += Get-Content $stdout }
    if (Test-Path $stderr) { $combined += Get-Content $stderr }
    $combined | Set-Content -Encoding UTF8 $LogPath
    if ($process.ExitCode -ne 0) {
        throw "Native command failed exit=$($process.ExitCode). See $LogPath"
    }
    return ($combined -join "`n")
}

function Invoke-RepoBuildScript {
    param([string[]]$Candidates, [string]$LogName, [int]$TimeoutSeconds)
    foreach ($candidate in $Candidates) {
        $full = Join-Path $Root $candidate
        if (-not (Test-Path $full)) { continue }
        $extension = [IO.Path]::GetExtension($full).ToLowerInvariant()
        if ($extension -eq '.ps1') {
            Invoke-NativeChecked -FilePath 'pwsh.exe' -UxbArguments @('-NoProfile','-ExecutionPolicy','Bypass','-File',$full,'-Root',$Root) -LogPath (Join-Path $ReportDir $LogName) -TimeoutSeconds $TimeoutSeconds | Out-Null
        } elseif ($extension -eq '.bat' -or $extension -eq '.cmd') {
            Invoke-NativeChecked -FilePath 'cmd.exe' -UxbArguments @('/d','/s','/c',('"' + $full + '"')) -LogPath (Join-Path $ReportDir $LogName) -TimeoutSeconds $TimeoutSeconds | Out-Null
        } else {
            throw "Unsupported build script: $full"
        }
        return
    }
    throw "No build script found. Checked: $($Candidates -join ', ')"
}

# Static/source gate is deliberately before long builds.
$staticJson = Join-Path $ReportDir 'static.json'
$static = Invoke-NativeChecked -FilePath $Python -UxbArguments @('tools\diagnostics\verify_post_quickjs_patch.py','--root',$Root,'--json-out',$staticJson) -LogPath (Join-Path $ReportDir 'static.log') -TimeoutSeconds 120
if ($static -notmatch '"status": "PASS"') { throw 'Static patch gate did not PASS' }

if (-not $SkipLibraryBuild) {
    Invoke-RepoBuildScript -Candidates @('runtime_ext\uxffi\build_uxffi_dll.bat','runtime_ext\uxffi\build_uxffi_dll.ps1') -LogName 'build_uxffi.log' -TimeoutSeconds 300
}
if (-not $SkipCompilerBuild) {
    Invoke-RepoBuildScript -Candidates @('build_64.bat','build_64.ps1','compiler\scripts\build_64.bat','compiler\scripts\build_64.ps1') -LogName 'build_compiler.log' -TimeoutSeconds 1200
}
if (-not $SkipLibraryBuild) {
    Invoke-RepoBuildScript -Candidates @('compiler\scripts\build_freebasic_a_group.ps1','compiler\scripts\build_freebasic_a_group.bat') -LogName 'build_freebasic_a_group.log' -TimeoutSeconds 900
}

$native = Invoke-NativeChecked -FilePath $Python -UxbArguments @('tests\libraries\ffi_final\test_uxffi_uxconfig_roundtrip.py','--root',$Root) -LogPath (Join-Path $ReportDir 'native_roundtrip.log') -TimeoutSeconds 240
if ($native -notmatch 'UXFFI_UXCONFIG_ROUNDTRIP_PASS') { throw 'Native roundtrip marker missing' }

$uxb = Join-Path $Root 'bin\uxb.exe'
$source = 'tests\libraries\ffi_final\ffi_freebasic_roundtrip.uxb'
foreach ($backend in @('AST','MIR')) {
    $backendSlug = $backend.ToLowerInvariant()
    $text = Invoke-NativeChecked -FilePath $uxb -UxbArguments @('int',$source,'--interpreter-backend',$backend) -LogPath (Join-Path $ReportDir ("uxb_interpreter_"+$backendSlug+'.log')) -TimeoutSeconds 240
    if ($text -notmatch 'UXB_FFI_FREEBASIC_ROUNDTRIP_PASS') { throw "$backend interpreter marker missing" }
}

if (-not $SkipNativeX64) {
    foreach ($backend in @('AST','MIR')) {
        $backendSlug = $backend.ToLowerInvariant()
        $exePath = Join-Path $ReportDir ("ffi_roundtrip_" + $backendSlug + ".exe")
        $arguments = @($source,'--build-x64','--codegen-source',$backend,'--build-x64-out',$exePath)
        if ($backend -eq 'MIR') {
            $arguments += @('--mir-verify')
        }
        Invoke-NativeChecked -FilePath $uxb -UxbArguments $arguments -LogPath (Join-Path $ReportDir ("build_x64_"+$backendSlug+'.log')) -TimeoutSeconds 420 | Out-Null
        if (-not (Test-Path $exePath)) { throw "$backend native x64 EXE was not produced: $exePath" }
        $nativeText = Invoke-NativeChecked -FilePath $exePath -UxbArguments @() -LogPath (Join-Path $ReportDir ("run_x64_"+$backendSlug+'.log')) -TimeoutSeconds 180 -WorkingDirectory $Root
        if ($nativeText -notmatch 'UXB_FFI_FREEBASIC_ROUNDTRIP_PASS') { throw "$backend native x64 marker missing" }
    }
}

if (-not $SkipQuickJsGeneratedE2E) {
    $quickJs = Invoke-NativeChecked -FilePath $Python -UxbArguments @('tests\libraries\uxjsruntime\test_generated_js_e2e.py','--root',$Root) -LogPath (Join-Path $ReportDir 'quickjs_generated_e2e.log') -TimeoutSeconds 300
    if ($quickJs -notmatch 'UXJSRT_GENERATED_JS_E2E_PASS') { throw 'QuickJS generated E2E marker missing' }
}

$markers = @(
    'UXFFI_UXCONFIG_ROUNDTRIP_PASS',
    'UXB_FFI_FREEBASIC_ROUNDTRIP_PASS',
    'UXJSRT_GENERATED_JS_E2E_PASS'
)
@{
    schema = 'uxb.post-quickjs-ffi-gate.v2'
    status = 'PASS'
    reportDir = $ReportDir
    nativeX64 = (-not $SkipNativeX64)
    markers = $markers
} | ConvertTo-Json -Depth 5 | Set-Content -Encoding UTF8 (Join-Path $ReportDir 'summary.json')
Write-Host 'UXB_POST_QUICKJS_FFI_GATE_PASS'
Write-Host "REPORT=$ReportDir"
