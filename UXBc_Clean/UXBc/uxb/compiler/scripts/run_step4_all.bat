@echo off
setlocal
pushd %~dp0\..\..
python tools\audit\uxb_mir_collect_opcodes.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_collect_lowering_handlers.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_collect_verify_rules.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_build_opcode_matrix.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_build_ast_to_mir_matrix.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_build_verify_matrix.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_step4_fake_status_scan.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_no_unknown_gate.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_json_schema_gate.py
if errorlevel 1 exit /b 1
python tools\audit\uxb_mir_gate.py
if errorlevel 1 exit /b 1
popd
exit /b 0
