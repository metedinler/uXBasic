# 13 — ADIM 8: Backend x64 / x86 FreeBASIC Patch Talimatı

Bu belge `UXB_KATMAN_BAZLI_COPILOT_BELGE_SETI/13_ADIM8_BACKEND_X64_X86.md` plan adını korur. Dosya adlarını değiştirme. Yeni Python aracı yazma. Mevcut kodu komple ezme. Bu patch **kontrollü merge** patchidir.

## Kısa amaç

Native backend zincirini şu hale getir:

```text
verified MIR
→ backend context
→ x64/x86 target gate
→ backend_step6 dispatch
→ x64 veya x86 ASM artifact
→ adim8 raporları
```

## “typed” ne demek?

Eski MIR kodunda local değişkenler çoğu yerde sadece isimdi:

```freebasic
localVars(Any) As String  ' A, B, X
```

Bu backend için yetersizdir. Backend şunu da bilmelidir:

```text
A hangi tip? I32 mi, I64 mü, F64 mü, STRING mi, PTR mi?
Kaç byte slot gerekir?
Win64 ABI’de integer register mı, XMM register mı kullanılır?
```

Bu nedenle önceki Adım 11 patchinde eklenen `localInfo/paramInfo/globalInfo` typed bilgidir:

```text
name=A, typeName=I32, sizeBytes=4, abiClass=INT
name=X, typeName=F64, sizeBytes=8, abiClass=FLOAT
name=S, typeName=STRING, sizeBytes=8, abiClass=STRING/PTR
```

Adım 13 bu typed bilgiyi **x64 stack slot ve Win64 ABI kararlarında kullanır**. Eski `localVars/paramVars` silinmez; typed info varsa typed yol kullanılır, yoksa eski I64 fallback geçici olarak kalır.

## Uygulama kuralları

1. Yeni Python aracı yazma.
2. Ana dosyaları komple ezme.
3. Değiştirilecek mevcut dosyaların yedeğini `_retired/backups/adim13_<timestamp>/` altına al.
4. `patch_files/src/...` altındaki yeni `.fbs` dosyalarını aynı repo yollarına kopyala.
5. `patch_files/snippets/...` içindeki değişiklikleri ilgili mevcut dosyalara merge et.
6. Derleme geçmeden ve `reports/control/current/adim8_gate.json` PASS olmadan başarı deme.

## Eski kod nerede, yeni kod nereye?

Ayrıntılı harita: `docs/ADIM13_ESKI_YENI_DOSYA_HARITASI.md`.

Özet:

| Eski yer | Sorun | Yeni/ek yer |
|---|---|---|
| `src/backend/common/backend_target.fbs` | x86 target yok | aynı dosyaya `UXB_TARGET_X86` ekle |
| `src/backend/backend_step6.fbs` | x86 dispatch yok | `UXBX86EmitModuleStep6` case ekle |
| `src/codegen/x64/mir_x64_codegen.fbs` | local slotlar I64 fallback | `mir_x64_typed_locals.fbs` include + typed slot çağrısı |
| `src/codegen/x64/mir_x64_context.fbs` | slot modeli zaten typeName taşıyor | değiştirme; typed helper bunu dolduracak |
| `src/codegen/x86/code_generator.fbs` | AST tabanlı eski rewrite | yeni MIR tabanlı `x86_backend_step6.fbs` ekle |
| `src/main_program_entry*.fbs` | direct x64 çağrılar | yeni `UXBBackendRunPipeline` çağrısı ekle |

## Kopyalanacak yeni dosyalar

```text
src/backend/backend_cli_args.fbs
src/backend/backend_context_builder.fbs
src/backend/backend_pipeline_gate.fbs
src/backend/backend_pipeline.fbs
src/backend/backend_native_report_writer.fbs
src/backend/backend_x64_build_bridge.fbs

src/codegen/x64/mir_x64_typed_locals.fbs
src/codegen/x64/mir_x64_abi_gate.fbs
src/codegen/x64/mir_x64_emit_registry_adim13.fbs

src/codegen/x86/x86_emit_registry.fbs
src/codegen/x86/mir_x86_rewrite_from_x64.fbs
src/codegen/x86/x86_backend_step6.fbs
```

## Mevcut dosyalarda merge yapılacak yerler

### 1. `src/backend/common/backend_target.fbs`

`patch_files/snippets/src/backend/common/backend_target_ADIM13_MERGE_SNIPPET.txt` içindeki 4 değişikliği uygula.

### 2. `src/backend/backend_step6.fbs`

`patch_files/snippets/src/backend/backend_step6_ADIM13_MERGE_SNIPPET.txt` içindeki include ve Select Case değişikliğini uygula.

### 3. `src/codegen/x64/mir_x64_codegen.fbs`

`patch_files/snippets/src/codegen/x64/mir_x64_codegen_ADIM13_MERGE_SNIPPET.txt` içindeki include ve typed slot çağrılarını uygula.

### 4. `src/main_program_entry.fbs` veya `src/main_program_entry_part2.fbs`

`patch_files/snippets/src/main/main_program_entry_ADIM13_MERGE_SNIPPET.txt` içindeki pipeline çağrısını, MIR module hazırlandıktan ve mandatory gate geçtikten sonra ekle.

## Include sırası

`src/main.bas` veya ilgili include bundle içinde backend include bölgesine şunları ekle:

```freebasic
#include once "backend/backend_cli_args.fbs"
#include once "backend/backend_context_builder.fbs"
#include once "backend/backend_pipeline_gate.fbs"
#include once "backend/backend_native_report_writer.fbs"
#include once "backend/backend_pipeline.fbs"
```

x64 include bölgesinde:

```freebasic
#include once "codegen/x64/mir_x64_typed_locals.fbs"
#include once "codegen/x64/mir_x64_abi_gate.fbs"
#include once "codegen/x64/mir_x64_emit_registry_adim13.fbs"
```

x86 include bölgesinde:

```freebasic
#include once "codegen/x86/x86_emit_registry.fbs"
#include once "codegen/x86/mir_x86_rewrite_from_x64.fbs"
#include once "codegen/x86/x86_backend_step6.fbs"
```

## Terminal komutları

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"

# current arşivle
$step = "13_adim8_backend_x64_x86"
$stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$historyRoot = "reports/control/history"
$current = "reports/control/current"
$historyTarget = Join-Path $historyRoot "${step}_${stamp}"
New-Item -ItemType Directory -Force $historyRoot | Out-Null
if (Test-Path $current) {
  if (Get-ChildItem $current -Force -ErrorAction SilentlyContinue) {
    New-Item -ItemType Directory -Force $historyTarget | Out-Null
    Move-Item "$current\*" $historyTarget -Force
  }
}
New-Item -ItemType Directory -Force $current | Out-Null
Write-Output "CURRENT_ARCHIVED_TO=$historyTarget"

# derle
.\compiler\scripts\build_uxb_main_64.bat
if ($LASTEXITCODE -ne 0) { throw "build failed" }

# pozitif x64
.\build\uxb_main_64.exe tests\adim13\positive\adim13_i32_backend.bas --emit-x64-nasm --codegen-source MIR
if ($LASTEXITCODE -ne 0) { throw "x64 i32 backend failed" }

# pozitif F64
.\build\uxb_main_64.exe tests\adim13\positive\adim13_f64_backend.bas --emit-x64-nasm --codegen-source MIR
if ($LASTEXITCODE -ne 0) { throw "x64 f64 backend failed" }

# x86 açık diagnostic veya emit
.\build\uxb_main_64.exe tests\adim13\positive\adim13_i32_backend.bas --emit-x86 --codegen-source MIR
Write-Output "X86_EXIT=$LASTEXITCODE"
```

## Beklenen raporlar

```text
reports/control/current/adim8_native_backend_matrix.csv
reports/control/current/adim8_x64_emit_registry.csv
reports/control/current/adim8_x86_emit_registry.csv
reports/control/current/adim8_x64_artifacts.json
reports/control/current/adim8_backend_result.json
reports/control/current/adim8_gate.json
reports/control/current/adim8_gate.md
```

## Olası hatalar ve çözüm

### Hata: `UXB_TARGET_X86` undefined

`src/backend/common/backend_target.fbs` içine x86 const ve normalize case eklenmemiştir. Snippet 1’i uygula.

### Hata: `UXBX86EmitModuleStep6` undefined

`backend_step6.fbs` içine `#include once "../codegen/x86/x86_backend_step6.fbs"` eklenmemiştir veya Select Case x86 case eksiktir.

### Hata: `localInfoCount` field not found

Adım 11 MIR typed storage patch’i uygulanmamış veya `mir_model.fbs` genişletilmemiştir. Önce 11. adımı tamamla.

### Hata: `MIRStackSlotBytes` undefined

`src/semantic/mir_type_layout_bridge.fbs` include edilmemiştir. `mir_x64_typed_locals.fbs` include yolunu kontrol et.

### Hata: `UXBMIRMandatoryGate` undefined

Adım 11 mandatory MIR gate uygulanmamıştır veya `src/semantic/mir_verification_gate.fbs` include edilmemiştir.

### Hata: x86 emit fail `X86_UNSUPPORTED`

Bu beklenen olabilir. x86 planında unsupported opcode açık diagnostic vermeli; fake IMPLEMENTED yazılmayacak. Eğer test yalnız I32 aritmetikse registry kararlarını kontrol et.

## Bitme şartı

Adım 13 PASS sayılması için:

```text
1. FreeBASIC derleme geçecek.
2. x64 I32 test ASM üretecek.
3. x64 F64 test ASM üretecek veya F64 için açık diagnostic değil gerçek XMM route gösterecek.
4. x86 hedefi ya ASM üretecek ya da X86_UNSUPPORTED diagnostic ile fail-closed olacak.
5. adim8_* raporları current altında üretilecek.
6. adim8_gate.json PASS olmadan başarı yazılmayacak.
```
