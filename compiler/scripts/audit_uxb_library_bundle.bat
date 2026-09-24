@echo off
setlocal
cd /d "%~dp0..\..\.."
set ZIPDIR=%~1
if "%ZIPDIR%"=="" set ZIPDIR=library_bundle_zips
python uxb\tools\uxb_library_importer.py --zip-dir "%ZIPDIR%"
echo.
echo Rapor:
echo   uxb\dist\libraries\library_import_report.md
endlocal
