# ADIM24 — JS Source Emit / MIR SourceLocation Uyumluluk Düzeltmesi

## Amaç

ADIM23 sonrası kalan ilk bloklayıcı `src/codegen/js/js_source_emit.fbs` dosyasındadır.
Bu dosya eski bir MIR instruction modelini varsaymaktadır:

```text
ins.sourceFile
ins.sourceLine
ins.sourceColumn
ins.sourceAstKind
ins.sourceLexeme
```

Fakat mevcut gerçek model şudur:

```freebasic
Type MIRIRInstruction
    opcode As String
    operands(0 To 15) As String
    operandCount As Integer
    result As String
    blockId As Integer
    srcLoc As SourceLocation
    comment As String
    flags As Integer
End Type
```

Bu nedenle çözüm yeni alan eklemek değildir. JS source comment üretimi `srcLoc`, `MIRGetSourceLine()` ve `MIRInstructionHasSource()` üzerinden yapılmalıdır.

## Uygulama

1. `patch_files/src/codegen/js/js_source_emit.fbs` dosyasını repo içinde aynı yola kopyala:

```text
uxb/src/codegen/js/js_source_emit.fbs
```

2. Başka dosyaya dokunma.
3. `MIRIRInstruction` içine `sourceFile/sourceLine/sourceColumn/sourceAstKind` alanları ekleme.
4. `js_emitter.fbs`, `js_codegen.fbs`, `main.bas`, `main_program_entry.fbs` dosyalarını bu adımda değiştirme.
5. Placeholder artifact üretme.

## Komut

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc"

powershell -NoProfile -ExecutionPolicy Bypass `
  -File uxb\compiler\scripts\run_adim23_lifecycle_web_output_binding_gate.ps1 `
  -NoRepair

Get-Content uxb\reports\control\current\adim23_lifecycle_web_output_binding_gate.json -TotalCount 80
Get-Content uxb\reports\control\current\adim23_compile.log -TotalCount 160
```

## Beklenen

Şu hatalar kaybolmalı:

```text
ins.sourceFile element not defined
ins.sourceLine element not defined
ins.sourceColumn element not defined
ins.sourceAstKind element not defined
```

Yeni hata gelirse, artık sıradaki gerçek bloklayıcıdır.

## JS transpiler durumu

Bu düzeltme JS transpiler'ı tamamlamaz. Sadece JS source mapping/comment adaptörünü mevcut MIR modeliyle uyumlu hale getirir.
Tam JS transpiler kalitesi için ayrıca opcode coverage, JS runtime call route, native-only fail gate, browser artifact ve expected/actual testlerinin geçmesi gerekir.
