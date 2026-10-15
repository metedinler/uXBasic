# uXBasiC Stage-3 Hook / Trace Sistemi

Bu hamle compiler davranışını değiştirmez. Ama her ana katmanın çalışmasını JSON olarak izlenebilir hale getirir.

## Yeni CLI seçenekleri

```bat
--hook-trace
--trace-json
--session-live-json-out dist\session.live.json
--layer-timing-json-out dist\layer_timing.json
```

`--hook-trace` veya `--trace-json` verilirse trace aktifleşir. Ayrıca iki JSON çıktı yolundan biri verilirse trace otomatik aktif olur.

## Üretilen dosyalar

```text
dist\session.live.json
```

Canlı oturum olaylarını içerir. Her event sonrası yazılır. Derleyici erken `End` ile çıkarsa bile son yazılan olay kalır.

```text
dist\layer_timing.json
```

Katman bazlı süre özetini içerir. Özellikle runner ve VSCode paneli için uygundur.

## İzlenen katmanlar

- SESSION
- SOURCE_LOAD
- EXTRACT_SRC
- LEXER
- PARSER
- SEMANTIC
- AST_JSON
- HIR_JSON
- MIR_SURFACE_JSON
- MIR_PIPELINE_JSON
- MIR_BUILD
- EXECMEM
- INTEROP
- X64_EMIT
- X64_CODEGEN
- X64_BUILD
- RUN_REPORT

## Neden önemli?

Bundan sonra runner sadece `PASS/FAIL` demek yerine şunu da bilebilir:

- Lexer gerçekten çalıştı mı?
- Parser AST node üretti mi?
- Semantic pass çalıştı mı?
- MIR build edildi mi?
- x64 codegen gerçekten çalıştı mı?
- Hangi çıktı dosyaları üretildi?
- Hata hangi katmanda oldu?

Bu, uXBasiC için “kod gerçeği” kalite kapısının temelidir.
