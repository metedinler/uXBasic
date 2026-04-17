param()

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

$fbc = Join-Path $repoRoot "tools/FreeBASIC-1.10.1-win64/fbc.exe"
if (-not (Test-Path $fbc)) {
    Write-Error "FreeBASIC compiler not found: $fbc"
    exit 1
}

function Invoke-BasTest {
    param(
        [Parameter(Mandatory = $true)][string]$BasPath,
        [Parameter(Mandatory = $true)][string]$ExePath,
        [Parameter(Mandatory = $true)][string]$Label
    )

    & $fbc -lang fb -arch x86_64 $BasPath -x $ExePath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "BUILD FAIL: $Label"
        exit $LASTEXITCODE
    }

    & $ExePath
    if ($LASTEXITCODE -ne 0) {
        Write-Error "RUN FAIL: $Label"
        exit $LASTEXITCODE
    }
}

Invoke-BasTest -BasPath "tests/run_err_codegen_parity_gate.bas" -ExePath "tests/run_err_codegen_parity_gate_64.exe" -Label "err_codegen_parity_gate"
Invoke-BasTest -BasPath "tests/run_err_backend_artifacts.bas" -ExePath "tests/run_err_backend_artifacts_64.exe" -Label "err_backend_artifacts"

if (-not (Test-Path "src/main_64.exe")) {
    & "./build_64.bat" "src/main.bas"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "main_64 build failed"
        exit $LASTEXITCODE
    }
}

$tmpSource = "tests/tmp_err_codegen_parity_gate.uxb"
@"
x = 0
TRY
x = x + 1
THROW 99, "pboom", "pdet"
CATCH
x = x + 10
FINALLY
x = x + 100
END TRY
"@ | Set-Content -Path $tmpSource -Encoding ascii

& "./src/main_64.exe" $tmpSource "--interop"
if ($LASTEXITCODE -ne 0) {
    Write-Error "main_64 interop run failed"
    exit $LASTEXITCODE
}

$mirPath = "dist/interop/err_mir_plan.csv"
$hookPath = "dist/interop/err_backend_hooks.csv"
$asmPath = "dist/interop/err_backend_stubs.asm"

foreach ($p in @($mirPath, $hookPath, $asmPath)) {
    if (-not (Test-Path $p)) {
        Write-Error "missing interop artifact: $p"
        exit 1
    }
}

$mir = Get-Content $mirPath -Raw
$hook = Get-Content $hookPath -Raw
$asm = Get-Content $asmPath -Raw

$mustHave = @(
    @{src="mir"; s="TRY_STMT,TRY_EDGE,TRY_THROW_TO_CATCH"},
    @{src="mir"; s="THROW_STMT,THROW_MATERIALIZE,ERR_OBJECT"},
    @{src="hook"; s="REGISTER_HANDLER_REGION"},
    @{src="hook"; s="UNREGISTER_HANDLER_REGION"},
    @{src="hook"; s="ERR_TRY_EDGE_TRY_THROW_TO_CATCH_"},
    @{src="hook"; s="ERR_THROW_FIELD_DETAIL"},
    @{src="asm"; s="__uxb_err_pending_code_ptr"},
    @{src="asm"; s="__uxb_err_pending_message_ptr"},
    @{src="asm"; s="__uxb_err_pending_detail_ptr"},
    @{src="asm"; s="__uxb_err_get_throw_code_ptr"},
    @{src="asm"; s="__uxb_err_get_throw_message_ptr"},
    @{src="asm"; s="__uxb_err_get_throw_detail_ptr"}
)

foreach ($m in $mustHave) {
    $text = switch ($m.src) {
        "mir" { $mir }
        "hook" { $hook }
        default { $asm }
    }

    if ($text -notlike "*${($m.s)}*") {
        Write-Error "missing parity marker [$($m.src)]: $($m.s)"
        exit 1
    }
}

Write-Output "ERR_CODEGEN_PARITY_GATE_OK"
exit 0
