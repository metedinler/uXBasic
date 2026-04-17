# Task Log

- [DONE] FFI-CONV-1 hucre aciklama revizyonu
- [DONE] FFI-SCOPE-1 test hucreleri KISMEN->OK guncellemesi
- [DONE] FFI-CONV-2 bootstrap notu (kapanis disi) dokumante edildi
- [DONE] FFI-CONV-2 codegen kapanis kriteri (shadow/alignment) kanit paketi
- [DONE] FFI-CONV-3 x86 lane baslangic hucre guncellemesi (PLAN->KISMEN)
- [DONE] FFI-CONV-3 resolver/runtime gate artisiyla R kolonu PLAN->KISMEN
- [DONE] FFI-CONV-3 invoke-proof lane: I32 imza icin 0..4 arg runtime pointer call yolu + cleanup sayaç kaniti
- [DONE] FFI-CONV-3 symptr map uzerinden pointer call kapanisi (stub_id/symptr/procAddr izlenebilir)
- [DONE] FFI-CONV-3 symptr write-through gozlemlenebilirlik kaniti (label/procAddr + write counter)
- [DONE] FFI-CONV-3 native lane probe otomasyonu eklendi (`tools/run_ffi_conv3_native_lanes.ps1` + probes)
- [DONE] FFI-CONV-3 gercek x86-32 proses duzeyinde stack cleanup icra kaniti (`native_cleanup` PASS; win32 target guard `__FB_WIN32__` + `Not __FB_WIN64__`)
- [DONE] FFI-CONV-3 native stub label bellek patchleme proof'u (`native_symptr_patch` PASS via cmd fallback)
- [NEXT] STUB-DEBT: `CALL(API,...)` lane'i su an bilincli olarak unsupported (kanit testi: `tests/run_call_api_unsupported_exec_ast.bas`)
