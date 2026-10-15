# 18 — ADIM 13: TEST SUITE / GATES / RELEASE

Bu adım **tamirat adımı değildir**. Derleme ve test çalıştırır, rapor üretir, release aday klasörü hazırlar; hata çıkarsa kaynak kodu düzeltmez.

## Kapsam

Plan belgesi adı:

```text
18_ADIM13_TEST_SUITE_GATES_RELEASE.md
```

Bu adımda amaç:

```text
surface_lifecycle_matrix -> test planı -> test koşumu -> expected/actual karşılaştırma -> release gate
```

## Değiştirilecek / eklenecek dosyalar

Yeni dosyalar:

```text
tools/control/uxb_surface_test_generator.py
tools/control/uxb_run_layer_tests.py
tools/control/uxb_expected_actual_compare.py
tools/release/uxb_release_gate.py
compiler/scripts/run_surface_suite.bat
compiler/scripts/run_release_gate.bat
compiler/scripts/run_adim18_test_suite_release_gate.ps1
```

Eğer bu dosyalar repo içinde zaten varsa **ezme yok**. Önce yedek al:

```text
_retired/backups/adim18_<timestamp>/...
```

Sonra patch dosyalarıyla kontrollü değiştir. Mevcut eski `tools/uxb_release_gate.py` varsa silme; yeni dosya `tools/release/uxb_release_gate.py` altında duracak. Eski araç gerekirse wrapper/fallback olarak kalacak.

## Bu adımda yasak

```text
Kaynak FreeBASIC dosyalarını düzeltme.
lexer/parser/semantic/mir/backend dosyalarına tamirat yapma.
Yeni analiz planı icat etme.
Gate FAIL iken PASS deme.
Commit/push yapma.
```

## Uygulama komutları

Repo kökünden veya `uxb` klasöründen çalışabilir. Script kökü kendisi bulur.

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
compiler/scripts/run_adim18_test_suite_release_gate.ps1 -NoRepair
```

Alternatif eski `.bat` zinciri:

```bat
compiler\scripts\run_surface_suite.bat
compiler\scripts\run_release_gate.bat
```

## Beklenen çıktılar

```text
reports/control/current/adim13_test_plan.csv
reports/control/current/adim13_test_results.csv
reports/control/current/adim13_expected_actual.csv
reports/control/current/adim13_release_gate.json
reports/control/current/adim13_release_gate.md
dist/release_candidate/README.md
dist/release_candidate/release_manifest.json
```

## Bitme şartı

Adım yalnızca şu durumda biter:

```text
adim13_release_gate.json status = PASS
```

FAIL ise çıktıların ilk 20 blocker satırını raporla, tamirata girme.
