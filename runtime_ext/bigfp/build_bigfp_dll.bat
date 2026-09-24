@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "BINDIR=uxb\bin"
set "OUTDLL=%OUTDIR%\uxb_bigfp.dll"
set "IMPLIB=%OUTDIR%\libuxb_bigfp.dll.a"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install MSYS2 UCRT64 and run:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-mpfr mingw-w64-ucrt-x86_64-gmp
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set "PATH=C:\msys64\ucrt64\bin;%PATH%"

"%GCC%" -O2 -DUXB_HAVE_GMP -shared -o "%OUTDLL%" ^
  "uxb\runtime_ext\bigfp\uxb_bigfp_mpfr.c" ^
  "uxb\runtime_ext\bigfp\uxb_bigi_gmp.c" ^
  "uxb\runtime_ext\bigfp\uxb_biginit_bridge_adim44.c" ^
  -Wl,--out-implib,"%IMPLIB%" -lmpfr -lgmp
if errorlevel 1 (
  echo ERROR: BIGI/BIGF/BIGD/BALL runtime DLL build failed.
  echo Install dependencies in MSYS2 UCRT64:
  echo   pacman -S mingw-w64-ucrt-x86_64-mpfr mingw-w64-ucrt-x86_64-gmp
  exit /b 1
)

echo OK: %OUTDLL%
if not exist "%BINDIR%" mkdir "%BINDIR%"
copy /y "%OUTDLL%" "%BINDIR%\uxb_bigfp.dll" >nul
for %%D in (libmpfr-6.dll libgmp-10.dll libgcc_s_seh-1.dll libwinpthread-1.dll) do (
  if exist "C:\msys64\ucrt64\bin\%%D" copy /y "C:\msys64\ucrt64\bin\%%D" "%OUTDIR%\%%D" >nul
  if exist "C:\msys64\ucrt64\bin\%%D" copy /y "C:\msys64\ucrt64\bin\%%D" "%BINDIR%\%%D" >nul
)
endlocal
