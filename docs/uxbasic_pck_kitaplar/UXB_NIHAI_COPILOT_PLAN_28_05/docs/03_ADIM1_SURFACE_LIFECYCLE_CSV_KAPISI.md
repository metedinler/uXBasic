# 03 — ADIM1: Surface Lifecycle CSV Kapısı

## Amaç

Lexer surface öğeleri tek tek yaşam döngüsü satırına bağlanacak. Her surface için hangi katmanda karşılığı olduğu, hangi katmanda olmadığı ve hangi hedefte neden bloklandığı açık görülecek.

## Mevcut CSV kontrol sonucu

Adım0 CSV paketi kontrol edildi:

```text
surface_count = 268
blocker_count = 222
target_backend_blocker_count = 137
fake_implemented_count = 91
strict_status = FAIL
```

Bu durumda gate bilinçli olarak FAIL durumunda. Bu kötü değil; saklanmayan gerçek durumdur.

## Copilot'a görev

```text
Mevcut CSV'leri silme.
surface_lifecycle_matrix.csv şemasını koru.
Boş hücre bırakma.
IMPLEMENTED yazmak için evidence_file zorunlu kıl.
BROKEN veya MISSING varsa master gate PASS olamaz.
```

## Kullanılacak mevcut CSV'ler

```text
reference_csv/adim0_surface/surface_lifecycle_matrix.csv
reference_csv/adim0_surface/surface_lifecycle_blockers.csv
reference_csv/adim0_surface/target_backend_blockers.csv
reference_csv/adim0_surface/surface_test_plan.csv
reference_csv/adim0_surface/fake_implemented_lifecycle.csv
```

## Yeni üretilecek raporlar

```text
reports/control/current/surface_lifecycle_matrix.csv
reports/control/current/surface_lifecycle_summary.json
reports/control/current/surface_lifecycle_gate.md
reports/control/current/surface_expected_actual.csv
reports/control/current/surface_error_classification.csv
```

## CSV kolon kuralı

Ana matrix en az şu kolonları taşımalı:

```text
id
surface_name
surface_group
surface_kind
syntax
source_file
lifecycle_route
route_owner_layer
route_complete
hard_blocker_count
missing_layers
broken_layers
target_blockers
evidence_score
required_next_action
recommended_step
```

## Kabul kuralı

```text
Her lexer surface öğesi bir route sahibi olmalı.
Her surface için test planı satırı olmalı.
IMPLEMENTED ama blocker varsa fake_implemented_lifecycle.csv satırı oluşmalı.
```
