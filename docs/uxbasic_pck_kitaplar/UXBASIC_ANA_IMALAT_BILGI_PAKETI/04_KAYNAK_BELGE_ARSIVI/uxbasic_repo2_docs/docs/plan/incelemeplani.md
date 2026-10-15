2026-04-24 durum notu:

- `layout` tek kaynakli hale getirildi.
- runtime global-state tasimasi `ExecRuntimeContext` uzerinden ilerletildi.
- `memory_exec` parcasi icinde FFI policy/resolver/invoke akisi [exec_ffi_runtime.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/runtime/exec/exec_ffi_runtime.fbs) dosyasina ayrildi.
- `mir.fbs` icinde model/opcode/declaration bloğu [mir_model.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_model.fbs) dosyasina ayrilarak split baslatildi.
- `mir.fbs` icinde evaluator/value-engine bloğu [mir_evaluator.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/semantic/mir_evaluator.fbs) dosyasina ayrildi.
- `code_generator.fbs` icinde context/global/declaration yüzeyi [cg_context.fbs](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/src/codegen/x64/cg_context.fbs) dosyasina ayrildi.
- modulerlestirme sinirlari artik [COMPILER_FILE_MANIFEST.md](/C:/Users/mete/Downloads/BasicOyunSource/uXBasic_repo/COMPILER_FILE_MANIFEST.md) icinde kanonik tutuluyor.
- sonraki ana hedef: `mir.fbs` ve `code_generator.fbs` icin ayni sinirlari uygulamak ve coverage sprintini `SELECT`, `DO/FOR`, file I/O, arrays, `TYPE/CLASS` etrafinda buyutmek.

1. Frontend: Lexer / Parser / AST
Durum: Görece en güçlü katman.

Eksikler / riskler:

parser_stmt_dispatch.fbs ve deklarasyon parser dosyaları çok büyümüş.
Bazı expression formları sınırlı: özellikle member access tarafında member access expression unsupported; expected call izi var.
Legacy syntax ile modern syntax belgelerde karışık: _ASM, ASM_SUB, ASM_FUNCTION, $ suffix gibi şeyler bazı dokümanlarda aktif gibi duruyor ama parser politikasında kapalı.
PCK2/PCK4/PCK5 arasında aynı komut için farklı durumlar yazıyor.
Sınıf:

Belge drift’i
Parser bakım karmaşıklığı
Legacy syntax politikası netleştirme
2. Semantic / Type / Layout / MIR
Durum: Var ve çalışıyor ama merkez omurga hâline tam gelmemiş.

Eksikler / riskler:

MIR hâlâ tüm dilin tek canonical IR’ı değil; AST runtime ve x64 codegen doğrudan AST’den de çalışıyor.
mir: unsupported binary op, mir: unsupported expr kind, mir: unsupported assign op hâlâ var.
Class/layout semantic ile native codegen arasında tam eşleşme yok.
Type sistemi runtime temsilinden yer yer kopuk: TYPE, CLASS, LIST/DICT/SET, pointer ve numeric tipler her katmanda aynı kontratla yürümüyor.
MIR interpreter yeni FFI tarafında düzeldi ama tüm PCK yüzeyini kapsayacak seviyede değil.
Sınıf:

IR merkezi eksikliği
Type/layout bütünlüğü
MIR opcode coverage eksikleri
OOP semantic-codegen bağlantısı
3. Runtime / AST Interpreter
Durum: En geniş çalışan dil yüzeyi burada.

Eksikler / riskler:

memory_exec.fbs çok büyük ve tarihsel kalıntı taşıyor.
Eski placeholder yorumları var: “Basit MIR execution, şimdilik placeholder” gibi artık yanıltıcı olabilecek alanlar.
DEF FN not implemented (user functions missing) izi var.
Bazı unsupported call fallback’leri hâlâ doğal olarak var; bunların hangisi gerçek eksik, hangisi beklenen hata ayrılmalı.
FFI policy hâlâ REPORT_ONLY davranışları ve allowlist drift’i taşıyor.
Runtime ile native output parity tam değil; interpreter ve native aynı programda farklı davranabiliyor.
Sınıf:

Runtime temizlik/refactor
User function / DEF FN eksikleri
Interpreter-native parity
FFI policy ve güvenlik modu
4. Native x64 Codegen
Durum: En kritik ve en riskli katman. Artık gerçek exe üretiyor ama tam compiler backend değil.

Eksikler / riskler:

code_generator.fbs çok büyük, tek dosyada çok sorumluluk var.
Açık izler: TODO: unsupported binary op, TODO: expression kind, TODO: emit node kind.
unsupported statement in GenerateStatement hâlâ ana kapsama sınırı.
Assignment operator coverage sınırlı.
String/PRINT codegen kırılganlığı var; uzun string kombinasyonlarında crash gözlemledik.
OOP, collection, file I/O, complex arrays, SELECT, advanced DO/FOR, method dispatch gibi yüzeylerin native coverage’ı tam değil.
x64 helper symbol’lerin bir kısmı minimal runtime stub gibi; gerçek ABI davranışları tam ayrıştırılmalı.
INLINE parser/plan olarak var ama ana x64 emit akışına tam örülü değil.
Sınıf:

Statement coverage
Expression coverage
Runtime helper ABI
String/print stabilitesi
OOP/collection native eksikleri
INLINE native entegrasyonu
Codegen modülerleştirme
5. FFI / DLL / Interop
Durum: Son çalışmayla Windows sistem DLL smoke gerçek çalışıyor. Ama bu sadece başlangıç.

Eksikler / riskler:

x64 CALL(DLL) gerçek resolver aldı, fakat harici DLL’ler için “DLL yoksa skip, varsa çağır” test altyapısı tam standartlaşmadı.
Karma tipli API desteği ilk seviyede: PTR,STRPTR,STRPTR,I32 var ama struct pointer, output pointer, callback, buffer ownership yok.
Win32 GUI’nin gerçek uygulama seviyesi eksik: window class, callback proc, message loop, WndProc, resource handling yok.
MPFR/Arb/Lua/Python/Prolog/curl için BASIC tarafında ergonomik wrapper kütüphaneleri yok; sadece probe/template var.
x86 FFI backend var ama odak x64; x86 policy/resolver kapsamı ayrıca temizlenmeli.
IMPORT ile CALL(DLL) ayrı dünyalar gibi; import edilen C sembolünü BASIC’ten çağırma ergonomisi net değil.
Sınıf:

FFI type marshalling
External DLL skip/probe standardı
GUI callback/message loop
C shim/wrapper kütüphaneleri
IMPORT + CALL birleşik model
x86 legacy/secondary lane
6. Build Pipeline / Toolchain
Durum: Güçlü ama raporlama ve standardizasyon eksik.

Eksikler / riskler:

x64_build_pipeline.fbs hâlâ raporda hardcoded “partial” yazıyor.
Build output standardı dağınık: dist, build, tests/out, release zipleri iç içe.
Toolchain fallback CodeBlocks/MinGW’e bağlı; ortam doğrulama raporu daha net olmalı.
Build başarısı ile exe runtime başarısı ayrıştırılmış bir JSON rapora bağlanmalı.
Exit code davranışı sorunlu: native exe bazen doğru çıktı üretse bile son rax exit code olarak kalıyor.
Sınıf:

Build report standardı
Toolchain detection
Artifact layout
Exit code contract
CI/test automation
7. Test Sistemi
Durum: Çok sayıda test var ama “hangi katman geçti?” standardı eksik.

Eksikler / riskler:

Her .bas için şu matris standart değil: parse, semantic, AST JSON, MIR JSON, AST run, MIR run, x64 asm, obj, exe, exe run.
Harici DLL testlerinde skip/fail ayrımı net değil.
GUI interaktif testleri otomatik testlerden ayrılmalı.
Runtime ve native parity testleri ayrı raporlanmalı.
Kırmızı testlerin nedeni katman bazında ayrılmıyor: parser mı, semantic mi, MIR mi, codegen mi, linker mı, runtime mı?
Sınıf:

Test matrisi
Skip/fail politikası
Parity testleri
GUI/manual test ayrımı
Otomatik raporlama
8. Dokümantasyon / PCK Belgeleri
Durum: En çok karışıklık burada.

Eksikler / riskler:

PCK2 append-only ve çelişkili.
PCK5 “onaylı yüzey” diyor ama bazı maddeler son kod durumuna göre güncellenmeli.
uxbasic_mimari.md FFI bölümünde artık eski sınırlamalar var; karışık tip FFI eklendiği için güncellenmeli.
RESULTS.md güncellendi ama 34-41 harici DLL örnekleri hâlâ eski “no-op/stub” dili taşıyor olabilir.
Komut durumu belgeleri tek kaynak değil; PCK2, PCK4, PCK5, inceleme.md, incelemegpt.md birbirinden ayrılmış.
Sponsor/README için “çalışıyor” iddiası ile “partial” gerçekliği dikkatli dengelenmeli.
Sınıf:

Doküman drift
Kanonik komut matrisi
Kullanıcı dokümanı
Sponsor dokümanı
Teknik mimari dokümanı
9. Repo Hijyeni / Release
Durum: Geliştirme ve üretilmiş artifact’ler karışmış.

Eksikler / riskler:

Root altında exe/zip/rar/pdf/log/tmp dosyaları var.
src5.zip silinmiş görünüyor; bu kullanıcı işi mi otomatik mi ayrılmalı.
build/ untracked çok büyük olabilir.
release/ altında hem belge hem zip hem analiz dosyaları var.
Dağıtım repo’su ile geliştirme repo’su ayrımı net prosedüre bağlanmalı.
Sınıf:

Kaynak vs artifact ayrımı
Release paketleme
Git temizliği
Dağıtım repo politikası
Önerilen Plan
Bence bundan sonraki plan şu sırayla olmalı:

Kanonik eksik matrisi üretelim: Her komut/fonksiyon/operator/veri tipi için satır satır parser, semantic, AST runtime, MIR runtime, x64 codegen, test, doc kolonları olsun.
Katman bazlı kırmızıları çıkaralım: Önce codegen ve MIR’deki unsupported/TODO noktalarını gerçek test dosyalarına bağlayalım.
Native x64 coverage sprint’i yapalım: PRINT/string crash, assignment ops, SELECT/DO/FOR parity, file I/O, arrays, TYPE/CLASS sırasıyla.
FFI v2 sprint’i yapalım: Harici DLL skip/probe standardı, wrapper .bas kütüphaneleri, Win32 GUI callback/message loop planı.
Dokümanları tekleştirelim: PCK5.md kanonik kullanıcı referansı, uxbasic_mimari.md teknik mimari, COMPILER_COVERAGE.md gerçek coverage matrisi olsun.
Test runner standardı kuralım: Her örnek için JSON + AST run + MIR run + x64 build + exe run raporu otomatik çıksın.
Kısa hüküm: Parser ve runtime geniş; FFI Windows smoke artık gerçek çalışıyor; ama “tam compiler” olmanın önündeki ana iş codegen coverage, MIR’i merkez yapmak, doküman drift’ini temizlemek ve test matrisini standardize etmek.
