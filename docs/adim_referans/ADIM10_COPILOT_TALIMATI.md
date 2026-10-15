# 10 — ADIM5 Semantic / Type Binding / HIR / Layout FreeBASIC Yama Talimatı

Bu paket, `UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI/10_ADIM5_SEMANTIC_TYPE_HIR_LAYOUT.md` belgesinin FreeBASIC yama dosyalarını içerir.

## Sert kurallar

- Yeni Python aracı yazma.
- Mevcut Python/bat gate araçları varsa onları kullan.
- Klasör ağacını yeniden düzenleme.
- Dosya silme yok.
- Her çalışma başında `reports/control/current` içeriğini `reports/control/history/10_adim5_semantic_type_hir_layout_<timestamp>/` altına taşı.
- Lexer/parser/backend düzeltmesi yapma; bu adım sadece semantic/type/HIR/layout içindir.

## Eklenecek yeni dosyalar

Aşağıdaki dosyaları paket içindeki aynı yollardan repo içine kopyala:

```text
src/symbols/symbol_key.fbs
src/symbols/scope_table.fbs
src/symbols/symbol_index.fbs
src/symbols/symbol_integrity_gate.fbs
src/semantic/hir_ast_bridge.fbs
src/semantic/hir_scope_bridge.fbs
src/semantic/hir_symbol_bridge.fbs
src/semantic/hir_fact_table.fbs
src/semantic/hir_builder.fbs
src/semantic/hir_mir_bridge.fbs
src/semantic/hir_json_report.fbs
src/semantic/semantic_type_result.fbs
src/semantic/semantic_layout_snapshot.fbs
src/semantic/semantic_hir_layout_bridge.fbs
src/semantic/semantic_step5_gate.fbs
src/semantic/semantic_step5_json.fbs
```

## Değiştirilecek mevcut dosyalar

### 1. `src/symbols/symbol_table.fbs`

Bu pakette verilen `patch_files/src/symbols/symbol_table.fbs` ile değiştir. Ama önce mevcut dosyayı silmeden yedekle:

```powershell
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
New-Item -ItemType Directory -Force "_retired/adim10_backups_$stamp/src/symbols" | Out-Null
Copy-Item "src/symbols/symbol_table.fbs" "_retired/adim10_backups_$stamp/src/symbols/symbol_table.fbs"
Copy-Item "patch_files/src/symbols/symbol_table.fbs" "src/symbols/symbol_table.fbs" -Force
```

### 2. `src/symbols/symbol_resolver.fbs`

Bu pakette verilen `patch_files/src/symbols/symbol_resolver.fbs` ile değiştir. Mevcut `UXBStep3ResolveSymbol` fonksiyonu korunmuştur.

### 3. `src/semantic/hir.fbs`

Dosyanın başına, AST/HIR inventory tiplerinden önce veya `HIRSemanticAnalyze` fonksiyonundan önce şu include satırlarını ekle. Aynı include varsa tekrar yazma:

```freebasic
#include once "hir_ast_bridge.fbs"
#include once "hir_scope_bridge.fbs"
#include once "hir_symbol_bridge.fbs"
#include once "hir_fact_table.fbs"
#include once "hir_builder.fbs"
#include once "hir_mir_bridge.fbs"
#include once "hir_json_report.fbs"
```

Eski `SymbolTable`, `ScopeStack`, `gGlobalScope`, `gScopeStack` bloklarını silme. Üstüne şu yorumu ekle:

```freebasic
' DEPRECATED: HIR local symbol/scope structures are not compiler truth.
' Use UXBStep3Symbols + HIRFactTable bridge instead.
```

`Function HIRSemanticAnalyze(...)` gövdesini şu hale getir:

```freebasic
Function HIRSemanticAnalyze(ByRef ps As ParseState, ByRef errText As String) As Integer
    errText = ""

    If ps.rootNode = -1 Or ps.ast.count = 0 Then
        errText = "hir: bos AST"
        Return 0
    End If

    If HIRBuildBridgeAfterSemantic(ps, gHIRBridge, errText) = 0 Then Return 0
    If HIRPrepareMirLowering(ps, gHIRBridge, errText) = 0 Then Return 0

    Return 1
End Function
```

Eski inventory fonksiyonları korunacak.

### 4. `src/semantic/semantic_step3_gate.fbs`

Include listesine şu satırları ekle:

```freebasic
#include once "semantic_hir_layout_bridge.fbs"
#include once "semantic_step5_gate.fbs"
#include once "semantic_step5_json.fbs"
```

`SemStep3SemanticTypeLayoutGate` fonksiyonunun sonunda, `Step3ValidateTargetCoverage` çağrısından sonra ve `Return 1` öncesinde şu bloğu ekle:

```freebasic
    Dim step5 As UXBSemanticStep5Result
    Dim step5Gate As UXBSemanticStep5GateResult
    Dim step5Err As String

    If UXBSemanticStep5Run(ps, step5, step5Err) = 0 Then
        errText = step5Err
        Return 0
    End If

    If UXBSemanticStep5GateCheck(step5, step5Gate) = 0 Then
        errText = step5Gate.errorsText
        Return 0
    End If

    Dim writeErr As String
    UXBSemanticStep5WriteGateJson step5, step5Gate, "reports/control/current/adim5_gate.json", writeErr
    UXBSemanticStep5WriteGateMarkdown step5, step5Gate, "reports/control/current/adim5_gate.md", writeErr
    UXBSemanticStep5WriteTypeCsv step5, "reports/control/current/adim5_type_table.csv", writeErr
    UXBSemanticStep5WriteLayoutCsv step5, "reports/control/current/adim5_layout_report.csv", writeErr
```

## Test dosyaları

Aşağıdaki dosyaları repo içine kopyala:

```text
tests/adim10/positive/adim10_scope_type.bas
tests/adim10/positive/adim10_class_layout.bas
tests/adim10/negative/adim10_undefined_symbol.bas
tests/adim10/negative/adim10_type_mismatch.bas
compiler/scripts/run_adim10_semantic_step5_gate.ps1
```

## Çalıştırma

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
PowerShell -ExecutionPolicy Bypass -File compiler/scripts/run_adim10_semantic_step5_gate.ps1
```

## PASS şartı

- FreeBASIC derleme PASS.
- Pozitif semantic/type/HIR/layout testleri PASS.
- Negatif undefined symbol ve type mismatch testleri FAIL dönmeli.
- `reports/control/current/adim5_gate.json` oluşmalı.
- `adim5_gate.json` içinde `ok: true` olmalı.
- Yeni Python aracı yazılmamış olmalı.
