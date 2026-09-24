@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxtensor.dll"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%GCC%" -O2 -shared -DUXTENSOR_NO_OPENBLAS -o "%OUTDLL%" "uxb\runtime_ext\uxtensor\uxtensor.c"
if errorlevel 1 (
  echo ERROR: uxtensor fallback build failed.
  exit /b 1
)

echo OK: %OUTDLL%
endlocal
