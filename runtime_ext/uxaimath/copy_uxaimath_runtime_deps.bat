@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "SRC=C:\msys64\ucrt64\bin"
set "DST=uxb\dist\runtime_ext\deps\uxaimath"
if not exist "%DST%" mkdir "%DST%"
for %%F in (libopenblas.dll libgfortran-5.dll libquadmath-0.dll libgcc_s_seh-1.dll libwinpthread-1.dll libstdc++-6.dll) do (
  if exist "%SRC%\%%F" copy /Y "%SRC%\%%F" "%DST%\%%F" >nul
)
if exist "uxb\dist\runtime_ext\uxaimath.dll" copy /Y "uxb\dist\runtime_ext\uxaimath.dll" "%DST%\uxaimath.dll" >nul
exit /b 0
