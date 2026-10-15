# Copilot Adım 6 Görevi — Test Matrix Binding + Broken Layer Reporting

Copilot, bu görevde yeni compiler özelliği yazmayacaksın. Test ve coverage sistemini tamamlayacaksın.

## Önce çalıştır

```bat
uxb\compiler\scripts\run_step6_release_gate.bat
```

Sonra şunları oku:

```text
uxb\dist\step6\copilot_step6_missing_work.md
uxb\dist\step6\test_matrix_link.csv
uxb\dist\step6\expected_runner.md
uxb\dist\step6\release_gate.md
```

## Senin görevin

1. Tüm testleri matrix statüleriyle bağla.
2. Kırılan katmanı açık raporla.
3. Test manifestini elle uydurma değil, dosya adı + içerik + matrix raporundan üret.
4. `uxb/tests/manifest.csv` varsa onunla birleştir.
5. `uxb/dist/surface/language_surface_full_matrix.json` varsa onu esas al.
6. Eski `uxb/dist/language_surface_matrix.json` varsa fallback olarak kullan.
7. Duplicate testleri ayrı ayrı koşmak yerine kanonik test seç; duplicate olanı `duplicate_of` olarak işaretle.
8. Test çıktıları `uxb/_work/test_runs` veya `uxb/_work/projects` altına gidecek.
9. `uxb/src` içine çıktı yazılmayacak.
10. Her test için `broken_layer` üretilecek.

## Beklenen manifest formatı

Şu dosyayı üret/güncelle:

```text
uxb/tests/expected/uxb_expected_tests.csv
```

Kolonlar:

```text
test_id
test_path
feature_family
surface_items
required_layers
expected_status
strictness
duplicate_of
notes
```

## Expected status kuralları

```text
PASS_ALL
    AST, MIR, x64 AST, MIR x64 aynı sonucu verir.

PASS_INTERPRETERS_ONLY
    AST ve MIR interpreter geçer; native toolchain veya backend eksik olabilir.

EXPECTED_DIAGNOSTIC
    Özellik bilinçli diagnostic verir.

TOOLCHAIN_OR_FILE_MISSING
    fbc/nasm/gcc/dll yoktur.

NATIVE_MISMATCH
    Native çıktı interpreter çıktısından farklıdır.

MIR_MISMATCH
    AST interpreter ve MIR interpreter farklıdır.

BUILD_OR_RUNTIME_FAIL
    Derleme veya çalışma kırılmıştır.

FAIL
    Açıklanamayan hata.
```

## Broken layer karar kuralları

1. Kaynak okunamadıysa: `SOURCE_LOAD`
2. Lexer/token hatasıysa: `LEXER`
3. Parser hatasıysa: `PARSER`
4. AST contract hatasıysa: `AST_CONTRACT`
5. Semantic/type/layout hatasıysa: `SEMANTIC`
6. MIR yoksa veya lowering yoksa: `MIR_BUILD`
7. MIR verify kırıldıysa: `MIR_VERIFY`
8. AST interpreter kırıldıysa: `AST_INTERPRETER`
9. MIR interpreter kırıldıysa: `MIR_INTERPRETER`
10. x64 AST ASM emit kırıldıysa: `X64_AST_CODEGEN`
11. MIR x64 emit kırıldıysa: `MIR_X64_CODEGEN`
12. NASM/linker kırıldıysa: `X64_BUILD`
13. F80/F128/BIGF/BIGD/BALL runtime yoksa: `EXTFP_RUNTIME`
14. CALL DLL/API/IMPORT/INLINE kırıldıysa: `FFI_BACKEND`
15. TYPE/CLASS/METHOD kırıldıysa: `TYPE_CLASS_BACKEND`

## Önceki adım açıklarını kapatma

`prior_step_gap_audit.md` şunu söylüyorsa:

- Step3 file runtime/string runtime eksikse: ilgili testleri `EXPECTED_DIAGNOSTIC` veya `PASS_INTERPRETERS_ONLY` olarak işaretle, sahte PASS yazma.
- Step5 audit yoksa: Step5 testlerini manifestte strict hale getir ama runtime/DLL yoksa `TOOLCHAIN_OR_FILE_MISSING` kabul et.
- `build_compiler_64.bat` kırılıyorsa önce derleme hatasını ayrı `BUILD_OR_RUNTIME_FAIL` olarak raporla.

## Kabul şartları

1. `run_step6_release_gate.bat` çalışır.
2. `release_gate.md` hangi gate'in kırıldığını gösterir.
3. `expected_runner.md` her test için beklenen/gerçek durumu gösterir.
4. `broken_layer` boş kalmaz.
5. Testler matrix itemleriyle bağlanır.
6. Duplicate testler açıkça işaretlenir.
7. Sahte PASS yoktur.
