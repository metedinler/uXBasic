# Adım 50 - Önceki ZIPlerden kaldırılan sembol/değişken bağlantı analizi

Taban seri: src(30.05_1).zip → son zip: src(31.05_3).zip. Bu analiz önceki ZIPlerde tanımlı olup son ZIPte aynı isimle tanımı kalmayan sembolleri inceler.

## Kısa hüküm

- Dosya eksikliği değil, API/sözleşme eksilmesi var.
- En tehlikeli eksilmeler: hedef sabitleri, FFI registry, PRINT #, WHILE, text builtin dispatch ve file line input.
- En güvenli geri alma kaynağı çoğunlukla `src(31.05_2).zip`; çünkü sembollerin çoğu son kez orada sağlam duruyor.

## Kritik/Yüksek geri alma tablosu

| Sembol | Tür | Risk | Amaç / bağlantı | Son zipte durum | Karar | Alınacak zip | Dosya | Uygulama |
|---|---|---|---|---|---|---|---|---|
| ASTK_PARALEL_STMT | CONST | YUKSEK | Kanonik PARALEL AST sabiti. | Son zipte ASTK_PARALLEL_STMT diye İngilizce yanlış değişken adı var, değer PARALEL_STMT. Kullanıcının kararına göre PARALEL doğru, PARALLEL yüzey hatalı. | EKLENMELI | src(31.05_2).zip | src/parser/ast_node_kinds.fbs | ASTK_PARALEL_STMT aliası geri eklenmeli; ASTK_PARALLEL_STMT varsa sadece geriye uyumluluk aliası olmalı. |
| ASTK_PRINT_FILE_STMT | CONST | KRITIK | PRINT # kanal yazma AST düğümü. | Son zipte PRINT_FILE_STMT hiç yok; PRINT # yürütme hattı kaybolmuş. | EKLENMELI | src(31.05_2).zip | src/parser/ast_node_kinds.fbs; src/parser/ast_contract_registry.fbs; src/parser/ast_contract_layer_bindings.fbs | Const + contract kayıtları geri eklenmeli; tek dosya yetmez. |
| ExecEvalBuiltinTextCategory | FUNCTION | KRITIK | UCASE/LCASE/LEFT/RIGHT/MID/LTRIM/RTRIM/TRIM/INSTR/STR/CHR/SPACE/STRING builtinlerini interpreter’da yürütür. | Son zipte dispatch bu çağrıları artık desteklemiyor; JS runtime’da karşılıklar var ama AST/MIR interpreter eksik. | EKLENMELI | src(31.05_2).zip | src/runtime/exec/exec_eval_builtin_categories.fbs + src/runtime/memory_exec.fbs | Fonksiyon fragmanı ve memory_exec içindeki Case string builtin dispatch satırı geri eklenmeli. |
| ExecRunPrintFileStmt | FUNCTION | KRITIK | Runtime’da PRINT # kanal yazma yürütücüsü. | Son zipte ExecRunPrintStmt var ama PRINT # yok. | EKLENMELI | src(31.05_2).zip | src/runtime/exec/exec_stmt_io_file.fbs | Fonksiyon ve dispatcher Case PRINT_FILE_STMT beraber geri eklenmeli. |
| ExecRunWhileStmt | FUNCTION | YUKSEK | Standalone WHILE runtime yürütücüsü. | Son zipte DO/LOOP yürütücü var, WHILE_STMT yok. | EKLENMELI | src(31.05_2).zip | src/runtime/exec/exec_stmt_flow.fbs | WHILE parser geri gelirse runtime da dönmeli. |
| gUXBFFIRegistry | GLOBAL | KRITIK | FFI sözleşmelerinin global registry dizisi. | Son zipte eşdeğer tablo yok; sadece runtime service dispatch var. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ailesiyle birlikte dönmeli. |
| gUXBFFIRegistryCount | GLOBAL | KRITIK | FFI registry kayıt sayacı. | Son zipte eşdeğer sayaç yok. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ailesiyle birlikte dönmeli. |
| ParseWhileStmt | FUNCTION | YUKSEK | Standalone WHILE ... WEND/END WHILE parser hattı. | Son zipte DO WHILE var ama WHILE_STMT yok. Dil yüzeyinde WHILE isteniyorsa kırılır. | EKLENMELI | src(31.05_2).zip | src/parser/parser.fbs; src/parser/parser/parser_stmt_flow.fbs; src/parser/parser/parser_stmt_registry.fbs | Declare + parser function + registry handler birlikte dönmeli. |
| SEM_E_INVALID_SLOT_RANGE | CONST | ORTA | Semantic slot range/target hata kodu. | Son zipte slot hataları string ile başka katmanlarda var ama merkezi kod yok. | EKLENMELI | src(31.05_2).zip | src/semantic/semantic_error_codes.fbs | Slot semantic testleri merkezi hata kodu bekliyorsa geri ekle. |
| STMT_HANDLER_WHILE | CONST | YUKSEK | Parser registry içinde WHILE dispatch sabiti. | Son zipte yok; WHILE tokenı parse edilmez. | EKLENMELI | src(31.05_2).zip | src/parser/parser/parser_stmt_registry.fbs | ParseWhileStmt ile birlikte dönmeli. |
| UXB_FFI_REGISTRY_MAX | CONST | KRITIK | FFI registry kapasitesi. | FFIContract ailesi geri alınırsa şart. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ile birlikte dönmeli. |
| UXB_MIR_OPCODE_MIR_PARALEL_HINT | CONST | YUKSEK | Kanonik PARALEL MIR metadata op sabiti. | Son zipte UXB_MIR_OPCODE_MIR_PARALLEL_HINT var; değer de MIR_PARALLEL_HINT. Bu senin kanonik kararına aykırı. | EKLENMELI | src(31.05_2).zip | src/mir/mir_opcode.fbs | UXB_MIR_OPCODE_MIR_PARALEL_HINT geri eklenmeli; PARALLEL varyantı sadece alias olmalı veya kaldırılmalı. |
| UXB_TARGET_WAT | CONST | KRITIK | Web/WASM hedef ayrımı; WAT üretimi ve coverage gate bunu hâlâ kullanıyor. | Son zipte sabit yok ama 3 yerde referans var; derleme kırılma riski kesin. Final referans: 3 | EKLENMELI | src(31.05_2).zip | src/backend/common/backend_target.fbs | Tam dosya alma yerine UXB_TARGET_WAT sabitini ve Case UXB_TARGET_WAT kabulünü 31.05_3 dosyasına geri ekle; WAT aliası WASM’a normalize edilebilir ama sabit korunmalı. |
| UXB_TARGET_X86 | CONST | KRITIK | x86 backend hedef adı; x86 pipeline ve x86 backend_step6 hâlâ kullanıyor. | Son zipte sabit yok ama 3 yerde referans var; x86 hattı kırılır. Final referans: 3 | EKLENMELI | src(31.05_2).zip | src/backend/common/backend_target.fbs | UXB_TARGET_X86 sabitini, normalize ve known/native hedef listesine geri ekle. |
| UXBFFIContract | TYPE | KRITIK | DLL/API/CALL FFI sözleşmesini taşıyan kayıt tipi. | Son zipte parser_ffi_import_contract_adim15.fbs hâlâ UXBFFIContract istiyor; runtime/ffi_registry.fbs sadece boş bridge. Final referans: 1 | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | En güvenlisi 31.05_2 dosyasını compatibility registry olarak geri almak; en alta #include once "ffi/runtime_ffi.fbs" eklenebilir. |
| UXBFFIRegistryAdd | FUNCTION | YUKSEK | FFI contract kaydı ekleme. | Registry ailesi yoksa FFI manifest/contract eksik kalır. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryContractToCsvRow | FUNCTION | ORTA | FFI rapor/manifest CSV satırı üretimi. | Temel derlemeyi kırmaz ama rapor zinciri eksik kalır. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI raporları isteniyorsa dönmeli. |
| UXBFFIRegistryFind | FUNCTION | YUKSEK | FFI contract arama. | Registry ailesi yoksa resolve zayıflar. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryMakeContract | FUNCTION | KRITIK | Parser tarafında DECLARE/CALL FFI sözleşmesini doğrulayıp contract üretir. | Son zipte bu fonksiyon adı hâlâ çağrılıyor; tanım yok. Final referans: 1 | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | Tam FFI registry geri alınmalı veya aynı imzayla wrapper yazılmalı. |
| UXBFFIRegistryReset | SUB | ORTA | FFI registry temizleme/test izolasyonu. | Son zipte yok; test koşularında kalıntı önleme zayıflar. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryResolveCall | FUNCTION | KRITIK | LLAMA/LUA gibi native library çağrılarını registry üzerinden çözer. | Son zipte runtime_library_registry_adim15 içinde string olarak hâlâ kullanılıyor; tanım yok. Final referans: 2 | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | Tam FFI registry geri alınmalı. |
| UXBFFIRegistrySame | FUNCTION | ORTA | FFI registry duplicate/same contract kontrolü. | Sadece registry iç helper; aile geri alınırsa gerekir. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | FFI registry dosyasıyla birlikte dönmeli. |
| UXBFFITargetIsNative | FUNCTION | YUKSEK | FFI çağrısının native hedefte çalışıp çalışamayacağını kontrol eder. | runtime_ffi içinde benzeri kontrol var ama eski imza yok. | EKLENMELI | src(31.05_2).zip | src/runtime/ffi_registry.fbs | Eski imzayı compatibility wrapper olarak koru. |
| UxbFileEnsureParentDirectory | SUB | ORTA | Dosya açarken parent klasör oluşturma. | Son zipte yok; OPEN OUTPUT ile alt klasör yazma kırılabilir. | EKLENMELI | src(31.05_2).zip | src/runtime/file_io.fbs | file_io ile birlikte geri alınmalı. |
| UxbFileInputLine | FUNCTION | YUKSEK | INPUT#/LINE INPUT# için satır okuma. | Son zipte UxbFileGetI32 var; satır/metin okuma yok. | EKLENMELI | src(31.05_2).zip | src/runtime/file_io.fbs | Tam 31.05_2 file_io.fbs daha geniş görünüyor; en güvenli kaynak 31.05_2. |

## Tüm kaldırılan semboller

| Sembol | Tür | Son görüldüğü zip | Eski dosya | Risk | Karar | Uygulama |
|---|---|---|---|---|---|---|
| ASTK_PARALEL_STMT | CONST | src(31.05_2).zip | src/parser/ast_node_kinds.fbs | YUKSEK | EKLENMELI | ASTK_PARALEL_STMT aliası geri eklenmeli; ASTK_PARALLEL_STMT varsa sadece geriye uyumluluk aliası olmalı. |
| ASTK_PRINT_FILE_STMT | CONST | src(31.05_2).zip | src/parser/ast_node_kinds.fbs | KRITIK | EKLENMELI | Const + contract kayıtları geri eklenmeli; tek dosya yetmez. |
| ExecEvalBuiltinTextCategory | FUNCTION | src(31.05_2).zip | src/runtime/exec/exec_eval_builtin_categories.fbs | KRITIK | EKLENMELI | Fonksiyon fragmanı ve memory_exec içindeki Case string builtin dispatch satırı geri eklenmeli. |
| ExecRunPrintFileStmt | FUNCTION | src(31.05_2).zip | src/runtime/exec/exec_stmt_io_file.fbs | KRITIK | EKLENMELI | Fonksiyon ve dispatcher Case PRINT_FILE_STMT beraber geri eklenmeli. |
| ExecRunWhileStmt | FUNCTION | src(31.05_2).zip | src/runtime/exec/exec_stmt_flow.fbs | YUKSEK | EKLENMELI | WHILE parser geri gelirse runtime da dönmeli. |
| gUXBFFIRegistry | GLOBAL | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | FFI registry ailesiyle birlikte dönmeli. |
| gUXBFFIRegistryCount | GLOBAL | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | FFI registry ailesiyle birlikte dönmeli. |
| IsEndClassRoutineStart | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_class_method.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| MIRX64CompareCondCode | FUNCTION | src(31.05_2).zip | src/codegen/x64/mir_x64_register_allocator.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| ParseOptionalSlotControlSuffix | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_event_pipe.fbs | ORTA | GEREK_YOK | Eski fonksiyonu geri alma; yeni parser korunmalı. Sadece regresyon testi yaz. |
| ParseWhileStmt | FUNCTION | src(31.05_2).zip | src/parser/parser.fbs | YUKSEK | EKLENMELI | Declare + parser function + registry handler birlikte dönmeli. |
| SEM_E_INVALID_SLOT_RANGE | CONST | src(31.05_2).zip | src/semantic/semantic_error_codes.fbs | ORTA | EKLENMELI | Slot semantic testleri merkezi hata kodu bekliyorsa geri ekle. |
| Step3FindAncestorClassNode | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | ORTA | GEREK_YOK | Geri alma; yeni scope/symbol çözümü korunmalı. |
| Step3FindOwnerNode | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | DUSUK | GEREK_YOK | Geri alma. |
| Step3HasNamedNode | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | DUSUK | GEREK_YOK | Geri alma. |
| Step3ImplicitClassFieldExists | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | ORTA | GEREK_YOK | Geri alma; class field testleriyle doğrula. |
| Step3ImplicitClassFieldType | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | ORTA | GEREK_YOK | Geri alma; test gerekir. |
| Step3ValidateSlotControlTarget | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step3_gate.fbs | ORTA | TESTE_BAGLI | Slot negatif testleri semantic aşamada hata bekliyorsa geri ekle; yoksa yeni MIR/runtime doğrulaması yeterli. |
| STMT_HANDLER_WHILE | CONST | src(31.05_2).zip | src/parser/parser/parser_stmt_registry.fbs | YUKSEK | EKLENMELI | ParseWhileStmt ile birlikte dönmeli. |
| UXB_FFI_REGISTRY_MAX | CONST | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | FFI registry ile birlikte dönmeli. |
| UXB_JS_FB_DIRECTORY_ATTR | CONST | src(31.05_2).zip | src/codegen/js/js_emitter.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXB_MIR_OPCODE_MIR_PARALEL_HINT | CONST | src(31.05_2).zip | src/mir/mir_opcode.fbs | YUKSEK | EKLENMELI | UXB_MIR_OPCODE_MIR_PARALEL_HINT geri eklenmeli; PARALLEL varyantı sadece alias olmalı veya kaldırılmalı. |
| UXB_RUNTIME_FFI_REGISTRY_FBS | DEFINE | src(31.05_2).zip | src/runtime/ffi_registry.fbs | DUSUK | GEREK_YOK | Eski dosya komple alınırsa guard da gelir; ayrıca işlem gerekmez. |
| UXB_TARGET_WAT | CONST | src(31.05_2).zip | src/backend/common/backend_target.fbs | KRITIK | EKLENMELI | Tam dosya alma yerine UXB_TARGET_WAT sabitini ve Case UXB_TARGET_WAT kabulünü 31.05_3 dosyasına geri ekle; WAT aliası WASM’a normalize edilebilir ama sabit korunmalı. |
| UXB_TARGET_X86 | CONST | src(31.05_2).zip | src/backend/common/backend_target.fbs | KRITIK | EKLENMELI | UXB_TARGET_X86 sabitini, normalize ve known/native hedef listesine geri ekle. |
| UXB_WASM_FB_DIRECTORY_ATTR | CONST | src(31.05_2).zip | src/codegen/wasm/wasm_emitter.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBAstAdim04GateIsValidIndex | FUNCTION | src(31.05_2).zip | src/parser/ast_contract_gate_adim04.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBAstAdim04IsValidIndex | FUNCTION | src(31.05_2).zip | src/parser/ast_child_accessors.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBAstAdim04ModelIsValidIndex | FUNCTION | src(31.05_2).zip | src/parser/ast_contract_child_model.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBAstAdim04RawChildCount | FUNCTION | src(31.05_2).zip | src/parser/ast_child_accessors.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBAstNodeKindIsValidIndex | FUNCTION | src(31.05_2).zip | src/parser/ast_node_kind_id.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBClassDeclMatchKeywordLike | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_core.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBClassDeclTokenCanBeParamName | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_core.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBClassDeclTokenTextIs | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_core.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBDeclMatchKeywordLike | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_proc.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBDeclTokenCanBeParamName | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_proc.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBDeclTokenTextIs | FUNCTION | src(31.05_2).zip | src/parser/parser/parser_stmt_decl_proc.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBFFIContract | TYPE | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | En güvenlisi 31.05_2 dosyasını compatibility registry olarak geri almak; en alta #include once "ffi/runtime_ffi.fbs" eklenebilir. |
| UXBFFIRegistryAdd | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | YUKSEK | EKLENMELI | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryContractToCsvRow | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | ORTA | EKLENMELI | FFI raporları isteniyorsa dönmeli. |
| UXBFFIRegistryFind | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | YUKSEK | EKLENMELI | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryMakeContract | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | Tam FFI registry geri alınmalı veya aynı imzayla wrapper yazılmalı. |
| UXBFFIRegistryReset | SUB | src(31.05_2).zip | src/runtime/ffi_registry.fbs | ORTA | EKLENMELI | FFI registry ailesiyle dönmeli. |
| UXBFFIRegistryResolveCall | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | KRITIK | EKLENMELI | Tam FFI registry geri alınmalı. |
| UXBFFIRegistrySame | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | ORTA | EKLENMELI | FFI registry dosyasıyla birlikte dönmeli. |
| UXBFFITargetIsNative | FUNCTION | src(31.05_2).zip | src/runtime/ffi_registry.fbs | YUKSEK | EKLENMELI | Eski imzayı compatibility wrapper olarak koru. |
| UxbFileEnsureParentDirectory | SUB | src(31.05_2).zip | src/runtime/file_io.fbs | ORTA | EKLENMELI | file_io ile birlikte geri alınmalı. |
| UxbFileInputLine | FUNCTION | src(31.05_2).zip | src/runtime/file_io.fbs | YUKSEK | EKLENMELI | Tam 31.05_2 file_io.fbs daha geniş görünüyor; en güvenli kaynak 31.05_2. |
| UXBNasmReplaceAll | FUNCTION | src(31.05_2).zip | src/codegen/x64/nasm/nasm_writer.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBStep3FindOwningClassScopeForNode | FUNCTION | src(30.05_3).zip | src/type_binding/type_infer_expr.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBStep3TextReplaceAll | FUNCTION | src(31.05_2).zip | src/type_binding/type_ffi_signature.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBStep3TryInferImplicitClassField | FUNCTION | src(30.05_3).zip | src/type_binding/type_infer_expr.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBStep5FindSymbolByAstNode | FUNCTION | src(31.05_2).zip | src/semantic/semantic_hir_layout_bridge.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |
| UXBStep5ReplaceAll | FUNCTION | src(31.05_2).zip | src/semantic/semantic_step5_json.fbs | DUSUK | GEREK_YOK | Geri alma; sadece ilgili özellik testinde kırılma çıkarsa fragman incelenir. |