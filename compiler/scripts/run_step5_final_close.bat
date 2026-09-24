@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_workspace_clean_guard.bat (
  call uxb\compiler\scripts\run_workspace_clean_guard.bat
)

call uxb\compiler\scripts\run_step5_fp_completion_audit.bat
python uxb\tools\uxb_codegen_regression_guard.py

echo.
echo Step5 final close tamamlandi.
echo   uxb\dist\step5\step5_fp_completion_audit.md
echo   uxb\dist\step5\codegen_regression_guard.md
endlocal
