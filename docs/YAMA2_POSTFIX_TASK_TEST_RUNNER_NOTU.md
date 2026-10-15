# Yama 2 Postfix — task test runner/checker düzeltmesi

Bu paket Yama 2 çekirdek kodunu değiştirmez.

Düzeltilenler:
- `run_yama2_task_tests.bat` içinde checker yolu yanlıştı.
- Eski bat, `tools\tests\...` var mı diye bakıp `python tests\...` çalıştırıyordu.
- Checker tek AST dosyasında `EVENT_STMT`, `PIPE_STMT`, `THREAD_STMT`, `PARALEL_STMT` türlerinin hepsini arıyordu.
- `PARALEL_STMT` `task_thread_paralel_body_yama2.uxb` AST'sinde var; nested AST içinde olmaması doğrudur.

Yeni davranış:
- Dört AST dosyası üretilir.
- Checker dört AST dosyasını birlikte okur.
- EVENT/PIPE/THREAD/PARALEL türlerinin birleşik AST setinde bulunduğunu denetler.
- İç içe task için dotted/qualified symbol varlığını denetler.
- PIPE için PARAM_DECL varlığını denetler.
