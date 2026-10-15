# 28. On Ayrı Proje Programı: Komutları Birleştirerek Öğrenme

Komutları tek tek öğrenmek gereklidir; fakat gerçek programcılık, komutları birleştirmeyi öğrenince başlar. Bu bölümde uXBasic için on ayrı küçük proje programı verilir. Her proje bir komut ailesini öne çıkarır, fakat yalnız o aileye kapanmaz. Değişken, operatör, koşul, döngü, fonksiyon, veri yapısı, dosya, preprocessor, backend ve dış çağrı fikirleri birbiriyle bağlanır.

Bu projeler, eski PCK belgelerinde çoğu zaman yalnız öneri olarak geçen konuları kod örneğine dönüştürür. Örnekler `docs_examples\book_projects` altında ayrı `.uxb` dosyaları olarak da verilir. Böylece okuyucu kitapta gördüğü programı dosya olarak alıp deneyebilir, değiştirebilir ve kendi örneğine çevirebilir.

## Proje 1 — Tank sıcaklık izleyici

Bu proje `DIM`, `AS`, dizi, `FOR`, `IF`, karşılaştırma operatörleri ve `PRINT` komutlarını birlikte kullanır. Amaç üç tankın sıcaklığını gezmek, güvenli aralık dışına çıkan tankları bildirmek ve ortalama sıcaklığı hesaplamaktır.

```basic id="5tfk52"
' Proje 1: Tank sicaklik izleyici
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 24
sicaklik(3) = 21

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)

    IF sicaklik(i) < 19 THEN
        PRINT "TANK_DUSUK"
    ELSEIF sicaklik(i) > 23 THEN
        PRINT "TANK_YUKSEK"
    ELSE
        PRINT "TANK_NORMAL"
    END IF
NEXT i

PRINT toplam / 3
```

Beklenen düşünce şudur: dizi ölçümleri tutar, döngü bütün tankları gezer, `IF` sıcaklığı sınıflandırır, toplam değişkeni ortalamaya hazırlanır. Aynı program daha sonra `FUNCTION SicaklikDurumu(...)` biçimine genişletilebilir.

Bu projedeki ana yapılar:

| Yapı | Görev |
|---|---|
| `DIM sicaklik(3) AS I32` | Üç elemanlı sayısal ölçüm dizisi kurar. |
| `FOR i = 1 TO 3` | Tankları sırayla gezer. |
| `IF / ELSEIF / ELSE` | Ölçümü düşük, normal veya yüksek sınıfına ayırır. |
| `toplam = toplam + sicaklik(i)` | Döngü içinde birikimli toplam alır. |

## Proje 2 — Yem stok ve maliyet hesaplayıcı

Bu proje değişken, fonksiyon, `RETURN`, çarpma, bölme ve koşullu uyarı kullanır. Amaç günlük yem tüketimini ve kaç günlük stok kaldığını hesaplamaktır.

```basic id="nw9nt3"
' Proje 2: Yem stok ve maliyet hesaplayici
FUNCTION GunlukYem(balikSayisi AS I32, gram AS I32) AS I32
    RETURN balikSayisi * gram
END FUNCTION

FUNCTION KalanGun(stokGram AS I32, gunlukGram AS I32) AS I32
    IF gunlukGram <= 0 THEN
        RETURN 0
    END IF
    RETURN stokGram / gunlukGram
END FUNCTION

DIM balik AS I32 = 250
DIM kisiBasiYem AS I32 = 12
DIM stok AS I32 = 90000

DIM gunluk AS I32
gunluk = GunlukYem(balik, kisiBasiYem)

PRINT gunluk
PRINT KalanGun(stok, gunluk)

IF KalanGun(stok, gunluk) < 10 THEN
    PRINT "STOK_AZ"
ELSE
    PRINT "STOK_YETERLI"
END IF
```

Bu programda iki fonksiyon vardır. `GunlukYem` saf hesap fonksiyonudur. `KalanGun` ise korumalı hesap yapar; günlük tüketim sıfır veya negatifse bölme yapmadan `0` döndürür. Bu, genç programcıya güvenli fonksiyon yazmayı öğretir.

## Proje 3 — Su kalite puanlayıcı

Bu proje mantıksal operatörleri kullanır. `AND`, `OR` ve `NOT` yalnız teorik sözcükler değildir; program kararını biçimlendirir.

```basic id="32pwwf"
' Proje 3: Su kalite puanlayici
DIM ph AS I32 = 7
DIM oksijen AS I32 = 8
DIM sicaklik AS I32 = 21

DIM phUygun AS I32
DIM oksijenUygun AS I32
DIM sicaklikUygun AS I32

phUygun = (ph >= 6) AND (ph <= 8)
oksijenUygun = oksijen >= 6
sicaklikUygun = (sicaklik >= 18) AND (sicaklik <= 23)

IF phUygun AND oksijenUygun AND sicaklikUygun THEN
    PRINT "SU_KALITESI_IYI"
ELSE
    PRINT "SU_KALITESI_KONTROL"
END IF

IF NOT oksijenUygun THEN
    PRINT "HAVALANDIRMA_AC"
END IF
```

Burada her ölçüm ayrı bir mantıksal değişkene bağlanır. Böyle yazmak uzun gibi görünür ama hata ayıklamayı kolaylaştırır. Tek satırda dev bir koşul yazmak yerine, koşulun parçaları adlandırılır.

## Proje 4 — Ölçüm dosyası yazma ve okuma

Bu proje `OPEN`, `PRINT #`, `INPUT #` ve `CLOSE` komutlarını gösterir. Dosya işlemlerinde `#` kanal numarasını belirtir.

```basic id="8tl1o9"
' Proje 4: Olcum dosyasi yazma ve okuma
OPEN "olcumler.txt" FOR OUTPUT AS #1
PRINT #1, "18"
PRINT #1, "21"
PRINT #1, "20"
CLOSE #1

OPEN "olcumler.txt" FOR INPUT AS #2
DIM a AS I32
DIM b AS I32
DIM c AS I32

INPUT #2, a
INPUT #2, b
INPUT #2, c
CLOSE #2

PRINT a + b + c
```

Dosya kanal mantığı önemlidir. `PRINT` ekrana yazar; `PRINT #1` ise bir numaralı dosya kanalına yazar. Bu ayrım tabloda kısa görünür ama programda gerçek fark yaratır.

## Proje 5 — TYPE ile ölçüm kaydı

Bu proje `TYPE` kullanarak birden çok değeri tek kayıt altında toplar. `TYPE`, yalnız veri saklamaz; veriye anlamlı bir biçim verir.

```basic id="k96be9"
' Proje 5: TYPE ile olcum kaydi
TYPE Olcum
    tank AS I32
    sicaklik AS I32
    oksijen AS I32
END TYPE

DIM o AS Olcum
o.tank = 1
o.sicaklik = 22
o.oksijen = 7

PRINT o.tank
PRINT o.sicaklik + o.oksijen

IF o.oksijen < 6 THEN
    PRINT "OKSIJEN_DUSUK"
ELSE
    PRINT "OKSIJEN_NORMAL"
END IF
```

`TYPE` bölümü anlatılırken bu örnek kullanılmalıdır. Çünkü `o.tank`, `o.sicaklik`, `o.oksijen` yazımı alan erişimini açıkça gösterir. Dizi ölçüm tutar; `TYPE` ise bir ölçümün iç yapısını taşır.

## Proje 6 — NAMESPACE ve ALIAS ile modüler hesap

Bu proje isim alanı kurmayı ve kısa ad vermeyi gösterir. Büyük projelerde aynı adlı fonksiyonların çakışmasını önlemek için `NAMESPACE` kullanılır. `ALIAS` ise uzun veya dışarıdan gelen adı daha okunur hâle getirir.

```basic id="0ayozw"
' Proje 6: Namespace ve alias ile moduler hesap
NAMESPACE SuHesap
    FUNCTION Ortalama(a AS I32, b AS I32, c AS I32) AS I32
        RETURN (a + b + c) / 3
    END FUNCTION

    FUNCTION Risk(sicaklik AS I32) AS I32
        IF sicaklik > 23 THEN
            RETURN 1
        END IF
        RETURN 0
    END FUNCTION
END NAMESPACE

USING SuHesap
ALIAS ORT AS Ortalama

DIM sonuc AS I32
sonuc = ORT(18, 21, 24)
PRINT sonuc
PRINT Risk(sonuc)
```

Bu örnek, `NAMESPACE`, `USING`, `ALIAS`, `FUNCTION`, `RETURN` ve `IF` komutlarını aynı bağlamda kullanır. Okuyucu modüler düşünmeyi tek başına anlatılan bir kavram olarak değil, çalışan fonksiyon düzeni olarak görür.

## Proje 7 — Preprocessor ile hedef seçen program

Bu proje preprocess komutlarının normal komutlardan farkını gösterir. `%%SET` ve `%%IF` derleme öncesi çalışır; kaynak metnin hangi parçalarının derleyiciye gideceğine karar verir.

```basic id="259q4g"
' Proje 7: Preprocessor ile hedef secimi
%%SET HEDEF = "KONSOL"

%%IF HEDEF == "KONSOL"
PRINT "KONSOL_HEDEFI"
%%ELSE
PRINT "DIGER_HEDEF"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 5
PRINT a * b
```

Bu programda `%%IF` çalışma zamanı koşulu değildir. Program çalışırken karar vermez; derleyiciye gitmeden önce kaynak metni seçer. Buna karşılık alttaki `PRINT a * b` normal çalışma zamanı ifadesidir.

Web hedefi genişletmesi:

```basic id="7ioih2"
%%TARGET WEB
%%OUTDIR "dist/preprocess_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Preprocessor Web Ciktisi</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("WEB_PREPROCESS_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## Proje 8 — Büyük sayı ve geniş duyarlık gösterimi

Bu proje `BIGINIT`, `BIGI`, `BIGINT`, `BIGD`, `BIGF` ve `BALL` ailesini gösterir. Amaç büyük sayı fikrini sözde bırakmamak, doğrudan kullanım biçimini yazmaktır.

```basic id="xwffg2"
' Proje 8: Buyuk sayi ve genis duyarlik
PRINT BIGINIT(BIGI, "12345")
PRINT BIGINIT(BIGINT, "23456")
PRINT BIGINIT(BIGD, "12.50")
PRINT BIGINIT(BIGF, "3.5")
PRINT BIGINIT(BALL, "7.1")
```

Bu örnek sayısal aileleri yüzeyden gösterir. Kitapta geniş duyarlık anlatılırken şu fark açık yazılır: `I32` gibi tipler makine sayısıdır; `BIGI`, `BIGD`, `BIGF` ve `BALL` ailesi daha geniş sayı sözleşmesi için kullanılır.

## Proje 9 — Event, Thread, Pipe ve Paralel yüzeyi

Bu proje olay, iş parçacığı, veri akışı ve paralel iş kavramlarını aynı sayfada gösterir. Bu aile, uXBasic’in klasik BASIC çizgisinden modern çalışma modeline geçtiği yerdir.

```basic id="flj1hh"
' Proje 9: Event, thread, pipe ve paralel yuzeyi
EVENT Tick
    PRINT "EVENT_TICK"
END EVENT

THREAD Worker
    DIM i AS I32 = 1
    PRINT i
END THREAD

PIPE DataPipe item AS I32
    PRINT item
END PIPE

PARALEL Grup
    PRINT "PARALEL_BODY"
END PARALEL

PRINT "ASYNC_SURFACE_OK"
```

Bu örnek özellikle doğru keyword kararlarını pekiştirir. Doğru yazım `THREAD`, `PARALEL` ve `MAGIC` biçimidir. `THREAT`, `PARALLEL` ve `SIHIRLIMETOT` kitapta yalnız yanlış kullanım notu olarak geçmelidir.

## Proje 10 — Dış kaynak, DLL/API rotası ve güvenli imza

Bu proje `IMPORT`, `DECLARE LIB ALIAS` ve `CALL(DLL)` arasındaki farkı gösterir. Aynı aileye yakın görünseler de görevleri farklıdır.

```basic id="q8r4nb"
' Proje 10: Dis kaynak ve DLL/API rotasi
IMPORT(C, "native/math.c")
IMPORT(CPP, "native/engine.cpp")
IMPORT(ASM, "native/fast.asm")

DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" _
    (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

CALL(DLL, "kernel32.dll", "Beep", 800, 200)
CALL(API, "local", "healthcheck")

PRINT "DIS_CAGRI_ROTASI_OK"
```

Bu örnek üç ayrı kapıyı birbirinden ayırır. `IMPORT(C, ...)` derleme zamanı kaynak ekleme kapısıdır. `DECLARE FUNCTION ... LIB ... ALIAS ...` dış fonksiyonun imzasını bildirir. `CALL(DLL, ...)` çalışma zamanı DLL çağrı rotasını kurar. `CALL(API, ...)` ise API/servis rotasıdır. Kitapta bu ayrım kesin korunmalıdır.

## Projelerin birlikte öğrettiği ana harita

| Proje | Öne Çıkan Konu | Birleşen Yapılar |
|---|---|---|
| 1 | Dizi ve sıcaklık kontrolü | `DIM`, dizi, `FOR`, `IF`, karşılaştırma |
| 2 | Fonksiyonla hesap | `FUNCTION`, `RETURN`, bölme koruması |
| 3 | Mantıksal koşullar | `AND`, `OR`, `NOT`, adlandırılmış koşul |
| 4 | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` |
| 5 | Kayıt tipi | `TYPE`, alan erişimi, koşul |
| 6 | Modüler yapı | `NAMESPACE`, `USING`, `ALIAS`, fonksiyon |
| 7 | Preprocessor | `%%SET`, `%%IF`, `%%TARGET`, web blokları |
| 8 | Büyük sayı | `BIGINIT`, `BIGI`, `BIGD`, `BIGF`, `BALL` |
| 9 | Modern çalışma yüzeyi | `EVENT`, `THREAD`, `PIPE`, `PARALEL` |
| 10 | Dış dünya | `IMPORT`, `DECLARE LIB ALIAS`, `CALL(DLL)`, `CALL(API)` |

Bu on proje, kitabın komut referansını canlı hâle getirir. Okuyucu önce komutu tablodan görür, sonra projede görevini izler, sonra kendi programına taşır.
