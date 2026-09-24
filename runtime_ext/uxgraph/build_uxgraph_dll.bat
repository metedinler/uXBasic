@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "PKGCONFIG=C:\msys64\ucrt64\bin\pkg-config.exe"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxgraph.dll"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install MSYS2 UCRT64 and run:
  echo   pacman -S mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-igraph pkgconf
  exit /b 2
)

if not exist "%PKGCONFIG%" (
  echo ERROR: pkg-config not found: %PKGCONFIG%
  echo Install:
  echo   pacman -S pkgconf
  exit /b 2
)

"%PKGCONFIG%" --exists igraph
if errorlevel 1 (
  echo ERROR: igraph package not found by pkg-config.
  echo Install in MSYS2 UCRT64 shell:
  echo   pacman -S mingw-w64-ucrt-x86_64-igraph
  echo If unavailable on your mirror, use build_uxgraph_fallback_dll.bat for the built-in graph algorithms.
  exit /b 3
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

for /f "usebackq delims=" %%i in (`"%PKGCONFIG%" --cflags igraph`) do set "IGRAPH_CFLAGS=%%i"
for /f "usebackq delims=" %%i in (`"%PKGCONFIG%" --libs igraph`) do set "IGRAPH_LIBS=%%i"

"%GCC%" -O2 -shared -DUXGRAPH_USE_IGRAPH %IGRAPH_CFLAGS% -o "%OUTDLL%" "uxb\runtime_ext\uxgraph\uxgraph_igraph.c" %IGRAPH_LIBS%
if errorlevel 1 (
  echo ERROR: uxgraph.dll build failed.
  exit /b 1
)

echo OK: %OUTDLL%
endlocal
