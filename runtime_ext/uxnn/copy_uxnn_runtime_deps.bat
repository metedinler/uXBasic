@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "SRC=C:\msys64\ucrt64\bin"
set "DST=uxb\dist\runtime_ext\deps\uxnn"
if not exist "%DST%" mkdir "%DST%"
for %%F in (libopenblas.dll libgfortran-5.dll libquadmath-0.dll libgcc_s_seh-1.dll libwinpthread-1.dll libstdc++-6.dll) do (
  if exist "%SRC%\%%F" copy /Y "%SRC%\%%F" "%DST%\%%F" >nul
)
if exist "uxb\dist\runtime_ext\uxnn.dll" copy /Y "uxb\dist\runtime_ext\uxnn.dll" "%DST%\uxnn.dll" >nul
echo OK: uxnn runtime deps copied to %DST%
endlocal
