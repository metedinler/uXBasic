# UXB S410 Library Type Tani Dikey Halkasi

## Baglayici karar

2026-10-11 tarihinde motor sadelestirme onerisi (S-409/T09) kabul edilmedi.
AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM uretim yollari korunur. Bir komutun
tasarim disi bir hedefte calismamasi, hedefe gore sessizce farkli davranis
yerine ortak tanimlanmis bir diagnostic code ile bildirilmelidir.

## Bu halkanin kapsami

Bu halka birinci sinif kutuphane tipi provider sozlesmesinin hata yuzeyini
standartlastirir. Motor secimini veya provider implementasyonunu degistirmez.

1. Secim hedefinde lifecycle/provider bulunmuyorsa `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`
   code'u kullanilir.
2. MIR provider registry'de provider yoksa
   `UXB_LIBTYPE_PROVIDER_MISSING` code'u kullanilir.
3. Provider kayitli olsa da tipi desteklemiyorsa
   `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH` code'u kullanilir.
4. `UXBOutputContractPushFailureDiagnostic`, target gate mesajini tek bir iki
   dilli `UXBDiagnostic` kaydina cevirir. Kayit `all_diagnostics.json` ve VS Code
   cikti yoluna ayni code ile tasinir.
5. Error center catalog ve legacy JSON yolu ayni code'lari tanir.

## Kaynak degisiklikleri

- `src/common/error_system_adim45.fbs`: uc provider code'u catalog'a ve legacy
  code inference yoluna eklendi.
- `src/semantic/library_type_contract.fbs`: target reddi canonical code ile
  baslar ve hedef adi normalize edilir.
- `src/main_output_contract_bridge.fbs`: provider reddi iki dilli, source
  location bilgili ve target validation asamasina ait tek diagnostic kaydina
  donusturulur.
- `src/main_program_entry.fbs`: library type target gate reddi birlesik
  diagnostics listesine yazilir.
- `src/interpreter/mir/mir_interp_library_type.fbs`: MIR provider missing ve
  type mismatch runtime mesajlari ayni code ailesine baglanir.

## Kanit

`tests/library_type_contract/run_library_type_tests.ps1` guncel kaynakla
38/38 PASS'tir. Buna uc code'un legacy structured JSON inference testini yapan
`test_library_type_error_catalog.bas` dahildir.

Temiz HEAD runtime'i ve Codex source degisiklikleriyle uretilen ayri scratch
binary `tmp/codex_build_baseline/uxb_s410.exe` SHA256
`78910FF063DB1DAD7E25D6A23DF39B386C67A975C0F055114D86FBE2E5CE0FDA` olarak
38/38 PASS verdi. Managed provider negatif kosusu AST, AST-x64, MIR-x64,
NATIVE, JS, WAT ve WASM hedeflerinin yedisinde de cikis 1, ayni
`UXB_LIBTYPE_PROVIDER_UNAVAILABLE` code'u ve `target_validation` phase'i ile
gecildi. MIR yolu ayni fixture'da OWNED_TEXT_REFERENCE provider'i kullanarak
cikis 0 verdi ve provider error uretmedi.

`--semantic-diagnostics-json-out` ile uretilen katman failure dosyasi da
`code`, `layer`, `phase`, `message_en`, `message_tr` ve `details` alanlarini
tasiyor. Ornek: `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`, `library_type`,
`target_validation`, `NATIVE: TEXT_REF`.

Ana `build_64.ps1 -Force` bu halkada tamamlanamadi. Paylasilan calisma
agacindaki `src/runtime/exec/exec_eval_support_helpers.fbs` dosyasi derleyicide
`ExecVarAt` ile `routineIndexCap/routineIndexSlots` tanimsizligi uretiyor. Bu
dosya Claude'un aktif inceleme alanindadir; Codex tarafindan degistirilmedi.
Bu nedenle yeni main binary ile AST/MIR/native/JS/WAT/WASM kosusu henuz kabul
kaniti degildir. Mevcut `bin/uxb.exe` eski binary'dir.

## Acik kalanlar

- Ana build yeniden alinacak ve `--all-diagnostics-json-out` ile target gate
  reddi tum ilgili hedeflerde code/message olarak olculecek.
- Diger error producer'lari da ayni structured envelope'a alinacak; bu halka
  library type failure yolunu kapatmistir.
- Gercek JS/WASM/native provider implementasyonlari ve provider ABI registry
  hala aciktir; metadata capability beyani implementasyon kaniti degildir.
- COMPLEX, POLYNOMIAL, MATRIX ve diger paketler henuz birinci sinif paket
  kapanisi degildir.
- S-410'un tam kapanisi icin lexer/parser/semantic/MIR/backend/runtime hata
  yuzeylerinin ayni session, source location ve final status sozlesmesiyle
  olculmesi gerekir.
