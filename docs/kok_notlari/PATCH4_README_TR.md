# uXBasic PATCH-4 — Array / Buffer / Collection Memory ABI

Tarih: 2026-08-09

Bu yama, PATCH-3 Memory ABI'nin üzerine uygulanmak üzere hazırlanmıştır.
Kaynak tabanı: `uxb(09.08_3).zip`.

## PATCH-4'ün amacı

PATCH-3 ile gelen canonical memory işlemlerinin gerçek array storage ile birleşmesini sağlar:

- `SIZEOF(array)` artık gerçek array layout bilgisine bağlanır.
- Array operandı `MIR_MEMORY_REF` ile canonical MemoryRef'e indirilir.
- `MEMCOPYB/W/D` kaynak veya hedef olarak statik, tek boyutlu array kabul eder.
- x64 array storage artık element tipinin gerçek byte genişliğini kullanır; önceki sabit 8-byte varsayımı kaldırılır.
- JS backend array MemoryRef'i gerçek runtime view olarak taşır ve memory copy/fill/load/store yolları bunu kullanabilir.
- Collection (`LIST/DICT/SET`) nesnelerinin ham object header'ını `MEMCOPY` ile kopyalamak özellikle engellenir.

## Yeni canonical MIR

```text
MIR_MEMORY_REF
    operands: kind, name, elementBytes, byteLength
    result: MemoryRef/ANY

MIR_ARRAY_SIZEOF
    operands: arrayName, elementBytes, elementCount
    result: I64
```

`MIR_MEMORY_REF` için şu anda gerçek kaynak türü:

```text
ARRAY
```

olarak tanımlıdır.

## Array sınırı

PATCH-4 mevcut compiler array backend'i ile uyumlu olmak için **tek boyutlu ve compile-time bounds** ile sınırlıdır.

Dinamik `REDIM` veya çok boyutlu array için sahte MemoryRef üretilmez; semantic aşamada hata verilir. Bu, sonraki gerçek dynamic-buffer ABI'si için bilinçli bir sınırdır.

## Collection kararı

Mevcut kaynakta UXCollections için gerçek bir compiler-level `MemoryView/CopyTo/CopyFrom` ABI bulunmadığı için PATCH-4:

```text
LIST object header -> MEMCOPY
DICT object header -> MEMCOPY
SET object header -> MEMCOPY
```

yapmaz.

Bunun yerine semantic lowering açık hata verir ve gerçek library contract'ı gelene kadar ham object kopyasını reddeder.

## WASM kararı

Mevcut WASM array backend'i host-handle tabanlıdır; canonical linear-memory array representation'ı henüz yoktur. Bu nedenle `MIR_MEMORY_REF` için WASM tarafında generic `host_call16` fallback kullanılmaz. Backend açıkça fail-closed olur.

`MIR_ARRAY_SIZEOF` WASM'de gerçek sabit hesaplama ile desteklenir.

Bu davranış bilinçlidir: PATCH-4'ün amacı çalışmayan bir WASM MemoryRef'i çalışıyormuş gibi göstermek değildir.

## x64 düzeltmesi

Önceki array backend:

```text
elementBytes = 8
```

varsayımındaydı.

PATCH-4 artık array declaration'ın `TYPE_REF` bilgisini MIR global array metadata'sına taşır ve x64 storage için:

```text
I8/U8/BYTE      1
I16/U16         2
I32/U32/F32     4
I64/U64/F64     8
F80/F128/...    16
```

şeklinde gerçek genişlik kullanır. x64 indexed load/store da genişliğe göre gerçek instruction üretir.

## `SIZEOF(array)`

Örneğin:

```text
DIM A(0 TO 99) AS I32
N = SIZEOF(A)
```

canonical MIR:

```text
MIR_ARRAY_SIZEOF A, 4, 100 -> N
```

ve sonuç:

```text
400
```

olur.

## Uygulama sırası

```text
PATCH-1 Canonical OOP MIR
        ↓
PATCH-2 OOP ABI
        ↓
PATCH-3 Memory ABI
        ↓
PATCH-4 Array / Buffer / Collection Memory ABI   <- BU YAMA
        ↓
PATCH-5 Iterator / EACH
```

## Test durumu

Bu paket hazırlanırken Windows/FreeBASIC build çalıştırılmamıştır; mevcut ortamda `fbc`/Wine bulunmadığı için kaynak düzeyinde doğrulama yapılmıştır.

Yama özellikle `src/src` alt ağacına uygulanmaz. Kullanıcının son kaynak paketindeki gerçek canonical kök `src/` kabul edilmiştir.
