# uXBasic Programcinin El Kitabi

Bu dokuman parser gercegi + test plani uzerinden standardize edilmis tek referanstir.
Hedef profil: Windows 11 x64.

## 1. Amac

- Belgedeki tum syntax kaliplari parser tarafinda gecerli olmalidir.
- Corrupt satirlar, kopya bolumler ve celiskili ornekler temizlenmistir.
- Komutlar iki etikette verilir:
  - implemented: parser/test ile dogrulanmis.
  - planned: parser veya runtime backlog.

## 2. Lexer Gercegi ve Yazim Kurali

### 2.1 Identifier Kurali

Parser identifier kurali:

- baslangic: harf veya `_`
- devam: harf, rakam veya `_`
- pratik regex: `[A-Za-z_][A-Za-z0-9_]*`

Sonuc:

- `x%`, `name$`, `pid&` gibi sonekli degisken adlari gecerli degildir.
- Turkce karakterli degisken adlari yerine ASCII ad kullan.

### 2.2 Sonek Tip Isaretleri

Strict parser profilinde su sonekler degisken adinin parcasi degildir:

- `$`, `%`, `&`, `!`, `#`, `@`

Tip belirtimi sadece `AS TYPE` ile yapilir.

### 2.3 Anahtar Kelime ve Operator

- keyword tanima buyuk/kucuk harf duyarsizdir.
- parser operatorleri: `+ - * / \\ % = < > <= >= <> ** << >> += -= *= /= \\= =+ =- ++ -- @`.

## 3. Tip Sistemi (Parser Builtin)

Builtin tip adlari:

- `I8`, `U8`
- `I16`, `U16`
- `I32`, `U32`
- `I64`, `U64`
- `F32`, `F64`, `F80`
- `BOOLEAN`
- `STRING`
- `ARRAY`, `LIST`, `DICT`, `SET`

Not:

- `LONG`, `INTEGER`, `DOUBLE`, `SINGLE`, `BYTE` parser builtin listesinde yoktur.
- `STRING * N` formu parser syntaxinda yoktur.

## 4. Parser Uyumlu Standart Soz Dizimi

### 4.1 Akis Komutlari

- `IF expr THEN ... [ELSEIF expr THEN ...] [ELSE ...] END IF`
- `SELECT CASE expr ... CASE expr [,expr ...] ... [CASE ELSE ...] END SELECT`
- `FOR ident = expr TO expr [STEP expr] ... NEXT [ident]`
- `DO [WHILE expr | UNTIL expr] ... LOOP [WHILE expr | UNTIL expr]`
- `GOTO label`
- `GOSUB label`
- `RETURN [expr]`
- `EXIT [FOR|DO]`
- `END`

### 4.2 Tanim ve Yapi Komutlari

- `CONST name = expr [, ...]`
- `DIM name[(bounds)] AS TYPE [= expr] [, ...]`
- `REDIM name[(bounds)] AS TYPE [, ...]`
- `TYPE Name ... field AS TYPE ... END TYPE`
- `DECLARE SUB Name(params)`
- `DECLARE FUNCTION Name(params) AS TYPE`
- `SUB Name(params) ... END SUB`
- `FUNCTION Name(params) AS TYPE ... END FUNCTION`
- `DEFINT rangeList`
- `DEFLNG rangeList`
- `DEFSNG rangeList`
- `DEFDBL rangeList`
- `DEFEXT rangeList`
- `DEFSTR rangeList`
- `DEFBYT rangeList`
- `SETSTRINGSIZE expr`
- `INCLUDE "file.bas"`
- `IMPORT(LANG, "file.ext")`

IMPORT notlari:

- `LANG`: `C`, `CPP`, `ASM`
- uzanti dil ile uyumlu olmalidir.

### 4.3 Giris-Cikis ve Dosya Komutlari

- `PRINT expr [,|; expr ...]`
- `INPUT target [, target ...]`
- `INPUT "prompt"; target [, target ...]`
- `INPUT #handle, target [, target ...]`
- `OPEN fileExpr FOR mode AS [#]handleExpr`
- `CLOSE`
- `CLOSE [#]handleExpr [, [#]handleExpr ...]`
- `GET [#]handleExpr, targetExpr`
- `GET [#]handleExpr, posExpr, targetExpr`
- `GET [#]handleExpr, posExpr, bytesExpr, targetExpr`
- `PUT [#]handleExpr, sourceExpr`
- `PUT [#]handleExpr, posExpr, sourceExpr`
- `PUT [#]handleExpr, posExpr, bytesExpr, sourceExpr`
- `SEEK [#]handleExpr [, posExpr]`
- `LOCATE rowExpr, colExpr`
- `COLOR fgExpr, bgExpr`
- `CLS`

Dosya handle notu:

- parser `#` isaretini kabul eder, zorunlu degildir.
- belge standardinda handle yaziminda `#` onerilir.
- legacy uyumluluk icin GET/PUT komutlarinda `pos` ve `bytes` ara argumanlari da kabul edilir.

### 4.4 Bellek ve Yardimci Komutlar

- `INC ident`
- `DEC ident`
- `RANDOMIZE [seedExpr]`
- `POKEB addrExpr, valueExpr`
- `POKEW addrExpr, valueExpr`
- `POKED addrExpr, valueExpr`
- `POKE addrExpr, valueExpr` (legacy alias, POKED semantigi)
- `MEMCOPYB srcExpr, dstExpr, countExpr`
- `MEMFILLB addrExpr, countExpr, valueExpr`
- `INLINE(...) ... END INLINE`

## 5. Intrinsic Fonksiyon Imzalari (Parser Validation)

### 5.1 1 Arguman

- `LEN(expr)`
- `STR(expr)`
- `VAL(expr)`
- `ABS(expr)`
- `INT(expr)`
- `UCASE(expr)`
- `LCASE(expr)`
- `ASC(expr)`
- `CHR(expr)`
- `LTRIM(expr)`
- `RTRIM(expr)`
- `SPACE(expr)`
- `SGN(expr)`
- `SQRT(expr)`
- `SIN(expr)`
- `COS(expr)`
- `TAN(expr)`
- `ATN(expr)`
- `EXP(expr)`
- `LOG(expr)`
- `CINT(expr)`
- `CLNG(expr)`
- `CDBL(expr)`
- `CSNG(expr)`
- `FIX(expr)`
- `SQR(expr)`
- `LOF(expr)`
- `EOF(expr)`
- `PEEKB(expr)`
- `PEEKW(expr)`
- `PEEKD(expr)`

### 5.2 Diger Arity Kurallari

- `MID(strExpr, startExpr [, lenExpr])` -> 2..3 arg
- `STRING(countExpr, charExpr)` -> 2 arg
- `RND([expr])` -> 0..1 arg
- `INKEY(flagsExpr [, stateExpr])` -> 1..2 arg
- `GETKEY()` -> 0 arg
- `TIMER()` / `TIMER(unitStr)` / `TIMER(startExpr, endExpr, unitStr)` -> 0, 1 veya 3 arg

## 6. Parser Uyumlu Ornekler

### 6.1 Temel If

```bas
DIM score AS I32 = 85

IF score >= 90 THEN
    PRINT "A"
ELSEIF score >= 80 THEN
    PRINT "B"
ELSE
    PRINT "C"
END IF
```

### 6.2 FOR + SUB + FUNCTION

```bas
DECLARE FUNCTION Add(a AS I32, b AS I32) AS I32
DECLARE SUB Show(v AS I32)

FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

SUB Show(v AS I32)
    PRINT v
END SUB

DIM i AS I32
FOR i = 1 TO 3
    Show(Add(i, 10))
NEXT i
```

### 6.3 TYPE / UDT

```bas
TYPE Vec2
    x AS I32
    y AS I32
END TYPE

DIM p AS Vec2
p.x = 10
p.y = 20
PRINT p.x
PRINT p.y
```

### 6.4 INPUT ve INPUT#

```bas
DIM name AS STRING
DIM age AS I32

INPUT "Name?"; name
INPUT "Age?"; age

OPEN "in.txt" FOR INPUT AS #1
INPUT #1, name, age
CLOSE #1
```

### 6.5 OPEN / GET / PUT / SEEK

```bas
DIM value AS I32

OPEN "data.bin" FOR RANDOM AS #1

value = 42
SEEK #1, 1
PUT #1, value

value = 0
SEEK #1, 1
GET #1, value

PRINT value
CLOSE #1
```

### 6.6 LOCATE / COLOR / CLS

```bas
CLS
COLOR 2, 0
LOCATE 5, 10
PRINT "uXBasic"
COLOR 7, 0
```

### 6.7 INCLUDE / IMPORT

```bas
INCLUDE "lib.bas"
IMPORT(C, "cmod.c")
IMPORT(CPP, "cpmod.cpp")
IMPORT(ASM, "asmstub.asm")
```

## 7. Komut Durum Matrisi (Ozet)

### 7.1 Implemented

- PRINT, CONST, DIM, REDIM, TYPE
- DECLARE, SUB, FUNCTION
- INCLUDE, IMPORT, INLINE
- IF, SELECT CASE, FOR, DO, GOTO, GOSUB, RETURN, EXIT, END
- TIMER
- OPEN, CLOSE, GET, PUT, SEEK, LOF, EOF
- LOCATE, COLOR, CLS
- INPUT, INPUT#
- LEN, MID, STR, VAL, ABS, INT, UCASE, LCASE, ASC, CHR, LTRIM, RTRIM, STRING, SPACE, SGN, SQRT, SIN, COS, TAN, ATN, EXP, LOG
- INKEY, GETKEY
- DEFINT, DEFLNG, DEFSNG, DEFDBL, DEFEXT, DEFSTR, DEFBYT
- SETSTRINGSIZE
- CINT, CLNG, CDBL, CSNG, FIX, SQR, RND, RANDOMIZE

### 7.2 Planned

- VARPTR, SADD, LPTR, CODEPTR
- POKES
- MEMCOPYW, MEMCOPYD
- MEMFILLW, MEMFILLD
- SETNEWOFFSET
- FILE_IO_ADVANCED
- INLINE x64 backend semantiklerinin tamamlanmasi

## 8. Bilincli Olarak Kaldirilan Hatali/Karmasik Kullanimlar

- sonekli degisken adlari (`x%`, `name$`, `pid&`)
- parser builtin olmayan tip adlariyla ornekler (`LONG`, `INTEGER`, vb.)
- `STRING * N`
- parser desteklemeyen bozuk print-channel kaliplari
- tekrar eden ve birbirini kopyalayan EK bloklari
- bozulmus (corrupt) satirlar ve anlamsiz karisimlar

## 9. Hizli Referans

- degisken: `DIM n AS I32`
- dizi: `DIM a(0 TO 9) AS I32`
- udt: `TYPE T ... END TYPE`
- fonksiyon: `FUNCTION F() AS I32 ... END FUNCTION`
- input: `INPUT "Prompt"; x`
- dosya: `OPEN "f" FOR INPUT AS #1`, `GET #1, x`, `PUT #1, x`, `SEEK #1, 10`
- intrinsics: `LEN(x)`, `MID(s,1,3)`, `GETKEY()`, `TIMER("ms")`

## 10. Kaynaklar

Bu standardizasyon su kaynaklardan cikartilmistir:

- parser statement dispatch ve parser modulleri
- lexer identifier/keyword kurallari
- expression intrinsic arguman dogrulamasi
- tests/plan/command_compatibility_win11.csv

Bu belge append-only duplicate yaklasimi yerine tekil ve sistematik kaynak olarak korunmalidir.
