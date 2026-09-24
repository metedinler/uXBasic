@echo off
setlocal
cd /d "%~dp0\..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "GSL_INCLUDE=C:\msys64\ucrt64\include\gsl\gsl_version.h"
set "OUTDIR=uxb\dist\runtime_ext"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 GCC not found: %GCC%
  echo Run: uxb\runtime_ext\uxgsl\fetch_uxgsl_deps_msys2.bat
  exit /b 2
)
if not exist "%GSL_INCLUDE%" (
  echo ERROR: GNU Scientific Library headers not found: %GSL_INCLUDE%
  echo Run: uxb\runtime_ext\uxgsl\fetch_uxgsl_deps_msys2.bat
  exit /b 3
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -std=c11 -shared -DUXGSL_BUILD_DLL -IC:\msys64\ucrt64\include -o "%OUTDIR%\uxgsl.dll" "uxb\runtime_ext\uxgsl\uxgsl.c" -LC:\msys64\ucrt64\lib -lgsl -lgslcblas -lm -Wl,--out-implib,"%OUTDIR%\libuxgsl.dll.a"
if errorlevel 1 exit /b 1

call uxb\runtime_ext\uxgsl\copy_uxgsl_runtime_deps.bat
exit /b %ERRORLEVEL%
