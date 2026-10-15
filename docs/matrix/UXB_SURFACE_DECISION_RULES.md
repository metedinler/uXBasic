# UXB Surface Decision Rules

- Lexer evidence without parser evidence sets `parser_status` to `MISSING`.
- Parser evidence without AST contract evidence sets `ast_contract_status` to `MISSING`.
- Runtime surfaces require at least one execution path among AST interpreter, MIR interpreter, MIR x64, JS, browser, or library binding.
- Compile-time surfaces use `COMPILE_TIME_ONLY` for execution layers.
- Native surfaces must say `NATIVE_ONLY` or `WASM_UNSUPPORTED` on non-native targets.
- Parser-only diagnostic surfaces use `DIAGNOSTIC_ONLY` only for diagnostic evidence.
