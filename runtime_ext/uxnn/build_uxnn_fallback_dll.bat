@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -shared -o "%OUTDIR%\uxnn.dll" "uxb\runtime_ext\uxnn\uxnn.c" -lm
if errorlevel 1 exit /b 1
echo OK: %OUTDIR%\uxnn.dll fallback
endlocal
