@echo off
setlocal
set ROOT=%~dp0..\..
cd /d "%ROOT%"
if not exist dist\browser\01_print mkdir dist\browser\01_print
if exist build\uxb_main_64.exe (
  build\uxb_main_64.exe tests\browser\01_print.bas --target js --js-out dist\browser\01_print\game.js
) else if exist src\main_64.exe (
  src\main_64.exe tests\browser\01_print.bas --target js --js-out dist\browser\01_print\game.js
) else (
  echo uXBasic compiler exe bulunamadi.
  exit /b 1
)
copy /Y runtime\browser\*.js dist\browser\01_print\ >nul
copy /Y runtime\browser\index.html dist\browser\01_print\ >nul
echo Browser JS smoke output: dist\browser\01_print\index.html
endlocal
