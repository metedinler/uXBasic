# UXB WASM Target Rules

uXBasic does not need to emit `.wasm` directly in Step 1. The first target path is:

`uXBasic source -> lexer/parser -> AST -> semantic/type/layout -> MIR -> WAT -> wat2wasm -> browser runtime`

Use `IMPLEMENTED` in `wasm_wat_status` only for MIR operations that lower to WAT directly: integer arithmetic, floating arithmetic, local/global variables, branch flow, loops, function calls, return, memory load/store, and simple arrays.

Console IO, file IO, HTTP, JSON, REGEX, DLL, WinAPI, GUI, AUDIO, CANVAS, LLAMA, PROLOG, LUA, SQLITE, and OS operations must be marked as `RUNTIME_CALL`, `BROWSER_ONLY`, `NATIVE_ONLY`, or `WASM_UNSUPPORTED`.

External tools: WABT `wat2wasm`, WABT `wasm2wat`, Binaryen `wasm-opt`, and Emscripten `emcc`.
