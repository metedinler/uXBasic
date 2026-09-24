@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_library_runtime_builder.py
echo.
echo Runtime build raporu:
echo   uxb\dist\libraries\library_runtime_build_report.md
endlocal
