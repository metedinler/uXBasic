# Adım 50 – `src` ZIP taban-son özellik ve kayıp analizi

Bu raporda taban `src(30.05_1).zip`, son paket `src(31.05_3).zip` kabul edilmiştir. Karşılaştırma dosya adı, açılmış boyut, CRC ve sembol taramasına göre yapılmıştır.

## 1. Net hüküm

- Son paket `src(31.05_3).zip` içinde tabana göre **eksik dosya yoktur**.
- Son paket, önceki tüm src ziplerinde görülen dosya adları açısından da **eksik dosya üretmemektedir**.
- Dosya sayısı tabandan sona **469 → 485** olmuştur; net **+16 dosya** vardır.
- İçerik düzeyinde tabana göre **68 büyüyen**, **24 küçülen**, **16 yeni** dosya vardır.
- Son aşamada `src(31.05_2)` → `src(31.05_3)` geçişinde dosya ekleme/silme yoktur; ama **93 dosya değişmiştir** ve açılmış boyut **18.888 byte küçülmüştür**. Bu yüzden son paket “eksik dosya” değil, “bazı uygulama/sözleşme parçaları sadeleşmiş veya geriye alınmış olabilir” şeklinde okunmalıdır.

## 2. Kronolojik ZIP özeti

| Sıra | ZIP | Dosya | Açılmış MB | Son iç tarih |
|---:|---|---:|---:|---|
| 1 | `src(30.05_1).zip` | 469 | 3.198 | 2026-05-30 00:50:36 |
| 2 | `src(30.05_2).zip` | 476 | 3.232 | 2026-05-30 01:20:08 |
| 3 | `src(30.05_3).zip` | 476 | 3.244 | 2026-05-30 04:40:20 |
| 4 | `src(30.05_4).zip` | 478 | 3.312 | 2026-05-30 21:31:14 |
| 5 | `src(30.05_5).zip` | 482 | 3.378 | 2026-05-30 21:31:14 |
| 6 | `src(31.05_0).zip` | 485 | 3.542 | 2026-05-31 03:22:58 |
| 7 | `src(31.05_1).zip` | 485 | 3.542 | 2026-05-31 03:22:58 |
| 8 | `src(31.05_2).zip` | 485 | 3.542 | 2026-05-31 03:22:58 |
| 9 | `src(31.05_3).zip` | 485 | 3.524 | 2026-05-31 07:43:46 |

## 3. Sıralı değişim akışı

| Önceki | Sonraki | Eklenen | Silinen | Değişen | Açılmış fark MB | Yorum |
|---|---|---:|---:|---:|---:|---|
| `src(30.05_1).zip` | `src(30.05_2).zip` | 7 | 0 | 2 | 0.034 | ekleme/çıkarma/değişim var |
| `src(30.05_2).zip` | `src(30.05_3).zip` | 0 | 0 | 17 | 0.012 | ekleme/çıkarma/değişim var |
| `src(30.05_3).zip` | `src(30.05_4).zip` | 2 | 0 | 58 | 0.068 | ekleme/çıkarma/değişim var |
| `src(30.05_4).zip` | `src(30.05_5).zip` | 4 | 0 | 0 | 0.066 | ekleme/çıkarma/değişim var |
| `src(30.05_5).zip` | `src(31.05_0).zip` | 3 | 0 | 19 | 0.164 | ekleme/çıkarma/değişim var |
| `src(31.05_0).zip` | `src(31.05_1).zip` | 0 | 0 | 0 | 0.0 | içerik aynı |
| `src(31.05_1).zip` | `src(31.05_2).zip` | 0 | 0 | 0 | 0.0 | içerik aynı |
| `src(31.05_2).zip` | `src(31.05_3).zip` | 0 | 0 | 93 | -0.018 | ekleme/çıkarma/değişim var |

## 4. Tabana göre yeni eklenen dosyalar ve görünen amaçları

| Dosya | Boyut | Amaç |
|---|---:|---|
| `src/backend/backend_web_coverage_gate_adim26.fbs` | 1031 | JS/WASM/browser hedeflerinde MIR opcode coverage kapısı |
| `src/cli/cli_backend_route_close_adim27.fbs` | 5363 | 3 harfli CLI komutlarının eski uzun flag sistemindeki karşılıklarını doğrulama kapısı |
| `src/cli/cli_output_contract_adim41.fbs` | 3761 | CLI çıktı dosyası uzantı/path sözleşmesi |
| `src/cli/cli_registry_adim41.fbs` | 62240 | Uzun/kısa CLI seçenekleri için merkezi kayıt tablosu |
| `src/codegen/js/js_mir_opcode_coverage_adim26.fbs` | 5817 | JS backend için MIR opcode coverage doğrulaması |
| `src/codegen/wasm/wasm_mir_opcode_coverage_adim26.fbs` | 4804 | WASM/WAT backend için MIR opcode coverage doğrulaması |
| `src/common/error_system_adim45.fbs` | 14670 | Merkezi hata sistemi, katalog, dil ve log döndürme sistemi |
| `src/error_i18n_seed_from_logs.csv` | 115549 | Loglardan üretilmiş hata mesajı/dil seed verisi |
| `src/error_i18n_template.csv` | 180 | Hata i18n şablonu |
| `src/main_backend_close_gate_adim27.fbs` | 2555 | AST/MIR/web/CLI kapanış kapılarını ana hatta bağlama |
| `src/main_cli_bridge_adim41.fbs` | 1206 | CLI argüman normalizasyon köprüsü |
| `src/main_output_contract_bridge_adim41_ext.fbs` | 1362 | CLI çıktı yazma sözleşmesi köprüsü |
| `src/preprocessor/preprocess_meta_eval_adim34.fbs` | 3663 | Meta preprocessor eval/hash/base64/html-json escape yardımcıları |
| `src/preprocessor/preprocess_meta_model.fbs` | 8506 | MetaBlock/MetaAsset/WatImport/Manifest preprocess veri modeli |
| `src/semantic/ast_mir_coverage_gate_adim25.fbs` | 8370 | AST node → MIR opcode coverage kapısı |
| `src/semantic/ast_mir_route_table_adim25.fbs` | 7213 | AST node yaşam yolu ve beklenen MIR opcode ailesi sözleşmesi |

## 5. Eklenen özellik aileleri

1. **AST → MIR yaşam yolu / coverage hattı:** `ast_mir_route_table_adim25` ve `ast_mir_coverage_gate_adim25` ile her AST düğümünün MIR tarafında karşılığı var mı denetlenmeye başlanmış.
2. **JS/WASM/browser hedef coverage hattı:** JS ve WASM için MIR opcode coverage kapıları eklenmiş; browser hedefinin native yüzeyden ayrılması amaçlanmış.
3. **CLI tam sözleşme hattı:** Adım 27 ve Adım 41 ile `lex/par/ast/sem/hir/mir/int/x64/x86/jsw/wat/...` gibi kısa komutların uzun seçeneklere bağlanması ve çıktı dosyalarının doğrulanması eklenmiş.
4. **Preprocessor meta-artifact sistemi:** `%%` blokları, asset, WAT import, manifest, config/hash/base64/eval gibi derleme zamanı meta üretim modeli eklenmiş.
5. **Merkezi hata sistemi:** Adım 45 ile hata kataloglama, dil dosyası, log döndürme ve sınıflandırılmış hata mesajı altyapısı eklenmiş.
6. **Tip bağlama ve BIGINIT/SIZEOF hattı:** `type_infer_expr` ve `type_check_call` tarafında BIGINIT tür denetimi, string argüman kontrolü ve çağrı dönüş tipi bağlama güçlendirilmiş görünüyor.
7. **Event/thread/pipe/slot parser hattı:** `parser_stmt_event_pipe` son pakette büyümüş; basit runtime decl, slot control ve end-block bakışı eklenmiş.

## 6. Tabana göre dosya kaybı

Taban `src(30.05_1)` içinde olup son `src(31.05_3)` içinde olmayan dosya sayısı: **0**.

## 7. Fakat sembol/API kaybı ve riskler

- Tabana göre kaldırılmış/sembol adı değişmiş öğe sayısı: **25**.
- Bir önceki `src(31.05_2)` paketine göre kaldırılmış/sembol adı değişmiş öğe sayısı: **52**.
- Bunların bir kısmı bilinçli sadeleştirme olabilir; ancak aşağıdaki semboller son pakette hâlâ referanslandığı için **gerçek kırılma riski** taşır:

| Kaldırılmış sembol | Eski dosya | Son pakette referanslandığı yer | Satır |
|---|---|---|---:|
| `UXB_TARGET_WAT` | `backend/common/backend_target.fbs` | `backend/backend_web_coverage_gate_adim26.fbs` | 23 |
| `UXB_TARGET_WAT` | `backend/common/backend_target.fbs` | `backend/backend_web_pipeline.fbs` | 41 |
| `UXB_TARGET_X86` | `backend/common/backend_target.fbs` | `backend/backend_pipeline_gate.fbs` | 54 |
| `UXB_TARGET_X86` | `backend/common/backend_target.fbs` | `codegen/x86/x86_backend_step6.fbs` | 42 |
| `UXBFFIContract` | `runtime/ffi_registry.fbs` | `parser/parser/parser_ffi_import_contract_adim15.fbs` | 9 |
| `UXBFFIRegistryMakeContract` | `runtime/ffi_registry.fbs` | `parser/parser/parser_ffi_import_contract_adim15.fbs` | 10 |
| `UXBFFIRegistryResolveCall` | `runtime/ffi_registry.fbs` | `runtime/services/runtime_library_registry_adim15.fbs` | 40 |

Bunlara göre kesin riskler:

- `UXB_TARGET_WAT` kaldırılmış ama `backend_web_coverage_gate_adim26.fbs` ve `backend_web_pipeline.fbs` hâlâ kullanıyor. Çözüm: ya sabit geri konmalı ya da tüm yerler `UXB_TARGET_WASM` ile normalize edilmeli.
- `UXB_TARGET_X86` kaldırılmış ama `backend_pipeline_gate.fbs` ve `codegen/x86/x86_backend_step6.fbs` hâlâ kullanıyor. X86 hedefi desteklenecekse sabit geri gelmeli; desteklenmeyecekse x86 hattı fail-close yapılmalı.
- `runtime/ffi_registry.fbs` artık yalnız `runtime/ffi/runtime_ffi.fbs` bridge dosyası olmuş; fakat `parser_ffi_import_contract_adim15.fbs` hâlâ `UXBFFIContract` ve `UXBFFIRegistryMakeContract` bekliyor. Bu derleme kırabilir.
- `runtime/services/runtime_library_registry_adim15.fbs`, string olarak `UXBFFIRegistryResolveCall` adını hâlâ kullanıyor. Yeni FFI dispatch modeline bağlanmamışsa runtime library registry boşa düşer.

## 8. Son paket `31.05_3`te küçülen/kaybolmuş olabilecek davranışlar

Dosya silinmedi ama bazı uygulama parçaları kaldırılmış veya bridge’e indirgenmiş görünüyor:

| Alan | Gözlem | Risk |
|---|---|---|
| FFI registry | `UXBFFIContract`, `UXBFFIRegistryMakeContract`, `UXBFFIRegistryResolveCall` kaldırılmış/bridge olmuş | DECLARE/CALL DLL/API sözleşmesi kırılabilir |
| File I/O | `UxbFileEnsureParentDirectory`, `UxbFileInputLine` kaldırılmış; OUTPUT/APPEND/BINARY/RANDOM öncesi klasör otomatik oluşturma kalkmış | Dosya yazma ve LINE INPUT davranışı gerileyebilir |
| PRINT # | `ExecRunPrintFileStmt` sembolü kaldırılmış | `PRINT #channel` testi varsa kırılabilir |
| Text builtin | `ExecEvalBuiltinTextCategory` kaldırılmış, text helper küçülmüş | MID/STR/VAL/CHR/ASC vb. kategori dispatch’i başka yere taşınmadıysa bozulabilir |
| WAT/X86 hedef sabitleri | `UXB_TARGET_WAT`, `UXB_TARGET_X86` kaldırılmış ama kullanımı kalmış | Derleme zamanı hata |
| Standalone WHILE | `ParseWhileStmt`, `ExecRunWhileStmt`, `STMT_HANDLER_WHILE` kaldırılmış | `WHILE ... WEND` benzeri ayrı form varsa kaybolmuş olabilir; `DO WHILE` kalmış görünüyor |
| Canonical keyword politikası | Lexer hâlâ `threat`, `parallel`, `sihirlimetot` kabul ediyor | Kullanıcının kanonik kararına aykırı: doğru yüzey `THREAD`, `PARALEL`, `MAGIC` olmalı |

## 9. En son geçişte büyüyen/küçülen ana dosyalar

### `31.05_2` → `31.05_3` büyüyenler
| Dosya | Fark byte |
|---|---:|
| `src/parser/lexer/lexer_preprocess.fbs` | 4323 |
| `src/parser/parser/parser_stmt_event_pipe.fbs` | 2483 |
| `src/type_binding/type_infer_expr.fbs` | 2080 |
| `src/semantic/mir.fbs` | 1774 |
| `src/parser/parser/parser_stmt_decl_core.fbs` | 1428 |
| `src/surface/uxb_surface_registry.fbs` | 903 |
| `src/semantic/hir.fbs` | 884 |
| `src/backend/backend_native_surface_scan.fbs` | 877 |
| `src/codegen/x64/mir_x64_codegen.fbs` | 867 |
| `src/parser/ast_contract.fbs` | 836 |

### `31.05_2` → `31.05_3` küçülenler
| Dosya | Fark byte |
|---|---:|
| `src/semantic/semantic_step3_gate.fbs` | -9718 |
| `src/runtime/exec/exec_eval_builtin_categories.fbs` | -4393 |
| `src/runtime/ffi_registry.fbs` | -4133 |
| `src/runtime/file_io.fbs` | -3242 |
| `src/runtime/exec/exec_stmt_io_file.fbs` | -2964 |
| `src/runtime/exec/exec_eval_text_helpers.fbs` | -2789 |
| `src/runtime/exec/exec_stmt_flow.fbs` | -1645 |
| `src/main_program_entry_part2.fbs` | -1511 |
| `src/parser/parser/parser_stmt_flow.fbs` | -1061 |
| `src/semantic/mir_evaluator_tail_controlflow.fbs` | -933 |

## 10. Adım 50 için önerilen karar

`src(31.05_3).zip` **dosya eksiltmemiştir**, bu yüzden Adım 50 için en güncel aday olarak kullanılabilir. Fakat doğrudan “sağlam release tabanı” demeden önce aşağıdaki küçük kritik yama yapılmalıdır:

1. `UXB_TARGET_WAT` ve `UXB_TARGET_X86` sabitleri/normalize politikası düzeltilmeli.
2. `runtime/ffi_registry.fbs` ya eski registry sözleşmesini korumalı ya da `parser_ffi_import_contract_adim15.fbs` yeni runtime FFI modeline taşınmalı.
3. `PRINT #`, `INPUT LINE`, text builtin ve file parent-dir davranışları için regresyon testi koşulmalı.
4. Lexer/surface sözleşmesinden yanlış eski anahtarlar (`THREAT`, `PARALLEL`, `SIHIRLIMETOT`) ya tamamen kaldırılmalı ya da açıkça hata üretmelidir.

Benim hükmüm: **Kayıp dosya yok; kayıp/bozulma riski dosya değil, sembol ve sözleşme seviyesinde.** En kritik iki risk FFI registry bridge’i ve WAT/X86 sabitlerinin referanslarıdır.