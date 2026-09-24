@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_MSYS2_ROOT (set "MSYS2_ROOT=%UXB_MSYS2_ROOT%") else set "MSYS2_ROOT=C:\msys64"
set "GCC_BIN=%MSYS2_ROOT%\ucrt64\bin"
set "GCC=%GCC_BIN%\x86_64-w64-mingw32-gcc.exe"
set "PATH=%GCC_BIN%;%PATH%"
set "OUT=%UXB_ROOT%\dist\libraries\bin"
if not exist "%GCC%" (
  echo ERROR: GCC bulunamadi: %GCC%
  exit /b 2
)
if not exist "%OUT%" mkdir "%OUT%"

"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -Wno-unused-parameter -Wno-unused-function -Wno-implicit-fallthrough -shared -static-libgcc -I"%MSYS2_ROOT%\ucrt64\include" -o "%OUT%\uxraylib.dll" "%~dp0uxraylib_adapter.c" -L"%MSYS2_ROOT%\ucrt64\lib" -lraylib
if errorlevel 1 exit /b 1

"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -shared -static-libgcc -I"%MSYS2_ROOT%\ucrt64\include" -o "%OUT%\uxsdl3.dll" "%~dp0uxsdl3_adapter.c" -L"%MSYS2_ROOT%\ucrt64\lib" -lSDL3
if errorlevel 1 exit /b 1

copy /y "%MSYS2_ROOT%\ucrt64\bin\libraylib.dll" "%OUT%\libraylib.dll" >nul
copy /y "%MSYS2_ROOT%\ucrt64\bin\glfw3.dll" "%OUT%\glfw3.dll" >nul
if errorlevel 1 exit /b 1
copy /y "%MSYS2_ROOT%\ucrt64\bin\SDL3.dll" "%OUT%\SDL3.dll" >nul

"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -o "%~dp0wrapper_smoke.exe" "%~dp0wrapper_smoke.c" -L"%OUT%" -luxraylib -luxsdl3
if errorlevel 1 exit /b 1
set "PATH=%OUT%;%PATH%"
"%~dp0wrapper_smoke.exe"
if errorlevel 1 exit /b 1
echo PASS: raylib/raygui primary and SDL3 backup wrappers
exit /b 0
