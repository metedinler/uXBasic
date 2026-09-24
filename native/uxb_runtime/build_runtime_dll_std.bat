@echo off
setlocal
set ROOT=%~dp0..\..
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_runtime_dll.ps1" -Root "%ROOT%" -Variant std
exit /b %ERRORLEVEL%
