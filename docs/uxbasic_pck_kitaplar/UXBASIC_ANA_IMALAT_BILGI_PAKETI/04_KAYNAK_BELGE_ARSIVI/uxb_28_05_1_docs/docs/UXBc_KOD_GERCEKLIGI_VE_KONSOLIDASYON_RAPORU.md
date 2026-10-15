# UXBc(yeni2) Kod Gerçekliği ve Konsolidasyon Raporu

Tarih: 2026-05-25  
Kaynak zip: `UXBc(yeni2).zip`  
Konsolidasyon çıktısı: `UXBc_konsolide_tek_kaynak.zip`

## 1. Kısa hüküm

Bu klasördeki dosyalar planın büyük kısmına göre işlenmiş durumda; ancak klasör yapısı karışmış. En önemli sorun kodun yokluğu değil, **aynı kaynak dosyalarının hem kökte düz dosya olarak hem de `uxb/src` altında modüler yerde bulunması**.

Aktif ve doğru ana kaynak:

```text
UXBc/uxb/src
```

Kök dizindeki çok sayıdaki `.fbs/.bas` dosyası aktif compiler hattı için ana kaynak değildir. Bunların çoğu `uxb/src` altındaki dosyaların düzleştirilmiş/yanlış kopyalarıdır. Bazıları birebir aynı, bazıları eski kalmış, bazıları ise daha dar/eksik sürümdür.

Bu nedenle konsolide pakette şu karar uygulandı:

```text
Ana kaynak:        UXBc/uxb/src
Ana runtime:       UXBc/uxb/runtime_ext
Ana testler:       UXBc/uxb/tests
Ana araçlar:       UXBc/uxb/tools
Ana VSCode eklenti: UXBc/uxb/vscode-extension
Kök dizin:         sadece çalıştırma .bat dosyaları ve genel belgeler
```

## 2. Kaynak klasörler gerçekten plana göre işlendi mi?

Evet, ana mimari katmanlar mevcut:

| Planlanan katman | Durum | Kanıt / dosya |
|---|---|---|
| Lexer / parser | Var | `uxb/src/parser/lexer.fbs`, `uxb/src/parser/parser.fbs` |
| AST | Var | `uxb/src/parser/ast.fbs` |
| AST contract | Var | `uxb/src/parser/ast_contract.fbs` |
| Semantic / type binding | Var | `uxb/src/semantic/semantic_pass.fbs`, `type_binding.fbs` |
| Layout | Var | `uxb/src/semantic/layout/` |
| HIR | Var | `uxb/src/semantic/hir.fbs` |
| MIR model | Var | `uxb/src/semantic/mir*.fbs` |
| MIR verifier/full JSON | Var | `mir_verifier.fbs`, `mir_full_exporter_json.fbs` |
| AST interpreter | Var | `uxb/src/runtime/memory_exec.fbs`, `runtime/exec/` |
| MIR interpreter | Var | `uxb/src/semantic/mir_evaluator.fbs` |
| x64 AST codegen | Var | `uxb/src/codegen/x64/code_generator.fbs` |
| MIR x64 experimental | Var | `mir_x64_*.fbs` |
| MIR x64 completion modules | Var | `mir_x64_arrays.fbs`, `mir_x64_builtins.fbs`, `mir_x64_fp64.fbs`, `mir_x64_field_synthetic.fbs` |
| F80/F128 external FP | Var | `extfp_type_policy.fbs`, `x64_extfp_call_emit.fbs`, `runtime_ext/fp80`, `runtime_ext/fp128` |
| BIGF/BIGD/BALL runtime | Var | `runtime_ext/bigfp/uxb_bigfp_mpfr.c` |
| VSCode eklenti | Var | `uxb/vscode-extension` |

Yani planın ana teknik yönleri dosya seviyesinde uygulanmış görünüyor.

## 3. Asıl sorun: dosyalar yerinde mi?

Kısmen hayır. Orijinal zipte kök dizinde 135 adet düz dosya vardı. Bunların 118 tanesi `uxb/src` altında aynı isimle bulunan kaynak dosyalarla çakışıyordu.

Özet:

| Durum | Sayı |
|---|---:|
| Kök dizindeki düz dosya | 135 |
| `uxb/src` içinde aynı isimli karşılığı olan | 118 |
| Birebir aynı olan | 108 |
| Aynı isimli ama farklı içerikli olan | 10 |
| Kök dizinde tutulması mantıklı operasyon dosyası / belge | 17 |
| Kaynak içinde olmaması gereken build/log çıktısı | 16 |

Farklı içerikli önemli dosyalar:

```text
extfp_runtime_status.fbs
extfp_type_policy.fbs
main.bas
mir_x64_capability.fbs
mir_x64_codegen.fbs
mir_x64_context.fbs
mir_x64_emit_helpers.fbs
x64_codegen_stmt_field_addr.fbs
x64_codegen_symbol_table_helpers.fbs
x64_extfp_call_emit.fbs
```

Bu farklarda genelde `uxb/src` altındaki dosya daha güncel ve daha geniştir. Örneğin `uxb/src/main.bas`, MIR x64 completion modüllerini include ediyor:

```text
mir_x64_arrays.fbs
mir_x64_builtins.fbs
mir_x64_fp64.fbs
mir_x64_field_synthetic.fbs
mir_x64_keyword_surface.fbs
```

Kök dizindeki `main.bas` ise bunları içermeyen daha eski/dar bir kopyadır. Bu yüzden ana kaynak olarak kök dosyalar değil, `uxb/src` alınmalıdır.

## 4. Klasörlerin amacı

| Klasör | Amaç |
|---|---|
| `uxb/src` | Asıl FreeBASIC compiler kaynak kodu |
| `uxb/src/parser` | Lexer, token, AST, parser |
| `uxb/src/semantic` | Type binding, layout, HIR, MIR, semantic pass |
| `uxb/src/runtime` | AST interpreter, console capture, diagnostics, runtime exec |
| `uxb/src/codegen/x64` | x64 AST codegen, MIR x64 experimental backend, FFI, inline ASM |
| `uxb/src/codegen/x86` | x86 rewrite/deneme hattı; ana hat değil |
| `uxb/runtime_ext` | F80/F128/BIGF/BIGD/BALL harici DLL runtime kaynakları |
| `uxb/tests` | Test kaynakları |
| `uxb/tools` | Audit, baseline, coverage ve temizlik araçları |
| `uxb/compiler` | Wrapper, script, switchboard |
| `uxb/vscode-extension` | VSCode eklentisi |
| `uxb/docs` | Teknik belgeler |
| `uxb/dist` | Çalışma çıktıları; kaynak değildir |

## 5. Komut / keyword durumu

Keyword listesi sabit 192 değildir. Bu klasörde lexer’dan otomatik çıkarılan keyword sayısı:

```text
197
```

Keyword matrix raporu üretilebiliyor:

```bat
python uxb\tools\uxb_keyword_layer_matrix.py
```

Statik coverage özeti:

| Katman | Durum |
|---|---|
| lexer | 197 keyword yüzeyi var |
| parser | büyük ölçüde işlenmiş |
| semantic | orta-iyi düzeyde |
| MIR | önemli ölçüde eksik/diagnostic yüzey var |
| x64 AST codegen | kullanılabilir ama her keyword yok |
| x64 MIR codegen | experimental; genişletilmiş ama tamamı gerçek native değil |
| tests | zengin test klasörü var |

`mir_x64_keyword_surface_audit.json` içindeki MIR x64 yüzey sınıfları:

| Sınıf | Sayı |
|---|---:|
| native_builtin_or_integer_op | 39 |
| compiletime_no_emit_or_type | 56 |
| native_storage_or_compiletime | 13 |
| diagnostic_exception_pending | 5 |
| external_fp_runtime | 5 |
| native_controlflow_or_call | 24 |
| diagnostic_fileio_pending | 7 |
| native_runtime_call | 7 |
| native_memory_or_builtin | 20 |
| diagnostic_native_pending | 5 |
| diagnostic_oop_pending | 6 |
| diagnostic_concurrency_pending | 10 |

Bu iyi bir şeydir: Eksikler gizlenmiyor, sınıflandırılıyor. Ancak şu an bütün keywordlerin gerçek machine-code karşılığı var demek doğru değildir.

## 6. F80/F128/BIGF/BIGD/BALL durumu

Bu klasörde yüksek hassasiyetli FP hattı doğru mimari yönde:

| Tip | Durum |
|---|---|
| F80 | FreeBASIC Extended DLL kaynakları var |
| F128 | GCC `__float128` + `libquadmath` DLL kaynakları var |
| BIGF/BIGD/BALL | MPFR/GMP tabanlı `bigfp` runtime kaynakları var |
| Compiler policy | `extfp_type_policy.fbs` ve `extfp_runtime_status.fbs` var |
| x64 call emitter | `x64_extfp_call_emit.fbs` var |

Bu hattın gerçek çalışırlığı yerelde şu scriptlerle doğrulanmalı:

```bat
uxb\runtime_ext\build_fp_runtime_all.bat
uxb\compiler\scripts\run_full_fp_runtime_smoke.bat
uxb\compiler\scripts\run_extfp_codegen_smoke.bat
```

## 7. Mimari yakınlık değerlendirmesi

| Alan | Planlanana yakınlık |
|---|---:|
| Lexer/parser | yüksek |
| AST/AST contract | yüksek |
| Semantic/type/layout | orta-yüksek |
| HIR/MIR model | orta-yüksek |
| MIR verifier/JSON | iyi |
| AST interpreter | iyi |
| MIR interpreter | orta |
| x64 AST backend | orta-yüksek |
| MIR x64 backend | orta; experimental ve diagnostic ağırlıklı |
| F80/F128 runtime | iyi, fakat yerel build/test şart |
| BIGF/BIGD/BALL runtime | kaynak var, yerel test şart |
| FFI | orta |
| TYPE/CLASS/OOP | orta |
| VSCode eklenti | yardımcı araç düzeyi; debugger değil |
| Release temizliği | bu konsolidasyondan önce zayıftı, bu pakette toparlandı |

## 8. Konsolidasyon kararı

Konsolidasyon sırasında şu kararlar uygulandı:

1. `uxb/src` ana kaynak kabul edildi.
2. Kök dizindeki düz `.fbs/.bas` kaynak kopyaları kaldırıldı.
3. `uxb/src` içindeki `main.exe`, `main_32.exe`, `main_64.exe` ve kaynak içi log kaldırıldı.
4. `uxb/dist` ve kök `dist` çalışma çıktısı kabul edilip boşaltıldı.
5. Operasyonel kök scriptleri korundu:
   - `build_64.bat`
   - `build_compiler_64.bat`
   - `run_uxb_ast.bat`
   - `run_uxb_mir.bat`
   - `run_prompt0_baseline.bat`
   - `install_vscode_extension_local.bat`
6. `uxb/runtime_ext`, `uxb/tests`, `uxb/tools`, `uxb/vscode-extension` korundu.
7. Kaldırılan dosyalar `uxb/docs/UXBc_KONSOLIDASYON_MANIFEST.csv` içinde listelendi.

## 9. Konsolide paket yapısı

Konsolide pakette durum:

| Klasör | Dosya | Klasör | Boyut MB |
|---|---:|---:|---:|
| `uxb/src` | 121 | 16 | 1.984 |
| `uxb/runtime_ext` | 12 | 4 | 0.024 |
| `uxb/tests` | 310 | 19 | 0.629 |
| `uxb/vscode-extension` | 5 | 2 | 0.034 |
| `uxb/compiler` | 29 | 3 | 0.043 |
| `uxb/tools` | 12 | 1 | 0.079 |
| `uxb/docs` | 15 | 0 | 0.026 |

## 10. Bundan sonra nasıl kullanılmalı?

Konsolide paketi yeni bir klasöre aç:

```bat
cd /d C:\Users\mete\Downloads\UXBc
```

Önce compiler build:

```bat
build_compiler_64.bat
```

Sonra baseline:

```bat
run_prompt0_baseline.bat
```

Sonra MIR x64 ve FP smoke:

```bat
uxb\compiler\scripts\run_mir_x64_completion_smoke.bat
uxb\compiler\scripts\run_extfp_codegen_smoke.bat
uxb\compiler\scripts\run_full_fp_runtime_smoke.bat
```

Keyword matrix:

```bat
python uxb\tools\uxb_keyword_layer_matrix.py
```

## 11. Net sonuç

Bu klasördeki dosyalar planın önemli kısmına göre işlenmiştir; fakat orijinal zipte kök kaynak kopyaları ve build çıktıları yüzünden mimari bulanıktı. Ana kaynak `uxb/src` olmalıdır. Kök dizindeki düz kaynak dosyaları ana kaynak kabul edilmemelidir.

Konsolide paket bu kararı uygulayan tek kaynaklı UXBc yapısıdır.
