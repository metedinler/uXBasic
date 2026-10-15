# ADIM50 Master V2 İnceleme ve Kurtarma Raporu

Bu paket, Mete abi'nin kanonik kararlarına göre `src(31.05_3)` hattını kayıpsız toparlamak için hazırlandı.

## Temel kararlar

- Ana gövde: `src(31.05_3).zip` ve önceki kurtarmayla oluşan `src_31_05_3_ADIM50_RECOVERED.zip`.
- Altın referans çizgisi: Adım45 hata merkezi + Adım47 operatör/logic16 + Adım48/Adım36 son 5 hata düzeltme ailesi.
- Yanlış kabul edilen yüzeyler: `PARALLEL`, `THREAT`, `SIHIRLIMETOT`.
- Doğru yüzeyler: `THREAD`, `PARALEL`, `MAGIC`.

## Bu turda yapılan gerçek düzeltme

Önceki kurtarma paketindeki alias/uyumluluk yaklaşımı kaldırıldı. Aktif `.fbs/.bas/.bi` kaynaklarında yanlış anahtarlar kanonik karşılıklarına çevrildi.

- `PARALLEL` → `PARALEL`
- `THREAT` → `THREAD`
- `SIHIRLIMETOT` → `MAGIC`
- `MIR_PARALLEL_HINT` → `MIR_PARALEL_HINT`
- `ASTK_PARALLEL_STMT` → `ASTK_PARALEL_STMT`

## Statik doğrulama sonucu

- PASS `forbidden_active_token_PARALLEL` = 0
- PASS `forbidden_active_token_THREAT` = 0
- PASS `forbidden_active_token_SIHIRLIMETOT` = 0
- PASS `required_symbol_THREAD` = 88
- PASS `required_symbol_PARALEL` = 100
- PASS `required_symbol_MAGIC` = 130
- PASS `required_symbol_UXB_TARGET_WAT` = 8
- PASS `required_symbol_UXB_TARGET_X86` = 7
- PASS `required_symbol_UXBFFIContract` = 8
- PASS `required_symbol_UXBFFIRegistryMakeContract` = 3
- PASS `required_symbol_UXBFFIRegistryResolveCall` = 3
- PASS `required_symbol_UxbFileInputLine` = 2
- PASS `required_symbol_UxbFileEnsureParentDirectory` = 5
- PASS `required_symbol_ExecRunPrintFileStmt` = 3
- PASS `required_symbol_ParseWhileStmt` = 3
- PASS `required_symbol_ExecRunWhileStmt` = 2
- PASS `required_symbol_ExecEvalBuiltinTextCategory` = 2
- PASS `required_symbol_SEM_E_INVALID_SLOT_RANGE` = 2
- PASS `required_symbol_ASTK_PARALEL_STMT` = 6
- PASS `required_symbol_UXB_MIR_OPCODE_MIR_PARALEL_HINT` = 2
- PASS `required_symbol_STMT_HANDLER_PARALEL` = 3
- PASS `required_symbol_STMT_HANDLER_WHILE` = 3
- PASS `missing_internal_includes` = 0

## Korunan ana bağlantılar

| Hat | Korunan/bağlanan dosyalar |
|---|---|
| Lexer → Parser yüzeyi | `parser/lexer/lexer_keyword_table.fbs`, `parser/parser/parser_stmt_event_pipe.fbs`, `parser/parser/parser_stmt_registry.fbs` |
| Parser → AST | `parser/ast_node_kinds.fbs`, `parser/ast_contract_registry.fbs`, `parser/ast_contract_layer_bindings.fbs` |
| AST → MIR | `semantic/ast_mir_route_table_adim25.fbs`, `semantic/ast_mir_coverage_gate_adim25.fbs`, `semantic/mir.fbs` |
| MIR → interpreter/runtime | `runtime/memory_exec.fbs`, `runtime/exec/*`, `runtime/file_io.fbs` |
| MIR → native/web backend | `backend/common/backend_target.fbs`, `codegen/x64/*`, `codegen/x86/*`, `codegen/js/*`, `codegen/wasm/*` |
| Hata merkezi | `common/error_system_adim45.fbs`, `runtime/diagnostics.fbs`, `runtime/error_localization.fbs` |
| FFI/DLL/API | `runtime/ffi_registry.fbs`, `semantic/ffi_signature_binding.fbs`, `parser/parser/parser_ffi_import_contract_adim15.fbs` |
| Operator/logic16 | `parser/parser/parser_adim08_operator_contract.fbs`, `backend/common/backend_emit_policy.fbs`, `mir/mir_registry.fbs` |

## Kalan yapılacak iş

Bu paket statik doğrulama paketidir. FreeBasic derleme bu ortamda çalıştırılamadı. Bilgisayarda çalıştırılacak ilk komut:

```powershell
python verify_adim50_master_v2.py "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
```

Sonraki hamlede bu statik doğrulamanın üstüne gerçek test runner ve derleme kapısı eklenecek.
