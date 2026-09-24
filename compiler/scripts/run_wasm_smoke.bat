@echo off
setlocal
set "ROOT=%~dp0..\.."
cd /d "%ROOT%"
set "UXB=bin\uxb.exe"
set "OUT=dist\wasm"
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
powershell -NoProfile -Command "Remove-Item -Force -ErrorAction SilentlyContinue '%OUT%\add.wat','%OUT%\add.wasm','%OUT%\wasm_manifest.json','%OUT%\wasm_report.json'"
"%UXB%" wat tests\wasm\01_add_function.bas --emit-wat --emit-wasm --wat-out "%OUT%\add.wat" --wasm-out "%OUT%\add.wasm" --wat2wasm="%WAT2WASM%" --manifest-out "%OUT%\wasm_manifest.json" --wasm-report-json-out "%OUT%\wasm_report.json"
if errorlevel 1 exit /b 1

powershell -NoProfile -Command "$ErrorActionPreference='Stop'; $files=@('%OUT%\add.wat','%OUT%\add.wasm','%OUT%\wasm_manifest.json','%OUT%\wasm_report.json'); foreach($f in $files){ $i=Get-Item -LiteralPath $f; if($i.Length -le 0){ throw ('Bos WASM ciktisi: '+$f) } }; $m=Get-Content -Raw '%OUT%\wasm_manifest.json'|ConvertFrom-Json; $r=Get-Content -Raw '%OUT%\wasm_report.json'|ConvertFrom-Json; if($null -eq $m.exports -or $m.exports.Count -eq 0){ throw 'WASM manifest export listesi bos' }; if($r.status -ne 'PASS' -or $r.target -ne 'wasm'){ throw 'WASM raporu PASS/wasm degil' }; $b=[IO.File]::ReadAllBytes('%OUT%\add.wasm'); if($b.Length -lt 8 -or $b[0] -ne 0 -or $b[1] -ne 97 -or $b[2] -ne 115 -or $b[3] -ne 109){ throw 'Gecersiz WASM ikili basligi' }"
if errorlevel 1 goto :fail
"tools\wabt\bin\wasm-validate.exe" "%OUT%\add.wasm"
if errorlevel 1 goto :fail
powershell -NoProfile -Command "$r=& 'tools\wabt\bin\wasm-interp.exe' '%OUT%\add.wasm' '--dummy-import-func' '-r' 'ADD' '-a' 'i32:10' '-a' 'i32:20'; if(($r|Out-String).Trim() -ne 'ADD(i32:10, i32:20) => i32:30'){ throw ('Yanlis WASM sonucu: '+($r|Out-String).Trim()) }"
if errorlevel 1 goto :fail

echo PASS_WASM: %OUT%\add.wasm
endlocal & exit /b 0

:fail
endlocal & exit /b 1
