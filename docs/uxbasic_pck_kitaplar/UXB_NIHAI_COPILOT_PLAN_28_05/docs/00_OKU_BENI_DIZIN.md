# UXB Nihai Copilot Planı — 28.05

Bu paket, önceki planları tek son plana indirir. Amaç Copilot'a tek dev metin değil, her biri ayrı uygulanabilir belge vermektir.

Kaynak kontrol notları:
- Adım0 surface lifecycle CSV paketi kontrol edildi.
- `surface_lifecycle_matrix.csv`: 268 surface.
- `surface_lifecycle_blockers.csv`: 222 blocker.
- `target_backend_blockers.csv`: 137 backend blocker.
- `fake_implemented_lifecycle.csv`: 91 sahte/erken IMPLEMENTED işareti.
- Strict gate durumu: `FAIL`.
- Route dağılımı: `{'AST_INTERPRETER': 50, 'MIR_TO_TARGET_BACKEND': 137, 'NATIVE_ONLY_WITH_TARGET_DIAGNOSTIC': 6, 'COMPILE_TIME_PREPROCESS': 46, 'RUNTIME_SERVICE': 21, 'DIRECT_NATIVE_AST_CODEGEN': 8}`.

Temel karar:
1. Temizlik silerek değil, inventory ve emekliye ayırma planıyla başlayacak.
2. Hiçbir katman “partial çalışıyor” diye kapatılmayacak.
3. Lexer surface öğesi bir yaşam döngüsü kaydına sahip olacak.
4. Her surface için lexer/parser/AST/semantic/HIR/MIR/interpreter/backend/runtime/test/doc karşılığı ya gerçek olacak ya da açık statüyle raporlanacak.
5. AST interpreter ve MIR interpreter ayrı modüler katmanlar olarak korunacak; biri diğerinin yerine geçmeyecek.
6. Minimal yol korunacak ama verified MIR'e kadar giden gerçek check yolu olacak.
7. Standard yol backend artifact üretim yolu olacak.
8. Full yol toolchain/release yolu olacak.

Klasör düzeni:
```text
docs/       Copilot'a verilecek ayrı belgeler
csv/        yeni nihai plan CSV'leri
reference_csv/ önceki detaylı CSV'lerin aynen kopyası
```

Önce `docs/01_COPILOT_ANA_KURALLAR.md`, sonra sırasıyla adım belgeleri verilecek.
