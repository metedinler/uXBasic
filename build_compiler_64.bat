@echo off
setlocal
cd /d "%~dp0"
call uxb\compiler\scripts\build_uxb_main_64.bat
exit /b %ERRORLEVEL%