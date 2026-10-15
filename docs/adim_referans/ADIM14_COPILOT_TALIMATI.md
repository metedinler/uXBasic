# 14 — ADIM9: JS / WAT / WASM / Browser Backend Profesyonel Yaması

## 0. Bu adımın anlamı

Bu adım, önceki `13_ADIM8_BACKEND_X64_X86` yamasının devamıdır. 13. adım native x64/x86 tarafını hedefliyordu. 14. adım ise web hedeflerini kapatır:

```text
JS emitter
WAT emitter
WASM binary için WABT / wat2wasm köprüsü
Browser HTML/CSS/manifest artifact üretimi
Backend web gate ve expected/actual raporu
```

Bu adımın amacı “çalışıyormuş gibi” JS/WASM üretmek değildir. Her unsupported opcode veya eksik toolchain açık diagnostic üretmelidir.

## 1. Kesin kurallar

```text
Yeni Python aracı yazma.
Ana dosyaları komple ezme.
Mevcut JS/WASM backend dosyalarını silme.
Mevcut backend_step6 dispatch fonksiyonunu silme.
Bu adımda derleme yapılacak ama otomatik tamirat yapılmayacak.
Derleme hatası varsa sadece raporlanacak; kaynak dosyada yeni müdahale yapılmayacak.
```

## 2. Eski kod nerede?

Bu adımın bağlanacağı mevcut dosyalar şunlardır:

```text
src/backend/backend_step6.fbs
src/backend/common/backend_context.fbs
src/backend/common/backend_result.fbs
src/codegen/js/*
src/codegen/wasm/*
src/main.bas
src/main_program_entry.fbs veya src/main_program_entry_part2.fbs
```

Eğer bu dosyalar farklı klasördeyse önce `rg "UXBBackendEmitModuleStep6|UXBJsBackendEmitModule|UXBWasmBackendEmitModule|UXBBackendContext" src` ile gerçek yerleri bul.

## 3. Yeni kod nereye eklenecek?

Patch içindeki yeni dosyaları aynı repo yollarına kopyala:

```text
src/codegen/js/uxb_js_backend_contract_adim14.fbs
src/codegen/js/uxb_js_emit_buffer_adim14.fbs
src/codegen/js/uxb_js_backend_strict_adim14.fbs
src/codegen/wasm/uxb_wat_emit_buffer_adim14.fbs
src/codegen/wasm/uxb_wasm_type_bridge_adim14.fbs
src/codegen/wasm/uxb_wasm_backend_strict_adim14.fbs
src/codegen/browser/uxb_browser_artifact_adim14.fbs
src/backend/uxb_backend_web_gate_adim14.fbs
src/backend/uxb_backend_web_report_adim14.fbs
compiler/scripts/run_adim14_backend_web_gate.ps1
tests/adim14/positive/*.bas
tests/adim14/negative/*.bas
```

## 4. Mevcut dosyalara merge edilecek küçük eklemeler

### 4.1 `src/main.bas`

`backend/codegen include` bölümünde, mevcut backend include satırlarının ALTINA ekle. Dosyayı komple değiştirme.

```freebasic
#include once "backend/uxb_backend_web_gate_adim14.fbs"
#include once "backend/uxb_backend_web_report_adim14.fbs"
#include once "codegen/js/uxb_js_backend_contract_adim14.fbs"
#include once "codegen/js/uxb_js_emit_buffer_adim14.fbs"
#include once "codegen/js/uxb_js_backend_strict_adim14.fbs"
#include once "codegen/wasm/uxb_wat_emit_buffer_adim14.fbs"
#include once "codegen/wasm/uxb_wasm_type_bridge_adim14.fbs"
#include once "codegen/wasm/uxb_wasm_backend_strict_adim14.fbs"
#include once "codegen/browser/uxb_browser_artifact_adim14.fbs"
```

### 4.2 `src/backend/backend_step6.fbs`

`UXBBackendEmitModuleStep6` içinde target dispatch bölümüne doğrudan ezme yapmadan şu mantığı ekle:

```freebasic
Case UXB_TARGET_JS
    Return UXBAdim14JsBackendEmitStrict(moduleValue, ctx, result)

Case UXB_TARGET_WASM
    Return UXBAdim14WasmBackendEmitStrict(moduleValue, ctx, result)

Case UXB_TARGET_BROWSER
    Return UXBAdim14BrowserBackendEmit(moduleValue, ctx, result)
```

Eğer `UXB_TARGET_BROWSER` sabiti yoksa `backend_target.fbs` içine şu sabiti ekle:

```freebasic
Const UXB_TARGET_BROWSER As String = "browser"
```

Ama mevcut sabit varsa tekrar ekleme.

### 4.3 `src/backend/common/backend_context.fbs`

Eğer aşağıdaki alanlar yoksa `UXBBackendContext` içine ekle. Varsa tekrar ekleme:

```freebasic
jsOutPath As String
jsRuntimeOutPath As String
watOutPath As String
wasmOutPath As String
wasmToolPath As String
htmlOutPath As String
cssOutPath As String
browserOutDir As String
backendReportOutPath As String
```

Bu alanlar başka isimle zaten varsa, yeni alan açma; context builder içinde mevcut isimleri kullan.

### 4.4 `src/backend/backend_context_builder.fbs`

CLI'dan context dolduran yerde şu pathleri doldur:

```text
--emit-js       -> ctx.jsOutPath
--emit-wat      -> ctx.watOutPath
--emit-wasm     -> ctx.wasmOutPath + ctx.wasmToolPath
--target-browser -> ctx.htmlOutPath + ctx.jsOutPath + ctx.watOutPath/wasmOutPath
```

## 5. Bu adım ne yapacak?

```text
JS target:
  verified MIR alır.
  JS dosyası üretir.
  Unsupported MIR opcode varsa FAIL eder.

WAT target:
  verified MIR alır.
  WAT dosyası üretir.
  wat2wasm yoksa WAT üretimi PASS olabilir.

WASM target:
  WAT üretir.
  wat2wasm ile .wasm üretmeye çalışır.
  wat2wasm yoksa FAIL eder.

BROWSER target:
  HTML shell + JS runtime + manifest üretir.
  Eğer WASM isteniyorsa WAT/WASM artifact yolunu manifest'e yazar.
```

## 6. Derleme ve test emri

Derleme adımı yapılacak ama tamirat yapılmayacak. Script hata görürse sadece rapor yazacak.

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
.\compiler\scripts\run_adim14_backend_web_gate.ps1 -NoRepair
```

## 7. PASS koşulları

```text
reports/control/current/adim14_compile.json var.
reports/control/current/adim14_backend_web_gate.json var.
reports/control/current/adim14_expected_actual.csv var.
Derleme PASS ise emit-js ve emit-wat smoke çalışmış olmalı.
Derleme FAIL ise gate FAIL olmalı; başarı yazılmamalı.
--emit-wasm, wat2wasm yoksa FAIL yazmalı ama bu beklenen negatif testtir.
```

## 8. Olası hatalar ve çözüm yönü

Bu script otomatik çözüm yapmayacak. Hata olursa şu sınıfa göre raporla:

```text
INCLUDE_ORDER_ERROR        -> main.bas include sırası yanlış.
MISSING_CONTEXT_FIELD      -> backend_context içinde path alanı yok.
MISSING_TARGET_CONST       -> UXB_TARGET_BROWSER yok.
MISSING_EXISTING_EMITTER   -> eski UXBJsBackendEmitModule / UXBWasmBackendEmitModule yok.
WABT_MISSING_EXPECTED      -> emit-wasm için wat2wasm yok; negatif test PASS sayılır ama full wasm PASS değildir.
COMPILE_FAIL               -> FreeBASIC build kırıldı, tamir etme.
```

## 9. Copilot kısa emir

```text
14_ADIM9_BACKEND_JS_WASM_BROWSER yamasını uygula.
Yeni Python aracı yazma.
Ana dosyaları ezme; sadece belirtilen include ve dispatch eklemelerini yap.
Derleme adımını çalıştır ama derleme hatası için tamir yapma.
Hataları reports/control/current/adim14_error_classification.csv içine yaz.
reports/control/current/adim14_backend_web_gate.json PASS olmadan başarı deme.
```
