@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "SRC=uxb\dist\runtime_ext\deps\uxonnx2"
set "DST=uxb\dist\runtime_ext"
if not exist "%SRC%\onnxruntime.dll" (
  echo ERROR: onnxruntime.dll not found. Run fetch_uxonnx2_deps.bat
  exit /b 1
)
copy /Y "%SRC%\onnxruntime.dll" "%DST%\onnxruntime.dll" >nul
copy /Y "%SRC%\uxonnx2_dependency_registry.json" "%DST%\uxonnx2_dependency_registry.json" >nul 2>nul
echo OK: copied ONNX Runtime deps.
endlocal
