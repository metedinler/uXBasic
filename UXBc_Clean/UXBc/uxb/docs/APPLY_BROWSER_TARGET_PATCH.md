# Browser Target Patch Uygulama Kılavuzu

## 1. Patch uygula

```bat
python tools\apply_browser_target_patch.py C:\UXB_MERGE\FINAL\uxb
```

## 2. Kontrol et

`src/main.bas` içinde şu include'lar görünmeli:

```freebasic
#include once "codegen/js/js_expr_emit.fbs"
#include once "codegen/js/js_stmt_emit.fbs"
#include once "codegen/js/js_mir_runtime_emit.fbs"
#include once "codegen/js/js_wasm_bridge_emit.fbs"
#include once "codegen/js/js_emitter.fbs"
#include once "codegen/wasm/wasm_type_emit.fbs"
#include once "codegen/wasm/wasm_instr_emit.fbs"
#include once "codegen/wasm/wasm_host_imports.fbs"
#include once "codegen/wasm/wasm_manifest_emit.fbs"
#include once "codegen/wasm/wasm_emitter.fbs"
```

## 3. Derle ve smoke çalıştır

```bat
compiler\scripts\run_browser_js_smoke.bat
compiler\scripts\run_wasm_smoke.bat
compiler\scripts\run_browser_hybrid_smoke.bat
```

## Not

Bu paket FreeBASIC derleyicisinin bulunduğu Windows ortamında test edilmelidir. İlk çalıştırmada mevcut MIR opcode adları ile emitter beklentileri arasında küçük düzeltmeler gerekebilir.
