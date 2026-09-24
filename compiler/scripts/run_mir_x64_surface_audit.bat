@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_mir_x64_surface_audit.py
endlocal
