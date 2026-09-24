@echo off
setlocal EnableExtensions
set "PACMAN=C:\msys64\usr\bin\pacman.exe"
if not exist "%PACMAN%" (
  echo ERROR: MSYS2 bulunamadi: %PACMAN%
  echo Kurulumdan sonra MSYS2 UCRT64 paketleri gerekir.
  exit /b 2
)
"%PACMAN%" -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-libffi mingw-w64-ucrt-x86_64-pkgconf
if errorlevel 1 exit /b 1
echo OK: uxffi build dependencies installed.
exit /b 0
