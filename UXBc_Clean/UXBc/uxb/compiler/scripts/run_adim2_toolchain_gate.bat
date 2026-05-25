@echo off
setlocal
cd /d "%~dp0\..\..\.."

set "PY=python"
where python >nul 2>nul
if errorlevel 1 (
  set "PY=py -3"
)

%PY% uxb\tools\uxb_toolchain_doctor.py
if errorlevel 1 exit /b 1

echo.
echo Toolchain gate outputs:
echo   uxb\dist\adim2\toolchain_doctor.json
echo   uxb\dist\adim2\toolchain_doctor.md
echo   uxb\dist\adim2\extfp_runtime_gate.json
echo   uxb\dist\adim2\extfp_runtime_gate.md

endlocal
