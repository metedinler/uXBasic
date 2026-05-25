@echo off
setlocal
cd /d "%~dp0\..\..\.."

set "PY=python"
where python >nul 2>nul
if errorlevel 1 (
  set "PY=py -3"
)

call uxb\compiler\scripts\run_adim2_toolchain_gate.bat
if errorlevel 1 exit /b 1

%PY% uxb\tools\uxb_cli_pipeline_gate.py
if errorlevel 1 exit /b 1

%PY% uxb\tools\uxb_differential_runner.py
if errorlevel 1 exit /b 1

echo.
echo Differential gate outputs:
echo   uxb\dist\adim2\cli_pipeline_gate.json
echo   uxb\dist\adim2\cli_pipeline_gate.md
echo   uxb\dist\adim2\cli_pipeline_gate.csv
echo   uxb\dist\adim2\differential_gate.json
echo   uxb\dist\adim2\differential_gate.md
echo   uxb\dist\adim2\differential_gate.csv

endlocal
