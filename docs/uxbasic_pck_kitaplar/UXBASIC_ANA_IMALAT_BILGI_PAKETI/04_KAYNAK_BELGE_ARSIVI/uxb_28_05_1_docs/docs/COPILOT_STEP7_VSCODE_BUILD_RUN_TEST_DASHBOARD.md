# Copilot Adım 7 Görevi — VSCode Build/Run/Test/Dashboard

Copilot, bu görevde gerçek debugger yazmayacaksın. Debugger bundan sonraki ayrı iştir.

## Önce çalıştır

```bat
uxb\compiler\scripts\run_step7_final_gate.bat
```

Sonra oku:

```text
uxb\dist\step7\final_gap_audit.md
uxb\dist\step7\ide_command_contract.md
uxb\dist\step7\vscode_contract_audit.md
uxb\dist\step7\copilot_step7_missing_work.md
```

## Kesin kurallar

1. Yeni compiler mimarisi icat etme.
2. `uxb/src` içine çıktı yazma.
3. VSCode eklentisi sadece komut çalıştırma, rapor açma ve dashboard gösterecek.
4. Gerçek debugger yok.
5. Breakpoint/step/variables/callstack komutları şimdilik future/disabled kalacak.
6. Komutlar `uxb/ide/uxb_ide_command_contract.json` içinden okunabilir olacak.
7. Her komut terminalde açık çalışacak; sessiz arka plan yok.
8. Hata olursa kullanıcıya hangi scriptin kırıldığını göster.
9. Çıktıları `uxb/dist` ve `uxb/_work` altında arayacak.
10. `package.json` komutları ile extension runtime komutları aynı id’leri kullanacak.

## Bu patch ile gelen yardımcı dosyalar

```text
uxb/ide/uxb_ide_command_contract.json
uxb/vscode-extension/src/uxbCommandContract.js
uxb/vscode-extension/src/uxbCommandRunner.js
uxb/vscode-extension/src/uxbDashboardProvider.js
uxb/tools/uxb_ide_command_contract.py
uxb/tools/uxb_vscode_contract_audit.py
```

## Copilot uygulama sırası

### 1. package.json komutları

`uxb/vscode-extension/package.json` içinde `contributes.commands` kısmına sözleşmedeki komutları ekle:

```text
uxbasic.buildCompiler
uxbasic.cleanGuard
uxbasic.runAst
uxbasic.runMir
uxbasic.emitX64AstAsm
uxbasic.emitMirX64Asm
uxbasic.runProjectDifferential
uxbasic.runSurfaceMatrix
uxbasic.runStep5FinalClose
uxbasic.runStep6ReleaseGate
uxbasic.createReleaseCandidate
uxbasic.openLatestReports
uxbasic.openDashboard
```

### 2. activationEvents

Aynı komutlar için activation event ekle:

```text
onCommand:uxbasic.buildCompiler
...
```

### 3. extension.js bağlantısı

Mevcut `extension.js` bozulmadan şu helperları bağla:

```javascript
const { UXB_COMMANDS } = require("./src/uxbCommandContract");
const { registerUXBCommandRunners } = require("./src/uxbCommandRunner");
const { registerUXBDashboard } = require("./src/uxbDashboardProvider");
```

`activate(context)` içinde:

```javascript
registerUXBCommandRunners(context);
registerUXBDashboard(context);
```

Eğer mevcut eklentide zaten register edilen komutlar varsa çakışmayı engelle. Aynı id iki kez register edilmesin.

### 4. Dashboard

Dashboard şu raporları göstermeli:

```text
uxb/dist/step7/step7_gate.md
uxb/dist/step7/final_gap_audit.md
uxb/dist/step6/release_gate.md
uxb/dist/step6/layer_gate.md
uxb/dist/step5/step5_fp_completion_audit.md
uxb/dist/surface/language_surface_full_matrix.md
```

Dosya yoksa dashboard “yok” diye açık yazacak.

### 5. Test

Şunları çalıştır:

```bat
uxb\compiler\scripts\run_step7_final_gate.bat
```

VSCode eklentisi için:

```powershell
cd uxb\vscode-extension
npm install
npm run compile
```

Eğer `npm run compile` yoksa:

```powershell
npm test
```

o da yoksa package.json scriptlerini raporla, sahte PASS verme.

## Kabul şartları

1. VSCode command list sözleşmeyle uyumlu.
2. Build/run/test/dashboard komutları terminalde çalışıyor.
3. Dashboard raporları açıyor/gösteriyor.
4. Gerçek debugger komutları uygulanmış gibi gösterilmiyor.
5. `vscode_contract_audit.md` PASS veya açık eksik listesi veriyor.
