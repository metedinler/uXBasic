# uXBasic x64 compiler build düzeltmesi

Bu yama yalnız değişen/yeni dosyaları içerir. Doğrudan `uxb` köküne açılır.

Düzeltilenler:

1. `src/runtime/exec/exec_slot_manager.fbs` içindeki FreeBASIC uyumsuz `Private Declare Function ExecSlotNativeCallback ...` satırı kaldırıldı. Fonksiyon gövdesi zaten daha aşağıda `Private Function ...` olarak tanımlıdır.
2. `src/main.bas` içinde `runtime/native/uxb_runtime_integration.fbs` include satırı runtime/exec bundlelarından önceye alındı. Böylece `uxb_runtime_try_init`, `uxb_task_register`, `uxb_slot_bind`, `uxb_slot_control`, `uxb_task_set_callback` prototipleri `exec_slot_manager.fbs` derlenmeden önce görünür.
3. `compiler/scripts/build_uxb_main_64.ps1` varsayılan olarak yalnız x64 host üretir. x86 host sadece `UXB_BUILD_X86=1` verilirse denenir.
4. `tools/library_tools/uxb_library_build.py` compiler build çağrısına `-SkipX86` ekler.

Yama DLL üretimini değiştirmez; std/libuv/TBB runtime DLL testleri zaten PASS verdi.
