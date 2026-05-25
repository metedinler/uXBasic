# Copilot Step 4 — MIR Lowering Implementation Görevi

Copilot, önce şu komutu çalıştır:

```bat
uxb\compiler\scripts\run_step2_mir_lowering_cli_audit.bat
```

Sonra şu dosyayı oku:

```text
uxb\dist\step2\copilot_step4_mir_lowering_targets.md
```

## Kesin görev

Sadece bu dosyada görülen eksikleri tamamla.

## Kurallar

1. Yeni mimari icat etme.
2. `uxb/src/semantic/mir_opcode_contract.fbs` ve `mir_lowering_contract.fbs` sözleşmesini kullan.
3. Eksik MIR lowering için:
   - `mir_lower_expr.fbs`
   - `mir_lower_stmt.fbs`
   - `mir_lower_stmt_core_split.fbs`
   dosyalarında gerçek lowering ekle.
4. Eksik MIR x64 emit için:
   - `mir_x64_capability.fbs`
   - `mir_x64_codegen.fbs`
   - ilgili `mir_x64_*.fbs` module
   dosyalarında gerçek emit ekle.
5. Runtime isteyen öğeye sahte native kod yazma.
6. x64 AST codegen'i bozma.
7. x86 codegen'i silme; x86 ikincil hat olarak raporlanmalı.
8. Her committen sonra:
   ```bat
   build_compiler_64.bat
   uxb\compiler\scripts\run_step2_mir_lowering_cli_audit.bat
   uxb\compiler\scripts\run_mir_x64_completion_smoke.bat
   ```
   çalıştır.

## CLI dikkat

Compiler ileride şunu açık desteklemeli:

```bat
--emit-x64-nasm --codegen-source AST
--emit-x64-nasm --codegen-source MIR --enable-mir-x64-experimental
--build-x64 --codegen-source AST
--build-x64 --codegen-source MIR --enable-mir-x64-experimental
```

Eksik CLI option varsa önce CLI parser/value-arg listesine ekle ama eski seçenekleri bozma.

## Hata dili notu

Türkçe varsayılan, İngilizce ikinci dil olacak. Bu adımda mevcut hata metinlerini taşımak zorunda değilsin; ama yeni diagnostic metinlerini ileride i18n'e taşınabilir sabit anahtarlarla yaz.
