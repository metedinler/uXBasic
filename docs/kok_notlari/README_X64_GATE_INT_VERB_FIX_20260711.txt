# UXB_X64_GATE_INT_VERB_FIX_20260711

Bu paket iki kök problemi hedefler:

1. `--build-x64 --codegen-source AST` sırasında ADIM25 close-gate MIR hazır
   olmadığı için `... FAIL_MIR_NOT_READY` hatası veriyordu.  x64 emit/build
   akışında semantic MIR artık coverage/diagnostic için her zaman kurulur.

2. `uxb.exe int file.uxb` kullanıcı-facing interpreter verb olarak YAMA6
   testlerinde `run` ile aynı davranış bekliyor; ancak `int` MIR'e gidiyordu.
   MIR runtime surface (EVENT/PIPE/THREAD/PARALEL/SHELL) henüz feature-complete
   değil.  Bu yüzden `int` varsayılanı AST-compatible interpreter yapıldı.
   MIR yine açıkça `mir` verb'i veya `--interpreter-backend MIR` ile test edilir.

Ek olarak Collect_UXB_Debug.ps1 daha çok report klasörü kopyalar ve
UXB_VISIBLE_TEST_RUNNER_20260711.ps1 terminalde sonuç dosyalarını görünür basar.
