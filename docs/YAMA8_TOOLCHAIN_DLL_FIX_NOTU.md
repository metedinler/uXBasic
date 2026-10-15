# Yama 8 toolchain / DLL üretim düzeltmesi

Bu yama yeni dil özelliği eklemez. Amaç runtime DLL üretimindeki araç zinciri karışmasını kapatmak ve test/runner altyapısını güvenilir hale getirmektir.

## Çözülen hata

Son logda derleyici `C:\Program Files\CodeBlocks\MinGW` g++ ile çalışırken script `C:\msys64\mingw64\include` ve `C:\msys64\mingw64\lib` yollarını da ekliyordu. Bu iki farklı MinGW/CRT evreni karışınca C++ standart başlıklarında şu hatalar oluştu:

- `at_quick_exit` has not been declared
- `quick_exit` has not been declared
- `timespec_get` has not been declared

Yeni `build_runtime_dll.bat` yalnız seçilen g++ kökünün include/lib yollarını kullanır.

## Önerilen komutlar

Önce teşhis:

```powershell
.\run_runtime_toolchain_doctor.bat
```

Temel derleme:

```powershell
.\native\uxb_runtime\build_runtime_dll.bat
.\run_yama6_runtime_abi_tests.bat
```

UCRT64 kullanmak için:

```powershell
set UXB_MINGW_ROOT=C:\msys64\ucrt64
.\native\uxb_runtime\build_runtime_dll.bat
```

libuv / oneTBB:

```powershell
set UXB_MINGW_ROOT=C:\msys64\ucrt64
.\native\uxb_runtime\build_runtime_dll.bat --libuv
.\native\uxb_runtime\build_runtime_dll.bat --tbb
.\native\uxb_runtime\build_runtime_dll.bat --libuv --tbb
```

## Araçlar

- `uxr_calistir.bat` eski yanlış `--init`, `--quick`, `--reserve` çağrılarını doğru komuta çevirir.
- `run_all_source_tests.bat` tests/examples içindeki `.uxb`, `.uxbh`, `.bas` kaynaklarını tarar.
- `run_adim36_full_surface_tests.bat` Adım 36 tam yüzey zincirini çağırır.
- `run_uxbrarp.bat` derin run raporlayıcıyı çağırır.

