@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_workspace_clean_guard.bat (
  call uxb\compiler\scripts\run_workspace_clean_guard.bat
)

python uxb\tools\uxb_step4_type_class_ffi_audit.py

echo.
echo Step 4 raporlari:
echo   uxb\dist\step4\step4_type_class_ffi_audit.md
echo   uxb\dist\step4\copilot_step4_missing_work.md
endlocal
