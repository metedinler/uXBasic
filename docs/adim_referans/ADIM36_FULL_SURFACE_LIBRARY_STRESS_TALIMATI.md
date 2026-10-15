# ADIM36 — Full Surface / Library / Import / Include Stress Suite

Bu paket ADIM35 BIG number canonical kararından sonra çalıştırılacak geniş test paketidir.
Amaç yeni compiler özelliği yazmak değildir; **var olan yüzeyin 10 halkalı yaşam zincirinde nerede kırıldığını** göstermek ve negatif testleri büyütmektir.

## Ön koşul

1. ADIM35 BIG number patch uygulanmış olmalı.
2. ADIM30 PASS bozulmamalı.
3. ADIM32 force rebuild mantığı korunmalı: `UXB_FORCE_REBUILD=1` kullanılacak; `Skipping rebuild` görülürse sonuç geçersiz.
4. Placeholder artifact üretmek yasaktır.

## 10 halka

Her pozitif test için plan dosyasındaki zincire göre aşağıdaki halkalardan biri veya tamamı çalışır:

1. LEX — lexer/preprocessor çıktısı
2. PAR — parser AST çıktısı
3. AST — AST contract
4. SEM — semantic/type/layout/HIR
5. MIR — MIR lowering
6. VERIFY — MIR verifier
7. INTERP_AST / INTERP_MIR — interpreter runtime
8. X64 — x64 NASM/backend
9. JS / WAT / BROWSER — web backendler
10. EXPECTED — expected/actual raporu

## Test kapsamı

Bu paket 50 pozitif kaynak dosyası ve 21 negatif kaynak dosyası getirir.
Kapsam: temel BASIC, operatörler, string, array/list/dict/set, type/class/OOP, namespace/using/alias, include, IMPORT(C/CPP/ASM), pointer/memory, event/thread/pipe/slot, file I/O, FFI CALL(DLL/API), bilimsel DLL route, browser meta artifact, WAT/WASM bridge, BIGF/BIGD/BALL/BIGI/BIGINT.

## Uygulama

Patch içindeki `patch_files/` içeriğini repo köküne aynı yollarla kopyala.
Sonra çalıştır:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File compiler\scripts\run_adim36_full_surface_library_suite.ps1 `
  -NoRepair
```

Raporlar:

```text
reports/control/current/adim36_full_surface_gate.json
reports/control/current/adim36_full_surface_results.csv
reports/control/current/adim36_expected_actual.csv
reports/control/current/adim36_source_inventory.csv
reports/control/current/adim36_first_fail_logs.txt
reports/control/current/adim36_10_chain_summary.md
```

## Kurallar

- IMPORT DLL/API/LIB eklenmeyecek.
- DLL/API için `DECLARE ... LIB ... ALIAS` ve `CALL(DLL/API,...)` kullanılacak.
- IMPORT yalnız `IMPORT(C,"file.c")`, `IMPORT(CPP,"file.cpp")`, `IMPORT(ASM,"file.asm")`.
- BIGI/BIGINT aynı tiptir; initializer `BIGINIT` kalır.
- Runtime DLL yoksa test PASS gibi gösterilmeyecek; `REQUIRES_DLL` veya FAIL/diagnostic olarak kalacak.
