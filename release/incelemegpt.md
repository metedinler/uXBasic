Evet. Zip’i açtım, üst klasörleri listeledim, `src` ağacını dosya bazında taradım ve ana dosyaları okuyup hızlı ama geniş bir mimari inceleme yaptım. Özellikle `src/main.bas`, `parser`, `semantic`, `runtime`, `build`, `codegen/x64`, `codegen/x86` taraflarını ve `tests/dist/spec/release/extras` klasörlerini karşılaştırdım.

## Üst klasörler ve amaçları

`src/` çekirdek derleyici kodu.
`tests/` çok geniş test/probe/smoke alanı. Çok sayıda parser, semantic, runtime, interop, class, memory ve codegen denemesi var.
`dist/` üretilmiş asm, exe, interop artifact, paket ve build çıktıları.
`build/` bazı derlenmiş çıktılar.
`spec/` dil ve IR plan dokümanları.
`release/` paketleme ve yayımlama kopyaları. İçinde repo kopyası da var.
`extras/uxstat/` ayrı bir eklenti/dll yan projesi gibi duruyor.

Bu dağılım şunu gösteriyor: proje tek bir derleyiciden fazlası olmuş; aynı repo içinde hem geliştirme çekirdeği, hem artifact üretimi, hem paketleme, hem de yan araçlar tutuluyor.

## `src` klasörü: genel durum

Toplam 66 metin tabanlı kaynak dosya var. Kabaca:

* `parser`: 27 dosya, yaklaşık 7.7k satır
* `semantic`: 9 dosya, yaklaşık 6.5k satır
* `runtime`: 19 dosya, yaklaşık 9.7k satır
* `build`: 4 dosya, yaklaşık 1.4k satır
* `codegen`: 5 dosya, yaklaşık 3.7k satır
* `legacy`: 1 dosya

Bu oran önemli: proje yalnızca parser değil, ciddi bir runtime ve semantic katman da taşıyor. Yani sistemin ağırlık merkezi aslında “sadece native compiler” değil, **hibrit frontend + semantic + interpreter + artifact emitter**.

## Ana giriş ve akış: `src/main.bas`

`main.bas` düz, anlaşılır bir sürücü dosyası. Şu yolları destekliyor:

* parse
* semantic
* AST json
* HIR/MIR inventory json
* MIR opcode/pipeline json
* `--execmem`
* `--interop`
* `--emit-x64-nasm` / `--x64gen`
* `--codegen` / `--x64`
* `--build-x64`

Bu da sistemi 5 ayrı çalışma moduna ayırıyor:

1. parser-only / semantic-only kontrol
2. AST interpreter (`ExecRunMemoryProgram`)
3. MIR interpreter (`MIRBuildModuleFromAST` + `MIROptimizeModule` + `MIRRunModule`)
4. interop/FFI artifact emit
5. x64 asm/native lane

Bu mimari zayıf değil. Aksine çok yönlü. Ama aynı anda iki farklı “yürütme felsefesi” taşıdığı için karmaşıklık yaratıyor: AST runtime, MIR runtime ve native codegen yan yana.

## Parser mimarisi

Parser bölümü şaşırtıcı derecede geniş. Ayrım iyi yapılmış:

* lexer çekirdeği
* preprocess
* expression parser
* statement parser’ları
* decl/core/proc/class/scope ayrımları
* path validation ve using/alias semantiğe hazırlık

Dosya isimlerinden ve testlerden görülen kapsama göre parser şu alanları hedefliyor:

* temel BASIC komutları
* akış kontrolü
* DIM/REDIM
* prosedürler
* namespace/module/alias
* class/interface
* preprocess direktifleri
* memory intrinsics
* FFI/INLINE
* registry ve bazı sistem çağrıları

Bu parser “küçük bir BASIC” parser’ı değil. Dil yüzeyi geniş.

### Parser güçlü taraflar

* Dosya bazlı ayrım mantıklı.
* Preprocess katmanı ayrı.
* Declaration mantığı parçalanmış, bu iyi.
* Path validation ayrı helper’da tutulmuş.

### Parser zayıf taraflar

* Dosya sayısı fazla ve statement dispatch merkezi oldukça büyümüş. Bu ileride bakım maliyeti doğurur.
* `parser_stmt_dispatch.fbs` ve `parser_stmt_decl_core.fbs` çok şişmiş.
* Bazı unsupported mesajlar hâlâ parser katmanında görünüyor; örneğin member access expression için “expected call” gibi sınırlar var.
* Error recovery derin değil; çoğunlukla ilk ciddi kırılmada akış kesiliyor.

## AST yapısı

`ast.fbs` merkezi düğüm tabanlı yapı kullanıyor. Bu uygun.
Hem parser hem semantic hem interpreter hem codegen için ortak yüzey olmuş.

Avantajı:

* tek veri modeli

Dezavantajı:

* AST çok fazla katmanın ortak taşıyıcısı olunca “ham syntax tree” ile “anlamsal olarak normalize edilmiş tree” birbirine yaklaşabiliyor. Bu da sonradan MIR/codegen tarafında ekstra if/else yükü doğurur.

## Semantic katman

`semantic_pass.fbs`, `type_binding.fbs`, `layout/*.fbs`, `hir.fbs`, `mir.fbs` birlikte düşünülmüş.

Burada iki ayrı dünya var:

1. klasik semantic doğrulama
2. IR ve MIR üretim/dönüşüm yönü

### Semantic tarafın iyi yanı

* Sadece “parse oldu mu” değil, anlam denetimi hedeflenmiş.
* layout / intrinsic / type table alt katmanları ayrılmış.
* MIR tarafı beklediğimden daha dolu; yalnızca isim olarak durmuyor.

### Kritik gözlem

Daha önceki kaba izlenimin aksine, bu repoda MIR tarafı boş değil. `semantic/mir.fbs` oldukça büyük ve içinde:

* instruction modeli
* basic block / function / module
* evaluator state
* arithmetic / compare / control flow değerlendirme
* AST → MIR lowering
* optimization pass
* module run
* pipeline/opcode json export

var.

Yani “MIR var ama göstermelik” demek bu zip için tam doğru değil. MIR katmanı gerçekten geliştirilmeye başlanmış.

### Semantic eksikler

* Yine de semantic bütünlüğü tek yerde çok derli toplu değil.
* Type binding ve runtime layout arasında zihinsel mesafe var; yani semantic tip sistemi ile runtime temsili her yerde tam birleşmiş görünmüyor.
* Bazı doğrulamalar var ama dil genişledikçe overload, tam type inference, kullanıcı tanımlı fonksiyon kontratları gibi alanlarda zorlanır.

## Runtime / interpreter

`runtime/memory_exec.fbs` büyük ve ciddi bir dosya. Sadece placeholder değil. İçinde:

* değişken ve değer tipleri
* object/array/collection taslakları
* FFI policy/resolver state
* call context
* debug console state
* expression / statement yürütme
* exception modeli parçaları
* dosya I/O ve çeşitli builtin yardımcıları

var.

Ama burada kritik bir ayrım lazım:

### Doğru tespit

Bu runtime **tamamen boş değil** ve “çalışmıyor” demek yanlış olur.

### Ama eksik olan şey

Runtime katmanı **heterojen**. Bir kısmı aktif, bir kısmı yarım, bir kısmı AST interpreter, bir kısmı MIR placeholder geçmişi taşıyor.

Örnek:

* dosyanın üst tarafında “Basit MIR execution, şimdilik placeholder” notları var.
* bazı eski MIR deneme kalıntıları yorum satırında kalmış.
* aynı dosyada hem güncel yürütme mantığı hem eski iskelet izleri bulunuyor.

Bu şu anlama geliyor:

* runtime kullanılabilir,
* ama temizlenmemiş katman kalıntıları var,
* dolayısıyla bakım maliyeti yüksek.

### Runtime güçlü yanlar

* FFI politika/allowlist yaklaşımı iyi düşünülmüş.
* exec helper dosyalarına parçalanmış yapı doğru.
* class layout, collections, builtin kategorileri, flow, file I/O ayrılmış.

### Runtime zayıf yanlar

* `memory_exec.fbs` çok büyük.
* AST runtime ile MIR runtime kavramları tarihsel olarak üst üste binmiş.
* `ExecValue` hâlâ temel alanlarda sade; yorum satırlarında “removed for simplicity” izleri var.
* User function / bazı ileri çağrı türlerinde unsupported/not implemented izleri sürüyor.

## Codegen: özellikle x64

Burada iki ayrı codegen hattı var:

1. `codegen/x64/ffi_call_backend.fbs` ve `x86/ffi_call_backend.fbs`

   * FFI stub planlama/emit
2. `codegen/x64/code_generator.fbs`

   * genel x64 native emit

### Bu zip’te codegen durumu

Bu repoda x64 codegen artık “yok” seviyesinde değil. Dosya 2600+ satır ve içinde:

* context
* symbol/routine/local yönetimi
* label generator
* local/global ayrımı
* expr emit
* DIM slot hesabı
* indexed local load/store
* routine local toplama
* statement emit
* `IF`, `FOR`, `CALL`, `PRINT`, `RETURN`, `ASSIGN`, `INC/DEC`
* DLL call support
* FFI extern/support emit
* `__uxb_main` ve output assembly toparlama

var.

Yani yukarıdaki terminal özetinde yazılan “x64 NASM codegen’i iskeletten işlevsel hale getirdim” sözü bu zip’teki dosya ile genel olarak **uyumlu**. Uydurma görünmüyor.

### Codegen gerçekten ne yapıyor?

* yalnızca FFI stub üretmiyor
* AST’den genel amaçlı asm üretiyor
* basit scope/slot sistemi var
* Win64 çağrı düzenini kullanıyor
* native build pipeline’a bağlanıyor

### Ama tam güçlü olduğu söylenebilir mi?

Hayır. Çünkü dosyanın içinde doğrudan görülen sınırlamalar var:

* unsupported binary op için TODO yorumları var
* expression kind TODO’ları var
* unsupported statement hataları var
* assignment operator desteği sınırlı
* unknown node fallback var
* build status raporunda da açıkça “partial” denmiş
* INLINE, artifact olarak planlanıyor ama ana emit yoluna tam örülmemiş

### Kısacası codegen yorumu

Bu repo için doğru cümle şu:

**x64 codegen artık gerçek bir backend çekirdeği olmuş, ama dil yüzeyinin tamamını kapsayan olgun bir backend değil.**

### Codegen güçlü taraflar

* Tek dosyada dağılmamış; merkezileşmiş.
* Routine, local, global, FFI, builtins, statement emit mantığı var.
* Sadece “çıktı veriyor” değil; build pipeline’a kadar gidiyor.
* Smoke/basic tests bunu destekliyor.

### Codegen zayıf taraflar

* Dosya çok şişmiş; 2600+ satır tek dosyada.
* Sezgisel ama kırılgan bir symbol/slot yönetimi olabilir; bunu daha fazla test gerekir.
* Her AST kind için kesin kapsama yok.
* Type-aware codegen derinliği sınırlı; daha çok integer/temel akış merkezli izlenim veriyor.
* INLINE ile ana emit arasında tam birleşim yok.

## x64 build pipeline

`src/build/x64_build_pipeline.fbs` önemli bir artı. Çünkü asm üretmekle kalmayıp:

* asm kaydı
* entry shim üretimi
* interop manifest çözme
* FFI x64 artifact üretme
* inline artifact planlama
* build bat/rsp/report üretimi

yapıyor.

Bu, derleyicinin “sadece asm döken oyuncak” olmadığını gösteriyor.

Ama kendi raporu bile “partial” diyor. Bu dürüst bir durum değerlendirmesi.

## FFI / interop katmanı

Bu projede gerçekten güçlü taraflardan biri burası.

* x64 FFI backend
* x86 FFI backend
* manifest çözme
* allowlist / policy
* resolver csv
* stub asm
* import build manifest
* rsp / bat / makefile üretimi

Bu alan, native codegen’den bile daha olgun görünüyor.

Yani projenin en sağlam üretim hattı muhtemelen:
**interop + FFI + build artifact zinciri**

## Dış klasörler ne söylüyor?

### `tests/`

Burada çok önemli bir veri var: test adları bile sistemin hedeflerini gösteriyor.

Görülen alanlar:

* lexer stabilization
* keyword normalization
* semantic extended pass
* memory vm / exec
* file io
* class ctor/dtor
* inheritance / virtual / interface
* collection engine
* percent preprocess
* namespace/module/main
* interop
* FFI x64/x86
* layout intrinsics
* pointer intrinsics
* runtime intrinsics
* codegen smoke

Yani hedeflenen dil yüzeyi geniş ve test repertuvarı da bunu doğruluyor.

Ama aynı zamanda şu da anlaşılıyor:

* testler geniş, sistem de geniş
* bu da derleyicinin henüz konsolide olmadan büyüdüğünü gösteriyor

### `dist/`

Bu klasörde çok fazla build/artifact var. Bu iyi ama aynı zamanda repo temizliği açısından kötü. Kaynak repo ile üretilmiş çıktıların iç içe geçmiş olması bakım kalitesini düşürür.

### `release/`

İçinde repo kopyası var. Bu pratikte karışıklık yaratır. Aynı projenin birden fazla gömülü kopyası ileride yanlış dosyayı inceleme/derleme riskini artırır.

### `extras/uxstat/`

Bu yan proje faydalı olabilir ama ana repo içinde ikinci bir ürün gibi duruyor. Modüler ayrım iyi yapılmazsa odak dağılır.

## Eksikler ve kırılgan noktalar

En net gördüklerim:

Birincisi, proje çok genişlemiş ama merkezileşme tam değil. Parser, AST runtime, MIR runtime, x64 codegen, FFI artifact zinciri aynı anda büyümüş.

İkincisi, `src` içinde bile derlenmiş exe dosyaları bulunuyor (`main.exe`, `main_32.exe`, `main_64.exe`). Kaynak ağacında binary bulunması kötü pratik.

Üçüncüsü, `code_generator.fbs` işlevsel olsa da kapsama tam değil. TODO/unsupported izleri bunun doğrudan kanıtı.

Dördüncüsü, runtime katmanında geçmiş placeholder/yarım geçiş izleri var. Özellikle MIR ile ilişkili tarihsel kod kalıntıları temizlik istiyor.

Beşincisi, semantic ve type/layout sistemi güçlü niyet taşıyor ama dil yüzeyi genişledikçe sistematik type contract zorunlu hale gelecek. Şu an yapı var, ama daha fazla yük gelirse dağılabilir.

Altıncısı, proje üretim/paketleme/test/artifact dosyalarını kaynakla çok iç içe tutuyor. Bu mimari değil ama bakım sorunu.

## En dürüst genel değerlendirme

uXBasic bu zip’te artık şunlardan biri değil:

* basit BASIC yorumlayıcı değil
* sadece parser demo’su değil
* sadece FFI deneyi değil

Bu sistem şu an:
**modüler ama ağırlaşmış, çok yollu çalışan bir BASIC frontend + semantic katman + runtime + kısmi native backend + güçlü interop aracı**

Yani “tam compiler mi?” sorusuna en dürüst cevap:
**yarı olgun hibrit derleyici platformu**

## Codegen için en net hüküm

Yukarıdaki log ile koddaki durum genel olarak örtüşüyor.
Bu repoda x64 codegen gerçekten büyütülmüş ve CLI’ye bağlanmış.
Ama hâlâ şu seviyede:

* işlevsel
* testlenmiş başlangıç backend’i
* tam kapsayıcı olmayan backend

Yani:
**“iskeletten işlevsele geçmiş ama hâlâ kısmi”**

## En güçlü alanlar

* FFI / interop hattı
* parser kapsamı
* test repertuvarı
* MIR katmanının beklenenden daha gelişmiş olması
* x64 build pipeline düşüncesi

## En riskli alanlar

* tek dosyada aşırı büyüyen codegen
* runtime’da tarihsel kalıntı/karmaşıklık
* type/layout/semantic bütünlüğünün ileride çatlama riski
* repo hijyeni: source ile binary/artifact karışması

İstersen sonraki mesajda sana sadece şu üç şeyi vereyim:
`src` dosyalarını klasör klasör kısa görev listesi, codegen kapsama matrisi ve eksiklerin öncelik sırası.
Aşağıya uXBasic’in mevcut mimarisini, ulaşılmak istenen hedef durumu, katmanlar arası bağlantıları, eksikleri ve bunların nasıl tamir edilip daha iyi hale getirileceğini tek bir bütün halinde yazıyorum. Bu, doğrudan `src` klasörü ve yan klasörlerin hızlı ama geniş kapsamlı incelenmesine dayanır.

# 1. uXBasic’in bugünkü mimarisi

uXBasic bugün tek bir şey değildir. Tek başına “BASIC derleyicisi” demek eksik kalır. Mevcut yapı aslında beş parçalı hibrit bir sistemdir.

Birinci katman lexer ve parser katmanıdır. `src/parser` altında dilin sözdizimini çözer, AST üretir, preprocess direktiflerini işler, sınıf, prosedür, bellek, I/O, registry, alias, include/import ve benzeri yapıları parse eder.

İkinci katman semantic katmandır. `src/semantic` altında AST üzerindeki anlam kontrollerini, type binding, layout, intrinsic çözümleme, HIR/MIR üretimi ve bazı optimizasyonları yapar.

Üçüncü katman runtime/interpreter katmanıdır. `src/runtime` ve `src/runtime/exec` altında AST tabanlı veya kısmen MIR tabanlı yürütme sağlar. Dosya işlemleri, sınıf yerleşimi, built-in çağrılar, bazı FFI köprüleri ve statement yürütme burada yaşar.

Dördüncü katman interop ve build katmanıdır. `src/build` altında include/import manifest çıkarımı, artifact üretimi, FFI stubları, x64 build pipeline ve paketleme türü çıktılar üretilir.

Beşinci katman codegen katmanıdır. `src/codegen/x64` altında gerçek bir x64 backend çekirdeği oluşmaya başlamıştır. `src/codegen/x86` tarafı daha çok FFI backend seviyesindedir.

Bunların tepesinde `src/main.bas` bir sürücü görevi görür. Kaynağı okur, lex/parse yapar, gerekirse semantic çalıştırır, sonra mod seçimine göre AST JSON, MIR JSON, interpreter çalıştırma, interop artifact üretimi, x64 asm emit veya x64 build yollarına sapar.

Yani mimari şu zincire sahiptir:

Kaynak kod → preprocess + lexer → parser → AST → semantic/type/layout → HIR/MIR → interpreter veya codegen veya interop/build artifact.

# 2. Ulaşılmaya çalışılan hedef durum

Kodun bugünkü hali, hedefin yalnızca “çalışan bir BASIC yorumlayıcı” olmadığını açıkça gösteriyor. Hedef daha büyük:

uXBasic bir modern BASIC ailesi dili olmak istiyor. Sadece klasik BASIC komutlarını değil, sınıfları, methodları, interface sözleşmelerini, alias/using mantığını, import/include yönetimini, FFI ve inline assembly’yi de taşıyan bir sistem olmaya çalışıyor.

Aynı zamanda tek yürütme yolu istemiyor. Üç farklı çalışma tarzına ilerliyor:

AST tabanlı interpreter, MIR tabanlı interpreter ve x64 native codegen.

Buna ek olarak bir “interop üretim hattı” olmak istiyor. Yani C/C++/ASM ile birlikte yaşayan, NASM/gcc/g++ araç zinciriyle derlenebilen, build artifact üreten bir sistem.

En doğru hedef tanımı şu olur: uXBasic, uzun vadede modüler bir frontend + sağlam semantic/type sistemi + MIR omurgası + interpreter + native backend + interop build platformu olmak istiyor.

# 3. Katmanların birbirleriyle bağlantısı

Parser semantic’e AST verir. Semantic katmanı parser’ın ürettiği ağacın doğru olup olmadığını, tipleri, çağrıları, override sözleşmelerini, bazı intrinsic ve layout kurallarını denetler. Semantic tarafı aynı zamanda HIR/MIR üretimi için altlık sağlar.

Runtime katmanı semantic sonucu geçmiş AST ya da türetilmiş anlam bilgisini kullanarak bellekte programı çalıştırır. Runtime içinde built-in çağrılar, dosya işlemleri, sınıf inşası ve akış kontrolü bulunur.

Codegen katmanı semantic’ten sonra AST üzerinden x64 assembly üretir. Şu an tam anlamıyla MIR merkezli değil; daha çok AST’den backend’e gider.

Interop/build katmanı semantic sonrası include/import ve FFI ihtiyaçlarını çıkarır, plan üretir, artifact döker, x64 build zincirini oluşturur.

Buradaki temel mimari gerilim şudur: AST, semantic, runtime, MIR ve codegen aynı anda merkez rolü oynuyor. İdeal mimaride merkez tek olur; burada merkez birden fazla.

# 4. Mevcut eksikler: tek tek ana başlıklar

## 4.1 Merkez IR eksikliği

En büyük yapısal eksik, MIR’in var olmasına rağmen bütün sistemi tek merkezde toplamamış olmasıdır. Şu an parser’dan sonra üç yol açılıyor: AST interpreter, MIR interpreter, AST tabanlı x64 codegen. Bu, orta vadede çoğaltılmış mantık üretir.

Tamir yolu: parser sonrası AST normalization zorunlu olmalı. Sonra semantic geçmeli. Sonra tek bir canonical HIR/MIR üretilmeli. Bundan sonra hem interpreter hem codegen MIR üzerinden çalışmalı. AST doğrudan runtime’a ve codegen’e gitmemeli.

## 4.2 `main.bas` fazla sorumluluk taşıyor

`src/main.bas` sadece program girişi değil, mod seçici, hata yerelleştirici, dosya okuma/yazma, semantic kontrol yöneticisi, JSON export sürücüsü ve build/interop yönlendiricisi haline gelmiş.

Tamir yolu: `main.bas` üç parçaya ayrılmalı. `cli_frontend.fbs`, `pipeline_runner.fbs`, `io_host.fbs`. `main.bas` sadece argümanları okuyup `RunPipeline(config)` çağırmalı.

## 4.3 Bundle sistemi dağınık

`main_frontend_include_bundle.fbs` ve `main_runtime_include_bundle.fbs` faydalı ama asıl katman sınırlarını garantilemiyor. `main.bas` doğrudan çok sayıda dosya include ediyor.

Tamir yolu: katman bazlı sabit bundle’lar olmalı: `frontend_bundle`, `semantic_bundle`, `runtime_bundle`, `codegen_bundle`, `interop_bundle`. `main.bas` yalnızca bu beş bundle’ı include etmeli.

## 4.4 Parser çok büyümüş

Özellikle `parser_stmt_dispatch.fbs`, `parser_stmt_decl_core.fbs`, `parser_stmt_flow.fbs` ve declaration dosyaları parser’ı çalışır tutuyor ama bakım maliyeti yükselmiş. Statement dispatch mantığı tek merkezde çok şişmiş.

Tamir yolu: statement parser’ları konuya göre daha sert bölünmeli. Örneğin `stmt_control`, `stmt_io`, `stmt_decl_vars`, `stmt_decl_routines`, `stmt_oop`, `stmt_interop`, `stmt_memory`, `stmt_system`. Dispatch dosyası sadece bir router olmalı.

## 4.5 Preprocessor güçlü ama tehlikeli

`lexer_preprocess.fbs` ayrı olması iyi. Ancak preprocess mantığı lexerden önce ve dilin geri kalanıyla zayıf kontratla bağlı. Büyük projelerde include ve conditional zincirleri zorlaşacaktır.

Tamir yolu: preprocess için ayrı bir ara çıktı modeli olmalı. `PreprocessSource -> PreprocessedUnit -> Lexer`. Ayrıca include stack, macro registry, platform symbol table gibi yapılar tek bir type içinde toplanmalı.

## 4.6 Semantic katman parçalı

`semantic_pass.fbs` büyük ve önemli bir dosya. İçinde override, interface, overload, constant fold ve çeşitli doğrulamalar var. Ama semantic görevleri hâlâ “kurallar toplamı” gibi. Daha sistematik bir “pass manager” görünmüyor.

Tamir yolu: semantic şu pass’lere bölünmeli: symbol collection, type registration, type resolve, routine signature validation, class/interface validation, call resolution, constant folding, control-flow sanity, final contract pass. Her pass ayrı dosya ve ortak `SemanticContext` ile çalışmalı.

## 4.7 Type sistemi ve runtime temsili tam birleşmemiş

`type_binding.fbs`, `layout_*` dosyaları, runtime value modeli ve codegen’in tip bilgisi tek merkezli bir type contract altında birleşmiş değil.

Tamir yolu: `TypeId`, `TypeInfo`, `StorageClass`, `LayoutInfo`, `CallSignature`, `ValueKind` tek bir çekirdek type modelinde toplanmalı. Semantic, runtime ve codegen aynı type çekirdeğini kullanmalı.

## 4.8 Runtime heterojen ve kısmen tarihsel

`memory_exec.fbs` büyük, ciddi ve çalışan parçalar taşıyor. Ama içinde eski MIR placeholder izleri, unsupported call noktaları, eksik unary/binary op alanları ve bazı “not implemented” kalıntıları var.

Tamir yolu: runtime ikiye ayrılmalı. `ast_exec_legacy` ve `mir_exec_core`. Hedefte AST runtime küçültülmeli, MIR runtime ana yürütücü olmalı. `memory_exec.fbs` parçalanmalı: environment, eval_expr, eval_stmt, call_engine, object_engine, ffi_bridge, debug_host.

## 4.9 Built-in çağrılar fazla dağılmış

`exec_eval_builtin_categories.fbs` büyük. Bu tür dosyalar büyüdükçe “unsupported call” hataları çoğalır ve bakım zorlaşır.

Tamir yolu: built-in sistem registry temelli olmalı. Her kategori `RegisterBuiltin(category, name, fnptr, signature)` ile kayıt edilmeli. Hata sistemi de “unsupported call” yerine önerili isimlerle cevap vermeli.

## 4.10 Hata sistemi ilkel

`diagnostics.fbs`, `error_format.fbs`, `error_localization.fbs` mevcut ama bu bir “tanı altyapısı” değil; daha çok log + string çeviri sistemi.

Bugünkü eksikler:

* hata kodu sistemi zayıf
* kaynak konum bilgisi bütün hatalarda yok
* katman bazlı structured error yok
* warning, info, note, hint düzeyleri yetersiz
* toplu hata raporu ve tekil hata tipi ayrımı zayıf

Tamir yolu: `Diagnostic` tipi tasarlanmalı. İçinde `code`, `severity`, `message_en`, `message_tr`, `file`, `line`, `column`, `stage`, `related_spans`, `hint`, `raw_detail` olmalı. Parser, semantic, runtime, codegen hepsi aynı yapıyı üretmeli. `DiagWrite` artık düz string değil, `Diagnostic` nesnesi almalı.

## 4.11 Codegen var ama kapsamı tam değil

`src/codegen/x64/code_generator.fbs` bu zip’te gerçekten işlevsel bir backend çekirdeği. Ancak kendi içinde de sınırlamalar açık:

* unsupported statement hataları var
* unsupported binary op yorumları var
* unsupported assignment op var
* genel emit TODO’ları var

Tamir yolu: codegen AST’den değil MIR’den beslenmeli. Geçici olarak AST codegen devam edecekse bile dosya modülerleşmeli. En az şu parçalara bölünmeli:

* `cg_context`
* `cg_symbols`
* `cg_locals`
* `cg_expr`
* `cg_stmt`
* `cg_flow`
* `cg_call`
* `cg_data_bss`
* `cg_builtins`
* `cg_entry`
* `cg_emit_text`

Bugünkü 2600+ satırlık tek dosya sürdürülebilir değil.

## 4.12 x86 ve x64 ayrımı yarım

x64 tarafı genel backend olmaya başlamış, x86 tarafı daha çok FFI backend görünümünde. Bu asimetri mimari borç üretir.

Tamir yolu: ortak backend arabirimi olmalı. `IBackend` benzeri bir yüzey ile `EmitModule`, `EmitCall`, `EmitData`, `EmitRoutine`, `FinalizeOutput` gibi sabit girişler tanımlanmalı. x64 ve x86 farklı implementasyon vermeli.

## 4.13 Interop/build hattı güçlü ama merkez dışı

`interop_manifest.fbs` ve `x64_build_pipeline.fbs` ciddi işler yapıyor. Ama build pipeline, compiler pipeline’ın doğal uzantısı gibi değil; biraz dışarıda duran araç katmanı gibi.

Tamir yolu: compiler pipeline içinde `ArtifactPlan` üretimi tek tip olmalı. FFI, inline asm, import objects, nasm asm, rsp, bat, report hepsi tek “build graph” içinde tanımlanmalı.

## 4.14 Repo hijyeni kötü

`src` içinde `.exe` bulunması, `release` içinde repo kopyası bulunması, `dist` ile kaynak ağacının çok iç içe olması ciddi bakım sorunu.

Tamir yolu: `src` tamamen saf kaynak olmalı. Binary ve artifact’ler yalnızca `dist/` veya `out/` altında. `release` ayrı paketleme script’i ile üretilmeli; içinde gömülü repo tutulmamalı.

# 5. Büyük dosyaların modülerleştirilmesi

En kritik dosyalar:

* `semantic/mir.fbs`
* `codegen/x64/code_generator.fbs`
* `runtime/memory_exec.fbs`
* `runtime/exec/exec_eval_support_helpers.fbs`
* `semantic/semantic_pass.fbs`
* `build/interop_manifest.fbs`
* `parser/parser/parser_stmt_dispatch.fbs`
* `parser/parser/parser_stmt_decl_core.fbs`

Bunlar konuya göre bölünmeli. Özellikle `mir.fbs` şu alt dosyalara ayrılmalı: model, builder, lowering_expr, lowering_stmt, optimizer, evaluator, exporter_json, helper_controlflow.

`semantic_pass.fbs` şu altlara ayrılmalı: symbols, types, calls, classes, interfaces, constants, controlflow, finalcheck.

`memory_exec.fbs` şu altlara ayrılmalı: exec_context, exec_expr, exec_stmt, exec_calls, exec_objects, exec_arrays, exec_ffi, exec_debug.

`interop_manifest.fbs` şu altlara ayrılmalı: scan_include_import, normalize_paths, manifest_model, emit_csv_rsp, emit_scripts.

# 6. Çıktıların mükemmel tasarımı nasıl olmalı

Burada “çıktı” yalnızca asm değil. AST JSON, MIR JSON, parse raporu, build report, interop manifest, runtime hata raporu, diagnostic log, final asm, build scripts hepsi tasarımlı olmalı.

İdeal tasarım:

Her çıktı için tek format sözleşmesi olmalı. İnsan-okur ve makine-okur ayrılmalı.

İnsan-okur raporlar:

* `dist/reports/parse_report.txt`
* `dist/reports/semantic_report.txt`
* `dist/reports/build_report.txt`
* `dist/reports/runtime_report.txt`

Makine-okur raporlar:

* `dist/json/ast.json`
* `dist/json/hir_inventory.json`
* `dist/json/mir_pipeline.json`
* `dist/json/diagnostics.json`
* `dist/json/build_plan.json`

Asm çıktısı:

* `dist/asm/program_x64.asm`
* `dist/asm/ffi_x64.asm`
* `dist/asm/inline_blocks.asm`

Obj ve exe:

* `dist/obj/...`
* `dist/bin/program.exe`

Yani çıktı ağacı katmanlı ve isimlendirilmiş olmalı. Şu an bazı çıktılar `dist` içine dağılmış durumda.

# 7. Hata sisteminin tam tasarımı

Yeni hata sistemi şu ilkelerle kurulmalı:

Her hata bir kod taşımalı. Örneğin `P1001` parser, `S2004` semantic, `R3008` runtime, `C4002` codegen, `B5001` build.

Her hata konum taşımalı. Yalnızca parse değil semantic ve codegen de mümkün olduğunca AST node üzerinden span bilgisi taşımalı.

Her hata bir ana mesaj ve bir ipucu taşımalı. Örneğin “unsupported binary op” yerine “Bu işlem x64 backend tarafından henüz desteklenmiyor. Geçici çözüm: MIR backend veya AST interpreter kullan.”

Her hata tek merkezde formatlanmalı. `UxbFormatError` bugünkü gibi düz stringle kalmamalı.

Her katman hem Türkçe hem İngilizce ham mesaj verebilmeli. Yerelleştirme string pattern değil hata kodu üstünden yapılmalı.

# 8. Hedef mimari: olması gereken tasarım

En temiz hedef mimari şu olur:

`CLI`
→ `Preprocessor`
→ `Lexer`
→ `Parser`
→ `AST Normalize`
→ `Semantic Pass Manager`
→ `Canonical MIR`
→ buradan iki ana yol:
`MIR Interpreter`
veya
`Backend (x64/x86/başka)`

Build ve interop ise MIR sonrası `BuildGraph` üzerinden çalışmalı.

Runtime’ın kalıcı omurgası MIR olmalı. AST runtime yalnızca geçici veya debug amaçlı tutulmalı.

# 9. En gerçekçi tamir sırası

İlk önce repo temizliği ve klasör düzeni yapılmalı. Çünkü kaynak, binary ve artifact karışımı devam ederse her ilerleme pahalı olur.

Sonra hata sistemi birleştirilmeli. Çünkü parser, semantic, runtime, codegen hepsi bugün dağınık hata üretirse bakım zorlaşır.

Sonra büyük dosyalar modülerleştirilmeli. Özellikle `code_generator`, `memory_exec`, `mir`, `semantic_pass`.

Sonra tek merkez MIR kararı verilmeli. AST interpreter korunabilir ama ana yol MIR olmalı.

Sonra type/layout/runtime/codegen tek type contract altında birleştirilmeli.

Sonra x64 backend tamamlanmalı ve x86 ile ortak backend arayüzü kurulmalı.

# 10. Net sonuç

uXBasic’in çekirdeği zayıf değil. Hatta beklenenden daha büyük. Parser, semantic, runtime, interop ve codegen hepsi ciddi emek taşıyor. Sorun, sistemin küçük olması değil; aynı anda çok fazla rol üstlenmesi ve bu rollerin tek merkezde tam birleşmemiş olması.

Bugünkü haliyle uXBasic:

* parser deneyi değildir
* sadece interpreter değildir
* sadece FFI aracı değildir
* ama henüz tek merkezli, temiz, tam olgun bir compiler platformu da değildir

En doğru cümle şu:
uXBasic, güçlü bir hibrit compiler platform çekirdeğidir; esas ihtiyacı yeni özellikten önce mimari sıkılaştırma, katman birleştirme, hata sisteminin profesyonelleştirilmesi ve büyük dosyaların disiplinli modülerleştirilmesidir.

İstersen bir sonraki adımda bunu daha da somutlaştırıp sana doğrudan şu üç şeyi yazayım: “hedef klasör yapısı”, “dosya dosya yeniden bölme planı” ve “diagnostic sistemi için tam veri modeli”.
--------------
**uXBasic Sistem İncelemesi (Tam Özet)**

ZIP içeriği (`uXBasic6.zip`, ~27 MB, 1831 dosya) tam olarak açılmış bir proje deposudur. Proje **uXBasic** (ubasic031’in FreeBASIC temelli, Windows 11 odaklı yeniden yapılandırılması) derleyicisidir. Hem **interpreter** (memory_exec) hem de **native x64 codegen** destekler; FFI/DLL + C/CPP/ASM interop çok güçlüdür.

### 1. Klasör Yapısı (Ana Dizinler)
```
/
├── src/                  ← Kalp (85 dosya, 66 kaynak .fbs/.bas)
├── tests/                ← Test suite + out/ artifact’ları (AST JSON, pipeline CSV’ler)
├── build/                ← Smoke test’ler + derlenmiş exeler
├── dist/                 ← Derleme artifact’ları (ASM, interop planları, loglar, x64build/)
├── extras/uxstat/        ← Resmi istatistik DLL (uxstat.dll)
├── spec/                 ← Dil sözleşmesi (LANGUAGE_CONTRACT.md)
├── release/              ← Dağıtım paketlemesi + git mirror
└── (dist altındaki cmp_interop, x64build, interop vs. otomatik üretilir)
```

### 2. src/ Klasörü – Mimari (Tam İnceleme)
Tüm src dosyaları **FreeBASIC** modüler include sistemiyle (`#include "xxx.fbs"`) tek bir `main.bas` içinde derleniyor. Yapı **katmanlı ve çok temiz**:

- **src/main.bas**  
  Tüm frontend + semantic + codegen + runtime modüllerini `#include` eder. Giriş noktası burası.

- **parser/** (lexer + parser)  
  - `lexer/`: `lexer_core.fbs`, `lexer_driver.fbs`, `lexer_keyword_table.fbs`, `lexer_preprocess.fbs`, `lexer_readers.fbs`  
    Tokenizasyon, keyword tablosu, preprocess (INCLUDE, INLINE vb.), strict syntax (eski `$ % & !` sonekleri yasak).  
  - `parser/`: `parser.fbs` + alt modüller (`parser_expr.fbs`, `parser_stmt_*.fbs`, `parser_stmt_decl_*.fbs`, `parser_stmt_dispatch_class_access.fbs` vb.)  
    ASTPool tabanlı gerçek AST üretir (node havuzu, firstChild/nextSibling).  
    Desteklenen yapılar: CLASS, NAMESPACE, MODULE, MAIN, USING, ALIAS, DIM/REDIM, procedure decl, flow (IF/FOR/DO), IO, class method/ctor/dtor.

- **semantic/**  
  - `hir.fbs`, `mir.fbs`, `semantic_pass.fbs`, `type_binding.fbs`  
  - `layout/` alt klasörü: class layout, type table, path resolution, intrinsic validation.  
  → Tip kontrolü, name resolution, class ctor/dtor çağrısı, memory layout.

- **codegen/** (İstenen tam inceleme)  
  - **x64/** (ana hedef):  
    - `code_generator.fbs` ← **Merkez**.  
      X64CodegenContext ile text/data/bss section üretir.  
      VarMapping, label seed, loopDepth, local frame, FFI stub index.  
      `X64EmitNode` → `GenerateStatement` dispatch (node kind’e göre).  
      Desteklenenler: DIM/ASSIGN, INC/DEC, PRINT (runtime), TIMER/GETKEY/LTRIM/RTRIM/SPACE/STRING/MID, RANDOMIZE, CLS/COLOR/LOCATE, FFI DLL çağrıları (stub + symptr + arg storage).  
      Runtime çağrıları: `__uxb_runtime_*`, `__uxb_builtin_*`, `__uxb_ffi_stub_*`.  
    - `var_mapping.fbs`, `inline_backend.fbs`, `ffi_call_backend.fbs`.  
  - **x86/**: Sadece FFI x86 stub’ları (CDECL/STDCALL).  

  **Codegen durumu (dist/x64build/codegen_status_report.md + loglardan)**:  
  - Statement-oriented native emit **kısmi**.  
  - Basit smoke test’ler (console, flow, math) çalışıyor → `dist/x64build/program.exe` üretiliyor.  
  - Eksik: Tam PCK4/inceleme kapsamı, INLINE’in semantic entegrasyonu henüz tamamlanmamış (“not yet semantically woven”).  
  - FFI stub’ları CSV → NASM → obj → link pipeline çok olgun (import_manifest.csv, link_args.rsp, build_import.bat).

- **runtime/**  
  - `memory_vm.fbs`, `memory_exec.fbs` → interpreter.  
  - `exec/` alt klasörü: stmt flow, io file, call dispatch, class layout, FFI x64 invoke, eval helpers.  
  - `file_io.fbs`, `timer.fbs`, `error_localization.fbs` (Türkçe hata mesajları), `ffi_signer.fbs`, `diagnostics.fbs`.

- **build/**  
  - `x64_build_pipeline.fbs`, `interop_manifest.fbs`, runtime/frontend include bundle’ları.

### 3. Diğer Önemli Klasörler (Hızlı İnceleme)
- **dist/**: Derleme sırasında üretilen her şey (interop CSV’ler, err_backend stubs, ffi_call_x64/x86 stubs, import_objs, x64build/ pipeline bat’ları, loglar).  
- **tests/basicCodeTests/**: 40+ smoke + FFI probe (curl, python embed, lua, flint, mpfr vb.). `out/` klasöründe AST JSON, MIR plan, x64 ASM, exe’ler var.  
- **extras/uxstat/**: Resmi ilk DLL. VectorF64 + temel istatistik (mean, var, std, sem, min/max). C ABI, stdcall/cdecl wrapper’lar, MinGW build bat.  
- **release/**: Dağıtım paketlemesi (mini zip’ler, SHA256, BUILD_INFO).

### 4. Genel Mimari ve Akış
```
Kaynak .bas
   ↓ (lexer → parser)
AST (ASTPool)
   ↓ (semantic_pass)
HIR → MIR + type/layout resolution
   ↓ (codegen/x64)
NASM ASM + FFI stubs + interop objs
   ↓ (nasm + gcc link)
program.exe (WinMain shim + runtime)
```

Ayrıca **interpreter modu** (`--execmem`) paralel çalışır (memory_vm + exec_stmt_*).

### 5. Eksikler ve Zayıf Noktalar (Bulunanlar)
1. **Codegen eksiklikleri** (en kritik):
   - Tam statement coverage henüz yok (loglarda sık “x64 build basarisiz”).
   - INLINE backend var ama AST emit path’ine tam entegre değil.
   - Bazı MIR hataları (“Sol operand bulunamadi”).
2. **FFI / Policy**:
   - Allowlist var (`dist/config/ffi_allowlist.txt`) ama birçok testte REPORT_ONLY + deny (Sleep, GetTickCount vb.).
   - x86 resolver’da stub matching eksik.
3. **32-bit**:
   - Kod üretim hattı korunuyor ama odak x64.
4. **Test / Stabilite**:
   - Birçok testte FFI “unsupported call CALL” veya “KEYWORD_REF” hataları.
   - Class ctor/dtor ve layout runtime’da var, codegen’de tam test edilmemiş görünüyor.
5. **Dokümantasyon**:
   - `spec/LANGUAGE_CONTRACT.md` ve `PCK5.md` var ama tam değil.
6. **Derleme Pipeline**:
   - CodeBlocks/MinGW fallback toolchain var ama CI’da bazen kırılıyor.

### 6. Güçlü Yönler
- Parser çok modern ve güçlü (class, namespace, module, strict syntax).
- Interop pipeline (C/CPP/ASM + DLL FFI) endüstriyel seviyede.
- Runtime Türkçe hata lokalizasyonu ve detaylı loglama.
- Hem interpreter hem native x64 desteği.
- Modular .fbs yapısı çok okunaklı ve genişletilebilir.

**Sonuç**: uXBasic, **temel altyapısı sağlam**, **x64 codegen’i olgunlaşma aşamasında** bir derleyici. Parser + semantic + interop çok ileri seviyede. Codegen’in kalan kısımlarını tamamlamak (özellikle FFI runtime resolve + INLINE tam entegrasyon + kalan statement’lar) ile production-ready hale gelebilir.

**✅ uXBasic Tam Mimari Katman Analizi (Güncel ZIP’e Göre)**

Aşağıda **tam katmanlı mimari haritası** + **birbirine karışan / placeholder / eksik / kısmen kalan yerler** net şekilde ortaya çıkarılmıştır. Analiz, `src/` içindeki tüm `.fbs` dosyaları, `main.bas`, `dist/x64build/codegen_status_report.md`, loglar ve `dist/interop/` artifact’ları üzerinden yapıldı.

### 1. Mimari Katmanlar (Layered Architecture)

| Katman | Modüller (src/) | Sorumluluk | Durum |
|--------|------------------|------------|-------|
| **1. Frontend** | `parser/lexer/*`<br>`parser/parser.fbs` + alt parser’lar (expr, stmt_decl_*, stmt_flow, stmt_io, class_access vb.)<br>`parser/ast.fbs` | Lexer → Token → **ASTPool** (node havuzu, firstChild/nextSibling) | **Tam & Olgun** |
| **2. Semantic / Middle-End** | `semantic/semantic_pass.fbs`<br>`semantic/hir.fbs`, `mir.fbs`<br>`semantic/type_binding.fbs`<br>`semantic/layout/*` (path_resolution, type_table, intrinsic_validation) | Name resolution, type checking, class layout, ctor/dtor validation, MIR üretimi | **Kısmi** (bazı operand/MIR hataları var) |
| **3. Codegen / Backend (x64 Native)** | `codegen/x64/code_generator.fbs` (ana emitter)<br>`codegen/x64/var_mapping.fbs`<br>`codegen/x64/ffi_call_backend.fbs`<br>`codegen/x64/inline_backend.fbs`<br>`codegen/x86/ffi_call_backend.fbs` | AST → NASM (text/data/bss) + runtime çağrıları + FFI stub’lar + interop manifest | **Kısmi (en kritik katman)** |
| **4. Build / Interop Pipeline** | `build/x64_build_pipeline.fbs`<br>`build/interop_manifest.fbs`<br>`build/main_frontend_include_bundle.fbs`<br>`build/main_runtime_include_bundle.fbs` | CSV planları → NASM stubs → import_objs → bat/rsp → nasm+link | **Olgun (pipeline)** |
| **5. Runtime** | `runtime/memory_exec.fbs` + `memory_vm.fbs`<br>`runtime/exec/*` (stmt_flow, call_dispatch, ffi_x64_invoke, class_layout_helpers vb.)<br>`runtime/file_io.fbs`, `timer.fbs`, `ffi_signer.fbs`, `error_localization.fbs` | Interpreter + shared runtime stubs (err_backend, ffi_call_x64/x86) | **Kısmi** |
| **6. Orchestrator** | `src/main.bas` | Komut satırı, mod seçimi (--interpreter-backend vs x64), include zinciri, error reporting | **Tam** |

**Genel Akış**:
```
.bas → Lexer → Parser (ASTPool) → SemanticPass (HIR→MIR) → 
Codegen (NASM + FFI stubs) → Build Pipeline (nasm+link) → .exe
          ↳ Interpreter Mode (memory_exec)
```

### 2. Mimari Yapıda **Birbirine Karışan / Placeholder / Eksik / Kısmen Kalan Yerler**

Aşağıda **katman bazında** net liste:

#### **En Kritik Karışıklıklar (Codegen Katmanı)**
`src/codegen/x64/code_generator.fbs` içinde **3 adet açık TODO** + çok sayıda placeholder:
- `X64EmitComment cg, "TODO: emit node kind='...'"` (2541. satır civarı)
- Binary expression: `TODO: unsupported binary op` + `TODO: expression kind`
- `NEW_EXPR`, `FOR`, `LOCATE`, `COLOR`, `INCDEC_STMT`, `ASSIGN_STMT` gibi node’larda eksik operand kontrolü ve emit.
- **INLINE** backend ayrı modül olarak var (`inline_backend.fbs`) ama status report’ta açıkça yazıyor:  
  > “INLINE is reported/planned as artifact but **not yet semantically woven into main AST emit path**”

**Sonuç**: Codegen **statement-oriented** ve **kısmi**. Basit smoke test’ler (console, math, flow) çalışıyor, ama PCK4/inceleme kapsamının büyük kısmı eksik.

#### **Build Pipeline Katmanı**
`src/build/x64_build_pipeline.fbs`:
- Hardcoded “partial” status raporları.
- `COMPILER_TODO.md` referansı var ama `src/` içinde dosya yok (legacy kalıntı).
- Interop manifest + CSV → NASM → link pipeline **olgun**, ama codegen’in eksikliklerini maskeliyor.

#### **Semantic / MIR Katmanı**
- `semantic_pass.fbs` + MIR interpreter’da sık görülen hata: **“MIR: Sol operand bulunamadi”** (loglarda tekrar tekrar).
- Class layout ve ctor/dtor semantic’de destekleniyor, ancak codegen’de tam entegrasyon yok (`ExecConfigureClassStorage`, `ExecAllocClassInstance` runtime’da var).

#### **Runtime / Interpreter Katmanı**
`src/runtime/memory_exec.fbs`:
- 2 adet **açık placeholder** (“unsupported call CALL”, “Expression: Desteklenmeyen ifade türü: KEYWORD_REF”).
- FFI x86 resolver’da stub matching eksik → allowlist’teki KERNEL32.Sleep/GetTickCount gibi çağrılar “deny” + “unsupported” hatası veriyor.
- `exec_ffi_x64_invoke_helpers.fbs` var ama tam runtime resolve (symptr doldurma) kısmi.

#### **FFI / Interop Katmanı**
- Pipeline (CSV plan, NASM stubs, import_build_manifest.csv, link_args.rsp) **çok olgun**.
- Ama **runtime tarafı** (özellikle x86 ve policy enforcement) kısmi → loglarda sürekli “FFI policy_decision mode=REPORT_ONLY decision=deny” ve “no matching entry”.

#### **Genel Mimari Karışıklık Noktaları**
1. **Interpreter vs Native** arasında runtime stubs’lar (`dist/interop/err_backend_*`, `ffi_call_x64/x86_stubs.asm`) **dist/** içinde otomatik üretiliyor ama `src/` içinde bazıları legacy kalıntı.
2. x86 FFI backend ayrı tutulmuş ama odak x64 → gereksiz karışıklık.
3. Error localization (`error_localization.fbs`) Türkçe çok iyi, ama codegen ve semantic hataları hâlâ İngilizce kalıyor.
4. `dist/x64build/codegen_status_report.md` her build’de “partial” yazıyor ve açıkça “not yet semantically woven” diyor → bu, mimaride **en net karışıklık** işareti.

### 3. Özet Tablo: Eksik / Kısmi / Karışan Yerler

| Katman              | Durum          | Karışan / Eksik / Placeholder’lar |
|---------------------|----------------|------------------------------------|
| Parser/AST          | Tam            | Yok |
| Semantic/MIR        | Kısmi          | Sol operand, class layout-codegen entegrasyonu |
| **x64 Codegen**     | **Kısmi**      | En fazla TODO, INLINE tam entegre değil, birçok stmt/expr eksik |
| FFI/Interop Pipeline| Olgun          | Runtime resolver (x86) ve policy eksik |
| Interpreter         | Kısmi          | Unsupported CALL / KEYWORD_REF |
| Build Pipeline      | Olgun          | Status raporları hardcoded + COMPILER_TODO.md referansı |

**Genel Değerlendirme**:
- Mimari **katmanlı ve modüler** (her şey `.fbs` include’larla ayrılmış, çok temiz).
- **En büyük sorun** `codegen/x64/code_generator.fbs` içindeki TODO’lar ve INLINE’in semantic entegrasyon eksikliği.
- Interop ve parser katmanları production-ready seviyede.
- Kalan iş: Codegen’de kalan node’ları tamamlamak + INLINE’i ana emit path’ine bağlamak + FFI runtime resolver’ı güçlendirmek.

**uXBasic Mimari Tasarım Dokümanı (v0.2 – Tam İnceleme & Yeniden Tasarım Önerisi)**

Bu doküman, **uXBasic6.zip** içindeki tüm kaynakları (src/, dist/, tests/, extras/, release/) detaylı inceledikten sonra hazırlanmıştır. Mevcut durumu, ulaşılmaya çalışılan vizyonu, **tüm eksiklikleri tek tek** ve **katman bazında** listeler. Ardından **tamir + iyileştirme + yeniden tasarım** önerilerini sunar.

### 1. Mevcut Mimari (Güncel Katmanlar)

```
Kaynak .bas
   ↓ Lexer (lexer_core + keyword_table + preprocess)
   ↓ Parser (ASTPool tabanlı, firstChild/nextSibling)
   ↓ SemanticPass (HIR → MIR + Type/Layout Resolution)
   ↓ Codegen (x64) + FFI Backend
   ↓ Build Pipeline (CSV → NASM stubs → import_objs → link)
   ↓ Runtime (Interpreter veya Native .exe)
```

**Katman Detay Tablosu:**

| Katman | Ana Modüller | Durum | Bağlantı Noktaları |
|--------|--------------|-------|--------------------|
| **1. Frontend** | `parser/lexer/*`, `parser/parser.fbs` + stmt/expr alt parser’ları | **Tam & Güçlü** | Token → ASTPool |
| **2. Semantic / Middle-End** | `semantic/semantic_pass.fbs`, `hir.fbs`, `mir.fbs`, `type_binding.fbs`, `layout/*` | **Kısmi** | AST → HIR → MIR + layout |
| **3. Codegen / Backend** | `codegen/x64/code_generator.fbs` (büyük dosya), `var_mapping.fbs`, `ffi_call_backend.fbs`, `inline_backend.fbs` | **En Zayıf Katman** | MIR → NASM + runtime stubs |
| **4. Build / Interop Pipeline** | `build/x64_build_pipeline.fbs`, `interop_manifest.fbs` | **Olgun** | CSV planları → bat/rsp → nasm+gcc |
| **5. Runtime** | `runtime/memory_exec.fbs`, `exec/*`, `file_io.fbs`, `ffi_signer.fbs`, `error_localization.fbs` | **Kısmi** | Interpreter + shared stubs |
| **6. Orchestrator** | `src/main.bas` | **Tam** | CLI + mod seçimi |

**Büyük Dosya Sorunu:**  
`src/codegen/x64/code_generator.fbs` ≈ 2500+ satır → tek dosya, çok fazla sorumluluk (emit_stmt, emit_expr, emit_ffi, emit_runtime, var mapping, label yönetimi…).

### 2. Ulaşılmaya Çalışılan Durum (Hedef Vizyon)

**Vizyon:**  
Modern, **üretim-ready**, **tamamen modüler** bir Basic derleyicisi:
- Hem **interpreter** (hızlı geliştirme) hem **native x64** (performans) modları tam destekli.
- **Tam class/ctor/dtor**, **namespace/module**, **operator overloading**, **generic** desteği.
- **Üst düzey FFI** (DLL + C/CPP/ASM interop) production kalitesinde (policy, signing, resolver tam).
- **INLINE** (assembly/C) tam semantic entegrasyonu.
- **Mükemmel hata sistemi** (Türkçe + İngilizce + structured JSON).
- **Mükemmel CI/CD çıktıları** (machine + human readable raporlar).
- **Kolay genişletilebilirlik** (yeni backend eklemek 1-2 modülle olsun).

**Hedef Mimari Prensipleri:**
- **Clean Architecture** (katmanlar arası net interface’ler)
- **Single Responsibility** (her modül tek iş yapsın)
- **Dependency Inversion** (yüksek seviye modüller düşük seviye modüllere bağlı olmasın)
- **Observable Outputs** (her adımda JSON + Markdown rapor)

### 3. Tüm Eksiklikler (Tek Tek – Katman Bazında)

**Frontend (Parser)**
- Eksik: Hiç yok (tam).

**Semantic / Middle-End**
1. MIR operand hataları (“Sol operand bulunamadi”).
2. Class layout + ctor/dtor semantic-codegen entegrasyonu eksik.
3. Bazı expression türlerinde type resolution eksik.

**Codegen (x64) – En Kritik Alan**
4. `code_generator.fbs` içinde **birçok TODO** ve placeholder (`TODO: emit node kind=...`, `TODO: unsupported binary op` vb.).
5. **INLINE** backend var ama “not yet semantically woven into main AST emit path”.
6. Birçok statement/expr (FOR, SELECT, NEW, bazı binary ops, array access vb.) eksik emit.
7. Var mapping ve local frame yönetimi kısmi.
8. Runtime stub çağrıları (print, timer, ltrim vb.) legacy printf ile karışık.

**Build / Interop Pipeline**
9. Status raporları hardcoded “partial”.
10. `COMPILER_TODO.md` referansı var ama dosya yok (legacy).

**Runtime / Interpreter**
11. “unsupported call CALL” ve “KEYWORD_REF” hataları.
12. FFI x86 resolver’da stub matching eksik → allowlist’teki çağrılar bile deny oluyor.
13. Policy enforcement (REPORT_ONLY modu) production-ready değil.

**Genel**
14. Hata sistemi dağınık (bazı yerler İngilizce, bazı yerler Türkçe).
15. Çıktılar tutarsız (bazı raporlar CSV, bazıları TXT, bazıları JSON).
16. Büyük dosyalar (code_generator.fbs, parser.fbs) bakım kâbusu.
17. 32-bit desteği korunuyor ama test coverage düşük.

### 4. Tasarım Önerileri & Çözüm Yolları

#### 4.1 Katman Bağlantıları (Dependency Graph)
```
Orchestrator (main.bas)
   ↓
Frontend → ASTPool (interface: GetRootNode, Traverse)
   ↓
SemanticPass (interface: ValidateAST → MIRContext)
   ↓
Codegen (interface: GenerateFromMIR → NASMText + Artifacts)
   ↓
BuildPipeline (interface: ExecuteBuild → Executable + Report)
   ↓
Runtime (shared stubs + interpreter)
```

**Öneri:** Her katman **net interface**’lere sahip olsun.  
Örnek: `CodegenInterface` → `EmitStatement(node)`, `EmitExpression(node)`, `EmitFFIStub(plan)`.

#### 4.2 Büyük Dosyaların Modülerleştirilmesi (Önerilen Yeni Yapı)
`src/codegen/x64/` klasörünü şu şekilde parçala:

```
codegen/x64/
├── codegen_interface.fbs          ← Ana interface
├── context.fbs                    ← X64CodegenContext
├── emit_stmt.fbs                  ← Tüm statement emit’leri
├── emit_expr.fbs                  ← Expression emit’leri
├── emit_ffi.fbs                   ← FFI stub + symptr
├── emit_inline.fbs                ← INLINE tam entegrasyon
├── emit_runtime.fbs               ← print, timer, ltrim vb.
├── var_mapping.fbs
├── label_manager.fbs
├── build_report.fbs               ← JSON + Markdown rapor
└── x64_main_driver.fbs            ← code_generator.fbs’in yerine
```

**Avantaj:** Her dosya < 600 satır, tek sorumluluk.

#### 4.3 Tüm Hata Sisteminin Yeniden Tasarımı
**Yeni Yapı:**
- `error/error_codes.fbs` → Enum (UXB_ERR_xxx)
- `error/error_context.fbs` → Struct (line, col, sourceFile, phase, details)
- `error/error_reporter.fbs` → Centralized (console, JSON, HTML)
- `error/localization.fbs` → Multi-language (TR/EN)

**Öneri:**
- Her hata `ErrorReport` objesi dönsün.
- Tüm katmanlar `ReportError(ctx)` çağırısın.
- Çıktı: `dist/errors/report.json` + `report.md` + `report.html`

#### 4.4 Tüm Çıktıların Mükemmel Tasarımı
Her build’de üretilmesi gereken **standart artifact seti**:

| Artifact | Format | İçerik |
|----------|--------|--------|
| `build_report.json` | JSON | node count, phase status, coverage, duration |
| `build_report.md` | Markdown | İnsan okunabilir özet + emoji status |
| `interop_manifest_v2.csv` + `.json` | CSV+JSON | Tüm import/FFI planları |
| `codegen_status.html` | HTML | Renkli dashboard (geçen/test edilen node’lar) |
| `errors/report.json` | JSON | Tüm hatalar + stack trace |
| `dist/x64build/program.exe` + `.map` | Binary + Map | Symbol + debug info |

**Ek:** `coverage/` klasörü → statement coverage raporu.

### 5. Tamir Yol Haritası (Prioritized)

**Phase 1 (1-2 hafta) – Temel Stabilizasyon**
- code_generator.fbs’i modüllere ayır.
- Tüm TODO’ları enumerate et ve emit_stub ekle.
- Hata sistemini centralized yap.

**Phase 2 (2-3 hafta) – Codegen Tamamlama**
- INLINE semantic entegrasyonu.
- Kalan statement/expr emit’leri.
- FFI runtime resolver’ı tam yap (x86 + x64).

**Phase 3 (1 hafta) – Çıktı & Rapor Mükemmelleştirme**
- Tüm artifact’ları yukarıdaki standartta üret.
- Build pipeline’ı `build_report.json` ile zenginleştir.

**Phase 4 – Test & Polish**
- Tüm tests/basicCodeTests/’i green yap.
- Class + namespace tam destek.
- 32-bit + x64 matrix CI.

