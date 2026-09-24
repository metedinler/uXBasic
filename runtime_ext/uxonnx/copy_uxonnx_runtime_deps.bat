@echo off
setlocal
cd /d "%~dp0\..\..\.."
set "SRC=uxb\dist\runtime_ext\deps\uxonnx"
set "DST=uxb\dist\runtime_ext"
if not exist "%SRC%\onnxruntime.dll" (
  echo ERROR: onnxruntime.dll not found. Run uxb\runtime_ext\uxonnx\fetch_uxonnx_deps.bat
  exit /b 1
)
if not exist "%DST%" mkdir "%DST%"
copy /Y "%SRC%\onnxruntime.dll" "%DST%\onnxruntime.dll" >nul
copy /Y "%SRC%\uxonnx_dependency_registry.json" "%DST%\uxonnx_dependency_registry.json" >nul
copy /Y "%SRC%\uxonnx_dependency_registry.csv" "%DST%\uxonnx_dependency_registry.csv" >nul
echo OK: copied ONNX Runtime deps to %DST%
endlocal
