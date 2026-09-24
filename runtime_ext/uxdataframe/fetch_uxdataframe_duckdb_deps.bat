@echo off
setlocal
cd /d "%~dp0\..\..\.."
powershell -ExecutionPolicy Bypass -File uxb\runtime_ext\uxdataframe\fetch_uxdataframe_duckdb_deps.ps1 %*
endlocal
