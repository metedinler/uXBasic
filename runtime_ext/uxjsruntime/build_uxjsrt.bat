@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_uxjsrt.ps1" -Root "%~dp0..\.." %*
exit /b %ERRORLEVEL%
