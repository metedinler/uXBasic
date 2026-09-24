@echo off
setlocal
cd /d "%~dp0..\.."
python tools\audit\uxb_ast_contract_build_matrix.py
endlocal
