@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
python tools\uxb_browser_build_pro.py --uxb-root . --out-dir dist\browser\hybrid_pro --mode hybrid --mir-json tests\browser_json\sample_add.mir.json --no-node-check
if errorlevel 1 exit /b 1
echo Browser hybrid pro bundle generated: dist\browser\hybrid_pro
endlocal
