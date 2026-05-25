@echo off
setlocal
cd /d "%~dp0..\..\.."

for /f %%i in ('powershell -NoProfile -Command "Get-Date -Format yyyyMMdd_HHmmss"') do set STAMP=%%i
set "RELEASE_DIR=uxb\_release\wasm_publish_%STAMP%"
set "ZIP_PATH=uxb\_release\UXBc_Wasm_publish_%STAMP%.zip"

if not exist "uxb\_release" mkdir "uxb\_release"
if not exist "%RELEASE_DIR%" mkdir "%RELEASE_DIR%"

rem Paket kapsamı: kaynak + testler + kullanim kilavuzlari + extension
xcopy /E /I /Y "uxb\src" "%RELEASE_DIR%\uxb\src" >nul
xcopy /E /I /Y "uxb\tests" "%RELEASE_DIR%\uxb\tests" >nul
xcopy /E /I /Y "uxb\docs" "%RELEASE_DIR%\uxb\docs" >nul
xcopy /E /I /Y "uxb\vscode-extension" "%RELEASE_DIR%\uxb\vscode-extension" >nul
xcopy /E /I /Y "uxb\compiler\scripts" "%RELEASE_DIR%\uxb\compiler\scripts" >nul
if exist "libs" xcopy /E /I /Y "libs" "%RELEASE_DIR%\libs" >nul
if exist "uxb\include" xcopy /E /I /Y "uxb\include" "%RELEASE_DIR%\uxb\include" >nul

copy /Y "UXBc_KULLANIM_KILAVUZU.md" "%RELEASE_DIR%\" >nul 2>nul
copy /Y "UXBc_VSCODE_KULLANIM.md" "%RELEASE_DIR%\" >nul 2>nul

powershell -NoProfile -Command "Compress-Archive -Path '%RELEASE_DIR%\*' -DestinationPath '%ZIP_PATH%' -Force"
if errorlevel 1 (
  echo ERROR: Release zip olusturulamadi.
  exit /b 1
)

echo WASM_PUBLISH_RELEASE_DIR=%RELEASE_DIR%
echo WASM_PUBLISH_RELEASE_ZIP=%ZIP_PATH%
endlocal
