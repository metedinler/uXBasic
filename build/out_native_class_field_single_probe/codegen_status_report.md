# uXBasic x64 Build Status

- source: .\tests\probes\native_class_field_single_probe.bas
- AST node count: 19
- x64 lane status: partial, statement-oriented native emit + import/ffi/link pipeline
- current guarantees: asm output, object build, import object aggregation, rsp generation, linker invocation, final exe emission
- known limits: x64 codegen still does not cover every language construct from PCK4/inceleme, INLINE is reported/planned as artifact but not yet semantically woven into main AST emit path
- recommendation: use this report together with COMPILER_TODO.md and generated interop artifacts
