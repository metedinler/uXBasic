@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
python tools\uxb_browser_build_pro.py --uxb-root . --out-dir dist\browser\webgpu_smoke --mode js --mir-json tests\browser_json\sample_add.mir.json --no-node-check
if errorlevel 1 exit /b 1
echo Open dist\browser\webgpu_smoke\index.html in a WebGPU-capable browser.
endlocal
