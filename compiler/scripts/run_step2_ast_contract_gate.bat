@echo off
setlocal
cd /d "%~dp0..\.."
python tools\audit\uxb_ast_contract_collect_parser_nodes.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_ast_contract_collect_contract_nodes.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_ast_contract_collect_handlers.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_ast_contract_build_matrix.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_ast_contract_fake_status_scan.py
if errorlevel 1 exit /b %errorlevel%
python tools\audit\uxb_ast_contract_gate.py
endlocal
