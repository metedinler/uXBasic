# UXB ABI10 Typed Return Route Fix — 05.07.2026

Bu yama ABI10 smoke testinde semantic/type katmanları geçildikten sonra kalan AST interpreter hatasını hedefler.

Önceki durum:
- `source file path not provided` düzeldi.
- `unknown symbol: dll` düzeldi.
- `unknown symbol: void` düzeldi.
- `missing type at ast=...` düzeldi.
- `invalid argument kind` düzeldi.
- Kalan hata `ASSERT(1002) line 45` idi.

Kök neden:
`CALL(DLL, ..., STRPTR, CDECL)` gibi no-arg typed return çağrıları eski x64 direct path'e düşüyordu. Bu eski yol yalnız Integer döndürdüğü için STRPTR/F64/PTR gibi typed dönüşleri `gExecLastCallValueEx` üzerinden korumuyordu. ABI10_Text() çağrısı bu yüzden beklenen STRING değerini taşımıyordu.

Düzeltme:
`src/runtime/exec/exec_eval_builtin_categories.fbs` içinde WIN64-MSABI yolunda şunlar ABI10 `uxffi_invoke10` typed bridge rotasına alındı:
- explicit type-list bulunan çağrılar,
- sıfır runtime argümanlı typed çağrılar,
- STRPTR / PTR / F64 / VOID dönüşlü çağrılar.

Bu yama önceki semantic/type/bridge int32 düzeltmelerini geri almaz.
