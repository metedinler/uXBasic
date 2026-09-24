@echo off
setlocal

if "%~1"=="" (
  echo Usage: build_32.bat path\to\main.bas
  exit /b 1
)

fbc -lang fb -arch 386 "%~1" -x "%~dpn1_32.exe"
if errorlevel 1 (
  echo Build 32-bit failed.
  exit /b 1
)

echo Build 32-bit ok: "%~dpn1_32.exe"
exit /b 0
