@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install with: uxb\runtime_ext\uxnn3\fetch_uxnn3_deps_msys2.bat
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -shared -o "%OUTDIR%\uxnn3.dll" "uxb\runtime_ext\uxnn3\uxnn3.c" -lm
if errorlevel 1 exit /b 1
echo OK: %OUTDIR%\uxnn3.dll
endlocal
