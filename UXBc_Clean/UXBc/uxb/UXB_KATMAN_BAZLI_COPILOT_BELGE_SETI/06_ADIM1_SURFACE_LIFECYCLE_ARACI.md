# 06 — ADIM 1: Surface Lifecycle Matrix Aracı

Bu belge genel surface yaşam döngüsü aracını kurar. Lexer sadece örnek değil; tüm surface bu araçla izlenecek.

## Amaç

Lexer/parser yüzeyinde bulunan her öğenin gerçek mimari yaşam yolunu CSV olarak çıkarmak.

## Girdi

```text
docs/matrix/UXB_KEYWORD_LAYER_MATRIX.csv
docs/matrix/UXB_AST_LAYER_MATRIX.csv
docs/matrix/UXB_AST_TO_MIR_MATRIX.csv
docs/matrix/UXB_MIR_TARGET_MATRIX.csv
src/**
tools/audit/**
reports/step1/**
```

## Araç

```text
compiler/scripts/run_step1_surface_matrix.bat
compiler/scripts/run_step1_surface_gate.bat
```

Not: tools/control/uxb_surface_lifecycle_matrix.py yolu bu pakette kanonik degildir; yanlis uretilen control araci emekliye alinmistir. Bu adim mevcut Step1 scriptleri ile yurutulur.

## Yapılacak işler

1. Tüm surface satırlarını oku.
2. Her satır için şu alanları üret:
   - surface_id
   - surface_name
   - surface_kind
   - lifecycle_route
   - implementation_owner
   - compile_time_route
   - runtime_route
   - backend_route_x64
   - backend_route_x86
   - backend_route_js
   - backend_route_wat
   - backend_route_wasm
   - test_positive
   - test_negative
3. Boş hücreleri fail yap.
4. `IMPLEMENTED` ama kanıt yoksa `FAKE_IMPLEMENTED` yap.
5. `PARTIAL` statüsünü nihai backend hedeflerinde blocker yap.
6. Her blocker için `recommended_step` üret.

## Çıktılar

```text
reports/control/current/surface_lifecycle_matrix.csv
reports/control/current/surface_lifecycle_blockers.csv
reports/control/current/target_backend_blockers.csv
reports/control/current/surface_test_plan.csv
reports/control/current/surface_lifecycle_summary.json
reports/control/current/surface_lifecycle_gate.md
```

## Pozitif test

```text
compiler/scripts/run_step1_surface_matrix.bat
compiler/scripts/run_step1_surface_gate.bat
```

Beklenen:

```text
Step1 matrix ve gate raporlari uretilir.
Matrix authority ve gate authority mevcut audit araclariyla dogrulanir.
Gate PASS almak zorunlu degildir; raporlarin uretimi zorunludur.
```

## Negatif test

```text
BROKEN veya MISSING varsa gate FAIL.
IMPLEMENTED ama evidence_file boşsa FAIL.
x64/js/wat/wasm target hücresinde PARTIAL varsa FAIL.
```

## Bitme şartı

Bu adımda gate PASS almak şart değildir; mevcut sistemde fail verebilir. Ama raporların doğru üretilmesi şarttır.
Bu adımın görevi problemi görünür yapmaktır.
