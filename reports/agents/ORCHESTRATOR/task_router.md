# Gorev Yonetimi

## Aktif Tur: FFI-CONV-3 Kapanis / Resolver + Cleanup Gate

1. AGENT_X86_CODEGEN
- Gorev: x86 plan/stub/resolver artefact zincirini tamamla.
- Cikti: `ffi_call_x86_plan.csv`, `ffi_call_x86_stubs.asm`, `ffi_call_x86_resolver.csv`.

2. AGENT_X86_ASM_STUBS
- Gorev: arg push sirasi (argN..arg1) ve CDECL/STDCALL cleanup davranisini asm'de dogrula.
- Cikti: asm assert kaniti + regressions.

3. AGENT_X86_RESOLVER
- Gorev: `__uxb_ffi_x86_symptr_N` lane'i icin runtime resolver/loader dogrulama katmanini bagla.
- Cikti: enforce/report mode davranisi ve symbol lookup kaniti.

4. AGENT_X86_TESTING
- Gorev: pozitif/negatif gate test paketini kos.
- Cikti: PASS/FAIL kaniti + hata kodu dogrulamasi.

5. AGENT_CONV3_QA
- Gorev: kapanis kanitlarini topla, matris lane gecisi icin onay notu hazirla.
- Cikti: gate checklist + kapanis notu.
