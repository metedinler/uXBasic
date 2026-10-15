# UXB Output Contract + YAMA6 PIPE RETURN Fix 20260711

Bu paket iki ayrı görünen ama aynı test zincirini etkileyen sorunu düzeltir.

1) ABI10 smoke: MIR gerçek PASS_ABI10 üretiyor fakat generic --stdout-out / --program-output-out dosyalarına yansıtılmıyordu.
   Kanıt: mir_exec_result.json içinde stdout/program_output = PASS_ABI10, fakat mir.stdout.txt boş.
   Düzeltme:
   - src/main_program_entry.fbs
   - src/main_program_entry_part2.fbs
   - compiler/scripts/run_library_abi10_smoke.ps1

2) YAMA6 PIPE: PIPE gövdesindeki RETURN INPUT, top-level RETURN/GOSUB hatasına sızıyordu.
   Kanıt: tasktable_all_kinds_yama6.uxb PIPE_RUN/3 yazdıktan sonra "RETURN used without GOSUB".
   Düzeltme:
   - src/runtime/exec/exec_slot_manager.fbs
   Task body çağrısı callContextDepth içinde çalışır; RETURN_CALL OUTPUT'a aktarılır ve top-level'e sızmaz.

3) .bat sessizliği:
   - tools/tests/run_yama6_interpreter_tests.py başarısız vakaların verb/source/stdout/stderr/check ayrıntılarını terminale basacak şekilde güncellendi.
