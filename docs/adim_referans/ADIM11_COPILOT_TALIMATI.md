# ADIM 11 / ADIM 6 — Copilot Talimatı

Bu belgeyi aynen uygula. Yorum yapmadan önce terminal komutlarını çalıştır.

## 1. Başlangıç temizliği: current → history

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
$step = "adim11_mir_lower_verify_opt"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$current = "reports/control/current"
$historyRoot = "reports/control/history"
$historyTarget = Join-Path $historyRoot "${step}_${stamp}"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
  $hasFiles = Get-ChildItem $current -Force -ErrorAction SilentlyContinue
  if ($hasFiles) {
    New-Item -ItemType Directory -Force $historyTarget | Out-Null
    Move-Item "$current\*" $historyTarget -Force
  }
}
New-Item -ItemType Directory -Force $current | Out-Null
Write-Output "CURRENT_ARCHIVED_TO=$historyTarget"
```

## 2. Dosyaları kopyala

`patch_files/src/semantic/*.fbs` dosyalarını `src/semantic/` altına kopyala. `patch_files/tests/adim11` klasörünü `tests/adim11` olarak kopyala. `patch_files/compiler/scripts/run_adim11_mir_gate.ps1` dosyasını `compiler/scripts/` altına kopyala.

## 3. `mir_model.fbs` değişikliği

`patch_snippets/mir_model_insert_fields.md` dosyasındaki snippet’i uygula. Eski `localVars(Any) As String`, `paramVars(Any) As String`, `globalVars(Any) As String` alanlarını silme. Sadece typed alanları ekle.

## 4. `mir.fbs` include değişikliği

`#include once "mir_full_exporter_json.fbs"` satırından sonra şunu ekle:

```freebasic
#include once "mir_var_info.fbs"
#include once "mir_type_layout_bridge.fbs"
#include once "mir_operand_role.fbs"
#include once "mir_opcode_signature.fbs"
#include once "mir_instruction_builder.fbs"
#include once "mir_emit_api.fbs"
#include once "mir_function_storage.fbs"
#include once "mir_symbol_storage_bridge.fbs"
#include once "mir_builder_gate.fbs"
#include once "mir_storage_gate.fbs"
#include once "mir_opt_const_fold.fbs"
#include once "mir_opt_dead_block.fbs"
#include once "mir_opt_pass.fbs"
#include once "mir_verification_gate.fbs"
#include once "mir_verification_gate_json.fbs"
```

## 5. `MIROptimizeModule` değişikliği

`src/semantic/mir_tail.fbs` veya mevcut `MIROptimizeModule` nerede ise, fonksiyonu şu gövdeye çevir:

```freebasic
Function MIROptimizeModule(ByRef module As MIRModule, ByRef errText As String) As Integer
    Return MIRRunOptimizationPasses(module, errText)
End Function
```

Eski gövdeyi silme istiyorsan önce `_retired/adim11_backups_<timestamp>` altına kopyala.

## 6. `main_program_entry.fbs` mandatory gate değişikliği

MIR build ve optimize başarılı olduktan hemen sonra, `mirModuleReady = 1` satırından önce veya hemen sonra ama MIR JSON/interpreter/backend’den önce şunu ekle:

```freebasic
Dim As UXBMIRGateResult adim6MirGate
Dim As String adim6MirGateErr
If UXBMIRMandatoryGate(mirModule, adim6MirGate, adim6MirGateErr) = 0 Then
    UxbError "MIR dogrulama basarisiz: " & LocalizeErrorMessage(adim6MirGateErr)
    End 18
End If
mirVerifiedForPolicy = 1
```

Eğer `--mir-verify-json-out` verilmişse eski `UXBMIRWriteVerifyJson` çalışabilir. Ayrıca `UXBMIRWriteGateJson` ile gate JSON yazdır.

## 7. Derleme

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
compiler\scripts\build_uxb_main_64.bat
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
```

## 8. Adım 11 gate testi

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
powershell -ExecutionPolicy Bypass -File compiler/scripts/run_adim11_mir_gate.ps1
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
```

## 9. Sonuç raporu

```powershell
Get-Content reports/control/current/adim6_gate.json -TotalCount 120
Get-Content reports/control/current/adim6_gate.md -TotalCount 120
Get-ChildItem reports/control/current | Where-Object { $_.Name -like 'adim6_*' } | Select-Object Name,Length
```

## 10. Olası hatalar

- `MIRVarInfo` tipi bulunamadı: `mir.fbs` include sırası yanlış. `mir_model.fbs` içine typed alanlar eklenmeden önce `mir_var_info.fbs` görülemiyor olabilir. Çözüm: `mir_model.fbs` başına `#include once "mir_var_info.fbs"` ekle veya typed alanları include sonrasına taşı.
- `UXBMIRStep4OpcodeKnown` yok: `mir_opcode_signature.fbs` içinde `../mir/mir_registry.fbs` erişimi sorunlu. Çözüm: mevcut `mir_verifier.fbs` nasıl include ediyorsa aynı yolu kullan.
- `localInfo` alanı yok: `mir_model.fbs` patch uygulanmamış.
- `MIROptimizeModule duplicate definition`: eski fonksiyon gövdesi silinmeden yeni fonksiyon eklenmiş. Eski gövdeyi değiştir, ikinci fonksiyon yazma.
- Negatif testler exit 0 veriyor: compiler hata üretmiyor demektir; negatif test sonuçları `adim6_negative_tests.csv` içinde FAIL olarak raporlanmalı.

Sorunu çözemiyorsan, bu kurallar içinde kendi bildiğin gibi düzelt: yeni Python aracı yazma, eski string listeleri silme, mandatory MIR gate’i kaldırma.
