# MIR x64 Lexer/Parser Keyword Surface Completion

Bu yama `192 keyword sabittir` varsayımını kaldırır. Keyword sayısı her zaman
`uxb/src/parser/lexer/lexer_keyword_table.fbs` içinden otomatik çıkarılır.
Bu paket hazırlanırken çıkarılan sayı: **197**.

## Eklenen dosyalar

- `uxb/src/codegen/x64/mir_x64_keyword_surface.fbs`
- `uxb/tools/uxb_mir_x64_surface_audit.py`
- `uxb/compiler/scripts/run_mir_x64_surface_audit.bat`

## Prensip

Her keyword için MIR x64 hattında bir karşılık vardır:

- gerçek native emit,
- compile-time/no-emit,
- runtime-call,
- external FP runtime,
- explicit diagnostic.

Sessiz eksik bırakmak yasaktır. Native olmayan alanlarda backend açık diagnostic verir.

## Çalıştırma

```bat
cd /d C:\Users\mete\Downloads\UXBc
uxb\compiler\scripts\run_mir_x64_surface_audit.bat
```

Çıktılar:

- `uxb/dist/mir_x64_keyword_surface_audit.json`
- `uxb/dist/mir_x64_keyword_surface_audit.csv`
- `uxb/dist/mir_x64_keyword_surface_audit.md`

## Dürüst sınır

Bu yama bütün keywordleri sessiz eksik olmaktan çıkarır. Ancak `CLASS`, `THREAD`,
`OPEN`, `TRY` gibi ağır sistemlerin native machine-code davranışı hâlâ ilgili
runtime/backend ailesinin tamamlanmasına bağlıdır. Bu keywordler artık `missing`
değil, `diagnostic_*_pending` durumundadır.
