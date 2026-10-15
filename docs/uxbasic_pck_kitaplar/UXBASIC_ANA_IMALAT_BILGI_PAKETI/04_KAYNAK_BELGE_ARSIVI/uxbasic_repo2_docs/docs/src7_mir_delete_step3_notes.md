# src7 MIR DELETE Step 3 Patch

Bu paket, feature matrix raporunda `DELETE` için görünen MIR/MIR evaluator boşluğunu kapatmak üzere hazırlanmıştır.

## Değişen dosyalar

- `src/semantic/mir_model.fbs`: `MIR_OP_DELETE` opcode sabiti ve opcode dışa aktarım listesi eklendi.
- `src/semantic/mir.fbs`: `DELETE_STMT` lowering eklendi.
- `src/semantic/mir_evaluator.fbs`: `MIR_OP_DELETE` yürütme eklendi.

## Dürüst sınır

MIR evaluator şu an destructor çağırabilecek AST/routine context taşımadığı için `DELETE` hedef değişkeni sıfırlar. Gerçek destructor çağrısı için sonraki adımda MIR evaluator'a routine table, class metadata ve object heap bağlanmalıdır.

## Test

`tests/oop/mir_delete_object.bas` eklendi. Amaç, MIR lowering/evaluator hattında `DELETE_STMT` yüzünden patlamamaktır.
