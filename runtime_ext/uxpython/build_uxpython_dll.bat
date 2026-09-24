@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"

if defined UXB_GCC (
  set "GCC=%UXB_GCC%"
) else if exist "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe" (
  set "GCC=C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
) else if exist "C:\msys64\ucrt64\bin\gcc.exe" (
  set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
) else (
  echo ERROR: MSYS2 UCRT64 x64 gcc bulunamadi.
  exit /b 2
)

for %%I in ("%GCC%") do set "PATH=%%~dpI;%PATH%"

set "OUT=%UXB_ROOT%\dist\libraries\bin"
set "LIB=%UXB_ROOT%\dist\libraries\lib"
set "LOG=%UXB_ROOT%\reports\libraries\logs"
for %%D in ("%OUT%" "%LIB%" "%LOG%" "%UXB_ROOT%\bin" "%UXB_ROOT%\dist\runtime_ext") do if not exist "%%~D" mkdir "%%~D"

"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -shared -static-libgcc -DWIN32_LEAN_AND_MEAN ^
  -Wl,--enable-auto-import -Wl,--out-implib,"%LIB%\libuxpython.dll.a" ^
  -o "%OUT%\uxpython.dll" "%UXB_ROOT%\runtime_ext\uxpython\uxpython.c" ^
  > "%LOG%\uxpython_gcc.log" 2>&1
if errorlevel 1 (
  type "%LOG%\uxpython_gcc.log"
  exit /b 1
)

copy /y "%OUT%\uxpython.dll" "%UXB_ROOT%\bin\uxpython.dll" >nul
copy /y "%OUT%\uxpython.dll" "%UXB_ROOT%\dist\runtime_ext\uxpython.dll" >nul

echo OK: %OUT%\uxpython.dll
exit /b 0
