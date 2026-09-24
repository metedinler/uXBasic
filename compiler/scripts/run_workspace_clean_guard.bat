@echo off
setlocal
cd /d "%~dp0..\..\.."

python uxb\tools\uxb_workspace_clean_guard.py %*
endlocal
