# UXBc Adım 7 Contract — Final Merge + VSCode Debugger Öncesi IDE

## Kapsam

Bu adımın kapsamı:

```text
final merge
release candidate üretimi
IDE command contract
VSCode build/run/test/dashboard entegrasyonu
önceki adım borçlarının gate raporuna bağlanması
```

Bu adımın kapsamı **değil**:

```text
gerçek breakpoint debugger
step into / step over motoru
canlı değişken debug protokolü
```

Gerçek debugger ayrı aşamadır.

## Ana klasör politikası

Kanonik kaynak:

```text
uxb/src
```

Üretilmiş çıktıların gideceği yerler:

```text
uxb/_work
uxb/dist
uxb/_release
uxb/_retired
```

`uxb/src` içine `.exe`, `.obj`, `.asm`, `.nasm`, `.log`, `dist`, `build`, `tmp` girmeyecek.

## Final merge ne yapar?

Final merge scripti:

1. workspace temizliğini kontrol eder.
2. Step1–Step6 raporlarını arar.
3. Step5 final close uygulanmış mı kontrol eder.
4. Step6 release gate durumunu okur.
5. kaynak ağacındaki build/test artığını raporlar.
6. canonical dosyaları release candidate altına kopyalar.
7. hash manifest üretir.
8. release notes üretir.
9. kaynak klasörünü değiştirmez.

## IDE command contract

VSCode eklentisi şu komut ailelerini desteklemelidir:

```text
Build Compiler
Clean Guard
Run AST
Run MIR
Emit x64 AST ASM
Emit MIR x64 ASM
Run Project Differential
Run Surface Matrix
Run Step5 Final Close
Run Step6 Release Gate
Create Release Candidate
Open Latest Reports
Open Dashboard
```

Debugger komutları bu adımda yalnızca `future_debugger` olarak listelenir; uygulanmaz.

## Kabul şartları

1. `run_step7_final_gate.bat` çalışır.
2. `final_gap_audit.md` açık borçları gösterir.
3. `ide_command_contract.md` üretilir.
4. `vscode_contract_audit.md` VSCode eklenti komut durumunu gösterir.
5. `create_step7_release_candidate.bat` release candidate klasörü üretir.
6. Release candidate içine build çıktısı değil, kaynak/araç/doküman/test/sözleşme girer.
7. Copilot görevi debugger yazmaya sapmaz.
