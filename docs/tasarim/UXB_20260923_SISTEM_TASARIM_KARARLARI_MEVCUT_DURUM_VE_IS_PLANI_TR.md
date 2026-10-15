# uXBasic 2026-09-23 Sistem Tasarim Kararlari, Mevcut Durum ve Is Plani

Tarih: 2026-09-23  
Hazirlayan: Codex  
Ana kaynaklar: paylasilan ChatGPT sohbeti (`UXBasic Bellek Tasarımı`), 20.09 tasarim belgeleri, canli `ai_koordinasyon` defterleri ve mevcut kod agaci.

Bu belge, 20.09 tasarim belgelerinin uzerine gelen 23.09 paylasimli sohbeti, canli kaynak agacindaki gercek durumu ve bundan sonraki is halkalarini tek sistem tasarim kaydinda toplar.

## 0. Okuma Anahtari

| Etiket | Anlam |
|---|---|
| `YAPILDI-DOGRULANDI` | Kodda var ve calistirilmis kanitla dogrulandi. |
| `KISMEN-YAPILDI-DOGRULANDI` | Dar halka calisiyor; hedef mimarinin onemli alt parcalari acik. |
| `TASARIM-KARARI` | Karar defterinde veya bu belgede kilitli, fakat kod henuz tam degil. |
| `ACIK-HALKA` | Takip edilecek yeni veya devam eden uygulama halkasi. |

Bu ayrim onemlidir; uXBasic'te "belgede var" ile "derleyici gercekte yapiyor" artik ayni sey sayilmamalidir.

## 1. Ana Kimlik Karari

uXBasic'in hedefi su degildir:

```text
Her yeni matematiksel/sistem/AI tipini cekirdege primitive olarak gommek.
```

uXBasic'in hedefi sudur:

```text
Cekirdege eklenmemis tiplerin bile dilin dogal parcasiymis gibi davranmasini
saglayan kucuk, saglam ve genisletilebilir bir BASIC olmak.
```

Bu nedenle yeni tip icin varsayilan soru:

```text
Bu tipi cekirdege nasil ekleriz?
```

degildir. Varsayilan soru:

```text
Birinci sinif kutuphane tipi sistemi bu tipi cekirdegi degistirmeden ifade
edebiliyor mu?
```

olacaktir. Cevap `evet` ise tip kutuphaneye gider. Cevap `hayir` ise o tipe ozel cekirdek istisnasi eklenmez; once tip-genisletme sisteminde hangi genel yetenegin eksik oldugu bulunur.

Bu karar `RATIONAL`, `COMPLEX`, `POLYNOMIAL`, `MATRIX`, `VECTOR`, `TENSOR`, `DATAFRAME`, `MODEL`, `IMAGE`, `COLOR`, `UNIT`, `QUATERNION` ve benzeri gelecek tipler icin gecerlidir.

## 2. Cekirdegin Bilmesi Gereken Sey

Cekirdek `RATIONAL` nasil toplanir bilmek zorunda degildir.

Cekirdegin bilmesi gerekenler:

```text
Bu bir tiptir.
Boyutu/yerlesimi budur.
Su operatorleri destekler.
Su donusumleri destekler.
Su yasam dongusu kurallarini tasir.
Su sekilde kopyalanir/yok edilir.
Su sekilde STRING'e cevrilir.
Su ABI ile gecirilir.
Su hedeflerde su provider'lar kullanilir.
```

Kutuphanenin saglamasi gereken sozlesme:

```text
RATIONAL
    layout: NUM:I64, DEN:I64
    operators: ADD, SUB, MUL, DIV, EQ, NE, LT, LE, GT, GE, CMP
    magic: TOSTRING, CLONE, HASH
    conversions: FROM_I64, ...
    lifecycle: INIT, COPY/CLONE, DROP
    abi: by-value/by-ref/native/js/wasm policies
    providers: MIR, JS, WASM, native
```

Bu sozlesme tek tek `IF type = RATIONAL` yiginlari yerine registry/manifest uzerinden cozulecektir.

## 3. Birinci Sinif Kutuphane Tipi Paketi

Birinci sinif kutuphane tipi siradan `TYPE` degildir.

Siradan `TYPE`:

```basic
TYPE Point
    X AS F64
    Y AS F64
END TYPE
```

Birinci sinif kutuphane tipi ise su pakettir:

```text
veri yerlesimi
+ operatorler
+ MAGIC davranis
+ donusumler
+ yasam dongusu
+ ABI
+ canonical MIR davranisi
+ JS/WASM/native provider politikasi
+ istege bagli hizlandirma
```

Bu, `TYPE`, `CLASS`, `MODULE`, `NAMESPACE`, `MAGIC`, `DERIVE`, operator cozumleme, preprocessor/generator sistemi ve canonical MIR'in ayni mimaride birlesecegi yerdir.

## 4. Canonical MIR Ilkesi

Kaynak:

```basic
c = a + b
```

Tip baglama katmani:

```text
a : RATIONAL
b : RATIONAL
RATIONAL.ADD mevcut
```

Kanonik indirgeme:

```text
CALL RATIONAL.ADD(a,b)
```

veya ileride:

```text
TYPE_OP ADD, RATIONAL, a, b
```

Bu noktadan sonra hedefler ayni sozlesmeyi tuketir:

```text
uXBasic source
    -> type binding
    -> MAGIC/operator resolution
    -> Canonical MIR
    -> optimizer
    -> MIR-x64 / JS / WAT-WASM / native provider
```

Tip hedef islemciye degil, MIR sozlesmesine baglanir.

## 5. Canli Kod Durumu: Birinci Sinif Kutuphane Tipi

Durum: `KISMEN-YAPILDI-DOGRULANDI`

Canli agacta S-112 icin su halkalar tamamlandi:

| Halka | Durum |
|---|---|
| `src/semantic/library_type_contract.fbs` registry/manifest cekirdegi | Var |
| Referans `RATIONAL` manifesti | Var |
| `DIM a AS RATIONAL` type-binding | Var |
| `RATIONAL + RATIONAL` operator cozumleme | Var |
| Canonical MIR `CALL RATIONAL.ADD` lowering | Var |
| MIR yorumlayici RATIONAL provider | Var |
| `ADD/SUB/MUL/DIV/EQ/NE/LT/LE/GT/GE` | Var |
| `mir_provider/js_provider/wasm_provider/native_provider` manifest alanlari | Var |
| JSON manifest okuma/yazma | Var |
| `LIBTYPE "name.library_type.json"` kaynak yuzeyi | Var |
| Kaynak-dizini ve paket-koku manifest arama | Var |
| Fail-closed negatifler | Var |

Son bilinen dogrulamalar:

```text
tests/library_type_contract/rational_include_manifest_semantic.uxb -> 3/1
tests/library_type_contract/rational_libtype_source_relative.uxb  -> 12/1
tests/library_type_contract/rational_libtype_package_search.uxb   -> 13/1
tests/library_type_contract/rational_mir_ops_value.uxb            -> 2/1, 24/1, 3/2
tests/library_type_contract/rational_mir_compare_value.uxb        -> EQ, GT
```

Son bilinen taze derleyici SHA256:

```text
CD663C2493D33381A2AEFC75BD085FCC965CBCEFA4F2C4A66D0CBAEFCBCF51FC
```

## 6. Acik Halka: Kutuphane Tipi Yasam Dongusu

Durum: `ACIK-HALKA`

Paylasimli sohbetin onemli bulgusu: manifestte `lifecycle` alani var, fakat yasam dongusu semantigi henuz yeterince somut degil.

Su kodun anlami kilitlenmeli:

```basic
DIM a AS RATIONAL
DIM b AS RATIONAL

b = a
```

Olasiliklar:

```text
deep copy
shared handle
reference count
move
clone
copy-on-write
```

Her tip ayni olmayabilir:

| Tip | Onerilen baslangic modeli |
|---|---|
| `RATIONAL` | Deger tipi; kucuk payload; copy by value olabilir. |
| `COMPLEX` | Deger tipi; copy by value olabilir. |
| `POLYNOMIAL` | Dinamik katsayi dizisi; clone/drop gerekir. |
| `MATRIX` | Buyuk tampon; ownership/share/move karari gerekir. |
| `TENSOR` | Buyuk ve hedef-provider bagimli; handle + refcount gerekebilir. |

Yeni manifest karar alani onerisi:

```text
storage_model: VALUE | HANDLE | REFERENCE
copy_model: BITCOPY | CLONE | MOVE_ONLY | REFCOUNT | COW
drop: NONE | PROVIDER_DROP | MAGIC_DROP
clone: NONE | MAGIC_CLONE | PROVIDER_CLONE
```

Bu is S-134 olarak takip edilmelidir.

## 7. RATIONAL Constructor ve `1 / 3` Karari

Durum: `TASARIM-KARARI`

Su kaynak:

```basic
DIM r AS RATIONAL
r = 1 / 3
```

bugunku sayisal kurallarla once normal sayisal bolme olarak cozulurse tam `1/3` bilgisi kaybolur.

Ilk guvenli karar:

```basic
r = RATIONAL(1, 3)
```

veya:

```basic
r = Rational.Create(1, 3)
```

olmalidir.

Ileride hedef-tipe-duyarli ifade cozumleme oturdugunda:

```basic
r = 1 / 3
```

baglamdan `RATIONAL.DIV(RATIONAL(1), RATIONAL(3))` gibi bir yola indirilebilir. Bu ikinci halka ayrica tasarlanmalidir; ilk RATIONAL paketi buna baglanmamali.

## 8. JS / WAT / WASM Hedefleri

Durum: `ACIK-HALKA`

JS/WASM artik yan hedef degildir. Bir kutuphane tipi yalniz Windows DLL veya native x64 provider ile calisiyorsa dilin dogal parcasi sayilmaz.

Her tip icin hedef politikasi acik olmalidir:

```text
pure MIR
JS provider
WASM linear-memory / handle provider
native x64 provider
C ABI provider
fail-closed tani
```

Buradaki `fail-closed`, nihai hedef degil; gelistirme sirasinda sessiz yanlis sonucu engelleyen gecici bilincli sinirdir. Nihai hedef desteklenen dil yuzeyinin JS/WASM'da da gercek bir karsiliginin olmasidir.

Antigravity icin gecerli sozlesme:

```text
RATIONAL primitive ekleme.
Canonical MIR CALL RATIONAL.<OP> sozlesmesini tuket.
Manifestteki js_provider / wasm_provider alanlarini kullan.
Destek yoksa sessiz fallback degil net tani ver.
```

## 9. Meta Komut ve Generator Registry

Durum: `ACIK-HALKA`

Paylasimli sohbetin baska ana ekseni: Python ile kaynak ureten generator fikri uXBasic'e yabanci degildir. Mevcut preprocessor/metakomut altyapisi zaten bunun parcalarini tasir:

```text
%%DEFINE
%%MACRO
%%SET
%%EVAL
%%FOR
%%FOREACH
%%REPEAT
%%API_ENDPOINT
%%ROUTE
%%EXPORT_BASIC
%%HOST_IMPORT
%%GEN_FILE
%%GEN_BLOCK
```

Hedef akisi:

```text
metadata
    -> generator registry
    -> normal uXBasic source
    -> lexer/parser
    -> semantic
    -> canonical MIR
    -> x64 / JS / WASM
```

Kritik kural:

```text
Uretilen kod ozel bir "meta runtime" olarak yasamaz.
Normal uXBasic kaynagina donusur ve normal derleyici kapilarindan gecer.
```

Ornek:

```basic
%%DERIVE JSON, EQ, HASH FOR FishRecord
```

su kaynaklara uretilebilir:

```basic
FUNCTION FishRecord_ToJson(...)
FUNCTION FishRecord_Equals(...)
FUNCTION FishRecord_Hash(...)
```

REST ornegi:

```basic
%%API_ENDPOINT FishList GET "/fish"
%%API_ENDPOINT FishCreate POST "/fish"
%%GENERATE REST_HANDLERS
```

su ek ciktilari uretebilir:

```text
uXBasic handler source
routes.json
openapi.json
browser client JS
WASM host binding
test skeleton
```

Bu sistem birinci sinif kutuphane tipiyle de birlesir:

```text
kütüphane tipi manifesti -> MAGIC/operator wrapper'lari
TYPE/CLASS metadata      -> constructor/clone/hash/tostring
HOST_IMPORT              -> JS/WASM host wrapper
DLL manifest             -> CALL(DLL) wrapper
```

Bu is S-136 olarak takip edilmelidir.

## 10. TASK / SLOT / THREAD / PARALEL Kararlari

Durum: `KISMEN-YAPILDI-DOGRULANDI`

Paylasimli sohbetin ana karari:

```text
SLOT sayisi ile TASK sayisi ayni sey degildir.
```

Hedef model:

```text
TaskDefinitionTable  -> EVENT / PIPE / THREAD / PARALEL tanimlari
SlotTable[0..255]    -> 256 sabit baglama/yonlendirme noktasi
TaskRunTable         -> dinamik calisma ornekleri
WorkerPool           -> sinirli sayida gercek OS worker thread
```

Bu nedenle:

```basic
FOR i = 1 TO 10000
    gorev(i) = TRIGGER THREAD Worker(i)
NEXT
```

10.000 gercek OS thread acmak anlamina gelmemelidir. 10.000 dinamik TASK calisma kaydi, sinirli bir worker havuzunda siralanip islenmelidir.

`TASKOUT`, 256 elemanli global SLOT sonuc dizisi olmamalidir. Her TASK calisma orneginin kendi sonucu, hatasi ve durumu olmalidir.

Kavramsal iliski:

```text
SLOT 5
  -> TASK #101 result=200
  -> TASK #102 result=400
  -> TASK #103 result=600
```

`TASK` kullanici acisindan opak sistem tutamacidir:

```basic
DIM t AS TASK
```

Bu sayi veya `PTR` degildir. Su islemler yasak olmalidir:

```basic
t = t + 1
t = t * 4
POKED t, 5
```

Yururlukteki kod/defter durumu: Claude 1'in 2026-09-23 kaydina gore S-030 Faz 1 AST motorunda tamamlandi. `SPAWN`, `TASK`, `TASKGROUP`, `.STATUS`, `.WAIT()`, `.RESULT`, `.JOIN()`, `.CANCEL()`, `.ERRORTEXT`, `TASKGROUP.ADD` ve `TASKGROUP.JOIN` AST'de calisiyor. Canonical-MIR/native x64/legacy x64 temiz reddediyor. JS codegen henuz gercek calisma saglamiyor.

Paylasimli sohbette gecen `WAIT TASK t`, `TASKSTATUS(t)`, `TASKOUT(t)`, `CANCEL TASK t` bicimleri kavramsal tasarim secenekleridir. Yururlukteki defterde kilitlenen canli yuzey simdilik `SPAWN` ve TASK member'lari uzerindendir.

## 11. Pointer, MemoryRef ve 6502 Adresleme Dersi

Durum: `TASARIM-KARARI` + bazi alt halkalar `ACIK-HALKA`

Mevcut raw `PTR` kurali korunur:

```text
PTR + integer -> PTR
integer + PTR -> PTR
PTR - integer -> PTR
PTR - PTR     -> I64
PTR + PTR     -> hata
```

Bu aritmetik byte tabanlidir:

```text
p + 1 -> 1 byte ileri
p + 4 -> 4 byte ileri
```

Bu karar 6502 adresleme zihniyetiyle uyumludur:

```text
temel adres + ofset
```

Fakat 6502'nin butun adresleme modlari dile yeni garip operatorler olarak eklenmemelidir. Mevcut uXBasic komutlariyla ifade edilebilir:

```basic
value = PEEKB(p + y)
base  = PTR(PEEKQ(p))
value = PEEKB(base + y)
value = PEEKB(PTR(PEEKQ(p + x)))
```

Bu, 6502'nin adresleme fikirlerini 64 bit genel pointer zincirine tasir.

Raw `PTR` byte-ofset araci olarak kalir. Gelecekteki tipli pointer ayri yuzey olmalidir:

```basic
DIM p AS PTR TO I32
p = p + 1    ' I32 stride kadar ilerler
```

Bu S-113 olarak takip edilmektedir.

MemoryRef hedefi:

```text
VARPTR
PEEK/POKE
MEMCOPY/MEMFILL
array backing storage
FFI/native pointer
BYREF
```

ayni ortak bellek cozumleyicisi uzerinden gecmelidir.

AUTO bellek secimi icin tasarim karari:

```text
PTR kaynak        -> NATIVE
duz sayisal adres -> VIRTUAL
EXTERNAL          -> bellek turu degil, NATIVE origin bilgisi
```

Bu kararlar eski 20.09 belgesinde vardir; canli kodda tum hedeflerde tam teklesmis degildir.

## 12. OOP Durumu

Durum: `KISMEN-YAPILDI-DOGRULANDI`

Kapanan onemli halkalar:

| Halka | Durum |
|---|---|
| `DIM a AS Class` NULL referans, nesne yalniz `NEW` ile dogar | S-108 kapandi |
| Null field/method access net hata | Kapandi |
| `PRINT obj.Method()` iki kez calisma hatasi | S-124 kapandi |
| Method return type tasimama | S-125 kapandi |
| Yazilmamis alanin bos basmasi | S-126 kapandi |
| Ciplak alan/metot adi `THIS.` olmadan | S-119 kapandi |
| Sinif alanina compound assignment / `++` / `--` | S-130 kapandi |
| Native x64 field width ezmesi | S-131 kapandi |
| F32 alan/deger atama sorunu | S-132 kapandi |

Hedefte OOP, birinci sinif kutuphane tipiyle su noktalarda birlesmelidir:

```text
MAGIC operatorler
MAGIC ITER
constructor/destructor
clone/drop
interface/virtual dispatch
library type provider wrapper'lari
```

Basit CLASS artik daha saglamdir; fakat tam hedef OOP sistemi hala yalniz bu kapali halkalardan ibaret degildir.

## 13. FOR EACH / DO EACH Sistemi: Ne Vardi, Ne Degisti?

Bu bolum, "FOR EACH da `IN a,b,c` neden kaldirildi?" sorusunun resmi cevabidir.

### Eski Sistem

uXBasic'te iki farkli EACH semantigi vardi:

```basic
FOR EACH x IN expr1, expr2, expr3
    ...
NEXT
```

`FOR EACH` snapshot/fotograf semantigiydi. Virgullu listedeki tum ifadeler govde calismadan once degerlendirilir.

Ornek:

```basic
a = 10
FOR EACH x IN a, a + 5, a + 20
    PRINT x
    a = 100
NEXT
```

Beklenen:

```text
10
15
30
```

`DO EACH` ise JIT/canli semantigiydi. Her ifade govdeyle araliksiz sirada degerlendirilir; onceki iterasyondaki mutasyon sonraki ifade icin gorunur.

Ornek:

```basic
a = 10
DO EACH x IN a, a + 5, a + 20
    PRINT x
    a = 100
LOOP
```

Beklenen:

```text
10
105
120
```

Bu ayrim `ai_koordinasyon/SORULAR_CEVAPLAR.md` icinde 2026-09-08 kaydinda dogrulandi.

### Deger Listesi Kaldi

Su karar hala gecerlidir:

```basic
FOR EACH x IN 10, 20, 30
```

Bu acik bir skaler deger listesidir. Kaldirilmis karar bu degildir.

### Kaldirilan / Reddedilen Kisim

Reddedilen kisim:

```basic
FOR EACH x IN a, b
```

burada `a` ve `b` dizi/koleksiyon/string gibi iterable kaynak adlariysa.

Bunun reddedilme nedeni:

```text
Bu "once a sonra b" mi?
Bu iki kaynagi ZIP etmek mi?
Bu iki array handle'ini skaler deger gibi gezmek mi?
Bu gelecekteki iki kaynakli iterator mi?
```

belirsizligidir.

Eski kodda bu ifade bazi yollarda dizi/koleksiyonun kendisini bir skaler handle gibi alabiliyor, AST ve MIR farkli sessiz yanlislar uretebiliyordu. Canli koddaki yorum bunu acikca kaydeder:

```text
comma-separated EACH list holds scalar values only
```

Test:

```text
tests/iterators/neg_each_two_arrays.uxb
```

beklenen hata:

```text
FOR EACH: a is a array; a comma-separated EACH list holds scalar values only
```

### Bugunku Tek Kaynak Iteration Sirasi

Tek kaynak:

```basic
FOR EACH v IN a
```

kaynak turune gore o kaynagi gezer.

Bugunku ozel yollar:

```text
ARRAY
STRING/WSTRING code point
LIST
DICT
SET
```

S-107 ile STRING/WSTRING uzerinde:

```basic
FOR EACH c, i IN s
```

`c` Unicode kod noktasi, `i` 0 tabanli karakter sirasidir. Byte veya JS UTF-16 unit'i degildir.

### Gelecek Hedef

Cok kaynakli iterator geri gelecekse belirsiz virgullu listeyle degil, acik kutuphane iteratorleriyle gelmelidir:

```basic
FOR EACH x IN CHAIN(a, b, c)
```

ve:

```basic
FOR EACH x, y IN ZIP(a, b)
```

Genel iterator sirasi:

```text
ARRAY
STRING / WSTRING
LIST
DICT
SET
library type MAGIC ITER
CLASS / OBJECT iterator
```

Hepsi sonunda ortak MIR sozlesmesine inmelidir:

```text
ITER_CREATE
ITER_NEXT
ITER_CLOSE
```

Bu is S-135 olarak takip edilmelidir.

## 14. Mevcut Durum vs Hedef Mimari

| Alan | Bugunku durum | Hedef |
|---|---|---|
| Birinci sinif library type | RATIONAL manifest, MIR provider, LIBTYPE var | Lifecycle/ABI/provider tablosu tum hedeflerde |
| RATIONAL | MIR yorumlayici calisiyor | JS/WASM/native provider + constructor/copy/drop |
| COMPLEX/POLYNOMIAL | Yok | RATIONAL sonrasi referans paketler |
| JS/WASM library type | Acik | Manifest provider tuketimi ve real runner parity |
| Raw PTR | Byte tabanli aritmetik var | Korunacak |
| Typed pointer | Yok | `PTR TO T` ayri yuzey |
| MemoryRef | Parcalar var | VARPTR/PEEK/POKE/BYREF/FFI tek cozumleyici |
| 6502 adresleme | Dile birebir eklenmeyecek | PTR+PEEK/POKE ile genel adres zinciri |
| OOP | Temel CLASS/NEW/null/field hatalari kapandi | Virtual/interface/lifecycle/MAGIC entegrasyonu |
| FOR EACH | ARRAY/STRING/LIST/DICT/SET ozel yollar | Genel `ITER_CREATE/NEXT/CLOSE`, MAGIC ITER |
| `IN a,b` | Iterable kaynaklarda derleme hatasi | `CHAIN`, `ZIP` gibi acik iterator kutuphaneleri |
| Meta/generator | Preprocessor parcalari var | Generator registry + normal-source output |
| TASK | AST Faz 1 var | Native/JS/WASM gercek asenkron provider |

## 15. Sonraki Is Plani

### Halka A: Belge ve Takip Sabitleme

Durum: Bu belge ile baslatildi.

Yapilacaklar:

- Bu belgeyi `docs/tasarim` altinda ana 23.09 tasarim kaydi kabul et.
- Karar defteri ve takip defterlerinde bu belgeyi referans goster.
- Yeni acik halkalari S-134/S-135/S-136 olarak sorun listesine bagla.

### Halka B: Library Type Lifecycle

Izleme: S-134

23.09 08:02 uygulama: B1 (manifest sozlesmesi + canonical-MIR deger aktarimi)
tamamlandi. Yeni alanlar `storage_model/copy_model/clone_model/drop_model`;
RATIONAL VALUE/BITCOPY/NONE. Kabul paketi 14/14, lifecycle unit 41 kontrol,
dizi parametre regresyonu 63/63. Ayrinti ve sinirlar:
`UXB_S134_LIBRARY_TYPE_LIFECYCLE_20260923_TR.md`. S-134 acik kalir.
Tarihsel on kosul: S-112'de manifest tip adlari parser'a erken ulasmiyordu.
Bu baglanti 2026-09-25 taze `bin/uxb.exe` ile uygulandi; RATIONAL disindaki
`DYNAMIC_PAYLOAD` adi artik parser'dan gecip semantic lifecycle kapisinda
kontrollu reddediliyor. Siradaki halka B2/B3 genel CLONE/RETAIN/DROP lowering
ve provider kabul vektorleridir.

Yapilacaklar:

- Manifest semasina `storage_model`, `copy_model`, `drop`, `clone` kararlarini ekle.
- `RATIONAL` icin `VALUE/BITCOPY` veya `VALUE/CLONE` karari ver.
- `POLYNOMIAL/MATRIX` icin handle/refcount ihtiyacini daha kodlamadan testle.
- `b = a`, `FUNCTION F(x AS RATIONAL)`, `RETURN r`, `ARRAY OF RATIONAL` davranislarini tasarim testlerine bagla.

### Halka C: Registry Raporu ve Paket Standardi

Izleme: S-112 devam

Yapilacaklar:

- `LIBTYPE` ile yuklenen manifestleri derleme raporuna JSON olarak yaz.
- Paket manifest standardini belgeye al:

```text
manifests/library_types/<package>/<type>.library_type.json
```

- Yayinlanacak paket metadata alanlarini netlestir:

```text
package
version
type_name
providers
dependencies
target_policy
```

### Halka D: JS/WAT/WASM Provider

Izleme: S-114  
Sahip aday: Antigravity

Yapilacaklar:

- JS emitter canonical `CALL RATIONAL.<OP>` ailesini provider uzerinden calistirsin.
- WAT/WASM tarafinda `RATIONAL` icin linear-memory veya handle temsili secilsin.
- Node ve wasm runner ciktisi AST/canonical-MIR ile karsilastirilsin.
- Desteklenmeyen provider sessiz fallback yapmasin.

### Halka E: Genel Iterator

Izleme: S-135

Yapilacaklar:

- `ITER_CREATE/NEXT/CLOSE` MIR sozlesmesini resmi yap.
- ARRAY/STRING/LIST/DICT/SET ozel yollarini bu sozlesmeye yaklastir.
- `MAGIC ITER` library type girisini tasarla.
- `CHAIN(a,b,c)` ve `ZIP(a,b)` icin kutuphane iterator paketini planla.
- Virgullu iterable kaynak listesi tekrar acilmayacak; cok kaynakli davranis acik fonksiyonla gelecek.

### Halka F: Typed Pointer ve MemoryRef

Izleme: S-113, S-094/S-056/S-069

Yapilacaklar:

- `PTR TO <type>` parser/type-binding tasarimini yaz.
- Raw `PTR + n` geriye donuk byte tabanli kalacak.
- `VARPTR(x)` ve `VARPTR(a(i))` icin tipli pointer veya raw pointer politikasi netlesecek.
- `PEEK/POKE/MEMCOPY/MEMFILL` AUTO secimi `PTR -> NATIVE`, sayi -> `VIRTUAL` kuralina baglanacak.

### Halka G: Meta / Generator Registry

Izleme: S-136

Yapilacaklar:

- `GEN_BLOCK` ve `%%GENERATE` akisi icin generator registry tasarla.
- Uretilen kod normal uXBasic kaynak olarak lexer/parser'a girsin.
- Identifier sanitizasyonu, DICT erisimi, source map ve test skeleton ciktilari standardize edilsin.
- Library type manifestinden operator/magic wrapper uretimi denensin.

### Halka H: Native Provider

Izleme: S-112/S-114 devam

Yapilacaklar:

- `native_provider` alanini gercek x64/C ABI baglamaya bagla.
- RATIONAL icin once dogruluk, sonra hizlandirma.
- Native provider yoksa MIR provider'a bilincli dusme veya fail-closed kurali manifestte acik olsun.

### Halka I: Tam Parite Olcumu

Yapilacaklar:

- AST, canonical-MIR, MIR-x64, legacy x64, JS, WAT/WASM hedefleri icin tek kabul matrisi olustur.
- Emit-only kabul sayilmasin; calistirma veya net fail-closed tani gereksin.
- Her kapatma `SORUN_TAKIP.md` icinde komut/cikti/hash ile yazilsin.

## 16. Kisa Sonuc

```text
uXBasic cekirdegi kucuk kalacak.
Tipler manifest/registry/operator/MAGIC/lifecycle/ABI sozlesmesiyle gelecek.
MIR hedef bagimsiz ortak dil olacak.
JS/WASM ikinci sinif hedef olmayacak.
Raw PTR korunacak; typed pointer ayrica gelecek.
6502 adresleme ruhu korunacak, ama yeni tuhaf sozdizimi olarak eklenmeyecek.
FOR EACH deger listesi kalacak; cok iterable kaynak acik CHAIN/ZIP ile gelecek.
OOP, TASK ve generator sistemi bu ayni sozlesme mimarisine baglanacak.
```
