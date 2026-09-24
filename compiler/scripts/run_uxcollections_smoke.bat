@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."

call tests\uxcollections\build_and_run_uxcollections_probe.bat
if errorlevel 1 exit /b 1

if not exist "bin\uxb.exe" (
  echo ERROR: bin\uxb.exe not found.
  exit /b 2
)

set "PATH=%CD%\bin;%CD%\dist\runtime_ext;C:\msys64\ucrt64\bin;%PATH%"
set "SOURCE=tests\uxcollections\uxcollections_include_smoke.bas"
set "OUTDIR=build\libraries\tests\uxcollections"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

bin\uxb.exe --source "%SOURCE%" --execmem --interpreter-backend AST --console-mode direct
if errorlevel 1 exit /b 1

bin\uxb.exe --source "%SOURCE%" --execmem --interpreter-backend MIR --mir-verify --console-mode direct
if errorlevel 1 exit /b 1

bin\uxb.exe --source "%SOURCE%" --build-x64 --build-x64-out "%OUTDIR%\uxcollections_x64.exe" --codegen-source AST
if errorlevel 1 exit /b 1
"%OUTDIR%\uxcollections_x64.exe"
if errorlevel 1 exit /b 1

echo PASS: uxcollections C DLL, AST, MIR and AST-x64 smoke tests
exit /b 0
