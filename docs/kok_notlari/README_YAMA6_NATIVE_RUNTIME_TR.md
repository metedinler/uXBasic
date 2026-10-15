# uXBasic Yama 6 — Native Runtime, 256 Slot ve Backend Sistemi

Bu paket yalnız değişen/yeni dosyaları içerir ve mevcut `uxb` klasörünün üzerine açılır.

## Uygulanan mimari

- Mevcut `ExecState.slotTable(0 To 255)` korunur; ikinci ve kopuk bir görev tablosu oluşturulmaz.
- Slot kimliği dış API'de `Integer` alınır ve 0..255 doğrulanır. `UByte` ile yapılamayan 256 taşma kontrolü düzeltilmiştir.
- `uxb_runtime.dll` C ABI bütün normal işlemlerde 1=başarı, 0=hata sözleşmesini kullanır.
- DLL arama sırası: `native\uxb_runtime\build`, `bin`, `.\bin`, PATH.
- DLL veya callback yoksa AST/MIR mevcut senkron yürütme yoluna düşer.
- Native callback varsa EVENT/PIPE doğrudan, THREAD/PARALEL std/libuv/oneTBB backendinden yürütülür.
- `UXB_RT_BACKEND=auto|std|libuv|tbb`, `UXB_TBB_THREADS=N` desteklenir.
- SHELL için CreateProcess, stdout/stderr capture, timeout ve runpath native DLL içinde uygulanmıştır.
- Parser ve MIR, `NOWAIT`, `TIMEOUT`, `RUNPATH`, `OUTPATH`, `ERRPATH`, `OUTVAR`, `ERRVAR`, `CODEVAR` sözleşmesini taşır.

## Kurulum

Bu ZIP'i doğrudan mevcut `uxb` klasörüne açıp üzerine yazdırın.

Önce core sistem:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.bat
```

Yalnız native runtime testi:

```powershell
.\run_yama6_runtime_abi_tests.bat
```

DLL + AST/MIR interpreter testleri:

```powershell
.\run_yama6_interpreter_tests.bat
```

libuv ve oneTBB paketleri kuruluysa `auto` build ikisini de algılar. Ayrı buildler:

```powershell
.\native\uxb_runtime\build_runtime_dll_std.bat
.\native\uxb_runtime\build_runtime_dll_libuv.bat
.\native\uxb_runtime\build_runtime_dll_tbb.bat
```

## Çıktılar

- Çalışma DLL'i: `bin\uxb_runtime.dll`
- Kaynak build DLL'i: `native\uxb_runtime\build\uxb_runtime.dll`
- Dağıtım DLL'i: `dist\libraries\bin\uxb_runtime.dll`
- Test raporları: `reports\yama6_runtime\`

## Doğrulama sınırı

C++ std backend Linux g++ ile `-Wall -Wextra -Werror` altında derlenip callback testiyle çalıştırılmıştır.
FreeBASIC/Windows derlemesi bu ortamda çalıştırılamadığı için Windows PASS sonucu varmış gibi gösterilmemiştir.
