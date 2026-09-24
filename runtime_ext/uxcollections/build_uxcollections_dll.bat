@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxcollections.dll"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install MSYS2 UCRT64 and run:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-glib2 pkgconf
  exit /b 2
)
for %%I in ("%GCC%") do set "PATH=%%~dpI;%PATH%"
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
for /f "usebackq tokens=*" %%I in (`C:\msys64\ucrt64\bin\pkg-config.exe --cflags --libs glib-2.0`) do set "GLIBFLAGS=%%I"
"%GCC%" -O2 -shared -o "%OUTDLL%" "uxb\runtime_ext\uxcollections\uxcollections_glib.c" %GLIBFLAGS%
if errorlevel 1 (
  echo ERROR: uxcollections.dll build failed. Check GLib package and pkg-config.
  exit /b 1
)
echo OK: %OUTDLL%
endlocal
