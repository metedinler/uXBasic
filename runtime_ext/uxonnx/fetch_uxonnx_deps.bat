@echo off
setlocal
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File fetch_uxonnx_deps.ps1 %*
endlocal
