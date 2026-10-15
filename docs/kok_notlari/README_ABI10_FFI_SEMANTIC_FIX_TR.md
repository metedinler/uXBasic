# ABI10 / CALL(DLL) Semantic Düzeltmesi

Bu yama, ABI10 smoke testinde görülen şu hatayı hedefler:

```text
semantic-step3: type: unknown symbol: dll
```

Kök sebep: `CALL(DLL, ...)` ifadesinde `DLL`, `I32`, `STRPTR`, `CDECL` gibi FFI metadata tokenları semantic expression validator tarafından normal değişken gibi değerlendiriliyordu. Parser ve runtime `CALL(DLL, ...)` yolunu destekliyor; semantic gate ise metadata çocuklarını runtime expression sanıp `DLL` için sembol arıyordu.

Değişiklikler:

- `src/semantic/semantic_step3_gate.fbs`
  - `CALL(DLL, ...)` ve `CALL(API, ...)` marker/metadata düğümleri semantic expression inference dışına alındı.
  - Library/symbol/signature/convention/type-list metadata olarak işaretlendi.
  - Runtime argümanlar yine normal şekilde type-check edilmeye devam eder.

- `src/type_binding/type_infer_expr.fbs`
  - `CALL(DLL, ...)`, `CALL(API, ...)`, `DLL(...)`, `API(...)` dönüş tipi FFI signature tokenından çıkarılır.
  - `STRPTR` dönüşü uXBasic runtime tarafında managed `STRING` kabul edilir.
  - `PTR` dönüşü `U64` handle/pointer taşıyıcısı kabul edilir.

Bu yama runner veya DLL build sistemini değiştirmez.
