# UXB ABI10 Typed User Argument Fix (2026-07-06)

Bu yama ABI10 smoke zincirinde kalan ASSERT hatasını hedefler.

## Kök neden

`CALL(DLL)` katmanı artık çalışıyor; `invalid argument kind` kalktı. Kalan sorun wrapper fonksiyonlarına giden argümanların `ExecInvokeRoutineByIndex` içinde `ExecEvalNode` ile integerleştirilmesiydi.

Örnek:

```basic
mixed = ABI10_Mix8(1.5,2,3.5,4,5.5,6,7.5,8)
point = ABI10_PointCreate(2.25,5.25)
```

Eski akışta `1.5`, `3.5`, `2.25`, `5.25` değerleri parametre değişkenlerine F64 olarak değil INTEGER olarak bağlanıyordu. Sonra wrapper içindeki `CALL(DLL, ..., "F64,...", a,b,...)` bu parametreleri okuduğu için DLL çağrısı çalışsa bile sonuç assertleri tutmuyordu.

## Değişen dosya

- `src/runtime/exec/exec_call_dispatch_helpers.fbs`

## Değişiklik

- Normal user FUNCTION/SUB çağrılarında argümanlar artık `ExecEvalExpression` ile `ExecValue` olarak değerlendirilir.
- Parametreler `ExecSetVarValue` ile frame'e bağlanır.
- Prepared integer çağrılar aynı şekilde `ExecValue` container üzerinden bağlanır, ama integer semantiği korunur.

## Beklenen etki

- ABI10_Mix8 F64 argümanları korunur.
- ABI10_PointCreate F64 argümanları korunur.
- ASSERT line 47/48 türü F64 sonuç kontrolleri gerçek değeri görür.
