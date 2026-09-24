@echo off
setlocal
cd /d "%~dp0..\..\.."
set "DEST=uxb\dist\runtime_ext\deps\uxnn2"
if not exist "%DEST%" mkdir "%DEST%"
if exist uxb\dist\runtime_ext\uxnn2.dll copy /Y uxb\dist\runtime_ext\uxnn2.dll "%DEST%\" >nul
echo OK: uxnn2 dependency cache refreshed: %DEST%
endlocal
