@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
python tools\uxb_localhost_bridge.py --config tools\uxb_bridge_allowlist.example.json %*
endlocal
