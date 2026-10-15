# Cilt II: Veri Yapıları, Paradigmalar, OOP ve Görevler

## Kitabın amacı

Bu cilt tek deyimlerden uygulama tasarımına geçer. Dizi, yapı, koleksiyon,
namespace, modül, nesne, saf fonksiyon, özyineleme ve görev sistemi aynı dil
içinde nasıl konumlanır sorusunu yanıtlar.

Önemli ilke: uXBasic'te aynı sözcüğe benzeyen her yüzey aynı mekanizma
değildir. Çekirdek `LIST` ile `uxcollections.dll` listesi; `|>` operatörü ile
`PIPE ... END PIPE`; normal `CALL` ile `CALL(DLL,...)` ayrı sözleşmelerdir.

## 1. Veri yapısı seçim tablosu

| İhtiyaç | Yapı | Özellik |
|---|---|---|
| sabit/yeniden boyutlanabilir sayısal alan | `ARRAY` / `DIM(...)` | tipli, indeksli |
| bellekte yerleşimli kayıt | `TYPE` | alan offset'i ve ABI yerleşimi |
| davranış taşıyan nesne | `CLASS` | metot, kurucu, kalıtım |
| sıralı dinamik değerler | çekirdek `LIST` | runtime tutacağı, dinamik öğe |
| anahtar/değer | çekirdek `DICT` | string anahtar, dinamik değer |
| benzersiz anahtar | çekirdek `SET` | üyelik |
| native GLib koleksiyonu | `uxcollections` | DLL tutacağı, tipli wrapper |
| tablo/veri analizi | `uxdataframe` | DuckDB tabanlı dış runtime |

## 2. Diziler

Temel dizi:

```text
DIM sicaklik(0 TO 23) AS F64
sicaklik(0) = 18.5
```

Yeniden boyutlandırma:

```text
REDIM sicaklik(0 TO 47) AS F64
```

Kullanıcı tipi içinde dizi:

```text
TYPE GunlukOlcum
    saatlik(0 TO 23) AS F32
    istasyon AS I32
END TYPE
```

Parser dizi sınırlarını `ParseDimBound`, `ParseDimDeclarator` ve
`ParseRedimDeclarator` yollarında çözer. Semantik katman indeks tipini ve
atama uyumunu; layout katmanı alan boyutunu ve hizalamayı denetlemelidir.

## 3. TYPE ile yerleşimli veri

```text
TYPE Konum
    x AS F64
    y AS F64
END TYPE

TYPE Durak
    konum AS Konum
    kod AS I32
    aktif AS U8
END TYPE
```

Kullanım:

```text
DIM d AS Durak
d.konum.x = 32.85
d.konum.y = 39.92
d.kod = 6042
d.aktif = U8(1)
```

`TYPE` veri yerleşimidir; kalıtım veya sanal metot taşımaz. C/C++ ABI
bağlantısında `SIZEOF` ve `OFFSETOF` ile gerçek yerleşim raporu birlikte
kontrol edilir.

## 4. ENUM

```text
ENUM KargoDurumu
    Hazir = 1
    Yolda = 2
    Teslim = 3
END ENUM
```

Enum sabitleri semantik sembol tablosuna `I32` tabanlı sabit olarak girer.
Değerleri dosya veya DLL sınırından geçerken açık sayısal sözleşme kullanmak,
başka dildeki enum boyutu varsayımına güvenmekten daha güvenlidir.

## 5. Çekirdek LIST

Bildirim:

```text
DIM kuyruk AS LIST
```

Çağrılar:

| İşlev | Anlam |
|---|---|
| `LISTADD(l, deger)` | sona ekle |
| `LISTLEN(l)` | öğe sayısı |
| `LISTGET(l, indeks)` | öğeyi al |
| `LISTSET(l, indeks, deger)` | öğeyi değiştir |
| `LISTREMOVE(l, indeks)` | öğeyi kaldır |
| `LISTCLEAR(l)` | tümünü temizle |

Çekirdek listede öğe dinamik `ExecValue/MIRValue` olarak taşınır. Bu nedenle
`LISTGET` statik olarak tek bir eleman tipi vaat etmez. Derleyici tip
bağlayıcısı `LISTLEN` gibi sayısal sonuçları `I32`, `LISTGET` sonucunu
`OBJECT` olarak kaydetmelidir.

## 6. Çekirdek DICT

```text
DIM durumlar AS DICT
CALL DICTSET(durumlar, "7506", 2)
```

| İşlev | Anlam |
|---|---|
| `DICTSET(d, anahtar, deger)` | ekle veya değiştir |
| `DICTLEN(d)` | kayıt sayısı |
| `DICTHAS(d, anahtar)` | anahtar var mı |
| `DICTGET(d, anahtar)` | değer |
| `DICTCLEAR(d)` | temizle |

Olmayan anahtarı okumak sessizce `0` döndürmemelidir. Runtime ve MIR
yorumlayıcı bu durumda tanılı hata üretir.

## 7. Çekirdek SET

```text
DIM bolgeler AS SET
CALL SETADD(bolgeler, "EGE")
CALL SETADD(bolgeler, "EGE")
ASSERT SETLEN(bolgeler) = 1
```

| İşlev | Anlam |
|---|---|
| `SETADD(s, anahtar)` | üyeyi ekle |
| `SETLEN(s)` | benzersiz üye sayısı |
| `SETHAS(s, anahtar)` | üyelik |
| `SETREMOVE(s, anahtar)` | üyeyi çıkar |
| `SETCLEAR(s)` | temizle |

Tam çalışan koleksiyon örneği:
[examples/cilt2/03_cekirdek_koleksiyonlar.uxb](examples/cilt2/03_cekirdek_koleksiyonlar.uxb)

## 8. Çekirdek koleksiyon ile uxcollections farkı

Çekirdek koleksiyon:

- dil yorumlayıcısının ve MIR evaluator'ün parçasıdır;
- `DIM ... AS LIST|DICT|SET` ile oluşur;
- heterojen/dinamik değer taşıyabilir;
- x64 backend runtime çağrısı üretir.

`uxcollections`:

- `uxcollections.dll` içindeki GLib tabanlı native koleksiyonları sarar;
- `INCLUDE "include/modules/uxcollections.uxmh"` ile alınır;
- `U64/PTR` tutacak ve `F64` gibi açık wrapper tipleri kullanır;
- liste yanında stack, queue, dict, set ve tree hizmetleri sunar;
- her `New`/`Create` çağrısı uygun `Free` ile eşleşmelidir.

Bu iki sistemi aynı programda kullanmak mümkündür; tutacakları birbirinin
yerine geçirilemez.

## 9. Namespace, module, using ve alias

```text
NAMESPACE Lojistik
    MODULE Fiyat
        FUNCTION Taban() AS I32
            RETURN 30
        END FUNCTION
    END MODULE
END NAMESPACE
```

Kullanım yüzeyi:

```text
USING Lojistik
```

`ALIAS` kapsamlı isimleri veya dış sembol adlarını bağlamak için farklı parser
yollarında kullanılır. Önişlemci `%%ALIAS` metin dönüşümüdür; dil düzeyi
`ALIAS` ile aynı mekanizma değildir.

## 10. Yordam yönelimli programlama

Uygulamanın ilk sağlam ayrımı veri, saf hesap ve etki yapan yordamlar
arasındadır:

```text
FUNCTION NetTutar(BYVAL ham AS I32, BYVAL indirim AS I32) AS I32
    RETURN ham - indirim
END FUNCTION

SUB Raporla(BYVAL tutar AS I32)
    PRINT tutar
END SUB
```

`NetTutar` yalnız parametrelerinden sonuç üretir. `Raporla` konsol etkisi
oluşturur. Bu ayrım testleri küçültür ve backend eşdeğerliğini ölçmeyi
kolaylaştırır.

## 11. Fonksiyonel programlama

uXBasic çekirdeğinde kullanıcı düzeyi `LAMBDA`, `MAP`, `FILTER`, `REDUCE`,
`CURRY` veya `YIELD` anahtar sözcüğü yoktur. Bunları varmış gibi belgelemek
yanlıştır. Fonksiyonel tarz şu araçlarla kurulur:

- yan etkisiz `FUNCTION` yordamları;
- açık parametre ve dönüş tipleri;
- küçük fonksiyonların sırayla bileştirilmesi;
- `|>` pipe operatörü;
- değeri değiştirmek yerine yeni sonuç üretme disiplini;
- özyineleme.

Örnek:

```text
FUNCTION KdvEkle(BYVAL tutar AS I32) AS I32
    RETURN tutar + tutar * 20 \ 100
END FUNCTION

FUNCTION YuvarlaOnluk(BYVAL tutar AS I32) AS I32
    RETURN ((tutar + 9) \ 10) * 10
END FUNCTION

sonuc = 125 |> KdvEkle |> YuvarlaOnluk
```

Tam çalışan kaynak:
[examples/cilt2/01_saf_fonksiyon_ve_pipe.uxb](examples/cilt2/01_saf_fonksiyon_ve_pipe.uxb)

## 12. `|>` operatörü

`deger |> Islev`, soldaki değeri sağdaki tek girişli çağrıya taşır.

```text
sonuc = 21 |> IkiKat
```

Zincir:

```text
sonuc = ham |> Dogrula |> Donustur |> KaydetmeKodu
```

Sağ taraf normal fonksiyon olabileceği gibi `PIPE` görevi de olabilir. Bu
özellik, `PIPE ... END PIPE` bloğunu ifade operatörüyle aynı yapmaz; operatör
yalnız bağlama ve çağrı ifadesidir.

## 13. Özyineleme

Özyinelemeli fonksiyonun üç zorunlu niteliği vardır:

1. sonlandırma koşulu;
2. problemi küçülten çağrı;
3. dönüş tipinin tüm yollarda korunması.

Öklid EBOB algoritması:

```text
FUNCTION Ebob(BYVAL a AS I32, BYVAL b AS I32) AS I32
    IF b = 0 THEN
        RETURN a
    END IF
    RETURN Ebob(b, a MOD b)
END FUNCTION
```

Tam çalışan kaynak:
[examples/cilt2/02_oz_yinelemeli_ebob.uxb](examples/cilt2/02_oz_yinelemeli_ebob.uxb)

Derleyici geliştiricisi özyinelemeyi yalnız parser testiyle doğrulamaz. Yordam
tablosu, çağrı stack'i, MIR `CALL/RET`, x64 stack hizası ve hata durumunda
stack temizliği ayrıca sınanır.

## 14. CLASS

Temel sınıf:

```text
CLASS GonderiKurali
PUBLIC
    METHOD Hesapla(BYVAL agirlik AS I32) AS I32
        RETURN 40 + agirlik * 5
    END METHOD
END CLASS
```

Kullanım:

```text
DIM kural AS GonderiKurali
kural = NEW GonderiKurali()
PRINT kural.Hesapla(6)
DELETE kural
```

Tam çalışan kaynak:
[examples/cilt2/04_oop_gonderi_kurali.uxb](examples/cilt2/04_oop_gonderi_kurali.uxb)

## 15. Erişim ve sınıf üyeleri

Erişim bölümleri:

- `PUBLIC`
- `PRIVATE`
- `PROTECTED`
- `RESTRICTED`
- `FRIEND`

Alan nitelikleri:

- `STATIC`
- `READONLY`
- `MUTABLE`
- `IMMUTABLE`

Sınıf parser'ı alan, property, operator, mixin, decorator, constructor,
destructor ve metot bildirimlerini ayrı işlevlerle çözer. Bir sözcüğün parser
yüzeyinde bulunması, tüm hedeflerde aynı sanal dispatch desteğinin var olduğu
anlamına gelmez; hedef matrisi ayrıca doğrulanır.

## 16. Metot bildirim biçimleri

Sınıf davranışı üç normal yordam biçimiyle yazılabilir:

```text
METHOD Deger() AS I32
    RETURN 1
END METHOD
```

```text
SUB Sifirla()
    THIS.deger = 0
END SUB
```

```text
FUNCTION Oku() AS I32
    RETURN THIS.deger
END FUNCTION
```

`METHOD ... END METHOD`, `SUB ... END SUB` ve
`FUNCTION ... END FUNCTION` eşleşmeleri korunur.

## 17. Kurucu ve yıkıcı

```text
CLASS Nokta
PUBLIC
    x AS I32
    y AS I32

    CONSTRUCTOR(BYVAL x0 AS I32, BYVAL y0 AS I32)
        THIS.x = x0
        THIS.y = y0
    END CONSTRUCTOR

    DESTRUCTOR()
        THIS.x = 0
        THIS.y = 0
    END DESTRUCTOR
END CLASS
```

`NEW` bellek ayırma ile kurucu çağrısını; `DELETE` dinamik yıkıcı ve kaynak
serbest bırakmayı temsil eder. Native backend'de sınıf alanları Win64 pointer
genişliği ve layout raporuyla uyumlu olmalıdır.

## 18. MAGIC metotlar

Sihirli metot bildirimi:

```text
MAGIC HASH() AS I32
    RETURN 123
END MAGIC
```

Doğru sonlandırıcı `END MAGIC`tir. `MAGIC ... END METHOD` dil sözleşmesi
değildir.

Parser bilinen hook adları ile özel geçerli adları `MAGIC_<AD>` biçiminde
kanonikleştirir. Normal `obj.HASH()` çağrısı önce gerçek `HASH` metodunu,
yoksa `MAGIC_HASH` fallback'ini bulmalıdır. Bu doğal çağrı yönünün semantik
tip çözümü, AST runtime, MIR runtime ve x64 dispatch'te aynı olması gerekir.

Mevcut derleyici örnekleri bu alanda doğrudan çağrıda bir çözümleme kusuru
gösterebilir. Kitap sözleşmesi yukarıdaki davranıştır; III. ciltte bu yol için
pozitif ve negatif katman testi yazılır.

## 19. Kalıtım ve arayüz

```text
INTERFACE IKural
    METHOD Hesapla(BYVAL deger AS I32) AS I32
END INTERFACE

CLASS TemelKural IMPLEMENTS IKural
PUBLIC
    VIRTUAL METHOD Hesapla(BYVAL deger AS I32) AS I32
        RETURN deger
    END METHOD
END CLASS
```

Türetilmiş sınıf yüzeyi `EXTENDS`, `IMPLEMENTS`, `VIRTUAL`, `OVERRIDE`,
`ABSTRACT`, `FINAL` ve `SEALED` sözleşmelerini kullanır. Override imzası,
erişim ve temel sınıf hiyerarşisi parser/semantik tarafından denetlenmelidir.

## 20. Property ve operator

Sınıf parser'ında `PROPERTY` ve `OPERATOR` için ayrı bildirim yolları vardır.
Operator overload, normal ifade operatörünün önceliğini değiştirmez; yalnız
uygun tiplerde çağrılacak sınıf metodunu bağlar. Her overload için:

- parametre sayısı;
- dönüş tipi;
- erişim;
- normal/magic ad çakışması;
- x64 ve yorumlayıcı dispatch eşdeğerliği

test edilmelidir.

## 21. Görev sistemi: ortak model

`EVENT`, `THREAD`, `PARALEL` ve `PIPE` adlandırılmış görev bloklarıdır.
`SLOT`, bunları kimlik ve açık/kapalı durumla bağlar. `ON`, `OFF` ve
`TRIGGER` yaşam döngüsünü yönetir.

Geçerli yazımlar:

- `THREAD`; `THREAT` değil.
- `PARALEL`; `PARALLEL` otomatik eş ad değil.

Her görev, derleyicinin ayrılmaz runtime DLL/hizmet katmanına indirgenir.
Parser başarısı gerçek thread veya event yürütme kanıtı değildir.

## 22. EVENT

```text
EVENT PaketGeldi
    PRINT "PAKET"
END EVENT
```

Tek satırlı eski bildirim de parser tarafından kabul edilebilir; blok biçimi
gövde ve görev kapsamı gerektiğinde kullanılır.

## 23. THREAD

```text
THREAD ArkaPlan
    CALL KuyrukTara()
END THREAD
```

Thread runtime'ında şu davranışlar sınanır:

- başlangıç ve join/sonlanma;
- aynı slotun yeniden tetiklenmesi;
- hata aktarımı;
- paylaşılan değerlerde yarış kontrolü;
- process kapanışında kaynak temizliği.

## 24. PARALEL

```text
PARALEL HesapGrubu
    CALL ParcaBir()
    CALL ParcaIki()
END PARALEL
```

`PARALEL`, iş grubunu runtime paralellik hizmetine indirir. Sıralı
yorumlayıcının gövdeyi yalnız sırayla çalıştırması, native paralellik kanıtı
değildir.

## 25. PIPE görevi

```text
PIPE RiskSinirla puan AS I32
    IF puan > 100 THEN
        OUTPUT = 100
    ELSE
        OUTPUT = puan
    END IF
END PIPE
```

Giriş parametresi isteğe bağlı `AS` tipi taşır. Görev sonucu `OUTPUT`
üzerinden aktarılır:

```text
sonuc = 137 |> RiskSinirla
TRIGGER RiskSinirla, 64
ASSERT OUTPUT = 64
```

## 26. SLOT tablosu

Kanonik tablo:

```text
SLOT
    RiskSlot 12 ON PIPE RiskSinirla
    IsciSlot 13 OFF THREAD ArkaPlan
END SLOT
```

Kimlik aralığı runtime sözleşmesinde 0..255 olarak tutulur. Açık tür notasyonu:

```text
SLOT PIPE <U8 12>
ON THREAD ArkaPlan SLOT <U8 13>
```

Basit kontrol biçimleri:

```text
SLOT ArkaPlan ON
SLOT ArkaPlan OFF
ON THREAD ArkaPlan
OFF THREAD ArkaPlan
```

## 27. TRIGGER

Kısa biçim slot tablosundan hedefi çözer:

```text
TRIGGER RiskSinirla, 64
```

Açık biçim:

```text
TRIGGER PIPE RiskSinirla, 64
TRIGGER EVENT PaketGeldi
```

Yanlış hedef adı, kapalı slot, kimlik çakışması veya argüman uyumsuzluğu
sessizce atlanmamalıdır.

## 28. SHELL

Temel kullanım:

```text
SHELL "program.exe"
```

Parser'ın kabul ettiği seçenekler:

| Seçenek | Değer |
|---|---|
| `NOWAIT` | değer almaz |
| `TIMEOUT` | süre ifadesi |
| `RUNPATH` | çalışma dizini |
| `OUTPATH` | stdout dosyası |
| `ERRPATH` | stderr dosyası |
| `OUTVAR` | stdout değişkeni |
| `ERRVAR` | stderr değişkeni |
| `CODEVAR` | çıkış kodu değişkeni |

Örnek:

```text
DIM cikti AS STRING
DIM hata AS STRING
DIM kod AS I32
SHELL "arac.exe --surum" TIMEOUT(5000) OUTVAR cikti ERRVAR hata CODEVAR kod
ASSERT kod = 0
```

Runtime komut satırını güvenli biçimde ayırmalı, timeout'ta child process'i
sonlandırmalı ve stdout/stderr'i gerçek içerikle döndürmelidir.

## 29. Bellek ve işaretçi programlama

uXBasic düşük seviyeli gücü bilinçli olarak sınırlandırmaz:

```text
DIM adres AS PTR
adres = VARPTR(deger)
POKED adres, 42
ASSERT PEEKD(adres) = 42
```

İşlevler:

- `PEEK`, `PEEKB`, `PEEKW`, `PEEKD`
- `POKE`, `POKEB`, `POKEW`, `POKED`, `POKES`
- `MEMCOPYB/W/D`
- `MEMFILLB/W/D`
- `VARPTR`, `SADD`, `LPTR`, `CODEPTR`
- `SETNEWOFFSET`

Geçersiz gerçek adres native programı bozabilir. Yorumlayıcı sanal bellek
testi ile gerçek x64 pointer testi ayrı yürütülür.

## 30. Önişlemci B ve proje üretimi

Preprocessor B, paket ve web uygulaması meta bilgisini düzenler:

```text
%%PP B
%%BUNDLE_NAME "KargoPano"
%%BUNDLE_VERSION "1.0.0"
%%BUNDLE_ID "tr.uxbasic.kargopano"
%%AUTHOR "Takim"
%%LICENSE "Proje Lisansi"
%%BROWSER_ENTRY "index.html"
%%SCRIPT_ENTRY "app.js"
%%STYLE_ENTRY "style.css"
```

Diğer B komut grupları:

- `BUILD_ID`, `SANDBOX_ROOT`, `CSP`, `SECURITY_NOTE`;
- `CAPABILITY`, `EXPORT_BASIC`, `API_ENDPOINT`, `ROUTE`;
- `REQUIRE_ASSET`, `HOST_IMPORT`, `GEN_FILE`;
- `FEATURE`, `TEST_EXPECT`, `DOC`;
- `GEN_BLOCK`, `GEN_END`.

B hattı temel A makro/koşul sözleşmesinin yerine geçmez; seçilen
önişlemci ve izin verilen komut kombinasyonu manifestte görünmelidir.

## 31. Katmanlar arası test matrisi

| Özellik | Lexer | Parser | Semantik | AST int | MIR int | x64 | JS | WAT |
|---|---|---|---|---|---|---|---|---|
| saf sayısal fonksiyon | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu |
| `TYPE` alanı | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | hedefe göre | hedefe göre |
| CLASS metodu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | matris | matris |
| MAGIC dispatch | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | matris | matris |
| çekirdek koleksiyon | zorunlu | zorunlu | zorunlu | zorunlu | zorunlu | runtime çağrısı | matris | matris |
| THREAD/PARALEL | zorunlu | zorunlu | zorunlu | model | model | gerçek runtime | uygun tanı | uygun tanı |
| browser Canvas | zorunlu | zorunlu | zorunlu | desteklenmez tanısı | desteklenmez tanısı | hedef dışı | gerçek | hedef dışı |

“Matris” yazılan alanlarda backend gerçek destek veya açık fail-close tanısı
vermelidir.

## 32. Cilt sonu uygulaması

Aşağıdaki kaynaklar sırayla çalıştırılır:

1. [saf fonksiyon ve pipe](examples/cilt2/01_saf_fonksiyon_ve_pipe.uxb)
2. [özyinelemeli EBOB](examples/cilt2/02_oz_yinelemeli_ebob.uxb)
3. [çekirdek koleksiyonlar](examples/cilt2/03_cekirdek_koleksiyonlar.uxb)
4. [OOP gönderi kuralı](examples/cilt2/04_oop_gonderi_kurali.uxb)

Her dosya AST ve MIR yorumlayıcıyla çalıştırılır. Sonuçların yalnız aynı
çıkış kodunu değil aynı iş değerini ve aynı hata davranışını üretmesi
beklenir.

## 33. Cilt sonu kontrol listesi

- `TYPE` ile `CLASS` seçimini gerekçelendirebiliyor musunuz?
- Çekirdek koleksiyon ile DLL koleksiyon tutacağını ayırıyor musunuz?
- `LISTGET/DICTGET` dinamik dönüşünü tip sisteminde doğru ele alıyor musunuz?
- Fonksiyonel tarzı olmayan lambda sözdizimi uydurmadan kurabiliyor musunuz?
- Özyinelemede sonlandırma ve stack davranışını sınadınız mı?
- MAGIC bildirimini `END MAGIC` ile kapattınız mı?
- `|>` ile `PIPE ... END PIPE` farkını biliyor musunuz?
- `THREAD` ve `PARALEL` yazımlarını doğru kullandınız mı?
- Slot kapalıyken tetiklemenin sessiz geçmediğini doğruladınız mı?
- `SHELL` çıkış kodunu ve stderr'i denetlediniz mi?

