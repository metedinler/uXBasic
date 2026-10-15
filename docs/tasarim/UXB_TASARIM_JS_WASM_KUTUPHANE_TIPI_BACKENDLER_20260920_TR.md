Mete abi, bu yön değişikliği yerinde. **18.09 ZIP'ini yeniden açıp bu kez özellikle JavaScript, tarayıcı, WAT/WASM ve 47 modüllük kütüphane sistemini birlikte taradım.** Önceki genel incelemeden daha net bir tablo çıktı.

En önemli sonuç şu:

> **uXBasic'in JavaScript ve WAT/WASM altyapısı göstermelik değil. Gerçek MIR tabanlı arka uçlar var. Fakat x64 ile aynı olgunluk düzeyinde değiller ve özellikle kütüphaneler hâlâ Windows DLL dünyasına fazla bağımlı.**
>
> Yeni konuştuğumuz **“birinci sınıf kütüphane tipi”** hedefi nedeniyle JS/WASM artık yan hedef değil, mimarinin merkezindeki meselelerden biri haline geliyor.

Kılavuzda da JavaScript'in MIR'den çalıştırılabilir JS ürettiği, WAT/WASM hattının da MIR omurgasını kullandığı belirtilmiş.  

# 1. Kaynakta gerçekten üç ciddi çıktı yolu var

18.09 kaynak yapısı artık kabaca:

```text
                         uXBasic
                            │
                     Parser / Tip sistemi
                            │
                      Canonical MIR
                            │
          ┌─────────────────┼──────────────────┐
          │                 │                  │
       MIR-x64          MIR → JS           MIR → WAT
          │                 │                  │
        NASM          JavaScript             WAT
          │                                    │
        x64                                  WASM
```

şeklinde okunabiliyor.

Bu bizim az önce konuştuğumuz kütüphane tipi açısından **doğru mimari**.

Eski tasarım belgelerinde de açıkça:

> `JS ve WASM yalnız MIRden beslenecek; MIR guclendikce JS/WASM otomatik olgunlasacak.`

kararı var. 

Bence bu karar kesinlikle korunmalı.

---

# 2. JavaScript arka ucu düşündüğümden daha gelişmiş

Kaynakta yalnız tek bir `js_codegen` dosyası yok. Ayrı bir alt sistem kurulmuş:

```text
src/codegen/js/
    js_codegen.fbs
    js_codegen_registry.fbs
    js_emitter.fbs
    js_expr_emit.fbs
    js_stmt_emit.fbs
    js_source_emit.fbs
    js_mir_runtime_emit.fbs
    js_emit_fail_closed.fbs
    js_json_report.fbs
    js_mir_opcode_coverage_adim26.fbs

    browser/
        js_browser_bootstrap.fbs
        js_browser_runtime_bindings.fbs

    runtime/
        js_runtime_services.fbs
        js_runtime_host_bridge.fbs
        js_runtime_writer.fbs
        ux_basic_runtime.js
```

Bu ciddi bir temel.

## Doğrudan JS üretilen alanlar

Kodda şu MIR aileleri için doğrudan yollar görüyorum:

```text
LOAD_CONST
LOAD_VAR
STORE_VAR

ADD
SUB
MUL
DIV
MOD

EQ NE LT LE GT GE

AND OR XOR
SHL SHR
ROL ROR
POW

NEG
NOT

CAST
COERCE

JMP
JZ
JNZ
RET
```

Üstelik:

```text
DIM
REDIM
ARRAY_NEW
ARRAY_LOAD
ARRAY_STORE

OBJECT_NEW
FIELD_LOAD
FIELD_STORE

METHOD_CALL
VIRTUAL_CALL
```

için de JS tarafında gerçek yollar mevcut.

Bu son grup özellikle önemli.

Çünkü **birinci sınıf kütüphane tipi** için:

```basic
a + b
```

↓

```text
MAGIC/OPERATOR
↓
METHOD_CALL
↓
MIR
↓
JS
```

zincirinin temeli zaten var.

---

# 3. BYREF'in JavaScript tarafında sonradan gerçekten ele alındığını gördüm

Bu önemli bir yeni bulgu.

`js_stmt_emit.fbs` başında S-051 açıklaması var. Eski JS arka ucunun `BYREF` uygulamadığı açıkça yazılmış.

Sonra çözüm olarak JavaScript'te **getter/setter kutusu**, yani okuyucu/yazıcı taşıyan küçük nesne kullanılmış:

Kavramsal olarak:

```javascript
{
    get value() { return vars[x]; },
    set value(v) { vars[x] = v; }
}
```

uXBasic:

```basic
SUB Bump(BYREF x AS I32)
    x += 1
END SUB
```

JavaScript'e giderken çağıranın değişkeni bu kutuyla taşınıyor.

Bu iyi çözüm.

Yani önceki incelemelerdeki:

> JS BYREF eksik.

bilgisi **18.09 için artık eskimiş**.

WASM tarafı ise aynı noktada değil.

---

# 4. JavaScript'te 64 bit sayı sorunu var

Burada ciddi bir mimari mesele buldum.

JS kod üreticisi örneğin I64/U64 dönüşümlerinde `BigInt` kullanıyor, fakat sonra tekrar:

```javascript
Number(...)
```

yapıyor.

Örneğin kaynakta kabaca:

```text
I64:
Number(BigInt.asIntN(64, BigInt(...)))

U64:
Number(BigInt.asUintN(64, BigInt(...)))
```

şeklinde.

Bu **tam 64 bit tamsayı doğruluğunu korumaz.**

JavaScript `Number`, tamsayıları yalnızca:

$$
2^{53}-1
$$

sınırına kadar kesin temsil eder.

Dolayısıyla uXBasic:

```basic
DIM x AS U64
x = &H FEDCBA9876543210
```

gibi gerçek 64 bit değerlerde JS hedefinde bilgi kaybedebilir.

Bu bizim daha önce belirlediğimiz U64 sınır testiyle doğrudan bağlantılı.

### Burada değişiklik gerekli

JS için:

```text
I8/I16/I32       → Number
U8/U16/U32       → Number

I64              → BigInt
U64              → BigInt
```

olmalı.

Ve ancak gerektiğinde açık dönüşüm yapılmalı.

Bu önemli bir JS işi.

---

# 5. F80/F128 tarafı daha da açık

JavaScript doğal olarak:

```text
Number = IEEE-754 F64
```

dünyasında.

Dolayısıyla:

```text
F32 -> Math.fround()
F64 -> Number
```

mantıklı.

Ama:

```text
F80
F128
BIGF
BIGD
BALL
```

JS `Number` içine sıkıştırılmamalı.

Bunlar için bizim yeni kütüphane tipi düşüncemiz mükemmel çözüm oluyor.

Örneğin:

```text
F128
 ↓
ux.f128.add(...)
```

veya:

```text
BIGF
 ↓
BigFloat runtime
```

gibi.

Yani **JS hedefinde geniş sayısal tipler çalışma zamanı/kütüphane tipi olmalı.**

---

# 6. WAT/WASM tarafında mimari var ama daha geride

WASM tarafında da oldukça düzenli dosya yapısı bulunuyor:

```text
src/codegen/wasm/
    wasm_codegen.fbs
    wasm_codegen_registry.fbs
    wasm_emitter.fbs
    wasm_instr_emit.fbs
    wasm_type_emit.fbs
    wasm_source_emit.fbs
    wasm_emit_fail_closed.fbs
    wasm_json_report.fbs
    wasm_manifest_emit.fbs

    imports/
        wasm_host_import_registry.fbs
        wasm_runtime_imports.fbs

    runtime/
        wasm_browser_loader.fbs
        wasm_runtime_bridge.fbs

    wat/
        wat_module.fbs
        wat_function.fbs
        wat_memory.fbs
        wat_import_export.fbs
        wat_writer.fbs
```

Bu da oyuncak değil.

---

# 7. WASM'ın doğal tip eşlemesi mevcut

`uxb_wasm_type_bridge_adim14.fbs` doğrudan şöyle eşliyor:

```text
uXBasic                    WASM
────────────────────────────────
I8/U8                      i32
I16/U16                    i32
I32/U32                    i32

I64/U64                    i64

F32                        f32
F64                        f64

PTR                        i64
STRPTR                     i64
WSTRPTR                    i64

STRING                     i32
```

STRING burada:

```text
i32 linear-memory offset / handle
```

olarak düşünülüyor.

Bu doğru yönde.

---

# 8. Ama burada F80/F128 için yanlış bir geçici çözüm var

Aynı dosyada:

```text
F80  -> f64
F128 -> f64
BIGF -> f64
BIGD -> f64
BALL -> f64
```

eşlemesi yapılmış.

Bu semantik olarak kabul edilemez.

Derleniyor olması doğru olduğu anlamına gelmiyor. Derleyiciler de insanlar gibi bazen sorunu halının altına süpürüp halının adını “uyumluluk katmanı” koyabiliyor.

Bunların WASM karşılığı doğrudan temel WASM tipi olmamalı.

Örneğin:

```text
F80
F128
BIGF
BIGD
BALL
```

şöyle temsil edilebilir:

```text
linear memory'de nesne
        +
i32 offset/handle
        +
runtime/kütüphane işlemleri
```

Bu da birinci sınıf kütüphane tipi mimarimize cuk oturuyor.

---

# 9. WASM'da asıl büyük eksik: bellek politikası fazla kaba

Şu an ortak hedef politikası şunu yapıyor:

```text
WASM:

STORAGE/ARITH/EXPR/CONTROL
    -> doğrudan

RUNTIME/STRING/BUILTIN/CALL/HOST/OBJECT
    -> host import

MEMORY/FILE
    -> unsupported
```

Ve açıkça:

```text
PEEK
POKE
MEMCOPY
MEMFILL
```

WASM hedefinde büyük ölçüde engelleniyor.

Burada artık eski kararımızı yeniden ele almak gerekiyor.

Çünkü **WASM zaten lineer belleğe sahip.**

Dolayısıyla:

```basic
PEEKB VIRTUAL, addr
POKEB VIRTUAL, addr, value
MEMCOPY VIRTUAL, ...
MEMFILL VIRTUAL, ...
```

WASM için son derece doğal işlemler.

Engellenmesi gereken:

```basic
PEEK NATIVE, hostAddress
POKE NATIVE, hostAddress
```

olmalı.

Bu ayrım bizim yeni:

```text
VIRTUAL
NATIVE
AUTO
```

bellek modelimizle çözülüyor.

### Yeni WASM kuralı

```text
VIRTUAL memory
    ↓
WASM linear memory
    ↓
DOĞRUDAN WAT

NATIVE memory
    ↓
WASM'da yok
    ↓
derleme hatası

EXTERNAL
    ↓
host import / capability
```

Bu çok daha temiz.

---

# 10. Böylece WASM'da PEEK/POKE yeniden anlam kazanıyor

Mesela:

```basic
POKED VIRTUAL, 100, 12345
x = PEEKD(VIRTUAL, 100)
```

WAT'a:

```wat
i32.const 100
i32.const 12345
i32.store

i32.const 100
i32.load
```

benzeri biçimde inebilir.

Bu **host çağrısı bile gerektirmez.**

MEMCOPY için WASM'ın:

```text
memory.copy
```

işlemi kullanılabilir.

MEMFILL için:

```text
memory.fill
```

kullanılabilir.

Yani şu anda WASM'ın desteklemediği kabul edilen bazı uXBasic özellikleri aslında **WASM'ın en doğal yaptığı işler arasında.**

---

# 11. Kütüphanelerde ise gerçek büyük problem burada

47 modülü tekrar taradım.

Kütüphanelerin çok önemli bölümü şu biçimde:

```basic
CALL(DLL, "xxx.dll", ...)
```

üzerinden çalışıyor.

Örneğin taramada yoğun DLL bağımlılığı olanlardan bazıları:

```text
uxcollections
uxraylib
uxcapi
uxgsl
uxstats2
uxaimath
uxclz
uxonnx2
uxmath
uxsdl3
uxmathcore
uxtensor
uxmatrix
uxdataset
uxnn
uxgraph
uxdataframe
...
```

Bu x64 için güzel.

Ama:

```text
CALL(DLL)
```

JavaScript'te çalışmaz.

WASM'da doğrudan çalışmaz.

Zaten hedef politikası JS için:

```text
CALL_DLL -> NATIVE_ONLY
CALL_API -> NATIVE_ONLY
```

diyor.

WASM için de aynı çağrıları reddediyor.

**İşte şu anda gerçek taşınabilirlik duvarımız bu.**

---

# 12. `uxjsruntime` ile JS arka ucunu karıştırmamak gerekiyor

Bir başka önemli ayrım:

```text
src/codegen/js/*
```

uXBasic → JavaScript **kod üreticisidir**.

Ama:

```text
libsx/uxjsruntime/uxjsruntime.bas
```

başka bir şey.

Bu kütüphane:

```basic
CALL(DLL, "uxjsrt.dll", ...)
```

kullanıyor ve QuickJS çalışma zamanını uXBasic içinden çağırıyor.

Yani:

```text
uXBasic -> JS
```

değil,

```text
native uXBasic programı
       ↓
uxjsrt.dll
       ↓
QuickJS
       ↓
JavaScript çalıştır
```

mekanizması.

Bu nedenle `uxjsruntime` **JS hedefinde kullanılabilecek taşınabilir kütüphane değil.**

Native köprü kütüphanesi.

---

# 13. Aynısı `uxwasmrt` için de geçerli

`libsx/uxwasmrt/uxwasmrt.bas`:

```basic
CALL(DLL, "uxwasmrt.dll", ...)
```

yapıyor.

Yani bu da:

```text
uXBasic -> WASM
```

üreticisi değil.

Native uXBasic programının WASM çalıştırmasını sağlayan bir çalışma zamanı köprüsü.

Bu ayrımı belgelerde ve modül metadatasında çok açık hale getirmeliyiz.

---

# 14. Yeni kütüphane sistemimiz burada çözüm olabilir

Az önce konuştuğumuz **birinci sınıf kütüphane tipi** mekanizmasını yalnız tipler için düşünmemeliyiz.

Aynı modülün hedefe göre farklı sağlayıcısı olmalı.

Örneğin:

```text
uxmath
   │
   ├── portable uXBasic implementation
   │
   ├── x64 provider
   │       └── DLL / native
   │
   ├── JS provider
   │       └── JavaScript runtime
   │
   └── WASM provider
           └── WAT / linear-memory runtime
```

Kullanıcı ise yalnız:

```basic
IMPORT uxmath
```

yazar.

Şunu yazmaz:

```basic
IMPORT uxmath_js
IMPORT uxmath_wasm
IMPORT uxmath_x64
```

Hedefi derleyici seçer.

---

# 15. Bunun için modül sözleşmesi lazım

Kavramsal olarak:

```text
MODULE uxmath

PROVIDER PORTABLE
PROVIDER X64
PROVIDER JS
PROVIDER WASM
```

gibi metadata düşünülebilir.

Örneğin:

```text
ABS
    portable : uXBasic
    x64      : native
    js       : Math.abs
    wasm     : direct/runtime

SIN
    x64      : GSL veya runtime
    js       : Math.sin
    wasm     : host/runtime
```

Daha karmaşık:

```text
RATIONAL.ADD
    portable : uXBasic BIGINT implementation
    x64      : optimized native
    js       : BigInt implementation
    wasm     : linear-memory implementation
```

İşte **uXBasic budur** dediğimiz yapı burada gerçek mimariye dönüşüyor.

---

# 16. Kütüphaneleri üç sınıfa ayırmalıyız

Bence 47 modülü bundan sonra şu şekilde sınıflandırmalıyız:

| Sınıf                          | Örnek                            | JS/WASM stratejisi           |
| ------------------------------ | -------------------------------- | ---------------------------- |
| **Saf uXBasic**                | mantık, bazı matematik işlemleri | MIR üzerinden her hedefe     |
| **Taşınabilir çalışma zamanı** | RATIONAL, COMPLEX, koleksiyon    | hedef sağlayıcısı            |
| **Gerçek native bağımlı**      | GSL, raylib DLL, ONNX Runtime    | x64 native veya host köprüsü |

Bu çok önemli.

GSL'yi WASM'da DLL gibi taklit etmeye çalışmak saçma olur.

Ama:

```basic
DIM z AS COMPLEX
z = a + b
```

gibi bir işlemin yalnız DLL yüzünden WASM'da çalışmaması da aynı derecede saçma olur.

---

# 17. JS tarafında host-fallback fazla cömert

Burada bir tasarım kusuru görüyorum.

JS ADIM26 kapsam denetimi bilinmeyen birçok işlemi sonunda:

```text
HOST_FALLBACK_JS
```

olarak kabul ediyor.

Yorum bile:

> son çare olarak `ux.callHost`

diyor.

Bu tehlikeli.

Çünkü “kapsandı” ile:

> “Gerçek JS uygulaması var.”

aynı şey değil.

Bir opcode'un host fallback'e düşmesi denetimde başarı sayılabiliyor.

Bence bundan sonra rapor üç ayrı başarı seviyesi vermeli:

```text
DIRECT
RUNTIME_PORTABLE
HOST_REQUIRED
```

ve:

```text
HOST_REQUIRED
```

**tam destek olarak sayılmamalı.**

Aksi halde yüzde 100 kapsam raporu görüp seviniyoruz, sonra tarayıcı programı ilk köşede `callHost` arıyor. Muhasebe güzel, program yok.

---

# 18. WASM tarafında da aynı durum var

WASM ADIM26:

```text
DIRECT_WAT
HOST_IMPORT_WAT
DIRECT_OR_HOST_WAT
```

kategorilerini kullanıyor.

Ama host import mevcut olması ile özelliğin gerçek taşınabilir WASM desteğine sahip olması aynı şey değil.

Burada da:

```text
WASM_NATIVE
WASM_RUNTIME
HOST_REQUIRED
UNSUPPORTED
```

ayrımı daha doğru.

---

# 19. OOP ve birinci sınıf kütüphane tipi için kritik hedef

Şimdi bizim yeni kararımız nedeniyle özellikle bunların **üç hedefte aynı olması** gerekiyor:

```text
TYPE
CLASS
FIELD
METHOD

OPERATOR
MAGIC

CONSTRUCTOR
DESTRUCTOR

INTERFACE
VIRTUAL
OVERRIDE

BYREF

ARRAY
LIST
DICT
SET
```

Çünkü RATIONAL yalnız iki sayıdan oluşan özel bir hack olmayacak.

Kullanıcı:

```basic
TYPE Rational
...
END TYPE
```

veya:

```basic
CLASS Rational
...
END CLASS
```

tanımlayacak.

Sonra:

```basic
c = a + b
```

x64, JS ve WASM'da aynı anlamı taşımalı.

Bu yüzden **JS/WASM OOP eşliği artık lüks değil.**

---

# 20. Ben bundan sonraki geliştirme sırasını değiştirirdim

Önceki listemizde x64 ve çeşitli tekil sorunlar daha öndeydi.

Yeni “birinci sınıf kütüphane tipi” kararıyla sıra bence şöyle olmalı:

1. **Canonical MIR sözleşmesini tek gerçek kaynak haline getirmek.**
2. **JS I64/U64 temsilini gerçek `BigInt` yapmak.**
3. **WASM tip sözleşmesini düzeltmek.**
4. **F80/F128/BIG/BALL için JS/WASM temsil sözleşmesi oluşturmak.**
5. **WASM VIRTUAL belleği doğrudan linear memory'ye bağlamak.**
6. **PEEK/POKE/MEMCOPY/MEMFILL VIRTUAL işlemlerini gerçek WAT üretimine geçirmek.**
7. **WASM BYREF'i linear-memory referansı olarak tamamlamak.**
8. **TYPE/STRUCT yerleşimini x64/JS/WASM arasında ortaklaştırmak.**
9. **OPERATOR/MAGIC → canonical MIR sözleşmesini tamamlamak.**
10. **METHOD/VIRTUAL/INTERFACE davranışını JS/WASM'da x64 ile eşitlemek.**
11. **Birinci sınıf kütüphane tipi sözleşmesini kurmak.**
12. **Kütüphanelere hedef sağlayıcısı sistemi eklemek.**
13. **47 modülü PORTABLE / X64 / JS / WASM / HOST sınıflarına ayırmak.**
14. **RATIONAL + COMPLEX'i ilk gerçek deneme kütüphane tipleri yapmak.**
15. **POLYNOMIAL ile sistemin gerçekten genel olduğunu kanıtlamak.**

Bunun ardından:

```basic
DIM a AS RATIONAL
DIM b AS RATIONAL
DIM c AS RATIONAL

c = a + b
PRINT c
```

aynı kaynak koddan:

```text
Windows x64 → NASM/native
Browser     → JavaScript
WASM        → WAT/WASM
```

üretebiliyorsa, **birinci sınıf kütüphane tipi mimarimizin gerçekten çalıştığını kanıtlamış oluruz.**

Ve burada bence uXBasic'in hedefi artık çok daha net: **x64, JavaScript ve WASM birbirinden bağımsız üç derleyici olmayacak. Tek uXBasic semantiğinin üç farklı fiziksel gerçekleştirmesi olacak.** Kütüphane sistemi de DLL listesi olmaktan çıkıp bu üç dünyaya aynı tipleri ve işlemleri taşıyan katman haline gelecek. Bu, şu anki kaynak yapısının ulaşabileceği en anlamlı sonraki mimari aşama.
