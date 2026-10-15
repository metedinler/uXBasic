# ADIM40 — ADIM36 Report-Driven Fixes + Latest Review Collector

## Kaynak inceleme sonucu

`history.zip` ve `latest.zip` incelendi.

Güvenilir son geniş yüzey sonucu:
- `ADIM36`: FAIL
- `test_case_count=79`
- `fail_count=139`
- `missing_output_count=293`
- `placeholder_count=0`
- `bad_json_count=0`

`latest.zip` doğru son çalışma derlemesi değil. İçinde `latest_review_*` altında eski/tekrarlı ADIM30 ve ADIM32B klasörleri kopyalanmış. En yeni ADIM36 fail durumu history içinde daha güvenilir görünüyor.

## Bu adımın amacı

1. `current` klasörüne bakmadan history’den doğru son raporu seçmek.
2. Son ADIM36 kırmızılarını kök hata ailesine göre kapatmak.
3. ADIM30 ve ADIM32B PASS durumunu bozmamak.
4. THREAT / PARALLEL / SIHIRLIMETOT yanlış yazımlarını geri getirmemek.

## Kesin dil kararları

- THREAT yok. Doğru anahtar: THREAD.
- PARALLEL yok. Doğru anahtar: PARALEL.
- SIHIRLIMETOT yok. Doğru anahtar: MAGIC.
- IMPORT DLL/API/LIB yok.
- DLL/API yolu: `DECLARE ... LIB ... ALIAS ...` ve `CALL(DLL/API,...)`.
- BIGI/BIGINT aynı tip. Internal canonical: TYPE_BIGINT. JSON/type report: BIGINT.
- BIGINIT initializer builtin kalır. BIGINT initializer değildir.

## Uygulama sırası

### 1. Rapor seçici

`patch_files/compiler/scripts/collect_latest_review_from_history.ps1` dosyasını `compiler/scripts/` altına kopyala.

Komut:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File compiler\scripts\collect_latest_review_from_history.ps1 `
  -NoCurrent `
  -OutPrefix adim40_latest_review
```

Bu script:
- `reports/control/current` kullanmaz.
- `latest_*` klasörlerini kaynak olarak seçmez.
- History içinde en yeni `adim36_full_surface_gate.json`, `adim32b_strict_gate.json`, `adim30_10step_gate.json`, `adim38_second_wave_gate.json` klasörlerini ayrı ayrı bulur.
- Hepsini `reports/control/history/adim40_latest_review_<timestamp>/` altına kopyalar.
- `manifest.json` ve `selected_gate_files.csv` yazar.

### 2. Kök düzeltmeler

Aşağıdaki dosyaları incele ve snippetlerdeki mantığı mevcut kod adlarına uyarla:

- `string_builtins_ast_mir_interpreter.fbs`
- `array_index_lvalue_fix.fbs`
- `recursion_function_type_inference_fix.fbs`
- `include_symbol_visibility_fix.fbs`
- `file_io_input_roundtrip_fix.fbs`
- `big_number_type_precision_biginit_fix.fbs`
- `preprocessor_extended_meta_fix.fbs`
- `wasm_host_js_block_fix.fbs`
- `rnd_timer_builtin_fix.fbs`
- `ptr_memory_type_rules_fix.fbs`
- `negative_gate_fail_close_fix.md`

### 3. Testler

Aşağıdaki yeni testleri ekle:
- `tests/adim36_full_surface/positive/56_string_builtins_full.bas`
- `tests/adim36_full_surface/positive/57_array_index_lvalue.bas`
- `tests/adim36_full_surface/positive/58_recursion_factorial_type.bas`
- `tests/adim36_full_surface/positive/59_file_input_roundtrip_no_dollar.bas`
- `tests/adim36_full_surface/positive/60_big_number_canonical.bas`
- `tests/adim36_full_surface/positive/61_preprocessor_foreach_ifn_elif.uxb`
- `tests/adim36_full_surface/negative/114_wrong_keyword_typos_removed.bas`

Plan CSV’ye ekle.

### 4. Gate sırası

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim36_full_surface_library_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim32b_strict_pass.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim30_10step_chain_suite.ps1 -NoRepair
```

Beklenen:
- ADIM30 PASS korunacak.
- ADIM32B strict PASS korunacak.
- ADIM36 fail_count düşecek.
- placeholder_count 0 kalacak.

## Tamir sıralaması

1. String builtins
2. Array index lvalue
3. Recursion type
4. Include symbol visibility
5. File I/O roundtrip
6. BIG number type
7. Preprocessor extended meta
8. WASM host JS raw block
9. RND/TIMER
10. PTR/memory
11. Negative gate fail-close
