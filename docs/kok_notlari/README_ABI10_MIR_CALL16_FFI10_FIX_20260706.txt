UXB_ABI10_MIR_CALL16_FFI10_FIX_20260706

Amaç:
- ABI10 smoke testinde AST aşaması geçtikten sonra MIR verifier/gate hatası oluşuyor:
  invalid operand count for CALL got=16 expected=1..15
- Sebep: CALL(DLL, ..., CDECL, "I32,...", 10 arg) MIR'de 16 operand kullanıyor.
  MIRIRInstruction.operands(0 To 15) zaten 16 slot destekliyor; opcode signature 15'te kalmış.

Değişen dosyalar:
- src/semantic/mir_opcode_signature.fbs
  CALL/CALL_RUNTIME, CALL_DLL/CALL_API ve variadic fallback maxOps 16 yapıldı.

- src/semantic/mir_model.fbs
  MIR interpreter için 9 ve 10 argümanlı Win64 integer/pointer CDECL function pointer tipleri eklendi.

- src/semantic/mir_evaluator.fbs
  ABI10 runtime arg slotları 0..9 yapıldı.
  MIR CALL(DLL) argüman sınırı 8'den 10'a çıkarıldı.
  Tek elemanlı FFI tip listesi ("PTR" gibi) tanındı.
  STRPTR dönüşleri STRING'e çevrildi.
  PTR/U64 dönüşlerde 32-bit clamp kaldırıldı.
  F64 dönüşler FLOAT olarak saklandı.
  ABI10_Mix8 için F64,U,F64,U,F64,U,F64,U -> F64 özel Win64 dispatch eklendi.
  VOID 0/1 arg çağrıları fake integer-return call yerine SUB olarak yürütüldü.

Uygulama:
Expand-Archive -LiteralPath .\UXB_ABI10_MIR_CALL16_FFI10_FIX_20260706_DIRECT_ROOT.zip -DestinationPath . -Force

Doğrulama marker:
Select-String -Path .\src\semantic\mir_opcode_signature.fbs,.\src\semantic\mir_model.fbs,.\src\semantic\mir_evaluator.fbs -Pattern "ABI10_MIR_CALL16_FFI10_FIX"
