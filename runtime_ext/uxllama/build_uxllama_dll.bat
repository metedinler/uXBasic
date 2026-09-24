@echo off
setlocal
cd /d "%~dp0..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUTDIR=uxb\dist\runtime_ext"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Install: pacman -S mingw-w64-ucrt-x86_64-gcc
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -shared -municode -o "%OUTDIR%\uxllama.dll" "uxb\runtime_ext\uxllama\uxllama_cli_bridge.c"
if errorlevel 1 exit /b 1
echo OK: %OUTDIR%\uxllama.dll
endlocal
