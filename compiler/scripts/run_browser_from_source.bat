@echo off
setlocal
REM Usage:
REM   run_browser_from_source.bat tests\browser\01_print.bas dist\browser\01_print
if "%~1"=="" (
  echo uXBasic kaynak .bas yolu gerekli.
  exit /b 2
)
set SRC=%~1
set OUTDIR=%~2
if "%OUTDIR%"=="" set OUTDIR=dist\browser\source_build
set COMPILER=src\main_64.exe
if not exist "%COMPILER%" set COMPILER=src\main.exe
python tools\uxb_browser_build.py --uxb-root . --compiler "%COMPILER%" --source "%SRC%" --out-dir "%OUTDIR%" --mode hybrid
exit /b %ERRORLEVEL%
