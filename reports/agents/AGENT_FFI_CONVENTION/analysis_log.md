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
