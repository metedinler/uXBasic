# uXBasic Programlayıcının Cep Kitabı — Cilt 3
# Değişken, Bellek, Diziler, Veri Yapıları, Nesne ve Eşzamanlılık


## Değişken kuralları

Değişken, bellekte bir kutudur. Tip, bu kutunun nasıl okunacağını söyler. `I32` ile tutulan değer tam sayıdır; `F64` ile tutulan değer kesirli bilimsel sayıdır; `PTR` veya `U64` ile tutulan değer çoğu zaman dış kütüphane handle bilgisidir. Bir handle doğrudan sayı gibi görünür ama aslında dış DLL içindeki nesnenin anahtarıdır.
```uxbasic
DIM ad AS STRING
DIM yas AS I32
DIM sicaklik AS F64
DIM df AS U64
ad = "Mete"
yas = 25
sicaklik = 24.7
PRINT ad; " "; yas; " "; sicaklik
```
## 2, 3, 4 ve 5 boyutlu diziler

Dizi, aynı tipten çok sayıda kutuyu düzenli saklar. İki boyut tablo, üç boyut katmanlı tablo, dört boyut zamanlı hacim, beş boyut deney seti gibi düşünülebilir.
```uxbasic
' 2 boyut: ogrenci x ders not tablosu
DIM notlar(1 TO 3, 1 TO 4) AS F64
FOR ogr = 1 TO 3
    FOR ders = 1 TO 4
        notlar(ogr, ders) = ogr * 10 + ders
    NEXT ders
NEXT ogr
PRINT notlar(2, 3)
```
```uxbasic
' 3 boyut: gun x havuz x olcum
DIM su(1 TO 7, 1 TO 4, 1 TO 3) AS F64
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        su(gun, havuz, 1) = 7.5       ' pH
        su(gun, havuz, 2) = 24.0      ' sicaklik
        su(gun, havuz, 3) = 6.8       ' oksijen
    NEXT havuz
NEXT gun
PRINT su(3, 2, 3)
```
```uxbasic
' 4 boyut: yil x ay x istasyon x parametre
DIM izleme(2024 TO 2026, 1 TO 12, 1 TO 5, 1 TO 6) AS F64
izleme(2026, 5, 2, 1) = 8.1
PRINT izleme(2026, 5, 2, 1)
```
```uxbasic
' 5 boyut: deney x tekrar x zaman x organ x olcum
DIM deney(1 TO 2, 1 TO 3, 1 TO 10, 1 TO 4, 1 TO 5) AS F64
deney(1, 2, 5, 3, 4) = 0.875
PRINT deney(1, 2, 5, 3, 4)
```

## ARRAY, LIST, DICT, SET
|Yapı|Anlam|Ne zaman kullanılır|Dikkat|
|---|---|---|---|
|ARRAY|Sabit veya belirli boyutlu düzenli veri|Matris, tablo, deney ölçümü|indeks hatasına dikkat|
|LIST|Sırası önemli, uzunluğu büyüyen veri|günlük kayıt, hata listesi, öğrenci listesi|çok arama yapılacaksa DICT daha hızlıdır|
|DICT|Anahtar-değer veri|ayar, isimden puan bulma, JSON benzeri yapı|anahtar benzersiz olmalı|
|SET|Benzersiz değerler|tekrarları temizleme, etiket toplama|sıra garantisi bekleme|
```uxbasic
DIM isimler AS LIST
DIM puanlar AS DICT
DIM turler AS SET
LIST.ADD isimler, "Ali"
LIST.ADD isimler, "Ayse"
DICT.SET puanlar, "Ali", 82
DICT.SET puanlar, "Ayse", 91
SET.ADD turler, "alabalik"
SET.ADD turler, "alabalik"
PRINT DICT.GET(puanlar, "Ayse")
```

## Bellek ve pointer ailesi

`VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `PEEK*`, `POKE*`, `MEMCOPY*`, `MEMFILL*` komutları uXBasic'i sistem programlama tarafına taşır. Bu komutlar güçlüdür; yanlış adres verirsen veri bozarsın. Kural: önce küçük tamponda dene, sonra gerçek veriye uygula.
```uxbasic
DIM tampon(0 TO 15) AS BYTE
MEMFILLB VARPTR(tampon(0)), 0, 16
POKEB VARPTR(tampon(0)), 65
PRINT CHR(PEEKB(VARPTR(tampon(0))))
```

## Nesne yönelimli düzen

Sınıf [veri ve davranış kalıbı] (class), aynı veriyle çalışan yordamları aynı çatıya toplar. `PUBLIC`, `PRIVATE`, `PROTECTED`, `METHOD`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE` gibi sözcükler bu çatıyı kurar.
```uxbasic
CLASS Sensor
PUBLIC:
    DIM ad AS STRING
    DIM sonDeger AS F64
    CONSTRUCTOR Sensor(yeniAd AS STRING)
        ad = yeniAd
        sonDeger = 0
    END CONSTRUCTOR
    METHOD Oku(deger AS F64)
        sonDeger = deger
    END METHOD
    METHOD Yaz()
        PRINT ad; "="; sonDeger
    END METHOD
END CLASS
DIM s AS Sensor
s = NEW Sensor("pH")
s.Oku(7.8)
s.Yaz()
DELETE s
```

## EVENT, PIPE, THREAD, PARALEL, SLOT

Olay sistemi, bir programda “şu olursa bu çalışsın” demektir. `EVENT` olay adını, `SLOT` olaya bağlanan işi, `TRIGGER` olayı ateşlemeyi, `PIPE` veri yolunu, `THREAD` ayrı iş parçacığını, `PARALEL` eşzamanlı iş fikrini taşır.
```uxbasic
EVENT VeriGeldi
PIPE OlcumAkisi AS F64
SLOT Yazdir ON VeriGeldi
    DIM v AS F64
    v = PIPE.READ(OlcumAkisi)
    PRINT "Yeni olcum="; v
END SLOT
PIPE.WRITE OlcumAkisi, 7.42
TRIGGER VeriGeldi
```
```uxbasic
THREAD DosyaOkuyucu
    OPEN "olcum.csv" FOR INPUT AS #1
    INPUT #1, satir
    CLOSE #1
END THREAD
PARALEL Analiz
    PRINT "Ana program donmadan analiz basladi"
END PARALEL
```

## Veri yapılarının her biri için derin kullanım defteri

Bir veri yapısını öğrenmenin en iyi yolu, onu gerçek hayattaki kutuya benzetmektir. `ARRAY` numaralı raf, `LIST` uzayan liste, `DICT` etiketli çekmece, `SET` tekrar kabul etmeyen sepet, `OBJECT` davranışı olan varlık, `PTR` ise dış dünyadaki bir şeyin adres pusulasıdır.

### ARRAY: düzenli ve hızlı ölçüm tablosu

Sözdizimi: `DIM ad(alt TO ust, ...) AS tip`. Sabit ölçüm tablosu, matris, görüntü, deney planı ve oyun tahtası için uygundur.

```uxbasic
DIM ph(1 TO 7, 1 TO 4) AS F64
DIM gun AS I32
DIM havuz AS I32
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        ph(gun, havuz) = 7.2 + gun * 0.01 + havuz * 0.02
    NEXT havuz
NEXT gun
PRINT "3. gun 2. havuz pH="; ph(3, 2)
```

İpucu: İki boyutlu dizi tablo gibi okunur. Birinci indeks satır, ikinci indeks sütun gibi düşünülür. Bilimsel ölçümde indeksleri isimlendiremiyorsan yanına açıklayıcı sabit koy: `PH_COL = 1`, `TEMP_COL = 2`.

### 3 boyutlu ARRAY: zaman, yer, ölçüm

```uxbasic
DIM olcum(1 TO 30, 1 TO 6, 1 TO 3) AS F64
DIM g AS I32, h AS I32
FOR g = 1 TO 30
    FOR h = 1 TO 6
        olcum(g,h,1)=7.5
        olcum(g,h,2)=24.0
        olcum(g,h,3)=6.4
    NEXT h
NEXT g
PRINT olcum(10,3,2)
```

### 4 boyutlu ARRAY: zamanlı hacim

```uxbasic
DIM sensor(2026 TO 2027, 1 TO 12, 1 TO 31, 1 TO 8) AS F64
sensor(2026,5,30,1)=24.8
sensor(2026,5,30,2)=7.9
PRINT "Bugun sensor1="; sensor(2026,5,30,1)
```

### 5 boyutlu ARRAY: deney evreni

```uxbasic
DIM deneme(1 TO 3, 1 TO 5, 1 TO 4, 1 TO 10, 1 TO 6) AS F64
' grup, tekrar, tank, zaman, parametre
deneme(2,3,1,7,4)=0.912
PRINT "7. zamanda 4. parametre="; deneme(2,3,1,7,4)
```

### LIST: olay günlüğü ve büyüyen sıra

Sözdizimi: `DIM ad AS LIST`, `LIST.ADD ad, deger`, `LIST.GET(ad, sira)`. Uzunluğu sonradan belli olan şeylerde kullanılır.

```uxbasic
DIM loglar AS LIST
LIST.ADD loglar, "Basladi"
LIST.ADD loglar, "Veri okundu"
LIST.ADD loglar, "Rapor yazildi"
PRINT LIST.GET(loglar, 2)
```

Gerçek iş: hata günlüğü tut, testlerde hangi dosya geçti yaz, kullanıcıya son işlemleri göster. `ARRAY` kullanırsan başta boyut bilmen gerekir; `LIST` bu zorunluluğu kaldırır.

### DICT: adı bilinen değere hızlı ulaşma

Sözdizimi: `DIM ad AS DICT`, `DICT.SET ad, anahtar, deger`, `DICT.GET(ad, anahtar)`. Ayar, JSON benzeri veri, istasyon adı, kullanıcı rolü ve sembol tablosu için uygundur.

```uxbasic
DIM ayar AS DICT
DICT.SET ayar, "hedef", "browser"
DICT.SET ayar, "outdir", "dist/web"
DICT.SET ayar, "debug", "true"
PRINT "Hedef="; DICT.GET(ayar, "hedef")
```

Derleyici yazarken `DICT` altın değerindedir. Lexer bir kelime gördüğünde anahtar kelime mi diye `DICT` içinde arayabilir. Parser bir değişken gördüğünde sembol tablosuna `DICT.SET symbol, ad, tip` diyebilir.

### SET: tekrarları temizleyen sepet

Sözdizimi: `DIM ad AS SET`, `SET.ADD ad, deger`, `SET.HAS(ad, deger)`. Bir şeyi bir kez saymak istediğinde kullanılır.

```uxbasic
DIM turler AS SET
SET.ADD turler, "alabalik"
SET.ADD turler, "sazan"
SET.ADD turler, "alabalik"
IF SET.HAS(turler, "sazan") THEN PRINT "Sazan listede var"
```

İpucu: Bir CSV dosyasından gelen şehir adlarını temizlemek istiyorsan önce `SET`, sonra rapor için `LIST` kullan. Böylece hem tekrar gider hem sıralı yazdırırsın.

## Program içi tablolar: sembol, tip, sabit ve hata tabloları

uXBasic gibi bir derleyicide tablolar programın hafızasıdır. Sembol tablosu değişken adını tipe bağlar. Tip tablosu hangi tipin kaç bayt olduğunu tutar. Sabit tablosu tekrar eden metin ve sayıları saklar. Hata tablosu satır, sütun, kod ve açıklamayı bir arada taşır.

```uxbasic
DIM symbol AS DICT
DIM types AS DICT
DIM errors AS LIST
DICT.SET types, "I32", 4
DICT.SET types, "F64", 8
DICT.SET symbol, "sicaklik", "F64"
IF DICT.GET(symbol, "sicaklik") <> "F64" THEN LIST.ADD errors, "Tip uyumsuz"
PRINT "sicaklik tipi="; DICT.GET(symbol, "sicaklik")
```

Genç programcı için kural: Bir program büyüdükçe `IF` sayısını azaltmak için tablo kullan. Yüz satırlık `IF kelime = ...` zinciri yerine `DICT` ile anahtar aramak daha temizdir.

## Dosya ve dizin işleriyle gerçek belge üretimi

Dosya işlemleri programcının dış hafızasıdır. `OPEN` dosyayı açar, `PRINT #` yazar, `INPUT #` okur, `EOF` dosya sonunu sorar, `LOF` uzunluk verir, `SEEK` konum değiştirir, `CLOSE` kapatır.

```uxbasic
DIM satir AS STRING
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "uXBasic raporu"
PRINT #1, "pH=7.8"
CLOSE #1

OPEN "rapor.txt" FOR INPUT AS #2
WHILE NOT EOF(2)
    LINE INPUT #2, satir
    PRINT satir
WEND
CLOSE #2
```

Eklemeli yazma günlük için kullanılır:

```uxbasic
OPEN "log.txt" FOR APPEND AS #1
PRINT #1, TIMER(); " islem tamam"
CLOSE #1
```

## Nesne, namespace, module, alias, using module

`NAMESPACE` ad çakışmasını önler. `MODULE` bir iş ailesini toplar. `ALIAS` uzun adı kısa ada bağlar. `USING MODULE` o modülün adlarını görünür kılar. Büyük projede bunlar lüks değil, düzen şartıdır.

```uxbasic
NAMESPACE SuUrunleri
MODULE Yem
    FUNCTION Oran(ByVal protein AS F64, ByVal yag AS F64) AS F64
        RETURN protein / (protein + yag)
    END FUNCTION
END MODULE
END NAMESPACE

USING MODULE SuUrunleri.Yem
ALIAS RASYON_ORANI = Oran
PRINT RASYON_ORANI(42.0, 12.0)
```

Sözlük kuralı: Programın ana işini anlatan adlar uzun ve temiz olsun; sık kullanılan adlar `ALIAS` ile kısaltılsın. `x`, `y`, `z` sadece küçük matematik döngüsünde iyidir.

## Olay, boru, slot, iş parçacığı ve koşut çalışma

Olay sistemi, bir şey olduğunda başka bir işi çağırma biçimidir. `EVENT` olay adını tanımlar, `SLOT` olaya bağlanan işi tarif eder, `TRIGGER` olayı ateşler. `PIPE` iki işi birbirine veri borusuyla bağlar. `THREAD` ayrı iş parçacığı açar. `PARALEL` bağımsız işleri birlikte koşturmak için düşünülür.

```uxbasic
EVENT YeniOlcum
SLOT Yazdir ON YeniOlcum
    PRINT "Yeni olcum geldi"
END SLOT
TRIGGER YeniOlcum
```

Veri borusu örneği:

```uxbasic
PIPE OlcumBoru AS STRING
THREAD Uretici
    PIPE.WRITE OlcumBoru, "ph=7.8"
END THREAD
THREAD Tuketici
    DIM gelen AS STRING
    gelen = PIPE.READ(OlcumBoru)
    PRINT gelen
END THREAD
```

Koşut analiz örneği:

```uxbasic
PARALEL
    CALL HesaplaOrtalama()
    CALL HesaplaSapma()
    CALL RaporHazirla()
END PARALEL
PRINT "Uc is birlikte planlandi"
```

Yedi katmanlı düşünme ipucu: Lexer olay adını kelime yapar; parser olay düğümünü kurar; AST olay ağacını taşır; HIR düzenler; MIR çağrıya indirir; runtime olay tablosunu yürütür; backend hedefe göre JS, WAT veya native çağrı üretir.

## Katmanlara yönelik yedi küçük geliştirme örneği

1. **Lexer örneği:** Yeni kelime eklemeden önce onun başka yerde değişken adı olarak kullanılıp kullanılmadığını test et.
2. **Parser örneği:** Her yeni komut için en küçük programı yaz: `KOMUT`, `KOMUT + IF`, `KOMUT + LOOP`, `KOMUT + FUNCTION`, `KOMUT + HATA`.
3. **AST örneği:** Düğüm adını görevine göre koy; `PRINT_STMT` komuttur, `CALL_EXPR` değer döndürebilir.
4. **HIR örneği:** Şeker sözdizimini sade forma indir. `INC A` aslında `A = A + 1` gibi düşünülür.
5. **MIR örneği:** Backendlerin ortak anlayacağı işlem üret; JS ve WAT aynı MIR bilgisinden beslenir.
6. **Runtime örneği:** Dosya, bellek, olay ve DLL çağrısı burada gerçekten çalışır; hata kodu burada netleşir.
7. **Backend örneği:** Aynı programı `--emit-js`, `--emit-wat`, `--emit-x64-nasm` ile çıkar; sonuçlar farklı dosya ama aynı niyet olmalıdır.
