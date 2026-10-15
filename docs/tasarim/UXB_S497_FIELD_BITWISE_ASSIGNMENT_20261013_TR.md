# UXB S-497: alanlara bit işlemi atamasının parser onarımı

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve altı yüzeyli odak testiyle doğrulandı

## Sorun

Parantezsiz `TYPE`/`CLASS` alanı atamasında sağ tarafın en üst işleci
`AND`, `OR`, `XOR` veya karşılaştırma bileşimi olduğunda parser, atamanın
`=` düğümünü bit işleminin sol dalına bağlayabiliyordu. Böylece atama
ifadesi yürütülebilir bir `ASSIGN_STMT` olarak kayboluyor, alan eski değerinde
kalıyor ve hata oluşmuyordu.

Örnek:

```basic
c.v = a.v AND b.v
```

## Düzeltme

`ParseExpressionStatement` kök binary ağacını, sol omurgada gömülü alan veya
nitelikli çağrı ataması için denetler. Bu biçim bulunduğunda atama düğümü
korunur, işleç ağacı sağ tarafa taşınır ve sonuç gerçek `ASSIGN_STMT` ile
sarmalanır. Normal yerel değişken atamaları ve dizi elemanı atamaları aynı
parser yolundan etkilenmez.

Kaynak: `src/parser/parser/parser_stmt_registry.fbs`.

## Kanıt

`tests/diagnostics/s497_field_bitwise_assignment.uxb` dört sonucu bekler:
`4`, `12`, `8`, `-1`. Koşucu:

```text
tests/diagnostics/run_s497_field_bitwise_tests.ps1
Toplam: 6   PASS: 6   FAIL: 0
```

Kontroller AST, canonical MIR, MIR-x64, legacy AST-x64, JS/Node ve WAT/WASM
artifact üretimidir. WAT varsa yerel `wat2wasm` ile bytecode doğrulaması da
yapılır.

Bu düzeltme, S-443 MAGIC işleç gövdelerinde aynı kök parser kusurunun alan
ataması biçimindeki etkisini de kaldırır; MAGIC provider davranışının bütün
ABI ve çalışma zamanı parity'si ayrı kapsamdır.
