@echo off
setlocal
cd /d "%~dp0..\..\.."

set REPORT=uxb\dist\step7\step7_gate.md
if not exist "%REPORT%" set REPORT=uxb\dist\step6\release_gate.md
if not exist "%REPORT%" set REPORT=uxb\dist\surface\language_surface_full_matrix.md

if exist "%REPORT%" (
  start "" "%REPORT%"
) else (
  echo Rapor bulunamadi.
)
endlocal
