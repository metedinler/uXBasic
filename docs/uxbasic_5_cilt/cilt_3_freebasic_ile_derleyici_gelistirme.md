# Cilt III: FreeBASIC ile uXBasic Derleyici Geliştirme

## Kitabın amacı

Bu cilt uXBasic'i kullanan değil, uXBasic'i geliştiren programcı içindir.
Amaç yeni sözdizimi ekleme yarışı değildir. Var olan dil sözleşmesini:

- tüm derleyici katmanlarında aynı anlamla taşımak;
- desteklenmeyen hedefte açık tanı üretmek;
- gerçek artifact ve çalışma sonucu ile sınamak;
- derleme süresini ve binary boyutunu denetlemek;
- sessiz atlama ve sahte başarıyı ortadan kaldırmak

için izlenecek mühendislik yöntemini anlatır.

## 1. Derlemeye gerçekten giren kaynak

Başlangıç zinciri:

```text
compiler/wrappers/uxb_main_wrapper.bas
    -> src/main.bas
```

Bir düzeltmenin depoda bulunması yetmez. Bu include zincirine girmeyen dosya
derleyici davranışını değiştirmez. Her değişiklikte şu üç soru sorulur:

1. Dosya aktif wrapper/include grafiğinde mi?
2. Aynı işin eski bir kopyası daha önce include ediliyor mu?
3. Test, yeni üretilmiş `bin/uxb.exe` ile mi çalıştı?

## 2. Kaynak ağacı

| Dizin | Sorumluluk |
|---|---|
| `src/common` | ortak tipler, JSON/CSV/yazıcı yardımcıları |
| `src/cli` | seçenek kaydı, fiil yönlendirme, yardım |
| `src/preprocessor` | A/B önişlemci |
| `src/parser/lexer` | karakter, literal, token ve anahtar sözcük |
| `src/parser/parser` | ifade ve deyim parser'ları |
| `src/parser` | AST modeli ve sözleşmesi |
| `src/semantic` | kapsam, sembol, tip, HIR/MIR geçişleri |
| `src/type_binding` | kanonik tip ve builtin dönüş kuralları |
| `src/layout` | x64/JS/WASM yerleşim ve ABI görünümü |
| `src/hir` veya semantic HIR birimleri | yüksek seviyeli IR |
| `src/mir` ve `src/semantic/mir*` | MIR kayıt, lowering, verifier |
| `src/interpreter` | yorumlayıcı katmanları |
| `src/runtime` | bellek, I/O, FFI, görev ve yerel hizmetler |
| `src/codegen/x64` | Win64 NASM üretimi |
| `src/codegen/js` | JavaScript üretimi |
| `src/codegen/browser` | HTML/Canvas/browser paketi |
| `src/codegen/wasm` | WAT/WASM üretimi |
| `src/backend` | ortak backend politika ve yüzey matrisi |
| `src/artifacts` | rapor ve çıktı sözleşmesi |
| `src/build` | ana include paketleri ve build köprüleri |

## 3. Include paketleri

`src/main.bas` yüzlerce dosyayı rastgele eklemek yerine build paketlerini
kullanır. Önemli örnekler:

- `src/build/main_cli_include_bundle.fbs`
- `src/build/main_preprocessor_include_bundle.fbs`
- `src/build/main_frontend_include_bundle.fbs`
- `src/build/main_semantic_include_bundle.fbs`
- `src/build/main_type_binding_include_bundle.fbs`
- `src/build/main_interpreter_include_bundle.fbs`
- `src/build/main_x64_include_bundle.fbs`
- `src/build/main_x64_mir_include_bundle.fbs`
- `src/build/main_web_backend_include_bundle.fbs`

Bir modül yanlış pakete eklenirse iki sorun çıkar: gereksiz hedeflerde binary
büyür veya gereken hedefte sembol bulunmaz. Paket sahipliği kod incelemesinin
parçasıdır.

## 4. FreeBASIC geliştirme kuralları

### 4.1 Include koruması

Her `.fbs` birimi bir kez eklenmelidir:

```freebasic
#ifndef UXB_ORNEK_FBS
#define UXB_ORNEK_FBS

' Gerçek uygulama

#endif
```

Koruma adı benzersiz olmalıdır. Aynı içeriği farklı dosya adlarıyla çoğaltmak
binary ve bakım maliyetini artırır.

### 4.2 Genel durum

Paylaşılan durum yalnız sahip modülde tanımlanır. Diğer modüller açık API
üzerinden erişir. AST, MIR veya runtime global dizilerini yeniden tanımlamak
hem bağlama hatası hem gizli durum ayrışması üretir.

### 4.3 Hata sözleşmesi

FreeBASIC yardımcı işlevleri genel olarak:

```freebasic
Function Islem(..., ByRef errText As String) As Integer
```

biçimini kullanır. Başarı `1`, hata `0` ve dolu `errText` ile dönmelidir.
Hata mesajını yazıp yine başarı döndürmek kabul edilmez.

### 4.4 Kaynak konumu

AST ve MIR düğümleri `sourceFile`, satır, sütun ve mümkünse offset/uzunluk
bilgisini korur. Son backend tanısı özgün uXBasic satırına bağlanabilmelidir.

## 5. Önişlemci A/B mimarisi

Komut ayrıştırma:

- `src/preprocessor/preprocess_parser.fbs`

Yürütme ve seçim:

- `src/preprocessor/preprocess_engine.fbs`

`UXBPreParseIsCanonicalCommand`, geçerli komut adını; doğrulama işlevi
argüman sözleşmesini belirler. `%%PP` için yalnız `A` ve `B` kabul edilir.

### 5.1 A komut grupları

| Grup | Komutlar |
|---|---|
| makro/koşul | `DEFINE`, `MACRO`, `UNDEF`, `IF`, `IFN`, `IFC`, `ELIF`, `ELSE`, `ENDIF` |
| kaynak/meta | `INCLUDE`, `ALIAS`, `SET`, `EVAL`, `PROFILE`, `CONFIG_FILE`, `PATH_ALIAS` |
| denetim | `LOCK_META`, `DUMP_META`, `SOURCE_MAP`, `EMITNOTE`, `ENV`, `DEPRECATED` |
| şablon | `TEMPLATE`, `TEMPLATE_BEGIN`, `TEMPLATE_END`, `TEMPLATE_USE` |
| asset | `MINIFY`, `FINGERPRINT_ASSETS`, `HASHFILE`, `COPY_DIR` |
| gömme | `EMBEDTEXT`, `EMBEDBASE64`, `LICENSEFILE`, `HTMLIMAGE`, `HTMLAUDIO` |
| güvenlik | `ALLOW_RAW_JS`, `ALLOW_RAW_WAT`, `SAFE_PATHS`, `REQUIRE_HOST_BINDING` |
| doğrulama | `ASSERT_META`, `WARN_META`, `ASSET_REQUIRE`, `MANIFEST_REQUIRE` |
| hedef | `TARGET`, `OUTDIR`, `ASSET_ROOT`, `EXPANDLIMIT`, `ASSET_COPY`, `ASSET_FILE`, `ASSET_IMAGE`, `ASSET_AUDIO` |
| web/wasm | `MANIFEST_SET`, `WAT_IMPORT`, `WAT_EXPORT`, `JS_LINE`, `HTML_LINE`, `CSS_LINE`, `JSON_SET` |
| blok | `SECTION`, `ENDSECTION`, `JS_BEGIN/END`, `WAT_BEGIN/END`, `WAT_FUNC_BEGIN/END`, `HTML_BEGIN/END`, `CSS_BEGIN/END`, `JSON_BEGIN/END`, `MD_BEGIN/END` |
| döngü | `FOR`, `FOREACH`, `ENDFOR`, `ENDFOREACH`, `NEXTMETA`, `REPEAT`, `ENDREPEAT`, `UNTILMETA` |

### 5.2 B komutları

Paket bilgisi ve üretim:

`BUNDLE_NAME`, `BUNDLE_VERSION`, `BUNDLE_ID`, `AUTHOR`, `LICENSE`,
`BUILD_ID`, `SANDBOX_ROOT`, `BROWSER_ENTRY`, `SCRIPT_ENTRY`, `STYLE_ENTRY`,
`DATA_JSON`, `CSP`, `SECURITY_NOTE`, `CAPABILITY`, `EXPORT_BASIC`,
`API_ENDPOINT`, `ROUTE`, `REQUIRE_ASSET`, `HOST_IMPORT`, `GEN_FILE`,
`FEATURE`, `TEST_EXPECT`, `DOC`, `GEN_BLOCK`, `GEN_END`.

### 5.3 Önişlemci testi

Pozitif test:

- komutlar çıktıda kalmamalı;
- makro doğru genişlemeli;
- kaynak haritası özgün satırı göstermeli;
- manifestte seçilen A/B hattı görünmeli.

Negatif test:

- bilinmeyen komut;
- `%%PP C`;
- kapanmayan `%%IF`;
- genişleme sınırı;
- güvenli kökün dışına asset yolu;
- raw JS/WAT izni olmadan raw blok.

## 6. Lexer

Ana dosyalar:

- `src/parser/lexer/lexer_core.fbs`
- `lexer_readers.fbs`
- `lexer_numeric_literal_gate.fbs`
- `lexer_keyword_table.fbs`
- `lexer_driver.fbs`

Lexer'ın görevi:

1. EOL, yorum, string ve operatörü ayırmak;
2. sayısal tabanı ve literal biçimini doğrulamak;
3. kelimeyi anahtar sözcük veya `IDENT` yapmak;
4. kaynak konumunu kaybetmemek;
5. token JSON yazıcısına gerçek akışı vermek.

### 6.1 Anahtar sözcük ekleme ölçütü

Yeni sözcük yalnız keyword tablosuna eklenmez. Şu kayıtlar birlikte
hazırlanır:

- token/keyword tanımı;
- parser dispatch veya ifade yolu;
- AST node sözleşmesi;
- semantik/type kuralı;
- HIR/MIR lowering;
- yorumlayıcı;
- hedef backend veya açık hedef tanısı;
- pozitif/negatif testler;
- yardım ve kitap.

Bu zincir yoksa yeni keyword eklemek yerine mevcut `CALL`, modül veya
kütüphane yüzeyi tercih edilir.

## 7. İfade parser'ı

`src/parser/parser/parser_expr.fbs`, katmanlı recursive descent parser'dır.
Ana sıra:

```text
Primary -> Postfix -> Unary -> Power -> Term -> Add -> Shift
-> Relation -> Bitwise -> Logical -> Pipe -> Ternary -> Assignment
```

Sağ birleşimli `**`, ternary ve atama özel olarak korunur. `^` token'ı
`XOR`a kanonikleşir; üs değildir.

Parser operatör kaynağı:

- `parser_adim08_operator_contract.fbs`

Bu dosyadaki öncelik tablosu ile AST/MIR/backend operatör tablosu otomatik
karşılaştırılmalıdır.

## 8. Deyim parser'ı

`parser_stmt_registry.fbs` ve `parser_stmt_dispatch.fbs`, anahtar sözcüğü
işleyiciye yönlendirir.

Başlıca ayrımlar:

| Dosya | Yüzey |
|---|---|
| `parser_stmt_basic.fbs` | PRINT, CALL, INLINE, SHELL, bellek deyimleri |
| `parser_stmt_flow.fbs` | IF, SELECT, döngü, GOTO/GOSUB, TRY, ASSERT |
| `parser_stmt_io.fbs` | OPEN, INPUT, CLOSE, GET, PUT, SEEK, ekran |
| `parser_stmt_decl_dim_redim.fbs` | DIM, REDIM, CONST |
| `parser_stmt_decl_proc.fbs` | DECLARE, SUB, FUNCTION |
| `parser_stmt_decl_core.fbs` | TYPE, ENUM, CLASS, INTERFACE, INCLUDE, IMPORT |
| `parser_stmt_decl_class_method.fbs` | METHOD, MAGIC, override |
| `parser_stmt_decl_scope.fbs` | MAIN, NAMESPACE, MODULE, USING, ALIAS |
| `parser_stmt_event_pipe.fbs` | EVENT, THREAD, PARALEL, PIPE, SLOT, ON/OFF/TRIGGER |

## 9. AST veri modeli

AST düğümünün temel alanları:

- `kind`
- `value`
- `op`
- `typeName`
- `symbolName`
- `role`
- `flags`
- `left`, `right`
- `firstChild`, `nextSibling`
- kaynak konumu

Çocuk rolü önemlidir. Örneğin FFI çağrısında çocuklar:

1. `LIBRARY`
2. `SYMBOL`
3. `SIGNATURE`
4. ve sonrası `ARG`

olarak işaretlenir. Sıra veya rol kaybolursa MIR lowering yanlış ABI operandı
üretir.

### 9.1 AST sözleşmesi

`ast_contract_registry.fbs`, `ast_contract_validate.fbs` ve child model
dosyaları node türünün zorunlu alan/çocuk düzenini denetler. Yeni node:

- registry'ye;
- child role modeline;
- JSON exporter'a;
- semantik route tablosuna

eklenmelidir.

## 10. Hata kurtarma

Parser tek hatadan sonra sonraki deyime ilerleyebilir, ancak:

- aynı token'da sonsuz döngüye girmemeli;
- asıl ilk hatayı kaybetmemeli;
- `END <blok>` sınırını yanlış tüketmemeli;
- pozitif kaynağı kurtarma bahanesiyle eksik AST'ye çevirmemelidir.

Kurtarma testi, hatalı kaynakta süre sınırı ve en az bir anlamlı tanı
denetler.

## 11. Semantik analiz

Semantik katmanın görevleri:

- kapsam ağacı;
- sembol bildirim ve kullanım çözümü;
- yordam imzası;
- dönüş yolu;
- tip uyumu ve açık dönüşüm;
- sınıf hiyerarşisi;
- slot/trigger hedefi;
- FFI ve hedef politikası;
- HIR/MIR için bağlanmış bilgi.

Bir özellik parser'da kabul edilip semantikte `OBJECT`a düşüyorsa bu, tip
sözleşmesi eksikliğidir.

## 12. Tip bağlama

Kanonik tipler `src/type_binding/type_rules.fbs` içindedir. Önemli işlemler:

- adın `TYPE_I32` benzeri iç tipe çevrilmesi;
- numeric/integer/float/pointer sınıfı;
- byte boyutu ve hizalama;
- ikili operatörde ortak tip;
- örtük veya açık dönüşüm gereği.

Dar atama:

```text
I32 -> U8
```

açık dönüşüm ister. `OBJECT -> I32` ancak dilin gerçek dinamik dönüşüm
sözleşmesi varsa yapılmalıdır; yalnız fonksiyon adı görünmediği için otomatik
sayısal varsayım yapılmaz.

### 12.1 Builtin registry

`type_builtin_registry.fbs`, ad, dönüş tipi, argüman politikası ve hedef
politikasını kaydeder.

Runtime tarafından yürütülen her builtin için bu tabloda veya aynı yetkide
başka tekil kayıt kaynağında dönüş kuralı olmalıdır. Çekirdek
`LISTLEN/DICTLEN/SETLEN` sayısal; `LISTGET/DICTGET` dinamik dönüşlüdür. Bu
kurallar eksik olduğunda statik değişkene atama yanlış `OBJECT` tanısı üretir.

## 13. Layout ve ABI

Layout katmanı:

- tip boyutu;
- alignment;
- alan offset'i;
- nested `TYPE`;
- dizi alanı;
- sınıf pointer gösterimi;
- JS/WASM temsil eşlemesi

üretir.

Win64 temel kuralı:

- pointer 8 byte;
- ilk integer/pointer argümanları RCX, RDX, R8, R9;
- kayan nokta argümanları XMM kayıtları;
- 32 byte shadow space;
- çağrı anında 16 byte stack hizası;
- RBX, RBP, RSI, RDI, R12-R15 korunur.

Her FFI ve INLINE örneği layout/ABI raporuyla bağlanmalıdır.

## 14. HIR

HIR kaynak yapısını daha düzenli semantik birimlere taşır. HIR üretiminde:

- bildirim ve gövde ayrımı;
- açık tipler;
- kapsamlı sembol adları;
- kontrol akışının yapılandırılmış biçimi

korunur. HIR JSON boş bir envanter değil gerçek yordam ve düğüm listesi
olmalıdır.

## 15. MIR

MIR, yorumlayıcı ve backend'ler arasında kanonik yürütme sözleşmesidir.
Temel opcode aileleri:

| Aile | Örnek |
|---|---|
| yükle/sakla | `LOAD_CONST`, `LOAD_VAR`, `STORE_VAR` |
| aritmetik | `ADD`, `SUB`, `MUL`, `DIV`, `IDIV`, `MOD`, `POW` |
| mantık | `AND`, `OR`, `XOR`, `NAND`, `NOR`, `XNOR` |
| karşılaştırma | `EQ`, `NE`, `LT`, `LE`, `GT`, `GE` |
| kontrol | `LABEL`, `JMP`, `JZ`, `JNZ`, `SELECT` |
| çağrı | `CALL`, `CALL_RUNTIME`, `CALL_DLL`, `CALL_API` |
| dönüş | `RET`, `RETURN` |
| veri | `DIM`, `REDIM`, `NEW`, alan ve indeks işlemleri |
| hizmet | `PRINT`, `INPUT`, görev ve dosya runtime çağrıları |

### 15.1 Operand sınırı ve ABI10

MIR çağrı imzası en çok 16 operand yuvası taşır. `CALL_DLL/CALL_API` için
zorunlu metadata operandları ayrıldıktan sonra kullanıcı ABI sözleşmesi en çok
10 çağrı argümanı sunar. Fazlası sessiz kesilmez.

### 15.2 MIR verifier

Verifier en az şunları denetler:

- opcode kayıtlı mı;
- operand sayısı ve rolü doğru mu;
- sonuç gerekliliği;
- branch hedef etiketi var mı;
- çağrı hedefi boş mu;
- tip ailesi opcode ile uyumlu mu;
- temel blok sonlandırması;
- ulaşılamayan veya döngü oluşturan bozuk dispatch.

## 16. AST yorumlayıcı

AST yorumlayıcı kaynak düğümlerini doğrudan yürütür. İyi kullanım alanı:

- dil semantiğini hızlı sınama;
- parser/semantik hatasını backend'den ayırma;
- dosya, koleksiyon, sınıf ve görev runtime'ını gözleme.

AST yorumlayıcıda desteklenmeyen hedefe özgü çağrı açık hata vermelidir.
Örneğin `SCREEN` Canvas hizmeti AST konsol runtime'ında sıradan işlev gibi
sessizce atlanmamalıdır.

## 17. MIR yorumlayıcı

MIR yorumlayıcı, lowering ve opcode anlamını sınar. AST ile aynı programda:

- aynı çıktı;
- aynı dönüş değeri;
- aynı dosya içeriği;
- aynı hata sınıfı

beklenir. MIR fiili seçilip gerçekte AST yorumlayıcı çalıştırılması katman
kanıtı değildir; run report backend adını kaydetmelidir.

## 18. Runtime

Runtime başlıca:

- `ExecState` ve değer modeli;
- sanal/gerçek bellek;
- string;
- dosya kanalları;
- koleksiyon motoru;
- FFI;
- sınıf/yordam dispatch;
- task/slot;
- shell;
- console

hizmetlerinden oluşur.

Kaynak sahipliği `src/runtime/memory_exec.fbs` ve `src/runtime/exec/*.fbs`
arasında bölünmüştür. Yeni hizmet için dev bir `Select Case`e yalnız ad
eklemek yerine, argüman doğrulama ve değer dönüşümü ilgili kategori
modülünde uygulanır.

## 19. Sınıf ve MAGIC dispatch geliştirme

Doğal metot çağrısı için çözüm sırası:

1. receiver tipini bul;
2. sınıfta normal metodu ara;
3. temel sınıf hiyerarşisini ara;
4. normal ad yoksa `MAGIC_<AD>` fallback'ini ara;
5. override/dinamik sınıfı uygula;
6. argüman ve dönüş tipini doğrula;
7. AST ve MIR'de aynı routine adına indir.

Bu sıranın bir katmanda değişmesi, “object is not callable” veya yanlış
`MAGIC_CALL` hatası üretir. Testler:

- normal metot;
- aynı doğal ada sahip MAGIC;
- normal ve MAGIC birlikte, normal öncelikli;
- kalıtılmış MAGIC;
- bilinmeyen MAGIC;
- receiver `NULL`;
- AST/MIR/x64 eşdeğerliği

içermelidir.

## 20. Dosya I/O geliştirme

Dosya kanalı durumu:

- kanal açık mı;
- mod doğru mu;
- dosya konumu;
- satır/alan ayrıştırma;
- hedef tip;
- EOF;
- kapatma

bilgilerini taşır.

`INPUT #` bir çağrıda verilen her hedef için sıradaki alanı tüketmelidir.
Ardışık çağrılar sıradaki kayıttan devam etmelidir. Sayısal okuma çalışırken
string hedefin `0`a dönüşmesi kabul edilemez. Pozitif test, okunan değeri
yalnız yazdırmamalı; `ASSERT` ile tam string eşitliğini denetlemelidir.

## 21. x64 backend

Kaynak yollar:

- `src/codegen/x64/code_generator.fbs`
- `src/codegen/x64/mir_x64_codegen.fbs`
- `src/codegen/x64/mir_x64_*`
- `src/build/main_x64_mir_include_bundle.fbs`

MIR tabanlı x64 akışı:

```text
uXBasic -> AST -> semantic -> MIR -> verify -> NASM -> object -> link -> EXE
```

### 21.1 Native test düzeyleri

1. ASM üretildi mi?
2. Beklenen sembol/çağrı ASM'de var mı?
3. NASM object üretti mi?
4. Linker EXE üretti mi?
5. EXE beklenen çıkış ve yan etkiyi verdi mi?
6. Aynı program AST/MIR sonucu ile eş mi?

Yalnız 1. düzey native çalışma kanıtı değildir.

### 21.2 Register ve stack

Her çağrı emitter'ı:

- argüman sınıflandırması;
- shadow space;
- stack taşan argümanlar;
- hizalama;
- caller/callee-saved kayıtlar;
- dönüş tipi;
- hata yolunda stack geri alma

kurallarını tek ABI yardımcısından almalıdır.

## 22. JavaScript backend

JS backend'in görevleri:

- sayısal ve string ifade üretimi;
- kontrol akışı;
- yordamlar;
- runtime service bağları;
- kaynak haritası;
- browser veya Node hedef farkı.

Üretilen `.js` dosyasının boyutlu olması yeterli değildir. Node/browser
harness işlevi çağırmalı ve sonucu denetlemelidir.

## 23. Browser backend

`SCREEN`, `CLS`, `FILLRECT`, `TEXT` gibi hizmetler DOM/Canvas runtime'ına
iner. Test:

- canvas genişlik/yüksekliği;
- beklenen `fillRect/fillText` çağrıları;
- üretilen HTML'nin JS runtime'ı yüklemesi;
- manifest yolları;
- gerçek browser'da görünür canvas

kanıtlarını toplar.

Browser-only çağrı AST konsol yorumlayıcısında desteklenmiyorsa bu doğal hedef
sınırıdır; kitap ve test matrisi bunu açıkça gösterir.

## 24. WAT/WASM backend

WAT emitter:

- fonksiyon parametre ve sonuç tipleri;
- local kayıtları;
- kontrol akışı dispatch'i;
- imports;
- exports;
- runtime çağrıları

üretir.

WASM testi yalnız `wat2wasm` çıkışına bakmaz:

```javascript
const { instance } = await WebAssembly.instantiate(bytes, imports);
const actual = instance.exports.TESLIMSKOR(18, 4, 2);
if (actual !== 154) throw new Error("yanlis sonuc");
```

String, pointer veya dış host özelliği henüz desteklenmiyorsa backend açık
fail-close tanısı verir. Sahte handle üretmek yasaktır.

## 25. CLI mimarisi

Başlıca dosyalar:

- `src/cli/cli_registry_adim41.fbs`
- `cli_args.fbs`
- `cli_verb_dispatch.fbs`
- `cli_help.fbs`
- `cli_route_matrix.fbs`

Bir seçenek için dört bağ gerekir:

1. registry ve argüman türü;
2. CLI parse/state alanı;
3. pipeline tüketicisi;
4. artifact writer ve hata aktarımı.

Yardımda görünmek veya state'e yazılmak artifact üretimi değildir.

## 26. JSON ve log artifact sözleşmesi

Her JSON writer:

- geçerli UTF-8 JSON;
- schema/sürüm;
- run id;
- kaynak yolu;
- seçilen katman/backend;
- durum ve tanılar;
- gerçek veri dizileri;
- artifact ilişkilendirmesi

üretmelidir.

Boş `{}` veya yalnız `"status":"pass"` gerçek rapor değildir. Test:

```powershell
$json = Get-Content $path -Raw | ConvertFrom-Json
if ($null -eq $json) { throw "JSON okunamadi" }
if ((Get-Item $path).Length -lt 32) { throw "JSON anlamsiz derecede kucuk" }
```

## 27. Yeni özellik geliştirme akışı

Örnek özellik adı `FOO` olsun.

### Adım 1: Sözleşme

- kesin sözdizimi;
- örnek pozitif ve negatif program;
- tip ve yan etki;
- hedef matrisi;
- hata kodları.

### Adım 2: Frontend

- lexer gerekiyorsa keyword;
- parser;
- AST kind/role;
- AST contract;
- JSON görünümü.

### Adım 3: Semantik

- sembol/kapsam;
- tip;
- hedef kısıtı;
- dönüşüm;
- negatif tanı.

### Adım 4: IR

- HIR karşılığı;
- MIR opcode veya runtime call;
- operand imzası;
- verifier.

### Adım 5: Yürütme ve backend

- AST yorumlayıcı;
- MIR yorumlayıcı;
- x64;
- JS/browser;
- WAT/WASM;
- desteklenmeyen hedef tanısı.

### Adım 6: Araçlar

- CLI;
- JSON/log;
- source map;
- dokümantasyon.

### Adım 7: Test

- birim;
- pozitif;
- negatif;
- parity;
- artifact;
- gerçek süreç/EXE/JS/WASM.

Bu adımların birini bilerek atlamak, özellik durumunu “kısmi” olarak
işaretlemeyi gerektirir.

## 28. Sessiz hata avı

Özel olarak aranacak belirtiler:

- desteklenmeyen case'de `Return 1`;
- sonuç değişkenine dokunmadan başarı;
- bilinmeyen opcode'u atlama;
- `Else` dalında boş dönüş;
- sabit `0`, boş string veya boş JSON ile başarı;
- hedef dışı özelliği yorum satırına çevirme;
- eksik DLL'de devam etme;
- testin yalnız marker basması;
- beklenen dosyayı oluşturmadan exit 0;
- timeout olmadan döngü testi.

Kaynak taraması davranış testinin yerine geçmez; yalnız riskli noktayı bulur.

## 29. Boş kanca politikası

Aktif include zincirindeki
`compiler/hooks/uxb_global_noop_hook.fbs` davranış üretmeyen bir kanca
barındırır. Böyle bir kanca:

- derleyici özelliği kanıtı sayılmaz;
- tracing açıkmış gibi belgelenmez;
- aktif çağrı maliyeti oluşturuyorsa kaldırılır;
- ihtiyaç varsa gerçek event kaydı, run id ve sink ile uygulanır.

İsmi veya yorumu “gelecekte” demek aktif üretim kodundaki davranış
eksikliğini çözmez.

## 30. Test mimarisi

### 30.1 Kaynak testleri

`.bas/.uxb/.uxm` dosyasını gerçek `uxb.exe` ile çalıştırır. Pozitif test
beklenen sonucu; negatif test beklenen tanıyı taşır.

### 30.2 FreeBASIC birim testleri

Parser, semantic, MIR veya codegen işlevini doğrudan include eder. Hızlıdır,
ancak dağıtım EXE'sinin CLI entegrasyonunu kanıtlamaz.

### 30.3 Xtestx

`xtestx` uçtan uca ve proje paketi testlerini barındırır. Runner:

- kaynak listesini;
- beklenen backend'leri;
- timeout'u;
- exit code'u;
- stdout/stderr'i;
- artifact hash/boyutunu

raporlamalıdır.

### 30.4 Negatif test

Negatif testin geçmesi için:

- sıfır olmayan exit code;
- beklenen hata sınıfı/kodu;
- doğru kaynak konumu;
- istenmeyen artifact'in oluşmaması

birlikte doğrulanır.

## 31. Derleme süresi mühendisliği

Uzun derlemenin olası nedenleri:

- aynı büyük `.fbs` dosyasının farklı yollardan yinelenmesi;
- derleyiciye gereksiz runtime kaynaklarının gömülmesi;
- dev tabloların her translation unit'te çoğalması;
- debug/PDB üretimi;
- release ve x86/x64 hedeflerin birlikte derlenmesi;
- build ağacında gereksiz recursive tarama;
- link-time optimizasyon;
- antivirus taraması;
- değişmeyen DLL'lerin her seferinde yeniden üretimi.

Ölçüm:

```powershell
Measure-Command { .\build_64.bat }
Get-Item .\bin\uxb.exe | Select-Object Length,LastWriteTime
```

Her ana build aşaması ayrı süre ve çıktı boyutu raporlamalıdır.

## 32. EXE boyutu mühendisliği

Boyut artışını sınıflandır:

1. `.text`: kod çoğalması;
2. `.rdata`: string, keyword, tablo ve gömülü içerik;
3. debug/PDB;
4. statik runtime;
5. import ve kaynak paketleri.

Karşılaştırma:

- release/debug;
- include manifest;
- linker map;
- bölüm boyutları;
- sembol tekrarı;
- gömülü test/veri olup olmadığı.

PDB dosyasını Git işleminden dışlamak binary büyümesini çözmez; yalnız depo
taşımasını düzeltir.

## 33. Git ve büyük artifact politikası

`diff` veya rapor dizinindeki 100 MB üzeri `.pdb` ve build artifact'leri
kaynak değişikliği değildir. `.gitignore` ve artifact saklama politikası:

- `*.pdb`, `*.obj`, geçici ASM/EXE;
- zaman damgalı test raporlarının seçilmiş özetleri;
- tekrar üretilebilir büyük paketler

için belirlenir. Kullanıcının mevcut artifact'i izinsiz silinmez.

## 34. Kitap örneklerinin açtığı düzeltme kapıları

İlk kitap doğrulaması şu alanları ortaya çıkarmıştır:

| Alan | Gözlenen belirti | Olması gereken |
|---|---|---|
| koleksiyon tip bağlama | `LISTLEN` sonucu `OBJECT` görülebiliyor | uzunluk `I32`, get dinamik |
| MAGIC çağrı | doğal `obj.HASH()` metodu bulunamayabiliyor | normal sonra `MAGIC_HASH` fallback |
| sınıf+yordam kaydı | bazı küçük birleşimlerde sınıf adı callable sanılıyor | kapsamlı routine tablosu |
| dosya string input | sonraki string alan `0` olabiliyor | gerçek string değeri |
| semantic JSON | seçenek exit 0, dosya yok | writer veya açık hata |
| FFI allowlist | report-only deny sonrası çağrı sürüyor | mod açık ve raporda görünür |
| WAT string | fail-close çalışıyor | linear-memory tamamlanana kadar açık tanı |
| Canvas AST | unsupported tanısı | browser hedefinde çalışma, AST'de açık sınır |

Bu tablo geçici bir bahane listesi değil, kaynak düzeltme sırasıdır.

## 35. Derleyici geliştiricisi kontrol listesi

- Değişiklik aktif include grafiğine girdi mi?
- Aynı sözleşmenin tek kayıt kaynağı var mı?
- Parser AST rolünü eksiksiz üretti mi?
- Semantik statik tipi doğru bağladı mı?
- MIR verifier gerçek operandları doğruladı mı?
- AST ve MIR yürütmesi eş mi?
- x64 ASM uXBasic tarafından üretildi mi ve EXE çalıştı mı?
- JS/WASM artifact'i gerçek motor tarafından çağrıldı mı?
- Desteklenmeyen hedef açık tanı verdi mi?
- JSON/log dosyası gerçekten oluştu ve ayrıştırıldı mı?
- Negatif test yanlış nedenle geçmedi mi?
- Derleme süresi ve binary boyutu ölçüldü mü?

