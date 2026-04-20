# uXBasic x64/x86-64 Master Yurutme Plani (2026-04-20)

Bu dokuman, tum plan dosyalari + matris + kod gerceginden uretilmis tek uygulama planidir.

## 1) Net Durum Analizi

### 1.1 Yapilanlar (kanitli)
1. Temel dil lane'leri (R1-R4 cekirdek) ve Faz A gate yesil.
2. ERR lane exec/smoke kanitlari PASS.
3. x64/x86 backend artefakt uretimi var:
   - dist/interop/ffi_call_x64_plan.csv
   - dist/interop/ffi_call_x64_stubs.asm
   - dist/interop/ffi_call_x86_plan.csv
   - dist/interop/ffi_call_x86_stubs.asm
   - dist/interop/ffi_call_x86_resolver.csv
4. mini release paketi uretilmis:
   - dist/uxbasic-v0.1.999-mini-win32-win64.zip

### 1.2 Yapilmayanlar (acik)
1. x64 CALL(DLL) runtime invoke kapsami yalniz I32 + <=4 arg baseline (tam kapsam degil).
2. x86 native lane host bagimli kanitlar BLOCKED olabilir.
3. FFI attestation hash/signer extraction tam kapanis degil.
4. CG/HIR/MIR parity lane'lerinde KISMEN hucreler var.

### 1.3 Celiski/duzeltme notu
1. Matristeki bazi satirlar "OK" olsa da codegen derinligi lane bazinda KISMEN.
2. Operasyonel kararlar icin gate + test + lane kaniti birlikte kullanilacak.

## 2) Hedef

x64 ve x86-64 icin calistirilabilir kod ureten derleyiciyi asamali olarak tamamlama:
1. P0: Runtime invoke baseline kapat.
2. P1: Signature/marshalling kapsamini genislet.
3. P2: Attestation + parity + advanced codegen lane kapanislari.

## 3) Uygulama Fazlari

### Faz P0 (hemen)
1. x64 runtime invoke baseline (I32, 0..4 arg).
2. mevcut gate'leri kirmadan entegrasyon.
3. Yeni test: x64 DLL invoke smoke.

### Faz P1 (kisa vade)
1. x64 signature kapsami: U64/F64/PTR/STRPTR/BYREF.
2. x86 runtime invoke proof kapsami genisletme.
3. CALL(DLL) convention ve cleanup dogrulama testlerinin artirilmasi.

### Faz P2 (orta vade)
1. hash/signer extraction + ENFORCE fail-closed.
2. ERR-CG full unwind/emit kapanisi.
3. HIR/MIR parity gate genisletme.

## 4) Kanit Kapilari

1. tools/validate_module_quality_gate.ps1
2. tools/run_faz_a_gate.ps1 -SkipBuild
3. tools/validate_matrix_psrt_ok.ps1
4. tools/release_mini.bat v0.1.X-mini

## 5) Bu Tur Uygulananlar

1. x64 runtime invoke helper eklendi:
   - src/runtime/exec/exec_eval_support_helpers.fbs
2. CALL(DLL) core x64 yola baglandi:
   - src/runtime/exec/exec_eval_builtin_categories.fbs

## 6) Sonraki Isler (sirali)

1. tests/run_call_dll_x64_runtime_smoke.bas eklenecek.
2. x64 invoke icin U64/F64/PTR marshalling genisletmesi.
3. x86 native lane host-conditional gate raporu standardize edilecek.
