# Komut Yazım Şablonu ve Tablo Yasası

uXBasic kitabında her komut aynı kalıpla ezberletilmez; fakat her komut aynı ciddiyetle açıklanır. Okuyucu bir komut sayfasına baktığında dört şeyi hemen görmelidir: komutun görevi, yazım biçimi, küçük örneği ve hangi yapılarla birlikte kullanıldığı.

Her komut için ana şablon şöyledir:

```text
Komut adı
Görev
Syntax
Parametreler
Temel örnek
Beklenen çıktı
Birlikte kullanıldığı komutlar
Gelişmiş örnek
Derleyici katmanı
İlgili test veya project pack
```

Bu şablon bir bürokrasi değildir. Şablon, kitabı tekrar eden boş cümlelerden korur. Bir komutun syntaxı yoksa okuyucu yazamaz. Örneği yoksa deneyemez. Beklenen çıktısı yoksa sonucu anlayamaz. Katmanı yoksa derleyicinin hangi yolundan geçtiğini göremez.

## Örnek komut sayfası: DIM

`DIM`, bellekte isimli değişken, dizi veya nesne alanı açar. `AS` ile birlikte kullanıldığında değişkenin tipi açıkça belirtilir. Bu sayede semantic katman değişkenin hangi tür değer taşıyacağını bilir; runtime veya backend tarafı da bu bilgiye göre alan ve işlem seçer.

Syntax:

```basic
DIM ad AS tip
DIM ad AS tip = ilkDeger
DIM ad(boyut) AS tip
```

Temel örnek:

```basic
DIM yas AS I32 = 20
PRINT yas
```

Beklenen çıktı:

```text
20
```

Dizi örneği:

```basic
DIM puan(3) AS I32
puan(1) = 10
puan(2) = 20
puan(3) = puan(1) + puan(2)
PRINT puan(3)
```

Beklenen çıktı:

```text
30
```

`DIM`, `AS`, `CONST`, `REDIM`, `TYPE`, `CLASS`, `ARRAY`, `LIST`, `DICT` ve `SET` ile aynı öğrenme ailesindedir. Bu komut anlatıldıktan sonra tipler, diziler ve kayıtlar daha kolay anlaşılır.

## Tablo yasası

Tablo satırları birbirinin kopyası gibi yazılmaz. Her satır komutun gerçek görevini açıklar.

Kötü tablo dili:

| Komut | Açıklama |
|---|---|
| `IF` | Koşul için kullanılır. |
| `FOR` | Döngü için kullanılır. |
| `FUNCTION` | Fonksiyon için kullanılır. |

Bu tablo doğru gibi görünür ama okuyucuya neredeyse hiçbir şey öğretmez.

İyi tablo dili:

| Komut | Syntax | Görev | Birlikte Kullanılır |
|---|---|---|---|
| `IF` | `IF koşul THEN ... END IF` | Koşulu değerlendirir ve program akışını doğru/yanlış kollarına ayırır. | `THEN`, `ELSEIF`, `ELSE`, `END IF` |
| `FOR` | `FOR i = ilk TO son STEP adım` | Sayısal sayaçla tekrarlı işlem kurar; `NEXT` satırında sayaç ilerler. | `TO`, `STEP`, `NEXT`, diziler |
| `FUNCTION` | `FUNCTION ad(...) AS tip ... END FUNCTION` | Parametre alıp değer döndüren adlandırılmış işlem bloğu kurar. | `RETURN`, `AS`, `BYVAL`, `BYREF` |

Bu ikinci tabloda her satır farklı bir bilgi verir. Kitap boyunca kullanılacak tablo dili budur.
