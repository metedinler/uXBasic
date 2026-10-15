# UXB ABI10 ASSERT + ABS Typed Fix (2026-07-06)

Bu yama ABI10 smoke testinde kalan `ASSERT(1002)` hatasını hedefler.

## Gerçek hata zinciri

Önceki yamalardan sonra şu hatalar aşılmıştı:

- `source file path not provided`
- `unknown symbol: dll`
- `unknown symbol: void`
- `missing type at ast=... kind=IDENT`
- `invalid argument kind`

Son kalan hata `ASSERT(1002) ASSERT failed [line 47:5]` idi. Include açılımında line 47 şu satıra denk gelir:

```basic
ASSERT ABS(mixed - 38.0) < 0.0001
```

Bu satır ABI10 F64 sonucunu test ediyor.

## Kök neden

İki integer-only yol kalmıştı:

1. `ExecRunAssertStmt` koşulu `ExecEvalNode` ile çalıştırıyordu.
2. `ABS(...)` CALL_EXPR olarak `ExecEvalNode` yoluna düşüyordu.

Bu yüzden `0.0001` integer yolda `0` oluyor ve F64 değer taşınsa bile ifade yanlış değerlendirilebiliyordu.

## Düzeltme

- `src/runtime/exec/exec_stmt_flow.fbs`
  - ASSERT koşulu artık `ExecEvalExpression` ile değerlendirilir.

- `src/runtime/memory_exec.fbs`
  - `ExecEvalExpression` içindeki CALL_EXPR yoluna typed `ABS` desteği eklendi.
  - `ABS` argümanı `ExecEvalExpression` ile hesaplanır, FLOAT korunur.

## Değişen dosyalar

- `src/runtime/exec/exec_stmt_flow.fbs`
- `src/runtime/memory_exec.fbs`
