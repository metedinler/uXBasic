# Analysis Log

## 2026-04-15 Delta
- FFI-CONV-1 hucresi parser/semantic/test tarafinda olgunlasti.
- FFI-SCOPE-1 runtime KISMEN sebebi scope statement exec siniriydi.

## 2026-04-15 Post-Update
- Scope runtime statement destegi eklendi; ilgili hucreler bir sonraki kanit turunda tekrar degerlendirilecek.

## 2026-04-15 Validation Cycle-2
- FFI-SCOPE-1 satirlarinda T kolonu iki satir icin OK'a cekildi.
- R kolonu policy/no-op dis cagrisi nedeniyle KISMEN olarak korundu.

## 2026-04-15 Validation Cycle-3
- FFI-CONV-1 notu, Win64 policy lane conv-compat ve ABI audit kaniti ile guncellendi.
- FFI-CONV-2 satiri PLAN durumda korundu; shadow-space/alignment codegen kriterleri acik.

## 2026-04-15 Validation Cycle-4
- FFI-CONV-2 satiri kanitli kapanisla OK/OK/OK/OK/OK olarak guncellendi.
- CG-3 satirlarinda CALL [register]/stack arg passing ve Win64 ABI hucreleri parser/semantic/test boyutunda yukseltilip runtime kolonunda KISMEN korundu.

## 2026-04-15 Validation Cycle-5
- FFI-CONV-3 satirinda x86 lane baslatildi: `src/codegen/x86/ffi_call_backend.fbs` + `tests/run_ffi_x86_call_backend.bas` kaniti ile P/S/T hucreleri KISMEN'e cekildi.
- R kolonu PLAN olarak korundu; x86 runtime gercek dis cagrida caller/callee cleanup icra kaniti ve resolver entegrasyonu acik.

## 2026-04-15 Validation Cycle-6
- FFI-CONV-3 satirinda runtime kolonu PLAN -> KISMEN guncellendi.
- Gerekce: resolver artifact (`ffi_call_x86_resolver.csv`) ve runtime resolver enforce/report gate entegrasyonu aktif.
- Kalan acik: gercek dis cagrida stack cleanup icra kaniti ve symptr adres yazimi.
- Kanit: `tests/run_ffi_x86_call_backend.bas`, `tests/run_ffi_x86_resolver_exec_ast.bas`, `tests/run_call_exec.bas` PASS.

## 2026-04-15 Validation Cycle-7
- Resolver lane'de bind-cache adimi tamamlandi; runtime dogrulama kaniti guclendi.
- Matris satirinda R=KISMEN korunuyor; cunku gercek dis cagrinin stack cleanup icrasi halen acik.
- Kanit: `ExecDebugGetFfiX86ResolvedCount` assertion'li test PASS.
