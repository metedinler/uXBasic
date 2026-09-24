@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_MSYS2_ROOT (set "MSYS2_ROOT=%UXB_MSYS2_ROOT%") else set "MSYS2_ROOT=C:\msys64"
set "GCC_BIN=%MSYS2_ROOT%\ucrt64\bin"
set "PATH=%GCC_BIN%;%PATH%"
set "OUT=%UXB_ROOT%\dist\libraries\bin"
if not exist "%OUT%" mkdir "%OUT%"
"%GCC_BIN%\x86_64-w64-mingw32-gcc.exe" -std=c11 -O2 -Wall -Wextra -Werror -shared -static-libgcc -o "%OUT%\uxterminal.dll" "%~dp0uxterminal.c"
if errorlevel 1 exit /b 1
echo OK: %OUT%\uxterminal.dll
