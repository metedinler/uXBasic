@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "DEPS=uxb\dist\runtime_ext\deps\uxonnx2"
set "INC=%DEPS%\include"
set "OUT=uxb\dist\runtime_ext\uxonnx2.dll"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
if not exist "%INC%\onnxruntime_c_api.h" (
  echo ERROR: onnxruntime_c_api.h not found. Run fetch_uxonnx2_deps.bat
  exit /b 3
)
if not exist "uxb\dist\runtime_ext" mkdir "uxb\dist\runtime_ext"
"%GCC%" -O2 -shared -I"%INC%" -o "%OUT%" "uxb\runtime_ext\uxonnx2\uxonnx2.c"
if errorlevel 1 exit /b 1
echo OK: %OUT%
endlocal
