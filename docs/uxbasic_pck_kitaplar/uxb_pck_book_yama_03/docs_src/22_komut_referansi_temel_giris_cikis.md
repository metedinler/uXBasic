# Temel Komut Referansı: Yazdırma, Değişken ve Giriş Çıkış

uXBasic öğrenirken ilk görülen komutlar basit görünür; fakat kitabın dili açısından en önemli komutlar bunlardır. Çünkü okuyucu ilk defa kaynak kodun neye dönüştüğünü, değişkenin nasıl ad aldığını, değerin nasıl saklandığını ve sonucun nasıl gözlemlendiğini burada öğrenir. `PRINT`, `DIM`, `AS`, `CONST`, `INPUT`, `CLS`, `COLOR`, `LOCATE`, `INKEY` ve `GETKEY` yalnız başlangıç komutları değildir; bütün daha büyük örneklerin taşıyıcı kolonlarıdır.

Bu bölümde her komut önce tek başına tanıtılır, sonra kendinden önce ve sonra gelen komutlarla birlikte kullanılır. Böylece okuyucu bir komutu ezberlemek yerine, o komutun program akışı içindeki yerini görür.

## PRINT

`PRINT`, bir ifadeyi görünür çıktı hâline getirir. Bu çıktı konsolda görülebilir, dosya kanalına yazılabilir veya hedefe göre runtime çıktı servisine bağlanabilir. Programcı açısından `PRINT`, sonucu görmenin en kısa yoludur. Derleyici açısından ise ifade çözümleme, tip dönüştürme ve çıktı rotasına bağlanma noktasıdır.

Syntax:

```basic
PRINT ifade
PRINT "metin"
PRINT degisken
PRINT #kanal, ifade
```

Temel örnek:

```basic
PRINT "uXBasic calisiyor"
```

Beklenen çıktı:

```text
uXBasic calisiyor
```

`PRINT` tek başına kullanıldığında yalnızca sabit metni gösterir. Bir değişkenle kullanıldığında programın iç durumunu dışarı çıkarır:

```basic
DIM puan AS I32 = 70
PRINT puan
```

Beklenen çıktı:

```text
70
```

Bir hesap ifadesiyle birlikte kullanıldığında `PRINT`, sonucu ayrıca değişkene almadan gözlemlemeyi sağlar:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
PRINT yem / balik
```

Beklenen çıktı:

```text
3
```

Bu örnek, `DIM`, `AS`, bölme operatörü ve `PRINT` komutunu aynı anda çalıştırır. Kitap boyunca bir komutun en küçük örneği verildikten sonra, hemen böyle birleşik bir örneğe geçilir.

## DIM ve AS

`DIM`, bellekte isimli alan açar. `AS`, bu alanın tipini bağlar. Bu ikisi birlikte kullanıldığında derleyici değişkenin adını, türünü ve kapsamını bilir. Bu bilgi semantic denetim için gereklidir; MIR ve hedef kod üretimi de bu tip bilgisinden yararlanır.

Syntax:

```basic
DIM ad AS tip
DIM ad AS tip = ilkDeger
DIM ad(boyut) AS tip
```

Temel örnek:

```basic
DIM sayi AS I32 = 30
PRINT sayi
```

Beklenen çıktı:

```text
30
```

Dizi örneği:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

PRINT sicaklik(1)
PRINT sicaklik(2)
PRINT sicaklik(3)
```

Beklenen çıktı:

```text
18
21
19
```

Bu kod, üç ayrı değişken açmak yerine tek bir dizi adı altında üç ölçüm saklar. Daha sonra `FOR` döngüsü öğrenildiğinde aynı dizi tek tek yazdırılmak yerine döngüyle gezilir:

```basic
DIM sicaklik(3) AS I32
sicaklik(1) = 18
sicaklik(2) = 21
sicaklik(3) = 19

DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 3
    toplam = toplam + sicaklik(i)
NEXT i

PRINT toplam
```

Beklenen çıktı:

```text
58
```

`DIM` böylece yalnız değişken tanımlama komutu değildir; dizi, kayıt, nesne, fonksiyon içi yerel değer ve hesap akışı kurmanın başlangıç noktasıdır.

## CONST

`CONST`, program boyunca değişmeyecek değeri adlandırır. Bu değer bir sınır, katsayı, ayar veya sabit mesaj olabilir. `CONST` kullanıldığında okuyucu ve derleyici bu adın normal değişken gibi değiştirilmemesi gerektiğini bilir.

Syntax:

```basic
CONST ad AS tip = deger
```

Örnek:

```basic
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Guvenli
```

Bu örnekte `LIMIT` sıradan bir sayı olarak yazılabilirdi; fakat sabit adı programın niyetini açıklar. Genç programcı için önemli ders şudur: kod yalnız makineye değil, gelecekte o kodu okuyacak insana da yazılır.

## INPUT

`INPUT`, kullanıcıdan veya dosya kanalından değer alır. Konsol kullanımında programı dış dünyadan gelen veriyle buluşturur. Dosya kanalında `INPUT #` biçimiyle kullanıldığında okuma rotası dosyaya bağlanır.

Syntax:

```basic
INPUT degisken
INPUT #kanal, degisken
```

Konsol mantığı:

```basic
DIM yas AS I32
INPUT yas
PRINT yas
```

Dosya kanalı mantığı:

```basic
OPEN "veri.txt" FOR OUTPUT AS #1
PRINT #1, "77"
CLOSE #1

OPEN "veri.txt" FOR INPUT AS #2
DIM okuma AS I32
INPUT #2, okuma
CLOSE #2

PRINT okuma
```

Beklenen çıktı:

```text
77
```

Burada `#` işareti değişken eki değildir; dosya kanal numarasıdır. uXBasic sözleşmesinde `#` karakteri dosya giriş çıkış kanalını göstermek için kullanılır.

## CLS, COLOR ve LOCATE

`CLS`, ekranı temizler. `COLOR`, yazı ve arka plan rengini ayarlar. `LOCATE`, imleci belirli satır ve sütuna taşır. Bu komutlar doğrudan hesap üretmez; fakat konsol programında kullanıcıya düzenli çıktı göstermek için kullanılır.

Syntax:

```basic
CLS
COLOR onPlan, arkaPlan
LOCATE satir, sutun
```

Örnek:

```basic
CLS
COLOR 10, 0
LOCATE 2, 5
PRINT "uXBasic panel"
```

Bu örnek bir hesap algoritması değil, çıktı düzeni örneğidir. Kitapta böyle komutlar anlatılırken “ekranı güzelleştirir” gibi boş cümle kullanılmaz. Görev açık yazılır: `CLS` eski çıktıyı siler, `COLOR` yeni çıktının renk bilgisini ayarlar, `LOCATE` yazının başlayacağı konumu seçer.

## INKEY ve GETKEY

`INKEY` ve `GETKEY`, klavyeden karakter veya tuş bilgisi alma ailesindedir. Bu iki sözcük birlikte korunur. `INKEY` genellikle beklemeden okuma fikrine, `GETKEY` ise tuş alma fikrine bağlanır. Kitapta ikisi de klavye giriş yüzeyi olarak anlatılır.

Örnek kullanım fikri:

```basic
DIM tus AS STRING

tus = INKEY

IF tus <> "" THEN
    PRINT tus
END IF
```

Basit menü fikri:

```basic
PRINT "1 - Baslat"
PRINT "2 - Cikis"

DIM tus AS STRING
 tus = GETKEY

IF tus = "1" THEN
    PRINT "Basliyor"
ELSEIF tus = "2" THEN
    PRINT "Cikis"
ELSE
    PRINT "Bilinmeyen secim"
END IF
```

Bu örnek, klavye komutlarını `IF`, `ELSEIF`, `PRINT` ve `STRING` tipiyle birleştirir. Komutlar kitapta tek tek görünür; fakat program gerçek gücünü bu birleşimlerde kazanır.

## Temel komutların birlikte akışı

Aşağıdaki küçük program, bu bölümdeki komut ailesini tek bir akışta kullanır:

```basic
CLS
COLOR 10, 0

CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

LOCATE 2, 1
PRINT "Olcum sonucu"

IF okuma < LIMIT THEN
    PRINT "Guvenli"
ELSE
    PRINT "Limit asildi"
END IF
```

Beklenen çıktı:

```text
Olcum sonucu
Guvenli
```

Bu program küçük görünür; fakat bir kitabın ilk dersleri için yeterince zengindir. Sabit değer vardır, değişken vardır, koşul vardır, ekran düzeni vardır ve sonuç vardır. uXBasic kitabında temel komutlar bu şekilde öğretilir: önce tek başına, sonra birlikte, sonra küçük bir düşünce düzeni içinde.
