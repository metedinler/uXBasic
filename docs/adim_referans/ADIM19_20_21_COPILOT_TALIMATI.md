# ADIM 19-20-21 — Sözleşme/Gate Yamaları

Bu paket, 19/20/21 belgelerinin gereğini uygular.

## Kapsam

- **19**: `surface_lifecycle_matrix.csv` kolon, durum ve evidence sözleşmesini denetler.
- **20**: Katman çıktı dosyalarının varlığını ve JSON/CSV yazılabilirliğini denetler.
- **21**: Copilot görevlerinin tek belge / tek adım sınırını korumak için görev şablonu ve boundary gate üretir.

## Kesin kural

```text
Yeni FreeBASIC çekirdek kodu yazma.
Compiler tamiratına girme.
Kaynak dosya silme.
Ana dosyaları ezme.
Var olan raporları kontrol et.
Hata varsa raporla; otomatik düzeltme yapma.
```

## Eklenecek dosyalar

```text
tools/control/uxb_surface_route_matrix_contract_gate.py
tools/control/uxb_layer_output_contract_gate.py
tools/control/uxb_copilot_task_boundary_gate.py

compiler/scripts/run_adim19_surface_route_matrix_contract_gate.ps1
compiler/scripts/run_adim20_layer_output_contract_gate.ps1
compiler/scripts/run_adim21_copilot_task_boundary_gate.ps1
compiler/scripts/run_adim19_20_21_contract_gates.ps1

docs/copilot/COPILOT_TEK_GOREV_SABLONU.md
docs/contracts/surface_route_matrix_contract.json
docs/contracts/layer_output_contract.json
docs/contracts/copilot_task_boundary_contract.json
```

## Çalıştırma

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
compiler/scripts/run_adim19_20_21_contract_gates.ps1 -NoRepair
```

## Beklenen raporlar

```text
reports/control/current/adim19_surface_contract_gate.json
reports/control/current/adim19_surface_contract_gate.md
reports/control/current/adim19_surface_contract_violations.csv

reports/control/current/adim20_layer_output_gate.json
reports/control/current/adim20_layer_output_gate.md
reports/control/current/adim20_layer_output_matrix.csv

reports/control/current/adim21_copilot_boundary_gate.json
reports/control/current/adim21_copilot_boundary_gate.md
reports/control/current/adim21_task_template.md
```

## PASS şartı

- 19: Zorunlu kolonlar eksiksiz, boş hücre yok, `BROKEN/MISSING/PARTIAL` ihlal yok, `IMPLEMENTED` olan satırlarda evidence var.
- 20: Beklenen katman çıktıları ya mevcut ya da açık `SKIPPED/NOT_REQUESTED` gerekçesiyle raporlanmış.
- 21: Copilot görevi tek belge / tek adım / kontrollü dosya kapsamı kuralını ihlal etmiyor.

## Not

Bu adım compiler tamiri değildir. Tamir daha sonra ilgili katmanın kendi adımında yapılır.
