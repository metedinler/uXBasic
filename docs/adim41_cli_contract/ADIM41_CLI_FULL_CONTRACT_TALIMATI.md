# ADIM41 — CLI Full Contract Patch Talimatı

Bu yama, 119 CLI seçeneğini yalnız argüman olarak değil, gerçek output contract olarak ele alır.

## Kaynak karar

- Toplam seçenek: 119
- Türkçe alias kaldırılacak: `--ayikla`, `--sessiz`, `--semantik`
- Her seçenek için 3 harfli kısa komut vardır.
- `*-out` ve `*json*` seçenekleri gerçek dosya üretmelidir.
- Placeholder, boş dosya ve bozuk JSON kabul edilmez.
- VSCode tarafından kullanılan veya kullanılabilecek çıktıların geriye uyumluluğu korunur.

## Eklenen dosyalar

```text
src/cli/cli_registry_adim41.fbs
src/cli/cli_output_contract_adim41.fbs
src/main_cli_bridge_adim41.fbs
src/main_output_contract_bridge_adim41_ext.fbs
tools/control/uxb_cli_full_contract_gate.py
compiler/scripts/run_adim41_cli_full_contract_gate.ps1
tests/adim41_cli/cli_smoke.bas
docs/ADIM41_CLI_COMMAND_MATRIX.csv
docs/ADIM41_CLI_COMMAND_MATRIX.json
docs/output_templates/ADIM41_OUTPUT_TEMPLATES.md
```

## Uygulama

1. Dosyaları aynı repo yollarına kopyala.
2. `main.bas` veya `main_program_entry.fbs` include zincirine şunları ekle:

```freebasic
#include once "cli/cli_registry_adim41.fbs"
#include once "cli/cli_output_contract_adim41.fbs"
#include once "main_cli_bridge_adim41.fbs"
#include once "main_output_contract_bridge_adim41_ext.fbs"
```

3. CLI argüman normalizasyon noktasında `UXBNormalizeCliArgAdim41` çağır.
4. Output path istenen seçeneklerde `UXBCliOutputContractValidatePathAdim41` çağır.
5. Gerçek yazıcıları şu köprüye bağla:
   - tokens → lexer writer
   - parser diagnostics → parser writer
   - AST → AST writer
   - semantic/symbol/type/layout/HIR → semantic writer
   - MIR/MIR verify/MIR surface → MIR writer
   - JS/WAT/WASM/HTML/manifest → backend/browser artifact writer
   - stdout/stderr/runtime trace → interpreter runtime writer

## Yasaklar

- Türkçe CLI seçeneklerini geri ekleme.
- Output istenince placeholder üretme.
- Dosya uzantısı yanlışsa sessiz geçme.
- `current` raporlarını karıştırma; gate raporları ayrı dosya yazmalı.

## Çalıştırma

```powershell
powershell -NoProfile -ExecutionPolicy Bypass `
  -File compiler\scripts\run_adim41_cli_full_contract_gate.ps1 `
  -NoRepair
```

## Başarı ölçütü

```text
adim41_cli_full_contract_gate.json
ok = true
command_count = 119
duplicate_short_count = 0
removed_turkish_alias_count = 3
```

Not: Bu gate ilk aşamada registry ve output contract doğrular. Gerçek compiler output run için sonraki ADIM41B scripti her file-output seçeneğini örnek programla çalıştırmalıdır.
