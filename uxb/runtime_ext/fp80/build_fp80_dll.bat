@echo off
setlocal
cd /d "%~dp0..\..\.."
set "FBC=tools\FreeBASIC-1.10.1-win64\fbc.exe"
if not exist "%FBC%" (
  echo ERROR: FreeBASIC compiler not found: %FBC%
  exit /b 2
)
if not exist "uxb\dist" mkdir "uxb\dist"
"%FBC%" -lang fb -dll -arch x86_64 "uxb\runtime_ext\fp80\uxb_fp80_fb.bas" -x "uxb\dist\uxb_fp80.dll"
if errorlevel 1 (
  echo ERROR: FP80 DLL build failed. This toolchain may not support Extended/F80 on win64.
  echo ERROR: Keep FP policy diagnostic-only until a compatible runtime toolchain is provided.
  exit /b 1
)
echo OK: uxb\dist\uxb_fp80.dll
endlocal
