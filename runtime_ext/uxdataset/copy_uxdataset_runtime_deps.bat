@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "DST=uxb\dist\runtime_ext\deps\uxdataset"
if not exist "%DST%" mkdir "%DST%"
for %%F in (libgcc_s_seh-1.dll libwinpthread-1.dll libstdc++-6.dll) do (
  if exist "C:\msys64\ucrt64\bin\%%F" copy /Y "C:\msys64\ucrt64\bin\%%F" "%DST%\%%F" >nul
)
if exist "uxb\dist\runtime_ext\uxdataset.dll" copy /Y "uxb\dist\runtime_ext\uxdataset.dll" "%DST%\uxdataset.dll" >nul
echo OK: copied uxdataset runtime deps to %DST%
endlocal
