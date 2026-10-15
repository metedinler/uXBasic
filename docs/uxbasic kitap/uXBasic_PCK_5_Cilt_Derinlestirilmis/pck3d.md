# uXBasic Programlayıcının Cep Kitabı — Cilt 3
# Değişkenler, Veri Yapıları, Nesne Düzeni, Kanca ve Eşzamanlılık

Bu cilt Cilt 2'deki komutları daha uzun program kalıplarına dönüştürür. Amaç, genç programcının `DIM`, `ARRAY`, `LIST`, `DICT`, `SET`, `CLASS`, `EVENT`, `PIPE`, `THREAD`, `PARALEL`, `SLOT`, kanca ve sarmalayıcı kavramlarını gerçek işlere bağlamasıdır.

## Değişken seçme rehberi
|İhtiyaç|Tip|Kullanım|
|---|---|---|
|Küçük sayaç|I32|FOR/NEXT, satır sayısı, menü seçimi|
|Büyük sayaç|I64|dosya boyutu, uzun kayıt sayısı|
|Ölçüm|F64|pH, sıcaklık, ağırlık, oran|
|Yüksek duyarlık|BIGD/BIGF/F128|finans, bilimsel hassas hesap, büyük matris|
|Metin|STRING|kullanıcı adı, dosya yolu, API cevabı|
|Ham veri|BYTE/U8/ARRAY|ikili dosya, resim, bellek tamponu|
|Nesne|OBJECT/CLASS|durum ve davranış bir arada|
|Adres|PTR/STRPTR|DLL, C fonksiyonu, bellek köprüsü|

## ARRAY — dizi
Dizi, aynı tipten çok sayıda değeri sıra numarasıyla tutar. Ölçüm listesi, görüntü pikseli, matris satırı, oyun haritası veya zaman serisi için kullanılır. Dizi kullanırken sınırı baştan düşün; sınır belirsizse `LIST`, çok boyut gerekiyorsa açık boyutlu `ARRAY` seç.
```uxbasic
DIM sicaklik(1 TO 7) AS F64
FOR gun = 1 TO 7
  INPUT sicaklik(gun)
NEXT gun
PRINT "3. gun="; sicaklik(3)
```
### 2, 3, 4 ve 5 boyutlu dizi fikri
```uxbasic
DIM tablo(1 TO 3, 1 TO 4) AS F64          ' 2 boyut: satır/sütun
DIM kup(1 TO 4, 1 TO 4, 1 TO 4) AS I32       ' 3 boyut: hacim
DIM deney(1 TO 2,1 TO 3,1 TO 4,1 TO 5) AS F64 ' 4 boyut: grup/gün/kap/ölçüm
DIM model(1 TO 2,1 TO 2,1 TO 2,1 TO 2,1 TO 2) AS F32 ' 5 boyut: küçük tensör
FOR g = 1 TO 2
  FOR gun = 1 TO 3
    deney(g, gun, 1, 1) = g * gun
  NEXT gun
NEXT g
PRINT deney(2,3,1,1)
```
## LIST — büyüyen liste
Liste, kaç eleman geleceğini bilmediğin durumlarda kullanılır. Kullanıcı satır satır veri girer, sensör ölçüm yollar, API sayfa sayfa cevap verir; sen listeye eklersin. Liste sıralıdır; aynı değer birden fazla kez bulunabilir.
```uxbasic
DIM adlar AS LIST OF STRING
LIST.ADD adlar, "Ali"
LIST.ADD adlar, "Ayse"
FOR EACH ad IN adlar
  PRINT UCASE(ad)
NEXT ad
```
## DICT — sözlük
Sözlük, anahtardan değere giden hızlı yoldur. Bir balığın adıyla ağırlığını, bir hata koduyla açıklamasını, bir API alanıyla değerini saklayabilirsin. Anahtar benzersizdir; aynı anahtar tekrar yazılırsa genellikle eski değer güncellenir.
```uxbasic
DIM stok AS DICT OF STRING, I32
DICT.SET stok, "yem", 25
DICT.SET stok, "kova", 3
IF DICT.HAS(stok, "yem") THEN PRINT DICT.GET(stok, "yem")
```
## SET — küme
Küme tekrarsız değer tutar. Bir dosyada kaç farklı tür adı geçti, kullanıcı hangi yetkilere sahip, hangi hata kodları görüldü gibi işlerde listeye göre daha temizdir.
```uxbasic
DIM turler AS SET OF STRING
SET.ADD turler, "alabalik"
SET.ADD turler, "alabalik"
SET.ADD turler, "sazan"
PRINT SET.COUNT(turler)
```
## Kanca [hook] ile geliştirme
Kanca, derleyici veya çalışma zamanı aşamasında asıl akışı bozmadan izleme ve ek davranış takma noktasıdır. uXBasic kaynak ağacında AST, HIR, MIR, çalışma zamanı ve kod üretimi için kanca dosyaları bulunur. Bunların temel fikri şudur: ana derleyici dosyasını her seferinde kirletme; ölçmek, raporlamak veya özel deneme yapmak için kanca çağrısını kullan. Kanca kodu varsayılan olarak sessiz olmalı, açıldığında rapor üretmelidir.
```uxbasic
%%DEFINE HOOK_TRACE
IF HOOK_TRACE THEN
  PRINT "MIR asamasi basladi"
END IF
PRINT "normal program akisi bozulmadi"
```
## Sarmalayıcı [wrapper] ile geliştirme
Sarmalayıcı, dış fonksiyonu genç programcının anlayacağı düzgün bir uXBasic fonksiyonuna çevirir. Örneğin `kernel32.dll` içindeki `Beep` doğrudan çağrılabilir; fakat bunu `UyariSesi` adlı fonksiyona sarmalarsan frekans kontrolü, hata mesajı ve test aynı yerde toplanır.
```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
  IF hz < 37 OR hz > 32767 THEN RETURN FALSE
  IF ms <= 0 THEN RETURN FALSE
  sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
  IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE END IF
END FUNCTION
PRINT UyariSesi(880, 200)
```
## EVENT, PIPE, THREAD, PARALEL, SLOT ile anlamlı sistem
Aşağıdaki örnek bir ölçüm sisteminin küçültülmüş modelidir. Olay adı tanımlanır, veri borusu kurulur, arka plan iş ölçüm üretir, yuva ekrana ve dosyaya yazar. GUI'de düğme basılması, tarayıcıda tıklama veya sensör verisi aynı mantıkla bağlanabilir.
```uxbasic
EVENT OlcumGeldi
PIPE OlcumBoru AS F64
THREAD SensorOku
  FOR i = 1 TO 5
    TRIGGER OlcumGeldi, i * 1.25
  NEXT i
END THREAD
SLOT Raporla ON OlcumGeldi
  INPUT deger
  PRINT "olcum="; deger
  OPEN "olcum.csv" FOR APPEND AS #1
  PRINT #1, STR(TIMER()) + ";" + STR(deger)
  CLOSE #1
END SLOT
PARALEL Calisma
  CALL SensorOku()
END PARALEL
```
## Her katman için 7 kısa örnek
### Ön-işleyici hedef seçimi
```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
%%HTML_LINE <pre id="uxb-console"></pre>
PRINT "tarayici cikisi"
```
### Kaynak dahil etme
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM x AS F64
x = 12.5
PRINT x
```
### Sözcük ve komut yüzeyi
```uxbasic
DIM yas AS I32
INPUT yas
IF yas >= 18 THEN PRINT "yetiskin" ELSE PRINT "genc" END IF
```
### Tip/anlam denetimi
```uxbasic
DIM toplam AS F64
DIM adet AS I32
ASSERT adet >= 0
IF adet > 0 THEN PRINT toplam/adet
```
### MIR/ara iş fikri
```uxbasic
FUNCTION Kare(x AS F64) AS F64
  RETURN x*x
END FUNCTION
PRINT Kare(4)
```
### JS tarayıcı hedefi
```uxbasic
%%TARGET js
PRINT "Bu metin program.js icinden tarayiciya gidebilir"
```
### WAT/WASM hedefi
```uxbasic
%%TARGET wasm
FUNCTION Topla(a AS I32, b AS I32) AS I32
  RETURN a + b
END FUNCTION
PRINT Topla(2,3)
```
