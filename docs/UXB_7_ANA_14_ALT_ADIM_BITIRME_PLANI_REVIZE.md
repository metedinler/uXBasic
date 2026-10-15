# UXBc 7 Ana / 14 Alt Adım Revize Plan

## Ek notlar
- x86 codegen unutulmayacak; ama ikincil/legacy backend olarak korunacak.
- Ana hedefler: x64 AST codegen ve MIR x64 codegen.
- CLI anahtarlama compiler'ın ana gücüdür; ayrı denetlenecek.
- JSON çıktıları standartlaştırılacak.
- Hata mesajları için varsayılan dil Türkçe, ikinci dil İngilizce olacak; dil dosyası dışarıda duracak.

## Adım 2 kapsamı
Adım 2 MIR lowering sözleşmesi ve CLI hat denetimidir.

Eklenen modüller:
- `uxb/src/semantic/mir_opcode_contract.fbs`
- `uxb/src/semantic/mir_lowering_contract.fbs`
- `uxb/tools/uxb_step2_mir_lowering_cli_audit.py`
- `uxb/i18n/tr.json`
- `uxb/i18n/en.json`

Bu adım compiler davranışını zorla değiştirmez; Copilot'un sonraki alt adımda neyi kodlayacağını netleştirir.
