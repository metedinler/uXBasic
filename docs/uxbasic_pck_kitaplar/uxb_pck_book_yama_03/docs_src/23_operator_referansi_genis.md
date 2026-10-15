# Operatör Referansı: İfade Kurma, Öncelik ve Logic16

Operatörler, programın düşünme biçimini kurar. Değişkenler değer taşır; operatörler bu değerler arasında ilişki kurar. `a + b` bir toplama ifadesidir, `sicaklik > 22` bir karar ifadesidir, `izin AND sicaklikUygun` iki şartı birleştirir, `maske SHL 1` bitleri sola kaydırır. Bu yüzden operatör bölümü yalnız işaret listesi değildir; ifade kurma dersidir.

uXBasic operatör sözleşmesinde büyük öncelik değeri daha sıkı bağlanır. Örneğin çarpma toplama işleminden önce gelir; üs alma sağdan bağlanır; atama ailesi en düşük önceliklerden birine sahiptir. `=` işareti bağlama duyarlıdır: sol taraf değişkense atama, koşul ifadesinde ise eşitlik karşılaştırması olarak yorumlanır. Kanonik eşitlik karşılaştırması için `==` yazımı da tanınır ve karşılaştırma anlamına bağlanır.

## Aritmetik operatörler

| Operatör | Görev | Örnek |
|---|---|---|
| `+` | İki sayıyı toplar veya uygun bağlamda metinleri birleştirme yüzeyine katılır. | `a + b` |
| `-` | Çıkarma yapar; tekli kullanımda sayının işaretini değiştirir. | `a - b`, `-a` |
| `*` | Çarpma yapar. | `a * b` |
| `/` | Bölme yapar. | `a / b` |
| `\` | Tam sayı bölme yüzeyi olarak kullanılır. | `a \ b` |
| `%`, `MOD` | Bölmeden kalanı üretir. | `a MOD b` |
| `**` | Üs alma operatörüdür; sağdan bağlanır. | `2 ** 3` |

Örnek:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a + b
PRINT a - b
PRINT a * b
PRINT a MOD b
```

Beklenen çıktı:

```text
17
7
60
2
```

Bu örnekte operatörler yalnız sonuç üretmez; aynı zamanda `PRINT` komutuna ifade verir. `PRINT a + b` satırında önce ifade çözülür, sonra sonuç yazdırılır.

## Karşılaştırma operatörleri

Karşılaştırma operatörleri karar yapılarının temelidir. `IF`, `WHILE`, `UNTIL`, `ASSERT` ve benzeri yapılar bu ifadelerin sonucuna göre akışı seçer.

| Operatör | Görev |
|---|---|
| `=`, `==` | İki değerin eşit olup olmadığını karşılaştırır. `==` açık karşılaştırma yazımıdır. |
| `<>`, `!=` | İki değerin farklı olup olmadığını karşılaştırır. |
| `<` | Sol değer sağ değerden küçük mü diye bakar. |
| `<=` | Sol değer sağ değerden küçük veya eşit mi diye bakar. |
| `>` | Sol değer sağ değerden büyük mü diye bakar. |
| `>=` | Sol değer sağ değerden büyük veya eşit mi diye bakar. |

Örnek:

```basic
DIM sicaklik AS I32 = 24

IF sicaklik > 22 THEN
    PRINT "Yuksek"
ELSE
    PRINT "Normal"
END IF
```

Beklenen çıktı:

```text
Yuksek
```

Burada `>` operatörü yalnız iki sayıyı kıyaslamaz; programın hangi kola gideceğini belirler.

## Mantıksal ve bit düzeyi operatörler

`AND`, `OR`, `NOT` ve `XOR` hem koşul ifadelerinde hem de bit düzeyi düşünmede önemlidir. Koşulda `AND`, iki şartın birlikte doğru olmasını ister. Bit düzeyinde ise iki sayının aynı konumdaki açık bitlerini sonuçta bırakır.

```basic
DIM izin AS I32 = 1
DIM sicaklikUygun AS I32 = 1

IF izin AND sicaklikUygun THEN
    PRINT "Sistem baslat"
ELSE
    PRINT "Bekle"
END IF
```

Beklenen çıktı:

```text
Sistem baslat
```

Bit işlemi örneği:

```basic
DIM a AS I32 = 12
DIM b AS I32 = 5

PRINT a AND b
PRINT a OR b
PRINT a XOR b
PRINT a SHL 1
PRINT a SHR 1
```

Bu örnekte `AND`, `OR`, `XOR`, `SHL` ve `SHR` sayıları bit desenleri gibi ele alır. Genç programcı için bu bölüm önemlidir: bilgisayar sayıları yalnız onluk sistemde değil, bit düzeyinde de işler.

## Kaydırma ve döndürme

| Operatör | Görev |
|---|---|
| `SHL`, `<<` | Bitleri sola kaydırır; küçük sayılarda çoğu zaman ikiyle çarpma etkisi verir. |
| `SHR`, `>>` | Bitleri sağa kaydırır; küçük pozitif sayılarda ikiye bölme etkisi verir. |
| `ROL` | Bitleri sola döndürme yüzeyidir. |
| `ROR` | Bitleri sağa döndürme yüzeyidir. |

Örnek:

```basic
DIM x AS I32 = 8
PRINT x SHL 1
PRINT x SHR 1
```

Beklenen çıktı:

```text
16
4
```

## Logic16 ailesi

uXBasic operatör yüzeyinde klasik `AND`, `OR`, `NOT`, `XOR` ailesinin yanında Logic16 ailesi de yer alır. Bu aile, mantıksal ilişkiyi daha geniş bir doğruluk tablosu olarak düşünmek isteyen kullanıcı içindir.

| Operatör | Görev |
|---|---|
| `NAND` | `AND` sonucunun tersini üretir. |
| `NOR` | `OR` sonucunun tersini üretir. |
| `XNOR` | `XOR` sonucunun tersidir; iki değer aynıysa doğru kabul edilir. |
| `IMP` | Mantıksal gerektirme yüzeyidir. |
| `CIMP` | Ters yönlü gerektirme yüzeyidir. |
| `NIMP` | Gerektirmeme yüzeyidir. |
| `NCIMP` | Ters gerektirmeme yüzeyidir. |
| `IDA` | Birinci girdinin kimlik yüzeyidir. |
| `IDB` | İkinci girdinin kimlik yüzeyidir. |
| `NOTA` | Birinci girdinin tersini alır. |
| `NOTB` | İkinci girdinin tersini alır. |

Bu aile özellikle yapay zekâ, karar motoru, kural tablosu ve mantıksal devre düşüncesi için değerlidir. Kitapta Logic16, yalnız “ek operatörler” diye değil, programı doğruluk tablosu gibi düşünme tekniği olarak anlatılır.

Örnek karar fikri:

```basic
DIM a AS I32 = 1
DIM b AS I32 = 0

PRINT a NAND b
PRINT a NOR b
PRINT a XNOR b
```

## Pipe ve üçlü koşul

`|>` operatörü, bir değeri sonraki işlem zincirine aktarma fikrini temsil eder. Bu operatör kitapta akışlı düşünme bölümünde anlatılır. `?:` ise üçlü koşul ifadesi yüzeyidir; koşula göre iki değerden birini seçme fikrini taşır.

Syntax fikri:

```basic
sonuc = kosul ? dogruDeger : yanlisDeger
```

Bu yüzey, kısa karar ifadeleri için kullanılır. Büyük karar ağaçlarında `IF ... THEN ... ELSE ... END IF` daha okunaklıdır.

## Atama operatörleri

Atama operatörleri değeri değiştirir. Bu yüzden karşılaştırma operatörlerinden ayrıdır.

| Operatör | Anlamı |
|---|---|
| `=` | Sol taraftaki değişkene sağ taraftaki değeri atar. |
| `+=` | Değişkeni sağdaki değer kadar artırır. |
| `-=` | Değişkeni sağdaki değer kadar azaltır. |
| `*=` | Değişkeni sağdaki değerle çarpar. |
| `/=` | Değişkeni sağdaki değere böler. |
| `%=`, `\=` | Kalan veya tam bölme ailesi atamasına bağlanır. |
| `<<=`, `>>=` | Bit kaydırma sonucunu aynı değişkene yazar. |
| `**=` | Üs alma sonucunu aynı değişkene yazar. |

Örnek:

```basic
DIM toplam AS I32 = 10

toplam += 5
toplam *= 2

PRINT toplam
```

Beklenen çıktı:

```text
30
```

Bu örnek, `toplam = toplam + 5` ve `toplam = toplam * 2` biçimlerinin kısa yazımıdır.

## Operatör öncelik özeti

| Öncelik | Aile |
|---:|---|
| 150 | Alan erişimi, çağrı, indeks, postfix artırım/azaltım |
| 140 | Üs alma `**` |
| 130 | Tekli operatörler, `NOT`, işaret değiştirme |
| 120 | Çarpma, bölme, tam bölme, `MOD` |
| 110 | Toplama ve çıkarma |
| 100 | Kaydırma ve döndürme |
| 90 | Karşılaştırma |
| 80 | Bit `&` yüzeyi |
| 70 | `XOR` |
| 60 | Bit `|` yüzeyi |
| 50 | `AND`, `NAND`, `NIMP`, `NCIMP` |
| 45 | `XNOR` |
| 40 | `OR`, `NOR`, `IMP`, `CIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| 30 | Pipe `|>` |
| 20 | Üçlü koşul `?:` |
| 10 | Atama ailesi |

Bu tablo, ifade okurken hangi parçanın önce bağlanacağını gösterir. Fakat kitapta yalnız tabloya güvenilmez; her önemli operatör ailesi örnekle gösterilir.
