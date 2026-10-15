# ADIM37 Copilot Talimatı

Bu adım ADIM30 ve ADIM32B PASS durumunu bozmayacak dar tamir adımıdır.

## Yasaklar

- `THREAT`, `PARALLEL`, `SIHIRLIMETOT` geri eklenmeyecek.
- `IMPORT DLL/API/LIB` eklenmeyecek.
- Placeholder artifact üretilmeyecek.
- Negatif testler actual_exit=0 iken PASS gösterilmeyecek.

## Sıra

1. `rotate_current_reports.ps1` scriptini ekle ve ADIM36/ADIM30/ADIM32B scriptlerinin başına çağır.
2. INCLUDE güvenli yol politikasını düzelt.
3. INPUT # AST interpreter runtime route’unu düzelt.
4. Preprocessor ADIM34 geniş komutları ve `%%FOREACH/%%ENDFOREACH` bloklarını uygula.
5. String builtins AST/MIR interpreter’a ekle.
6. BIGF/BIGD/BALL/BIGI/BIGINT type precision + BIGINIT return type düzelt.
7. RND/TIMER ve PTR builtin type/builtin route düzelt.
8. Negatif test gate’lerini fail-close yap.

## Çalıştırma

```powershell
$env:UXB_FORCE_REBUILD=1
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim36_full_surface_library_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim32b_strict_pass.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim30_10step_chain_suite.ps1 -NoRepair
```

Beklenen ara hedef: fail_count bir anda sıfır olmak zorunda değil; önce fail grupları azalmalı. İlk hedef INCLUDE + preprocessor + INPUT# + string builtin gruplarını kapatmaktır.
