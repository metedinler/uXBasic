# 09 — ADIM7: AST Interpreter, MIR Interpreter, Runtime ve Parity

## Amaç

AST interpreter ve MIR interpreter ayrı modüler katmanlar olarak korunacak. Biri diğerinin yerine geçmeyecek. İkisi de CLI ile açılıp kapanabilir olacak ve aynı programda aynı beklenen sonucu vermelidir.

## Temel karar

```text
AST interpreter = source/AST davranışını hızlı kontrol eder.
MIR interpreter = MIR lowering ve opcode davranışını kontrol eder.
İkisi de gereklidir.
```

## Çözülecek sorunlar

```text
Interpreter yolları gate'e tam bağlı değil.
AST ve MIR interpreter sonuçları beklenen/gerçekleşen karşılaştırmasına düzenli girmiyor.
Runtime service route'ları surface lifecycle ile yeterince bağlı değil.
```

## Yeni/değiştirilecek modüller

```text
src/interpreter/common/interpreter_result.fbs
src/interpreter/common/interpreter_parity_gate.fbs
src/interpreter/ast/ast_interpreter_entry.fbs
src/interpreter/mir/mir_interpreter_entry.fbs
src/runtime/services/runtime_service_gate.fbs
tools/control/uxb_interpreter_parity_runner.py
```

## İş planı

```text
1. AST interpreter route'u açıkça cli.runAst ile kontrol edilecek.
2. MIR interpreter route'u cli.runMir ile kontrol edilecek.
3. Minimal mode --run-ast, --run-mir, --run-both destekleyecek.
4. MIR interpreter başlamadan önce MIR mandatory gate geçecek.
5. AST interpreter başlamadan önce AST contract ve semantic gate geçecek.
6. run-both durumunda expected_actual_interpreter.csv üretilecek.
7. Runtime service çağrıları surface_lifecycle_matrix içinde RUNTIME_SERVICE route'una bağlanacak.
```

## Pozitif testler

```basic
PRINT 2 + 3
DIM s AS STRING
s = "mete"
PRINT s
```

Beklenen: AST ve MIR interpreter aynı çıktı.

## Negatif testler

```text
AST interpreter OK, MIR interpreter farklı çıktı verirse PARITY_FAIL.
MIR gate FAIL iken MIR interpreter başlamaz.
Runtime service handler yoksa RUNTIME_SERVICE_EKSIK.
```

## Çıktı

```text
reports/control/current/interpreter_parity.csv
reports/control/current/runtime_service_gate.json
reports/control/current/interpreter_gate.md
```
