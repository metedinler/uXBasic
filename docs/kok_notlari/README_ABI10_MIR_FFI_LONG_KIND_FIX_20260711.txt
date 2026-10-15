UXB ABI10 MIR FFI Long Kind Fix 20260711

Problem:
MIR interpreter calls uxffi_invoke10. uxffi.h expects C int return_kind, int arg_count and const int *arg_kinds.
AST bridge already uses FreeBASIC Long for these 32-bit C-int fields and ABI10 AST passes.
MIR bridge used FreeBASIC Integer for the same fields. On Win64 this can break the argKinds memory layout seen by C, so uxffi.dll reports: invalid argument kind.

Fix:
- src/interpreter/mir/mir_interp_ffi.fbs
- Use Long for FFI kind constants, returnKind, argCount, errorCapacity/textCapacity, and argKinds() array.
- Keep ULongInt for uint64 values and Double for F64 values.

Expected next result:
The MIR smoke should no longer stop at "MIR CALL(DLL) invocation failed: invalid argument kind".
If another failure appears, it should be a later semantic/runtime assertion or x64 build stage.
