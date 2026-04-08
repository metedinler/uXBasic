@echo off
setlocal

set "ROOT=%~dp0"
set "DOWNLOAD_DIR=%ROOT%downloads"
set "ZIP_PATH=%DOWNLOAD_DIR%\FreeBASIC-1.10.1-win64.zip"
set "TARGET_DIR=%ROOT%FreeBASIC-1.10.1-win64"
set "URL=https://downloads.sourceforge.net/project/fbc/FreeBASIC-1.10.1/Binaries-Windows/FreeBASIC-1.10.1-win64.zip"

if not exist "%DOWNLOAD_DIR%" mkdir "%DOWNLOAD_DIR%"

if not exist "%TARGET_DIR%\fbc.exe" (
  if not exist "%ZIP_PATH%" (
    echo Downloading FreeBASIC win64 package...
    powershell -NoProfile -ExecutionPolicy Bypass -Command "curl.exe -L '%URL%' -o '%ZIP_PATH%'"
    if errorlevel 1 (
      echo Download failed.
      exit /b 1
    )
  )

  echo Extracting package...
  powershell -NoProfile -ExecutionPolicy Bypass -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%ROOT%' -Force"
  if errorlevel 1 (
    echo Extraction failed.
    exit /b 1
  )
)

if not exist "%TARGET_DIR%\fbc.exe" (
  echo Toolchain setup incomplete: missing fbc.exe
  exit /b 1
)

"%TARGET_DIR%\fbc.exe" -version >nul 2>nul
if errorlevel 1 (
  echo Toolchain verification failed.
  exit /b 1
)

echo Toolchain ready: "%TARGET_DIR%"
exit /b 0