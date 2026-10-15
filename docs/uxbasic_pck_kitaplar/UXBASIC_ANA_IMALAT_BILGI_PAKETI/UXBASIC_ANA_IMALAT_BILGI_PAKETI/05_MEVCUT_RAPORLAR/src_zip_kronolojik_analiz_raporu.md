# src ZIP kronolojik analiz raporu

Not: ZIP arşivinin gerçek oluşturulma zamanı ZIP formatında güvenilir tek alan olarak saklanmaz; burada sıralama dosya adındaki tarih/sıra (`30.05_1` ... `31.05_3`) ve ZIP içindeki dosya zaman damgalarıyla yapılmıştır.

## 1) ZIP özet tablosu
| sira | zip | arsiv_boyutu_MB | dosya_sayisi | klasor_sayisi | acilmis_boyut_MB | zip_ic_en_yeni_mtime |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | src(30.05_1).zip | 0.678 | 469 | 59 | 3.198 | 2026-05-30 00:50:36 |
| 2 | src(30.05_2).zip | 0.69 | 476 | 59 | 3.232 | 2026-05-30 01:20:08 |
| 3 | src(30.05_3).zip | 0.694 | 476 | 59 | 3.244 | 2026-05-30 04:40:20 |
| 4 | src(30.05_4).zip | 0.706 | 478 | 60 | 3.312 | 2026-05-30 21:31:14 |
| 5 | src(30.05_5).zip | 0.716 | 482 | 60 | 3.378 | 2026-05-30 21:31:14 |
| 6 | src(31.05_0).zip | 0.73 | 485 | 60 | 3.542 | 2026-05-31 03:22:58 |
| 7 | src(31.05_1).zip | 0.732 | 485 | 60 | 3.542 | 2026-05-31 03:22:58 |
| 8 | src(31.05_2).zip | 0.73 | 485 | 60 | 3.542 | 2026-05-31 03:22:58 |
| 9 | src(31.05_3).zip | 0.726 | 485 | 60 | 3.524 | 2026-05-31 07:43:46 |

## 2) Sıralı farklar
| onceki_zip | sonraki_zip | eklenen_dosya | silinen_eksilen_dosya | icerigi_degisen_dosya | net_dosya_sayisi_farki | acilmis_boyut_farki_byte | durum_yorumu |
| --- | --- | --- | --- | --- | --- | --- | --- |
| src(30.05_1).zip | src(30.05_2).zip | 7 | 0 | 2 | 7 | 35449 | ekleme/çıkarma/değişim var |
| src(30.05_2).zip | src(30.05_3).zip | 0 | 0 | 17 | 0 | 12336 | ekleme/çıkarma/değişim var |
| src(30.05_3).zip | src(30.05_4).zip | 2 | 0 | 58 | 2 | 71625 | ekleme/çıkarma/değişim var |
| src(30.05_4).zip | src(30.05_5).zip | 4 | 0 | 0 | 4 | 68729 | ekleme/çıkarma/değişim var |
| src(30.05_5).zip | src(31.05_0).zip | 3 | 0 | 19 | 3 | 172294 | ekleme/çıkarma/değişim var |
| src(31.05_0).zip | src(31.05_1).zip | 0 | 0 | 0 | 0 | 0 | içerik aynı |
| src(31.05_1).zip | src(31.05_2).zip | 0 | 0 | 0 | 0 | 0 | içerik aynı |
| src(31.05_2).zip | src(31.05_3).zip | 0 | 0 | 93 | 0 | -18888 | ekleme/çıkarma/değişim var |

## 3) Taban dosya = en eski ZIP
Taban: `src(30.05_1).zip`. Son dosya: `src(31.05_3).zip`.
- Son ZIP dosya sayısı: 485
- Taban ZIP dosya sayısı: 469
- Son ZIP tabana göre yeni dosya: 16
- Son ZIP tabana göre eksik dosya: 0
- Son ZIP herhangi önceki ZIP’e göre eksik dosya: 0
- Son ZIP önceki ZIP’e göre eklenen/silinen dosya: 0 eklenen / 0 silinen

## 4) En son ZIP hakkında hüküm
`src(31.05_3).zip` içinde tabana göre eksik dosya yoktur. Ayrıca önceki tüm ZIP’lerin birleşiminde olup da en sonda kaybolan dosya da yoktur. Bu yüzden son tarihli ZIP dosya listesi açısından eksik değil; fakat `src(31.05_2).zip` ile karşılaştırıldığında 93 dosyanın içeriği değişmiştir ve açılmış toplam boyut 18.888 byte azalmıştır.

## 5) Son ZIPte tabana göre yeni gelen dosyalar
- `src/backend/backend_web_coverage_gate_adim26.fbs`
- `src/cli/cli_backend_route_close_adim27.fbs`
- `src/cli/cli_output_contract_adim41.fbs`
- `src/cli/cli_registry_adim41.fbs`
- `src/codegen/js/js_mir_opcode_coverage_adim26.fbs`
- `src/codegen/wasm/wasm_mir_opcode_coverage_adim26.fbs`
- `src/common/error_system_adim45.fbs`
- `src/error_i18n_seed_from_logs.csv`
- `src/error_i18n_template.csv`
- `src/main_backend_close_gate_adim27.fbs`
- `src/main_cli_bridge_adim41.fbs`
- `src/main_output_contract_bridge_adim41_ext.fbs`
- `src/preprocessor/preprocess_meta_eval_adim34.fbs`
- `src/preprocessor/preprocess_meta_model.fbs`
- `src/semantic/ast_mir_coverage_gate_adim25.fbs`
- `src/semantic/ast_mir_route_table_adim25.fbs`

## 6) Son ZIPte önceki ZIPe göre en çok küçülen dosyalar
| dosya | durum | onceki_boyut | son_boyut | boyut_farki |
| --- | --- | --- | --- | --- |
| src/semantic/semantic_step3_gate.fbs | degisti_kuculdu | 30808 | 21090 | -9718 |
| src/runtime/exec/exec_eval_builtin_categories.fbs | degisti_kuculdu | 51844 | 47451 | -4393 |
| src/runtime/ffi_registry.fbs | degisti_kuculdu | 4360 | 227 | -4133 |
| src/runtime/file_io.fbs | degisti_kuculdu | 21589 | 18347 | -3242 |
| src/runtime/exec/exec_stmt_io_file.fbs | degisti_kuculdu | 21647 | 18683 | -2964 |
| src/runtime/exec/exec_eval_text_helpers.fbs | degisti_kuculdu | 14312 | 11523 | -2789 |
| src/runtime/exec/exec_stmt_flow.fbs | degisti_kuculdu | 32842 | 31197 | -1645 |
| src/main_program_entry_part2.fbs | degisti_kuculdu | 13205 | 11694 | -1511 |
| src/parser/parser/parser_stmt_flow.fbs | degisti_kuculdu | 21035 | 19974 | -1061 |
| src/semantic/mir_evaluator_tail_controlflow.fbs | degisti_kuculdu | 59970 | 59037 | -933 |
| src/parser/parser/parser_stmt_decl_proc.fbs | degisti_kuculdu | 9713 | 8990 | -723 |
| src/parser/ast_contract_gate_adim04.fbs | degisti_kuculdu | 12891 | 12193 | -698 |
| src/type_binding/type_rules.fbs | degisti_kuculdu | 10988 | 10301 | -687 |
| src/parser/parser/parser_stmt_decl_class_method.fbs | degisti_kuculdu | 15601 | 14927 | -674 |
| src/parser/ast_child_accessors.fbs | degisti_kuculdu | 4951 | 4290 | -661 |
| src/codegen/x64/nasm/nasm_writer.fbs | degisti_kuculdu | 2482 | 1829 | -653 |
| src/parser/parser/parser_shared.fbs | degisti_kuculdu | 16713 | 16066 | -647 |
| src/type_binding/type_ffi_signature.fbs | degisti_kuculdu | 2266 | 1623 | -643 |
| src/semantic/semantic_step5_json.fbs | degisti_kuculdu | 5468 | 4865 | -603 |
| src/codegen/js/js_source_emit.fbs | degisti_kuculdu | 2291 | 1719 | -572 |

## 7) Son ZIPte önceki ZIPe göre en çok büyüyen dosyalar
| dosya | durum | onceki_boyut | son_boyut | boyut_farki |
| --- | --- | --- | --- | --- |
| src/parser/lexer/lexer_preprocess.fbs | degisti_buyudu | 87312 | 91635 | 4323 |
| src/parser/parser/parser_stmt_event_pipe.fbs | degisti_buyudu | 7616 | 10099 | 2483 |
| src/type_binding/type_infer_expr.fbs | degisti_buyudu | 23306 | 25386 | 2080 |
| src/semantic/mir.fbs | degisti_buyudu | 69532 | 71306 | 1774 |
| src/parser/parser/parser_stmt_decl_core.fbs | degisti_buyudu | 45592 | 47020 | 1428 |
| src/surface/uxb_surface_registry.fbs | degisti_buyudu | 31529 | 32432 | 903 |
| src/semantic/hir.fbs | degisti_buyudu | 37429 | 38313 | 884 |
| src/backend/backend_native_surface_scan.fbs | degisti_buyudu | 7233 | 8110 | 877 |
| src/codegen/x64/mir_x64_codegen.fbs | degisti_buyudu | 36419 | 37286 | 867 |
| src/parser/ast_contract.fbs | degisti_buyudu | 39712 | 40548 | 836 |
| src/semantic/mir_verifier.fbs | degisti_buyudu | 28567 | 29103 | 536 |
| src/surface/uxb_surface_layer_bridge.fbs | degisti_buyudu | 19609 | 20115 | 506 |
| src/parser/lexer/lexer_keyword_table.fbs | degisti_buyudu | 4414 | 4826 | 412 |
| src/parser/ast.fbs | degisti_buyudu | 20334 | 20736 | 402 |
| src/codegen/x64/mir_x64_keyword_surface.fbs | degisti_buyudu | 20564 | 20960 | 396 |
| src/codegen/x64/mir_x64_opcode_surface_emitters.fbs | degisti_buyudu | 16222 | 16600 | 378 |
| src/parser/parser/uxb_parser_surface_contract.fbs | degisti_buyudu | 19174 | 19534 | 360 |
| src/codegen/js/uxb_js_surface_contract.fbs | degisti_buyudu | 19166 | 19523 | 357 |
| src/codegen/wasm/uxb_wasm_surface_contract.fbs | degisti_buyudu | 19167 | 19524 | 357 |
| src/codegen/x86/uxb_x86_surface_contract.fbs | degisti_buyudu | 19159 | 19516 | 357 |

## 8) 31.05_0 / 31.05_1 / 31.05_2 notu
Bu üç ZIP içerik düzeyinde aynıdır: dosya listesi, dosya boyutları ve CRC karşılaştırmasında değişiklik yoktur. Arşiv byte boyutları/SHA değerleri farklı olabilir; bu paketleme farkıdır, kaynak içeriği farkı değildir.