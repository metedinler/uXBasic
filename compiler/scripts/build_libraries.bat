@echo off
setlocal
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0build_libraries.ps1" %*
exit /b %ERRORLEVEL%
