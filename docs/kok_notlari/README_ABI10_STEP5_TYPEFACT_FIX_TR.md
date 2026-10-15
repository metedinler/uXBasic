# UXB ABI10 Step5 TypeFact Fix (05.07.2026)

Bu yama ABI10 smoke testinde semantic/type zincirinde görülen şu aşamayı hedefler:

- Önce `CALL(DLL, ...)` kaynak dosyası CLI'ye ulaşmıyordu.
- Sonra `DLL` ve `VOID` FFI metadata tokenları normal değişken sanıldı.
- Token/type düzeltmesi sonrası Step5 type-fact gate, deklarasyon adı veya FFI metadata olan bazı IDENT düğümlerini hâlâ `MISSING_TYPE` saydı.

Bu paket, önceki ABI10 runner + FFI metadata düzeltmelerini korur ve ek olarak:

- `src/semantic/semantic_hir_layout_bridge.fbs` içinde FFI metadata isimlerini Step5 type-fact seviyesinde `NOT_REQUIRED` kabul eder.
- FUNCTION/SUB/DECLARE/PARAM/TYPE_REF/RETURN_TYPE gibi isim-only bağlamlardaki IDENT düğümlerini çalıştırılacak expression gibi zorunlu type istemekten çıkarır.

Değişen dosyalar:

- compiler/scripts/run_library_abi10_smoke.ps1
- tests/libraries/abi10/build_abi10_test_dll.bat
- tests/libraries/abi10/build_abi10_test_dll.ps1
- src/semantic/semantic_step3_gate.fbs
- src/semantic/semantic_hir_layout_bridge.fbs
- src/type_binding/type_infer_expr.fbs

Uygulama sonrası x64 compiler yeniden üretilmelidir:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\build_uxb_main_64.ps1 `
  -Root . `
  -Force `
  -SkipX86
```
