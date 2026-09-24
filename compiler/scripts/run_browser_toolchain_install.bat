@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
powershell -NoProfile -ExecutionPolicy Bypass -File tools\install_browser_wasm_toolchain.ps1 -UxbRoot "%CD%" %*
endlocal
