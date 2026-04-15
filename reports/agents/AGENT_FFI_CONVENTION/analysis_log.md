# Analysis Log

## 2026-04-15 Delta
- stdcall/cdecl tokenleri eklendi.
- Kalan risk: x64 ABI gerçek DLL icrasi halen no-op/policy modunda.

## 2026-04-15 Post-Update
- Optional calling convention parse/runtime ayrisma aktif.
- Scope testleri ile regression PASS.

## 2026-04-15 Validation Cycle-2
- Scope fixture'lari MAIN global kuralina gore duzeltildikten sonra cdecl/stdcall parse-runtime yolu tekrar dogrulandi.
- run_call_exec regresyonu tekrar PASS (exit code 0).

## 2026-04-15 Validation Cycle-3
- Allowlist parser'a opsiyonel calling convention kolonu eklendi.
- Win64 policy eslestirmesinde CDECL/STDCALL uyumlulugu aktif edildi.
- Audit satirina ABI alani eklendi ve run_call_exec ile dogrulandi (ABI=WIN64-MSABI).
- Not: Bu adim codegen tarafindaki shadow-space/alignment kapanisini temsil etmez.

## 2026-04-15 Validation Cycle-4
- `src/codegen/x64/ffi_call_backend.fbs` ile CALL(DLL) icin x64 plan+stub emitter eklendi.
- Reserve formulu `40 + stackArg*8 + odd pad` ile 16-byte alignment ve 32-byte shadow-space kaniti uretildi.
- RCX/RDX/R8/R9 register arg ve `[rsp+32+]` stack arg slot mapping emit edildi.
- Kanit: `tests/run_ffi_x64_call_backend.bas`, `tests/run_call_exec.bas`, `main --interop` smoke artifact ciktilari.

## 2026-04-15 Delta

### Kapsam
- FFI-CONV-2 kalan teknik borc var mi dogrulama.
- FFI-CONV-3 ilk artis: x86 cdecl/stdcall caller-callee ayrimi codegen plan seviyesinde baslatma.

### Bulgular
- CONV-2 kapanis kriterleri (Win64 stack/shadow/alignment + call-shape) kod ve testte tamam.
- CONV-2 disinda kalan `__uxb_ffi_symptr_N` gercek resolver/loader baglama isi ayrik lane olarak acik.
- x86 lane icin yeni backend ile `cleanup_type` (CALLER/CALLEE) metadata uretiliyor.

### Kanit
- PASS: `tests/run_ffi_x86_call_backend.bas`
- PASS: `tests/run_ffi_x64_call_backend.bas` (regresyon)

## 2026-04-15 Post-Update
- `src/codegen/x86/ffi_call_backend.fbs` eklendi.
- `src/main.bas` interop akisina x86 artifact emit eklendi.
- x86 plan CSV kolonu: `arg_stack_bytes, abi, cleanup_type`.

## 2026-04-15 Validation Cycle-6
- x86 stub lane genisletildi: arg push sirasi (`argN..arg1`) ve arg slot etiketleri asm cikisina eklendi.
- Yeni resolver artifact: `dist/interop/ffi_call_x86_resolver.csv` uretimi aktif.
- Runtime resolver enforce/report davranisi eklendi; resolver plani yoksa fail-fast, report-only modda warning+devam.
- Symbol varlik dogrulamasi `LoadLibraryA/GetProcAddress` ile baglandi.
- Kanit: `tests/run_ffi_x86_call_backend.bas`, `tests/run_ffi_x86_resolver_exec_ast.bas`, `tests/run_call_exec.bas` PASS.

## 2026-04-15 Validation Cycle-7
- Runtime resolver'a bind-cache eklendi (stub_id bazli procAddr saklama).
- Basarili resolver yolunda tekrar binding yerine cache kullanimi aktif.
- Testte binding kaniti: `ExecDebugGetFfiX86ResolvedCount() > 0`.
- Kanit: `tests/run_ffi_x86_resolver_exec_ast.bas`, `tests/run_call_exec.bas` PASS.

## 2026-04-15 Validation Cycle-8
- Symptr map lane'i eklendi (`stub_id -> __uxb_ffi_x86_symptr_N -> procAddr`).
- Cleanup contract validator eklendi (`ExecX86FfiValidateCleanupContract`).
- Kanit: `tests/run_ffi_x86_resolver_cleanup_proof.bas` PASS.
