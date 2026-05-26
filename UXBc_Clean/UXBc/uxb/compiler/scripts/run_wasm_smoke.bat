@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
if not exist dist\wasm mkdir dist\wasm
if exist build\uxb_main_64.exe (
  build\uxb_main_64.exe tests\wasm\01_add_function.bas --target wasm --wasm-wat-out dist\wasm\add.wat --wasm-manifest-out dist\wasm\wasm_manifest.json
) else if exist src\main_64.exe (
  src\main_64.exe tests\wasm\01_add_function.bas --target wasm --wasm-wat-out dist\wasm\add.wat --wasm-manifest-out dist\wasm\wasm_manifest.json
) else (
  echo uXBasic compiler exe bulunamadi.
  exit /b 1
)
echo WASM smoke WAT output: dist\wasm\add.wat
endlocal
