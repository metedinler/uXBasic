Evet, **UBASIC'teki eksik matematiksel kavramları uXBasic'e kazandırmak iyi fikir.** Ama hepsini çekirdek veri tipi yapmak gerekmiyor. Kütüphane kullanmak da x64 assembly üretimini bozmak zorunda değil.

Asıl mesele **kütüphanenin nasıl tasarlandığı**.

## Üç farklı yol var

### 1. Tam çekirdek tip

Örneğin uXBasic'e doğrudan:

```basic
DIM r AS RATIONAL
DIM z AS COMPLEX
```

eklersek derleyici bunları baştan sona bilir:

```text
Lexer/Parser
    ↓
Tip sistemi
    ↓
AST
    ↓
MIR
    ↓
MIR-x64
    ↓
NASM x64
```

Örneğin:

```basic
z3 = z1 + z2
```

MIR seviyesinde:

```text
COMPLEX_ADD z3, z1, z2
```

olabilir ve x64 arka ucu gerçek assembly üretebilir.

Bu en yüksek performans potansiyelini verir ama **derleyiciyi şişirir**. RATIONAL, COMPLEX, POLYNOMIAL, MATRIX, VECTOR derken matematik kütüphanesini derleyicinin içine gömmeye başlarız. İnsanlık bu yolu daha önce defalarca denedi; sonunda derleyici buzdolabı büyüklüğüne geliyor.

---

## 2. Sıradan kütüphane

Örneğin:

```basic
IMPORT uxmathx

DIM a AS Rational
DIM b AS Rational
DIM c AS Rational

c = RationalAdd(a, b)
```

x64 üretirken:

```text
CALL RationalAdd
```

üretilebilir.

Bu da **native x64'tür**.

Yani kütüphane kullanılması:

> “Assembly üretilemez.”

anlamına gelmez.

Tam tersine çıktı şöyle olabilir:

```asm
lea rcx, [a]
lea rdx, [b]
lea r8,  [c]
call ux_rational_add
```

Burada uXBasic programının kendisi x64 assembly'dir. Yalnız rasyonel toplama yordamı kütüphanededir.

DLL kullanıyorsak DLL çağrılır. Statik bağlama yapabiliyorsak nesne kodu programa bağlanır.

---

# 3. Bence uXBasic için asıl güçlü çözüm: çekirdek + yerel tip kütüphanesi

Bizim mevcut `TYPE/CLASS`, `MAGIC`, operatörler ve ilerideki sağlam ABI sistemi burada çok işe yarayabilir.

Mesela kütüphane:

```basic
TYPE RATIONAL
    Numerator AS BIGINT
    Denominator AS BIGINT
END TYPE
```

tanımlasın.

Ve:

```basic
OPERATOR +(a AS RATIONAL, b AS RATIONAL) AS RATIONAL
    ...
END OPERATOR
```

gibi bir mekanizmayla:

```basic
c = a + b
```

yazabilelim.

Derleyici bunu başlangıçta:

```text
RATIONAL.operator+(a,b)
```

çağrısına indirger.

Sonra MIR:

```text
CALL rational_add
```

üretir.

MIR-x64 da:

```asm
call rational_add
```

üretir.

**Assembly üretiminde hiçbir temel sorun yok.**

---

# Ama bundan daha iyisini yapabiliriz

uXBasic'in kendi kütüphaneleri uXBasic ile yazılabiliyorsa:

```basic
FUNCTION RationalAdd(...)
    ...
END FUNCTION
```

ve bu fonksiyon da MIR'e indirgenebiliyorsa, linker aşamasında onu programa dahil edebiliriz.

O zaman:

```basic
c = a + b
```

şöyle bir yol izler:

```text
a + b
 ↓
RATIONAL OPERATOR +
 ↓
RationalAdd(a,b)
 ↓
canonical MIR
 ↓
MIR-x64
 ↓
NASM
 ↓
native makine kodu
```

Yani matematiksel tip **kütüphanede tanımlanmış olmasına rağmen bütün program native assembly'ye dönüşebilir.**

İşte benim tercih edeceğim model bu.

---

# Daha da ileri: INLINE

18.09 kaynak incelememizde uXBasic'te `INLINE(...) ... END INLINE` yüzeyinin bulunduğunu görmüştük.

Bu da özel durumlarda kütüphaneye doğrudan NASM gövdesi koyma fırsatı verir.

Örneğin kavramsal olarak:

```basic
FUNCTION ComplexAdd(...)
    INLINE("x64")
        ; NASM kodu
    END INLINE
END FUNCTION
```

Böylece çok kritik matematiksel işlemlerde doğrudan optimize edilmiş x64 kodu kullanılabilir.

Fakat bunu varsayılan yöntem yapmazdım. Yoksa kütüphane kısa sürede taşınabilirliğini kaybeder.

---

# COMPLEX özel bir örnek

Mesela:

```basic
TYPE COMPLEX64
    Real AS F64
    Imag AS F64
END TYPE
```

olsun.

İki karmaşık sayının toplamı:

$$
(a+bi)+(c+di)=(a+c)+(b+d)i
$$

Derleyicinin bunun için özel bir `COMPLEX_ADD` komutuna ihtiyacı **yok**.

Kütüphane:

```basic
FUNCTION ComplexAdd(a AS COMPLEX64, b AS COMPLEX64) AS COMPLEX64
```

tanımlar.

MIR bunu normal F64 işlemlerine indirebilir:

```text
F64_ADD a.Real, b.Real
F64_ADD a.Imag, b.Imag
```

MIR-x64 ise uygun x64/SSE işlemlerini üretir.

Hatta ileride iyileştirici bunu tanıyıp iki işlemi daha verimli hale getirebilir.

Bu noktada kütüphane kullanmış olmamız performans cezası olmak zorunda değildir.

---

# POLYNOMIAL farklı

Polinom:

```basic
DIM p AS POLYNOMIAL
```

sabit boyutlu basit bir makine tipi değildir.

İçinde örneğin:

```text
degree
coefficientCount
coefficients pointer
coefficientType
```

bulunabilir.

Dolayısıyla bunu derleyici çekirdeğine gömmek bana gereksiz geliyor.

Kütüphane tipi çok daha doğru:

```basic
p = Polynomial(...)
q = Polynomial(...)

r = p * q
```

Derleyici:

```text
p * q
 ↓
PolynomialMul(p,q)
 ↓
CALL
```

üretebilir.

Bunun assembly açısından hiçbir sakıncası yok.

---

# RATIONAL da ilginç

Örneğin:

```basic
DIM r AS RATIONAL

r = 1 / 3
```

Burada sorun assembly değil, **sözdizimi ve tip çıkarımı**.

Çünkü normal:

```basic
1 / 3
```

derleyici tarafından I32 veya başka bir sayısal işlem olarak değerlendirilirse sonuç `RATIONAL` olmaz.

Bunun için:

```basic
r = RATIONAL(1,3)
```

kolaydır.

Ama UBASIC benzeri:

```basic
r = 1 / 3
```

davranışı istiyorsak derleyicinin bağlamdan:

```text
hedef tip = RATIONAL
```

olduğunu görüp işlemi rasyonel bölmeye dönüştürmesi gerekir.

İşte burada **çekirdek desteği** gerekir.

Ama RATIONAL'ın bütün matematiğinin çekirdekte olması gerekmez.

Bu ayrım çok değerli.

---

# Ben uXBasic'i üç katmanlı yapardım

### Katman 1: Fiziksel çekirdek tipleri

Derleyicinin gerçekten bilmesi gerekenler:

```text
BOOL

I8 U8
I16 U16
I32 U32
I64 U64

F32
F64
F80
F128

PTR
STRPTR
WSTRPTR

STRING
```

Bunların:

* boyutu,
* hizalaması,
* yazmaç kullanımı,
* ABI davranışı,
* bellek gösterimi

derleyici tarafından bilinmeli.

### Katman 2: Geniş sayısal çekirdek

Mevcut:

```text
BIGINT
BIGF
BIGD
BALL
```

gibi türlerin çalışma zamanı desteği olabilir.

Bunlar tek CPU komutuna dönüşmek zorunda değil.

Örneğin:

```basic
c = a * b
```

bir BIGINT çarpmasıysa:

```asm
call __ux_bigint_mul
```

üretmek tamamen normaldir.

### Katman 3: Matematiksel tip kütüphaneleri

Buraya:

```text
RATIONAL
COMPLEX
POLYNOMIAL

MATRIX
VECTOR

QUATERNION
INTERVAL
FRACTION

MODINT
MODPOLY
```

gibi yapıları koyardım.

Bunlar `TYPE/CLASS + MAGIC/OPERATOR + MODULE` üzerinden gerçek dil tipi gibi görünür.

---

## Sonra derleyici iyileştirmesi devreye girer

İşte burası uXBasic açısından daha ilginç.

İlk sürüm:

```basic
c = a + b
```

↓

```asm
call complex_add
```

olsun.

Daha sonra iyileştirici görsün:

```text
complex_add
    yalnız dört F64 alanına erişiyor
    yan etkisi yok
    küçük fonksiyon
```

ve fonksiyon çağrısını kaldırıp kodu doğrudan yerleştirsin:

```text
CALL yok
↓
işlem doğrudan çağıran fonksiyonun içine
```

Sonuç yine saf native kod.

Yani mimari:

```text
        uXBasic çekirdeği
              │
       fiziksel tip sistemi
              │
       genişletilebilir TYPE
              │
    MAGIC / OPERATOR / GENERIC
              │
 ┌────────────┼─────────────┐
 │            │             │
RATIONAL   COMPLEX      POLYNOMIAL
 │            │             │
 └────────────┼─────────────┘
              ↓
        canonical MIR
              ↓
        MIR iyileştirici
              ↓
          MIR-x64
              ↓
            NASM
```

olabilir.

## Bunun UBASIC'ten daha genel bir sonucu olur

UBASIC:

> “Rasyonel, karmaşık ve polinom benim dilimin özel matematiksel tipleridir.”

diyor.

uXBasic ise:

> “Bunları tanımlayabilecek kadar güçlü bir **tip genişletme sistemi** benim dilimin özelliğidir.”

diyebilir.

Bu çok daha önemli.

Çünkü yarın biri:

```text
MATRIX
TENSOR
QUATERNION
DECIMAL128
DUAL
AUTODIFF
UNIT<METER>
COLOR
VECTOR3
```

eklemek istediğinde tekrar derleyici kaynak kodunu değiştirmemiz gerekmez.

**Assembly üretiminde de temel bir engel oluşmaz.** Kritik koşul, kütüphane tiplerinin bellek yerleşiminin ve çağrı sözleşmesinin derleyici tarafından açık biçimde bilinmesi ve mümkünse uXBasic kütüphane gövdelerinin canonical MIR'e indirilebilmesidir.

Bu nedenle UBASIC'ten alacağımız en değerli şey tek tek `RATIONAL`, `COMPLEX`, `POLYNOMIAL` tipleri olmayabilir. **uXBasic'e bu tipleri ve gelecekte henüz düşünmediğimiz tipleri doğal operatörlerle ekleyebilecek bir “birinci sınıf kütüphane tipi” mekanizması kazandırmak daha büyük hedef olur.** Bu da mevcut `TYPE/CLASS`, `MAGIC`, `MODULE`, MIR ve x64 mimarimizin doğal devamı.
