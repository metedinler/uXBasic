# Kaynak Gerçekliği ve Kanıt Haritası

Bu kitap `12.06_1` çalışan kaynak baskısını esas alır. Kitapta bir özellik “çalışmıyor” diliyle anlatılmaz; özellik hangi katmanda yürüyorsa o katman yazılır. Bu yaklaşım hem dili sahiplenir hem de teknik dürüstlüğü korur. Bir komut AST yorumlayıcıda, başka bir komut MIR yorumlayıcıda, başka bir hedef JS/WAT/WASM veya x64 üretiminde anlam kazanabilir.

## Kaynak yüzeyi özeti

| Alan | Gözlenen sayı | Kaynak dosya |
|---|---:|---|
| Benzersiz lexer keyword / yüzey sözcüğü | 220 | `src/parser/lexer/lexer_keyword_table.fbs` |
| Statement dispatch girişi | 79 | `src/parser/parser/parser_stmt_registry.fbs` |
| AST node sabiti | 142 | `src/parser/ast_node_kinds.fbs` |
| Runtime service ID | 83 | `src/runtime/services/runtime_service_ids.fbs` |
| CLI seçenek adı | 167 | `src/cli/cli_registry_adim41.fbs` |
| Project pack | 30 | `xtestx/project_packs/_expected/project_pack_manifest.json` |

Bu tablo kitabın ana sınırını çizer. Kitaptaki anahtar kelime, komut, veri tipi, runtime servisi ve CLI anlatımı bu dosyalarla uyumlu tutulur. Eski PCK belgelerinde geçen ama bu kaynak baskısının kanonik kararlarıyla çelişen bilgi ana gövdeye alınmaz.

## Project pack sonucu

`xtestx/project_packs` hattı kitabın çalışan örnek omurgasıdır. Bu paketler yalnız test değil, aynı zamanda kitap için örnek deposudur. Her büyük bölümde mümkün olduğunca bu paketlerden bir örnek alınır, gerekirse büyütülür ve açıklanır.

| Pack | Faz | Görev | Yüzey etiketleri | Beklenen çıktı başlangıcı |
|---|---|---|---|---|
| `pack_01_core_numeric_flow` | `run` | Çekirdek sayısal akış: DIM, AS, atama, aritmetik, PRINT. | `core, numeric, dim, assignment, print` | `30, 35, 70, 55, ...` |
| `pack_02_operators_logic_bit` | `run` | Operatör önceliği ve bit düzeyi işleçler. | `operators, mod, and, or, xor, shl, shr` | `22, 34, 2, 4, ...` |
| `pack_03_strings_builtins` | `run` | Kanonik string fonksiyonları; $ suffix yok. | `strings, len, left, mid, right, lcase, trim, chr, asc` | `7, UXB, XBA, IC, ...` |
| `pack_04_arrays_index_lvalue` | `run` | Dizi indeksleme ve lvalue ataması. | `array, index, lvalue` | `3, 8, 16` |
| `pack_05_control_flow_if_for` | `run` | Kontrol akışı: FOR/NEXT, IF/ELSE, DO WHILE/LOOP. | `if, for, do, while, loop` | `15, BUYUK, 0, 1, ...` |
| `pack_06_functions_recursion_include` | `run` | Fonksiyon, RETURN ve rekürsiyon. | `function, return, recursion` | `15, 120` |
| `pack_07_type_record_structures` | `run` | TYPE kaydı ve alan erişimi. | `type, record, field` | `42, 18` |
| `pack_08_namespace_using_alias` | `run` | NAMESPACE, USING ve ALIAS çağrı çözümleme. | `namespace, using, alias, function` | `30, 15` |
| `pack_09_class_oop_magic` | `ast` | MAGIC HASH ve custom MAGIC parser/AST yüzeyi. Runtime doğal dispatch Fix-14 sonrası ayrıca test edilecek. | `class, magic, hash, custom-magic, operator-magic` | `` |
| `pack_10_file_io_channels` | `run` | # yalnız file I/O kanal numarasıdır; LINE INPUT ve $ yok. | `open, print-file, input-file, close, #-channel` | `101, 202, 303` |
| `pack_11_preprocessor_meta` | `run` | Temel preprocessor meta komutları. | `preprocessor, set, define, eval, if` | `META_ON, 20, UXB` |
| `pack_12_preprocessor_include_foreach` | `run` | INCLUDE .uxbh başlık kullanımı; foreach iddiası yok. | `include, uxbh, const, function` | `42, 12` |
| `pack_13_import_c_cpp_asm` | `ast` | IMPORT yalnız C/CPP/ASM derleme zamanı kaynak rotasıdır; DLL/API değildir. | `import, c, cpp, asm` | `` |
| `pack_14_ffi_winapi_routes` | `run` | CALL(DLL,...) route smoke; gerçek DLL yükleme değil. | `declare, lib, alias, call-dll, ffi-route` | `FFI14_01, FFI14_02, FFI14_03, FFI14_04, ...` |
| `pack_15_science_external_routes` | `ast` | CALL(API,...) parser/AST yüzeyi; runtime servis davranışı ayrı test edilecek. | `call-api, json, regex, library-route` | `` |
| `pack_16_big_extfp_canonical` | `run` | Büyük sayı ailesi yüzeyi. | `biginit, bigi, bigint, bigd, bigf, ball` | `12345, 23456, 12.50, 3.5, ...` |
| `pack_17_memory_ptr_intrinsics` | `ast` | Bellek intrinsics parser/AST yüzeyi; güvenli runtime davranışı Fix sonrası ayrı test. | `poke, peek, memory` | `` |
| `pack_18_event_thread_pipe_slot` | `ast` | EVENT/THREAD/PIPE/PARALEL bloklarında normal uXBasic gövde parse edilir; runtime dispatch ayrı. | `event, thread, pipe, paralel, slot, trigger` | `` |
| `pack_19_browser_wasm_webgpu_route` | `run` | WEB/BROWSER/JS hedefinde RUNTIME JS bloğu serbesttir; raw hedefsiz JS negatifte kalır. | `target-web, html-begin, js-begin-runtime, browser` | `WEB_ROUTE, WASM_READY` |
| `pack_20_module_main_using` | `ast` | MODULE ve MAIN parser/AST yüzeyi. | `module, main, using, function` | `` |
| `pack_21_input_line_file` | `run` | LINE INPUT ve $ yok; kanonik INPUT # kanal testi. | `input-file, print-file, #-channel` | `165` |
| `pack_22_error_try_catch_surface` | `ast` | TRY/CATCH/FINALLY parser yüzeyi. | `try, catch, finally` | `` |
| `pack_23_data_structures_list_dict_set` | `ast` | Veri yapısı tip adları yüzeyi; runtime koleksiyon API ayrı. | `array-type, list, dict, set` | `` |
| `pack_24_math_time_random_surface` | `run` | Deterministik matematik fonksiyonları; TIMER/RND exact stdout testine konmadı. | `abs, int, sgn, sqr` | `9, 12, -1, 0, ...` |
| `pack_25_nested_calls_expressions` | `run` | İç içe fonksiyon çağrıları ve ifade değerlendirme. | `nested-calls, function, expression` | `15, 21, 3` |
| `pack_26_negative_raw_js_gate` | `run` | TARGET WEB/BROWSER/JS olmadan raw JS fail-close kalmalıdır. | `negative, raw-js-gate` | `` |
| `pack_27_negative_include_cycle` | `preprocess` | INCLUDE döngüsü hata vermelidir. | `negative, include-cycle` | `` |
| `pack_28_negative_semantic_unknown_symbol` | `semantic` | Bilinmeyen sembol hata vermelidir. | `negative, semantic, unknown-symbol` | `` |
| `pack_29_negative_wrong_keywords` | `ast` | Yanlış keywordler reddedilir: THREAT, PARALLEL, SIHIRLIMETOT. | `negative, wrong-keyword, thread, paralel, magic` | `` |
| `pack_30_full_integration_project` | `run` | Çalışan katmanlardan kanonik entegrasyon smoke testi. | `full, integration, preprocessor, include, import, type, array, string, big, namespace, alias` | `900, 30, 103, 15, ...` |

## Kanıt seviyesinin kitap dili

Bu kitapta “şu özellik yok” dili kullanılmaz. Bunun yerine şu katman dili kullanılır:

| Katman | Kitaptaki anlamı |
|---|---|
| Preprocess | Kaynak kod derleyiciye gitmeden önce dönüştürülür, koşullu bloklar ve hedef dosyalar hazırlanır. |
| Lexer | Sözcükler token yüzeyinde tanınır. Keyword, operatör ve literal sınırları bu katmanda belirlenir. |
| Parser / AST | Kaynak sözdizimi AST düğümlerine dönüşür. Komutun kaynak anlamı burada taşınır. |
| Semantic | Tip, sembol, kapsam, çağrı ve hata kapıları denetlenir. |
| MIR | Kod üretimi ve hedefe indirme için daha düz ara temsil kurulur. |
| AST Interpreter | AST üzerinden doğrudan çalışma yoludur. |
| MIR Interpreter | MIR üzerinden çalışma yoludur. |
| Runtime | Dosya, bellek, DLL, API, string, matematik, web ve dış sistem çağrıları servisleştirilir. |
| JS / WAT / WASM / x64 | MIR destekli hedef üretim hatlarıdır. x64 üretim MIR seviyesindedir; AST’den destek alabilir. |

Bu dil, kitabı hem güvenli hem de sahiplenen bir teknik metin yapar. Özellik çalışır kabul edilir; ancak hangi yoldan çalıştığı açıkça yazılır.
