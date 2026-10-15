# 02 — ADIM0: Inventory Temelli Silmeden Temizlik

## Amaç

İlk iş kod yazmak değildir. İlk iş proje ağacını inventory belgesine göre sınıflandırmak ve hiçbir dosyayı silmeden temizlik planı çıkarmaktır.

## Copilot'a verilecek görev

```text
Inventory ağacını oku. Aktif kaynak, geçici dosya, derleme çıktısı, log, eski backup, tekrar dosya, dış araç, rapor ve belge sınıflarını ayır.
Hiçbir dosyayı silme.
Sadece reports/control/current altında CSV/JSON/MD rapor üret.
Taşıma yapılacaksa önce retirement_plan.csv üret; uygulama ayrı onay gerektirir.
```

## Girdi

```text
inventory_tree.txt
varsa inventory_files.csv
repo dosya ağacı
```

Not: `inventory_files.csv` sadece başlık içeriyorsa esas kaynak `inventory_tree.txt` olacak.

## Oluşturulacak araçlar

```text
tools/control/uxb_inventory_reader.py
tools/control/uxb_folder_classifier.py
tools/control/uxb_file_classifier.py
tools/control/uxb_retirement_plan.py
tools/control/uxb_retirement_apply_safe.py
tools/control/uxb_retirement_verify.py
```

## Emekli klasörleri

```text
_retired/tmp_imports/
_retired/step_tmp/
_retired/zip_work/
_retired/old_outputs/
_retired/old_logs/
_retired/duplicate_tests/
_retired/old_backups/
_retired/old_tools/
```

## Üretilecek raporlar

```text
reports/control/current/inventory_parsed.csv
reports/control/current/folder_classification.csv
reports/control/current/file_classification.csv
reports/control/current/retirement_plan.csv
reports/control/current/retirement_gate.json
reports/control/current/retirement_gate.md
```

## Sınıflar

```text
AKTIF
KANONIK
EMEKLI_ADAYI
EMEKLI
TEKRAR
GECICI
DERLEME_CIKTISI
DIS_ARAC
LOG
RAPOR
KAYNAK_KOD
TEST
BELGE
KUTUPHANE
KIRIK
```

## Pozitif test

```text
_step*_tmp klasörleri EMEKLI_ADAYI veya GECICI sınıfına düşmeli.
src altındaki .fbs/.bas dosyaları KAYNAK_KOD/AKTIF sınıfına düşmeli.
tools/FreeBASIC-1.10.1-win64 DIS_ARAC sınıfına düşmeli.
```

## Negatif test

```text
Hiçbir kaynak dosya retirement_apply_safe çalışmadan taşınmayacak.
main.bas kaynak olarak kalacak; main.exe derleme çıktısı sayılacak.
__dup1 dosyaları aktif test sayılmayacak.
```

## Tamamlanma ölçütü

```text
retirement_plan.csv var.
Raporlarda silme işlemi yok.
Her satır için sınıf var.
Taşıma planı ayrı onay olmadan uygulanmıyor.
```
