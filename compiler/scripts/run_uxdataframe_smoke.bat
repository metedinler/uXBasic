@echo off
setlocal EnableExtensions
cd /d "%~dp0\..\.."

if not exist "dist\runtime_ext\deps\uxdataframe\include\duckdb.h" (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File runtime_ext\uxdataframe\fetch_uxdataframe_duckdb_deps.ps1
  if errorlevel 1 exit /b 1
)

call runtime_ext\uxdataframe\build_uxdataframe_dll.bat
if errorlevel 1 exit /b 1
call tests\uxdataframe\build_and_run_uxdataframe_probe.bat
if errorlevel 1 exit /b 1

if not exist "bin\uxb.exe" (
  echo ERROR: bin\uxb.exe not found.
  exit /b 2
)

set "PATH=%CD%\bin;%CD%\dist\runtime_ext;%CD%\dist\runtime_ext\deps\uxdataframe\bin;C:\msys64\ucrt64\bin;%PATH%"
set "SOURCE=tests\uxdataframe\uxdataframe_include_smoke.bas"
set "OUTDIR=build\libraries\tests\uxdataframe"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

bin\uxb.exe --source "%SOURCE%" --execmem --interpreter-backend AST --console-mode direct
if errorlevel 1 exit /b 1

bin\uxb.exe --source "%SOURCE%" --execmem --interpreter-backend MIR --mir-verify --console-mode direct
if errorlevel 1 exit /b 1

bin\uxb.exe --source "%SOURCE%" --build-x64 --build-x64-out "%OUTDIR%\uxdataframe_x64.exe" --codegen-source AST
if errorlevel 1 exit /b 1
"%OUTDIR%\uxdataframe_x64.exe"
if errorlevel 1 exit /b 1

echo PASS: uxdataframe DuckDB C probe, AST, MIR and AST-x64 smoke tests
exit /b 0
