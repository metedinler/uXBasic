# uXBasic Kod Gerçekliği — Mimari ve Dil Yüzeyi Tabloları

Kaynak: son yüklenen `uxb(10.06_1).zip` içindeki `src` klasörü ve birlikte gelen build/test çıktısı. Not: daha sonra verilen yama zipleri bu rapora ayrıca uygulanmadıysa bu tablo son yüklenen zipin gerçekliğini gösterir.

## Sayısal özet

- CLI option registry: 171 seçenek
- CLI verb: 20 kısa komut
- Lexer keyword: 221 yüzey anahtar sözcüğü
- Preprocessor komutu: 125 komut
- AST node sabiti: 142 node
- MIR opcode sabiti: 258 opcode
- Type kind: 37 tip sabiti
- Builtin type rule/fonksiyon: 45 kayıt
- Runtime service id: 83 servis

## Mimari yapı


| katman                      | ana_dosyalar                                            | gorev                                                                                                                  |
|-----------------------------|---------------------------------------------------------|------------------------------------------------------------------------------------------------------------------------|
| Girdi/CLI                   | src/cli, src/main\*.fbs                                 | 3 harfli verb ve uzun optionları route eder; response file @file.uxcli desteği; out-root/run-id politikasını kurar |
| Preprocessor A/B            | src/preprocessor, src/parser/lexer/lexer_preprocess.fbs | Makro, conditional, include, web manifest, raw JS/WAT/HTML/CSS blokları; PP seçimi --pp/--preprocessor               |
| Lexer                       | src/parser/lexer\*, token_kinds.fbs                     | Token üretir: KEYWORD/IDENT/NUMBER/STRING/OP/COMMENT; keyword ve operator yüzeyi burada                              |
| Parser/AST                  | src/parser/parser\*, ast\*.fbs                          | Komutları AST node’larına indirir; OOP, EVENT/PIPE/THREAD/PARALEL, SLOT/TRIGGER, SHELL vb. burada                  |
| Semantic/type/symbol/layout | src/semantic, src/type_binding, src/symbols, src/layout | Type binding, symbol table, layout, HIR/MIR köprüleri, fail-closed doğrulamalar                                     |
| MIR                         | src/mir, src/semantic/mir_\*                            | Kanonik ara temsil; opcode, operand, verify ve JSON exporter katmanı                                                  |
| Interpreter                 | src/interpreter/ast, src/interpreter/mir                | AST/MIR bellek yürütme; output, trace, runtime call ve task/slot dispatch                                            |
| Runtime service             | src/runtime, src/runtime/services                       | Console/string/math/file/memory/FFI/library/web servis aileleri ve dispatch registry                                   |
| Native runtime DLL          | src/runtime/native, native/uxb_runtime                  | uxb_runtime.dll C ABI loader/bridge; std/Windows, libuv, oneTBB backend hazırlığı                                  |
| Backends                    | src/codegen/x64, js, wasm, browser; src/backend         | x64 NASM, JS, WAT/WASM, browser artifact ve backend rapor/gate sistemi                                                 |
| Build/artifact output       | src/build, src/runtime/project_output_policy.fbs        | build/<run-id>/json/logs/execution düzeni; merkezi çıktı kökü                                              |
| Test/runner araçları      | tools/tests, run_\*.bat, build/all_tests                | Yama testleri, output audit, source discovery, runtime backend testleri                                                |


## CLI verbleri


| verb | gorev                       | ornek                         |
|------|-----------------------------|-------------------------------|
| lex  | Lexer/token çıktısı     | uxb lex program.uxb [options] |
| par  | Parser-only                 | uxb par program.uxb [options] |
| ast  | AST sözleşme/JSON         | uxb ast program.uxb [options] |
| sem  | Semantic/type/symbol/layout | uxb sem program.uxb [options] |
| hir  | HIR üretimi                | uxb hir program.uxb [options] |
| mir  | MIR üretim/doğrulama      | uxb mir program.uxb [options] |
| int  | MIR interpreter run         | uxb int program.uxb [options] |
| x64  | x64 NASM üretim            | uxb x64 program.uxb [options] |
| x86  | x86 hedef izi               | uxb x86 program.uxb [options] |
| jsw  | JS/web backend              | uxb jsw program.uxb [options] |
| wat  | WAT/WASM metin üretimi     | uxb wat program.uxb [options] |
| bld  | x64 build pipeline          | uxb bld program.uxb [options] |
| run  | execmem çalıştırma      | uxb run program.uxb [options] |
| chk  | toplu doğrulama            | uxb chk program.uxb [options] |
| fmt  | format check                | uxb fmt program.uxb [options] |
| map  | source map                  | uxb map program.uxb [options] |
| doc  | dokümantasyon çıktısı  | uxb doc program.uxb [options] |
| rel  | release gate                | uxb rel program.uxb [options] |
| hlp  | help                        | uxb hlp program.uxb [options] |
| ver  | version                     | uxb ver program.uxb [options] |


## CLI anahtarları — ilk 60 kayıt


| no | anahtar                         | kisa | katman                  | deger | cikti_dosyasi | uzanti                |
|----|---------------------------------|------|-------------------------|-------|---------------|-----------------------|
| 0  | --format-check                  | fmt  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 1  | --help                          | hlp  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 2  | --version                       | ver  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 3  | --target                        | tgt  | CLI / Genel             | evet  | hayir         | yok / parametre       |
| 4  | --stop-after                    | stp  | CLI / Genel             | evet  | hayir         | yok / parametre       |
| 5  | --json-out                      | jsn  | Web / JS / WASM         | evet  | evet          | .json                 |
| 6  | --diag-format                   | dgf  | CLI / Genel             | evet  | hayir         | yok / parametre       |
| 7  | --error-limit                   | erl  | CLI / Genel             | evet  | hayir         | yok / parametre       |
| 8  | --emit-nasm                     | ens  | Native backend          | hayir | hayir         | yok / parametre       |
| 9  | --emit-js                       | ejs  | Web / JS / WASM         | hayir | hayir         | yok / parametre       |
| 10 | --emit-wat                      | ewt  | Web / JS / WASM         | hayir | hayir         | yok / parametre       |
| 11 | --emit-wasm                     | ewm  | Web / JS / WASM         | hayir | hayir         | yok / parametre       |
| 12 | --dump-ast                      | das  | AST                     | hayir | hayir         | yok / parametre       |
| 13 | --dump-mir                      | dmi  | MIR                     | hayir | hayir         | yok / parametre       |
| 14 | --strict                        | str  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 15 | --time-passes                   | tim  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 16 | --debug-token-dump              | tdp  | Lexer / Preprocessor    | hayir | hayir         | yok / parametre       |
| 17 | --token-json-out                | tkj  | Lexer / Preprocessor    | evet  | evet          | .json                 |
| 18 | --parse-only                    | par  | CLI / Genel             | hayir | hayir         | yok / parametre       |
| 19 | --parser-json-out               | pjo  | Parser                  | evet  | evet          | .json                 |
| 20 | --ast-contract-check            | acc  | AST                     | hayir | hayir         | yok / parametre       |
| 21 | --ast-json-out                  | ajo  | AST                     | evet  | evet          | .json                 |
| 22 | --semantic                      | sem  | Semantic / HIR / Type   | hayir | hayir         | yok / parametre       |
| 23 | --semantic-json-out             | sjo  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 24 | --hir-json-out                  | hjo  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 25 | --mir-verify                    | mvf  | MIR                     | hayir | hayir         | yok / parametre       |
| 26 | --codegen-source                | cgs  | CLI / Genel             | evet  | hayir         | .c/.cpp/.asm/.js/.wat |
| 27 | --mir-full-json-out             | mfj  | MIR                     | evet  | evet          | .json                 |
| 28 | --execmem                       | exm  | Runtime / Interpreter   | hayir | hayir         | yok / parametre       |
| 29 | --interpreter-backend           | ibk  | Runtime / Interpreter   | evet  | hayir         | yok / parametre       |
| 30 | --run-report-json-out           | rrj  | Web / JS / WASM         | evet  | evet          | .json                 |
| 31 | --emit-x64-nasm                 | x6e  | Native backend          | hayir | hayir         | yok / parametre       |
| 32 | --emit-x64-nasm-out             | x6o  | Native backend          | evet  | evet          | .asm/.nasm            |
| 33 | --x64-codegen-policy-json-out   | x6p  | Native backend          | evet  | evet          | .json                 |
| 34 | --emit-x86                      | x86  | Native backend          | hayir | hayir         | yok / parametre       |
| 35 | --backend-report-json-out       | brj  | Web / JS / WASM         | evet  | evet          | .json                 |
| 36 | --js-out                        | jso  | Web / JS / WASM         | evet  | evet          | .js                   |
| 37 | --wasm-wat-out                  | wto  | Web / JS / WASM         | evet  | evet          | .wat                  |
| 38 | --build-x64                     | bx6  | Native backend          | hayir | hayir         | yok / parametre       |
| 39 | --build-x64-out                 | bxo  | Native backend          | evet  | evet          | .exe                  |
| 40 | --validate-all                  | val  | Tooling / VSCode / Gate | hayir | hayir         | yok / parametre       |
| 41 | --validate-all-report-json-out  | vaj  | Web / JS / WASM         | evet  | evet          | .json                 |
| 42 | --source-map                    | smp  | Tooling / VSCode / Gate | hayir | hayir         | yok / parametre       |
| 43 | --source-map-json-out           | smj  | Web / JS / WASM         | evet  | evet          | .json                 |
| 44 | --doc                           | doc  | Tooling / VSCode / Gate | hayir | hayir         | yok / parametre       |
| 45 | --doc-json-out                  | djo  | Web / JS / WASM         | evet  | evet          | .json                 |
| 46 | --release-gate                  | rel  | Tooling / VSCode / Gate | hayir | hayir         | yok / parametre       |
| 47 | --release-json-out              | rjo  | Web / JS / WASM         | evet  | evet          | .json                 |
| 48 | --tokens-json-out               | tjs  | Lexer / Preprocessor    | evet  | evet          | .json                 |
| 49 | --lexer-diagnostics-json-out    | ldj  | Lexer / Preprocessor    | evet  | evet          | .json                 |
| 50 | --preprocessed-out              | pre  | Lexer / Preprocessor    | evet  | evet          | .bas/.uxb             |
| 51 | --parser-diagnostics-json-out   | pdj  | Parser                  | evet  | evet          | .json                 |
| 52 | --symbol-table-json-out         | syj  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 53 | --type-table-json-out           | tyj  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 54 | --layout-report-json-out        | lrj  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 55 | --hir-inventory-json-out        | hij  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 56 | --semantic-diagnostics-json-out | sdj  | Semantic / HIR / Type   | evet  | evet          | .json                 |
| 57 | --mir-opt-report-json-out       | mor  | MIR                     | evet  | evet          | .json                 |
| 58 | --stdout-out                    | sto  | Runtime / Interpreter   | evet  | evet          | .txt                  |
| 59 | --stderr-out                    | ste  | Runtime / Interpreter   | evet  | evet          | .txt                  |


Tam liste için `cli_options.csv`.

## Preprocessor komutları — özet


| kategori | komut | tipik_syntax           | gorev                                                               |
|----------|-------|------------------------|---------------------------------------------------------------------|
| Genel    | PP    | %%PP <komut> ... | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi |


| Makro/koşullu derleme       | DEFINE               | %%DEFINE ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | MACRO                | %%MACRO ...                | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | UNDEF                | %%UNDEF ...                | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | IF                   | %%IF ...                   | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | IFN                  | %%IFN ...                  | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | IFC                  | %%IFC ...                  | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | ELIF                 | %%ELIF ...                 | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | ELSE                 | %%ELSE ...                 | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Makro/koşullu derleme       | ENDIF                | %%ENDIF ...                | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | INCLUDE              | %%INCLUDE ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | ALIAS                | %%ALIAS ...                | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | SET                  | %%SET ...                  | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | EVAL                 | %%EVAL ...                 | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | PROFILE              | %%PROFILE ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | CONFIG_FILE          | %%CONFIG_FILE ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | PATH_ALIAS           | %%PATH_ALIAS ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | LOCK_META            | %%LOCK_META ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | DUMP_META            | %%DUMP_META ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | SOURCE_MAP           | %%SOURCE_MAP ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | EMITNOTE             | %%EMITNOTE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | ENV                  | %%ENV ...                  | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta/konfigürasyon          | DEPRECATED           | %%DEPRECATED ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | TEMPLATE             | %%TEMPLATE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | TEMPLATE_BEGIN       | %%TEMPLATE_BEGIN ...       | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | TEMPLATE_END         | %%TEMPLATE_END ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | TEMPLATE_USE         | %%TEMPLATE_USE ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | MINIFY               | %%MINIFY ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | FINGERPRINT_ASSETS   | %%FINGERPRINT_ASSETS ...   | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | HASHFILE             | %%HASHFILE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | COPY_DIR             | %%COPY_DIR ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | EMBEDTEXT            | %%EMBEDTEXT ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | EMBEDBASE64          | %%EMBEDBASE64 ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | LICENSEFILE          | %%LICENSEFILE ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | HTMLIMAGE            | %%HTMLIMAGE ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | HTMLAUDIO            | %%HTMLAUDIO ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | CSS_RULE             | %%CSS_RULE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | CSS_IMPORT           | %%CSS_IMPORT ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | MD_SAFE              | %%MD_SAFE ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Üretim/asset yardımcı     | MD_CSS               | %%MD_CSS ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | BREAK                | %%BREAK ...                | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | CONTINUE             | %%CONTINUE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | INFOMETA             | %%INFOMETA ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | ALLOW_RAW_JS         | %%ALLOW_RAW_JS ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | ALLOW_RAW_WAT        | %%ALLOW_RAW_WAT ...        | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | SAFE_PATHS           | %%SAFE_PATHS ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | REQUIRE_HOST_BINDING | %%REQUIRE_HOST_BINDING ... | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | ASSERT_META          | %%ASSERT_META ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | WARN_META            | %%WARN_META ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | TARGET               | %%TARGET ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | OUTDIR               | %%OUTDIR ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_ROOT           | %%ASSET_ROOT ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | EXPANDLIMIT          | %%EXPANDLIMIT ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_COPY           | %%ASSET_COPY ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_FILE           | %%ASSET_FILE ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_IMAGE          | %%ASSET_IMAGE ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_AUDIO          | %%ASSET_AUDIO ...          | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | ASSET_REQUIRE        | %%ASSET_REQUIRE ...        | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | MANIFEST_SET         | %%MANIFEST_SET ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Manifest/asset               | MANIFEST_REQUIRE     | %%MANIFEST_REQUIRE ...     | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_IMPORT           | %%WAT_IMPORT ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_EXPORT           | %%WAT_EXPORT ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JS_LINE              | %%JS_LINE ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | HTML_LINE            | %%HTML_LINE ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | CSS_LINE             | %%CSS_LINE ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JSON_SET             | %%JSON_SET ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | SECTION              | %%SECTION ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Genel                        | ENDSECTION           | %%ENDSECTION ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JS_BEGIN             | %%JS_BEGIN ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JS_END               | %%JS_END ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_BEGIN            | %%WAT_BEGIN ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_END              | %%WAT_END ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_FUNC_BEGIN       | %%WAT_FUNC_BEGIN ...       | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WAT_FUNC_END         | %%WAT_FUNC_END ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WASM_HOST_JS_BEGIN   | %%WASM_HOST_JS_BEGIN ...   | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | WASM_HOST_JS_END     | %%WASM_HOST_JS_END ...     | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | HTML_BEGIN           | %%HTML_BEGIN ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | HTML_END             | %%HTML_END ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | CSS_BEGIN            | %%CSS_BEGIN ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | CSS_END              | %%CSS_END ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JSON_BEGIN           | %%JSON_BEGIN ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JSON_END             | %%JSON_END ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JSON_ARRAY_BEGIN     | %%JSON_ARRAY_BEGIN ...     | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | JSON_ARRAY_END       | %%JSON_ARRAY_END ...       | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | MD_BEGIN             | %%MD_BEGIN ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Web/JS/WASM/raw blok         | MD_END               | %%MD_END ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | FOR                  | %%FOR ...                  | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | FOREACH              | %%FOREACH ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | ENDFOR               | %%ENDFOR ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | ENDFOREACH           | %%ENDFOREACH ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | NEXTMETA             | %%NEXTMETA ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | REPEAT               | %%REPEAT ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | ENDREPEAT            | %%ENDREPEAT ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Meta kontrol/loop/diagnostic | UNTILMETA            | %%UNTILMETA ...            | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | PLATFORM             | %%PLATFORM ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | DESTOS               | %%DESTOS ...               | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | NOZEROVARS           | %%NOZEROVARS ...           | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | SECSTACK             | %%SECSTACK ...             | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | ENDCOMP              | %%ENDCOMP ...              | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi || Uyumluluk/eski meta          | ERRORENDCOMP         | %%ERRORENDCOMP ...         | Kod ön işleme, meta durum, manifest/asset veya raw blok yönetimi |

## Sözdizimi/komutlar


| ad                          | syntax                                                                                             | ornek                                                                     | ast_node                         | gorev                              |
|-----------------------------|----------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------|----------------------------------|------------------------------------|
| Değişken bildirimi        | DIM ad [AS Tip] [= ifade]                                                                          | DIM x AS I32 = 10                                                         | DIM_STMT/DIM_DECL                | Yerel/global değişken bildirimi  |
| Dizi yeniden boyutlama      | REDIM ad(bounds) [AS Tip]                                                                          | REDIM a(10) AS I32                                                        | REDIM_STMT                       | Dizi boyutu/type yenileme          |
| Sabit                       | CONST ad [AS Tip] = ifade                                                                          | CONST PI AS F64 = 3.14                                                    | CONST_STMT                       | Sabit değer                       |
| Alt program                 | SUB ad([paramlar]) ... END SUB                                                                     | SUB Yaz(x AS I32) ... END SUB                                             | SUB_STMT                         | Değer döndürmeyen rutin         |
| Fonksiyon                   | FUNCTION ad([paramlar]) [AS Tip] ... END FUNCTION                                                  | FUNCTION Topla(a AS I32,b AS I32) AS I32                                  | FUNCTION_STMT                    | Değer döndüren rutin            |
| DECLARE                     | DECLARE FUNCTION ad LIB "dll" ALIAS "x" (...) AS Tip                                               | DECLARE FUNCTION MessageBox LIB "user32" ALIAS "MessageBoxA" (...) AS I32 | DECLARE_\*                       | Dış DLL/API imzası              |
| CALL                        | CALL ad(args) / CALL(DLL/API,...)                                                                  | CALL Yaz(1)                                                               | CALL_STMT                        | Rutin veya dış çağrı          |
| IMPORT                      | IMPORT(C/CPP/CXX/ASM/NASM/HEADER/INCLUDE,"dosya")                                                  | IMPORT(C,"x.c")                                                           | IMPORT_STMT                      | Derleme zamanı kaynak ekleme      |
| INCLUDE                     | INCLUDE "dosya.uxbh"                                                                               | INCLUDE "std.uxbh"                                                        | INCLUDE_STMT                     | Kaynak ekleme                      |
| USING                       | USING ns1, ns2                                                                                     | USING Math                                                                | USING_STMT                       | Kapsam/namespace kullanımı       |
| ALIAS                       | ALIAS yeni = eski.yol                                                                              | ALIAS P = System.Print                                                    | ALIAS_STMT                       | Ad eşleme                         |
| NAMESPACE                   | NAMESPACE ad ... END NAMESPACE                                                                     | NAMESPACE App ... END NAMESPACE                                           | NAMESPACE_STMT                   | Ad alanı                          |
| MODULE                      | MODULE ad ... END MODULE                                                                           | MODULE Core ... END MODULE                                                | MODULE_STMT                      | Modül bloğu                      |
| MAIN                        | MAIN ... END MAIN                                                                                  | MAIN ... END MAIN                                                         | MAIN_STMT                        | Ana giriş bloğu                  |
| TYPE                        | TYPE ad ... END TYPE                                                                               | TYPE Vec2: x AS F64: y AS F64: END TYPE                                   | TYPE_STMT                        | Kayıt/struct benzeri tip          |
| CLASS                       | CLASS ad [IMPLEMENTS x] ... END CLASS                                                              | CLASS Kedi ... END CLASS                                                  | CLASS_STMT                       | OOP sınıf                        |
| INTERFACE                   | INTERFACE ad ... END INTERFACE                                                                     | INTERFACE IRun ... END INTERFACE                                          | INTERFACE_STMT                   | Arayüz                            |
| ENUM                        | ENUM ad ... END ENUM                                                                               | ENUM Color ... END ENUM                                                   | ENUM_STMT                        | Sıralı sabitler                  |
| METHOD                      | METHOD ad(...) [AS Tip] ... END METHOD                                                             | METHOD Run() ... END METHOD                                               | CLASS_METHOD_DECL                | Sınıf metodu                     |
| CONSTRUCTOR                 | CONSTRUCTOR(...) ... END CONSTRUCTOR                                                               | CONSTRUCTOR() ... END CONSTRUCTOR                                         | CLASS_CONSTRUCTOR_DECL           | Kurucu                             |
| DESTRUCTOR                  | DESTRUCTOR() ... END DESTRUCTOR                                                                    | DESTRUCTOR() PRINT "bye" END DESTRUCTOR                                   | CLASS_DESTRUCTOR_DECL            | Yıkıcı                          |
| MAGIC                       | MAGIC ADD/GET/SET/CALL/TOSTRING/... ... END MAGIC                                                  | MAGIC ADD ... END MAGIC                                                   | CLASS_METHOD_DECL/MAGIC metadata | Sihirli metot/operator hook        |
| OPERATOR                    | OPERATOR <op>(...) [AS Tip] ... END OPERATOR                                                 | OPERATOR +(...) AS Vec2                                                   | CLASS_OPERATOR_DECL              | Operator overload                  |
| PROPERTY                    | PROPERTY ad [AS Tip] ... END PROPERTY                                                              | PROPERTY Name AS STRING                                                   | CLASS_PROPERTY_DECL              | Sınıf özelliği                 |
| IF                          | IF ifade THEN ... [ELSEIF ...] [ELSE ...] END IF                                                   | IF x>0 THEN PRINT x END IF                                             | IF_STMT                          | Koşul                             |
| SELECT                      | SELECT CASE ifade ... CASE ... [CASE ELSE] END SELECT                                              | SELECT CASE x ... END SELECT                                              | SELECT_STMT                      | Çoklu seçim                      |
| FOR                         | FOR i = a TO b [STEP s] ... NEXT                                                                   | FOR i=1 TO 10 PRINT i NEXT                                                | FOR_STMT                         | Sayaçlı döngü                  |
| FOR EACH                    | FOR EACH x IN koleksiyon ... NEXT                                                                  | FOR EACH x IN a PRINT x NEXT                                              | FOR_EACH_STMT                    | Koleksiyon döngüsü              |
| WHILE                       | WHILE ifade ... WEND                                                                               | WHILE x<10 ... WEND                                                    | DO/WHILE path                    | Koşullu döngü                   |
| DO                          | DO [WHILE/UNTIL ifade] ... LOOP [WHILE/UNTIL ifade]                                                | DO ... LOOP UNTIL done                                                    | DO_STMT                          | Genel döngü                      |
| GOTO/GOSUB                  | GOTO label / GOSUB label                                                                           | GOTO Bitir                                                                | GOTO_STMT/GOSUB_STMT             | Etiketli atlama                    |
| RETURN                      | RETURN [ifade]                                                                                     | RETURN x                                                                  | RETURN_STMT                      | Fonksiyon/gosub dönüşü         |
| EXIT                        | EXIT [FOR/DO/SUB/FUNCTION]                                                                         | EXIT FOR                                                                  | EXIT_STMT                        | Bloktan çıkış                  |
| TRY                         | TRY ... CATCH ... FINALLY ... END TRY                                                              | TRY ... CATCH e ... END TRY                                               | TRY_STMT                         | Hata yönetimi                     |
| THROW                       | THROW ifade                                                                                        | THROW "hata"                                                              | THROW_STMT                       | Hata fırlatma                     |
| ASSERT                      | ASSERT ifade [, mesaj]                                                                             | ASSERT x>0                                                             | ASSERT_STMT                      | Doğrulama                         |
| PRINT                       | PRINT ifade [,/; ifade...]                                                                         | PRINT "A", x                                                              | PRINT_STMT                       | Konsol çıktı                    |
| INPUT                       | INPUT [prompt,] değişken                                                                         | INPUT "Ad", ad                                                            | INPUT_STMT                       | Konsol giriş                      |
| OPEN                        | OPEN dosya FOR mode AS #n                                                                          | OPEN "a.txt" FOR OUTPUT AS #1                                             | OPEN_STMT                        | Dosya açma                        |
| GET/PUT/SEEK/CLOSE          | GET #n,... / PUT #n,... / SEEK #n,pos / CLOSE #n                                                   | CLOSE #1                                                                  | GET/PUT/SEEK/CLOSE               | Dosya I/O                          |
| CLS/COLOR/LOCATE            | CLS / COLOR fg,bg / LOCATE row,col                                                                 | LOCATE 1,1                                                                | CLS/COLOR/LOCATE                 | Konsol kontrol                     |
| SHELL                       | SHELL expr [TIMEOUT n] [OUTVAR id] [ERRVAR id] [CODEVAR id] [RUNPATH(x)] [OUTPATH(x)] [ERRPATH(x)] | SHELL "dir" TIMEOUT 3000 OUTVAR out CODEVAR rc                            | SHELL_STMT                       | Dış komut çalıştırma         |
| INLINE                      | INLINE hedef, kod                                                                                  | INLINE "ASM", "nop"                                                       | INLINE_STMT                      | Inline native/metin                |
| DELETE                      | DELETE ifade                                                                                       | DELETE obj                                                                | DELETE_STMT                      | Nesne silme/destructor             |
| POKE/PEEK                   | POKE addr,value; PEEK\* fonksiyon                                                                  | POKE 100, 1                                                               | POKE\*_STMT                      | Bellek erişimi                    |
| MEMCOPY/MEMFILL             | MEMCOPYB dst,src,n / MEMFILLB dst,v,n                                                              | MEMFILLB p,0,10                                                           | MEMCOPY/MEMFILL                  | Bellek blok işlemi                |
| INC/DEC                     | INC var / DEC var                                                                                  | INC i                                                                     | INCDEC_STMT                      | Artır/azalt                       |
| EVENT                       | EVENT ad ... END EVENT                                                                             | EVENT VeriGeldi ... END EVENT                                             | EVENT_STMT                       | Gövdeli görev/event              |
| PIPE                        | PIPE ad [input] ... END PIPE                                                                       | PIPE Donustur x ... END PIPE                                              | PIPE_STMT                        | Girdi/çıktı hattı              |
| THREAD                      | THREAD ad ... END THREAD                                                                           | THREAD Isci ... END THREAD                                                | THREAD_STMT                      | Runtime task/thread bloğu         |
| PARALEL                     | PARALEL ad ... END PARALEL                                                                         | PARALEL Grup ... END PARALEL                                              | PARALEL_STMT                     | Paralel görev bloğu              |
| SLOT tablo                  | SLOT ... ad id ON/OFF [EVENT/PIPE/THREAD/PARALEL] hedef ... END SLOT                               | SLOT                                                                      |                             |                               |
| Kaydet 5 ON EVENT VeriGeldi |                                                                                               |                                                                      |                             |                               |
| END SLOT                    | SLOT_TABLE_STMT                                                                                    | 0..255 görev bağlama tablosu                                            |                             |                               |
| SLOT kontrol                | ON/OFF SLOT id/ad / ON/OFF hedef                                                                   | OFF SLOT 5                                                                | SLOT_CONTROL_STMT                | Slot/görev aktiflik kontrolü     |
| TRIGGER                     | TRIGGER hedef [, veri]                                                                             | TRIGGER VeriGeldi, 42                                                     | TRIGGER_STMT                     | Slot’a bağlı görevi tetikleme |


## Operatörler


| kategori                  | operator  | oncelik | baglayicilik | gorev                                          |
|---------------------------|-----------|---------|--------------|------------------------------------------------|
| Postfix/call/index/member | .         | 14      | sol          | üye erişimi; CALL/INDEX iç temsil           |
| Power                     | \*\*      | 13      | sağ         | üs alma                                       |
| Unary                     | ++        | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | --        | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | +U        | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | -U        | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | @         | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | !         | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | ~         | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Unary                     | NOT       | 12      | sağ         | tekli art/azalt, adres, mantıksal/bit not     |
| Mul/Div                   | \*        | 11      | sol          | çarpma/bölme/tamsayı bölme/mod             |
| Mul/Div                   | /         | 11      | sol          | çarpma/bölme/tamsayı bölme/mod             |
| Mul/Div                   |      | 11      | sol          | çarpma/bölme/tamsayı bölme/mod             |
| Mul/Div                   | %         | 11      | sol          | çarpma/bölme/tamsayı bölme/mod             |
| Mul/Div                   | MOD       | 11      | sol          | çarpma/bölme/tamsayı bölme/mod             |
| Add/Sub                   | +         | 10      | sol          | toplama/çıkarma                              |
| Add/Sub                   | -         | 10      | sol          | toplama/çıkarma                              |
| Shift/Rotate              | <<  | 9       | sol          | kaydırma/döndürme                           |
| Shift/Rotate              | >>  | 9       | sol          | kaydırma/döndürme                           |
| Shift/Rotate              | SHL       | 9       | sol          | kaydırma/döndürme                           |
| Shift/Rotate              | SHR       | 9       | sol          | kaydırma/döndürme                           |
| Shift/Rotate              | ROL       | 9       | sol          | kaydırma/döndürme                           |
| Shift/Rotate              | ROR       | 9       | sol          | kaydırma/döndürme                           |
| Relation                  | =         | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | ==        | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | <>  | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | !=        | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | <      | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | <=     | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | >      | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Relation                  | >=     | 8       | sol          | karşılaştırma; == lexer canonical olarak = |
| Bit AND                   | &     | 7       | sol          | bit düzeyi AND                                |
| Bit XOR                   | ^         | 6       | sol          | bit düzeyi XOR                                |
| Bit XOR                   | XOR       | 6       | sol          | bit düzeyi XOR                                |
| Bit OR                    | /         | 5       | sol          | bit düzeyi OR                                 |
| Logic AND family          | AND       | 4       | sol          | mantıksal 16’lı aile                       |
| Logic AND family          | NAND      | 4       | sol          | mantıksal 16’lı aile                       |
| Logic AND family          | NIMP      | 4       | sol          | mantıksal 16’lı aile                       |
| Logic AND family          | NCIMP     | 4       | sol          | mantıksal 16’lı aile                       |
| Logic XNOR family         | XNOR      | 3       | sol          | eşdeğerlik ailesi                            |
| Logic XNOR family         | NXOR      | 3       | sol          | eşdeğerlik ailesi                            |
| Logic XNOR family         | EQV       | 3       | sol          | eşdeğerlik ailesi                            |
| Logic XNOR family         | EQA       | 3       | sol          | eşdeğerlik ailesi                            |
| Logic XNOR family         | IFF       | 3       | sol          | eşdeğerlik ailesi                            |
| Logic OR family           | OR        | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | NOR       | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | IMP       | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | CIMP      | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | IDA       | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | IDB       | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | NOTA      | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Logic OR family           | NOTB      | 2       | sol          | mantıksal OR/implikasyon ailesi               |
| Pipe                      | />     | 1       | sol          | akış/pipe operatörü                        |
| Ternary                   | ?:        | 0       | sağ         | ternary koşul                                 |
| Assignment                | =         | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | +=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | -=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | \*=       | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | /=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | =         | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | %=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | &=    | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | /=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | ^=        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | <<= | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | >>= | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | \*\*=     | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | =+        | -1      | sağ         | atama ve bileşik atama                        |
| Assignment                | =-        | -1      | sağ         | atama ve bileşik atama                        |


## Veri tipleri


| kategori               | tip_sabiti          | yuzey_adı     |
|------------------------|---------------------|----------------|
| Özel                  | TYPE_VOID           | VOID           |
| Özel                  | TYPE_BOOL           | BOOL           |
| Tamsayı               | TYPE_I8             | I8             |
| Tamsayı               | TYPE_U8             | U8             |
| Tamsayı               | TYPE_I16            | I16            |
| Tamsayı               | TYPE_U16            | U16            |
| Tamsayı               | TYPE_I32            | I32            |
| Tamsayı               | TYPE_U32            | U32            |
| Tamsayı               | TYPE_I64            | I64            |
| Tamsayı               | TYPE_U64            | U64            |
| Ondalık/büyük sayı | TYPE_F32            | F32            |
| Ondalık/büyük sayı | TYPE_F64            | F64            |
| Ondalık/büyük sayı | TYPE_F80            | F80            |
| Ondalık/büyük sayı | TYPE_F128           | F128           |
| Ondalık/büyük sayı | TYPE_BIGINT         | BIGINT         |
| Ondalık/büyük sayı | TYPE_BIGFLOAT       | BIGFLOAT       |
| Ondalık/büyük sayı | TYPE_BIGD           | BIGD           |
| Ondalık/büyük sayı | TYPE_BALL           | BALL           |
| String                 | TYPE_STRING         | STRING         |
| String                 | TYPE_WSTRING        | WSTRING        |
| Pointer/handle/ABI     | TYPE_PTR            | PTR            |
| Pointer/handle/ABI     | TYPE_STRPTR         | STRPTR         |
| Pointer/handle/ABI     | TYPE_WSTRPTR        | WSTRPTR        |
| Yapısal/OOP           | TYPE_ARRAY          | ARRAY          |
| Yapısal/OOP           | TYPE_OBJECT         | OBJECT         |
| Yapısal/OOP           | TYPE_VARIANT        | VARIANT        |
| Yapısal/OOP           | TYPE_ANY            | ANY            |
| Yapısal/OOP           | TYPE_TYPEDEF        | TYPEDEF        |
| Yapısal/OOP           | TYPE_CLASS          | CLASS          |
| Yapısal/OOP           | TYPE_INTERFACE      | INTERFACE      |
| Pointer/handle/ABI     | TYPE_FUNCTION_PTR   | FUNCTION_PTR   |
| Pointer/handle/ABI     | TYPE_DLL_HANDLE     | DLL_HANDLE     |
| Pointer/handle/ABI     | TYPE_FILE_HANDLE    | FILE_HANDLE    |
| Web/WASM               | TYPE_JS_OBJECT      | JS_OBJECT      |
| Web/WASM               | TYPE_WASM_EXTERNREF | WASM_EXTERNREF |
| Özel                  | TYPE_UNKNOWN        | UNKNOWN        |
| Özel                  | TYPE_ERROR          | ERROR          |


## Builtin fonksiyon/type kuralları


| ad      | donus         | arg_policy        | target_policy   |
|---------|---------------|-------------------|-----------------|
| LEN     | TYPE_I32      | STRING:1          | ALL             |
| VAL     | TYPE_F64      | STRING:1          | ALL             |
| VALINT  | TYPE_I32      | STRING:1          | ALL             |
| STR     | TYPE_STRING   | NUMERIC:1         | ALL             |
| LEFT    | TYPE_STRING   | STRING,INT        | ALL             |
| RIGHT   | TYPE_STRING   | STRING,INT        | ALL             |
| MID     | TYPE_STRING   | STRING,INT[,INT]  | ALL             |
| INSTR   | TYPE_I32      | STRING,STRING     | ALL             |
| ASC     | TYPE_I32      | STRING:1          | ALL             |
| CHR     | TYPE_STRING   | INT:1             | ALL             |
| ABS     | TYPE_F64      | NUMERIC:1         | ALL             |
| SIN     | TYPE_F64      | NUMERIC:1         | ALL             |
| COS     | TYPE_F64      | NUMERIC:1         | ALL             |
| TAN     | TYPE_F64      | NUMERIC:1         | ALL             |
| ATN     | TYPE_F64      | NUMERIC:1         | ALL             |
| LOG     | TYPE_F64      | NUMERIC:1         | ALL             |
| EXP     | TYPE_F64      | NUMERIC:1         | ALL             |
| SQR     | TYPE_F64      | NUMERIC:1         | ALL             |
| SQRT    | TYPE_F64      | NUMERIC:1         | ALL             |
| RND     | TYPE_F64      | OPTIONAL_SEED     | ALL             |
| TIMER   | TYPE_F64      | NOARGS            | ALL             |
| SGN     | TYPE_I32      | NUMERIC:1         | ALL             |
| INT     | TYPE_I32      | NUMERIC:1         | ALL             |
| CINT    | TYPE_I32      | ANY:1             | ALL             |
| CLNG    | TYPE_I32      | ANY:1             | ALL             |
| CSNG    | TYPE_F64      | ANY:1             | ALL             |
| CDBL    | TYPE_F64      | ANY:1             | ALL             |
| LCASE   | TYPE_STRING   | STRING:1          | ALL             |
| UCASE   | TYPE_STRING   | STRING:1          | ALL             |
| TRIM    | TYPE_STRING   | STRING:1          | ALL             |
| LTRIM   | TYPE_STRING   | STRING:1          | ALL             |
| RTRIM   | TYPE_STRING   | STRING:1          | ALL             |
| INPUT   | TYPE_STRING   | OPTIONAL_PROMPT   | CONSOLE_RUNTIME |
| STRPTR  | TYPE_STRPTR   | STRING:1          | NATIVE_RUNTIME  |
| WSTRPTR | TYPE_WSTRPTR  | WSTRING:1         | NATIVE_RUNTIME  |
| PTR     | TYPE_PTR      | ANY:1             | NATIVE_RUNTIME  |
| CASTPTR | TYPE_PTR      | TYPE,VALUE        | NATIVE_RUNTIME  |
| VARPTR  | TYPE_PTR      | IDENT:1           | NATIVE_RUNTIME  |
| SADD    | TYPE_PTR      | STRING:1          | NATIVE_RUNTIME  |
| BIGINIT | TYPE_BIGFLOAT | BIG_EXTERNAL_INIT | EXTFP_RUNTIME   |
| F80     | TYPE_F80      | EXTFP_CONSTRUCT   | EXTFP_RUNTIME   |
| F128    | TYPE_F128     | EXTFP_CONSTRUCT   | EXTFP_RUNTIME   |
| BIGF    | TYPE_BIGFLOAT | EXTFP_CONSTRUCT   | EXTFP_RUNTIME   |
| BIGD    | TYPE_BIGD     | EXTFP_CONSTRUCT   | EXTFP_RUNTIME   |
| BALL    | TYPE_BALL     | EXTFP_CONSTRUCT   | EXTFP_RUNTIME   |


## Runtime servisleri


| service_id          | sabit               |
|---------------------|---------------------|
| RT_PRINT            | RT_PRINT            |
| RT_INPUT            | RT_INPUT            |
| RT_CLS              | RT_CLS              |
| RT_COLOR            | RT_COLOR            |
| RT_LOCATE           | RT_LOCATE           |
| RT_GETKEY           | RT_GETKEY           |
| RT_INKEY            | RT_INKEY            |
| RT_STR_LEN          | RT_STR_LEN          |
| RT_STR_CONCAT       | RT_STR_CONCAT       |
| RT_STR_LEFT         | RT_STR_LEFT         |
| RT_STR_RIGHT        | RT_STR_RIGHT        |
| RT_STR_MID          | RT_STR_MID          |
| RT_STR_COMPARE      | RT_STR_COMPARE      |
| RT_STR_TO_UPPER     | RT_STR_TO_UPPER     |
| RT_STR_TO_LOWER     | RT_STR_TO_LOWER     |
| RT_STR_TRIM         | RT_STR_TRIM         |
| RT_MATH_ABS         | RT_MATH_ABS         |
| RT_MATH_SQRT        | RT_MATH_SQRT        |
| RT_MATH_SIN         | RT_MATH_SIN         |
| RT_MATH_COS         | RT_MATH_COS         |
| RT_MATH_LOG         | RT_MATH_LOG         |
| RT_MATH_EXP         | RT_MATH_EXP         |
| RT_RANDOMIZE        | RT_RANDOMIZE        |
| RT_RND              | RT_RND              |
| RT_TIMER            | RT_TIMER            |
| RT_MEM_LOAD         | RT_MEM_LOAD         |
| RT_MEM_STORE        | RT_MEM_STORE        |
| RT_MEM_COPY         | RT_MEM_COPY         |
| RT_MEM_FILL         | RT_MEM_FILL         |
| RT_PEEK             | RT_PEEK             |
| RT_POKE             | RT_POKE             |
| RT_FILE_OPEN        | RT_FILE_OPEN        |
| RT_FILE_CLOSE       | RT_FILE_CLOSE       |
| RT_FILE_READ        | RT_FILE_READ        |
| RT_FILE_WRITE       | RT_FILE_WRITE       |
| RT_FILE_SEEK        | RT_FILE_SEEK        |
| RT_FILE_DELETE      | RT_FILE_DELETE      |
| RT_DLL_LOAD         | RT_DLL_LOAD         |
| RT_DLL_CALL         | RT_DLL_CALL         |
| RT_API_CALL         | RT_API_CALL         |
| RT_INLINE_NATIVE    | RT_INLINE_NATIVE    |
| RT_LIBRARY_CALL     | RT_LIBRARY_CALL     |
| RT_JSON_CALL        | RT_JSON_CALL        |
| RT_REGEX_CALL       | RT_REGEX_CALL       |
| RT_HTTP_CALL        | RT_HTTP_CALL        |
| RT_OS_CALL          | RT_OS_CALL          |
| RT_LLAMA_CALL       | RT_LLAMA_CALL       |
| RT_LUA_CALL         | RT_LUA_CALL         |
| RT_PROLOG_CALL      | RT_PROLOG_CALL      |
| RT_SQLITE_CALL      | RT_SQLITE_CALL      |
| RT_BROWSER_CANVAS   | RT_BROWSER_CANVAS   |
| RT_BROWSER_AUDIO    | RT_BROWSER_AUDIO    |
| RT_BROWSER_INPUT    | RT_BROWSER_INPUT    |
| RT_BROWSER_FILE     | RT_BROWSER_FILE     |
| RT_BROWSER_FETCH    | RT_BROWSER_FETCH    |
| RT_WEBGPU_CALL      | RT_WEBGPU_CALL      |
| RT_ARCHIVE_CALL     | RT_ARCHIVE_CALL     |
| RT_AUDIO_CALL       | RT_AUDIO_CALL       |
| RT_CRYPTO_CALL      | RT_CRYPTO_CALL      |
| RT_CURL_CALL        | RT_CURL_CALL        |
| RT_GRAPHICS_CALL    | RT_GRAPHICS_CALL    |
| RT_IMAGE_CALL       | RT_IMAGE_CALL       |
| RT_ONNX_CALL        | RT_ONNX_CALL        |
| RT_SERVER_CALL      | RT_SERVER_CALL      |
| RT_STRINGX_CALL     | RT_STRINGX_CALL     |
| RT_WASM_IMPORT_CALL | RT_WASM_IMPORT_CALL |
| RT_WASM_EXPORT_CALL | RT_WASM_EXPORT_CALL |
| RT_HOST_CALL        | RT_HOST_CALL        |
| RT_EXTFP_CALL       | RT_EXTFP_CALL       |
| RT_MATH_TAN         | RT_MATH_TAN         |
| RT_MATH_ATN         | RT_MATH_ATN         |
| RT_MATH_SGN         | RT_MATH_SGN         |
| RT_MATH_FIX         | RT_MATH_FIX         |
| RT_MATH_INT         | RT_MATH_INT         |
| RT_STR_LTRIM        | RT_STR_LTRIM        |
| RT_STR_RTRIM        | RT_STR_RTRIM        |
| RT_STR_SPACE        | RT_STR_SPACE        |
| RT_STR_ASC          | RT_STR_ASC          |
| RT_STR_CHR          | RT_STR_CHR          |
| RT_STR_VAL          | RT_STR_VAL          |
| RT_STR_STR          | RT_STR_STR          |
| RT_FILE_EOF         | RT_FILE_EOF         |
| RT_FILE_LOF         | RT_FILE_LOF         |


## AST node grupları — ilk 120


| kategori        | node                    | sabit                        |
|-----------------|-------------------------|------------------------------|
| Genel           | PROGRAM                 | ASTK_PROGRAM                 |
| Genel           | BLOCK                   | ASTK_BLOCK                   |
| İfade          | IDENT                   | ASTK_IDENTIFIER              |
| İfade          | NUMBER                  | ASTK_NUMBER                  |
| İfade          | STRING                  | ASTK_STRING                  |
| İfade          | BOOLEAN                 | ASTK_BOOLEAN                 |
| OOP/tip         | TYPE_REF                | ASTK_TYPE_REF                |
| Genel           | PARAM_DECL              | ASTK_PARAM_DECL              |
| OOP/tip         | RETURN_TYPE             | ASTK_RETURN_TYPE             |
| İfade          | BINARY                  | ASTK_BINARY                  |
| İfade          | UNARY                   | ASTK_UNARY                   |
| İfade          | TERNARY_EXPR            | ASTK_TERNARY_EXPR            |
| İfade          | CALL_EXPR               | ASTK_CALL_EXPR               |
| İfade          | FIELD_EXPR              | ASTK_FIELD_EXPR              |
| Genel           | KEYWORD_REF             | ASTK_KEYWORD_REF             |
| İfade          | NEW_EXPR                | ASTK_NEW_EXPR                |
| İfade          | RANGE_EXPR              | ASTK_RANGE_EXPR              |
| Runtime/bellek  | INCDEC_EXPR             | ASTK_INCDEC_EXPR             |
| İfade          | INDEX_EXPR              | ASTK_INDEX_EXPR              |
| Runtime/bellek  | MEMBER_EXPR             | ASTK_MEMBER_EXPR             |
| İfade          | CAST_EXPR               | ASTK_CAST_EXPR               |
| İfade          | SIZEOF_EXPR             | ASTK_SIZEOF_EXPR             |
| İfade          | INIT_EXPR               | ASTK_INIT_EXPR               |
| İfade          | PROMPT_EXPR             | ASTK_PROMPT_EXPR             |
| Bildirim/kapsam | DIM_STMT                | ASTK_DIM_STMT                |
| Bildirim/kapsam | DIM_DECL                | ASTK_DIM_DECL                |
| Bildirim/kapsam | DIM_BOUNDS              | ASTK_DIM_BOUNDS              |
| Bildirim/kapsam | REDIM_STMT              | ASTK_REDIM_STMT              |
| Bildirim/kapsam | REDIM_DECL              | ASTK_REDIM_DECL              |
| Bildirim/kapsam | CONST_STMT              | ASTK_CONST_STMT              |
| Bildirim/kapsam | CONST_DECL              | ASTK_CONST_DECL              |
| OOP/tip         | TYPE_STMT               | ASTK_TYPE_STMT               |
| OOP/tip         | TYPE_FIELD              | ASTK_TYPE_FIELD              |
| OOP/tip         | CLASS_STMT              | ASTK_CLASS_STMT              |
| OOP/tip         | CLASS_FIELD             | ASTK_CLASS_FIELD             |
| OOP/tip         | CLASS_PROPERTY_DECL     | ASTK_CLASS_PROPERTY_DECL     |
| OOP/tip         | CLASS_PROPERTY_GET_STMT | ASTK_CLASS_PROPERTY_GET_STMT |
| OOP/tip         | CLASS_PROPERTY_SET_STMT | ASTK_CLASS_PROPERTY_SET_STMT |
| OOP/tip         | CLASS_METHOD_DECL       | ASTK_CLASS_METHOD_DECL       |
| OOP/tip         | CLASS_CONSTRUCTOR_DECL  | ASTK_CLASS_CONSTRUCTOR_DECL  |
| OOP/tip         | CLASS_DESTRUCTOR_DECL   | ASTK_CLASS_DESTRUCTOR_DECL   |
| OOP/tip         | CLASS_OPERATOR_DECL     | ASTK_CLASS_OPERATOR_DECL     |
| OOP/tip         | CLASS_BASE_REF          | ASTK_CLASS_BASE_REF          |
| OOP/tip         | CLASS_IMPLEMENTS_REF    | ASTK_CLASS_IMPLEMENTS_REF    |
| OOP/tip         | CLASS_DECORATOR_REF     | ASTK_CLASS_DECORATOR_REF     |
| OOP/tip         | CLASS_MIXIN_REF         | ASTK_CLASS_MIXIN_REF         |
| OOP/tip         | CLASS_FLAG              | ASTK_CLASS_FLAG              |
| OOP/tip         | CLASS_FIELD_FLAG        | ASTK_CLASS_FIELD_FLAG        |
| OOP/tip         | CLASS_METHOD_FLAG       | ASTK_CLASS_METHOD_FLAG       |
| OOP/tip         | CLASS_PROPERTY_FLAG     | ASTK_CLASS_PROPERTY_FLAG     |
| OOP/tip         | CLASS_ACCESS            | ASTK_CLASS_ACCESS            |
| OOP/tip         | CLASS_FRIEND_STMT       | ASTK_CLASS_FRIEND_STMT       |
| OOP/tip         | FRIEND_ITEM             | ASTK_FRIEND_ITEM             |
| OOP/tip         | INTERFACE_STMT          | ASTK_INTERFACE_STMT          |
| OOP/tip         | INTERFACE_METHOD_DECL   | ASTK_INTERFACE_METHOD_DECL   |
| OOP/tip         | ENUM_STMT               | ASTK_ENUM_STMT               |
| OOP/tip         | ENUM_ITEM               | ASTK_ENUM_ITEM               |
| OOP/tip         | ENUM_BASE_TYPE          | ASTK_ENUM_BASE_TYPE          |
| Bildirim/kapsam | SUB_STMT                | ASTK_SUB_STMT                |
| Bildirim/kapsam | FUNCTION_STMT           | ASTK_FUNCTION_STMT           |
| Bildirim/kapsam | DECLARE_SUB_STMT        | ASTK_DECLARE_SUB_STMT        |
| Bildirim/kapsam | DECLARE_FUNCTION_STMT   | ASTK_DECLARE_FUNCTION_STMT   |
| Bildirim/kapsam | MODULE_STMT             | ASTK_MODULE_STMT             |
| Bildirim/kapsam | NAMESPACE_STMT          | ASTK_NAMESPACE_STMT          |
| Bildirim/kapsam | MAIN_STMT               | ASTK_MAIN_STMT               |
| Bildirim/kapsam | IMPORT_STMT             | ASTK_IMPORT_STMT             |
| Bildirim/kapsam | INCLUDE_STMT            | ASTK_INCLUDE_STMT            |
| Bildirim/kapsam | USING_STMT              | ASTK_USING_STMT              |
| Bildirim/kapsam | USING_ITEM              | ASTK_USING_ITEM              |
| Bildirim/kapsam | ALIAS_STMT              | ASTK_ALIAS_STMT              |
| Bildirim/kapsam | ALIAS_TARGET            | ASTK_ALIAS_TARGET            |
| Genel           | ASSIGN_STMT             | ASTK_ASSIGN_STMT             |
| İfade          | EXPR_STMT               | ASTK_EXPR_STMT               |
| I/O             | PRINT_STMT              | ASTK_PRINT_STMT              |
| I/O             | PRINT_ITEM              | ASTK_PRINT_ITEM              |
| I/O             | INPUT_STMT              | ASTK_INPUT_STMT              |
| I/O             | INPUT_FILE_STMT         | ASTK_INPUT_FILE_STMT         |
| I/O             | INPUTF_STMT             | ASTK_INPUTF_STMT             |
| Akış          | IF_STMT                 | ASTK_IF_STMT                 |
| Akış          | ELSEIF_PART             | ASTK_ELSEIF_PART             |
| Genel           | ELSE_PART               | ASTK_ELSE_PART               |
| Akış          | SELECT_STMT             | ASTK_SELECT_STMT             |
| Akış          | CASE_BLOCK              | ASTK_CASE_BLOCK              |
| Akış          | CASE_ELSE               | ASTK_CASE_ELSE               |
| Akış          | CASE_IS_VALUE           | ASTK_CASE_IS_VALUE           |
| Akış          | FOR_STMT                | ASTK_FOR_STMT                |
| Akış          | FOR_EACH_STMT           | ASTK_FOR_EACH_STMT           |
| Genel           | EACH_ITEMS              | ASTK_EACH_ITEMS              |
| Genel           | EACH_BODY               | ASTK_EACH_BODY               |
| Akış          | DO_STMT                 | ASTK_DO_STMT                 |
| Akış          | DO_EACH_STMT            | ASTK_DO_EACH_STMT            |
| Akış          | EXIT_STMT               | ASTK_EXIT_STMT               |
| Akış          | RETURN_STMT             | ASTK_RETURN_STMT             |
| Akış          | GOTO_STMT               | ASTK_GOTO_STMT               |
| Bildirim/kapsam | GOSUB_STMT              | ASTK_GOSUB_STMT              |
| Genel           | LABEL_STMT              | ASTK_LABEL_STMT              |
| İfade          | CALL_STMT               | ASTK_CALL_STMT               |
| Akış          | TRY_STMT                | ASTK_TRY_STMT                |
| Akış          | TRY_BODY                | ASTK_TRY_BODY                |
| Akış          | CATCH_PART              | ASTK_CATCH_PART              |
| Akış          | FINALLY_PART            | ASTK_FINALLY_PART            |
| Akış          | THROW_STMT              | ASTK_THROW_STMT              |
| Akış          | ASSERT_STMT             | ASTK_ASSERT_STMT             |
| Akış          | END_STMT                | ASTK_END_STMT                |
| OOP/tip         | DEFTYPE_STMT            | ASTK_DEFTYPE_STMT            |
| Akış          | RANDOMIZE_STMT          | ASTK_RANDOMIZE_STMT          |
| Runtime/bellek  | INCDEC_STMT             | ASTK_INCDEC_STMT             |
| I/O             | OPEN_STMT               | ASTK_OPEN_STMT               |
| Genel           | MODE_REF                | ASTK_MODE_REF                |
| I/O             | CLOSE_STMT              | ASTK_CLOSE_STMT              |
| I/O             | GET_STMT                | ASTK_GET_STMT                |
| I/O             | PUT_STMT                | ASTK_PUT_STMT                |
| I/O             | SEEK_STMT               | ASTK_SEEK_STMT               |
| I/O             | LOCATE_STMT             | ASTK_LOCATE_STMT             |
| I/O             | COLOR_STMT              | ASTK_COLOR_STMT              |
| I/O             | CLS_STMT                | ASTK_CLS_STMT                |
| Runtime/bellek  | DELETE_STMT             | ASTK_DELETE_STMT             |
| Runtime/bellek  | SETSTRINGSIZE_STMT      | ASTK_SETSTRINGSIZE_STMT      |
| Runtime/bellek  | POKEB_STMT              | ASTK_POKEB_STMT              |
| Runtime/bellek  | POKEW_STMT              | ASTK_POKEW_STMT              |


## MIR opcode grupları — ilk 160


| kategori                      | opcode            | sabit             |
|-------------------------------|-------------------|-------------------|
| Aritmetik                     | ADD               | ADD               |
| Karşılaştırma/mantık/bit | AND               | AND               |
| Kontrol/çağrı              | CALL              | CALL              |
| Kontrol/çağrı              | CALL_API          | CALL_API          |
| Kontrol/çağrı              | CALL_DLL          | CALL_DLL          |
| Kontrol/çağrı              | CALL_USER         | CALL_USER         |
| I/O                           | CLOSE             | CLOSE             |
| I/O                           | CLS               | CLS               |
| Karşılaştırma/mantık/bit | COLOR             | COLOR             |
| Veri/bellek                   | CONST             | CONST             |
| Genel                         | DEF_TYPE          | DEF_TYPE          |
| Genel                         | DIM               | DIM               |
| Aritmetik                     | DIV               | DIV               |
| Karşılaştırma/mantık/bit | EQ                | EQ                |
| Aritmetik                     | FADD              | FADD              |
| Aritmetik                     | FDIV              | FDIV              |
| Aritmetik                     | FMUL              | FMUL              |
| Aritmetik                     | FNEG              | FNEG              |
| Aritmetik                     | FSUB              | FSUB              |
| Karşılaştırma/mantık/bit | GE                | GE                |
| Karşılaştırma/mantık/bit | GET               | GET               |
| Karşılaştırma/mantık/bit | GT                | GT                |
| Karşılaştırma/mantık/bit | IMPORT            | IMPORT            |
| Karşılaştırma/mantık/bit | INLINE            | INLINE            |
| I/O                           | INPUT             | INPUT             |
| Kontrol/çağrı              | JMP               | JMP               |
| Genel                         | JNZ               | JNZ               |
| Genel                         | JZ                | JZ                |
| Kontrol/çağrı              | LABEL             | LABEL             |
| Karşılaştırma/mantık/bit | LE                | LE                |
| Veri/bellek                   | LOAD_CONST        | LOAD_CONST        |
| Veri/bellek                   | LOAD_FIELD        | LOAD_FIELD        |
| Veri/bellek                   | LOAD_INDEXED      | LOAD_INDEXED      |
| Veri/bellek                   | LOAD_VAR          | LOAD_VAR          |
| I/O                           | LOCATE            | LOCATE            |
| Karşılaştırma/mantık/bit | LT                | LT                |
| Veri/bellek                   | MEMCOPY           | MEMCOPY           |
| Veri/bellek                   | MEMFILL           | MEMFILL           |
| Aritmetik                     | MOD               | MOD               |
| Aritmetik                     | MUL               | MUL               |
| Karşılaştırma/mantık/bit | NE                | NE                |
| Aritmetik                     | NEG               | NEG               |
| Karşılaştırma/mantık/bit | NEW               | NEW               |
| Karşılaştırma/mantık/bit | NOT               | NOT               |
| I/O                           | OPEN              | OPEN              |
| Karşılaştırma/mantık/bit | OR                | OR                |
| Veri/bellek                   | PEEK              | PEEK              |
| Veri/bellek                   | POKE              | POKE              |
| I/O                           | PRINT             | PRINT             |
| Genel                         | PUT               | PUT               |
| Genel                         | REDIM             | REDIM             |
| Kontrol/çağrı              | RET               | RET               |
| Kontrol/çağrı              | RETURN            | RETURN            |
| Karşılaştırma/mantık/bit | ROL               | ROL               |
| Karşılaştırma/mantık/bit | ROR               | ROR               |
| I/O                           | SEEK              | SEEK              |
| Karşılaştırma/mantık/bit | SETNEWOFFSET      | SETNEWOFFSET      |
| String                        | SETSTRINGSIZE     | SETSTRINGSIZE     |
| Karşılaştırma/mantık/bit | SHL               | SHL               |
| Karşılaştırma/mantık/bit | SHR               | SHR               |
| Karşılaştırma/mantık/bit | STORE_FIELD       | STORE_FIELD       |
| Karşılaştırma/mantık/bit | STORE_INDEXED     | STORE_INDEXED     |
| Karşılaştırma/mantık/bit | STORE_VAR         | STORE_VAR         |
| Aritmetik                     | SUB               | SUB               |
| Karşılaştırma/mantık/bit | XOR               | XOR               |
| Karşılaştırma/mantık/bit | NAND              | NAND              |
| Karşılaştırma/mantık/bit | NOR               | NOR               |
| Karşılaştırma/mantık/bit | XNOR              | XNOR              |
| Karşılaştırma/mantık/bit | IMP               | IMP               |
| Karşılaştırma/mantık/bit | CIMP              | CIMP              |
| Karşılaştırma/mantık/bit | NIMP              | NIMP              |
| Karşılaştırma/mantık/bit | NCIMP             | NCIMP             |
| Genel                         | IDA               | IDA               |
| Genel                         | IDB               | IDB               |
| Karşılaştırma/mantık/bit | NOTA              | NOTA              |
| Karşılaştırma/mantık/bit | NOTB              | NOTB              |
| Aritmetik                     | POW               | POW               |
| Genel                         | MIR_NOP           | MIR_NOP           |
| Veri/bellek                   | MIR_CONST         | MIR_CONST         |
| Veri/bellek                   | MIR_LOAD_CONST    | MIR_LOAD_CONST    |
| Veri/bellek                   | MIR_LOCAL_DECL    | MIR_LOCAL_DECL    |
| Veri/bellek                   | MIR_GLOBAL_DECL   | MIR_GLOBAL_DECL   |
| Veri/bellek                   | MIR_PARAM_DECL    | MIR_PARAM_DECL    |
| Veri/bellek                   | MIR_LOAD_LOCAL    | MIR_LOAD_LOCAL    |
| Karşılaştırma/mantık/bit | MIR_STORE_LOCAL   | MIR_STORE_LOCAL   |
| Veri/bellek                   | MIR_LOAD_GLOBAL   | MIR_LOAD_GLOBAL   |
| Karşılaştırma/mantık/bit | MIR_STORE_GLOBAL  | MIR_STORE_GLOBAL  |
| Aritmetik                     | MIR_ADD           | MIR_ADD           |
| Aritmetik                     | MIR_SUB           | MIR_SUB           |
| Aritmetik                     | MIR_MUL           | MIR_MUL           |
| Aritmetik                     | MIR_DIV           | MIR_DIV           |
| Aritmetik                     | MIR_IDIV          | MIR_IDIV          |
| Aritmetik                     | MIR_MOD           | MIR_MOD           |
| Aritmetik                     | MIR_NEG           | MIR_NEG           |
| Aritmetik                     | MIR_FADD          | MIR_FADD          |
| Aritmetik                     | MIR_FSUB          | MIR_FSUB          |
| Aritmetik                     | MIR_FMUL          | MIR_FMUL          |
| Aritmetik                     | MIR_FDIV          | MIR_FDIV          |
| Aritmetik                     | MIR_FNEG          | MIR_FNEG          |
| Karşılaştırma/mantık/bit | MIR_EQ            | MIR_EQ            |
| Karşılaştırma/mantık/bit | MIR_NE            | MIR_NE            |
| Karşılaştırma/mantık/bit | MIR_LT            | MIR_LT            |
| Karşılaştırma/mantık/bit | MIR_LE            | MIR_LE            |
| Karşılaştırma/mantık/bit | MIR_GT            | MIR_GT            |
| Karşılaştırma/mantık/bit | MIR_GE            | MIR_GE            |
| Karşılaştırma/mantık/bit | MIR_AND           | MIR_AND           |
| Karşılaştırma/mantık/bit | MIR_OR            | MIR_OR            |
| Karşılaştırma/mantık/bit | MIR_XOR           | MIR_XOR           |
| Karşılaştırma/mantık/bit | MIR_NAND          | MIR_NAND          |
| Karşılaştırma/mantık/bit | MIR_NOR           | MIR_NOR           |
| Karşılaştırma/mantık/bit | MIR_XNOR          | MIR_XNOR          |
| Karşılaştırma/mantık/bit | MIR_IMP           | MIR_IMP           |
| Karşılaştırma/mantık/bit | MIR_CIMP          | MIR_CIMP          |
| Karşılaştırma/mantık/bit | MIR_NIMP          | MIR_NIMP          |
| Karşılaştırma/mantık/bit | MIR_NCIMP         | MIR_NCIMP         |
| Genel                         | MIR_IDA           | MIR_IDA           |
| Genel                         | MIR_IDB           | MIR_IDB           |
| Karşılaştırma/mantık/bit | MIR_NOTA          | MIR_NOTA          |
| Karşılaştırma/mantık/bit | MIR_NOTB          | MIR_NOTB          |
| Karşılaştırma/mantık/bit | MIR_NOT           | MIR_NOT           |
| Karşılaştırma/mantık/bit | MIR_SHL           | MIR_SHL           |
| Karşılaştırma/mantık/bit | MIR_SHR           | MIR_SHR           |
| Karşılaştırma/mantık/bit | MIR_ROL           | MIR_ROL           |
| Karşılaştırma/mantık/bit | MIR_ROR           | MIR_ROR           |
| Genel                         | MIR_CAST          | MIR_CAST          |
| Genel                         | MIR_COERCE        | MIR_COERCE        |
| Kontrol/çağrı              | MIR_LABEL         | MIR_LABEL         |
| Kontrol/çağrı              | MIR_JMP           | MIR_JMP           |
| Kontrol/çağrı              | MIR_JMP_IF_TRUE   | MIR_JMP_IF_TRUE   |
| Kontrol/çağrı              | MIR_JMP_IF_FALSE  | MIR_JMP_IF_FALSE  |
| Kontrol/çağrı              | MIR_RETURN        | MIR_RETURN        |
| Kontrol/çağrı              | MIR_CALL          | MIR_CALL          |
| Karşılaştırma/mantık/bit | MIR_CALL_BUILTIN  | MIR_CALL_BUILTIN  |
| Kontrol/çağrı              | MIR_CALL_RUNTIME  | MIR_CALL_RUNTIME  |
| Kontrol/çağrı              | MIR_CALL_EXTERNAL | MIR_CALL_EXTERNAL |
| Kontrol/çağrı              | MIR_CALL_DLL      | MIR_CALL_DLL      |
| Kontrol/çağrı              | MIR_CALL_API      | MIR_CALL_API      |
| I/O                           | MIR_PRINT         | MIR_PRINT         |
| I/O                           | MIR_INPUT         | MIR_INPUT         |
| I/O                           | MIR_CLS           | MIR_CLS           |
| Karşılaştırma/mantık/bit | MIR_COLOR         | MIR_COLOR         |
| I/O                           | MIR_LOCATE        | MIR_LOCATE        |
| Karşılaştırma/mantık/bit | MIR_STR_NEW       | MIR_STR_NEW       |
| String                        | MIR_STR_ASSIGN    | MIR_STR_ASSIGN    |
| String                        | MIR_STR_CONCAT    | MIR_STR_CONCAT    |
| Karşılaştırma/mantık/bit | MIR_STR_LEN       | MIR_STR_LEN       |
| Karşılaştırma/mantık/bit | MIR_STR_LEFT      | MIR_STR_LEFT      |
| String                        | MIR_STR_RIGHT     | MIR_STR_RIGHT     |
| String                        | MIR_STR_MID       | MIR_STR_MID       |
| String                        | MIR_STR_COMPARE   | MIR_STR_COMPARE   |
| Karşılaştırma/mantık/bit | MIR_ARRAY_NEW     | MIR_ARRAY_NEW     |
| Veri/bellek                   | MIR_ARRAY_LOAD    | MIR_ARRAY_LOAD    |
| Karşılaştırma/mantık/bit | MIR_ARRAY_STORE   | MIR_ARRAY_STORE   |
| Karşılaştırma/mantık/bit | MIR_OBJECT_NEW    | MIR_OBJECT_NEW    |
| Veri/bellek                   | MIR_FIELD_LOAD    | MIR_FIELD_LOAD    |
| Karşılaştırma/mantık/bit | MIR_FIELD_STORE   | MIR_FIELD_STORE   |
| Veri/bellek                   | MIR_MEM_LOAD      | MIR_MEM_LOAD      |
| Karşılaştırma/mantık/bit | MIR_MEM_STORE     | MIR_MEM_STORE     |
| Veri/bellek                   | MIR_MEM_COPY      | MIR_MEM_COPY      |
| Veri/bellek                   | MIR_MEM_FILL      | MIR_MEM_FILL      |


## Kısa kritik notlar

- Lexer yüzeyinde `BYTE` yok; `I8/U8` var.
- `PARALEL` kanonik yazım olarak lexer/parser yüzeyinde var; `PARALLEL` görünmüyor.
- `RUN` keyword olarak yok; CLI verb `run` var. Dil içi dış komut için `SHELL` var.
- `EXEC` keyword olarak yok.
- `IMPORT` parser path policy içinde `C/CPP/CXX/ASM/NASM/HEADER/INCLUDE` kaynak dillerini kabul ediyor.
- Aşama 5 task/slot/trigger yüzeyi AST node ve test build çıktılarında yerleşmiş görünüyor.

 
