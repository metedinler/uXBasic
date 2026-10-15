# Copilot Adım 4 Görevi — TYPE / CLASS / FFI Gerçek Backend Bağlantısı

Copilot, bu görevde **TYPE / CLASS / FFI** hattını gerçek backend sözleşmesine bağlayacaksın.

## Önce oku

```text
uxb\docs\COPILOT_WORKSPACE_CLEAN_POLICY.md
uxb\docs\UXB_MIMARI_NOTU_BACKENDS_CLI_JSON_I18N.md
uxb\docs\STEP4_TYPE_CLASS_FFI_BACKEND_CONTRACT.md
uxb\dist\step4\copilot_step4_missing_work.md
```

## Kesin kurallar

1. Yeni mimari icat etme.
2. AST x64 codegen'i bozma.
3. MIR interpreter ve AST interpreter doğruluk referansı olarak kullanılacak.
4. Her katmanda çıkan hata ve çalışma mesajları loglanacak.
5. Varsayılan mesaj dili Türkçe olacak.
6. İkinci dil İngilizce olacak.
7. CLI'de dil seçimi açık olmalı:
   ```text
   --message-lang tr
   --message-lang en
   --dil tr
   --language en
   ```
8. Eski `LocalizeErrorMessage()` bozulmayacak; yeni message bus onun üstünde çalışacak.
9. `CALL DLL`, `CALL API`, `IMPORT`, `INLINE` sahte başarı vermeyecek.
10. Runtime/linker/toolchain eksiği varsa diagnostic verilecek.
11. Derleme/test/artifact çıktıları `uxb/src` içine yazılmayacak.
12. Her büyük işlemden önce/sonra:
    ```bat
    uxb\compiler\scripts\run_workspace_clean_guard.bat
    ```

## Bu patch ile gelen yeni contract dosyaları

```text
uxb/src/runtime/compiler_message_bus.fbs
uxb/src/runtime/layer_event_contract.fbs
uxb/src/semantic/type_class_ffi_backend_contract.fbs
uxb/src/codegen/x64/mir_x64_type_class_ffi_contract.fbs
uxb/src/codegen/x64/mir_x64_type_class_ffi_emit_helpers.fbs
```

## Include zinciri

`uxb/src/main.bas` veya uygun include bundle içinde şunları bağla:

```freebasic
#include once "runtime/compiler_message_bus.fbs"
#include once "runtime/layer_event_contract.fbs"
#include once "semantic/type_class_ffi_backend_contract.fbs"
#include once "codegen/x64/mir_x64_type_class_ffi_contract.fbs"
#include once "codegen/x64/mir_x64_type_class_ffi_emit_helpers.fbs"
```

Mevcut include sırasını bozma. İlgili temel dosyalar önce include edilmiş olmalı:

```text
runtime/diagnostics.fbs
runtime/error_localization.fbs
semantic/layout.fbs
semantic/mir_model.fbs
codegen/x64/mir_x64_context.fbs
codegen/x64/mir_x64_emit_helpers.fbs
codegen/x64/ffi_call_backend.fbs
```

## CLI dil seçimi

`main_program_entry.fbs` içinde arg parser'a ekle:

```text
--message-lang <tr|en>
--language <tr|en>
--dil <tr|en>
```

Value-arg listesine ekle:

```text
--message-lang
--language
--dil
```

Varsayılan:

```text
tr
```

CLI parsing bittikten hemen sonra:

```freebasic
UXBMessageBusSetLanguage(messageLang)
```

Eğer geçersiz dil verilirse:

```text
UXB_I18N_LANG_UNSUPPORTED
```

diagnostic ver ve `tr` kullan.

## Katman bazlı log

Her büyük katmanda şu olaylar loglanacak:

```text
SOURCE_LOAD
LEXER
PARSER
AST_CONTRACT
SEMANTIC
HIR
MIR_BUILD
MIR_VERIFY
AST_INTERPRETER
MIR_INTERPRETER
X64_AST_CODEGEN
MIR_X64_CODEGEN
X64_BUILD
TYPE_LAYOUT
CLASS_LAYOUT
FFI_ANALYZE
FFI_EMIT
INLINE_EMIT
IMPORT_RESOLVE
```

Kullanılacak helper:

```freebasic
UXBLayerEventBegin("MIR_X64_CODEGEN", sourcePath)
UXBLayerEventEnd("MIR_X64_CODEGEN", "ok", "")
UXBLayerEventDiagnostic("FFI_EMIT", "UXB_FFI_DLL_NOT_ALLOWED", "...")
```

Bu helperlar log-out/debug-log-out/hook trace ile çakışmayacak, onları tamamlayacak.

## TYPE field backend

Aşağıdakiler gerçek davranış almalı:

```basic
TYPE TPOINT
    X AS INTEGER
    Y AS INTEGER
END TYPE

DIM P AS TPOINT
P.X = 10
PRINT P.X
```

MIR x64 tarafı:

```text
LOAD_FIELD
STORE_FIELD
LOAD_ADDR field
```

Alan offseti layout/type table’dan alınacak. Uydurma offset yok. Offset bulunamazsa:

```text
UXB_TYPE_FIELD_OFFSET_MISSING
```

## CLASS / METHOD backend

İlk aşama gerçekçi kapsam:

```text
CLASS layout
THIS pointer
METHOD call direct dispatch
NEW object allocation
DELETE object release
CTOR call
DTOR call
```

Şimdilik virtual/inheritance için:

```text
UXB_CLASS_VIRTUAL_DISPATCH_PENDING
UXB_CLASS_INHERITANCE_BACKEND_PENDING
```

diagnostic verilebilir; ama direct method call çalışmalı.

## FFI backend

Kapsam:

```text
DECLARE DLL
CALL DLL
CALL API
IMPORT
INLINE x64
```

Kurallar:

1. `ffi_signer.fbs` allowlist/path validation korunacak.
2. Mutlak/kaçış path yasaksa aynen kalacak.
3. Win64 ABI:
   - RCX/RDX/R8/R9
   - 32-byte shadow space
   - 16-byte stack alignment
4. String argümanlar açıkça pointer/STRPTR/WSTRPTR olarak çözülecek.
5. F64 argümanlar XMM register istiyorsa destek yoksa diagnostic ver.
6. `INLINE x64` preserve list ve clobber bilgisi olmadan tehlikeli emit yapmayacak.
7. `IMPORT` interop manifest'e yazılacak.

## Copilot uygulama sırası

1. Audit çalıştır:
   ```bat
   uxb\compiler\scripts\run_step4_type_class_ffi_audit.bat
   ```
2. `copilot_step4_missing_work.md` oku.
3. Önce CLI dil anahtarlarını bağla.
4. Sonra layer event log helperlarını gerçek giriş noktalarına bağla.
5. Sonra TYPE field `LOAD_FIELD/STORE_FIELD` emitini tamamla.
6. Sonra CLASS direct method/THIS/NEW/DELETE/CTOR/DTOR için diagnostic + ilk emit hattını bağla.
7. Sonra FFI `CALL_DLL/CALL_API/IMPORT/INLINE` emitlerini gerçek backend'e bağla.
8. Her değişiklikten sonra:
   ```bat
   build_compiler_64.bat
   uxb\compiler\scripts\run_step4_type_class_ffi_audit.bat
   uxb\compiler\scripts\run_step3_project_runner.bat uxb\tests\basicCodeTests\50_type_field_numeric__dup1.bas
   ```

## Kabul şartları

1. `--message-lang tr/en` çalışır.
2. `--dil tr/en` çalışır.
3. Her katman için log/diagnostic kayıt sistemi vardır.
4. TYPE field offset uydurulmaz; layout'tan alınır.
5. CLASS direct method call en azından AST/MIR interpreter ile aynı doğruluğa bağlanır.
6. FFI path/signature validation korunur.
7. Unsupported FFI/OOP özellikleri sessiz geçmez.
8. JSON çıktıları parse edilebilir kalır.
