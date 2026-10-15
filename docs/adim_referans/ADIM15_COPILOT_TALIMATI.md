# ADIM 15 / ADIM 10 — FFI / Library / IMPORT / INCLUDE / DLL/API

Bu belge `README/15_ADIM10_FFI_LIBRARY_IMPORT_INCLUDE.md` planının uygulanması için hazırlanmıştır. Bu adım 14 numaralı JS/WAT/WASM/BROWSER backend adımından sonra gelir.

## Mutlak kurallar

1. Yeni Python aracı yazma.
2. Ana dosyaları komple ezme.
3. `src/parser/ast.fbs` ve `src/parser/ast_contract.fbs` dosyalarına dokunma.
4. `src/runtime/exec/exec_ffi_runtime.fbs`, `src/build/interop_manifest.fbs`, `src/parser/parser/parser_stmt_decl_core.fbs` gibi mevcut dosyaları silme veya baştan yazma.
5. Yeni `.fbs` dosyalarını aynı repo yollarına kopyala.
6. Mevcut dosyalara sadece bu belgede belirtilen include/çağrı snippetlerini ekle.
7. Derleme adımı çalıştırılacak; derleme hatasında otomatik tamirat yapılmayacak.
8. `reports/control/current` her koşudan önce silinmeden history altına taşınacak.
9. Gate PASS olmadan başarı yazma.

## Bu adım ne yapar?

Bu adım dış dünya bağlantılarını tek sözleşmeye bağlar:

- `CALL(DLL,...)`
- `CALL(API,...)`
- `CALL_EXTERNAL`
- `IMPORT(C)`, `IMPORT(CPP)`, `IMPORT(ASM)`
- `INCLUDE`
- Library registry surface öğeleri
- Native-only hedef diagnosticleri

## Eklenecek yeni dosyalar

Aşağıdaki dosyaları `patch_files` altından aynı repo yoluna kopyala:

```text
src/semantic/ffi_signature_binding.fbs
src/runtime/ffi_registry.fbs
src/runtime/services/runtime_library_registry_adim15.fbs
src/build/interop_manifest_policy_adim15.fbs
src/build/interop_manifest_json_adim15.fbs
src/parser/parser/parser_ffi_import_contract_adim15.fbs
src/backend/backend_native_only_diagnostics_adim15.fbs
src/codegen/x64/mir_x64_ffi_contract_gate_adim15.fbs
src/codegen/x86/mir_x86_ffi_contract_gate_adim15.fbs
```

## Mevcut dosyalara kontrollü merge

### 1. `src/main.bas`

`runtime / semantic / build / backend include` bölümlerine, ilgili ana dosyalar zaten include edildikten sonra ekle:

```freebasic
#include once "semantic/ffi_signature_binding.fbs"
#include once "runtime/ffi_registry.fbs"
#include once "runtime/services/runtime_library_registry_adim15.fbs"
#include once "build/interop_manifest_policy_adim15.fbs"
#include once "build/interop_manifest_json_adim15.fbs"
#include once "parser/parser/parser_ffi_import_contract_adim15.fbs"
#include once "backend/backend_native_only_diagnostics_adim15.fbs"
#include once "codegen/x64/mir_x64_ffi_contract_gate_adim15.fbs"
#include once "codegen/x86/mir_x86_ffi_contract_gate_adim15.fbs"
```

### 2. `src/parser/parser/parser_stmt_decl_core.fbs`

IMPORT/INCLUDE parse edilirken path/language doğrulaması için yeni helper kullanılacak. Dosya komple ezilmeyecek. IMPORT parse noktasına şuna benzer kontrol eklenecek:

```freebasic
Dim ffiImportErr As String
If UXBParserValidateImportIncludeAdim15(langText, pathText, ffiImportErr) = 0 Then
    ParserError ps, ffiImportErr
    Return -1
End If
```

Eğer mevcut parser error fonksiyonunun adı farklıysa, aynı anlamdaki mevcut error reporting fonksiyonunu kullan.

### 3. `src/build/interop_manifest.fbs`

Mevcut `InteropManifest` tipi ve fonksiyonları korunacak. JSON/export ve policy için yeni dosyadaki wrapper fonksiyonlar kullanılacak:

```freebasic
UXBInteropAdim15ValidateManifest manifest, targetText, report, errText
UXBInteropAdim15WriteManifestJson manifest, outPath, errText
```

### 4. `src/runtime/exec/exec_ffi_runtime.fbs`

Mevcut execution helper silinmeyecek. Çağrıdan önce signature/allowlist contract çalıştırılacak:

```freebasic
Dim ffiContract As UXBFFIContract
Dim ffiContractErr As String
If UXBFFIRegistryResolveCall(libName, symbolName, signatureText, conventionText, targetText, ffiContract, ffiContractErr) = 0 Then
    Return ExecRuntimeError(ffiContractErr)
End If
```

Mevcut runtime error fonksiyon adı farklıysa projedeki karşılığını kullan.

### 5. `src/backend/backend_step6.fbs`

JS/WASM hedefinde DLL/API/Native-only surface görülürse sessiz geçiş yok. `UXBBackendNativeOnlyDiagnosticAdim15` kullanılacak.

## Derleme / kontrol komutu

```powershell
compiler/scripts/run_adim15_ffi_library_import_gate.ps1 -NoRepair
```

Bu script tamirat yapmaz. Sadece derler, raporlar ve hatayı sınıflandırır.

## Beklenen raporlar

```text
reports/control/current/adim10_ffi_matrix.csv
reports/control/current/adim10_library_registry_matrix.csv
reports/control/current/adim10_import_include_matrix.csv
reports/control/current/adim10_interop_manifest.json
reports/control/current/adim10_positive_tests.csv
reports/control/current/adim10_negative_tests.csv
reports/control/current/adim10_compile.json
reports/control/current/adim10_gate.json
reports/control/current/adim10_gate.md
```

## Bitme şartı

Adım 15 ancak şu durumda biter:

- FFI signature parser çalışır.
- `CALL(DLL/API)` native hedefte contract alır.
- JS/WASM hedefte native-only diagnostic verir.
- IMPORT/INCLUDE path güvenliği çalışır.
- Interop manifest JSON üretir.
- Pozitif ve negatif testler raporlanır.
- Derleme denenir ama hata varsa otomatik tamir yapılmaz.
