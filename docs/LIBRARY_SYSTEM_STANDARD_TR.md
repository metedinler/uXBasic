# uXBasic Kütüphane Sistemi Standardı

## 1. Amaç

Bu sözleşme, uXBasic derleyicisinin kaynak kodunu, native kütüphane kaynaklarını, uXBasic wrapperlarını, testleri, geçici derleme ürünlerini ve çalışma DLL'lerini birbirinden ayırır. Kaynak klasörlerine DLL, OBJ veya EXE yazılmaz. Program çalışırken gerekli DLL'lerin bir kopyası daima `bin\uxb.exe` ile aynı klasörde bulunur.

Bu yama binlerce mevcut `INCLUDE` yolunu kıracak fiziksel kaynak taşıması yapmaz. Var olan kaynak konumlarını kanonik kabul eder; ürünlerin ve test sonuçlarının kaynak ağacına karışmasını engeller.

## 2. Kanonik klasörler

| İçerik | Klasör |
|---|---|
| Derleyici kaynak kodu | `src\` |
| Native C/C++ kütüphane kaynağı ve kendi C başlığı | `runtime_ext\<modül>\` |
| uXBasic wrapper kaynakları | `libsx\<modül>\*.bas` |
| Kullanıcıya açık uXBasic include başlıkları | `include\modules\*.uxmh` |
| Kütüphane test kaynakları | `tests\libraries\` |
| Geçici test/derleme ürünleri | `build\libraries\` |
| Birinci taraf dağıtım DLL'leri | `dist\libraries\bin\` |
| Üçüncü taraf bağımlılık DLL'leri | `dist\libraries\deps\` |
| Import library dosyaları | `dist\libraries\lib\` |
| SDK kopyası | `dist\libraries\sdk\` |
| Çalışma zamanı DLL kopyaları | `bin\` |
| Raporlar | `reports\libraries\` |
| Eski çıktı yolu, yalnız uyumluluk | `dist\runtime_ext\` |

`dist\runtime_ext` yeni kanonik hedef değildir. Eski modül BAT dosyaları buraya yazsa bile birleşik üretici sonucu sınıflandırıp `dist\libraries` ve `bin` içine taşır.

## 3. Önerilen tek komut

Yamayı uyguladıktan sonra `uxb` klasöründe:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.ps1
```

veya:

```bat
BUILD_UXB_LIBRARY_SYSTEM.bat
```

Varsayılan akış şunları tek oturumda yapar:

1. klasörleri hazırlar ve eski ürünleri kanonik hedeflere toplar;
2. kaynak bütünlük kapısını çalıştırır;
3. 542 wrapper `CALL(DLL)` satırını gerçek C prototipleriyle karşılaştırır;
4. gerekiyorsa MSYS2/UCRT64 bağımlılıklarını ister;
5. x64 `bin\uxb.exe` üretir;
6. çekirdek DLL'leri ve `uxffi.dll` köprüsünü derler;
7. DLL exportlarını ve PE x64 mimarisini doğrular;
8. DLL'leri `dist\libraries\bin` ve `bin` içine dağıtır;
9. AST, MIR, x64 ve web fail-close ABI10 testlerini çalıştırır;
10. oturum raporunu `reports\libraries\sessions\<zaman>` altında yazar.

Tüm kütüphaneleri denemek:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.ps1 -Set all -StrictAll
```

Bağımlılıkları daha önce kurduysan:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.ps1 -SkipDependencyInstall
```

Yalnız statik kaynak/ABI kontrolü:

```powershell
.\compiler\scripts\build_libraries.ps1 -AuditOnly
```

Tek modül:

```powershell
.\compiler\scripts\build_libraries.ps1 -Library uxstats -StrictRuntime
```

## 4. Windows araç gereksinimleri

Varsayılan yollar:

```text
C:\msys64\ucrt64\bin\gcc.exe
C:\msys64\ucrt64\bin\pkg-config.exe
```

`uxffi.dll` için libffi gerekir. Yalnız bu bağımlılığı kurmak için:

```bat
runtime_ext\uxffi\fetch_uxffi_deps_msys2.bat
```

Derleyicinin x64 yeniden üretimi için FreeBASIC x64 toolchain'i ve proje build betiğinin beklediği NASM/link araçları erişilebilir olmalıdır.

## 5. Üretim sırası ve kapılar

1. `uxb_library_source_gate.py` zorunlu dosyaları, kaynak ankrajlarını, FBS ön işlemci dengesini, public header yönlendirmelerini ve ABI köprüsü export sözleşmesini denetler.
2. `uxb_library_abi.py` C header/source prototiplerini çıkarır ve wrapper imzalarıyla karşılaştırır.
3. Hata veya imza uyuşmazlığı varsa DLL derlemesi başlamaz.
4. Manifestte seçilen mevcut BAT dosyaları çalıştırılır.
5. Ana build başarısızsa yalnız manifestte tanımlı modüllerde fallback build denenir.
6. Eski bir DLL yeni build sonucu gibi kabul edilmez; seçilen DLL'in eski build çıktısı önce temizlenir ve yeni zaman damgası aranır.
7. DLL'ler `dist\libraries\bin`, bağımlılıklar `dist\libraries\deps` altında sınıflandırılır.
8. Bütün çalışma DLL'leri düz olarak `bin\` içine kopyalanır.
9. PE mimarisi ve export tablosu Python ile doğrudan denetlenir.
10. SHA-256 içeren `dist\libraries\manifests\runtime_manifest.json` yazılır.

## 6. Çalışma zamanı arama kuralı

Windows, DLL aramasında çalıştırılabilir dosyanın klasörünü kullanabildiği için standart çalışma düzeni şöyledir:

```text
bin\uxb.exe
bin\uxffi.dll
bin\uxstats.dll
bin\uxstats2.dll
bin\uxmath.dll
bin\uxmathcore.dll
bin\libffi-*.dll
...
```

Testin veya kaynak dosyanın hangi klasörden başlatıldığı bu standardı değiştirmez. Dağıtım kopyaları ayrıca `dist\libraries` altında sınıflı biçimde tutulur.

## 7. x64 zorunluluğu

İncelenen kaynak paketindeki eski `bin\uxb.exe`, PE başlığına göre x86/32-bit durumundaydı. x64 DLL'ler bu işlem içine yüklenemez. Birleşik üretim aracı bu nedenle varsayılan olarak compilerı x64 yeniden üretir. Eski EXE `.pre_library_patch.bak` adıyla korunur.

Yalnız DLL üretip compilerı bilinçli biçimde atlamak mümkündür:

```powershell
.\BUILD_UXB_LIBRARY_SYSTEM.ps1 -SkipCompilerBuild -SkipSmoke
```

Bu kullanım, mevcut `bin\uxb.exe` gerçekten x64 değilse çalışma doğrulaması sağlamaz.

## 8. AST, MIR ve x64 davranışı

- **AST interpreter:** Karma tipli, metin/pointer dönüşlü ve 5–10 parametreli çağrıları `bin\uxffi.dll` üzerinden yürütür.
- **MIR interpreter:** `MIR_CALL_DLL`, `MIR_CALL_API` ve DLL/API hedefli genel `MIR_CALL` artık aynı ABI10 köprüsünü doğrudan kullanır. Eski native-only fail-close kaldırılmıştır.
- **STRPTR dönüşü:** C metni `uxffi_copy_string` ile interpreter belleğine kopyalanır; native adres kullanıcı programına çıplak olarak bırakılmaz.
- **PTR dönüşü:** Interpreterda güvenli etiketli handle tokenı kullanılır ve sonraki PTR argümanında gerçek pointera çözülür.
- **x64 codegen:** Windows x64 32-byte shadow space, 16-byte stack hizalaması ve 5–10. stack argümanlarıyla doğrudan native çağrı üretir.
- **0–4 eski tek tip çağrı:** `uxffi.dll` bulunmazsa bazı eski I32 uyumluluk yolları çalışabilir.
- **Karma tip, STRPTR veya 5–10 argüman:** Interpreter için `uxffi.dll` zorunludur.
- **I64/U64 interpreter sınırı:** Dilin eski `ExecValue` yapısı ayrı 64-bit tamsayı alanı taşımadığından saf geniş sayısal dönüşlerin tamamı AST tarafında henüz garanti edilmez. Pointer tokenları, F64 ve STRPTR güvenli biçimde korunur; x64/MIR değer modeli geniş tamsayıyı taşıyabilir.

## 9. JS, WAT ve WASM

Windows DLL dosyası tarayıcıda veya saf WASM ortamında doğrudan yüklenemez. Native `CALL(DLL/API)`:

- AST/MIR interpreter ve x64 native hedefte kullanılabilir;
- JS/WAT/WASM hedeflerinde açık bir host-import köprüsü yoksa **fail-close** olur;
- compiler sahte JavaScript/WASM sonucu üretmez.

ABI10 smoke testi bu hedeflerde başarısız çıkış bekler.

## 10. Public header ve wrapper kuralı

Her DLL modülü üç kaynak parçasıyla tanımlanır:

```text
runtime_ext\modul\modul.c/.h
libsx\modul\modul.bas
include\modules\modul.uxmh
```

Kullanıcı doğrudan wrapper yolunu ezberlemek yerine public headerı dahil eder:

```uxbasic
INCLUDE "include/modules/uxmatrix.uxmh"
```

Çoğu modül kendi `NAMESPACE` alanını taşır:

```uxbasic
m = uxmatrix.Create(4, 4)
```

Birden fazla modülü topluca dahil etmek için `include\libs.uxmh` kullanılabilir. Global isim kullanan `UXSTATS_*`, `UXSTATS2_*`, `UXMATH_*` ve `UXMATHCORE_*` aileleri zaten benzersiz önek taşır.

## 11. Kaynak taşıma politikası

Var olan çalışan kaynak konumları korunur. Eski kaynak klasörlerinde kalmış DLL/OBJ/EXE dosyalarını toplamak için:

```powershell
.\compiler\scripts\organize_library_layout.ps1 -RemoveSourceProducts
```

Ürünler önce kanonik dağıtım klasörlerine alınır, sonra `_retired\library_source_products\<zaman>` altına taşınır. Dosya silinmez.

## 12. Bir modülün “hazır” sayılması

Bir modülün kullanılabilir sayılması için şu kanıtların tamamı gerekir:

1. C/C++ uygulaması ve `.h` prototipi;
2. C prototipiyle birebir uyumlu uXBasic `.bas` wrapperı;
3. `include\modules\*.uxmh` public include dosyası;
4. başarılı x64 DLL build;
5. export ve mimari denetimi;
6. `bin` çalışma kopyası;
7. mümkünse AST, MIR ve x64 smoke testi.

Yalnız dosya adının veya kaynak klasörünün bulunması çalışan kütüphane kanıtı değildir.
