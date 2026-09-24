@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "SRC=uxb\runtime_ext\uxdataframe\uxdataframe_duckdb.c"
set "OUTDIR=uxb\dist\runtime_ext"
set "DEPDIR=%OUTDIR%\deps\uxdataframe"
set "DUCKINC=%DEPDIR%\include"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  echo Run: uxb\runtime_ext\uxdataframe\fetch_uxdataframe_duckdb_deps.ps1
  exit /b 2
)
for %%I in ("%GCC%") do set "PATH=%%~dpI;%PATH%"
if not exist "%DUCKINC%\duckdb.h" (
  echo ERROR: duckdb.h not found: %DUCKINC%\duckdb.h
  echo Run: powershell -ExecutionPolicy Bypass -File uxb\runtime_ext\uxdataframe\fetch_uxdataframe_duckdb_deps.ps1
  exit /b 2
)
if not exist "%OUTDIR%" mkdir "%OUTDIR%"
"%GCC%" -O2 -shared -o "%OUTDIR%\uxdataframe.dll" "%SRC%" -I"%DUCKINC%" -Wl,--out-implib,"%OUTDIR%\libuxdataframe.dll.a"
if errorlevel 1 exit /b 1
copy /Y "%DEPDIR%\bin\duckdb.dll" "%OUTDIR%\duckdb.dll" >nul
copy /Y "%OUTDIR%\uxdataframe.dll" "%DEPDIR%\bin\uxdataframe.dll" >nul
echo OK: %OUTDIR%\uxdataframe.dll
endlocal
