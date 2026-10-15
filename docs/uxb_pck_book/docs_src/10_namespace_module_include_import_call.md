# Namespace, Module, Include, Import ve Dış Çağrı Ayrımı

uXBasic büyüdükçe tek dosya program yetmez. Kod bölümlere ayrılır, isimler çakışmasın diye alanlara alınır, başlık dosyaları eklenir, dış kaynaklar build hattına bağlanır ve runtime sırasında DLL/API rotaları çağrılır. Bu bölümün ana görevi, birbirine benzeyen ama aynı olmayan yapıları ayırmaktır.

## Namespace, using ve alias

```basic
NAMESPACE NS08
    FUNCTION ADD(a AS I32, b AS I32) AS I32
        RETURN a + b
    END FUNCTION
END NAMESPACE

USING NS08
ALIAS TOPLA AS ADD
PRINT TOPLA(10, 20)
PRINT ADD(7, 8)
```

Beklenen çıktı:

```text
30
15
```

`NAMESPACE` isim alanı kurar. `USING`, o isim alanındaki adları görünür yapar. `ALIAS`, bir ada ikinci bir kullanım adı verir. Bu üç yapı büyük programda okunabilirliği ve isim denetimini güçlendirir.

## Module ve main

```basic
MODULE Mod20
    FUNCTION MADD(a AS I32, b AS I32) AS I32
        RETURN a + b
    END FUNCTION
END MODULE

USING Mod20
MAIN
    PRINT MADD(2, 3)
END MAIN
```

Beklenen çıktı:

```text
5
```

`MODULE`, ilgili fonksiyonları bir araya toplar. `MAIN`, programın ana giriş bloğunu belirginleştirir.

## Include

```basic
INCLUDE "xtestx/project_packs/pack_12_preprocessor_include_foreach/support/math.uxbh"
PRINT INC12(30)
PRINT PACK12_CONST
```

`INCLUDE`, uXBasic başlık veya kaynak parçasını projeye ekler. Bu yapı, ortak fonksiyon ve sabitleri ayrı dosyada tutmak için kullanılır.

## Import

```basic
IMPORT(C, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.c")
IMPORT(CPP, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.cpp")
IMPORT(ASM, "xtestx/project_packs/pack_13_import_c_cpp_asm/native/a.asm")
PRINT "IMPORT_ROUTE"
```

`IMPORT`, yalnız derleme zamanı dış kaynak ekleme yoludur. `IMPORT(C, ...)`, `IMPORT(CPP, ...)` ve `IMPORT(ASM, ...)` geçerli yönlerdir. `IMPORT DLL`, `IMPORT API` veya `IMPORT LIB` kanonik kullanım değildir.

## DECLARE ve CALL(DLL)

```basic
DECLARE FUNCTION ux_route_14 LIB "uxmath.dll" ALIAS "ux_route_14" (BYVAL a AS I32, BYVAL b AS I32) AS I32
CALL(DLL, "uxmath.dll", "ux_route_14", 1, 2)
PRINT "FFI14_01"
```

`DECLARE ... LIB ... ALIAS ...`, dış fonksiyonun imzasını tanımlar. `CALL(DLL, ...)`, runtime sırasında DLL fonksiyon rotasını çağırır. Bu iki yapı `IMPORT` değildir; görevleri farklıdır.

## CALL(API)

```basic
CALL(API, "json", "noop", CDECL, 1)
CALL(API, "regex", "noop", CDECL, 2)
PRINT "API_ROUTE_SURFACE"
```

`CALL(API, ...)`, JSON, regex, web, dış servis veya benzer API rotaları için kullanılır. Kitapta `CALL(DLL)` ve `CALL(API)` aynı “dış dünya” ailesinde anlatılır; fakat DLL dosyası çağrısı ile API servis rotası birbirine karıştırılmaz.
