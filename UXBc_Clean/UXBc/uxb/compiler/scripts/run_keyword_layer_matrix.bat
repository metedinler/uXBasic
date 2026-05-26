@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_keyword_layer_matrix.py
if errorlevel 1 exit /b %errorlevel%
python uxb\tools\uxb_keyword_layer_decision_gate.py
endlocal
