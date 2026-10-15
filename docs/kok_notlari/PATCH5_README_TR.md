# uXBasic PATCH-5 — Iterator / EACH + Integration Hardening

Kaynak: `uxb(09.08_3).zip` + PATCH-4. `src/src` dahil edilmez.

- `FOR EACH` / `DO EACH` comma-separated expression-list semantiğini korur.
- Tek statik compile-time-bound array iterable olur; MIR yolu gerçek index/compare/load/branch üretir.
- x64 AST yolu da aynı array iteration semantiğini uygular.
- Canonical `MIR_ITER_CREATE/NEXT/CLOSE` ABI eklenir.
- Interpreter ve JS array iterator ABI'sini gerçek uygular.
- WASM mevcut host-handle array modeline fake import eklemez; iterator ABI fail-closed kalır.
- `MIR_MEMORY_REF` ikinci operandı ARRAY_NAME olarak düzeltilir.
- x64 iterator erişimi gerçek element width kullanır.
- LIST/DICT/SET için mevcut kaynakta gerçek iterator/MemoryView library ABI bulunmadığından uydurma implementasyon yapılmaz.
- `EXIT FOR/DO` loop context ile korunur.

Native Windows/FreeBASIC build bu ortamda çalıştırılmamıştır; uygulama sonrası build/test zorunludur.
