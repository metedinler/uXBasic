Bunu karşılaştırmak **çok faydalı**, çünkü UBASIC ile uXBasic aynı BASIC ailesinden geliyor ama tip sistemi açısından neredeyse iki farklı felsefeyi temsil ediyor.

Burada **UBASIC derken Yuji Kida'nın sayı teorisi için geliştirdiği UBASIC'i** esas alıyorum. Adam Dunkels'in gömülü sistemler için yaptığı küçük `uBASIC` yorumlayıcısı başka bir dil. Dunkels'in uBASIC'i yalnız tamsayı değişkenleri destekleyen çok küçük bir yorumlayıcıdır. ([GitHub][1]) Yuji Kida'nın UBASIC'i ise büyük tamsayılar, rasyonel sayılar, karmaşık sayılar ve polinomlarla sayı teorisine odaklanmıştır. ([CodeArchaeology][2])

## 1. İki dilin temel yaklaşımı

UBASIC'in tip sistemi şu soruya cevap vermek için büyümüş:

> **“Matematikte çok büyük ve farklı türde sayıları nasıl doğrudan kullanırım?”**

uXBasic'in tip sistemi ise giderek şu soruya cevap veriyor:

> **“Makine düzeyinden bilimsel hesaplamaya, DLL'den nesnelere kadar aynı dilde veriyi nasıl temsil ederim?”**

Bu nedenle UBASIC'in tip sistemi **matematiksel olarak derin**, uXBasic'inki ise **fiziksel temsil ve kullanım alanı bakımından çok daha geniş**.

---

# 2. Sayısal tipler

En belirgin fark burada.

| Alan                   | UBASIC                             | uXBasic 18.09                                 |
| ---------------------- | ---------------------------------- | --------------------------------------------- |
| Küçük tamsayı          | 16 bit kısa tamsayı                | `I8`, `U8`, `I16`, `U16`                      |
| 32 bit tamsayı         | Temel amacı bu değil               | `I32`, `U32`                                  |
| 64 bit tamsayı         | Temel amacı bu değil               | `I64`, `U64`                                  |
| Büyük tamsayı          | **Dilin temel özelliklerinden**    | `BIGINT`                                      |
| Tek duyarlıklı gerçek  | Matematiksel sayı sistemi farklı   | `F32`                                         |
| Çift duyarlıklı gerçek | Matematiksel sayı sistemi farklı   | `F64`                                         |
| 80 bit gerçek          | Yok/merkezi değil                  | `F80`                                         |
| 128 bit gerçek         | Yok/merkezi değil                  | `F128`                                        |
| Büyük gerçek sayı      | Çok uzun sabit noktalı sayılar     | `BIGF`, `BIGD`                                |
| Rasyonel sayı          | **Var**                            | Çekirdek tip olarak belirgin karşılığı yok    |
| Karmaşık sayı          | **Var**                            | Kütüphane/matematik sistemiyle karşılanabilir |
| Polinom                | **Birinci sınıf matematiksel tip** | Kütüphane/veri yapısı düzeyinde               |
| Modüler polinom        | Var                                | Doğrudan çekirdek tip değil                   |
| Aralık/top tipi        | Yok                                | `BALL` ailesi                                 |

UBASIC'in erken sürümlerinde 16 bit kısa değişkenler, programcının uzunluğunu belirleyebildiği uzun değişkenler ve sabit azami uzunluk kullanan özel değişkenler bulunuyordu. Sonraki sürümlerde kesin rasyonel sayılar, karmaşık sayılar, dizgiler ve tek değişkenli polinomlar eklendi. ([CodeArchaeology][2])

Burada UBASIC'in gerçekten çok güzel bir özelliği var:

**Sayının büyüklüğü ve hassasiyeti dil tasarımının merkezinde.**

Bu uXBasic açısından incelenmeye değer.

---

# 3. UBASIC'in ilginç `WORD` ve `POINT` yaklaşımı

UBASIC'te hassasiyet yalnız `DOUBLE` gibi birkaç sabit tipe bırakılmamış.

`WORD` ve `POINT` gibi ayarlarla büyük sayıların kullanılacağı alan kontrol edilebiliyor. Kaynaklara göre `WORD` büyük tamsayı kapasitesini, `POINT` ise sabit noktalı sayıların kesir kısmı için kullanılacak kapasiteyi belirliyor. ([CodeArchaeology][2])

Kavramsal olarak:

```text id="dfcy81"
WORD ...
POINT ...
```

ile:

> “Ben bundan sonraki hesaplarımda şu kadar büyük/hassas sayılarla çalışacağım.”

denebiliyor.

Bu, uXBasic'teki:

```basic id="3p1nxx"
DIM x AS F32
DIM y AS F64
DIM z AS F80
DIM q AS F128
DIM n AS BIGINT
```

yaklaşımından farklı.

### UBASIC

**Hesaplama alanının hassasiyetini belirle.**

### uXBasic

**Değişkenin fiziksel/mantıksal tipini belirle.**

uXBasic sistem programlamaya da yöneldiği için bizim yaklaşımımız gerekli. `I32` ile `I64` arasındaki fark yalnız hassasiyet değildir. Bellek genişliği, ABI, STRUCT yerleşimi, DLL çağrısı ve PEEK/POKE açısından da önemlidir.

---

# 4. UBASIC'in uXBasic'ten daha güçlü olduğu önemli alan: matematiksel tipler

Burada UBASIC'e hakkını vermek lazım.

Örneğin:

### Rasyonel sayı

Matematiksel olarak:

$$
\frac{1}{3}
$$

F64 kullanırsak yaklaşık:

```text id="1tkznn"
0.333333333333333...
```

saklarız.

Rasyonel tip kullanırsak:

```text id="klql1d"
pay   = 1
payda = 3
```

**tam olarak** saklanır.

Dolayısıyla:

$$
\frac13+\frac13+\frac13=1
$$

kesin olur.

UBASIC'in sonraki sürümleri kesin rasyonel aritmetiği doğrudan destekliyor. ([CodeArchaeology][2])

uXBasic açısından burada ciddi bir fikir var:

```basic id="sgl8l5"
DIM r AS RATIONAL
```

gibi bir tip teorik olarak `BIGINT` altyapısının üzerinde kurulabilir.

---

# 5. Karmaşık sayı da aynı şekilde

UBASIC karmaşık sayıları doğrudan matematiksel sisteminin parçası haline getirmiş. ([CodeArchaeology][2])

uXBasic'te bugün bunu kütüphane veya yapı üzerinden temsil etmek mümkün:

```basic id="ekmt0f"
TYPE Complex
    Real AS F64
    Imag AS F64
END TYPE
```

Ama bu:

```basic id="ntk0zv"
DIM z AS COMPLEX
```

ile aynı şey değil.

Çekirdek `COMPLEX` tipi olursa derleyici:

```basic id="wd3zlr"
c = a + b
d = a * b
```

işlemlerinin karmaşık sayı işlemleri olduğunu bilir.

Bizdeki `MAGIC`/operatör mekanizmasıyla bunu kullanıcı tanımlı tip üzerinden yapmak da mümkün hale getirilebilir. Dolayısıyla **UBASIC'in yaptığı şeyi mutlaka yeni çekirdek tip ekleyerek yapmak zorunda değiliz.**

Bu önemli bir mimari fark.

---

# 6. Polinom tipi daha da ilginç

UBASIC'in sayı teorisi kökeni burada iyice belli oluyor. Tek değişkenli polinomları ve farklı katsayı alanlarını destekleyen yapılar dilin matematiksel dünyasına dahil edilmiş. ([CodeArchaeology][2])

Örneğin matematiksel olarak:

$$
P(x)=3x^3+2x-7
$$

UBASIC bunu yalnızca:

```text id="01t15s"
ARRAY OF coefficients
```

olarak görmek zorunda değil.

**Polinom olarak biliyor.**

uXBasic açısından bu önemli bir tasarım dersi:

> Her şeyi çekirdeğe koymak yerine güçlü kullanıcı tanımlı tip + operatör + kütüphane sistemi oluşturursak aynı gücü daha genel biçimde sağlayabiliriz.

Örneğin gelecekte:

```basic id="5jdswv"
DIM p AS Polynomial<F64>
DIM q AS Polynomial<BIGINT>

r = p * q
```

gibi bir yapı, UBASIC'in fikrini daha genel hale getirir.

---

# 7. uXBasic'in UBASIC'i ezip geçtiği taraf: makine tipleri

Burada karşılaştırma tersine dönüyor.

uXBasic'te:

```text id="j8b5yd"
I8
U8
I16
U16
I32
U32
I64
U64

F32
F64
F80
F128
```

gibi fiziksel anlamı olan tipler bulunuyor.

Bunların önemi:

```basic id="gohq09"
DIM b AS U8
DIM port AS U16
DIM flags AS U32
DIM address AS U64
```

gibi kodlarda ortaya çıkıyor.

UBASIC'in amacı zaten donanım sürücüsü, DLL ABI'si veya bellek düzeni yazmak değildi. Sayı teorisi için yapılmıştı. ([Vikipedi][3])

uXBasic ise:

```basic id="ug6nwl"
PEEKB(...)
PEEKW(...)
PEEKD(...)
PEEKQ(...)
```

dediğinde **1, 2, 4 ve 8 baytlık fiziksel bellek işlemlerini** ayırabiliyor.

UBASIC'in tip felsefesinde böyle bir gereksinim merkezi değil.

---

# 8. Pointer sistemi

Burada fark artık uçurum.

UBASIC:

```text id="3ytsaz"
matematiksel değer
```

merkezli.

uXBasic:

```text id="ouby4m"
değer
+
fiziksel temsil
+
adres
+
bellek sınıfı
```

dünyasına doğru gidiyor.

uXBasic'te:

```text id="t8vnw2"
PTR
STRPTR
WSTRPTR
```

ve:

```basic id="k3kcvx"
VARPTR(x)
SADD(s)
PTR(n)
CASTPTR(n)
```

bulunuyor.

18.09 incelememizde `PTR / STRPTR / WSTRPTR` temelinin çalıştığını, asıl açık alanın gelecekteki birleşik `MemoryRef` köken/sahiplik modeli olduğunu görmüştük. 

UBASIC ile karşılaştırınca bu tamamen başka bir tip sistemi katmanı.

---

# 9. Veri yapısı tipleri

uXBasic burada modern bir dile çok daha yakın:

```text id="x6l8yg"
ARRAY
TYPE
STRUCT
UNION
CLASS
INTERFACE

LIST
DICT
SET
```

UBASIC'te diziler önemli olmakla birlikte dilin veri modeli uXBasic'teki nesne/veri yapısı çeşitliliğine sahip değil.

Özellikle:

```basic id="bl8d4s"
TYPE Point
    X AS F64
    Y AS F64
END TYPE
```

ve:

```basic id="69ur7u"
CLASS Particle
    ...
END CLASS
```

uXBasic'i yalnız matematiksel BASIC olmaktan çıkarıyor.

---

# 10. İki tip sistemini katmanlara ayırırsak

Asıl tablo bence bu:

| Katman                     |               UBASIC |                  uXBasic |
| -------------------------- | -------------------: | -----------------------: |
| Makine tamsayıları         |                Zayıf |            **Çok güçlü** |
| İşaretsiz tipler           |                Zayıf |            **Çok güçlü** |
| IEEE kayan nokta çeşitleri |     Sınırlı yaklaşım |                **Güçlü** |
| Çok büyük tamsayı          |        **Çok güçlü** |        Güçlü/hedeflenmiş |
| Keyfî hassasiyet           |        **Çok güçlü** |               BIG ailesi |
| Kesin rasyonel             |        **Çok güçlü** |                    Eksik |
| Karmaşık sayı              |     **Doğal destek** |           Kütüphane/yapı |
| Polinom                    | **Olağanüstü güçlü** |         Kütüphane düzeyi |
| Dizgi                      |                  Var |           **Daha geniş** |
| Pointer                    |    Yok/merkezi değil |                **Güçlü** |
| Fiziksel bellek            |                  Yok | **PEEK/POKE/MEMCOPY...** |
| STRUCT/UNION               |                  Yok |                  **Var** |
| Nesne tipi                 |                  Yok |                **CLASS** |
| Arayüz                     |                  Yok |            **INTERFACE** |
| Genel koleksiyonlar        |              Sınırlı |        **LIST/DICT/SET** |
| DLL/C ABI tipleri          |           Amaç değil |    **Temel hedeflerden** |
| Sanal bellek tipi/kökeni   |                  Yok |           Geliştiriliyor |

---

# 11. Fakat UBASIC'ten uXBasic'e alınabilecek çok değerli fikirler var

Ben burada **UBASIC'i taklit etmezdim**. Onun matematiksel tip yaklaşımını uXBasic'in mevcut mimarisine taşırdım.

Özellikle dört alan çok değerli:

1. **RATIONAL**
   Kesin kesir hesabı.

2. **COMPLEX**
   Özellikle GSL, FFT, sinyal işleme, bilimsel hesaplama için doğal.

3. **POLYNOMIAL**
   İstatistik, sayısal analiz, sembolik matematik ve sayı teorisi için.

4. **Hassasiyet denetimi**
   `BIGINT/BIGF/BIGD/F128` ailesinin hesaplama hassasiyetinin daha açık yönetilmesi.

Burada UBASIC'in tarihsel olarak çok büyük sayılar ve sayı teorisi için özelleştirilmiş olması özellikle öğretici. ([CodeArchaeology][2])

## uXBasic için daha büyük fikir

Bence doğrudan:

```text id="b6okhf"
RATIONAL
COMPLEX
POLYNOMIAL
```

diye üç yeni çekirdek tip eklemekten önce başka bir şeyi sorgulamalıyız:

**uXBasic'in tip sistemi kullanıcı tarafından genişletilebilir matematiksel tipleri gerçekten birinci sınıf vatandaş yapabiliyor mu?**

Örneğin ideal durumda:

```basic id="vgyl1b"
DIM a AS RATIONAL
DIM z AS COMPLEX
DIM p AS POLYNOMIAL
DIM n AS BIGINT

a = 1 / 3
z = COMPLEX(2, 3)

PRINT a
PRINT z
```

çalışırken bunların üçünün de derleyici çekirdeğine gömülmesi şart olmamalı.

Bizde geliştirdiğimiz:

```text id="q4qh4p"
TYPE / CLASS
MAGIC
GET / SET
TOSTRING
operatör aşırı yükleme
DLL
NAMESPACE
MODULE
```

mekanizmaları tam çalışır hale gelirse, **UBASIC'in matematiksel tip zenginliğini uXBasic'te genel bir “genişletilebilir tip sistemi” üzerinden kurabiliriz.**

Bu daha büyük kazanç olur.

UBASIC bize burada güzel bir ders veriyor: **tip sistemi yalnız RAM'de kaç bayt kapladığını söylememeli, verinin matematiksel anlamını da taşıyabilmeli.** uXBasic'in mevcut makine tipi zenginliğine bu katmanı eklemek, iki dünyanın güçlü taraflarını birleştirir.

[1]: https://github.com/adamdunkels/ubasic?utm_source=chatgpt.com "GitHub - adamdunkels/ubasic: The uBASIC interpreter · GitHub"
[2]: https://codearchaeology.dev/languages/ubasic/?utm_source=chatgpt.com "UBASIC | CodeArchaeology"
[3]: https://en.wikipedia.org/wiki/UBASIC?utm_source=chatgpt.com "UBASIC"
