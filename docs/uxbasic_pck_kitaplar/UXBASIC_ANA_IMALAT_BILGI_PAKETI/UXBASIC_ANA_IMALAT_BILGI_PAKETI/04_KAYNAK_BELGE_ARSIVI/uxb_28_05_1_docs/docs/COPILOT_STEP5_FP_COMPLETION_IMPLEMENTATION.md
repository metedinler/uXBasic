# Copilot Adım 5 Görevi — Floating Point Completion

Copilot, bu görevde F80/F128/BIGF/BIGD/BALL hattını tamamlayacaksın.

## Önce oku

```text
uxb\docs\COPILOT_WORKSPACE_CLEAN_POLICY.md
uxb\docs\STEP5_FP_COMPLETION_CONTRACT.md
uxb\dist\step5\copilot_step5_missing_work.md
```

## Çok önemli önceki kodgen farkı

Eski `mir_x64_codegen.fbs` içinde `MIRX64EmitRuntimeSupport` adlı inline printf/sprintf/scanf mini-runtime vardı.

Yeni runtime-backed tasarımda bu kodun doğrudan dosyadan çıkarılması **ancak şu şartla doğrudur**:

1. `mir_x64_runtime_call_contract.fbs` include edilmiş olacak.
2. `mir_x64_runtime_emit_helpers.fbs` include edilmiş olacak.
3. `MIRX64EmitRuntimePrintI64`, `MIRX64EmitRuntimePrintCStr`, `MIRX64EmitRuntimeInputI64` gerçek ve derlenebilir olacak.
4. Extern/runtime symbol/link işi audit raporunda görünecek.
5. Eski çalışan PRINT/INPUT smoke testi interpreter ve MIR x64 asm emit seviyesinde kırılmayacak.

Eğer bu şartlar sağlanmıyorsa eski inline runtime support tamamen silinmiş sayılmaz; ya geri alınacak ya da `legacy compatibility fallback` olarak ayrı module taşınacak.

## Kesin kurallar

1. F80/F128/BIGF/BIGD/BALL için native register/x87/SSE arithmetic yazma.
2. F80/F128/BIGF/BIGD/BALL arithmetic external runtime call'a inecek.
3. F64 normal native SSE olabilir; F80/F128/BIGF/BIGD/BALL olamaz.
4. x64 AST codegen bozulmayacak.
5. MIR interpreter ve AST interpreter doğruluk referansı olacak.
6. DLL/runtime yoksa strict modda FAIL, diagnostics modda EXPECTED_DIAGNOSTIC.
7. BIGF/BIGD/BALL handle-based işlem görecek.
8. Sahte başarı yok.
9. JSON çıktıları parse edilebilir kalacak.
10. Kaynak klasörüne build/test çıktısı yazılmayacak.

## Bu patch ile gelen yeni dosyalar

```text
uxb/src/semantic/extfp_lowering_contract.fbs
uxb/src/codegen/x64/mir_x64_extfp_emit_contract.fbs
uxb/src/codegen/x64/mir_x64_extfp_emit_helpers.fbs
uxb/tools/uxb_step5_fp_completion_audit.py
uxb/tools/uxb_codegen_regression_guard.py
```

## Include zinciri

`uxb/src/main.bas` veya uygun include bundle içinde şunları bağla:

```freebasic
#include once "semantic/extfp_lowering_contract.fbs"
#include once "codegen/x64/mir_x64_extfp_emit_contract.fbs"
#include once "codegen/x64/mir_x64_extfp_emit_helpers.fbs"
```

Bu dosyalar şunlardan sonra gelmeli:

```text
semantic/extfp_type_policy.fbs
runtime/extfp_runtime_status.fbs
codegen/x64/x64_extfp_call_emit.fbs
codegen/x64/mir_x64_context.fbs
codegen/x64/mir_x64_emit_helpers.fbs
```

## Parser / semantic / MIR lowering

Aşağıdaki syntaxlar korunacak:

```basic
DIM A AS F80
DIM B AS F128
DIM X AS BIGF(256)
DIM Y AS BIGD(80)
DIM Z AS BALL(256)
```

Lowering kararı:

```text
F80 literal assignment        -> uxb_f80_from_str
F128 literal assignment       -> uxb_f128_from_str
BIGF literal assignment       -> uxb_bigf_from_str
BIGD literal assignment       -> uxb_bigd_from_str
BALL literal assignment       -> uxb_ball_from_str

F80 A+B                       -> uxb_f80_add(&A,&B,&OUT)
F128 A+B                      -> uxb_f128_add(&A,&B,&OUT)
BIGF A+B                      -> uxb_bigf_add(handleA,handleB,outHandle)
BIGD A+B                      -> uxb_bigd_add(handleA,handleB,outHandle)
BALL A+B                      -> uxb_ball_add(handleA,handleB,outHandle)

PRINT F80/F128/BIGF/BIGD/BALL -> *_to_str + print cstr
```

## MIR opcode önerisi

Var olan MIR CALL yapısı yeterliyse yeni opcode ekleme.

Önerilen representation:

```text
EXTFP_CALL family op arg1 arg2 out
```

veya mevcut CALL ile:

```text
CALL uxb_f80_add &A &B &C
```

Hangisi kod gerçeğine uygunsa onu kullan. Uydurma alan adı oluşturma.

## MIR x64 emit

`mir_x64_codegen.fbs` içinde FP op veya EXTFP_CALL geldiğinde şu helperlar kullanılacak:

```freebasic
MIRX64EmitExtFpFromString(...)
MIRX64EmitExtFpBinary(...)
MIRX64EmitExtFpToString(...)
MIRX64EmitExtFpPrint(...)
```

Adres hesaplaması mevcut local/field/array adres helperlarından alınacak. Adres bulunamazsa:

```text
UXB_EXTFP_ADDRESS_LOWERING_MISSING
```

## Yasak ASM patternleri

F80/F128/BIGF/BIGD/BALL için üretilen MIR x64 ASM içinde şu patternler görülürse hata:

```text
fld
fstp
fadd
fsub
fmul
fdiv
addsd
subsd
mulsd
divsd
addss
subss
mulss
divss
```

F64 testinde SSE kullanılabilir; bu yasak sadece external FP tiplerine uygulanır.

## Codegen regression guard

Adım 5 öncesinde ve sonrasında çalıştır:

```bat
python uxb\tools\uxb_codegen_regression_guard.py --root . --current uxb\src\codegen\x64\mir_x64_codegen.fbs
```

Eğer eski `MIRX64EmitRuntimeSupport` silindiyse ve yeni runtime helperlar yoksa rapor FAIL olacak. Helperlar varsa PASS_WITH_NOTE.

## Testler

```bat
uxb\compiler\scripts\run_step5_fp_completion_audit.bat
uxb\compiler\scripts\run_step3_project_runner.bat uxb\tests\step5\f80_assignment_binary_print.bas
uxb\compiler\scripts\run_step3_project_runner.bat uxb\tests\step5\f128_assignment_binary_print.bas
uxb\compiler\scripts\run_step3_project_runner.bat uxb\tests\step5\bigf_bigd_ball_policy.bas
```

## Copilot uygulama sırası

1. Step5 audit çalıştır.
2. Include zincirini bağla.
3. `MIRX64EmitRuntimeSupport` silinmesinin helperlarla kapatıldığını doğrula.
4. F80/F128 literal assignment lowering'i bağla.
5. F80/F128 binary arithmetic lowering'i bağla.
6. F80/F128 PRINT lowering'i bağla.
7. BIGF/BIGD/BALL handle policy/lowering diagnostic veya runtime call bağla.
8. ASM native FP forbidden audit'i bağla.
9. Her değişiklikten sonra build + step5 audit + project runner çalıştır.

## Kabul şartları

1. F80/F128 için runtime DLL çağrısı dışında arithmetic yok.
2. BIGF/BIGD/BALL için handle runtime contract var.
3. DLL yoksa diagnostic açık.
4. Eski çalışan PRINT/INPUT smoke testi kırılmadı.
5. `mir_x64_codegen.fbs` içinde kaybedilen emitler ya helperla karşılandı ya da diagnostic'e dönüştü.
6. JSON/MD rapor üretildi.
