@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxb_fp80.dll"
set "IMPLIB=%OUTDIR%\libuxb_fp80.dll.a"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install MSYS2, then run:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set "PATH=C:\msys64\ucrt64\bin;%PATH%"

"%GCC%" -O2 -shared -o "%OUTDLL%" "uxb\runtime_ext\fp80\uxb_fp80_ld.c" -Wl,--out-implib,"%IMPLIB%" -lquadmath
if errorlevel 1 (
  echo ERROR: FP80 DLL build failed.
  echo ERROR: Check MSYS2 UCRT64 GCC availability.
  exit /b 1
)

echo OK: %OUTDLL%
endlocal
