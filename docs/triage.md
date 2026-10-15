# uXBasic Project Pack Triage - reports10 / 20260611_233616

Ana expected suite: 138/138 PASS. Project pack: 20/30 PASS.

Kalan 10 fail ve 4 weak-negative durumu aşağıdadır.

## pack_02_operators_logic_bit

- phase: `run`
- status: `FAIL_STDOUT`
- rc: `0`
- sınıf: **REAL_RUNTIME_SEMANTICS**

- belirti: `satir 34: beklenen='8', gelen='-1'; satir 35: beklenen='15', gelen='-1'`

- kök yorum: AND/OR AST execmem boolean sonucu -1 üretiyor; project pack bitwise I32 sonuç bekliyor. Mantıksal ve bit düzeyi operatör ayrımı netleştirilmeli.

- öneri: Bitwise AND/OR/XOR için numeric context, logical &&/|| için boolean context ayrımı yaması.

## pack_03_strings_builtins

- phase: `run`
- status: `FAIL_RC`
- rc: `2`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=2`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_05_control_flow_if_for

- phase: `run`
- status: `FAIL_RC`
- rc: `1`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=1`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_09_class_oop_magic

- phase: `run`
- status: `FAIL_RC`
- rc: `1`
- sınıf: **REAL_COMPILER_GAP_FIX15_TARGET**

- belirti: `Beklenen rc=0, gelen rc=1`

- kök yorum: OOP/MAGIC tarafında TYPE_I32 -> TYPE_OBJECT semantic assignment hatası; Fix15 MAGIC dispatch + gerekirse object assignment/type binding kontrolü.

- öneri: Fix15 uygulandıktan sonra pack_09 özel tekrar test; kalırsa NEW/object assignment yaması gerekir.

## pack_10_file_io_channels

- phase: `run`
- status: `FAIL_RC`
- rc: `2`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=2`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_16_big_extfp_canonical

- phase: `run`
- status: `FAIL_STDOUT`
- rc: `0`
- sınıf: **REAL_RUNTIME_BUILTIN_OR_TEST_EXPECTATION**

- belirti: `satir 1: beklenen='111', gelen='0'; satir 2: beklenen='222', gelen='0'; satir 3: beklenen='333', gelen='0'; satir 4: beklenen='444', gelen='0'; satir 5: beklenen='555', gelen='0'; satir 6: beklenen='666', gelen='0'; satir 7: beklenen='777', gelen='0'; satir 8: beklenen='888', gelen='0'`

- kök yorum: BIGINIT/BIG* project pack koşusunda 0 dönüyor; expected suite big_extfp geçmişti, bu yüzden testin kullandığı fonksiyon adı/arg tipi ile runtime route ayrışıyor.

- öneri: Kanonik clean testten sonra BIGINIT kullanımını doğrula; gerekiyorsa AST builtin route veya test expected düzeltmesi.

## pack_17_memory_ptr_intrinsics

- phase: `run`
- status: `FAIL_RC`
- rc: `2`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=2`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_18_event_thread_pipe_slot

- phase: `sem`
- status: `FAIL_RC`
- rc: `1`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=1`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_21_input_line_file

- phase: `run`
- status: `FAIL_RC`
- rc: `2`
- sınıf: **TEST_PACK_MISMATCH_OR_PHASE_MISMATCH**

- belirti: `Beklenen rc=0, gelen rc=2`

- kök yorum: Çalışan test kaynağı/manifest hâlâ kanonik temiz paketle uyuşmuyor veya AST/semantic fazı yanlış seçilmiş.

- öneri: Önce uxb_project_packs_30_CANONICAL_REINSTALL_GUARD ile xtestx/project_packs klasörünü silip yeniden kur; sonra tekrar ölç.

## pack_26_negative_raw_js_gate

- phase: `sem`
- status: `PASS_NEGATIVE_WEAK`
- rc: `2`
- sınıf: **RUNNER_DIAGNOSTIC_MATCH_WEAK**

- belirti: `Hata verdi ama beklenen diagnostic parcalari bulunamadi: JS, gate`

- kök yorum: Compiler hata veriyor; runner beklenen parçayı case/format yüzünden güçlü eşleştiremiyor.

- öneri: Runner diagnostic matching case-insensitive ve code-based yapılmalı.

## pack_27_negative_include_cycle

- phase: `sem`
- status: `PASS_NEGATIVE_WEAK`
- rc: `2`
- sınıf: **RUNNER_DIAGNOSTIC_MATCH_WEAK**

- belirti: `Hata verdi ama beklenen diagnostic parcalari bulunamadi: cycle, include`

- kök yorum: Compiler hata veriyor; runner beklenen parçayı case/format yüzünden güçlü eşleştiremiyor.

- öneri: Runner diagnostic matching case-insensitive ve code-based yapılmalı.

## pack_28_negative_semantic_unknown_symbol

- phase: `sem`
- status: `PASS_NEGATIVE_WEAK`
- rc: `1`
- sınıf: **RUNNER_DIAGNOSTIC_MATCH_WEAK**

- belirti: `Hata verdi ama beklenen diagnostic parcalari bulunamadi: unknown symbol`

- kök yorum: Compiler hata veriyor; runner beklenen parçayı case/format yüzünden güçlü eşleştiremiyor.

- öneri: Runner diagnostic matching case-insensitive ve code-based yapılmalı.

## pack_29_negative_wrong_keywords

- phase: `ast`
- status: `PASS_NEGATIVE_WEAK`
- rc: `2`
- sınıf: **RUNNER_DIAGNOSTIC_MATCH_WEAK**

- belirti: `Hata verdi ama beklenen diagnostic parcalari bulunamadi: THREAT, PARALLEL, SIHIRLIMETOT`

- kök yorum: Compiler hata veriyor; runner beklenen parçayı case/format yüzünden güçlü eşleştiremiyor.

- öneri: Runner diagnostic matching case-insensitive ve code-based yapılmalı.

## pack_30_full_integration_project

- phase: `run`
- status: `FAIL_STDOUT`
- rc: `0`
- sınıf: **REAL_RUNTIME_BUILTIN_OR_TEST_EXPECTATION**

- belirti: `satir 6: beklenen='12345', gelen='0'`

- kök yorum: BIGINIT/BIG* project pack koşusunda 0 dönüyor; expected suite big_extfp geçmişti, bu yüzden testin kullandığı fonksiyon adı/arg tipi ile runtime route ayrışıyor.

- öneri: Kanonik clean testten sonra BIGINIT kullanımını doğrula; gerekiyorsa AST builtin route veya test expected düzeltmesi.


## Öncelik sırası

1. `uxb_project_packs_30_CANONICAL_REINSTALL_GUARD` ile test klasörünü kesin temizle.

2. Tekrar project pack çalıştır.

3. Kalan gerçek compiler açıkları için: Fix15 MAGIC; sonra bitwise AND/OR; sonra BIGINIT/BIG* route.
