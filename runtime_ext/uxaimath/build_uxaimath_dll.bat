@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Run: uxb\runtime_ext\uxaimath\fetch_uxaimath_deps_msys2.bat
  exit /b 2
)
"%GCC%" -O2 -shared -DUXAIMATH_USE_CBLAS -IC:\msys64\ucrt64\include -o "%OUTDIR%\uxaimath.dll" "uxb\runtime_ext\uxaimath\uxaimath.c" -LC:\msys64\ucrt64\lib -lopenblas
if errorlevel 1 (
  echo ERROR: OpenBLAS build failed. Try fallback:
  echo   uxb\runtime_ext\uxaimath\build_uxaimath_fallback_dll.bat
  exit /b 1
)
call uxb\runtime_ext\uxaimath\copy_uxaimath_runtime_deps.bat
exit /b %ERRORLEVEL%
