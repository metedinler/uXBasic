# uXBasic inceleme ve karar önerileri

Mete için hazırlayan Codex. Tarih 6 Ekim 2026. Araştırma ve karar hazırlığı belgesi.

Bu belge, geçmiş tasarımları güncel kaynak ve çalıştırma kayıtlarıyla karşılaştırır. Eksiklerin çözümü için önerileri, alternatifleri ve kabul koşullarını verir. Öneriler henüz kullanıcı kararı sayılmaz. Yeni uygulama planı, bu belgenin değerlendirilmesinden sonra kesinleştirilecektir. Mete'nin araştırma ve karar belgesi istediği son mesajından sonra araştırma, kayıt ve karar hazırlığına geçilmiştir.

Derleyicinin tamamlandığı söylenemez. Mevcut kabul paketleri iyi sonuç verdi, fakat kitapta altı örnek hâlâ başarısız ve daha geniş tasarım halkaları açık. Ayrıca AST yorumlayıcısında 257 değişkenle yeniden üretilen, merkezi hata kaydından kaçan bir sınır aşımı bulundu.

## Araştırmanın kapsamı ve kanıt sınırı

Etkin Git deposu çalışma alanındaki `uxb` klasörüdür. Compiler kaynakları `src`, C++ çalışma zamanı `native/uxb_runtime`, dil kütüphaneleri `libsx`, dış adaptörler `runtime_ext` altındadır. Arşiv, paket, RAG ve yayımlama kopyaları canlı kaynak sayılmamıştır. Başlangıçta bulunan 14 izlenen dosya değişikliği korunmuştur.

Koordinasyon günlükleri, karar defteri, Eylül devirleri, 20/23/24 Eylül tasarım birleşimleri, 28 Eylül yerel uzman çalışması ve daha yeni karar ekleri incelendi. Belge indeksi ilk taramada 1.196 dosya, 639 farklı içerik ve 21.973 bölüm çıkardı. DOCX metni çıkarıldı; PDF, eski DOC ve ZIP içeriği bu otomatik indekse dahil değildir. İndeks, bütün tarihsel cümlelerin güncel doğrulaması değildir.

Tarihsel sorun defterinin 203 bölümü ayrı envantere alındı. Bir bölümün ilk durum satırı, daha sonraki kapanış notundan eski olabilir. Ek envanter bu nedenle kayıttaki durum ile bugünkü ek kanıtı ayrı sütunlarda tutar. Eski açık başlıklar kendiliğinden yeniden doğrulanmış hata sayılmaz; eski kapanışlar da çalışan özellik garantisi sayılmaz.

Güncel kaynak haritası 1.272 kod dosyası, 738 Basic/FreeBASIC dosyası ve 26.146 sembol içerir. Arama paketi 7.523 rutin kaydı içerir; 7.069'u tanımdır. Son üretimde haritadan sonra değişen kaynak dosyası sayısı sıfırdır. Önceden modelle yazılmış amaç ve özetler taslak olarak korunmuştur; bu araştırmada başka bir model çalıştırılmamıştır.

## Çalıştırmaların sonucu

| Kanıt | Sonuç | Anlamı |
|---|---|---|
| Başlangıç tam paket koşusu | 1.147 / 1.153, 23 / 26 paket | O günkü başlangıç durumu; altı düşüşün sonraki kanıtları ayrıca tutuldu |
| Son geniş koşu | 1.171 / 1.171, 24 / 24 paket | Yeni 83 kontrollük konsolidasyon paketi dahil; raylib ve SDL ayrı doğrulandı |
| Son metin ömrü koşusu | 21 / 21 | Geniş koşudan ayrı, aynı yayımlanan ikiliyle |
| Kitap örnekleri | 92 / 98 beklentili örnek | AST, MIR ve varsayılan native x64 birlikte; önceki koşu 86 / 98 |
| Kitaptaki diğer örnekler | 32 örnekte çıktı beklentisi yok | Başarı oranının paydasına katılmadı |
| SDL çekirdek koşusu | 4 / 4 | Normal kullanıcı ortamında DLL bağımlılıklarıyla; sandbox PrefPath yazması engellenmişti |
| Tam raymath native programı | RAYMATH_PASS, çıkış 0 | Stack düzeltmesinden sonra; tüm motorlardaki ölçek sorununun kapanışı değildir |

Bu turların sayıları birbirine eklenerek yeni bir genel başarı oranı oluşturulmaz. Bir pakette beklenen ret tanısının geçmesi, özelliğin o motorda çalıştığını göstermez. Son büyük koşuya string_lifetime adı yerine yanlışlıkla string_fields seçimi yazılmıştı; atlanan gerçek paket ayrıca 21/21 çalıştırıldı. Koşucu artık bilinmeyen paket adını sessizce atlamıyor.

Konsolidasyon paketinde dosya/metin işlemleri, sayı tabanları, SELECT, DIM tekrar yürütme, ileri bildirim, PRINT sütunları, float yazımı, PROPERTY ve Win64 ABI denetleniyor. Negatif ileri bildirim testleri de dahil toplam 83 kontrol geçti. Legacy BYREF desteği ilan edilmedi; bilinen açık ret sınırı korunuyor.

Standart compiler kopyalarının SHA256 değeri `08212216723B1F18C3566F53E43878E69D69433DDCCED90B635C80B6AAC61B2B`; runtime kopyalarının değeri `4796B660A75A99E503DAD9E0342DD6309FE19A080172D0EA58FE6F49C7AA6D33`. Önceki ikililer `reports/consolidation_20261006_before_publish` altında korunmuştur. Paketlenmiş raylib DLL'i çalışan kopyayla eşitlendi; eski paket DLL'i ayrı yedektedir.

## Bellek uyarısının araştırılması

### Yeniden üretilen sınır aşımı

AST yorumlayıcısının değişken tablosu `ExecState.vars(0 to 255)` biçiminde sabittir. `ExecEnsureVar` kapasite dolunca -1 döndürüyor; `ExecSetVarValue` bu sonucu denetlemeden dizi indeksi olarak kullanıyor. 255 ve 256 değişkenli program çıkış 0 ve doğru çıktı verdi. 257 değişkenli program çıkış 6 ile durdu; stderr kaydı doğrudan `EXECSETVARVALUE()` içinde “out of bounds array access” diyor.

Aynı 257 değişkenli kaynak çalışma öncesi yedek compiler ile de çıkış 6 verdi. Bu hata son düzeltmelerin oluşturduğu bir gerileme değildir. Katman kaydı AST_INTERPRETER başlangıcında kesiliyor; merkezi hata günlüğünde bu abort'un karşılığı yok. Kullanıcının gördüğü uyarının tam metni bilinmediği için iki olay henüz aynı kabul edilmemiştir.

### Önceden düzeltilen Win64 sorunları

Büyük yerel frame için stack sayfaları atlanıyordu; iki x64 üreticisinde sayfalar RSP düşürülmeden önce yoklanıyor. 2.048 yerel değişkenli probe iki yerel motorda geçti. Native tam raymath programı da çalıştı. Foreign caller'ın korunmasını beklediği register'lar ayrıca düzeltilmiştir: geçerli callback probe'unda eski native sonuç 2, eski legacy sayısal callback sonucu 4 iken yeni sonuçlar 0'dır. Bu, somut ABI bozulmasını gösterir; bilgisayarın genel RAM'inin bozulduğu sonucunu göstermez.

### Henüz açıklanmayan kullanıcı uyarısı

Son yedi günün okunabilen 119 Windows Application olayında uXBasic/program/compiler araçlarıyla eşleşen çökme bulunmadı. Resource Exhaustion Detector sorgusunda eşleşen olay çıkmadı. Bu, olay günlüğü oluşturmayan bir uyarıyı dışlamaz. Son örnek bellek anında yaklaşık 16,8 GB fiziksel bellekten 5,55 GB boş, commit kapasitesinden yaklaşık 19,7 GB kullanılabilir görünüyordu; bu tek anlık ölçüm bütün derlemeyi temsil etmez.

Son büyük-frame programı tekrar çalıştırıldı ve `20` çıktısı, çıkış 0 verdi. Çok hızlı bittiği için süreç bellek tepe değeri örneklenemedi; ölçülemeyen değer sıfır sayılmaz. Sistemin toplam bellek değişimi başka uygulamaları da içerir.

**Öneri B01:** Önce kapasite dönüşlerinin bütün tüketicilerini denetlemek; ardından BYREF ve VARPTR adreslerini taşımayan, parçalı ve kararlı hücre depolamasına geçmek. Her hata merkezi tanı ve tamamlanmış oturum özeti üretmeli. Kabul: 255/256/257 ve çok büyük tablolar, özyineleme, gölgeleme, BYREF alias ve VARPTR sonrasında büyüme.

**Alternatifler:** Sabit sınırı koruyup kapasite dolduğunda anlaşılır tanı vermek en hızlı ara çözümdür; büyük program sınırı kalır. Düz yeniden boyutlanan dizi kolaydır fakat kaçmış adresleri geçersizleştirebilir; kararlı adres sözleşmesi çözülmeden önerilmez. Sadece sınırı artırmak kök hatayı kapatmaz.

**Öneri B02:** Kullanıcı uyarısını ayrı olay olarak izlemek. Aynı kaynak, compiler/runtime hash'i, çıkış kodunun onaltılık biçimi, stdout/stderr, bellek örnekleri ve zaman aralığındaki Windows olayları birlikte kaydedilmeli. `tools/maintenance/capture_uxb_fault.ps1` bu amaçla hazırlandı ve hem başarılı hem hatalı süreçle sınandı. Mevcut günlükler önce korunmalı; bütün uzun testleri tekrar etmek ancak uyarıyı yeniden üretmeye katkı sağlıyorsa yapılmalı.

## Hata merkezi ve iki dil

Hata merkezi atıl değildir: `main_program_entry.fbs` yapılandırıyor; `runtime/diagnostics.fbs` ve `common/diagnostic.fbs` kayıt gönderiyor. Ancak ortak sonuca ulaşan üç ayrı yol var: kategoriye göre `E.*` katalog biçimi, yapılandırılmış `UXB_*` tanı listesi ve metinden Türkçeye dönüştürme. Native çalışma zamanı ayrıca kendi stderr/hata durumunu tutuyor.

Gerçek TR/EN denemesinde aynı ileri bildirim hatası iki dilde çalıştırıldı. Türkçe başlık ve E.0300 kategorisi çevriliyor; ayrıntıdaki “declaration signature mismatch” İngilizce kalıyor. all_diagnostics.json içindeki message_tr de İngilizce. TXT ana kaynak konumu 0:0; ayrıntı ve VS Code kaydı genel 1:1 konumuna düşüyor. `--diag-format json` denemesi terminalde yine INFO/ERROR metni üretti. Bunlar kayıtla doğrulandı.

Kaynak incelemesinde katalog seçimi alt dize tahminine dayanıyor; geniş “arg/path/ast” eşleşmeleri gerçek hata sınıfını örtebilir. Katman/modül konumları metinden yeniden çıkarılıyor. Log yazma hataları yutuluyor; 60 KB rotasyon tek .bak kopyasını değiştiriyor. Katalog kapasitesi 300 girdidir. Şema denetimi üretilecek şema metninde bir adın varlığını kontrol ediyor; bütün çıkan tanı nesnelerini gerçek JSON şemasıyla doğrulamıyor. Farklı servislerde ayrıca sayısal hata kodları var.

**Öneri H01:** Tek yapılandırılmış tanı kaydı esas alınsın: sabit kod, önem, katman, aşama, gerçek kaynak aralığı, ilgili sembol, parametreler, TR/EN mesajları, çözüm ipucu ve sebep zinciri. Eski E.* ve servis kodları uyumluluk eşlemesiyle korunmalı. TXT, JSON ve VS Code aynı kaydı biçimlendirmeli; metinden sınıf tahmini geçiş adaptörü olarak sınırlanmalı.

**Alternatifler:** Yalnız eski metin çevirisini büyütmek hızlıdır fakat kod/konum kaybını çözmez. Bütün kodları ve üreticileri tek seferde değiştirmek daha sade bir son durum sağlayabilir, ancak mevcut araçlar ve testlerde yüksek geçiş maliyeti taşır. Önerilen yol, uyumluluk köprüsüyle aşamalı birleştirmedir.

**Öneri H02:** JSON'da iki dil daima saklansın; terminal ve editör açıkça seçilen dili göstersin. Eksik çeviri raporlansın, kaynak ayrıntısı kaybolmasın. Mevcut varsayılan EN açık bir karar olmadan değişmesin. TR/EN katalog dosyaları UTF-8 ve parametreli mesajları kapsasın. Dil seçimi kodu, çıkış değerini ve kaynak aralığını değiştirmesin.

**Alternatifler:** Terminalde her zaman iki dili birlikte yazmak açıklığı artırır fakat metin ve token hacmini büyütür. Dil başına ayrı tanı nesnesi üretmek, kayıt sayısını ve önem düzeyini iki kez sayma riskini taşır. Aynı kaydın iki görünümü daha uygundur.

**Öneri H03:** Bir işlem için tek oturum kimliği ve tek nihai durum oluşturulsun. Compiler/çocuk süreç abort'u, timeout ve yazılamayan rapor dış toplama katmanında da yakalansın. Bilinen kaynak konumu taşınmalı; bilinmeyen konum açıkça bilinmiyor olarak işaretlenmeli, sahte 1:1 yazılmamalı. İstenen özel log yolu korunmalı. Yerel host çağrısı bağlanmadığında stderr yazıp -1 dönerek programı başarıyla bitirme davranışı kaldırılmalı; S-185 native kaydı bunun örneğidir.

**Alternatifler:** Her katmanın ayrı dosya üretimini sürdürüp yalnız bir özet eklemek daha az değişiklik gerektirir. Tüm ayrıntıları tek dev dosyaya taşımak incelemeyi zorlaştırır. Öneri, mevcut katman dosyalarını koruyan ve onları manifestte bağlayan küçük bir oturum özetidir.

Kabul: lexer/parser/semantic/MIR/backend/runtime/FFI kaynaklı aynı hata TR/EN ve text/json/vscode biçimlerinde; dosya yazma engeli; çocuk süreç çıkış 6; bind edilmeyen native çağrı; hata limiti; tekrar eden tanının tek sayılması; kaynak include zinciri ve satır/kolon.

## Dil yüzeyindeki karar önerileri

### D01 Daraltma ve ondalıktan tamsayıya dönüşüm

S-176 açık seçim içeriyor. Mevcut atama kapısı daraltmada açık tip adı dönüşümü ister; `I8(x)` biçimi önceden kabul edilmiş, `CAST(I8,x)` ve tip son ekleri dilin parçası değildir. Öneri: aralığa sığan tamsayı literali istisnasını açıkça tanımlamak; değişken ve ondalık daraltmada açık dönüşümü sürdürmek. Literal sınır dışındaysa derleme tanısı verilsin. Açık `I8(255)` gibi dönüşümlerin kayıtlı dar genişlik davranışı korunmalı.

Ondalık dönüşüm için öneri: tip adıyla tamsayı dönüşümü sıfıra doğru kessin; FIX sıfıra kessin, INT aşağı yuvarlasın; CINT/CLNG için eski BASIC uyum davranışı ayrıca belgelenip her motorda aynı uygulanmalı. Bu son ayrım henüz Mete kararı sayılmaz. Alternatifler: bütün daraltmalarda açık dönüşüm istemek; veya bütün tamsayı dönüşümlerini aynı yuvarlama kuralına bağlamak. Seçim örnekler ve eski testlerle birlikte yapılmalı. Kabul: pozitif/negatif yarımlar, sınırlara yakın sayılar, NaN/inf ve U64 sınırı; bütün motorlar.

### D02 FUNCTION ve THREAD dönüşleri

S-166 kaynakta doğrulanıyor: RETURN yalnız ifadenin türünü çıkarıyor, bildirilen dönüş türüyle atama uyumunu denetlemiyor. Öneri: dönüşü normal atama kuralına bağlamak; daraltma/ondalık dönüşüm açık yazılsın. AST, iki MIR biçimi, yerel register yolu ve görev sonucu aynı tipi taşımalı. Alternatif: dönüşte örtük çevirmek; bu durumda atamadan farklı kural ve bütün motorlarda gerçek dönüşüm gerekir. Öneri mevcut güçlü tip denetimiyle uyumludur. Kabul: yanlış dönüşün derleme tanısı; doğru dar, float, metin, aggregate ve LIBTYPE dönüşü.

### D03 CONTINUE

S-174'te deyim uygulaması yok. Öneri: çıplak CONTINUE en iç döngüye; CONTINUE FOR/DO/WHILE en yakın ilgili döngüye gitsin. FOR'da artış, DO/WHILE'da uygun koşul denetimi atlanmamalı; iterator kapanışı ve TRY/LOCK çıkışları doğru yürüsün. Alternatif: yalnız türü belirtilmiş CONTINUE; veya dil yüzeyinden kaldırmak. Son alternatif kitap ve yüzey beklentisini değiştirir. Kabul: iç içe döngü, FOR EACH, kilit ve kaynak sahibi iterator.

### D04 STATIC yerel değişken

S-186'nın PROPERTY kısmı dört motorda düzeltilmiştir; rutin içindeki STATIC kısmı açık. Öneri: rutin kapsamlı, çağrılar arasında kalıcı, bir kez başlatılan typed depo. Model D gereği görevler normal STATIC veriye erişebilir; deyim senkronu ve yaşam döngüsü uygulanmalı. Alternatif: ilk aşamada yalnız sabit başlangıç değerine izin vermek; veya kullanıcıdan global depo kullanmasını istemek. İkinci alternatif STATIC özelliğini tamamlamaz. Kabul: tekrar çağrı, özyineleme, farklı rutinlerde aynı ad, eşzamanlı ilk başlatma ve managed değer kapanışı.

### D05 ENUM türü

S-189'da üyeler çalışıyor, `AS Renk` parser'da reddediliyor. Öneri: enum kimliğini statik tür olarak korumak, boyut ve işlemleri belirtilen tamsayı tabanıyla taşımak. Üye sonucu da enum kimliğini taşımalı; farklı enum'ların ataması açık dönüşüm gerektirmeli. Alternatif: enum'u yalnız I32/tamsayı alias'ı yapmak; daha kolaydır fakat tür güvenliğini azaltır. Kabul: varsayılan ve açık taban, negatif/büyük üye, parametre/dönüş/dizi ve farklı enum ataması.

### D06 MID ataması

S-182'nin kökü taze AST kaydında görüldü: `MID(s,2,2)="XY"` bir atama değil, sonucu atılan eşitlik ifadesi oluyor. Öneri: ayrı yazılabilir dil deyimi; hedef ve sınır ifadeleri bir kez değerlendirilsin, metin sahipliği korunsun. Başlangıç bir tabanlı ve değiştirilecek uzunluk hedef/replacement sınırlarıyla açık tanımlansın. Alternatif: kaynak dönüştürerek normal STRING atamasına indirmek; veya açık desteklenmiyor tanısı. Tanı ara çözümdür; çalışan özellik sayılmaz. Kabul: değişken/alan/dizi hedefi, boş replacement, sınırlar, yan etkili argüman ve BYREF.

### D07 IFF çağrısı

S-185'te infix IFF mantıksal eşdeğerliktir; kitap üç argümanlı koşul çağrısı bekliyor. Öneri: infix anlam korunsun; çağrı biçimi `IFF(koşul,doğru,yanlış)` olsun ve yalnız seçilen dal değerlendirilsin. Sonuç türü iki dalın ortak tür kuralıyla belirlensin. Alternatifler: iki dalı da değerlendiren normal builtin; koşul işlevine ayrı IIF adı verip kitap örneğini değiştirmek; yalnız mantık operatörünü tutmak. Kabul: seçilmeyen dalda sıfıra bölme/yan etki, metin ve sayısal sonuç, iki dilde arity tanısı.

Bu yedi başlık içinde hangileri gerçek dil seçimi gerektiriyorsa belge değerlendirmesinde birlikte kararlaştırılmalı. Önceki kısa soru seçenekleri onaylanmış sayılmamıştır.

## Önceden kabul edilen tasarımların tamamlanması

### T01 LIBTYPE ve yaşam döngüsü

S-112/S-134'te manifest/provider, COPY/BYVAL/RETURN ve alan kopyası yolları var; genel kapanış açık. Öneri, RATIONAL'i primitive yapmadan mevcut birinci sınıf kütüphane tipi sözleşmesini tamamlamak: nested managed field, kopya/drop dengesi, BYREF escape, görev transferi ve bütün motorlarda gerçek provider. Alternatif: yalnız trivially-copyable türlerle dar bir ürün sunmak; kabul edilmiş hedefin kapsamını azaltır. Kabul: allocation/clone/drop/live sayaçları, hata ve iptal sonrası kapanış, nested aggregate, native/JS/WASM gerçek işlem.

### T02 Provider ve paket sözleşmesi

S-114/S-115 için öneri, sürümlü type/provider ABI, bağımlılık ve capability kayıtlarını tek manifestte doğrulamak; LIBTYPE programını gerçek paket örneğiyle taşımak. Alternatif: hedef başına bağımsız wrapper; bakım ve anlam ayrışması artar. Manifest v2 gibi bir sürüm adı bu belgeyle kesinleşmiş değildir. Kabul: sürüm uyumsuzluğu anlaşılır tanı, eksik bağımlılık, paketlenmiş temiz klasörde çalıştırma ve üç hedefte aynı değer.

### T03 Tipli pointer ve MemoryRef

S-113/S-056/S-094 kararı raw PTR'nin bayt aritmetiğini korur, PTR TO T eleman aritmetiği ekler. Öneri mevcut kararı parser/type/layout ve iki MIR yolu boyunca taşımak; stride için layout kaynağını kullanmak. F80 payload 10, depolama stride 16 kararını korumak. MemoryRef köken, bölge, sınır ve ömür bilgisi genişletilmeli. Alternatif: yalnız raw PTR bırakmak; typed pointer hedefini kapatmaz. Genel pointer davranışını tek taraflı değiştirmek önceki kararla çelişir. Kabul: typed dereference, fark/stride, alignment, BYREF/FFI ve geçersiz ömür.

### T04 Ortak iterator

S-031/S-135 için mevcut dizi/metin/LIST/SET/DICT özel yollarından ortak ITER_CREATE/NEXT/CLOSE sözleşmesine geçiş öneriliyor. MAGIC ITER, CHAIN ve ZIP kütüphane protokolü olarak tamamlanmalı; kaynak kapanışı EXIT/CONTINUE/THROW/iptalde çalışmalı. Alternatif: her koleksiyona yeni özel döngü yolu eklemek; tekrar ve lifecycle ayrışması büyür. ZIP en kısa kaynakta mı biter, uzunluk uyuşmazlığında mı tanı verir sorusu ürün tercihi olarak açık tutulmalı. Kabul: erken çıkış, boş kaynak, birden çok kaynak, managed eleman ve özel iterator.

### T05 Meta ve generator registry

S-136'da daha yeni karar ekleri eski A/B ayrımını kaldırıyor; mevcut %% testleri korunarak MetaScanExpandedSource, MetaBindAST ve MetaBindMIR zinciri gerekiyor. Öneri sürümlü registry, normal kaynak üretimi, kaynak izi ve tekrarlanabilir çıktı. Alternatif: dış scriptlerle üretimi sürdürmek; build bağımlılığı ve kaynak izi eksik kalır. Ön işlemciyi AST'yi geriye dönük değiştiren bir mekanizmaya çevirmek yerine bağlama aşamalarını açık tutmak önceki kararla uyumludur. Kabul: aynı girdi aynı çıktı, include izi, hata konumu ve eski meta corpus'u.

### T06 Görev modeli

Model D yürürlüktedir. Genel global/STATIC erişim, deyim senkronu, LOCK/ATOMIC/MUTEX ve görevler arası tutamaç yolu korunmalı. Öneri kalan CLASS/managed tür/MemoryRef transferini copy/clone/move/retain/share sözleşmesiyle tamamlamak; çağrılan yardımcı rutinin iptal noktaları ve ömür garantisini denetlemek. Alternatif, eski R1-R6 kısıtlarına dönmektir; Mete'nin yeni kararını geri alır ve önerilmez. JS Worker/WASM hedeflerinde gerçek görev uygulaması ayrıca gerekir. AST/MIR senkron referansı ve native asenkron zamanlama farkı tek başına hata sayılmaz. Legacy görev yolu için kayıtlı kalıcı ret politikasını değiştirmek ayrıca karar ister.

### T07 JOINALL sonucu

S-147'nin LIST sonuç hedefi kararlaştırılmış, heterojen değer sözleşmesi ön koşuludur. Öneri typed/task sonuçlarının LIST'e sahiplik bilgisiyle aktarılması; başarısız görev ve iptal sonucu açık temsil edilmeli. Alternatif: yalnız başarı durumunu döndürmek veya sadece homojen sonuçları kabul etmek. Bunlar mevcut ürün hedefini daraltır. Kabul: farklı sonuç türleri, hatalı/iptal görev, sıralama garantisi ve sonuçların serbest bırakılması.

### T08 Web sayı ve çağrı yolları

S-085/S-150/S-122/S-123'te gerçek F32/F64, 64-bit tamsayı, BYREF alias ve GOSUB dönüş yığını tamamlanmalı. Öneri ortak type/ABI metadatasından typed local/parametre/dönüş/işlemler üretmek; JS'te BigInt, WASM'da gerçek i64/f32/f64 yolları kullanmak. BYREF için kopya yerine ortak hücre/adres sözleşmesi gerekir. Alternatif: web hedeflerini bilinçli alt küme ürün yapmak; önceki tam yüzey hedefini değiştirir. Açık ret geliştirme sınırıdır, çalışan destek değildir. Kabul: Node ile gerçek yürütme, sınır sayıları, mixed dönüşler, alias ve iç içe GOSUB.

### T09 MIR ve motor politikası

S-004 gereği mevcut yollar ve referans/test kümeleri korunmalı; ölü kod ilanıyla kaldırılmamalı. Kaynakta semantic MIR ve canonical MIR ayrı temsillerdir; native/JS/WASM semantic MIR tüketirken yorumlayıcı köprüden geçen canonical kayıtları kullanır. Öneri yeni metadata'nın iki temsil ve köprüde kayıpsız taşınması; özel verifier'ların gerçek pipeline'a bağlanması; BOTH karşılaştırmasının assembly metni yerine gözlenebilir sonuçları karşılaştırması. Alternatif: tek MIR'e büyük göç; uzun vadeli sadeleşme getirir fakat mevcut motor politikasını ve araçları etkiler. Ayrı mimari kararı olmadan uygulanmamalı.

### T10 Yüzey matrisi ve test güveni

S-153 için öneri lexer/parser/builtin/type/provider kayıtlarından türetilmiş tam envanter; her satırda hedef, uygulama kaynağı, gerçek probe ve son hash. S-170 dosya yazma sorunu düzelmiştir; bu tam kapsam eksikliğini kapatmaz. Alternatif: elle seçilmiş duman matrisi tutmak; adı ve kapsamı açıkça sınırlı olmalı. Birden çok test koşucusunda exit kodu ve çıktının birlikte denetlenmesi, beklentisiz örneğin doğrulanmış sayılmaması sürdürülmeli. Kabul: yeni builtin eklenince satırın otomatik gelmesi ve hiç sınanmamış hücrenin PASS olmaması.

### T11 Kalan legacy OOP ve metin ömrü

S-105/S-157-L/S-159-L/S-162-L ve eski genişletilmiş float kayıtları taze kabul gerektiriyor. Öneri bilinen alan/aggregate/namespace yazımlarını ortak typed storage yardımcılarına bağlamak; metin retain/release ve bütün değer kopyasını tamamlamak. Alternatif: legacy'yi belirlenmiş referans alt küme olarak sınırlamak; kapsam azaltımı kararı gerektirir. Mevcut dört motor PROPERTY kabulü genel OOP/lifetime kapanışı değildir. Kabul: arayüz dispatch, nested metin alanı, 32'den çok metin üretimi, alias ve namespace dizisi.

### T12 İfade sırası ve ölçek

S-161'de global okuma ile yan etkili çağrı sırası; S-090/S-111/S-191'de ölçek kayıtları açık. Öneri ifade değerlendirme sırasını önce sözleşmeyle kesinleştirmek, sonra IR geçicileriyle aynı sıraya indirmek. Alternatif: sırayı tanımsız bırakmak veya yalnız belirsiz programları reddetmek; deterministik BASIC beklentisini zayıflatır. Ön uç performansında katman ve rutin düzeyinde ölçüm, deklarasyon/scope/layout önbelleği öneriliyor. FFI modül önbelleği uxffi.c içinde zaten var ve 64 modül sınırı denetleniyor; “300 çağrı sabit tabloyu taşır” eski şüphesi doğrulanmış neden değildir. Raymath kaydında semantic yaklaşık 165 s, MIR 50 s, x64 build 398 s; aynı koşullarda yeni karşılaştırma olmadan hızlanma iddia edilmemeli.

### T13 Kütüphane ve dağıtım denetimi

S-041/S-052/S-075 gibi kayıtlar için kaynak build'i, DLL export'u, bağımlılık ve paket hash'i birlikte doğrulanmalı. Öneri compiler/runtime/provider/kütüphane dosyalarını tek sürümlü dağıtım manifestinde bağlamak. Raylib eski paket kopyası bu araştırmada eşitlendi; daha geniş kütüphane yüzeyi ayrıca ölçülmeli. Alternatif: yalnız bin klasörünü çalışır kabul etmek; kullanıcıya dağıtılan paket farklı kalabilir. Kabul: temiz klasörde build/run, AST/MIR/native/legacy FFI sonuçları ve eksik DLL tanısı.

### T14 Belgeler ve düşük token çalışma

Öneri tek sorumlu AGENTS kaydı, yerel FTS belge indeksi, sembol paketleri, kısa kabul özeti ve append-only kanıt bağlantıları. Eski RAG/model taslakları kaynak kanıtı yerine geçmemeli. Ek MCP/AI servisi sırf mevcut olduğu için kurulmasın; hazır yerel araçlar arama işini karşılıyor. GitNexus şu anda başka bir depoyu listeliyordu; uXBasic indeksi varsayılmadı. Alternatif: ayrı bir semantik arama servisi; gerçek ihtiyacı, indeks tazeliği ve ek süreç maliyeti ölçüldükten sonra düşünülmeli. Bilgisayarda mevcut Claude/Ollama süreçleri görüldü; uXBasic dosyalarını aktif düzenledikleri kanıtlanmadı ve bu araştırma tarafından başlatılmadılar. Tek proje sahibi kararı, bütün bilgisayardaki süreçlerin otomatik kapatıldığı anlamına gelmez.

## Planlamaya geçerken kullanılacak öncelikler

Bu bölüm bir uygulama takvimi veya verilen yeni karar değildir. Öncelik girdisidir. İlk değerlendirme grubuna AST kapasite abort'u, merkezi hata kaydından kaçan süreç hataları, native çağrıda yanlış başarı ve dönüş tipi bit/ABI uyumu alınmalı. Bunlar yanlış sonucu ve tanısız kapanışı önler.

İkinci grupta altı kitap açığı, gerçek dil seçimleri ve bütün motorlarda ortak tür/değerlendirme kuralları bulunur. Üçüncü grupta yaşam döngüsü, pointer/iterator/provider/task/web halkaları; ardından tam yüzey matrisi, performans ve temiz dağıtım kabulü gelir. Birinci sınıf tipler, iterator ve görev transferi ortak ömür sözleşmesine bağımlıdır; sırf paket testleri yeşil diye bu bağımlılık atlanmamalı.

Her iş için sorun numarası, yürürlükteki karar, değişecek sözleşme, kaynak dosyaları, gerçek kabul programı, motor kapsamı ve geri dönüş yolu yazılmalı. Günlükteki eski kapanış kanıtı ile son ikili hash'i karıştırılmamalı. Kararları belge üzerinden aldıktan sonra bu girdiler somut iş planına çevrilebilir.

## Kanıt dosyaları ve ekler

Çalışma kökü `C:/Users/mete/Downloads/BasicOyunSource/UXBc_Clean/UXBc/uxb`.

- `reports/consolidation_20261006_verified_regression.md` ve `.log`: son 24 paket.
- `reports/consolidation_20261006_verified_string_lifetime.md`: ayrı 21 kontrol.
- `reports/compiler_consolidation/20261006_150927_6406/language.json` ve `matrices.json`: 83 kontrolün ayrıntısı.
- `reports/consolidation_20261006_book_examples_verified.json`: 130 örneğin motor kayıtları; altı açık beklentili örnek CONTINUE, STATIC, ENUM tipi, dar tamsayı literali, MID ataması ve IFF.
- `reports/consolidation_20261006_capacity_probe`: 255/256/257 kaynakları, önce/sonra stderr ve süreç bellek/çıkış kayıtları.
- `reports/consolidation_20261006_fault_replay_checked/capture.json`: büyük-frame tekrar çalıştırması ve örneklenemeyen bellek için null kaydı.
- `reports/consolidation_20261006_error_center`: TR/EN tanı JSON ve TXT kayıtları; `reports/consolidation_20261006_diag_format_json.txt`: biçim seçimi deneyi.
- `reports/consolidation_20261006_windows_fault_events.json` ve `resource_exhaustion_events.json`: olay günlüğü sorgusunun kapsamı ve sonucu.
- `reports/consolidation_20261006_raymath_run.json`, `raymath_build.log`, raymath oturumunun `layer_timing.json`: native kabul ve katman süresi.
- `reports/compiler_audit_20261006/issues_inventory.csv` ve `.json`: bütün tarihsel başlıklar, kayıt durumları ve bu çalışmanın ek değerlendirmesi.
- `reports/context_index/inventory.json`, `headings.tsv`, `issues.json`: belge ve konum envanteri; kaynak haritası çalışma alanındaki `reports/uxb_map_system/20261006_151008` altında.

Esas karar kaynakları: `ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md`, `SORUN_TAKIP.md`, `DURUM.md`, `SORULAR_CEVAPLAR.md`; 20/23/24 Eylül tasarım belgeleri; `docs/tasarim/UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` ve yeni Model D ekleri. En yeni açık kullanıcı kararı eski planı geçersiz kılar.

Teknik dayanaklar: [Microsoft x64 prolog ve stack yoklaması](https://learn.microsoft.com/en-us/cpp/build/prolog-and-epilog?view=msvc-170), [Microsoft printf yuvarlama davranışı](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/printf-printf-l-wprintf-wprintf-l?view=msvc-170), [OpenAI kısa skill ve bağlam kullanımı](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra). Bu kaynaklar yerel compiler testinin yerine geçmez.
