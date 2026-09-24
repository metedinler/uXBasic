@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "OUT=uxb\dist\runtime_ext"
set "DEP=%OUT%\deps\uxdataframe\bin"
if not exist "%DEP%\duckdb.dll" (
  echo ERROR: cached duckdb.dll not found. Run fetch_uxdataframe_duckdb_deps.ps1 first.
  exit /b 1
)
if not exist "%OUT%" mkdir "%OUT%"
copy /Y "%DEP%\duckdb.dll" "%OUT%\duckdb.dll" >nul
if exist "%OUT%\uxdataframe.dll" copy /Y "%OUT%\uxdataframe.dll" "%DEP%\uxdataframe.dll" >nul
echo OK: uxdataframe runtime deps copied.
endlocal
