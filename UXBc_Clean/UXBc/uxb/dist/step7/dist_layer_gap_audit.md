# UXBc Dist Layer Gap Audit

## Surface Matrix
- rows: `375`
- layer missing/partial/diagnostic counts:
  - ast_interpreter: `375`
  - docs: `375`
  - hir: `375`
  - mir: `375`
  - mir_interpreter: `375`
  - runtime: `375`
  - semantic: `375`
  - x64_ast: `375`
  - x64_mir: `375`
  - ast: `306`
  - ffi: `297`
  - lexer: `294`
  - parser: `124`
  - tests: `56`

## Keyword Layer Matrix
- rows: `197`
- unknown keyword count: `197`
- unknown sample: `ABS, ABSTRACT, ALIAS, AND, ARRAY, AS, ASC, ASSERT, ATN, BALL, BIGD, BIGF, BOOLEAN, BYREF, BYTE, BYVAL, CALL, CASE, CATCH, CDBL`
- AST/MIR interpreter mismatch count: `48`

## Step6 Expected Runner
- rows: `40`
- accepted NO count: `1`
- actual status counts:
  - TOOLCHAIN_OR_FILE_MISSING: `30`
  - EXPECTED_DIAGNOSTIC: `8`
  - PASS_OR_ACCEPTED: `1`
  - SKIPPED_DUPLICATE: `1`

## JS/WASM Coverage Schema
- js_transpiler_column_present: `False`
- wasm_column_present: `False`
- note: Dist core matrices do not have dedicated js_transpiler/wasm columns; coverage is not proven by matrix schema.