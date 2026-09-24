@echo off
setlocal
cd /d "%~dp0..\.."
python tools\audit\uxb_build_keyword_layer_matrix.py
endlocal
