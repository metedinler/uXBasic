@echo off
setlocal

if "%~1"=="" (
  echo Usage: build_matrix.bat path\to\main.bas
  exit /b 1
)

call "%~dp0build_32.bat" "%~1"
if errorlevel 1 exit /b 1

call "%~dp0build_64.bat" "%~1"
if errorlevel 1 exit /b 1

echo Build matrix ok.
exit /b 0
