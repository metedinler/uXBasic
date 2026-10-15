UXB_ABI10_MIR_MAIN_BODY_LOWER_FIX_20260711

Duzeltilen sorun:
- ABI10 smoke testinde MIR exit=0 veriyor ama PASS_ABI10 uretmiyordu.
- Bunun nedeni FFI degil; MIR MAIN fonksiyonunun govdesi bos/yanlis lower edilebiliyor.
- Routine declaration'lar ayri pass ile lower ediliyor; MAIN_STMT govdesi ise artik AST icinde nerede durursa dursun bulunup sentetik MAIN MIR fonksiyonuna acikca indiriliyor.

Degisen dosya:
- src/semantic/mir_tail.fbs

Beklenen sonuc:
- ABI10 MIR stdout/program-output PASS_ABI10 icermeli.
- run_library_abi10_smoke.ps1 MIR asamasindan x64_ast_build asamasina gecmeli.
