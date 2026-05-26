@echo off
setlocal
set UXB_ROOT=%~dp0..
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0install_browser_wasm_toolchain.ps1" -UxbRoot "%UXB_ROOT%" %*
endlocal
