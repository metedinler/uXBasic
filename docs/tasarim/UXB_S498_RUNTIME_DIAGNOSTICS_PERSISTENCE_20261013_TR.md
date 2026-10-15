# UXB S-498: çalışma anı tanılarının yapılandırılmış kaydı

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Uygulandı ve AST/MIR kanıtıyla doğrulandı

## Sorun

AST veya canonical MIR yorumlayıcısı çalışma anında başarısız olduğunda
derleyici çıkış kodunu ve terminal metnini doğru veriyor, ancak
`all_diagnostics.json` ile `vscode_diagnostics.json` boş kalabiliyordu. Bu,
dosyayı okuyarak hata durumunu izleyen araçlarda sessiz başarı görüntüsü
oluşturuyordu.

## Düzeltme

AST ve MIR yürütme bloklarının hata dalları, mevcut `frontendDiagnostics`
listesine `UXBOutputContractPushFailureDiagnostic` ile ortak kodlu runtime
tanısı ekliyor. Son çıkıştan önce `UXBOutputContractWriteDiagnosticList`
çağrısı hem canonical diagnostics JSON'u hem VS Code biçimini güncelliyor.
Çıkış kodu ve insan okunabilir terminal iletisi korunuyor.

Kaynak: `src/main_program_entry_part2.fbs`.

Native x64, JS ve WASM programları ayrı süreçler olduğu için bu compiler-side
dosyanın kapsamı değildir; onların runtime tanıları ilgili program/host
çalışma sözleşmesine ayrı taşınmalıdır.

## Kanıt

`tests/diagnostics/run_s498_runtime_diagnostic_tests.ps1` uncaught `THROW`
fixture'ını iki yorumlayıcıda çalıştırdı:

```text
PASS AST all_diagnostics
PASS AST vscode_diagnostics
PASS MIR all_diagnostics
PASS MIR vscode_diagnostics
Toplam: 4   PASS: 4   FAIL: 0
```

Her JSON'da `count > 0`, `error_count > 0` ve en az bir diagnostic nesnesi
var; süreç başarısız çıkıyor. `build_64.ps1 -Force` exit 0 verdi.
