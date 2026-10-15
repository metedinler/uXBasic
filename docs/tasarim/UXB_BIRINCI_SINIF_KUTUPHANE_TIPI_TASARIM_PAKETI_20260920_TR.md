# uXBasic Birinci Sinif Kutuphane Tipi Tasarim Paketi

Tarih: 2026-09-20

Bu belge, Mete'nin 2026-09-20 tasarim yonlendirmesini ve ayni turda verilen
onceki inceleme belgelerini uXBasic calisma agacinda kalici bir mimari kayda
donusturur. Ana ilke sudur:

> uXBasic, her matematiksel veya sistem tipini cekirdege gomerek buyuyen dev
> bir BASIC olmamalidir. Cekirdek, kutuphaneden gelen tiplerin dilin dogal
> parcasiymis gibi davranmasini saglayan sozlesmeyi bilmelidir.

## Kaynak Belgeler

Bu pakete baglanan ham tasarim notlari `docs/tasarim` altinda saklandi:

| Belge | Konu |
|---|---|
| `UXB_TASARIM_F80_MEMORYREF_AUTO_KARARLARI_20260920_TR.md` | F80, VARPTR, AUTO/NATIVE/VIRTUAL, MemoryRef, BYREF, iterator, OOP ve motor esligi acik kararlari |
| `UXB_TASARIM_6502_ADRESLEME_VE_PTR_ARITMETIGI_20260920_TR.md` | 6502 adresleme dusunce deneyi ve uXBasic komutlariyla ifade edilebilen adresleme modeli |
| `UXB_TASARIM_TYPED_POINTER_VE_RAW_PTR_20260920_TR.md` | Raw `PTR` ile gelecekteki `PTR TO T` ayrimi |
| `UXB_TASARIM_PTR_BYTE_ARITMETIGI_VE_ARRAY_STRIDE_20260920_TR.md` | `PTR + n` bayt tabanli aritmetik, dizi eleman adreslemesinde `elementStride` ayrimi |
| `UXB_TASARIM_UBASIC_UXBASIC_TIP_SISTEMI_KARSILASTIRMA_20260920_TR.md` | UBASIC matematiksel tipleri ile uXBasic fiziksel/ABI tabanli tip sistemi karsilastirmasi |
| `UXB_TASARIM_KUTUPHANE_TIPI_CEKIRDEK_TIPI_AYRIMI_20260920_TR.md` | RATIONAL/COMPLEX/POLYNOMIAL gibi tiplerin cekirdek yerine kutuphane tipi olmasi |
| `UXB_TASARIM_JS_WASM_KUTUPHANE_TIPI_BACKENDLER_20260920_TR.md` | JS/WAT/WASM arka uclarinin birinci sinif kutuphane tipi sistemi icin hedef olmasi |

## Birinci Sinif Kutuphane Tipi

Birinci sinif kutuphane tipi siradan `TYPE` kaydindan daha genis bir pakettir.
Asgari sozlesme:

- Veri yerlesimi: boyut, hizalama, stride, alanlar ve gerekirse dinamik payload.
- Operatorler: `ADD`, `SUB`, `MUL`, `DIV`, `EQ`, `CMP` ve hedefe gore genisleyen diger islemler.
- MAGIC / ozel davranis: `TOSTRING`, `CLONE`, `HASH`, `ITER`, `INDEX`, `CALL` gibi dil-yuzeyi baglari.
- Donusumler: explicit/implicit cast kurallari, hata durumlari ve hedef uyumlulugu.
- Yasam dongusu: constructor, destructor, copy/move/clone, ownership ve reference modeli.
- ABI: parametre gecisi, donus degeri, BYREF, pointer/MemoryRef, JS/WASM handle veya linear-memory temsili.
- MIR davranisi: canonical MIR'e hedef bagimsiz indirgeme; native hizlandirma varsa opsiyonel alt yol.

Bu sistemin amaci su soruyu tersine cevirmektir:

Eski soru:

```text
Bu yeni tipi cekirdege nasil ekleriz?
```

Yeni soru:

```text
Birinci sinif kutuphane tipi sistemi bu tipi cekirdegi degistirmeden ifade edebiliyor mu?
```

Cevap evet ise tip kutuphaneye gider. Cevap hayir ise once o tipe ozel bir
cekirdek eklemek yerine, tip genisletme sisteminde eksik olan genel yetenek
bulunur.

## Canonical MIR Ilkesi

Kaynak:

```basic
c = a + b
```

Eger `a` ve `b` `RATIONAL` ise tip baglama katmani bunu tamsayi toplama olarak
degil, kutuphane tipi operatoru olarak cozer:

```text
RATIONAL.ADD(a, b)
```

veya ileride daha genel bicimde:

```text
TYPE_OP ADD, RATIONAL, a, b
```

Bu noktadan sonra x64, JS ve WAT/WASM ayni canonical sozlesmeyi kullanir.
Tip hedef islemciye degil MIR sozlesmesine baglanir.

## Raw PTR ve Typed Pointer Ayrimi

Mevcut uXBasic davranisi korunacak tasarim tabani:

```text
PTR + integer -> PTR
integer + PTR -> PTR
PTR - integer -> PTR
PTR - PTR     -> I64
PTR + PTR     -> hata
```

Bu aritmetik bayt tabanlidir. Yani `p + 1` bir bayt ilerler.

Gelecekteki typed pointer yuzeyi farkli bir tip ailesi olmalidir:

```basic
DIM p AS PTR TO I32
p = VARPTR(a(0))
p = p + 1     ' I32 stride kadar ilerleme aday semantigi
```

Bu, raw `PTR` davranisini bozmaz. `PTR` makine adresi / byte offset araci
olarak kalir; `PTR TO T` ise tipli eleman pointer'i olur. `VARPTR(x)` uzun
vadede tipli pointer dondurebilir, fakat raw pointer gereken yerde acik
donusum veya `CASTPTR` gerekir.

## 6502 Adresleme Modelinden Alinan Ders

6502 adresleme modlari birebir sozdizimine tasinmamalidir. uXBasic zaten
asagidaki yapilarla adresleme hesaplarini ifade edebilir:

```basic
POKEB p + offset, value
x = PEEKD(p + i * 4)
p2 = PTR(PEEKQ(table + i * 8))
```

Gerekirse ileride `ADDR(base, index, scale, disp)` benzeri hedef bagimsiz bir
MIR yardimcisi dusunulebilir. Ancak bu ilk asamada yeni sozdizimi degil,
mevcut pointer + PEEK/POKE + MemoryRef sozlesmesinin tutarliligi olarak
izlenmelidir.

## UBASIC'ten Alinacak Ders

Yuji Kida'nin UBASIC'i matematiksel tipler acisindan derindir:

- BIGINT
- RATIONAL
- COMPLEX
- POLYNOMIAL

uXBasic'in farki fiziksel temsil, ABI, sistem programlama, OOP, DLL, JS/WASM ve
native x64 hedeflerini ayni omurgada tasimasidir. Bu nedenle UBASIC kavramlari
uXBasic'e alinacaksa varsayilan yol cekirdek tipi degil, birinci sinif
kutuphane tipi olmalidir.

Ilk aday paketler:

- `RATIONAL`
- `COMPLEX`
- `POLYNOMIAL`
- `VECTOR`, `MATRIX`
- `TENSOR`, `EMBEDDING`, `MODEL`
- `VECTOR2`, `VECTOR3`, `MATRIX4`, `COLOR`, `IMAGE`
- `DISTRIBUTION`, `DATAFRAME`, `SERIES`

## JS / WAT / WASM Tasarim Kuralı

JS ve WAT/WASM arka uclari yan hedef sayilmamalidir. Birinci sinif kutuphane
tipi sozlesmesi x64 ile birlikte bu hedeflerde de anlamli olmalidir.

Bir kutuphane tipi sadece Windows DLL'e bagliysa dilin dogal parcasi olamaz.
Her tip icin hedef politikasi acik olmalidir:

- pure BASIC / canonical MIR implementasyonu,
- JS implementasyonu veya host provider baglanti sozlesmesi,
- WASM implementasyonu veya linear-memory/handle sozlesmesi,
- native x64 hizlandirma veya C ABI baglanti katmani.

## Kod Gercekligiyle Iliskili Mevcut Durum

2026-09-20 itibariyla kodda bu tasarimin parcalari vardir:

- `TYPE`, `CLASS`, `MODULE`, `NAMESPACE`, `MAGIC`, operator ve semantic/MIR
  katmanlari mevcut.
- Pointer aritmetigi raw `PTR` icin bayt tabanli olarak var.
- MemoryRef ve array rawData calismalari baslamis durumda.
- JS ve WAT/WASM arka uclari MIR tabanlidir; son turda dizi parametresi
  icin AST/canonical-MIR/JS/WAT halkasi guclendirildi.

Eksik olan sey, bunlari tek bir birinci sinif kutuphane tipi sozlesmesi altinda
resmilestiren manifest/registry, operator cozumu, yasam dongusu ve ABI
baglama katmanidir.

## Izleme Kayitlari

Bu tasarim paketiyle ilgili acik isler `ai_koordinasyon/SORUN_TAKIP.md`
icinde su basliklarla takip edilir:

- S-112: Birinci sinif kutuphane tipi sozlesmesi eksik.
- S-113: `PTR TO T` typed pointer yuzeyi yok.
- S-114: JS/WASM hedefleri icin hedef bagimsiz kutuphane tipi ABI/manifest
  sozlesmesi eksik.
- S-115: UBASIC matematiksel kavramlarinin cekirdege gomulmeden kutuphane tipi
  olarak tasinmasi icin ilk paket yok.

S-096, dizi parametresi ve WAT array op baglama isinin ilk kapatilmis halkasidir;
MIR-x64 array-view ABI'si onun acik alt maddesi olarak kalir.

## 2026-09-20 Ilk Kod Karsiligi

S-112 icin ilk kod halkasi `src/semantic/library_type_contract.fbs` ile
baslatildi. Bu dosya cekirdege yeni primitive tip eklemeden bir kutuphane tipini
manifest olarak kaydeder:

- `UXBLibraryTypeContract`: layout, operator, MAGIC, conversion, lifecycle, ABI,
  MIR, JS, WASM ve native politika alanlari.
- `UXBLibraryTypeRegistryInit/Find/Register`: manifest registry yuzeyi.
- `UXBLibraryTypeMakeRationalReference`: referans `RATIONAL` manifesti.
- Parser erken tip kapisi `RATIONAL` referans library type adini gecirir.
- Type-binding `DIM a AS RATIONAL` icin manifest layout bilgisini kullanir.
- Type inference `RATIONAL + RATIONAL` ifadesini library type operatoru olarak
  cozup sonucu `RATIONAL` olarak baglar.
- Canonical MIR lowering `a + b` ifadesini `CALL RATIONAL.ADD(a,b)` bicimine
  indirir; full JSON kanitinda `opcode:"CALL"`, `type:"RATIONAL"` ve
  `operands:["RATIONAL.ADD","a","b"]` gorunur.

Bu halka henuz gercek `RATIONAL` aritmetik provider'i degildir. Sonraki kod
halkasi, `RATIONAL.ADD` sembolunu pure MIR/uXBasic veya hedef provider paketiyle
calistirmak; JS/WAT/WASM/native hedeflerde yurutme ve dogruluk kanitini almaktir.
