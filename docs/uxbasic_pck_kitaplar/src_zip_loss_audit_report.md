# src.zip Kayıp/Silinen Modül İnceleme Raporu

## Özet karar

Son `src.zip`, `src(30.05_5).zip` tabanına göre **kaynak modül kaybı içeriyor**. Bu yalnız sıkıştırma farkı değil: `src(30.05_5).zip` içinde bulunan **18 kaynak dosya `src.zip` içinde yok**. Ayrıca 73 ortak dosyada içerik değişmiş; en büyük küçülmeler `lexer_preprocess.fbs`, `type_infer_expr.fbs`, `semantic_step3_gate.fbs`, `main_program_entry.fbs` üzerinde.

## Boyut karşılaştırması

| Paket | Zip byte | src dosya sayısı | Açılmış src byte |
|---|---:|---:|---:|
| src(30.05_5).zip | 750,839 | 482 | 3,541,903 |
| src.zip | 702,488 | 464 | 3,318,064 |

`src(30.05_5).zip -> src.zip`: dosya sayısı 482 -> 464; açılmış kaynak boyutu 3,541,903 -> 3,318,064; fark **-223,839 byte**.

## src.zip içinde kaybolan dosyalar

| Dosya | Boyut | Risk | Neden önemli |
|---|---:|---|---|
| `src/backend/backend_native_surface_scan.fbs` | 7,233 | HIGH | native surface tarama/gate |
| `src/backend/backend_web_cli_args.fbs` | 2,645 | HIGH | web hedef CLI argümanları |
| `src/backend/backend_web_context_builder.fbs` | 1,961 | HIGH | web backend context kurulumu |
| `src/backend/backend_web_coverage_gate_adim26.fbs` | 1,031 | HIGH | web coverage gate |
| `src/backend/backend_web_pipeline.fbs` | 6,810 | HIGH | JS/WAT/WASM/browser pipeline çağrısı |
| `src/cli/cli_backend_route_close_adim27.fbs` | 5,363 | HIGH | CLI backend route kapanış/gate |
| `src/cli/cli_output_contract_adim41.fbs` | 3,761 | HIGH | ADIM41 çıktı sözleşmesi |
| `src/cli/cli_registry_adim41.fbs` | 62,400 | HIGH | ADIM41 tam CLI registry + 3 harfli köprü |
| `src/codegen/js/js_mir_opcode_coverage_adim26.fbs` | 5,817 | HIGH | MIR->JS opcode coverage |
| `src/codegen/wasm/wasm_mir_opcode_coverage_adim26.fbs` | 4,804 | HIGH | MIR->WASM opcode coverage |
| `src/main_backend_close_gate_adim27.fbs` | 2,555 | HIGH | main backend close gate |
| `src/main_cli_bridge_adim41.fbs` | 1,206 | HIGH | main CLI bridge |
| `src/main_output_contract_bridge.fbs` | 9,986 | HIGH | output contract gerçek yazıcı köprüsü |
| `src/main_output_contract_bridge_adim41_ext.fbs` | 1,362 | HIGH | ADIM41 output contract extension |
| `src/preprocessor/preprocess_meta_eval_adim34.fbs` | 3,663 | HIGH | ADIM34 meta eval |
| `src/preprocessor/preprocess_meta_model.fbs` | 8,506 | HIGH | preprocessor MetaBlock/PreprocessResult modeli |
| `src/semantic/ast_mir_coverage_gate_adim25.fbs` | 8,370 | HIGH | AST->MIR coverage gate |
| `src/semantic/ast_mir_route_table_adim25.fbs` | 7,213 | HIGH | AST->MIR route table |

## En büyük küçülen ortak dosyalar

| Dosya | Önce | Son | Fark | Yorum |
|---|---:|---:|---:|---|
| `src/parser/lexer/lexer_preprocess.fbs` | 70,057 | 34,826 | -35,231 | yüksek risk |
| `src/type_binding/type_infer_expr.fbs` | 21,304 | 7,631 | -13,673 | yüksek risk |
| `src/semantic/semantic_step3_gate.fbs` | 27,416 | 19,824 | -7,592 | yüksek risk |
| `src/main_program_entry.fbs` | 34,767 | 29,601 | -5,166 | yüksek risk |
| `src/runtime/exec/exec_stmt_io_file.fbs` | 20,533 | 18,124 | -2,409 | yüksek risk |
| `src/main.bas` | 21,597 | 19,711 | -1,886 | yüksek risk |
| `src/main_program_entry_part2.fbs` | 13,205 | 11,436 | -1,769 | yüksek risk |
| `src/runtime/exec/exec_stmt_flow.fbs` | 32,842 | 31,125 | -1,717 | yüksek risk |
| `src/parser/parser/parser_stmt_event_pipe.fbs` | 7,616 | 6,059 | -1,557 | yüksek risk |
| `src/parser/parser/parser_stmt_basic.fbs` | 12,639 | 11,453 | -1,186 | yüksek risk |
| `src/codegen/browser/uxb_browser_artifact_adim14.fbs` | 4,241 | 3,272 | -969 | kontrol gerekli |
| `src/parser/parser/parser_stmt_decl_core.fbs` | 45,470 | 44,647 | -823 | kontrol gerekli |
| `src/parser/parser/parser_stmt_flow.fbs` | 21,035 | 20,287 | -748 | kontrol gerekli |
| `src/parser/parser/parser_stmt_decl_proc.fbs` | 9,591 | 8,880 | -711 | kontrol gerekli |
| `src/codegen/js/js_emitter.fbs` | 9,494 | 8,787 | -707 | kontrol gerekli |

## ADIM45/Copilot ekranı ile src.zip tutarsızlığı

Bugünkü Copilot ekranında ADIM45 için şu dosyalar işlendi/commitlendi deniyor: `error_system_adim45.fbs`, `diagnostics.fbs`, `main.bas`, `main_program_entry.fbs`, `cli_registry_adim41.fbs`, `run_adim45_error_system_gate.ps1`, `error_i18n_template.csv`, `error_i18n_seed_from_logs.csv`. Son `src.zip` içinde bunların kaynak tarafındaki kritik olanları yok veya eski boyutta kaldı.

| Beklenen dosya | src(30.05_5) | src.zip |
|---|---:|---:|
| `src/common/error_system_adim45.fbs` | YOK | YOK |
| `src/runtime/diagnostics.fbs` | 4625 | 4625 |
| `src/main.bas` | 21597 | 19711 |
| `src/main_program_entry.fbs` | 34767 | 29601 |
| `src/cli/cli_registry_adim41.fbs` | 62400 | YOK |
| `src/cli/cli_output_contract_adim41.fbs` | 3761 | YOK |
| `src/main_cli_bridge_adim41.fbs` | 1206 | YOK |
| `src/main_output_contract_bridge_adim41_ext.fbs` | 1362 | YOK |
| `src/error_i18n_template.csv` | YOK | YOK |
| `src/error_i18n_seed_from_logs.csv` | YOK | YOK |

## ADIM36/ADIM45 rapor kanıtı

- 20260531_013737 ADIM36: status=FAIL, fail_count=48, missing_output_count=78, placeholder_count=0.
- ADIM45 sonrası ADIM36: status=FAIL, fail_count=21, missing_output_count=13, placeholder_count=0.
- ADIM45 gate: ok=True, build_exit_code=0, run_exit_code=0, error_log_path=uxb\dist\loglar\adim45_test.hata.log.

## Hüküm

Bu `src.zip` son güvenilir kaynak değildir. ADIM45 raporu PASS olsa bile, gönderilen son `src.zip` ADIM45 dosyalarını taşımıyor ve ADIM25/26/27/34/41 bağlantı dosyalarının bir bölümünü kaybetmiş görünüyor. Bu src üzerine operatör yaması veya ADIM46 uygulanmadan önce eksik modüller geri alınmalı.

## Önerilen güvenli işlem

1. `src.zip` doğrudan ana kaynak yapılmasın.
2. `src(30.05_5).zip` içindeki 18 eksik dosya geri kopyalansın.
3. ADIM45 patch içindeki `src/common/error_system_adim45.fbs`, `src/error_i18n_template.csv`, `src/error_i18n_seed_from_logs.csv` ve `main` bağlantıları tekrar doğrulansın.
4. Sonra önce derleme, sonra ADIM45 gate, sonra ADIM36 gate çalıştırılsın.
5. Operator yamasına ancak bu eksik modül durumu kapandıktan sonra geçilsin.