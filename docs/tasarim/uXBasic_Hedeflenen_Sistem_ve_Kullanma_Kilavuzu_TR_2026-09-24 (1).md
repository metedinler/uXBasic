# uXBasic Hedeflenen Sistem ve Kullanma Kılavuzu

**Belge tarihi:** 24 Eylül 2026  
**Temel:** `uxb(23.09).zip` kaynak ağacı + uXBasic için birlikte kararlaştırılmış hedef tasarımlar  
**Belge türü:** Hedeflenen tam sistemin kullanım ve mimari kılavuzu

> Bu belge, hedef sistemin sözleşmesini ve kullanım yüzeyini anlatır; canlı
> uygulama durumu değildir. “Hedefte var” anlatımı, kaynakta tamamlandığı
> anlamına gelmez. Gerçek durum için `docs/tasarim/UXB_KOD_TASARIM_UZLASTIRMA_DENETIMI_20260924_TR.md`
> ve `ai_koordinasyon/SORUN_TAKIP.md` bağlayıcı denetim kayıtlarıdır. Özellikle
> TASK, library provider, JS/WASM/native parity ve lifecycle bölümleri hedef
> sözleşmedir; açık işler tamamlanmış gibi yorumlanamaz.

---

# 1. uXBasic'in amacı

uXBasic, klasik BASIC okunabilirliğini korurken sistem programlama, nesne yönelimli programlama, bilimsel hesaplama, veri bilimi, yapay zekâ, olay güdümlü programlama, gerçek eşzamanlı görev yürütme, meta programlama ve web üretimini aynı dil yüzeyinde birleştiren çok paradigmalı bir programlama dilidir.

Dil tek bir çalışma motoruna bağlı değildir. Aynı programın gözlenebilir anlamı AST yorumlayıcı, kanonik MIR, yerel x64, JavaScript ve WebAssembly hedeflerinde korunur.

```text
uXBasic kaynak
    ↓
önişlemci / meta katmanı
    ↓
lexer + parser
    ↓
AST
    ↓
tip bağlama + anlamsal çözümleme
    ↓
kanonik MIR
    ↓
┌─────────────┬──────────────┬───────────────┐
│ yerel x64   │ JavaScript   │ WASM / WAT    │
└─────────────┴──────────────┴───────────────┘
    ↓
çalışma zamanı + kütüphaneler + host sağlayıcıları
```

Bir özellik hedefte sessizce yok sayılamaz. Her özellik `DIRECT`, `PORTABLE_RUNTIME`, `TARGET_RUNTIME`, `HOST_PROVIDER`, `EMULATED` veya `COMPILE_TIME` yollarından biriyle gerçekleştirilir; karşılığı yoksa derleme açık hata verir.

---

# 2. En küçük program

```basic
MAIN
    PRINT "Merhaba uXBasic"
END MAIN
```

Yordamlar `SUB` ve `FUNCTION` ile tanımlanır:

```basic
FUNCTION Kare(x AS I32) AS I32
    RETURN x * x
END FUNCTION

SUB MesajYaz(text AS STRING)
    PRINT text
END SUB

MAIN
    MesajYaz("Sonuc:")
    PRINT Kare(12)
END MAIN
```

Atama ve karşılaştırma bilinçli olarak ayrılır:

```basic
x = 10

IF x == 10 THEN
    PRINT "x on"
END IF
```

`=` atamadır; ifade/koşul bağlamında eşitlik kanoniğine de indirgenebilse de yeni kodda karşılaştırma için `==` kullanımı tercih edilir.

---

# 3. Veri tipleri

## 3.1 Tamsayılar

| Tip | Anlam |
|---|---|
| `I8` | 8 bit işaretli |
| `U8` | 8 bit işaretsiz |
| `I16` | 16 bit işaretli |
| `U16` | 16 bit işaretsiz |
| `I32` | 32 bit işaretli |
| `U32` | 32 bit işaretsiz |
| `I64` | 64 bit işaretli |
| `U64` | 64 bit işaretsiz |
| `BIGINT` | büyük tamsayı |

`U32 op U32` sonucu `U32` olarak kalır ve taşma mod 2^32 davranışı gösterir. `U8/U16` gibi küçük türler normal aritmetikte daha geniş türe yükseltilebilir.

## 3.2 Kayan nokta ve geniş duyarlık

| Tip | Amaç |
|---|---|
| `F32` | 32 bit kayan nokta |
| `F64` | 64 bit kayan nokta |
| `F80` | genişletilmiş duyarlık |
| `F128` | 128 bit / quad duyarlık |
| `BIGF` | keyfi duyarlıklı büyük kayan sayı |
| `BIGD` | büyük ondalık |
| `BALL` | değer + hata yarıçapı / ball arithmetic |

```basic
DIM x AS F80
DIM y AS F128
DIM z AS BIGF

x = F80("3.141592653589793238")
y = F128("1.234567890123456789")
z = BIGF("2.718281828459045235")
```

## 3.3 Metin

```basic
DIM s AS STRING
DIM ws AS WSTRING
```

Metin işlevleri:

```basic
PRINT LEN(s)
PRINT LEFT(s, 3)
PRINT RIGHT(s, 4)
PRINT MID(s, 2, 5)
PRINT INSTR(s, "abc")
PRINT UCASE(s)
PRINT LCASE(s)
PRINT TRIM(s)
```

## 3.4 Sistem ve çalışma zamanı tipleri

uXBasic hedef tip sistemi ayrıca şunları taşır:

```text
BOOLEAN
OBJECT
VARIANT
ANY
ARRAY
LIST
DICT
SET
PTR
STRPTR
WSTRPTR
FUNCTION_PTR
DLL_HANDLE
FILE_HANDLE
JS_OBJECT
WASM_EXTERNREF
TASK
TASKGROUP
```

`TASK`, belirli bir `SPAWN` çalışma örneğinin opak tutamacıdır. `TASKGROUP`, birden fazla TASK'ı bir grup halinde yönetir.

---

# 4. Değişkenler, sabitler ve diziler

```basic
DIM adet AS I32 = 10
DIM sicaklik AS F64
DIM ad AS STRING
DIM aktif AS BOOLEAN = TRUE

CONST MAX_RETRY AS I32 = 5
```

Dizi:

```basic
DIM veri(99) AS F64

FOR i = LBOUND(veri) TO UBOUND(veri)
    veri(i) = i * 0.25
NEXT i
```

Dinamik yeniden boyutlandırma:

```basic
REDIM veri(999)
```

Çok boyutlu dizi:

```basic
DIM matris(9, 9) AS F64
matris(2, 3) = 7.25
```

---

# 5. Koleksiyonlar ve kullanıcı veri yapıları

## 5.1 LIST

```basic
DIM sayilar AS LIST

LISTADD(sayilar, 10)
LISTADD(sayilar, 20)
LISTADD(sayilar, 30)

PRINT LISTLEN(sayilar)
PRINT LISTGET(sayilar, 1)

LISTSET(sayilar, 1, 25)
LISTREMOVE(sayilar, 0)
```

## 5.2 DICT

```basic
DIM hata AS DICT

DICTSET(hata, "OK", 0)
DICTSET(hata, "UYARI", 1)
DICTSET(hata, "HATA", 2)

IF DICTHAS(hata, "HATA") THEN
    PRINT DICTGET(hata, "HATA")
END IF
```

## 5.3 SET

```basic
DIM benzersiz AS SET

SETADD(benzersiz, "Tank-1")
SETADD(benzersiz, "Tank-1")
SETADD(benzersiz, "Tank-2")

PRINT SETLEN(benzersiz)
```

## 5.4 TYPE / STRUCT / UNION

```basic
TYPE Olcum
    ph AS F64
    sicaklik AS F64
    zaman AS I64
END TYPE

DIM x AS Olcum
x.ph = 7.20
x.sicaklik = 23.8
```

ABI odaklı yapı:

```basic
STRUCT NativeHeader
    ABI CDECL
    PACK 8
    ALIGN 8

    size AS U32
    flags AS U32
    ptr AS PTR
END STRUCT
```

`UNION`, aynı bellek alanını farklı veri görünümleriyle kullanır.

---

# 6. Operatörler

## 6.1 Aritmetik

```text
+  -  *  /  \  MOD  %  **
```

`^` üs değildir; XOR'dur.

```basic
PRINT 2 ** 10
PRINT 17 MOD 5
PRINT 17 \ 5
```

## 6.2 Karşılaştırma

```text
==  =  <>  !=  <  <=  >  >=
```

## 6.3 Mantıksal ve bit işlemleri

```text
AND OR XOR NOT
ANDALSO ORELSE
NAND NOR XNOR
IMP CIMP NIMP NCIMP
IDA IDB NOTA NOTB
& | ~
<< >> SHL SHR ROL ROR
```

```basic
IF ptr <> 0 ANDALSO IsValid(ptr) THEN
    PRINT "gecerli"
END IF
```

## 6.4 Bileşik atamalar

```text
+= -= *= /= \= %= &= |= ^= <<= >>= **= ROL= ROR=
```

```basic
x += 5
mask <<= 1
```

## 6.5 Üçlü seçim

```basic
etiket = x < 0 ? -1 : x > 0 ? 1 : 0
```

## 6.6 Boru operatörü

```basic
sonuc = veri |> Normalize |> Analyze
```

## 6.7 Kullanıcı operatörleri ve MAGIC

```basic
CLASS Vector2
PUBLIC:
    DIM x AS F64
    DIM y AS F64

    OPERATOR +(other AS Vector2) AS Vector2
        DIM r AS Vector2
        r.x = x + other.x
        r.y = y + other.y
        RETURN r
    END OPERATOR

    MAGIC TOSTRING() AS STRING
        RETURN "(" + STR(x) + "," + STR(y) + ")"
    END MAGIC
END CLASS
```

---

# 7. Koşullar ve döngüler

```basic
IF derece < 20 THEN
    PRINT "dusuk"
ELSEIF derece < 30 THEN
    PRINT "normal"
ELSE
    PRINT "yuksek"
END IF
```

```basic
SELECT CASE durum
    CASE 0
        PRINT "bekliyor"
    CASE 1
        PRINT "calisiyor"
    CASE ELSE
        PRINT "bilinmiyor"
END SELECT
```

```basic
FOR i = 1 TO 100 STEP 2
    PRINT i
NEXT i
```

```basic
DO WHILE sensorAktif
    OkuSensor()
LOOP
```

```basic
WHILE i < 100
    i += 1
WEND
```

Koleksiyon ve iterator dolaşımı:

```basic
FOR EACH x IN liste
    PRINT x
NEXT
```

`DO EACH` aynı ortak iterator sözleşmesinin başka bir çalışma biçimidir.

---

# 8. SUB, FUNCTION ve özyineleme

uXBasic doğrudan özyinelemeyi destekler:

```basic
FUNCTION Faktoriyel(n AS I64) AS I64
    IF n <= 1 THEN
        RETURN 1
    END IF

    RETURN n * Faktoriyel(n - 1)
END FUNCTION

MAIN
    PRINT Faktoriyel(10)
END MAIN
```

Karşılıklı özyineleme:

```basic
DECLARE FUNCTION CiftMi(n AS I32) AS BOOLEAN
DECLARE FUNCTION TekMi(n AS I32) AS BOOLEAN

FUNCTION CiftMi(n AS I32) AS BOOLEAN
    IF n == 0 THEN RETURN TRUE
    RETURN TekMi(n - 1)
END FUNCTION

FUNCTION TekMi(n AS I32) AS BOOLEAN
    IF n == 0 THEN RETURN FALSE
    RETURN CiftMi(n - 1)
END FUNCTION
```

Özyinelemeli fonksiyonlar sınıf metotlarının, PIPE'ların ve görev gövdelerinden çağrılan normal yordamların içinde de kullanılabilir.

---

# 9. Modüller, ad alanları ve isim yönetimi

```basic
MODULE MathTools

    FUNCTION Square(x AS F64) AS F64
        RETURN x * x
    END FUNCTION

END MODULE
```

```basic
NAMESPACE Biology

    TYPE Sample
        ph AS F64
    END TYPE

END NAMESPACE
```

```basic
USING Biology
ALIAS MT = MathTools

PRINT MT.Square(3.0)
```

`INCLUDE`, `IMPORT`, `USING`, `ALIAS`, `MODULE` ve `NAMESPACE` birlikte büyük projeleri katmanlara ayırmak için kullanılır.

---

# 10. Nesne yönelimli programlama

```basic
INTERFACE IMeasure
    METHOD Value() AS F64
END INTERFACE

CLASS Sensor IMPLEMENTS IMeasure

PRIVATE:
    DIM raw AS F64

PUBLIC:
    CONSTRUCTOR(v AS F64)
        raw = v
    END CONSTRUCTOR

    VIRTUAL METHOD Value() AS F64
        RETURN raw
    END METHOD

    PROPERTY Current AS F64
        GET
            RETURN raw
        END GET
        SET(v AS F64)
            raw = v
        END SET
    END PROPERTY

END CLASS
```

Kalıtım ve override:

```basic
CLASS CalibratedSensor EXTENDS Sensor
PRIVATE:
    DIM offset AS F64

PUBLIC:
    OVERRIDE METHOD Value() AS F64
        RETURN BASE.Value() + offset
    END METHOD
END CLASS
```

Nesne yaşam döngüsü:

```basic
DIM s AS Sensor
s = NEW Sensor(22.5)

PRINT s.Value()

DELETE s
```

Erişim ve davranış belirteçleri:

```text
PUBLIC PRIVATE PROTECTED RESTRICTED FRIEND
STATIC ABSTRACT FINAL SEALED
READONLY MUTABLE IMMUTABLE
```

---

# 11. UXClazz üst katmanı

UXClazz, normal uXBasic `CLASS/METHOD/MAGIC` kodu üretmek için kullanılan üst seviye modeldir. Hedef profiller:

```text
VALUE
DATA
ENTITY
ACTOR
COMPONENT
NATIVE
```

Örnek düşünce modeli:

```basic
CLAZZ DATA FishSample
    ph AS F64
    temperature AS F64
    species AS STRING

    DERIVE EQ
    DERIVE HASH
    DERIVE CLONE
    DERIVE TOSTRING
    DERIVE JSON
END CLAZZ
```

Bu üst yüzey, normal uXBasic sınıf koduna indirilir. `USES` kompozisyon/trait benzeri yeniden kullanım, `DECORATOR` ise meta veri üretimi için kullanılır.

---

# 12. EVENT / PIPE / THREAD / PARALEL / SLOT / TRIGGER

Bu aile uXBasic'in özgün olay ve görev sistemidir. Yeni `SPAWN/TASK` sistemi bunun yerine geçmez.

## 12.1 EVENT

```basic
EVENT SensorChanged(sensorId AS I32, value AS F64)
    PRINT "Sensor="; sensorId; " value="; value
END EVENT
```

```basic
TRIGGER EVENT SensorChanged, 4, 27.5
```

EVENT olay işleyicisidir; dış olay sağlayıcısına, SLOT'a veya yazılımdan TRIGGER'a bağlanabilir.

## 12.2 PIPE

PIPE senkron değer dönüşüm yordamıdır:

```basic
PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE
```

PIPE'lar iç içe kullanılabilir:

```basic
PIPE Clamp01(x AS F64) AS F64
    IF x < 0 THEN RETURN 0
    IF x > 1 THEN RETURN 1
    RETURN x
END PIPE

PIPE Prepare(x AS F64) AS F64
    RETURN Clamp01(Normalize(x))
END PIPE
```

## 12.3 THREAD

```basic
THREAD Worker(x AS I32)
    PRINT "Worker "; x
END THREAD
```

Eski/yönlendirme yolu:

```basic
TRIGGER THREAD Worker, 100
```

Takip edilebilir yeni yol:

```basic
DIM t AS TASK

t = SPAWN Worker(100)
t.WAIT()
PRINT t.STATUS
```

## 12.4 PARALEL

```basic
PARALEL AnalyzeChunk(firstRow AS I32, count AS I32)
    DIM i AS I32

    FOR i = firstRow TO firstRow + count - 1
        AnalyzeRow(i)
    NEXT i
END PARALEL
```

```basic
DIM t AS TASK
t = SPAWN AnalyzeChunk(0, 1000)
t.JOIN()
```

## 12.5 SLOT

SLOT, çalışan görevin kendisi değil; bağlama, kimlik, ON/OFF ve yönlendirme tablosudur.

```basic
SLOT
    SensorSlot  1 ON EVENT   SensorChanged
    NormSlot    2 ON PIPE    Normalize
    WorkerSlot  3 ON THREAD  Worker
    BatchSlot   4 ON PARALEL AnalyzeChunk
END SLOT
```

SLOT kimlik alanı `0..255`, yani 256 bağlama noktasıdır. Bir SLOT zaman içinde veya eşzamanlı olarak çok sayıda TASK çalışma örneği başlatabilir.

## 12.6 TRIGGER ve SPAWN birlikte

```text
TRIGGER = çalıştır / yönlendir / olay tetikle
SPAWN   = THREAD/PARALEL çalıştır ve TASK tutamacını döndür
```

Eski `TRIGGER/SLOT` sistemi korunur; yeni `SPAWN/TASK` sistemi görev yaşam döngüsünü tamamlar.

---

# 13. TASK ve TASKGROUP

```basic
DIM a AS TASK
DIM b AS TASK
DIM g AS TASKGROUP

a = SPAWN Worker(10)
b = SPAWN Worker(20)

g.ADD(a)
g.ADD(b)

g.JOIN()

PRINT a.STATUS
PRINT b.STATUS
```

TASK yüzeyi:

```text
.STATUS
.RESULT
.ERRORTEXT
.WAIT()
.JOIN()
.CANCEL()
```

Görev içinde hata oluşursa hata çalışma örneğinde tutulur:

```basic
THREAD RiskyWorker(x AS I32)
    IF x < 0 THEN
        THROW "negatif deger"
    END IF
END THREAD

DIM t AS TASK
t = SPAWN RiskyWorker(-1)

TRY
    t.JOIN()
CATCH
    PRINT t.ERRORTEXT
END TRY
```

`TASKGROUP.JOINALL()` heterojen sonuç koleksiyonu sözleşmesiyle birlikte çalışır; temel `ADD/JOIN` modeli grup yönetiminin çekirdeğidir.

---

# 14. Eşzamanlı paylaşılan veri

Gerçek görevler varsayılan olarak izole kabul edilir. Güvenli değerler görev sınırından `BYVAL` anlık görüntü olarak geçer.

## 14.1 SHARED

```basic
DIM SHARED state AS SensorState
```

```basic
LOCK state
    state.temperature = 24.1
    state.ph = 7.30
END LOCK
```

Değiştirilebilir SHARED veriye kilit dışında doğrudan erişim reddedilir.

## 14.2 ATOMIC

```basic
DIM ATOMIC counter AS U64 = 0

THREAD Worker(id AS I32)
    counter += 1
END THREAD
```

Atomik skaler işlemler hedefler arasında sıralı-tutarlı ortak semantik kullanır.

## 14.3 MUTEX

```basic
DIM dllLock AS MUTEX

LOCK dllLock
    CALL(DLL, "legacy.dll", "unsafe_function")
END LOCK
```

`LOCK ... END LOCK` yapılandırılmış kapsamdır. `RETURN`, `THROW` veya başka bir çıkış yolu kilidin güvenli bırakılmasını bozmaz.

## 14.4 BYSHARED

Asenkron görev sınırında `BYREF` yerine ömrü çalışma zamanı tarafından korunan açık paylaşım kullanılır:

```basic
THREAD Process(BYSHARED buffer() AS F64)
    LOCK buffer
        buffer(0) += 1
    END LOCK
END THREAD
```

`BYREF` normal çağrı alias'ıdır; `BYSHARED` görevler arası paylaşılan nesnedir.

---

# 15. Hata yönetimi

```basic
TRY
    sonuc = RiskliIslem()
CATCH
    PRINT "Hata yakalandi"
FINALLY
    PRINT "Temizlik"
END TRY
```

```basic
IF x < 0 THEN
    THROW "x negatif olamaz"
END IF
```

```basic
ASSERT bufferSize > 0, "bufferSize sifirdan buyuk olmali"
```

Normal yordam hataları `TRY/CATCH/FINALLY` zincirine çıkar; görev hataları ayrıca `TASK.ERRORTEXT` ve `TASK.RESULT/JOIN` sözleşmesinde korunur.

---

# 16. Sistem programlama ve bellek

uXBasic bellek modeli iki ana sınıfa dayanır:

```text
VIRTUAL
NATIVE
```

`EXTERNAL`, ayrı bellek sınıfı değil adresin dış kaynaktan geldiğini belirten köken bilgisidir.

## 16.1 Pointer

```basic
DIM x AS I32 = 42
DIM p AS PTR

p = VARPTR(x)
```

Ham pointer aritmetiği bayt tabanlıdır:

```basic
p = p + 4
```

`PTR + PTR` geçersizdir; iki pointer'ın farkı bayt uzaklığı üretir.

## 16.2 PEEK / POKE

```basic
POKE address, value
PRINT PEEK(address)
```

Genişlik aileleri:

```text
PEEKB / POKEB
PEEKW / POKEW
PEEKD / POKED
PEEKQ / POKEQ
PEEKS / POKES
```

## 16.3 MEMCOPY / MEMFILL

```basic
MEMCOPYD hedef, kaynak, adet
MEMFILLB hedef, deger, adet
```

```text
B = byte
W = word
D = dword
Q = qword
```

## 16.4 MemoryRef

Birleşik bellek başvurusu şu kavramları taşır:

```text
memoryClass
origin
baseAddress
offset
length
elementSize
elementStride
count
readable
writable
owner
generation
lifetime
sharingMode
lockId
```

Bu model REDIM sonrası eski pointer, serbest bırakılmış nesne, paylaşılan bölge ve JS/WASM bellek eşlemelerini aynı soyutlamada denetler.

---

# 17. Dosya, konsol ve süreç işlemleri

Dosya:

```basic
OPEN "data.txt" FOR INPUT AS #1

WHILE EOF(1) == 0
    INPUT #1, line
    PRINT line
WEND

CLOSE #1
```

```basic
PRINT LOF(1)
SEEK #1, 0
```

Konsol:

```basic
CLS
COLOR 15, 0
LOCATE 10, 20
PRINT "uXBasic"
```

Süreç:

```basic
SHELL "python --version"
```

Gelişmiş süreç kontrolü için `TIMEOUT`, `OUTVAR`, `ERRVAR`, `CODEVAR`, `RUNPATH`, `OUTPATH`, `ERRPATH` yüzeyi kullanılır.

---

# 18. DLL, API, FFI ve ABI

```basic
DECLARE FUNCTION NativeAdd(a AS I32, b AS I32) AS I32 _
    CDECL LIB "mylib.dll" ALIAS "native_add"
```

Dinamik çağrı:

```basic
r = CALL(DLL, "mylib.dll", "native_add", a, b)
```

FFI modeli şu kavramları birlikte kullanır:

```text
CDECL
STDCALL
BYVAL
BYREF
STRUCT/UNION ABI
PACK
ALIGN
CODEPTR
VARPTR
```

uXBasic kodu da `uxbdll` ürün hattıyla yerel Windows x64 DLL ürününe dönüştürülebilir.

---

# 19. Önişlemci

Önişlemci çalışma zamanından önce kaynak üzerinde işlem yapar.

## 19.1 Makro ve koşul

```basic
%%DEFINE DEBUG 1

%%IF DEBUG
PRINT "debug build"
%%ELSE
PRINT "release build"
%%ENDIF
```

## 19.2 Derleme zamanı döngüsü

```basic
%%FOR I = 1 TO 3
PRINT "uretilen satir"
%%ENDFOR
```

Bu çalışma zamanı `FOR` döngüsü değildir; kaynak genişletilir.

## 19.3 FOREACH

```basic
%%FOREACH METHOD IN GET,POST,DELETE
    ' şablon içeriği
%%ENDFOREACH
```

## 19.4 Şablon

```basic
%%TEMPLATE_BEGIN HANDLER
FUNCTION {{NAME}}(x AS I32) AS I32
    RETURN x
END FUNCTION
%%TEMPLATE_END

%%TEMPLATE_USE HANDLER
```

## 19.5 Hedef ve profil

```basic
%%TARGET WEB
%%PROFILE RELEASE
%%OUTDIR "dist/web"
```

---

# 20. Meta komut sistemi ve kod üretimi

Meta komutlar sıradan BASIC statement'ı değildir. Derleme zamanı manifest, host bağlantısı, web dosyası ve otomatik kaynak üretimini tanımlar.

```basic
%%API_ENDPOINT GetFish GET "/fish"
%%API_ENDPOINT AddFish POST "/fish"
%%ROUTE FishPage "/fish"
%%FEATURE REST_API
```

Kaynak üretimi:

```basic
%%GEN_BLOCK SOURCE REST_HANDLERS

%%FOREACH METHOD IN GET,POST

FUNCTION Handle{{METHOD}}Fish(request AS DICT) AS DICT
    DIM response AS DICT
    DICTSET(response, "status", 200)
    RETURN response
END FUNCTION

%%ENDFOREACH

%%GEN_END
```

Üretilen kod tekrar normal uXBasic derleyici zincirine girer. Aynı mekanizma REST işleyicileri, JSON serileştiricileri, sınıf türetmeleri, FFI sarmalayıcıları, test iskeletleri ve CLI ayrıştırıcıları üretebilir.

---

# 21. Önişlemci ve meta yönergeleri

Çekirdek yönerge yüzeyi:

```text
PP, DEFINE, MACRO, UNDEF, IF, IFN, IFC, ELIF, ELSE, ENDIF,
INCLUDE, ALIAS, SET, EVAL, PROFILE, CONFIG_FILE, PATH_ALIAS,
LOCK_META, DUMP_META, SOURCE_MAP, EMITNOTE, ENV, DEPRECATED,
TEMPLATE, TEMPLATE_BEGIN, TEMPLATE_END, TEMPLATE_USE,
MINIFY, FINGERPRINT_ASSETS, HASHFILE, COPY_DIR,
EMBEDTEXT, EMBEDBASE64, LICENSEFILE, HTMLIMAGE, HTMLAUDIO,
CSS_RULE, CSS_IMPORT, MD_SAFE, MD_CSS, BREAK, CONTINUE, INFOMETA,
ALLOW_RAW_JS, ALLOW_RAW_WAT, SAFE_PATHS, REQUIRE_HOST_BINDING,
ASSERT_META, WARN_META, TARGET, OUTDIR, ASSET_ROOT, EXPANDLIMIT,
ASSET_COPY, ASSET_FILE, ASSET_IMAGE, ASSET_AUDIO, ASSET_REQUIRE,
MANIFEST_SET, MANIFEST_REQUIRE, WAT_IMPORT, WAT_EXPORT,
JS_LINE, HTML_LINE, CSS_LINE, JSON_SET,
SECTION, ENDSECTION, JS_BEGIN, JS_END, WAT_BEGIN, WAT_END,
WAT_FUNC_BEGIN, WAT_FUNC_END, WASM_HOST_JS_BEGIN, WASM_HOST_JS_END,
HTML_BEGIN, HTML_END, CSS_BEGIN, CSS_END,
JSON_BEGIN, JSON_END, JSON_ARRAY_BEGIN, JSON_ARRAY_END,
MD_BEGIN, MD_END, FOR, FOREACH, ENDFOR, ENDFOREACH,
NEXTMETA, REPEAT, ENDREPEAT, UNTILMETA,
PLATFORM, DESTOS, NOZEROVARS, SECSTACK, ENDCOMP, ERRORENDCOMP
```

Web/manifest üretim ailesi:

```text
BUNDLE_NAME, BUNDLE_VERSION, BUNDLE_ID, AUTHOR, LICENSE, BUILD_ID,
SANDBOX_ROOT, BROWSER_ENTRY, SCRIPT_ENTRY, STYLE_ENTRY, DATA_JSON,
CSP, SECURITY_NOTE, CAPABILITY, EXPORT_BASIC, API_ENDPOINT, ROUTE,
REQUIRE_ASSET, HOST_IMPORT, GEN_FILE, FEATURE, TEST_EXPECT, DOC,
GEN_BLOCK, GEN_END
```

---

# 22. Yerleşik fonksiyonlar

Tip bağlama kayıt sistemindeki çekirdek yerleşik işlevler:

```text
LEN, VAL, VALINT, STR, LEFT, RIGHT, MID, INSTR, ASC, CHR,
ABS, SIN, COS, TAN, ATN, LOG, EXP, SQR, SQRT, RND, TIMER, SGN, INT,
CINT, CLNG, CSNG, CDBL, LCASE, UCASE, TRIM, LTRIM, RTRIM, INPUT,
STRPTR, WSTRPTR, PTR, CASTPTR, VARPTR, SADD,
BIGINIT, F80, F128, BIGF, BIGD, BALL,
SIZEOF, OFFSETOF, PEEK, PEEKB, PEEKW, PEEKD, PEEKQ,
LISTLEN, LISTGET, LISTSET, LISTADD, LISTREMOVE, LISTCLEAR,
DICTLEN, DICTHAS, DICTGET, DICTSET, DICTCLEAR,
SETLEN, SETHAS, SETADD, SETREMOVE, SETCLEAR,
CODEPTR, LPTR, LIST_NEW, DICT_NEW, SET_NEW,
EOF, LOF, LBOUND, UBOUND
```

Lexer/statement yüzeyinde ayrıca `FIX`, `RANDOMIZE`, `INKEY`, `GETKEY`, `SPACE`, `PEEKS`, `POKE*`, `MEMCOPY*`, `MEMFILL*`, `INC`, `DEC` gibi aileler bulunur.

---

# 23. Birinci sınıf kütüphane tipi sistemi

uXBasic'in önemli hedeflerinden biri, yeni bilimsel tipleri compiler çekirdeğine tek tek hard-code etmemektir.

Bir kütüphane tipi sözleşmesi şu bilgileri taşır:

```text
typeName
packageName
layout
size
alignment
fields
operators
magic
conversions
lifecycle
storageModel
copyModel
cloneModel
dropModel
abiPolicy
mirPolicy / mirProvider
jsPolicy / jsProvider
wasmPolicy / wasmProvider
nativePolicy / nativeProvider
```

Örnek hedef kullanım:

```basic
DIM a AS RATIONAL
DIM b AS RATIONAL
DIM c AS RATIONAL

a = RATIONAL(1, 3)
b = RATIONAL(1, 6)
c = a + b

PRINT c
```

Compiler `RATIONAL + RATIONAL` için özel lexer kodu taşımak zorunda değildir. Tip descriptor'ındaki `ADD`, `TOSTRING`, `CLONE`, `HASH` ve yaşam döngüsü sağlayıcılarını kullanır.

İlk kabul sırası:

```text
RATIONAL → COMPLEX → POLYNOMIAL
```

Aynı model daha sonra matris, tensör, veri çerçevesi ve başka bilimsel tipleri kapsayabilir.

---

# 24. Kütüphane tipi ve görev güvenliği

Kütüphane tipinin TASK sınırından geçiş sözleşmesi de descriptor'da tanımlanır:

```text
taskTransfer = FORBID | COPY | RETAIN | SHARE
threadSafety = NONE | IMMUTABLE | INTERNAL | EXTERNAL_LOCK | THREAD_AFFINE
sharedPolicy
clone
retain
release
```

Immutable `RATIONAL` kopyalanabilirken, mutable `DATAFRAME` dış kilit gerektirebilir; GPU bağlamı ise thread-affine olabilir.

---

# 25. Ana kütüphaneler

23.09 kaynak ağacındaki ana uXBasic kütüphane aileleri:

```text
uxaimath, uxarchive, uxcapi, uxclazz, uxclz, uxcollections,
uxcompress, uxconfig, uxcrypto, uxdataframe, uxdataset, uxdatetime,
uxfs, uxgraph, uxgsl, uxhttp, uxjson, uxjsruntime,
uxllama, uxllamax, uxlog, uxlogic, uxmath, uxmathcore, uxmatrix,
uxnn, uxnn2, uxnn3, uxonnx, uxonnx2, uxpath, uxprocess, uxpython,
uxraylib, uxregex, uxscalar_module, uxsdl3, uxsqlite,
uxstats, uxstats2, uxsystem, uxtensor, uxterminal, uxuuid, uxwasmrt
```

## 25.1 Matematik, bilim ve istatistik

```text
uxmath
uxmathcore
uxaimath
uxmatrix
uxscalar_module
uxstats
uxstats2
uxtensor
uxgsl
```

`uxgsl`, GNU Scientific Library yüzeyini geniş biçimde uXBasic'e taşır; özel fonksiyon başlıkları Airy, Bessel, Coulomb, Debye, erf, gamma, hypergeometric, Legendre, zeta ve benzeri GSL ailelerini kapsar.

## 25.2 Veri bilimi ve yapay zekâ

```text
uxdataframe
uxdataset
uxgraph
uxnn
uxnn2
uxnn3
uxonnx
uxonnx2
uxllama
uxllamax
uxpython
```

## 25.3 Sistem ve dosya

```text
uxfs
uxpath
uxprocess
uxsystem
uxterminal
uxconfig
uxlog
uxuuid
uxarchive
uxcompress
uxcrypto
```

## 25.4 Veri biçimleri, ağ ve kalıcı veri

```text
uxjson
uxhttp
uxregex
uxsqlite
uxdatetime
```

## 25.5 Nesne ve koleksiyon

```text
uxclazz
uxclz
uxcollections
```

## 25.6 Grafik ve medya

```text
uxraylib
uxsdl3
```

## 25.7 Hedef çalışma zamanı

```text
uxjsruntime
uxwasmrt
```

---

# 26. uxclz dinamik nesne sistemi

`uxclz`, uXBasic'in yerel `CLASS` sisteminin yerine geçmez. C/C++ tabanlı bağımsız dinamik nesne kayıt sistemi sağlar.

Temel özellikleri:

```text
generation-safe U64 handle
retain / release
stale handle koruması
type registry
base type
interface / capability
method registry
metadata
multiple dispatch
```

Bu yapı plugin, C/C++ nesnesi ve çalışma zamanında tanınan tipler için uygundur.

---

# 27. Paradigmalar

| Paradigma | uXBasic karşılığı |
|---|---|
| Prosedürel | `SUB`, `FUNCTION`, `CALL`, `RETURN` |
| Yapısal | `IF`, `SELECT`, `FOR`, `DO`, `WHILE` |
| Özyinelemeli | doğrudan ve karşılıklı recursion |
| Nesne yönelimli | `CLASS`, `INTERFACE`, `VIRTUAL`, `OVERRIDE`, `PROPERTY`, `MAGIC` |
| Olay güdümlü | `EVENT`, `SLOT`, `TRIGGER` |
| Eşzamanlı | `THREAD`, `PARALEL`, `SPAWN`, `TASK`, `TASKGROUP` |
| Veri akışı | `PIPE`, `|>` |
| Sistem programlama | `PTR`, `PEEK/POKE`, `MEMCOPY`, FFI, INLINE |
| Bilimsel | geniş sayılar, GSL, matrix, tensor, stats |
| Veri odaklı | ARRAY, LIST, DICT, SET, dataframe, dataset |
| Meta programlama | `%%MACRO`, `%%TEMPLATE`, `%%FOREACH`, `%%GEN_BLOCK` |
| Modüler | `MODULE`, `NAMESPACE`, `USING`, `ALIAS`, `IMPORT` |
| Web/host | API endpoint, route, JS/HTML/CSS/WAT/WASM üretimi |

---

# 28. Paradigmaların iç içe kullanımı

Aşağıdaki örnek sınıf, EVENT, SLOT, PIPE, SPAWN, TASKGROUP, recursion, atomik sayaç ve SHARED veriyi tek programda birleştirir:

```basic
TYPE Measurement
    sensorId AS I32
    value AS F64
END TYPE

CLASS Analyzer
PUBLIC:
    METHOD RecursiveSmooth(x AS F64, depth AS I32) AS F64
        IF depth <= 0 THEN RETURN x
        RETURN RecursiveSmooth((x + Normalize(x)) / 2.0, depth - 1)
    END METHOD
END CLASS

PIPE Normalize(value AS F64) AS F64
    RETURN value / 100.0
END PIPE

DIM SHARED lastMeasurement AS Measurement
DIM ATOMIC processedCount AS U64 = 0

EVENT MeasurementArrived(sensorId AS I32, rawValue AS F64)

    LOCK lastMeasurement
        lastMeasurement.sensorId = sensorId
        lastMeasurement.value = rawValue
    END LOCK

    TRIGGER THREAD AuditWorker, sensorId

END EVENT

THREAD AuditWorker(sensorId AS I32)

    DIM localValue AS F64

    LOCK lastMeasurement
        localValue = lastMeasurement.value
    END LOCK

    DIM analyzer AS Analyzer
    analyzer = NEW Analyzer()

    localValue = analyzer.RecursiveSmooth(localValue, 4)
    processedCount += 1

    DELETE analyzer

END THREAD

PARALEL BatchAnalyze(firstId AS I32, count AS I32)

    DIM group AS TASKGROUP
    DIM tasks(count - 1) AS TASK
    DIM i AS I32

    FOR i = 0 TO count - 1
        tasks(i) = SPAWN AuditWorker(firstId + i)
        group.ADD(tasks(i))
    NEXT i

    group.JOIN()

END PARALEL

SLOT
    MeasurementSlot 1 ON EVENT   MeasurementArrived
    AuditSlot       2 ON THREAD  AuditWorker
    BatchSlot       3 ON PARALEL BatchAnalyze
END SLOT

MAIN
    TRIGGER EVENT MeasurementArrived, 1, 72.5

    DIM batch AS TASK
    batch = SPAWN BatchAnalyze(1, 32)
    batch.JOIN()

    PRINT "Islenen: "; processedCount
END MAIN
```

Bu örnekte eski `TRIGGER/SLOT` sistemi ve yeni `SPAWN/TASK` sistemi birlikte yaşar. Olay güdümlü, nesne yönelimli, veri akışlı, özyinelemeli ve eşzamanlı paradigmalar aynı uygulamada iç içedir.

---

# 29. Meta programlama ile görev sisteminin birleşmesi

```basic
%%API_ENDPOINT Analyze GET "/analyze"
%%FEATURE ASYNC_ANALYSIS

%%GEN_BLOCK SOURCE REST_API

FUNCTION HandleAnalyze(request AS DICT) AS DICT

    DIM response AS DICT
    DIM t AS TASK

    t = SPAWN AnalyzeRequest(DICTGET(request, "id"))
    t.JOIN()

    DICTSET(response, "status", 200)
    DICTSET(response, "result", t.RESULT)

    RETURN response

END FUNCTION

%%GEN_END
```

Üretilen kaynak normal uXBasic kodudur; parser, tip bağlama ve MIR süreçlerinden tekrar geçer.

---

# 30. Hedefler arası karşılık

| Özellik | x64 | JavaScript | WASM |
|---|---|---|---|
| I32/F64 | native | Number | i32/f64 |
| I64/U64 | native | BigInt | i64 |
| F80/F128/BIG | native/runtime provider | runtime object | linear-memory runtime |
| CLASS | object + vtable | runtime class/object | layout + type/vtable id |
| THREAD | worker runtime | Worker pool | WASM thread/host worker |
| ATOMIC | native atomic | SharedArrayBuffer/Atomics | WASM atomics |
| PTR | native/MemoryRef | DataView/MemoryRef | linear-memory offset |
| DLL/API | native ABI | host provider | import/provider |
| Web meta | artefakt üretimi | doğal hedef | JS/WASM paketi |

---

# 31. Kaynak yüzeyindeki anahtar sözcükler

23.09 lexer yüzeyinin ana sözlük alanı:

```text
IF THEN ELSE ELSEIF END SELECT CASE IS
TRY CATCH FINALLY THROW ASSERT
EVENT THREAD PARALEL PIPE SLOT ON OFF TRIGGER SPAWN
FOR TO STEP NEXT DO LOOP WHILE WEND UNTIL EXIT EACH IN
SUB FUNCTION DECLARE RETURN GOTO GOSUB CALL
TYPE STRUCT UNION ABI PACK ALIGN CLASS INTERFACE ENUM IMPLEMENTS
METHOD MAGIC VIRTUAL OVERRIDE CONSTRUCTOR DESTRUCTOR NEW DELETE
DIM REDIM AS CONST INCLUDE LIBTYPE IMPORT ABSTRACT FINAL SEALED STATIC
PROPERTY OPERATOR MIXIN DECORATOR
PUBLIC PRIVATE PROTECTED RESTRICTED FRIEND READONLY MUTABLE IMMUTABLE
MAIN NAMESPACE MODULE USING ALIAS
DEFINT DEFLNG DEFSNG DEFDBL DEFEXT DEFSTR DEFBYT
PRINT INPUT OPEN CLOSE GET PUT SEEK CLS COLOR LOCATE
AND OR ANDALSO ORELSE NOT XOR MOD SHL SHR ROL ROR
NAND NOR XNOR NXOR EQV EQA IFF IMP CIMP NIMP NCIMP IDA IDB NOTA NOTB
INLINE SHELL TIMEOUT OUTVAR ERRVAR CODEVAR RUNPATH OUTPATH ERRPATH
I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BIGF BIGD BALL
BOOLEAN STRING OBJECT PTR STRPTR BYREF BYVAL CDECL STDCALL
TRUE FALSE ZERO ONE TASK TASKGROUP ARRAY LIST DICT SET
SETSTRINGSIZE TIMER LOF EOF LEN MID STR VAL ABS INT UCASE LCASE
ASC CHR LTRIM RTRIM SPACE SGN SQRT SIN COS TAN ATN EXP LOG
INKEY GETKEY VARPTR SADD LPTR CODEPTR SIZEOF OFFSETOF
CINT CLNG CDBL CSNG FIX SQR RND RANDOMIZE
PEEK PEEKS PEEKB PEEKW PEEKD PEEKQ NATIVE
POKE POKEB POKEW POKED POKEQ POKES
MEMCOPYB MEMCOPYW MEMCOPYD MEMCOPYQ
MEMFILLB MEMFILLW MEMFILLD MEMFILLQ
SETNEWOFFSET INC DEC
```

Bu kelimelerin tamamı aynı kategori değildir; bazıları statement, bazıları tip, bazıları modifier, bazıları operatör ve bazıları yerleşik işlev adıdır.

---

# 32. Tasarım ilkeleri

uXBasic hedef sistemi şu ilkeleri korur:

1. **Eski sistemi gereksiz yere bozma.** `EVENT/PIPE/THREAD/PARALEL/SLOT/TRIGGER` yaşamaya devam eder.
2. **Yeni görev modeli tamamlayıcıdır.** `SPAWN/TASK/TASKGROUP`, belirli çalışma örneğini izler.
3. **Sessiz anlam kaybı yoktur.** Desteklenmeyen hedef açık hata üretir.
4. **Kanonik MIR ortak dildir.** AST, native, JS ve WASM aynı semantiğe bağlanır.
5. **Kütüphaneler dili büyütebilir.** Yeni bilimsel tipler descriptor üzerinden birinci sınıf olabilir.
6. **Sistem programlama saklanmaz.** Pointer, bellek, ABI ve FFI açıkça kullanılabilir.
7. **Eşzamanlılıkta paylaşım açıktır.** `SHARED/ATOMIC/MUTEX` ile güvenli model kurulur.
8. **Meta programlama derleme zamanı üretimidir.** Üretilen kod normal compiler zincirinden geçer.
9. **Paradigmalar birlikte kullanılabilir.** Bir program prosedürel, OOP, olay güdümlü, paralel, bilimsel ve meta-programlı olabilir.
10. **Hedef platform fiziksel uygulamayı değiştirir, dil anlamını değil.**

---

# 33. Son mimari görünüm

```text
EVENT / PIPE / THREAD / PARALEL
          │
          ├── SLOT / TRIGGER
          │       yönlendirme + olay + uyumluluk
          │
          └── SPAWN / TASK
                  çalışma örneği + yaşam döngüsü
                         │
                     TASKGROUP
                         │
              SHARED / ATOMIC / MUTEX
                         │
                     MemoryRef
                         │
             x64 / JavaScript / WASM

CLASS / INTERFACE / MAGIC / OPERATOR
                         │
                     UXClazz
                         │
                  Library Type Contract
                         │
          RATIONAL → COMPLEX → POLYNOMIAL → ...

Önişlemci / Meta
       │
       ├── koşul / makro / şablon
       ├── web / asset / manifest
       ├── REST / route / host binding
       └── uXBasic kaynak kodu üretimi
```

uXBasic'in hedef karakteri budur: **okunabilir BASIC yüzeyi, sistem seviyesinde denetim, güçlü çalışma zamanı sözleşmeleri, birinci sınıf kütüphane tipleri ve aynı program içinde paradigma değiştirebilme özgürlüğü.**
