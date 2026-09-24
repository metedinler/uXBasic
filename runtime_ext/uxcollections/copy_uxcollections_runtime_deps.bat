@echo off
setlocal EnableExtensions
for %%I in ("%~dp0..\..") do set "UXB_ROOT=%%~fI"
set "MSYS_BIN=C:\msys64\ucrt64\bin"

for %%F in (libglib-2.0-0.dll libintl-8.dll libiconv-2.dll libpcre2-8-0.dll) do (
  if not exist "%MSYS_BIN%\%%F" (
    echo ERROR: required GLib runtime dependency missing: %%F
    exit /b 1
  )
  for %%D in ("%UXB_ROOT%\dist\libraries\deps" "%UXB_ROOT%\dist\runtime_ext" "%UXB_ROOT%\bin") do (
    if not exist "%%~D" mkdir "%%~D"
    copy /y "%MSYS_BIN%\%%F" "%%~D\%%F" >nul || exit /b 1
  )
)

echo OK: GLib runtime dependency closure deployed beside uxcollections outputs.
exit /b 0
