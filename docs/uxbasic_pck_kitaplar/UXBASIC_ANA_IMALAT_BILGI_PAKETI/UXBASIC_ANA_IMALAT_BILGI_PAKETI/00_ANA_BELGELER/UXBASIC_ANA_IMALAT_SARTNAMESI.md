# UXBasic Ana İmalat Şartnamesi — Adım 50 Master Bilgi Dosyası

Bu dosya, bundan sonra uXBasic compiler/interpreter/transpiler imalatında **ana karar dosyası** olarak kabul edilmelidir. Amaç: daha önce planlanan mimariyi ve 29.05 sonrası yamalarla kurulan bağlantıları kaybetmeden devam etmek.

## 1. Dilin amacı

UXBasic; BASIC benzeri, ancak modern sistem programlama, DLL/API/FFI, OOP, veri yapıları, bilimsel hesaplama, browser/JS/WASM hedefi ve native x64 üretim hattını bir araya getiren bir dildir. Çekirdek komut sayısı gereksiz şişirilmemeli; genişleme `CALL`, `DECLARE`, `INCLUDE`, `IMPORT(C/CPP/ASM)`, `NAMESPACE`, `MODULE`, `USING`, `ALIAS` ve dış C/C++/ASM/DLL katmanlarıyla sağlanmalıdır.

## 2. Kanonik anahtar kelime kararları

| Doğru | Yanlış/iptal | Karar |
|---|---|---|
| `THREAD` | `THREAT` | `THREAT` yazım hatasıdır, alias değildir, kabul edilmemelidir. |
| `PARALEL` | `PARALLEL` | Doğru komut `PARALEL`dir. `PARALLEL` İngilizce alias değildir; yazım hatasıdır. |
| `MAGIC` | `SIHIRLIMETOT` | Sihirli metot yüzeyi `MAGIC`tir; Türkçe eski deneme kaldırılmalıdır. |

Bu karar lexer, parser, AST, MIR, runtime, docs, test ve hata mesajlarına aynı şekilde uygulanmalıdır. Bir katmanda `PARALEL`, başka katmanda `PARALLEL` yazmak sözleşme kırılmasıdır.

## 3. Import / DLL / API kesin ayrımı

| Yüzey | Anlam | Nerede işlenir | Yasak/yanlış yorum |
|---|---|---|---|
| `IMPORT(C,"file.c")` | Derleme zamanında C kaynak dosyası ekleme | build manifest, interop manifest, native build pipeline | DLL/API import değildir |
| `IMPORT(CPP,"file.cpp")` | Derleme zamanında C++ kaynak dosyası ekleme | build manifest | DLL/API import değildir |
| `IMPORT(ASM,"file.asm")` | ASM kaynak ekleme | x64/nasm build pipeline | DLL/API import değildir |
| `DECLARE ... LIB ... ALIAS ...` | Dış sembol bildirimi | parser FFI contract, type binding, FFI registry | Çağrı değildir, sembol bildirir |
| `CALL(DLL,...)` / `CALL(API,...)` | Dış çağrı | runtime FFI, MIR, native backend | Web/JS/WASM hedefte fail-close gerekir |

`IMPORT DLL/API/LIB` aktif dil yüzeyine eklenmemelidir. İleride manifest/preload bildirim sistemi olarak ayrıca değerlendirilebilir, ama mevcut compiler yüzeyine karıştırılmamalıdır.

## 4. Mimari katmanlar

UXBasic yüzeyindeki her komut şu zincirde izlenebilir olmalıdır:

```text
Kaynak .bas
  → Lexer / Preprocessor
  → Parser / AST
  → AST contract / layer binding
  → Semantic / symbol / type / layout
  → HIR/MIR lower
  → MIR verify / optimizer
  → Runtime interpreter
  → Backend: x64, x86, JS, WASM, WAT, browser runtime
  → CLI / reports / diagnostics
```

Hiçbir özellik yalnızca lexer keyword olarak kalmamalıdır. Bir anahtar kelimenin görevi yoksa `unsupported` veya `metadata_only` olarak açık raporlanmalıdır.

## 5. Hedef hatları

| Hat | Amaç | Korunacak karar |
|---|---|---|
| Native x64 | Windows üzerinde NASM/FreeBasic köprüsüyle exe üretimi | Win64 ABI, stack/local layout, FFI contract korunacak |
| x86 | Gelecek/uyumluluk hattı | `UXB_TARGET_X86` sabiti kaldırılmayacak; destek yoksa kontrollü fail |
| JS | Browser hedefi, DOM/Canvas/Audio/Fetch/Storage | Native DLL/API kaçarsa fail-close |
| WASM/WAT | MIR→WASM/WAT hedefi | Host binding manifest zorunlu, eksik binding fail-close |
| Interpreter | AST/MIR sonuçlarını önceden çalıştırma | VSCode/CLI JSON bridge ile canlı rapor üretmeli |

## 6. Veri tipleri ve veri yapıları

Temel tipler: `I8 U8 I16 U16 I32 U32 I64 U64 F32 F64 F80 F128 BIGINT BIGF BIGD BALL BOOLEAN STRING OBJECT PTR ANY VARIANT VOID`.

Veri yapıları: `ARRAY LIST DICT SET`, ayrıca class/interface layout ve string layout. Her veri tipi için type registry, layout, MIR type, interpreter ve backend davranışı uyumlu olmalıdır.

Özel kararlar:

- `SIZEOF`, `OFFSETOF`, `TYPEOF` type binding içinde builtin olarak tanınmalı.
- `BIGINIT(BIGINT,"1.5",0)` gibi decimal string negatif testte fail-close olmalıdır.
- F80/F128 ve big number hatları dış runtime ile desteklenebilir; destek yoksa sessiz başarı verilmemelidir.

## 7. OOP sistemi

OOP yüzeyi geniş ve kaliteli olmalıdır: `CLASS`, `INTERFACE`, `IMPLEMENTS`, `METHOD`, `PROPERTY`, `OPERATOR`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE`, `STATIC`, `MIXIN`, `DECORATOR`, `MAGIC`, `NEW`, `DELETE`, `THIS/ME`.

Eski helper fonksiyonlar yeni scope/symbol resolver sistemini bozacak şekilde geri konmamalıdır. Class field, owner, ancestor çözümü merkezi symbol/scope üzerinden ilerlemelidir.

## 8. Preprocessor ve meta-artifact sistemi

Preprocessor basit metin değişimi değildir; meta üretim, asset, gate ve hedef bağlama motorudur. Şu davranışlar korunmalıdır:

- Macro/alias cycle tespit edilmeli.
- `ASSERT_META` başarısızsa fail-close.
- `RAW_JS` gate olmadan geçmemeli.
- Asset path escape engellenmeli.
- WAT/WASM host import binding eksikse fail-close.
- Preprocessor çıktısı parser’a girmeden önce raporlanabilir olmalı.

## 9. Operatör ve Logic16 sözleşmesi

Operatorler tüm katmanlarda aynı öncelik/sözleşmeyle işlenmelidir: lexer token, parser expression tree, AST node, MIR opcode, runtime evaluator, JS/WASM/x64 emit. BASIC eşitlik ve atama ayrımı korunmalı; mantıksal operatorler `AND OR NOT XOR MOD SHL SHR ROL ROR` olarak tek sözleşmede olmalıdır.

## 10. Hata merkezi

Adım45 hata merkezi altın çizgidir. Dağınık string hata metinleri yerine kodlu, katmanlı, i18n şablonlu hata yapısı kullanılmalıdır. Negatif testlerde beklenen hata üretmek başarı sayılmalıdır; sessiz geçmek hata sayılmalıdır.

## 11. Test kapıları

Her yeni özellik için:

1. Lexer token testi
2. Parser/AST testi
3. AST contract/layer matrix testi
4. Semantic/type/layout testi
5. MIR lower + verify testi
6. Runtime/interpreter testi
7. Hedef backend testi veya kontrollü unsupported testi
8. Negatif fail-close testi

Eski testler tekrar paketlenmeyecek; yeni stage yalnız kendi testlerini ve en az iki birleşik kullanım testini içermelidir.

## 12. Kaybolmaması gereken kurtarılmış görevler

- `UXB_TARGET_WAT`, `UXB_TARGET_X86`
- `UXBFFIContract`, `UXBFFIRegistryMakeContract`, `UXBFFIRegistryResolveCall`
- `UxbFileInputLine`, `UxbFileEnsureParentDirectory`
- `ExecRunPrintFileStmt`
- `ParseWhileStmt`, `ExecRunWhileStmt`, `STMT_HANDLER_WHILE`
- `ExecEvalBuiltinTextCategory`
- `SEM_E_INVALID_SLOT_RANGE`
- `ASTK_PARALEL_STMT`, `UXB_MIR_OPCODE_MIR_PARALEL_HINT`, `STMT_HANDLER_PARALEL`

Bunlar kaldırılırsa kaynak dosyası eksilmese bile özellik/regresyon kaybı oluşur.
