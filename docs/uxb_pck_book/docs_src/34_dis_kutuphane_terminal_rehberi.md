# Dış Kütüphane Terminal Rehberi

## Doğrulanmış üretim kapıları

```powershell
.\compiler\scripts\build_uxb_main_64.ps1 -Verbose
.\run_final_ffi_quickjs_release_no_package.cmd
.\run_uxwasmrt_gate.ps1 -SkipCompilerBuild
python .\tools\audit\uxb_ast_contract_audit.py gate
```

`UXB_FINAL_FFI_QUICKJS_RELEASE_GATE_PASS` ve `UXB_WASMTIME_CORE_GATE_PASS` işaretleri görülmeden dağıtım hazırlanmaz. Strict olumlu çağrı için hedef DLL gerçekten bulunmalı, hash eşleşmeli ve Authenticode imza konusu kayıtla aynı olmalıdır.

Dış kütüphaneler yalnız belgede okunmaz; build, smoke test, AST/MIR çalıştırma ve runtime DLL denetimiyle kontrol edilir. Bu bölümde komutlar Windows PowerShell üzerinden verilir.

## Runtime extension DLL dosyalarını derleme

```powershell
.\compiler\scripts\build_all_runtime_ext_dlls.bat
.\compiler\scripts\build_imported_library_runtimes.bat
```

## Dış kütüphane smoke testleri

```powershell
.\compiler\scripts\run_uxaimath_smoke.bat
.\compiler\scripts\run_uxcollections_smoke.bat
.\compiler\scripts\run_uxdataframe_smoke.bat
.\compiler\scripts\run_uxdataset_smoke.bat
.\compiler\scripts\run_uxgraph_smoke.bat
.\compiler\scripts\run_uxllama_smoke.bat
.\compiler\scripts\run_uxllamax_placeholder_smoke.bat
.\compiler\scripts\run_uxmath_smoke.bat
.\compiler\scripts\run_uxmathcore_smoke.bat
.\compiler\scripts\run_uxmatrix_smoke.bat
.\compiler\scripts\run_uxnn_smoke.bat
.\compiler\scripts\run_uxnn2_smoke.bat
.\compiler\scripts\run_uxnn3_smoke.bat
.\compiler\scripts\run_uxonnx_smoke.bat
.\compiler\scripts\run_uxonnx2_smoke.bat
.\compiler\scripts\run_uxstats_smoke.bat
.\compiler\scripts\run_uxstats2_smoke.bat
.\compiler\scripts\run_uxtensor_smoke.bat
```

## Kitap örneklerini AST ve MIR yorumlayıcı ile çalıştırma

```powershell
.\tools\docs\run_external_library_examples.ps1 -Root . -Backend AST
.\tools\docs\run_external_library_examples.ps1 -Root . -Backend MIR
```

## Compiler katman çıktılarıyla dış kütüphane örneği üretme

Aşağıdaki komutlar tek bir `.uxb` örneğinin preprocess, AST, MIR ve artefact JSON çıktısını aynı klasöre alır. CLI anahtarları kaynak baskıya göre değişebileceği için kitapta bu komutlar pratik şablon olarak verilir.

```powershell
$SRC = "docs_examples\external_libraries\uxstats\uxstats_ornek_01.uxb"
$OUT = "reports\book_external_layers\uxstats_ornek_01"
New-Item -ItemType Directory -Force $OUT | Out-Null
.\bin\uxb.exe $SRC --execmem --interpreter-backend AST --ast-json-out "$OUT\ast.json" 2>&1 | Tee-Object "$OUT\ast_run.log"
.\bin\uxb.exe $SRC --execmem --interpreter-backend MIR --mir-pipeline-json-out "$OUT\mir_pipeline.json" --mir-opcodes-json-out "$OUT\mir_opcodes.json" 2>&1 | Tee-Object "$OUT\mir_run.log"
.\bin\uxb.exe $SRC --artifact-report-json-out "$OUT\artifact_report.json" 2>&1 | Tee-Object "$OUT\artifact.log"
```

## Registry ve wrapper yüzeyi raporu

```powershell
python .\tools\docs\generate_external_library_docs.py --root . --update-order
python .\tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```
