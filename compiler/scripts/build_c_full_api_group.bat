@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
set "INSTALL_ARG="
if "%UXB_LIBRARY_FETCH_DEPS%"=="1" set "INSTALL_ARG=-InstallDeps"
where pwsh.exe >nul 2>nul
if %ERRORLEVEL%==0 (
  pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_c_full_api.ps1" -Root "%UXB_ROOT%" %INSTALL_ARG%
) else (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_c_full_api.ps1" -Root "%UXB_ROOT%" %INSTALL_ARG%
)
exit /b %ERRORLEVEL%
