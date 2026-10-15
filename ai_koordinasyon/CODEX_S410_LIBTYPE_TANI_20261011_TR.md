# Codex S410 Library Type Tani Kaydi - 2026-10-11

## Karar

S-409/T09 motor sadelestirme onerisi uygulanmadi. Alti uretim yolu korunur:
AST, MIR, MIR-x64, AST-x64, JS ve WAT/WASM. Tasarim disi calisma icin ortak
diagnostic kimligi zorunludur.

## Uygulama

Provider hata ailesi eklendi:

- `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`
- `UXB_LIBTYPE_PROVIDER_MISSING`
- `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH`

Target gate, error center catalog, legacy JSON inference, birlesik diagnostics
listesi ve MIR provider runtime yolu birbirine baglandi. Library target gate
reddi artik `frontendDiagnostics` listesine de yaziliyor.

## Kanit

`tests/library_type_contract/run_library_type_tests.ps1`: 38/38 PASS.
Yeni birim: `test_library_type_error_catalog.bas`.

Temiz HEAD runtime + Codex patch scratch binary'si
`tmp/codex_build_baseline/uxb_s410.exe`
(`78910FF063DB1DAD7E25D6A23DF39B386C67A975C0F055114D86FBE2E5CE0FDA`) ile
structured target kosusu AST/AST-x64/MIR-x64/NATIVE/JS/WAT/WASM icin 7/7 PASS
verdi. Her biri exit 1, `UXB_LIBTYPE_PROVIDER_UNAVAILABLE`,
`target_validation` ve hedef adini tasiyan `message_en` uretti. MIR ayni
fixture'da provider'i kullanarak exit 0 verdi ve provider error uretmedi.

Katman failure JSON'u da dogrudan kontrol edildi: `code`, `layer`, `phase`,
`message_en`, `message_tr` ve `details` alanlari mevcut; ornek code
`UXB_LIBTYPE_PROVIDER_UNAVAILABLE`, phase `target_validation`.

`build_64.ps1 -Force`: FAIL, ancak hata bu halkanin dosyalarinda degil;
`src/runtime/exec/exec_eval_support_helpers.fbs` icinde `ExecVarAt` ve
`routineIndexCap/routineIndexSlots` tanimsizligi var. Claude aktif gorev alanina
ait dosyaya dokunulmadi. Bu sebeple guncel main binary uretilemedi ve target
diagnostic parity'si yeni binary ile henuz kapanmadi.

## Sonraki adim

Build engeli kalkinca ayni kosu guncel paylasilan binary ile tekrarlanacak;
sonra diger error producer'lari ayni structured envelope'a alinacak.
JS/WASM/native provider implementasyonlari ayri halkalardir.
