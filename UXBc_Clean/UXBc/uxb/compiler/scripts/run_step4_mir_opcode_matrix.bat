@echo off
setlocal
pushd %~dp0\..\..
python tools\audit\uxb_mir_collect_opcodes.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_build_opcode_matrix.py
if errorlevel 1 exit /b 1
popd
exit /b 0
