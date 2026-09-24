@echo off
setlocal

if "%~1"=="" (
  echo Usage: build.bat path\to\main.bas
  exit /b 1
)

fbc -lang fb "%~1" -x "%~dpn1.exe"
if errorlevel 1 (
  echo Build failed.
  exit /b 1
)

echo Build ok: "%~dpn1.exe"
exit /b 0
