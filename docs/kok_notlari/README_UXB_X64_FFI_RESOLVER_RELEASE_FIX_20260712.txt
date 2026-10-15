# UXB x64 FFI resolver + release diagnostics fix 20260712

Bu yama üç kök sorunu hedefler:

1. ABI10 x64 build, include çözümlemeden sonra program.asm üretmeye başladı; fakat program.asm
   `__uxb_ffi_resolve_all` çağırmasına rağmen `ffi_resolver.c` üretilmiyordu. Nedeni:
   `src/codegen/x64/ffi_call_backend.fbs` resolver pass'i `CALL_DLL_STMT` / `CALL_API_STMT`
   düğümlerini toplamıyordu. Bu yama bu düğümleri ve IDENT/TYPE_REF imza düğümlerini toplar.

2. `--build-x64-out` compiler içinde artifact klasörü gibi davranıyor. ABI10 script'i buna
   `abi10_x64_ast.exe` adında dosya yolu verince klasör oluşuyor ve sonra PowerShell Confirm
   soruları geliyor. Script artık `abi10_x64_ast_build\program.exe` sözleşmesini kullanır.

3. Release pipeline'daki tp_03 string builtin hatasında x64 asm `call left` / `call right`
   üretiyordu. AST-x64 builtin tablosuna LEFT/LEFT$ ve RIGHT/RIGHT$ eklendi.

Ek olarak `x64_build_pipeline.fbs` build_all.bat stdout/stderr dosyalarını artifact klasörüne
yazar. Bundan sonraki NASM/GCC/link hataları terminale ve debug zip'e açık düşer.
