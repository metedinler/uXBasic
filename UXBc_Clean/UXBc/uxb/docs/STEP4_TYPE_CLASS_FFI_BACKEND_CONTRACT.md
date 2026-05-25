# UXBc Adım 4 Contract — TYPE / CLASS / FFI

## Amaç

TYPE, CLASS ve FFI sistemlerini MIR/x64 backend tarafında tek sözleşmeye bağlamak.

## Katman sorumlulukları

| Katman | Sorumluluk |
|---|---|
| Parser | TYPE/CLASS/DECLARE/CALL/IMPORT/INLINE sözdizimini AST'ye alır |
| Semantic | isim çözümleme, type binding, field/method doğrulama |
| Layout | field offset, object slot, vtable/metadata |
| MIR | LOAD_FIELD, STORE_FIELD, METHOD_CALL, CALL_DLL, IMPORT, INLINE |
| MIR x64 | runtime/ABI sözleşmesine uygun emit |
| Runtime | object memory, FFI validation, diagnostics |
| JSON | her kararın raporu |

## Diagnostic ilkeleri

- Sahte başarı yasak.
- Offset bilinmiyorsa emit yok.
- ABI bilinmiyorsa emit yok.
- Signer/allowlist reddediyorsa emit yok.
- Unsupported virtual/inheritance açık diagnostic.

## İlk gerçek kapsam

```text
TYPE field load/store
CLASS THIS direct method
NEW/DELETE object pointer lifecycle
CTOR/DTOR direct call
CALL DLL integer/pointer/string pointer args
IMPORT manifest
INLINE x64 guarded
```

## Ertelenen ama saklanmayacak kapsam

```text
virtual dispatch
multiple inheritance
generic class
closure/lambda
SEH exception interop
System V ABI
advanced F64 vector ABI
```
