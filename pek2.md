# uXBasic Teknik El Kitabi (pek2.md)

## 0) Bu Belgenin Sozlesmesi

Bu belge, proje gercegini tek yerde toplamak icin yazildi.

Bu dokumanin en kritik karari su:
- Birinci dogruluk kaynagi koddur (lexer/parser/runtime).
- Ikinci dogruluk kaynagi test/matrix dosyalaridir.
- Tarihsel dokumanlar (ProgramcininElKitabi.md vb.) yalnizca baglam verir.

### 0.1 Kanonik Kaynaklar

- `src/parser/lexer/*`
- `src/parser/parser/*`
- `src/runtime/*`
- `src/build/interop_manifest.fbs`
- `tests/manifest.csv`
- `tests/plan/command_compatibility_win11.csv`
- `tests/plan/cmp_interop_win11.csv`
- `spec/LANGUAGE_CONTRACT.md`
- `WORK_QUEUE.md`

### 0.2 Durum Etiketleri

- `IMPLEMENTED-PARSER`: Lexer + parser + AST kabul ediyor.
- `IMPLEMENTED-RUNTIME`: Runtime davranisi da var.
- `PARTIAL`: Bir parcasi var ama tamam degil.
- `PLANNED`: Planli, henuz aktif degil.

### 0.3 Katman Tanimi

- `LEXER`: karakterleri tokenlara cevirir.
- `PARSER`: syntaxi dogrular, AST uretir.
- `VALIDATION`: parser sonrasi imza/tip kurallari.
- `RUNTIME`: kod calistirma / davranis katmani.
- `BUILD`: interop resolver ve artefakt uretimi.

---

## 1) Projede Nerede Kalindi?

uXBasic su anda parser-merkezli ve Win11 x64 odakli bir gecis fazindadir.

### 1.1 Tamamlanan Ana Alanlar

1. Lexer moduler yapida calisiyor.
2. Parser moduler yapida calisiyor ve AST uretiyor.
3. Tip dogrulama (builtin + UDT referans) aktif.
4. INCLUDE/IMPORT parser kurallari aktif.
5. INCLUDE recursive resolver + include-once mantigi aktif.
6. IMPORT icin build manifest + link plan artefaktlari uretiliyor.
7. Core intrinsic imza dogrulamalari aktif (LEN, MID, STR, ...).
8. File I/O parser kapsami aktif (OPEN/CLOSE/GET/PUT/SEEK/INPUT).
9. Bellek komutlarinin bir alt kumesi parser + memory runtime ile aktif.
10. `POKE` legacy alias olarak `POKED` semantigine esleniyor.

### 1.2 Acik/Planli Ana Alanlar

1. Pointer intrinsics: `VARPTR`, `SADD`, `LPTR`, `CODEPTR` (PLANNED).
2. Gelismis bellek komutlari: `POKES`, `MEMCOPYW/D`, `MEMFILLW/D`, `SETNEWOFFSET` (PLANNED).
3. INLINE x64 backend semantigi (PLANNED).
4. File I/O ileri semantik standardizasyonu (record/binary kanal davranisi) (PLANNED).

### 1.3 Kritik Durum Notu

Parser kapsami runtime kapsamindan daha ileridedir.
Bu nedenle su ayrim zorunludur:
- "Parse ediliyor" != "Tum semantik davranis runtime'da tamam".

---

## 2) Belgeler Arasi Farklar ve Celiski Cozumu

Bu bolum, proje icindeki ana dokumanlarin neyi iyi yaptigini ve nerede risk olusturdugunu netlestirir.

### 2.1 ProgramcininElKitabi.md

Guclu yanlari:
- Tarihsel akis ve niyet anlatimi kuvvetli.
- Kapsam iddiasi genis.

Sorunlu yanlari:
- Tekrarli bolumler var.
- Bazi syntax satirlari kod gercegiyle birebir eslesmiyor.
- "implement edildi" ile "planlandi" ayrimi her yerde net degil.

### 2.2 ProgramcininElKitabi.standardized.md

Guclu yanlari:
- Daha sistematik bolumleme denemesi var.
- Parser gercegine yaklasan bir iskelet sunuyor.

Sorunlu yanlari:
- Ozellikle I/O civarinda bozulmus/karismis satirlar var.
- Bazi satirlarda bicim bozuklugu bilgi guvenini dusuruyor.

### 2.3 command_compatibility_win11.csv

Guclu yanlari:
- Her komut icin status + katman + test_ref veriyor.
- Proje backlog'unu acikca tasiyor.

Dikkat noktasi:
- GET/PUT icin hem "MVP satiri" hem "compat satiri" var; tek syntax gibi okunursa kafa karistirir.

### 2.4 tests/manifest.csv

Guclu yanlari:
- Komut/fonksiyon bazli test senaryolari ayrintili.
- Pozitif/negatif parse senaryolari iyi dagitilmis.

Dikkat noktasi:
- `result` kolonlari bircok satirda `pending`; satirlar fixture olarak duruyor.
- Gercek gecis durumu, `tests/run_manifest.bas` ile anlik kosuma bakilarak anlasilir.

### 2.5 Bu Belgedeki Cozum Karari

Bu dokumanda tum syntaxlar koddan cekilmis ve su kuralla sunulmustur:
- Once parser gercegi,
- Sonra runtime kapsami,
- Sonra backlog.

---

## 3) Lexical Katman (Token Kurallari)

### 3.1 Identifier Kurali

Syntax sablonu:
- Baslangic: harf veya `_`
- Devam: harf, rakam, `_`

Ornekler:
```bas
player
_tmp
score2
```

Gecersiz ornekler:
```bas
1abc
name$
count%
```

Not:
- Strict modda suffix-style identifier (ornek `x$`, `n%`) kabul edilmez.

### 3.2 Literaller

- Number: `42`, `3.14`
- String: `"metin"`, cift tirnak kacisi: `"A""B"`

Ornek:
```bas
PRINT 42
PRINT 3.14
PRINT "A""B"
```

### 3.3 Yorum

- Tek satir yorum: `'`

Ornek:
```bas
PRINT 1 ' yorum
```

### 3.4 Satir Sonu ve Ayiraclar

- `EOL` token uretilir.
- `:` statement ayirici olarak parser tarafinda separator kabul edilir.

### 3.5 Operator Tokenlari (Lexer)

Lexer tarafinda taninan operatorler:
- Ciftli: `++ -- += -= *= /= \\= =+ =- ** << >> <= >= <>`
- Tekli: `+ - * / \\ % = < > @ # ( ) [ ] , : ; . | &`

Onemli not:
- Lexer'in tanimasi parser semantigi anlamina gelmez.
- Ornek: `<<` ve `>>` token olarak var, ancak expression parserinda aktif operator degil.

---

## 4) Expression Sistemi

### 4.1 Oncelik Sirasi

Expression parser su zinciri kullanir:
1. `relation`
2. `add`
3. `term`
4. `power`
5. `unary`
6. `primary`

### 4.2 EBNF Benzeri Ozet

```txt
expression  := relation
relation    := add ( ("=" | "<>" | "<" | ">" | "<=" | ">=") add )*
add         := term ( ("+" | "-") term )*
term        := power ( ("*" | "/" | "\\" | "%") power )*
power       := unary ("**" power)?
unary       := (("+" | "-" | "@") | "NOT") unary | primary
primary     := NUMBER | STRING | IDENT | KEYWORD_REF | call | "(" expression ")"
call        := name "(" [expression ("," expression)*] ")"
```

### 4.3 Intrinsic Cagri Dogrulama (Validation)

Parser call_expr uretir, sonra `ValidateCoreIntrinsicCall` ve ilgili dogrulamalarla arity kontrolu yapar.

Ornek:
```bas
x = LEN("abc")      ' gecerli
x = MID("abc",1,2)  ' gecerli
x = MID("abc")      ' parse_fail
```

### 4.4 Su Anda Desteklenmeyen Expression Beklentileri

Asagidaki token/keywordler lexerda gorulebilir ama expression semantiginde tamam degildir:
- `AND`, `OR`, `XOR`
- `SHL`, `SHR`, `ROL`, `ROR`
- keyword `MOD` (operator `%` aktif, fakat `MOD` keyword yolu parserda ayri islenmiyor)

---

## 5) Komutlar (Statement) - Sistematik Rehber

Bu bolumde her komut ayni sablonla verilir:
- Amac
- Katman/Durum
- Syntax
- Ornek
- Not

## 5.1 Temel Komutlar

### PRINT
- Amac: Ifade sonucunu ciktiya vermek.
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
PRINT expr [,|; expr ...]
```
- Ornek:
```bas
PRINT 1 + 2
PRINT "Ad:", name
PRINT "X="; x
```
- Not: Runtime format davranisi parser disi konudur.

### INLINE
- Amac: Inline blok tanimlamak.
- Katman/Durum: `IMPLEMENTED-PARSER`, `PARTIAL` (x64 backend semantigi planli)
- Syntax:
```txt
INLINE(...) 
  ...
END INLINE
```
- Ornek:
```bas
INLINE("x86_64", "nasm", "sub", "")
  ; asm body
END INLINE
```
- Not:
  - `_ASM`, `ASM_SUB`, `ASM_FUNCTION` reddedilir.

### END
- Amac: Program sonlandirma komutu.
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
END
```
- Ornek:
```bas
IF fatal THEN END
```

## 5.2 Atama ve Sayac Komutlari

### Atama Operatorleri
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
ident = expr
ident += expr
ident -= expr
ident *= expr
ident /= expr
ident \\= expr
ident =+ expr
ident =- expr
```
- Ornek:
```bas
x = 10
x += 5
x =- 2
```

### Postfix inc/dec
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
ident++
ident--
```
- Ornek:
```bas
i++
j--
```

### INC / DEC
- Katman/Durum: `IMPLEMENTED-PARSER` + memory exec icinde islenir
- Syntax:
```txt
INC ident
DEC ident
```
- Ornek:
```bas
INC counter
DEC counter
```

## 5.3 Kontrol Akisi Komutlari

### IF / ELSEIF / ELSE / END IF
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
IF expr THEN
  ...
[ELSEIF expr THEN
  ...]
[ELSE
  ...]
END IF
```
- Ornek:
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
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
SELECT CASE expr
CASE expr [, expr ...]
  ...
CASE ELSE
  ...
END SELECT
```
- Ornek:
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

### FOR / NEXT
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax: FOR var = baslangic TO bitis [STEP adim] ... NEXT [var]
For syntaxinda STEP yoksa varsayilan adim `1`'dir.
FOR VAR = START TO END [STEP STEP_VAL] ... EXIT FOR ... END FOR seklinde kullanilabilir. STEP ifadesi optional'dir ve varsayilan olarak 1 degerini alir.
  ...

```txt
FOR ident = startExpr TO endExpr [STEP stepExpr]
  ...
NEXT [ident]
```
- Ornek:
```bas
FOR i = 1 TO 10 STEP 2
    PRINT i
NEXT i
```
- Not: STEP yoksa varsayilan `1` uretilir.

### DO / LOOP
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax: DO [UNTIL| WHILE expr] ... LOOP [UNTIL|WHILE expr]
```txt
DO
  ...
LOOP

DO WHILE expr
  ...
LOOP

DO UNTIL expr
  ...
LOOP

DO
  ...
LOOP WHILE expr

DO
  ...
LOOP UNTIL expr
```
- Ornek:
```bas
DO WHILE i < 10
    i += 1
LOOP
```

### GOTO / GOSUB
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
GOTO labelOrNumber
GOSUB labelOrNumber
```
- Ornek:
```bas
GOTO Start
GOSUB Worker
```

### RETURN
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
RETURN
RETURN expr
```
- Ornek:
```bas
RETURN
RETURN x + 1
```

### EXIT
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
EXIT
EXIT FOR
EXIT DO
```
- Ornek:
```bas
IF done THEN EXIT FOR
```
- Not: `EXIT NOW` gibi formlar parse_fail.

## 5.4 Bildirim ve Tip Komutlari

### DIM
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
DIM name[(bound[,bound...])] AS TYPE [= expr] [, ...]
```
- Ornek:
```bas
DIM skor AS I32 = 0
DIM arr(0 TO 9) AS I32
DIM mat(0 TO 2, 0 TO 2) AS F64
```

### REDIM
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
REDIM name(bounds) AS TYPE [, ...]
```
- Ornek:
```bas
REDIM arr(0 TO 99) AS I32
```

### CONST
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
CONST Name = expr [, Name = expr ...]
```
- Ornek:
```bas
CONST PI = 3.14159, LIMIT = 100
```

### TYPE ... END TYPE
- Katman/Durum: `IMPLEMENTED-PARSER` + type reference validation
- Syntax:
```txt
TYPE Name
  fieldName AS TYPE
  ...
END TYPE
```
- Ornek:
```bas
TYPE Vec2
    x AS I32
    y AS I32
END TYPE
```
- Not:
  - UDT referanslari parse sonunda dogrulanir.
  - Ileri kullanim desteklidir (once kullan, sonra TYPE bildir).

### DECLARE SUB/FUNCTION
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
DECLARE SUB Name([param [AS TYPE], ...])
DECLARE FUNCTION Name([param [AS TYPE], ...]) AS TYPE
```
- Ornek:
```bas
DECLARE SUB Draw(x AS I32, y AS I32)
DECLARE FUNCTION Add(a AS I32, b AS I32) AS I32
```

### SUB ... END SUB
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
SUB Name([param [AS TYPE], ...])
  ...
END SUB
```
- Ornek:
```bas
SUB Hello(name AS STRING)
    PRINT "Merhaba", name
END SUB
```

### FUNCTION ... END FUNCTION
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
FUNCTION Name([param [AS TYPE], ...]) AS TYPE
  ...
END FUNCTION
```
- Ornek:
```bas
FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION
```

### DEF* ve SETSTRINGSIZE
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
DEFINT rangeList
DEFLNG rangeList
DEFSNG rangeList
DEFDBL rangeList
DEFEXT rangeList
DEFSTR rangeList
DEFBYT rangeList
SETSTRINGSIZE expr
```
- Ornek:
```bas
DEFINT A-Z
DEFSTR S-T
SETSTRINGSIZE 256
```

## 5.5 INCLUDE / IMPORT

### INCLUDE
- Katman/Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-BUILD/RESOLVER`
- Syntax:
```txt
INCLUDE "file.bas"
```
- Ornek:
```bas
INCLUDE "lib/math.bas"
```
- Not:
  - Yalniz `.bas` uzantisi kabul edilir.
  - Unsafe karakterler reddedilir.
  - Resolver include-once davranisi uygular.

### IMPORT
- Katman/Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-BUILD`
- Syntax:
```txt
IMPORT(C, "file.c")
IMPORT(CPP, "file.cpp")
IMPORT(ASM, "file.asm")
```
- Ornek:
```bas
IMPORT(C, "native/add.c")
IMPORT(CPP, "native/math.cpp")
IMPORT(ASM, "native/fast.asm")
```
- Not:
  - Parantezli form zorunludur.
  - Dil/uzanti uyumu zorunludur.
  - Kaynak root disina cikisa izin verilmez.

## 5.6 Dosya ve Giris/Cikis Komutlari

### OPEN
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
OPEN fileExpr FOR mode AS [#]handleExpr
```
- Ornek:
```bas
OPEN "data.txt" FOR INPUT AS #1
OPEN fileName FOR OUTPUT AS 2
```
- Not: `mode` token olarak KEYWORD veya IDENT kabul edilir.

### CLOSE
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
CLOSE
CLOSE [#]handleExpr [, [#]handleExpr ...]
```
- Ornek:
```bas
CLOSE
CLOSE #1
CLOSE 1, 2, #3
```

### GET
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax (kanonik parser formu):
```txt
GET [#]handleExpr, arg1 [, arg2 [, arg3]]
```
- Ornekler:
```bas
GET 1, x
GET 1, 10, x
GET 1, 10, 2, x
```
- Not:
  - Handle sonrasi en az 1, en fazla 3 arguman.
  - Matrixteki legacy uyumluluk formlari bu kurala denk gelir.

### PUT
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax (kanonik parser formu):
```txt
PUT [#]handleExpr, arg1 [, arg2 [, arg3]]
```
- Ornekler:
```bas
PUT 1, x
PUT 1, 10, x
PUT 1, 10, 2, x
```
- Not:
  - Handle sonrasi en az 1, en fazla 3 arguman.

### SEEK
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
SEEK [#]handleExpr [, positionExpr]
```
- Ornek:
```bas
SEEK 1
SEEK #1, 10
```

### INPUT
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
INPUT target[, target ...]
INPUT promptExpr; target[, target ...]
INPUT promptExpr, target[, target ...]
```
- Ornek:
```bas
INPUT x
INPUT "Ad?"; ad
INPUT "X,Y?", x, y
```

### INPUT#
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
INPUT #handleExpr, target[, target ...]
```
- Ornek:
```bas
INPUT #1, x
INPUT #1, x, y
```
- Not: Handle sonrasi virgul zorunludur.

## 5.7 Ekran Komutlari

### LOCATE
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
LOCATE rowExpr, colExpr
```
- Ornek:
```bas
LOCATE 5, 10
```

### COLOR
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
COLOR fgExpr, bgExpr
```
- Ornek:
```bas
COLOR 2, 0
```

### CLS
- Katman/Durum: `IMPLEMENTED-PARSER`
- Syntax:
```txt
CLS
```
- Ornek:
```bas
CLS
```

## 5.8 Bellek Komutlari

### POKEB / POKEW / POKED
- Katman/Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-RUNTIME(memory_exec + memory_vm)`
- Syntax:
```txt
POKEB addrExpr, valueExpr
POKEW addrExpr, valueExpr
POKED addrExpr, valueExpr
```
- Ornek:
```bas
POKEB 4096, 255
POKEW 4096, 4660
POKED 4096, 305419896
```

### POKE (legacy alias)
- Katman/Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-RUNTIME`
- Syntax:
```txt
POKE addrExpr, valueExpr
```
- Ornek:
```bas
POKE 4096, 123
```
- Not: AST seviyesinde `POKED_STMT` olarak uretilir.

### MEMCOPYB / MEMFILLB
- Katman/Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-RUNTIME`
- Syntax:
```txt
MEMCOPYB srcExpr, dstExpr, lenExpr
MEMFILLB addrExpr, valueExpr, lenExpr
```
- Ornek:
```bas
MEMCOPYB 1000, 2000, 16
MEMFILLB 2000, 7, 64
```

### PLANLI Bellek Komutlari
- `POKES`
- `MEMCOPYW`
- `MEMCOPYD`
- `MEMFILLW`
- `MEMFILLD`
- `SETNEWOFFSET`

Durum: `PLANNED`.

---

## 6) Fonksiyonlar (Intrinsic) - Tam Katalog

## 6.1 TIMER ve Dosya Bilgi Fonksiyonlari

### TIMER
- Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-RUNTIME(timer.fbs)`
- Imzalar:
```txt
TIMER()
TIMER(unit)
TIMER(startTick, endTick, unit)
```
- Gecerli unit:
```txt
ns, us, ms, s, min, h, day, year
```
- Ornek:
```bas
t0 = TIMER("ms")
dt = TIMER(1, 2, "ms")
```

### LOF / EOF
- Durum: `IMPLEMENTED-PARSER` + `VALIDATION`
- Imzalar:
```txt
LOF(handleExpr)
EOF(handleExpr)
```
- Ornek:
```bas
size = LOF(1)
isEnd = EOF(1)
```

## 6.2 String ve Numeric Intrinsics

Asagidaki arity kurallari parser validation tarafinda aktif:

- 1 arguman: `LEN STR VAL ABS INT UCASE LCASE ASC CHR LTRIM RTRIM SPACE SGN HYP SIN COS TAN ATN EXP LOG CINT CLNG CDBL CSNG FIX SQR HEX OCT BIN `
- 2..3 arguman: `MID`
- Tam 2 arguman: `STRING`
- 1..2 arguman: `INKEY`
- 0 arguman: `GETKEY`
- 0..1 arguman: `RND`

Ornekler:
```bas
a = LEN("abc")
s = MID("abcdef", 2, 3)
s2 = STRING(5, "*")
k = GETKEY()
state = INKEY(1, flags)
r = RND()
r2 = RND(1)
x = SQR(9)
```

## 6.3 Bellek Okuma Intrinsics

- Durum: `IMPLEMENTED-PARSER` + `IMPLEMENTED-RUNTIME(memory_vm)`
- Imzalar:
```txt
PEEKB(addrExpr)
PEEKW(addrExpr)
PEEKD(addrExpr)
```
- Ornek:
```bas
b = PEEKB(4096)
w = PEEKW(4096)
d = PEEKD(4096)
```

## 6.4 Kaldirilan/Engellenen Legacy Form

- `INKEY_LEGACY` reddedilir.
- Mesaj: `INKEY_LEGACY removed; use GETKEY or INKEY`

---

## 7) Veri Tipleri, Veri Yapilari ve Kurallar

## 7.1 Builtin Type Keyword Seti

Parser tarafinda gecerli builtin tip tokenlari:

```txt
I8 U8 I16 U16 I32 U32 I64 U64
F32 F64 F80
BOOLEAN STRING
ARRAY LIST DICT SET
```

Not:
- Bu liste parser/type-token dogrulama listesidir.
- Her tipin runtime semantigi esit seviyede tamamlanmis degildir.

## 7.2 UDT (Kullanici Tipi)

- `TYPE ... END TYPE` ile tanimlanir.
- `DIM x AS MyType` seklinde kullanilir.
- Parse sonu type referans dogrulamasi yapilir.

Ornek:
```bas
TYPE Player
    hp AS I32
    name AS STRING
END TYPE

DIM p AS Player
```

## 7.3 Degisken Isimlendirme Kurallari

- Harf veya `_` ile baslar.
- Harf/rakam/`_` ile devam eder.
- Suffix tip belirtecleri (`$`, `%`, `&`, `!`, `#`, `@`) identifier parcasi degildir.

## 7.4 Separator ve Satir Kurallari

- `EOL` veya `:` statement sonlandirici/ayirici olarak kabul edilir.
- Birden fazla statement ayni satirda `:` ile yazilabilir.

Ornek:
```bas
a = 1 : b = 2 : PRINT a + b
```

---

## 8) Operatorler - Gercek Destek Matrisi

## 8.1 Parser Expression'da Aktif Operatorler

- Unary: `+`, `-`, `@`, `NOT`
- Binary arithmetic: `+`, `-`, `*`, `/`, `\\`, `%`, `**`
- Binary relation: `=`, `<>`, `<`, `>`, `<=`, `>=`

## 8.2 Statement Seviyesinde Aktif Operatorler

- Atama: `=`, `+=`, `-=`, `*=`, `/=`, `\\=`, `=+`, `=-`
- Postfix: `++`, `--`

## 8.3 Token Olarak Var Ama Semantik Olarak Acik Olmayanlar

- `<<`, `>>`
- `|`, `&`
- keyword bazli `AND/OR/XOR/SHL/SHR/ROL/ROR/MOD`

Bu operatorler icin runtime veya expression semantigi talep edilirse yeni dalga gerekir.

---

## 9) Hata Kurallari ve Tipik Parse Fail Sebepleri

Bu bolum ekip ici hata triage icin pratik kural setidir.

1. `DIM: AS expected`
2. `TYPE: missing AS in field declaration`
3. `missing END IF / END SELECT / END SUB / END FUNCTION / END TYPE`
4. `IMPORT: expected syntax IMPORT(<LANG>, file)`
5. `IMPORT: unsupported language`
6. `INCLUDE: unsafe or unsupported path`
7. `GET/PUT: missing expression after comma`
8. `GET/PUT: too many arguments`
9. `CLS: unexpected arguments`
10. `EXIT: expected FOR, DO, or statement end`
11. `unknown type: <TypeName>` (parse sonu type reference check)
12. `legacy inline forms are disabled; use INLINE(...)`
13. `underscore commands are disabled`

---

## 10) Mimari - Moduller ve Sorumluluklar

## 10.1 Ust Seviye Akis

1. `src/main.bas` kaynak metni yukler.
2. `LexerInit` token akisini uretir.
3. `ParserInit` + `ParseProgram` AST uretir.
4. Parse basarisizsa `lastError` ile cikilir.
5. Opsiyonel: `--execmem` ile memory AST executor calistirilir.
6. Source dosya verildiyse interop resolver ve artefakt uretimi yapilir.

## 10.2 Modul Haritasi

### Parser cekirdegi
- `src/parser/token_kinds.fbs`
  - `Token`, `TokenList`, dinamik kapasite yonetimi.
- `src/parser/lexer/lexer_core.fbs`
  - Karakter siniflama, cursor/line/col state.
- `src/parser/lexer/lexer_readers.fbs`
  - String/number/identifier/operator okuma.
- `src/parser/lexer/lexer_keyword_table.fbs`
  - Keyword tanima.
- `src/parser/lexer/lexer_driver.fbs`
  - Lex dongusu ve EOF token.
- `src/parser/ast.fbs`
  - AST node havuzu, cocuk zinciri, dump.
- `src/parser/parser/parser_expr.fbs`
  - Expression precedence parser.
- `src/parser/parser/parser_stmt_*.fbs`
  - Konu bazli statement parserlari.
- `src/parser/parser/parser_shared.fbs`
  - Ortak yardimcilar + type/intrinsic validation.
- `src/parser/parser/parser_stmt_dispatch.fbs`
  - Komut dispatch ana girisi.

### Runtime
- `src/runtime/timer.fbs`
  - Unit normalize + saniye donusumleri.
- `src/runtime/memory_vm.fbs`
  - Sanal bellek, peek/poke/copy/fill, text blit.
- `src/runtime/memory_exec.fbs`
  - AST uzerinden sinirli komut yurutme.

### Build/Interop
- `src/build/interop_manifest.fbs`
  - INCLUDE recursive cozumleme
  - IMPORT compile/link plan artefaktlari
  - Path normalize/root siniri/guvenlik kontrolleri

### Legacy gecis
- `src/legacy/get_commands_port.fbs`
  - Tarihsel satir bolme davranisinin portu.

### Test
- `tests/run_manifest.bas`
  - CSV tabanli parser smoke harness.
- `tests/run_cmp_interop.bas`
  - INCLUDE/IMPORT resolver ve artefakt testleri.

---

## 11) Modul Seviyesi Ana Degiskenler ve Veri Yapilari

## 11.1 Lexer Durumu

`LexerState`:
- `sourceText`: tum kaynak metin
- `cursor`: mevcut karakter pozisyonu
- `lineNo`, `colNo`: hata raporu koordinatlari
- `tokens`: `TokenList`

## 11.2 Parser Durumu

`ParseState`:
- `lx`: lexer cikisi
- `cursorIndex`: token index
- `lastError`: son hata mesaji
- `ast`: `ASTPool`
- `rootNode`: PROGRAM node index

## 11.3 AST Veri Yapisi

`ASTNode` alanlari:
- `kind`, `value`, `op`
- `left`, `right`
- `firstChild`, `nextSibling`
- `lineNo`, `colNo`

Bu kombinasyon hem binary expr hem de n-ary statement cocuklarini tek havuzda tasir.

## 11.4 Tip Dogrulama Global Durumu

`parser_shared.fbs` icinde:
- `gDeclaredTypeNames()`
- `gDeclaredTypeCount`
- `gReferencedTypeNames()`
- `gReferencedTypeCount`

Parse sonunda `ValidateTypeReferences` cagrilir.

## 11.5 Memory Runtime Durumu

`VMemState`:
- `data()`, `sizeBytes`
- `textBase`, `textCols`, `textRows`
- `active`

Global:
- `g_vmem` (Shared)

## 11.6 Memory Executor Durumu

`ExecState`:
- `vars()`
- `count`

Amac: AST'deki sinirli statement alt kumelerini memory VM ile calistirmak.

---

## 12) Derleme ve Calisma Is Akisi

## 12.1 Build Komutlari

- `build.bat src\main.bas`
- `build_32.bat src\main.bas`
- `build_64.bat src\main.bas`
- `build_matrix.bat src\main.bas`

## 12.2 Parser Smoke

- Derle: `build.bat tests\run_manifest.bas`
- Calistir: `tests\run_manifest.exe`

`run_manifest.bas` su mantigi kullanir:
1. `tests/manifest.csv` oku
2. `result=pending` satirlarini sec
3. Ilk 180 satiri parserdan gecir
4. Expected etiketiyle AST/token kontrolu yap

## 12.3 Interop Smoke

- Derle: `build.bat tests\run_cmp_interop.bas`
- Calistir: `tests\run_cmp_interop.exe`

Kontrol edilenler:
- INCLUDE include-once count
- IMPORT count
- Artefakt dosyalarinin olusmasi
- CSV'de INCLUDE/IMPORT satirlari

## 12.4 Main Program Opsiyonlari

- `src/main.exe <source.bas>`
- `src/main.exe <source.bas> --execmem`

`--execmem` memory runtime yolunu aktif eder.

---

## 13) Uretilen Artefaktlar

## 13.1 Interop Artefaktlari

Resolver/build akisi su dosyalari uretir:
- `dist/cmp_interop/import_build_manifest.csv`
- `dist/cmp_interop/import_link_args.rsp`
- `dist/cmp_interop/import_link_plan_win11.txt`

## 13.2 Binary Ciktilar

Build scriptlerine gore:
- `*.exe` (default)
- `*_32.exe`
- `*_64.exe`

## 13.3 Release Katmani

Release otomasyonunda ilgili dosyalar:
- `release/ci_outputs.map`
- `release/RELEASE_CHECKLIST.md`
- `tools/release_mini.bat`

---

## 14) Komut/Fonksiyon Ozet Matrisi

Asagidaki ozet, "ne parserda var, ne runtime'da var" sorusunu hizli cevaplamak icindir.

### 14.1 Parser + Runtime aktif alt kume

- TIMER
- PEEKB/PEEKW/PEEKD
- POKEB/POKEW/POKED/POKE(alias)
- MEMCOPYB/MEMFILLB
- INC/DEC (memory exec yolu icinde)
- INCLUDE resolver
- IMPORT artefakt uretimi

### 14.2 Parser aktif, runtime semantigi daha genis calisma isteyenler

- IF/SELECT/FOR/DO
- OPEN/CLOSE/GET/PUT/SEEK
- INPUT/INPUT#
- DECLARE/SUB/FUNCTION
- DEF*/SETSTRINGSIZE
- CLS/COLOR/LOCATE
- Core intrinsiclerin bir bolumu (arity validation seviyesi)

### 14.3 Planli backlog

- VARPTR, SADD, LPTR, CODEPTR
- POKES, MEMCOPYW/D, MEMFILLW/D, SETNEWOFFSET
- INLINE x64 backend semantigi
- FILE I/O ileri semantik standardizasyonu

---

## 15) Tutarlilik Kararlari (Bu Belgeyi Okurken)

Bu bolum, ekipte "hangi syntax kesin" sorusunu hizli kapatir.

1. `IMPORT` yalnizca parantezli formdadir: `IMPORT(LANG, "file")`.
2. `GET/PUT` icin parser dogrusu: handle + 1..3 arguman.
3. `POKE` kanonikte vardir ama runtime'da `POKED` semantigine map edilir.
4. Suffix-tipli identifier kabul edilmez.
5. Legacy inline adlari kabul edilmez; `INLINE ... END INLINE` kullanilir.
6. `_` ile baslayan komut-cagri formlari engellenir (atama/incdec disinda).
7. UDT referanslari parse sonunda toplu dogrulanir.
8. Path guvenligi parser ve resolver tarafinda zorunludur.

---

## 16) Kisa Ornek Programlar

## 16.1 Tip + Fonksiyon + Akis

```bas
TYPE Vec2
    x AS I32
    y AS I32
END TYPE

DECLARE FUNCTION Len2(vx AS I32, vy AS I32) AS I32

FUNCTION Len2(vx AS I32, vy AS I32) AS I32
    RETURN vx * vx + vy * vy
END FUNCTION

DIM p AS Vec2
p.x = 3
p.y = 4

IF Len2(p.x, p.y) = 25 THEN
    PRINT "ok"
ELSE
    PRINT "fail"
END IF
```

## 16.2 INCLUDE/IMPORT ve Dosya I/O

```bas
INCLUDE "lib/common.bas"
IMPORT(C, "native/io.c")

OPEN "data.bin" FOR BINARY AS #1
GET #1, 1, 4, value
PUT #1, 1, 4, value
SEEK #1, 1
CLOSE #1
```

## 16.3 Bellek Alt Kumesi

```bas
POKEB 4096, 65
POKEW 4098, 4660
POKED 4100, 305419896

x = PEEKB(4096)
MEMFILLB 5000, 0, 128
MEMCOPYB 5000, 6000, 128
```

---

## 17) Sonuc

Bu belge, proje durumunu su netlikte kapatir:

1. uXBasic su anda parser/AST omurgasini oturtmus durumdadir.
2. Runtime, secili alt kumelerde gercek davranis sunar.
3. Interop tarafinda INCLUDE/IMPORT zinciri parserdan build artefaktina kadar isler.
4. Bir sonraki buyuk teknik adim, parser kapsamini runtime/backend semantigi ile tam eslemek olacaktir.

Bu nedenle ekipte teknik karar verilirken sira su olmali:
- once parser gercegi,
- sonra runtime gercegi,
- sonra backlog plani.
