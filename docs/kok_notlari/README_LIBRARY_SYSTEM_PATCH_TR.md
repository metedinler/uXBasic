# uXBasic x64 Kütüphane Sistemi Yaması

Bu yama yalnız değişen ve yeni dosyaları içerir. Kaynak arşivinin tam kopyası değildir.

## Kurulum

İki eşdeğer paket üretilmiştir:

1. `UXB_LIBRARY_SYSTEM_PATCH_PARENT_ROOT.zip`: `C:\...\UXBc` klasöründe açılır. Paket içindeki `uxb\` klasörü mevcut `uxb\` klasörünün üzerine yazılır.
2. `UXB_LIBRARY_SYSTEM_PATCH_DIRECT_ROOT.zip`: doğrudan `C:\...\UXBc\uxb` klasöründe açılır.

Önce mevcut klasörün yedeğini alın. ZIP açılırken **üzerine yazmaya izin verin**.

## Tek komut

Yama uygulandıktan sonra `uxb` klasöründe:

```bat
BUILD_UXB_LIBRARY_SYSTEM.bat
```

Bu komut varsayılan olarak:

- x64 `uxb.exe` dosyasını yeniden üretir ve `bin\uxb.exe` konumuna koyar,
- çekirdek kütüphaneleri ve `uxffi.dll` ABI10 köprüsünü derler,
- wrapper–C prototip uyumunu derleme öncesinde doğrular,
- DLL mimarisi ve export tablosunu derleme sonrasında doğrular,
- çalışma DLL’lerini `bin\` içine,
- dağıtım DLL’lerini `dist\libraries\bin\` içine,
- bağımlılık DLL’lerini `dist\libraries\deps\` içine,
- import library dosyalarını `dist\libraries\lib\` içine koyar,
- AST, MIR ve x64 ABI10 duman testlerini çalıştırır,
- JS/WAT/WASM için native DLL çağrılarının fail-close davranışını test eder.

MSYS2 UCRT64 ve gerekli paketler eksikse varsayılan çalışma bunları `pacman` ile kurmayı dener. FreeBASIC için proje içindeki `tools\FreeBASIC-1.10.1-win64\fbc.exe` veya PATH üzerindeki `fbc.exe` kullanılır.

## Dizin sözleşmesi

| Amaç | Klasör |
|---|---|
| Derleyici kaynakları | `src\` |
| Native C/C++ DLL kaynakları | `runtime_ext\<modül>\` |
| uXBasic wrapper kaynakları | `libsx\<modül>\` |
| Genel uXBasic başlıkları | `include\modules\` |
| Kütüphane testleri | `tests\libraries\` |
| Geçici derleme ürünleri | `build\libraries\` |
| Dağıtım ürünleri | `dist\libraries\` |
| Çalışma zamanı DLL kopyaları | `bin\` |
| Raporlar | `reports\libraries\` |

Kaynak klasörlerine yeni DLL/EXE/OBJ/LIB ürünleri bırakılmaz. Eski modül BAT dosyalarının `dist\runtime_ext` çıktısı uyumluluk girişi olarak kabul edilir ve kanonik dizinlere taşınır/kopyalanır.

## ABI10

`CALL(DLL, ...)` için kanonik biçim:

```uxbasic
CALL(DLL, "modul.dll", "sembol", DONUS_TIPI, CDECL, "ARG1,ARG2,...", arg1, arg2, ...)
```

Desteklenen ABI türleri:

```text
VOID I32 U32 I64 U64 F64 PTR STRPTR
```

En fazla 10 çalışma zamanı parametresi vardır. Mevcut wrapper kaynaklarında gözlenen en yüksek sayı 8’dir. AST ve MIR interpreter karma tipli çağrılarda `bin\uxffi.dll` köprüsünü kullanır. x64 kod üretimi Microsoft x64 ABI’ye doğrudan çağrı üretir.

Ayrıntılar için:

- `docs\LIBRARY_SYSTEM_STANDARD_TR.md`
- `docs\LIBRARY_ABI10_TR.md`
- `docs\LIBRARY_PATCH_INSTALL_TR.md`
- `manifests\uxb_library_system.json`
