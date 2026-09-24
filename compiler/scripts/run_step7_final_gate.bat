@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist uxb\compiler\scripts\run_workspace_clean_guard.bat (
  call uxb\compiler\scripts\run_workspace_clean_guard.bat
)

if exist uxb\compiler\scripts\run_step5_final_close.bat (
  call uxb\compiler\scripts\run_step5_final_close.bat
)

if exist uxb\compiler\scripts\run_step6_release_gate.bat (
  call uxb\compiler\scripts\run_step6_release_gate.bat
)

python uxb\tools\uxb_final_gap_audit.py
python uxb\tools\uxb_ide_command_contract.py
python uxb\tools\uxb_vscode_contract_audit.py
python uxb\tools\uxb_final_merge.py --dry-run
python uxb\tools\uxb_step7_gate_compose.py

echo.
echo Step 7 raporlari:
echo   uxb\dist\step7\step7_gate.md
echo   uxb\dist\step7\final_gap_audit.md
echo   uxb\dist\step7\ide_command_contract.md
echo   uxb\dist\step7\vscode_contract_audit.md
echo   uxb\dist\step7\final_merge_dry_run.md
endlocal
