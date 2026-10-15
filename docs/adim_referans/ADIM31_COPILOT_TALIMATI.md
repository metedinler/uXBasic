# ADIM31 — ADIM30 FAIL Ailelerini Kapatma Yamaları

Bu paket ADIM30 sonuçlarındaki gerçek kırılmaları hedefler. Amaç çalışan CORE_FLOW/BROWSER_META/BROWSER_CANVAS_PROGRAM zincirlerini bozmadan şu aileleri ilerletmektir:

- TYPE_CLASS_LAYOUT: semantic class-field resolver
- EVENT_PIPE_MEMORY: EVENT/THREAD/PIPE tek satır tanım + SLOT Worker ON + TRIGGER OnTick
- FILE_STRING_RUNTIME: PRINT #handle, expr
- GUI_WINAPI_NATIVE: DECLARE param listesinde BYVAL/BYREF ve AS sonrası keyword-context
- SCIENCE_DLL_ROUTES: IMPORT DLL/API/LIB "x.dll"
- Runner: NATIVE_ONLY_WEB_NEG unknown step + layer-output var ama exit 1 görünen LEX/PAR/AST yanlış fail
- Browser/WAT: HTML script path basename; WAT string literal için tanımsız local.get üretimini azaltma

## Kurallar

- Ana dosyaları körlemesine ezme; önce yedek al.
- Bu paket içindeki patch_files dosyaları `uxb/` köküne aynı yollarla kopyalanabilir.
- Placeholder artifact üretme.
- Test runner çıktıyı uydurmayacak; sadece mevcut çıktı dosyalarının varlığını/placeholder olmadığını kontrol edecek.
- CORE_FLOW, BROWSER_META, BROWSER_CANVAS_PROGRAM ve negatif testler bozulursa yama geri alınmalı.

## Uygulama

Repo kökünde:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
```

Patch kopyalama mantığı:

```powershell
$patch = "UXB_31_ADIM30_FAIL_FAMILY_FIXES_PATCH"
Copy-Item -Force "$patch\patch_files\src\parser\lexer\lexer_keyword_table.fbs" "src\parser\lexer\lexer_keyword_table.fbs"
Copy-Item -Force "$patch\patch_files\src\parser\parser\parser_stmt_decl_proc.fbs" "src\parser\parser\parser_stmt_decl_proc.fbs"
Copy-Item -Force "$patch\patch_files\src\parser\parser\parser_stmt_event_pipe.fbs" "src\parser\parser\parser_stmt_event_pipe.fbs"
Copy-Item -Force "$patch\patch_files\src\parser\parser\parser_stmt_basic.fbs" "src\parser\parser\parser_stmt_basic.fbs"
Copy-Item -Force "$patch\patch_files\src\parser\parser\parser_stmt_decl_core.fbs" "src\parser\parser\parser_stmt_decl_core.fbs"
Copy-Item -Force "$patch\patch_files\src\type_binding\type_infer_expr.fbs" "src\type_binding\type_infer_expr.fbs"
Copy-Item -Force "$patch\patch_files\src\semantic\semantic_step3_gate.fbs" "src\semantic\semantic_step3_gate.fbs"
Copy-Item -Force "$patch\patch_files\src\codegen\browser\uxb_browser_artifact_adim14.fbs" "src\codegen\browser\uxb_browser_artifact_adim14.fbs"
Copy-Item -Force "$patch\patch_files\src\codegen\wasm\wasm_instr_emit.fbs" "src\codegen\wasm\wasm_instr_emit.fbs"
Copy-Item -Force "$patch\patch_files\tools\control\uxb_10step_chain_runner.py" "tools\control\uxb_10step_chain_runner.py"
```

Sonra:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim30_10step_chain_suite.ps1 -NoRepair
Get-Content reports\control\current\adim30_10step_gate.json -TotalCount 80
Import-Csv reports\control\current\adim30_10step_results.csv | Where-Object { $_.result -eq 'FAIL' } | Select-Object -First 30 | Format-Table -AutoSize
```

## Beklenen iyileşmeler

- `NATIVE_ONLY_WEB_NEG` artık unknown step olmamalı.
- `EVENT_PIPE_MEMORY` lexer/parser en azından `SLOT Worker ON` ve `TRIGGER OnTick` nedeniyle kırılmamalı.
- `FILE_STRING_RUNTIME` parser `PRINT #1, ...` yüzünden kırılmamalı.
- `GUI_WINAPI_NATIVE` DECLARE signature param listesinde BYVAL/text/STRING bağlamı yüzünden kırılmamalı.
- `SCIENCE_DLL_ROUTES` parser `IMPORT DLL "..."` formunu kabul etmeli.
- `TYPE_CLASS_LAYOUT` semantic içinde class method field kullanımında `VALUE` unknown symbol vermemeli.
- Browser HTML script path basename olmalı.

