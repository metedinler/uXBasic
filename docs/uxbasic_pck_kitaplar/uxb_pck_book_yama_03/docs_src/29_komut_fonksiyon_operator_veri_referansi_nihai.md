# 29. Nihai Referans: Komut, Fonksiyon, Operatör, Veri Tipi ve Veri Yapısı

Bu bölüm hızlı başvuru için yazılmıştır; fakat kuru liste değildir. Her aile önce görevine göre açıklanır, sonra sözdizimi ve örnekle bağlanır. uXBasic kitabında referans bölümü, okuyucuyu örneksiz bırakmamalıdır.

## 29.1. Temel giriş, çıkış ve değişken ailesi

| Sözcük | Syntax | Görev | Kısa Örnek |
|---|---|---|---|
| `PRINT` | `PRINT ifade` | Ekrana veya hedef çıktıya değer yazar. `PRINT #` biçimi dosya kanalına yazar. | `PRINT "OK"` |
| `DIM` | `DIM ad AS tip` | Değişken, dizi veya nesne alanı açar. | `DIM x AS I32 = 10` |
| `AS` | `ad AS tip` | Değişkenin, parametrenin veya fonksiyon dönüşünün tipini bağlar. | `FUNCTION F() AS I32` |
| `CONST` | `CONST ad AS tip = değer` | Program boyunca değişmeyen sabit tanımlar. | `CONST LIMIT AS I32 = 100` |
| `REDIM` | `REDIM dizi(yeniBoyut)` | Dizi boyutunu yeniden kurar. | `REDIM veri(20)` |
| `LET` | `LET ad = ifade` | Atamayı açık biçimde yazar; modern kullanımda doğrudan `ad = ifade` de kullanılır. | `LET x = 5` |
| `INPUT` | `INPUT değişken` | Kullanıcıdan veya `INPUT #` ile dosyadan değer alır. | `INPUT yas` |

Temel örnek:

```basic id="6ur8u5"
CONST LIMIT AS I32 = 100
DIM okuma AS I32 = 76

IF okuma < LIMIT THEN
    PRINT "GUVENLI"
ELSE
    PRINT "LIMIT_ASILDI"
END IF
```

## 29.2. Akış kontrol ailesi

| Sözcük | Syntax | Görev | Birlikte Kullanılır |
|---|---|---|---|
| `IF` | `IF koşul THEN ... END IF` | Koşula göre program akışını kola ayırır. | `THEN`, `ELSEIF`, `ELSE` |
| `ELSEIF` | `ELSEIF koşul THEN` | İlk koşul yanlışsa yeni koşul dener. | `IF`, `ELSE`, `END IF` |
| `ELSE` | `ELSE` | Önceki koşulların hiçbiri doğru değilse çalışır. | `IF`, `ELSEIF` |
| `SELECT` | `SELECT CASE ifade` | Tek ifadeyi birçok olası duruma göre ayırır. | `CASE`, `CASE ELSE` |
| `CASE` | `CASE değer` | `SELECT` içinde eşleşme kolu açar. | `SELECT CASE` |
| `FOR` | `FOR i = a TO b STEP s` | Sayaçla tekrar eden döngü kurar. | `TO`, `STEP`, `NEXT` |
| `NEXT` | `NEXT i` | `FOR` döngüsünü ilerletir. | `FOR` |
| `DO` | `DO ... LOOP` | Koşullu veya koşulsuz döngü bloğu açar. | `LOOP`, `WHILE`, `UNTIL` |
| `WHILE` | `WHILE koşul` | Koşul doğru oldukça çalışır. | `WEND`, `DO` |
| `UNTIL` | `LOOP UNTIL koşul` | Koşul doğru olana kadar döngüyü sürdürür. | `DO`, `LOOP` |
| `EXIT` | `EXIT FOR`, `EXIT DO` | İçinde bulunulan döngü veya bloktan çıkar. | `FOR`, `DO`, `FUNCTION` |

Akış kontrolü yalnız karar vermek değildir; veri işleme düzenini kurar:

```basic id="h8wyxe"
DIM i AS I32
DIM toplam AS I32 = 0

FOR i = 1 TO 5
    toplam = toplam + i
NEXT i

IF toplam == 15 THEN
    PRINT "TOPLAM_DOGRU"
END IF
```

## 29.3. Fonksiyon ve çağrı ailesi

| Sözcük | Syntax | Görev |
|---|---|---|
| `FUNCTION` | `FUNCTION ad(parametreler) AS tip` | Değer döndüren adlandırılmış işlem bloğu kurar. |
| `SUB` | `SUB ad(parametreler)` | Değer döndürmeyen işlem bloğu kurar. |
| `RETURN` | `RETURN ifade` | Fonksiyondan değer döndürür veya bloktan çıkar. |
| `DECLARE` | `DECLARE FUNCTION ...` | Dış veya önceden bildirilecek fonksiyon imzasını tanımlar. |
| `CALL` | `CALL ad(...)`, `CALL(DLL,...)`, `CALL(API,...)` | Yerel, DLL veya API çağrı rotasını kullanır. |
| `BYVAL` | `BYVAL x AS tip` | Parametreyi değer olarak geçirir. |
| `BYREF` | `BYREF x AS tip` | Parametreyi referans/adres etkisiyle geçirir. |
| `CDECL` | `CDECL` | C çağrı düzeni bilgisini belirtir. |
| `STDCALL` | `STDCALL` | Windows API çağrı düzeni bilgisini belirtir. |

İç içe çağrı örneği:

```basic id="5pwrp3"
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

FUNCTION Mul(a AS I32, b AS I32) AS I32
    RETURN a * b
END FUNCTION

PRINT Add(Mul(2, 3), Add(4, 5))
```

Bu örnekte önce içteki çağrılar çözülür, sonra dıştaki `Add` çağrısı çalışır. AST bu yapıyı ağaç olarak taşır; MIR ise çağrı sırasını hedefe uygun ara temsil hâline getirir.

## 29.4. Operatör ailesi

| Aile | Operatörler | Görev |
|---|---|---|
| Aritmetik | `+`, `-`, `*`, `/`, `\`, `MOD`, `**` | Sayısal hesap yapar. |
| Karşılaştırma | `=`, `==`, `<>`, `!=`, `<`, `<=`, `>`, `>=` | İki değeri karşılaştırır. |
| Mantık | `AND`, `OR`, `NOT`, `XOR` | Koşul veya bit düzeyinde mantıksal işlem yapar. |
| Kaydırma | `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>` | Bitleri sola, sağa veya döndürerek taşır. |
| Logic16 | `NAND`, `NOR`, `XNOR`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` | Genişletilmiş mantık kapısı ailesidir. |
| Atama | `=`, `+=`, `-=`, `*=`, `/=`, `%=`, `<<=`, `>>=`, `**=` | Değişkene yeni değer bağlar. |
| Pipe | `|>` | Bir işlemin sonucunu sonraki işleme aktarma yüzeyi kurar. |
| Üçlü | `?:` | Kısa koşullu ifade kurar. |

Karşılaştırma notu önemlidir. `=` bağlama göre atama veya koşul eşitliği olarak görülebilir. Daha açık karşılaştırma için `==` kullanmak güvenlidir.

```basic id="h93g0w"
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1

IF a >= b THEN
    PRINT "A_BUYUK"
END IF
```

## 29.5. Veri tipi ailesi

| Tip | Görev | Kullanım |
|---|---|---|
| `I8`, `I16`, `I32`, `I64` | İşaretli tam sayı ailesidir. | Sayaç, miktar, indis |
| `U8`, `U16`, `U32`, `U64` | İşaretsiz tam sayı ailesidir. | Bayt, maske, pozitif sayaç |
| `F32`, `F64`, `F80`, `F128` | Kayan nokta ailesidir. | Ölçüm, oran, bilimsel hesap |
| `BIGI`, `BIGINT` | Büyük tam sayı yüzeyidir. | Uzun tam sayı hesapları |
| `BIGD`, `BIGF`, `BALL` | Geniş duyarlık / büyük ondalık yüzeyidir. | Para, hassas ölçüm, uzun hesap |
| `BOOLEAN` | Doğru/yanlış değeri taşır. | Koşul, bayrak |
| `STRING` | Metin taşır. | Ad, mesaj, dosya satırı |
| `OBJECT` | Nesne yüzeyi taşır. | Sınıf, dış bağlama, genel nesne |
| `PTR`, `STRPTR` | Adres ve metin işaretçisi yüzeyidir. | Dış fonksiyon, bellek işlemleri |

Örnek:

```basic id="8sy6xp"
DIM sayac AS I32 = 10
DIM ad AS STRING = "uXBasic"
DIM aktif AS BOOLEAN = TRUE

PRINT ad
PRINT sayac
```

## 29.6. Veri yapısı ailesi

| Yapı | Syntax | Görev |
|---|---|---|
| Dizi | `DIM a(10) AS I32` | Aynı tipten çoklu değerleri indeksle saklar. |
| `TYPE` | `TYPE Ad ... END TYPE` | Alanlardan oluşan kayıt tipi tanımlar. |
| `CLASS` | `CLASS Ad ... END CLASS` | Veri ve davranışı birlikte taşıyan nesne tipi kurar. |
| `INTERFACE` | `INTERFACE Ad ... END INTERFACE` | Davranış sözleşmesi tanımlar. |
| `ARRAY` | `ARRAY OF tip` | Koleksiyon tip yüzeyi olarak dizi ailesini belirtir. |
| `LIST` | `LIST OF tip` | Sıralı büyüyebilir liste yüzeyi kurar. |
| `DICT` | `DICT OF anahtar, değer` | Anahtar-değer eşleme yüzeyi kurar. |
| `SET` | `SET OF tip` | Benzersiz eleman kümesi yüzeyi kurar. |
| `MODULE` | `MODULE Ad ... END MODULE` | Büyük kodu modül başlığı altında toplar. |
| `NAMESPACE` | `NAMESPACE Ad ... END NAMESPACE` | İsim çakışmasını önleyen kapsam alanı kurar. |

`TYPE` örneği:

```basic id="rsaf7e"
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

DIM p AS Nokta
p.x = 12
p.y = 30

PRINT p.x + p.y
```

`CLASS` ve `MAGIC` örneği:

```basic id="o8qk6n"
CLASS Anahtar
    VALUE AS I32

    MAGIC HASH() AS I32
        RETURN VALUE + 100
    END MAGIC

    MAGIC ADD(other AS I32) AS I32
        RETURN VALUE + other
    END MAGIC
END CLASS
```

Burada `MAGIC`, sınıf içinde özel davranış sözleşmesi açar. Bu bölümde `MAGIC` sıradan fonksiyon adı gibi değil, nesne davranış kapısı olarak anlatılır.
