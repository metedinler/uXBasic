# Sonraki Faz Giris Kriterleri

Tarih: 2026-04-11
Amac: Parser + Runtime odakli sonraki faza giris icin olculebilir teknik kriterler

## 1) Test Kriterleri
- Faz A quality gate tamamen yesil olmali.
- Su kosucular PASS olmali:
  - `tests/run_layout_intrinsics_64.exe`
  - `tests/run_memory_width_semantics_64.exe`
  - `tests/run_memory_stride_failfast_64.exe`
  - `tests/run_memory_exec_ast_64.exe`
  - `tests/run_each_exec_64.exe`
- `tools/run_faz_b2_failfast.ps1` PASS olmali.

## 2) Semantik Kriterleri
- `SIZEOF` ve `OFFSETOF` semantigi deterministik calismali.
- Indexed path (`field(i).member`) parse ve semantic fail-fast kurallari aktif olmali.
- Width mismatch kurali:
  - `PEEKB/W/D` ve `POKEB/W/D` icin hedef alan boyutu ile komut boyutu uyusmazsa hata verilmelidir.
  - Hata metni `WIDTH MISMATCH` ifadesini korumali.

## 3) Runtime Kriterleri
- Runtime evaluator `SIZEOF` ve `OFFSETOF` cagri degerlendirmesini desteklemeli.
- `TYPE` ve `CLASS` statementleri memory exec akisinda no-op olarak guvenli gecmeli.
- `VARPTR(root)+OFFSETOF(path)` ile nested alan yazma/okuma testleri PASS olmali.

## 4) Dokumantasyon Kriterleri
- `.plan.md` append-only EK kayitlari guncel olmalidir.
- `reports/faz_b2_done_checklist.md` ve `reports/faz_b2_release_notes.md` guncel olmalidir.
- README icinde B2-DONE milestone referansi bulunmalidir.

## 5) CI/Gate Kriterleri
- `tools/run_faz_a_gate.ps1` build/run adimlari yeni kosuculari icermelidir.
- `.github/workflows/win64-ci.yml` build/run ve artifact listesi B.2 kosucularini icermelidir.

## Giris Karari
Yukaridaki 5 baslik altindaki tum maddeler saglandiginda sonraki faz backlog'u aktiflenir.
