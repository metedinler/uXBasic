@echo off
setlocal
cd /d "%~dp0..\..\.."
set ZIPDIR=%~1
if "%ZIPDIR%"=="" set ZIPDIR=library_bundle_zips
python uxb\tools\uxb_library_importer.py --zip-dir "%ZIPDIR%" --apply --conflict retire
python uxb\tools\uxb_library_ide_contract_extend.py
echo.
echo Import raporu:
echo   uxb\dist\libraries\library_import_report.md
echo Registry:
echo   uxb\libs\uxb_library_registry.json
echo Header:
echo   uxb\include\libs.uxmh
endlocal
