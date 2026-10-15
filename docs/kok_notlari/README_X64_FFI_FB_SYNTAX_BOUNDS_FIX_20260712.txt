UXB X64 FFI FreeBASIC syntax + AST bounds fix 20260712

Fixes two issues observed after UXB_X64_FFI_MKDIR_NATIVEERR_FIX:

1) FreeBASIC build error:
   ffi_call_backend.fbs(...): Syntax error, found Resume in On Error Resume Next
   The project FreeBASIC mode does not accept VB-style On Error Resume Next.
   FfiEnsureDirSafe now uses Dir(path, 16) before MkDir, so no exception path is needed.

2) x64 ABI10 build runtime error:
   runtime error 6 out of bounds array access at FfiCallReadDllEntry() line 216
   The FFI collector walked AST child/sibling pointers without validating bounds.
   It now validates node indices in FfiCallChildAt, FfiCallChildCount, FfiCallReadDllEntry, and recursive collection.

Touched files:
  src/codegen/x64/ffi_call_backend.fbs
