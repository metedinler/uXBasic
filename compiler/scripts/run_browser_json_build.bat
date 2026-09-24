@echo off
setlocal
REM Usage:
REM   run_browser_json_build.bat dist\mir\program.mir.json dist\browser\program
if "%~1"=="" (
  echo MIR JSON yolu gerekli.
  exit /b 2
)
set MIRJSON=%~1
set OUTDIR=%~2
if "%OUTDIR%"=="" set OUTDIR=dist\browser\json_build
python tools\uxb_browser_build.py --uxb-root . --mir-json "%MIRJSON%" --out-dir "%OUTDIR%" --mode hybrid
exit /b %ERRORLEVEL%
