@echo off
setlocal
cd /d "%~dp0..\..\.."
python uxb\tools\uxb_library_smoke_runner.py --timeout 90
echo.
echo Smoke raporu:
echo   uxb\dist\libraries\library_smoke_report.md
echo Probe testleri de calistirmak icin:
echo   python uxb\tools\uxb_library_smoke_runner.py --include-probes --timeout 180
endlocal
