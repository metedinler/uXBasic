@echo off
setlocal
cd /d "%~dp0..\..\.."

set "SOURCE="
set "USE_ALIAS_LAYER=0"
set "ALIAS_SPEC="

:parse_args
if "%~1"=="" goto args_done
if /I "%~1"=="--alias-layer" (
  set "USE_ALIAS_LAYER=1"
  shift
  goto parse_args
)
if /I "%~1"=="--no-alias-layer" (
  set "USE_ALIAS_LAYER=0"
  shift
  goto parse_args
)
if /I "%~1"=="--alias-spec" (
  if "%~2"=="" (
    echo [HATA] TR: --alias-spec icin yol bekleniyor ^| EN: --alias-spec expects a path
    exit /b 2
  )
  set "ALIAS_SPEC=%~2"
  shift
  shift
  goto parse_args
)
if not defined SOURCE (
  set "SOURCE=%~1"
  shift
  goto parse_args
)

echo [HATA] TR: Bilinmeyen arguman: %~1 ^| EN: Unknown argument: %~1
exit /b 2

:args_done
if not defined SOURCE (
  echo [HATA] TR: Kullanim: run_step3_project_runner.bat path\to\program.bas ^| EN: Usage: run_step3_project_runner.bat path\to\program.bas
  exit /b 2
)

echo [BILGI] TR: Step3 proje runner baslatiliyor ^| EN: Step3 project runner starting
if "%USE_ALIAS_LAYER%"=="1" (
  echo [BILGI] TR: Alias layer aktif ^| EN: Alias layer enabled
  if defined ALIAS_SPEC (
    echo [BILGI] TR: Islenen komut: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer --alias-spec "%ALIAS_SPEC%" ^| EN: Processing command: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer --alias-spec "%ALIAS_SPEC%"
    python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer --alias-spec "%ALIAS_SPEC%"
  ) else (
    echo [BILGI] TR: Islenen komut: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer ^| EN: Processing command: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer
    python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default --alias-layer
  )
) else (
  echo [BILGI] TR: Islenen komut: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default ^| EN: Processing command: python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default
  python uxb\tools\uxb_differential_project_runner.py "%SOURCE%" --project default
)
endlocal
