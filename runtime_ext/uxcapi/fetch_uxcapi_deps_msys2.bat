@echo off
setlocal EnableExtensions
set "PACMAN=C:\msys64\usr\bin\pacman.exe"
if defined UXB_PACMAN set "PACMAN=%UXB_PACMAN%"

if not exist "%PACMAN%" (
  echo ERROR: MSYS2 pacman bulunamadi: %PACMAN%
  exit /b 2
)

"%PACMAN%" -S --needed --noconfirm ^
  mingw-w64-ucrt-x86_64-gcc ^
  mingw-w64-ucrt-x86_64-libffi ^
  mingw-w64-ucrt-x86_64-pkgconf

if errorlevel 1 exit /b 1
echo OK: uxcapi dependencies installed.
exit /b 0
