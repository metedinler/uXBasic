# uXBasic x64 Build Status

- source: C:\Users\mete\Downloads\BasicOyunSource\uXBasic_repo\tests\basicCodeTests\21_matrix_flow_if_select_exitif.bas
- AST node count: 31
- x64 lane status: partial, statement-oriented native emit + import/ffi/link pipeline
- current guarantees: asm output, object build, import object aggregation, rsp generation, linker invocation, final exe emission
- known limits: x64 codegen still does not cover every language construct from PCK4/inceleme, INLINE is reported/planned as artifact but not yet semantically woven into main AST emit path
- recommendation: use this report together with COMPILER_TODO.md and generated interop artifacts
