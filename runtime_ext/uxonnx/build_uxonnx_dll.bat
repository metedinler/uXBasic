@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "GCC=C:\msys64\ucrt64\bin\gcc.exe"
set "PATH=C:\msys64\ucrt64\bin;%PATH%"
set "DEP=uxb\dist\runtime_ext\deps\uxonnx"
set "OUT=uxb\dist\runtime_ext"
if not exist "%GCC%" (
  echo ERROR: MSYS2 UCRT64 gcc not found: %GCC%
  exit /b 2
)
if not exist "%DEP%\include\onnxruntime_c_api.h" (
  echo ERROR: ONNX Runtime headers not found. Run uxb\runtime_ext\uxonnx\fetch_uxonnx_deps.bat
  exit /b 3
)
if not exist "%DEP%\lib\onnxruntime.lib" (
  echo ERROR: ONNX Runtime import library not found: %DEP%\lib\onnxruntime.lib
  echo Run uxb\runtime_ext\uxonnx\fetch_uxonnx_deps.bat
  exit /b 4
)
if not exist "%OUT%" mkdir "%OUT%"
"%GCC%" -O2 -shared -I"%DEP%\include" -o "%OUT%\uxonnx.dll" "uxb\runtime_ext\uxonnx\uxonnx.c" "%DEP%\lib\onnxruntime.lib"
if errorlevel 1 exit /b 1
call uxb\runtime_ext\uxonnx\copy_uxonnx_runtime_deps.bat
if errorlevel 1 exit /b 1
echo OK: %OUT%\uxonnx.dll
endlocal
