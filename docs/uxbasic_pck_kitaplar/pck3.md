# uXBasic Programlayıcının Cep Kitabı — Cilt 3
## Değişkenler, Veri Yapıları, Nesne Düzeni, Dosya, Olay ve Dış Bağlantı

## Ana değişken düşüncesi

Değişken, programın kısa süreli hafızasıdır. Bir balık tartım çizelgesinde `agirlik`, `boy`, `tankNo`, `tarih` gibi adlar değişkendir. İyi değişken adı, yorum satırı okumadan anlam verir. `x` kısa deneme için olur; gerçek programda `gunlukYemMiktari` daha iyidir.

```basic
DIM tankNo AS I32
DIM balikSayisi AS I32
DIM ortalamaAgirlik AS F64
DIM notlar AS STRING
```

Değişken sınırı tipten gelir. `U8` 0..255 tutar; tank sayısı 300 olursa taşar. `I32` çoğu günlük sayı için güvenlidir. `F64` bilimsel hesaplarda iyi başlangıçtır. `BIGF`, `BIGD`, `F80`, `F128` uzun duyarlık gereken hesaplarda dış geniş sayı kütüphaneleriyle kullanılır.

## 1 boyutlu dizi

```basic
DIM sicaklik(7) AS F64
FOR i = 1 TO 7
    sicaklik(i) = 20.0 + i * 0.5
NEXT
PRINT sicaklik(3)
```

Bir boyutlu dizi defterde tek sütun gibidir. Gün gün sıcaklık, öğrenci notu, ölçüm listesi için kullanılır.

## 2 boyutlu dizi

```basic
DIM tablo(3, 4) AS F64
FOR satir = 1 TO 3
    FOR sutun = 1 TO 4
        tablo(satir, sutun) = satir * 10 + sutun
    NEXT
NEXT
PRINT tablo(2, 3)
```

İki boyut tablo gibidir: satır ve sütun. Laboratuvar denemesinde satır örnek, sütun ölçüm olabilir.

## 3 boyutlu dizi

```basic
DIM tankGunParam(4, 7, 3) AS F64
' tank, gun, parametre: 1=sicaklik 2=pH 3=oksijen
FOR tank = 1 TO 4
    FOR gun = 1 TO 7
        tankGunParam(tank, gun, 1) = 22.0
        tankGunParam(tank, gun, 2) = 7.4
        tankGunParam(tank, gun, 3) = 6.8
    NEXT
NEXT
```

Üç boyut kutu gibidir. Tank, gün, parametre gibi üç eksenli veriler için uygundur.

## 4 boyutlu dizi

```basic
DIM deney(2, 4, 7, 3) AS F64
' grup, tank, gun, parametre
FOR grup = 1 TO 2
    FOR tank = 1 TO 4
        FOR gun = 1 TO 7
            deney(grup, tank, gun, 1) = 20 + grup
        NEXT
    NEXT
NEXT
```

Dört boyutta ilk eksen deneme grubu olabilir. Böylece kontrol ve uygulama grupları ayrı tutulur.

## 5 boyutlu dizi

```basic
DIM buyukDeney(2, 3, 4, 7, 5) AS F64
' yil, lokasyon, tank, gun, parametre
buyukDeney(1, 2, 3, 4, 5) = 12.75
PRINT buyukDeney(1, 2, 3, 4, 5)
```

Beş boyut büyük bilimsel veride kullanılır. İpucu: beş boyuta çıktıysan mutlaka her eksenin anlamını yorum olarak yaz. Yoksa iki hafta sonra sen bile unutursun.

## ARRAY, LIST, DICT, SET

| Yapı | Ne zaman kullanılır | Örnek söz dizimi |
|---|---|---|
| ARRAY | Boyutu belli ve hızlı erişim gereken veri | `DIM a(100) AS F64` |
| LIST | Boyu büyüyen sıra listesi | `CALL uxcollections_list_push_f64(l, 3.14)` |
| DICT | Anahtar-değer sözlüğü | `CALL uxcollections_dict_set_f64(d, "pH", 7.2)` |
| SET | Tekrarsız değer kümesi | `CALL uxcollections_set_add(s, "tank1")` |

```basic
INCLUDE "modules/uxcollections.uxmh"
DIM liste AS PTR
liste = CALL uxcollections_list_new()
CALL uxcollections_list_push_f64(liste, 10.5)
CALL uxcollections_list_push_f64(liste, 11.0)
PRINT CALL uxcollections_list_count(liste)
CALL uxcollections_list_free(liste)
```

Liste sıra tutar, sözlük anlam tutar, küme tekrarları engeller. Derleyici yazarken `DICT` sembol tablosuna benzer: ad verirsin, karşılığında tip veya adres alırsın.

## TYPE ile kayıt

```basic
TYPE BalikOlcumu
    tank AS I32
    boy AS F64
    agirlik AS F64
END TYPE

DIM o AS BalikOlcumu
o.tank = 2
o.boy = 14.5
o.agirlik = 38.2
PRINT o.agirlik
```

`TYPE`, birden çok değeri tek ad altında toplar. CSV satırı, öğrenci, ürün, sensör kaydı için kullanılır.

## CLASS ile nesne

```basic
CLASS Tank
    DIM hacimLitre AS F64
    DIM balikSayisi AS I32

    METHOD Yogunluk() AS F64
        RETURN balikSayisi / hacimLitre
    END METHOD
END CLASS

DIM t AS Tank
t.hacimLitre = 1000
t.balikSayisi = 250
PRINT t.Yogunluk()
```

Sınıf [veri ve davranışı birleştiren yapı] (class), veriyi ve o verinin işini bir yerde tutar. `TYPE` defter satırı gibidir; `CLASS` küçük makine gibidir.

## NAMESPACE, MODULE, USING, ALIAS

```basic
NAMESPACE Bilim
    MODULE Istatistik
        FUNCTION Ortalama(a AS F64, b AS F64) AS F64
            RETURN (a + b) / 2
        END FUNCTION
    END MODULE
END NAMESPACE

USING Bilim
ALIAS ORT = Bilim.Istatistik.Ortalama
PRINT ORT(10, 20)
```

`NAMESPACE` ad çakışmasını önler. `MODULE` bir işi paketler. `USING` uzun yolu kısaltır. `ALIAS` eski adla yeni adı bağlar. Büyük projelerde bu dört komut temizlik sağlar.

## INCLUDE ve IMPORT

```basic
INCLUDE "core.uxmh"
INCLUDE "modules/uxstats.uxmh"
IMPORT(C, "src/native/hizli_toplam.c")
IMPORT(CPP, "src/native/grafik.cpp")
IMPORT(ASM, "src/native/kopyala.asm")
```

`INCLUDE` uXBasic başlık/kaynak parçası ekler. `IMPORT` derleme zamanında dış C/C++/ASM dosyasını zincire alır. DLL çağırmak için `IMPORT DLL` kullanılmaz; DLL için `DECLARE ... LIB ... ALIAS ...` veya `CALL(DLL,...)` yolu kullanılır.

## DLL ve Windows API

```basic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (freq AS I32, ms AS I32) AS I32
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32

CALL Beep(750, 300)
CALL MessageBoxA(0, "uXBasic calisiyor", "Bilgi", 0)
```

DLL çağırırken tip eşleşmesi hayatidir. Windows API yanlış parametreyle çağrılırsa program çökebilir. Önce küçük ve zararsız API ile dene. `Beep` iyi ilk örnektir.

## Dosya yazma, okuma, ekleme

```basic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Deney Raporu"
PRINT #1, "pH=7.4"
CLOSE #1

OPEN "rapor.txt" FOR APPEND AS #1
PRINT #1, "Yeni satir eklendi"
CLOSE #1

OPEN "rapor.txt" FOR INPUT AS #1
INPUT #1, satir
PRINT satir
CLOSE #1
```

Dosya açıldıysa kapat. Bu basit kuraldır. Dosyayı kapatmazsan veri tamponda kalabilir.

## Terminal ve dış programla iletişim

```basic
CALL(API, "system", "dir")
CALL(API, "system", "curl https://example.com")
```

Dış program çağırmak güçlüdür ama tehlikelidir. Kullanıcıdan aldığın metni doğrudan terminal komutuna ekleme. Önce izin verilen komut listesi yap.

## Olay, boru, iş parçacığı ve yuva

```basic
EVENT OlcumGeldi(tank AS I32, deger AS F64)

SLOT OlcumuYaz(tank AS I32, deger AS F64)
    PRINT "Tank=" + STR(tank) + " Deger=" + STR(deger)
END SLOT

ON OlcumGeldi CALL OlcumuYaz
TRIGGER OlcumGeldi(3, 7.25)
```

```basic
PIPE HamVeri TO Temizleyici
THREAD Temizleyici()
PARALEL
    CALL SensorOku()
    CALL AnalizYap()
END PARALEL
```

`EVENT` haber verir. `SLOT` haberi alır. `PIPE` veri taşır. `THREAD` aynı anda iş yapar. `PARALEL` işleri bölüştürür. İpucu: paylaşılan değişkene aynı anda yazdırma; önce her iş kendi sonucunu üretsin, sonra birleştir.
