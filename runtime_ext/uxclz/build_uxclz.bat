@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
if defined UXB_MSYS2_ROOT (set "MSYS2_ROOT=%UXB_MSYS2_ROOT%") else set "MSYS2_ROOT=C:\msys64"
if not defined UXB_CXX if exist "%MSYS2_ROOT%\ucrt64\bin\x86_64-w64-mingw32-g++.exe" set "UXB_CXX=%MSYS2_ROOT%\ucrt64\bin\x86_64-w64-mingw32-g++.exe"
if not defined UXB_CXX set "UXB_CXX=g++"
for %%I in ("%UXB_CXX%") do set "CXX_BIN=%%~dpI"
set "PATH=%CXX_BIN%;%PATH%"
pushd "%~dp0"
if errorlevel 1 exit /b 1
if not exist build mkdir build
echo [uxclz] compiler=%UXB_CXX%
"%UXB_CXX%" -std=gnu++17 -O2 -Wall -Wextra -Wpedantic -DUXCLZ_BUILD_DLL -Iinclude -shared src\uxclz.cpp -o build\uxclz.dll -Wl,--out-implib,build\libuxclz.dll.a -static-libgcc -static-libstdc++
if errorlevel 1 (
  popd
  exit /b 1
)
"%UXB_CXX%" -std=gnu++17 -O2 -Wall -Wextra -Wpedantic -Iinclude tests\uxclz_smoke.cpp -Lbuild -luxclz -o build\uxclz_smoke.exe
if errorlevel 1 (
  popd
  exit /b 1
)
copy /Y build\uxclz.dll build\uxclz_smoke.dll >nul
set "PATH=%CD%\build;%PATH%"
build\uxclz_smoke.exe
set RC=%ERRORLEVEL%
if not "%RC%"=="0" (
  popd
  exit /b %RC%
)
echo [uxclz] PASS
if not exist "%UXB_ROOT%\dist\libraries\bin" mkdir "%UXB_ROOT%\dist\libraries\bin"
if not exist "%UXB_ROOT%\dist\libraries\lib" mkdir "%UXB_ROOT%\dist\libraries\lib"
copy /Y build\uxclz.dll "%UXB_ROOT%\dist\libraries\bin\uxclz.dll" >nul
if errorlevel 1 (
  popd
  exit /b 1
)
copy /Y build\libuxclz.dll.a "%UXB_ROOT%\dist\libraries\lib\libuxclz.dll.a" >nul
if errorlevel 1 (
  popd
  exit /b 1
)
popd
exit /b 0
