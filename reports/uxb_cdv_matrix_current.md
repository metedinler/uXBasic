# uXBasic CDV Matrix - Current Source Reality

## Scope

This report reflects the current `uxb/src` tree and does not assume the old 192-command figure. It separates lexer keywords, parser dispatch, AST, semantic lowering, runtime execution, MIR, and x64 codegen.

## Key Counts

- Lexer keyword entries: 190 distinct keywords, with one duplicate `string` entry in the source table.
- Statement dispatch entries: 76 `AddStatementDispatchEntry` calls in `parser_stmt_registry.fbs`.
- Matrix sources: `uxb/src/parser/lexer/lexer_keyword_table.fbs`, `uxb/src/parser/parser/parser_stmt_registry.fbs`, `uxb/src/parser/ast.fbs`, `uxb/src/semantic/mir.fbs`, `uxb/src/runtime/exec/*.fbs`, `uxb/src/build/x64_build_pipeline.fbs`.

## Coverage Matrix

| Surface | Lexer | Parser | AST | Semantic | Runtime | MIR | x64 | Status |
|---|---|---|---|---|---|---|---|---|
| Flow control | yes | yes | yes | yes | yes | yes | partial | `IF`, `SELECT`, `FOR`, `DO`, `GOTO`, `GOSUB`, `RETURN`, `EXIT`, `TRY`, `THROW`, `ASSERT` |
| Declarations | yes | yes | yes | yes | yes | yes | partial | `CONST`, `DIM`, `REDIM`, `TYPE`, `CLASS`, `INTERFACE`, `SUB`, `FUNCTION`, `DECLARE` |
| Scope/organization | yes | yes | yes | partial | partial | partial | partial | `MODULE`, `MAIN`, `NAMESPACE`, `USING`, `ALIAS`, `IMPORT`, `INCLUDE` |
| Console I/O | yes | yes | yes | yes | yes | partial | partial | `PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`, `LOCATE`, `COLOR`, `CLS` |
| Memory ops | yes | yes | yes | partial | yes | yes | yes | `POKE*`, `PEEK*`, `MEMCOPY*`, `MEMFILL*`, `SETNEWOFFSET`, `INC`, `DEC` |
| Event/thread lane | yes | yes | yes | partial | partial | no | no | `EVENT`, `THREAD`, `PARALEL`, `PIPE`, `SLOT`, `ON`, `OFF`, `TRIGGER` |
| Expression operators | yes | parser expr | yes | yes | yes | yes | partial | `AND`, `OR`, `NOT`, `XOR`, `MOD`, `SHL`, `SHR`, `ROL`, `ROR` |
| Built-in types/modifiers | yes | yes | yes | partial | partial | partial | partial | `I8..U64`, `F32`, `F64`, `F80`, `BOOLEAN`, `STRING`, `OBJECT`, `PTR`, `BYREF`, `BYVAL`, `CDECL`, `STDCALL` |
| Built-in functions | yes | parser expr | yes | partial | partial | partial | partial | `LEN`, `MID`, `STR`, `VAL`, `ABS`, `INT`, `UCASE`, `LCASE`, `SIN`, `COS`, `TAN`, `ATN`, `EXP`, `LOG`, `SQR`, `RND`, `TIMER`, `VARPTR`, `SIZEOF`, `OFFSETOF` |

## Notes

- `FOR EACH` and `DO EACH` are lookahead variants in the dispatch registry.
- `ABSTRACT`, `FINAL`, and `SEALED` are class modifiers that reuse the `CLASS` dispatch lane.
- `KEYWORD_REF` exists in the AST surface so keywords can participate in expression parsing when needed.
- `x64_build_pipeline.fbs` still reports the codegen lane as partial for the full language surface.

## Recommendation

Use this report as the baseline CDV matrix for Stage-4 planning. Any future keyword-count reference should be regenerated from source rather than copied from old notes.
