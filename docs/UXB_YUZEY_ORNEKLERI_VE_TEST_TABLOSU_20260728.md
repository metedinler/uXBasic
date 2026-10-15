# uXBasic yüzey örnekleri ve test tablosu

Bu belge `docs/uxbasic kitap`, gerçek lexer tablosu, preprocess motoru,
`libsx` kütüphane sarmalayıcıları ve mevcut testler karşılaştırılarak
üretilmiştir. Amaç zaten var olan örnekleri yeniden yazmak değil, boşlukları
tamamlamaktır.

## Son kapsam

| Yüzey | Gerçek kaynak | Etkin örnek kapsamı | Test |
|---|---|---:|---|
| Lexer anahtar sözcükleri, tipler, built-in fonksiyonlar, operatörler | `src/parser/lexer/lexer_keyword_table.fbs` | 222/222 | `tests/surface_gaps` ve mevcut testler |
| Preprocess komutları | `src/preprocessor` | 40/40 | `tests/surface_gaps` ve mevcut testler |
| `libsx` kütüphane FUNCTION/SUB imzaları | `libsx/ux*/ux*.bas` | 940/940 | 35 kütüphane, 752 yeni imza testi |

Makinece okunabilir ayrıntı:

- `reports/surface_example_gaps.json`
- `reports/library_surface_gaps/results.csv`
- `reports/library_surface_gaps/summary.json`

## Yeni mantık operatörleri

Bu eş adlar daha önce yürütülebilir örnekte yoktu:

| Operatör | Kanonik davranış |
|---|---|
| `NXOR`, `EQV`, `EQA`, `IFF` | `XNOR` |
| `CIMP` | `a OR (NOT b)` |
| `NIMP` | `a AND (NOT b)` |
| `NCIMP` | `(NOT a) AND b` |
| `IDA`, `IDB` | sırasıyla sol veya sağ değeri geçirir |
| `NOTA`, `NOTB` | sırasıyla sol veya sağ değili |

Kısa program:

```basic
PRINT 5 NXOR 3
PRINT 5 CIMP 3
PRINT 5 IDA 3
PRINT 5 NOTB 3
```

Beklenen çıktı:

```text
-7
-3
5
-4
```

Tam test: `tests/surface_gaps/01_logic16_aliases.uxb`.

## Yeni preprocess B örneği

```basic
%%PP B
%%TARGET WEB
%%CAPABILITY console ON
%%EXPORT_BASIC AddTwo AS "I32(I32,I32)"
%%HOST_IMPORT env.print_i32 AS host_print SIG "I32(I32)"
%%REPEAT 2
PRINT "REPEAT_OK"
%%ENDREPEAT
```

Beklenen çıktı iki kez `REPEAT_OK` satırıdır. Tam test:
`tests/surface_gaps/02_preprocessor_b_uncovered.uxb`.

## Kütüphane testlerinin anlamı

Kütüphanelerde iki test düzeyi kullanılır:

1. Mevcut smoke/integration testleri DLL’i gerçekten çağıran temsilci davranış
   testleridir.
2. Yeni `tests/library_surface_gaps` dosyaları, daha önce hiç örneklenmemiş her
   API imzasını `IF FALSE THEN` içinde parser ve semantic katmanından geçirir.

İkinci düzey güvenlik nedeniyle ağ isteği, dosya silme, süreç öldürme, model
çalıştırma veya bellek serbest bırakma gibi yan etkili yüzlerce API’yi sıfır
tanıtıcıyla gerçekten çağırmaz. Buna rağmen INCLUDE, namespace, fonksiyon adı,
parametre sayısı, parametre türü ve çağrı sözdizimi derleyici tarafından
doğrulanır; programın sonundaki sabit PASS satırı beklenen değerle karşılaştırılır.

Örnek:

```basic
INCLUDE "include/modules/uxhttp.uxmh"

MAIN
    IF FALSE THEN
        PRINT uxhttp.SetMethod(0, "")
        PRINT uxhttp.Perform(0)
        PRINT uxhttp.ResponseText(0)
    END IF
    PRINT "PASS_LIBRARY_SURFACE_UXHTTP"
END MAIN
```

## Test komutları

Yalnız lexer/preprocess boşlukları:

```powershell
.\tests\surface_gaps\run_surface_gap_tests.ps1
```

Bütün eksik kütüphane imzaları:

```powershell
.\tests\library_surface_gaps\run_library_surface_tests.ps1
```

Tek veya birkaç kütüphane:

```powershell
.\tests\library_surface_gaps\run_library_surface_tests.ps1 `
  -Libraries uxhttp,uxjson,uxsqlite
```

Kapsamı yeniden çıkarma ve yalnız eksik testleri üretme:

```powershell
python .\tools\analyze_surface_example_gaps.py
python .\tools\generate_missing_library_surface_tests.py
```

Üretici, mevcut `tests\ux*` örneklerinde zaten çağrılan API’leri yeniden
üretmez.
