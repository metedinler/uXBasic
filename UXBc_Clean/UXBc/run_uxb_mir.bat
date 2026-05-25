@echo off
setlocal
cd /d "%~dp0"

set "SOURCE="
set "USE_ALIAS_LAYER=0"

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
if not defined SOURCE (
  set "SOURCE=%~1"
  shift
  goto parse_args
)

echo Bilinmeyen arguman: %~1
exit /b 2

:args_done
if not defined SOURCE (
  echo Kullanım: run_uxb_mir.bat [--alias-layer] uxb\tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas
  exit /b 1
)

set "EFFECTIVE_SOURCE=%SOURCE%"
if "%USE_ALIAS_LAYER%"=="1" (
  if not exist uxb\_work\alias mkdir uxb\_work\alias
  for %%F in ("%SOURCE%") do set "ALIAS_OUT=uxb\_work\alias\%%~nF.alias%%~xF"
  python uxb\tools\uxb_alias_overlay_preprocessor.py --source "%SOURCE%" --out "%ALIAS_OUT%"
  if errorlevel 1 exit /b %ERRORLEVEL%
  set "EFFECTIVE_SOURCE=%ALIAS_OUT%"
)

uxb\compiler\wrappers\uxb_main_wrapper_64.exe "%EFFECTIVE_SOURCE%" --execmem --interpreter-backend MIR --mir-verify --console-mode direct
exit /b %ERRORLEVEL%
