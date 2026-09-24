@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PKGCONF=C:\msys64\ucrt64\bin\pkg-config.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxmatrix.dll"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install in MSYS2 UCRT64:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-openblas pkgconf
  exit /b 2
)
for %%I in ("%GCC%") do set "PATH=%%~dpI;%PATH%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
set "CFLAGS=-O2 -DUXMATRIX_USE_OPENBLAS -DUXMATRIX_USE_LAPACKE"
set "LIBS=-lopenblas"
if exist "%PKGCONF%" (
  for /f "usebackq tokens=*" %%i in (`"%PKGCONF%" --cflags openblas 2^>nul`) do set "PKG_CFLAGS=%%i"
  for /f "usebackq tokens=*" %%i in (`"%PKGCONF%" --libs openblas 2^>nul`) do set "PKG_LIBS=%%i"
  if not "%PKG_LIBS%"=="" set "LIBS=%PKG_LIBS%"
)
"%GCC%" %CFLAGS% %PKG_CFLAGS% -shared -o "%OUTDLL%" "uxb\runtime_ext\uxmatrix\uxmatrix_openblas.c" %LIBS%
if errorlevel 1 (
  echo ERROR: uxmatrix OpenBLAS/LAPACKE build failed.
  echo Try fallback build without OpenBLAS:
  echo   uxb\runtime_ext\uxmatrix\build_uxmatrix_fallback_dll.bat
  exit /b 1
)
echo OK: %OUTDLL%
endlocal
