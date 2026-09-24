@echo off
REM Runs compiler Step3 semantic/type/layout gate through normal compiler pipeline.
if "%~1"=="" (echo Usage: run_step3_semantic_type_layout_gate.bat path\to\test.bas & exit /b 2)
uxbasic.exe "%~1" --semantic-json-out reports\step3\semantic.json --type-json-out reports\step3\type.json --layout-json-out reports\step3\layout.json --target x64 --no-exe
