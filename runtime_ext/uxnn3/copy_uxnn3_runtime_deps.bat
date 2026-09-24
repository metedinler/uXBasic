@echo off
setlocal
cd /d "%~dp0..\..\.."
set "DST=uxb\dist\runtime_ext\deps\uxnn3"
if not exist "%DST%" mkdir "%DST%"
for %%D in (libgcc_s_seh-1.dll libwinpthread-1.dll) do (
  if exist "C:\msys64\ucrt64\bin\%%D" copy /Y "C:\msys64\ucrt64\bin\%%D" "%DST%\" >nul
)
if exist "uxb\dist\runtime_ext\uxnn3.dll" copy /Y "uxb\dist\runtime_ext\uxnn3.dll" "%DST%\" >nul
echo OK: uxnn3 deps copied to %DST%
endlocal
