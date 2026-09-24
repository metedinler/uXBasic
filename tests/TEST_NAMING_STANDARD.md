# Test Naming Standard (v1)

Bu proje icin test adlandirma standardi zorunludur.

## 1) Manifest Test ID Formati

Tum `tests/manifest.csv` satirlari su kimlik formatini kullanir:

`TST-<GROUP>-<SUBGROUP...>-<seq3>`

Ornekler:
- `TST-OP-POW-001`
- `TST-MEMCOPYW-001`
- `TST-INLINE-X64-FAIL-001`

Kurallar:
- Prefix her zaman `TST-`.
- Prefix sonrasi sadece buyuk harf, rakam ve `-` kullanilir.
- Son bolum her zaman uc haneli sirali numaradir (`001`, `002`, ...).
- FAIL varyantlari ad icinde `-FAIL-` ile belirtilir.

## 2) Standalone Runner Dosya Formati

`tests/run_*.bas` dosyalari su sekilde adlandirilir:
- `run_<domain>_<scope>.bas`
- sadece kucuk harf, rakam ve `_`

Ornekler:
- `run_manifest.bas`
- `run_file_io_runtime.bas`
- `run_inline_x64_backend.bas`

## 3) Plan Referans Formati

`tests/plan/command_compatibility_win11.csv` icindeki `test_ref` alaninda:
- Manifest testleri icin sadece gecerli `TST-...` kimlikleri kullanilir.
- Compat testleri (`CMP-*`) oldugu gibi korunur.
- Bos test_ref kullanilmaz.

`tests/plan/command_compatibility_win11.csv` icindeki `command` alaninda:
- Komut adlarinda `_` kullanilmaz.
- Alt cizgi sadece degisken adlarinda kullanilir, komut adlarinda kullanilmaz.

`tests/plan/cmp_interop_win11.csv` icinde:
- `cmp_id` alani `CMP-<GROUP...>` formatini kullanir.
- `cmp_id` degerleri tekildir.
- `evidence` alani `tests/...` goreli path olmalidir ve dosya gercekten var olmalidir.

## 4) Phase Coverage Kurali

`tests/manifest.csv` icindeki tum phase alanlari su kurallara uyar:
- Format: `phase<index>` (or. `phase8`, `phase20`).
- Her phase index'i en az bir satirla dolu olmalidir.
- Min ve max phase araliginda bosluk (index atlama) olmaz.

`tests/plan/command_compatibility_win11.csv` icinde:
- Her manifest phase'i en az bir `TST-...` referansi ile kapsanir.

## 5) CI Kurali

Asagidaki dogrulama scripti CI'da calisir:
- `tools/validate_test_naming.ps1`

Bu script basarisiz olursa merge edilmez.
