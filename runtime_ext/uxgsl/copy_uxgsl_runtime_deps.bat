@echo off
setlocal
cd /d "%~dp0\..\..\.."

set "BINDIR=C:\msys64\ucrt64\bin"
set "OUTDIR=uxb\dist\runtime_ext"
set "RUNTIMEBIN=uxb\bin"
set "UXGSLDLL=%OUTDIR%\uxgsl.dll"
if not exist "%BINDIR%" (
  echo ERROR: MSYS2 UCRT64 runtime directory not found: %BINDIR%
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
if not exist "%RUNTIMEBIN%" mkdir "%RUNTIMEBIN%"
if not exist "%UXGSLDLL%" (
  echo ERROR: UXGSL facade DLL was not built: %UXGSLDLL%
  exit /b 4
)

rem Keep bin in sync with dist/runtime_ext to prevent stale facade exports.
copy /Y "%UXGSLDLL%" "%RUNTIMEBIN%\uxgsl.dll" >nul

set "COPIED=0"
for %%F in ("%BINDIR%\libgsl*.dll") do (
  if exist "%%~fF" (
    copy /Y "%%~fF" "%OUTDIR%\" >nul
    copy /Y "%%~fF" "%RUNTIMEBIN%\" >nul
    set "COPIED=1"
  )
)
if "%COPIED%"=="0" (
  echo ERROR: libgsl runtime DLLs were not found in %BINDIR%
  exit /b 3
)
exit /b 0
