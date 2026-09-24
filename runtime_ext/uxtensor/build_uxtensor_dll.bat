@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "PKGCONF=C:\msys64\ucrt64\bin\pkg-config.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxtensor.dll"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install dependencies using:
  echo   uxb\runtime_ext\uxtensor\fetch_uxtensor_deps_msys2.bat
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

set "CFLAGS="
set "LIBS=-lopenblas"
if exist "%PKGCONF%" (
  for /f "delims=" %%A in ('"%PKGCONF%" --cflags openblas 2^>nul') do set "CFLAGS=%%A"
  for /f "delims=" %%A in ('"%PKGCONF%" --libs openblas 2^>nul') do set "LIBS=%%A"
)

"%GCC%" -O2 -shared %CFLAGS% -o "%OUTDLL%" "uxb\runtime_ext\uxtensor\uxtensor.c" %LIBS%
if errorlevel 1 (
  echo ERROR: uxtensor OpenBLAS build failed.
  echo You may try fallback build:
  echo   uxb\runtime_ext\uxtensor\build_uxtensor_fallback_dll.bat
  exit /b 1
)

echo OK: %OUTDLL%
call uxb\runtime_ext\uxtensor\copy_uxtensor_runtime_deps.bat
endlocal
