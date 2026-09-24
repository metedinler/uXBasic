@echo off
setlocal EnableExtensions
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..") do set "UXB_ROOT=%%~fI"
set "VARIANT=full"
set "HAS_UV=0"
set "HAS_TBB=0"
:parse
if "%~1"=="" goto parsed
if /I "%~1"=="--std" set "VARIANT=std"
if /I "%~1"=="--auto" set "VARIANT=auto"
if /I "%~1"=="--libuv" set "HAS_UV=1"
if /I "%~1"=="--tbb" set "HAS_TBB=1"
if /I "%~1"=="--full" set "HAS_UV=1"& set "HAS_TBB=1"
shift
goto parse
:parsed
if "%HAS_UV%%HAS_TBB%"=="10" set "VARIANT=libuv"
if "%HAS_UV%%HAS_TBB%"=="01" set "VARIANT=tbb"
if "%HAS_UV%%HAS_TBB%"=="11" set "VARIANT=full"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%build_runtime_dll.ps1" -Root "%UXB_ROOT%" -Variant %VARIANT%
exit /b %ERRORLEVEL%
