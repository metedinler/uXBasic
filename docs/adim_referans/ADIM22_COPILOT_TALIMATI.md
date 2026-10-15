# ADIM22 — Full Layer Expected Test Suite Copilot Talimatı

## Görev

uXBasic geliştirme ortamını, tüm katmanların beklenen çıktılarını kullanarak test et.

Bu görev compiler tamiratı değildir.

## Uygulama

1. Bu paketteki `patch_files/tests/full_layer` klasörünü repo içindeki `tests/full_layer` yoluna kopyala.
2. Bu paketteki `patch_files/compiler/scripts/run_adim22_full_layer_expected_suite.ps1` dosyasını `compiler/scripts/` altına kopyala.
3. Eğer aynı dosya varsa önce `_retired/backups/adim22_<timestamp>/` altına yedek al.
4. Yeni Python aracı yazma.
5. Adım 18 test runner araçlarını kullan:
   - `tools/control/uxb_run_layer_tests.py`
   - `tools/control/uxb_expected_actual_compare.py`
6. Sonra şu komutu çalıştır:

```powershell
compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
```

## Yasak

```text
Kaynak FreeBASIC tamiratı yapma.
Lexer/parser/semantic/mir/backend dosyalarını düzeltme.
Plan dosyası değiştirme.
Gate FAIL iken PASS yazma.
Commit/push yapma.
```

## Beklenen raporlar

```text
reports/control/current/adim22_test_results.csv
reports/control/current/adim22_expected_actual.csv
reports/control/current/adim22_layer_output_expected_actual.csv
reports/control/current/adim22_surface_coverage_summary.csv
reports/control/current/adim22_full_layer_gate.json
reports/control/current/adim22_full_layer_gate.md
```

## PASS şartı

```text
Test runner PASS.
Expected/actual compare PASS.
Zorunlu katman çıktı dosyaları oluşmuş.
Surface coverage map içinde boş assigned_test_id yok.
```
