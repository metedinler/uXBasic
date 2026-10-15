# uXBasic son ekosistem sağlamlaştırma analizi — 29 Temmuz 2026

## İncelenen durum

Bu inceleme `uxb(29.07_1).zip` kaynağına, son VS Code Workbench/QuickJS/WASM tanı yamasının üstüne uygulanmıştır. Amaç yeni dil özelliği eklemek değil; büyüyen compiler, runtime, DLL ve IDE ekosisteminde sessizce atlanan, yanlış raporlanan veya kişisel makineye bağlı kalan noktaları kapatmaktır.

## Kanıtlanan sorunlar ve yapılan düzeltmeler

### 1. `--set all` gerçekte bütün kütüphaneleri seçmiyordu

Eski seçim sabit bir tier listesine bağlıydı. `multimedia-primary`, `multimedia-fallback`, `terminal-ui` ve `language-bridge` tier'ları bu listede olmadığı için raylib, SDL3, terminal ve mantık köprüsü `all` build içinde dahi atlanıyordu.

Yeni sözleşme:

- `minimal`: yalnız `required=true` modüller.
- `core`: zorunlu modüller ile `core` ve `bridge` tier'ları.
- `all`: manifestteki bütün kanonik modüller.
- `--library`: adı verilen modüller.

### 2. Ekosistem manifesti parçalıydı

Kanonik manifestte 30 kütüphane bulunurken wrapper ve runtime ağaçlarında daha geniş bir ekosistem vardı. C full-API ve FreeBASIC A-grubu ayrı build sistemlerinde kalmıştı.

Kanonik manifest 45 modüle genişletildi. Şunlar ana orkestratöre alındı:

- C full API: SQLite, HTTP/libcurl, JSON-C, PCRE2, Zstandard, libarchive, libsodium.
- FreeBASIC A grubu: system, fs, path, process, log, config, datetime, UUID.
- Wasmtime tabanlı `uxwasmrt`.

Ortak build scriptleri `build_group` ile yalnız bir kez çalıştırılır; grup içindeki her beklenen DLL ayrıca doğrulanır.

### 3. Wrapper ABI denetimi FreeBASIC kaynaklarını okuyamıyordu

Eski denetleyici C kaynaklarına odaklandığından FreeBASIC ile üretilen DLL'lerde 134 sahte “symbol not found” hatası oluşuyordu. Bu gürültü gerçek imza hatalarını saklıyordu.

Denetleyiciye şunlar eklendi:

- FreeBASIC `PUBLIC FUNCTION/SUB ... ALIAS` export taraması.
- C/C++ source ve header prototype taraması.
- I8/U8/I16/U16/F32/F64/LONGDOUBLE, aggregate ve string pointer tipleri.
- ABI makro temizleme.
- Biçim farkı ile gerçek semantik imza farkının ayrılması.

Bunun sonucunda beş wrapper ailesinde 45 gerçek hata bulundu: opaque 64 bit handle'lar `PTR` olarak bildirilmişti. `uxconfig`, `uxfs`, `uxlog`, `uxlogic` ve `uxprocess` çağrıları `U64` yapıldı.

Sonuç: **1115 CALL(DLL) çağrısı, 0 hata, 0 uyumsuzluk**.

### 4. `uxmh` uyumluluk başlıkları geçersiz C preprocessor kullanıyordu

`include/include/modules` altındaki 17 uyumluluk başlığı `#ifndef/#define/#endif` içeriyordu. uXBasic preprocessor sözleşmesi bu C header guard biçimini kullanmıyor.

Başlıklar sade uXBasic `INCLUDE` forwarder'larına dönüştürüldü.

### 5. DLL export envanteri bozuktu

GNU `objdump` PE export tablosundaki `+base[...]` alanı sembol adı sanılıyordu. Envanterde gerçek export adları yerine binlerce bozuk kayıt oluşuyordu.

Parser GNU PE/COFF satır biçimine göre düzeltildi. Envanter yeniden üretildi ve `+base[` kaydı kalmadı.

### 6. `uxlogic` kişisel makine yollarına bağlıydı

Build scripti doğrudan belirli bir kullanıcının Lua klasörünü, Prolog çağrısı da sabit `C:\Program Files` yolunu kullanıyordu.

Yeni çözüm:

- GCC: `UXB_GCC`, `UXB_MSYS2_ROOT`, ardından PATH.
- Lua: açık argüman, `UXB_LUA_DLL`, PATH, LocalAppData veya MSYS2.
- SWI-Prolog: `PrologQueryWith`, `UXB_SWIPL`, PATH veya standart Program Files konumu.
- Prolog süreç çağrısı `_popen/cmd.exe` yerine `CreateProcessA` ve yönlendirilmiş pipe kullanır.
- Native public header eklendi; API sürümü 110 oldu.

### 7. Kaynakta gömülü API anahtarları vardı

Birden fazla eski Gemini/OpenRouter/Groq analiz aracında anahtarlar doğrudan kaynakta tutuluyordu. Anahtarlar kaldırıldı. Araçlar artık yalnız şu ortam değişkenlerini kullanır:

- `GEMINI_API_KEY`
- `OPENROUTER_API_KEY`
- `GROQ_API_KEY`

Kişisel kaynak/çıktı yolları da proje kökü ve ortam değişkenleriyle değiştirildi. Ecosystem Doctor gömülü anahtar desenini build kapısı olarak denetler.

Eski anahtarlar daha önce dosyalarda bulunduğu için ilgili sağlayıcı panellerinden iptal edilip yenilenmelidir.

### 8. Üretilmiş 20 MB FreeBASIC C dosyası `src` altında tutuluyordu

`src/main.c` kanonik kaynak değil, FreeBASIC'in üretilmiş çıktısıdır. Yeni arşivleyici bunu klasör yapısını koruyarak şu alana taşır:

`build/generated/freebasic_c/main.c`

SHA-256 ve boyut bilgisi `archive_manifest.json` içinde saklanır.

### 9. Ana build girişleri kaynak paketinde yoktu

Kök dizine şu kararlı forwarder'lar eklendi:

- `build_64.bat/.ps1`
- `build_libraries.bat/.ps1`
- `BUILD_UXB_LIBRARY_SYSTEM.bat/.ps1`
- `RUN_UXB_ECOSYSTEM_DOCTOR.bat`

### 10. Source gate eski ve eksik test paketlerine bağlıydı

Gate artık pakette bulunmayan tarihsel yama testlerini zorunlu saymaz. Güncel ecosystem testi, doctor, root girişleri, module forwarder'ları, native header'lar, ABI ve kaynak sözleşmeleri denetlenir.

### 11. VS Code Toolchain Doctor yalnız araç yollarına bakıyordu

Workbench Toolchain Doctor artık Python ekosistem doktorunu da çalıştırır. Manifest, wrapper ABI, secret taraması, header sözleşmesi ve build set bütünlüğü VS Code raporuna eklenir.

## Doğrulama sonuçları

- Ecosystem Doctor: 150 kontrol, PASS.
- Library source gate: 453 kontrol, PASS.
- Wrapper/native ABI: 1115 çağrı, 0 hata, 0 uyumsuzluk.
- DLL export audit: 46 DLL, PASS.
- Layout Doctor: 181 kontrol, PASS.
- VS Code Workbench: 29 komut ve dil yüzeyi doğrulaması, PASS.
- Python compileall/JSON doğrulama: PASS. Truncated ADIM44 repair tool and browser path escape warning were fixed.
- DLL envanteri: 86 dağıtılmış DLL, 1131 wrapper API kaydı.

## Bilinen doğrulama sınırı

Bu Linux inceleme ortamında Windows FreeBASIC compiler build'i, MSYS2 DLL build'leri ve QuickJS/Wasmtime native runtime smoke testleri çalıştırılmadı. Yama bunlar için Windows build komutlarını ve statik kapıları sağlar. Gerçek Windows doğrulaması sırasıyla Ecosystem Doctor, compiler build, core/all library build ve runtime smoke testleriyle yapılmalıdır.
