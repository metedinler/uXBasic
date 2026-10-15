# uXBasic reports7 project pack triage

Durum: expected suite 138/138 PASS. Project pack son koşu: 30 total, 20 pass, 10 fail; ayrıca 4 PASS_NEGATIVE_WEAK diagnostic eşleşme zayıf.

## Kaynak marker kontrolü

| Dosya | FIX14 | FIX15 |
|---|---:|---:|
| `src/parser/lexer/lexer_driver.fbs` | 1 | 0 |
| `src/preprocessor/preprocess_engine.fbs` | 3 | 0 |
| `src/runtime/exec/exec_call_dispatch_helpers.fbs` | 1 | 0 |
| `src/semantic/mir.fbs` | 1 | 0 |
| `src/semantic/mir_lower_expr.fbs` | 1 | 0 |
| `src/codegen/x64/code_generator.fbs` | 2 | 0 |
| `src/type_binding/type_infer_expr.fbs` | 0 | 0 |
| `src/runtime/exec/exec_eval_support_helpers.fbs` | 0 | 0 |

## Hata sınıfları

### pack_02_operators_logic_bit — FAIL_STDOUT rc=0

- Detay: satir 34: beklenen='8', gelen='-1'; satir 35: beklenen='15', gelen='-1'
- Kök: Gerçek compiler/runtime eksikliği: AND/OR gibi operatörler I32 bit düzeyi yerine boolean -1 üretiyor.
- Eylem: AST eval/MIR eval operator ayrımı: numeric I32 AND/OR/XOR bitwise, BOOL bağlamında logical ayrı yapılmalı.

### pack_03_strings_builtins — FAIL_RC rc=2

- Detay: Beklenen rc=0, gelen rc=2
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_05_control_flow_if_for — FAIL_RC rc=1

- Detay: Beklenen rc=0, gelen rc=1
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_09_class_oop_magic — FAIL_RC rc=1

- Detay: Beklenen rc=0, gelen rc=1
- Kök: MAGIC/OOP semantic eksikliği: TYPE_I32 -> TYPE_OBJECT assignment veya NEW/object inference sorunlu; Fix15 MAGIC dispatch ile kısmen hedefleniyor ama object assignment ayrıca incelenmeli.
- Eylem: Fix15 uygulanmadan önce/sonra bu paket özel izlenmeli. Gerekirse NEW ve class object assignment type binding ayrı düzeltilecek.

### pack_10_file_io_channels — FAIL_RC rc=2

- Detay: Beklenen rc=0, gelen rc=2
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_16_big_extfp_canonical — FAIL_STDOUT rc=0

- Detay: satir 1: beklenen='111', gelen='0'; satir 2: beklenen='222', gelen='0'; satir 3: beklenen='333', gelen='0'; satir 4: beklenen='444', gelen='0'; satir 5: beklenen='555', gelen='0'; satir 6: beklenen='666', gelen='0'; satir 7: beklenen='777', gelen='0'; satir 8: beklenen='888', gelen='0'
- Kök: BIGINIT/EXTFP runtime text/numeric dönüş yolu proje testinde 0 üretiyor; expected suite ile farklı kullanım olabilir.
- Eylem: BIGINIT çağrısı hem numeric hem string arg ile test edilmeli; return value text/int ayrımı execmem PRINT yolunda düzeltilmeli.

### pack_17_memory_ptr_intrinsics — FAIL_RC rc=2

- Detay: Beklenen rc=0, gelen rc=2
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_18_event_thread_pipe_slot — FAIL_RC rc=1

- Detay: Beklenen rc=0, gelen rc=1
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_21_input_line_file — FAIL_RC rc=2

- Detay: Beklenen rc=0, gelen rc=2
- Kök: Kurulu project_pack hâlâ eski/geniş test setinden geliyor veya phase/manifest eski; kanonik temiz test içeriği değil.
- Eylem: Önce reinstall guard ile canonical project packs kurulmalı. Compiler yamasıyla ölçülmemeli.

### pack_26_negative_raw_js_gate — PASS_NEGATIVE_WEAK rc=2

- Detay: Hata verdi ama beklenen diagnostic parcalari bulunamadi: JS, gate
- Kök: Negatif test doğru şekilde hata veriyor; runner diagnostic eşleştirmesi Türkçe/uppercase/kod parçasını yakalayamıyor.
- Eylem: Runner expected_diagnostic_contains normalize edilmeli veya expected.json parçası mevcut mesaja göre ayarlanmalı.

### pack_27_negative_include_cycle — PASS_NEGATIVE_WEAK rc=2

- Detay: Hata verdi ama beklenen diagnostic parcalari bulunamadi: cycle, include
- Kök: Negatif test doğru şekilde hata veriyor; runner diagnostic eşleştirmesi Türkçe/uppercase/kod parçasını yakalayamıyor.
- Eylem: Runner expected_diagnostic_contains normalize edilmeli veya expected.json parçası mevcut mesaja göre ayarlanmalı.

### pack_28_negative_semantic_unknown_symbol — PASS_NEGATIVE_WEAK rc=1

- Detay: Hata verdi ama beklenen diagnostic parcalari bulunamadi: unknown symbol
- Kök: Negatif test doğru şekilde hata veriyor; runner diagnostic eşleştirmesi Türkçe/uppercase/kod parçasını yakalayamıyor.
- Eylem: Runner expected_diagnostic_contains normalize edilmeli veya expected.json parçası mevcut mesaja göre ayarlanmalı.

### pack_29_negative_wrong_keywords — PASS_NEGATIVE_WEAK rc=2

- Detay: Hata verdi ama beklenen diagnostic parcalari bulunamadi: THREAT, PARALLEL, SIHIRLIMETOT
- Kök: Negatif test doğru şekilde hata veriyor; runner diagnostic eşleştirmesi Türkçe/uppercase/kod parçasını yakalayamıyor.
- Eylem: Runner expected_diagnostic_contains normalize edilmeli veya expected.json parçası mevcut mesaja göre ayarlanmalı.

### pack_30_full_integration_project — FAIL_STDOUT rc=0

- Detay: satir 6: beklenen='12345', gelen='0'
- Kök: Entegrasyon içinde BIGINIT 0 üretiyor; ayrıca eski test fazladan 201.. çıktı üretiyor, kurulu pack eski olabilir.
- Eylem: Kanonik pack kurulduktan sonra tekrar bakılmalı; kalan 0 BIGINIT ile aynı kök.

