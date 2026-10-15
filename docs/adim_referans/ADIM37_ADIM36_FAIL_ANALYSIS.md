# ADIM37 — ADIM36 Sonuç Analizi ve Dar Tamir Talimatı

## Mevcut kesin durum

`current1.zip` içindeki raporlara göre:

- `adim30_10step_gate.json`: PASS
- `adim32b_strict_gate.json`: PASS
- `adim36_full_surface_gate.json`: FAIL
- `test_case_count`: 74
- `step_run_count`: 485
- `fail_count`: 178
- `missing_output_count`: 356
- `placeholder_count`: 0
- `bad_json_count`: 0

Bu sonuç “ana zincir çalışıyor ama geniş yüzey/kütüphane stres testi gerçek açıkları yakalıyor” anlamına gelir.

## Anahtar kelime kararları

Aşağıdaki yanlış yüzeyler kaldırılmış/kalıcı olarak yasak kabul edilmiştir:

- `THREAT` yanlış; doğru anahtar `THREAD`.
- `PARALLEL` yanlış; doğru anahtar `PARALEL`.
- `SIHIRLIMETOT` yanlış; doğru anahtar `MAGIC`.
- Sihirli metot yüzeyi ileride `<. ... .>` biçiminde ve `MAGIC` ile kurulacaktır.

Kodda tekrar görünürlerse surface/lexer/parser/backend policy’den silinmelidir.

## Öncelik sırası

### P0 — Test runner/rapor altyapısı

1. Her run başında `reports/control/current` önce `reports/control/history/<timestamp>` altına taşınmalı.
2. Runner negatif testlerde `expected_exit != actual_exit` durumunu açıkça FAIL saymalı.
3. `LEX` adımı, parser hatası nedeniyle yanlışlıkla LEX fail görünmemeli; layer-only stop veya çıktı tabanlı değerlendirme kullanılmalı.

### P1 — Geniş fail sayısını katlayan kök problemler

1. `INCLUDE` güvenli yol politikası `.uxbh` ve repo-içi `tests/...` yollarını desteklemiyor.
2. Preprocessor döngüleri (`%%FOREACH/%%ENDFOREACH`) ve ADIM34 geniş meta komutları tam uygulanmamış.
3. File I/O `INPUT #` AST interpreter’da `mode not readable` veriyor.
4. String builtins AST/MIR interpreter’da eksik: `UCASE`, `LCASE`, `LEFT`, `RIGHT`, `MID`, `LEN`, `INSTR`.
5. Big number tipleri `BIGF(256)`, `BIGD(80)`, `BALL(256)` precision suffix ile type olarak çözülemiyor; `BIGINIT` dönüş tipi TYPE_OBJECT kalıyor.
6. `PTR` bazı parser/type contextlerinde bilinmiyor.
7. `RND`/`TIMER` semantic runtime builtin olarak çözülmüyor.

### P2 — Semantik/AST kalite problemleri

1. `WEND` semantik aşamada sembol gibi yorumlanıyor.
2. `RANGE_EXPR` contract hâlâ `left/right` artefaktına takılıyor.
3. Recursion/function call return type çözümü numeric operatörlerde OBJECT kalabiliyor.
4. Pointer/memory testlerinde `TYPE_I32 -> TYPE_PTR` kontrolü çok katı veya test yanlış yazılmış; `VARPTR/SADD` kaynaklı pointer ile raw integer ayrılmalı.

### P3 — Negatif testlerin gerçek kırmızı vermesi

Aşağıdaki negatifler actual_exit=0 ile geçmemesi gerekirken geçiyor:

- unknown event trigger
- alias cycle
- ASSERT_META fail
- raw JS without gate
- bad path asset escape
- WAT import missing host binding
- PRINT # without OPEN
- POKE bad address

Bunların her biri ya preprocessor/semantic gate eksikliği ya da runner expected_exit değerlendirme sorunudur.
