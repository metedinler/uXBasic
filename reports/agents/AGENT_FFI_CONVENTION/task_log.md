# Task Log

- [DONE] CDECL/STDCALL lexer+parser+runtime token path
- [DONE] Invalid convention parse fail-fast testi
- [DONE] Win64 policy lane conv-compat scaffold (FFI-CONV-2 bootstrap)
- [DONE] Shadow-space + stack-alignment emitter lane (FFI-CONV-2 closure)
- [DONE] x86 plan backend + cleanup_type metadata (FFI-CONV-3 kickoff)
- [DONE] x86 backend test coverage (tests/run_ffi_x86_call_backend.bas)
- [DONE] x86 resolver artifact + runtime enforce/report gate (tests/run_ffi_x86_resolver_exec_ast.bas)
- [DONE] x86 resolver symbol bind-cache (stub_id -> procAddr)
- [DONE] x86 resolver cleanup-contract proof gate (tests/run_ffi_x86_resolver_cleanup_proof.bas)
- [DONE] x86 runtime pointer invoke-proof (I32 signature, 0..4 arg) + caller/callee cleanup byte sayaç kaniti
- [DONE] symptr map tabanli pointer call kapanisi (invoke stub id/conv/cleanup debug izleme)
- [DONE] symptr write-through gozlemlenebilirlik kaniti (label/procAddr mapping + write counter)
- [DONE] x86 native lane probe otomasyonu (`tools/run_ffi_conv3_native_lanes.ps1`) + probe testleri eklendi
- [NEXT] gercek x86-32 assembly-level cleanup icra kaniti (host blocked: `bin/win32/as.exe` eksik)
- [NEXT] __uxb_ffi_x86_symptr_N native bellek patchleme (host blocked: `bin/win32/as.exe` eksik)
- [NEXT] STUB-DEBT: CALL(API,...) lane'i bilincli unsupported; ileride API router tasarimi ile ele alinacak
