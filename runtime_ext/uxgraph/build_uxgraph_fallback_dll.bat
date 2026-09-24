@echo off
setlocal
cd /d "%~dp0..\..\.."

set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
set "OUTDLL=%OUTDIR%\uxgraph.dll"

if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)

if not exist "%OUTDIR%" mkdir "%OUTDIR%"

echo INFO: Building uxgraph.dll with the built-in graph algorithms.
"%GCC%" -O2 -shared -o "%OUTDLL%" "uxb\runtime_ext\uxgraph\uxgraph_igraph.c"
if errorlevel 1 exit /b 1

echo OK: %OUTDLL%
endlocal
