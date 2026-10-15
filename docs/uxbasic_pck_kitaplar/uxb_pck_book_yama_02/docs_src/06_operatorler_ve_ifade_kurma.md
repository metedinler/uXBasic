# Operatörler ve İfade Kurma

Operatör, değerleri birbirine bağlayan küçük ama güçlü bir araçtır. `a + b` yalnız iki sayının toplamı değildir; AST içinde ikili ifade düğümü, MIR içinde işlem adımı, backend tarafında hedefe uygun hesap komutu demektir. uXBasic’te operatörler yalnız aritmetik değildir. Mantık, bit işlemi, karşılaştırma, atama, pipe ve üçlü seçim de ifade kurma yüzeyine dahildir.

## Aritmetik operatörler

| Operatör | Görev | Örnek |
|---|---|---|
| `+` | Toplama veya metin birleştirme bağlamı kurar. | `a + b` |
| `-` | Çıkarma veya negatif değer üretir. | `a - b`, `-x` |
| `*` | Çarpma yapar. | `a * b` |
| `/` | Bölme yapar. | `a / b` |
| `\` | Tam sayı bölme ailesinde kullanılır. | `a \ b` |
| `MOD` | Bölümden kalanı verir. | `a MOD b` |
| `**` | Üs alma yüzeyidir. | `a ** b` |

Project pack örneği:

```basic
DIM x AS I32 = 12
DIM y AS I32 = 5
PRINT x + y * 2
PRINT (x + y) * 2
PRINT x MOD y
```

Beklenen çıktı:

```text
22
34
2
```

İlk satırda çarpma toplama işleminden önce yapılır. İkinci satırda parantez önceliği değiştirir. Bu yüzden iki satır aynı sayıları kullandığı halde farklı sonuç verir.

## Mantık ve bit operatörleri

| Operatör | Görev | Örnek |
|---|---|---|
| `AND` | Koşulda iki tarafın da doğru olmasını ister; bit düzeyinde ortak 1 bitleri bırakır. | `izin AND uygun` |
| `OR` | Koşulda en az bir tarafın doğru olmasını ister; bit düzeyinde açık bitleri birleştirir. | `a OR b` |
| `XOR` | Yalnız bir tarafta açık olan bitleri bırakır. | `a XOR b` |
| `NOT` | Koşulu veya bit desenini tersler. | `NOT hazir` |
| `SHL` | Bitleri sola kaydırır; çoğu sayısal bağlamda ikiyle çarpma etkisi verir. | `a SHL 1` |
| `SHR` | Bitleri sağa kaydırır; çoğu sayısal bağlamda ikiye bölme etkisi verir. | `a SHR 1` |
| `ROL` | Bitleri sola döndürme yüzeyidir. | `a ROL 1` |
| `ROR` | Bitleri sağa döndürme yüzeyidir. | `a ROR 1` |

Örnek:

```basic
DIM x AS I32 = 12
DIM y AS I32 = 5
PRINT x AND y
PRINT x OR y
PRINT x XOR y
PRINT x SHL 1
PRINT x SHR 2
```

Beklenen çıktı:

```text
4
13
9
24
3
```

Bu örnek, operatörlerin yalnız matematik işlemi değil, bit düzeyinde düşünme aracı olduğunu gösterir. Bir bayrak sistemi, izin maskesi veya düşük seviye protokol çözümü yazarken bu aile önem kazanır.

## Eşitlik ve atama ayrımı

uXBasic’te `=` bağlama göre yorumlanır. Sol tarafta değişken varsa atama, koşul bağlamında karşılaştırma görevi görebilir. `==` ise eşitlik karşılaştırması için kanonik ve açık yazımdır.

```basic
DIM a AS I32 = 10

IF a == 10 THEN
    PRINT "ESIT"
END IF
```

Bu kitapta özellikle genç programcıya güvenli alışkanlık kazandırmak için koşul örneklerinde `==` kullanımı tercih edilir. BASIC uyumluluğu gereken yerde `=` koşul karşılaştırması olarak ayrıca açıklanır.
