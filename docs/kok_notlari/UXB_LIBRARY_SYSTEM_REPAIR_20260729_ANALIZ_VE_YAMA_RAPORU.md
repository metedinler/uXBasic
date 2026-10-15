# uXBasic Kaynak Kodu ve Kütüphane Sistemi Hata Analizi ve Yama Raporu

**İncelenen paket:** `uxb(29.07_1)(2).zip`  
**İnceleme tarihi:** 29 Temmuz 2026  
**Yama adı:** `UXB_LIBRARY_SYSTEM_REPAIR_20260729`

## 1. Sonuç

Kaynak paketi, çok sayıda gerçek ve çalışabilir DLL/wrapper bileşeni içeriyor; fakat kütüphane sistemi tek bir tutarlı üretim zinciri hâline gelmemişti. En önemli sorun, **kaynakta bulunan kütüphaneler ile manifest, build, test, audit ve dağıtım yüzeylerinin birbirinden kopmuş olmasıydı**.

Başlangıçta kaynak kapısı **376 kontrolden 31 hata**, yerleşim denetimi **117 kontrolden 2 hata** verdi. Envanter üreticisi `docs` klasörünü kendisi oluşturmadığı için doğrudan çöktü. Yama sonrasında kaynak kapısı **458/458 PASS**, yerleşim **185/185 PASS**, wrapper/ABI denetimi **1120 çağrı ve 0 hata**, export denetimi **45/45 PASS**, yeni PE import kapanış denetimi **45/45 PASS** verdi.

Bu rapor, yalnız kaynakta ve ekli envanterde kanıtlanan sorunları kapsar. Windows x64 DLL’leri bu Linux inceleme ortamında yeniden derlenip çalıştırılamadığı için dinamik sonuçlar ayrıca Windows üzerinde doğrulanmalıdır.

## 2. Kritik hatalar

### 2.1 Paket kendi kendini yeniden doğrulayamıyordu

Kaynak kapısı aşağıdaki temel dosyaların eksik olduğunu gösterdi:

- YAMA6 EVENT/PIPE/THREAD/PARALEL, SLOT OFF ve SHELL capture testleri
- ABI10 test programı ve test DLL kaynağı
- kök `build_64.bat/.ps1`
- kök `BUILD_UXB_LIBRARY_SYSTEM.bat/.ps1`
- YAMA6 runtime/interpreter test girişleri
- `uxllamax` include smoke testi

Böylece pakette eski PASS raporları veya DLL’ler bulunabilse bile aynı kanıt temiz bir makinede yeniden üretilemiyordu.

**Yama:** Eksik test kaynakları ve kök girişleri eklendi. Testler mevcut parser örneklerindeki gerçek `SLOT`, `TRIGGER`, `INPUT`, `PIPE`, `THREAD`, `PARALEL` ve `SHELL ... OUTVAR/ERRVAR/CODEVAR` yüzeylerine göre yazıldı.

### 2.2 `include/include/modules` altında C başlıkları `.uxmh` diye çoğaltılmıştı

On altı dosya `#ifndef`, `#define` ve C prototype’ları içerdiği hâlde uXBasic modül başlığı uzantısı taşıyordu. Bu dosyalar dil seviyesi INCLUDE ağacını bozuyor, source gate’i düşürüyor ve C header ile uXBasic wrapper ayrımını ortadan kaldırıyordu.

**Yama:** Hatalı `include/include` ağacı kaldırıldı. Manifestte `public_header` ile `native_header` alanları ayrıldı. SDK staging yalnız gerçek `.uxmh` modüllerini dil yüzeyine, C başlıklarını `sdk/native` alanına koyuyor.

### 2.3 Manifest kaynak gerçeğinin yalnız bir bölümünü yönetiyordu

Orijinal manifestte **29** kütüphane vardı. Buna rağmen kaynakta ve bin ağacında aşağıdaki gerçek modüller bulunuyordu, fakat ana build/deploy zincirinin dışındaydı:

`uxsqlite`, `uxhttp`, `uxjson`, `uxregex`, `uxcompress`, `uxarchive`, `uxcrypto`, `uxsystem`, `uxfs`, `uxpath`, `uxprocess`, `uxlog`, `uxconfig`, `uxdatetime`, `uxuuid`, `uxwasmrt`.

`uxllamax` ise ayrı DLL değil, `uxllama.dll` üstünde wrapper-only modüldü; manifest bunu ifade edemiyordu.

**Yama:** Manifest **45 build edilebilir kütüphane + 1 wrapper-only modül** olacak şekilde genişletildi. Kütüphane setleri ve tier seçimi manifestten dinamik üretiliyor; sabit tier listesi kaldırıldı.

### 2.4 Belge ile dağıtılan DLL paketi uyuşmuyordu

Ekli envanter 94 DLL bildirirken ZIP içindeki `bin` klasöründe 86 DLL vardı. Belgede bulunup pakette olmayan sekiz dosya:

- `glfw3.dll`
- `libraylib.dll`
- `lua54.dll`
- `SDL3.dll`
- `uxlogic.dll`
- `uxraylib.dll`
- `uxsdl3.dll`
- `uxterminal.dll`

Bunların dördü birinci taraf adaptör, dördü çalışma bağımlılığıdır. Release paketleme betiği de bu yüzeyi beklemektedir; dolayısıyla bu yalnız belge sayacı farkı değildir.

**Yama:** Eksik adaptörleri üretecek manifest/build bağlantıları ve raylib/SDL3/Lua bağımlılık fetch betikleri eklendi. DLL’ler yamanın içinde sahte olarak üretilmedi; Windows üzerinde `-Set all` ve bağımlılık kurulumu ile gerçek biçimde derlenmelidir.

### 2.5 `uxlogic` kişisel bilgisayar yoluna bağlıydı

`runtime_ext/uxlogic/build_uxlogic.bat`, Lua DLL’sini sabit `C:\Users\mete\...` yolundan kopyalıyordu. Başka kullanıcıda veya temiz makinede build zorunlu olarak başarısız oluyordu.

**Yama:** Çözüm sırası `UXB_LUA54_DLL` → `UXB_MSYS2_ROOT\ucrt64\bin\lua54.dll` → yerel Lua kurulumu şeklinde taşınabilir hâle getirildi. Ayrı MSYS2 fetch betiği eklendi ve eksik bağımlılıkta açıklayıcı fail-close davranışı getirildi.

### 2.6 Raylib/SDL3 build aynı işi iki kez yapıyor ve kaynak ağacını kirletiyordu

`uxraylib` ile `uxsdl3` aynı `build_wrappers.bat` dosyasına bağlıydı. `--set all` iki manifest satırını ayrı çalıştırdığı için ikili build iki kez tekrarlanıyordu. Ayrıca `wrapper_smoke.exe` doğrudan `runtime_ext/uxraylib` altına yazılıyordu ve bir kopyası ZIP’e girmişti. SDL3 kopyasından sonra hata kontrolü de yoktu.

**Yama:** `coalesced_build_group` desteği eklendi; ortak betik bir kez çalışıyor, iki çıktı ayrı ayrı doğrulanıyor. Smoke EXE `build/libraries/tests/uxraylib` altına taşındı. Her bağımlılık ve kopyalama adımı fail-close yapıldı. Kaynak altındaki eski EXE silindi.

## 3. Yüksek önem dereceli API/runtime sorunları

### 3.1 `uxtensor` hata kodlarını yutuyordu

Native `uxtensor_fill_f64`, `zero`, `set_flat`, `set2d/3d/4d` yordamları `I32` durum kodu döndürürken wrapper bunları `SUB` içinde atıyordu. Kullanıcı indeks/şekil/handle hatasını göremiyordu.

**Yama:** Geriye uyumluluk için eski `SUB` yordamları korundu; ek olarak `TryFill`, `TryZero`, `TrySetFlat`, `TrySet2D/3D/4D` durum döndüren API’leri eklendi. Test örneğindeki yanlış `New1D` adı gerçek `Create1D` API’sine düzeltildi.

### 3.2 `uxlogic` Lua handle ABI metadata’sı PTR/U64 arasında tutarsızdı

Wrapper handle’ı `U64` olarak taşıdığı hâlde bazı imza metadata’ları PTR olarak işaretlenmişti. AST/MIR/x64 yollarında tür metadata’sı aynı sözleşmeyi temsil etmiyordu.

**Yama:** Lua handle argümanları wrapper sözleşmesiyle uyumlu U64 metadata’sına getirildi.

### 3.3 Native runtime hata durumu eşzamanlı kullanımda güvenli değildi

`uxb_last_error` iç string tamponuna doğrudan pointer döndürüyor ve sonraki kilitli işlemde pointer geçerliliği bozulabiliyordu. Başarılı çağrılar eski hata metnini her zaman temizlemiyordu. `uxb_rt_backend` geçersiz buffer için açık hata üretmiyordu.

**Yama:** Thread-local hata snapshot’ı, `clear_error()` ve başarılı çağrılarda hata temizleme eklendi. Backend buffer kontrolü ve smoke testi genişletildi.

### 3.4 Windows SHELL yolu kaynak sızıntısı ve eksik hata kontrolleri taşıyordu

Pipe oluşturmanın ikinci aşaması başarısız olduğunda ilk handle’lar kapanmıyordu. `SetHandleInformation`, `WaitForSingleObject` ve `GetExitCodeProcess` sonuçları yeterince denetlenmiyordu.

**Yama:** Bütün ara handle’lar için deterministik cleanup, `WAIT_FAILED` kontrolü, exit-code kontrolü, boş komut doğrulaması ve stale-error temizliği eklendi.

## 4. Build/audit sistemindeki mantık hataları

### 4.1 `all` seti gerçekte bütün tier’ları seçmiyordu

Tier listesi Python kodunda sabitti. Manifestte yeni tier eklenince `--set all` sessizce onu atlayabiliyordu.

**Yama:** Tier kümesi manifestten hesaplanıyor; kaynak kapısı seçilen bütün manifest satırlarının erişilebilirliğini denetliyor.

### 4.2 Eski DLL zaman damgasıyla yeni çıktıyı ezebiliyordu

Staging çeşitli klasörlerden “en yeni tarihli” DLL’yi seçiyordu. Kopyalanmış eski bir binary daha yeni timestamp taşıyorsa gerçek yeni build yerine dağıtıma girebiliyordu.

**Yama:** Kaynak önceliği deterministik yapıldı: kanonik `dist/libraries/bin` → legacy dist → dependency → modül çıktısı. Seçilen build öncesi yalnız build output’ları temizleniyor; `bin` son bilinen çalışma kopyası olarak korunuyor.

### 4.3 Export denetimi `uxffi.dll`yi iki kez sayıyordu

Manifest satırı ve özel kontrat satırı ayrı audit kaydı üretiyordu. Bu nedenle orijinal rapor 29 manifest kütüphanesine rağmen 46 satırlık karma bir görünüm oluşturabiliyordu.

**Yama:** Beklenen exportlar tek DLL satırında birleştirildi. Audit yalnız manifest tarafından sahiplenilen kanonik wrapperları kullanıyor.

### 4.4 Import kapanış denetimi yoktu

Bir DLL x64 ve exportları doğru olsa bile ihtiyaç duyduğu başka DLL paket içinde bulunmayabilirdi. Eski sistem bunu PASS sayabiliyordu.

**Yama:** Harici Python paketi gerektirmeyen PE import parser’ı eklendi. Seçilen DLL’nin mimarisi ve transitif runtime dependency kapanışı denetleniyor.

### 4.5 Envanter aracı ilk çalıştırmada çöküyordu

`docs/UXB_DLL_WRAPPER_API_ENVANTERI_...md` yazılmadan önce `docs` klasörü oluşturulmuyordu.

**Yama:** Çıktı klasörleri otomatik oluşturuluyor. Kanonik/yardımcı wrapper ayrımı manifestten okunuyor; `_easy` kopyaları API sayısını iki kez şişirmiyor. Son statik üretim: **86 DLL, 1048 kanonik API, 0 duplicate API**.

## 5. Yama dosyaları

Yama 39 yeni dosya ekler, 16 dosyayı değiştirir ve 17 yolu kaldırır.

Başlıca değişen alanlar:

- `manifests/uxb_library_system.json`
- `tools/library_tools/*`
- `tools/library_codegen/inventory_dll_and_wrappers.py`
- `native/uxb_runtime/*`
- `runtime_ext/uxlogic/*`
- `runtime_ext/uxraylib/*`
- C-base ve FreeBASIC-A modülleri için build girişleri
- ABI10/YAMA6/kütüphane smoke testleri
- kök build ve test girişleri

## 6. Uygulama

### Önerilen güvenli yöntem

Yama ZIP’ini ayrı klasöre açın ve uXBasic kökünde çalıştırın:

```powershell
python .\APPLY_UXB_LIBRARY_SYSTEM_REPAIR.py --root C:\...\uxb
```

Betik mevcut dosyaları `_patch_backups` altında yedekler, SHA-256 doğrulaması yapar, yeni dosyaları kopyalar, kaldırılması gereken yolları temizler ve statik kapıları çalıştırır.

### Doğrudan-kök paket

Doğrudan-kök ZIP’i uXBasic klasörüne `-Force` ile açtıktan sonra:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\APPLY_UXB_LIBRARY_SYSTEM_REPAIR_CLEANUP.ps1 `
  -Root .
```

## 7. Windows üzerinde zorunlu doğrulama sırası

```powershell
Set-Location C:\...\uxb
$env:UXB_MSYS2_ROOT = "C:\msys64"
$env:UXB_GCC = "C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gcc.exe"
$env:PATH = "C:\msys64\ucrt64\bin;$PWD\bin;$env:PATH"
```

Önce statik kapılar:

```powershell
python .\tools\library_tools\uxb_library_source_gate.py --root . --report-dir .\reports\control\repair_source_gate
python .\tools\library_tools\uxb_library_layout_doctor.py --root . --strict
python .\tools\library_tools\uxb_library_abi.py --root . --report-dir .\reports\control\repair_abi
```

Bütün bağımlılıkları, DLL’leri ve x64 compiler’ı üretip smoke çalıştırın:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\BUILD_UXB_LIBRARY_SYSTEM.ps1 `
  -Set all `
  -StrictAll `
  -RequireMirX64
```

YAMA6 runtime ve interpreter testleri:

```powershell
.\run_yama6_runtime_abi_tests.bat
.\run_yama6_interpreter_tests.bat
```

ABI10 manuel kapı:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass `
  -File .\compiler\scripts\run_library_abi10_smoke.ps1 `
  -Root . `
  -SkipBuild `
  -RequireMirX64
```

Beklenen temel sonuçlar:

- source gate: `PASS`
- layout doctor: `PASS`
- wrapper ABI: `errors=0 mismatches=0`
- DLL export audit: `PASS`
- DLL import audit: `PASS`
- `bin/uxb.exe`: PE32+ x64
- AST, MIR, AST-x64 ve istenirse MIR-x64 ABI10 çıktıları aynı
- JS/WAT/WASM native DLL çağrısı fail-close

## 8. Bilinçli olarak yama dışında bırakılan eksikler

### 8.1 THREAD/PARALEL API adları asenkron beklenti yaratıyor

Native std backend thread’i hemen `join`, libuv backend loop’u tamamlanana kadar çalıştırıyor, TBB task group ise `wait` ediyor. Bu nedenle API uygulamada senkron tamamlanıyor. Bunu sessizce değiştirmek ABI ve yaşam döngüsü tasarımı gerektirir; bu bakım yamasında davranış değiştirilmedi.

### 8.2 POSIX SHELL fallback üretim kalitesinde değil

Windows hedefi düzeltilmiştir. POSIX fallback sabit geçici dosya adları kullanıyor ve timeout’u gerçek anlamda uygulamıyor. Linux/macOS resmi hedef olacaksa ayrı süreç yöneticisi gerekir.

### 8.3 SWI-Prolog bağımlılığı taşınabilir tek DLL değildir

`uxlogic` Prolog çağrısını harici runtime süreci olarak kullanıyor. SWI-Prolog home/boot dosyalarıyla birlikte kurulmalıdır; yalnız `libswipl.dll` kopyalamak doğru dağıtım değildir.

### 8.4 Dinamik Windows sonucu bu ortamda kanıtlanmadı

Bu pakette kaynak ve statik denetimler gerçek olarak çalıştırıldı. Ancak Windows DLL build, FreeBASIC compiler build, AST/MIR runtime ve x64 smoke testleri Linux konteynerinde yürütülmedi. Son üretim kararı, yukarıdaki Windows testleri PASS olduktan sonra verilmelidir.
