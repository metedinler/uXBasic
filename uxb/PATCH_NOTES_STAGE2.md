# uXBasiC Stage 2 — AST Contract / Traversal / Validation Patch

Bu paket davranış değiştirmeyen bir altyapı hamlesidir. Parser'ın ürettiği AST değişmez; sadece AST'yi güvenli okumak ve doğrulamak için yeni yardımcı katman eklenir.

## Eklenen dosyalar

```text
uxb/src/parser/ast_contract.fbs
uxb/docs/AST_CONTRACT.md
uxb/tests/ast/ast_contract_manual_probe.bas
uxb/tools/apply_stage2_ast_contract_patch.py
```

## Elle uygulanacak ana include değişiklikleri

`uxb/src/main.bas` içinde:

```freebasic
#include "parser/ast.fbs"
#include "parser/ast_contract.fbs"
```

`uxb/src/build/main_frontend_include_bundle.fbs` içinde:

```freebasic
#include "../parser/ast.fbs"
#include "../parser/ast_contract.fbs"
```

## CLI entegrasyonu

Patch scripti uygulanırsa şu seçenekler eklenir:

```bat
--ast-contract-json-out <path>
--ast-contract-check
```

## Test

```bat
cd /d C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo\uxb
python tools\apply_stage2_ast_contract_patch.py
compiler\scripts\build_uxb_main_64.bat
build\uxb_main_64.exe tests\basicCodeTests\42_uxb_native_console_codegen_smoke.bas --ast-contract-json-out dist\ast_contract.json --ast-contract-check --debug
```

Ek manuel probe:

```bat
fbc tests\ast\ast_contract_manual_probe.bas -x build\ast_contract_manual_probe.exe
build\ast_contract_manual_probe.exe
```
