param(
    [string]$Root = "",
    [switch]$SkipWebFailClose,
    [switch]$SkipBuild,
    [switch]$RequireMirX64
)
$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Root)) {
    $Root = (Resolve-Path "$PSScriptRoot\..\..").Path
} else {
    $Root = (Resolve-Path $Root).Path
}
Set-Location $Root

$report = Join-Path $Root "reports\libraries\tests\abi10"
$work = Join-Path $Root "build\libraries\tests\abi10"
$logDir = Join-Path $Root "reports\libraries\logs"
$distBin = Join-Path $Root "dist\libraries\bin"
New-Item -ItemType Directory -Force $report,$work,$logDir,$distBin | Out-Null

$invocationLog = Join-Path $report "abi10_invocations.log"
"ABI10 smoke run: $(Get-Date -Format o)" | Set-Content $invocationLog -Encoding UTF8
"ROOT=$Root" | Add-Content $invocationLog -Encoding UTF8

if (!$SkipBuild) {
    & "$Root\compiler\scripts\build_libraries.ps1" -Root $Root -Library uxffi -StrictRuntime
    if ($LASTEXITCODE -ne 0) { throw "uxffi build/deploy failed" }
}

$abiBuildLog = Join-Path $logDir "abi10_test_dll_gcc.log"
& "$Root\tests\libraries\abi10\build_abi10_test_dll.ps1" -Root $Root
if ($LASTEXITCODE -ne 0) {
    if (Test-Path $abiBuildLog) { Get-Content $abiBuildLog -Tail 120 | Write-Host }
    throw "ABI10 test DLL build failed; log=$abiBuildLog"
}

$uxb = Join-Path $Root "bin\uxb.exe"
if (!(Test-Path $uxb)) { throw "bin\uxb.exe bulunamadi" }
$env:PATH = "$Root\bin;$env:PATH"

$srcRel = "tests\libraries\abi10\abi10_smoke.uxb"
$srcAbs = Join-Path $Root $srcRel
if (!(Test-Path $srcAbs)) { throw "ABI10 source missing: $srcAbs" }

$rows = @()

function Read-TextSafe([string]$Path) {
    if (Test-Path $Path) { return (Get-Content $Path -Raw) }
    return ""
}

function Invoke-UxbRaw([string]$Name, [string[]]$CliArgs) {
    $procStdout = Join-Path $script:report "$Name.process.stdout.txt"
    $procStderr = Join-Path $script:report "$Name.process.stderr.txt"
    if (Test-Path $procStdout) { Remove-Item -Force $procStdout }
    if (Test-Path $procStderr) { Remove-Item -Force $procStderr }

    "CASE=$Name" | Add-Content $script:invocationLog -Encoding UTF8
    "ARGS=$($CliArgs -join ' ')" | Add-Content $script:invocationLog -Encoding UTF8

    & $script:uxb @CliArgs 1> $procStdout 2> $procStderr
    $code = $LASTEXITCODE
    "EXIT=$code" | Add-Content $script:invocationLog -Encoding UTF8
    if (Test-Path $procStdout) { "STDOUT=$procStdout" | Add-Content $script:invocationLog -Encoding UTF8 }
    if (Test-Path $procStderr) { "STDERR=$procStderr" | Add-Content $script:invocationLog -Encoding UTF8 }

    return [pscustomobject]@{
        code=$code
        procStdout=$procStdout
        procStderr=$procStderr
        stdoutText=(Read-TextSafe $procStdout)
        stderrText=(Read-TextSafe $procStderr)
    }
}

function Run-Case([string]$Name, [string[]]$BodyArgs, [bool]$ExpectSuccess=$true) {
    $stdoutOut = Join-Path $script:report "$Name.stdout.txt"
    $stderrOut = Join-Path $script:report "$Name.stderr.txt"
    $programOut = Join-Path $script:report "$Name.program_output.txt"
    $execJsonOut = Join-Path $script:report "$Name.exec_result.json"
    foreach ($p in @($stdoutOut,$stderrOut,$programOut,$execJsonOut)) {
        if (Test-Path $p) { Remove-Item -Force $p }
    }

    # ABI10_GENERIC_EXEC_OUTPUT_FIX_20260711:
    # Use both the legacy generic output contract and the explicit backend
    # output contract.  AST used to satisfy --stdout-out through the global
    # console, while MIR keeps stdout in its UXBInterpResult.  Passing
    # --mir-stdout-out makes the smoke test independent from that implementation
    # detail, and the compiler patch mirrors MIR output back to generic paths too.
    $backendOutArgs = @()
    if ($Name -like "ast*") {
        $backendOutArgs = @(
            "--ast-stdout-out", $stdoutOut,
            "--ast-stderr-out", $stderrOut,
            "--ast-program-output-out", $programOut,
            "--ast-exec-result-json-out", $execJsonOut
        )
    } elseif ($Name -like "mir*") {
        $backendOutArgs = @(
            "--mir-stdout-out", $stdoutOut,
            "--mir-stderr-out", $stderrOut,
            "--mir-program-output-out", $programOut,
            "--mir-exec-result-json-out", $execJsonOut
        )
    }

    # The current compiler accepts --source/-s explicitly. Do not rely on positional source parsing.
    $primaryArgs = @("--source", $script:srcRel) + $BodyArgs + @(
        "--stdout-out", $stdoutOut,
        "--stderr-out", $stderrOut,
        "--program-output-out", $programOut
    ) + $backendOutArgs
    $result = Invoke-UxbRaw $Name $primaryArgs

    # Defensive fallback for older CLI builds: retry with -s only if the compiler still says source is missing.
    if ($result.code -ne 0 -and (($result.stdoutText + $result.stderrText) -match "source file path not provided|Kaynak dosya yolu verilmedi")) {
        "RETRY_WITH=-s" | Add-Content $script:invocationLog -Encoding UTF8
        $fallbackArgs = @("-s", $script:srcRel) + $BodyArgs + @(
            "--stdout-out", $stdoutOut,
            "--stderr-out", $stderrOut,
            "--program-output-out", $programOut
        ) + $backendOutArgs
        $result = Invoke-UxbRaw ($Name + "_retry_s") $fallbackArgs
    }

    $combined = ($result.stdoutText + "`n" + $result.stderrText + "`n" + (Read-TextSafe $stdoutOut) + "`n" + (Read-TextSafe $stderrOut) + "`n" + (Read-TextSafe $programOut) + "`n" + (Read-TextSafe $execJsonOut))
    $ok = if ($ExpectSuccess) {
        $result.code -eq 0 -and ($combined -match "PASS_ABI10")
    } else {
        $result.code -ne 0
    }

    $script:rows += [pscustomobject]@{
        name=$Name
        exit_code=$result.code
        expected_success=$ExpectSuccess
        status=if($ok){"PASS"}else{"FAIL"}
        stdout=$stdoutOut
        stderr=$stderrOut
        program_output=$programOut
        exec_result_json=$execJsonOut
        process_stdout=$result.procStdout
        process_stderr=$result.procStderr
        args=("--source " + $script:srcRel + " " + ($BodyArgs -join " "))
    }

    if (!$ok) {
        Write-Host "--- $Name process stdout ---"
        if (Test-Path $result.procStdout) { Get-Content $result.procStdout -Tail 120 | Write-Host }
        Write-Host "--- $Name process stderr ---"
        if (Test-Path $result.procStderr) { Get-Content $result.procStderr -Tail 120 | Write-Host }
        Write-Host "--- $Name compiler stdout-out ---"
        if (Test-Path $stdoutOut) { Get-Content $stdoutOut -Tail 120 | Write-Host }
        Write-Host "--- $Name compiler stderr-out ---"
        if (Test-Path $stderrOut) { Get-Content $stderrOut -Tail 120 | Write-Host }
        Write-Host "--- $Name program-output-out ---"
        if (Test-Path $programOut) { Get-Content $programOut -Tail 120 | Write-Host }
        throw "ABI10 test failed: $Name exit=$($result.code); invocation_log=$script:invocationLog"
    }
}

Run-Case "ast" @("--execmem", "--interpreter-backend", "AST", "--console-mode", "direct")
Run-Case "mir" @("--execmem", "--interpreter-backend", "MIR", "--mir-verify", "--console-mode", "direct")

# X64_BUILD_DIR_CONTRACT_FIX_20260712:
# The compiler currently treats --build-x64-out as an artifact directory and
# writes program.exe under it.  Do not pass a path named *.exe as the directory;
# use a real build directory and run its program.exe.
$x64BuildDir = Join-Path $work "abi10_x64_ast_build"
$x64exe = Join-Path $x64BuildDir "program.exe"
$x64BuildStdout = Join-Path $report "x64_ast_build.process.stdout.txt"
$x64BuildStderr = Join-Path $report "x64_ast_build.process.stderr.txt"
$x64out = Join-Path $report "x64_ast.stdout.txt"
foreach ($p in @($x64BuildDir,$x64BuildStdout,$x64BuildStderr,$x64out)) {
    if (Test-Path $p) { Remove-Item -LiteralPath $p -Force -Recurse -ErrorAction SilentlyContinue }
}
$x64Args = @("--source", $srcRel, "--build-x64", "--build-x64-out", $x64BuildDir, "--codegen-source", "AST")
"CASE=x64_ast_build" | Add-Content $invocationLog -Encoding UTF8
"ARGS=$($x64Args -join ' ')" | Add-Content $invocationLog -Encoding UTF8
# X64_NATIVE_COMMAND_ERROR_CAPTURE_FIX_20260712:
# PowerShell may convert native stderr/non-zero exit into a NativeCommandError
# when $ErrorActionPreference is Stop.  Keep the smoke runner alive long enough
# to record LASTEXITCODE and the x64 artifact logs.
$oldErrorActionPreference = $ErrorActionPreference
$oldPSNative = $null
if (Get-Variable -Name PSNativeCommandUseErrorActionPreference -Scope Global -ErrorAction SilentlyContinue) {
    $oldPSNative = $Global:PSNativeCommandUseErrorActionPreference
    $Global:PSNativeCommandUseErrorActionPreference = $false
}
$ErrorActionPreference = "Continue"
try {
    & $uxb @x64Args 1> $x64BuildStdout 2> $x64BuildStderr
    $x64BuildExit = $LASTEXITCODE
} catch {
    $x64BuildExit = if ($LASTEXITCODE -ne $null) { $LASTEXITCODE } else { 1 }
    ("NATIVE_EXCEPTION=" + $_.Exception.Message) | Add-Content $x64BuildStderr -Encoding UTF8
} finally {
    $ErrorActionPreference = $oldErrorActionPreference
    if ($oldPSNative -ne $null) { $Global:PSNativeCommandUseErrorActionPreference = $oldPSNative }
}
"EXIT=$x64BuildExit" | Add-Content $invocationLog -Encoding UTF8
if ($x64BuildExit -ne 0 -or !(Test-Path $x64exe)) {
    if (Test-Path $x64BuildStdout) { Get-Content $x64BuildStdout -Tail 160 | Write-Host }
    if (Test-Path $x64BuildStderr) { Get-Content $x64BuildStderr -Tail 160 | Write-Host }
    $buildStdout = Join-Path $x64BuildDir "build_all.stdout.txt"
    $buildStderr = Join-Path $x64BuildDir "build_all.stderr.txt"
    if (Test-Path $buildStdout) { Write-Host "--- x64 build_all stdout ---"; Get-Content $buildStdout -Tail 160 | Write-Host }
    if (Test-Path $buildStderr) { Write-Host "--- x64 build_all stderr ---"; Get-Content $buildStderr -Tail 160 | Write-Host }
    throw "ABI10 AST-x64 build failed exit=$x64BuildExit; build_dir=$x64BuildDir; invocation_log=$invocationLog"
}
& $x64exe 1> $x64out 2>&1
$x64RunExit = $LASTEXITCODE
if ($x64RunExit -ne 0 -or ((Read-TextSafe $x64out) -notmatch "PASS_ABI10")) {
    if (Test-Path $x64out) { Get-Content $x64out -Tail 120 | Write-Host }
    throw "ABI10 AST-x64 runtime failed exit=$x64RunExit"
}
$rows += [pscustomObject]@{
    name="x64_ast"; exit_code=$x64RunExit; expected_success=$true; status="PASS"
    stdout=$x64out; stderr=""; program_output=""; process_stdout=$x64out; process_stderr=""
    args=("--source " + $srcRel + " --build-x64 --codegen-source AST")
}

if ($RequireMirX64) {
    $mirX64BuildDir = Join-Path $work "abi10_x64_mir"
    $mirX64Exe = Join-Path $mirX64BuildDir "program.exe"
    $mirX64BuildStdout = Join-Path $report "x64_mir_build.process.stdout.txt"
    $mirX64BuildStderr = Join-Path $report "x64_mir_build.process.stderr.txt"
    $mirX64Out = Join-Path $report "x64_mir.stdout.txt"
    foreach ($p in @($mirX64BuildDir,$mirX64BuildStdout,$mirX64BuildStderr,$mirX64Out)) {
        # X64_DLL_CALL_RETURN_TYPE_FIX_20260711: same recursive cleanup for optional MIR-x64 artifacts.
        if (Test-Path $p) { Remove-Item -LiteralPath $p -Force -Recurse -ErrorAction SilentlyContinue }
    }
    $mirArgs = @("--source", $srcRel, "--build-x64", "--build-x64-out", $mirX64BuildDir, "--codegen-source", "MIR", "--x64-mode", "MIR", "--mir-verify")
    & $uxb @mirArgs 1> $mirX64BuildStdout 2> $mirX64BuildStderr
    $mirBuildExit = $LASTEXITCODE
    if ($mirBuildExit -ne 0 -or !(Test-Path $mirX64Exe)) { throw "ABI10 experimental MIR-x64 build failed exit=$mirBuildExit" }
    & $mirX64Exe 1> $mirX64Out 2>&1
    $mirRunExit = $LASTEXITCODE
    if ($mirRunExit -ne 0 -or ((Read-TextSafe $mirX64Out) -notmatch "PASS_ABI10")) { throw "ABI10 experimental MIR-x64 runtime failed exit=$mirRunExit" }
    $rows += [pscustomObject]@{name="x64_mir";exit_code=$mirRunExit;expected_success=$true;status="PASS";stdout=$mirX64Out;stderr="";program_output="";process_stdout=$mirX64Out;process_stderr="";args=("--source " + $srcRel + " --build-x64 --codegen-source MIR")}
}

if (!$SkipWebFailClose) {
    Run-Case "js_fail_close" @("--emit-js", "--js-out", (Join-Path $work "abi10.js")) $false
    Run-Case "wat_fail_close" @("--emit-wat", "--wat-out", (Join-Path $work "abi10.wat")) $false
    Run-Case "wasm_fail_close" @("--emit-wasm", "--wasm-out", (Join-Path $work "abi10.wasm")) $false
}

$rows | Export-Csv (Join-Path $report "abi10_test_results.csv") -NoTypeInformation -Encoding UTF8
@{schema="uxb.library_abi10_test.v3";status="PASS";rows=$rows;invocation_log=$invocationLog} | ConvertTo-Json -Depth 8 | Set-Content (Join-Path $report "abi10_test_results.json") -Encoding UTF8
Write-Host "PASS: AST interpreter, MIR interpreter, AST-x64 and web fail-close ABI10 tests"
