# PCK5 - uXBasic Onayli Dil Yuzeyi ve Ornekler

## 1. Kapsam

Bu belge "planlanan dil"i degil, repoda kod ve testlerle dogrulanmis ya da bu turdaki compiler build lane'i ile teyit edilmis yuzeyi toplar.

Durum etiketleri:

- `OK`: parser + semantic + runtime veya build lane ile dogrulandi
- `PARTIAL`: katmanlardan bazilari var, bazilarinda kisit var
- `TEMPLATE`: syntax veriliyor, gercek kullanim icin ortam DLL'i veya wrapper gerekiyor

## 2. Program Yapisi

### `MAIN ... END MAIN`

Syntax:

```basic
MAIN
    PRINT 123
END MAIN
```

Aciklama:

- Programin acik giris noktasi olarak kullanilir.
- x64 build lane'de final `main`/entry yapisina baglanir.

## 3. Komutlar

### `PRINT`

Syntax:

```basic
PRINT expr
PRINT "metin";
```

Aciklama:

- Konsola yazar.
- String ve integer odakli runtime/codegen yolu vardir.

Ornek:

```basic
PRINT "Merhaba"
PRINT 42
```

Durum: `OK`

### `INPUT`

Syntax:

```basic
INPUT x
INPUT ad$
```

Aciklama:

- Konsoldan veri alir.
- Runtime lane dogrulanmistir.

Durum: `OK`

### `IF ... THEN ... ELSE ... END IF`

Syntax:

```basic
IF x > 10 THEN
    PRINT "buyuk"
ELSE
    PRINT "kucuk"
END IF
```

Aciklama:

- Kosullu akistir.

Durum: `OK`

### `SELECT CASE`

Syntax:

```basic
SELECT CASE x
    CASE 1
        PRINT "bir"
    CASE IS > 10
        PRINT "buyuk"
    CASE ELSE
        PRINT "diger"
END SELECT
```

Aciklama:

- Birden cok kosullu dal yapisi sunar.

Durum: `OK`

### `FOR ... NEXT`

Syntax:

```basic
FOR i = 1 TO 10
    PRINT i
NEXT
```

Aciklama:

- Sayisal dongudur.
- `STEP` kullanimi da parser/runtime tarafinda bulunur.

Durum: `OK`

### `FOR EACH`

Syntax:

```basic
FOR EACH v, idx IN 10, 20, 30
    PRINT v
    PRINT idx
NEXT
```

Aciklama:

- Liste benzeri literal item akisi uzerinde doner.

Durum: `OK`

### `DO ... LOOP`

Syntax:

```basic
DO WHILE x < 10
    x = x + 1
LOOP
```

Aciklama:

- Kosullu dongudur.

Durum: `OK`

### `DO EACH`

Syntax:

```basic
DO EACH v IN 4, 5, 6
    PRINT v
LOOP
```

Aciklama:

- Item tabanli dongu modelidir.

Durum: `OK`

### `GOTO`, `GOSUB`, `RETURN`

Syntax:

```basic
GOTO done
GOSUB worker
RETURN
```

Aciklama:

- Klasik BASIC akis ve alt-rutin komutlari.

Durum: `OK`

### `EXIT`

Syntax:

```basic
EXIT FOR
EXIT DO
EXIT IF
```

Aciklama:

- Bulundugu bloktan erken cikis yapar.

Durum: `OK`

### `END`

Syntax:

```basic
END
```

Aciklama:

- Program akisini sonlandirir.

Durum: `OK`

### `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`

Syntax:

```basic
OPEN "a.dat" FOR BINARY AS #1
PUT #1, , x
SEEK #1, 1
GET #1, , y
CLOSE #1
```

Aciklama:

- Dosya I/O komutlaridir.

Durum: `OK`

### `CONST`

Syntax:

```basic
CONST PI2 = 6
```

Aciklama:

- Sabit tanimi yapar.

Durum: `OK`

### `DIM`

Syntax:

```basic
DIM x AS I32
DIM y AS STRING = "merhaba"
DIM arr(0 TO 9) AS I32
```

Aciklama:

- Degisken ve dizi tanimlar.

Durum: `OK`

### `REDIM`

Syntax:

```basic
REDIM arr(0 TO 19) AS I32
REDIM PRESERVE arr(0 TO 29) AS I32
```

Aciklama:

- Dizi boyutunu yeniden duzenler.

Durum: `OK`

### `TYPE`

Syntax:

```basic
TYPE Vec2
    x AS I32
    y AS I32
END TYPE
```

Aciklama:

- Alanli kullanici veri tipi tanimlar.

Durum: `OK`

### `CLASS`, `INTERFACE`, `NEW`, `DELETE`

Syntax:

```basic
CLASS Counter
END CLASS

INTERFACE ILog
END INTERFACE
```

Aciklama:

- OOP yuzeyi repoda mevcut ve testleri vardir.
- Native x64 codegen kapsami bu alanda tum ayrintilar icin henuz tam degildir.

Durum: `PARTIAL`

### `DECLARE SUB`, `DECLARE FUNCTION`

Syntax:

```basic
DECLARE SUB Show()
DECLARE FUNCTION Add(a AS I32, b AS I32) AS I32
```

Aciklama:

- Imza bildirimi yapar.
- Parser/runtime seviyesi dogrulanmistir.

Durum: `OK`

### `INCLUDE`

Syntax:

```basic
INCLUDE "ortak.bas"
```

Aciklama:

- Kaynak dosya dahil eder.

Durum: `OK`

### `IMPORT(C/CPP/ASM, "file")`

Syntax:

```basic
IMPORT(C, "native/helper.c")
IMPORT(CPP, "native/mod.cpp")
IMPORT(ASM, "native/entry.asm")
```

Aciklama:

- Build manifest ve native artefact lane'ine dis kaynak ekler.

Durum: `OK`

### `INLINE(...) ... END INLINE`

Syntax:

```basic
INLINE("x64","nasm","sub","abi=win64;preserve=rbx;stack=16;shadow=32")
END INLINE
```

Aciklama:

- Modern inline/native blok syntax'idir.
- Parser ve x64 policy validation vardir.
- Ana native emit akisina tam butunlesme henuz tamamlanmamistir.

Durum: `PARTIAL`

### `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT`

Syntax:

```basic
DEFINT A-Z
DEFSTR S-T
```

Aciklama:

- Isim araligina varsayilan tip atar.

Durum: `OK`

### `SETSTRINGSIZE`

Syntax:

```basic
SETSTRINGSIZE 64
```

Aciklama:

- Varsayilan string buffer alanini ayarlar.

Durum: `OK`

### `CLS`, `COLOR`, `LOCATE`

Syntax:

```basic
CLS
COLOR 14, 1
LOCATE 5, 10
```

Aciklama:

- Konsol ekran kontrol komutlaridir.
- Runtime ve x64 codegen tarafinda minimal destek vardir.

Durum: `OK`

### `INC`, `DEC`

Syntax:

```basic
INC x
DEC y
```

Aciklama:

- Kisaltma arttirma/azaltma komutlari.

Durum: `OK`

### `POKEB`, `POKEW`, `POKED`, `POKE`

Syntax:

```basic
POKEB 100, 1
POKEW 200, 1024
POKED 300, 777
```

Aciklama:

- Sanal bellek veya runtime memory lane uzerine yazar.

Durum: `OK`

### `MEMCOPYB`, `MEMFILLB`

Syntax:

```basic
MEMFILLB 1000, 255, 16
MEMCOPYB 2000, 1000, 16
```

Aciklama:

- Yardimci bellek komutlaridir.

Durum: `OK`

## 4. Dahili Fonksiyonlar

### Metin

`LEN`, `MID`, `UCASE`, `LCASE`, `LTRIM`, `RTRIM`, `SPACE`, `STRING`, `ASC`, `CHR`, `STR`, `VAL`

Ornek:

```basic
PRINT LEN("abc")
PRINT MID("ABCDE", 2, 2)
PRINT UCASE("abc")
PRINT LTRIM("   a")
PRINT STRING(3, 65)
```

Durum: `OK`

### Sayisal

`ABS`, `INT`, `FIX`, `SGN`, `SQR`, `SQRT`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`, `CINT`, `CLNG`, `CDBL`, `CSNG`

Ornek:

```basic
PRINT ABS(-7)
PRINT FIX(3.9)
PRINT SIN(0)
PRINT LOG(1)
PRINT CINT(3.2)
```

Durum: `OK`

### Rastgelelik / Zaman / Tus

`RND`, `RANDOMIZE`, `TIMER`, `INKEY`, `GETKEY`

Ornek:

```basic
RANDOMIZE
PRINT RND(1)
PRINT TIMER("ms")
PRINT GETKEY()
```

Durum: `OK`

### Dosya

`LOF`, `EOF`

Ornek:

```basic
PRINT LOF(1)
PRINT EOF(1)
```

Durum: `OK`

### Bellek

`PEEKB`, `PEEKW`, `PEEKD`

Ornek:

```basic
x = PEEKD(1000)
PRINT x
```

Durum: `OK`

## 5. Operatorler

### Aritmetik

- `+`
- `-`
- `*`
- `/`
- `MOD`

Ornek:

```basic
x = 10 + 3
y = 10 MOD 4
```

Durum: `OK`

### Karsilastirma

- `=`
- `<>`
- `<`
- `<=`
- `>`
- `>=`

Ornek:

```basic
ok = (x >= y)
```

Durum: `OK`

### Mantiksal / bitwise

- `AND`
- `OR`
- `XOR`
- `NOT`

Ornek:

```basic
mask = (1 SHL 4) OR 1
```

Durum: `OK`

### Kaydirma / rotate

- `SHL`
- `SHR`
- `ROL`
- `ROR`

Ornek:

```basic
a = 1 SHL 4
b = 8 SHR 1
c = 1 ROL 3
```

Durum: `OK`

### Atama ve bilesik atama

- `=`
- `+=`
- `-=`
- `*=`
- `/=`

Not:

- Bilesik atama operatorleri repoda test artefactlariyla izleniyor.
- Native kapsami ifade turune gore degisebilir.

Durum: `PARTIAL`

## 6. Degiskenler

### Skaler degiskenler

Syntax:

```basic
DIM x AS I32
DIM name AS STRING
```

Durum: `OK`

### Diziler

Syntax:

```basic
DIM arr(0 TO 9) AS I32
```

Durum: `OK`

### Varsayilan tip atamasi

Syntax:

```basic
DEFINT A-Z
x = 10
```

Durum: `OK`

## 7. Veri Tipleri

Asagidaki tipler kod ve testlerle teyit edilmis cekirdek tip ailesidir:

- `I8`
- `U8`
- `I16`
- `U16`
- `I32`
- `U32`
- `I64`
- `U64`
- `F32`
- `F64`
- `BOOLEAN`
- `STRING`
- `POINTER` / `PTR` baglamlari

Ornek:

```basic
DIM a AS I8 = 1
DIM b AS U8 = 2
DIM c AS I16 = 3
DIM d AS I32 = 4
DIM e AS I64 = 5
DIM f AS F64 = 2.5
DIM ok AS BOOLEAN = 1
DIM s AS STRING = "ab"
```

Durum: `OK`

## 8. Veri Yapilari

### `TYPE`

Alanli veri yapisi.

```basic
TYPE Point
    x AS I32
    y AS I32
END TYPE
```

Durum: `OK`

### `LIST`, `DICT`, `SET`

Syntax:

```basic
DIM l AS LIST
DIM d AS DICT
DIM s AS SET
```

Aciklama:

- Runtime handle tabanli koleksiyon tipleri.

Durum: `OK`

### `CLASS`, `INTERFACE`

OOP modelinin ust veri yapilari.

Durum: `PARTIAL`

## 9. FFI ve DLL Kullanimi

### `CALL(DLL, ...)`

Genel syntax:

```basic
sonuc = CALL(DLL, "kernel32.dll", "GetTickCount", I32)
CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
```

Aciklama:

- DLL yukler, sembol bulur ve cagrir.
- `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYVAL`, `BYREF` signature tokenlari kullanilir.

Onemli sinir:

- mevcut runtime FFI modeli tek cagrida tum argumanlari ayni signature ailesinde marshall eder
- bu nedenle karisik tipli Win32 ve modern C API'lerde bazen wrapper/shim gerekir

Durum: `OK`

## 10. Windows Kernel ve GUI DLL Ornekleri

### Kernel32 sleep ve tick

```basic
MAIN
    t0 = TIMER("ms")
    CALL(DLL, "kernel32.dll", "Sleep", I32, STDCALL, 25)
    t1 = TIMER("ms")
    delta = t1 - t0
    PRINT delta
END MAIN
```

### User32 ekran olculeri

```basic
MAIN
    w = CALL(DLL, "user32.dll", "GetSystemMetrics", I32, STDCALL, 0)
    h = CALL(DLL, "user32.dll", "GetSystemMetrics", I32, STDCALL, 1)
    PRINT w
    PRINT h
END MAIN
```

### User32 interaktif message box

```basic
MAIN
    rc = CALL(DLL, "user32.dll", "MessageBoxA", BYVAL, STDCALL, 0, 0, 0, 0)
    PRINT rc
END MAIN
```

Not:

- Son ornek interaktiftir; otomatik testte bloke olabilir.

## 11. Harici Kutuphaneler Icin uXBasic Ornekleri

### GNU MPFR

```basic
MAIN
    tls = CALL(DLL, "libmpfr-6.dll", "mpfr_buildopt_tls_p", I32, CDECL)
    PRINT tls
END MAIN
```

### Arb / FLINT

```basic
MAIN
    CALL(DLL, "libflint.dll", "flint_cleanup", BYVAL, CDECL)
    PRINT 1
END MAIN
```

Not:

- Gercek `arb_t` nesneleri icin C shim daha pratiktir.

### Lua

```basic
MAIN
    L = CALL(DLL, "lua54.dll", "luaL_newstate", PTR, CDECL)
    PRINT L
    CALL(DLL, "lua54.dll", "lua_close", PTR, CDECL, L)
END MAIN
```

### Python

```basic
MAIN
    CALL(DLL, "python313.dll", "Py_Initialize", BYVAL, CDECL)
    ok = CALL(DLL, "python313.dll", "Py_IsInitialized", I32, CDECL)
    PRINT ok
    CALL(DLL, "python313.dll", "Py_FinalizeEx", I32, CDECL)
END MAIN
```

### SWI-Prolog

```basic
MAIN
    ok0 = CALL(DLL, "libswipl.dll", "PL_is_initialised", PTR, CDECL, 0, 0)
    PRINT ok0
END MAIN
```

### Fuzzy Prolog

```basic
MAIN
    ok = CALL(DLL, "fuzzyprolog.dll", "FuzzyInit", I32, CDECL)
    PRINT ok
END MAIN
```

Not:

- DLL adi ve export ismi vendor paketine gore duzeltilmelidir.

### libcurl

```basic
MAIN
    rc = CALL(DLL, "libcurl.dll", "curl_global_init", I32, CDECL, 3)
    h = CALL(DLL, "libcurl.dll", "curl_easy_init", PTR, CDECL)
    PRINT rc
    PRINT h
END MAIN
```

## 12. REST ve Kutuphane Iskeletleri

Bugunku uXBasic ile REST icin iki pratik yol vardir:

1. `libcurl.dll` uzerinden bootstrap/probe ve ileride shim ile genisletme
2. Windows `winhttp.dll` veya `wininet.dll` uzerinden probe ve ileride shim ile genisletme

Onerilen kutuphane modeli:

- `uxb_http_libcurl_template.bas`
- `uxb_http_winhttp_template.bas`
- karisik tipli API'ler icin ince C shim

## 13. Bu Belgede Referanslanan Ornek Dosyalar

Asagidaki yeni `.bas` dosyalari `tests/basicCodeTests/` altinda yazildi:

- `31_uxb_windows_kernel_sleep_tick.bas`
- `32_uxb_windows_user32_metrics.bas`
- `33_uxb_windows_user32_messagebox_interactive.bas`
- `34_uxb_mpfr_probe.bas`
- `35_uxb_arb_flint_probe.bas`
- `36_uxb_lua54_probe.bas`
- `37_uxb_python_embed_probe.bas`
- `38_uxb_swipl_probe.bas`
- `39_uxb_fuzzy_prolog_template.bas`
- `40_uxb_libcurl_probe.bas`
- `41_uxb_winhttp_probe.bas`
- `42_uxb_native_console_codegen_smoke.bas`
- `43_uxb_native_flow_math_codegen_smoke.bas`
