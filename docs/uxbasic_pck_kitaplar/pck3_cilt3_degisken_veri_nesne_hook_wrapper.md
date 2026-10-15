# uXBasic Programlayıcının Cep Kitabı — Cilt 3
## Değişkenler, Veri Yapıları, Nesne Düzeni, Kanca, Sarmalayıcı ve Eşzamanlı Tasarım

**Hazırlayan:** Zühtü Mete Dinler  
**Cilt amacı:** 2. ciltteki komut tablosunu tekrar etmek değil; o komutları gerçek program kurma düzenine çevirmek.  
**Kaynak kabulü:** `src(30.05_5)` son gerçeklik kabul edilmiştir. Bu ciltte `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, koleksiyonlar, olay sistemi, kanca [derleyici akışına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [karmaşık dış çağrıyı temiz uXBasic çağrısına çeviren katman] (wrapper), modül ve dış bağlantı düzeni çalışıyor varsayılır.

Bu cilt genç programcıya şunu öğretir: program yalnız komutlardan oluşmaz; değişkenin ömrü, tipin sınırı, verinin nerede tutulduğu, kütüphanenin nasıl çağrıldığı, dış dünyanın nasıl güvenli sarmalandığı ve aynı anda yürüyen işlerin nasıl birbirine karışmadan konuştuğu da programın parçasıdır. Bir dosyayı okumak kolaydır; zor olan okunan veriyi doğru tipe koymak, hata varsa yakalamak, sonucu dosyaya ve rapora yazmak, büyük programda aynı kodu tekrar etmeden kullanmaktır.

---

## 1. Değişken düşüncesi: ad, tip, ömür, kapsam

Değişken, programın bellekte ad verdiği kutudur. Bu kutunun içine sayı, metin, mantık değeri, nesne başvurusu, dosya tanıtıcısı, dış kütüphane işaretçisi veya büyük sayı yerleşebilir. Genç programcının ilk hatası değişkene yalnız “değer saklama yeri” gibi bakmasıdır. Aslında değişken dört şey taşır: adı, tipi, kapsamı ve ömrü. Ad, insanın okuduğu etikettir; tip, içine ne gireceğini söyler; kapsam, nereden görüleceğini belirler; ömür, ne zaman başlayıp ne zaman biteceğini anlatır.

| Kavram | uXBasic karşılığı | Ne zaman düşünülür? | Kısa örnek |
|---|---|---|---|
| Ad | `tankNo`, `phDegeri`, `toplamAgirlik` | Kod okunur olsun istendiğinde | `DIM phDegeri AS F64` |
| Tip | `I32`, `F64`, `STRING`, `BIGD`, `DICT` | Değerin sınırı ve hesap türü seçilirken | `DIM sayac AS I32` |
| Kapsam | `MAIN`, `SUB`, `FUNCTION`, `MODULE`, `CLASS` | Değişkeni kim görebilecek sorusunda | `DIM yerelToplam AS F64` |
| Ömür | blok içi, program boyu, nesne boyu | Kaynak temizliği ve hata yakalamada | `STATIC toplam AS I64` |
| Başlangıç değeri | atama satırı | Yanlış rastgele değer oluşmasın diye | `toplam = 0` |

### DIM

**Sözdizimi:** `DIM ad AS Tip` veya `DIM dizi(boyut) AS Tip`  
**Ne işe yarar:** Yeni değişken, dizi veya nesne başvurusu ayırır.  
**Nerede kullanılır:** Programda veriye ad vermek istediğin her yerde kullanılır. Bir ölçüm değeri, sayaç, dosya yolu, olay verisi veya istatistik sonucu `DIM` ile başlar.

```uxbasic
DIM tankNo AS I32
DIM phDegeri AS F64
DIM sonuc AS STRING
phDegeri = 7.35
sonuc = "normal"
PRINT "Tank="; tankNo; " pH="; phDegeri; " durum="; sonuc
```

### AS

**Sözdizimi:** `ad AS Tip`  
**Ne işe yarar:** Bir adın hangi tipte olacağını söyler.  
**Nerede kullanılır:** `DIM`, `FUNCTION`, `SUB`, `TYPE`, `CLASS`, `DECLARE` ve kütüphane çağrılarında kullanılır.

```uxbasic
FUNCTION KiloBasinaYem(yemKg AS F64, balikKg AS F64) AS F64
    IF balikKg <= 0 THEN RETURN 0
    RETURN yemKg / balikKg
END FUNCTION
```

### CONST

**Sözdizimi:** `CONST ad AS Tip = değer`  
**Ne işe yarar:** Değişmeyecek değeri adlandırır.  
**Nerede kullanılır:** Sınır değerleri, katsayılar, sabit yollar, test eşikleri için kullanılır.

```uxbasic
CONST PH_ALT AS F64 = 6.5
CONST PH_UST AS F64 = 8.5
IF phDegeri < PH_ALT OR phDegeri > PH_UST THEN PRINT "pH sinir disi"
```

### REDIM

**Sözdizimi:** `REDIM dizi(yeniBoyut)`  
**Ne işe yarar:** Diziyi yeni boyuta taşır.  
**Nerede kullanılır:** Kaç ölçüm geleceği başta bilinmiyorsa, okudukça büyüyen dizi kurarken kullanılır.

```uxbasic
DIM olcumler(10) AS F64
DIM kapasite AS I32
kapasite = 10
IF yeniAdet > kapasite THEN
    kapasite = kapasite * 2
    REDIM olcumler(kapasite)
END IF
```

### DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFSTR, DEFBYT, DEFEXT

Bu komutlar eski BASIC alışkanlığını taşır: belirli harfle başlayan değişkenlerin varsayılan tipini seçer. Yeni uXBasic kodunda açık `DIM ... AS ...` kullanmak daha öğreticidir; ama eski kodu taşırken veya hızlı prototipte işe yarar.

| Komut | Sözdizimi | Kısa görev | Uyarı |
|---|---|---|---|
| `DEFINT` | `DEFINT A-Z` | Adsız tipleri tam sayı yapar. | Yeni kodda açık `I32` daha temizdir. |
| `DEFLNG` | `DEFLNG A-Z` | Uzun tam sayı varsayar. | Dosya boyu ve sayaçta işe yarar. |
| `DEFSNG` | `DEFSNG A-Z` | Tek duyarlıklı sayı varsayar. | Bilimsel hesapta `F64` çoğu zaman daha güvenlidir. |
| `DEFDBL` | `DEFDBL A-Z` | Çift duyarlıklı sayı varsayar. | Ölçüm hesaplarında iyi başlangıçtır. |
| `DEFSTR` | `DEFSTR A-Z` | Metin varsayar. | Eski BASIC kodlarını taşırken görülür. |
| `DEFBYT` | `DEFBYT A-Z` | Bayt varsayar. | Ham veri, renk, küçük kod için uygundur. |
| `DEFEXT` | `DEFEXT A-Z` | Geniş sayı ailesine yönelir. | Yüksek duyarlık istediğinde kullanılır. |

```uxbasic
DEFDBL A-Z
DIM acikAd AS STRING
acikAd = "Yeni kodda yine de AS Tip yazmak daha okunur"
PRINT acikAd
```

### Kallavi örnek 1 — değişken, sabit, dizi, hata ve rapor disiplini

Aşağıdaki program 30 üretim ölçüsünü değerlendirir. pH, sıcaklık ve çözünmüş oksijen gibi üç değeri aynı mantıkla düşünebilirsin; örnek yalnız bir üretim kalite puanı kullanır. Program `DIM`, `CONST`, `FOR`, `IF`, `ELSEIF`, `SELECT CASE`, `OPEN`, `PRINT #`, `CLOSE`, `FUNCTION`, `RETURN`, `ABS`, `STR` ve `ASSERT` kullanır. Asıl ders şudur: iyi program yalnız ortalama yazmaz; sınır dışı değeri, sapmayı ve sonucu da raporlar.

```uxbasic
CONST HEDEF AS F64 = 100.0
CONST UYARI_YUZDE AS F64 = 3.0
CONST RED_YUZDE AS F64 = 7.0

FUNCTION SapmaYuzde(deger AS F64, hedef AS F64) AS F64
    IF hedef = 0 THEN RETURN 0
    RETURN ABS(deger - hedef) * 100.0 / hedef
END FUNCTION

MAIN
    DIM kalite(30) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ortalama AS F64
    DIM uyari AS I32
    DIM red AS I32
    DIM durum AS STRING

    FOR i = 1 TO 30
        kalite(i) = 98.0 + RND() * 6.0
        IF i = 7 THEN kalite(i) = 90.0
        IF i = 23 THEN kalite(i) = 109.5
    NEXT i

    OPEN "kalite_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "no;deger;sapma%;durum"

    FOR i = 1 TO 30
        DIM sapma AS F64
        sapma = SapmaYuzde(kalite(i), HEDEF)
        SELECT CASE sapma
        CASE IS > RED_YUZDE
            durum = "RED"
            red = red + 1
        CASE IS > UYARI_YUZDE
            durum = "UYARI"
            uyari = uyari + 1
        CASE ELSE
            durum = "OK"
        END SELECT
        toplam = toplam + kalite(i)
        PRINT #1, STR(i) + ";" + STR(kalite(i)) + ";" + STR(sapma) + ";" + durum
    NEXT i

    ortalama = toplam / 30.0
    PRINT #1, "ortalama;" + STR(ortalama)
    PRINT #1, "uyari;" + STR(uyari)
    PRINT #1, "red;" + STR(red)
    CLOSE #1

    ASSERT ortalama > 0
    IF red > 0 THEN PRINT "Uretimde kritik hata var" ELSE PRINT "Uretim kabul edilebilir"
END MAIN
```

Bu örneğin zekâ dolu tarafı şudur: sınır değerleri kodun içine saklanmamış, `CONST` ile adlandırılmıştır. Böylece yarın kalite sınırı değişirse bütün programı aramazsın. `SapmaYuzde` fonksiyonu tek işi yapar; hem raporda hem ekranda kullanılabilir. Rapor satırları noktalı virgül ile ayrıldığı için daha sonra tablo programında açılabilir.

---

## 2. Tip ailesi ve sayı seçimi

Tip seçimi, programın sessiz kaderidir. Küçük sayı için büyük tip seçersen bellek harcarsın; büyük sayı için küçük tip seçersen taşma yaşarsın. Bilimsel hesapta `F64` çoğu zaman yeterlidir; para, hassas ondalık ve çok basamaklı hesapta `BIGD`; geniş ikili hassasiyet ve matematiksel işlemde `BIGF`; dev tam sayıda `BIGI`/`BIGINT`; aralık veya belirsizlik mantığında `BALL` kullanılır.

| Tip | Anlamı | Tipik kullanım | Püf noktası |
|---|---|---|---|
| `I8` | işaretli 8 bit tam sayı | küçük durum kodu | -128..127 sınırını unutma |
| `U8` | işaretsiz 8 bit sayı | renk, bayt, küçük sayaç | 0..255 dışına taşma olur |
| `I16`, `U16` | 16 bit tam sayılar | sensör ham değeri, küçük indeks | cihaz verisinde kullanışlıdır |
| `I32`, `U32` | 32 bit tam sayılar | günlük sayaç, döngü, adet | en güvenli genel sayaç ailesidir |
| `I64`, `U64` | 64 bit tam sayılar | dosya boyu, büyük sayaç | uzun süreç ve büyük veri için seçilir |
| `F32` | tek duyarlıklı ondalık | grafik ve hızlı yaklaşık hesap | bilimsel sonuçta dikkatli kullan |
| `F64` | çift duyarlıklı ondalık | genel bilimsel hesap | ilk tercih çoğunlukla budur |
| `F80`, `F128` | geniş kayan sayı | hassas nümerik hesap | dış çalışma zamanı gerekir |
| `BIGI`, `BIGINT` | çok büyük tam sayı | kripto, kombinasyon, faktöriyel | sınırsız büyüklük mantığı sağlar |
| `BIGD` | çok basamaklı ondalık | para, tartım, hassas rapor | ondalık basamak korunur |
| `BIGF` | büyük/yüksek duyarlıklı kayan sayı | bilimsel model, matris | hassas ama maliyetlidir |
| `BALL` | aralık/güvenli yaklaşık sayı | hata payı, ölçüm belirsizliği | tek değer yerine aralık düşünür |
| `BOOLEAN` | doğru/yanlış | bayrak ve koşul | `TRUE/FALSE` mantığıdır |
| `STRING` | metin | ad, yol, JSON, rapor satırı | uzun metinde tampon düşün |
| `PTR`, `STRPTR`, `OBJECT` | adres ve nesne başvurusu | dış çağrı, DLL, runtime handle | yanlış kullanılırsa program çöker |

### Büyük sayı ailesi için düşünme şekli

`BIGI` ve `BIGINT` tam sayı ailesidir; küsurat taşımaz. `BIGD` insanın yazdığı ondalık basamağı korumaya yakındır; para ve hassas tartım için uygundur. `BIGF` bilimsel hesaplarda çok geniş duyarlık verir; matris, türev, model, simülasyon gibi işlerde kullanılır. `BALL`, tek sonuç yerine “sonuç bu aralıkta” demeyi sağlar; laboratuvar ölçümünde hata payını saklamak için çok değerlidir.

```uxbasic
DIM n AS BIGINT
DIM tartim AS BIGD
DIM modelSonucu AS BIGF
DIM phAraligi AS BALL

n = BIGINT("1000000000000000000000000000001")
tartim = BIGD("12.345678901234")
modelSonucu = BIGF("3.141592653589793238462643383279")
phAraligi = BALL("7.30", "7.38")
PRINT "Buyuk sayilar hazir"
```

### Kallavi örnek 2 — para, laboratuvar ve belirsizlik aynı programda

Bu örnek hem `F64`, hem `BIGD`, hem `BALL` kullanır. Genç programcı burada bir gerçeği öğrenir: her sayı aynı değildir. Para hesabında ikili kayan nokta küçük küsurat hataları üretebilir; pH ölçümünde cihazın hata payı vardır; üretim toplamında hızlı `F64` yeterli olabilir.

```uxbasic
INCLUDE "modules/uxmath.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM yemKg AS F64
    DIM balikKg AS F64
    DIM fcr AS F64
    DIM birimFiyat AS BIGD
    DIM toplamTutar AS BIGD
    DIM ph AS BALL
    DIM karar AS STRING

    yemKg = 125.5
    balikKg = 82.3
    fcr = yemKg / balikKg

    birimFiyat = BIGD("38.75")
    toplamTutar = BIGD_MUL(birimFiyat, BIGD_FROM_F64(yemKg))
    ph = BALL("7.25", "7.45")

    IF fcr < 1.4 THEN
        karar = "yem verimi iyi"
    ELSEIF fcr < 1.8 THEN
        karar = "yem verimi orta"
    ELSE
        karar = "yem verimi zayif"
    END IF

    PRINT "FCR="; fcr
    PRINT "Yem tutari="; BIGD_TO_STRING(toplamTutar)
    PRINT "pH araligi="; BALL_TO_STRING(ph)
    PRINT karar
END MAIN
```

Bu programdaki incelik, aynı sayısal kavramı tek tipe zorlamamaktır. FCR hızlı oran hesabıdır; `F64` yeterlidir. Para tutarı ondalık basamak ister; `BIGD` daha uygundur. pH cihaz hatasıyla gelir; `BALL` ölçümü aralık olarak taşır. Programlama zekâsı bazen daha karmaşık kod yazmak değil, doğru veriye doğru kabı seçmektir.

---

## 3. Diziler: 1, 2, 3, 4 ve 5 boyutlu düşünme

Dizi, aynı türden birçok değeri düzenli adresle saklar. Bir boyut liste gibidir; iki boyut tablo; üç boyut küp; dört boyut deney planı; beş boyut büyük araştırma defteridir. Çok boyutlu dizi kullanırken her eksenin anlamını yazmak zorunlu alışkanlık olmalıdır.

| Boyut | Benzetme | Örnek eksenler | Ne zaman kullanılır? |
|---|---|---|---|
| 1D | tek sütun | gün | sıcaklık listesi, not listesi |
| 2D | tablo | satır, sütun | numune x parametre |
| 3D | küp | tank, gün, parametre | saha izleme |
| 4D | deney defteri | grup, tank, gün, parametre | kontrol/uygulama deneyi |
| 5D | araştırma ambarı | yıl, bölge, tank, gün, parametre | uzun dönem veri |

### 1 boyut: tek ölçüm listesi

```uxbasic
DIM sicaklik(7) AS F64
FOR gun = 1 TO 7
    sicaklik(gun) = 21.0 + gun * 0.25
NEXT gun
PRINT "3. gun sicaklik="; sicaklik(3)
```

### 2 boyut: numune x parametre tablosu

```uxbasic
DIM tablo(10, 3) AS F64
' sutun 1=pH, 2=oksijen, 3=sicaklik
FOR numune = 1 TO 10
    tablo(numune, 1) = 7.2 + RND() * 0.4
    tablo(numune, 2) = 6.0 + RND() * 1.5
    tablo(numune, 3) = 22.0 + RND() * 2.0
NEXT numune
```

### 3 boyut: tank x gün x parametre

```uxbasic
DIM saha(4, 7, 3) AS F64
FOR tank = 1 TO 4
    FOR gun = 1 TO 7
        saha(tank, gun, 1) = 7.3
        saha(tank, gun, 2) = 6.8
        saha(tank, gun, 3) = 22.5
    NEXT gun
NEXT tank
```

### 4 boyut: grup x tank x gün x parametre

```uxbasic
DIM deney(2, 4, 14, 3) AS F64
FOR grup = 1 TO 2
    FOR tank = 1 TO 4
        FOR gun = 1 TO 14
            deney(grup, tank, gun, 1) = 7.2 + grup * 0.05
            deney(grup, tank, gun, 2) = 6.5 + RND()
            deney(grup, tank, gun, 3) = 22.0 + RND()
        NEXT gun
    NEXT tank
NEXT grup
```

### 5 boyut: yıl x lokasyon x tank x gün x parametre

```uxbasic
DIM izleme(3, 5, 8, 30, 4) AS F64
' yil, lokasyon, tank, gun, parametre
izleme(1, 2, 4, 15, 3) = 23.7
PRINT "secili sicaklik="; izleme(1, 2, 4, 15, 3)
```

### Kallavi örnek 3 — çok boyutlu diziden rapor üretme

Bu program 2 grup, 4 tank, 7 gün, 3 parametre üzerinden veri üretir. Parametre 1 pH, 2 oksijen, 3 sıcaklıktır. Program hem dizi kurar, hem ortalama hesaplar, hem riskli tankları raporlar. En önemli ders: çok boyutlu veride döngü sırası, eksen adları ve rapor satırı birlikte düşünülmelidir.

```uxbasic
CONST GRUP_ADET AS I32 = 2
CONST TANK_ADET AS I32 = 4
CONST GUN_ADET AS I32 = 7
CONST PARAM_ADET AS I32 = 3

FUNCTION ParamAd(p AS I32) AS STRING
    SELECT CASE p
    CASE 1: RETURN "pH"
    CASE 2: RETURN "oksijen"
    CASE 3: RETURN "sicaklik"
    CASE ELSE: RETURN "bilinmeyen"
    END SELECT
END FUNCTION

MAIN
    DIM veri(GRUP_ADET, TANK_ADET, GUN_ADET, PARAM_ADET) AS F64
    DIM grup AS I32, tank AS I32, gun AS I32, p AS I32

    FOR grup = 1 TO GRUP_ADET
        FOR tank = 1 TO TANK_ADET
            FOR gun = 1 TO GUN_ADET
                veri(grup,tank,gun,1) = 7.1 + RND() * 0.6
                veri(grup,tank,gun,2) = 5.8 + RND() * 1.8
                veri(grup,tank,gun,3) = 21.0 + RND() * 3.0
            NEXT gun
        NEXT tank
    NEXT grup

    OPEN "cok_boyutlu_rapor.csv" FOR OUTPUT AS #1
    PRINT #1, "grup;tank;param;ortalama;durum"

    FOR grup = 1 TO GRUP_ADET
        FOR tank = 1 TO TANK_ADET
            FOR p = 1 TO PARAM_ADET
                DIM toplam AS F64
                toplam = 0
                FOR gun = 1 TO GUN_ADET
                    toplam = toplam + veri(grup,tank,gun,p)
                NEXT gun
                DIM ort AS F64
                ort = toplam / GUN_ADET
                DIM durum AS STRING
                durum = "OK"
                IF p = 1 AND (ort < 6.8 OR ort > 8.2) THEN durum = "pH risk"
                IF p = 2 AND ort < 6.0 THEN durum = "oksijen risk"
                IF p = 3 AND ort > 24.0 THEN durum = "sicaklik risk"
                PRINT #1, STR(grup)+";"+STR(tank)+";"+ParamAd(p)+";"+STR(ort)+";"+durum
            NEXT p
        NEXT tank
    NEXT grup
    CLOSE #1
    PRINT "Rapor hazir: cok_boyutlu_rapor.csv"
END MAIN
```

Bu örnekte zekâ, dizinin kendisinde değil dizinin adlandırılmasındadır. `veri(1,2,3,1)` çıplak bakınca anlamsızdır; ama yorum satırı ve `ParamAd` fonksiyonu ile okunur hâle gelir. Büyük veri yapısında isimlendirme, hız kadar önemlidir.

---

## 4. LIST, DICT, SET ve ARRAY ile tablo kurma

`ARRAY` hızlı ve düzenlidir; indeksle erişirsin. `LIST` büyüyebilir sıra tutar; ne kadar veri geleceği başta belli değilse güzeldir. `DICT` anahtar/değer tablosudur; yüz satırlık `IF kelime = ...` zincirini temizler. `SET` tekrarsız kümedir; daha önce gördün mü sorusuna hızlı cevap verir.

| Yapı | Soru | Cevap verdiği problem | Kısa kullanım |
|---|---|---|---|
| `ARRAY` | Kaç hücre var? | sabit boyutlu hızlı veri | `DIM a(100) AS F64` |
| `LIST` | Sıra önemli mi? | büyüyen ölçüm listesi | `CALL ListPush(liste, deger)` |
| `DICT` | Anahtardan değere gitmek mi istiyorsun? | kod->açıklama, ad->tip | `CALL DictSet(sozluk,"pH",7.2)` |
| `SET` | Tekrarı engellemek mi istiyorsun? | benzersiz tank, benzersiz hata | `CALL SetAdd(kume,"TANK-1")` |

### ARRAY ile küçük tablo

```uxbasic
DIM ayToplam(12) AS F64
FOR ay = 1 TO 12
    ayToplam(ay) = 1000 + ay * 25
NEXT ay
PRINT ayToplam(6)
```

### LIST ile büyüyen ölçüm listesi

```uxbasic
INCLUDE "modules/uxcollections.uxmh"
DIM phListe AS PTR
phListe = ux_list_new()
CALL ux_list_push_f64(phListe, 7.2)
CALL ux_list_push_f64(phListe, 7.4)
CALL ux_list_push_f64(phListe, 7.1)
PRINT ux_list_count(phListe)
CALL ux_list_free(phListe)
```

### DICT ile karar tablosu

```uxbasic
INCLUDE "modules/uxcollections.uxmh"
DIM mesaj AS PTR
mesaj = ux_dict_new()
CALL ux_dict_set_string(mesaj, "OK", "Sorun yok")
CALL ux_dict_set_string(mesaj, "WARN", "Dikkat")
CALL ux_dict_set_string(mesaj, "FAIL", "Mudahale gerekli")
PRINT ux_dict_get_string(mesaj, "WARN")
CALL ux_dict_free(mesaj)
```

### SET ile tekrar kontrolü

```uxbasic
DIM gorulen AS PTR
gorulen = ux_set_new()
CALL ux_set_add(gorulen, "Tank-1")
CALL ux_set_add(gorulen, "Tank-1")
CALL ux_set_add(gorulen, "Tank-2")
PRINT ux_set_count(gorulen)
CALL ux_set_free(gorulen)
```

### Kallavi örnek 4 — IF zincirini DICT tablosuna dönüştürme

Genç programcı çoğu zaman şöyle yazar: `IF kod="A" THEN ... ELSEIF kod="B" THEN ...`. Üç kodda sorun yoktur; yüz kodda felaket olur. Çözüm `DICT` tablosudur. Aşağıda üretim hata kodları sözlükte tutulur, görülen tanklar `SET` ile tekrarsız sayılır, ham ölçümler `LIST` içinde akar.

```uxbasic
INCLUDE "modules/uxcollections.uxmh"

MAIN
    DIM hataMesaj AS PTR
    DIM gorulenTank AS PTR
    DIM agirlikler AS PTR
    hataMesaj = ux_dict_new()
    gorulenTank = ux_set_new()
    agirlikler = ux_list_new()

    CALL ux_dict_set_string(hataMesaj, "E01", "dusuk oksijen")
    CALL ux_dict_set_string(hataMesaj, "E02", "yuksek sicaklik")
    CALL ux_dict_set_string(hataMesaj, "E03", "pH sinir disi")

    FOR i = 1 TO 20
        DIM tank AS STRING
        DIM kod AS STRING
        DIM agirlik AS F64
        tank = "T" + STR(1 + (i MOD 4))
        agirlik = 35.0 + RND() * 8.0
        IF i = 6 THEN kod = "E01" ELSEIF i = 13 THEN kod = "E03" ELSE kod = "OK" END IF

        CALL ux_set_add(gorulenTank, tank)
        CALL ux_list_push_f64(agirlikler, agirlik)

        IF kod <> "OK" THEN
            PRINT tank + " hata=" + ux_dict_get_string(hataMesaj, kod)
        END IF
    NEXT i

    PRINT "Benzersiz tank="; ux_set_count(gorulenTank)
    PRINT "Olcum adedi="; ux_list_count(agirlikler)

    CALL ux_list_free(agirlikler)
    CALL ux_set_free(gorulenTank)
    CALL ux_dict_free(hataMesaj)
END MAIN
```

Bu örnek, “tablo kurmak” sözünün gerçek anlamıdır. Tablo yalnız ekranda çizilen satır değildir; kararları veriye çevirmektir. Karar veriye çevrilirse program büyürken bozulmaz. Yeni hata kodu eklemek için IF zincirini kurcalamazsın; sözlüğe yeni satır eklersin.

---

## 5. Tampon, işaretçi, ham bellek ve güvenli handle düzeni

Tampon [geçici veri alanı] (buffer), veriyi kısa süreli taşımak için ayrılan alandır. Dosyadan parça okumak, DLL’e metin vermek, ağ cevabını toplamak, WAT/JS üretirken satırları biriktirmek veya büyük diziyi kopyalamak için kullanılır. Handle [kaynağı temsil eden sayı/adres] ise dosya, liste, sözlük, dış kütüphane nesnesi veya çalışma zamanı kaynağına verilen tutamaktır. İyi kural: handle açıldıysa kapatılır; tampon ayrıldıysa sınırı bilinir.

| Araç | Sözdizimi | Ne işe yarar? | Dikkat |
|---|---|---|---|
| `SETSTRINGSIZE` | `SETSTRINGSIZE metin, uzunluk` | metin tamponu hazırlar | uzunluk sınırını yaz |
| `VARPTR` | `VARPTR(değişken)` | değişken adresini verir | dış çağrıda dikkatli kullan |
| `SADD` | `SADD(metin)` | metin içeriği adresini verir | metin ömrü bitmemeli |
| `PEEKB/W/D` | `PEEKB(adres)` | adresten okur | yanlış adres tehlikelidir |
| `POKEB/W/D` | `POKEB adres, değer` | adrese yazar | sınır kontrolü şarttır |
| `MEMFILLB/W/D` | `MEMFILLB hedef, değer, adet` | belleği doldurur | tampon boyunu aşma |
| `MEMCOPYB/W/D` | `MEMCOPYB hedef, kaynak, adet` | bellek kopyalar | çakışan alanı bil |
| `INC/DEC` | `INC x`, `DEC x` | sayaç veya değeri değiştirir | döngü sınırıyla kullan |

### Tampon oluşturma ve doldurma

```uxbasic
DIM tampon AS STRING
SETSTRINGSIZE tampon, 256
DIM adres AS PTR
adres = SADD(tampon)
MEMFILLB adres, 0, 256
POKES adres, "uXBasic tampon denemesi"
PRINT tampon
```

### Bellek kopyalama

```uxbasic
DIM kaynak AS STRING
DIM hedef AS STRING
SETSTRINGSIZE kaynak, 64
SETSTRINGSIZE hedef, 64
POKES SADD(kaynak), "deney satiri"
MEMCOPYB SADD(hedef), SADD(kaynak), LEN(kaynak)
PRINT hedef
```

### Kallavi örnek 5 — dosya satırlarını tamponla işleyip güvenli rapora çevirmek

Bu örnek, büyük dosyayı her seferinde dev metne çevirmek yerine satır satır işler. Tampon mantığı gösterilir, satır temizlenir, sayısal değer ayrılır, hatalı değer rapora yazılır. Burada amaç “dosya okudum” değil, “veriyi denetimli aktardım” düşüncesidir.

```uxbasic
FUNCTION Temizle(s AS STRING) AS STRING
    RETURN RTRIM(LTRIM(s))
END FUNCTION

FUNCTION SayiyaCevir(s AS STRING) AS F64
    IF LEN(Temizle(s)) = 0 THEN THROW "bos sayi"
    RETURN VAL(s)
END FUNCTION

MAIN
    DIM satir AS STRING
    DIM tampon AS STRING
    DIM deger AS F64
    DIM adet AS I32
    DIM toplam AS F64
    SETSTRINGSIZE tampon, 512

    TRY
        OPEN "olcumler.txt" FOR INPUT AS #1
        OPEN "temiz_rapor.csv" FOR OUTPUT AS #2
        PRINT #2, "no;ham;deger;durum"

        DO WHILE EOF(#1) = 0
            INPUT #1, satir
            MEMFILLB SADD(tampon), 0, 512
            POKES SADD(tampon), Temizle(satir)
            TRY
                deger = SayiyaCevir(tampon)
                adet = adet + 1
                toplam = toplam + deger
                PRINT #2, STR(adet)+";"+satir+";"+STR(deger)+";OK"
            CATCH e2
                PRINT #2, STR(adet+1)+";"+satir+";0;HATA"
            END TRY
        LOOP

        IF adet > 0 THEN PRINT #2, "ortalama;;;" + STR(toplam/adet)
    CATCH e
        PRINT "Dosya isleme hatasi: "; e
    FINALLY
        CLOSE #1
        CLOSE #2
    END TRY
END MAIN
```

Bu programdaki önemli ders, temizleme ve sayıya çevirmenin ayrı fonksiyon yapılmasıdır. Her satırda aynı kodu yazmazsın. Hatalı satır geldiğinde bütün program çökmez; yalnız o satır raporda işaretlenir. Tampon sınırı bellidir; bu da dış çağrı ve büyük veri için güvenli alışkanlık kazandırır.

---

## 6. TYPE, CLASS ve nesne düzeni

`TYPE`, veri alanlarını bir kayıt gibi toplar. `CLASS`, veriyle birlikte davranışı da taşır. `TYPE` bir form satırıdır; `CLASS` kendi işini yapabilen küçük makinedir. Büyük projede her şeyi çıplak değişkenlerle taşımak kodu dağıtır. Numune, tank, pencere, AST düğümü, hata raporu, derleyici seçeneği, dış kütüphane tanımı gibi kavramlar nesne veya kayıt olarak düşünülmelidir.

| Yapı | Sözdizimi | Ne zaman kullanılır? |
|---|---|---|
| `TYPE` | `TYPE Ad ... END TYPE` | yalnız veri alanı toplanacaksa |
| `CLASS` | `CLASS Ad ... END CLASS` | veri + davranış birlikteyse |
| `PROPERTY` | `PROPERTY Ad AS Tip` | alan kontrollü okunacak/yazılacaksa |
| `METHOD` | `METHOD Ad(...) AS Tip` | sınıf davranışı yazılacaksa |
| `CONSTRUCTOR` | `CONSTRUCTOR(...)` | nesne oluşurken başlangıç ayarı gerekiyorsa |
| `DESTRUCTOR` | `DESTRUCTOR()` | dosya/handle/bellek temizliği gerekiyorsa |
| `NEW` | `nesne = NEW Sınıf(...)` | nesne üretilecekse |
| `DELETE` | `DELETE nesne` | nesne veya kaynak bırakılacaksa |
| `INTERFACE` | `INTERFACE Ad ... END INTERFACE` | sınıflar için sözleşme kurulacaksa |
| `IMPLEMENTS` | `CLASS A IMPLEMENTS B` | sözleşme uygulanacaksa |
| `VIRTUAL/OVERRIDE` | `VIRTUAL METHOD`, `OVERRIDE METHOD` | alt sınıf davranışı değiştirecekse |
| `PUBLIC/PRIVATE/PROTECTED` | erişim bölümleri | neyin dışarı açılacağı seçilecekse |
| `READONLY/MUTABLE/IMMUTABLE` | alan niyeti | değişebilirlik açık yazılacaksa |
| `STATIC` | ortak alan/yöntem | sınıfa ait tek değer gerekiyorsa |
| `MAGIC` | `MAGIC <.ad.>(...)` | özel davranış tanımlanacaksa |

### TYPE ile numune kaydı

```uxbasic
TYPE Numune
    id AS STRING
    ph AS F64
    oksijen AS F64
    sicaklik AS F64
END TYPE

DIM n AS Numune
n.id = "N-001"
n.ph = 7.4
n.oksijen = 6.8
n.sicaklik = 22.5
PRINT n.id; " "; n.ph
```

### CLASS ile tank modeli

```uxbasic
CLASS Tank
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY hacimLitre AS F64
    PROPERTY balikKg AS F64

    METHOD Yogunluk() AS F64
        IF hacimLitre <= 0 THEN RETURN 0
        RETURN balikKg / hacimLitre
    END METHOD

    METHOD Durum() AS STRING
        IF Yogunluk() > 0.08 THEN RETURN "yogun"
        RETURN "normal"
    END METHOD
END CLASS

DIM t AS Tank
t = NEW Tank()
t.ad = "T1"
t.hacimLitre = 1000
t.balikKg = 72
PRINT t.ad; " "; t.Durum()
DELETE t
```

### INTERFACE ve IMPLEMENTS ile sözleşme

```uxbasic
INTERFACE IRaporlayici
    METHOD RaporSatiri() AS STRING
END INTERFACE

CLASS TankRapor IMPLEMENTS IRaporlayici
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY ph AS F64
    METHOD RaporSatiri() AS STRING
        RETURN ad + ";" + STR(ph)
    END METHOD
END CLASS
```

### Kallavi örnek 6 — TYPE, CLASS, DICT ve dosya raporu birlikte

Bu örnek, nesne düşüncesinin neden gerekli olduğunu gösterir. Tank yalnız üç değişken değildir; kendi yoğunluğunu hesaplar, kendi durumunu verir, rapor satırı üretir. Böylece ana program karar tablosu gibi sade kalır.

```uxbasic
INCLUDE "modules/uxcollections.uxmh"

TYPE GunlukOlcum
    gun AS I32
    ph AS F64
    oksijen AS F64
    yemKg AS F64
END TYPE

CLASS Tank
PUBLIC
    PROPERTY ad AS STRING
    PROPERTY hacim AS F64
    PROPERTY balikKg AS F64
    PROPERTY son AS GunlukOlcum

    METHOD Yogunluk() AS F64
        IF hacim <= 0 THEN RETURN 0
        RETURN balikKg / hacim
    END METHOD

    METHOD Risk() AS STRING
        IF son.oksijen < 6.0 THEN RETURN "oksijen"
        IF son.ph < 6.8 OR son.ph > 8.2 THEN RETURN "pH"
        IF Yogunluk() > 0.09 THEN RETURN "yogunluk"
        RETURN "OK"
    END METHOD

    METHOD Csv() AS STRING
        RETURN ad + ";" + STR(son.gun) + ";" + STR(son.ph) + ";" + STR(son.oksijen) + ";" + Risk()
    END METHOD
END CLASS

MAIN
    DIM tanklar AS PTR
    tanklar = ux_dict_new()

    FOR i = 1 TO 4
        DIM t AS Tank
        t = NEW Tank()
        t.ad = "T" + STR(i)
        t.hacim = 1000
        t.balikKg = 60 + i * 5
        t.son.gun = 1
        t.son.ph = 7.0 + RND() * 0.8
        t.son.oksijen = 5.5 + RND() * 1.5
        CALL ux_dict_set_object(tanklar, t.ad, t)
    NEXT i

    OPEN "tank_nesne_raporu.csv" FOR OUTPUT AS #1
    PRINT #1, "tank;gun;pH;oksijen;risk"
    FOR i = 1 TO 4
        DIM ad AS STRING
        ad = "T" + STR(i)
        DIM t AS Tank
        t = ux_dict_get_object(tanklar, ad)
        PRINT #1, t.Csv()
        DELETE t
    NEXT i
    CLOSE #1
    CALL ux_dict_free(tanklar)
END MAIN
```

Bu örnek “ana programı ince tut” kuralını öğretir. Ana program veri üretir ve raporu çağırır; risk hesabı sınıfın içinde durur. Yarın risk hesabı değişirse ana program bozulmaz.

---

## 7. NAMESPACE, MODULE, USING, ALIAS, INCLUDE ve IMPORT ile proje örgüsü

Büyük proje tek dosyada büyütülmez. `NAMESPACE` ad çakışmasını önler. `MODULE` aynı işe ait yordamları toplar. `USING` uzun adları kullanıma açar. `ALIAS` uzun veya dış adları okunur hâle getirir. `INCLUDE` uXBasic başlık/modül dosyasını ekler. `IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)` dış kaynak dosyalarını derleme zincirine alır. DLL ve API için `DECLARE ... LIB ... ALIAS ...` veya `CALL(DLL,...)` kullanılır.

| Araç | Sözdizimi | Görev |
|---|---|---|
| `NAMESPACE` | `NAMESPACE Bilim ... END NAMESPACE` | isim alanı açar |
| `MODULE` | `MODULE Istatistik ... END MODULE` | iş ailesi toplar |
| `USING` | `USING NAMESPACE Bilim` | uzun yolu kısaltır |
| `ALIAS` | `ALIAS ORT = Bilim.Istatistik.Ortalama` | kısa ad verir |
| `INCLUDE` | `INCLUDE "modules/uxstats.uxmh"` | uXBasic başlık ekler |
| `IMPORT` | `IMPORT(C,"native/hizli.c")` | dış kaynak dosyası bağlar |
| `DECLARE` | `DECLARE FUNCTION ... LIB ... ALIAS ...` | DLL/API imzası bildirir |

### Modül tasarımı

```uxbasic
NAMESPACE Bilim
    MODULE Temel
        FUNCTION Ortalama(a AS F64, b AS F64) AS F64
            RETURN (a + b) / 2.0
        END FUNCTION
    END MODULE
END NAMESPACE

USING NAMESPACE Bilim
ALIAS ORT = Bilim.Temel.Ortalama
PRINT ORT(10, 20)
```

### INCLUDE ile başlık kullanma

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxcollections.uxmh"
DIM liste AS PTR
liste = ux_list_new()
CALL ux_list_push_f64(liste, 10.0)
CALL ux_list_free(liste)
```

### IMPORT ile C/C++/ASM bağlama

```uxbasic
IMPORT(C, "native/hizli_toplam.c")
IMPORT(CPP, "native/model.cpp")
IMPORT(ASM, "native/memfast.asm")

DECLARE FUNCTION HizliToplam(a AS I32, b AS I32) AS I32
PRINT HizliToplam(12, 30)
```

### Kallavi örnek 7 — temiz proje iskeleti

Aşağıdaki örnek tek dosyada gösterilir; gerçek projede `Bilim`, `Dosya`, `NativeKopru` ayrı `.uxmh` dosyalarına taşınır. Buradaki amaç projeyi isim alanıyla büyütmeyi öğretmektir.

```uxbasic
INCLUDE "modules/uxstats.uxmh"
IMPORT(C, "native/fast_sum.c")
DECLARE FUNCTION FastSumPtr(adres AS PTR, adet AS I32) AS F64

NAMESPACE Proje
    MODULE Dosya
        SUB SatirYaz(yol AS STRING, satir AS STRING)
            OPEN yol FOR APPEND AS #1
            PRINT #1, satir
            CLOSE #1
        END SUB
    END MODULE

    MODULE Analiz
        FUNCTION OrtalamaDizi(BYREF a AS F64, adet AS I32) AS F64
            DIM toplam AS F64
            FOR i = 1 TO adet
                toplam = toplam + a(i)
            NEXT i
            IF adet = 0 THEN RETURN 0
            RETURN toplam / adet
        END FUNCTION
    END MODULE
END NAMESPACE

USING NAMESPACE Proje
ALIAS Yaz = Proje.Dosya.SatirYaz

MAIN
    DIM veri(5) AS F64
    FOR i = 1 TO 5
        veri(i) = 10 + i
    NEXT i
    DIM ort AS F64
    ort = Proje.Analiz.OrtalamaDizi(veri, 5)
    CALL Yaz("proje.log", "ortalama=" + STR(ort))
    PRINT "Bitti"
END MAIN
```

Bu tasarımda dosya yazma ve analiz ayrıdır. Ana program yalnız işi orkestre eder. İyi mimari budur: ana akış roman gibi okunur, ayrıntı modüllerde durur.

---

## 8. Kanca ve sarmalayıcı geliştirme yöntemi

Kanca, derleyici veya çalışma zamanı akışında “bu noktada haber ver” demektir. Sarmalayıcı ise dış dünyanın karmaşasını uXBasic tarafında temiz fonksiyon hâline getirir. Bir DLL fonksiyonu on parametre istiyorsa, kullanıcının her yerde bunu yazması yerine bir `MODULE WindowsDialog` içine `MesajGoster` fonksiyonu koyarsın. Bir yapay zeka servisi JSON istiyorsa, kullanıcı JSON kurmak zorunda kalmaz; `LlamaSor` veya `ChatSor` gibi sarmalayıcı çağırır.

| Kavram | Görev | Genç programcıya kural |
|---|---|---|
| Hook | katmandan iz/olay toplar | ana işi bozma, yalnız ölç ve bildir |
| Wrapper | karmaşık çağrıyı sadeleştirir | dış ayrıntıyı tek yerde sakla |
| Bundle wrapper | dosya ailesini toplar | büyük derleyiciyi tek dosyaya yığma |
| Runtime wrapper | DLL/servis çağrısını taşır | aç/kullan/kapat düzeni kur |
| Test gate | çıktıyı doğrular | sahte başarı üretme |

### Basit hook düşüncesi

```uxbasic
MODULE DebugHook
    SUB KatmanGirdi(ad AS STRING, dosya AS STRING, satir AS I32)
        OPEN "hook_trace.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";ENTER;" + ad + ";" + dosya + ";" + STR(satir)
        CLOSE #1
    END SUB

    SUB KatmanCikti(ad AS STRING, durum AS STRING)
        OPEN "hook_trace.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";LEAVE;" + ad + ";" + durum
        CLOSE #1
    END SUB
END MODULE
```

### DLL sarmalayıcı örneği

```uxbasic
NAMESPACE Win
    MODULE Ses
        DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32

        FUNCTION Bip(hz AS I32, ms AS I32) AS BOOLEAN
            IF hz < 37 OR hz > 32767 THEN RETURN FALSE
            IF ms <= 0 THEN RETURN FALSE
            DIM r AS I32
            r = Beep(hz, ms)
            RETURN r <> 0
        END FUNCTION
    END MODULE
END NAMESPACE

IF Win.Ses.Bip(750, 250) THEN PRINT "ses verildi" ELSE PRINT "ses verilemedi"
```

Bu sarmalayıcı kullanıcıyı Windows API ayrıntısından korur. `Beep` sınırları kontrol edilir. Hata sessizce geçmez; `BOOLEAN` sonuç döner. İyi wrapper dış çağrıyı güzelleştirir.

### Kallavi örnek 8 — REST, DLL ve log için ortak wrapper anlayışı

```uxbasic
INCLUDE "modules/uxhttp.uxmh"
INCLUDE "modules/uxjson.uxmh"

NAMESPACE Sistem
    MODULE Log
        SUB Yaz(seviye AS STRING, mesaj AS STRING)
            OPEN "sistem.log" FOR APPEND AS #1
            PRINT #1, STR(TIMER()) + ";" + seviye + ";" + mesaj
            CLOSE #1
        END SUB
    END MODULE

    MODULE Ag
        FUNCTION Getir(url AS STRING) AS STRING
            TRY
                DIM cevap AS STRING
                cevap = ux_http_get(url)
                CALL Sistem.Log.Yaz("INFO", "GET basarili: " + url)
                RETURN cevap
            CATCH e
                CALL Sistem.Log.Yaz("ERROR", "GET hata: " + url)
                RETURN ""
            END TRY
        END FUNCTION
    END MODULE
END NAMESPACE

MAIN
    DIM ham AS STRING
    ham = Sistem.Ag.Getir("http://localhost:5000/status")
    IF LEN(ham) = 0 THEN
        PRINT "sunucu yok"
    ELSE
        PRINT "cevap="; MID(ham,1,80)
    END IF
END MAIN
```

Burada dış dünya ile konuşma tek satıra indirilmiştir: `Sistem.Ag.Getir`. Ana program HTTP ayrıntısını bilmez. Hata loglanır. Genç programcı için ders: dış çağrı yapılan yerde değil, sarmalayıcı içinde güvenli hâle getirilir.

---

## 9. Olay, boru, iş parçacığı ve paralel düzeni tasarlamak

`EVENT`, `SLOT`, `TRIGGER`, `PIPE`, `THREAD`, `PARALEL`, `ON`, `OFF` 2. ciltte komut olarak anlatıldı. Bu ciltte tasarım olarak anlatılır. Tek iş parçacıklı programda her şey sırayla olur. Büyük programda sensör okuma, dosya yazma, grafik çizme, API cevabı bekleme ve kullanıcı arayüzü aynı anda düşünülür. Burada paylaşılan değişkeni her yerden değiştirmek yerine olay ve boru kullanmak gerekir.

| Parça | Tasarım görevi | Örnek |
|---|---|---|
| `EVENT` | olay adını ve anlamını verir | `EVENT OlcumGeldi` |
| `SLOT` | olaya tepki verir | `SLOT Kaydet ON OlcumGeldi` |
| `TRIGGER` | olayı çalıştırır | `TRIGGER OlcumGeldi, deger` |
| `PIPE` | veri akış hattıdır | `PIPE TemizVeri AS F64` |
| `THREAD` | uzun işi arkaya alır | `THREAD DosyaOku` |
| `PARALEL` | bağımsız işleri gruplar | `PARALEL Saha` |
| `ON/OFF` | bağlama ve kapama mantığıdır | `OFF OlcumGeldi` |

### Kallavi örnek 9 — sensör, filtre, rapor, uyarı hattı

Bu örnekte program sensör verisi geldiğini varsayar. Olay tetiklenir, slot veriyi değerlendirir, risk varsa log yazar. Gerçek sistemde sensör okuma `THREAD` içine alınır; burada çalışma düzeni gösterilir.

```uxbasic
EVENT OlcumGeldi
PIPE HamOlcum AS F64
PIPE TemizOlcum AS F64

FUNCTION GecerliPh(x AS F64) AS BOOLEAN
    RETURN x >= 0 AND x <= 14
END FUNCTION

SLOT PhDegerlendir ON OlcumGeldi
    DIM ph AS F64
    INPUT ph
    IF NOT GecerliPh(ph) THEN
        OPEN "olay_hata.log" FOR APPEND AS #1
        PRINT #1, STR(TIMER()) + ";gecersiz pH;" + STR(ph)
        CLOSE #1
        EXIT SUB
    END IF

    PRINT "pH="; ph
    IF ph < 6.8 OR ph > 8.2 THEN
        OPEN "uyari.log" FOR APPEND AS #2
        PRINT #2, STR(TIMER()) + ";pH risk;" + STR(ph)
        CLOSE #2
    END IF
END SLOT

THREAD SensorOku
    FOR i = 1 TO 10
        TRIGGER OlcumGeldi
    NEXT i
END THREAD

PARALEL SahaIzleme
    CALL SensorOku()
    PRINT "ana ekran acik kalir"
END PARALEL
```

Bu örnekte paylaşılan büyük dizi yoktur; olay veriyi taşır. Hata ayrı loga, uyarı ayrı loga gider. Bu ayrım küçük görünür ama büyük sistemde hayat kurtarır.

### Kallavi örnek 10 — derleyici katman izleme olay modeli

Bir derleyicide her katman giriş/çıkışını olay gibi düşünebilirsin. Parser başladı, AST çıktı, MIR doğrulandı, JS yazıldı. Bu olayları loglarsan hangi aşamanın yavaş veya sorunlu olduğunu görürsün.

```uxbasic
EVENT KatmanBasladi
EVENT KatmanBitti

SLOT KatmanLog ON KatmanBasladi
    INPUT ad
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";BEGIN;" + ad
    CLOSE #1
END SLOT

SLOT KatmanSon ON KatmanBitti
    INPUT ad
    OPEN "build_trace.csv" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";END;" + ad
    CLOSE #1
END SLOT

SUB KatmanCalistir(ad AS STRING)
    TRIGGER KatmanBasladi, ad
    PRINT "calisiyor: "; ad
    TRIGGER KatmanBitti, ad
END SUB

MAIN
    CALL KatmanCalistir("preprocessor")
    CALL KatmanCalistir("lexer")
    CALL KatmanCalistir("parser")
    CALL KatmanCalistir("semantic")
    CALL KatmanCalistir("mir")
    CALL KatmanCalistir("js-backend")
END MAIN
```

Bu örneğin öğretici tarafı şudur: derleyici de olay sistemi gibi izlenebilir. Genç programcı kendi derleyicisini yazarken önce katman isimlerini loglamalıdır; sonra ölçüm, hata ve çıktı dosyası eklemelidir.

---

## 10. Değişken ve veri yapısı seçim defteri

Aşağıdaki tablo, “hangi işi hangi veri yapısıyla yapayım?” sorusuna cep cevabıdır.

| İş | En uygun yapı | Neden? | Kısa örnek |
|---|---|---|---|
| 30 günlük tek ölçüm | `ARRAY` | boyut belli, hızlı | `DIM ph(30) AS F64` |
| Dosyadan belirsiz satır | `LIST` | büyüyebilir | `ux_list_push_string` |
| Hata kodu açıklaması | `DICT` | anahtar/değer | `E01 -> düşük oksijen` |
| Benzersiz tank adları | `SET` | tekrar engeller | `T1` yalnız bir kez |
| Numune satırı | `TYPE` | alanları toplar | `Numune.ph` |
| Tank davranışı | `CLASS` | hesap ve veri birlikte | `Tank.Risk()` |
| DLL kaynağı | `PTR`/handle | dış dünya tanıtıcısı | `ptr = OpenLib()` |
| Para | `BIGD` | ondalık basamak | `BIGD("12.30")` |
| Büyük tam sayı | `BIGINT` | taşma istemez | faktöriyel |
| Ölçüm belirsizliği | `BALL` | aralık tutar | `BALL("7.2","7.4")` |
| Tarayıcı varlık listesi | `DICT` + `LIST` | yol ve sıra birlikte | manifest |

### Kallavi örnek 11 — mini sembol tablosu

Derleyici yazarken sembol tablosu, değişken adından tipe giden sözlüktür. Aynı ad tekrar tanımlanırsa hata olmalıdır. Bu örnekte `DICT` ad->tip için, `SET` tekrar denetimi için, `LIST` bildirim sırası için kullanılır.

```uxbasic
INCLUDE "modules/uxcollections.uxmh"

SUB SembolEkle(adlar AS PTR, tipler AS PTR, siralama AS PTR, ad AS STRING, tip AS STRING)
    IF ux_set_contains(adlar, ad) THEN
        PRINT "tekrar sembol: "; ad
        EXIT SUB
    END IF
    CALL ux_set_add(adlar, ad)
    CALL ux_dict_set_string(tipler, ad, tip)
    CALL ux_list_push_string(siralama, ad)
END SUB

MAIN
    DIM adlar AS PTR
    DIM tipler AS PTR
    DIM siralama AS PTR
    adlar = ux_set_new()
    tipler = ux_dict_new()
    siralama = ux_list_new()

    CALL SembolEkle(adlar, tipler, siralama, "ph", "F64")
    CALL SembolEkle(adlar, tipler, siralama, "tankNo", "I32")
    CALL SembolEkle(adlar, tipler, siralama, "ph", "STRING")

    OPEN "symbol_table.csv" FOR OUTPUT AS #1
    PRINT #1, "ad;tip"
    FOR i = 1 TO ux_list_count(siralama)
        DIM ad AS STRING
        ad = ux_list_get_string(siralama, i)
        PRINT #1, ad + ";" + ux_dict_get_string(tipler, ad)
    NEXT i
    CLOSE #1

    CALL ux_list_free(siralama)
    CALL ux_dict_free(tipler)
    CALL ux_set_free(adlar)
END MAIN
```

Bu örnek, derleyici zekâsının temelini gösterir. Bir değişkeni yalnız metin olarak görmek yetmez; adı, tipi ve sırası ayrı ayrı tutulur. Aynı adın tekrarını `SET` yakalar. Tip bilgisini `DICT` verir. Bildirim sırasını `LIST` saklar. Büyük derleyiciler de bu fikrin büyümüş hâlidir.

---

## 11. Cilt 3 son öğüdü: veri yapısı programın ahlakıdır

Program büyüdükçe gerçek sorun komut bilmemek değil, veriyi yanlış yere koymaktır. Yanlış tip sessiz hata üretir. Yanlış dizi boyutu hesapları bozar. Her yerde kullanılan çıplak `STRING` zamanla JSON, yol, hata, komut ve raporun birbirine karışmasına yol açar. Her dış çağrıyı ana programa yazarsan kodun DLL mezarlığına döner. Her kararı `IF` zinciri yaparsan programın sözlükle çözülecek yerleri kaya gibi donar.

Genç programcı için beş kural:

1. Değişken adını gerçek hayattaki nesneye göre koy: `phDegeri`, `tankNo`, `hataKodu`.
2. Tipi tahminle değil sınırla seç: 0..255 ise `U8`, günlük sayı ise `I32`, ölçüm ise `F64`, para ise `BIGD`.
3. Diziye geçtiğinde eksenleri yorumla: `grup, tank, gün, parametre` yazmadan çok boyutlu dizi kullanma.
4. `DICT` ile tablo kurmayı öğren: uzun `IF` zincirinin çoğu sözlükle temizlenir.
5. Dış dünyayı sarmalayıcıya kapat: `DECLARE`, `CALL`, `TRY`, `LOG`, `FREE` düzenini tek yerde tut.

Bu cildin özeti şudur: uXBasic’te iyi program, doğru komutu bilen program değil; doğru veriyi doğru kapta taşıyan programdır.
