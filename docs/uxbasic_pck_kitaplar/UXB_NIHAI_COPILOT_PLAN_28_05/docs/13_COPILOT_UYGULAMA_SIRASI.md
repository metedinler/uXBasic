# 13 — Copilot'a Verilecek Uygulama Sırası

Aşağıdaki sırayı bozma. Her belge ayrı verilecek.

```text
1. 01_COPILOT_ANA_KURALLAR.md
2. 02_ADIM0_INVENTORY_SILMEDEN_TEMIZLIK.md
3. 03_ADIM1_SURFACE_LIFECYCLE_CSV_KAPISI.md
4. 04_ADIM2_LEXER_PREPROCESSOR.md
5. 05_ADIM3_PARSER_ERROR_RECOVERY_SCOPE.md
6. 06_ADIM4_AST_CONTRACT_HIBRIT_COCUK.md
7. 07_ADIM5_SYMBOL_SCOPE_HASH_HIR_BRIDGE.md
8. 08_ADIM6_MIR_BUILDER_TYPED_STORAGE_VERIFY.md
9. 09_ADIM7_INTERPRETER_RUNTIME_PARITY.md
10. 10_ADIM8_BACKEND_PIPELINE_WABT.md
11. 11_ADIM9_MAIN_ENTRY_ROUTER.md
12. 12_ADIM10_TEST_RAPOR_RELEASE_GATE.md
```

## Her Copilot konuşmasına eklenecek kısa emir

```text
Sadece bu adımı uygula.
Önce repo durumunu ve ilgili dosyaları tara.
Hiçbir dosya silme.
Kod değişikliği yapmadan önce hangi dosyaları değiştireceğini yaz.
Her değişiklikten sonra pozitif/negatif test ve expected/actual rapor üret.
BROKEN/MISSING saklama.
IMPLEMENTED demek için gerçek handler/emitter/runtime/test/evidence gerekir.
```

## Her adım sonrası benden istenecek paket

```text
1. Son zip
2. reports/control/current/<step>_gate.json
3. reports/control/current/<step>_gate.md
4. reports/control/current/<step>_expected_actual.csv
5. reports/control/current/error_classification.csv
6. directory_snapshot.txt
```
