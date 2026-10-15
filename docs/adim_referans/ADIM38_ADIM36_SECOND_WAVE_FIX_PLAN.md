# ADIM38 — ADIM36 İkinci Dalga Kök Hata Yamaları

Amaç: ADIM36 full surface stress suite içinde ADIM37 kapsamına girmeyen veya ADIM37'de eksik kalan kökleri kapatmak.

Bu paket **yeni dil özelliği icat etmez**. Mevcut kanonik kararları korur:

- `THREAT` yok, doğru anahtar `THREAD`.
- `PARALLEL` yok, doğru anahtar `PARALEL`.
- `SIHIRLIMETOT` yok, doğru anahtar `MAGIC`.
- `IMPORT DLL/API/LIB` yok.
- `IMPORT(C/CPP/ASM)` kaynak derleme içindir.
- DLL/API çağrısı `DECLARE ... LIB ... ALIAS` ve `CALL(DLL/API,...)` ile yapılır.

## Current1 raporuna göre kök sınıflar

1. INCLUDE safe path: 70 fail civarı. `.uxbh` ve `tests/.../includes/...` yanlış reddediliyor.
2. BIG number type: 25 fail civarı. `BIGF(256)`, `BIGD(80)`, `BALL(256)`, `BIGI/BIGINT` bağlama eksik.
3. Preprocessor block/meta: `%%FOREACH/%%ENDFOREACH`, inline `{{...}}` / `%%EVAL`, ADIM34 meta komutları sızıyor.
4. WEND: `WHILE ... WEND` kapanışı statement/symbol gibi semantik katmana sızıyor.
5. RANGE_EXPR: AST contract, legacy left/right yüzünden `RANGE_EXPR` için fazla katı.
6. Array index lvalue: `A(i)=...` CALL_EXPR gibi görülüp yazılabilir kabul edilmiyor.
7. String builtins: AST/MIR interpreter `UCASE`, `LEFT` vb. çağrıları desteklemiyor.
8. Function recursion/type: fonksiyon return/param tipi çözülmediği için numeric operand hatası.
9. File I/O: `OPEN` yol modu, `INPUT #`, `GET/PUT/SEEK`, string suffix `$` eksikleri.
10. PTR / PEEK / POKE / VARPTR / SADD: pointer type context ve atama kuralları eksik.
11. RND/TIMER builtin: semantic builtin listesinde yok.
12. Negatif gate: hata vermesi gereken bazı testler exit 0 ile geçiyor.

## Uygulama sırası

1. `compiler/scripts/rotate_current_reports.ps1` scriptini gate başlarına bağla.
2. WEND parser + semantic sızma düzelt.
3. INCLUDE safe path policy düzelt.
4. RANGE_EXPR contract geçiş uyumluluğu ekle.
5. Array index lvalue yazılabilirlik kuralı ekle.
6. String builtins AST/MIR interpreter route ekle.
7. BIG number precision suffix ve BIGINIT tip çıkarımı ADIM35 kararına göre bağla.
8. File I/O: `INPUT #`, `GET/PUT/SEEK`, `$` string suffix.
9. PTR/PEEK/POKE/VARPTR/SADD type context.
10. RND/TIMER builtin.
11. Negatif gate fail-close.

Her düzeltmeden sonra:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim36_full_surface_library_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim32b_strict_pass.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler/scripts/run_adim30_10step_chain_suite.ps1 -NoRepair
```

Beklenen: ADIM30 ve ADIM32B PASS korunacak. ADIM36 kırmızıları azalacak.
