@echo off
setlocal
cd /d "%~dp0..\..\.."

if "%~1"=="" (
  echo [HATA] TR: Kullanim: run_step3_project_runner.bat path\to\program.bas ^| EN: Usage: run_step3_project_runner.bat path\to\program.bas
  exit /b 2
)

set "SOURCE=%~1"

echo [BILGI] TR: Step3 proje runner baslatiliyor ^| EN: Step3 project runner starting
echo [BILGI] TR: Islenen komut: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default ^| EN: Processing command: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default
python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default
endlocal
