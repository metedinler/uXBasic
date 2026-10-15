# uXBasic C Tabanlı A Grubu Kütüphaneleri

Bu paket mevcut uXBasic kaynak ağacının üzerine açılacak, yalnız yeni dosyalar
içeren bir kütüphane eklentisidir. Mevcut kütüphaneleri, compiler kaynaklarını
ve `build_libraries.ps1` sistemini değiştirmez.

## Kesin mimari kararı

C derleyicisi SQLite, libcurl, PCRE2, Zstandard, libarchive veya libsodium
motorlarını kendi içinde taşımaz. Bunlar ayrı üçüncü taraf kütüphanelerdir.

Bu pakette iki katman kullanılır:

```text
üçüncü taraf C motoru
    ↓
uXBasic için dar ve sabit C ABI adaptörü: ux*.dll
    ↓
libsx/<modül>/<modül>.bas
    ↓
INCLUDE "include/modules/<modül>.uxmh"
    ↓
uXBasic programı
```

Adaptör kullanılmasının nedeni:

- `libcurl` ayar API'si variadic olduğu için doğrudan ABI10 çağrısına uygun değildir.
- yyjson, PCRE2 ve libarchive yapı/ömür/pointer ayrıntılarını dışarı taşır.
- SQLite doğrudan çağrılabilse de prepared statement ve hata yaşam döngüsünü
  standartlaştırmak gerekir.
- Zstandard ve libsodium doğrudan çağrılabilir; fakat buffer sahipliği, boyutlar,
  hata dönüşleri ve güvenli varsayımlar uXBasic adaptöründe sabitlenir.

## Modüller

| Modül | Motor | Uygulama |
|---|---|---|
| `uxsqlite` | SQLite | MSYS2 UCRT64 DLL + uXBasic adaptörü |
| `uxhttp` | libcurl | MSYS2 UCRT64 DLL + zorunlu adaptör |
| `uxjson` | yyjson 0.12.0 | Kaynak kod adaptör DLL içine gömülür |
| `uxregex` | PCRE2-8 | MSYS2 UCRT64 DLL + adaptör |
| `uxcompress` | Zstandard | MSYS2 UCRT64 DLL + adaptör |
| `uxarchive` | libarchive | MSYS2 UCRT64 DLL + güvenli çıkarma adaptörü |
| `uxcrypto` | libsodium | MSYS2 UCRT64 DLL + yüksek seviye güvenli adaptör |

## Klasör düzeni

Paket mevcut kanonik düzene uyar:

```text
runtime_ext/<modül>/       C adaptör kaynakları
libsx/<modül>/             uXBasic wrapper
include/modules/           INCLUDE başlıkları
tests/libraries/cbase/     uXBasic smoke testi
compiler/scripts/          kurulum, build ve test betikleri
build/libraries/cbase/     geçici build ürünleri
dist/libraries/bin/        ux*.dll adaptörleri
dist/libraries/deps/       üçüncü taraf bağımlılık DLL'leri
dist/libraries/lib/        import library dosyaları
reports/libraries/cbase/   build ve test raporları
bin/                       runtime için adaptör ve bağımlılık DLL kopyaları
```

## İlk çalıştırma

uXBasic kökünde:

```powershell
.\BUILD_UXB_CBASE_LIBRARIES.bat -InstallDeps -FetchDeps -Clean -RunTests
```

`-InstallDeps` yalnız eksik MSYS2 UCRT64 paketlerini kurar. MSYS2 sisteminin
tam güncellemesini otomatik yapmaz. Pacman veritabanı veya sistem sürümü eskiyse
önce MSYS2 UCRT64 terminalinde:

```bash
pacman -Syu
```

çalıştırın; terminal kapanmasını isterse yeniden açıp aynı komutu tekrar çalıştırın.

Sadece yeniden derleme:

```powershell
.\BUILD_UXB_CBASE_LIBRARIES.bat -FetchDeps
```

Yalnız belirli modüller:

```powershell
.\BUILD_UXB_CBASE_LIBRARIES.bat -Modules uxsqlite,uxjson,uxregex -FetchDeps
```

Test çalıştırmadan build:

```powershell
.\BUILD_UXB_CBASE_LIBRARIES.bat -InstallDeps -FetchDeps
```

## Araç yolları

Betik öncelikle mevcut uXBasic araç sözleşmesini kullanır:

```text
UXB_GCC
UXB_PKG_CONFIG
UXB_PACMAN
UXB_OBJDUMP
```

Bunlar yoksa varsayılan olarak:

```text
C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe
C:\msys64\ucrt64\bin\pkgconf.exe
C:\msys64\usr\bin\pacman.exe
C:\msys64\ucrt64\bin\objdump.exe
```

aranır.

## Çalıştırma örneği

```uxbasic
INCLUDE "include/modules/uxsqlite.uxmh"

DIM db AS U64
db = uxsqlite.OpenMemory()
ASSERT db <> 0
ASSERT uxsqlite.Exec(db, "CREATE TABLE t(x INTEGER)") = 0
ASSERT uxsqlite.Exec(db, "INSERT INTO t VALUES(1),(2),(3)") = 0
uxsqlite.Close(db)
```

## İlk sürümün bilinçli sınırları

- Bu paket compiler çekirdeğini değiştirmez.
- JS/WAT/WASM hedeflerinde native DLL çağrıları desteklenmez ve fail-close
  davranışı korunmalıdır.
- `uxarchive` ilk sürümde okuma, sayma ve güvenli çıkarma sağlar; arşiv oluşturma
  ikinci aşamaya bırakılmıştır.
- `uxhttp` ilk sürümde senkron istemcidir. Asenkron/multi API sonraki aşamadır.
- `uxjson` ilk sürümde okuma, JSON Pointer sorgulama ve yeniden yazma sağlar.
  Mutable builder API sonraki aşamadır.
- Grafik ve ses kütüphaneleri bu pakette derlenmez. Aynı sistemin ikinci seti
  olarak `uxraylib`, `uxsdl`, `uxaudio/miniaudio` ve `uximage` eklenecektir.

## Doğrulanmamış nokta

Bu çalışma ortamında Windows 11, MSYS2 UCRT64 ve güncel `bin\uxb.exe`
bulunmadığından DLL'ler burada gerçekten derlenemedi. Betik gerçek Windows
ortamında:

- package varlığı,
- pkg-config modülü,
- GCC dönüş kodu,
- PE32+ x64 mimarisi,
- export tablosu,
- bağımlılık kopyalama,
- AST/MIR smoke testi

sonuçlarını rapora yazacak şekilde hazırlanmıştır.
