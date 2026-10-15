# 10 — ADIM8: Backend Pipeline, x64, JS, WAT, WASM ve WABT

## Amaç

HIR → MIR → Backend zinciri tek backend pipeline ile bağlanacak. `backend_step6.fbs` dispatch kapısı korunacak ama doğrudan main içinden dağınık çağrılmayacak.

## Çözülecek sorunlar

```text
UXBBackendContext merkezi doldurulmuyor.
main_program_entry içinde x64EmitMode/codegenMode/x64BuildMode dağınık.
JS/WASM backend verified MIR almadan çalışabilir.
WAT üretimi ile WASM binary üretimi ayrılmıyor.
wat2wasm tools altında yoksa durum saklanıyor.
```

## Yeni modüller

```text
src/backend/backend_cli_args.fbs
src/backend/backend_toolchain.fbs
src/backend/backend_context_builder.fbs
src/backend/backend_pipeline_gate.fbs
src/backend/backend_pipeline.fbs
src/backend/backend_pipeline_report.fbs
src/backend/backend_x64_build_bridge.fbs
src/backend/backend_wasm_tool_bridge.fbs

tools/scripts/install_wabt.ps1
tools/scripts/check_wabt.ps1
tools/toolchain_manifest.json
```

## İş planı

```text
1. UXBBackendCliArgs main CLI'dan üretilecek.
2. UXBBackendContextFromCliArgs context'i tek yerde dolduracak.
3. UXBBackendRunPipeline:
   - MIR mandatory gate kontrolü
   - target gate
   - toolchain gate
   - UXBBackendEmitModuleStep6 dispatch
   - artifact/report üretimi
4. x64/js/wat/wasm backend doğrudan main'den çağrılmayacak.
5. JS/WASM için codegenSourceMode=MIR zorunlu.
6. --emit-wat WAT üretir, wat2wasm zorunlu değildir.
7. --emit-wasm WAT + wat2wasm ile .wasm üretir; wat2wasm yoksa FAIL.
8. WABT tools/wabt/bin/wat2wasm.exe yoluna kurulacak.
```

## Toolchain düzeni

```text
tools/
  FreeBASIC-1.10.1-win64/
  wabt/
    bin/
      wat2wasm.exe
      wasm2wat.exe
      wasm-validate.exe
```

## Pozitif testler

```bat
uxb_main_64.exe tests/hello.bas --mode=std --emit-x64
uxb_main_64.exe tests/hello.bas --mode=std --emit-js
uxb_main_64.exe tests/hello.bas --mode=std --emit-wat
uxb_main_64.exe tests/hello.bas --mode=full --emit-wasm
```

## Negatif testler

```bat
uxb_main_64.exe tests/hello.bas --emit-js --codegen-source AST
uxb_main_64.exe tests/hello.bas --emit-wasm
```

Beklenen:
- JS AST fallback FAIL.
- wat2wasm yoksa emit-wasm FAIL, emit-wat PASS.

## Çıktı

```text
reports/control/current/backend_pipeline.json
reports/control/current/toolchain_gate.json
reports/control/current/backend_expected_actual.csv
reports/control/current/wabt_check.md
```
