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
