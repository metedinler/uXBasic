# uXBasic Teknik Kitap (pek.md)

## 0. Amac ve Okuma Sekli

Bu dokumanin amaci, proje gercegini parser ve test kaynaklarindan cikartip tek yerde, celiskisiz ve sistematik halde sunmaktir.

Bu belge 4 ihtiyaci birlikte karsilar:
1. Projede nerede kalindigini netlestirir.
2. Mevcut dokumanlari elestirel ama yapici sekilde degerlendirir.
3. Komut, fonksiyon, operator, tip ve veri yapilarini syntax + ornek ile toplar.
4. Mimari, modul, degisken/tip ve artifact akislarini anlatir.

Notasyon:
- Durum etiketi: IMPLEMENTED / PARTIAL / PLANNED
- Katman etiketi:
  - LEXER: token tanima
  - PARSER: syntax kabul + AST
  - RUNTIME: calisan davranis

---

## 1. Projede Nerede Kalindik? (Durum Ozeti)

### 1.1 Su an tamamlanmis cekirdek

1. Lexer calisiyor (identifier/keyword/number/string/operator tokenlari).
2. Parser calisiyor (statement + expression + AST uretimi).
3. TYPE dogrulama post-pass aktif (unknown type kontrolu).
4. Interop resolver/emit calisiyor (INCLUDE/IMPORT grafi, dist artefactlari).
5. Timer runtime yardimcilari var.
6. Memory VM ve sinirli AST memory execution yolu var.
7. Legacy uyum adimlari eklendi:
   - GET/PUT icin handle sonrasi ek argumanlar (uyumluluk formu)
   - POKE alias (POKED semantigine map)

### 1.2 Hala tamamlanmamis alanlar

1. Tum dil icin genel runtime/interpreter yok.
2. Inline x64 backend semantikleri tamamlanmadi.
3. Pointer intrinsics (VARPTR/SADD/LPTR/CODEPTR) planli.
4. Gelismis memory komut ailesi (POKES, MEMCOPYW/D, MEMFILLW/D, SETNEWOFFSET) planli.
5. Dosya I/O ileri semantik standardizasyonu planli.

### 1.3 Kisa teknik sonuc

- Parser kapsami runtime kapsamini geciyor.
- "Parse olmasi" ile "calisan runtime davranisi" ayni sey degil.
- Proje su an parser-merkezli dogrulama asamasinda.

---

## 2. Mevcut Dokumanlara Elestirel Degerlendirme

### 2.1 ProgramcininElKitabi.md

Gozlem:
1. Icerik tekrarli, bazi bolumler append-only birikim etkisi tasiyor.
2. Tarihsel bilgi ile aktif parser gercegi yer yer karisiyor.
3. Bazi satirlar parserin bugunku davranisindan daha genis iddia ediyor.

Bilimsel degerlendirme:
- Pozitif: Tarihsel baglam ve kapsama niyeti guclu.
- Risk: Kaynak dogrulugu tek adimda okunamiyor; yeni katilimci icin girdi maliyeti yuksek.

### 2.2 ProgramcininElKitabi.standardized.md

Gozlem:
1. Cok daha sistematik bir cekirdek olusturuyor.
2. Parser gercegine daha yakin bir cizgide.
3. Fakat belirli kisimlarda bicim/icerik bozulmasi (karisik satirlar) var.

Bilimsel degerlendirme:
- Pozitif: Dogru yone gecis.
- Risk: Kismi corruption nedeniyle tek basina "nihai referans" olmaya henuz uygun degil.

### 2.3 Kod gercegi ile farkin kaynagi

Ana fark kaynagi su:
1. Dokumanlar tarihsel birikimle yazildi.
2. Parser ve test matrisi daha hizli evrildi.
3. Bu nedenle dokumanin tek kaynak olarak kalmasi zorlasti.

Sonuc:
- Bu pek.md, parser + test plani + runtime kodu uzerinden yeniden normalize edilmis referanstir.

---

## 3. Dil Cekirdegi: Lexer ve Parser Gercegi

### 3.1 Identifier kurali

Syntax:
- Baslangic: harf veya _
- Devam: harf/rakam/_
- Regex benzeri: [A-Za-z_][A-Za-z0-9_]*

Ornekler:
- Gecerli: player1, _tmp, score_total
- Gecersiz: x%, name$, 1abc

Not:
- Sonekli eski stil (x%, name$, vb.) strict profilde kabul edilmez.

### 3.2 String literal

Syntax:
- "..."
- Cift tirnak kacisi: "" (literal icinde tek tirnak karakteri)

Ornek:
```bas
PRINT "Merhaba"
PRINT "A""B"  ' A"B
```

### 3.3 Number literal

Syntax:
- Tamsayi: 42
- Ondalik: 3.14

Not:
- Hex/bin/octal literal parserda bu cekirdekte tanimli degil.

### 3.4 Yorum

Syntax:
- Tek satir yorum: '

Ornek:
```bas
PRINT 1 ' bu bir yorum
```

---

## 4. Statement Komut Referansi (Syntax + Ornek)

Bu bolum parser dispatch gercegine gore yazilmistir.

## 4.0 Atama ve ifade tabanli statementlar

### 4.0.1 Atama operatorleri

Durum: IMPLEMENTED (PARSER)

Syntax:
- ident = expr
- ident += expr
- ident -= expr
- ident *= expr
- ident /= expr
- ident \\= expr
- ident =+ expr
- ident =- expr

Ornek:
```bas
DIM x AS I32
x = 10
x += 5
x =- 2
```

### 4.0.2 Postfix inc/dec

Durum: IMPLEMENTED (PARSER)

Syntax:
- ident++
- ident--

Ornek:
```bas
DIM n AS I32
n++
n--
```

### 4.0.3 Keyword inc/dec

Durum: IMPLEMENTED (PARSER)

Syntax:
- INC ident
- DEC ident

Ornek:
```bas
DIM counter AS I32
INC counter
DEC counter
```

## 4.1 Kontrol akis komutlari

### IF

Durum: IMPLEMENTED (PARSER)

Syntax:
- IF expr THEN ... END IF
- IF expr THEN ... ELSEIF expr THEN ... ELSE ... END IF

Ornek:
```bas
IF score > 90 THEN
    PRINT "A"
ELSEIF score > 70 THEN
    PRINT "B"
ELSE
    PRINT "C"
END IF
```

### SELECT CASE

Durum: IMPLEMENTED (PARSER)

Syntax:
- SELECT CASE expr
  - CASE expr[, expr...]
  - CASE ELSE
  - END SELECT

Ornek:
```bas
SELECT CASE mode
CASE 0
    PRINT "Idle"
CASE 1, 2
    PRINT "Run"
CASE ELSE
    PRINT "Unknown"
END SELECT
```

### FOR

Durum: IMPLEMENTED (PARSER)

Syntax:
- FOR ident = expr TO expr [STEP expr] ... NEXT [ident]

Ornek:
```bas
DIM i AS I32
FOR i = 1 TO 10 STEP 2
    PRINT i
NEXT i
```

### DO LOOP

Durum: IMPLEMENTED (PARSER)

Syntax:
- DO ... LOOP
- DO WHILE expr ... LOOP
- DO UNTIL expr ... LOOP
- DO ... LOOP WHILE expr
- DO ... LOOP UNTIL expr

Ornek:
```bas
DIM i AS I32
i = 0
DO WHILE i < 3
    PRINT i
    i += 1
LOOP
```

### GOTO

Durum: IMPLEMENTED (PARSER)

Syntax:
- GOTO labelOrNumber

Ornek:
```bas
GOTO 100
```

### GOSUB

Durum: IMPLEMENTED (PARSER)

Syntax:
- GOSUB labelOrNumber

Ornek:
```bas
GOSUB InitBlock
```

### RETURN

Durum: IMPLEMENTED (PARSER)

Syntax:
- RETURN
- RETURN expr

Ornek:
```bas
RETURN
RETURN x + 1
```

### EXIT

Durum: IMPLEMENTED (PARSER)

Syntax:
- EXIT
- EXIT FOR
- EXIT DO

Ornek:
```bas
IF quitFlag THEN EXIT DO
```

### END

Durum: IMPLEMENTED (PARSER)

Syntax:
- END

Ornek:
```bas
END
```

## 4.2 Deklarasyon ve program yapisi komutlari

### CONST

Durum: IMPLEMENTED (PARSER)

Syntax:
- CONST name = expr [, name = expr ...]

Ornek:
```bas
CONST PI = 3.14159, MAXN = 1024
```

### DIM

Durum: IMPLEMENTED (PARSER)

Syntax:
- DIM name AS TYPE
- DIM name AS TYPE = expr
- DIM name(bounds) AS TYPE
- DIM name(lower TO upper, ...) AS TYPE

Ornek:
```bas
DIM a AS I32
DIM b AS F64 = 1.5
DIM arr(0 TO 9) AS I32
DIM grid(1 TO 3, 1 TO 3) AS I16
```

### REDIM

Durum: IMPLEMENTED (PARSER)

Syntax:
- REDIM name(bounds) AS TYPE [, ...]

Ornek:
```bas
REDIM arr(0 TO 99) AS I32
```

### TYPE

Durum: IMPLEMENTED (PARSER)

Syntax:
- TYPE Name
  - field AS TYPE
  - END TYPE

Ornek:
```bas
TYPE Vec2
    x AS I32
    y AS I32
END TYPE

DIM p AS Vec2
p.x = 10
```

Not:
- UDT referanslari parse sonunda toplu dogrulanir.
- Uygulamada ileri referans da kabul edilir (type sonradan tanimlansa bile).

### DECLARE SUB

Durum: IMPLEMENTED (PARSER)

Syntax:
- DECLARE SUB Name(param [AS TYPE], ...)

Ornek:
```bas
DECLARE SUB PrintScore(v AS I32)
```

### DECLARE FUNCTION

Durum: IMPLEMENTED (PARSER)

Syntax:
- DECLARE FUNCTION Name(param [AS TYPE], ...) AS TYPE

Ornek:
```bas
DECLARE FUNCTION Add(a AS I32, b AS I32) AS I32
```

### SUB

Durum: IMPLEMENTED (PARSER)

Syntax:
- SUB Name(param [AS TYPE], ...)
  - statements
  - END SUB

Ornek:
```bas
SUB PrintScore(v AS I32)
    PRINT v
END SUB
```

### FUNCTION

Durum: IMPLEMENTED (PARSER)

Syntax:
- FUNCTION Name(param [AS TYPE], ...) AS TYPE
  - statements
  - END FUNCTION

Ornek:
```bas
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION
```

### DEF* ailesi

Durum: IMPLEMENTED (PARSER)

Syntax:
- DEFINT rangeList
- DEFLNG rangeList
- DEFSNG rangeList
- DEFDBL rangeList
- DEFEXT rangeList
- DEFSTR rangeList
- DEFBYT rangeList

Ornek:
```bas
DEFINT A-Z
DEFSNG X, Y, Z
```

### SETSTRINGSIZE

Durum: IMPLEMENTED (PARSER)

Syntax:
- SETSTRINGSIZE expr

Ornek:
```bas
SETSTRINGSIZE 256
```

### INCLUDE

Durum: IMPLEMENTED (PARSER + INTEROP)

Syntax:
- INCLUDE "file.bas"

Ornek:
```bas
INCLUDE "mathlib.bas"
```

Kural:
- Yol .bas ile bitmeli.
- Guvensiz karakterler reddedilir.

### IMPORT

Durum: IMPLEMENTED (PARSER + INTEROP)

Syntax:
- IMPORT(LANG, "file.ext")
- LANG: C | CPP | ASM

Ornek:
```bas
IMPORT(C, "cmod.c")
IMPORT(CPP, "cppmod.cpp")
IMPORT(ASM, "lowlevel.asm")
```

Kural:
- Dil/uzanti uyumu zorunlu.
- Resolver kok disina tasan path'i reddeder.

### INLINE

Durum: PARTIAL
- PARSER: IMPLEMENTED
- x64 BACKEND SEMANTIK: PLANNED

Syntax:
- INLINE(...) ... END INLINE

Ornek:
```bas
INLINE("ASM", "BLOB1", "PROC", "")
    ; asm body
END INLINE
```

Not:
- Eski inline adlari (_ASM, ASM_SUB, ASM_FUNCTION) parserda bilincli sekilde kapali.

## 4.3 I/O ve konsol komutlari

### PRINT

Durum: IMPLEMENTED (PARSER)

Syntax:
- PRINT expr [ ,|; expr ... ]

Ornek:
```bas
PRINT "A", 10; "B"
```

### INPUT

Durum: IMPLEMENTED (PARSER)

Syntax:
- INPUT target [, target ...]
- INPUT "prompt"; target [, target ...]
- INPUT "prompt", target [, target ...]

Ornek:
```bas
DIM name AS STRING
DIM age AS I32
INPUT "Ad?"; name
INPUT age
```

### INPUT#

Durum: IMPLEMENTED (PARSER)

Syntax:
- INPUT #handle, target [, target ...]

Ornek:
```bas
INPUT #1, name, age
```

### OPEN

Durum: IMPLEMENTED (PARSER)

Syntax:
- OPEN fileExpr FOR mode AS [#]handleExpr

Ornek:
```bas
OPEN "data.bin" FOR RANDOM AS #1
```

### CLOSE

Durum: IMPLEMENTED (PARSER)

Syntax:
- CLOSE
- CLOSE [#]handleExpr [, [#]handleExpr ...]

Ornek:
```bas
CLOSE
CLOSE #1
CLOSE #1, #2
```

### GET

Durum: IMPLEMENTED (PARSER)

Syntax:
- GET [#]handle, target
- GET [#]handle, pos, target
- GET [#]handle, pos, bytes, target

Ornek:
```bas
GET #1, value
GET #1, 10, value
GET #1, 10, 2, value
```

Not:
- Legacy uyumluluk icin 1..3 arguman formu desteklenir.

### PUT

Durum: IMPLEMENTED (PARSER)

Syntax:
- PUT [#]handle, source
- PUT [#]handle, pos, source
- PUT [#]handle, pos, bytes, source

Ornek:
```bas
PUT #1, value
PUT #1, 10, value
PUT #1, 10, 2, value
```

### SEEK

Durum: IMPLEMENTED (PARSER)

Syntax:
- SEEK [#]handle
- SEEK [#]handle, pos

Ornek:
```bas
SEEK #1
SEEK #1, 128
```

### LOCATE

Durum: IMPLEMENTED (PARSER)

Syntax:
- LOCATE rowExpr, colExpr

Ornek:
```bas
LOCATE 5, 10
```

### COLOR

Durum: IMPLEMENTED (PARSER)

Syntax:
- COLOR fgExpr, bgExpr

Ornek:
```bas
COLOR 14, 1
```

### CLS

Durum: IMPLEMENTED (PARSER)

Syntax:
- CLS

Ornek:
```bas
CLS
```

## 4.4 Bellek ve yardimci komutlar

### RANDOMIZE

Durum: IMPLEMENTED (PARSER)

Syntax:
- RANDOMIZE
- RANDOMIZE seedExpr

Ornek:
```bas
RANDOMIZE
RANDOMIZE 42
```

### POKEB / POKEW / POKED

Durum: IMPLEMENTED
- PARSER: IMPLEMENTED
- MEMORY EXEC RUNTIME: IMPLEMENTED

Syntax:
- POKEB addr, value
- POKEW addr, value
- POKED addr, value

Ornek:
```bas
POKEB 4096, 255
POKEW 4096, 4660
POKED 4096, 305419896
```

### POKE (legacy alias)

Durum: IMPLEMENTED
- PARSER: IMPLEMENTED
- MAP: POKED semantigi

Syntax:
- POKE addr, value

Ornek:
```bas
POKE 4096, 305419896
```

### MEMCOPYB

Durum: IMPLEMENTED
- PARSER: IMPLEMENTED
- MEMORY EXEC RUNTIME: IMPLEMENTED

Syntax:
- MEMCOPYB src, dst, n

Ornek:
```bas
MEMCOPYB 1000, 2000, 16
```

### MEMFILLB

Durum: IMPLEMENTED
- PARSER: IMPLEMENTED
- MEMORY EXEC RUNTIME: IMPLEMENTED

Syntax:
- MEMFILLB addr, value, n

Ornek:
```bas
MEMFILLB 2000, 7, 64
```

---

## 5. Intrinsic Fonksiyon Referansi (Syntax + Ornek)

## 5.1 Dosya ve zaman

### LOF

Durum: IMPLEMENTED (PARSER call validation)

Syntax:
- LOF(handleExpr)

Ornek:
```bas
x = LOF(1)
```

### EOF

Durum: IMPLEMENTED (PARSER call validation)

Syntax:
- EOF(handleExpr)

Ornek:
```bas
isEnd = EOF(1)
```

### TIMER

Durum: IMPLEMENTED (PARSER call validation + runtime support)

Syntax:
- TIMER()
- TIMER(unitStr)
- TIMER(startExpr, endExpr, unitStr)

Gecerli unit:
- ns, us, ms, s, min, h, day, year

Ornek:
```bas
t0 = TIMER("ms")
' ...
elapsed = TIMER(t0, TIMER("ms"), "ms")
```

## 5.2 String fonksiyonlari

### LEN

Syntax:
- LEN(expr)

Ornek:
```bas
l = LEN(name)
```

### MID

Syntax:
- MID(strExpr, startExpr)
- MID(strExpr, startExpr, lenExpr)

Ornek:
```bas
s = MID("abcdef", 2, 3)
```

### STR

Syntax:
- STR(expr)

Ornek:
```bas
s = STR(123)
```

### VAL

Syntax:
- VAL(expr)

Ornek:
```bas
n = VAL("123")
```

### UCASE

Syntax:
- UCASE(expr)

Ornek:
```bas
s = UCASE("ab")
```

### LCASE

Syntax:
- LCASE(expr)

Ornek:
```bas
s = LCASE("AB")
```

### LTRIM

Syntax:
- LTRIM(expr)

Ornek:
```bas
s = LTRIM("   x")
```

### RTRIM

Syntax:
- RTRIM(expr)

Ornek:
```bas
s = RTRIM("x   ")
```

### ASC

Syntax:
- ASC(expr)

Ornek:
```bas
c = ASC("A")
```

### CHR

Syntax:
- CHR(expr)

Ornek:
```bas
s = CHR(65)
```

### STRING

Syntax:
- STRING(countExpr, charExpr)

Ornek:
```bas
s = STRING(3, "*")
```

### SPACE

Syntax:
- SPACE(expr)

Ornek:
```bas
s = SPACE(5)
```

## 5.3 Matematik ve donusum

### ABS

Syntax:
- ABS(expr)

Ornek:
```bas
x = ABS(-5)
```

### INT

Syntax:
- INT(expr)

Ornek:
```bas
x = INT(3.9)
```

### SGN

Syntax:
- SGN(expr)

Ornek:
```bas
x = SGN(-10)
```

### SQRT

Syntax:
- SQRT(expr)

Ornek:
```bas
x = SQRT(25)
```

### SIN / COS / TAN

Syntax:
- SIN(expr)
- COS(expr)
- TAN(expr)

Ornek:
```bas
sx = SIN(1)
cx = COS(1)
tx = TAN(1)
```

### ATN / EXP / LOG

Syntax:
- ATN(expr)
- EXP(expr)
- LOG(expr)

Ornek:
```bas
a = ATN(1)
e = EXP(1)
l = LOG(10)
```

### CINT / CLNG / CDBL / CSNG

Syntax:
- CINT(expr)
- CLNG(expr)
- CDBL(expr)
- CSNG(expr)

Ornek:
```bas
i = CINT(3.4)
l = CLNG(3.4)
d = CDBL(3)
s = CSNG(3)
```

### FIX

Syntax:
- FIX(expr)

Ornek:
```bas
x = FIX(3.9)
```

### SQR

Syntax:
- SQR(expr)

Ornek:
```bas
x = SQR(16)
```

### RND

Syntax:
- RND()
- RND(expr)

Ornek:
```bas
r1 = RND()
r2 = RND(1)
```

## 5.4 Klavye ve bellek fonksiyonlari

### INKEY

Syntax:
- INKEY(flagsExpr)
- INKEY(flagsExpr, stateExpr)

Ornek:
```bas
k = INKEY(1)
k2 = INKEY(1, st)
```

### GETKEY

Syntax:
- GETKEY()

Ornek:
```bas
k = GETKEY()
```

### PEEKB / PEEKW / PEEKD

Syntax:
- PEEKB(addrExpr)
- PEEKW(addrExpr)
- PEEKD(addrExpr)

Ornek:
```bas
b = PEEKB(4096)
w = PEEKW(4096)
d = PEEKD(4096)
```

---

## 6. Operator Referansi

## 6.1 Gercekten expression parser tarafinda desteklenenler

### Unary

- +expr
- -expr
- @expr
- NOT expr

Ornek:
```bas
a = -x
p = @x
f = NOT flag
```

### Us alma

- expr ** expr

Ornek:
```bas
y = 2 ** 8
```

### Carpma seviyesi

- *  /  \\  %

Ornek:
```bas
a = x * y
b = x / y
c = x \\ y
d = x % y
```

### Toplama seviyesi

- +  -

Ornek:
```bas
z = a + b - c
```

### Karsilastirma seviyesi

- =  <>  <  >  <=  >=

Ornek:
```bas
ok = x >= y
```

## 6.2 Lexer tarafinda taninip expression parserda aktif olmayanlar

Durum: PARTIAL
- LEXER: keyword/operator olarak taniniyor
- PARSER EXPR: infix anlami henuz yok

Liste:
- AND, OR, XOR
- MOD (keyword form)
- SHL, SHR, ROL, ROR
- <<, >> (operator token olarak okunur, expr parser adimi yok)

Not:
- Matematik modulo icin aktif olan operator %, MOD keyword degil.

## 6.3 Statement seviyesinde ek operatorler

- Atama operatorleri: =, +=, -=, *=, /=, \\=, =+, =-
- Postfix: ++, --

---

## 7. Tipler ve Veri Yapilari

## 7.1 Builtin tip keywordleri (parser)

Durum: IMPLEMENTED (type token validation)

Liste:
- I8, U8
- I16, U16
- I32, U32
- I64, U64
- F32, F64, F80
- BOOLEAN
- STRING
- ARRAY, LIST, DICT, SET

Ornek:
```bas
DIM a AS I32
DIM b AS F64
DIM s AS STRING
```

Not:
- LONG, INTEGER, DOUBLE, SINGLE, BYTE adlari bu parserin builtin listesinde degil.

## 7.2 User-defined type (UDT)

Durum: IMPLEMENTED (PARSER)

Syntax:
- TYPE Name ... END TYPE
- DIM x AS Name

Ornek:
```bas
TYPE Rect
    w AS I32
    h AS I32
END TYPE

DIM r AS Rect
```

## 7.3 Veri yapisi anahtar kelimeleri

### ARRAY / LIST / DICT / SET

Durum: PARTIAL
- Type keyword olarak kabul edilir.
- Tam koleksiyon semantigi/runtime davranisi bu cekirdekte tanimli degildir.

Ornek (parser tip baglami):
```bas
DIM bag AS LIST
DIM map AS DICT
```

## 7.4 Planli tip/veri yapisi genislemeleri

Durum: PLANNED

Liste:
- VARPTR, SADD, LPTR, CODEPTR
- POKES
- MEMCOPYW, MEMCOPYD
- MEMFILLW, MEMFILLD
- SETNEWOFFSET

Hedef syntax ornekleri (plan):
```bas
p = VARPTR(x)
addr = SADD(s)
POKES 4096, "ABC"
MEMCOPYW src, dst, n
```

---

## 8. Runtime Gercegi (Cok Onemli Ayrim)

## 8.1 Genel dil runtime'i

Durum: PLANNED
- Tum parser statementlarini calistiran tam runtime yok.

## 8.2 Mevcut calisan runtime parcasi

### Timer runtime

Durum: IMPLEMENTED
- TimerNormalizeUnit
- TimerConvertSeconds
- TimerNow
- TimerRange

### Memory VM runtime

Durum: IMPLEMENTED
- VMemInit
- VMemPeekB/W/D
- VMemPokeB/W/D
- VMemCopyB
- VMemFillB
- Text window blit

### Memory AST execution

Durum: IMPLEMENTED (sinirli)

Calisan statementlar:
- ASSIGN_STMT
- INCDEC_STMT
- POKEB_STMT
- POKEW_STMT
- POKED_STMT
- MEMCOPYB_STMT
- MEMFILLB_STMT
- EXPR_STMT (sinirli expr destegi ile)

Calisan expr dugumleri:
- NUMBER
- IDENT
- UNARY (+, -)
- BINARY (+, -, *, /, \\, %)
- CALL_EXPR: PEEKB/PEEKW/PEEKD

Not:
- Bu yol, tum dil runtime'i degil; memory-odakli kontrollu alt kume yurutucudur.

---

## 9. Mimari ve Modul Kitabi

## 9.1 Ust seviye akis

1. Kaynak oku
2. Lexer token listesi uret
3. Parser AST uret
4. Opsiyonel: memory execution
5. Interop manifest resolve et
6. Interop artifactlari uret

## 9.2 Modul bazli siniflandirma

### src/main.bas

Amac:
- Program girisi, dosya okuma, lexer/parser cagrisi, AST dump, interop emit, opsiyonel execmem.

Ana degiskenler:
- sourceText
- sourcePath
- st (LexerState)
- ps (ParseState)

### src/parser/token_kinds.fbs

Amac:
- Token ve TokenList veri yapilari.

Temel tipler:
- Type Token
- Type TokenList

### src/parser/ast.fbs

Amac:
- AST node havuzu ve cocuk baglama.

Temel tipler:
- Type ASTNode
- Type ASTPool

### src/parser/lexer/*.fbs

Amac:
- Lexing pipeline.

Alt moduller:
- lexer_core: temel karakter/token yardimcilari
- lexer_readers: string/number/identifier/operator okuyuculari
- lexer_keyword_table: keyword siniflandirma
- lexer_driver: ana lex dongusu

### src/parser/parser.fbs

Amac:
- ParseState ve parser modul baglantisi.

Temel tip:
- Type ParseState

### src/parser/parser/parser_shared.fbs

Amac:
- Ortak parser yardimcilari, intrinsic arguman denetimi, tip dogrulama.

Kritik global durum:
- gDeclaredTypeNames/gDeclaredTypeCount
- gReferencedTypeNames/gReferencedTypeCount

### src/parser/parser/parser_expr.fbs

Amac:
- Expression parsing zinciri:
  ParsePrimary -> ParseUnary -> ParsePower -> ParseTerm -> ParseAdd -> ParseRelation

### src/parser/parser/parser_stmt_basic.fbs

Amac:
- Basic statement parserlari:
  PRINT, INLINE, INC/DEC, RANDOMIZE, POKE*, MEMCOPYB/MEMFILLB

### src/parser/parser/parser_stmt_decl.fbs

Amac:
- Deklarasyon/yapi parserlari:
  CONST, DIM, REDIM, TYPE, DECLARE, SUB, FUNCTION, DEF*, SETSTRINGSIZE, INCLUDE, IMPORT

### src/parser/parser/parser_stmt_flow.fbs

Amac:
- Akis parserlari:
  IF, SELECT, FOR, DO, GOTO, GOSUB, RETURN, EXIT, END

### src/parser/parser/parser_stmt_io.fbs

Amac:
- I/O ve konsol parserlari:
  INPUT, OPEN, CLOSE, GET, PUT, SEEK, LOCATE, COLOR, CLS

### src/parser/parser/parser_stmt_dispatch.fbs

Amac:
- Tek merkez statement dispatch ve ParseProgram dongusu.

### src/build/interop_manifest.fbs

Amac:
- INCLUDE/IMPORT agacini cozer, cikti artifactlarini uretir.

Temel tipler:
- InteropIncludeEntry
- InteropImportEntry
- InteropManifest
- InteropStringSet

### src/runtime/timer.fbs

Amac:
- Zaman birimi normalize ve donusum fonksiyonlari.

### src/runtime/memory_vm.fbs

Amac:
- Sinirli sanal bellek modeli.

Temel tip:
- VMemState

### src/runtime/memory_exec.fbs

Amac:
- AST uzerinden memory odakli kontrollu yurutme.

Temel tipler:
- ExecVar
- ExecState

### src/legacy/get_commands_port.fbs

Amac:
- Legacy satir parcala davranisinin portu.

---

## 10. Derleme/Calistirma Is Akisi ve Artifactlar

## 10.1 Calisma akis resmi

1. Kaynak dosya verilir.
2. Lexer token listesi uretir.
3. Parser AST uretir.
4. Parse basariliysa AST dump alinabilir.
5. --execmem verilirse memory execution denenir.
6. INCLUDE/IMPORT resolver calisir.
7. dist/interop altina artifactlar yazilir.

## 10.2 Uretilen artifactlar

Interop emit sonrasi:
- dist/interop/import_build_manifest.csv
- dist/interop/import_link_args.rsp
- dist/interop/import_link_plan_win11.txt
- dist/interop/import_objs/*.o (planlanan objeler)

## 10.3 Guvenlik/hijyen kurallari

1. INCLUDE/IMPORT path kontrolu var.
2. Kullanim kaynagi source root disina tasarsa reddedilir.
3. Dosya yoksa resolver hata verir.
4. Guvensiz karakterli pathler parser seviyesinde reddedilir.

---

## 11. Dokumanlar Arasi Fark Analizi

Bu bolumde 3 kaynak karsilastirilmistir:
1. ProgramcininElKitabi.md
2. ProgramcininElKitabi.standardized.md
3. Kod + test gercegi (parser/runtime/tests)

## 11.1 Kapsam stili farki

- ProgramcininElKitabi.md:
  - Tarihsel birikim agirlikli.
  - Tekrarlar ve append-only izleri fazla.
- standardized:
  - Daha temiz ve sinifli.
  - Ancak belirli bolumlerde bicim bozulmasi var.
- kod+test:
  - En guvenilir teknik kaynak.

## 11.2 Teknik celiski odakli farklar

1. Sonekli adlar:
   - Eski metinlerde tarihsel izler var.
   - Kod gercegi: strict parserda sonekli identifier yok.

2. Intrinsic aliaslar:
   - Eski metinler alias gecmisine referans verebiliyor.
   - Kod gercegi: aktif validation listesi suffixsiz isimler uzerinde.

3. GET/PUT formu:
   - Eski bir kisim sadece MVP forma odakli.
   - Kod gercegi: handle sonrasi 1..3 arguman kompat form aktif.

4. POKE:
   - Eski tablolar yer yer eksik.
   - Kod gercegi: POKE alias aktif ve POKED'e mapleniyor.

5. Runtime iddiasi:
   - Metinlerde parser ve runtime bazen yakin anlatilmis.
   - Kod gercegi: genel runtime yok, memory runtime alt kume var.

## 11.3 Test plani ile farklar

- command_compatibility tablosunda GET/PUT icin eski ve yeni satirlar birlikte bulunabiliyor.
- Bu durum dokumanda tek normalize syntax ailesiyle birlestirilmeli.

Sonuc:
- Bu pek.md, bu farklari tek modelde normalize eder:
  - once parser gercegi
  - sonra runtime seviyesi
  - en sonda planli backlog

---

## 12. Komut/Fonksiyon/Operator/Tip Hizli Endeks

## 12.1 Komutlar

IMPLEMENTED (PARSER):
- PRINT
- INLINE
- IF, SELECT, FOR, DO
- GOTO, GOSUB, RETURN, EXIT, END
- DECLARE, SUB, FUNCTION
- CONST, DIM, REDIM, TYPE
- DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT
- SETSTRINGSIZE
- INCLUDE, IMPORT
- INPUT, OPEN, CLOSE, GET, PUT, SEEK
- LOCATE, COLOR, CLS
- INC, DEC
- RANDOMIZE
- POKEB, POKEW, POKED, POKE
- MEMCOPYB, MEMFILLB

PLANNED:
- POKES
- MEMCOPYW, MEMCOPYD
- MEMFILLW, MEMFILLD
- SETNEWOFFSET

## 12.2 Fonksiyonlar

IMPLEMENTED (CALL VALIDATION):
- LEN, MID, STR, VAL
- ABS, INT, SGN, SQRT
- SIN, COS, TAN, ATN, EXP, LOG
- LTRIM, RTRIM, UCASE, LCASE, ASC, CHR, STRING, SPACE
- CINT, CLNG, CDBL, CSNG, FIX, SQR, RND
- INKEY, GETKEY
- TIMER
- LOF, EOF
- PEEKB, PEEKW, PEEKD

PLANNED:
- VARPTR, SADD, LPTR, CODEPTR

## 12.3 Operatorler

Expression aktif:
- unary: + - @ NOT
- binary: **, *, /, \\, %, +, -, =, <>, <, >, <=, >=

Statement aktif:
- =, +=, -=, *=, /=, \\=, =+, =-, ++, --

Lexer var ama parser infix degil:
- AND, OR, XOR, MOD, SHL, SHR, ROL, ROR, <<, >>

## 12.4 Tipler ve veri yapilari

Type token IMPLEMENTED:
- I8/U8/I16/U16/I32/U32/I64/U64/F32/F64/F80/BOOLEAN/STRING/ARRAY/LIST/DICT/SET

UDT IMPLEMENTED:
- TYPE ... END TYPE

Koleksiyon semantigi:
- ARRAY/LIST/DICT/SET tam runtime semantigi PARTIAL/PLANNED

---

## 13. Onerilen Sonraki Teknik Adimlar

1. Parser-gercekli command matrisi tekillestirilsin (GET/PUT duplicate satirlar normalize).
2. Runtime seviyeleri resmi etiketlensin:
   - parser-only
   - parser+runtime
3. Operator backlog netlestirilsin (AND/OR/XOR ve shift ailesi).
4. Pointer intrinsics icin guvenli runtime spesifikasyonu tamamlanip teste baglansin.
5. Inline x64 backend fazi parser dokusundan ayrik milestone olarak kapatilsin.

---

## 14. Kapanis

Bu belge, tarihsel dokumanlari silmeden, teknik gercegi parser/test/runtime ekseninde tek bir referansa indirger.

Temel ilke:
- Kod + test celisirse, dogru kaynak kod + testtir.
- Dokuman, bu gercegi izlemek icin vardir.
