@echo off
setlocal
set "ROOT=%~dp0..\.."
cd /d "%ROOT%"
set "UXB=bin\uxb.exe"
set "OUT=dist\browser\hybrid_add"
set "WAT2WASM=tools\wabt\bin\wat2wasm.exe"

if not exist "%UXB%" (
  echo uXBasic compiler exe bulunamadi.
  exit /b 1
)
if not exist "%WAT2WASM%" (
  echo wat2wasm bulunamadi: %WAT2WASM%
  exit /b 1
)

if not exist "%OUT%" mkdir "%OUT%"
powershell -NoProfile -Command "Remove-Item -Force -ErrorAction SilentlyContinue '%OUT%\index.html','%OUT%\program.js','%OUT%\ux_runtime.js','%OUT%\program.wat','%OUT%\program.wasm','%OUT%\wasm_manifest.json','%OUT%\backend_report.json'"
"%UXB%" jsw tests\browser\06_hybrid_wasm_add.bas --emit-browser --emit-js --emit-wat --emit-wasm --html-out "%OUT%\index.html" --js-out "%OUT%\program.js" --js-runtime-out "%OUT%\ux_runtime.js" --wat-out "%OUT%\program.wat" --wasm-out "%OUT%\program.wasm" --wat2wasm="%WAT2WASM%" --manifest-out "%OUT%\wasm_manifest.json" --backend-report-json-out "%OUT%\backend_report.json"
if errorlevel 1 exit /b 1

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $files=@('%OUT%\index.html','%OUT%\program.js','%OUT%\ux_runtime.js','%OUT%\program.wat','%OUT%\program.wasm','%OUT%\wasm_manifest.json','%OUT%\backend_report.json'); foreach($f in $files){ $i=Get-Item -LiteralPath $f; if($i.Length -le 0){ throw ('Bos browser hybrid ciktisi: '+$f) } }; $m=Get-Content -Raw '%OUT%\wasm_manifest.json'|ConvertFrom-Json; $r=Get-Content -Raw '%OUT%\backend_report.json'|ConvertFrom-Json; if($m.wat -ne 'program.wat' -or $m.wasm -ne 'program.wasm'){ throw 'Hybrid manifest artefakt adlari yanlis' }; if($r.status -ne 'PASS' -or $r.target -ne 'browser'){ throw 'Hybrid backend raporu PASS/browser degil' }; $h=Get-Content -Raw '%OUT%\index.html'; if($h -notmatch 'program\.wasm'){ throw 'Hybrid HTML WASM dosyasina baglanmiyor' }; $b=[IO.File]::ReadAllBytes('%OUT%\program.wasm'); if($b.Length -lt 8 -or $b[0] -ne 0 -or $b[1] -ne 97 -or $b[2] -ne 115 -or $b[3] -ne 109){ throw 'Gecersiz hybrid WASM ikili basligi' }"
if errorlevel 1 goto :fail
"tools\wabt\bin\wasm-validate.exe" "%OUT%\program.wasm"
if errorlevel 1 goto :fail
powershell -NoProfile -Command "$r=& 'tools\wabt\bin\wasm-interp.exe' '%OUT%\program.wasm' '--dummy-import-func' '-r' 'ADD' '-a' 'i32:10' '-a' 'i32:20'; if(($r|Out-String).Trim() -ne 'ADD(i32:10, i32:20) => i32:30'){ throw ('Yanlis hybrid WASM sonucu: '+($r|Out-String).Trim()) }"
if errorlevel 1 goto :fail

echo PASS_BROWSER_HYBRID: %OUT%\index.html
endlocal & exit /b 0

:fail
endlocal & exit /b 1
