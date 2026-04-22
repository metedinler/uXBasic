# uXBasic Compiler Mimarisi

## 1. Genel Bakis

uXBasic su an cok katmanli bir compiler + interpreter mimarisine sahip:

1. Kaynak dosya okunur.
2. Lexer token akisi uretir.
3. Parser tokenlardan AST olusturur.
4. Semantic pass AST uzerinde tip, komut ve yapi denetimleri yapar.
5. HIR/MIR envanteri ve MIR akisi uretilebilir.
6. Program ya runtime interpreter ile calistirilir ya da x64 codegen hattina verilir.
7. x64 hatta asm, obj, import artefact, rsp ve final exe uretilir.

Bu mimari "tek backend" degil, paralel yeteneklerden olusur:

- AST tabanli interpreter
- MIR tabanli interpreter
- x64 asm codegen
- IMPORT / INLINE / FFI build lane
- x64 asm -> obj -> link -> exe pipeline

## 2. Dizin Bazli Katmanlar

### `src/parser/`

Frontendin cekirdegidir.

- `lexer/`: tokenization, preprocess ve keyword normalization
- `ast.fbs`: AST dugum modeli
- `parser.fbs` ve `parser/parser_*.fbs`: statement ve expression parsing

Onemli noktalar:

- `IF`, `SELECT CASE`, `FOR`, `DO`, `GOTO`, `RETURN`, `DIM`, `TYPE`, `IMPORT`, `INLINE` gibi komutlar burada AST dugumlerine cevrilir.
- Modern ve legacy ayrimi parser seviyesinde yapilir.
- `INLINE(...) ... END INLINE` modern form olarak parse edilir.

### `src/semantic/`

Parser sonrasi anlamsal katmandir.

- `semantic_pass.fbs`: genel semantic kontrol
- `hir.fbs`: inventory toplama ve JSON envanteri
- `mir.fbs`: MIR uretimi, MIR optimizer, MIR interpreter
- `layout/`: `TYPE`, alan offsetleri, `SIZEOF/OFFSETOF` ve bellek layout mantigi

Bu katmanin gorevleri:

- komut ve expression semantigi
- veri tipi ve layout kontrolu
- intrinsics surface inventory
- MIR lowering
- pipeline ve opcode JSON ciktilari

### `src/runtime/`

AST ve runtime yurutme katmanidir.

- `memory_exec.fbs`: AST runtime calistirma
- `exec/`: statement, expression, builtin, FFI ve file I/O yardimcilari
- `memory_vm.fbs`: sanal bellek / poke-peek tabanli test runtime

Bu katman su anda en genis "calisan dil yuzeyi"ni verir.

### `src/codegen/x64/`

Native x64 codegen ve FFI/backend artefact uretim katmanidir.

- `code_generator.fbs`: BASIC AST -> NASM x64 asm
- `ffi_call_backend.fbs`: `CALL(DLL, ...)` icin x64 stub/plan artefactlari
- `inline_backend.fbs`: `INLINE("x64", "nasm", ...)` policy validation ve plan

Burada iki sey ayri dusunulmeli:

1. Native BASIC kodunu asm'e ceviren emitter
2. FFI / inline yardimci artefactlarini ureten yan lane

### `src/build/`

Build orkestrasyon katmanidir.

- `interop_manifest.fbs`: `IMPORT(C/CPP/ASM, file)` cozumleme, manifest ve batch uretimi
- `x64_build_pipeline.fbs`: asm + obj + rsp + link + exe akisinin orkestrasyonu

Bu katmanin sonucu artik gercek build zinciridir:

- `program.asm`
- `entry_shim.asm`
- `obj/*.obj`
- `interop/*`
- `program_link_args.rsp`
- `program.exe`

### `src/main.bas`

Compiler entry point'idir.

Ana gorevleri:

- CLI argumanlarini okumak
- source file yuklemek
- lexer + parser + semantic akisini baslatmak
- AST JSON / inventory JSON / pipeline JSON ciktilarini yazmak
- `--execmem`, `--codegen`, `--build-x64` gibi modlari calistirmak

## 3. Derleme Akisi

### Frontend akisi

1. `LoadTextFile`
2. `LexerInit`
3. `ParserInit`
4. `ParseProgram`
5. `SemanticAnalyze`

Bu asamada uretilen ana veri yapisi AST'dir.

### Inventory ve JSON akisi

Semantic pass sonrasinda su JSON ciktilari alinabilir:

- `--ast-json-out`
- `--inventory-json-out`
- `--pipeline-json-out`
- `--mir-opcodes-json-out`

Burada:

- AST JSON dogrudan parse agacini verir
- inventory JSON dil yuzeyinde kullanilan komut/fonksiyon/operator/tip/envanteri verir
- pipeline JSON compiler pipeline akis bilgisini verir
- MIR opcode JSON MIR yuzeyini verir

### Interpreter akisi

Iki yorumlayici backend vardir:

- `--execmem --interpreter-backend AST`
- `--execmem --interpreter-backend MIR`

AST backend daha eski ve genis runtime yuzeyini tasir.
MIR backend daha yapisal bir ara katmandir.

### Native x64 build akisi

`--build-x64` ile:

1. `GenerateX64Code` asm uretir.
2. `ResolveInteropManifestForSource` import bagimliliklarini toplar.
3. `EmitInteropArtifacts` import batch/rsp dosyalarini uretir.
4. `FfiX64BackendEmitArtifacts` `CALL(DLL)` stub artefactlarini uretir.
5. `InlineX64BackendEmitPlan` inline plan ciktilarini yazar.
6. `program.asm` ve `entry_shim.asm` NASM ile objeye doner.
7. MinGW linker rsp dosyasi ile final exe baglanir.

## 4. CALL(DLL) ve IMPORT Mimarisi

### `CALL(DLL, ...)`

Bu lane runtime agirliklidir.

- DLL yukleme: `LoadLibraryA`
- symbol cozumleme: `GetProcAddress`
- x64/x86 runtime invoke helper'lari
- allowlist / policy / attestation altyapisi

Mevcut pratik sinir:

- runtime FFI marshaller tek signature token ile cagrinin tum argumanlarini ayni marshalling sinifinda ele alir
- bu nedenle karisik tipli modern C API'lerde bazen C shim gerekebilir

### `IMPORT(C/CPP/ASM, file)`

Bu lane build zamaninda dis native artefaktlari projeye eklemek icindir.

- parser `IMPORT_STMT` uretir
- semantic/root safety kontrolu yapilir
- build manifest compile ve link plan cikartir

Not:

- bugunku repo durumunda `IMPORT` lane objeleri build'e dahil eder
- ama BASIC tarafindan dis sembollerin ergonomik cagrisi hala FFI yuzeyi kadar rahat degildir

### `INLINE("x64", "nasm", ...)`

Parser ve policy validation aktif.
Build artefact ve plan cikisi var.
Ancak inline kodun ana native BASIC emit akisi ile tam semantik butunlesmesi henuz partial durumdadir.

## 5. x64 Build Lane'in Guncel Durumu

Bu depo durumunda x64 build lane su kabiliyetleri saglar:

- asm cikisi
- obj cikisi
- import obj aggregasyonu
- rsp uretimi
- linker cagirma
- final exe uretimi

Uretilen tipik cikti agaci:

- `dist/x64build/program.asm`
- `dist/x64build/entry_shim.asm`
- `dist/x64build/obj/program.obj`
- `dist/x64build/interop/*`
- `dist/x64build/program_link_args.rsp`
- `dist/x64build/program.exe`

## 6. Su Anki Gucler

- Parser katmani genis komut yuzeyi tasiyor.
- AST runtime bircok komutu fiilen calistirabiliyor.
- MIR lane mevcut ve kullanilabilir.
- `CALL(DLL)` runtime lane aktif.
- `IMPORT` manifest/build lane aktif.
- x64 native build lane artik asm->obj->exe zincirine sahip.
- AST / inventory / pipeline JSON ciktilari alinabiliyor.

## 7. Su Anki Sinirlar

- PCK4/inceleme icindeki tum dil yuzeyi native x64 codegen tarafinda tamamen kapanmis degil.
- `INLINE` ana x64 emit akisina tam dokulu degil.
- FFI marshalling halen dar: karisik tipli, string+pointer+int karmasi API'lerde C shim ergonomisi gerekebilir.
- GUI window class / callback / message loop gibi Win32 senaryolari bugunku saf `CALL(DLL)` modeli ile kisitli.
- MPFR, Arb, Lua, Python, Prolog gibi kutuphanelerde basit bootstrap cagrilari kolay; derin entegrasyon icin wrapper katmani daha saglikli.

## 8. Tavsiye Edilen Kullanım Modeli

Bugunku uXBasic mimarisiyle en verimli kullanim:

1. Genel dil testleri icin AST veya MIR interpreter
2. Native console/x64 smoke icin `--build-x64`
3. Dis C/CPP/ASM artefaktlari icin `IMPORT`
4. Basit DLL bootstrap/probe icin `CALL(DLL)`
5. Karma API'ler icin ince C shim + BASIC tarafinda ince wrapper

## 9. Bu Turda Eklenen Mimari Iyilestirmeler

Bu repo turunda ozellikle asagidaki iyilestirmeler yapildi:

- eksik komutlarin MIR/runtime/codegen kapsami genisletildi
- `CLS`, `COLOR`, `LOCATE`, `RANDOMIZE`, `INC`, `DEC`, `DEF*`, `SETSTRINGSIZE` destekleri toparlandi
- x64 build pipeline gercek exe uretir hale getirildi
- import batch/rsp goreli yol sorunlari cozuldu
- MinGW/NASM fallback lane duzeltildi
- AST JSON cikisi eklendi

