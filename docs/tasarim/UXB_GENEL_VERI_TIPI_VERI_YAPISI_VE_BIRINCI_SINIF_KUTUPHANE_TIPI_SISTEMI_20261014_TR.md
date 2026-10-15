# uXBasic Genel Veri Tipi, Veri Yapisi ve Birinci Sinif Kutuphane Tipi Sistemi

**Tarih:** 2026-10-14  
**Durum:** Tasarim karari ve uygulama plani  
**Kapsam:** `uxb/` aktif derleyicisi, canonical MIR, native x64, AST/MIR yorumlayicisi, JS, WAT/WASM ve birinci sinif kutuphane tipleri

Bu belge, `uXBasic WASM hedefi Metinler icin dogrusal bellek mimarisi` belgesindeki
linear-memory kararlarini genellestirir. Amac yalnizca metinleri WASM'e tasimak
degil; primitive tipleri, kullanici tanimli veri tiplerini, dizileri,
koleksiyonlari, siniflari, handle tiplerini ve kutuphane tiplerini tek bir
semantik sozlesme altinda toplamaktir.

Belge iki seyi ayni anda korur:

1. Mevcut parser, AST, type binding, MIR ve backend kodunu gereksiz yere
   yeniden yazmadan ilerleyebilmek.
2. Kisa vadeli kolayliklarin ileride `RATIONAL`, `COMPLEX`, `MATRIX`, `TENSOR`
   veya kullanici tarafindan saglanan herhangi bir tip icin cekirdege ozel
   `IF type = ...` yiginina donusmesini onlemek.

Bu bir uygulama iddiasi degildir. Uygulama durumu bu belgenin 18. bolumunde
ayrica verilmistir.

---

## 1. Temel mimari karari

uXBasic'te bir tip, yalnizca lexer veya parser tarafinda taninan bir isim
degildir. Tam tip sozlesmesi asagidaki katmanlarin birlikte cozulmus halidir:

```text
TypeIdentity
  + SemanticCategory
  + StorageLayout
  + OwnershipAndLifetime
  + OperationsAndConversions
  + ABIContract
  + MIRContract
  + TargetProviders
  + Diagnostics
```

Bir tipin hedef makinedeki fiziksel temsili ile kaynak dilindeki semantik
kimligi ayni sey degildir.

Ornegin `RATIONAL`:

```text
Kaynak semantigi : RATIONAL
MIR kimligi      : library-type:rational@<resolved-version>
Native temsili   : runtime address veya provider-defined aggregate
WASM temsili     : linear-memory handle/descriptor
JS temsili       : uXBasic runtime object/handle
Operasyon        : provider operation table
```

Derleyici `RATIONAL`in matematiksel algoritmasini bilmez. Derleyici,
`RATIONAL.ADD` sozlesmesini bulur, tipleri ve sahipligi kontrol eder ve bunu
canonical MIR'e indirir. Algoritma kutuphane provider'inin sorumlulugundadir.

### 1.1 Degismez kurallar

- Tip semantigi hedef backend tarafindan degistirilemez.
- Her backend ayni canonical MIR sozlesmesini uygular.
- Bir tipin desteklenmeyen operasyonu sessizce baska bir tipe veya host
  semantigine dusurulmez.
- `PTR` ham, tur bilgisi olmayan byte adresidir.
- `PTR TO T` gelecekte eklenecekse `PTR`in takma adi degil, tipli ve provenance
  bilgili ayri bir bellek referansidir.
- Yonetsel tipler ham `MEMCOPY` ile kopyalanamaz; provider veya lifecycle
  lowering kullanilir.
- Primitive, record, class ve kutuphane tipleri farkli parser hileleriyle degil,
  ortak TypeDescriptor sozlesmesiyle temsil edilir.
- Native, JS ve WASM arasindaki fark fiziksel yerlesim olabilir; observable
  dil davranisi farkli olamaz.
- Bir hedef desteklemiyorsa ayni canonical diagnostic zarfi icinde acikca
  `target capability unavailable` bildirilir.

### 1.2 Hedeflenen akista tip nerede cozulur?

```text
uXBasic kaynak
    |
    v
Lexer / Parser / AST
    |
    v
Type binding ve TypeDescriptor resolution
    |
    v
MAGIC / operator / conversion / lifecycle resolution
    |
    v
Canonical MIR + type/layout/ownership metadata
    |
    +--> MIR evaluator/runtime
    +--> MIR-x64 / native provider
    +--> JS provider/runtime
    +--> WAT/WASM provider/runtime
```

Kisa vadede mevcut kaynak syntax'i ve AST korunur. Buyuk degisiklik
TypeDescriptor ve MIR metadata katmanina eklenir.

---

## 2. Mevcut kaynakla uzlastirma

Aktif kod tabaninda su anda zaten bircok temel parca vardir:

### 2.1 Uygulanmis veya kullanilabilir temel

- `type_kinds.fbs` primitive, string, pointer, array, object, class, handle,
  task ve benzeri turleri ayirt ediyor.
- `type_rules.fbs` canonical isim, numeric promotion, string, pointer ve
  object-like siniflandirmalarini yapiyor.
- `type_registry.fbs` TYPE, CLASS, INTERFACE ve ENUM tanimlarini kaydediyor.
- Shared layout katmani field offset, size, align, PACK/ALIGN ve C ABI
  kurallarini uretmeye basladi.
- `mir_opcode.fbs` string, array, object/field, union ve memory operasyonlarini
  canonical MIR yuzeyinde ayirtiyor.
- Native scalar array'lerde `rawData` ana veri kaynagi olarak kullaniliyor;
  managed/library array'lerde boxed deger ve library copy yardimcilari var.
- String runtime'da `LEN`, `CONCAT`, `LEFT`, `RIGHT`, `MID`, `COMPARE`
  servisleri var.
- Birinci sinif library manifest/registry; layout, operator, MAGIC,
  conversion, lifecycle, ABI ve target provider alanlarini tasiyor.
- Provider operation registry ve MIR capability gate uygulandi.
- B3 lifecycle lowering ile implicit clone/retain ve scope DROP icin temel
  lowering vardir.
- WASM bellek operasyonlari icin helper ailesi ve acik fail-closed davranisi
  vardir. `MIR_MEMORY_REF` mevcut host-handle array backend'inde bilincli olarak
  engellenir.

### 2.2 Kismen uygulanmis alanlar

- `UXBInterpValue` library payload ve handle alanlarina sahip olsa da tum
  declared type'lari exact fiziksel temsilleriyle tutan tek bir Value modeli
  degildir. Ornegin F80 interpreter tarafinda F64'e indirgenmektedir.
- `ARRAY` semantic olarak taninir; ancak tum hedeflerde ortak descriptor ve
  linear-memory yerlesimi yoktur.
- WASM tarafinda bazi array ve memory davranislari host handle yardimci
  fonksiyonlarina dayanir; bu, portable library type icin hedeflenen son durum
  degildir.
- String operasyonlari vardir; canonical UTF-8 descriptor, code-point/byte
  kurallari ve tum hedeflerde parity kaniti tamamlanmamistir.
- `BYTELEN`, UTF-8 validation, slice lifetime ve `memory.grow` sonrasi JS view
  yenileme ortak bir canonical sozlesme olarak kapanmamistir.
- Layout tablosu user record ve C ABI icin gucludur; managed field, class,
  collection ve library layout'i tek bir runtime descriptor modelinde
  birlesmemistir.
- Library manifest provider alanlari vardir; version/dependency solver ile
  gercek JS/WASM/native provider parity'si aciktir.
- TASK icin mevcut davranis korunmustur; `TASK OF T` ve async provider
  parity'si bu belgenin runtime tip ailesi planinda ayrica ele alinmalidir.

### 2.3 Bu belge neyi degistirir?

Bu belge mevcut yapilari cope atmaz. Asagidaki additive ilerlemeyi onerir:

```text
Mevcut TypeKind/TypeRules
        |
        +--> TypeDescriptor v2 ile zenginlestirilir

Mevcut layout tables
        |
        +--> StorageDescriptor ve LayoutId ile canonical metadata'ya baglanir

Mevcut MIR opcodes
        |
        +--> typeId, layoutId, ownership ve provider metadata alir

Mevcut library manifest
        |
        +--> v2 lifecycle, collection, task-transfer ve target capability
             alanlariyla geriye uyumlu genisletilir
```

Parser ve AST'yi bastan yazmak bu tasarimin kosulu degildir.

---

## 3. Birlesik tip modeli

### 3.1 TypeIdentity

Her tipin iki adi olmalidir:

```text
sourceName  : kullanicinin yazdigi isim, ornegin RATIONAL
typeId      : module/package/version ile cozulen kararlı kimlik
```

`sourceName` tek basina registry anahtari olamaz. Iki paket ayni tip adini
verebilir. Canonical kimlik su parcalari tasir:

```text
namespace
package
version
qualifiedName
abiRevision
```

Ornek:

```text
math.rational:RATIONAL@1.0.0#abi2
```

### 3.2 SemanticCategory

`TypeKind` geriye uyumluluk icin korunur. Buna ek olarak her TypeDescriptor
asagidaki semantik kategorilerden birini alir:

| Kategori | Anlam |
|---|---|
| `VOID` | deger tasimayan tip |
| `SCALAR` | boolean, integer, float ve benzeri POD deger |
| `TEXT` | STRING/WSTRING ve text provider |
| `RAW_POINTER` | tur bilgisi olmayan ham adres |
| `TYPED_REFERENCE` | element type/provenance bilgili bellek referansi |
| `RECORD` | sabit field yerlesimli TYPE/STRUCT/UDT |
| `UNION` | ayni storage'i paylasan secimli alanlar |
| `ARRAY` | rank, bounds, stride ve element lifecycle tasiyan dizi |
| `CLASS` | object header, payload, vtable ve lifecycle |
| `INTERFACE` | vtable/contract view |
| `FUNCTION` | callable veya function pointer |
| `COLLECTION` | LIST, DICT, SET ve iterator provider |
| `HANDLE` | dosya, DLL, JS, WASM veya dis runtime referansi |
| `VARIANT` | runtime type tag tasiyan deger |
| `ANY_OBJECT` | statik tipi bilinmeyen object-like deger |
| `TASK` | async hesap ve sonuc sozlesmesi |
| `SYNC` | TASKGROUP, MUTEX ve thread/synchronization nesnesi |
| `LIBRARY` | yukaridaki davranislardan bir veya daha fazlasini provider ile sunan tip |

`LIBRARY` fiziksel bir layout turu degildir. `RATIONAL` gibi bir tip ayni
anda `LIBRARY + MANAGED + NUMERIC_OPERAND` ozelliklerine sahip olabilir.

### 3.3 TypeDescriptor v2

Asagidaki alanlar hedef modeldir. Mevcut manifest alanlari korunur; yeni
alanlar geriye uyumlu varsayilanlarla eklenir.

```text
TypeDescriptor
  typeId
  sourceName
  qualifiedName
  package
  version
  abiRevision
  semanticCategory
  baseTypeId              optional
  elementTypeId           optional
  resultTypeId            optional
  genericParameters       optional
  storage
  layout
  ownership
  operations
  conversions
  lifecycle
  abi
  providers
  capabilities
  diagnostics
  debug/serialization     optional
```

Descriptor, backend'in runtime nesnesi olmak zorunda degildir. Derleme
metadata'sidir; runtime'da gereken kismi `layoutId`, `providerId`, `typeId`
veya kompakt bir runtime type handle olarak tasinir.

### 3.4 Fiziksel temsili semantikten ayirma

Her tip icin su uc kavram ayrilmalidir:

```text
SemanticValue  : kaynak dilinin gordugu deger
StorageValue   : bir hedefte bu degerin tutuldugu yer/format
TransferValue  : ABI veya provider cagrisi sirasinda tasinan temsil
```

Bu ayrim sayesinde:

- `I32` dogrudan 4 byte olabilir.
- `RATIONAL` native'te pointer veya runtime object olabilir.
- Ayni `RATIONAL` WASM'de linear-memory offset + descriptor olabilir.
- JS'te bir runtime handle olabilir.
- Kaynak program yine ayni `RATIONAL.ADD` semantigini gorur.

Her seyi zorunlu olarak 16 byte descriptor yapmak dogru degildir. Descriptor
gereken managed ve external tipler descriptor kullanir; POD degerler dogrudan
deger olarak kalir.

---

## 4. Tum mevcut veri tipi aileleri

Asagidaki tablo, mevcut `TypeKind` listesini hedef storage, lifecycle ve
WASM kuralina baglar.

### 4.1 Void ve bool

```text
VOID
  Semantic : deger yok
  Storage  : ABI'ye gore yok veya dummy
  Copy     : none
  WASM     : function result yok

BOOLEAN
  Semantic : true/false
  Storage  : canonical i32 (runtime) veya target bool ABI
  Copy     : bitcopy
  WASM     : i32, yalnizca 0/1 invariant'i
```

Bool icin `2`, `-1` veya rastgele non-zero degerlerin dil semantigine
sokulmamasi gerekir. Host boolean degerleri giriste normalize edilir.

### 4.2 Signed ve unsigned integer

`I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64` exact-width tiplerdir.

- Arithmetic promotion mevcut kurallarla canonical MIR'de cozulur.
- Storage width degistirilmez; promotion gecici MIR degeri uretir.
- Native alignment target ABI'den gelir.
- WASM numeric width'i desteklemiyorsa load/store sign-extension ile yapilir.
- `U64` JS numeric double'a kayipsizce dusurulmez; BigInt veya runtime pair
  provider gerekir.
- Pointer arithmetic integer promotion degildir; raw pointer icin ayri memory
  rule kullanilir.

### 4.3 Floating ve genis sayilar

`F32`, `F64`, `F80`, `F128`, `BIGINT`, `BIGF`, `BIGD`, `BALL` ayni numeric
ailenin parcasi olsa da ayni fiziksel temsile zorlanmaz.

```text
F32/F64       : direct scalar veya target numeric instruction
F80/F128      : target capability yoksa provider/runtime value
BIGINT/BIGF   : managed numeric object veya immutable value provider
BIGD/BALL     : precision/context tasiyan managed numeric object
```

Precision kaybi explicit conversion olmadan yapilmaz. Interpreter'in F80'i
F64'e map etmesi gecici bir compatibility davranisidir; hedef modelde
`externalPrecision` metadata'si, numeric provider ve diagnostic ile
kanitlanmalidir.

### 4.4 STRING ve WSTRING

`STRING` canonical olarak UTF-8 text semantigine, `WSTRING` ise wide text
semantigine sahiptir. Fiziksel encoding ile logical Unicode degeri ayridir.

Hedef karar:

- `STRING` ic storage: UTF-8 bytes.
- `WSTRING` ic logical value: ayni Unicode scalar semantics; ABI storage'i
  UTF-16 veya UTF-32 olabilir ve descriptor ile belirtilir.
- Dil seviyesindeki `LEN`, code point sayisini verir.
- `BYTELEN`, fiziksel encoding'in byte sayisini verir.
- `LEFT`, `RIGHT`, `MID` UTF-8 byte'in ortasindan kesmez.
- Invalid UTF-8 acik hata veya explicit byte-string conversion ister.
- Embedded zero byte, string sonlandiricisi degil, uzunlukla tasinan veridir.

Mevcut runtime davranisi bu kurallarla olculmeli ve alt motorlarda ayni hale
getirilmelidir. Bu belge, olcum yapilmamis bir mevcut davranisi tamamlanmis
ilan etmez.

### 4.5 PTR, STRPTR, WSTRPTR ve tipli pointer

`PTR`:

```text
PTR = tur bilgisi olmayan, byte adresi veya target memory handle'i
```

`STRPTR` ve `WSTRPTR`, text ABI'sine bagli pointer benzeri tiplerdir; managed
string sahibi olmak zorunda degildir ve lifetime kurali acikca belirtilmelidir.

Gelecekteki `PTR TO T` su metadata'yi tasir:

```text
MemoryRef
  domain              NATIVE | WASM_LINEAR | JS_BUFFER | EXTERNAL
  elementTypeId       T
  elementSize
  stride
  baseOffset/address
  length/bounds
  permissions         READ | WRITE | EXECUTE (EXECUTE genellikle kapali)
  provenanceId
  generation
  nullable
  borrowed/owned
```

`PTR TO T`, raw `PTR`e otomatik ve sessizce indirgenmez. Raw `PTR`ten typed
pointer'a gecis explicit cast ve bounds/provenance kontrolu ister. Typed
pointer'in `+ 1` islemi byte degil element stride ile yapilir. `PTR`in mevcut
 byte aritmetigi korunur.

WASM'de `MemoryRef` native pointer degildir. Linear memory icindeki offset,
length ve generation sozlesmesidir. `memory.grow` sonrasinda host view'lari
yenilenir; eski JS typed-array view'lari kullanilmaz.

### 4.6 ARRAY

ARRAY, yalnizca ard arda elemanlar dizisi degildir. Array descriptor su
alanlari tasir:

```text
ArrayDescriptor
  typeId
  elementTypeId
  rank
  lowerBounds[rank]
  upperBounds[rank]
  extents[rank]
  strides[rank]
  elementSize
  dataRef
  capacity
  flags
  allocatorId
  lifecycleId
  generation
```

POD array'de `dataRef` contiguous linear storage olabilir. Managed element
array'de her element icin clone/retain/drop kurali uygulanir; ham byte kopyasi
yalnizca `BITCOPY` element icin gecerlidir.

Multidimensional row-major layout canonical MIR'de belirlenir. Lower bound
`0` veya `1` olmasi storage adresini degil index conversion'ini etkiler.

### 4.7 TYPE/STRUCT/UDT, TYPEDEF, ENUM ve UNION

`TYPE Point` bir record descriptor uretir:

```text
RecordDescriptor
  typeId
  size
  align
  pack
  fields[] = name, typeId, offset, bitWidth, fieldFlags
  layoutId
  copyModel
  managedFieldMask
```

Kurallar:

- Field offset, size ve align shared layout engine tarafindan uretilir.
- By-value recursive record yasaktir; recursive link pointer/reference olur.
- Managed field iceren record C ABI'de dogrudan by-value tasinmaz; pointer veya
  provider ABI kullanilir.
- Field assignment field type'in lifecycle sozlesmesini kullanir.
- `MEMCOPY(record)` yalnizca record `BITCOPY` ise gecerlidir.

`UNION` ayni storage'i paylasir. Guvenli union icin aktif variant tag gerekir:

```text
UnionStorage
  payload
  activeTypeId
  tagPolicy
```

Tag'siz raw union erisimi explicit unsafe/low-level operation olarak ayrilir.

`TYPEDEF` yeni bir storage tipi degildir. Mevcut TypeDescriptor'a yeni bir
source-level ad verir ve canonical typeId'ye cozulur. Alias, ABI veya
lifecycle semantigini degistirmez.

`ENUM` iki farkli formu acikca ayirir:

```text
ENUM (numeric)
  closed set of named values
  underlying scalar type
  bitcopy veya numeric provider

ENUM (tagged)
  named variants
  active tag
  union-like payload ve lifecycle
```

Numeric enum'un underlying type'i manifestte sabitlenir. Tagged enum, UNION
kurallarini ve managed variant cleanup planini kullanir. Backend enum adlarini
unutup rastgele integer gibi davranamaz; explicit cast gerekir.

### 4.8 CLASS ve INTERFACE

Class runtime object'i hedefte su mantiksal basliga sahiptir:

```text
ObjectHeader
  typeId
  layoutId
  vtableId
  flags
  size
  generation
```

Payload field layout descriptor ile cozulur. Constructor/destructor,
inheritance ve interface dispatch provider/runtime sozlesmesidir. Interface
degeri object payload degil, object + interface vtable view'idir.

Native'te vtable pointer olabilir; WASM'de table index veya linear-memory
vtable offset olabilir; JS'te runtime object handle olabilir. MIR ayni
`CALL_VIRTUAL` / `FIELD_LOAD` semantigini korur.

### 4.9 VARIANT, ANY ve OBJECT

Bu tipler bilincli olarak farkli statik guvenlik seviyeleridir:

- `VARIANT`: runtime type tag + payload. Conversion explicit veya operator
  registry ile cozulur.
- `ANY`: statik tip bilgisi bilinmeyen deger; kullanmadan once runtime check.
- `OBJECT`: object-like reference; uzerinde yalnizca registry'nin izin verdigi
  ortak operasyonlar calisir.

`ANY` veya `OBJECT` bir kutuphane tipine sessizce cast edilmez. Provider
resolution veya explicit cast gerekir.

### 4.10 FUNCTION_PTR ve handle tipleri

`FUNCTION_PTR` callable signature ve calling convention tasir. Signature
eslesmeden function pointer assignment yapilamaz.

`DLL_HANDLE`, `FILE_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF` dis kaynak
handle'laridir:

- Handle degeri raw pointer gibi aritmetige girmez.
- Handle lifecycle provider tarafindan uygulanir.
- Serialization varsayilan olarak yoktur.
- Hedef desteklemiyorsa handle capture veya import yerine explicit diagnostic
  verilir.

### 4.11 TASK, TASKGROUP ve MUTEX

Mevcut tipsiz `TASK` davranisi korunur. Guvenli statik sonuc icin hedef syntax:

```basic
TASK OF T
```

`TASK OF T` descriptor'i:

```text
TaskDescriptor
  taskTypeId
  resultTypeId
  state
  cancellationPolicy
  errorTypeId
  transferPolicy
  providerId
```

`TASKGROUP` ve `MUTEX` synchronization category altinda handle/lifecycle
kurallarini kullanir. JS Worker, WASM worker/thread veya native thread
secimi kaynak semantigini degistiremez. Destek yoksa ortak capability
diagnostic'i uretilir.

---

## 5. StorageDescriptor ve linear memory modeli

### 5.1 Storage modelleri

Her descriptor asagidaki storage modellerinden birini secer:

| Storage modeli | Kullanim | Kopya kurali |
|---|---|---|
| `DIRECT_SCALAR` | integer, float, bool | bitcopy |
| `INLINE_RECORD` | POD TYPE/STRUCT/UNION | layout'a gore bitcopy |
| `MANAGED_INLINE` | kucuk ama lifecycle gerektiren deger | clone/retain/drop |
| `DESCRIPTOR` | string, array, collection, library value | descriptor-aware |
| `OPAQUE_HANDLE` | external, JS, WASM, DLL, file | provider retain/release |
| `MEMORY_REF` | typed pointer veya memory view | borrow/ownership |
| `TASK_HANDLE` | async sonuc | task provider |

Bu secim kaynak tip adindan otomatik tahmin edilmez; TypeDescriptor'da
cozulur.

### 5.2 WASM linear memory bolgeleri

WASM tarafinda memory kullanimi mantiksal bolgelere ayrilir:

```text
0 .. runtime/static region       immutable constants, type tables
heap                             strings, arrays, records, library values
stack                            activation/frame-local data
host bridge                      import/export marshalling buffers
debug/guard                      optional bounds and generation metadata
```

Bolge adresleri compile-time sabit olmak zorunda degildir. Runtime allocator
`MemoryRef` uretir. Her allocation length, alignment, owner/generation ve
drop callback bilgisine sahip olur.

WASM pointer olarak saklanan degerler linear-memory offset'tir. Native pointer
ile karistirilmasini onlemek icin MIR metadata'da `domain` zorunludur.

### 5.3 Endianness ve alignment

- Canonical MIR scalar degerin bit anlamini tanimlar.
- WASM little-endian storage'tir.
- Native hedef target ABI alignment'i uygular.
- JS DataView explicit little-endian kullanir; typed array'in platform
  varsayimina guvenilmez.
- Packed record ile aligned record ayri `layoutId` alir.
- Misaligned access backend tarafinda load/store helper'a dusurulur.

### 5.4 MemoryRef guvenlik siniri

`MemoryRef` ile raw memory operasyonu su kosullari kontrol eder:

```text
offset >= base
offset + requestedBytes <= base + length
requested elementType compatible
requested permission allowed
generation still active
```

`MIR_MEMORY_REF`, managed `LIST`, `DICT`, `SET`, class veya opaque library
payload'a dogrudan acilmaz. Bu degerler icin provider operation veya explicit
serialization gerekir.

---

## 6. String ve metin bellek sozlesmesi

### 6.1 Canonical descriptor

Hedef canonical descriptor asagidaki mantiksal alanlara sahiptir:

```text
TextDescriptor
  dataRef       offset/address/handle
  byteLength
  capacity
  encoding      UTF8 | UTF16 | UTF32
  flags         CONST | OWNED | TEMP | BORROWED | VALIDATED
  generation
```

16 byte fiziksel descriptor zorunlu hedef degildir. Native, JS ve WASM
alignment farklari nedeniyle fiziksel layout backend'e ait olabilir; MIR
`TextDescriptor` semantigini tasir.

### 6.2 Omur siniflari

```text
CONST    : static storage, release yok
OWNED    : current scope/object sahibidir
TEMP     : expression sonucu, full expression veya statement sonunda drop
BORROWED : baska text'in view'i, sahibi degil
```

`MID` ve `LEFT` sonucu hedef davranis olarak yeni owned text veya lifetime'i
acik borrowed view olabilir. Iki anlam ayni opcode altinda gizlenemez;
MIR'de result ownership metadata'si bulunur.

### 6.3 Runtime operasyonlari

Asgari ortak servis listesi:

```text
UX_STR_ALLOC
UX_STR_RESERVE
UX_STR_ASSIGN
UX_STR_CLONE
UX_STR_APPEND
UX_STR_SLICE
UX_STR_LEN
UX_STR_BYTELEN
UX_STR_COMPARE
UX_STR_RELEASE
UX_STR_UTF8_VALIDATE
```

Mevcut `MIR_STR_NEW`, `MIR_STR_ASSIGN`, `MIR_STR_CONCAT`, `MIR_STR_LEN`,
`MIR_STR_LEFT`, `MIR_STR_RIGHT`, `MIR_STR_MID`, `MIR_STR_COMPARE` korunur.
`BYTELEN` ve validation icin yeni runtime registry entries gerekir; backend
her biri icin kendi semantigini icat etmez.

### 6.4 JS ve memory.grow

JS tarafinda WASM memory view'lari allocation veya `memory.grow` sonrasinda
gecersizlesebilir. Kurallar:

- JS runtime allocation'in sahibi degildir.
- WASM descriptor'dan offset/length okunur.
- `memory.grow` sonrasi `Uint8Array`, `DataView` ve benzeri view'lar yeniden
  kurulur.
- Eski view'i saklayip kullanmak ortak runtime hatasidir.
- JS host'a verilen string owned copy veya explicit borrowed callback lifetime'i
  ile gider.

### 6.5 VARPTR ve string

String `VARPTR` sonucu genel amacli kalici char pointer degildir. Sonuc:

```text
descriptor address veya data MemoryRef
```

olarak tanimlanir ve string mutate/reallocate oldugunda invalid olabilir.
Kalici byte buffer gerekiyorsa explicit `BYTES`/`MEMORY_REF` kopyasi kullanilir.

---

## 7. Veri yapilari ve koleksiyon protokolleri

### 7.1 Genel koleksiyon descriptor'i

Koleksiyonlar dogrudan JS `Array`, `Map` veya `Set` anlamina gelmez. Ortak
protocol su islemleri tanimlar:

```text
COLLECTION_LEN
COLLECTION_EMPTY
COLLECTION_ITER_BEGIN
COLLECTION_ITER_NEXT
COLLECTION_CLEAR
COLLECTION_CLONE
COLLECTION_RETAIN
COLLECTION_DROP
```

Concrete collection kendi operation table'ini saglar.

### 7.2 LIST

```text
ListDescriptor
  elementTypeId
  count
  capacity
  storageRef
  mutationGeneration
  lifecycleId
```

Indexing `O(1)` olmak zorunda olmayan list provider'lari icin `LIST_AT` ve
iterator ayridir. Iterator mutation generation kontrolu yapar; invalid iterator
explicit diagnostic verir.

### 7.3 DICT

```text
DictDescriptor
  keyTypeId
  valueTypeId
  hashProviderId
  equalityProviderId
  entryCount
  generation
```

Key icin `HASH` ve `EQ` operation contract'i zorunludur. Floating NaN,
mutable key ve library type key davranislari provider manifestinde belirtilir.

### 7.4 SET

SET, DICT'in value'suz varyanti degildir; ayni hash/equality contract'ini
paylasabilir ancak source-level semantics ve iteration contract'i ayridir.

### 7.5 DataFrame, Matrix, Tensor ve benzeri

`MATRIX`, `TENSOR`, `DATAFRAME` cekirdek type kind eklenerek degil, collection
ve library type protocol'u ile ifade edilir:

```text
MATRIX
  element type + rank/shape + stride + storage order + numeric provider

TENSOR
  element type + shape + stride + device/storage domain + operations

DATAFRAME
  column schema + row/index provider + nullable policy + serialization
```

Derleyici, `MATRIX.MUL` icin genel `TYPE_OP` cozer; matrix algoritmasi
provider'a aittir.

### 7.6 Genel veri yapisi aileleri

Kuyruk, stack, deque, priority queue, graph, tree, hash table, sparse matrix,
ring buffer, byte buffer, slice, view, iterator, stream, option/result ve
benzeri yapilarin her biri icin cekirdege yeni `TypeKind` eklenmez. Bunlar
generic library type veya collection provider olarak tanimlanir.

Ortak taban contract'i:

```text
DataStructureDescriptor
  typeId
  parameterTypeIds[]
  storagePolicy
  elementLifecycle
  iteratorTypeId optional
  mutationGeneration
  operations[]
  serializationPolicy
  threadPolicy
```

Yapiya ozel operation'lar registry'de tanimlanir:

```text
STACK       PUSH, POP, PEEK
QUEUE       ENQUEUE, DEQUEUE, FRONT
DEQUE       PUSH_FRONT, PUSH_BACK, POP_FRONT, POP_BACK
PRIORITY_Q  INSERT, MIN, MAX, REMOVE
GRAPH       ADD_NODE, ADD_EDGE, NEIGHBORS, BFS, DFS
TREE        ROOT, CHILDREN, INSERT, REMOVE, SEARCH
BUFFER      READ, WRITE, RESIZE, SLICE
ITERATOR    BEGIN, NEXT, CURRENT, END
OPTION      SOME, NONE, IS_SOME, UNWRAP
RESULT      OK, ERR, IS_OK, UNWRAP, ERROR
```

Bu operasyonlar `TYPE_OP` veya provider call olarak canonical MIR'e iner.
POD elemanli bir ring buffer direct linear storage kullanabilir; managed
elemanli bir queue ise her enqueue/dequeue'da element lifecycle'ini uygular.
Iterator, kaynak yapinin `mutationGeneration` degeri ile baglanir ve
invalidasyon acik diagnostic olarak raporlanir.

`BYTE_BUFFER` ile `STRING` ayni sey degildir. Byte buffer arbitrary byte
tasir; text provider UTF-8 invariant'larini uygular. Bu ayrim `PTR`,
`STRPTR` ve `STRING` karisikliklarini onler.

---

## 8. Birinci sinif kutuphane tipi sozlesmesi

### 8.1 Birinci sinif kutuphane tipinin tanimi

Birinci sinif library type su pakettir:

```text
veri yerlesimi
+ operatorler
+ MAGIC
+ donusumler
+ yasam dongusu
+ ABI
+ MIR davranisi
+ hedef provider'lari
+ istege bagli native hizlandirma
+ debug/serialization/hash sozlesmesi
```

`TYPE Point` yalnizca record layout olabilir. `RATIONAL`, ayni zamanda
operator, numeric conversion, lifecycle, string, hash ve ABI provider'i olan
bir library type'tir.

### 8.2 Manifest v2 hedefi

Mevcut `UXBLibraryTypeContract` korunur. Asagidaki alanlar additive olarak
eklenir veya mevcut alanlarin semantigi netlestirilir:

```text
LibraryTypeManifestV2
  typeName
  qualifiedTypeId
  package
  version
  dependencies[]
  category
  capabilities[]
  layout
  storageModel
  copyModel
  ownershipModel
  cloneProvider
  retainProvider
  dropProvider
  moveProvider
  operators[]
  magic[]
  conversions[]
  serialization
  debugFormatter
  hashProvider
  abi
  mirProvider
  nativeProvider
  jsProvider
  wasmProvider
  watProvider
  taskTransfer
  threadSafety
  sharedPolicy
  status
```

Yeni alanlar eski manifest yoksa su varsayimlari alir:

```text
copyModel       = BITCOPY only if layout is explicitly POD; otherwise NONE
clone           = unavailable
retain/drop     = unavailable for unmanaged types, required for managed types
threadSafety    = NOT_THREAD_SAFE
sharedPolicy    = PRIVATE
taskTransfer    = NON_TRANSFERABLE
```

Sessiz `BITCOPY` varsayimi ile managed bir tip kopyalanmaz.

### 8.3 Operation registry

Operation key yalnizca method adi degildir:

```text
OperationKey
  ownerTypeId
  operationKind
  name
  operandTypeIds
  resultTypeId
  abiRevision
  providerId
```

Asgari operation kinds:

```text
ADD SUB MUL DIV MOD
EQ NE LT LE GT GE CMP
NEG ABS POW
INDEX SLICE ITER_BEGIN ITER_NEXT
CONCAT
TOSTRING PARSE
HASH
CLONE RETAIN DROP MOVE
SERIALIZE DESERIALIZE
```

Operator overloading kaynak syntax'inden sonra registry'de cozumu yapar.
Backend bu islemi tekrar isimle aramaz; resolved provider reference MIR'e
konur.

### 8.4 MAGIC

MAGIC, cekirdege yeni TypeKind eklemek degil, standart operation slot'larina
provider vermektir. Ornegin:

```text
RATIONAL
  MAGIC.ADD       -> rational.add
  MAGIC.CMP       -> rational.cmp
  MAGIC.TOSTRING  -> rational.toString
  MAGIC.CLONE     -> rational.clone
  MAGIC.DROP      -> rational.drop
```

Bir MAGIC slot'u cozulmemisse compiler generic operation veya explicit
`operation unavailable` diagnostic'i ureter.

### 8.5 Provider ABI

Provider cagrisi uniform bir zarfa sahip olmalidir:

```text
ProviderCall
  providerId
  operationId
  abiRevision
  receiver
  arguments[]
  resultTypeId
  resultStorage
  ownershipIn[]
  ownershipOut
  exceptionPolicy
  targetCapability
```

Native provider dogrudan symbol call yapabilir. JS/WASM provider runtime
helper veya imported function kullanabilir. MIR seviyesinde bunlar ayni
`ProviderCall` semantics'idir.

### 8.6 Portable MIR provider ve native provider

Bir kutuphane tipi iki implementation secebilir:

```text
portable MIR provider : her hedefte canonical MIR ile calisir
native provider       : hedefte hizlandirma, ayni sonucu vermek zorunda
```

Native provider yoksa portable MIR provider secilebilir. Portable provider da
yoksa compiler, hedefe ozel sessiz fallback yapmaz; acik capability hatasi
verir.

Bu iki seviye sayesinde cekirdege `RATIONAL`, `COMPLEX`, `MATRIX` gibi özel
operator yiginlari eklenmez.

### 8.7 Ornek: RATIONAL

```text
typeId       = math.rational:RATIONAL@1.0.0#abi2
category     = LIBRARY
storage      = MANAGED_INLINE veya DESCRIPTOR
copyModel    = CLONE
operations   = ADD,SUB,MUL,DIV,EQ,CMP,TOSTRING,HASH
lifecycle    = INIT,CLONE,RETAIN,DROP
portableMIR  = mevcut veya planli rational provider
native       = optional
js           = provider veya portable MIR
wasm         = linear-memory provider veya unavailable diagnostic
```

Kaynak:

```basic
DIM c AS RATIONAL
c = a + b
```

Tip binding sonucu:

```text
resolve ADD(a.typeId, b.typeId)
resolve RATIONAL.ADD
check result type and ownership
emit provider call
```

Canonical MIR hedef formu:

```text
TYPE_OP_ADD type=RATIONAL provider=math.rational.add a b -> c
```

Kisa vadeli uygulamada ayni ifade `CALL_PROVIDER` veya provider symbol call
olarak kodlanabilir. Kaynak compiler akisi degismez.

---

## 9. Ownership, lifecycle ve kopyalama

### 9.1 Copy modelleri

Her TypeDescriptor tam olarak hangi kopya modelini kullandigini belirtir:

```text
NONE       : kopyalanamaz; move veya borrow gerekir
BITCOPY    : byte-for-byte kopya guvenli
CLONE      : yeni bagimsiz deger uretilir
RETAIN     : paylasilan ownership sayaci/artisi
MOVE       : kaynak kullanilamaz hale gelir
BORROW     : sahibi degildir, lifetime baglidir
```

`CLONE` ile `RETAIN` ayni sey degildir. Immutable shared string `RETAIN`,
mutable RATIONAL `CLONE` kullanabilir.

### 9.2 Assignment

Atama semantigi:

```text
target old value -> DROP veya REPLACE
source compatible ise
  BITCOPY -> direct copy
  CLONE   -> provider clone
  RETAIN  -> retain + handle assign
  MOVE    -> move and invalidate source
  BORROW  -> lifetime check
```

`DIM a AS I32 = "text"` gibi uyumsuz ilk deger atamasi type binding safhasinda
reddedilir. Parser veya yalnizca runtime assignment'a guvenilmez.

### 9.3 Scope ve exception

Her managed local icin MIR scope exit listesi olmalidir. Normal return,
`THROW`, erken exit ve hata unwind ayni cleanup planini calistirir:

```text
scope enter
  acquire/clone/retain values
scope exit normal
  reverse-order DROP
scope exit exceptional
  same reverse-order DROP
```

Cleanup listesi target backend tarafindan yeniden icat edilmez; canonical MIR
metadata'sindan lower edilir.

### 9.4 BYVAL, RETURN ve BYREF

- `BYVAL T`: callable boundary'de T'nin manifest copy/transfer modeli uygulanir.
- `RETURN T`: sonucun ownership'i function signature ve result metadata ile
  belirlenir; caller gerekli retain/move/drop'u yapar.
- `BYREF T`: alias'dir; yeni owner olmaz, referans lifetime'i scope/escape
  analysis ile kontrol edilir.
- Managed T icin C ABI by-value otomatik secilmez; provider ABI veya pointer
  boundary kullanilir.

### 9.5 Escape ve heap

Local borrowed referans scope disina cikamaz. Heap'e konan deger:

- clone edilir,
- ownership move edilir,
- veya shared retain ile saklanir.

Compiler secimi TypeDescriptor ve operation contract'tan yapar; tip adına
gore ozel if yazmaz.

---

## 10. Canonical MIR sozlesmesi

### 10.1 MIR value metadata

Mevcut `MIRValue` ve `MIRInstruction` yapilari korunarak asagidaki metadata
alanlari additive olarak eklenir:

```text
MIRValue
  typeId
  storageType
  layoutId
  ownership
  memoryDomain
  provenanceId
  nullable

MIRInstruction
  resultTypeId
  providerId/operationId optional
  cleanupScopeId optional
  targetPolicy optional
  sourceLocation
```

Bir instruction'in opcode'u genel olabilir; sonuc tipinin cozulmus metadata'si
zorunludur.

### 10.2 Generic TYPE_OP

Her library type icin opcode eklenmez. Iki asamali uyumluluk onerilir:

1. Kisa vadede mevcut `CALL`/provider call altyapisi kullanilir.
2. Optimizer ve backend gerektirdiginde generic `MIR_TYPE_OP` eklenir.

```text
MIR_TYPE_OP
  operationId
  receiver/operands
  resultTypeId
  providerId
```

`MIR_TYPE_OP` matematik semantigini bilmez; cozulmus operation contract'ini
tasir.

### 10.3 Mevcut MIR opcode'larinin kullanimi

- Scalar arithmetic: mevcut numeric opcode'lar.
- Text: mevcut `MIR_STR_*`, yeni `MIR_STR_BYTELEN` gerektiğinde.
- POD array: `MIR_ARRAY_NEW/LOAD/STORE` ve memory ref.
- Managed array: descriptor-aware array ops, raw memory degil.
- Record/field: field offsets ve layoutId.
- Class: object/field/virtual call ops.
- Library operation: provider call veya generic TYPE_OP.
- Lifecycle: `CLONE`, `RETAIN`, `DROP`, `MOVE` lowering ops.
- Typed pointer: MemoryRef metadata'si ile memory ops.

### 10.4 Memory lowering

`MIR_MEMORY_LOAD/STORE/COPY/FILL` yalnizca memory domain ve lifecycle
kurallari kontrol edildikten sonra lower edilir.

```text
POD contiguous memory
  -> direct load/store/helper

managed value
  -> provider copy/clone/drop

collection/class/library
  -> provider veya explicit serialize

raw PTR
  -> byte-oriented low-level operation
```

`MEMCOPY` ile managed `LIST`, `DICT`, `SET` kopyalamak yasaktir.

### 10.5 Diagnostic envelope

Alt motorlar ayni canonical diagnostic ailesini kullanir:

```text
diagnosticId
category
sourceLocation
typeId/operationId
target
messageKey
details
```

Ornek kategoriler:

```text
TYPE_MISMATCH
CONVERSION_UNAVAILABLE
OPERATION_UNAVAILABLE
PROVIDER_UNAVAILABLE
TARGET_CAPABILITY_UNAVAILABLE
LAYOUT_UNAVAILABLE
MEMORY_BOUNDS
LIFETIME_VIOLATION
INVALID_UTF8
ABI_MISMATCH
```

AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM ayni kaynak hatasinda ayni
`diagnosticId` ve `messageKey` ailesini uretmelidir. Backend sadece hedef
ayrintisini `details` alanina ekler.

---

## 11. Backend uygulama sozlesmesi

### 11.1 Interpreter ve AST/MIR evaluator

Kisa vadede mevcut `UXBInterpValue` korunabilir. Ancak her managed veya
library deger icin:

- `typeName` yerine cozulmus `typeId` eklenmeli,
- `libraryPayload` provider lifecycle ile yonetilmeli,
- `arrayId/objectId/handleId` domain metadata tasimali,
- `rawData` sadece `BITCOPY` storage icin kullanilmalidir.

Uzun vadede `UXBValue` storage class'i semantic value, direct scalar,
descriptor ve handle'i ayirmalidir.

### 11.2 Native x64

- POD scalar ve POD record direct instruction ile lower edilir.
- Managed/library degerler runtime/provider cagrilarina gider.
- C ABI by-value yasagi layout metadata'dan uygulanir.
- Native accelerated provider sonucu portable MIR ile ayni test corpus'u ile
  karsilastirilir.
- Runtime string ve library cleanup exception/return yollarinda tamamlanir.

### 11.3 JS

JS backend uXBasic semantics icin runtime facade kullanir:

```text
ux.str.*
ux.array.*
ux.record.*
ux.library.*
ux.memory.*
ux.task.*
```

Dogal JS `Array`, `Map`, `Set`, `BigInt` veya Promise semantigi uXBasic
semantiginin yerine gecmez; provider implementation olabilir.

### 11.4 WAT/WASM

- Portable value'lar linear-memory descriptor veya numeric WASM value olarak
  temsil edilir.
- Host handles sadece external/host-only tiplerde kullanilir.
- `MIR_MEMORY_REF` icin array descriptor ve bounds/lifetime proof gerekir.
- NATIVE memory mode WASM'e aktarilmaz.
- 8-byte/Q load-store ve alignment yolu eksikse `WASM_UNSUPPORTED` yerine
  canonical capability diagnostic'i kullanilir.
- WASM runtime helper isimleri provider ABI ile registry'den gelir.

### 11.5 Alt motor parity matrisi

Her feature icin su satirlar doldurulmadan “tamamlandi” denmez:

| Feature | AST | MIR | MIR-x64 | AST-x64 | JS | WAT/WASM |
|---|---|---|---|---|---|---|
| `RATIONAL.ADD` | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag |
| UTF-8 `LEN` | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag |
| typed pointer bounds | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag |
| managed array clone/drop | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag |
| `TYPE_OP` provider | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag | execute/diag |

“Diag” hucreleri, feature desteklenmiyorsa ayni acik ve beklenen hatayi
verebilir; bos hucre kabul edilmez.

---

## 12. Donusum sistemi

Donusumlar yonlu edge olarak kaydedilir:

```text
ConversionEdge
  sourceTypeId
  targetTypeId
  kind       IMPLICIT | EXPLICIT | PARSE | FORMAT
  cost
  lossPolicy
  providerId
  targetCapabilities
```

Kurallar:

- Numeric widening implicit olabilir.
- Precision loss explicit ister.
- `STRING`ten `RATIONAL` parse provider ile yapilir; numeric cast degildir.
- `RATIONAL`ten `STRING` format provider ile yapilir.
- `PTR`ten `PTR TO T` explicit ve bounds/provenance check ister.
- `ANY`/`VARIANT`ten concrete type runtime check ister.
- Iki donusum yolu ayni maliyetteyse belirsiz overload diagnostic'i verilir.

Donusum provider'i yoksa parser kabul etse bile type binding tamamlanmis
sayilmaz ve canonical MIR uretilmez.

---

## 13. ABI ve paket cozumu

### 13.1 ABI katmanlari

Her external/provider cagrisi su bilgileri uyumlu hale getirir:

```text
calling convention
argument storage
result storage
alignment
ownership transfer
exception/error channel
thread/async transfer
endianness
abiRevision
```

Managed degerler native C ABI'ye primitive gibi sokulmaz. Gerekirse opaque
handle veya explicit marshalled buffer kullanilir.

### 13.2 Package/version/dependency

Library type registry, ayni paketin farkli ABI revision'larini birbirine
karistirmaz. Resolver su sirayla calisir:

```text
package identity
  -> version constraints
  -> dependency graph
  -> ABI revision compatibility
  -> target provider selection
  -> operation table freeze
```

Cycle, conflict, missing provider ve ABI uyusmazligi derleme asamasinda
raporlanir. Paket solver tamamlanana kadar manifest registry'nin tek basina
runtime parity kaniti olmadigi kabul edilir.

---

## 14. En az kod degisikligi ile kaliteli hedefe giden yol

### Faz 0 - Tasarim ve invariant kilitleme

- Bu belge ve string linear-memory belgesi baglayici design baseline olur.
- Tum TypeKind ve existing manifest alanlari inventory ile eslenir.
- Alt motor parity matrisi gercek testlerle doldurulur.
- Eski TASK/TASKOUT/WAIT kayitlari ile guncel TASK kurali ayrilir.

### Faz 1 - Additive TypeDescriptor v2

Dokunulacak ana yuzeyler:

```text
src/type_binding/type_kinds.fbs
src/type_binding/type_rules.fbs
src/type_binding/type_registry.fbs
src/type_binding/type_storage_contract.fbs     yeni veya additive
src/semantic/layout/layout_shared_core.fbs
src/semantic/layout/layout_type_table.fbs
src/semantic/library_type_contract.fbs
```

Yapilacaklar:

- TypeKind korunur, SemanticCategory ve StorageModel eklenir.
- `typeId`, `layoutId`, ownership ve provider id registry'de sabitlenir.
- Eski builtin resolution, yeni descriptor'a adapter ile baglanir.
- Parser/AST syntax degistirilmez.

### Faz 2 - MIR metadata

```text
src/semantic/mir_model.fbs
src/semantic/mir_opcode.fbs
src/mir/mir_registry.fbs
src/semantic/memory_ref_lowering.fbs
```

- MIRValue ve MIRInstruction metadata genisletilir.
- Mevcut opcode'lar yeniden adlandirilmaz.
- Provider call icin resolved operation id tasinir.
- Raw memory ile managed memory ayrimi MIR'de zorunlu hale gelir.

### Faz 3 - String contract ve POD WASM memory

```text
src/runtime/string/runtime_string.fbs
src/codegen/js/
src/codegen/wasm/
src/codegen/x64/
```

- `BYTELEN`, validation, descriptor lifetime ve UTF-8 testleri eklenir.
- WASM POD array ve text descriptor linear memory'de calistirilir.
- JS view refresh kuralina test eklenir.
- Host-handle yol yalnizca external fallback degil, acik capability secenegi
  olarak kalir.

### Faz 4 - Record, union, class ve managed array

- Shared layout ile runtime layoutId ayni artifact'tan uretilir.
- Managed field mask ve lifecycle planlari record/class descriptor'a eklenir.
- Array descriptor rank/bounds/stride ve generation ile tamamlanir.
- Union active tag runtime'da kontrol edilir.

### Faz 5 - Library provider parity

- RATIONAL once portable MIR + native + JS + WASM provider olarak kapanir.
- Sonra COMPLEX, POLYNOMIAL, MATRIX gibi tipler cekirdege dokunmadan eklenir.
- `taskTransfer`, `threadSafety`, `sharedPolicy` ve `TASK OF T` uygun
  provider sozlesmesine baglanir.
- Paket version/dependency solver tamamlanir.

### Faz 6 - External ABI ve Component Model

- Internal descriptor dis sinira dogrudan acilmaz.
- Component Model veya C ABI boundary adapter'i internal layout'i standarda
  cevirir.
- Serialization/ownership transfer explicit olur.

### 14.1 Minimum degisiklikle yapilmamasi gerekenler

Su yaklasimlar kisa vadede kolay gorunse de hedef sistemi sakatlar:

- Her yeni tipe `type_rules` icinde ozel `IF type = ...` eklemek.
- Her backend'in kendi operator overload tablosunu tutmasi.
- Tum degerleri zorunlu olarak 16 byte descriptor'a cevirmek.
- WASM'de her library type'i JS host object handle'ina dusurmek.
- Managed degerleri `MEMCOPY` ile kopyalamak.
- `PTR` ve `PTR TO T`yi ayni tip saymak.
- JS `Map`, `Set`, Promise veya BigInt davranisini uXBasic semantics olarak
  kabul etmek.
- Provider yokken zero/default/null fallback ile derlemeyi basarili saymak.
- Sadece rejection testlerini feature parity kaniti saymak.

---

## 15. Dosya ve kod sahipligi haritasi

| Sorumluluk | Birincil kaynak yuzeyi |
|---|---|
| Type kind ve canonical isim | `src/type_binding/type_kinds.fbs`, `type_rules.fbs` |
| User type registry | `src/type_binding/type_registry.fbs` |
| Storage/layout | `src/semantic/layout/*` |
| Library manifest | `src/semantic/library_type_contract.fbs` |
| Provider operation/capability | `src/semantic/library_type_provider*.fbs`, registry |
| MIR value/instruction | `src/semantic/mir_model.fbs` |
| MIR op family/signature | `src/semantic/mir_opcode.fbs`, `src/mir/mir_registry.fbs` |
| Ownership lowering | lifecycle lowering ve scope cleanup kaynaklari |
| Typed memory | `src/semantic/memory_ref_lowering.fbs` |
| Interpreter value/heap | `src/interpreter/common/interp_value.fbs`, `interp_heap.fbs` |
| Text runtime | `src/runtime/string/*` |
| Native lowering | `src/codegen/x64/*`, native runtime/provider |
| JS lowering | `src/codegen/js/*` |
| WASM/WAT lowering | `src/codegen/wasm/*` |
| Tests ve parity | `tests/*`, model test runner ve target probes |
| Tasarim/karar kaydi | `docs/tasarim/*`, `ai_koordinasyon/*` |

Her dosya degisikligi bu sorumluluk haritasinda tek bir katmana ait olmali;
provider mantigi backend dosyasina gomulmemelidir.

---

## 16. Test ve kabul kriterleri

### 16.1 Type descriptor

- Tum mevcut TypeKind'ler TypeDescriptor'a kayipsiz map edilir.
- Alias ve canonical typeId ayni semantik tipe cozulur.
- Iki paketin ayni source name'i qualified typeId ile ayrilir.
- Layout size/align/offset artifact'i deterministiktir.

### 16.2 Lifecycle

- BITCOPY, CLONE, RETAIN, MOVE, BORROW ve NONE icin ayri testler vardir.
- Assignment, BYVAL, RETURN, BYREF, array store ve field store ayni kurali
  kullanir.
- Normal return, early exit ve THROW yollarinda DROP sayilari aynidir.
- Double drop, use-after-move, borrowed escape ve missing provider reddedilir.

### 16.3 Text

Asgari corpus:

```text
empty
ASCII
Turkish UTF-8
combining marks
multi-byte emoji
embedded zero
long string requiring growth
invalid UTF-8
slice at character boundaries
memory.grow before/after JS view creation
```

Her corpus AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM'de ayni sonucu veya
ayni canonical diagnostic'i vermelidir.

### 16.4 Arrays ve records

- rank 1/2/N, lower bound 0/1, empty array, REDIM/PRESERVE.
- POD ve managed element array ayrimi.
- stride, alignment ve field offset parity.
- union active tag, unsafe raw union ve recursive pointer record.
- class constructor/destructor/interface dispatch.

### 16.5 Library types

Ilk kabul dizisi:

```text
RATIONAL : ADD,SUB,MUL,DIV,EQ,CMP,TOSTRING,CLONE,DROP
COMPLEX  : ADD,MUL,CONJUGATE,ABS
POLYNOMIAL: ADD,MUL,EVAL
MATRIX   : shape, index, ADD,MUL
```

Her tip icin portable MIR provider, hedef provider'i veya ayni explicit
capability diagnostic'i tum backend hucrelerinde bulunur.

### 16.6 Artifact kaniti

Her kapanan feature icin su artifact'ler saklanir:

```text
canonical MIR dump
layout JSON
provider resolution report
target parity result
diagnostic parity result
runtime output
```

Sadece “derlendi” veya “rejection testi gecti” yeterli kapanis kaniti degildir.

---

## 17. Baglayici tasarim karar listesi

1. Primitive, record, collection ve library tipleri ortak TypeDescriptor
   sozlesmesinden gecmelidir.
2. Semantic type identity ile target physical storage birbirinden ayridir.
3. `PTR` raw byte pointer olarak kalir; typed pointer ayri MemoryRef ailesidir.
4. `STRING` canonical UTF-8, `WSTRING` ayri wide-text ABI'sidir; logical text
   fonksiyonlari Unicode-aware olur.
5. `LEN` code point, `BYTELEN` encoding byte sayisidir.
6. Managed degerlerin raw `MEMCOPY`si yasaktir.
7. `RATIONAL`, `COMPLEX`, `MATRIX`, `TENSOR`, `POLYNOMIAL` gibi tipler
   cekirdege ozel TypeKind olarak eklenmez; library provider olarak eklenir.
8. Operator resolution source type ve operation registry'de bir kez yapilir;
   backend tekrar operator aramaz.
9. Canonical MIR provider reference, type metadata ve ownership metadata
   tasir.
10. Native, JS ve WASM provider'lari ayni semantigi uygulamak zorundadir;
    destek yoksa ayni explicit diagnostic ailesi kullanilir.
11. Tum yeni manifest alanlari geriye uyumlu additive olarak tasarlanir.
12. `TASK` mevcut davranisi korunur; `TASK OF T` statik sonuc tipi olarak
    ayri uygulama halkasidir.
13. En az kod degisikligi, hedef mimariyi bozuyorsa tercih edilmez; additive
    adapter ile ilerlenir, fakat semantic contract gevsetilmez.

---

## 18. Mevcut durum ve acik isler

### Uygulanmis temel

- TypeKind, type rules ve user type registry'nin temel katmanlari.
- Shared record/layout ve C ABI kurallari.
- String MIR opcode/runtime yuzeyi.
- Library manifest, registry, operation provider ve capability gate temeli.
- B3 lifecycle lowering'in clone/retain/drop temel parcasi.
- WASM memory helper'lari ve unsupported alanlarda fail-closed davranis.

### Kismen uygulanmis

- Exact-width ve wide numeric value parity.
- Unified TypeDescriptor v2.
- Unified StorageDescriptor/MemoryRef.
- UTF-8 descriptor, `BYTELEN`, validation ve code-point parity.
- Managed array/record/class runtime layout ve lifecycle.
- JS/WASM linear-memory array ve library value provider'lari.
- `TASK OF T` ve async target provider parity.

### Uygulanmamis veya kapanmamis

- Version/dependency resolver'in tam provider secimi.
- RATIONAL icin gercek portable MIR + native + JS + WASM runtime parity.
- COMPLEX/POLYNOMIAL/MATRIX gibi ilk library paketlerinin kanitli provider'lari.
- Tum alti motorda ayni runtime output/diagnostic matrix'i.
- Component Model veya standard external ABI adapter'i.

Bu bolum, kaynak kod ve test kaniti guncellendikce coordination log ile
birlikte revize edilir. Tasarim metnindeki “hedef” ifadeleri, gercek test
artifact'i olusmadan “uygulandi” anlamina gelmez.

---

## 19. Uygulama sirasi ve bir sonraki halka

Bu belgeden sonra en dusuk riskli ve mimariyi en cok ilerleten sira sudur:

1. TypeDescriptor v2 ve StorageDescriptor'u additive olarak tanimla.
2. Mevcut builtin/library type registry'yi bu descriptor'a map et.
3. MIRValue/MIRInstruction'a typeId, layoutId ve ownership metadata ekle.
4. `DIM ... = ...` tip kontrolunu declaration binding safhasinda kapat.
5. Genel `CLONE/RETAIN/DROP`, `BYVAL`, `RETURN`, scope ve `THROW` cleanup'i
   descriptor-driven hale getir.
6. String descriptor + `BYTELEN` + UTF-8 parity'sini tamamla.
7. POD WASM linear-memory array, sonra managed array descriptor'ini uygula.
8. RATIONAL provider'ini altı motorda ayni output/diagnostic matrix'iyle kapa.
9. Version/dependency solver ve target provider selection'i tamamla.
10. `TASK OF T`, async provider parity ve dis ABI adapter'ini bagla.

Bu sirada her halkada once design artifact, sonra kaynak patch'i, sonra
canonical MIR/runtime kaniti, en son alti motor parity sonucu kaydedilir.

