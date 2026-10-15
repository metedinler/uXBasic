# UXB ABI10 FFI Token Type Fix (05.07.2026)

Bu paket ABI10 smoke zincirinde görülen `semantic-step3: type: unknown symbol: void` hatasını hedefler.

## Kök neden

`CALL(DLL, ...)` ifadesindeki `DLL`, `VOID`, `CDECL`, `I32`, `F64`, `PTR`, `STRPTR` gibi parçalar runtime argümanı değil FFI imza/metaverisidir. Parser bunları bazı akışlarda `IDENT` veya `KEYWORD_REF` düğümü olarak bıraktığı için semantic step3 expression taraması bu düğümleri tek başına ziyaret edip kullanıcı değişkeni sanıyordu. Önce `dll`, sonra `void` hatası bu yüzden oluştu.

## Değişiklik

- `src/type_binding/type_infer_expr.fbs` içine `UXBStep3InferBareFfiMetaType` eklendi.
- `UXBStep3InferIdentType` başlangıcında FFI metadata/type tokenları güvenli biçimde kanonik tipe bağlandı.
- Önceki owner/metadata semantic düzeltmesi korunur.
- ABI10 runner ve test DLL build betikleri önceki sağlamlaştırılmış halleriyle paketlenir.

## Uygulama

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
Expand-Archive -LiteralPath .\UXB_ABI10_FFI_TOKEN_TYPE_FIX_20260705_DIRECT_ROOT.zip -DestinationPath . -Force

powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\build_uxb_main_64.ps1 `
  -Root . `
  -Force `
  -SkipX86

.\bin\uxb.exe `
  --source tests\libraries\abi10\abi10_smoke.uxb `
  --execmem `
  --interpreter-backend AST `
  --console-mode direct `
  --stdout-out reports\libraries\tests\abi10\manual_ast.stdout.txt `
  --stderr-out reports\libraries\tests\abi10\manual_ast.stderr.txt `
  --program-output-out reports\libraries\tests\abi10\manual_ast.program_output.txt
```
