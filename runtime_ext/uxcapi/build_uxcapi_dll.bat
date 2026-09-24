@echo off
setlocal EnableExtensions EnableDelayedExpansion

for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"

if defined UXB_MSYS2_ROOT (
  set "MSYS2_ROOT=%UXB_MSYS2_ROOT%"
) else (
  set "MSYS2_ROOT=C:\msys64"
)

if defined UXB_GCC (
  set "GCC=%UXB_GCC%"
) else if exist "%MSYS2_ROOT%\ucrt64\bin\x86_64-w64-mingw32-gcc.exe" (
  set "GCC=%MSYS2_ROOT%\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
) else (
  set "GCC=%MSYS2_ROOT%\ucrt64\bin\gcc.exe"
)

if defined UXB_PKG_CONFIG (
  set "PKGCONF=%UXB_PKG_CONFIG%"
) else if exist "%MSYS2_ROOT%\ucrt64\bin\pkgconf.exe" (
  set "PKGCONF=%MSYS2_ROOT%\ucrt64\bin\pkgconf.exe"
) else (
  set "PKGCONF=%MSYS2_ROOT%\ucrt64\bin\pkg-config.exe"
)

set "PATH=%MSYS2_ROOT%\ucrt64\bin;%PATH%"
set "OUT=%UXB_ROOT%\dist\libraries\bin"
set "DEPS=%UXB_ROOT%\dist\libraries\deps"
set "LIB=%UXB_ROOT%\dist\libraries\lib"
set "LOG=%UXB_ROOT%\reports\libraries\logs"

for %%D in ("%OUT%" "%DEPS%" "%LIB%" "%LOG%" "%UXB_ROOT%\bin") do (
  if not exist "%%~D" mkdir "%%~D"
)

if not exist "%GCC%" (
  echo ERROR: UCRT64 GCC bulunamadi: %GCC%
  exit /b 2
)

set "CFLAGS="
set "LIBS="
for /f "usebackq tokens=*" %%i in (`"%PKGCONF%" --cflags libffi 2^>nul`) do set "CFLAGS=%%i"
for /f "usebackq tokens=*" %%i in (`"%PKGCONF%" --libs libffi 2^>nul`) do set "LIBS=%%i"

if "!LIBS!"=="" (
  echo ERROR: libffi pkg-config modulu bulunamadi.
  echo Calistirin: runtime_ext\uxcapi\fetch_uxcapi_deps_msys2.bat
  exit /b 2
)

"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror ^
  -shared -static-libgcc !CFLAGS! ^
  -Wl,--enable-auto-import ^
  -Wl,--out-implib,"%LIB%\libuxcapi.dll.a" ^
  -o "%OUT%\uxcapi.dll" ^
  "%UXB_ROOT%\runtime_ext\uxcapi\uxcapi.c" !LIBS! ^
  > "%LOG%\uxcapi_gcc.log" 2>&1

if errorlevel 1 (
  type "%LOG%\uxcapi_gcc.log"
  exit /b 1
)

copy /y "%OUT%\uxcapi.dll" "%UXB_ROOT%\bin\uxcapi.dll" >nul
copy /y "%OUT%\uxcapi.dll" "%OUT%\uxcabi.dll" >nul
copy /y "%OUT%\uxcapi.dll" "%UXB_ROOT%\bin\uxcabi.dll" >nul

for %%D in ("%MSYS2_ROOT%\ucrt64\bin\libffi-*.dll") do if exist "%%~fD" (
  copy /y "%%~fD" "%DEPS%\%%~nxD" >nul
  copy /y "%%~fD" "%UXB_ROOT%\bin\%%~nxD" >nul
)

echo OK: %OUT%\uxcapi.dll
echo OK: %OUT%\uxcabi.dll ^(compatibility alias^)
exit /b 0
