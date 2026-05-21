@echo off
setlocal
cd /d "%~dp0..\.."

echo === Build FP80 DLL ===
call uxb\runtime_ext\fp80\build_fp80_dll.bat
if errorlevel 1 (
  echo ERROR: FP80 build failed.
  exit /b 1
)

echo === Build FP128 DLL ===
call uxb\runtime_ext\fp128\build_fp128_dll.bat
if errorlevel 1 (
  echo ERROR: FP128 build failed.
  exit /b 1
)

echo === Generate manifest ===
python uxb\runtime_ext\fpcommon\uxb_fp_runtime_manifest.py
if errorlevel 1 (
  echo ERROR: manifest generation failed.
  exit /b 1
)

echo OK: all FP runtime DLLs built.
endlocal
