@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
where pwsh.exe >nul 2>nul
if %ERRORLEVEL%==0 (
  pwsh.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_freebasic_a_group.ps1" -Root "%UXB_ROOT%" -SkipTests
) else (
  powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_freebasic_a_group.ps1" -Root "%UXB_ROOT%" -SkipTests
)
exit /b %ERRORLEVEL%
