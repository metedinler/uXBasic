@echo off
setlocal
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File fetch_uxonnx2_deps.ps1 %*
endlocal
