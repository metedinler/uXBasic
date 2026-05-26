@echo off
setlocal
pushd %~dp0\..\..
python tools\audit\uxb_mir_json_schema_gate.py
if errorlevel 1 exit /b 1
popd
exit /b 0
