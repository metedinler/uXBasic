# ADIM42 Copilot Talimatı — Kaynak Odaklı ADIM36 Tamiri

`src(30.05_4).zip` kaynak durumu esas alınacak.

## Ön şart

ADIM30 ve ADIM32B PASS korunacak. ADIM36 fail_count düşürülecek.

## Uygulama

Aşağıdaki snippet dosyalarını mevcut kaynak adlarına göre uygula:

```text
plain_include_prelexer_fix.fbs
preprocessor_foreach_block_capture_fix.fbs
string_builtins_ast_mir_fix.fbs
array_index_lvalue_semantic_fix.fbs
recursion_function_return_type_fix.fbs
file_io_input_roundtrip_fix.fbs
big_number_precision_biginit_fix.fbs
negative_gate_fail_close_fix.md
cli_adim41_missing_apply_note.md
```

## Kritik kurallar

- Genel `CALL_EXPR` writable yapılmayacak.
- `A(i)=...` sadece `A` array sembolü ise writable.
- `INCLUDE "x.uxbh"` lexer öncesi ana kaynak stream'e genişletilecek.
- `%%FOREACH ... %%ENDFOREACH` parser'a sızmayacak.
- `%%WASM_HOST_JS_BEGIN` içindeki `{}` BASIC parser'a sızmayacak.
- `BIGINIT` initializer olarak kalacak; `BIGINT` fonksiyon yapılmayacak.
- `BIGI/BIGINT` aynı tip: internal `TYPE_BIGINT`, report `BIGINT`.

## Çalıştırma

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim42_source_driven_gate.ps1 -NoRepair
```

Beklenen:

- ADIM30 PASS
- ADIM32B strict PASS
- ADIM36 fail_count düşer
- placeholder_count 0 kalır
