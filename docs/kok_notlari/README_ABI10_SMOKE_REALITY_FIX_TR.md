# ABI10 Smoke gerçeklik düzeltmesi

Bu yama son ABI10 düzeltmesini körlemesine büyütmez; mevcut 05.07 kaynak gerçeğine göre yalnız ABI10 smoke zincirini onarır.

## Değişen dosyalar

- `compiler/scripts/run_library_abi10_smoke.ps1`
- `tests/libraries/abi10/build_abi10_test_dll.bat`
- `tests/libraries/abi10/build_abi10_test_dll.ps1`

## Neden?

Önceki test DLL derlemesi düzeldi; fakat smoke runner `uxb.exe` çağrısında kaynak dosyasını pozisyonel argüman olarak veriyordu. Güncel CLI bazen bunu kaynak olarak almıyor ve `source file path not provided` hatası döndürüyordu. Yeni runner bütün smoke çağrılarında `--source tests\libraries\abi10\abi10_smoke.uxb` kullanır.

Ayrıca `Run-Case` fonksiyonundaki `$Args` parametresi `$CliArgs` olarak değiştirildi. PowerShell'in otomatik `$args` değişkeniyle karışma riski kaldırıldı.

BAT dosyası tekrar bağımsız/okunabilir hale getirildi: GCC'yi `UXB_GCC`, `GCC`, MSYS2 UCRT64 ve PATH sırasıyla arar, log yazar, DLL'i `build`, `bin`, `dist\libraries\bin` ve import library'yi `dist\libraries\lib` altına kopyalar.
