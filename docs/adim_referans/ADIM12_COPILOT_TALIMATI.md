# ADIM 12 / ADIM 7 — Interpreter Runtime FreeBASIC Patch Talimatı

## Mutlak kurallar

- Yeni Python aracı yazma.
- Mevcut `tools/audit`, `tools/control`, `compiler/scripts` araçlarını yeniden yazma.
- Kaynak dosya silme.
- `reports/control/current` içeriğini silmeden history altına taşı.
- Bu adım lexer/parser/backend adımı değildir; sadece interpreter/runtime adımıdır.

## 1. Patch dosyalarını kopyala

`patch_files` altındaki dosyaları aynı repo yollarına kopyala:

```text
patch_files/src/runtime/services/runtime_service_signature.fbs
patch_files/src/runtime/services/runtime_service_catalog.fbs
patch_files/src/runtime/services/runtime_service_gate.fbs
patch_files/src/runtime/runtime_route_matrix_writer.fbs
patch_files/src/runtime/runtime_dispatch_strict.fbs
patch_files/src/runtime/runtime_interpreter_report.fbs
patch_files/src/semantic/mir_runtime_bridge.fbs
patch_files/compiler/scripts/run_adim12_runtime_gate.ps1
patch_files/tests/adim12/**
```

## 2. Include ekle

`src/main.bas` içinde runtime include bölgesinde `runtime/runtime_service_dispatch.fbs` veya runtime include’larının yakınına şu satırları ekle:

```freebasic
#include once "runtime/services/runtime_service_signature.fbs"
#include once "runtime/services/runtime_service_catalog.fbs"
#include once "runtime/services/runtime_service_gate.fbs"
#include once "runtime/runtime_dispatch_strict.fbs"
#include once "runtime/runtime_route_matrix_writer.fbs"
#include once "runtime/runtime_interpreter_report.fbs"
#include once "semantic/mir_runtime_bridge.fbs"
```

Eğer `src/main.bas` içinde runtime service dispatch include yoksa bu satırları `runtime/runtime_context.fbs` ve `runtime/runtime_service_dispatch.fbs` include’larından sonra ekle.

## 3. Runtime dispatcher davranışı

Mevcut `UXBRuntimeDispatch` silinmeyecek. Yeni `UXBRuntimeDispatchStrict` şu kuralı uygular:

```text
service yoksa: RUNTIME_SERVICE_MISSING
handler yoksa: RUNTIME_HANDLER_NOT_AVAILABLE
handler error dönerse: error backend/interpreter'a taşınır
```

## 4. MIR evaluator bağlantısı

MIR runtime call yürütülen noktada `UXBMIRRuntimeDispatchInstruction` kullanılabilir. Eğer mevcut evaluator içinde runtime call zaten `UXBRuntimeDispatch` ile çözülüyorsa, o çağrıyı `UXBRuntimeDispatchStrict` ile değiştir.

Değişim kuralı:

```text
Eski:
UXBRuntimeDispatch(ctx.runtime, sid, args)

Yeni:
Dim dispatchResult As UXBRuntimeStrictDispatchResult
If UXBRuntimeDispatchStrict(ctx.runtime, sid, args, dispatchResult) = 0 Then
    hata/diagnostic dön
End If
r = dispatchResult.value
```

## 5. Çalıştırma

Terminal:

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
PowerShell -ExecutionPolicy Bypass -File compiler/scripts/run_adim12_runtime_gate.ps1 -RepoRoot .
```

## 6. Beklenen çıktılar

```text
reports/control/current/adim7_runtime_route_matrix.csv
reports/control/current/adim7_interpreter_report.json
reports/control/current/adim7_runtime_services.csv
reports/control/current/adim7_positive_tests.csv
reports/control/current/adim7_negative_tests.csv
reports/control/current/adim7_gate.json
reports/control/current/adim7_gate.md
```

`adim7_gate.json` içinde beklenen:

```json
{
  "status": "PASS"
}
```

## 7. Olası hatalar ve çözümler

### Hata: Duplicate definition `UXBRuntimeJsonEscape`

Çözüm: Yeni dosyalarda kullanılan helper adları `UXBRuntimeReportJsonEscape`, `UXBRuntimeCsvEscape` gibi farklıdır. Eğer çakışma olursa yeni helper adını özgün yap.

### Hata: `UXB_RT_ERR_HANDLER_NOT_AVAILABLE` tanımsız

Çözüm: `src/runtime/runtime_error_codes.fbs` içinde mevcut hata kodlarını kontrol et. Yoksa aynı dosyada şu sabiti ekle:

```freebasic
Const UXB_RT_ERR_HANDLER_NOT_AVAILABLE As Integer = 1002
```

Aynı şekilde `UXB_RT_ERR_SERVICE_NOT_FOUND` yoksa mevcut adla eşleştir veya sabit ekle.

### Hata: `UXBInterpValueFromLiteral` bulunamadı

Çözüm: `runtime_value.fbs` zaten `../interpreter/common/interp_value.fbs` include ediyor. Eğer include sırası sorun çıkarırsa `mir_runtime_bridge.fbs` içinde ayrıca şu include ekle:

```freebasic
#include once "../interpreter/common/interp_value.fbs"
```

### Hata: `MkDir reportDir` parent klasör yok diye başarısız

Çözüm: Script zaten `reports/control/current` oluşturuyor. FreeBASIC fonksiyonu script dışında çağrılırsa önce klasör oluştur.

### Hata: Build geçiyor ama gate FAIL

Çözüm: `reports/control/current/adim7_gate.md` ve `adim7_runtime_services.csv` oku. Eksik RT_* sabiti, matrix kaydı veya dispatch referansı varsa ilgili runtime family dispatch dosyasında handler ekle.

## 8. Başarı demeden önce

Şunları terminalde göster:

```powershell
Get-Content reports/control/current/adim7_gate.json
Get-Content reports/control/current/adim7_gate.md
Import-Csv reports/control/current/adim7_runtime_services.csv | Group-Object known_in_matrix,referenced_by_dispatch_or_runtime | Format-Table -AutoSize
```
