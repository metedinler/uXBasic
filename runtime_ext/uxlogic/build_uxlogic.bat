@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_GCC (
  set "GCC=%UXB_GCC%"
) else (
  if defined UXB_MSYS2_ROOT (set "MSYS2_ROOT=%UXB_MSYS2_ROOT%") else set "MSYS2_ROOT=C:\msys64"
  set "GCC=%MSYS2_ROOT%\ucrt64\bin\gcc.exe"
)
if not exist "%GCC%" (
  for %%G in (gcc.exe x86_64-w64-mingw32-gcc.exe) do if not defined GCC_FOUND for /f "delims=" %%P in ('where %%G 2^>nul') do set "GCC_FOUND=%%P"
  if defined GCC_FOUND set "GCC=%GCC_FOUND%"
)
if not exist "%GCC%" (
  echo ERROR: GCC bulunamadi. UXB_GCC veya UXB_MSYS2_ROOT ayarlayin.
  exit /b 2
)
set "OUT=%UXB_ROOT%\dist\libraries\bin"
if not exist "%OUT%" mkdir "%OUT%"
"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -shared -static-libgcc -Wl,--out-implib,"%UXB_ROOT%\dist\libraries\lib\libuxlogic.dll.a" -o "%OUT%\uxlogic.dll" "%~dp0uxlogic.c"
if errorlevel 1 exit /b 1
set "LUA_DLL="
if defined UXB_LUA_DLL if exist "%UXB_LUA_DLL%" set "LUA_DLL=%UXB_LUA_DLL%"
if not defined LUA_DLL for /f "delims=" %%P in ('where lua54.dll 2^>nul') do if not defined LUA_DLL set "LUA_DLL=%%P"
if not defined LUA_DLL if exist "%LOCALAPPDATA%\Programs\Lua\bin\lua54.dll" set "LUA_DLL=%LOCALAPPDATA%\Programs\Lua\bin\lua54.dll"
if defined UXB_MSYS2_ROOT if not defined LUA_DLL if exist "%UXB_MSYS2_ROOT%\ucrt64\bin\lua54.dll" set "LUA_DLL=%UXB_MSYS2_ROOT%\ucrt64\bin\lua54.dll"
if defined LUA_DLL (
  copy /y "%LUA_DLL%" "%OUT%\lua54.dll" >nul
  copy /y "%LUA_DLL%" "%UXB_ROOT%\bin\lua54.dll" >nul
) else (
  echo WARN: lua54.dll bulunamadi; uxlogic.dll yine uretildi. UXB_LUA_DLL veya PATH ayarlanabilir.
)
copy /y "%OUT%\uxlogic.dll" "%UXB_ROOT%\bin\uxlogic.dll" >nul
if not exist "%UXB_ROOT%\dist\libraries\lib" mkdir "%UXB_ROOT%\dist\libraries\lib"
echo OK: %OUT%\uxlogic.dll
exit /b 0
