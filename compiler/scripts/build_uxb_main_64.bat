@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
set "FORCE_ARG="
if /I "%~1"=="force" set "FORCE_ARG=-Force"
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_uxb_main_64.ps1" -Root "%UXB_ROOT%" %FORCE_ARG%
exit /b %ERRORLEVEL%
