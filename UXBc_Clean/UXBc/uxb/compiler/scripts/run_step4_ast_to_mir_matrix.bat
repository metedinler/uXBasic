@echo off
setlocal
pushd %~dp0\..\..
python tools\audit\uxb_mir_collect_lowering_handlers.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_build_ast_to_mir_matrix.py
if errorlevel 1 exit /b 1
popd
exit /b 0
