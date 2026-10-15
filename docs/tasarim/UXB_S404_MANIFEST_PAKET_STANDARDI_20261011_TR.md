# uXBasic birinci sinif kutuphane tipi manifest paket standardi

Tarih: 2026-10-11
Durum: Kismen uygulandi, S-404 acik

## Uygulanan sozlesme

`LIBTYPE` manifestleri eski `uxb.library_type.contract.v1` semasini korur.
Asagidaki opsiyonel metadata alanlari registry'ye ve registry JSON cikitisina
tasinar:

```json
{
  "package": "uxmath.external_test",
  "version": "0.1.0",
  "dependencies": "uxmath.core>=0.1.0",
  "capabilities": "MIR_PROVIDER,LINEAR_MEMORY,NATIVE_X64"
}
```

Kaynak karsiligi:

- `package` -> `packageName`
- `version` -> `packageVersion`
- `dependencies` -> `dependenciesCsv`
- `capabilities` -> `capabilitiesCsv`

`version`, `dependencies` ve `capabilities` eksikse eski manifestler geriye
donuk okunur. Alan mevcut ama string degilse sessiz varsayilan kullanilmaz;
manifest reddedilir.

## Provider siniri

Bu metadata yalniz tanim ve raporlama bilgisidir. Bagimlilik indirme/cozme,
provider yukleme ve JS/WASM/native runtime govdesi bu halkada uygulanmis
sayilmaz. Provider registry ayri olarak `target + provider + type` eslesmesini
denetler ve desteklenmeyen hedefleri fail-closed reddeder.

## Kanit

- `tests/library_type_contract/rational_external.library_type.json` metadata
  alanlarini icerir.
- `test_library_type_contract.bas` registry yukleme ve alanlari dogrular.
- `tests/library_type_contract/run_library_type_tests.ps1`: **34/34 PASS**.
- `build_64.ps1 -Force`: exit 0.
- `tests/exceptions_cross`: **20/20 PASS**.
- `tests/task_model`: **192/192 PASS**.
- Tam `tests/run_all_model_tests.ps1` bu oturumda stdout/rapor uretmeden
  bekledi; kontrollu durduruldu ve PASS sayilmadi.

## Sonraki halka

1. `dependencies` icin yalniz manifest icinde deterministik, fail-closed
   uyumluluk kontrolu.
2. Registry metadata raporunun derleme raporuna baglanmasi.
3. Her hedef icin gercek provider descriptor/capability kaydi.
4. RATIONAL/TEXT_VALUE/TEXT_REF kabul vektorlerinin JS, WAT/WASM ve native
   x64'te gercek calistirilmasi.
