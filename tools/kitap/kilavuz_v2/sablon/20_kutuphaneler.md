# 20. Standart kütüphaneler (libsx)

uXBasic dilinin kendisi bilerek küçük tutulur. "JSON dosyası okumak", "veri tabanına bağlanmak", "ağdan veri çekmek", "sinir ağı eğitmek", "ZIP açmak" gibi büyük işlerin her biri bir **kütüphanededir**. Bu bölüm o kütüphanelerin dizinini, hepsinde geçerli kullanım kalıplarını, kategori kategori orta ve üst düzey örnekleri ve bilinen sınırları anlatır.

> **Dürüst özet.**
> * Kütüphanelerin çoğu **AST, MIR ve x64** motorlarında aynı sonucu verir. **JS ve WASM** hiçbir DLL çağrısını derlemez; bunlar açıkça reddedilir (Bölüm 21).
> * Kütüphane çağrıları **yerel koda göre pahalıdır** ve yorumlayıcılarda çok pahalıdır (20.7); çok sayıda çağrı yapan programları x64 olarak derleyin.
> * Kütüphanelerin hata bildirme biçimi **tek tip değildir** (20.3). Dönüş değerini hiçbir zaman varsaymayın, her çağrıdan sonra denetleyin.
> * Aşağıdaki **her örnek gerçekten çalıştırılmıştır**; sayısal sonuçlar mümkün olan her yerde kütüphaneden bağımsız bir hesapla (Python, numpy) karşılaştırılmıştır. Bulunan sessiz hatalar ve eşlik sorunları 20.7'de listelenmiştir.

## 20.1 Bir kütüphane üç parçadır

| Parça | Dosya | Ne yapar? |
|---|---|---|
| Yerel kod | `bin\<ad>.dll` | İşi gerçekten yapan, C/C++ ile yazılmış kütüphane (JSON ayrıştırma, SQL, ağ …) |
| Sarmalayıcı | `libsx\<ad>\<ad>.bas` | DLL'in işlevlerini uXBasic `FUNCTION`/`SUB` olarak gösterir; içinde `CALL(DLL, …)` vardır (Bölüm 16) |
| Başlık | `include\modules\<ad>.uxmh` | Tek satırlık `INCLUDE`; programınız yalnız bunu ekler |

Programınızda yazdığınız satır şudur: `INCLUDE "include/modules/uxjson.uxmh"`. Derleyici bu yolu bulunduğu klasörden başlayarak üst klasörlere tırmanıp proje kökünden çözer.
Üç adım her kütüphanede aynıdır: **(1)** başlığı ekleyin, **(2)** işlevi `ad_alani.Islev(...)` biçiminde çağırın (bazı eski kütüphanelerde ad alanı yoktur, işlevler `UXSTATS_VecCreate` gibi önekle başlar), **(3)** dönüş değerini denetleyin. Aşağıdaki küçük örnek bu üç adımı üç kütüphaneyle gösterir.

{{ORNEK:65_kv_kutuphane_kisa/ilk_adim|baslik=Üç adım: ekle, çağır, denetle|anlat=evet}}

### Kütüphane sistemi: kaynak düzeni ve üretim

`docs/LIBRARY_SYSTEM_STANDARD_TR.md` (2026-07-02) derleyici kaynağını, yerel kütüphane kaynaklarını, sarmalayıcıları, testleri, geçici ürünleri ve çalışma DLL'lerini birbirinden ayırır; kaynak klasörlerine DLL, OBJ ya da EXE yazılmaz:

| İçerik | Klasör |
|---|---|
| Derleyici kaynağı | `src\` |
| Yerel C/C++ kütüphane kaynağı ve C başlığı | `runtime_ext\<modül>\` |
| uXBasic sarmalayıcıları | `libsx\<modül>\*.bas` |
| Kullanıcıya açık başlıklar | `include\modules\*.uxmh` (hepsini birden ekleyen: `include\libs.uxmh`) |
| Kütüphane testleri | `tests\libraries\` |
| Geçici test ve derleme ürünleri | `build\libraries\` |
| Birinci taraf dağıtım DLL'leri | `dist\libraries\bin\` |
| Üçüncü taraf bağımlılık DLL'leri | `dist\libraries\deps\` |
| İçe aktarma kitaplıkları, SDK kopyası | `dist\libraries\lib\`, `dist\libraries\sdk\` |
| Çalışma zamanı DLL kopyaları | `bin\` (hepsi `uxb.exe` ile aynı klasörde) |
| Raporlar | `reports\libraries\` |

Tek komutla üretim (**bu kılavuzun hazırlığında çalıştırılmadı**, yalnız betiklerin varlığı denetlendi): `.\BUILD_UXB_LIBRARY_SYSTEM.ps1` klasörleri hazırlar, kaynak bütünlük kapısını (`tools\library_tools\uxb_library_source_gate.py`) ve sarmalayıcı–C imza denetimini (`uxb_library_abi.py`) çalıştırır, DLL'leri derler, dışa aktarımları ve PE x64 mimarisini doğrular, DLL'leri `dist\libraries\bin` ve `bin`'e dağıtır, AST, MIR, x64 ve web "kapalı başarısızlık" duman testlerini koşar ve oturum raporunu `reports\libraries\sessions\<zaman>` altına yazar. `-Set all -StrictAll` bütün kütüphaneleri dener; `.\compiler\scripts\build_libraries.ps1 -AuditOnly` yalnız statik kaynak/ABI denetimidir; `-Library uxstats -StrictRuntime` tek modül içindir. İmza uyuşmazlığı varsa DLL derlemesi **başlamaz**; eski bir DLL yeni build sonucu sayılmaz.

**Bir modül “hazır” sayılır** ancak şunların hepsi varsa: C/C++ uygulaması ve `.h` prototipi; ona birebir uyan `.bas` sarmalayıcı; `include\modules\*.uxmh`; başarılı x64 DLL build; dışa aktarım ve mimari denetimi; `bin` kopyası; mümkünse AST, MIR ve x64 duman testi. **Dosya adının ya da klasörün bulunması çalışan kütüphane kanıtı değildir.**

**Yeni kütüphane eklemek** (`docs/UXB_LIBRARY_IMPORT_POLICY.md`): ek kütüphane zip'leri derleyici çekirdeğini ezmeden alınır; çakışan dosya sessizce ezilmez. İçerik aynıysa (`same_hash`) atlanır, farklıysa eski hedef `_retired\library_import\<zaman>\` altına **emekliye** ayrılır (nedeni Türkçe bir `.txt` ile yazılır) ve yenisi kopyalanır; aynı modülün farklı zip'lerden gelmesi raporlanır; dış bağımlılığı olan çalışma zamanı modülü sahte başarı üretmez. Her modül için otomatik bir `.uxmh` üretilir. Politika belgelerinin atıf yaptığı bazı araçlar kaynak ağacında yoktur (✖ G-ARAC-5; Ek I).

## 20.2 Kütüphane dizini

Aşağıdaki sayılar **elle yazılmaz**: işlev sayıları `include/modules` ve `libsx` dosyalarından, sembol denetimi bin klasöründeki DLL'lerden, örnek durumu da bu kılavuzun doğrulama sonuçlarından üretilir. "Sembol denetimi", sarmalayıcının çağırdığı her işlev adının DLL'de gerçekten dışa aktarıldığını gösterir (`28/28 sembol` = 28 işlevin 28'i bulundu).
"Dayandığı yazılım" sütunu yalnız DLL'in içeriğinden ya da sürüm dizgisinden **doğrulananlar** için doludur.

{{KUTUPHANELER}}

## 20.3 Her kütüphanede geçerli kalıplar

### Tutamaçlar ve yaşam döngüsü

Kütüphane içindeki nesneler (bir JSON belgesi, bir veri tabanı, bir tensör, bir HTTP isteği) uXBasic'e **tutamaç** olarak gelir: çoğunlukla `U64`, bazı kütüphanelerde (`uxwasmrt`, `uxjsruntime`) `I32`, `uxclz`'de tür numarası için `U32`. Tutamaç nesnenin kendisi değil, kütüphanenin içindeki nesneyi gösteren bir kimliktir.

| Kural | Neden? |
|---|---|
| Her `Create`/`Open`/`Parse` sonucunu `<> 0` ile denetleyin | `0`, "oluşturulamadı" demektir (`uxtensor`, `uxjson`, `uxsqlite` …) |
| İşiniz bitince `Free`/`Close` çağırın | Bırakılmayan tutamaçlar işlem bitene kadar bellekte kalır |
| `Free`/`Close` çağırdıktan sonra değişkene `0` atayın | **Kapatılmış tutamacı yeniden kullanmak** AST ve MIR'de açık hata verir, x64'te yığını bozar ve program `0xC0000374` koduyla çöker (G-KUT-10) |
| Başka bir nesnenin sahipliğindeki nesneyi ayrıca bırakmayın | `uxnn`'de ağa eklediğiniz katmanın sahibi ağdır; `LayerFree` de çağırırsanız çifte serbest bırakma olur (G-KUT-9) |
| `0` tutamacı güvenlidir | Her motorda sorunsuz reddedilir: `Perform(0)` → 2, `Close(0)` etkisiz |

Hata ayıklarken şu kalıp işe yarar: **oluştur → denetle → kullan → bırak → sıfırla**. `uxclz` bayat tutamacı kendisi yakalar ("release on invalid/stale handle"); diğer kütüphanelerde bu koruma yoktur.

### Hata nasıl bildirilir?

Kütüphaneler hatayı farklı biçimlerde bildirir. Aşağıdaki tablo, bu kılavuzdaki sınamalardan çıkarılmıştır.

| Kütüphane | Başarısızlıkta ne döner? | Nedeni nerede okunur? |
|---|---|---|
| `uxjson`, `uxfs`, `uxprocess`, `uxcompress` (dosya işlevleri), `uxlog` | `0` ya da boş sonuç | `ErrorText()` / `LastError()` (örn. `cannot open file`, `unexpected character … at byte 1`) |
| `uxregex`, `uxsqlite` (`Open`) | `0` | `ErrorText(tutamaç)`; tutamaç `0` olduğundan **asıl neden kaybolur** (G-KUT-22) |
| `uxsqlite` (`Exec`, `Step`) | SQLite sonuç kodu: `0` tamam, `1` genel hata, `19` kısıt ihlali; `Step` için `100` satır var, `101` bitti | `ErrorText(veri tabanı)` (örn. `near "SELEKT": syntax error`) |
| `uxdataframe` | `0` | `LastError(…)`: DuckDB'nin tam iletisi |
| `uxcrypto` | `0` | `ErrorText()` çoğu zaman boş: yanlış parola ile bozuk özet ayırt edilemez (G-KUT-22) |
| `uxarchive` | `-1` | `ErrorText()` (Türkçe harfli adlarda yanıltıcı, G-KUT-18) |
| `uxhttp` | `Perform` libcurl kodu (`0` tamam, `3` geçersiz adres, `28` zaman aşımı); ayarlama işlevleri başarıda `1` | `ErrorText(tutamaç)`; HTTP 404/500 başarıdır, `Status` ile okunur (G-KUT-11) |
| `uxgsl` | `0` ya da `nan` | `LastStatus()`, `LastError()`, `StatusText()` |
| `uxclz` | `0` | `LastError()` (net iletiler) |
| `uxjsruntime` | `0` | `JsLastError(bağlam)`; kodlu iletiler (`UXJS_EVAL_FAILED` …) |
| `uxpython` | `0` | `PythonError(oturum)`; Python istisna sınıfıyla birlikte |
| `uxwasmrt` | `0` | `WasmLastOk(oturum)`, `WasmLastError(oturum)` (oturum `0` verilirse son genel hata) |
| `uxonnx`, `uxllama` | `0` | `LastError(…)` |
| `uxtensor`, `uxmathcore` | tutamaç `0` / `nan` | **İleti yok** (G-KUT-6, G-KUT-16) |
| `uxstats2`, `uxmath` | `nan` / `0` | **İleti yok** (G-KUT-15, G-KUT-19) |
| `uxdatetime` | `-1` | **`ErrorText` boş kalır** (G-KUT-7, G-KUT-8) |
| `uxuuid` | `0` ya da boş metin | **İleti yok** (G-KUT-20) |

Genel ilke: sonucu önce bir değişkene alın, `0`, `-1`, `nan` ve boş metin olasılığını denetleyin, sonra kullanın.

### İşaretçiler ve tamponlar

Bazı işlevler veri kümesini ham bellek işaretçisiyle (`...Ptr` ile biten adlar) alır. İşaretçiyi kütüphaneden alın (`uxtensor.DataPtr(t)`, `UXMC_BufferDataPtr(b)`); kendiniz hesaplamaya çalışmayın.
**İşaretçiye sayı eklemek** (`taban + satir * 32`) yalnız x64'te çalışır; AST ve MIR bu işaretçileri opak jeton olarak tuttukları için ofsetli değeri reddeder (G-DIS-9). Taşınabilir yol, kütüphanenin dilim işlevidir (`uxtensor.SliceAxis0`).

### DLL'ler nerede aranır?

AST ve MIR derleyicinin kendi klasöründen çalıştığı için DLL'leri bulur. **x64 `.exe`'yi** başka yere taşırsanız şunlardan birini yapın: `.exe`'yi DLL'lerin yanına koyun ya da derleyicinin `bin` klasörünü `PATH`'e ekleyin (G-KUT-4). Çalışma zamanı DLL'leri (`uxb_runtime.dll` ve beş bağımlısı) her EXE için zorunludur ve `bld` bunları EXE'nin klasörüne kendisi koyar; kütüphane DLL'leri ise ayrıca taşınmalıdır (G-HEDEF-22). Üçüncü taraf DLL'ler (`duckdb.dll`, `libcurl`, `libgsl`, `onnxruntime.dll` …) aynı kurala bağlıdır. Dosya yolları (`INCLUDE` dışında) **çalışma klasörüne göre** çözülür.

### Motorlara göre

| Konu | AST | MIR | x64 | JS | WASM |
|---|---|---|---|---|---|
| `CALL(DLL, …)` ve kütüphane çağrıları | ✔ (çok yavaş: çağrı başına ≈ 90 ms, G-HIZ-2) | ✔ (≈ 2,5 ms) | ✔ (≈ 0) | ✖ açık ret (ifade biçimi yürütme anında "host binding missing: DLL"; deyim biçimi derlemede reddedilir) | ✖ açık ret |
| `CODEPTR` geri çağrıları | ✖ açık ret | ✖ açık ret | ✔ | ✖ | ✖ |
| İşaretçiye ofset eklemek | ✖ (jeton hatası) | ✖ (jeton hatası) | ✔ | — | — |
| Kapatılmış tutamaç | açık hata | açık hata | **çökme** | — | — |
| AST'de FFI uyarı satırı (`WARN: FFI CALL(DLL) …`) | her çağrıda | — | — | — | — |

AST'deki uyarı satırı bilgi amaçlıdır (izin listesi kipi `REPORT_ONLY`, Bölüm 16); ama sonucu `PRINT` içinde kütüphane çağrısıyla birlikte yazarsanız uyarı **aynı satırın ortasına** karışır. Bu yüzden bu bölümdeki örneklerde kütüphane sonucu önce bir değişkene alınır, sonra yazdırılır.

### Tasarlanan: hedefe göre sağlayıcı (◇ HEDEF, G-HEDEF-21)

**Bugünkü gerçek:** {{CALLDLL_YOGUN}}; bunun içindeki `uxclazz_support` "saf uXBasic" destek kodudur (özet işlevi, JSON kaçışı; Bölüm 16.9). Onu da sınadık: `EscapeJson` dört motorda aynı sonucu verir, ama 64 bitlik özet işlevi `HashString("abc")` yerel motorlarda `16242233503745875709`, JS'te `-3.894559365132612e+30` verir (G-JS-4). Yani bugün **JS ya da WASM'da tümüyle taşınabilen bir kütüphane modülü yoktur**; bu bölümdeki bütün kütüphane örnekleri yerel motorlar içindir.

**Tasarım:** kütüphane, DLL listesi olmaktan çıkıp aynı tipleri ve işlemleri üç dünyaya (x64, JS, WASM) taşıyan bir katman olacaktır. Kullanıcı yalnız `IMPORT uxmath` yazar; hedefe özel `uxmath_js` gibi adlar yazılmaz, hedefi derleyici seçer. Her modülün hedefe göre ayrı **sağlayıcısı** olur:

| Hedef | Sağlayıcı | Örnek (`ABS`, `SIN`, `RATIONAL.ADD`) |
|---|---|---|
| Taşınabilir | Saf uXBasic gerçeklemesi (MIR üzerinden her hedefe iner) | `ABS`: uXBasic |
| x64 | Yerel (DLL ya da doğrudan assembly) | `SIN`: GSL ya da çalışma zamanı; `RATIONAL.ADD`: eniyilenmiş yerel kod |
| JS | JavaScript çalışma zamanı | `ABS`: `Math.abs`; `SIN`: `Math.sin`; `RATIONAL.ADD`: `BigInt` gerçeklemesi |
| WASM | WAT / doğrusal bellek çalışma zamanı | `ABS`: doğrudan; `RATIONAL.ADD`: doğrusal bellek gerçeklemesi |

Kütüphaneler bu modelde **üç sınıfa** ayrılır: **saf uXBasic** (mantık, bazı matematik işlemleri: her hedefe MIR üzerinden), **taşınabilir çalışma zamanı** (`RATIONAL`, `COMPLEX`, koleksiyonlar: hedef sağlayıcısıyla) ve **gerçek native bağımlı** (GSL, raylib, ONNX Runtime: x64 ya da konak köprüsü). GSL'yi WASM'da DLL gibi taklit etmek anlamsızdır; ama `COMPLEX` toplamanın yalnız bir DLL yüzünden WASM'da çalışmaması da öyledir.
Tasarım ayrıca 47 modülün `PORTABLE` / `X64` / `JS` / `WASM` / `HOST` olarak sınıflandırılmasını ve modül üstverisinde `PROVIDER` bildirimini ister. `uxjsruntime` (QuickJS) ve `uxwasmrt` (wasmtime) ise JS ya da WASM hedefinde kullanılabilecek kütüphaneler **değildir**: yerel bir programın içinden JavaScript ya da WASM çalıştıran **köprü kütüphaneleridir** ve bu ayrımın modül üstverisinde açıkça yazılması istenir.
Bugün modüllerde hedef sağlayıcı üstverisi **yoktur**; bu özellik uygulanana dek JS ve WASM kütüphane çağrılarını açıkça reddeder (G-HEDEF-21).

## 20.4 Kategori kategori kullanım örnekleri

### Veri biçimleri ve metin

`uxjson`, `uxregex`, `uxconfig`, `uxlog` ve `uxuuid` gündelik programların temelidir: gelen veriyi okur, ayıklar, ayarları saklar, olup biteni günlüğe yazar.

{{ORNEK:64_kv_kutuphane/json_envanter|baslik=JSON belgesi okumak ve toplam hesaplamak|anlat=evet}}

{{ORNEK:64_kv_kutuphane/regex_log_ayikla|baslik=Düzenli ifadeyle günlük ayıklamak|anlat=evet}}

{{ORNEK:64_kv_kutuphane/ayar_gunluk_surec|baslik=Ayar dosyası, günlük ve dış süreç bir arada|anlat=evet}}

{{ORNEK:65_kv_kutuphane_kisa/uuid_bicimi|baslik=uxuuid yalnız süslü parantezli kimliği tanır|anlat=evet}}

### Dosya, sistem ve süreç

Dosya bütünlüğü, sıkıştırma, kriptografi, zaman ve arşiv işleri bu gruptadır.

{{ORNEK:64_kv_kutuphane/dosya_butunluk_sikistirma|baslik=Dosya bütünlüğü: SHA-256, sıkıştırma, kimlik ve sistem bilgisi|anlat=evet}}

{{ORNEK:64_kv_kutuphane/zaman_sla_takibi|baslik=Zaman hesabı: destek bileti SLA takibi|anlat=evet}}

{{ARAC:dis/zip_cikar_dogrula|baslik=ZIP arşivini açmak, içeriği doğrulamak, zip-slip saldırısını sınamak|anlat=evet}}

### Ağ

`uxhttp` libcurl kullanır. Bu kılavuzun örnekleri dış ağa bağlanmaz: Python ile yerel bir HTTP hizmeti açılır ve uXBasic programı ona istek yapar; bu hem tekrarlanabilir hem de güvenlidir.

{{ARAC:dis/yerel_http_istemci|baslik=HTTP istemcisi: GET, POST+JSON, yönlendirme, zaman aşımı, yeniden deneme|anlat=evet}}

### Veri tabanı ve çözümleme

{{ORNEK:64_kv_kutuphane/sqlite_ogrenci|baslik=Gömülü SQL veri tabanı (SQLite)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/duckdb_satis_raporu|baslik=Sütunlu veri çerçevesi ve SQL raporu (DuckDB)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/koleksiyonlar_karma|baslik=Yığın, sözlük, küme ve kuyruk bir arada|anlat=evet}}

{{ORNEK:64_kv_kutuphane/graf_yollar|baslik=Çizge çözümlemesi: en kısa yol ve bileşenler|anlat=evet}}

### Sayısal hesap

Bu grup en geniş gruptur ve kütüphaneler birbirinin yerine geçmez; hangisinin ne için olduğu 20.5'tedir.

{{ORNEK:64_kv_kutuphane/matris_denklem|baslik=Doğrusal denklem takımı çözmek (uxmatrix)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/istatistik_regresyon|baslik=Betimsel istatistik ve doğrusal regresyon (uxstats)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/ab_testi_karari|baslik=A/B testi karar raporu (uxstats2)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/tensor_not_analizi|baslik=Not matrisi çözümlemesi (uxtensor)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/maliyet_ve_buyume|baslik=Polinom maliyet fonksiyonu ve lojistik büyüme (uxmath)|anlat=evet}}

{{ORNEK:65_kv_kutuphane_kisa/tampon_goruntu|baslik=Tipli tamponlar: piksel dizisi çözümlemesi (uxmathcore)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/gsl_hesap_defteri|baslik=Mühendislik hesap defteri (uxgsl)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/gsl_geri_cagri_integral|baslik=uXBasic işlevini C kütüphanesine geri çağrı olarak vermek (CODEPTR)|anlat=evet}}

### Yapay zekâ

Dört kütüphane (`uxnn`, `uxnn2`, `uxnn3`, `uxaimath`) sinir ağı çekirdeğini farklı yükseklikte sunar. `uxonnx` ve `uxllama` ise hazır modelleri çalıştırır ve model dosyası ister.

{{ORNEK:64_kv_kutuphane/sinir_agi_xor|baslik=XOR problemini öğrenen sinir ağı (uxtensor + uxnn)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/ai_siniflandirici_cikisi|baslik=Sınıflandırıcı çıktı katmanı: softmax, çapraz entropi, SGD (uxaimath)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/csv_model_egitimi|baslik=CSV dosyasından model eğitmek (uxfs + uxsystem + uxnn3)|anlat=evet}}

{{ORNEK:65_kv_kutuphane_kisa/model_dosyasi_yok|baslik=Model dosyası yokken uxonnx ve uxllama|anlat=evet}}

### Mantık ve betik köprüleri

Başka dillerin gücünü uXBasic programının içine almak için dört yol vardır: `uxlogic` (Lua, Prolog, bulanık mantık), `uxpython`, `uxjsruntime` (QuickJS) ve `uxwasmrt` (wasmtime).

{{ORNEK:64_kv_kutuphane/bulanik_klima|baslik=Bulanık mantık denetleyici (uxlogic)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/js_kural_motoru|baslik=JavaScript kural motoru (uxjsruntime)|anlat=evet}}

{{ORNEK:64_kv_kutuphane/python_is_gunu_takvimi|baslik=Python modülünü çağırmak (uxpython)|anlat=evet}}

{{ARAC:dis/wat_el_yazisi_uxwasmrt|baslik=Elle yazılmış WAT modülünü uXBasic'ten çalıştırmak (uxwasmrt)|anlat=evet}}

> **uXBasic → WASM → `uxwasmrt` dönüşü bugün çalışmaz.** uXBasic'in ürettiği her WASM modülü dört `ux` içe aktarması taşır ve `uxwasmrt` içe aktarmalı modülü açıkça reddeder (G-WASM-10). Yukarıdaki örnek bu yüzden elle yazılmış, içe aktarması olmayan bir WAT modülü kullanır.

### Nesne altyapısı

{{ORNEK:65_kv_kutuphane_kisa/tip_kayit_defteri|baslik=Çalışma anında tür kayıt defteri (uxclz)|anlat=evet}}

### Grafik, oyun ve konsol

`uxsdl3` (pencere, çizim, olay, ses) ve `uxraylib` (2B/3B oyun kütüphanesi) pencere açar; bu kılavuzun sınama düzeneği pencere açmadığı için örnekleri yoktur ve dizinde **sınanmadı** olarak görünür. `uxsdl3` için yazılı rehber `docs\UXB_SDL3_KILAVUZU_20260923_TR.md` dosyasındadır. **Kapsam dışı ve bekleyen yüzeyler (✖ G-KUT-23).** `uxraylib`'te modeller ve 3B çizim ile gölgelendiriciler (shader) henüz yazılmamıştır (S-052; görüntü işleme sarmalayıcıları vardır); `uxraylib_3d` başlığı yalnız işlemci tarafında kalan 3B işlevleri (kamera, çarpışma) sunar. `uxsdl3` tamamlanmış sayılır, ama şunlar **bilinçli olarak** sarmalanmamıştır: GPU API (`SDL_gpu`), Vulkan/Metal/OpenGL/EGL bağlamları, kamera, HID, sensör aygıtları, dokunma-kalem, kuvvet geri bildirimi (haptic), tepsi, süreç / iş parçacığı / mutex / atomic, özel G/Ç akışları, asyncio, depolama ve özellik kümeleri; mesaj kutusu, bağlantı açma ve dosya iletişim kutuları (yan etkili, otomatik sınanamaz); yüzey (surface) API'sinde yalnız BMP yükleme / kaydetme ve piksel geri okuma vardır (PNG ve JPEG çözülmez). Dokunmatik aygıt sorguları vardır ama gerçek donanım olmadan yalnız "aygıt yok" davranışı sınanır. Bunlara ihtiyacınız varsa kendi `CALL(DLL, …)` sarmalayıcınızı yazın.

`uxterminal`, çizim işlevlerini gerçek bir konsolda ister; saf hesap olan çarpışma denetimi sınanabilir:

{{ORNEK:65_kv_kutuphane_kisa/cakisma_denetimi|baslik=Terminal oyunu için dikdörtgen çarpışma tablosu (uxterminal)|anlat=evet}}

## 20.5 Hangisini seçmeli? Benzer kütüphanelerin farkı

| Grup | Fark |
|---|---|
| `uxnn` / `uxnn2` / `uxnn3` | **uxnn:** tek nöron, yoğun katman ve ağ nesneleri; eğitim, ham işaretçilerle verilen veri dizileri üzerinde tek `NetworkTrainMSESGDPtr` çağrısıyla yapılır. **uxnn2:** katmanı `AddDense` ile ekleyin, en iyileyiciyi seçin (SGD, momentum, Adam), ağı dosyaya kaydedin. **uxnn3:** veri kümesi, model ve eğitim bir arada; CSV'den modele en kısa yol. Sabit adlarını ad alanıyla yazın: `OPT_MOMENTUM` uxnn2'de 1, uxnn3'te 2'dir |
| `uxaimath` ve `uxnn*` | uxaimath ağ **kurmaz**; etkinleştirme, kayıp ve güncelleme işlevlerini tek tek verir. Kendi eğitim döngünüzü yazıyorsanız uxaimath, hazır ağ istiyorsanız uxnn* |
| `uxstats` / `uxstats2` / `uxmath` | uxstats betimsel (ortalama, ortanca, varyans, korelasyon, regresyon); uxstats2 çıkarımsal (t, z, ki-kare, F, ANOVA, post hoc); uxmath polinom, integral, diferansiyel denklem ve küçük vektör/matris işleridir |
| `uxmatrix` / `uxtensor` / `uxmathcore` / `uxgsl` (Matrix) | uxmatrix: 2 boyutlu matris cebiri (ters, determinant, Solve). uxtensor: 1–4 boyutlu tensör (MatMul, MatVec, dilim). uxmathcore: tipli ham bellek tamponu (U8 … F64). uxgsl: bilimsel kütüphanenin küçük matris/vektör katmanı |
| `uxdataframe` / `uxsqlite` / `uxcollections` | uxdataframe: büyük, sütunlu veri; çözümleme için (DuckDB). uxsqlite: dosyada ya da bellekte duran, SQL ile sorgulanan veri tabanı. uxcollections: bellekteki liste/sözlük/küme/yığın/kuyruk; dil içi `LIST`, `DICT`, `SET` yetmediğinde |
| `uxcompress` / `uxarchive` | uxcompress: tek veri parçasını sıkıştırır/açar (zstd). uxarchive: ZIP/TAR gibi **çok dosyalı arşivi** açar |
| `uxjsruntime` / `uxpython` / `uxlogic` / `uxwasmrt` | JavaScript / Python / Lua-Prolog-bulanık mantık / WebAssembly: her biri başka bir dilin kodunu uXBasic içinde çalıştırır. Python makinede kurulu olmalıdır, diğerleri DLL ile birlikte gelir |
| `uxsdl3` / `uxraylib` | İkisi de pencere ve çizim sunar. uxsdl3 daha alçak düzeyli (pencere, çizim, olay, ses; 334 işlev); uxraylib oyun odaklı ve daha yüksek düzeyli (doku, yazı tipi, ses, arayüz bileşenleri; 3B ve matematik başlıklarıyla genişler) |
| `uxonnx` / `uxllama` | uxonnx hazır bir ONNX modelini kendi sürecinde çalıştırır; uxllama dış bir llama komut satırı programını çağırarak dil modelinden yanıt ister |
| `uxclz` ve dilin `CLASS`'ı | `CLASS` derleyiciye gömülüdür ve hızlıdır; uxclz çalışma anında kaydedilen, adla sorgulanan ayrı bir nesne altyapısıdır (eklenti sistemleri için) |

## 20.6 Kendi kütüphanenizi yazmak

Yeni bir kütüphane aynı üç parçayı gerektirir: C (ya da C++) ile bir DLL, `CALL(DLL, …)` içeren bir `.bas` sarmalayıcısı ve tek satırlık bir `.uxmh` başlığı. En küçük örnek `uxscalar_module`'dür (üç işlev). C ile yazılmış bir DLL'i derleyip uXBasic'ten çağırmanın uçtan uca örneği Bölüm 16'dadır (`kendi_dll`).
Yazarken üç şeye dikkat edin: **(1)** DLL'in her işlevinin dönüş değerinde ve hata bildiriminde bu bölümün 20.3 kurallarını izleyin (sıfır tutamaç, hata metni işlevi); **(2)** sarmalayıcıdaki parametre adlarını işlev adlarından farklı seçin (`Prompt(…, prompt AS STRING)` AST'de çalışmaz, G-KUT-21); **(3)** sarmalayıcıdaki bir işlev DLL'de yoksa x64 programı **hiç başlamaz**, çünkü x64 bütün DLL sembollerini başlangıçta çözer (`uxlogic`, G-KUT-2).

## 20.7 Bilinen sınırlar

{{SINIRLAR:KUT}}

### Hız ve yükleme süresi

Kütüphane çağrıları ve başlıklar yorumlayıcılarda yavaştır; ölçülen değerler aşağıdadır. Ölçümler i7-10610U dizüstü bilgisayarda, makine başka işlerle meşgulken yapıldı; mutlak değerler değişir, **sıralama** değişmez.

{{SINIRLAR:HIZ}}

## 20.8 Yol haritalarında olup henüz olmayanlar (◇ HEDEF)

`docs/UX*_ROADMAP.md` belgeleri (2026-05-25) her kütüphane için "sonraki paket"i yazar. Aşağıdaki tablo, **bugünkü işlev listeleriyle** karşılaştırılmış hâlidir; "Bugün" sütunundaki her "yok", ilgili kütüphanenin sarmalayıcı işlev adlarına bakılarak yazılmıştır (G-HEDEF-29):

| Kütüphane | Yol haritasında planlanan | Bugün |
|---|---|---|
| `uxnn`, `uxnn2`, `uxnn3`, `uxaimath` | RMSProp; evrişim ve yinelemeli katmanlar; gradyan birikimi; eğitim geri çağrıları; karışıklık matrisi ve sınıflandırma raporu; çapraz entropiyle sınıflandırıcı eğitimi; ONNX dışa/içe aktarma | Adam yalnız `uxnn2`'dedir (`OPT_SGD`, `OPT_MOMENTUM`, `OPT_ADAM`); `uxnn3` yalnız SGD ve momentum bilir (`OPT_SGD = 1`, `OPT_MOMENTUM = 2`); eğitim kaybı MSE'dir, çapraz entropi `uxaimath`'te yalnız işlev olarak vardır (`CategoricalCrossEntropy`, `BinaryCrossEntropy`). Geri kalanı yok |
| `uxdataframe` | Arrow C Data köprüsü; `uxtensor` ile sıfır kopya köprü; doğrudan `uxdataset` dönüştürme; veri temizleme; kategorik / one-hot kodlayıcı | `ToF64Matrix` matrisi **kopyalayarak** verir; geri kalanı yok (`FillMissingMean` ayrı kütüphane `uxdataset`'tedir) |
| `uxonnx`, `uxonnx2` | Dinamik şekil yardımcısı; dizi ve harita çıktıları; belirteç çözücü (HuggingFace JSON, sentencepiece); görüntü ön işleme (yeniden boyutlandırma, normalleştirme, CHW/NHWC); G/Ç bağlama ve sabitlenmiş bellek; model üstverisi ve işleç listesi dışa aktarımı; DirectML / CUDA paket ayrımı ve otomatik sağlayıcı kaydı | `uxonnx2`'de çok girdi/çıktılı koşu (`RunCreate`, `RunAddInput`, `RunAddOutput`), I64 ve metin tensörü (`TensorSetI64`, `TensorSetString`) ve `ProviderAvailable` vardır; öbürleri yok |
| `uxllamax` | Doğrudan llama.cpp API köprüsü; akış ve belirteç geri çağrıları; gömme; durum kaydet/yükle; KV önbellek; toplu istem; dilbilgisi kısıtlı çözümleme; LoRA; sohbet şablonu; GPU sağlayıcıları; yerel sunucu; örnekleme önayarları; model üstverisi | Bugün `uxllama` ile **aynı işlevleri** taşır (komut satırı köprüsü: `SetCliPath`, `SetModelPath`, `Prompt`, `PromptFile` …; 18 işlev); yol haritasının hiçbir kalemi yok |
| `uxmatrix`, `uxtensor` | SuiteSparse / UMFPACK seyrek matris; MPFR / MPLAPACK yüksek duyarlıklı matris (F80, F128, BIGF, BIGD, BALL); isteğe bağlı `uxggml` | Yok |
| `uxai` (UXAI 4 istem yol haritası) | `uxai.dll`: nöron / katman / ağ tutamaçları, sök-tak katman kurucusu, ileri geçiş; sonra geri yayılım, kayıplar, en iyileyiciler, model kaydı; XOR, regresyon ve sınıflandırma örnekleri | `uxai` adında kütüphane yoktur; karşılığı `uxnn` (`NeuronCreate`, `DenseLayerCreate`, `NetworkAddLayer` …), `uxnn2` ve `uxnn3`'tür |

Yol haritalarında anılan `uxnum`, `uxpoly`, `uxml` ve `uxllm` adlı kütüphaneler de yoktur (polinom işleri `uxmath` içindedir). Bu kalemler **söz verilmiş özellik değil, planlanmış adımdır**: biri gerekiyorsa kütüphanenin 20.2'deki gerçek işlev listesine bakın.

## 20.9 Kütüphanelerle ilgili programlama kararları

* Bir kütüphaneyi kullanmadan önce dizinde (20.2) **örnek durumuna** bakın: "sınanmadı" yazan kütüphaneye üretim kodunda güvenmeyin.
* Her çağrının sonucunu bir değişkene alın ve **hata biçimini** (20.3 tablosu) bilerek denetleyin; `nan`, `0`, `-1` ve boş metin sessiz hatadır.
* Tutamacı bıraktıktan sonra değişkeni `0`'a çekin; kapatılmış tutamacı yeniden kullanmayın (x64'te çökme).
* Sahipliği olan nesneleri (ağdaki katman, koleksiyondaki öğe) **iki kez bırakmayın**.
* Çok sayıda kütüphane çağrısı yapan ya da büyük başlık ekleyen programları **x64 olarak derleyin**; AST'de yalnız küçük deneme yapın.
* İşaretçi aritmetiği ve `CODEPTR` gerektiren kütüphane özelliklerini yalnız x64 hedefinde kullanın; JS ve WASM'a taşımayı planlamayın.
* Tarih, saat dilimi, kimlik ve dosya adı gibi **biçime duyarlı** girdileri kütüphaneye vermeden önce biçimini kendiniz doğrulayın (`uxdatetime`, `uxuuid`, `uxarchive`).
* Karşılaştırmalı deneyleri (özellikle `uxnn3` eğitimi) ayrı işlemlerde çalıştırın; aynı işlemde tekrarlanabilirlik yoktur.
* Kütüphane sonuçlarını mümkün olduğunda **bağımsız bir hesapla** doğrulayın; bu kılavuzdaki örnekler bunu yapar.
* Yeni bir kütüphane yazarken sarmalayıcıda parametre adı ile işlev adını aynı seçmeyin ve DLL'de olmayan işlevi sarmalamayın.
