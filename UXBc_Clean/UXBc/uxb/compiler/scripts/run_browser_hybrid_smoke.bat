@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
if not exist dist\browser\hybrid_add mkdir dist\browser\hybrid_add
if exist build\uxb_main_64.exe (
  build\uxb_main_64.exe tests\browser\06_hybrid_wasm_add.bas --target browser-hybrid --browser-out-dir dist\browser\hybrid_add --wasm-wat-out dist\browser\hybrid_add\program.wat --wasm-manifest-out dist\browser\hybrid_add\wasm_manifest.json
) else if exist src\main_64.exe (
  src\main_64.exe tests\browser\06_hybrid_wasm_add.bas --target browser-hybrid --browser-out-dir dist\browser\hybrid_add --wasm-wat-out dist\browser\hybrid_add\program.wat --wasm-manifest-out dist\browser\hybrid_add\wasm_manifest.json
) else (
  echo uXBasic compiler exe bulunamadi.
  exit /b 1
)
echo Browser hybrid smoke output: dist\browser\hybrid_add\index.html
endlocal
