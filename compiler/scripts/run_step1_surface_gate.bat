@echo off
setlocal
cd /d "%~dp0..\.."
python tools\audit\uxb_build_keyword_layer_matrix.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_keyword_layer_gate.py
endlocal
