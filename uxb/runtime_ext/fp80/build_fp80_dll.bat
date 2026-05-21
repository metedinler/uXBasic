@echo off
setlocal
cd /d "%~dp0..\..\.."

set "FBC=tools\FreeBASIC-1.10.1-win64\fbc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxb_fp80.dll"

if not exist "%FBC%" (
  echo ERROR: FreeBASIC compiler not found: %FBC%
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%FBC%" -lang fb -dll -arch x86_64 "uxb\runtime_ext\fp80\uxb_fp80_fb.bas" -x "%OUTDLL%"
if errorlevel 1 (
  echo ERROR: FP80 DLL build failed.
  echo ERROR: Keep F80 external runtime disabled until this DLL builds.
  exit /b 1
)

echo OK: %OUTDLL%
endlocal
