@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxmatrix.dll"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
for %%I in ("%GCC%") do set "PATH=%%~dpI;%PATH%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -shared -o "%OUTDLL%" "uxb\runtime_ext\uxmatrix\uxmatrix_openblas.c"
if errorlevel 1 (
  echo ERROR: uxmatrix fallback build failed.
  exit /b 1
)
echo OK: %OUTDLL%
echo NOTE: fallback build uses built-in GEMM and linear algebra algorithms.
endlocal
