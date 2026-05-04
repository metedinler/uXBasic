# src7 OOP Runtime Step 2 Patch

Bu paket, src7 feature matrix raporundaki CLASS METHOD / CONSTRUCTOR / DESTRUCTOR kopukluğunu kapatmak için hazırlanmıştır.

## Değişen parçalar

1. `src/parser/parser/parser_stmt_decl_core.fbs`
   - `END CONSTRUCTOR`, `END DESTRUCTOR`, `END METHOD` algılayıcıları eklendi.
   - `inline METHOD body is not supported` engeli kaldırıldı.
   - `CONSTRUCTOR ... END CONSTRUCTOR` gövdesi parse edilir.
   - `DESTRUCTOR ... END DESTRUCTOR` gövdesi parse edilir.

2. `src/parser/parser/parser_stmt_decl_class_method.fbs`
   - `METHOD ... END METHOD` gövdesi parse edilir.
   - Declaration-only eski biçim korunur.

3. `src/runtime/exec/exec_eval_support_helpers.fbs`
   - Routine haritası artık sadece top-level `SUB/FUNCTION` görmez.
   - `CLASS_METHOD_DECL`, `CLASS_CONSTRUCTOR_DECL`, `CLASS_DESTRUCTOR_DECL` de çağrılabilir routine olarak kaydedilir.
   - İsimlendirme:
     - `CLASS Vec2 / METHOD Length2` -> `VEC2_LENGTH2`
     - `CONSTRUCTOR` -> `VEC2_CTOR`
     - `DESTRUCTOR` -> `VEC2_DTOR`

4. `src/runtime/exec/exec_call_dispatch_helpers.fbs`
   - `CLASS_METHOD_DECL` function-like çağrıda kullanılabilir.
   - Class routine çağrılarında `THIS` ve `ME` implicit receiver olarak ayarlanır.
   - Receiver artık parametre sayısına yapay parametre olarak eklenmez.
   - Metadata çocukları (`PARAM_DECL`, `RETURN_TYPE`, `CLASS_METHOD_FLAG`, `CLASS_ACCESS`) çalıştırılmadan atlanır.

5. `src/runtime/exec/exec_class_layout_helpers.fbs`
   - Constructor/destructor doğrulaması artık hem eski `SUB CLASS_CTOR` tarzını hem de yeni class içi `CONSTRUCTOR/DESTRUCTOR` tarzını kabul eder.

## Test

Eklenen örnek:

```basic
CLASS Vec2
PUBLIC
    x AS I32
    y AS I32

    CONSTRUCTOR(x0 AS I32, y0 AS I32)
        THIS.x = x0
        THIS.y = y0
    END CONSTRUCTOR

    METHOD Length2() AS I32
        RETURN THIS.x * THIS.x + THIS.y * THIS.y
    END METHOD
END CLASS

DIM v AS Vec2
v = NEW Vec2(3, 4)
PRINT v.Length2()
```

Beklenen çıktı:

```text
25
```

## Kalan eksikler

Bu paket AST interpreter tarafını güçlendirir. Hâlâ kalan büyük işler:

- x64 codegen tarafında class method body, constructor ve destructor üretimi.
- MIR tarafında `CLASS_METHOD_DECL`, `CLASS_CONSTRUCTOR_DECL`, `CLASS_DESTRUCTOR_DECL` lowering.
- `DELETE` sırasında destructor çağrısının garanti edilmesi.
- Object heap / gerçek allocation policy.
- Interface dispatch ve virtual dispatch için tam vtable modeli.
