# Copilot Alt Adım 2 — MIR Lowering Eksiklerini Kapat

Copilot, önce şunu çalıştır:

```bat
uxb\compiler\scripts\run_language_surface_full_matrix.bat
```

Sonra şu dosyayı oku:

```text
uxb\dist\surface\copilot_step2_targets.md
```

## Emirler
1. Yeni mimari icat etme.
2. Önce `semantic`, `mir_lower_expr.fbs`, `mir_lower_stmt*.fbs`, `mir_model.fbs` dosyalarını oku.
3. Parser/semantic'te zaten var olan ama MIR'de missing görünen öğeleri MIR'e indir.
4. Destek runtime gerektiriyorsa runtime helper yoksa diagnostic ver.
5. x64_mir tarafında eksik olan öğelerde önce capability, sonra emitter ekle.
6. Her opcode için `mir_verifier` ve `mir_full_json` bozulmayacak.
7. Eski AST x64 emitter'a fallback gizlenmeyecek.

## Test
Her değişiklikten sonra:

```bat
build_compiler_64.bat
uxb\compiler\scripts\run_language_surface_full_matrix.bat
uxb\compiler\scripts\run_mir_x64_completion_smoke.bat
```

Başarı ölçüsü:
- `mir=missing` sayısı azalacak.
- `x64_mir=missing` sayısı azalacak.
- Build kırılmayacak.
