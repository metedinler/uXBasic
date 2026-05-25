@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_workspace_clean_guard.bat (
  call uxb\compiler\scripts\run_workspace_clean_guard.bat
)

python uxb\tools\uxb_step5_fp_completion_audit.py
python uxb\tools\uxb_codegen_regression_guard.py --root . --current uxb\src\codegen\x64\mir_x64_codegen.fbs

echo.
echo Step 5 raporlari:
echo   uxb\dist\step5\step5_fp_completion_audit.md
echo   uxb\dist\step5\copilot_step5_missing_work.md
echo   uxb\dist\step5\codegen_regression_guard.md
endlocal
