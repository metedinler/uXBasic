# Faz B.2 Done Checklist

Tarih: 2026-04-11
Durum: Tamamlandi (kapanis-oncesi kalite sertlestirme)

## 1) Fixture/Pattern Sadelestirme
- [x] Ortak runtime test yardimcilari eklendi: `tests/helpers/runtime_test_common.fbs`
- [x] `run_memory_exec_ast` ortak helper kullanimina alindi.
- [x] `run_memory_stride_failfast` ortak helper kullanimina alindi.

## 2) Runtime Hata Prefix Standardi
- [x] `src/runtime/memory_exec.fbs` icine tek nokta normalizasyonu eklendi:
  - `EXEC_ERR_PREFIX = "exec: "`
  - `ExecNormalizeError(errText)`
- [x] `ExecRunMemoryProgram` hata cikislarinda prefix normalizasyonu zorunlu kilindi.

## 3) Stride + Width Sertlestirme
- [x] `run_each_exec` icine pointer-stride capraz dogrulama eklendi.
- [x] Width mismatch hata mesaji teshis bilgileriyle zenginlestirildi (`expected/got/fieldType/path`).
- [x] Yeni fail-fast kosucu eklendi: `tests/run_memory_stride_failfast.bas`
- [x] Yeni script kosucu eklendi: `tools/run_memory_stride_failfast.ps1`

## 4) Gate ve CI Entegrasyonu
- [x] Faz A gate build/run adimlari guncellendi.
- [x] Win64 CI build/run + artifact listesi guncellendi.

## 5) Dogrulama Ozeti
- [x] `tests/run_each_exec_64.exe` -> PASS
- [x] `tests/run_memory_stride_failfast_64.exe` -> PASS
- [x] `tools/run_memory_stride_failfast.ps1` -> PASS
- [x] `tools/run_faz_a_gate.ps1` -> PASS
