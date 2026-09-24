@echo off
setlocal EnableExtensions EnableDelayedExpansion

if "%~1"=="" (
  echo Usage: tools\release_mini.bat v0.1.X-mini [--publish]
  exit /b 1
)

set "TAG=%~1"
set "PUBLISH=%~2"
set "ROOT=%~dp0.."
set "MAP=%ROOT%\release\ci_outputs.map"
set "STAGE=%ROOT%\dist\%TAG%"
set "ZIP=%ROOT%\dist\uxbasic-%TAG%-win32-win64.zip"

powershell -NoProfile -Command "$t='%TAG%'; if ($t -match '^v0\.1\.[0-9]+-mini$') { exit 0 } else { exit 1 }" >nul
if errorlevel 1 (
  echo Invalid tag format. Expected: v0.1.X-mini
  exit /b 1
)

pushd "%ROOT%" >nul

git diff --quiet
if errorlevel 1 (
  echo Working tree has unstaged changes.
  popd >nul
  exit /b 1
)

git diff --cached --quiet
if errorlevel 1 (
  echo Working tree has staged but uncommitted changes.
  popd >nul
  exit /b 1
)

set "HAS_UNTRACKED="
for /f "delims=" %%U in ('git ls-files --others --exclude-standard') do set "HAS_UNTRACKED=1"
if defined HAS_UNTRACKED (
  echo Working tree has untracked files.
  popd >nul
  exit /b 1
)

if not exist "%MAP%" (
  echo Missing map file: %MAP%
  popd >nul
  exit /b 1
)

git rev-parse "%TAG%" >nul 2>nul
if not errorlevel 1 (
  echo Local tag already exists: %TAG%
  popd >nul
  exit /b 1
)

git ls-remote --exit-code --tags origin "refs/tags/%TAG%" >nul 2>nul
if not errorlevel 1 (
  echo Remote tag already exists: %TAG%
  popd >nul
  exit /b 1
)

call build.bat src\main.bas
if errorlevel 1 (
  popd >nul
  exit /b 1
)

call build.bat tests\run_manifest.bas
if errorlevel 1 (
  popd >nul
  exit /b 1
)

tests\run_manifest.exe
if errorlevel 1 (
  popd >nul
  exit /b 1
)

call build_matrix.bat src\main.bas
if errorlevel 1 (
  popd >nul
  exit /b 1
)

if exist "%STAGE%" rmdir /s /q "%STAGE%"
mkdir "%STAGE%"
if errorlevel 1 (
  popd >nul
  exit /b 1
)

for /f "usebackq tokens=1,2 delims=|" %%A in ("%MAP%") do (
  set "SRC=%%~A"
  set "DST=%%~B"
  if not "!SRC!"=="" (
    if not "!SRC:~0,1!"=="#" (
      if not exist "!SRC!" (
        echo Missing build output: !SRC!
        popd >nul
        exit /b 1
      )
      copy /y "!SRC!" "%STAGE%\!DST!" >nul
      if errorlevel 1 (
        popd >nul
        exit /b 1
      )
    )
  )
)

(
  echo CI Workflow: .github/workflows/win64-ci.yml
  echo Artifact Name: uxbasic-win-build-artifacts
  echo Packaged At: %DATE% %TIME%
  echo Tag: %TAG%
) > "%STAGE%\BUILD_INFO.txt"

powershell -NoProfile -Command "Get-ChildItem -File '%STAGE%' | Get-FileHash -Algorithm SHA256 | ForEach-Object { '{0}  {1}' -f $_.Hash, $_.Name } | Set-Content '%STAGE%\SHA256SUMS.txt'"
if errorlevel 1 (
  echo SHA256 generation failed.
  popd >nul
  exit /b 1
)

if exist "%ZIP%" del /f /q "%ZIP%"
powershell -NoProfile -Command "Compress-Archive -Path '%STAGE%\*' -DestinationPath '%ZIP%' -Force"
if errorlevel 1 (
  echo Zip creation failed.
  popd >nul
  exit /b 1
)

echo Release package ready: %ZIP%

if /I "%PUBLISH%"=="--publish" (
  where gh >nul 2>nul
  if errorlevel 1 (
    echo GitHub CLI not found. Install gh to publish.
    popd >nul
    exit /b 1
  )

  git tag -a "%TAG%" -m "uXBasic %TAG%"
  if errorlevel 1 (
    popd >nul
    exit /b 1
  )

  git push origin "%TAG%"
  if errorlevel 1 (
    popd >nul
    exit /b 1
  )

  gh release create "%TAG%" "%STAGE%\uXbasic_main_32.exe" "%STAGE%\uXbasic_main_64.exe" "%STAGE%\uXbasic_manifest_smoke.exe" "%ZIP%" --title "uXBasic %TAG%" --notes "Automated mini release with CI-gated checklist and package routine."
  if errorlevel 1 (
    popd >nul
    exit /b 1
  )

  echo Release published: %TAG%
)

popd >nul
exit /b 0
