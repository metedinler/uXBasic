# uXBasic OOP hedef tasarımı ve uygulama planı

Tarih: 2026-09-15

Durum: Tasarım önerisi v1. Bu belge yeni özelliklerin uygulandığı veya bütün motorların geçtiği iddiası değildir. Kullanıcının THIS/ME/SUPER görev ayrımı ve eksiksiz OOP tasarımı talebini somutlaştırır. Derleyici kaynakları bu çalışmada değiştirilmemiştir.

## 1. Hedef ve tasarım ilkeleri

Hedef; kayıtlar, nesneler, arayüzler, bileşim, kaynak ömrü, davranış genişletme ve dış kütüphaneleri tek bir dil sözleşmesi altında birleştirmektir. Özellik sayısı tek başına tamamlanmışlık değildir: kabul, yürütme, hata ve kaynak ömrü sözleşmeleri birlikte geçmelidir.

- Nesne kimliği, üye görünürlüğü, statik tür ve çağrı hedefi ayrı kavramlardır.
- Hiçbir motor programın anlamını kendi başına yeniden yorumlamaz.
- Metadata davranışın kendisi sayılmaz; davranış ancak tanımlı tüketicisi varsa uygulanır.
- Derleyicinin nesnesi ile uxclz native nesnesi açık adaptörle birleşir; adresleri birbirine eşit varsayılmaz.
- Sessiz başarısızlık yoktur. Geçici desteklenmeme tanısı ilerleme durumudur, nihai tamamlanma değildir.
- Uyum kıran değişiklikler dil sürümüne bağlanır; eski kaynak sessizce yeni anlama geçirilmez.

## 2. Mevcut durumdan ayrım

Mevcut kaynakta THIS/ME için ortak bağlam denetimleri, SUPER için taban hiyerarşisinden çözümleme, tek tabana indirgenen MIXIN ve DECORATOR metadata denetimi bulunuyor. Aşağıdaki daha güçlü sözleşmeler hedef tasarımdır.

UXClazz üreticisinde önceki turda gerçek üretimle doğrulanan iki açık: USES Logger ile LoggerPart alanı iki GetLoggerPart/SetLoggerPart üretir; x ve X birlikte kabul edilir. Bunlar düzeltme kuyruğundadır.

S-050 native statik TYPE-dizisi alan erişimi son kayıtla uygulanmıştır; baştan yapılmayacak, regresyon kapsamı genişletilecektir. S-037 OOP rota farkları yeni derleyiciyle yeniden ölçülecektir.

## 3. THIS, ME ve SUPER: kesin görev ayrımı

### 3.1 Temel karar

Üç erişim biçimi aynı nesnenin kimliğini taşır. Fark, üye çözümlemesi ve çağrı seçimindedir. Bu sözleşme sınıfın örnek metotları, property erişimcileri ve operatörleri için geçerlidir; STATIC üyede üçü de yasaktır.

| Biçim | Anlam | Üye araması | Metot çağrısı |
|---|---|---|---|
| THIS | Bu metot gövdesini tanımlayan sınıfın uygulama görünümü | Gövdenin sözcüksel sahibi olan sınıftan | Doğrudan; sanal slotu yeniden dağıtmaz |
| ME | Aynı nesnenin çok biçimli davranışı | Derleme sırasında aynı görünür sözleşmeden | Sanal/arayüz slotu varsa gerçek nesne türüne göre; sıradan metotta doğrudan |
| SUPER | Bu gövdenin sahibinin doğrudan tabanından başlayan uygulama görünümü | Doğrudan taban ve onun ataları | Doğrudan taban uygulaması; türetilmiş override'a dönmez |

Önemli: ME dinamik üye adı araması değildir. Taban sınıfın kodu, yalnız türetilmiş sınıfta bulunan alan/metoda ME ile erişemez. Önce kontrollü tür daraltma gerekir. THIS/ME erişim denetimini aşmaz.

Alanlar sanal değildir. THIS.x ve ME.x, gövdenin statik sözleşmesinde çözülen aynı alana gider. Property ve operatör erişimcileri sanal ilan edilebildiğinden çağrı politikası bunlarda da korunur.

### 3.2 Ayırt edici örnek

Bu bölüm hedef sürümün örneğidir; mevcut derleyicide geçtiği iddia edilmez.

```basic
CLASS Base
    VIRTUAL METHOD Value() AS I32
        RETURN 10
    END METHOD

    METHOD Inspect() AS I32
        RETURN THIS.Value() * 100 + ME.Value()
    END METHOD
END CLASS

CLASS Child EXTENDS Base
    OVERRIDE METHOD Value() AS I32
        RETURN SUPER.Value() + 10
    END METHOD
END CLASS
```

Child örneğinde miras alınmış Inspect çağrısının sonucu 1020 olmalıdır: THIS.Value Base.Value=10; ME.Value Child.Value=20; Child.Value içindeki SUPER.Value Base.Value=10. Inspect'in sözcüksel sahibi Base kalır.

Üç seviyeli kalıtımda da SUPER, çalışma anındaki en alt sınıfın tabanından değil, yürüyen metot gövdesinin sahibinin tabanından başlar. Seçilen taban uygulaması kendi içinde ME ile sanal çağrı yaparsa bu iç çağrı yeniden çok biçimlidir.

### 3.3 Ek kurallar

- Gövde içindeki niteliksiz örnek üye kullanımı THIS ile eşdeğerdir. Önce yerel/parametre, sonra sınıf üyesi çözülür. Gölgeleme lint tanısı üretir.
- Dışarıdaki obj.Method() normal çok biçimli çağrıdır; yalnız sanal slot varsa override seçer.
- THIS/ME yeniden atanamaz. İfade olarak kaçırılması nesne referansını taşır; THIS'in doğrudan çağrı politikası başka değişkene bulaşmaz.
- SUPER tek başına değer değildir; atanamaz, döndürülemez, saklanamaz. SUPER.Member ve kurucuda SUPER(...) özel biçimleri vardır.
- THIS ile gövdesiz ABSTRACT üyeye doğrudan çağrı hatadır. ME ile çağrı somut nesnenin uygulamasına gider.
- Taban private üyesine SUPER ile erişilemez. Erişim yetkisi ile çağrı politikası ayrıdır.
- Kurucu/yıkıcı içinden ME üzerinden sanal çağrı yasaktır. THIS/SUPER ile doğrudan çağrılar ve sıradan yardımcılar kullanılabilir.
- Kurulum sırasında nesnenin dışarı kaçması veya kısmen kurulmuş nesneye sanal çağrı, kaçış analizi ve gerekli runtime durum kontrolüyle engellenir; yalnız sözdizimi yasağı yeterli değildir.
- Lambda/closure receiver yakalama bu sözleşmeye eklendiğinde, sözcüksel sınıf ve receiver birlikte taşınmalıdır; güçlü/weak yakalama açık olmalıdır.

### 3.4 Geçiş

Bu ayrım klasik THIS=ME alias kullanımından daha güçlü ve alışılmışın dışındadır. Gerekçesi, kullanıcının istediği açık görev ayrımıdır. Bedeli eski THIS.Virtual() kodunun davranışının değişebilmesidir.

Yeni sözleşme sürümlü olarak etkinleşir. Geçiş aracı THIS ile sanal çağrı, niteliksiz sanal çağrı ve property erişimlerini listeler; eski dinamik davranışı korumak isteyen yerde ME önerir. Anlamı belirsiz çağrıları otomatik dönüştürmez. Runtime'a göre farklı sürüm seçilemez.

## 4. Türler, kimlik ve kopyalama

| Yapı | Önerilen sözleşme |
|---|---|
| TYPE | Yönetilen değer kaydı; atama alan bazlı değer kopyası; içindeki CLASS alanları referans kopyalar |
| STRUCT ABI C | C yerleşimli kayıt; ABI açısından uygun alanlar; ham blok kopyası yalnız trivially-copyable türlerde |
| UNION ABI C | Ortak byte depolama; otomatik aktif alan veya sahiplik yok; yönetilen referanslar reddedilir |
| ENUM | Adlandırılmış nominal sabit kümesi; taban türü tamsayı; aralık doğrulaması; açık sayısal dönüşüm |
| CLASS | Kimlikli referans nesnesi; atama referans paylaşır, nesneyi kopyalamaz |
| INTERFACE | Ayrı nesne oluşturmayan, nesne kimliği + arayüz dispatch görünümü |

TYPE'ın CLASS üyesini kopyalamak derin kopya değildir. CloneShallow/CloneDeep ayrımı kütüphane sözleşmesinde açık olmalıdır; derin kopya döngü ve ortak referansları koruyan ziyaret tablosu ister. Native kaynaklar varsayılan olarak kopyalanamaz.

CLASS için varsayılan eşitlik kimlik eşitliğidir. Değer eşitliği kullanıcı sözleşmesiyle gelir. EQ ve HASH birlikte tutarlı olmalı; eşit nesneler aynı hash'i vermeli. Dictionary anahtarının eşitliğe katılan alanları değiştirilemez veya anahtar açıkça çıkarılıp yeniden eklenir.

NULL/dangling ayrımı, nil kontrolü ve type-test/checked-cast işlemleri tek sözleşme ister. Başarısız daraltma sessiz sıfır veya yanlış pointer üretmez. Tam kaynak yazımı gramer aşamasında kesinleşecektir.

## 5. Kalıtım, erişim ve metot sözleşmesi

- CLASS tek uygulama tabanı, birden fazla INTERFACE uygular. Çoklu durum kalıtımı yoktur.
- OVERRIDE yalnız var olan sanal slotla, aynı parametre/BYREF yönü ve uyumlu dönüşle eşleşir. İlk sürümde dönüş tipi birebir; kovaryans daha sonra ayrı kuralla açılır.
- FINAL sınıf türetilemez; FINAL metot override edilemez. SEALED, FINAL CLASS için belgeli eşanlamlıdır; ayrı belirsiz anlam taşımaz.
- ABSTRACT sınıf doğrudan oluşturulamaz; tüm abstract ve interface slotları tamamlanmadan somut sınıf oluşmaz.
- STATIC üye nesneye değil türe aittir; VIRTUAL/OVERRIDE ile birleşmez.
- PUBLIC herkese, PRIVATE yalnız bildiren sınıfa, PROTECTED bildiren sınıf ve türevlerine açıktır. PROTECTED receiver kuralı da denetlenir: türetilmiş sınıf rastgele bir taban örneğinin korumalı durumuna erişemez.
- RESTRICTED paket/modül içi erişimdir; ham klasör yoluna bağlı değildir. FRIEND yalnız açık sembollere sınırlı yetki verir ve metadata'da görünür.
- Alan adını kalıtımla gizlemek varsayılan hata olur. Metot overload ve override farklıdır. Overload çözümlemesi derleme zamanında, sanal dispatch seçilen imzanın slotunda yapılır.
- Overload'da tam tür eşleşmesi, kayıpsız sayısal genişletme ve referans upcast sıralaması açık olacaktır; eşit iyi aday belirsizlik hatasıdır. Dönüş tipi tek başına overload ayıramaz.
- Generic sınıf/arayüzler hedef kapsamındadır: açık tür parametreleri, constraint denetimi, varsayılan invariance. İlk uygulama monomorphization; FFI'ye kapalı jenerik yerine yalnız somutlaştırılmış adaptör çıkar.

## 6. PROPERTY, MAGIC ve OPERATOR

- PROPERTY saklama alanı değildir; GET/SET erişimci sözleşmesidir. Otomatik property için derleyici ayrı field-id üretir.
- Getter-only dışarıdan okunur; setter-only okunamaz. Setter tek yeni-değer parametresi alır. İndeksli property için indeksler iki erişimcide aynı tiptedir.
- READONLY alan kurulum sonunda sabitlenir; referansın hedefini derin dondurmaz. IMMUTABLE nesne grafiği için daha güçlü ve doğrulanabilir bir garantidir. MUTABLE, IMMUTABLE garantisini sessiz delmez.
- Sanal property'nin GET ve SET slotları ayrı fakat aynı property-id altında tutulur; override uyumluluğu birlikte denetlenir.
- OPERATOR ve karşılık gelen bilinen MAGIC aynı davranış slotuna normalize edilir. İkisini aynı sınıfta çelişkili tanımlamak hatadır.
- MAGIC_GET/SET/CALL yalnız normal üye çözümlemesinde üye bulunamadığında fallback olabilir; PRIVATE erişim ihlalini veya yanlış imzayı gizleyemez.
- TOSTRING açık dönüşüm/yazdırma sözleşmesine bağlıdır; format, hata ve recursion guard belirlenir. Hash/clone gibi özel isimler otomatik hook sayılmaz.
- AndAlso/OrElse kısa devre garantisi korunur; normal iki argümanlı overload gibi erkenden iki tarafı değerlendiremez.
- a().P += f() sırası: receiver bir kez, getter bir kez, sağ taraf bir kez, operatör bir kez, setter bir kez. Ara adım hata verirse sonraki adımlar çalışmaz.

## 7. MIXIN ve bileşim

Hedef MIXIN, tek tabana gizlice dönüştürülmek yerine açık trait bileşimidir. Trait varsayılan metot gövdeleri ve gereken arayüzleri bildirir. İlk trait sürümü durum taşımaz; durumlu parçalar normal CLASS alanlarıdır.

İki trait aynı imzayı verirse son eklenen kazanmaz; açık seçim/yeniden adlandırma veya sınıfta override gerekir. Trait gövdesinde THIS, bağlandığı sınıfın denetlenmiş uygulama sözleşmesine göre normalize edilir; ME sanal dispatch'i korur. Trait, sınıfın private alanlarına örtük erişemez; gereksinimleri property/metot sözleşmesiyle ister. Trait içindeki SUPER yasaktır; sıralamaya bağlı gizli taban zinciri yaratılmaz.

UXClazz USES ise nesne bileşimidir: içerilen parça + açık delegasyon. MIXIN ile eşanlamlı değildir. Delege edilen metotların isim, hata, sahiplik ve erişim kuralları üretim manifestinde gösterilir. Eski tek-mixin-as-base davranışı sürüm geçişine alınır.

## 8. DECORATOR: amaç, görev ve karşılık

DECORATOR bir bildirim üzerine tanımlı dönüşüm veya metadata sözleşmesi uygulamak içindir. Her decorator için kayıt zorunludur: kimlik/sürüm, tür, geçerli hedef, argüman tipleri, tekrar edilebilirlik, sıra, eklediği üyeler, runtime bağımlılığı ve uyumluluk gereksinimi.

| Tür | İşlem aşaması | Ürettiği karşılık | Örnek |
|---|---|---|---|
| Metadata | Bildirim çözümleme | Türlenmiş attribute kaydı | Açıklama, deprecated bilgisi, serileştirme alan adı |
| Derleme dönüşümü | İlk sembol toplama sonrası, son tür kontrolü öncesi | Normal AST üyeleri/gövdeleri | Eşitlik, hash, JSON, doğrulama kodu üretimi |
| Çağrı sarmalama | Gövde dönüştürme, sonra normal lowering | Tek public giriş + özgün gövde çağrısı | Trace, ölçüm, yetki/argüman kontrolü |

Decorator uygulaması için DECORATOR Name(args) korunabilir; decorator tanım grameri ayrıca yazılacaktır. Buradaki Trace vb. isimler önerilen kütüphane adlarıdır, yeni global keyword değildir.

Kurallar:

1. Bilinmeyen decorator hatadır; sessiz metadata kabulü yoktur.
2. Hedef yanlışsa veya argüman türü uymuyorsa kaynak konumuyla hata verilir.
3. Metadata kendi başına iş yapmaz. Örneğin JSON adı yalnız serileştirici tükettiğinde etkilidir.
4. Derleme dönüşümleri deterministik, sürümlü ve sınırlı çalışır. Genel keyfi derleme zamanı I/O varsayılan değildir. Sonsuz dönüşüm/döngü tespit edilir.
5. Üretilen üyeler normal erişim/tür/isim denetiminden tekrar geçer; kullanıcı üyesini ezemez.
6. D, E sırasıyla bildirilen çağrı decorator'ları D(E(body)) olur: giriş D,E; çıkış E,D. Cleanup finally garantisiyle çalışır.
7. Kalıtılan değiştirilmemiş metot aynı sarılmış uygulamadır. Override'a decorator kendiliğinden kopyalanmaz. Sözleşme niteliğindeki doğrulamalar ayrı inheritance kuralıyla taşınır.
8. THIS/ME/SUPER uygun uygulamanın sarılmış girişini çağırır; THIS/SUPER decorator'ı atlayamaz. Özgün gövde girişi kullanıcıya açık değildir.
9. BYREF, return, exception ve kısa devre davranışı korunur; geçici kopya BYREF yerine geçirilemez.
10. Memoize yalnız açık saflık/anahtar/ömür sözleşmesiyle; Retry yalnız tekrar çalıştırmanın yan etkileri açıkça kabul edildiğinde kullanılabilir. Trace gibi basit sarıcılarla başlanır.
11. Constructor/destructor üzerinde yalnız ömrü koruduğu kanıtlanan decorator sınıfları kabul edilir; nesne yaratmayı/serbest bırakmayı çoğaltamaz.

## 9. Nesne ömrü ve kaynak yönetimi

Önerilen yönetilen CLASS modeli: güçlü referans sayımı + weak referans. Güçlü döngüler otomatik toplanmış sayılmaz; weak bağlantı veya açık cycle-breaking gerekir. Döngü toplayıcısı ayrı ve açık runtime yeteneğidir; eksiksiz OOP, mutlaka tracing GC demek değildir.

- NEW önce taban alanlarını, sonra türetilmiş alanları hazırlar. Taban kurucu önce, türetilmiş kurucu sonra çalışır. Parametreli taban için SUPER(...) zorunlu; yoksa yalnız erişilebilir parametresiz kurucu seçilebilir.
- Nesne durumları: allocated, constructing, live, disposing, disposed. Durum geçişleri tek sahipli runtime operasyonlarıdır.
- Kurucu hata verirse yalnız başarıyla kurulmuş parçalar ters sırayla temizlenir; nesne live olarak yayınlanmaz.
- Son güçlü referans bırakıldığında yıkıcı türetilmişten tabana bir kez çalışır. Yıkıcıdan exception dışarı kaçmaz; cleanup sürer ve belirlenmiş hata kanalına kaydedilir.
- DELETE değişkeni, hedef değişkendeki güçlü referansı bırakıp NULL yapar; diğer alias'ları geçersizleştirmez. Geçerli lvalue gerektirir; ifade üzerinde DELETE reddedilir. Bu da eski davranıştan ayrılabilecek sürümlü karardır.
- Close/Dispose, dosya/DLL kaynağını erken kapatmak içindir ve idempotent olmalıdır. Kapalı kaynağa işlem kontrollü hata üretir; bellek referansı hâlâ geçerli olabilir.
- Kaynak kapsamı için ayrı bir sözdizimi tasarlanacaktır; mevcut namespace USING sessizce başka anlama genişletilmeyecek.
- OWNED/BORROWED/WEAK gibi sahiplik nitelemelerinin tam yazımı sonraki gramer kararıdır. Anlamları şimdi sabittir: sahiplik devri, geçici erişim, ömrü uzatmayan erişim.
- Thread paylaşımı varsayılan garanti değildir. Refcount güvenliği ile nesne alanlarının thread-safety'si ayrı sözleşmelerdir.

## 10. UXClazz profilleri ve kütüphane sınırı

| Profil | Hedefte gerçek garanti | Uygulama sınırı |
|---|---|---|
| DATA | Constructor, kontrollü erişimciler, açık DERIVE üretimi | Normal CLASS çıktısı |
| VALUE | Değer eşitliği, kopyalama ve immutable sözleşme | Sıradan CLASS üreterek değer depolaması var denemez; ayrı value lowering gerektirir |
| ENTITY | Sabit kimlik, sürüm, kimlik temelli eşitlik | Veritabanı kaydı otomatik değildir |
| COMPONENT | İçerilme, sahiplik ve attach/detach ömrü | ECS zamanlayıcısı otomatik değildir |
| ACTOR | Mailbox, sıralı işlem, mesaj türleri, hata/kapanış ve zamanlayıcı | Gerçek actor runtime gelmeden destekleniyor sayılmaz |
| NATIVE | Harici kaynağa tipli handle, ABI ve owned/borrowed sözleşmesi | C++ nesne adresi BASIC CLASS adresi değildir |

UXClazz isim üretimi case-insensitive sembol tablosuyla yapılır. Alanlar, get/set metotları, traits, derives ve metadata üyeleri üretimden önce birlikte ayrılır. İç adlar metin birleştirmeye değil sembol kimliğine dayanır. Çakışmada iki kaynak konumu gösterilir.

uxclz ile köprüde TypeId, ObjectId, InterfaceId ve MethodId ayrı alanlardır. Generation denetimli handle geçerliliği ve retain/release dengesi korunur. İki runtime'ın referans sayımı açık adaptörle bağlanır; her çağrıda rastgele retain yapılamaz. Borrowed sonuç, owner'dan uzun yaşayamaz veya açık retain ile owned'a çevrilir.

FFI nesne/metot exception'ı C sınırından taşmaz; durum kodu + türlenmiş hata sonucu kullanılır. Callback için çağıran thread, senkron/asenkron oluşu, yakalanan receiver ömrü ve reentrancy tanımlanır. Web hedefinde DLL yüklenmiş varsayılmaz; host adaptörü veya açık capability gerekir. C STRUCT by-value yalnız doğrulanmış ABI; UNION/PACK/özel ALIGN adaptör gereksinimi korunur.

## 11. Katmanların tek sözleşmesi

1. Lexer: kararlı tokenlar, kaynak konumu, sürüm bilgisi. Önceki keyword'e dayanan dağınık isim tahminlerini azaltmak.
2. Parser: receiver biçimini ayrı AST düğümü/politikası olarak saklamak; bağlamsal adları merkezi kuralla kabul etmek.
3. Sembol aşaması: sınıf/arayüz/generic/trait/decorator kimlikleri, case-insensitive ad tablosu.
4. Dönüşüm: trait ve decorator genişletmesi; üretilen kaynak haritası; yeniden sembol ve tür kontrolü.
5. Semantic: lexical owner, statik receiver türü, erişim, imza, lifetime ve dispatch kararı.
6. Layout: field-id/offset/stride, object header sözleşmesi, vtable ve interface slotları. Host byte düzenleri farklı olabilir; gözlenebilir dil davranışı eşdeğer olmalıdır.
7. MIR: açık receiver + lexical owner + method/slot id + dispatch kind (direct/virtual/interface/base) + sahiplik işlemleri. İsim metninden sınıf tahmin edilmez.
8. Interpreter/codegen: doğrulanmış MIR veya ortak resolved semantic planı tüketmek. AST-direct yollar aynı karar modelini kullanır, yeniden bağımsız çözümleme yapmaz.
9. Runtime: identity, lifecycle, retain/release, weak, errors ve host adaptörleri.
10. Ürün/araçlar: CLI capability, editör grameri, UXClazz, debugger/source map ve belge aynı sürüm bilgisini taşır.

## 12. Anahtar kelime politikası

THIS/ME/SUPER örnek bağlamında özel receiver sözcükleridir; aynı bağlamda kullanıcı değişkeni olarak bildirilemez. Nokta sonrası keyword benzeri isimlerin kabulü merkezi gramer kuralıdır; declaration/use simetrisi test edilir. Gerekirse kaçırılmış identifier sözdizimi ayrı kararla eklenir, tahmini bir biçim şimdi uygulanmaz.

VIRTUAL bellek deyimi ile VIRTUAL METHOD açık parser bağlamlarında ayrılır. GET dosya deyimi/property/magic; SET koleksiyon türü/property/magic olarak ayrılır. Aynı kelime farklı AST kind'larına bağlanır. DESTRUCTOR ile DELETE; IMMUTABLE ile READONLY; FINAL ile SEALED fark/eşanlamları belgelenir. NATIVE profil ile bellek nitelemesi de bağlamla ayrılır.

Decorator adları, profil adları ve derive seçenekleri gereksiz yere global reserved word yapılmaz. CLASS ve CLAZZ farklı giriş dilleridir. Aynı yardımcı listelerin lexer/parser/editor/üreticide elle çoğaltılması yerine sürümlü dil manifestinden üretim hedeflenir.

## 13. Kendimize sorduğumuz sorular ve önerilen cevaplar

| Soru | Önerilen cevap / karar durumu |
|---|---|
| THIS ile ME ayrı nesne mi? | Hayır; aynı kimlik, farklı doğrudan/sanal çağrı politikası. |
| ME türetilmiş türün her alanını görebilir mi? | Hayır; statik sözleşme ve erişim korunur. |
| THIS ile virtual çağrıyı bypass etmek erişimi deler mi? | Hayır; yalnız dispatch değişir. Erişim ve decorator korunur. |
| SUPER hangi taban? | Gövdenin lexical sahibinin doğrudan tabanından başlayan hiyerarşi. |
| Niteliksiz çağrı ne olur? | THIS; dinamik niyet ME ile açık. Uyum kırıcı olduğu için sürümlü. |
| Constructor ME çağırabilir mi? | Sanal çağrı hayır; kısmi nesne kaçışı ayrıca engellenir. |
| CLASS ataması kopya mı? | Referans paylaşımı. TYPE ataması değer kopyasıdır. |
| DELETE alias'ları öldürür mü? | Hayır; bir referansı bırakır. Close ayrı kaynak işlemidir. |
| Döngüler nasıl biter? | Weak/cycle-breaking; otomatik cycle GC iddiası yok. |
| Çoklu kalıtım gerekiyor mu? | Çoklu arayüz ve açık trait bileşimi yeterli; çoklu durum tabanı yok. |
| Decorator yalnız etiket mi? | Türüne göre metadata, derleme dönüşümü veya çağrı sarma. |
| Bilinmeyen decorator korunur mu? | Hayır; kayıt/consumer sözleşmesi olmadan hata. |
| Actor etiketi aktör sistemi mi? | Hayır; mailbox/zamanlayıcı/mesaj sözleşmesi gerekir. |
| Generics temel kabul için şart mı? | Tam hedefin ayrı paketi; ilk temel dispatch testlerinin önkoşulu değil. |
| Interface default metotları? | İlk sürümde yalnız sözleşme; default davranış trait üzerinden. |
| Reflection her private alanı açar mı? | Hayır; public metadata varsayılan, private erişim ayrı açık yetenek. |
| ABI her motorda aynı byte mı? | Hayır; C ABI sınırı hedefe özgü, dil semantiği ortak. |
| Kusursuzluk nasıl ölçülür? | Sözleşme matrisi + negatif test + gerçek runtime + bağımsız beklenen sonuç; sınırsız garanti verilmez. |

Ürün kararı olarak onaylanması gereken başlıca değişiklikler: THIS'in direct anlamı ve niteliksiz çağrı kuralı; DELETE/refcount modeli; MIXIN'in trait'e geçişi; VALUE profilinin değer türü gerektirmesi. Kullanıcı görev ayrımını istemiştir; burada seçilen ayrıntılı semantik öneridir ve henüz derleyiciye uygulanmamıştır.

## 14. Uygulama paketleri ve bağımlılıklar

| Paket | İş | Bağımlılık | Çıkış ölçütü |
|---|---|---|---|
| P0 | Dil sözleşmesi, kaynak envanteri, S-037 yeniden üretim, motor matrisi | Yok | Güncel ve tekrarlanabilir baseline |
| P1 | İsimler, contextual keyword, UXClazz collision | P0 | Bildirim/kullanım simetrisi; erken üretim tanıları |
| P2 | Receiver AST/semantic, THIS/ME/SUPER, upcast/interface cast | P0-P1 | 1020 örneği ve üç seviye dispatch; negatif erişim testleri |
| P3 | MethodId/slot/layout ve ortak resolved plan/MIR | P2 | Metin tahmini olmadan direct/virtual/base/interface |
| P4 | Nesne ömrü, alias, weak, constructor failure, hata modeli | P2-P3 | Tek destruction, doğru cleanup, dangling tanıları |
| P5 | Bütün motorlarda çekirdek OOP parity | P3-P4 | Gerçek AST/MIR/x64/JS/WASM testleri |
| P6 | Property/operator/magic, overload ve bileşik veri | P5 | Tek değerlendirme, imza ve hata parity |
| P7 | Trait ve decorator işlem hattı | P3,P6 | Deterministik genişletme, çakışma ve sıra testleri |
| P8 | UXClazz/uxclz/FFI sahiplik ve sürüm uyumu | P4-P7 | Üretimden native/host çalıştırmaya uçtan uca |
| P9 | Generics, VALUE, reflection ve actor/component ileri paketleri | P5-P8 | Her özelliğin bağımsız sözleşme ve kabul kapısı |
| P10 | Geçiş aracı, doküman, editör, release gate | Her pakette güncellenir | Destek tablosu gerçek sonuçlarla aynı |

Her pakette owner ve CLAIM güncel ortak kayıttan belirlenir. Bu belge başka oturumun aktif dosyasını devralmaz. Özellikle ortak lowering'in birden fazla include/kopya yolu ve üretilen JS runtime kaynağı kontrol edilmelidir. Yeni çalışma için mevcut yararlı test araçları yeniden kullanılır.

## 15. Kabul matrisi ve bitiş koşulları

Sütunlar: lexer/parser, semantic/layout, AST interpreter, canonical MIR interpreter, AST→x64 gerçek EXE, MIR→x64 gerçek EXE, JS/Node, browser host, WASM/Wasmtime, browser WASM. WAT ayrıca doğrulanır fakat ayrı yürütme motoru sayılmaz. Depoda başka aktif hedefler varsa P0 envanterine eklenir; dışarıda bırakılma gerekçesi yazılır.

Satır grupları:

- THIS/ME/SUPER, üç seviye kalıtım, inherited-body lexical owner, abstract direct hata.
- Field/property/metot, private/protected/restricted/friend ve static negatifleri.
- Base/interface referansı üzerinden override; overload ve interface slot çakışması.
- Constructor/destructor sırası, exception sırasında partial construction, alias/weak/cycle.
- NULL, disposed native kaynak, stale handle, yanlış downcast.
- TYPE/STRUCT/UNION/ENUM, nested record, nesne dizileri, değişken indeks, alt sınır, compound assignment.
- Magic/operator fallback ve kısa devre; yan etki sayaçları.
- Trait çakışması, decorator sırası, hata/cleanup, üretilen isim ve kaynak konumları.
- UXClazz her profil için vaat edilen gerçek çıktı; eksik profile açık hata.
- FFI owned/borrowed, callback lifetime, thread/reentrancy, ABI boyut ve hizalama.
- Generics constraint/instantiate, immutable ve hash, actor kapanış/mesaj sırası.
- Eski dil sürümü ve yeni dil sürümü karşılaştırması; dönüşümün davranış koruması.

Her test beklenen stdout dışında return/exception, yan etki sırası, destructor sayısı, sahiplik dengesi ve mümkünse bellek tanılarını doğrular. İki motor aynı yanlış sonucu verince PASS sayılmaz; sözleşmeden bağımsız beklenen oracle vardır. ASM/WAT üretildi diye runtime PASS yazılmaz. Desteklenmeyen yetenek SKIP/UNSUPPORTED olarak görünür ve hedef kapsamındaysa paketin kapanmasını engeller.

## 16. Kaynak dayanakları

- src/parser/lexer/lexer_keyword_table.fbs: keyword/identifier bağlamı.
- src/parser/parser/parser_stmt_decl_core.fbs ve parser_stmt_decl_class_method.fbs: sınıf, property, magic ve bildirimler.
- src/semantic/semantic_pass.fbs: THIS/ME, static, mixin, decorator, interface ve slot kontrolleri.
- src/runtime/exec/exec_call_dispatch_helpers.fbs: SUPER ve çağrı çözümlemesi.
- src/runtime/exec/exec_class_layout_helpers.fbs: kurucu/yıkıcı/tahsis.
- src/semantic/layout/layout_type_table.fbs: kayıt düzeni ve FFI sınırlamaları.
- tools/uxclazz/uxclazz.py: profil ve üye üretimi.
- runtime_ext/uxclz/src/uxclz.cpp ve libsx/uxclz/: native runtime ve sarmalayıcı.
- ai_koordinasyon/SORUN_TAKIP.md: S-037 ve diğer açık/kapanmış denetim kayıtları.
- ai_koordinasyon/S050_NATIVE_DUZELTME_20260914.md: native statik TYPE dizisi güncellemesi.
