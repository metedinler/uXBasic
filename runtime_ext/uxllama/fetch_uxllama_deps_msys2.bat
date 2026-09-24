@echo off
setlocal
set "BASH=C:\msys64\usr\bin\bash.exe"
if not exist "%BASH%" (
  echo ERROR: MSYS2 bash not found. Install MSYS2 first.
  exit /b 2
)
"%BASH%" -lc "pacman -S --needed --noconfirm mingw-w64-ucrt-x86_64-gcc mingw-w64-ucrt-x86_64-cmake mingw-w64-ucrt-x86_64-ninja git"
endlocal
