# Nested Memory Layout Spec (Win11 x64, incremental)

Durum: Proposed
Tarih: 2026-04-10
Hedef: TYPE/ARRAY ic ice yapilar icin deterministik bellek yerlesimi ve adresleme

## 1. Problem ve kapsam

Bu belge su cekirdek ihtiyaclari tanimlar:

1. Recursive `SizeOf` hesaplama: kullanici tanimli `TYPE` ve `ARRAY` dahil.
2. `OffsetOf(path)` hesaplama: nokta (`.`) ve indeks (`(...)`) zinciri.
3. `ARRAY OF TYPE` icin hizalama/padding politikasi.
4. `PEEK/POKE` ailesi icin kesin adres formulu.
5. Mevcut parser/runtime mimarisine artimli gecis (kirmadan ilerleme).

Kapsam disi (simdilik):

- `UNION`, bitfield, packed attribute.
- GC/heap compacting.
- F80 ABI-ozel alignment tuning (simdilik sabit kural).

## 2. Mimari baglam (mevcut kodla uyum)

Mevcut durum ozeti:

- Parser `TYPE`, `DIM`, `REDIM` duzeyinde AST uretiyor.
- Type referanslari parser sonunda dogrulaniyor.
- Runtime `memory_vm` + `memory_exec` ile adres bazli komutlar calisiyor.
- Noktali/indeksli postfix zinciri expression parser'da henuz AST'ye inmiyor.

Bu nedenle cozum iki kanalli ilerler:

1. Semantik layout tablosu (parserdan sonra) eklenecek.
2. Postfix path parse/resolve destegi fazli acilacak.

## 3. Veri modeli

## 3.1 Layout tipleri

```text
LayoutKind = SCALAR | TYPE_REC | ARRAY_REC | REF
```

`REF`: runtime handle/pointer ile tasinan degisken boyutlu yapilar (or: STRING, LIST, DICT, SET).

## 3.2 Kayitlar

```text
TypeLayout {
  typeName: string
  kind: LayoutKind
  sizeBytes: u32
  alignBytes: u32
  fields[]: FieldLayout      // kind=TYPE_REC
  elem: *TypeLayout          // kind=ARRAY_REC
  dims[]: DimInfo            // kind=ARRAY_REC
  elemStrideBytes: u32       // kind=ARRAY_REC
}

FieldLayout {
  name: string
  offsetBytes: u32
  layout: *TypeLayout
}

DimInfo {
  lower: i64
  upper: i64
  extent: u64 // upper-lower+1
}
```

## 3.3 Temel boyut/alignment tablosu (Win11 x64)

```text
I8/U8/BOOLEAN -> size=1 align=1
I16/U16       -> size=2 align=2
I32/U32/F32   -> size=4 align=4
I64/U64/F64   -> size=8 align=8
F80           -> size=10 align=8   // pratik ABI kurali
POINTER/REF   -> size=8 align=8
```

Not:

- `STRING`, `LIST`, `DICT`, `SET`, dinamik `ARRAY` runtime'da `REF` olarak ele alinabilir.
- Eger ileride fixed `STRING * N` acilacaksa: `size=N`, `align=1`.

## 4. Alignment/padding politikasi

Temel yardimci:

```text
AlignUp(x, a) = ((x + a - 1) / a) * a
```

Kurallar:

1. `TYPE` icinde her alan ofseti: `offset = AlignUp(offset, field.alignBytes)`.
2. Alan yerlestikten sonra: `offset += field.sizeBytes`.
3. `TYPE` toplam boyutu: `size = AlignUp(offset, typeAlign)`.
4. `typeAlign = min(8, max(field.alignBytes))`.
5. `ARRAY` eleman stride: `elemStride = AlignUp(elemSize, elemAlign)`.
6. `ARRAY` toplam boyut: `total = elemStride * Product(extent[])`.

Bu politika ile `ARRAY OF TYPE` eleman baslangiclari her zaman `elemAlign` ile hizali olur.

## 5. Recursive SizeOf algoritmasi

## 5.1 Kural

`SizeOf(T)` asagidaki sekilde hesaplanir:

1. Scalar/Ref ise tablo degerini don.
2. `TYPE` ise alanlari sirayla recursive hesapla.
3. `ARRAY` ise eleman layout'unu recursive hesapla, stride ile carp.
4. Dongusel tip bagimliligini (cycle) yakala.

## 5.2 Cycle kurali

- Dogrudan kendi kendini iceren by-value tip yasak: `TYPE A: x AS A` -> hata.
- Pointer/ref uzerinden recursive model izinli: `next AS POINTER` veya `REF`.

## 5.3 Pseudocode

```text
Function ComputeLayout(typeName): TypeLayout
  if layoutCache has typeName: return cache[typeName]
  if visiting has typeName: error "recursive by-value type"

  mark visiting[typeName]=1

  if builtin(typeName):
    L = BuiltinLayout(typeName)
  else:
    T = findTypeDecl(typeName)
    L.kind = TYPE_REC
    cur = 0
    maxAlign = 1
    for field in T.fields:
      FL = ResolveFieldLayout(field)
      cur = AlignUp(cur, FL.alignBytes)
      add FieldLayout(field.name, cur, FL)
      cur += FL.sizeBytes
      if FL.alignBytes > maxAlign then maxAlign = FL.alignBytes
    L.alignBytes = min(8, maxAlign)
    L.sizeBytes = AlignUp(cur, L.alignBytes)

  cache[typeName]=L
  unmark visiting[typeName]
  return L
End Function
```

`ResolveFieldLayout` icinde `ARRAY` varsa once eleman layout, sonra `dims` ile toplam boyut hesaplanir.

## 6. OffsetOf(path) algoritmasi

## 6.1 Path modeli

Path, bir kok degisken uzerinde postfix zinciridir:

```text
ident ( "." field )* ( "(" idx[,idx]* ")" )* ...
```

Ornek:

```text
oyuncu.envanter(2).ozellikler(1).deger
```

## 6.2 Cikti

`OffsetOf(path)` sadece kok adrese gore bayt ofset dondurur.

```text
addr = baseAddress(ident) + OffsetOf(pathTail)
```

## 6.3 Dizi lineerlesme (row-major)

Bir boyut vektoru icin:

```text
linear = sum_{k=0..n-1} (idx[k]-lower[k]) * strideIdx[k]
strideIdx[k] = product_{j=k+1..n-1} extent[j]
```

Bayt ofset:

```text
offsetArray = linear * elemStrideBytes
```

## 6.4 Pseudocode

```text
Function OffsetOf(rootLayout, pathSteps): i64
  curLayout = rootLayout
  off = 0

  for step in pathSteps:
    if step.kind == FIELD:
      require curLayout.kind == TYPE_REC
      F = findField(curLayout, step.name)
      off += F.offsetBytes
      curLayout = F.layout

    else if step.kind == INDEX:
      require curLayout.kind == ARRAY_REC
      require step.indexCount == curLayout.dims.count

      linear = 0
      for k in 0..dims-1:
        idx = EvalConstOrRuntime(step.idx[k])
        if idx < lower[k] or idx > upper[k]: error "index out of bounds"
        linear += (idx - lower[k]) * strideIdx[k]

      off += linear * curLayout.elemStrideBytes
      curLayout = curLayout.elem

  return off
End Function
```

Not:

- Compile-time sabit index varsa semantik fazda ofset sabitlenebilir.
- Runtime index varsa codegen/runtime'da ayni formul uygulanir.

## 7. PEEK/POKE adres formulu

Genel form:

```text
EffectiveAddress = BaseAddress + OffsetOf(path)
```

Kullanima baglama:

1. `BaseAddress` genelde `VARPTR(kokDegisken)`.
2. `OffsetOf(path)` yukaridaki algoritmadan gelir.
3. Son adim tipine gore genislik secilir:

```text
1 byte -> PEEKB / POKEB
2 byte -> PEEKW / POKEW
4 byte -> PEEKD / POKED
8 byte -> PEEKQ / POKEQ (ileride)
```

Kompakt ifade:

```text
addr(path) = VARPTR(root) + OFF(path)
value = PEEK*(addr(path))
POKE* addr(path), value
```

`POKE` legacy alias kurali korunabilir (`POKED` ile eslenmis davranis).

## 8. Parser/Semantik/Runtime entegrasyon plani (incremental)

## Faz 0 - Layout altyapisi, syntax degismeden

Hedef:

- `TYPE` ve `DIM/REDIM` uzerinden layout tablosu cikarmak.
- `SizeOf(typeName)` API'sini semantik katmanda acmak.

Degisiklikler:

1. Yeni modul: `src/semantic/layout.fbs` (veya parser altinda gecici).
2. `ParseProgram` sonrasi: `BuildLayoutTable(ast)` cagrisi.
3. Hata sozlesmesi:
   - unknown type
   - recursive by-value type
   - invalid bound

Cikis:

- Heniz dotted/indexed expression parse edilmeden bile `SizeOf(TYPE)` hazir olur.

## Faz 1 - Postfix path AST (minimal grammar extension)

Hedef:

- `ident.field(index).field` zincirini expression AST'ye almak.

Degisiklikler:

1. `parser_expr.fbs` icinde `ParsePostfix` katmani ekle.
2. Yeni AST kind: `FIELD_ACCESS`, `INDEX_ACCESS`.
3. Atama LHS tarafi sadece bu node'lar icin acilsin.

Risk azaltma:

- Once sadece `IDENT` kokune izin ver.
- Method call/complex postfix daha sonra.

## Faz 2 - Offset resolver + runtime adresleme

Hedef:

- AST postfix zincirini `OffsetOf` ile compile-time/runtime karmasi cozumlemek.

Degisiklikler:

1. Yeni cozumleyici: `ResolveAddressExpr(node)`.
2. `memory_exec.fbs` icinde LHS/RHS ident disi adreslenebilir hedef destegi.
3. `PEEK*`/`POKE*` icin tek `EffectiveAddress` helper.

## Faz 3 - ARRAY OF TYPE full policy + test matrisi

Hedef:

- `elemStride` + row-major + bounds check tam devre.
- Layout dogrulama testleri.

Test siniflari:

1. `SMK-LAYOUT-SIZEOF-001`: nested type sizeof.
2. `SEM-LAYOUT-OFFSETOF-00x`: field+index kombinasyonlari.
3. `SEM-LAYOUT-ALIGN-00x`: padding dogrulama.
4. `REG-MEM-PEEKPOKE-LAYOUT-00x`: adres bazli okuma/yazma.

## 9. Determinizm ve hata sozlesmesi

Gerekli garanti:

1. Ayni AST + ayni type table => ayni `size/align/offset` sonucu.
2. Hata metni stabil olmalı (CI ve manifest icin).
3. Bounds check davranisi acik secilebilir olmali:
   - strict: hata
   - legacy: mask/ignore (onerilmez)

Oneri:

- Varsayilan `strict`.
- Legacy mod sadece feature-flag ile.

## 10. Kisa ornek

```text
TYPE Vec2
  X AS F32
  Y AS F32
END TYPE

TYPE Entity
  Pos AS Vec2
  Hp AS I32
END TYPE

DIM E(0 TO 9) AS Entity
```

Hesap:

1. `SizeOf(Vec2)=8`, `Align(Vec2)=4`
2. `Entity`:
   - `Pos` offset 0, size 8
   - `Hp`  offset 8, size 4
   - toplam 12, typeAlign=4 => `SizeOf(Entity)=12`
3. `ARRAY Entity`:
   - `elemStride = AlignUp(12,4)=12`
4. `OffsetOf(E(3).Hp)= 3*12 + 8 = 44`
5. `addr = VARPTR(E) + 44`

## 11. Uygulama checklist

1. `layout` tablosu cache + cycle detect eklendi.
2. `TYPE` field metadata AST'den okunuyor.
3. `ARRAY` dims icin extent/stride hesabi var.
4. `OffsetOf` resolver dotted/indexed zinciri cozuyor.
5. `PEEK/POKE` tek adres helper kullaniyor.
6. Testler: smoke + semantic + regression yesil.
