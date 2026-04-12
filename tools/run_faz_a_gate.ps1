param(
    [switch]$SkipBuild,
    [switch]$SkipStructureGate,
    [switch]$StrictStructureGate
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Set-Location $repoRoot

function Invoke-Step {
    param(
        [string]$Name,
        [scriptblock]$Action
    )

    Write-Host "[STEP] $Name"
    & $Action
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[FAIL] $Name (exit=$LASTEXITCODE)"
        exit $LASTEXITCODE
    }
    Write-Host "[PASS] $Name"
}

Invoke-Step "Validate test naming" { .\tools\validate_test_naming.ps1 }

if (-not $SkipStructureGate) {
    if ($StrictStructureGate) {
        Invoke-Step "Validate module quality gate (strict)" { .\tools\validate_module_quality_gate.ps1 -Strict }
    } else {
        Invoke-Step "Validate module quality gate" { .\tools\validate_module_quality_gate.ps1 }
    }
}

if (-not $SkipBuild) {
    Invoke-Step "Build main_64" { cmd /c build_64.bat src\main.bas }
    Invoke-Step "Build run_manifest_64" { cmd /c build_64.bat tests\run_manifest.bas }
    Invoke-Step "Build run_file_io_runtime_64" { cmd /c build_64.bat tests\run_file_io_runtime.bas }
    Invoke-Step "Build run_file_io_exec_ast_64" { cmd /c build_64.bat tests\run_file_io_exec_ast.bas }
    Invoke-Step "Build run_file_io_exec_ast_negative_64" { cmd /c build_64.bat tests\run_file_io_exec_ast_negative.bas }
    Invoke-Step "Build run_call_exec_64" { cmd /c build_64.bat tests\run_call_exec.bas }
    Invoke-Step "Build run_call_user_exec_ast_64" { cmd /c build_64.bat tests\run_call_user_exec_ast.bas }
    Invoke-Step "Build run_memory_vm_64" { cmd /c build_64.bat tests\run_memory_vm.bas }
    Invoke-Step "Build run_memory_exec_ast_64" { cmd /c build_64.bat tests\run_memory_exec_ast.bas }
    Invoke-Step "Build run_flow_io_exec_ast_64" { cmd /c build_64.bat tests\run_flow_io_exec_ast.bas }
    Invoke-Step "Build run_if_exec_ast_64" { cmd /c build_64.bat tests\run_if_exec_ast.bas }
    Invoke-Step "Build run_console_state_exec_ast_64" { cmd /c build_64.bat tests\run_console_state_exec_ast.bas }
    Invoke-Step "Build run_case_is_exec_ast_64" { cmd /c build_64.bat tests\run_case_is_exec_ast.bas }
    Invoke-Step "Build run_print_exec_ast_64" { cmd /c build_64.bat tests\run_print_exec_ast.bas }
    Invoke-Step "Build run_print_zone_exec_ast_64" { cmd /c build_64.bat tests\run_print_zone_exec_ast.bas }
    Invoke-Step "Build run_input_exec_ast_64" { cmd /c build_64.bat tests\run_input_exec_ast.bas }
    Invoke-Step "Build run_return_exec_ast_64" { cmd /c build_64.bat tests\run_return_exec_ast.bas }
    Invoke-Step "Build run_jump_exec_ast_64" { cmd /c build_64.bat tests\run_jump_exec_ast.bas }
    Invoke-Step "Build run_end_exec_ast_64" { cmd /c build_64.bat tests\run_end_exec_ast.bas }
    Invoke-Step "Build run_dim_redim_exec_ast_64" { cmd /c build_64.bat tests\run_dim_redim_exec_ast.bas }
    Invoke-Step "Build run_namespace_module_main_parse_64" { cmd /c build_64.bat tests\run_namespace_module_main_parse.bas }
    Invoke-Step "Build run_class_access_friend_parse_64" { cmd /c build_64.bat tests\run_class_access_friend_parse.bas }
    Invoke-Step "Build run_each_exec_64" { cmd /c build_64.bat tests\run_each_exec.bas }
    Invoke-Step "Build run_layout_intrinsics_64" { cmd /c build_64.bat tests\run_layout_intrinsics.bas }
    Invoke-Step "Build run_memory_width_semantics_64" { cmd /c build_64.bat tests\run_memory_width_semantics.bas }
    Invoke-Step "Build run_memory_stride_failfast_64" { cmd /c build_64.bat tests\run_memory_stride_failfast.bas }
    Invoke-Step "Build run_pointer_intrinsic_contract_64" { cmd /c build_64.bat tests\run_pointer_intrinsic_contract.bas }
    Invoke-Step "Build run_runtime_intrinsics_64" { cmd /c build_64.bat tests\run_runtime_intrinsics.bas }
    Invoke-Step "Build run_diagnostics_log_64" { cmd /c build_64.bat tests\run_diagnostics_log.bas }
}

Invoke-Step "Run run_manifest_64" { cmd /c tests\run_manifest_64.exe }
Invoke-Step "Run run_file_io_runtime_64" { cmd /c tests\run_file_io_runtime_64.exe }
Invoke-Step "Run run_file_io_exec_ast_64" { cmd /c tests\run_file_io_exec_ast_64.exe }
Invoke-Step "Run run_file_io_exec_ast_negative_64" { cmd /c tests\run_file_io_exec_ast_negative_64.exe }
Invoke-Step "Run run_call_exec_64" { cmd /c tests\run_call_exec_64.exe }
Invoke-Step "Run run_call_user_exec_ast_64" { cmd /c tests\run_call_user_exec_ast_64.exe }
Invoke-Step "Run run_memory_vm_64" { cmd /c tests\run_memory_vm_64.exe }
Invoke-Step "Run run_memory_exec_ast_64" { cmd /c tests\run_memory_exec_ast_64.exe }
Invoke-Step "Run run_flow_io_exec_ast_64" { cmd /c tests\run_flow_io_exec_ast_64.exe }
Invoke-Step "Run run_if_exec_ast_64" { cmd /c tests\run_if_exec_ast_64.exe }
Invoke-Step "Run run_console_state_exec_ast_64" { cmd /c tests\run_console_state_exec_ast_64.exe }
Invoke-Step "Run run_case_is_exec_ast_64" { cmd /c tests\run_case_is_exec_ast_64.exe }
Invoke-Step "Run run_print_exec_ast_64" { cmd /c tests\run_print_exec_ast_64.exe }
Invoke-Step "Run run_print_zone_exec_ast_64" { cmd /c tests\run_print_zone_exec_ast_64.exe }
Invoke-Step "Run run_input_exec_ast_64" { cmd /c tests\run_input_exec_ast_64.exe }
Invoke-Step "Run run_return_exec_ast_64" { cmd /c tests\run_return_exec_ast_64.exe }
Invoke-Step "Run run_jump_exec_ast_64" { cmd /c tests\run_jump_exec_ast_64.exe }
Invoke-Step "Run run_end_exec_ast_64" { cmd /c tests\run_end_exec_ast_64.exe }
Invoke-Step "Run run_dim_redim_exec_ast_64" { cmd /c tests\run_dim_redim_exec_ast_64.exe }
Invoke-Step "Run run_namespace_module_main_parse_64" { cmd /c tests\run_namespace_module_main_parse_64.exe }
Invoke-Step "Run run_class_access_friend_parse_64" { cmd /c tests\run_class_access_friend_parse_64.exe }
Invoke-Step "Run run_each_exec_64" { cmd /c tests\run_each_exec_64.exe }
Invoke-Step "Run run_layout_intrinsics_64" { cmd /c tests\run_layout_intrinsics_64.exe }
Invoke-Step "Run run_memory_width_semantics_64" { cmd /c tests\run_memory_width_semantics_64.exe }
Invoke-Step "Run run_memory_stride_failfast_64" { cmd /c tests\run_memory_stride_failfast_64.exe }
Invoke-Step "Run run_pointer_intrinsic_contract_64" { cmd /c tests\run_pointer_intrinsic_contract_64.exe }
Invoke-Step "Run run_runtime_intrinsics_64" { cmd /c tests\run_runtime_intrinsics_64.exe }
Invoke-Step "Run run_diagnostics_log_64" { cmd /c tests\run_diagnostics_log_64.exe }

Write-Host "[DONE] Faz A quality gate passed."
exit 0
