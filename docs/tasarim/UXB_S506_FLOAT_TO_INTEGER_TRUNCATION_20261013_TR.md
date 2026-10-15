# UXB S-506: ondalık değerden tamsayıya dönüşümde sıfıra doğru kesme

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve AST/MIR/native/JS kanıtıyla doğrulandı

## Sorun

AST yorumlayıcısında `I8`, `I16`, `I64`, `U8`, `U16`, `U32` ve `U64`
dönüşümleri FLOAT kaynak değerini `CInt`/`CLngInt` üzerinden geçiriyordu.
FreeBASIC bu dönüşümlerde yuvarladığı için `3.9` değeri `4`, `-3.9` değeri
`-4` oluyordu. Aynı kaynak program MIR, native x64 ve JS'te sıfıra doğru
kesiliyordu. `I32` için S-480'deki özel düzeltme zaten doğru davranıyordu.

## Düzeltme

AST ortak değer dönüştürme yardımcılarında FLOAT dalları `Fix` kullanır:

- `ExecValueToInteger` bütün dar/signed dönüşümlerde sıfıra doğru keser.
- `ExecValueToU64` 64-bit ve unsigned dönüşümlerde aynı kuralı korur.
- Bildirilen hedef türün genişlik maskesi ve signed yorumu dönüşüm katmanında
  eskisi gibi uygulanır.

Kaynak: `src/runtime/exec/exec_state_value_utils.fbs`.

## Kanıt

`tests/diagnostics/s506_float_to_integer_truncation.uxb` şu dönüşümleri
pozitif, negatif ve F32 kaynaklarla kapsar:

```text
I8, I16, I64, U8, U16, U32, U64
```

`run_s506_float_to_integer_tests.ps1`: **5/5 PASS**.

- AST yorumlayıcı
- canonical MIR yorumlayıcı
- MIR-x64 gerçek EXE
- AST-x64 gerçek EXE
- JS/Node

Beklenen çıktı bütün hedeflerde `3, -3` kesme sözleşmesiyle aynıdır.
`build_64.ps1 -Force` başarılıdır.

## Açık sınır

Bu düzeltme AST FLOAT kaynak dönüşümünü kapatır. FFI sınırlarının ve tüm kitap
külliyatının ayrı geniş ölçümü hâlâ regresyon izleme kapsamındadır; S-480'in
tarihsel tam külliyat iddiası bu fixture ile otomatik olarak kapanmış sayılmaz.
