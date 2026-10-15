# uXBasic Programlama Kuralları

_Bu belge otomatik üretilir (`tools/kitap/kural_belgesi_uret.py`). Amaç: uXBasic kodu yazan kişinin ve yerel kodlayıcı modelin (uxcoder)
dilin kurallarını, her yapının **çalışan** yazımını ve bilinen sınırları tek yerde görmesi._

## 0. Okuma kuralları (kanıt işaretleri)

- **[DOĞRULANDI]** — örnek AST yorumlayıcı, MIR yorumlayıcı ve native x64'te çalıştırıldı, çıktısı beklenenle birebir aynı.
- **[HEDEF]** — tasarım belgesinde var, ama çalıştırılarak doğrulanmadı. Yeni kodda güvenme.
- **[YOK / SINIR]** — denendi, çalışmıyor ya da motorlar arasında farklı. Bölüm 17'de listelidir.
- Bu belge ile `docs/tasarim/uXBasic_Hedeflenen_Sistem_ve_Kullanma_Kilavuzu_TR_2026-09-24 (1).md` arasında fark varsa **bu belge doğrudur**
  (kılavuz hedef tasarımdır; farklar Bölüm 16'dadır).

## 1. Temel kurallar (Mete'nin kesin kuralları)

1. **Tip adları:** `I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BIGINT BIGF BIGD BALL BOOLEAN STRING WSTRING`.
   **`LONG`, `INTEGER`, `DOUBLE`, `SINGLE`, `BYTE` adları ve `$ # % ! &` tip son ekleri uXBasic'te YOKTUR.** (`LEFT$` değil `LEFT`, `CHR$` değil `CHR`.)
2. **Tip dönüştürme tip adıyla yapılır:** `I8(x)`, `U8(x)`, `I32(x)`, `F32(x)`. Klasik `CINT CLNG CDBL CSNG FIX INT` de vardır.
3. **Büyük/küçük harf ayrımı yok.** Tip adları ve değişken adları aynı ad alanındadır (`CLASS K` varken `DIM k` hata).
4. **`TRUE = -1`, `FALSE = 0`.** Karşılaştırma sonucu doğruysa `-1` yazdırılır.
5. **`^` üs değil XOR'dur;** üs alma `**`'dır.
6. **Satır sonu deyim ayırıcıdır;** `:` ile aynı satıra birden çok deyim yazılabilir.
7. **Aynı program her motorda aynı sonucu vermelidir** (AST yorumlayıcı, MIR yorumlayıcı, native x64; ayrıca JS/WASM hedefleri).
8. Yorum satırı `'` ile başlar.

## 2. Program yapısı

Üst düzey deyimler doğrudan çalışır; istenirse giriş noktası `MAIN ... END MAIN` bloğudur:

```basic
FUNCTION Kare(x AS I32) AS I32
    RETURN x * x
END FUNCTION

MAIN
    PRINT "selam"
    PRINT Kare(3)
END MAIN
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
selam
9
```

Yordamlar:

```basic
SUB Selam(ad AS STRING)
    PRINT "Merhaba " + ad
END SUB
FUNCTION Kare(n AS I32) AS I32
    RETURN n * n
END FUNCTION
Selam("Ayse")
PRINT Kare(5)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
Merhaba Ayse
25
```

- `BYVAL` kopya verir, `BYREF` asıl değişkeni verir:

```basic
SUB Arttir(BYVAL x AS I32, BYREF y AS I32)
    x = x + 10
    y = y + 10
END SUB
DIM a AS I32 = 1
DIM b AS I32 = 1
Arttir(a, b)
PRINT "a="; a; " b="; b
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
a=1 b=11
```

- `CALL` ile yordam çağrısı, `DECLARE` ile ileri bildirim, özyineleme desteklenir, `STATIC` yerel değişken çağrılar arasında değerini korur:

```basic
SUB Yaz(n AS I32)
    PRINT "cagrildi"; " "; n
END SUB
CALL Yaz(3)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
cagrildi 3
```

```basic
DECLARE FUNCTION Iki(x AS I32) AS I32
PRINT Iki(4)
FUNCTION Iki(x AS I32) AS I32
    RETURN x * 2
END FUNCTION
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
8
```

```basic
FUNCTION Fakt(n AS I64) AS I64
    IF n <= 1 THEN RETURN 1
    RETURN n * Fakt(n - 1)
END FUNCTION
PRINT Fakt(5)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
120
```

```basic
SUB Say()
    STATIC n AS I32
    n = n + 1
    PRINT n
END SUB
Say()
Say()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1
2
```

- Dizi parametresi:

```basic
FUNCTION Topla(a AS I32[]) AS I32
    DIM t AS I32 = 0
    DIM i AS I32
    FOR i = LBOUND(a) TO UBOUND(a)
        t = t + a(i)
    NEXT i
    RETURN t
END FUNCTION
DIM d(0 TO 2) AS I32
d(0) = 1
d(1) = 2
d(2) = 3
PRINT Topla(d)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
6
```

## 3. Değişken, sabit, dizi

```basic
CONST PI_YAKLASIK = 3.14
PRINT PI_YAKLASIK
DIM d(0 TO 1) AS I32
d(0) = 7
REDIM PRESERVE d(0 TO 2) AS I32
d(2) = 9
PRINT d(0); " "; d(1); " "; d(2)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3.14
7 0 9
```

```basic
DIM d(2 TO 5) AS I32
PRINT LBOUND(d); " "; UBOUND(d)
DIM m(0 TO 1, 0 TO 2) AS I32
m(1, 2) = 9
PRINT m(1, 2)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2 5
9
```

Üst düzeyde bildirilen değişken aynı dosyadaki rutinlerden okunup yazılabilir (**`DIM SHARED` sözdizimi yoktur**):

```basic
DIM sayac AS I32 = 5

SUB Say()
    PRINT sayac
    sayac = sayac + 1
END SUB

Say()
PRINT sayac
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
5
6
```

Tipler:

```basic
DIM e AS I32 = 2147483647
DIM f AS U32 = 4294967295
DIM g AS I64 = 9223372036854775807
PRINT e; " "; f
PRINT g
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2147483647 4294967295
9223372036854775807
```

```basic
DIM a AS I8 = 1
DIM b AS U8 = 2
DIM c AS I16 = 3
DIM d AS U16 = 4
PRINT a; " "; b; " "; c; " "; d
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1 2 3 4
```

```basic
DIM a AS F32 = 2.5
DIM b AS F64 = 0.1
PRINT a
PRINT b
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2.5
0.1
```

```basic
DIM u AS U64 = 18446744073709551615
PRINT u
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
18446744073709551615
```

```basic
DIM x AS F80
x = 1.5
PRINT x
PRINT SIZEOF(F80)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1.5
10
```

```basic
DIM s AS STRING = "uXBasic"
DIM b AS BOOLEAN = TRUE
PRINT s
PRINT b
b = FALSE
PRINT b
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
uXBasic
-1
0
```

`DEFINT/DEFLNG/DEFSNG/DEFDBL/DEFSTR` harf aralığına göre örtük tip verir; bildirimsiz değişken de kullanılabilir:

```basic
DEFINT A, B
a = 7
b = a + 5
PRINT b
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
12
```

```basic
a = 7
PRINT a + 5
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
12
```

## 4. Operatörler

```basic
PRINT 10 + 3; " "; 10 - 3; " "; 10 * 3
PRINT 10 / 4
PRINT 10 \ 3; " "; 10 MOD 3
PRINT 10 ** 3
PRINT 2 ^ 10
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
13 7 30
2.5
3 1
1000
8
```

```basic
PRINT (3 = 3); " "; (3 <> 3); " "; (2 < 3); " "; (2 > 3); " "; (3 <= 3); " "; (4 >= 3)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
-1 0 -1 0 -1 -1
```

```basic
PRINT 6 AND 5; " "; 6 OR 5; " "; 6 XOR 5; " "; NOT 0
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
4 7 3 -1
```

```basic
PRINT 6 NAND 5; " "; 6 NOR 5; " "; 6 XNOR 5; " "; 6 EQV 5; " "; 6 IMP 5
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
-5 -8 -4 -4 -3
```

```basic
DIM b AS I32 = 0
IF b <> 0 ANDALSO 10 \ b > 1 THEN
    PRINT "bolundu"
ELSE
    PRINT "guvenli"
END IF
IF b = 0 ORELSE 10 \ b > 1 THEN PRINT "tamam"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
guvenli
tamam
```

```basic
PRINT 1 SHL 3; " "; 16 SHR 3
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
8 2
```

```basic
DIM x AS I32 = 10
x += 5
PRINT x
x -= 3
PRINT x
x *= 2
PRINT x
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
15
12
24
```

```basic
PRINT &HFF
PRINT &B101
PRINT &O17
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
255
5
15
```

```basic
PRINT -7 MOD 3; " "; -7 \ 2
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
-1 -3
```

```basic
PRINT "abc" < "abd"; " "; "b" > "a"; " "; "x" = "x"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
-1 -1 -1
```

## 5. Akış denetimi

```basic
DIM i AS I32
DIM x AS I32
FOR i = 1 TO 3
    x = 30 - i * 10
    IF x > 15 THEN
        PRINT "buyuk"
    ELSEIF x > 5 THEN
        PRINT "orta"
    ELSE
        PRINT "kucuk"
    END IF
NEXT i
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
buyuk
orta
kucuk
```

Tek satırlık `IF ... THEN a ELSE b` (S-083 düzeltmesinden sonra yalnız seçilen dal çalışır; düzeltmeden önceki derleyicilerde iki dal da çalışırdı):

```basic
DIM a AS I32 = 7
IF a > 0 THEN PRINT "pozitif"
IF a = 0 THEN PRINT "sifir" ELSE PRINT "sifir-degil"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
pozitif
sifir-degil
```

```basic
DIM n AS I32
FOR n = 1 TO 9 STEP 2
    SELECT CASE n
        CASE 1
            PRINT "bir"
        CASE 2, 3
            PRINT "iki-uc"
        CASE IS > 8
            PRINT "buyuk"
        CASE ELSE
            PRINT "bilinmeyen"
    END SELECT
NEXT n
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
bir
iki-uc
bilinmeyen
bilinmeyen
buyuk
```

```basic
DIM i AS I32
FOR i = 9 TO 1 STEP -8
    SELECT CASE i
        CASE IS > 5
            PRINT "buyuk"
        CASE ELSE
            PRINT "kucuk"
    END SELECT
NEXT i
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
buyuk
kucuk
```

```basic
DIM n AS I32 = 5
SELECT CASE n
    CASE 4 TO 6
        PRINT "aralik"
    CASE ELSE
        PRINT "disari"
END SELECT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
aralik
```

```basic
DIM ad AS STRING
ad = "elma"
SELECT CASE ad
    CASE "elma", "armut"
        PRINT "meyve"
    CASE ELSE
        PRINT "sebze"
END SELECT
ad = "pirasa"
SELECT CASE ad
    CASE "elma", "armut"
        PRINT "meyve"
    CASE ELSE
        PRINT "sebze"
END SELECT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
meyve
sebze
```

Döngüler:

```basic
DIM i AS I32
FOR i = 1 TO 5 STEP 2
    PRINT i; " ";
NEXT i
PRINT
FOR i = 10 TO 1 STEP -3
    PRINT i; " ";
NEXT i
PRINT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1 3 5
10 7 4 1
```

```basic
DIM t AS I32 = 0
DIM i AS I32 = 0
WHILE i < 5
    i = i + 1
    t = t + i
WEND
PRINT t
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
15
```

```basic
DIM k AS I32 = 0
DO WHILE k < 3
    k = k + 1
LOOP
PRINT "a="; k
k = 0
DO UNTIL k >= 3
    k = k + 1
LOOP
PRINT "b="; k
k = 0
DO
    k = k + 1
LOOP WHILE k > 5
PRINT "c="; k
k = 0
DO
    k = k + 1
LOOP UNTIL k = 3
PRINT "d="; k
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
a=3
b=3
c=1
d=3
```

```basic
DIM v AS I32
DIM i AS I32
FOR EACH v, i IN 10, 20, 30
    PRINT i; ":"; v
NEXT
DIM t AS I32 = 0
DIM u AS I32
DO EACH u IN 4, 5, 6
    t = t + u
LOOP
PRINT "toplam="; t
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
0:10
1:20
2:30
toplam=15
```

**FOR EACH ile DO EACH aynı şey değildir** (docs/tasarim, 23.09 sistem kararları §13):

- `FOR EACH` **anlık görüntü** (snapshot) alır: virgüllü listedeki bütün ifadeler gövde çalışmadan ÖNCE değerlendirilir.
- `DO EACH` **canlıdır** (JIT): her ifade sırası gelince değerlendirilir; önceki turda yapılan değişiklik sonraki ifadede görünür.

```basic
DIM a AS I32 = 10
DIM x AS I32
FOR EACH x IN a, a + 5, a + 20
    PRINT x
    a = 100
NEXT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
10
15
30
```

```basic
DIM a AS I32 = 10
DIM x AS I32
DO EACH x IN a, a + 5, a + 20
    PRINT x
    a = 100
LOOP
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
10
105
120
```

Metin üzerinde `FOR EACH c, i IN s` kod noktası kod noktası gezer, `i` 0 tabanlı sıradır (bayt ya da JS UTF-16 birimi değil):

```basic
DIM s AS STRING = "abc"
DIM c AS STRING
DIM i AS I32
FOR EACH c, i IN s
    PRINT i; ":"; c
NEXT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
0:a
1:b
2:c
```

**Kural [KARARLI]:** virgüllü `IN` listesi yalnız **skaler değer listesidir** (`IN 10, 20, 30` ya da `IN a, a + 5`). Dizi/koleksiyon/metin
kaynağı adlarını virgülle birleştirmek (`FOR EACH x IN a, b`, burada a ve b dizi) derleme hatasıdır:
`FOR EACH: a is a array; a comma-separated EACH list holds scalar values only` (test: `tests/iterators/neg_each_two_arrays.uxb`).
Çok kaynaklı gezinti gelecekte açık iterator işlevleriyle gelecektir: `CHAIN(a, b)` ve `ZIP(a, b)` **[HEDEF, S-135 — henüz yok]**.
Tek kaynak: `FOR EACH v IN a` dizi, STRING/WSTRING, LIST, DICT, SET üzerinde çalışır.

```basic
DIM t AS I32 = 0
DIM i AS I32
FOR i = 1 TO 5
    t = t + i
    IF i = 3 THEN EXIT FOR
NEXT i
PRINT "for="; t
DIM j AS I32 = 0
DO
    j = j + 1
    IF j = 3 THEN EXIT DO
LOOP
PRINT "do="; j
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
for=6
do=3
```

```basic
DIM i AS I32
FOR i = 1 TO 5
    IF i = 3 THEN CONTINUE
    PRINT i
NEXT i
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1
2
4
5
```

```basic
DIM a AS I32 = 12
IF a > 0 THEN
    PRINT "girdi"
    EXIT IF
    PRINT "gorunmez"
END IF
PRINT "bitti"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
girdi
bitti
```

```basic
PRINT "bas"
GOTO atla
PRINT "gorunmez"
atla:
PRINT "son"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
bas
son
```

```basic
PRINT "once"
GOSUB alt
PRINT "sonra"
END
alt:
PRINT "altyordam"
RETURN
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
once
altyordam
sonra
```

## 6. Metin ve matematik işlevleri

```basic
DIM s AS STRING = "uXBasic"
PRINT LEN(s)
PRINT MID(s, 3, 3)
PRINT INSTR(s, "Ba")
PRINT INSTR(s, "zz")
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
7
Bas
3
0
```

```basic
DIM s AS STRING = "uXBasic"
PRINT LEFT(s, 2)
PRINT RIGHT(s, 3)
PRINT UCASE(s)
PRINT LCASE(s)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
uX
sic
UXBASIC
uxbasic
```

```basic
PRINT STR(42)
PRINT VAL("40") + 7
PRINT CHR(65)
PRINT ASC("B")
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
42
47
A
66
```

```basic
PRINT HEX(255)
PRINT OCT(8)
PRINT BIN(5)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
FF
10
101
```

```basic
DIM s AS STRING = "  ab  "
PRINT "["; LTRIM(s); "]"
PRINT "["; RTRIM(s); "]"
PRINT "["; SPACE(3); "]"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
[ab  ]
[  ab]
[   ]
```

```basic
DIM s AS STRING = "n=" + STR(5)
PRINT s
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
n=5
```

```basic
PRINT STRING(3, "ab")
PRINT STRING(3, 65)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
aaa
AAA
```

```basic
PRINT ABS(-5); " "; SGN(-2)
PRINT INT(-2.5); " "; FIX(-2.5)
PRINT SQR(16)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
5 -1
-3 -2
4
```

```basic
PRINT SIN(0); " "; COS(0); " "; TAN(0)
PRINT ATN(1)
PRINT EXP(1)
PRINT LOG(1)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
0 1 0
0.7853981633974483
2.718281828459045
0
```

```basic
PRINT CINT(2.6)
PRINT CLNG(3.5)
PRINT CDBL(5) / 2
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3
4
2.5
```

```basic
PRINT IFF(3 > 2, 10, 20)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
10
```

```basic
RANDOMIZE 7
DIM r AS F64 = RND(1)
PRINT (r >= 0) AND (r < 1)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
-1
```

## 7. Kayıtlar, yapılar, sayımlar, koleksiyonlar

```basic
TYPE NOKTA
    X AS I32
    Y AS I32
END TYPE
DIM p(0 TO 2) AS NOKTA
DIM i AS I32
FOR i = 0 TO 2
    p(i).X = (i + 1) * 10
    p(i).Y = (i + 1) * 3
NEXT i
PRINT p(0).X; " "; p(0).Y
PRINT p(2).X
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
10 3
30
```

```basic
TYPE Nokta
    x AS I32
    y AS I32
END TYPE

TYPE Cizgi
    a AS Nokta
    b AS Nokta
END TYPE

DIM c AS Cizgi
c.a.x = 3
c.a.y = 4
PRINT c.a.x; " "; c.a.y
PRINT c.a.x + c.a.y
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3 4
7
```

```basic
STRUCT Vec2 ABI C
    x AS F32
    y AS F32
END STRUCT
UNION Bitler ABI C
    tam AS U64
    ondalik AS F64
END UNION
STRUCT Paket ABI C PACK 1
    etiket AS U8
    deger AS U32
END STRUCT
PRINT SIZEOF(Vec2); " "; OFFSETOF(Vec2, "y")
PRINT SIZEOF(Bitler)
PRINT SIZEOF(Paket)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
8 4
8
5
```

```basic
ENUM Renk
    KIRMIZI
    YESIL
END ENUM
PRINT Renk.KIRMIZI; " "; Renk.YESIL
ENUM Kod
    TAMAM = 1
    HATA = 5
END ENUM
PRINT Kod.HATA
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
0 1
5
```

```basic
DIM l AS LIST
LISTADD(l, 10)
LISTADD(l, 20)
LISTADD(l, 30)
PRINT LISTLEN(l)
PRINT LISTGET(l, 1)
DIM v AS I32
DIM i AS I32
FOR EACH v, i IN l
    PRINT i; ":"; v
NEXT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3
20
0:10
1:20
2:30
```

```basic
DIM d AS DICT
DICTSET(d, 1, 10)
DICTSET(d, 2, 20)
PRINT DICTLEN(d)
PRINT DICTGET(d, 2)
PRINT DICTHAS(d, 1)
PRINT DICTHAS(d, 9)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2
20
-1
0
```

```basic
DIM s AS SET
SETADD(s, 5)
SETADD(s, 7)
SETADD(s, 5)
PRINT SETLEN(s)
PRINT SETHAS(s, 7)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2
-1
```

## 8. Sınıflar ve nesneler

```basic
CLASS KUTU
    DIM X AS I32
    METHOD Iki() AS I32
        RETURN X * 2
    END METHOD
END CLASS
DIM b AS KUTU = NEW KUTU()
b.X = 33
PRINT b.X
PRINT b.Iki()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
33
66
```

```basic
CLASS Sayac
    PUBLIC
    DIM n AS I32
    CONSTRUCTOR()
        PRINT "kuruldu"
        n = 5
    END CONSTRUCTOR
    DESTRUCTOR()
        PRINT "silindi"
    END DESTRUCTOR
END CLASS
DIM s AS Sayac = NEW Sayac()
PRINT s.n
DELETE s
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
kuruldu
5
silindi
```

```basic
CLASS Hayvan
    PUBLIC
    VIRTUAL METHOD Ses() AS STRING
        RETURN "..."
    END METHOD
END CLASS
CLASS Kopek EXTENDS Hayvan
    PUBLIC
    OVERRIDE METHOD Ses() AS STRING
        RETURN "hav"
    END METHOD
END CLASS
DIM k AS Kopek = NEW Kopek()
PRINT k.Ses()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
hav
```

```basic
INTERFACE IHesap
    METHOD Calis(x AS I32) AS I32
END INTERFACE
CLASS Ikiye IMPLEMENTS IHesap
    PUBLIC
    METHOD Calis(x AS I32) AS I32
        RETURN x * 2
    END METHOD
END CLASS
DIM h AS Ikiye = NEW Ikiye()
PRINT h.Calis(7)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
14
```

```basic
CLASS Kutu
    PUBLIC
    PROPERTY Deger AS I32 GET SET
END CLASS
DIM k AS Kutu = NEW Kutu()
k.Deger = 3
PRINT k.Deger
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3
```

```basic
CLASS Kasa
    PRIVATE
    METHOD Gizli() AS I32
        RETURN 5
    END METHOD
    PUBLIC
    METHOD Ac() AS I32
        RETURN THIS.Gizli()
    END METHOD
END CLASS
DIM k AS Kasa = NEW Kasa()
PRINT k.Ac()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
5
```

**MAGIC metotları** `MAGIC ADI(...) ... END MAGIC` biçimindedir (`END METHOD` ile kapanmaz). Operatör aşırı yükleme `OPERATOR +` ile değil `MAGIC ADD(other)` ile yapılır:

```basic
CLASS Sayi
    PUBLIC:
    DIM v AS I32
    MAGIC ADD(other AS Sayi) AS Sayi
        DIM r AS Sayi = NEW Sayi()
        r.v = v + other.v
        RETURN r
    END MAGIC
END CLASS

DIM a AS Sayi = NEW Sayi()
DIM b AS Sayi = NEW Sayi()
DIM c AS Sayi = NEW Sayi()
a.v = 1
b.v = 3
c = a + b
PRINT c.v
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
4
```

```basic
CLASS Nokta
    PUBLIC:
    DIM x AS I32
    DIM y AS I32
    MAGIC TOSTRING() AS STRING
        RETURN "(" + STR(x) + "," + STR(y) + ")"
    END MAGIC
END CLASS

DIM p AS Nokta = NEW Nokta()
p.x = 1
p.y = 2
PRINT STR(p)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
(1,2)
```

## 9. Modül, ad alanı, ALIAS, kütüphane

```basic
MODULE Hesap
    FUNCTION Topla(A AS I32, B AS I32) AS I32
        RETURN A + B
    END FUNCTION
END MODULE
USING Hesap
MAIN
    PRINT Topla(3, 4)
END MAIN
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
7
```

```basic
NAMESPACE ns
    DIM nv AS I32
END NAMESPACE
FUNCTION F(x AS I32) AS I32
    RETURN ns.nv + x
END FUNCTION
ns.nv = 5
PRINT F(1)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
6
```

```basic
MODULE MathTools
    FUNCTION Square(x AS I32) AS I32
        RETURN x * x
    END FUNCTION
END MODULE

ALIAS MT = MathTools
PRINT MT.Square(3)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
9
```

**Kütüphane kullanımı:** kütüphane `INCLUDE "include/modules/<ad>.uxmh"` ile eklenir, işlevleri kütüphane adıyla (ad alanı) çağrılır:

```basic
INCLUDE "include/modules/uxsystem.uxmh"

MAIN
    ASSERT uxsystem.CpuCount() > 0
    PRINT "tamam"
END MAIN
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
tamam
```

### Birinci sınıf kütüphane tipleri [KARARLI tasarım, kısmen uygulandı]

uXBasic çekirdeği küçük kalır; `RATIONAL`, `COMPLEX`, `POLYNOMIAL`, `MATRIX`, `TENSOR`, `DATAFRAME` gibi tipler çekirdeğe gömülmez, **manifest/registry
sözleşmesiyle** gelir: yerleşim, operatörler (`ADD SUB MUL DIV EQ NE LT LE GT GE`), MAGIC davranışları (`TOSTRING CLONE HASH ITER`), dönüşümler, yaşam
döngüsü (`storage_model / copy_model / clone_model / drop_model`), ABI ve hedef sağlayıcıları (MIR, JS, WASM, native). `c = a + b` iki `RATIONAL` için
tamsayı toplama değil `CALL RATIONAL.ADD(a, b)` olarak indirilir. Kaynakta `LIBTYPE "ad.library_type.json"` ile manifest yüklenir. Durum: referans `RATIONAL`
**yalnız MIR yorumlayıcıda** çalışır (`tests/library_type_contract`); JS/WASM/native sağlayıcıları ve genel CLONE/RETAIN/DROP **[HEDEF]**. `r = 1 / 3`
`RATIONAL` oluşturmaz (sayısal bölme olur); güvenli yazım `RATIONAL(1, 3)` biçimidir. Bir görev sınırından geçiş `taskTransfer / threadSafety /
sharedPolicy` alanlarına bağlıdır (varsayılan FORBID).

## 10. Dış kütüphane çağrıları: CALL(DLL, ...) ve CALL(API, ...)

Gerçek yazım (kılavuzdaki kısa biçim DEĞİL):

`CALL(DLL, "dosya.dll", "işlev", DÖNÜŞ_TİPİ, ÇAĞRI_KURALI, "ARGÜMAN_TİPLERİ", argüman1, argüman2, ...)`

- `DÖNÜŞ_TİPİ`: `I32`, `I64`, `U64`, `F64`, `PTR` gibi bir tip adı. `ÇAĞRI_KURALI`: `CDECL` ya da `STDCALL`.
- `"ARGÜMAN_TİPLERİ"`: tek metin içinde virgülle (`"STRPTR,PTR"`, `"STRPTR,U64"`); `STRPTR` metin göstericisi, `PTR` gösterici.

```basic
PRINT CALL(DLL, "ucrtbase.dll", "strlen", U64, CDECL, "STRPTR", "uXBasic")
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
7
```

```basic
PRINT CALL(DLL, "ucrtbase.dll", "strtod", F64, CDECL, "STRPTR,PTR", "2.5", 0)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
2.5
```

```basic
DIM bad AS I32
bad = CALL(DLL, "kernel32.dll", "IsBadStringPtrA", I32, STDCALL, "STRPTR,U64", "abc", 3)
IF bad = 0 THEN PRINT "tamam"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
tamam
```

`CALL(API, "kütüphane", "işlev", DÖNÜŞ_TİPİ)` biçimi API sağlayıcı yoluyla çağırır:

```basic
DIM t AS I32
t = CALL(API, "kernel32", "GetTickCount", I32)
IF t >= 0 THEN PRINT "ok"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
ok
```

## 11. Hata yönetimi

```basic
TRY
    PRINT "deneme"
    THROW 7
CATCH
    PRINT "yakalandi"
FINALLY
    PRINT "hep"
END TRY
PRINT "bitti"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
deneme
yakalandi
hep
bitti
```

```basic
DIM x AS I64 = 0
SUB Patla()
    x += 1
    THROW 9
END SUB
TRY
    Patla()
CATCH
    PRINT "yakalandi"
END TRY
PRINT x
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
yakalandi
1
```

```basic
DIM a AS I32 = 5
ASSERT a = 5
ASSERT a > 0
PRINT "gecti"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
gecti
```

## 12. Olay, boru, iş parçacığı, görev, eşzamanlılık

```basic
EVENT VeriGeldi
    PRINT "olay calisti"
END EVENT
SLOT
    Kaydet 5 ON EVENT VeriGeldi
END SLOT
TRIGGER VeriGeldi
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
olay calisti
```

```basic
EVENT VeriGeldi(x AS I32)
    PRINT x
END EVENT
SLOT
    Kaydet 5 ON EVENT VeriGeldi
END SLOT
TRIGGER VeriGeldi, 42
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
42
```

```basic
PIPE Ikile(value AS I32) AS I32
    RETURN value * 2
END PIPE
TRIGGER PIPE Ikile, 21
PRINT TASKOUT
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
42
```

```basic
DIM g AS I32
THREAD T1(x AS I32)
    g = g + x
END THREAD
TRIGGER T1, 5
PRINT g
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
5
```

```basic
THREAD Is(x AS I32)
    PRINT "w "; x
END THREAD

TRIGGER THREAD Is, 100
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
w 100
```

`SPAWN` bir THREAD/PARALEL'i görev olarak başlatır; `TASK OF tip` sonuç tipini bildirir; `JOIN()` sonucu alır:

```basic
THREAD Is(x AS I32) AS I32
    RETURN x * 2
END THREAD
DIM t AS TASK OF I32 = SPAWN Is(21)
PRINT t.JOIN()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
42
```

```basic
PARALEL Kare(x AS I32)
    RETURN x * x
END PARALEL

DIM a AS TASK = SPAWN Kare(3)
DIM b AS TASK = SPAWN Kare(4)
DIM c AS TASK = SPAWN Kare(5)
PRINT a.JOIN()
PRINT b.JOIN()
PRINT c.JOIN()
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
9
16
25
```

```basic
DIM ATOMIC toplam AS I64 = 0
THREAD Isci(n AS I64) AS I64
    DIM i AS I64
    FOR i = 1 TO n
        toplam.ADD(1)
    NEXT i
    RETURN n
END THREAD
DIM g AS TASKGROUP
DIM k AS I64
FOR k = 1 TO 3
    g.ADD(SPAWN Isci(10000))
NEXT k
g.JOIN()
PRINT toplam
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
30000
```

**SLOT ile TASK aynı şey değildir [KARARLI]:** `SLOT` 0..255 arası **256 sabit bağlama noktasıdır** (adı, türü, hedefi, ON/OFF durumu); çalışan
görev değildir. Her `SPAWN`/`TRIGGER` ayrı bir **çalışma örneği (TaskRun)** üretir ve `TASK` bu örneğin opak tutamacıdır (sayı ya da PTR
değildir: `t = t + 1` yasak). 10.000 SPAWN 10.000 işletim sistemi iş parçacığı demek değildir; çalışma zamanı sınırlı bir işçi havuzu kullanır.
Her çalışmanın kendi sonucu ve hatası vardır; `TASK OF T` sonucun statik tipini bildirir (tipsiz `TASK` sonucu `OBJECT` olur).
`EVENT / PIPE / THREAD / PARALEL / SLOT / TRIGGER` aynen korunur; `SPAWN / TASK / TASKGROUP` bunların üstüne çalışma örneği katmanı ekler.

**Ortak veri — Model D (Mete'nin kesin kararı, 2026-09-26) [KARARLI]:** normal global/modül/STATIC değişkenler görevlerde **kullanılabilir**;
tek deyimlik ortak erişim **otomatik senkronizedir** (kullanıcı LOCK yazmaz). İki görev `toplam += x` yaparsa sonuç her motorda kesindir:

```basic
DIM toplam AS I64 = 0

THREAD Ekle(x AS I32)
    toplam += x
END THREAD

DIM a AS TASK = SPAWN Ekle(10)
DIM b AS TASK = SPAWN Ekle(20)
a.JOIN()
b.JOIN()
PRINT toplam
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
30
```

`LOCK a, b ... END LOCK` yalnız **birden çok deyimin birlikte bölünmez olması** içindir ve **transaction değildir** (hata olursa yapılan yazmalar geri
alınmaz). Kilitler `lockOrderId` sırasıyla alınır, ters sırada bırakılır; aynı kilidi ikinci kez açıkça LOCK etmek `SELF_DEADLOCK` hatasıdır:

```basic
DIM a AS I64 = 1
DIM b AS I64 = 2

THREAD Degistir(x AS I32)
    LOCK a, b
        a = a + 2
        b = b + 5
    END LOCK
END THREAD

DIM t AS TASK = SPAWN Degistir(0)
t.JOIN()
PRINT a; " "; b
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3 7
```

Diğer kurallar: `MUTEX` yalnız dış kaynak/programcı tanımlı kritik bölge içindir; `UNSAFE ... END UNSAFE` yalnız ham adres ve sözleşmesiz FFI
güvencelerini o bölgede kaldırır; görev zincirinde **`END` yasaktır** (RETURN/THROW/sonuç kullanılır); bekleme çevrimi `TASK_WAIT_CYCLE` hatasıdır;
LOCK içinde `JOIN/WAIT` bloklaması yasaktır. Yorumlayıcılarda görevler SPAWN anında çalıştırılabilir: **görevler arası çıktı sırası dil garantisi
değildir**, sıra gerekiyorsa `JOIN` kullan. Legacy AST-x64 bu yapıları açık tanıyla reddeder. Henüz uygulanmayanlar (yerel `SHARED`, `BYSHARED`,
`MOVE/CLONE`, JOINALL LIST) **[HEDEF]**: "henuz uygulanmadi: S-146 adim N" tanısı verir.

Paylaşılan veri **`LOCK`**, **`MUTEX`**, **`DIM ATOMIC`** ile korunur (`DIM SHARED` sözdizimi henüz yoktur):

```basic
DIM x AS I64 = 0
LOCK x
    x += 100
END LOCK
LOCK x
    x += 1000
END LOCK
PRINT x
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1100
```

```basic
DIM m AS MUTEX
DIM sayac AS I64 = 0
THREAD Isci(n AS I64) AS I64
    DIM i AS I64
    DIM gecici AS I64
    FOR i = 1 TO n
        LOCK m
            gecici = sayac
            gecici = gecici + 1
            sayac = gecici
        END LOCK
    NEXT i
    RETURN n
END THREAD
DIM g AS TASKGROUP
g.ADD(SPAWN Isci(10000))
g.ADD(SPAWN Isci(10000))
g.JOIN()
PRINT sayac
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
20000
```

```basic
DIM ATOMIC sayac AS I64 = 0
sayac += 5
PRINT sayac.ADD(2)
PRINT sayac.SUB(1)
PRINT sayac.LOAD()
PRINT sayac.EXCHANGE(10)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
7
6
6
6
```

## 13. Bellek ve işaretçiler

```basic
DIM a AS I32 = 5
INC a
PRINT a
DEC a
PRINT a
PRINT SIZEOF(I32); " "; SIZEOF(F64)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
6
5
4 8
```

```basic
DIM X AS I64 = 99
DIM p AS PTR = VARPTR(X)
PRINT PEEKQ(p)
POKEQ p, 7
PRINT X
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
99
7
```

```basic
DIM x AS I64 = 6000
POKEB x, 65
POKEW x + 2, 4660
POKED x + 8, 305419896
MEMFILLB x + 16, 9, 3
MEMCOPYB x + 24, x + 16, 3
PRINT PEEKB(x)
PRINT PEEKW(x + 2)
PRINT PEEKD(x + 8)
PRINT PEEKB(x + 24)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
65
4660
305419896
9
```

**Ham `PTR` aritmetiği bayt tabanlıdır [KARARLI, S-071]:** `PTR + n` n bayt ilerler (`PTR + PTR` hata, `PTR - PTR` bayt farkı = I64). Dizi elemanının adresi
`taban + (indeks - LBOUND) * adım`tır; I32 dizisinde sonraki eleman `p + 4`'tür:

```basic
DIM a(1) AS I32
a(0) = 11
a(1) = 22
DIM p AS PTR = VARPTR(a)
PRINT PEEKD(p)
PRINT PEEKD(p + 4)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
11
22
```

Tasarım kararları: `PTR TO T` (tipli işaretçi, `p + 1` bir eleman ilerler) **[HEDEF, S-113 — henüz yok]**; F80'in gerçek veri boyutu 10 bayt, depolama adımı 16
(`SIZEOF(F80)` 10; ham PTR +1 bayt, tipli PTR +16); bellek çeşidi yalnız `VIRTUAL` ve `NATIVE`'dir, `EXTERNAL` bir bellek türü değil adresin
**kökenidir**; mod yazılmazsa PEEK/POKE için `PTR` kaynağı → NATIVE, düz sayısal adres → VIRTUAL.

## 14. Girdi/çıktı, dosya, ekran, süreç

```basic
PRINT 1, 2
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
1             2
```

```basic
OPEN "kitap_ornek.txt" FOR OUTPUT AS #1
PRINT #1, "merhaba"
CLOSE #1
DIM s AS STRING
OPEN "kitap_ornek.txt" FOR INPUT AS #2
INPUT #2, s
CLOSE #2
PRINT s
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
merhaba
```

```basic
OPEN "kitap_satir.txt" FOR OUTPUT AS #1
PRINT #1, "a"
PRINT #1, "b"
PRINT #1, "c"
CLOSE #1
DIM n AS I32 = 0
DIM s AS STRING
OPEN "kitap_satir.txt" FOR INPUT AS #1
DO WHILE NOT EOF(1)
    INPUT #1, s
    n = n + 1
LOOP
CLOSE #1
PRINT n; " satir"
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3 satir
```

```basic
CLS
COLOR 14, 1
LOCATE 2, 3
PRINT "renkli"
COLOR 7, 0
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
renkli
```

```basic
DIM cikti AS STRING
SHELL "cmd /c echo UXB" OUTVAR cikti
PRINT TRIM(cikti)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
UXB
```

## 15. Önişlemci (derleme zamanı)

Önişlemci yönergeleri `%%` ile başlar; kaynak derlemeden önce genişletilir:

```basic
%%DEFINE FLAG 1
%%IF FLAG
PRINT 99
%%ELSE
PRINT 0
%%ENDIF
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
99
```

```basic
%%DEFINE BASLANGIC 4
%%MACRO IKIKAT(X) X + X
DIM a AS I32 = BASLANGIC
a = IKIKAT(a)
PRINT a
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
8
```

```basic
%%FOR I = 1 TO 3
PRINT "x"
%%ENDFOR
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
x
x
x
```

**Tek önişlemci [KARARLI, docs/tasarim 24.09]:** eski A/B önişlemci ayrımı kalktı; bütün `%%` komutları tek komut uzayındadır. `%%PP A` / `%%PP B`
eski kaynak uyumluluğu için kabul edilir ama etkisizdir (`PREPROCESSOR_PP_DEPRECATED_NO_EFFECT`); yeni kodda yazma. Önişlemci kaynağı genişletir ve normal
derleyici kapılarından geçecek **normal uXBasic kaynağı** üretir. `%%FOREACH` listesi parantez içinde tırnaklı değerlerle yazılır (tek metin
`"A,B"` biçimi [HEDEF]):

```basic
%%FOREACH NAME IN ("A", "B")
PRINT "NAME {{NAME}}"
%%ENDFOREACH
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
NAME A
NAME B
```

```basic
%%FOREACH T IN ("I32", "F64")
FUNCTION Max_{{T}}(a AS {{T}}, b AS {{T}}) AS {{T}}
    IF a > b THEN RETURN a
    RETURN b
END FUNCTION
%%ENDFOREACH

PRINT Max_I32(3, 2)
PRINT Max_F64(2.5, 1.5)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
3
2.5
```

**`REM %%` meta komutları [KARARLI tasarım; ilk halka çalışıyor]:** ham `%%` komutlarından sonra, **önişlemci genişlemesinden sonra** toplanır ve AST/MIR
bildirimine bağlanır. Programın çalışma sonucunu değiştirmez. İki aile vardır: `REM %%ATTR <ad> [arg]` (programın ne olduğunu tanımlar: `TEST`, `DEPRECATED
"neden"`, `REFLECT`, `SERIALIZABLE`, `EXPORT JS`, `EXPORT WASM`, `ROUTE GET "/yol"`, `AUTHOR "ad"`) ve `REM %%MIR <politika> [değer]` (yalnız gerçekten tüketicisi
olan MIR/arka uç politikaları; tanınan ama uygulanmayan politika `META_MIR_POLICY_NOT_IMPLEMENTED` ile reddedilir). Sınır: `REM %%` geçmişi değiştirmez —
ham `%%` = kaynağı üretir, `REM %%ATTR` = oluşan programı tanımlar, `REM %%MIR` = arka uç politikasını verir.

```basic
REM %%ATTR TEST
FUNCTION Kare(x AS I32) AS I32
    RETURN x * x
END FUNCTION

PRINT Kare(3)
```
Çıktı **[DOĞRULANDI: AST, MIR, native x64]**:
```text
9
```

## 16. Tasarım kılavuzu ile gerçek arasındaki farklar

| Kılavuzda | Gerçekte (doğrulanmış) |
|---|---|
| `CALL(DLL, "mylib.dll", "f", a, b)` | `CALL(DLL, "mylib.dll", "f", DÖNÜŞ_TİPİ, ÇAĞRI_KURALI, "ARG_TİPLERİ", a, b)` (Bölüm 10) |
| `DIM SHARED x AS T` | Parser reddeder (`DIM: AS expected`); paylaşım `LOCK/MUTEX/ATOMIC` ile |
| `OPERATOR +(other) ... END OPERATOR` | `MAGIC ADD(other) ... END MAGIC` |
| `MAGIC ... END MAGIC` (kılavuzda doğru) / eski testlerde `END METHOD` | Yalnız `END MAGIC` geçerli; `END METHOD` parse hatası |
| `DIM t AS TASK` | `DIM t AS TASK OF I32 = SPAWN F(...)` (sonuç tipiyle); tipsiz `TASK` sonucu `OBJECT`tir |
| `PUBLIC:` (iki nokta) | Hem `PUBLIC` hem `PUBLIC:` kabul edilir |
| `%%FOREACH T IN "I32,F64"` (tek metin) | `%%FOREACH T IN ("I32", "F64")` (parantezli tırnaklı liste) |
| `DIM SHARED`, `LOCK x` ile `GUARDED BY` | Model D: global değişkenler zaten otomatik senkron; `LOCK a, b ... END LOCK` çok deyimli bölge için |

## 17. Bilinen sınırlar ve açık hatalar (uygulanmışmış gibi yazma)

Doğrulanamayan örnek yok.

## 18. Kod yazarken kontrol listesi

1. Tip adı listesi dışında tip kullandın mı? (`LONG/INTEGER/DOUBLE` yok.)
2. Sınıf değişkenini `DIM x AS Sinif = NEW Sinif()` biçiminde mi başlattın? (`DIM c AS Sinif = a + b` geçersiz: başlatıcı `NEW` olmalı.)
3. MAGIC bloğunu `END MAGIC` ile mi kapattın?
4. `CALL(DLL, ...)` içinde dönüş tipi, çağrı kuralı ve argüman tipleri metni var mı?
5. Kütüphane için `INCLUDE "include/modules/<ad>.uxmh"` ve `ad.İşlev(...)` biçimini kullandın mı?
6. Paylaşılan veriyi `LOCK`/`MUTEX`/`ATOMIC` ile mi koruyorsun?
7. `^` XOR'dur; üs için `**`.
8. Bir yapıyı bu belgede [DOĞRULANDI] işareti yoksa yeni kodda kullanmadan önce küçük bir örnekle sına.
