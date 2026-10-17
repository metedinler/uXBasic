# uXBasic OOP Kaynak Kod Denetimi

**Tarih:** 16 Ekim 2026  
**İncelenen kaynak:** `uxb(16.10).zip` (kullanıcının yüklediği paket)  
**Denetim türü:** Kaynak, mimari, gerçek çalışma zamanı alt-bileşen testleri, motor eşdeğerliği riskleri  
**Not:** Bu, bütün Windows derleyicilerinin çalıştırıldığı ve tam test matrisi tamamlandığı anlamına gelmez.

## 0. Yönetici özeti

**Genel sonuç:** uXBasic'in OOP sistemi yalnızca sözdizimi taslağı değil. Gerçek parser, semantik kontroller, sanal metot tabloları, kanonik MIR sözleşmesi, yerel x64 nesne üretimi, iki yorumlayıcı ve JS/WASM köprüleri bulunuyor. `UXClazz` ve `uxclz` ise birbirinden ayrı iki ek nesne altyapısı. Buna karşılık kaynakta **nesne silme/ömür davranışı, `THIS/ME` sanal dağıtım ayrımı, parametreli taban kurucusu, sınıf metodu aşırı yüklemesi, profil semantiği, WASM bellek gösterimi** gibi kritik açıklıklar var. Bunlar kapatılmadan «altı motor tam OOP eşdeğerliği» ilan edilmemeli.

**Kesinleştirilmiş bulguların ilk beşi:**

1. **Kritik — MIR yorumlayıcısında `MIR_DELETE_OBJECT` gerçek silme gerçekleştirmiyor.** Olay kaydı oluşturup dönüyor: `src/interpreter/mir/mir_interp_array_object.fbs:177-181`. Bu işlev kanonik MIR nesne işlem dağıtıcısına bağlı: `src/interpreter/mir/mir_interp_dispatch.fbs:403-406`.
2. **Yüksek — JS çalışma zamanında silinmiş nesneye erişim sürüyor.** `objectDelete()` `__uxbDeleted=true` ayarlıyor; `fieldLoad()` ve `fieldStore()` bu durumu denetlemiyor: `src/codegen/js/runtime/ux_basic_runtime.js:146-184`. Ayrı Node.js denemesinde silme sonrasında okuma `3`, yazma sonrası okuma `4` döndü.
3. **Yüksek — `THIS/ME` çağrı politikası MIR düzeyinde tasarımla uyumsuz görünüyor.** `src/semantic/mir_lower_expr.fbs:531-573` çözümlemesi, sınıfın sanal yuvası varsa `THIS` ile `ME` arasında açık ayrım yapmadan sanal hedef seçiyor. Hedef tasarımda `THIS` doğrudan, `ME` sanal dağıtımlı: `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md:26-84`. Bu yol gerçek yürütme testiyle ayrıca doğrulanmalı.
4. **Yüksek — WASM, genel nesneler için evrensel yerel doğrusal bellek OOP modeli kullanmıyor.** `OBJECT_NEW`, `FIELD_LOAD`, `FIELD_STORE`, `DELETE_OBJECT` işlemleri dış ortam çağrılarına yönlendiriliyor: `src/codegen/wasm/wasm_emitter.fbs:478-503,708-713`. Metin sabitleri için `:953-972` ve F32/F64 için `:946-951` açık ret var. Bu iyi bir sessiz-hata önlemi, ama tam motor eşdeğerliği değil.
5. **Yüksek — `UXClazz` profillerinin davranış garantileri aynı değil.** `tools/uxclazz/uxclazz.py:8-12,302-381` profilden bağımsız `CLASS` üretip profili `__UxClazzMetadata()` içine yazıyor. `CLAZZ ACTOR` için yapılan gerçek kaynak-üretim denemesi `CLASS Sayac` üretti; mesaj kuyruğu, izolasyon, gerçek paralellik eklenmedi. `VALUE` da dilin doğal değer semantiğine kendiliğinden dönüşmez.

### A. Doğrulama sınırları

- ZIP: 16.140 üye; yaklaşık 345 MB sıkıştırılmış, 1,05 GiB açılmış boyut.
- Çekirdek `src/`, `runtime/`, `libsx/`, `include/`, `docs` tasarım ve uygulama belgeleri, `tools/uxclazz/` ve `runtime_ext/uxclz/` incelendi. İlgisiz üçüncü taraf ikili kütüphaneler kaynak OOP kanıtı sayılmadı.
- Pakette `tests/oop_parity/` ve belgelerde geçen `examples/uxclazz/` klasörleri **bulunmuyor**. Belgelerdeki «PASS 126/126» gibi kayıtlar tarihsel test beyanlarıdır; bu ZIP üzerinde yeniden çalıştırılmış kanıt değillerdir.
- Mevcut yürütme ortamı Linux; Windows FreeBASIC, NASM ve x64 Windows bağlama hattı burada kurulup çalıştırılmadı. AST/MIR/yerel x64 altı motor matrisi tamamlanmadı.
- **Gerçek alt-test:** `g++ -std=c++17 -O2 -Wall -Wextra -Werror -I runtime_ext/uxclz/include runtime_ext/uxclz/src/uxclz.cpp runtime_ext/uxclz/tests/uxclz_smoke.cpp -o ... && ...` → `UXCLZ_SMOKE_PASS value=42`.
- **Gerçek alt-test:** `UXClazz` denemesi → `PASS UXClazz parse: 1 class(es)`.
- **Gerçek alt-test:** Node.js `UxBasicRuntime.objectDelete` sonrası `fieldLoad/fieldStore` → erişim devam ediyor.

## 1. Mevcut OOP mimarisi ve bağlantıları

| Katman | Kaynak | Gerçekte gördüğümüz |
|---|---|---|
| Ayrıştırıcı | `src/parser/parser/parser_stmt_decl_core.fbs:1300-1428` | `CLASS`, `ABSTRACT/FINAL/SEALED`, `EXTENDS`, `IMPLEMENTS`, `FRIEND`, `MIXIN`, `DECORATOR`, `METHOD`, `OPERATOR`, kurucu, yıkıcı, `PROPERTY`, alanlar |
| Metot çözümleme | `src/parser/parser/parser_stmt_decl_class_method.fbs` | `VIRTUAL`, `OVERRIDE`, `STATIC`, `MAGIC`; taban metot imzası denetimi |
| Semantik | `src/semantic/semantic_pass.fbs:1692-2235`, `semantic_pass_tail.fbs:1457-1506` | Kalıtım, erişim, arayüz imza kontrolü, alan gizleme, kurucu `ME` denetimi, özellik/işleç denetimi |
| Örtük alıcı | `src/semantic/semantic_implicit_this.fbs:1-174` | Adı çıplak yazılmış alan ve metotları `THIS` üzerinden normalleştirme |
| MIR | `src/semantic/mir_lower_expr.fbs:531-709`, `src/semantic/mir_tail.fbs:958-1202` | Metot çağrısı, sanal yuva, sınıf-boyut, temel sınıf, kurucu/yıkıcı üstverisi |
| Kanonik IR doğrulama | `src/semantic/semantic_to_canonical_mir_bridge.fbs:212-314` | Nesne/alan/çağrı işlemlerinin operand sözleşmesi ve bozuk hedef reddi |
| AST çalışma zamanı | `src/runtime/exec/exec_class_layout_helpers.fbs` | Taban-ilkeli parametresiz kurucu zinciri, türev-ilkeli yıkıcı zinciri |
| MIR yorumlayıcı | `src/interpreter/mir/mir_interp.fbs`, `mir_interp_array_object.fbs` | Yığıt üzerinden nesne tutamaçları, alan erişimi, kurucu çağrısı; silme açığı |
| Yerel x64 | `src/codegen/x64/mir_x64_codegen.fbs:770-860,1362-1391,1536-1586` | Nesne ayırma, vtable, kurucu/yıkıcı ve `free` kod yolu |
| Eski AST-x64 | `src/codegen/x64/code_generator.fbs` | Ayrı eski nesne çağrı ve yıkıcı yolu; sürekli parite maliyeti |
| JS | `src/codegen/js/js_stmt_emit.fbs`, `runtime/ux_basic_runtime.js` | Nesneler JS nesnesi, sanal çağrı dizisi, asenkron kurucu/yıkıcı |
| WASM | `src/codegen/wasm/wasm_emitter.fbs` | Dış ortam nesne tutamacı + WAT işlemleri; tam nesne doğrusal bellek modeli değil |
| UXClazz | `tools/uxclazz/uxclazz.py` | CLAZZ'dan normal CLASS üreten kaynak dönüştürücü; DERIVE yardımcıları |
| uxclz | `runtime_ext/uxclz/src/uxclz.cpp`, `include/uxclz.h` | Ayrı C/C++ kayıt sistemi: türler, nesil denetimli tutamaç, başvuru sayımı, çağrı ve arayüz sorgusu |

**Sistem ayrımı:** uXBasic CLASS/vtable ana nesne modeli; UXClazz kaynak üreticisi; `uxclz` bağımsız C++ nesne kayıt sistemi. Birinin sağladığı özellik diğerine kendiliğinden geçmez. `docs/UXCLAZZ_UXBDLL_MIMARI_VE_KULLANIM_KILAVUZU_TR.md:9-40` bu ayrımı açıkça doğruluyor.

## 2. Kanıtlı veya güçlü statik bulgular

### K-01 / Kritik — MIR `DELETE_OBJECT` yalnızca kayıt
- **Kaynak:** `src/interpreter/mir/mir_interp_array_object.fbs:177-181`.
- **Neden:** Geçerli nesne kimliği çıkarılıyor, `UXBRuntimeOutputEventAdd` çağrılıyor; `ctx.heap.slots(id).active=0`, kurucu-yıkıcı veya referans geçersizleştirme yapılmıyor.
- **Etkisi:** MIR yorumlayıcısında `DELETE` sonrasında nesne hâlâ etkin kabul edilebilir; AST/x64/JS ile anlamsal fark.
- **Kalıcı çözüm:** `OBJECT` için açık yaşam döngüsü geçişi, kimlik+nesil tutamacı, dinamik türün yıkıcı zinciri, başarısızlık politikası; sonrasında `active=0` ve bütün takma referansların ortak geçersizlik görmesi. Aynı işi iki ayrı dalda yapmayın.
- **Test:** `NEW`, `DELETE`, ikinci `DELETE`, silme sonrası alan erişimi, taban sınıf referansı üzerinden silme, kurucu/yıkıcı sıralaması ve yeniden bellek kullanımı.

### K-02 / Yüksek — JS silme sonrası nesne kullanılabilir
- **Kaynak:** `src/codegen/js/runtime/ux_basic_runtime.js:145-184`.
- **Gerçek sonuç:** `before-delete 3; delete-result 0; after-delete-field-read 3; after-delete-field-write 4`.
- **Öneri:** `objectDelete` ve `fieldLoad`, `fieldStore`, `callMethod`, `virtualCall` için ortak `assertLiveObject`; yıkım sırasında `disposing`, bitince `disposed`; tekrar silmenin açık semantiği; sahipsiz ve paylaşılan referanslar için sözleşme.

### K-03 / Yüksek — `THIS/ME` doğrudan-sanal hedef farkı yok
- **Kaynak:** `src/semantic/mir_lower_expr.fbs:531-573,619-646,695-702`.
- **Gözlem:** `SUPER` için açık doğrudan çağrı istisnası var. `THIS` için aynı istisna yok; `MIRNormalizeMethodTargetFromReceiver` türün sanal yuvasını görürse her iki alıcıda da sanal hedef döndürüyor.
- **Ayrı semantik sorun:** `src/semantic/semantic_pass.fbs:1407-1444` kurucu içindeki **her** doğrudan `ME.metot()` çağrısını «ME virtual» tanısıyla reddediyor. Sanal olmayan metodu da reddedebiliyor; bu bilinçli genel yasaksa tanı ve tasarım belgeleri buna göre düzeltilmeli.
- **Test:** Üç seviyeli kalıtım, `THIS.Value()`, `ME.Value()`, `SUPER.Value()`, niteliksiz `Value()`, temel gövdeden sanal çağrı. Tasarım belgesindeki `1020` örneği.

### K-04 / Yüksek — sınıf metotlarında gerçek aşırı yükleme engeli
- **Kaynak:** `src/parser/parser/parser_stmt_decl_class_method.fbs:395-407` metot imzası okunup değerlendirilmeden önce aynı isme sahip bütün sınıf üyeleri reddediliyor.
- **Sonuç:** Aynı ada sahip farklı parametre listeli sınıf metotlarının klasik aşırı yüklenmesi mümkün görünmüyor.
- **Ek:** `src/semantic/semantic_pass_tail.fbs:56-165` genel yordam çağrılarında adayları ağırlıkla **argüman sayısına** göre eşliyor. Aynı sayıda farklı tür imzalarına tam çözümleme yerine belirsiz çağrı üretebiliyor.
- **Öneri:** İç sembol anahtarı `ad + parametre türleri + BYREF yönleri + jenerik somutlaştırma` düzeyinde olmalı; dönüş tipi tek başına overload ayırmamalı. Vtable yuvaları «isim» yerine çözümlenmiş imza kimliğini taşımalı.

### K-05 / Yüksek — WASM nesne modeli ayrı bir dış ortam rejimi
- **Kaynak:** `src/codegen/wasm/wasm_emitter.fbs:478-503,533-591,708-713,946-972`.
- **Gözlem:** Temel nesneler ve alanlar dış ortam fonksiyonlarıyla yönetiliyor. Metin literal ve kayan nokta kısıtları mevcut.
- **Doğru taraf:** Eksik özellikler sessizce yanlış üretilmek yerine açıkça reddediliyor.
- **Öneri:** WASM32 doğrusal bellek üzerinde sınıf başlığı + tür kimliği + alan düzeni + vtable ve temizleme işlevleri, ya da dış ortam tutamacının açık olarak birinci sınıf ve sınırlı hedef olduğu alternatif sözleşme. İkisini «aynı yetenek» diye gizlemeyin.

### K-06 / Yüksek — `MemoryRef` ham adreslerden kaynağı eksiksiz izleyemiyor
- **Kaynak:** `src/common/memory_ref.fbs:4-40,54-129`.
- **Gözlem:** Bölge kaydı yalnız ARRAY türü için tanımlı; üst sınır 4096. Nesil numarası kayıt içinde, fakat ham adresin yanında taşınmıyor. Serbest bırakılmış alana yeni ayırma gelince mezar kaydı kaldırılıyor: eski ham adres artık yeni nesneyi gösterebilir.
- **Risk:** Yönetilen nesne güvenliği için tam «eski referansı reddetme» garantisi verilemez. Toplama ve sınır toplamada `base + length`, `addr + size` aritmetiği taşma denetimiyle güçlendirilmeli.
- **Öneri:** İki açık tip: ham `PTR<T>` ve `REF<T>`/tutamaç, ikinci türde kimlik+nesil+yetki; önce adres/alan sınıfını doğru çözümle, sonra sınır ve ömür denetle. Native dış adres davranışı yalnız açık `UNSAFE` sözleşmesiyle.

### K-07 / Yüksek — parametreli taban kurucuları tam sözleşmeye bağlı değil
- **Kaynak:** `src/runtime/exec/exec_class_layout_helpers.fbs:278-342`, `docs/tasarim/UXB_S485_OOP_BASE_CONSTRUCTOR_CHAIN_20261013_TR.md`.
- **Gözlem:** Parametresiz taban kurucusu zinciri var; parametre isteyen taban kurucusu otomatik çalıştırılmıyor. `SUPER(...)` henüz tamamlanmış görünmüyor.
- **Öneri:** Türetilmiş kurucuda gerekli taban kurucusunu çağırmayı zorunlu kıl; erişim ve argüman türlerini denetle; kısmi kurulumda kurulmuş alt nesneleri ters sırada temizle. Parametreli taban eksikse «sessiz atlama» yerine derleme hatası.

### K-08 / Orta-yüksek — profillerin bir kısmı yalnızca üstveri
- **Kaynak:** `tools/uxclazz/uxclazz.py:27-35,156-190,240-360`.
- **Gerçek test:** `CLAZZ ACTOR Sayac ... END CLAZZ` başarıyla `CLASS Sayac` + `STATIC METHOD __UxClazzMetadata()` üretti. Üretilmiş kodda görev yalıtımı veya mesajlaşma yok.
- **Ek:** `VALUE`, `DATA`, `ENTITY`, `COMPONENT`, `NATIVE` sınıfları aynı genel `CLASS` arayüzüne iniyor; gerçek ABI, değer kopyalama, otomatik bellek ömrü ve aktör izolasyonu için ayrı sözleşmeler gerekli.
- **Öneri:** Üstveri ile gerçek semantik yeteneği açıkça ayır; her profilin ayrı kabul testleri olmalı; gereken profil doğrudan dilde yoksa araç desteklenmiyor desin ya da adını `@Hint`/şablon olarak göster.

### K-09 / Orta-yüksek — MIXIN/DECORATOR gelişmiş vaatleri henüz çekirdek garantisi değil
- **Kaynak:** `src/semantic/semantic_pass.fbs:1795-1865` MIXIN en çok 1, tek taban modeli. `tools/uxclazz/uxclazz.py:288-311` dekoratör üstveri metni üretir.
- **Öneri:** `USES` ile parça bileşimi, trait ile davranış bileşimi, `MIXIN` ile klasik temel zincirini karıştırma. Çakışma politikası ve yürütülebilir davranış olmadan «dekoratör uygulanıyor» denmemeli.

### K-10 / Orta-yüksek — JS yapıcı/yıkıcı sözleşmesi ve hata temizliği
- **Kaynak:** `src/codegen/js/runtime/ux_basic_runtime.js:108-187`.
- **Gözlem:** Üst sınıf kurucularının tümüne aynı kullanıcı argüman listesinin parçaları veriliyor. Taban kurucusunun kendine özgü argümanları `SUPER(...)` ile çözümlenemiyor. Kurucuda hata verilirse daha önce oluşturulan kaynakları temizleyen genel geri sarma görünmüyor.
- **Öneri:** Her kurucu çağrısı için ayrı argüman paketi; kısmi kurulum durumu ve geri sarma; alt sınıf yıkıcılarından sonra taban yıkıcıları; `THROW` ve `CANCEL` için açık politika.

### K-11 / Orta — arayüz ve aşırı yükleme imzası zenginleştirilmeli
- **Kaynak:** `src/semantic/semantic_pass.fbs:1630-1663,2161-2235`.
- **Gözlem:** İmza, görünen parametre türleri ve dönüş türünü birleştiriyor; kontrol edilen alanda BYREF/BYVAL, varsayılan değer, erişim görünürlüğü, jenerik kısıtları ayrı imza kimliği olarak görünmüyor. Gerçek başka kapılar olabilir, bu nedenle tümden eksik iddiası değil.
- **Öneri:** Tek `MethodSignature` nesnesi; tüm tüketiciler aynı çıktıyı kullansın. `PROPERTY`, `MAGIC`, `INTERFACE`, `OVERRIDE`, `DLL` için ortak kimlik.

### K-12 / Orta — yorumlayıcı yığıtındaki nesne belleği ölçeklemesi
- **Kaynak:** `src/interpreter/common/interp_heap.fbs:68-85`.
- **Gözlem:** Her nesne yuvası eklemede `ReDim Preserve h.slots(h.slotCount)` kullanılıyor. Büyük nesne sayılarında büyütme maliyeti araştırılmalı. Bu, çalışmayla doğrulanmış yavaşlık değil; kod incelemesinden çıkan performans riski.
- **Öneri:** Kapasiteyi geometrik büyüten tablo, boş yuva tekrar kullanımı, nesil sayacı; benchmark ile doğrulama.

## 3. Yürütme motorlarının OOP kapsamı

| Motor | Kod desteği | Kanıtlanmamış veya açık kritik konular | Bu denetimin kararı |
|---|---|---|---|
| AST yorumlayıcı | Alan/metot/kurucu/yıkıcı ve örnek saklama yolları var | Parametreli taban kurucusu, alias ömrü, zor yaşam döngüsü durumları | Temel uygulanmış, tam eşdeğerlik doğrulanmadı |
| Kanonik MIR yorumlayıcı | Nesne ve alan işlevleri, ctor çağrısı, sanal tablo | `DELETE` gerçek etki yok, dinamik tür/yıkıcı, `THIS/ME` ayrımı | Kritik açık |
| MIR→yerel x64 | vtable, nesne ayırma, destructor thunk, `free` | Yanlış tür ile silme, çift silme, kısmi kurucu hatası, ABI stres | Güçlü altyapı; dinamik test gerek |
| Eski AST→x64 | Ayrı nesne işlemleri | Yeni semantik iki ayrı kod üreticisinde yaşayabilir | Teknik borç riski |
| JS | `objectNew`, metot/sanal çağrı, `objectDelete` | Silme sonrası erişim gerçekten geçiyor, yapıcı argümanları, hata temizliği | Kritik yaşam döngüsü düzeltmesi |
| WASM/WAT | Dış ortam tabanlı nesne işlemleri, bazı WAT işlemleri | Doğrusal bellek OOP yerleşimi, F32/F64/metin, diğer ortamlarda host bağımlılığı | Tam bağımsız OOP eşdeğerliği yok |

Bu tablo ikili çalıştırma matrisi değildir. **Kodun varlığını ve statik işlevini** gösterir. `PASS` yalnız gerçek yürütme sonucuyla verilmiştir.

## 4. Eksik sayılabilecek modern OOP öğeleri: tasarım karşısında gerçek uygulama

| Öğeler | Uygulama yorumu | Önerilen sıra |
|---|---|---|
| Metot aşırı yükleme | Sınıfta ad çakışması engeli | P0 |
| Taban kurucu `SUPER(...)` | Açık tasarım/uygulama boşluğu | P0 |
| Güvenli nesne silme ve ömür | Motorlar farklı davranıyor | P0 |
| Tek tür/metot/yerleşim kimliği | Kaynaklar arası parçalı sözleşme | P0 |
| `THIS/ME/SUPER` politikası | Hedef ayrımın MIR karşılığı eksik | P0 |
| Jenerik CLASS/INTERFACE | Sınıf bildiriminde `CLASS Foo<T>` yolu görünmüyor (`parser_stmt_decl_core.fbs:1300-1322`); rutinlerde `GENERIC_PARAM` izleri var | P1 |
| Null/Option/Result | Birinci sınıf türler ve desen eşleme ayrıca tasarlanmalı | P1 |
| Güvenli tür daraltma | `IS`, checked cast, interface karşısında tutarlı ret | P1 |
| Kapsam temizliği | `USING` ad alanı sözdizimiyle çatışmayacak kaynak kapsamı | P1 |
| Trait/USES bileşimi | MIXIN tek taban, UXClazz USES delegasyonu üretiyor | P2 |
| Sahiplik türleri | `MemoryRef` + REF/OWNED/BORROWED/SHARED kuralları | P1 |
| Actor CLASS | Profilden gerçek görev izolasyonuna geçiş gerekir | P2 |
| Veri odaklı AoS/SoA | Nesne düzeni değişimi `VARPTR`/ABI nedeniyle kısıtlı | P3 |
| Etki/yetki analizi | WASM/JS/native ayrışmasını erkenden tespit etmek için değerli | P2 |
| Durum güvenli nesneler | Jenerik + yaşam döngüsü üstüne inşa edilmeli | P3 |

## 5. Önerilen hedef mimari: OOP çekirdeğini tekleştirme

**Öncelik, yeni sözdizimi değil, yaşam döngüsünü tekleştirmek.**

1. **Ortak tür tablosu:** `TypeId`, `BaseTypeId`, `InterfaceId`, alan yerleşimi, `MethodId`, `MethodSignature`, vtable slotları, `ConstructorPlan`, `DestructorPlan`, tür sürümü ve ABI. `UXClazz`/`uxclz` için bağdaştırıcı uygulanır; ana `CLASS` adresinin doğrudan `uxclz` nesnesi olduğu varsayılmaz.
2. **Nesne tutamacı ve durum modeli:** `allocated → constructing → live → disposing → disposed`; `REF<T>` nesil denetimli, `PTR<T>` açık ham adres. `SHARED/WEAK` ancak sahiplik semantiği kanıtlandıktan sonra. `NEW` hata verirse yalnız başarıyla kurulmuş alanları ters sırada temizle.
3. **Tek dağıtım kararı:** `MethodResolution = {lexicalOwner, staticReceiverType, dispatchKind, methodId, slotId, accessPolicy}`; `THIS`, `ME`, `SUPER` ayrımı tür çözümlemesinde yapılır ve MIR'ye taşınır.
4. **Kanonik MIR:** Yeni MIR işlevi ancak gerçek çalışma zamanı eylemini temsil ediyorsa oluşturulur. Metot jenerikleri, sözleşmeler ve erişim çoğunlukla statik çözümlemeyle tamamlanır.
5. **Hedef adaptörleri:** AST/MIR/x64/JS/WASM aynı görünür kurucu/yıkıcı/erişim sonucunu uygular; fiziksel adres ve çalışma ortamı aynı olmak zorunda değil. WASM yerel doğrusal bellek modeli desteklenmiyorsa özelliğin kullanımında fail-closed tanı verilir.
6. **İsteğe bağlı deneysel kütüphaneler:** Gerçek `ACTOR` görev yalıtımı, veri odaklı yerleşim, durum güvenli API ve etki denetimi çekirdek oturduktan sonra etkinleştirilir.

## 6. Uygulama iş emri sırası ve kabul sınamaları

| İş | Sıra | İlk düzeltme | Kabul için gerekli asgari test |
|---|---|---|---|
| OOP yaşam döngüsü | P0.1 | `MIR_DELETE_OBJECT` gerçek nesne silme; JS silinmiş nesne kapısı | Altı motor: NEW/DELETE/erişim, DOUBLE DELETE, alias, null |
| Kurucu/yıkıcı zinciri | P0.2 | `SUPER(...)` ve parametreli taban zorunluluğu; kısmi kurucu başarısızlığı | Üç seviyeli kalıtım, ctor/dtor sırası, hata temizliği |
| Çağrı çözümleme | P0.3 | `THIS` doğrudan, `ME` sanal, `SUPER` taban-doğrudan; niteliksiz çağrı | Tasarımdaki `1020` testi, override ve iç içe kalıtım |
| Tek imza | P0.4 | Yöntem kimliği+tipli overload çözümü | Aynı isim/ayrı tür, BYREF, belirsizlik, interface/override |
| Bellek referansları | P0.5 | `MemoryRef` yaşam döngüsü, overflow, ham/yönetilen adres ayrımı | Yeniden kullanım/nesil, REDIM, farklı nesne/dizi/metin boyutları |
| UXClazz semantik sınırı | P1.1 | Profil yeteneklerini gerçek, şablon, sadece üstveri olarak sınıflandır | `ACTOR` gerçekten izole mi; `VALUE` gerçekten değer olarak kopyalanıyor mu |
| WASM OOP | P1.2 | Doğrusal bellek nesne ABI'si veya açık host-sınırlı API | Standalone WASM nesne+metot+delete; string/F64 kabul/ret doğru |
| Tür jenerikleri ve sonuç türleri | P2 | Somutlaştırma, constraint, OPTION/RESULT | LIST/DICT/Class/Method generics, hata teşhisi |
| Deneysel özellikler | P3 | ACTOR, DATA, EFFECTS, STATE | Performans + davranış + altı hedef garantisi ayrı |

**Tamamlanmışlık kuralı:** Bir iş `PASS` sayılabilmek için pozitif test, negatif tanı testi, yaşam döngüsü testi, motor karşılaştırması ve gerekiyorsa çıktının gerçek çalıştırılmasıyla kanıtlanmalıdır. Sadece sözdizimi ayrıştırılması, MIR opkod kaydı veya metadata mevcudiyeti tamamlanmış uygulama sayılmaz.

## 7. Her motor için zorunlu test matrisi

- `basic_fields`: CLASS, PRIVATE/PUBLIC/PROTECTED/RESTRICTED, STATIC/READONLY, alan türü.
- `identity`: referans paylaşımı, değer türü kopyalama, NULL, geçersiz tutamaç.
- `dispatch`: THIS/ME/SUPER 1020 testi, niteliksiz metot, override, interface, üç seviyeli kalıtım.
- `constructor`: parametresiz/parametreli taban, üst sınıfa argüman, başarısız kurucu temizliği.
- `destructor`: silme, tekrar silme, alias kullanımı, son kapsam, türetilmiş nesneye taban referansı.
- `method_resolution`: overloaded isim/farklı tür, hata durumları, BYREF ve generics.
- `traits`: MIXIN/USES/dekoratör çakışması, üye görünürlüğü ve üstveri-davranış ayrımı.
- `memory`: VARPTR/SADD, Native/Virtual/External, sınır, aşım, belleğin aynı adrese yeniden gelmesi.
- `interop`: DLL/UXClazz/uxclz/JS/WASM bileşen sınırları, nesne sahipliğinin devri.
- `parity`: beklenen çıktılar ve hatalar; AST, MIR, MIR-x64, AST-x64, JS, WAT/WASM.

**Test kapsamı eksiği:** Yüklenen arşivde `tests/oop_parity/` yoktur. Testlerin başka bir kopyada başarıyla koştuğunu belgeleyen tarihsel raporlar, bu sürümün aynı durumda olduğunu kanıtlamaz. Test klasörleri ve Windows ikilisi sağlandığında statik denetim yürütme matrisiyle tamamlanabilir.

## 8. Sonuç

OOP çekirdeği üzerinde önemli ve gerçek bir çalışma var: kalıtım, arayüz, metot, sanal tablo, yerel nesne ABI'si ve kaynak dönüştürme mevcuttur. En büyük risk, **aynı görünür sözdiziminin farklı motorlarda farklı nesne ömrüne ve çağrı anlamına sahip olmasıdır.** İlk mühendislik hamlesi yeni sınıf nitelikleri üretmek değil, **MIR silme yolu, JS yaşam denetimi, THIS/ME/SUPER çağrı ilkesi, kurucu zinciri, metot imza kimliği ve nesil denetimli referans sözleşmesini** ortak hâle getirmektir.

Bu yapılmadan `ACTOR`, `VALUE`, SoA veya tam jenerik sistemini tamamlanmış temel saymamak gerekir. Önce davranış güvencesi, ardından ileri özellikler.
