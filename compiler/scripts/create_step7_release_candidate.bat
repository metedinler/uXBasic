@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_workspace_clean_guard.bat (
  call uxb\compiler\scripts\run_workspace_clean_guard.bat
)

python uxb\tools\uxb_final_gap_audit.py
python uxb\tools\uxb_ide_command_contract.py
python uxb\tools\uxb_vscode_contract_audit.py
python uxb\tools\uxb_final_merge.py

echo.
echo Release candidate uretildi. Rapor:
echo   uxb\dist\step7\final_merge_created.md
endlocal
