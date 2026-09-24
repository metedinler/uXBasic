@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxbc_baseline_runner.py %*
endlocal
