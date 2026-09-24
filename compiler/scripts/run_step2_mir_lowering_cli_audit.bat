@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_language_surface_full_matrix.bat (
  call uxb\compiler\scripts\run_language_surface_full_matrix.bat
)

python uxb\tools\uxb_step2_mir_lowering_cli_audit.py

echo.
echo Step 2 raporlari:
echo   uxb\dist\step2\cli_pipeline_audit.md
echo   uxb\dist\step2\mir_opcode_contract_report.md
echo   uxb\dist\step2\copilot_step4_mir_lowering_targets.md
endlocal
