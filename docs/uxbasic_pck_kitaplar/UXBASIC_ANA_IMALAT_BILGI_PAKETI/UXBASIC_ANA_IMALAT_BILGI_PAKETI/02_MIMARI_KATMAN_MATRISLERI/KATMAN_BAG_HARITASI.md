# UXBasic Katmanlar Arası Bağ Haritası

Bu belge, bir yüzey özelliğinin hangi katmanlarda karşılık bulması gerektiğini gösterir. Bundan sonra hiçbir yama yalnız tek dosyayı değiştirmiş sayılmamalı; zincirdeki etkileri kontrol edilmelidir.

## Standart zincir

| Katman | Görev | Tipik dosyalar |
|---|---|---|
| Lexer | Anahtar kelime/operator/token üretimi | `parser/lexer/lexer_keyword_table.fbs`, `token_kinds.fbs`, `lexer_readers.fbs` |
| Preprocessor | Meta komutlar, include/import, asset, gate | `parser/lexer/lexer_preprocess.fbs`, `src/preprocessor/*` |
| Parser | Statement/expression parse | `parser/parser/*.fbs` |
| AST | Düğüm türleri, child/accessor, contract | `parser/ast*.fbs`, `ast_node_kinds.fbs`, `ast_contract*` |
| Semantic | Symbol, scope, type, layout, diagnostics | `semantic/*`, `symbols/*`, `type_binding/*`, `layout/*` |
| MIR | Opcode, registry, lower, verify, JSON export | `mir/*`, `semantic/mir*.fbs` |
| Runtime | Interpreter ve servis yürütme | `runtime/*`, `runtime/exec/*`, `runtime/services/*` |
| Backend | x64/x86/JS/WASM emit ve target policy | `backend/*`, `codegen/*` |
| CLI/Tools | Run/build/check/gate JSON üretimi | `cli/*`, `tools/control/*`, `compiler/scripts/*` |
| Docs/Reports | Matrix, status, test sonuçları | `docs/matrix/*`, `reports/control/*` |

## Örnek: `PARALEL` komutu

1. Lexer: `paralel` keyword olmalı; `parallel` olmamalı.
2. Parser: `ParseParalelStmt` veya `ParseNamedSlotHeader(...,"PARALEL_STMT","PARALEL")`.
3. AST: `ASTK_PARALEL_STMT`, node text `PARALEL_STMT`.
4. Semantic/MIR: lane/hint `PARALEL`, opcode `MIR_PARALEL_HINT`.
5. Runtime: slot/lane manager `PARALEL` tanımalı.
6. Backend: metadata-only/host policy; native emit gerekiyorsa explicit unsupported.
7. Test: `PARALEL` kabul, `PARALLEL` negatif fail.

## Örnek: FFI/DLL/API

- Lexer: `DECLARE`, `LIB`, `ALIAS`, `CALL` keyword.
- Parser: `DECLARE ... LIB ... ALIAS ...` ayrı; `CALL(DLL/API,...)` ayrı.
- Semantic: signature binding, ABI, arg/return type check.
- Runtime/native: FFI registry ve manifest.
- JS/WASM: native yüzey fail-close.
- CLI/report: hangi hedefte neden desteklenmediği JSON raporlanmalı.

## Örnek: Preprocessor RAW_JS

- Preprocessor: komut tanınır.
- Gate: JS hedefi ve izin olmadan geçmez.
- Parser: preprocess çıktı geçerliyse parse edilir.
- Reports: negatif testte beklenen hata kodu üretilir.
