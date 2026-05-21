@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxb_fp128.dll"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install MSYS2, then run:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

"%GCC%" -O2 -shared -o "%OUTDLL%" "uxb\runtime_ext\fp128\uxb_fp128_quad.c" -lquadmath
if errorlevel 1 (
  echo ERROR: FP128 DLL build failed.
  echo Check MSYS2 UCRT64 GCC and libquadmath availability.
  exit /b 1
)

echo OK: %OUTDLL%
endlocal
