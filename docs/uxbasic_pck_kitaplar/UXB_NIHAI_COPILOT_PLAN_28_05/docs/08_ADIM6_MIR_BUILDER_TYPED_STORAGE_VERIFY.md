# 08 — ADIM6: MIR Modeli, Builder, Typed Storage ve Mandatory Gate

## Amaç

MIR instruction üretimi güvenli hale getirilecek. MIR local/param storage tip bilgisi taşıyacak. MIR verifier opt-in olmaktan çıkıp zorunlu gate olacak.

## Çözülecek sorunlar

```text
MIRAppendInstruction 16 konumsal operand alıyor.
Operand sırası hataları derleniyor ama yanlış çalışıyor.
MIRFunction.localVars sadece string.
x64 codegen I64/8 byte varsayımına düşüyor.
MIR verifier --mir-verify ile opt-in çalışıyor.
```

## Yeni modüller

```text
src/semantic/mir_operand_role.fbs
src/semantic/mir_opcode_signature.fbs
src/semantic/mir_instruction_builder.fbs
src/semantic/mir_emit_api.fbs
src/semantic/mir_builder_gate.fbs
src/semantic/mir_hir_operand_bridge.fbs

src/semantic/mir_var_info.fbs
src/semantic/mir_type_layout_bridge.fbs
src/semantic/mir_function_storage.fbs
src/semantic/mir_symbol_storage_bridge.fbs
src/semantic/mir_storage_gate.fbs

src/semantic/mir_verification_gate.fbs
src/semantic/mir_verification_gate_json.fbs
```

## İş planı

```text
1. MIRIRInstruction storage hemen yıkılmayacak; operands(0 To 15) kalacak.
2. MIRInstrBuilder üst üretim kapısı olacak.
3. MIROpcodeSignature opcode başına operand sayısı/rolü belirleyecek.
4. MIREmitLoadConst/LoadVar/StoreVar/Binary/Jump/CallRuntime gibi API'ler eklenecek.
5. Eski MIRAppendInstruction deprecated/raw kabul edilecek.
6. MIRFunction localVars/paramVars string listesi kalacak.
7. localInfo/paramInfo/globalInfo typed listeleri eklenecek.
8. MIRStorageGate typed info eksiklerini yakalayacak.
9. UXBMIRMandatoryGate şu sırayla çalışacak:
   - MIRBuilderGate
   - MIRStorageGate
   - UXBMIRVerifyModule
   - symbol/HIR/MIR consistency
10. --mir-verify sadece rapor isteme anlamına gelecek; verifier kapatılamaz.
```

## Pozitif testler

```basic
DIM a AS I32
DIM b AS I32
DIM c AS I32
c = a + b
```

Beklenen:

```text
ADD operandCount=2
c localInfo type I32
MIR gate OK
```

## Negatif testler

```text
ADD t, a
localVars=A ama localInfo yok
JMP olmayan label
CALL_DLL eksik ABI/signature
```

Beklenen: Gate FAIL; backend çalışmaz.

## Çıktı

```text
reports/control/current/mir_builder_gate.json
reports/control/current/mir_storage_gate.json
reports/control/current/mir_verify_gate.json
reports/control/current/mir_expected_actual.csv
```
