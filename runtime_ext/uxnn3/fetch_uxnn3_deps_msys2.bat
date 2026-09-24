@echo off
echo Run this in MSYS2 UCRT64 shell if pacman is not available from CMD:
echo   pacman -Syu
echo   pacman -S mingw-w64-ucrt-x86_64-gcc
where pacman >nul 2>nul
if errorlevel 1 exit /b 0
pacman -S --needed mingw-w64-ucrt-x86_64-gcc
