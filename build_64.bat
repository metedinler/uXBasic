@echo off
setlocal

if "%~1"=="" (
  echo Usage: build_64.bat path\to\main.bas
  exit /b 1
)

fbc -lang fb -arch x86_64 "%~1" -x "%~dpn1_64.exe"
if errorlevel 1 (
  echo Build 64-bit failed.
  exit /b 1
)

echo Build 64-bit ok: "%~dpn1_64.exe"
exit /b 0
