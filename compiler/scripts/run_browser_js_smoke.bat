@echo off
setlocal
set "ROOT=%~dp0..\.."
cd /d "%ROOT%"
set "UXB=bin\uxb.exe"
set "OUT=dist\browser\01_print"
set "CANVAS_OUT=dist\browser\03_canvas_rect"

if not exist "%UXB%" (
  echo uXBasic compiler exe bulunamadi.
  exit /b 1
)

if not exist "%OUT%" mkdir "%OUT%"
powershell -NoProfile -Command "Remove-Item -Force -ErrorAction SilentlyContinue '%OUT%\index.html','%OUT%\game.js','%OUT%\ux_runtime.js','%OUT%\backend_report.json'"
"%UXB%" jsw tests\browser\01_print.bas --emit-browser --emit-js --html-out "%OUT%\index.html" --js-out "%OUT%\game.js" --js-runtime-out "%OUT%\ux_runtime.js" --backend-report-json-out "%OUT%\backend_report.json"
if errorlevel 1 exit /b 1

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $files=@('%OUT%\index.html','%OUT%\game.js','%OUT%\ux_runtime.js','%OUT%\backend_report.json'); foreach($f in $files){ $i=Get-Item -LiteralPath $f; if($i.Length -le 0){ throw ('Bos browser JS ciktisi: '+$f) } }; $r=Get-Content -Raw '%OUT%\backend_report.json'|ConvertFrom-Json; if($r.status -ne 'PASS' -or $r.target -ne 'browser'){ throw 'Browser backend raporu PASS/browser degil' }; $h=Get-Content -Raw '%OUT%\index.html'; if($h -match '\.wasm'){ throw 'Yalniz-JS HTML olmayan WASM dosyasina baglaniyor' }; $j=Get-Content -Raw '%OUT%\game.js'; if($j -notmatch 'globalThis\.uxbMain'){ throw 'JS giris noktasi uretilmedi' }"
if errorlevel 1 goto :fail
powershell -NoProfile -Command "$r=& node '%OUT%\game.js'; if(($r|Out-String).Trim() -ne 'Merhaba browser'){ throw ('Yanlis browser JS sonucu: '+($r|Out-String).Trim()) }"
if errorlevel 1 goto :fail

if not exist "%CANVAS_OUT%" mkdir "%CANVAS_OUT%"
powershell -NoProfile -Command "Remove-Item -Force -ErrorAction SilentlyContinue '%CANVAS_OUT%\index.html','%CANVAS_OUT%\game.js','%CANVAS_OUT%\ux_runtime.js','%CANVAS_OUT%\backend_report.json'"
"%UXB%" jsw tests\browser\03_canvas_rect.bas --emit-browser --emit-js --html-out "%CANVAS_OUT%\index.html" --js-out "%CANVAS_OUT%\game.js" --js-runtime-out "%CANVAS_OUT%\ux_runtime.js" --backend-report-json-out "%CANVAS_OUT%\backend_report.json"
if errorlevel 1 goto :fail
powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $files=@('%CANVAS_OUT%\index.html','%CANVAS_OUT%\game.js','%CANVAS_OUT%\ux_runtime.js','%CANVAS_OUT%\backend_report.json'); foreach($f in $files){ $i=Get-Item -LiteralPath $f; if($i.Length -le 0){ throw ('Bos Canvas ciktisi: '+$f) } }; $r=Get-Content -Raw '%CANVAS_OUT%\backend_report.json'|ConvertFrom-Json; if($r.status -ne 'PASS' -or $r.target -ne 'browser'){ throw 'Canvas backend raporu PASS/browser degil' }"
if errorlevel 1 goto :fail
powershell -NoProfile -Command "$r=& node tests\browser\browser_dom_harness.js '%CANVAS_OUT%\game.js'; if(($r|Out-String).Trim() -ne 'PASS_BROWSER_CANVAS'){ throw ('Canvas JS yurutme hatasi: '+($r|Out-String).Trim()) }"
if errorlevel 1 goto :fail

echo PASS_BROWSER_JS: %OUT%\index.html
endlocal & exit /b 0

:fail
endlocal & exit /b 1
