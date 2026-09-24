@echo off
setlocal EnableExtensions
set "SCRIPT_DIR=%~dp0"
for %%I in ("%SCRIPT_DIR%..\..\..") do set "UXB_ROOT=%%~fI"

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%SCRIPT_DIR%build_abi10_test_dll.ps1" -Root "%UXB_ROOT%"
exit /b %ERRORLEVEL%
