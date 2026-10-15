@echo off
call "%~dp0build_program.bat"
if errorlevel 1 exit /b 1
call "%~dp0link_program.bat"
exit /b %errorlevel%
