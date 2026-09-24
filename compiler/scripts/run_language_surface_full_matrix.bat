@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_language_surface_full_matrix.py %*
endlocal
