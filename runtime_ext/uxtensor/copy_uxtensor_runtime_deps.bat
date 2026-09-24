@echo off
setlocal
cd /d "%~dp0..\..\.."
set "BINDIR=C:\msys64\ucrt64\bin"
set "DEPDIR=uxb\dist\runtime_ext\deps\uxtensor"
if not exist "%DEPDIR%" mkdir "%DEPDIR%"
for %%F in (libopenblas.dll libgcc_s_seh-1.dll libgfortran-5.dll libquadmath-0.dll libwinpthread-1.dll libstdc++-6.dll) do (
  if exist "%BINDIR%\%%F" copy /Y "%BINDIR%\%%F" "%DEPDIR%\%%F" >nul
)
if exist "uxb\dist\runtime_ext\uxtensor.dll" copy /Y "uxb\dist\runtime_ext\uxtensor.dll" "%DEPDIR%\uxtensor.dll" >nul
echo OK: uxtensor dependency cache: %DEPDIR%
endlocal
