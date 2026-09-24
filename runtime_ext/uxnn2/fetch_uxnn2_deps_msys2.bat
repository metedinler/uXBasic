@echo off
setlocal
set "PACMAN=C:\msys64\usr\bin\pacman.exe"
if not exist "%PACMAN%" (
  echo ERROR: MSYS2 pacman not found. Install MSYS2 first.
  exit /b 2
)
"%PACMAN%" -S --needed mingw-w64-ucrt-x86_64-gcc
endlocal
