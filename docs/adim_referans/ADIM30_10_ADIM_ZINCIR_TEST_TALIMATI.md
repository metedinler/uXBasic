# ADIM30 — 10 Adımlı uXBasic Yaşam Zinciri Test Paketi

Bu paket yeni compiler özelliği eklemez. Amaç, bir uXBasic yüzey öğesinin gerçekten yaşayıp yaşamadığını 10 halkalı zincirde kanıtlamaktır.

## Ölçü zinciri

1. Lexer tanıyor mu?
2. Parser AST node üretiyor mu?
3. AST contract kabul ediyor mu?
4. Semantic/type/layout çözüyor mu?
5. MIR'e iniyor mu?
6. MIR verifier geçiyor mu?
7. Interpreter çalıştırıyor mu? AST ve MIR backend ayrı kontrol edilir.
8. x64 NASM/ASM üretiyor mu?
9. JS/WAT/WASM/BROWSER üretiyor mu?
10. Expected/actual karşılaştırması geçiyor mu?

## Kurallar

- Placeholder artifact üretme.
- Test runner eksik çıktıyı uydurmayacak.
- Compiler gerçek çıktı üretmezse test FAIL kalacak.
- Source dosyası tamiri yapılmayacak.
- Her test çıktısı `reports/control/current/adim30_10step_chain/` altına yazılacak.
- GUI desteği Windows DLL/API üzerinden test edilir; bu test native-only kabul edilir ve JS/WASM hedefinde NATIVE_ONLY diagnostic beklenir.
- uXBasic bilimsel kütüphaneleri DLL tabanlı test edilir; `uxmath.dll`, `uxstats.dll`, `uxmatrix.dll`, `uxtensor.dll`, `uxnn.dll`, `uxonnx.dll`, `uxllama.dll`, `uxdataframe.dll` için source/parse/native route doğrulanır. DLL yoksa bu durum ayrı raporlanır; sahte DLL üretilmez.

## Dosyalar

```text
tools/control/uxb_10step_chain_runner.py
compiler/scripts/run_adim30_10step_chain_suite.ps1
tests/adim30_10step/positive/*.bas|*.uxb
tests/adim30_10step/negative/*.bas|*.uxb
tests/adim30_10step/expected/adim30_chain_test_plan.csv
```

## Uygulama

1. Patch içindeki dosyaları aynı repo yollarına kopyala.
2. Compiler kaynak koduna dokunma.
3. Önce derleme için mevcut scripti çalıştır.
4. Sonra ADIM30 runner'ı çalıştır.

```powershell
Set-Location "C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\uxb"
powershell -NoProfile -ExecutionPolicy Bypass -File compiler\scripts\run_adim30_10step_chain_suite.ps1 -NoRepair
```

## Başarı ölçütü

`reports/control/current/adim30_10step_gate.json` içinde:

```json
{
  "status": "PASS",
  "fail_count": 0,
  "placeholder_count": 0
}
```

olmadan bu adım bitmiş sayılmaz.
