@echo off
setlocal
rem Compatibility entry point. Canonical system is manifests\uxb_library_system.json.
call "%~dp0build_libraries.bat" -Set all %*
exit /b %ERRORLEVEL%
