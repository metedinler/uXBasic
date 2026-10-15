# uXBasic 18.09 → JavaScript / WAT-WASM Tam Yüzey Matrisi

Kaynak: `uxb(18.09).zip` içindeki güncel `src`, `include/modules` ve `libsx` ağaçları.

## 1. Kesin kaynak sayımları

| Yüzey | 18.09 kaynak gerçeği | Sayım notu |
|---|---:|---|
| Lexer anahtar sözcükleri | **234** | Tabloda 235 kayıt var; `STRING` iki bağlam nedeniyle iki kez geçiyor, benzersiz sayı 234. |
| Statement dispatch kayıtları | **85** | `FOR EACH` ve `DO EACH` lookahead varyantları ana `FOR`/`DO` kayıtlarının altında. |
| Kanonik önişlemci yönergeleri | **125** | `%%PP`, `%%DEFINE`, web/manifest/WAT/JS blokları dahil. |
| Tip dönüş kayıtlı yerleşik çağrılar | **75** | `type_builtin_registry.fbs`; runtime/parser alias yüzeyi bundan daha geniş. |
| Kullanılabilir kanonik tip sınıfları | **35** | `TYPE_UNKNOWN` ve `TYPE_ERROR` sayılmadı. |
| Surface registry OPERATOR öğeleri | **71** | Parser-only/contextual operatör biçimleri ayrıca vardır; bu nedenle eski tooling'deki 82 sayısıyla bire bir aynı ölçü değildir. |
| Üst düzey modül başlıkları | **47** | `include/modules/*.uxmh`; üretilmiş GSL alt başlıkları hariç. |
| GSL üretilmiş alt başlıkları | **23** | `include/modules/uxgsl_generated/*.uxmh`. |

## 2. JS / WAT-WASM ana uyumluluk matrisi

| Aile | Kanonik MIR / sözleşme | JavaScript karşılığı | WAT/WASM karşılığı | Hedef kuralı |
|---|---|---|---|---|
| Anahtar sözcük / statement | Önce AST → canonical MIR; derleme-zamanı öğeler MIR üretmez | Doğrudan JS veya runtime çağrısı | Doğrudan WAT veya runtime/import çağrısı | Geçerli yüzey öğesi sessizce atlanamaz |
| Operatörler | Kanonik operator opcode + tip-bağlı operator/MAGIC çözümü | Number/BigInt veya tip sağlayıcısı | i32/i64/f32/f64 veya tip runtime'ı | Her operatör için DIRECT/RUNTIME/HOST/EMULATED kaydı |
| Yerleşik işlevler | Tek birleşik builtin registry | JS intrinsic + uxb runtime | WASM instruction + runtime/import | 75 tip kaydı ile parser/runtime yüzeyi tek registry'de birleşmeli |
| Önişlemci | Derleme zamanı | JS/HTML/manifest üretimi | WAT/WASM/import/manifest üretimi | 125 yönergenin her birinde IMPLEMENTED veya bilinçli compile-time davranış |
| Temel sayılar | Tip sözleşmesi | I8..U32 Number; I64/U64 BigInt; F32/F64 Number | i32/i64/f32/f64 | Daraltma, signed/unsigned ve taşma semantiği ortak |
| F80/F128/BIG/BALL | Birinci sınıf runtime tipi | Nesne/typed-array runtime | Linear-memory nesnesi + runtime | F64'e sessiz düşürme yasak |
| STRING/WSTRING | Kanonik kodlama + uzunluk sözleşmesi | Runtime string wrapper / UTF dönüşümü | Linear-memory string descriptor | LEN/MID/INSTR aynı karakter semantiği |
| PTR/MemoryRef | Bellek sınıfı + köken + ofset + sınır | MemoryRef handle + ArrayBuffer/DataView | Linear-memory offset/ref + host capability | VIRTUAL doğrudan; NATIVE host capability |
| ARRAY | Eleman tipi + stride + bounds | TypedArray/ArrayBuffer veya runtime array | Linear memory + descriptor | VARPTR/REDIM/PRESERVE aynı davranış |
| TYPE/STRUCT/UNION | Ortak layout tablosu | DataView/layout wrapper | Linear memory layout | SIZEOF/OFFSETOF/ABI/PACK/ALIGN eşit |
| CLASS/INTERFACE | ObjectRef + vtable/interface table | JS object/runtime class | Linear memory object + type/vtable id | NEW/DELETE/virtual/override aynı semantik |
| LIST/DICT/SET | Kanonik koleksiyon protokolü | JS tabanlı uXBasic wrapper | Linear-memory collection runtime | JS Map/Set semantiğine kör bağımlılık yok |
| FOR EACH / DO EACH | ITER_CREATE/NEXT/CLOSE | iterator adapter | runtime iterator | ARRAY/LIST/DICT/SET aynı dolaşım |
| EVENT/SLOT/TRIGGER | Event runtime | event loop/queue | host/runtime event queue | Sessiz no-op yasak |
| THREAD/PARALEL/PIPE | Task/worker runtime | Worker/worker pool/MessageChannel | WASM threads veya host workers | Gerçek paralellik yoksa açık provider |
| TRY/CATCH/THROW | Exception contract | try/catch veya runtime | WASM exception veya runtime status/stack | Hata metni ve kontrol akışı eşdeğer |
| Dosya/GÇ | Host service contract | Node FS veya browser virtual FS/provider | WASI/host FS import | OPEN/GET/PUT/SEEK/EOF/LOF kaybolmaz |
| SHELL/EXEC/RUN | Process capability | Node process; browser sandbox provider | WASI/host provider | Tarayıcıda OS erişimi taklit edilmez; sandbox hizmeti kullanılır |
| DLL/API/FFI | FOREIGN_CALL + ABI signature | Node/native bridge veya host provider | WASM import/provider | Kaynak sözdizimi aynı, fiziksel sağlayıcı hedefe göre |
| Grafik/ses/girdi | Host graphics/input contract | Canvas/WebAudio/Event | JS host/import veya WASM provider | SCREEN/CLS/drawing/input aynı gözlenebilir davranış |
| MODULE/NAMESPACE/IMPORT | Sembol/bağlama sistemi | ES module üretimi zorunlu değil; isim mangling/runtime olabilir | WASM import/export/name mangling | Kaynak modül semantiği hedef dil modülüne teslim edilmez |
| Birinci sınıf kütüphane tipi | Type descriptor + MAGIC/OPERATOR + lifecycle + ABI | JS provider/portable MIR | WASM provider/portable MIR | RATIONAL/COMPLEX/POLYNOMIAL ilk kabul tipleri |

## 3. Anahtar sözcük yüzeyi

| Grup | Sözcükler |
|---|---|
| Koşul/akış | `IF`, `THEN`, `ELSE`, `ELSEIF`, `END`, `SELECT`, `CASE`, `IS` |
| Hata | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` |
| Görev/olay | `EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT`, `ON`, `OFF`, `TRIGGER` |
| Döngü | `FOR`, `TO`, `STEP`, `NEXT`, `DO`, `LOOP`, `WHILE`, `WEND`, `UNTIL`, `EXIT`, `EACH`, `IN` |
| Yordam | `SUB`, `FUNCTION`, `DECLARE`, `RETURN`, `GOTO`, `GOSUB`, `CALL` |
| Tip/OOP/bildirim | `TYPE`, `STRUCT`, `UNION`, `ABI`, `PACK`, `ALIGN`, `CLASS`, `INTERFACE`, `ENUM`, `IMPLEMENTS`, `METHOD`, `MAGIC`, `VIRTUAL`, `OVERRIDE`, `CONSTRUCTOR`, `DESTRUCTOR`, `NEW`, `DELETE`, `DIM`, `REDIM`, `AS`, `CONST`, `INCLUDE`, `IMPORT`, `ABSTRACT`, `FINAL`, `SEALED`, `STATIC`, `PROPERTY`, `OPERATOR`, `MIXIN`, `DECORATOR` |
| Erişim/değiştirilebilirlik | `PUBLIC`, `PRIVATE`, `PROTECTED`, `RESTRICTED`, `FRIEND`, `READONLY`, `MUTABLE`, `IMMUTABLE` |
| Program/modül | `MAIN`, `NAMESPACE`, `MODULE`, `USING`, `ALIAS` |
| DEF tip varsayımları | `DEFINT`, `DEFLNG`, `DEFSNG`, `DEFDBL`, `DEFEXT`, `DEFSTR`, `DEFBYT` |
| Dosya/GÇ | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` |
| Terminal | `CLS`, `COLOR`, `LOCATE` |
| Mantık operatör sözcükleri | `AND`, `OR`, `ANDALSO`, `ORELSE`, `NOT`, `XOR`, `MOD`, `SHL`, `SHR`, `ROL`, `ROR`, `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB` |
| INLINE/SHELL seçenekleri | `INLINE`, `SHELL`, `TIMEOUT`, `OUTVAR`, `ERRVAR`, `CODEVAR`, `RUNPATH`, `OUTPATH`, `ERRPATH` |
| Tip/sabit sözcükleri | `I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64`, `F32`, `F64`, `F80`, `F128`, `BIGF`, `BIGD`, `BALL`, `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`, `CDECL`, `STDCALL`, `TRUE`, `FALSE`, `ZERO`, `ONE` |
| Koleksiyonlar | `ARRAY`, `LIST`, `DICT`, `SET` |
| Yerleşik çağrı adları | `SETSTRINGSIZE`, `TIMER`, `LOF`, `EOF`, `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `ASC`, `CHR`, `LTRIM`, `RTRIM`, `STRING`, `SPACE`, `SGN`, `SQRT`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`, `INKEY`, `GETKEY`, `VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `SIZEOF`, `OFFSETOF` |
| Dönüşüm/rastgele | `CINT`, `CLNG`, `CDBL`, `CSNG`, `FIX`, `SQR`, `RND`, `RANDOMIZE` |
| Bellek | `PEEK`, `PEEKS`, `PEEKB`, `PEEKW`, `PEEKD`, `PEEKQ`, `NATIVE`, `POKE`, `POKEB`, `POKEW`, `POKED`, `POKEQ`, `POKES`, `MEMCOPYB`, `MEMCOPYW`, `MEMCOPYD`, `MEMCOPYQ`, `MEMFILLB`, `MEMFILLW`, `MEMFILLD`, `MEMFILLQ`, `SETNEWOFFSET`, `INC`, `DEC` |

**Not:** Lexer tablosu 235 satır-adı içerir fakat `STRING` hem tip hem klasik BASIC işlev adı bağlamında tekrarlandığı için benzersiz anahtar sözcük sayısı 234'tür.

## 4. Operatör yüzeyi

`uxb_surface_registry.fbs` içinde OPERATOR olarak sınıflanan 71 öğe:

`%`, `%=`, `&`, `&=`, `(`, `)`, `*`, `*=`, `+`, `++`, `+=`, `,`, `-`, `--`, `-=`, `.`, `/`, `/=`, `:`, `<`, `<<`, `<<=`, `<=`, `<>`, `=`, `>`, `>=`, `>>`, `>>=`, `@`, `AND`, `MOD`, `NOT`, `OR`, `ROL`, `ROR`, `SHL`, `SHR`, `XOR`, `[`, `\`, `\=`, `]`, `^`, `^=`, `|`, `|=`, `!`, `!=`, `&&`, `**`, `**=`, `==`, `~`, `||`, `|>`, `NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IFF`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB`

Parser sözleşmesi ayrıca bağlama bağlı `?:`, postfix/prefix `++/--`, `ROL=`, `ROR=`, `=+`, `=-`, `CALL`, `INDEX` gibi biçimleri ayrı ele alır. Bu nedenle eski araçların verdiği **82 operatör** sayısı ile 71 doğrudan surface-registry tokenı aynı ölçüm değildir. Yeni matris tek bir kanonik operatör kayıt defterine indirgenmelidir.

## 5. Tip kayıtlı yerleşik işlevler

| İşlev | Dönüş/argüman politikası | Hedef politikası |
|---|---|---|
| `LEN` | `TYPE_I32` / `STRING:1` | `ALL` |
| `VAL` | `TYPE_F64` / `STRING:1` | `ALL` |
| `VALINT` | `TYPE_I32` / `STRING:1` | `ALL` |
| `STR` | `TYPE_STRING` / `NUMERIC:1` | `ALL` |
| `LEFT` | `TYPE_STRING` / `STRING,INT` | `ALL` |
| `RIGHT` | `TYPE_STRING` / `STRING,INT` | `ALL` |
| `MID` | `TYPE_STRING` / `STRING,INT[,INT]` | `ALL` |
| `INSTR` | `TYPE_I32` / `STRING,STRING` | `ALL` |
| `ASC` | `TYPE_I32` / `STRING:1` | `ALL` |
| `CHR` | `TYPE_STRING` / `INT:1` | `ALL` |
| `ABS` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `SIN` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `COS` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `TAN` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `ATN` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `LOG` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `EXP` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `SQR` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `SQRT` | `TYPE_F64` / `NUMERIC:1` | `ALL` |
| `RND` | `TYPE_F64` / `OPTIONAL_SEED` | `ALL` |
| `TIMER` | `TYPE_F64` / `NOARGS` | `ALL` |
| `SGN` | `TYPE_I32` / `NUMERIC:1` | `ALL` |
| `INT` | `TYPE_I32` / `NUMERIC:1` | `ALL` |
| `CINT` | `TYPE_I32` / `ANY:1` | `ALL` |
| `CLNG` | `TYPE_I32` / `ANY:1` | `ALL` |
| `CSNG` | `TYPE_F64` / `ANY:1` | `ALL` |
| `CDBL` | `TYPE_F64` / `ANY:1` | `ALL` |
| `LCASE` | `TYPE_STRING` / `STRING:1` | `ALL` |
| `UCASE` | `TYPE_STRING` / `STRING:1` | `ALL` |
| `TRIM` | `TYPE_STRING` / `STRING:1` | `ALL` |
| `LTRIM` | `TYPE_STRING` / `STRING:1` | `ALL` |
| `RTRIM` | `TYPE_STRING` / `STRING:1` | `ALL` |
| `INPUT` | `TYPE_STRING` / `OPTIONAL_PROMPT` | `CONSOLE_RUNTIME` |
| `STRPTR` | `TYPE_STRPTR` / `STRING:1` | `NATIVE_RUNTIME` |
| `WSTRPTR` | `TYPE_WSTRPTR` / `WSTRING:1` | `NATIVE_RUNTIME` |
| `PTR` | `TYPE_PTR` / `ANY:1` | `NATIVE_RUNTIME` |
| `CASTPTR` | `TYPE_PTR` / `TYPE,VALUE` | `NATIVE_RUNTIME` |
| `VARPTR` | `TYPE_PTR` / `IDENT:1` | `NATIVE_RUNTIME` |
| `SADD` | `TYPE_PTR` / `STRING:1` | `NATIVE_RUNTIME` |
| `BIGINIT` | `TYPE_BIGFLOAT` / `BIG_EXTERNAL_INIT` | `EXTFP_RUNTIME` |
| `F80` | `TYPE_F80` / `EXTFP_CONSTRUCT` | `EXTFP_RUNTIME` |
| `F128` | `TYPE_F128` / `EXTFP_CONSTRUCT` | `EXTFP_RUNTIME` |
| `BIGF` | `TYPE_BIGFLOAT` / `EXTFP_CONSTRUCT` | `EXTFP_RUNTIME` |
| `BIGD` | `TYPE_BIGD` / `EXTFP_CONSTRUCT` | `EXTFP_RUNTIME` |
| `BALL` | `TYPE_BALL` / `EXTFP_CONSTRUCT` | `EXTFP_RUNTIME` |
| `SIZEOF` | `TYPE_I32` / `TYPE:1` | `ALL` |
| `OFFSETOF` | `TYPE_I32` / `TYPE,STRING` | `ALL` |
| `PEEK` | `TYPE_I32` / `PTR:1` | `NATIVE_RUNTIME` |
| `PEEKB` | `TYPE_U8` / `PTR:1` | `NATIVE_RUNTIME` |
| `PEEKW` | `TYPE_U16` / `PTR:1` | `NATIVE_RUNTIME` |
| `PEEKD` | `TYPE_U32` / `PTR:1` | `NATIVE_RUNTIME` |
| `LISTLEN` | `TYPE_I32` / `LIST:1` | `ALL` |
| `LISTGET` | `TYPE_OBJECT` / `LIST,INT` | `ALL` |
| `LISTSET` | `TYPE_BOOL` / `LIST,INT,ANY` | `ALL` |
| `LISTADD` | `TYPE_BOOL` / `LIST,ANY` | `ALL` |
| `LISTREMOVE` | `TYPE_BOOL` / `LIST,INT` | `ALL` |
| `LISTCLEAR` | `TYPE_BOOL` / `LIST:1` | `ALL` |
| `DICTLEN` | `TYPE_I32` / `DICT:1` | `ALL` |
| `DICTHAS` | `TYPE_BOOL` / `DICT,STRING` | `ALL` |
| `DICTGET` | `TYPE_OBJECT` / `DICT,STRING` | `ALL` |
| `DICTSET` | `TYPE_BOOL` / `DICT,STRING,ANY` | `ALL` |
| `DICTCLEAR` | `TYPE_BOOL` / `DICT:1` | `ALL` |
| `SETLEN` | `TYPE_I32` / `SET:1` | `ALL` |
| `SETHAS` | `TYPE_BOOL` / `SET,STRING` | `ALL` |
| `SETADD` | `TYPE_BOOL` / `SET,STRING` | `ALL` |
| `SETREMOVE` | `TYPE_BOOL` / `SET,STRING` | `ALL` |
| `SETCLEAR` | `TYPE_BOOL` / `SET:1` | `ALL` |
| `CODEPTR` | `TYPE_PTR` / `IDENT:1` | `NATIVE_RUNTIME` |
| `LPTR` | `TYPE_PTR` / `IDENT:1` | `NATIVE_RUNTIME` |
| `LIST_NEW` | `"LIST"` / `NOARGS` | `ALL` |
| `DICT_NEW` | `"DICT"` / `NOARGS` | `ALL` |
| `SET_NEW` | `"SET"` / `NOARGS` | `ALL` |
| `EOF` | `TYPE_I32` / `INT:1` | `CONSOLE_RUNTIME` |
| `LOF` | `TYPE_I32` / `INT:1` | `CONSOLE_RUNTIME` |
| `PEEKQ` | `TYPE_U64` / `PTR:1` | `NATIVE_RUNTIME` |

Parser/runtime tarafında `FIX`, `SPACE`, `STRING(...)`, `GETKEY`, `INKEY`, `INSTR`, `LEFT`, `RIGHT`, `TRIM`, `INSTANCEOF` ve `$` uyumluluk adları gibi ek yüzeyler vardır. Bunların bir kısmı 75 öğelik tip-kayıt tablosunda değildir. JS/WASM çalışmasından önce bunlar tek **BuiltinDescriptor** kayıt defterine taşınmalıdır.

## 6. 35 kanonik veri tipi

| Tip ailesi | Tipler | JS fiziksel temsili | WASM fiziksel temsili |
|---|---|---|---|
| Kontrol | VOID, BOOLEAN | undefined/bool | void/i32 |
| Tamsayı | I8, U8, I16, U16, I32, U32 | Number + daraltma | i32 |
| 64 bit tamsayı | I64, U64 | BigInt | i64 |
| Kayan nokta | F32, F64 | Math.fround / Number | f32 / f64 |
| Geniş sayı | F80, F128, BIGINT, BIGF, BIGD, BALL | runtime object | linear-memory runtime object |
| Metin | STRING, WSTRING | runtime string descriptor | linear-memory descriptor |
| İşaretçi | PTR, STRPTR, WSTRPTR | MemoryRef handle | linear-memory offset/ref |
| Genel/dinamik | ARRAY, OBJECT, VARIANT, ANY | runtime handle/object | runtime handle/descriptor |
| Kullanıcı tipi | TYPE/STRUCT/UDT, CLASS, INTERFACE | layout/object wrapper | linear-memory layout/object |
| Çağrı/handle | FUNCTION_PTR, DLL_HANDLE, FILE_HANDLE | host capability handle | funcref/import/host handle |
| Hedef özel | JS_OBJECT, WASM_EXTERNREF | native JS object / wrapper | externref veya host ref |

Kanonik 35 tip: `VOID`, `BOOLEAN`, `I8`, `U8`, `I16`, `U16`, `I32`, `U32`, `I64`, `U64`, `F32`, `F64`, `F80`, `F128`, `BIGINT`, `BIGF`, `BIGD`, `BALL`, `STRING`, `WSTRING`, `PTR`, `STRPTR`, `WSTRPTR`, `ARRAY`, `OBJECT`, `VARIANT`, `ANY`, `TYPE/STRUCT/UDT`, `CLASS`, `INTERFACE`, `FUNCTION_PTR`, `DLL_HANDLE`, `FILE_HANDLE`, `JS_OBJECT`, `WASM_EXTERNREF`.

## 7. Veri yapıları

| Yapı | Kanonik sözleşme | JS | WASM |
|---|---|---|---|
| Skaler | typed value | Number/BigInt/runtime object | i32/i64/f32/f64/runtime |
| Sabit/dinamik ARRAY | bounds + elemType + elemStride + storage | ArrayBuffer/TypedArray | linear memory |
| Çok boyutlu ARRAY | dims + lower bounds + strides | descriptor | descriptor + linear memory |
| TYPE/STRUCT | field layout | DataView/layout wrapper | linear memory |
| UNION | shared byte region | ArrayBuffer/DataView | linear memory |
| ENUM | underlying integer + names | Number | i32/i64 |
| CLASS | ObjectRef + fields + vtable | object/runtime | linear-memory object |
| LIST | ordered dynamic collection | uXBasic list wrapper | collection runtime |
| DICT | key/value map | uXBasic dict wrapper | hash-map runtime |
| SET | unique-membership set | uXBasic set wrapper | set runtime |
| Native/VIRTUAL tampon | MemoryRef + length | ArrayBuffer/DataView | linear memory |
| Harici handle | provider-owned object id | host handle | import/externref/handle |
| Iterator | ITER_CREATE/NEXT/CLOSE | iterator adapter | runtime iterator |

## 8. 47 üst düzey kütüphane modülü

| Alan | Modüller | JS/WASM yönü |
|---|---|---|
| Çekirdek/sistem | `uxarchive`, `uxcapi`, `uxcompress`, `uxconfig`, `uxcrypto`, `uxdatetime`, `uxfs`, `uxhttp`, `uxjson`, `uxlog`, `uxpath`, `uxprocess`, `uxregex`, `uxsqlite`, `uxsystem`, `uxterminal`, `uxuuid` | Portable MIR mümkün olan yerde; OS özellikleri host provider/WASI/Node |
| Matematik/bilim | `uxaimath`, `uxgsl`, `uxlogic`, `uxmath`, `uxmathcore`, `uxmatrix`, `uxscalar_module`, `uxstats`, `uxstats2`, `uxtensor` | Portable MIR + JS/WASM runtime; native DLL yalnız x64 hızlandırıcısı |
| Veri/AI | `uxdataframe`, `uxdataset`, `uxgraph`, `uxllama`, `uxllamax`, `uxnn`, `uxnn2`, `uxnn3`, `uxonnx`, `uxonnx2`, `uxpython` | Portable veri katmanı; ONNX/Python/llama için host veya WASM provider |
| Nesne/koleksiyon | `uxclazz`, `uxclz`, `uxclz_object`, `uxcollections`, `uxcollections_aliases` | Birinci sınıf kütüphane tipi ve ortak collection/object runtime |
| Grafik/medya | `uxraylib`, `uxsdl3` | Canvas/WebAudio/WebGPU veya WASM-host provider |
| Hedef çalışma zamanı | `uxjsruntime`, `uxwasmrt` | Bunlar hedef çalıştırıcıdır; normal taşınabilir API ile karıştırılmamalı |

`uxgsl` altında ayrıca **23** üretilmiş özel-fonksiyon başlığı vardır: `gsl_sf_airy`, `gsl_sf_bessel`, `gsl_sf_coulomb`, `gsl_sf_coupling`, `gsl_sf_debye`, `gsl_sf_erf`, `gsl_sf_exp`, `gsl_sf_expint`, `gsl_sf_fermi_dirac`, `gsl_sf_gamma`, `gsl_sf_gegenbauer`, `gsl_sf_hermite`, `gsl_sf_hyperg`, `gsl_sf_laguerre`, `gsl_sf_lambert`, `gsl_sf_legendre`, `gsl_sf_log`, `gsl_sf_psi`, `gsl_sf_sincos_pi`, `gsl_sf_synchrotron`, `gsl_sf_transport`, `gsl_sf_trig`, `gsl_sf_zeta`.

## 9. Tasarım aileleri

| Tasarım | Kaynak yüzeyi | JS gerçekleştirme | WAT/WASM gerçekleştirme | Zorunlu kabul testi |
|---|---|---|---|---|
| Prosedürel | SUB/FUNCTION/MAIN/CALL/RETURN/BYVAL/BYREF | function + ref-box/runtime | func + locals/memory ref | aynı dönüş ve BYREF yan etkisi |
| OOP | CLASS/INTERFACE/METHOD/PROPERTY/NEW/DELETE/VIRTUAL/OVERRIDE | runtime class/object | object layout + vtable | virtual dispatch parity |
| MAGIC/operatör | MAGIC/OPERATOR | descriptor dispatch/inlining | descriptor call/inlining | RATIONAL/COMPLEX |
| Modülerlik | MODULE/NAMESPACE/USING/ALIAS/IMPORT/INCLUDE | symbol mangling/provider | symbol/import/export | aynı isim çözümleme |
| Bellek | VIRTUAL/NATIVE/AUTO + PEEK/POKE/MEMCOPY/MEMFILL | MemoryRef + DataView | linear memory + host capability | B/W/D/Q dört genişlik |
| FFI/ABI | DECLARE/CDECL/STDCALL/CALL(DLL/API)/STRUCT ABI | host bridge | imports/provider | ABI descriptor validation |
| Eşzamanlılık | EVENT/SLOT/TRIGGER/THREAD/PARALEL/PIPE | event loop/workers | threads/host workers | order + payload + concurrency |
| Hata | TRY/CATCH/FINALLY/THROW/ASSERT | native JS exceptions/runtime | WASM EH/runtime | aynı catch/finally |
| Koleksiyon/iterator | ARRAY/LIST/DICT/SET/FOR EACH/DO EACH | runtime adapters | runtime iterators | aynı sıra/key-value semantics |
| Dosya/işletim | OPEN/CLOSE/GET/PUT/SEEK/SHELL | Node/browser provider | WASI/host provider | capability profile |
| Web/asset | 125 %% yönerge, HTML/CSS/JS/WAT blokları | doğal hedef | WAT/WASM üretim | preprocessor matrix PASS |
| Birinci sınıf kütüphane tipi | TYPE/CLASS + MAGIC + MODULE + lifecycle + layout | provider veya portable MIR | provider veya portable MIR | RATIONAL→COMPLEX→POLYNOMIAL |

## 10. Zorunlu kapanış kuralı

Her yüzey öğesi için hedef matrisi şu değerlerden **tam birini** taşımalıdır: `DIRECT`, `PORTABLE_RUNTIME`, `TARGET_RUNTIME`, `HOST_PROVIDER`, `EMULATED`, `COMPILE_TIME`. `MISSING`, `SILENT_SKIP` ve sahte `HOST_FALLBACK=PASS` üretim build'inde yasaktır.

Önerilen makine çıktıları: `surface_backend_matrix.json`, `builtin_backend_matrix.json`, `type_backend_matrix.json`, `library_target_matrix.json`, `design_semantics_matrix.json`. Resmî JS/WASM build'inde herhangi bir zorunlu hücre boşsa derleme sistemi FAIL vermelidir.