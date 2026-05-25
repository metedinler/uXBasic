# ADIM2 Toolchain CLI Differential Gate

Bu dokuman Adim 2.0 kapisini tanimlar. Bu adim yeni dil ozelligi yazmaz.
Oncelik: toolchain, pipeline secimi, interpreter referansli native dogrulama.

## Kapsam

1. Toolchain doctor
2. CLI pipeline gate
3. Differential runner
4. ExtFP runtime gate
5. Lock ve MIR verify tekrar kontrol raporu

## Komutlar

Repo kokunde calistirin:

```bat
uxb\compiler\scripts\run_adim2_toolchain_gate.bat
uxb\compiler\scripts\run_adim2_differential_gate.bat
```

## Uretilen ciktilar

```text
uxb\dist\adim2\toolchain_doctor.json
uxb\dist\adim2\toolchain_doctor.md
uxb\dist\adim2\extfp_runtime_gate.json
uxb\dist\adim2\extfp_runtime_gate.md
uxb\dist\adim2\cli_pipeline_gate.json
uxb\dist\adim2\cli_pipeline_gate.md
uxb\dist\adim2\cli_pipeline_gate.csv
uxb\dist\adim2\differential_gate.json
uxb\dist\adim2\differential_gate.md
uxb\dist\adim2\differential_gate.csv
uxb\dist\adim2\logs\...
```

## Durum kurallari

Toolchain gate:
- Eksik arac varsa FAIL yerine dogrudan raporlanir.
- Native adimlarda durum `TOOLCHAIN_OR_FILE_MISSING` olabilir.

Differential gate:
- `PASS_ALL`
- `PASS_INTERPRETERS_ONLY`
- `NATIVE_MISMATCH`
- `MIR_MISMATCH`
- `TOOLCHAIN_MISSING`
- `EXPECTED_DIAGNOSTIC`
- `FAIL`

## Notlar

- AST interpreter ve MIR interpreter referans kabul edilir.
- Native AST ve native MIR ciktilari referansla kiyaslanir.
- Sessiz fallback kabul edilmez; policy JSON ile gorunur olmali.
- MIR x64 build yolu kilit/timeout bilgisi audit raporunda ayrica yazilir.
