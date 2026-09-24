param(
    [string]$Root = "",
    [switch]$SkipBuild,
    [switch]$SkipWebFailClose
)
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}
Set-Location $Root

$report = Join-Path $Root "reports\libraries\tests\uxpython"
$work = Join-Path $Root "build\libraries\tests\uxpython"
New-Item -ItemType Directory -Force $report,$work | Out-Null

if (!$SkipBuild) {
    & "$Root\compiler\scripts\build_libraries.ps1" -Root $Root -Library uxpython -StrictRuntime
    if ($LASTEXITCODE -ne 0) { throw "uxpython build/deploy failed" }
}

$pythonCommand = Get-Command python -ErrorAction SilentlyContinue
if (-not $pythonCommand) { $pythonCommand = Get-Command py -ErrorAction SilentlyContinue }
if (-not $pythonCommand) { throw "Python 3 executable not found" }

$runtimeInfo = & $pythonCommand.Source -c "import pathlib,sys; print(pathlib.Path(sys.base_prefix)); print(f'python{sys.version_info.major}{sys.version_info.minor}.dll')"
if ($LASTEXITCODE -ne 0 -or $runtimeInfo.Count -lt 2) { throw "cannot query Python runtime location" }
$pythonBase = [string]$runtimeInfo[0]
$pythonDll = Join-Path $pythonBase ([string]$runtimeInfo[1])
if (!(Test-Path $pythonDll)) {
    $stable = Join-Path $pythonBase "python3.dll"
    if (Test-Path $stable) { $pythonDll = $stable }
}
if (!(Test-Path $pythonDll)) { throw "Python runtime DLL not found under $pythonBase" }

$env:UXPYTHON_DLL = $pythonDll
$env:PATH = "$(Split-Path $pythonDll -Parent);$Root\bin;$env:PATH"

$uxb = Join-Path $Root "bin\uxb.exe"
if (!(Test-Path $uxb)) { throw "bin\uxb.exe not found" }

function Read-TextSafe([string]$Path) {
    if (Test-Path $Path) { return Get-Content $Path -Raw }
    return ""
}

function Invoke-InterpreterCase([string]$Name, [string]$Source, [string]$Backend, [string]$ExpectedText) {
    $stdoutOut = Join-Path $script:report "$Name.stdout.txt"
    $stderrOut = Join-Path $script:report "$Name.stderr.txt"
    $programOut = Join-Path $script:report "$Name.program_output.txt"
    $args = @("--source", $Source, "--execmem", "--interpreter-backend", $Backend, "--console-mode", "direct",
        "--stdout-out", $stdoutOut, "--stderr-out", $stderrOut, "--program-output-out", $programOut)
    if ($Backend -eq "MIR") { $args += "--mir-verify" }
    & $script:uxb @args
    $code = $LASTEXITCODE
    $combined = (Read-TextSafe $stdoutOut) + "`n" + (Read-TextSafe $stderrOut) + "`n" + (Read-TextSafe $programOut)
    if ($code -ne 0 -or $combined -notmatch $ExpectedText) {
        throw "$Name failed exit=$code"
    }
}

$source = "tests\libraries\uxpython\uxpython_smoke.uxb"
Invoke-InterpreterCase "ast" $source "AST" "PASS_UXPYTHON"
Invoke-InterpreterCase "mir" $source "MIR" "PASS_UXPYTHON"

$negative = "tests\libraries\uxpython\uxpython_bad_json_negative.uxb"
Invoke-InterpreterCase "ast_negative" $negative "AST" "PASS_UXPYTHON_NEGATIVE"
Invoke-InterpreterCase "mir_negative" $negative "MIR" "PASS_UXPYTHON_NEGATIVE"

$x64Exe = Join-Path $work "uxpython_x64_ast.exe"
$x64BuildOut = Join-Path $report "x64_build.stdout.txt"
$x64BuildErr = Join-Path $report "x64_build.stderr.txt"
$x64RunOut = Join-Path $report "x64_run.stdout.txt"
$savedErrorActionPreference = $ErrorActionPreference
try {
    $ErrorActionPreference = "Continue"
    & $uxb --source $source --build-x64 --build-x64-out $x64Exe --codegen-source AST 1> $x64BuildOut 2> $x64BuildErr
    $x64BuildCode = $LASTEXITCODE
} finally {
    $ErrorActionPreference = $savedErrorActionPreference
}
if ($x64BuildCode -ne 0 -or !(Test-Path $x64Exe)) { throw "uxpython AST-x64 build failed exit=$x64BuildCode" }
try {
    $ErrorActionPreference = "Continue"
    & $x64Exe 1> $x64RunOut 2>&1
    $x64RunCode = $LASTEXITCODE
} finally {
    $ErrorActionPreference = $savedErrorActionPreference
}
if ($x64RunCode -ne 0 -or (Read-TextSafe $x64RunOut) -notmatch "PASS_UXPYTHON") {
    throw "uxpython AST-x64 runtime failed"
}

if (!$SkipWebFailClose) {
    $jsOut = Join-Path $work "uxpython.js"
    $webBuildLog = Join-Path $report "web_build.txt"
    $webRunLog = Join-Path $report "web_fail_close.txt"
    $nodeCommand = Get-Command node -ErrorAction SilentlyContinue
    if (-not $nodeCommand) { throw "Node.js executable not found for JS fail-close test" }
    try {
        $ErrorActionPreference = "Continue"
        & $uxb --source $source --emit-js --js-out $jsOut *> $webBuildLog
        $webBuildCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $savedErrorActionPreference
    }
    if ($webBuildCode -ne 0 -or !(Test-Path $jsOut)) { throw "uxpython JS generation failed exit=$webBuildCode" }
    try {
        $ErrorActionPreference = "Continue"
        & $nodeCommand.Source $jsOut *> $webRunLog
        $webRunCode = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $savedErrorActionPreference
    }
    $webRunText = Read-TextSafe $webRunLog
    if ($webRunCode -eq 0 -or $webRunText -notmatch "UXB host binding missing: DLL") {
        throw "native Python bridge did not fail closed at JS runtime exit=$webRunCode"
    }
}

@{
    schema = "uxb.library_uxpython_test.v1"
    status = "PASS"
    python_runtime = $pythonDll
    cases = @("ast","mir","ast_negative","mir_negative","x64_ast","web_fail_close")
} | ConvertTo-Json -Depth 6 | Set-Content (Join-Path $report "uxpython_test_results.json") -Encoding UTF8

Write-Host "PASS: Python bridge AST, MIR, AST-x64, negative validation and web fail-close tests"
