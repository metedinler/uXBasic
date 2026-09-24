@echo off
setlocal
cd /d "%~dp0..\..\.."
if "%~1"=="" (
  echo Usage: run_emit_x86_codegen_artifacts.bat source.bas
  exit /b 2
)
if not exist uxb\compiler\wrappers\uxb_main_wrapper_64.exe (
  call build_compiler_64.bat
)
if not exist uxb\dist\x86 mkdir uxb\dist\x86
uxb\compiler\wrappers\uxb_main_wrapper_64.exe "%~1" --interop --artifact-report-json-out "uxb\dist\x86\x86_codegen_artifact_report.json"
if errorlevel 1 exit /b %ERRORLEVEL%
echo.
echo x86 interop/codegen artifacts:
echo   dist\interop\ffi_call_x86_plan.csv
echo   dist\interop\ffi_call_x86_stubs.asm
echo   dist\interop\ffi_call_x86_resolver.csv
echo   uxb\dist\x86\x86_codegen_artifact_report.json
endlocal
