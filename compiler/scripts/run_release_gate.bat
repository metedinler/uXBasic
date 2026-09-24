@echo off
setlocal
cd /d "%~dp0..\..\.."

if exist "uxb\tools\release\uxb_release_gate.py" (
  python uxb\tools\release\uxb_release_gate.py --root uxb --strict %*
  exit /b %errorlevel%
) else (
  echo Missing uxb\tools\release\uxb_release_gate.py
  exit /b 1
)
endlocal
