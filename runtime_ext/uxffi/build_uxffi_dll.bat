@echo off
setlocal EnableExtensions EnableDelayedExpansion
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_GCC (
  set "GCC=%UXB_GCC%"
) else if exist "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe" (
  set "GCC=C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
) else (
  set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
)
if defined UXB_PKG_CONFIG (
  set "PKGCONF=%UXB_PKG_CONFIG%"
) else if exist "C:\msys64\ucrt64\bin\pkg-config.exe" (
  set "PKGCONF=C:\msys64\ucrt64\bin\pkg-config.exe"
) else if exist "C:\msys64\ucrt64\bin\pkgconf.exe" (
  set "PKGCONF=C:\msys64\ucrt64\bin\pkgconf.exe"
) else (
  set "PKGCONF="
)
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "OUT=%UXB_ROOT%\dist\libraries\bin"
set "DEPS=%UXB_ROOT%\dist\libraries\deps"
set "LIB=%UXB_ROOT%\dist\libraries\lib"
set "LOG=%UXB_ROOT%\reports\libraries\logs"
set "SDK=%UXB_ROOT%\dist\libraries\sdk\native\uxffi"
if defined UXB_OBJDUMP (
  set "OBJDUMP=%UXB_OBJDUMP%"
) else (
  set "OBJDUMP=C:\msys64\ucrt64\bin\objdump.exe"
)
for %%D in ("%OUT%" "%DEPS%" "%LIB%" "%LOG%" "%SDK%" "%UXB_ROOT%\bin" "%UXB_ROOT%\dist\runtime_ext") do if not exist "%%~D" mkdir "%%~D"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc bulunamadi: %GCC%
  exit /b 2
)
set "CFLAGS="
set "LIBS="
if not "!PKGCONF!"=="" (
  for /f "usebackq tokens=*" %%i in (`"!PKGCONF!" --cflags libffi 2^>nul`) do set "CFLAGS=%%i"
  for /f "usebackq tokens=*" %%i in (`"!PKGCONF!" --libs libffi 2^>nul`) do set "LIBS=%%i"
)
if "!LIBS!"=="" if exist "C:\msys64\ucrt64\include\ffi.h" if exist "C:\msys64\ucrt64\lib\libffi.dll.a" (
  set "CFLAGS=-IC:\msys64\ucrt64\include"
  set "LIBS=-LC:\msys64\ucrt64\lib -lffi"
)
if "!LIBS!"=="" (
  echo ERROR: libffi gelistirme dosyalari bulunamadi.
  echo Kurulum: C:\msys64\usr\bin\pacman.exe -S --needed --noconfirm mingw-w64-ucrt-x86_64-libffi mingw-w64-ucrt-x86_64-pkgconf
  exit /b 2
)
"%GCC%" -std=c11 -O2 -Wall -Wextra -Werror -shared -static-libgcc !CFLAGS! ^
  -Wl,--enable-auto-import -Wl,--out-implib,"%LIB%\libuxffi.dll.a" ^
  -o "%OUT%\uxffi.dll" "%UXB_ROOT%\runtime_ext\uxffi\uxffi.c" !LIBS! > "%LOG%\uxffi_gcc.log" 2>&1
if errorlevel 1 (
  type "%LOG%\uxffi_gcc.log"
  exit /b 1
)
if not exist "%OBJDUMP%" (
  echo ERROR: objdump bulunamadi: %OBJDUMP%
  exit /b 2
)
"%OBJDUMP%" -f "%OUT%\uxffi.dll" > "%LOG%\uxffi_pe.log" 2>&1
findstr /i /c:"pei-x86-64" "%LOG%\uxffi_pe.log" >nul || (type "%LOG%\uxffi_pe.log" & echo ERROR: uxffi.dll PE32+ x86-64 degil & exit /b 1)
"%OBJDUMP%" -p "%OUT%\uxffi.dll" > "%LOG%\uxffi_exports.log" 2>&1
for %%E in (uxffi_version uxffi_max_args uxffi_invoke10 uxffi_string_length uxffi_copy_string uxffi_release_handle uxffi_clear_handles uxffi_shutdown) do (
  findstr /i /c:"%%E" "%LOG%\uxffi_exports.log" >nul || (type "%LOG%\uxffi_exports.log" & echo ERROR: eksik export %%E & exit /b 1)
)
copy /y "%UXB_ROOT%\runtime_ext\uxffi\uxffi.h" "%SDK%\uxffi.h" >nul
copy /y "%OUT%\uxffi.dll" "%UXB_ROOT%\bin\uxffi.dll" >nul
copy /y "%OUT%\uxffi.dll" "%UXB_ROOT%\dist\runtime_ext\uxffi.dll" >nul
for %%D in ("C:\msys64\ucrt64\bin\libffi-*.dll") do if exist "%%~fD" (
  copy /y "%%~fD" "%DEPS%\%%~nxD" >nul
  copy /y "%%~fD" "%UXB_ROOT%\bin\%%~nxD" >nul
)
echo OK: %OUT%\uxffi.dll
exit /b 0
