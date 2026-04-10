# Faz B.2 Release Notes

Tarih: 2026-04-11
Etiket: B2-DONE (kapanis adayi)

## Ozet
Faz B.2 kapsaminda nested type/array layout semantigi, indexed OFFSETOF cozumleme, PEEK/POKE width uyum dogrulamasi ve runtime adres formulu entegrasyonu tamamlandi.

## Eklenen Ana Yetkinlikler
- Deterministik `SIZEOF(TYPE)` ve `OFFSETOF(TYPE, "path")` semantigi
- Indexed path destegi: `field(i).member`
- Row-major offset lineerlesmesi ve array bounds dogrulamasi
- `PEEKB/W/D` ve `POKEB/W/D` icin width mismatch semantic fail-fast
- Runtime evaluator icinde `SIZEOF/OFFSETOF` calistirma destegi
- `VARPTR(root) + OFFSETOF(path)` ile nested alan yazma/okuma
- FOR EACH pointer vektorleri uzerinden stride capraz dogrulama

## Test ve Kapilar
- Yeni/gelistirilen kosucular:
  - `tests/run_layout_intrinsics.bas`
  - `tests/run_memory_width_semantics.bas`
  - `tests/run_memory_stride_failfast.bas`
  - `tests/run_memory_exec_ast.bas`
  - `tests/run_each_exec.bas`
- Fail-fast scriptleri:
  - `tools/run_layout_indexed_failfast.ps1`
  - `tools/run_memory_width_failfast.ps1`
  - `tools/run_memory_stride_failfast.ps1`
- Toplu fail-fast scripti:
  - `tools/run_faz_b2_failfast.ps1`

## Kalite Durumu
- Faz A quality gate: PASS
- B.2 kapsami icin done checklist: `reports/faz_b2_done_checklist.md`
