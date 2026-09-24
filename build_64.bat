@echo off
setlocal

if "%~1"=="" (
  echo Usage: build_64.bat path\to\main.bas
  exit /b 1
)

set "FBC64=%~dp0tools\FreeBASIC-1.10.1-win64\fbc.exe"
if not exist "%FBC64%" (
  echo Missing local win64 FreeBASIC toolchain: "%FBC64%"
  echo Run: tools\setup_win64_toolchain.bat
  exit /b 1
)

"%FBC64%" -lang fb -arch x86_64 "%~1" -x "%~dpn1_64.exe"
if errorlevel 1 (
  echo Build 64-bit failed.
  exit /b 1
)

echo Build 64-bit ok: "%~dpn1_64.exe"
exit /b 0
