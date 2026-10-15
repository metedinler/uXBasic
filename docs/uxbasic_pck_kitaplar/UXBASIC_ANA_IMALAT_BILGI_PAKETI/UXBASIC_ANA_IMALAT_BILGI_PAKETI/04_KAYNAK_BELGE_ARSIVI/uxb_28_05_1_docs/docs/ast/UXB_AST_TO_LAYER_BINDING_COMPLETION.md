# AST to Layer Binding Completion Rules

## Compile-time-only nodes

Import/include/alias/using/module/namespace/declaration metadata nodes are marked `COMPILE_TIME_ONLY` for execution layers. Layout is `NOT_APPLICABLE` unless the node defines a type or object layout.

## Native-only nodes

Native inline nodes are marked `NATIVE_ONLY`. They are not silently accepted by JS or WASM.

## Layout nodes

TYPE, CLASS, INTERFACE, field, declaration, object creation, field access, member access, and index access nodes receive a layout binding decision through `LayoutStep2Contract`.

## Runtime nodes

Console, file, memory, event, slot, pipe, thread, and runtime-service nodes are bound to the portable AST execution bridge and to MIR runtime decisions.

## WASM/WAT

Pure expressions and control-flow nodes can be WAT-dispatch candidates. File, console, browser, and runtime-service nodes are `RUNTIME_CALL`. Type/object and native-only nodes are `WASM_UNSUPPORTED` unless a later backend step explicitly implements them.
