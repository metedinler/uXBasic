# uXBasic VS Code, Lexer/Parser, QuickJS ve WASM kaynak analizi

## 1. Dil yüzeyinin gerçek kaynakları

VS Code grammar'ının elle tutulması doğru değildir. Kaynakta yedi kanonik kayıt vardır:

1. `src/parser/lexer/lexer_keyword_table.fbs`: lexer keyword yüzeyi.
2. `src/parser/parser/parser_stmt_registry.fbs`: statement → handler → parser yönlendirmesi.
3. `src/parser/parser/parser_adim08_operator_contract.fbs`: sembolik ve kelime operatörleri.
4. `src/parser/parser/parser_shared.fbs`: parser'ın kabul ettiği built-in tip adları.
5. `src/runtime/memory_exec.fbs`: runtime tarafından gerçekten dispatch edilen built-in fonksiyonlar.
6. `src/preprocessor/preprocess_parser.fbs`: `%%` yönergeleri ve gömülü JS/WAT/HTML/CSS/JSON/MD blokları.
7. `src/cli/cli_registry_adim41.fbs`: CLI seçenekleri, çıktı türleri ve doğrulama bilgileri.

Son kaynak taramasında:

```text
keyword             227
statement            81
built-in function    89
built-in type        35
operator             82
preprocessor        125
CLI option          171
```

bulundu. Eklenti bu kaynaklardan `generated/language-surface.json`, TextMate grammar, completion, hover ve semantic token verisini üretir. Böylece compiler'a yeni bir komut veya fonksiyon eklendiğinde IDE listesi elle düzenlenmez.

Built-in fonksiyonlar gerçek runtime dispatch kayıtlarına göre FFI, layout, conversion, math, string, time, file, keyboard, memory, pointer, collection ve big-number gruplarına ayrılır.

## 2. Lexer ve parser tanı hattı

Lexer kendi `LexerDiagnosticList` listesini, parser ise `ParseState.parseErrors` dizisini kullanır. Ortak `UXBDiagnosticList` ve `UXBDiagnosticListToVSCodeJson` desteği kaynakta mevcuttur. İncelemede üç bağlantı eksikliği bulundu:

- Lexer hata bulduğunda program, çıktı sözleşmesi yazılmadan sona erebiliyordu.
- `allDiagnosticsJsonOutPath` ve `vscodeDiagnosticsJsonOutPath` alanları tanımlıydı fakat ortak liste bu dosyalara bağlanmamıştı.
- Parser/semantic ve bazı gate hata yolları yalnız metin yazıyor, Problems paneline uygun konumlu kayıt üretmiyordu.

Yama `UXBOutputContractWriteDiagnosticList` ile ortak listeyi hem normal JSON hem VS Code range JSON biçiminde yazar. Source load, preprocessor, lexer, numeric lexer gate, parser surface gate, parser, semantic ve native-only gate hataları ortak listeye eklenir. Parser mesajlarındaki `[satır:sütun]` biçimi source location'a çevrilir.

Eklenti her kontrolden önce eski tanı dosyalarını siler, yeni JSON'ları okur ve farklı kaynak dosyalara ait tanıları doğru URI üzerinde gösterir.

## 3. Parser mimarisi ve IDE özellikleri

Parser merkezi registry ile statement dispatch yapar. Bu nedenle eklenti registry'den:

- statement completion,
- handler/parser hover bilgisi,
- document symbol ve outline,
- blok folding,
- kaynak yüzeyi denetimi

üretir.

FUNCTION, SUB, EVENT, PIPE, THREAD, PARALEL, METHOD, PROPERTY, TYPE, STRUCT, UNION, CLASS, INTERFACE, ENUM, NAMESPACE, MODULE ve MAIN tanımları sembol olarak gösterilir. Çok satırlı declaration'lar kütüphane indeksinde birleştirilir. `INCLUDE` ve `IMPORT` hedefleri document link olarak açılır. Fonksiyon ve rutin çağrıları için signature help sağlanır.

## 4. QuickJS desteğinin gerçek kapsamı

QuickJS yolu yalnız bir `.js` dosyası üretmekten ibaret değildir. Kaynakta:

- `src/codegen/js/*`: MIR/AST bağlantıları, opcode coverage, strict/fail-closed denetimi ve browser bootstrap,
- `runtime/js/common/ux_runtime_core.js`: ortak runtime,
- `runtime/js/quickjs/ux_runtime_quickjs.js`: QuickJS provider,
- `runtime_ext/uxjsruntime/uxjsrt.c/.h`: runtime/context, memory/stack/time limitleri, bootstrap, eval, JSON çağrı, Promise/job yürütme,
- `runtime_ext/uxjsruntime/build_uxjsrt.bat`: DLL build,
- `bin/uxjsrt.dll`: çalışma DLL'i

bulunur.

Eklenti compiler'ı `--emit-js`, `--js-out`, `--js-runtime-out` ve backend report seçenekleriyle çalıştırır. `tools/run_quickjs.py`, DLL export sözleşmesine göre runtime ve context oluşturur, limitleri uygular, core/provider bootstrap eder, programı değerlendirir ve `globalThis.uxbMain` girişini JSON argümanlarıyla çağırır. Promise sonucu varsa job kuyruğunu tamamlar.

## 5. WAT/WASM desteğinin gerçek kapsamı

WASM yolu `src/codegen/wasm` altında type, instruction, module, function, import/export, manifest, fail-closed ve opcode-coverage katmanlarına ayrılmıştır. Kaynakta ayrıca:

- `tools/wabt/bin/wat2wasm.exe`,
- `tools/wabt/bin/wasm-validate.exe`,
- `tools/wabt/bin/wasm-interp.exe`,
- `runtime_ext/uxwasmrt/uxwasmrt.c/.h`,
- `runtime_ext/uxwasmrt/build_uxwasmrt.bat`,
- `bin/uxwasmrt.dll`

bulunur.

Eklenti WAT üretir, WABT ile `.wasm` ikilisine çevirir, `wasm-validate` ile doğrular ve `tools/run_wasm.py` üzerinden `uxwasmrt.dll` kullanır. Host; dosya doğrulama, modül açma, export varlığı ve sıfır ile dört i32 argümanlı export çağrısı yapar.

## 6. Browser/hybrid hedefi

`runtime/browser` yalnız HTML kabuğu değildir. Canvas, audio, input, file, WebGPU, WASM bridge, OOP handle, localhost, AI, serial/Bluetooth ve MIR executor modülleri içerir. Compiler hibrit yolunda JS, runtime JS, WAT, WASM, HTML, manifest ve backend report aynı hedef klasörüne üretilebilir.

Workbench bu artefaktları tek `browser` klasöründe toplar ve iki çalışma yolu sunar:

- doğrudan HTML dosyasını açma,
- WASM fetch için Python `http.server` başlatma.

## 7. Eklenti mimarisi

- `uxbProfiles.js`: adlandırılabilir toolchain ve komut profilleri.
- `uxbWorkbench.js`: AST/MIR/native/QuickJS/WASM/browser süreçleri.
- `uxbLanguageFeatures.js`: diagnostics, completion, hover, signature, links, symbols, folding, semantic tokens.
- `uxbLibraryIndex.js`: wrapper/runtime sembol indeksi ve cache.
- `uxbProjectTree.js`: dil, hedef, build ve output ağacı.
- `tools/sync_language_surface.py`: compiler kaynaklarından grammar ve metadata üretimi.
- `tools/run_quickjs.py`: `uxjsrt.dll` host'u.
- `tools/run_wasm.py`: `uxwasmrt.dll` host'u.

## 8. Tamamlanan ana eksikler

- Eski wrapper EXE yerine `bin/uxb.exe` varsayılanı.
- Tek kayıt noktasında 29 komut.
- Kaynakla senkron keyword/statement/type/function/operator/preprocessor/CLI yüzeyi.
- AST/MIR ayrı çalışma ve diff.
- Katman JSON sekmeleri.
- Gerçek QuickJS ve WASM runtime yolları.
- Çoklu toolchain profili ve doctor.
- Lexer/parser/semantic hata durumlarında konumlu diagnostic JSON.
- Çok satırlı library index, signature help ve include/import navigation.

## 9. Bilinen sınır

Bu yama interpreter çalıştırma ve çıktı karşılaştırması sunar; satır satır breakpoint, step-in/step-over ve değişken izleme sağlayan ayrı bir VS Code Debug Adapter Protocol sunucusu değildir. Bunun için AST/MIR interpreter'ların durdurulabilir bir debug protokolü ve durum snapshot sözleşmesi ayrıca tanımlanmalıdır.
