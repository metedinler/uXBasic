@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
"%GCC%" -O2 -shared -o "%OUTDIR%\uxaimath.dll" "uxb\runtime_ext\uxaimath\uxaimath.c"
if errorlevel 1 exit /b 1
exit /b 0
