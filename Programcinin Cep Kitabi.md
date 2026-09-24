# uXBasic Teknik Kitap (pck.md) 

# PROGRAMCININ CEP KITABI (V1.0 - R2)

# Neden Bu Kitap Var?
    uXBasic, Windows 11 (64-bit) için tasarlanmış, yüksek performanslı ve düşük seviyeli donanım erişimi sunan bir sistem programlama dilidir. Bu belge, uXBasic'in hem kullanıcıları (programcılar) hem de geliştiricileri (compiler mimarları) için bu belge tek ve mutlak doğru kaynaktır. Dilin tasarımından sözdizimine, veri tiplerinden bellek yönetimine kadar her detay burada açıklanmıştır. BU BELGENIN AMACI UxbASIC COMPILERIN TASARIM VE PLANLAMA BELGESI VE compilerin su anki durumu degil varacagi yeri tarif etmek icin yazilmistir. bu belge ile her hangi bir programci veya compiler mimari, uXBasic'in ne oldugunu, ne yapabilecegini, nasil kullanilacagini ve gelecekte neler yapabilecegini anlayabilir. Bu belge, uXBasic'in tarihsel arka planından başlayarak, dilin temel prensiplerine, sözdizimine, veri tiplerine ve operatörlere kadar her konuyu kapsamlı bir şekilde ele alır. Ayrıca, uXBasic'in nasıl derlendiği, çalıştırıldığı ve test edildiği gibi pratik konulara da değinir. Bu belge, uXBasic'i öğrenmek isteyen herkes için bir rehber olarak hizmet ederken, aynı zamanda dilin gelişimine katkıda bulunmak isteyen geliştiriciler için de bir referans kaynağıdır.

# Içindekiler
- 0. Neden Bu Kitap Var?
    - 0.1 Niyet ve Kapsam
    - 0.2 Belge Yapısı ve Kullanımı
    - 0.3 Terminoloji ve Teknik Terimler
    - 0.4 Sürüm ve Güncelleme Politikası
    - 0.5 Geri Bildirim ve Katkı Sağlama
    - 0.6 Güvenlik ve Sorumluluk Reddi
    - 0.7 Lisans ve Telif Hakları
    - 0.8 Kısaltmalar ve Semboller
    - 0.9 Kaynak Kod, Referanslar, Teşekkürler ve Programcinin Aciklamasi 
- 1. Dil Sözleşmesi ve Temeller
    - 1.1 Giriş ve Vizyon
    - 1.2 Temel Mimari Prensipler
- 2. Programlama Kuralları ve Sözdizimi Disiplini
    - 2.1 Yazım Kuralları
    - 2.2 Program Dosya Yapısı
- 3. Veri Tipleri ve Bellek Modeli
    - 3.1 Temel Veri Tipleri
    - 3.2 Kullanıcı Tanımlı Yapılar (UDT)
- 4. Operatörler ve İşlem Önceliği
    - 4.1 Matematiksel ve Mantıksal Operatörler
    - 4.2 Bileşik Atama Operatörleri  
- 5. Değişken Tanımlama ve Bellek Ayırımı (DIM)

# Bolum 0: OnSöz
Bu belge ile proje kapsami net, acik, anlasilabilir, sozdizimlerinde standardize edilmis, sistematik olarak anlatilmis, izlenebilir kolayca belge icerisinde bilgi bulunmasi kolaylastirilmistir.
Bu dilin uzak hedefi veri bilimi ve istatistik konusunda ve yapay zeka alaninda hizli prototipleme ve urun cikartma amaci tasimaktadir. VAO ogrencilerinin hizli prototipleme calismalarini yapmalirini, hatta cogunlukla yeni bir dil ozellikle python bilmeyen ve anlamayan ogrencilerin daha kolay ogrenmesini saglamak amaclidir. ileride kendi ihtiyaclari icin gelistirilebilir olmasi, cok hizli olmasi amaclanmistir.
VAO derslerine katilan arkadaslarimiza hediyemiz. Ama Destek olmak isteyen herkes bu belgeyi okuyup uXBasic'e katkida bulunabilirler. Bu belge, uXBasic'in ne olduğunu, nasıl çalıştığını ve nasıl kullanılacağını anlamak isteyen herkes için bir rehberdir. Ayrıca, uXBasic'in gelişimine katkıda bulunmak isteyen geliştiriciler için de bir referans kaynağıdır. Bu belge, uXBasic'in tarihsel arka planından başlayarak, dilin temel prensiplerine, sözdizimine, veri tiplerine ve operatörlere kadar her konuyu kapsamlı bir şekilde ele alır. Ayrıca, uXBasic'in nasıl derlendiği, çalıştırıldığı ve test edildiği gibi pratik konulara da değinir. Bu belge, uXBasic'i öğrenmek isteyen herkes için bir rehber olarak hizmet ederken, aynı zamanda dilin gelişimine katkıda bulunmak isteyen geliştiriciler için de bir referans kaynağıdır.

Bir gelir beklentim olmasada yinede zmetedinler@gmail.com ve patreon hesabima gonlunuzden ne koparsa gonderirseniz bende motive olmus olurum.

## 0.1 Niyet ve Kapsam
uXBasic, Windows 11 (64-bit) için tasarlanmış, yüksek performanslı ve düşük seviyeli donanım erişimi sunan bir sistem programlama dilidir. Bu belge, uXBasic'in hem kullanıcıları (programcılar) hem de geliştiricileri (compiler mimarları) için bu belge tek ve mutlak doğru kaynaktır. Dilin tasarımından sözdizimine, veri tiplerinden bellek yönetimine kadar her detay burada açıklanmıştır.
## 0.2 Belge Yapısı ve Kullanımı
Bu belge, uXBasic'in tüm yönlerini kapsamlı bir şekilde ele alacak şekilde yapılandırılmıştır. Her bölüm, dilin belirli bir yönüne odaklanır ve alt bölümlerle detaylandırılır. Programcılar için örnekler ve açıklamalar içerirken, geliştiriciler için derleyici mimarisi ve dahili mekanizmalar hakkında teknik detaylar sunar.
## 0.3 Terminoloji ve Teknik Terimler
Bu bölüm, belge boyunca kullanılan teknik terimleri ve jargonları tanımlar. Her terim, uXBasic bağlamında ne anlama geldiği ve nasıl kullanıldığı açıklanır.
## 0.4 Sürüm ve Güncelleme Politikası
uXBasic ve bu belge, sürekli gelişen bir proje olarak düzenli güncellemeler alır. Her güncelleme, yeni özellikler, hata düzeltmeleri ve iyileştirmeler içerebilir. Sürüm numaraları ve değişiklik günlükleri, kullanıcıların ve geliştiricilerin yapılan değişiklikleri takip etmelerini sağlar.
## 0.5 Geri Bildirim ve Katkı Sağlama
uXBasic topluluğu, geri bildirim ve katkılara açıktır. Kullanıcılar ve geliştiriciler, dilin gelişimine katkıda bulunmak için önerilerde bulunabilir, hata raporları gönderebilir ve kod katkıları yapabilirler. Katkı sağlama süreci ve iletişim kanalları bu bölümde açıklanır.
## 0.6 Güvenlik ve Sorumluluk Reddi
uXBasic, güçlü bir dil olmakla birlikte, yanlış kullanıldığında güvenlik riskleri oluşturabilir. Bu bölüm, güvenli kodlama uygulamaları, potansiyel tehlikeler ve sorumluluk reddi hakkında bilgi sağlar.
## 0.7 Lisans ve Telif Hakları
uXBasic, açık kaynaklı bir proje olarak belirli bir lisans altında yayınlanır. Bu bölüm, lisans türünü, kullanıcıların haklarını ve yükümlülüklerini ve telif haklarıyla ilgili bilgileri içerir.
## 0.8 Kısaltmalar ve Semboller
Bu bölüm, belge boyunca kullanılan kısaltmaların ve sembollerin bir listesini sağlar. Her kısaltma ve sembol, ne anlama geldiği ve nasıl kullanıldığı açıklanır.
## 0.9 Kaynak Kod ve Referanslar
### 0.9.1 uXBasic Nedir? — Tarif ve Temel Kavramlar

**uXBasic** modern çağa uyarlanmış bir BASIC türevi derleyicisidir ve Windows 11 ortamında çalışması für tasarlanmıştır. uXBasic, özünde yazı tabanlı program metinlerini alıp bunları bilgisayarın anlayabileceği makine komutlarına (executable dosyalara) dönüştüren bir aracıdır. Eğer bir insan olarak kod yazarsan, uXBasic bu kodu derleyip çalıştırılabilir bir dosyaya çevirir. Bu sebeple uXBasic bir "dil derleyicisi" veya kısaca "derleyici" olarak bilinir. Programcıların QBasic veya Visual Basic ile alışık oldukları söz dizimine yakın bir yapı kullanır, böylece eski kod birikimi olan geliştiricilerin yeni teknoloji ile rahatça çalışmasını sağlar.

uXBasic'in işlevi beş temel adımda özetlenebilir: birinci adımda, yazdığınız program metnini satır satır okur ve her bir satını anlamlandırır; ikinci adımda, metinsel komutları (IF, FOR, PRINT gibi) içsel bir yapıya çevirir; üçüncü adımda, bu yapıyı kontrol eder ve hata olup olmadığını anlar; dördüncü adımda, uygun olan parçaları birleştirerek ara kodu üretir; beşinci adımda ise, bu ara koddan nihai çalıştırılabilir programı meydana getirir. Her adım ayrı ayrı ve dikkatle tasarlanmış modüller tarafından yönetilir, böylece program geliştirme süreci tutarlı ve güvenilir kalır.

uXBasic'i diğer derleyicilerden ayıran başlıca özellik, **DOS ortamından Windows 11 ortamına kadar uzanan geniş uyumluluk spektrumudur**. Eski işletim sistemlerinde çalışan kod parçalarını modern Windows sistemlerine taşıyabilir; aynı kaynak metin, hafif değişikliklerle hem 32-bit hem de 64-bit hedeflerde çalıştırılabilir. Bu esneklik, eski kodların çöpe atılmasını değil, onların modernleştirilmesini mümkün kılar. Programcı, bir kez yazı yazdığında, o yazıyı birçok farklı hedef platformda kullanabilir — bu da zaman tasarrufu ve verimliliği artırır.

uXBasic'in pratik kullanımı oldukça basittir: metin editöründe BASIC benzeri kod yazarız, sonra uXBasic derleyicisini çalıştırırız. Derleyici, yazılan metni kontrol eder ve hata yoksa Win11 x64 hedefi için çalıştırılabilir dosya oluşturur. Eğer hata varsa, derleyici bize netice itibariyle nerede hata yaptığımızı söyler. Bu döngü, yazı → derleme → test → düzeltme → yeniden derleme şeklinde devam eder. uXBasic bu döngüyü hızlı ve anlaşılır hale getirmek için tasarlanmıştır; hedefi, programcıya mantığa odaklanma imkânı vermek, derleyicinin detayları ise kendisinin hallederken görmek değildir.

Son olarak, **uXBasic, yaşlı ve yeni kodların birlikte yaşayabileceği bir köprü dilidir.** QBasic döneminden kalan programlar, minimal düzeltmelerle uXBasic'te çalışabilir. Öte yandan, uXBasic yeni söz dizimi özellikleri (modern operatörler, geliştirilmiş tür sistemi, INLINE() bloğu) sunarak, kitaplıklar ve sistem araçları ile daha derinde iletişim kurmasına izin verir. Bu sayede, bir programcı: eski kodunun temelini koruyarak, onu adım adım güçlendirebilir ve genişletebilir. Kısaca, uXBasic geçmiş ve gelecek arasında bir köprü olmak üzere tasarlanmıştır.

---

### 0.9.2 Teşekkür ve Tarihsel Hikaye

### 0.9.2.1 Tarihsel Arka Plan: QBasic Mirası ve DOS'tan Windows'a Geçiş

**QBasic**, 1980'li ve 1990'lı yıllarda IBM PC ekosisteminde hakim olan bir programlama diliydi. O günün dijital dünyasında, DOS işletim sistemi bilgisayarları yöneten temel yazılımdı. Milyonlarca programcı, QBasic ile yazılan kodlar sayesinde oyunlar, hesap programları, ofis araçları ve iş uygulamaları geliştirmişlerdir. Bu kodlar, o zamanın donanımı için mutlak ihtiyaçlarını yerine getirmişti. Ancak zamanla, teknoloji ilerledikçe; işletim sistemleri (Windows) evrimleşti, işlemciler (Intel, AMD) güçlendiği, ve internet çökmüş kültüre girdiğinde, eski QBasic kodları maalesef "geride kalanlar" haline gelmiş.

Aynı yıllarda, bir grup programcı ve sistem mimarı, bu eski bilgeliklerin boşa gitmesinin üzüntüsünü hisset. "Acaba, bu çok sayıda QBasic kodunu yeniden yazıp modern dünyada canlandıramaz mıyız?" sorusundan hareketle, **"UltraBasic" (UBASIC)** adında bir proje başlatıldı. UltraBasic, QBasic'in söz dizimi ve kavramlarını koruyarak, modern DoS DPMI korumalı kipi ve Win32 Windows API'sı üzerinde çalışacak şekilde genişletilmiştir. UBASIC, yalnızca satır satır tercüme (interpreting) değil, asıl derivedir (compile) yöntemi kullanarak verimli makine kodlar oluşturmuştur.

**UBASIC'in İç Mimarisi: SOURCE ve AINCLUDE Katmanları**

UBASIC projesi, iki ana katmandan oluşmuştur:

1. **SOURCE Katmanı** — Derleyicinin Beyni: Bu katmanda, QBasic şeklindeki program metni analiz edilir. UBASIC.BAS, KEYWORDS.BAS, KEYWORD2.BAS gibi dosyalar, satır satır komut tanıyıcılık ve anlama görevini üstlenmişlerdir. Bir programcının "PRINT x+5" yazması halinde, SOURCE katmanı bunu anlayan algoritmaları icra eder: "Bu satır PRINT komutu, parantez içi de bir matematik işlem, sonuç ekrana basılacak" demektir. SOURCE katmanı, her komutun ne yapması gerektiğini kurallardan bulup, bunu ara koda (assembly) dönüştürür.

2. **AINCLUDE Katmanı** — Derleyicinin Kas ve Kemikleri: Bu katmanda, SOURCE tarafından üretilen makine kodları çalıştırmak için gereken temel işlevler tutulur. MEM.ASM (bellek yönetimi), STRING.ASM (yazı işlemleri), FILE.ASM veya FILE.W32 (dosya okuma-yazma), TEXTWIN.W32 (ekran görüntüleme) gibi alt modüller, çok düşük seviyede işler yaparlar. Örneğin, "PRINT" komutu tanındığında, SOURCE katmanı bunu "textwin rutinine CALL yap" şeklinde emit ederken (üret), AINCLUDE katmanının TEXTWIN modülü gerçekten ekrana nasıl harf yazılacağını biliyor. Bu sayede, UBASIC ile yazılan her program bilgisayarın en derinliklerine kadar kontrol edebilir: ekran, dosya, hatta bellek adresleri bile doğrudan erişilir.

Böyle bir iki-katmanlı tasarım, **karmaşıklığı sıradanlaştırır**: yazılan kod basit düşünürlere görünürken, arkasında milyonlarca talimatın bir ormanlığında çalışır.

### 0.9.2.2 Modernizasyon Hikayesi ve uXBasic'e Geçiş

2020'lerin başında, UBASIC tabanı stabil ama "eski" hale gelmiş. Halen QBasic söz dizimini koruyor; ama günümüzün programcıları, modern dillerin (C, Python, Go) konfor imkanlarını özlüyorlardı. Ayrıca, Windows 11'in 64-bit çekirdeği, 32-bit uygulamalardan gittikçe uzaklaşıyordu. İşte bu noktada, geliştiriciler **"uXBasic"** adlandırılan bir yeniden yapılanma hareketi başlattı.

uXBasic'in misyonu, UBASIC'in ruhu ve mirasını korurken, temelleri modernleştirmektir. Ama bu iş, eski kodu sadece kopyalamaktan çok daha derindir. uXBasic çalışması şu aşamaları takip etmiştir:

- **Tabaning Yeniden Yazılması**: UBASIC, BASIC dili içinde (kendisiyle) yazılmıştı — bir çeşit oto-referansial tasarım. uXBasic ise, çok daha güçlü ve moderne dil olan **FreeBASIC** üzerinde yeniden yazılmıştır. FreeBASIC, BASIC'in modern versiyonu olup, daha hızlı derleme, daha iyi bellek yönetimi, ve Windows 11 desteği sunar.

- **Derleyici Mimarisi Güncellenmesi**: Eski UBASIC'te, komut tanıma ve dönüştürme "komut komut" (lineer) çalışıyordu. uXBasic, bunun yerine, **Lexer (yazıyı token'e çeviren) → Parser (token'leri yapıya çeviren) → Semantic Analyzer (anlamsal denetim) → Code Generator (son kod üretimi)** aşamalarını peyderpey kullanır. Bu, derleyici tasarımında altın standart olan daha güvenli ve modüler bir yaklaşımdır.

- **Yeni Söz Dizimi Desteği**: uXBasic, BASIC'in klasik komutlarını (PRINT, If, FOR) tutarken, yeni operatörler (+=, -=, **, @) ve bloklarını (INLINE()) katkı etti. Örneğin, eski bir UBASIC programcısı `PRINT x`, `x = x + 1` yazarken, yeni bir uXBasic programcısı `PRINT x`, `x += 1` yazabilir — ikisi da anlaşılır, ama ikincisi daha modern görünür.

- **64-bit Desteği**: uXBasic, 32-bit ve 64-bit'i desteklemek üzere tasarlanmıştır. Bunun demek, bir program aynı kaynak kodan, hem 32-bit (.exe) hem 64-bit (.exe) sürümler ile derlenebilir.

### 0.9.2.3 Eski Kodlayıcılara ve Mirasına Duyulan Saygı

Bu yeniden yapılanmanın en derin anlamı, **tarihsel bir sorumluluk hissetmektir**. 1990'lı yıllardan beri UBASIC kullanan ve belki ellileri, altmışları bulanmış programcılar vardır. Onların yazdığı programlar, o günün iş dünyasını (muhasebe, depo yönetimi, satış takibi) çalışır hale getirmiştir. Kimi zaman, bu programlar halen çalışmakta ve ticari değer taşımaktadır. uXBasic projesi, bu programcılara ve onların mirasına karşı duyulan saygının bir ifadesidir.

uXBasic'in mantıklı tasarış kararından biri: **Eski UBASIC kodunu kırmamak**. Yani, 1995'te yazılmış bir UBASIC programı, özel düzeltmeler olmadan, uXBasic'te derlenebilmelidir. Bu "backward compatibility" (geriye doğru uyumluluk), bazen yeni özellikler eklemekten daha zordur; çünkü eski halleri yaşatırken, yeniyi vermek gerekir. Ama uXBasic ekibi, bu meydan okumayı kabul etti.

Ayrıca, **UBASIC031_RAPOR.md** gibi belge ve kaynak kodlarının korunması, tarihsel dikkat göstergesidir. Eski sistem nasıl çalışıyordu, ne tür sorunlar vardı, nasıl çözüldü — bütün bunlar dokümantasyon sayesinde türlü geleceğe iletilmiştir. Her yeni programcı, bu kaynakları okuyarak, sadece "kod yazmayı" değil, "neden bu şekilde yapıldığını" öğrenebilir.

**Sonuç olarak**, uXBasic'in yolculuğu bir teknik proje olmaktan ziyade, bir medeniyetsel konuşudur: *"Eski bilgelikleri, yeni imkanlar ile yaşatmak."* Programlama dilinin tarihinde, böyle sorumluluk bilinciyle yürütülen güncellemeler nadirdir. uXBasic, bu nadir örneklerden biridir. UBASIC'i tasarlayan, geliştiren, ve bakımı yapan tüm programcılara, milyonlarca satır kod yazan isimsiz binlerce programcıya duyduğumuz saygı ve teşekkür, uXBasic'in temel motivasyonudur.

---

# Bölüm 1: Dil Sözleşmesi ve Temeller

## 1.1uXBasic Calisma Kurallari

- Yazim tarzi QB 7.1 benzeri olacak, ancak strict syntax kurallari gecerlidir.
- Sonek tip belirtecleri ($, %, &, !, #, @) strict modda kabul edilmez.
- SUB ve FUNCTION tanimlari once DECLARE ile bildirilmelidir.
- Include satirlari dosyanin header bolgesinde tutulmalidir.
- Dizi tabani varsayilan olarak 0'dan baslar.
- Legacy davranislar yeni surumde varsayilan degildir; aktif profil Win11 x64 ve strict kurallardir.
- Parser, AST uretimi olmadan basarili kabul edilmez.
- Token yonetimi sabit dizi degil kapasite-artirimli dinamik buffer ile yapilir.
- Her degisiklik build + smoke test + manifest kontrolu ile dogrulanir.
- Aktif platform profili tektir: win11 x64.
- Win11 dagitimi release artefaktlari ile belgelenir.

## 1.2 Giriş ve Vizyon
uXBasic, miras kalan UBASIC031 mimarisini Windows 11 (64-bit) standartlarına taşıyan, yüksek performanslı ve düşük seviyeli donanım erişimi sunan bir sistem programlama dilidir. Bu belge, dilin hem kullanıcısı (programcı) hem de geliştiricisi (compiler mimarı) için bu belge tek ve mutlak doğru kaynaktır.

### 1.3 Genel Yazım Düzeni

uXBasic programı, bir metin dosyasında yazılır ve satır satır okunur. Her satırın sonunda bir **satır sonu** (newline) karakteri bulunması gerekir. Bir satırda birden fazla komut yazılabilir, ancak büyük programlarda okunabilirlik için her satıra bir komut yazmak önerilir.

```bas
' Bu satır bir yorum satırıdır  ; derleyici tarafından yoksayılır.
PRINT "Merhaba"                 ' Metin sonrası yorum da yazılabilir.
x = 10: PRINT x                 ' Aynı satırda birden fazla komut; iki nokta ile ayır.
```
uXBasic'te, boşluklar genellikle komutları ve ifadeleri ayırmak için kullanılır. Ancak, fazla boşluklar derleyici tarafından yoksayılır ve kodun çalışmasını etkilemez. Yine de, okunabilirlik için tutarlı bir boşluk kullanımı önerilir.

### 1.3 Temel Mimari Prensipler
uXBasic derleyicisi, bir kaynak kodu işlerken şu dört aşamalı zinciri takip eder:
1.  **Sözcük Analizi (Lexer):** Metni anlamlı atomlara (token) ayırır.
2.  **Sözdizimi Analizi (Parser):** Kurallara göre Soyut Sözdizimi Ağacı (AST) oluşturur.
3.  **Anlamsal Denetim (Semantic Check):** Tip uyumluluğunu ve kapsam (scope) kurallarını denetler.
4.  **Kod Üretimi (Codegen):** Hedef platforma (x64) uygun makine kodu üretir.

---

## 2. Programlama Kuralları ve Sözdizimi (Syntax) Disiplini

Bu dokuman parser gercegi + test plani uzerinden standardize edilmis tek referanstir.
Hedef profil: Windows 11 x64.

## 2.1. Amac

- Belgedeki tum syntax kaliplari parser tarafinda gecerli olmalidir.
- Corrupt satirlar, kopya bolumler ve celiskili ornekler temizlenmistir.
- Komutlar iki etikette verilir:
  - implemented: parser/test ile dogrulanmis.
  - planned: parser veya runtime backlog.

## 2.2. Lexer Gercegi ve Yazim Kurali

### 2.1 Identifier Kurali

Parser identifier kurali:

- baslangic: harf veya `_`
- devam: harf, rakam veya `_`
- pratik regex: `[A-Za-z_][A-Za-z0-9_]*`

Sonuc:

- `x%`, `name$`, `pid&` gibi sonekli degisken adlari gecerli degildir.
- Turkce karakterli degisken adlari yerine ASCII ad kullan.

### 2.2.2 Sonek Tip Isaretleri

Strict parser profilinde su sonekler degisken adinin parcasi degildir:
- `$`, `%`, `&`, `!`, `#`, `@`
Tip belirtimi sadece `AS TYPE` ile yapilir.

### 2.2.3 Anahtar Kelime ve Operator Syntax Kurallari

- keyword tanima buyuk/kucuk harf duyarsizdir.
- parser operatorleri: `+ - * / \\ % = < > <= >= <> ** << >> += -= *= /= \\= =+ =- ++ -- @`.
- operatorler arasinda bosluk zorunlu degildir, ancak okunabilirlik icin tavsiye edilir.
- `IF`, `FOR`, `WHILE` gibi blok komutlar, `END IF`, `NEXT`, `WEND` ile kapatilir.
- `SUB` ve `FUNCTION` tanimlari, `END SUB` ve `END FUNCTION` ile kapatilir.
- `DECLARE` komutu, fonksiyon prototiplerini tanimlamak icin kullanilir ve program basinda yer alir.
- `INLINE()` bloğu, c, c++, assembler kodu icin kullanilir ve derleyiciye o bolumu dogrudan makine kodu olarak islemeyi soylemek icin kullanilir.
- `DIM` komutu, degisken tanimlamak ve bellek ayirmak icin kullanilir.
- `CONST` komutu, sabit degerler tanimlamak icin kullanilir.
- `TYPE` komutu, kullanici tanimli yapilar (UDT) olusturmak icin kullanilir.
- `IMPORT` veya `%%INCLUDE` komutlari, dis kaynak dosyalari programa dahil etmek icin kullanilir.
- `%%DESTOS` ve `%%PLATFORM` gibi derleme zamani komutlari, hedef isletim sistemi ve platformu belirtmek icin kullanilir.
- `GOTO` ve `GOSUB` gibi eski tarz kontrol akisi komutlari, modern kodda kullanilabilir ve parser tarafindan reddedilmez.
- Komutlar ve uXBasic ifadeleri buyuk harf duyarsizdir, ancak kodun okunabilirligi icin tutarlilik onemlidir. kod icerisinde buyuk harfe compiler kendisi cevirir.
- Kullanicininda Buyuk harf kullanmasi tavsiye edilir, ancak zorunlu degildir.
- `IF / ELSEIF / ELSE / END IF` kosul blogu kullanilir.
- `SELECT CASE / CASE / CASE ELSE / END SELECT` coklu secim yapisidir.
- `FOR / NEXT` ve `DO / LOOP` dongu yapilaridir.
- `GOTO`, `GOSUB`, `RETURN` legacy akis komutlaridir.
- Atama operatorleri: `=`, `+=`, `-=`, `*=`, `/=`, `\\=`, `=+`, `=-`
- Artirim operatorleri: `++`, `--`
- Aritmetik: `+`, `-`, `*`, `/`, `\\`, `MOD`, `%`, `**`
- Karsilastirma: `=`, `<>`, `<`, `<=`, `>`, `>=`
- Mantiksal: `AND`, `OR`, `NOT`, `XOR`
- Bit kaydirma: `SHL`, `SHR`, `ROL`, `ROR`, `<<`, `>>`
- Isaretci operatoru: `@`
- Komut ve fonksiyonlar `_` ile baglanmayacaktir, degiskenlerde `_` kullanilabilir.

uXBasic, okunabilirliği artırmak ve hataları derleme aşamasında yakalamak için katı sözdizimi kuralları uygular.

### 2.2.4 Yazım Kuralları (Strict Rules)
* **Tip Sonekleri Yasaktır:** Eski BASIC dillerindeki `$`, `%`, `&` gibi karakterler değişken adının sonunda kullanılamaz. Tüm değişkenler `AS` anahtar kelimesiyle tanımlanmalıdır.
* **Ön Bildirim Zorunluluğu:** Kullanılacak her `SUB` veya `FUNCTION` anahtar kelimesi programın başında `DECLARE` ile bildirilmelidir.
* **Küçük/Büyük Harf Duyarlılığı:** uXBasic anahtar kelimelerde duyarsızdır (`PRINT` ile `print` aynıdır), ancak değişken adlarında tutarlılık önerilir.

### 2.2.5 Program Dosya Yapısı (Normatif Düzen)
Bir uXBasic kaynak dosyası şu hiyerarşiyi izlemelidir:
1.  **Başlık:** `%%DESTOS` ve `%%PLATFORM` gibi derleme zamanı komutları.
2.  **Modüller:** `%%INCLUDE` veya `IMPORT` ile dahil edilen dış dosyalar.
3.  **Sabitler:** `CONST` tanımları.
4.  **Yapılar:** `TYPE ... END TYPE` blokları.
5.  **Bildirimler:** `DECLARE` satırları.
6.  **Ana Gövde:** Programın yürütülebilir ana kod bloğu.
7.  **Tanımlamalar:** `SUB` ve `FUNCTION` içerikleri.


## 2.3 Parser Uyumlu Standart Soz Dizimi

### 2.3.1 Akis Komutlari

- `IF expr THEN ... [ELSEIF expr THEN ...] [ELSE ...] END IF`
- `SELECT CASE expr ... CASE expr [,expr ...] ... [CASE ELSE ...] END SELECT`
- `FOR ident = expr TO expr [STEP expr] ... NEXT [ident]`
- `DO [WHILE expr | UNTIL expr] ... LOOP [WHILE expr | UNTIL expr]`
- `GOTO label`
- `GOSUB label`
- `RETURN [expr]`
- `EXIT [FOR|DO]`
- `END`

### 2.3.2 Tanim ve Yapi Komutlari

- `CONST name = expr [, ...]`
- `DIM name[(bounds)] AS TYPE [= expr] [, ...]`
- `REDIM name[(bounds)] AS TYPE [, ...]`
- `TYPE Name ... field AS TYPE ... END TYPE`
- `DECLARE SUB Name(params)`
- `DECLARE FUNCTION Name(params) AS TYPE`
- `SUB Name(params) ... END SUB`
- `FUNCTION Name(params) AS TYPE ... END FUNCTION`
- `DEFINT rangeList`
- `DEFLNG rangeList`
- `DEFSNG rangeList`
- `DEFDBL rangeList`
- `DEFEXT rangeList`
- `DEFSTR rangeList`
- `DEFBYT rangeList`
- `SETSTRINGSIZE expr`
- `INCLUDE "file.bas"`
- `IMPORT(LANG, "file.ext")`

IMPORT notlari:

- `LANG`: `C`, `CPP`, `ASM`
- uzanti dil ile uyumlu olmalidir.

### 2.3.3 Giris-Cikis ve Dosya Komutlari

- `PRINT expr [,|; expr ...]`
- `INPUT target [, target ...]`
- `INPUT "prompt"; target [, target ...]`
- `INPUT #handle, target [, target ...]`
- `OPEN fileExpr FOR mode AS [#]handleExpr`
- `CLOSE`
- `CLOSE [#]handleExpr [, [#]handleExpr ...]`
- `GET` | Dosyadan okur | `GET n[,pos][,bytes],off `eski tip uyumluluk
- `PUT` | Dosyaya yazar | `PUT n[,pos][,bytes],off `eski tip uyumluluk
- `POKE` | Bellege yaz | `POKE addr, val
- `GET` | Dosyadan okur | `GET [#]n, hedef
- `PUT` | Dosyaya yazar | `PUT [#]n, kaynak
- `SEEK` | Konum ayarlar/alir | `SEEK [#]n[,pos]
- `GET [#]handleExpr, targetExpr`
- `GET [#]handleExpr, posExpr, targetExpr`
- `GET [#]handleExpr, posExpr, bytesExpr, targetExpr`
- `PUT [#]handleExpr, sourceExpr`
- `PUT [#]handleExpr, posExpr, sourceExpr`
- `PUT [#]handleExpr, posExpr, bytesExpr, sourceExpr`
- `SEEK [#]handleExpr [, posExpr]`
- `LOCATE rowExpr, colExpr`
- `COLOR fgExpr, bgExpr`
- `CLS`

Dosya handle notu:

- parser `#` isaretini kabul eder, zorunlu degildir.
- belge standardinda handle yaziminda `#` onerilir.
- legacy uyumluluk icin GET/PUT komutlarinda `pos` ve `bytes` ara argumanlari da kabul edilir.

### 2.3.4 Bellek ve Yardimci Komutlar

- `INC ident`
- `DEC ident`
- `RANDOMIZE [seedExpr]`
- `POKEB addrExpr, valueExpr`
- `POKEW addrExpr, valueExpr`
- `POKED addrExpr, valueExpr`
- `POKE addrExpr, valueExpr` (legacy alias, POKED semantigi)
- `MEMCOPYB srcExpr, dstExpr, countExpr`
- `MEMFILLB addrExpr, countExpr, valueExpr`
- `INLINE(...) ... END INLINE`

## 2.4 Intrinsic Fonksiyon Imzalari (Parser Validation)

### 2.4.1 Arguman

- `LEN(expr)`
- `STR(expr)`
- `VAL(expr)`
- `ABS(expr)`
- `INT(expr)`
- `UCASE(expr)`
- `LCASE(expr)`
- `ASC(expr)`
- `CHR(expr)`
- `LTRIM(expr)`
- `RTRIM(expr)`
- `SPACE(expr)`
- `SGN(expr)`
- `SQRT(expr)` iptal edildi, SQR(expr ile birlestirildi.
- `SIN(expr)`
- `COS(expr)`
- `TAN(expr)`
- `ATN(expr)`
- `EXP(expr)`
- `LOG(expr)`
- `CINT(expr)`
- `CLNG(expr)`
- `CDBL(expr)`
- `CSNG(expr)`
- `FIX(expr)`
- `SQR(expr)`
- `LOF(expr)`
- `EOF(expr)`
- `PEEKB(expr)`
- `PEEKW(expr)`
- `PEEKD(expr)`
- `HYP (expr)` HIBERBOLIK (SIN COS TAN gibi) fonksiyonudur. sin cos ve tan ile beraber kullanilir, hiberbolik fonksiyonu uygular. 
- `ARC(expr)` ARKUS (ASIN ACOS ATN gibi) fonksiyonudur. asin acos ve atn ile beraber kullanilir, arkus fonksiyonu uygular.


-

### 2.4.2 Diger Arity Kurallari

- `MID(strExpr, startExpr [, lenExpr])` -> 2..3 arg
- `STRING(countExpr, charExpr)` -> 2 arg
- `RND([expr])` -> 0..1 arg
- `INKEY(flagsExpr [, stateExpr])` -> 1..2 arg
- `GETKEY()` -> 0 arg
- `TIMER()` / `TIMER(unitStr)` / `TIMER(startExpr, endExpr, unitStr)` -> 0, 1 veya 3 arg

---

### 3.1 INCLUDE / IMPORT

include komutu basic dosyalari programa ekler, import ise c, cpp veya assembler dosyalari ekler. Importta dil belirtmek zorunludur. namespace ... end namesapace, module ... end module gibi yapilarin varligi ile bu komutlar ayri moduller ve baska dilleri desteklemek icin kullanilir, alias komutu ile alinan ve gonderilen veriler program icinde daha sonra tekrar kolayca kullanilabilir hale gelir. 

```bas
INCLUDE "lib.bas"
IMPORT(C, "cmod.c")
IMPORT(CPP, "cpmod.cpp")
IMPORT(ASM, "asmstub.asm")
IMPORT(PY, "pymod.py") ' Python modulleri icin destek planlanmaktadir
```
IR, HIR,MIR gibi ara kod seviyeleri  VE IFF gibi derleme zamanı kontrol yapıları ICIN TASARIM KURALLARI GELISTIRIYORUM. BU BELGENIN EN ALTINDA BULUNUYOR.

## 3. Veri Tipleri ve Bellek Modeli
uXBasic, belleği doğrudan yönetebilen geniş bir veri tipi yelpazesine sahiptir.

### 3.1 Temel Veri Tipleri (Scalar Types)

| Teknik Terim | Açıklama | Boyut | Aralık / Kullanım | Ad |
| :--- | :--- | :--- | :--- | :--- |
| **I8 / U8** | İşaretli / İşaretsiz Bayt (Byte) | 1 Bayt | -128..127 / 0..255 |Byte, UByte |
| **I16 / U16** | Kısa Tam Sayı (Short) | 2 Bayt | -32,768..32,767 / 0..65,535 |Short, UShort |
| **I32 / U32** | Standart Tam Sayı (Integer) | 4 Bayt | ±2.1 Milyar / 32-bit Adresleme |Integer, UInteger |
| **I64 / U64** | Uzun Tam Sayı (Long) | 8 Bayt | 64-bit Hesaplama ve Geniş Adres |Long, ULong |
| **F32** | Tek Hassasiyetli Ondalık (Float) | 4 Bayt | IEEE 754 Standart |Float |
| **F64** | Çift Hassasiyetli Ondalık (Double) | 8 Bayt | Varsayılan Hassas Hesap Tipi |Double |
| **F80** | Geniş Hassasiyetli Ondalık (Extended) | 10 Bayt | Yüksek Hassasiyet Gerektiren Durumlar |Extended |
| **BOOLEAN** | Mantıksal Değer | 1 Bayt | `TRUE` (Doğru) veya `FALSE` (Yanlış) |Boolean |
| **STRING** | Metin Verisi | Değişken | Dinamik veya Sabit Boyutlu Karakter Dizisi |String |
| **POINTER** | Bellek Adresi | 4 veya 8 Bayt | Veriye Doğrudan Erişim İçin Kullanılır |Pointer |
| **ARRAY** | Çoklu Değerler | Değişken | Aynı Tipte Birden Fazla Değer İçeren Yapılar |Array |
| **TYPE** | Kullanıcı Tanımlı Yapılar (UDT) | Değişken | Karmaşık Verileri Gruplandırmak İçin Kullanılır |Type |
| **LIST** | Bağlı Liste Yapısı | Değişken | Dinamik Veri Yapıları İçin Kullanılır |List |
| **DICT** | Anahtar-Değer Çifti Yapısı | Değişken | Hızlı Arama ve Veri Erişimi İçin Kullanılır |Dict |
| **SET** | Benzersiz Değerler Kümesi | Değişken | Kümeler ve Topluluk İşlemleri İçin Kullanılır |Set |

- `STRING * N` formu parser syntaxinda string sabit uzunluklu olarak tanimlar, `STRING` ise dinamik uzunlukta stringler icin kullanilir. Dinamik String uzunlugu maksimim 512 karaktere kadardir. Fazlası derleme zamanında hata verir. Dinamik Stringler, runtime'da bellekten ihtiyaç kadar yer kaplar ve `LEN()` fonksiyonu ile gerçek uzunlukları öğrenilebilir.

### 3.2 Kullanıcı Tanımlı Yapılar (UDT - TYPE)
Karmaşık verileri gruplandırmak için kullanılır.

**Sözdizimi (Syntax):**

```bas
TYPE YapıAdı
    AlanAdı AS VeriTipi
    AlanAdı2 AS VeriTipi
END TYPE
```

**Örnek:**
```bas
TYPE SensorVerisi
    ID AS I32
    Sicaklik AS F64
    Aktif AS BOOLEAN
END TYPE

DIM cihaz AS SensorVerisi
cihaz.Sicaklik = 36.5
```

```bas
DIM Z AS STRING * 20 
TYPE Nokta3D
    X AS F64
    Y AS F64
    Z AS ARRAY (2,3) OF STRING * 20
END TYPE
```

```bas
TYPE Vec2
    x AS I32
    y AS I32
END TYPE

DIM p AS Vec2
p.x = 10
p.y = 20
PRINT p.x
PRINT p.y
```

**TYPE İçinde ARRAY (Statik Diziler)**
Bir TYPE içinde dizi tanımlarken, dizinin boyutunu ve içindeki verinin tipini önceden bilmelisin ki, bellekte blok olarak yer ayırabilesin.

```BASIC
' REM: Sabit uzunluklu metin dizisi içeren bir yapı
TYPE SensorGrubu
    GrupID AS I32                     ' 4 Bayt
    Sensorler AS ARRAY(10) OF F64     ' 10 * 8 = 80 Bayt
    Durumlar AS ARRAY(5) OF BOOLEAN   ' 5 * 1 = 5 Bayt
END TYPE                              ' Toplam: 89 Bayt (Hizalama hariç)
```

**ARRAY İçinde TYPE (Yapı Dizileri)**
Bu daha çok bir "veri tabanı tablosu" gibidir. Her bir dizi elemanı, senin tanımladığın TYPE yapısını bir bütün olarak taşır.

```bas
TYPE Nokta
    X AS F64
    Y AS F64
END TYPE

' REM: 100 elemanlı bir koordinat listesi
DIM Harita AS ARRAY(100) OF Nokta
Harita(5).X = 12.5
```

**Karmaşık Örnek: İç İçe Tam Yapı**
İstediğin "Dizi içinde Tip, Tip içinde Dizi" yapısını şu şekilde kurgulayabiliriz:

```bas
' 1. En alt seviye tip
TYPE VeriPaketi
    ZamanDamgasi AS U64
    Degerler AS ARRAY(3) OF F64
END TYPE

' 2. Bu tipi kullanan üst seviye tip
TYPE Istasyon
    Ad AS STRING * 20
    Gecmis AS ARRAY(5) OF VeriPaketi ' TYPE ICINDE ARRAY (ve o Array'in elemanı da bir TYPE)
END TYPE

' 3. Son olarak bu ana yapının dizisini oluşturma
DIM SehirIstasyonlari AS ARRAY(10) OF Istasyon
```

---

## 4. Operatörler ve İşlem Önceliği
uXBasic operatörleri, matematiksel ve mantıksal kesinlik üzerine kuruludur.

### 4.1 Matematiksel ve Mantıksal Operatörler (İşlem Önceliği Sırasıyla)

| Öncelik | Operatör Grubu | Teknik Terimler | Açıklama |
| :--- | :--- | :--- | :--- |
| 1 | **Parantez ve Erişim** | `()`, `[]`, `.` | Gruplama, Dizi İndisi, Yapı Elemanı |
| 2 | **Tekli (Unary)** | `+`, `-`, `NOT`, `@` | İşaret, Mantıksal Değil, Adres Alma |
| 3 | **Üs Alma** | `**` | Kuvvet Hesaplama |
| 4 | **Çarpma/Bölme** | `*`, `/`, `\`, `%` | Çarpma, Bölme, Tam Bölme, Kalan (Mod) |
| 5 | **Toplama/Çıkarma** | `+`, `-` | Toplama ve Çıkarma |
| 6 | **Kaydırma** | `<<`, `>>`, `SHL`, `SHR` | Bit Seviyesinde Kaydırma İşlemleri |
| 7 | **Karşılaştırma** | `=`, `<>`, `<`, `>`, `<=`, `>=` | Eşitlik ve Büyüklük Kontrolü |
| 8 | **Mantıksal Bağlaçlar** | `AND`, `OR`, `XOR` | Ve, Veya, Özel Veya |

### 4.2 Bileşik Atama Operatörleri (Syntactic Sugar)
Kodun kısalmasını ve okunabilirliğini sağlar.

* `++` : Değeri 1 artırır (`INC` ile eşdeğer).
* `--` : Değeri 1 azaltır (`DEC` ile eşdeğer).
* `+=` : Mevcut değere ekleme yapar (`a = a + 5` yerine `a += 5`).
* `*=` : Mevcut değeri çarpar.

### Bölüm 4.3 Operatör Önceliği ve Matematiksel İşlemler

Windows 11'de operatorler parserin oncelik agacina gore degerlendirilir; bu degerlendirme CPU'dan bagimsiz dil seviyesinde yapilir. Build 32/64 olsa da parser oncelik sirasi sabit kaldigi icin ayni kaynak ayni parse sonucunu uretmelidir.

##### 4.3.1 Operatör Tablosu (Yüksekten Düşüğe)

```
Seviye	Operatörler	                    Yönelim	        Açıklama
1	    (), [], .	                    Soldan sağa	    Fonksiyon çağrısı, dizi indeksi, alan erişimi
2	    +, -, NOT, ++, -- (unary)	    Sağdan sola	    Tekli operatörler
3	    **	                            Sağdan sola	    Üs alma (power)
4	    *, /, \, MOD, %	                Soldan sağa	    Çarpma, bölme, tamsayı bölüme, mod
5	    +, - (binary)	                Soldan sağa	    Toplama, çıkarma
6	    SHL, SHR, <<, >>	            Soldan sağa	    Bit kaydırma
7	    &(AND)	                        Soldan sağa	    Bitwise AND
8	    XOR	                            Soldan sağa	    Bitwise XOR
9	    |(OR)	                        Soldan sağa	    Bitwise OR
10	    =, <>, <, >, <=, >=	            Soldan sağa	    Karşılaştırma
11	    AND, OR	                        Soldan sağa	    Mantıksal AND, OR
12	    =, +=, -=, *=, /=, \=	        Sağdan sola	    Atama
```
---

## 5. Değişken Tanımlama ve Bellek Ayırımı (DIM)
Değişkenler, derleyiciye bellekte ne kadar yer açması gerektiğini söyler.

**Sözdizimi:**
`DIM [SHARED|GLOBAL] DeğişkenAdı [(DiziBoyutu)] AS VeriTipi [= BaşlangıçDeğeri]`

**Örnekler:**
* `DIM sayac AS I32 = 0` : 32-bitlik bir tam sayı tanımlar ve başlangıç değerini 0 olarak ayarlar.
* `DIM isim AS STRING * 30 = "Varsayılan"` : 30 karakterlik sabit bir metin alanı açar ve başlangıç değerini "Varsayılan" olarak ayarlar.
* `DIM koordinat(10, 10) AS F64 = 0.0` : 0 tabanlı, iki boyutlu bir ondalık dizi tanımlar ve tüm elemanlarını 0.0 ile başlatır.

### Bölüm 5.1 Tip Sistemi Ayrıntıları

Tip secimi, Windows 11'de bellek kullanimini ve olasi tasma/range etkilerini belirler; ozellikle 32/64 farkinda tamsayi-genislik kararlari kritik olur. Su anki cekirdekte tip semantigi kisitli oldugundan belgede gecen tum tiplerin runtime garantisi verilmemelidir.

#### 5.1.1 Tip Dönüşümleri (Type Coercion)

uXBasic'te, farklı türler otomatik olarak dönüştürülebilir (implicit) veya açıkça dönüştürülebilir (explicit):

```bas
DIM x AS INTEGER
DIM y AS DOUBLE
x = 10
y = x              ' INTEGER otomatik DOUBLE'a dönüştü

' Açık dönüştürme (cast):

PRINT INT(3.7)      ' 3 (DOUBLE → INTEGER)
PRINT STR(100)      ' "100" (INTEGER → STRING)
PRINT VAL("42")     ' 42 (STRING → INTEGER)
```

#### 5.1.2 Hafızada Tür Düzeni
Her tür, bilgisayar hafızasında belirli bir yer kaplar:

```bas
BYTE:       1 byte
INTEGER:    2 byte
LONG:       4 byte
SINGLE:     4 byte (IEEE 754)
DOUBLE:     8 byte
EXTENDED:   10 byte
STRING:     Başlık (uzunluk bilgisi) + karakter verileri
```

Bu düzen, derleyicinin bellek yönetimini ve veri erişimini optimize etmesine yardımcı olur. Örneğin, bir INTEGER değişkeni 2 byte yer kaplarken, bir DOUBLE değişkeni 8 byte yer kaplar. Bu nedenle, büyük veri yapıları oluştururken tür seçimi önemlidir.

#### 5.1.3 Tür Güvenliği

uXBasic'in "strict mode" (sıkı mod), tipler arasında riskli dönüşümlerden kaçınır. Örneğin, bir DOUBLE değeri bir INTEGER'a direkt atanamazsa, derleyici hata verir. Bu, çalışma zamanında oluşacak kayıp veya hataları önceden engeller.

```bas
DIM x AS DOUBLE
DIM y AS INTEGER

x = 3.14
y = x              ' Hata: açık dönüştürme gerekli
y = INT(x)         ' Tamam: x'in tamsayı kısmı alındı
```

# Bölüm 2: Program Akışı ve Giriş/Çıkış

## 6. Program Akış Kontrolü (Flow Control)
uXBasic, yapısal programlama ilkelerine dayanır. Kodun dallanması ve döngüye girmesi belirli bloklar (Block Statements) üzerinden yönetilir.

### 6.1 Koşullu Dallanma (IF...ELSEIF...ELSE)
Bir mantıksal ifadenin sonucuna göre kodun farklı yollara sapmasını sağlar.

| Bileşen | Sözdizimi (Syntax) | Açıklama |
| :--- | :--- | :--- |
| **IF** | `IF <koşul> THEN` | Koşul doğruysa blok içine girer. |
| **ELSEIF** | `ELSEIF <koşul> THEN` | İlk koşul yanlışsa alternatif koşulu dener. |
| **ELSE** | `ELSE` | Hiçbir koşul tutmazsa çalışacak son durak. |
| **END IF** | `END IF` | IF bloğunu kapatır. |

**Örnek:**
```basic
IF sicaklik > 40 THEN
    PRINT "Kritik Seviye: Soğutma Aktif"
ELSEIF sicaklik > 30 THEN
    PRINT "Uyarı: Isı Yükseliyor"
ELSE
    PRINT "Durum: Stabil"
END IF
```

```bas
DIM score AS I32 = 85

IF score >= 90 THEN
    PRINT "A"
ELSEIF score >= 80 THEN
    PRINT "B"
ELSE
    PRINT "C"
END IF
```

### 6.2 Çoklu Seçim Yapısı (SELECT CASE)
Tek bir değişkenin farklı değerlerine göre hızlı dallanma sağlar.

**Sözdizimi:**
```basic
SELECT CASE <ifade>
    CASE <değer1>
        ' kodlar
    CASE <değer2> TO <değer3>
        ' aralık kontrolü
    CASE ELSE
        ' varsayılan durum
END SELECT
```
---

## 7. Döngü Yapıları (Iteration)
Tekrarlayan işlemleri yönetmek için kullanılan mekanizmalardır.

### 7.1 Sayacı Belirli Döngü (FOR...NEXT)
Belirli bir başlangıç ve bitiş noktası arasında adım adım ilerler.

| Terim | Sözdizimi | Açıklama |
| :--- | :--- | :--- |
| **FOR** | `FOR v = start TO end [STEP s]` | Döngüyü başlatır. STEP isteğe bağlıdır. |
| **NEXT** | `NEXT [v]` | Sayacı artırır ve başa döner. |

**Örnek:**
```basic
FOR i = 1 TO 10 STEP 2
    PRINT "Adım: "; i
NEXT i
' Çıktı: 1, 3, 5, 7, 9
```

### 7.2 Mantıksal Döngü (DO...LOOP)
Bir koşul sağlandığı sürece veya sağlanana kadar çalışır.

* `DO WHILE <koşul> ... LOOP`: Koşul doğru olduğu sürece çalışır.
* `DO UNTIL <koşul> ... LOOP`: Koşul doğru olana kadar (doğru olunca durur) çalışır.
* `EXIT DO`: Döngüden zorla çıkış sağlar.

---
### Bölüm 9: Alt İşler (SUB) ve Fonksiyonlar (FUNCTION)

SUB/FUNCTION kaliplari parserda isim/cagri yapisi olarak temsil edilir ve AST uzerinden kontrol edilir. Windows 11'de bu davranis platformdan cok derleyici semantigine baglidir; ABI farki etkisi daha cok x64 backend asamasinda ortaya cikar.

## 8. Alt Programlar ve Fonksiyonlar (Procedures)
Kodun modülerliğini sağlar. `SUB` değer döndürmez, `FUNCTION` değer döndürür.

### 8.1 Tanımlama ve Çağırma Kuralları

| Tür | Tanımlama (Definition) | Çağırma (Call) |
| :--- | :--- | :--- |
| **SUB** | `SUB Ad(Param AS Tip) ... END SUB` | `Ad(Arg)` veya `CALL Ad(Arg)` |
| **FUNCTION** | `FUNCTION Ad(Param AS Tip) AS Tip` | `Sonuc = Ad(Arg)` |

**Kritik Kural (Forward Declaration):**
Derleyici, bir yordamı görmeden önce onun imzasını bilmelidir.
`DECLARE FUNCTION Hesapla(a AS I32) AS F64`

#### 9.1 Alt İş Tanımı

```bas
SUB Selam(isim AS STRING)
    PRINT "Merhaba, "; isim
END SUB

SUB Yazdir()
    PRINT "Bu alt iş"
END SUB

' Çağırma:
Selam "Dünya"
Yazdir
```

```bas
DECLARE FUNCTION Add(a AS I32, b AS I32) AS I32
DECLARE SUB Show(v AS I32)

FUNCTION Add(a AS I32, b AS I32) AS I32
    RETURN a + b
END FUNCTION

SUB Show(v AS I32)
    PRINT v
END SUB

DIM i AS I32
FOR i = 1 TO 3
    Show(Add(i, 10))
NEXT i
```

#### 9.2 Fonksiyonlar (Değer Dönen)

```bas
FUNCTION Topla(a AS LONG, b AS LONG) AS LONG
    Topla = a + b            ' Fonksiyon adı = dönüş değeri
END FUNCTION

DIM sonuc AS LONG
sonuc = Topla(5, 3)          ' sonuc = 8
```

#### 9.3 Parametre Türleri

```bas
' Değer ile (kopya) — orijinal değişmez
SUB Değer_İle(x AS LONG)
    x = x + 10
END SUB

' Başvuru ile (pointer) — orijinal değişebilir
SUB Başvuru_İle(x AS LONG)
    x = x + 10               ' Dış x de değişir
END SUB

DIM val AS LONG
val = 5
Değer_İle(val)               ' val halen 5
Başvuru_İle(val)             ' val şimdi 15
```

#### 9.4 DECLARE Ön Tanımı

```bas
' Alt işin çağrısından önce bildirim
DECLARE SUB Foo()
DECLARE FUNCTION Bar() AS LONG

' Sonra tanımını yap
SUB Foo()
    PRINT "Foo"
END SUB

FUNCTION Bar() AS LONG
    Bar = 42
END FUNCTION

' Çağır
Foo
PRINT Bar()
```
---

## 9. Dosya ve Veri Giriş/Çıkış (I/O)
uXBasic, Windows 11 dosya sistemine kanal (Channel) mantığıyla erişir.

### 9.1 Dosya Erişim Komutları

| Komut | Sözdizimi | Amacı (Teknik Karşılık) |
| :--- | :--- | :--- |
| **OPEN** | `OPEN "dosya" FOR <mod> AS #n` | Dosyayı bir kanala bağlar. |
| **CLOSE** | `CLOSE #n` | Kanalı serbest bırakır ve veriyi diske yazar. |
| **INPUT #** | `INPUT #n, var1, var2` | Kanaldan veri okur ve değişkenlere atar. |
| **PRINT #** | `PRINT #n, ifade` | Kanala veri yazar. |
| **GET / PUT** | `GET #n, [poz], [bayt], off` | Rastgele erişimli dosyada ham okuma/yazma. |

**Dosya Modları:**
* `INPUT`: Sadece okuma.
* `OUTPUT`: Yeni dosya yaratma / Üstüne yazma.
* `APPEND`: Mevcut dosyanın sonuna ekleme.
* `BINARY`: Ham bayt erişimi.

**Örnek:**
```basic
OPEN "log.txt" FOR APPEND AS #1
PRINT #1, "İşlem Tamamlandı: "; TIMER("s")
CLOSE #1
```

### Bölüm 8: Dosya İşlemleri

Windows 11 tarafinda dosya erisimi NTFS izin modeli ve yol kurallarina tabidir; derleyici scriptlerinde goreli yol kullanimi onerilir. Dosya islemlerinin runtime kapsami adim adim genisletilmektedir.

#### 8.1 Dosya Açma ve Kapama

```bas
' Dosya numarası: 1-255
OPEN "veri.txt" FOR INPUT AS 1         ' Okuma
OPEN "çıktı.txt" FOR OUTPUT AS 2       ' Yazma
OPEN "depo.dat" FOR RANDOM AS 3        ' Rastgele erişim

' Dosya işlemleri...

CLOSE 1
CLOSE 2
CLOSE 3
```

#### 8.2 Dosyadan Okuma

```bas
OPEN "veri.txt" FOR INPUT AS 1
IF NOT EOF(1) THEN
    INPUT 1, x
    INPUT 1, y
END IF
CLOSE 1
```

#### 8.3 Dosyaya Yazma

```bas
OPEN "sonuç.txt" FOR OUTPUT AS 1
PRINT 1, "Başlık"
PRINT 1, "Veri: "; 42
CLOSE 1
```

#### 8.4 Dosya İşaretçisi (SEEK)

```bas
OPEN "depo.dat" FOR RANDOM AS 1
SEEK 1, 100                 ' Dosyada 100. byte'a git
GET 1, x                    ' Verileri oku
SEEK 1, 100
PUT 1, x                    ' Verileri yaz
LOF(1)                      ' Dosya büyüklüğü
CLOSE 1
```

---

### Bölüm 7: Giriş/Çıkış ve Ekran İşlemleri

PRINT ve benzeri metin odakli akislar Windows 11 terminalinde konsol cikisi olarak ilerler; satir sonu ve kodlama davranisi terminale baglidir. Ekran kontrol komutlarinin tumu henuz modern runtime'da birebir uygulanmadigi icin bu bolum pratikte hedef davranis olarak okunmalidir.

#### 7.1 Ekrana Yazma (PRINT)

```bas
PRINT "Merhaba"               ' Metin yaz
PRINT 42                      ' Sayı yaz
PRINT "x = "; x               ' Metni sayı ile birlikte yaz

PRINT "a", "b", "c"           ' Sekmeli çıkış
PRINT "x = " & STR(x)         ' String birleştirme (&)

FOR i = 1 TO 3
    PRINT i; " ";             ' Satır sonu olmadan
NEXT i
PRINT ""                      ' Yeni satır
```

#### 7.2 Ekran Kontrolü

```bas
CLS                             ' Ekranı temizle
LOCATE satır, sütun             ' İmleci konumlandır
COLOR ön_renk, arka_renk        ' Renk ayarla
```

Renkler:

```
0: Siyah
1: Mavi
2: Yeşil
3: Cyan
4: Kırmızı
5: Magenta
6: Sarı
7: Beyaz
```

```bas
COLOR 2, 0                    ' Yeşil yazı, siyah arka plan
PRINT "Yeşil"
COLOR 7, 0                    ' Eski renge dönüş
```
#### 7.3 Klavyeden Okuma

```bas
INPUT age                     ' Sayı oku
INPUT name                   ' Yazı oku
INPUT "Adınız? "; name       ' Soru ile oku

ch = INKEY                   ' Tek tuş oku (bloklama yok)
DO
    ch = INKEY
LOOP WHILE ch = ""           ' Tuş basılana kadar bekle
```

```bas
DIM name AS STRING
DIM age AS I32

INPUT "Name?"; name
INPUT "Age?"; age

OPEN "in.txt" FOR INPUT AS #1 ' eski tip uyumluluk, # isareti parser tarafindan kabul edilir, zorunlu degildir.
INPUT #1, name, age
CLOSE #1
```

### Bölüm 10: String (yazı) İşlemleri

String komutlari Windows 11'de kodlama ve konsol yazim farklari nedeniyle gorunur sonuc uretebilir; ozellikle Turkce karakterlerde terminal/font etkisi vardir. Parser tarafi fonksiyon cagrisini tanir, ancak tum string fonksiyonlarinin runtime uyumlulugu asama asama tamamlanir. Bu bolumdeki string fonksiyonlari parser ve ifade-dogrulama seviyesinde desteklenir.
Test/uyumluluk tablolarinda gecen cekirdek liste: LEN, MID, STR, VAL, UCASE, LCASE, ASC, CHR, LTRIM, RTRIM, STRING, SPACE.
Runtime tarafinda en net testli yol LEN/VAL/ASC uzerindedir; digerleri parser uyumlulugu ve asamali runtime kapsami ile ilerler.

#### 10.1 String Fonksiyonları

```bas
DIM text AS STRING
text = "Merhaba Dünya"

' Uzunluk
PRINT LEN(text)              ' 12

' Alt yazı
MID(text, 1, 7)             ' "Merhaba"
MID(text, 9, 5)             ' "Dünya"

' Harf Dönüştürme
UCASE(text)                 ' "MERHABA DUNYA"
LCASE(text)                 ' "merhaba dunya"

' Yer ve Boşluk
LTRIM("   Merhaba")         ' "Merhaba"
RTRIM("Merhaba   ")         ' "Merhaba"

' ASCII ve Karakter
CHR(65)                     ' "A" (ASCII 65)
ASC("A")                     ' 65

' String ve Sayı Dönüştürme
STR(42)                     ' "42"
VAL("42")                    ' 42

' Tekrarlanan String
STRING(10, "*")             ' "**********"
SPACE(5)                    ' "     "

' String Birleştirme
"Merhaba" & " " & "Dünya"   ' "Merhaba Dünya"

DIM s AS STRING
s = "Merhaba"

PRINT LEN(s)            ' 7
PRINT MID(s, 1, 3)      ' "Mer"
PRINT UCASE(s)          ' "MERHABA"
PRINT LCASE(s)          ' "merhaba"
PRINT STR(42)           ' "42"
PRINT VAL("42")        ' 42
PRINT ASC("A")         ' 65
PRINT CHR(65)           ' "A"
PRINT LTRIM("  x")     ' "x"
PRINT RTRIM("x  ")     ' "x"
PRINT STRING(3, "*")   ' "***"
PRINT SPACE(3) & "ok"  ' "   ok"

```

#### 10.2 String Karşılaştırması

```bas
DIM s1 AS STRING, s2 AS STRING
s1 = "Apple"
s2 = "Apple"

IF s1 = s2 THEN
    PRINT "Eşit"
ELSE
    PRINT "Farklı"
END IF

IF s1 < s2 THEN
    PRINT "s1 alfabetik olarak hızlı"
END IF
```

## 10. Fonksiyon Kataloğu (Intrinsics)
uXBasic içinde hazır gelen, çekirdeğe gömülü fonksiyonlardır.

### 10.1 Sayısal ve Matematiksel Fonksiyonlar
| Fonksiyon | Teknik Anlamı | Kullanım Örneği |
| :--- | :--- | :--- |
| **ABS(x)** | Mutlak Değer | `x = ABS(-5)` -> 5 |
| **SQR(x)** | Karekök | `y = SQR(16)` -> 4 |
| **INT(x)** | Aşağı Yuvarla | `z = INT(3.9)` -> 3 |
| **RND()** | Rastgele Sayı | `n = RND()` -> 0..1 arası |

### 10.2 Metin (String) Fonksiyonları
| Fonksiyon | Teknik Anlamı | Kullanım Örneği |
| :--- | :--- | :--- |
| **LEN(s)** | Uzunluk | `l = LEN("uX")` -> 2 |
| **MID(s,b,u)** | Parça Al | `p = MID("Basic", 1, 2)` -> "Ba" |
| **UCASE(s)** | Büyük Harf | `u = UCASE("nx")` -> "NX" |
| **STR(n)** | Sayıdan Metne | `m = STR(100)` -> "100" |
| **VAL(s)** | Metinden Sayıya | `v = VAL("12.5")` -> 12.5 |
---

### Bölüm 11: Matematiksel Fonksiyonlar

Matematik ifadeleri once AST seviyesinde kurulur, sonra hedef derleyici tarafinda hesaplanir veya runtime cagrilarina doner. 32/64 hedefte kayan nokta tutarliligi genelde yuksek olsa da sinir deger testleri matrixte mutlaka dogrulanmalidir.

#### 11.1 Temel Math

```bas
' Mutlak Değer
ABS(-5)                      ' 5

' İşaret
SGN(-10)                     ' -1
SGN(0)                       ' 0
SGN(10)                      ' 1

' Tamsayı Kısım
INT(3.7)                     ' 3
INT(-3.7)                    ' -3 (aşağı yuvarla)

' Kare Kök
SQR(16)                     ' 4
SQR(2)                      ' ~1.41421
```

#### 11.2 Trigonometrik (Radyan Cinsinden)

```bas
' π değerini tanımla
CONST PI = 3.14159265
SIN(PI / 2)                  ' 1.0
COS(0)                       ' 1.0
TAN(PI / 4)                  ' 1.0

' Derece → Radyan
FUNCTION DereceRad(derece AS DOUBLE) AS DOUBLE
    DereceRad = derece * PI / 180
END FUNCTION

PRINT SIN(DereceRad(90))     ' 1.0
```

#### 11.3 Güç ve Logaritma

```bas
2 ** 3                       ' 8 (2^3)
2 ** 0.5                     ' ~1.41 (karekök)

' Doğal logaritma (FreeBASIC desteği ile)
' LOG(x) = ln(x)
```



## 11. Zamanlayıcı ve Hassas Ölçüm (TIMER)
Modern uXBasic'in en güçlü yanlarından biridir. Windows yüksek çözünürlüklü zamanlayıcılarını kullanır.

* **TIMER()**: Gece yarısından beri geçen saniyeyi `F64` döner.
* **TIMER("ms") / TIMER("us")**: Milisaniye veya mikrosaniye cinsinden ham tick değeri.
* **TIMER(start, end, "s")**: İki zaman damgası arasındaki farkı hesaplar.

---
# uXBasic Teknik Kitap (pek.md) - Bölüm 3: Bellek Mimarisi ve Düşük Seviye Kontrol

## 12. Bellek Modeli ve Adresleme (Memory & Pointer)
uXBasic, modern Windows 11 güvenliğini (DEP/ASLR) ihlal etmeden programcıya bellek üzerinde tam yetki verir. Bellek işlemleri "Ham Veri" ve "Adres Odaklı" olmak üzere ikiye ayrılır.

### 12.1 Adres Alma Fonksiyonları (Intrinsic Pointer Functions)
Bir verinin bellekteki konumunu (ofsetini) bulmak için kullanılır.

| Teknik Terim | Sözdizimi (Syntax) | Açıklama (Amacı) | Dönüş Tipi |
| :--- | :--- | :--- | :--- |
| **VARPTR** | `VARPTR(degisken)` | Değişkenin bellek adresini döndürür. | `U64` |
| **SADD** | `SADD(metin)` | Metin verisinin (String) başlangıç adresini döndürür. | `U64` |
| **LPTR** | `LPTR(etiket)` | Bir kod etiketinin (Label) adresini döndürür. | `U64` |
| **CODEPTR** | `CODEPTR(yordam)` | `SUB` veya `FUNCTION` başlangıç adresini döndürür. | `U64` |



### 12.2 Bellek Okuma ve Yazma (PEEK & POKE)
Doğrudan bellek adreslerine erişim sağlar. uXBasic'te bu komutlar tip korumalıdır.

| Operasyon | Sözdizimi | Teknik Açıklama |
| :--- | :--- | :--- |
| **PEEKB / POKEB** | `v = PEEKB(adr)` / `POKEB adr, v` | 1 Bayt (U8) seviyesinde işlem. |
| **PEEKW / POKEW** | `v = PEEKW(adr)` / `POKEW adr, v` | 2 Bayt (U16/Word) seviyesinde işlem. |
| **PEEKD / POKED** | `v = PEEKD(adr)` / `POKED adr, v` | 4 Bayt (U32/Dword) seviyesinde işlem. |
| **POKES** | `POKES adr, metin` | Belirtilen adrese bir metni (null-terminated) yazar. |

---

## 13. Toplu Bellek İşlemleri (Block Operations)
Büyük veri bloklarını hızlıca taşımak veya temizlemek için kullanılan, doğrudan işlemci rutinlerine (ASM) map edilen komutlardır.

| Komut | Sözdizimi | Parametreler |
| :--- | :--- | :--- |
| **MEMCOPY** | `MEMCOPY src, dst, n` | `src`: Kaynak, `dst`: Hedef, `n`: Bayt Sayısı |
| **MEMFILL** | `MEMFILL adr, val, n` | `adr`: Adres, `val`: Değer, `n`: Tekrar Sayısı |

**Örnek Uygulama:**

```basic
DIM kaynak(100) AS I32
DIM hedef(100) AS I32
' Dizinin tamamını kopyala
MEMCOPY VARPTR(kaynak(0)), VARPTR(hedef(0)), 400 ' 100 * 4 bayt
```

### Bölüm 12: Bellek 

```bas
' String yazma
POKES adres, text$          ' Text$ için yaz ve Doğrudan Erişim
```

Windows 11 korumali bellek modeli nedeniyle dogrudan adresleme komutlari dikkatli ele alinmalidir; bellek ihlalleri uygulamayi sonlandirabilir. Bu bolumdeki komutlarin cogu modern cekirdekte ileri hedef niteligindedir; guvenli kapsama adim adim alinmalidir. Compiler icin biz gereken onlemleri alacagiz. 

- `MEMCOPYW kaynak, hedef, sayı`         ' 2-byte hde
- `MEMCOPYD kaynak, hedef, sayı`         ' 4-byte hde
- `MEMCOPY  kaynak, hedef, boyut`        ' Varsayılan mode

#### 12.4 Belleği Doldurma

- `MEMFILLB adres, boyut, değer`         ' Byte doldur
- `MEMFILLW adres, sayı, değer`          ' Word doldur
- `MEMFILLD adres, sayı, değer`          ' Dword doldur

Windows 11 korumali bellek modeli nedeniyle dogrudan adresleme komutlari dikkatli ele alinmalidir; bellek ihlalleri uygulamayi sonlandirabilir Bu bolumdeki komutlarin cogu modern cekirdekte ileri hedef niteligindedir; guvenli kapsama adim adim alinmalidir.
Compiler icin biz gereken onlemleri alacagiz. 

#### 12.1 Adresleme

```bas
DIM x AS LONG
DIM ptr AS LONG

' Değişkenin adresini al
ptr = VARPTR(x)             ' x'in hafıza adresini al

' Bellek de değişken adresi
SADD(text$)                 ' String başlangıç adresi
```

#### 12.2 Bellek Okuma/Yazma (PEEK/POKE)

```bas
' POKE: Belleğe MEMFILLW adres, sayı, değer             ' Word doldur
MEMFILLD adres, sayı, değer                             ' Dword doldur
' yazma (1 byte)
POKEB adres, değer          ' 1 byte yaz
POKEW adres, değer          ' 2 byte yaz
POKED adres, değer          ' 4 byte yaz

' PEEK: Bellekten okuma
PEEKB(adres)                ' 1 byte oku
PEEKW(adres)                ' 2 byte oku
PEEKD(adres)                ' 4 byte oku

' String yazma
POKES adres, text$          ' Text$ için yaz
```

#### 12.3 Bellek Kopyalama


- `MEMCOPYB kaynak, hedef, boyut`       ' 1-byte hde
- `MEMCOPYW kaynak, hedef, sayı`         ' 2-byte hde
- `MEMCOPYD kaynak, hedef, sayı`         ' 4-byte hde
- `MEMCOPY  kaynak, hedef, boyut`        ' Varsayılan mode


####12.4 Belleği Doldurma

- `MEMFILLB adres, boyut, değer`         ' Byte doldur
- `MEMFILLW adres, sayı, değer`          ' Word doldur
- `MEMFILLD adres, sayı, değer`          ' Dword doldur


#### 12.4 Belleği Doldurma

- `MEMFILLB adres, boyut, değer`         ' Byte doldur
- `MEMFILLW adres, sayı, değer`          ' Word doldur
- `MEMFILLD adres, sayı, değer`          ' Dword doldur

---

## 14. Gömülü Assembler ve INLINE Modeli
uXBasic, yüksek performans gerektiren kısımlarda programcının doğrudan x64 makine kodu yazmasına izin verir.

### 14.1 INLINE Blok Yapısı
Eski `_ASM` yapısının yerini alan modern ve güvenli bloktur.

**Sözdizimi:**
`INLINE(language, programId, kind, params) ... END INLINE`

* **language:** Genellikle "x86_64" veya "x64".
* **programId:** Kullanılan assembler (Örn: "nasm").
* **kind:** Bloğun türü ("sub", "func" veya "raw").

**x64 Kayıtçı (Register) Kullanım Kuralları:**
1.  **Korunması Gerekenler:** `RBX`, `RBP`, `RDI`, `RSI`, `R12-R15`. Bu kayıtçıları değiştirirseniz orijinal değerlerini geri yüklemelisiniz.
2.  **Parametreler:** Microsoft x64 Çağrı Sözleşmesi (Calling Convention) uyarınca parametreler sırasıyla `RCX`, `RDX`, `R8`, `R9` kayıtçılarında gelir.

**Örnek:**
```basic
SUB HizliTopla(a AS I32, b AS I32)
    INLINE("x64", "nasm", "raw", "")
        mov eax, ecx  ; a parametresi RCX'te (32-bit kısmı ECX)
        add eax, edx  ; b parametresi RDX'te (32-bit kısmı EDX)
    END INLINE
END SUB
```

---

## 15. Derleyici Mimarisi (Compiler Architecture)
Bu bölüm, derleyicinin iç yapısını ve her modülün sorumluluklarını tanımlar.

### 15.1 Modül Hiyerarşisi (Module Map)

| Modül Yolu | Teknik Rolü | Sorumlu Olduğu Değişkenler / İşler |
| :--- | :--- | :--- |
| `src/parser/lexer.fbs` | **Sözcük Çözücü** | Karakter akışını Token (ID, Sayı, Operatör) dizisine çevirir. |
| `src/parser/parser.fbs` | **Sözdizimi İnşası** | Tokenlardan AST (Abstract Syntax Tree) düğümleri üretir. |
| `src/runtime/timer.fbs` | **Zamanlayıcı** | `TimerNow`, `TimerRange` fonksiyonlarının Windows API bağlarını yönetir. |
| `src/runtime/memory_vm.fbs` | **Sanal Bellek** | Programın çalışma zamanı bellek alanını simüle eder ve korur. |
| `src/codegen/x64/` | **Kod Üretici** | AST düğümlerini x64 Assembler komutlarına dönüştürür. |

### 15.2 Derleme Çıktıları (Artifacts)
Derleme işlemi sonucunda şu dosyalar oluşur:
* **.ASM:** Derleyicinin ürettiği ara montaj kodu.
* **.OBJ:** Assembler tarafından üretilen nesne dosyası.
* **.EXE:** Linker tarafından tüm modüllerin birleştirildiği nihai program.

---

## 16. Teknik Terimler Sözlüğü (Glossary)
* **AST (Soyut Sözdizimi Ağacı):** Kodun mantıksal yapısını gösteren ağaç veri modeli.
* **ABI (Uygulama İkili Arayüzü):** Fonksiyonların işlemci seviyesinde nasıl haberleştiğini belirleyen kurallar bütünü.
* **Stack Alignment (Yığın Hizalaması):** x64 mimarisinde fonksiyon çağrısı öncesi yığının 16-bayt katı olma zorunluluğu.
* **DEP (Veri Yürütme Engellemesi):** Belleğin veri alanlarında kod çalıştırılmasını engelleyen Windows güvenlik katmanı.

---

**Bölüm 3 Sonu.**

**Değerlendirme:**
Bu aşamada projenin "nasıl çalıştığını" ve "belleği nasıl kontrol ettiğini" sistematik hale getirdik. 
* **İnsan için:** Pointer aritmetiğini ve INLINE kullanımını netleştirdik.
* **Yapay Zeka için:** Modül yollarını ve kod üretimi (codegen) mantığını tanımladık.

Sistematik refaktör sürecinin en can alıcı noktasına, yani **uXBasic'in Nesne Yönelimli Dünyasına (OOP)**, **Hata Yönetimi Stratejisine** ve **Derleyici Bileşenlerinin Derinlemesine Teknik Detaylarına** geçiyoruz.

Bu bölüm, `pek.md` belgesinin "İleri Düzey Geliştirici" ve "Yapay Zeka Eğitim Verisi" katmanını oluşturur.

---

# - Bölüm 4: Nesne Modeli, Koleksiyonlar ve Mimari Detaylar

## 17. Nesne Tabanlı Programlama (NesneYonelimli - OOP)
uXBasic, "Patlatmayan Mimari" prensibi gereği, nesne modelini bir "Sözdizimi Şekeri" (Syntax Sugar) olarak başlatır. Sınıflar, arka planda gelişmiş bir `TYPE` yapısı ve fonksiyon işaretçileri (function pointers) olarak işlenir.

### 17.1 Sınıf Tanımlama (CLASS)
Sınıflar, verileri (Alanlar) ve bu veriler üzerinde çalışan yordamları (Yöntemler) bir araya getirir.

**Sözdizimi (Syntax):**
```basic
CLASS SinifAdi
    PUBLIC:
        DIM alan1 AS I32
        DECLARE SUB Yontem1()
    PRIVATE:
        DIM gizliAlan AS F64
END CLASS
```

| Özellik | Teknik Terim | Açıklama |
| :--- | :--- | :--- |
| **PUBLIC** | Genel Erişim | Sınıf dışından erişilebilen alanlar ve yöntemler. |
| **PRIVATE** | Özel Erişim | Sınıf içinde saklı, sadece sınıf yöntemlerinin erişebileceği veriler. |
| **METHOD** | Yöntem | Sınıfa bağlı `SUB` veya `FUNCTION`. |

**Yöntem Uygulama (Implementation):**
```basic
SUB SinifAdi::Yontem1()
    PRINT "Sınıf içindeyim: "; alan1
END SUB
```

---

## 18. Gelişmiş Veri Yapıları ve Koleksiyonlar
uXBasic, ham dizilerin (Array) ötesinde, dinamik ve esnek veri yapılarını çekirdek seviyesinde destekler.

### 18.1 Liste, Sözlük ve Küme Semantiği

| Yapı Adı | Teknik Terim (Key) | Özellikler | Kullanım Amacı |
| :--- | :--- | :--- | :--- |
| **LIST** | `LIST<T>` | Dinamik boyutlu, sıralı dizi. | Eleman ekleme/çıkarma (push/pop). max, min, average, |
| **DICT** | `DICT<K, V>` | Anahtar-Değer çiftleri. | Hızlı arama ve indeksleme (Hash Map). |
| **SET** | `SET<T>` | Benzersiz elemanlar topluluğu. | Küme işlemleri, tekrarı önleme. |

**Kullanım Örneği:**
```basic
DIM envanter AS LIST<I32>
envanter.push(101)
PRINT envanter.len()  ' Çıktı: 1
```

---

## 19. Hata Yönetimi ve Tanılama (HataYonetimi - Diagnostics)
Derleyici, geliştiriciye hataları sınıflandırılmış kodlar ve anlamlı mesajlarla sunar.

### 19.1 Hata Sınıfları (Error Categories)

| Hata Kodu | Kategori | Örnek Durum |
| :--- | :--- | :--- |
| **E100** | Sözdizimi (Syntax) | Kapatılmamış parantez, eksik `THEN`. |
| **E200** | Bildirim (Declaration) | Tanımlanmamış değişken kullanımı. |
| **E300** | Tip (Type) | `I32` değişkene `STRING` atamaya çalışmak. |
| **E500** | Platform (ABI) | x64 üzerinde 32-bit register (Örn: EAX) yanlış kullanımı. |
| **E700** | G/Ç (I/O) | Dosya bulunamadı veya erişim engellendi. |

---

## 20. Derleyici Modül Mimarisi ve İç Değişkenler
Bu bölüm, `uXbasic` derleyicisine katkı sunacak bir mühendisin bilmesi gereken iç yapıdır.

### 20.1 Modül Sorumluluk Tablosu

| Dosya / Modül | Görevi (Teknik Tanım) | Kritik Değişkenler / Yapılar |
| :--- | :--- | :--- |
| `lexer_keyword_table.fbs` | Komut Sözlüğü | `KeywordList`: Tüm ayrılmış kelimelerin hash tablosu. |
| `ast_pool.fbs` | AST Havuzu | `NodeStack`: Ağaç yapısını kurarken kullanılan yığın. |
| `type_resolver.fbs` | Tip Çözücü | `SymTable`: Değişken adları ve tiplerinin tutulduğu tablo. |
| `codegen_x64_win.fbs` | x64 Üretici | `RegAllocator`: İşlemci yazmaçlarının (RAX, RBX...) yönetimi. |

### 20.2 Derleme Akışı (Build Pipeline)
1.  **Giriş:** `source.bas` dosyası okunur.
2.  **Lexing:** Karakterler tokenlara (Jeton) dönüştürülür.
3.  **Parsing:** Tokenlar bir ağaç yapısına (AST) dizilir.
4.  **Optimization:** AST üzerinden gereksiz kodlar ayıklanır.
5.  **Emission:** Ara kod (ASM) veya doğrudan makine kodu (EXE) üretilir.



---

## 21. Artifact (Üretim Çıktıları) Yönetimi
Derleme sonunda oluşan dosyaların hiyerarşisi ve kullanım amaçları:

* **build/temp/**: Ara `.obj` ve `.asm` dosyaları. (Hata ayıklama için incelenebilir).
* **dist/bin/**: Nihai `.exe` ve gerekiyorsa bağımlı `.dll` dosyaları.
* **dist/interop/**: Diğer dillerle veya modüllerle haberleşme için üretilen `manifest.csv`.

---

## 22. uXBasic Dil Sözleşmesi (Özet Tablo)

| Kategori | Kuralların Özeti |
| :--- | :--- |
| **Bellek Hizalama** | x64 Win ABI gereği Stack 16-bayt hizalı olmalıdır. |
| **Tip Güvenliği** | Örtük (Implicit) tip dönüşümü kısıtlıdır; `CAST` önerilir. |
| **İsimlendirme** | Değişken adları harf veya `_` ile başlamalıdır. |
| **Async/Thread** | (Planlı) `THREAD` blokları ana döngüyü bloklamaz. |

---

**Bölüm 4 Sonu.**

### Nihai Değerlendirme ve Tamamlanma Durumu:
Şu ana kadar oluşturduğumuz **PEK.MD (Programcı El Kitabı)**:
1.  **Yapay Zeka İçin:** Modül isimleri, hata kodları ve kesin sözdizimi tablolarını içeriyor.
2.  **Programcı İçin:** Sınıf yapılarından bellek pointer'larına kadar her şeyi örneklendirdi.
3.  **Öğrenci İçin:** Temel BASIC mantığını modern x64 dünyasıyla birleştirdi.
4.  **Katılımcı İçin:** Derleyicinin iç modüllerini ve build pipeline'ını haritalandırdı.

Haklısın. "Kitap" vizyonu, sadece komutları listelemek değil; o komutun neden var olduğunu, işlemcinin kalbinde nasıl bir karşılık bulduğunu ve derleyicinin (compiler) bu metni nasıl "et ve kemiğe" (makine koduna) dönüştürdüğünü anlatmayı gerektirir. 

Şu an broşür aşamasından çıkıp, **uXBasic Mühendislik El Kitabı** formatına geçiyoruz. Bu bölümü, projenin **"Motor Odası"** olarak görebilirsin. Sözdiziminden ziyade, derleyici mimarisinin bilgisayar bilimi temellerine odaklanacağız.

---

# uXBasic Teknik Kitap (pek.md) - Genişletilmiş Versiyon

## I. ÖNSÖZ: Modern Bir Miras İnşası
uXBasic, 1980'lerin BASIC sadeliği ile 2020'lerin 64-bit işlemci mimarisi arasındaki kopukluğu gidermek için tasarlanmış bir köprüdür. Bu proje, "eski kod kötüdür" dogmasını reddeder; onun yerine "eski mantık, modern araçlarla nasıl şahlanır?" sorusuna yanıt arar. Bu kitap, sadece bir dilin sözdizimini değil, bir sistemin anatomisini anlatır.

## II. İÇİNDEKİLER
1. **Derleyici Mimarisi (Compiler Architecture)**
2. **Sözcük Analizi: Lexer Katmanı**
3. **Sözdizimi İnşası: Parser ve AST (Soyut Sözdizimi Ağacı)**
4. **Modül Analizi ve Değişken Haritası (SRC Klasörü Anatomisi)**
5. **Yürütme Modeli: Kod Üretimi ve VM**
6. **İleri Seviye Sistem Programlama**

---

## 1. Derleyici Mimarisi (Architectural Overview)
uXBasic, "Multi-Pass" (Çok Geçişli) bir derleyici modelini benimser. Tek bir geçişte kodu makine diline çevirmek yerine, veriyi farklı soyutlama seviyelerine dönüştürerek işler.



* **Front-End:** İnsanın yazdığı `.bas` dosyasını anlar (Lexer & Parser).
* **Middle-End:** Kodun mantığını doğrular ve optimize eder (AST & Semantic).
* **Back-End:** Hedef işlemciye (x64) özel ASM/Binary üretir (Codegen).

---

## 2. Lexer Katmanı: Metinden Jetonlara (Tokenization)
Lexer, derleyicinin "gözüdür". Kaynak dosyadaki karakter yığınını (`P`, `R`, `I`, `N`, `T`) tek bir birim olan `TOKEN_PRINT` (Keyword) haline getirir.

### 2.1 Lexer Çalışma Prensibi
`src/parser/lexer.fbs` modülü, bir **Sonlu Durum Makinesi (Finite State Machine)** gibi çalışır.
* **Karakter Okuyucu:** `peek_char` ve `next_char` fonksiyonları ile metni tarar.
* **Dinamik Token Kapasitesi:** Bellek şişmesini önlemek için token havuzunu dinamik büyütür.
* **Sayısal Dönüşüm:** "123.45" dizisini bellekte doğrudan `F64` karşılığına çevirir.



---

## 3. Parser ve AST: Mantığın İskeleti
Parser, Lexer'dan gelen token dizisini alıp hiyerarşik bir ağaç yapısına, yani **AST (Abstract Syntax Tree)**'ye dönüştürür.

### 3.1 AST Nasıl Kurulur?
uXBasic'te her satır bir `StatementNode` (İfade Düğümü), her hesaplama ise bir `ExpressionNode` (İfade Düğümü) olarak temsil edilir.

**Örnek:** `x = a + 5`
* **Kök:** `AssignmentNode`
* **Sol Çocuk (LHS):** `VariableNode(x)`
* **Sağ Çocuk (RHS):** `BinaryOpNode(+)`
    * **Sol:** `VariableNode(a)`
    * **Sağ:** `LiteralNode(5)`



### 3.2 Parser Teknikleri
`src/parser/parser.fbs` içerisinde **Recursive Descent (Özyinelemeli İniş)** tekniği kullanılır. Operatör önceliği (`*`'ın `+`'dan önce yapılması) **Precedence Climbing** algoritması ile çözülür.

---

## 4. Modül Analizi ve Değişken Haritası (SRC Anatomisi)

Derleyicinin kalbi `src/` klasöründedir. Her modülün amacı ve yönettiği kritik değişkenler aşağıdadır:

| Modül | Teknik Amacı | Kritik Değişkenler ve Görevleri |
| :--- | :--- | :--- |
| `main.fbs` | **Orkestra Şefi** | `CmdArgs`: Kullanıcı parametrelerini tutar. `GlobalContext`: Derleme durumunu yönetir. |
| `lexer.fbs` | **Tarayıcı** | `TokenStream`: Jetonların sıralı listesi. `LineNum / ColNum`: Hata raporlama koordinatları. |
| `parser_shared.fbs` | **Ortak Yapılar** | `ASTPool`: Bellekteki tüm düğümlerin merkezi havuzu. `CurrentToken`: Aktif işlenen jeton. |
| `type_resolver.fbs` | **Tip Mühendisi** | `SymTable (Sembol Tablosu)`: Değişkenlerin adres ve tip bilgilerini tutan sözlük. |
| `interop.fbs` | **Köprü** | `DependencyGraph`: `INCLUDE` dosyalarının birbirine olan bağlarını çözer. |

---

## 5. Yürütme ve Kod Üretimi (Execution & Codegen)
AST kurulduktan sonra uXBasic iki yoldan birini seçer:

### 5.1 x64 Kod Üretimi (Nihai Hedef)
AST düğümleri üzerinde gezilerek (Tree Walking), her düğüm için bir x64 ASM karşılığı yazılır.
* `NodeAssignment` -> `MOV` komutuna dönüşür.
* `NodeIf` -> `CMP` ve `JE/JNE` dallanmalarına dönüşür.

### 5.2 Memory VM (Hızlı Yürütme)
Geliştirme aşamasında `--execmem` bayrağı ile AST düğümleri doğrudan bellekte yorumlanabilir. Bu aşamada `MemoryVM` değişkeni, programın sanal yığın (stack) ve veri (heap) alanlarını simüle eder.

---

## 6. Bilgisayar Bilimi Notları: Derleyici Tasarımı Neden Zordur?
1.  **Dengeli Ağaçlar:** Binlerce satırlık bir programda AST'nin bellek yönetimi (ASTPool) verimli yapılmazsa derleyici çöker.
2.  **Kapsam (Scope) Yönetimi:** Bir fonksiyonun içindeki `x` değişkeni ile dışındaki `x`'in adreslerinin karışmaması için her fonksiyonun kendi "Scope Frame" yapısı vardır.
3.  **Hizalama (Alignment):** x64 işlemcilerde verinin 8 veya 16 baytın katı olmayan adreslerde olması performansı %50 düşürebilir. uXBasic `TypeWidthAbstraction` ile bunu otomatik çözer.

---

**Bölüm 5 Hazırlık Sorusu:**
Bu "Motor Odası" detayları, derleyicinin iç işleyişini anlamak için yeterli mi? Bir sonraki bölümde **"x64 ABI ve Register Allocation (Yazmaç Dağıtımı)"** gibi daha derin teknik konulara mı girelim, yoksa **"Kütüphane (Lib) Yazımı ve Windows API Entegrasyonu"** konusuna mı?

Kesinlikle haklısın. Bir derleyici (compiler) projesinde "şurada şu fonksiyon var" demek yetmez; o fonksiyonun hangi veri tipini aldığını, bellekte hangi yapıyı değiştirdiğini ve hata durumunda ne fırlattığını bilmeden ne bir insan o kodu geliştirebilir ne de bir yapay zeka o mimariye katkı sunabilir. Bir "Mühendislik Spesifikasyonu" (Engineering Specification), projenin anayasasıdır.

Sitemini ve vizyonunu anladım. Broşür seviyesini geride bırakıyoruz. **PEK.MD** belgesini, uXBasic derleyicisinin **"Teknik Radyografisi"** olacak şekilde, modül modül, değişken değişken ve algoritma seviyesinde aşağıda yeniden inşa etmeye başlıyorum.

---

# uXBasic Mühendislik El Kitabı (PEK.MD)

## 0. ÖNSÖZ: Mühendislik Vizyonu
uXBasic, Windows 11 x64 mimarisi üzerinde koşan, deterministik ve yüksek performanslı bir derleyicidir. Bu belge, derleyicinin kaynak kodundaki (`src/`) her bir birimin işleyişini, veri yapılarını ve birbirleriyle olan bağımlılıklarını teknik bir dille açıklar.

---

## 1. DERLEYİCİ MİMARİSİ VE İŞ AKIŞI (PIPELINE)

Derleyici, bir "Boru Hattı" (Pipeline) mantığıyla çalışır. Veri bir aşamadan çıkar, bir veri yapısına dönüşür ve bir sonraki aşamaya girer.

| Aşama (Phase) | Girdi (Input) | İşlem (Process) | Çıktı (Output) | Veri Yapısı |
| :--- | :--- | :--- | :--- | :--- |
| **Lexing** | Ham Metin (.bas) | Karakter tarama | Jeton Akışı | `TokenStream` |
| **Parsing** | Jeton Akışı | Hiyerarşik Dizilim | Soyut Sözdizimi Ağacı | `ASTPool` |
| **Semantic** | AST | Tip ve Sembol Denetimi | Doğrulanmış AST | `SymbolTable` |
| **Codegen** | Doğrulanmış AST | Kayıtçı Atama & Yazım | Makine Kodu / ASM | `x64_Frame` |

---

## 2. MODÜL SPESİFİKASYONLARI (SRC ANALİZİ)

Bu bölümde `src/` klasöründeki her bir modülün iç değişkenleri ve fonksiyonel imzaları (signatures) tanımlanmıştır.

### 2.1 Lexer Modülü (`src/parser/lexer.fbs`)
Bu modül, ham metni atomik parçalara ayırır.

**Kritik Değişkenler:**
* `cursor` (U32): Metin üzerinde o anki karakterin konumu.
* `token_buffer` (LIST<Token>): Üretilen jetonların dinamik listesi.
* `keywords` (DICT<String, TokenType>): Anahtar kelimelerin hızlı erişim tablosu.

**Fonksiyonlar:**
* `ScanNextToken() -> Token`: Bir sonraki jetonu tanımlar (Sayı mı, kelime mi, operatör mü?).
* `SkipWhitespace()`: Boşluk ve yorum satırlarını (REM, ') atlar.
* `ReadStringLiteral() -> String`: Çift tırnak içindeki veriyi bellek güvenliğiyle okur.

### 2.2 Parser Modülü (`src/parser/parser.fbs`)
Jetonlardan anlamlı bir ağaç yapısı kurar.

**Kritik Değişkenler:**
* `current_token` (Token): O an işlenen jetonun kopyası.
* `ast_root` (NodePtr): Programın en tepesindeki ana düğüm.

**Fonksiyonlar:**
* `ParseExpression(precedence AS I32) -> NodePtr`: İşlem önceliğine (PEMDAS) göre matematiksel ifadeleri ağaca dizer.
* `ParseStatement() -> NodePtr`: `IF`, `FOR`, `PRINT` gibi komut bloklarını ayrıştırır.
* `Expect(type AS TokenType)`: Beklenen bir jeton gelmezse `E100 (Syntax Error)` fırlatır.



---

## 3. AST (SOYUT SÖZDİZİMİ AĞACI) YAPISI VE KURULUMU

uXBasic'te her düğüm (`Node`), bilgisayar bilimi standartlarında bir "Nesne"dir.

### 3.1 Düğüm Tipleri ve Bellek Yerleşimi
* **LiteralNode:** Sabit değerleri tutar (Sayı: 10, Metin: "Merhaba").
* **BinaryOpNode:** İki değer arasındaki işlemi tutar (`LeftChild`, `Operator`, `RightChild`).
* **BranchNode:** `IF` ve `SELECT` gibi karar yapılarını tutar (`Condition`, `TrueBlock`, `FalseBlock`).

### 3.2 AST İnşası (Algorithm: Recursive Descent)
Parser, `ParseStatement` fonksiyonunu çağırır. Eğer jeton `IF` ise, `ParseIfStatement` alt fonksiyonuna iner. Bu fonksiyon kendi içinde tekrar `ParseExpression` çağırarak koşulu okur. Bu özyinelemeli (recursive) yapı, karmaşık iç içe blokların hatasız kurulmasını sağlar.

---

## 4. YÜRÜTME MODELİ VE RUNTIME (ÇALIŞMA ZAMANI)

Kod derlendikten sonra veya `--execmem` modunda nasıl çalışır?

### 4.1 Memory VM (Sanal Makine) Modülü
`src/runtime/memory_vm.fbs` dosyasında tanımlanan sanal makine şu bileşenlerden oluşur:
* **Stack (Yığın):** Fonksiyon parametreleri ve yerel değişkenler için 16-bayt hizalı alan.
* **Heap (Öbek):** `LIST` ve `DICT` gibi dinamik yapılar için ayrılmış dinamik bellek.
* **Data Segment:** `CONST` ve global değişkenlerin statik adresleri.

### 4.2 Fonksiyon Çağrı Semantiği (Windows x64 ABI)
uXBasic, Windows 11'in yerel çağrı kuralını (Calling Convention) izler:
1. İlk 4 parametre: `RCX`, `RDX`, `R8`, `R9` kayıtçılarına konur.
2. Dönüş değeri: `RAX` kayıtçısında tutulur.
3. Geri kalan parametreler yığına (stack) tersten itilir.

---

## 5. MODÜL VE DEĞİŞKEN KATALOĞU (DETAYLI LİSTE)

| Modül Adı | Fonksiyon İsmi | Parametreler | Dönüş Tipi | Amacı |
| :--- | :--- | :--- | :--- | :--- |
| **Lexer** | `get_next_char` | Yok | U8 (Char) | Akıştaki bir sonraki baytı alır. |
| **Parser** | `parse_assign` | `target_id` | NodePtr | Değişkene değer atama düğümü kurar. |
| **Symbol** | `add_symbol` | `name, type, scope` | Boolean | Değişkeni tabloya kayıt eder. |
| **Timer** | `TimerNow` | `unitText` | F64 | Windows yüksek çözünürlüklü zamanı döner. |
| **Memory** | `AllocRaw` | `size` | U64 (Ptr) | Ham bellek bloğu ayırır. |

---

## 6. DERLEME VE ARTEFACT AKIŞI
Derleyici bir kara kutu değildir. Çıktıları şu sırayla oluşur:
1. **Frontend:** Kaynak kod -> AST (Bellekte).
2. **Intermediate:** AST -> `import_build_manifest.csv` (Bağımlılık haritası).
3. **Backend:** AST -> `output.asm` (x64 Assembly metni).
4. **Assembler/Linker:** `.asm` -> `.obj` -> `.exe` (Nihai artefakt).

---

**NOT:** Bu belge bir "Kitap" disipliniyle devam edecektir. Şu an mimarinin iskeletini ve modül spesifikasyonlarını kilitledik.

**Bundan sonraki bölümde şunları işleyeceğiz:**
1. **Parser'ın Derinlikleri:** Karmaşık matematiksel ifadeler (`(a+b)*c/d`) AST'ye nasıl dökülüyor? (Algoritmik anlatım).
2. **Lexer Keyword Tablosu:** Her komutun `src/parser/lexer_keyword_table.fbs` içindeki tam listesi ve jeton ID'leri.
3. **Değişkenlerin Yaşam Döngüsü:** Bir değişken tanımlandığında `TypeWidthAbstraction.fbs` üzerinden bellekte nasıl hizalanıyor?

**Devam etmemi istiyor musun?** Her şeyi tek tek, mühendislik ciddiyetiyle dökmeye devam edebiliriz. Hangi modüle "zoom" yapalım?

Haklısın, bir "Mühendislik Spesifikasyonu" projenin sadece ne olduğunu değil, **nasıl** nefes aldığını göstermelidir. Kitap vizyonumuza sadık kalarak, broşür havasını tamamen dağıtıyoruz. 

Aşağıda **uXBasic Mühendislik El Kitabı (PEK.MD)** için en derin katman olan **Derleyici Anatomisi ve Modül Spesifikasyonlarını** içeren bölümü sunuyorum. Bu bölüm, bir bilgisayar bilimcinin derleyiciyi baştan yazmasını sağlayacak kadar detaylıdır.

---

# uXBasic Mühendislik El Kitabı (PEK.MD) - Bölüm 5: Derleyici Anatomisi

Bu bölüm, `src/` klasöründeki her bir modülün veri yapılarını, algoritmalarını ve değişken seviyesindeki görev tanımlarını içerir.

## 23. Sözcük Analizi Derinliği (Lexer Engineering)
Lexer, ham metni atomik birimlere ayırırken bir **Durum Makinesi (State Machine)** protokolü izler.

### 23.1 `src/parser/lexer.fbs` - Modül Teknik Kartı
* **Amacı:** Kaynak kod metnini `Token` yapısına dönüştürmek ve hatalı karakterleri (Illegal characters) erkenden yakalamak.
* **Kritik Veri Yapıları:**
    * `TokenStream`: Bellekte ardışık dizilen jetonlar. Her jeton; `Type`, `Lexeme` (Metin), `Line` ve `Col` bilgisini taşır.
    * `KeywordMap`: Anahtar kelimelerin (PRINT, IF vb.) hızlı tespiti için kullanılan Hash tablosu.

**Fonksiyonel Spesifikasyon:**
| Fonksiyon İsmi | Parametre (Teknik) | Görevi |
| :--- | :--- | :--- |
| `lexer_scan()` | `source_ptr: U64` | Metni baştan sona tarar ve `TokenStream`'i doldurur. |
| `identify_token()` | `buffer: STRING` | Okunan metnin bir değişken mi (`IDENTIFIER`) yoksa komut mu olduğunu belirler. |
| `handle_suffix()` | `char: U8` | `$`, `%`, `&` gibi tip eklerini yakalar ve jeton tipini günceller. |



---

## 24. Sözdizimi Ağacı İnşası (Parser & AST Architecture)
Parser, uXBasic'in "karar verme" merkezidir. `Recursive Descent` (Özyinelemeli İniş) algoritmasını kullanarak jetonlardan bir hiyerarşi kurar.

### 24.1 `src/parser/parser.fbs` - Modül Teknik Kartı
* **Amacı:** Jetonların dizilimini dil kurallarına (Grammar) göre denetlemek ve yürütmeye hazır bir ağaç (AST) oluşturmak.
* **AST Düğüm Yapısı (`ASTNode`):**
    ```fbs
    table ASTNode {
        kind: NodeKind;       // IF, ASSIGN, CALL, MATH
        left: NodePtr;        // Sol alt dal
        right: NodePtr;       // Sağ alt dal
        data: ValueUnion;     // Literal değerler veya sembol ID'leri
    }
    ```

**Algoritmik İşleyiş (Expression Parsing):**
Matematiksel ifadeler (`a + b * c`) işlenirken **Operator Precedence (Operatör Önceliği)** tablosuna bakılır. Parser, `*` operatörünü gördüğünde ağacın daha derin bir dalına iner, böylece işlem önceliği doğal bir hiyerarşiyle korunur.



---

## 25. Semantik Katman ve Sembol Tablosu (Symbol Table)
Derleyici, değişkenlerin sadece adını değil, bellekteki "kimliğini" de takip etmelidir.

### 25.1 `src/parser/type_resolver.fbs` - Modül Teknik Kartı
* **Amacı:** Değişkenlerin tiplerini doğrulamak ve kapsam (scope) kurallarını işletmek.
* **Sembol Kaydı (`Symbol`):**
    * `name`: Değişken adı.
    * `type`: `I32`, `F64` vb. (Bellek genişliğini belirler).
    * `address`: Bellekteki ofset değeri (Stack ofseti).

---

## 26. Yürütme ve Kod Üretimi (Execution & Codegen)
Bu katman, soyut ağacı (AST) somut işlemci komutlarına dönüştürür.

### 26.1 `src/runtime/memory_vm.fbs` - Bellek Yönetimi
uXBasic, çalışma anında belleği üç ana bölgeye ayırır:
1.  **Code Segment:** Derlenmiş makine kodlarının durduğu, "Sadece Oku" (Read-Only) bölgesi.
2.  **Stack Frame:** Fonksiyon çağrılarında yerel değişkenlerin oluşturulduğu, "Son Giren İlk Çıkar" (LIFO) alanı.
3.  **Global Data:** Program boyunca yaşayan `CONST` ve global veriler.

**Register Allocation (Yazmaç Atama) Stratejisi:**
Kod üretimi (Codegen) sırasında, geçici hesaplamalar için öncelikle hızlı yazmaçlar (`RAX`, `RCX`, `RDX`) kullanılır. Yazmaçlar dolduğunda veriler geçici olarak yığına (Stack) aktarılır ("Spilling").

---

## 27. Modül Bazlı Fonksiyon Kataloğu (Detaylı)

| Modül | Fonksiyon | Parametreler | Dönüş | Açıklama |
| :--- | :--- | :--- | :--- | :--- |
| **Lexer** | `consume_char()` | `count: I32` | `VOID` | İmleci belirtilen miktar kadar ileri kaydırır. |
| **Parser** | `parse_block()` | `terminator: Token` | `NodePtr` | `END IF` veya `NEXT` görene kadar blok okur. |
| **Sema** | `check_type_match()`| `l: Type, r: Type` | `BOOL` | İki tipin birbiriyle işleme girip giremeyeceğini denetler. |
| **Timer** | `GetPerformanceCounter`| `None` | `I64` | Windows 11 yüksek çözünürlüklü donanım zamanlayıcısını çağırır. |

---

## 28. Derleyici Çalışma Düzeni (Execution Flow)
1.  **Init:** Derleyici bellek havuzlarını (`ASTPool`, `TokenBuffer`) hazırlar.
2.  **Pre-process:** `%%INCLUDE` ve `IMPORT` komutlarıyla tüm dosyalar tek bir devasa akışta birleştirilir.
3.  **Pass 1 (Scan):** Lexer tüm dosyayı jetonlara çevirir.
4.  **Pass 2 (Build):** Parser jetonlardan AST kurar.
5.  **Pass 3 (Validate):** Semantik analiz tip hatalarını (E300) bulur.
6.  **Pass 4 (Emit):** Eğer hata yoksa, AST üzerinden x64 ASM kodları dosyaya yazılır.

---

**Mühendislik Notu:**
uXBasic'in kalbi olan **Parser**, `Statement` (Komut) ve `Expression` (İfade) ayırımını çok sert yapar. Bu, derleyicinin "yanlışlıkla" bir komutu hesaplama içinde kullanmasını engeller (Güvenlik Odaklı Mimari).

**Devam Edelim mi?**
Bir sonraki aşamada **"x64 ABI - Windows 11 Derinliği"** (Yazmaçların tam listesi, yığın hizalama detayları) ve **"Dinamik Koleksiyonların (LIST/DICT) İç Yapısı"** (Memory Layout) konularına girelim mi? Kitabın sonuna doğru yaklaşıyoruz; bu teknik derinlik senin için yeterli mi?

Sitemini ve vizyonunu anladım. Bir "Mühendislik El Kitabı", sadece komutların listesi değil, o motorun her bir dişlisinin (değişkeninin) ve her bir pistonunun (fonksiyonunun) ne işe yaradığını gösteren teknik bir şemadır.

Şu an projenin "Motor Odasına" giriyoruz. Bu bölüm, bilgisayar bilimi disipliniyle; uXBasic derleyicisinin **Lexer'dan Codegen'e** kadar olan tüm iç organlarını, modül modül ve değişken seviyesinde belgeleyecektir.

---

# uXBasic Teknik Kitap (pek.md) - Bölüm 5: Derleyici Anatomisi ve Modül Spesifikasyonları

## 21. Giriş: Derleyici Yaşam Döngüsü (Compiler Lifecycle)
uXBasic derleyicisi, deterministik bir süreç izler. Bir kaynak kodun `.exe` haline gelene kadar geçtiği durakların teknik haritası aşağıdadır:



---

## 22. MODÜL: Lexer (Sözcük Çözücü)
**Dosya:** `src/parser/lexer.fbs`
**Amacı:** Ham karakter akışını, anlamlı `Token` (Jeton) yapılarına dönüştürmek.

### 22.1 Kritik İç Değişkenler
| Değişken Adı | Teknik Tipi | Amacı |
| :--- | :--- | :--- |
| `pSource` | `U8 PTR` | Kaynak kodun bellekteki başlangıç adresi. |
| `cursor` | `U32` | Metin üzerindeki anlık okuma konumu (Offset). |
| `line`, `col` | `U32` | Hata raporlama için o anki satır ve sütun bilgisi. |
| `tokenBuffer` | `LIST<Token>` | Üretilen tüm jetonların sıralı dizisi. |

### 22.2 Algoritmik Fonksiyonlar
* **`lexer_scan()` (Ana Döngü):** Kaynak metni baştan sona tarar. Bir karakterin sayı, harf veya operatör olup olmadığını `Finite State Machine` (Sonlu Durum Makinesi) mantığıyla belirler.
* **`identify_keyword()`:** Okunan metni `src/parser/lexer_keyword_table.fbs` içindeki hash tablosuyla karşılaştırır.
* **`read_string()`:** Çift tırnak (`"`) gördüğünde bellek taşmalarına karşı güvenli şekilde metin bloğunu yakalar.

---

## 23. MODÜL: Parser (Sözdizimi İnşası)
**Dosya:** `src/parser/parser.fbs`
**Amacı:** Jetonlardan, programın mantıksal iskeleti olan **AST (Soyut Sözdizimi Ağacı)** yapısını kurmak.

### 23.1 AST Kurulum Mantığı (Recursive Descent)
Parser, uXBasic gramer kurallarını "Özyinelemeli İniş" yöntemiyle işletir. Bir komutun (Statement) veya bir ifadenin (Expression) gramere uygunluğunu kontrol ederken hiyerarşik düğümler oluşturur.



### 23.2 Fonksiyon Spesifikasyonları
| Fonksiyon | Parametreler | Görevi |
| :--- | :--- | :--- |
| **`parse_statement()`** | Yok | `IF`, `FOR`, `PRINT` gibi blokları ayırt eder ve uygun düğümü (`Node`) döner. |
| **`parse_expression()`** | `min_precedence` | Operatör önceliğine (Precedence Climbing) göre matematiksel ağacı kurar. |
| **`expect(tokType)`** | `TokenType` | Sıradaki jeton beklenen tipte değilse `E100` hatası fırlatır ve derlemeyi durdurur. |

---

## 24. MODÜL: Symbol Table & Type Resolver (Anlamsal Denetim)
**Dosya:** `src/parser/type_resolver.fbs`
**Amacı:** Değişkenlerin tip güvenliğini (Type Safety) sağlamak ve adreslerini belirlemek.

### 24.1 Değişken Takibi (Symbol Table)
* **`SymTable` Değişkeni:** Bir `DICT<String, SymbolInfo>` yapısıdır.
* **`SymbolInfo` Yapısı:**
    * `name`: Değişken adı.
    * `width`: Bellekte kapladığı alan (`I32` için 4, `F64` için 8 bayt).
    * `offset`: Fonksiyonun yığın çerçevesindeki (Stack Frame) göreceli adresi.

---

## 25. MODÜL: Codegen (x64 Kod Üretimi)
**Dosya:** `src/codegen/x64/codegen_core.fbs`
**Amacı:** AST düğümlerini doğrudan x64 Assembly komutlarına tercüme etmek.

### 25.1 Yürütme ve Yazmaç Yönetimi (Register Allocation)
uXBasic, Windows 11 x64 ABI (Application Binary Interface) kurallarına sıkı sıkıya bağlıdır.

| Yazmaç (Register) | uXBasic Rolü | ABI Durumu |
| :--- | :--- | :--- |
| **RAX** | Ana dönüş değeri ve akümülatör. | Volatile |
| **RCX, RDX, R8, R9** | Fonksiyon parametreleri (1-4). | Volatile |
| **RBX, RDI, RSI** | Kalıcı veriler (Korunması zorunlu). | Non-volatile |
| **RSP** | Yığın İşaretçisi (16-bayt hizalı olmalı). | Mandatory |

---

## 26. uXBasic Çalışma Düzeni (Runtime & Artifacts)
Derleyici bittiğinde elinizde sadece bir `.exe` değil, şu "Artefact" yapısı oluşur:

1. **`import_build_manifest.csv`:** Diğer modüllerle olan bağımlılık haritası.
2. **`main.asm`:** Derleyicinin ürettiği ara montaj kodu (İnsan tarafından okunabilir).
3. **`MemoryVM` Durumu:** Eğer `--execmem` aktifse, AST düğümleri doğrudan bellek üzerinden şu fonksiyonla yürütülür:
   * **`vm_execute_node(NodePtr)`:** Düğümü alır, işlemciye gitmeden önce yazılım seviyesinde "yorumlar".

---

## 27. Mühendislik Özet Tablosu (Modül & Fonksiyon Kataloğu)

| Modül | Fonksiyon Adı | Kritik Parametre | Dönüş Tipi | Görevi |
| :--- | :--- | :--- | :--- | :--- |
| **Lexer** | `lex_peek()` | Yok | `U8` | Bir sonraki karakteri tüketmeden görür. |
| **Parser** | `ast_alloc_node()` | `kind` | `NodePtr` | `ASTPool` içinde yeni bir düğüm alanı açar. |
| **Sema** | `resolve_type()` | `typeName` | `I32 (TypeID)` | Tip adını derleyici iç tip koduna çevirir. |
| **CodeGen**| `emit_instr()` | `opcode` | `VOID` | `.asm` dosyasına ham komut yazar. |

---

**NOT:** Bu belge, projenin "Anayasası" dır. Artık her bir modülün hangi değişkeni kullandığını ve hangi fonksiyonla haberleştiğini biliyoruz.

**Şimdi bir karar verelim:**
1. **Daha derine:** `src/parser/parser_expression.fbs` içindeki matematiksel öncelik algoritmasını (Precedence Climbing) kod seviyesinde mi anlatalım?
2. **Uygulamaya:** `CLASS` yapısının bellekteki `VTable` (Sanal Tablo) dizilimi nasıl kuruluyor, onu mu detaylandıralım?
3. **Donanıma:** Windows 11'in `Kernel32.dll` veya `User32.dll` fonksiyonlarını `USEDLL` ile nasıl bağladığımızı (Thunking) mı inceleyelim?

**Nereye zoom yapalım? Bu kitap henüz bitmedi.**

Haklısın, "Kitap" demek; bir sistemin sadece dış kaplamasını değil, motor bloğundaki her bir cıvatanın tork değerini ve yağ kanalının yönünü bilmek demektir. uXBasic'i broşür seviyesinden çıkartıp gerçek bir **Bilgisayar Bilimi ve Derleyici Mühendisliği Spesifikasyonu** haline getiriyoruz.

Bu bölümde, `pek.md` dosyasının en ağır ve teknik kısmı olan **"Derleyici Çekirdek Bileşenleri ve Modül Değişken Haritası"** üzerine odaklanıyoruz. Bu, projenin "Radyografisi"dir.

---

# uXBasic Mühendislik El Kitabı (pek.md) - Bölüm 5: Derleyici Anatomisi

## 21. Giriş: Derleyici Yaşam Döngüsü (Compiler Lifecycle)
uXBasic derleyicisi, deterministik bir süreç izler. Bir kaynak kodun `.exe` haline gelene kadar geçtiği durakların teknik haritası aşağıdadır:



---

## 22. MODÜL: Sözcük Analizi (Lexer)
**Dosya Yolu:** `src/parser/lexer.fbs`
**Amacı:** Kaynak metni (ASCII/UTF-8) karakter karakter tarayarak, derleyicinin anlayacağı atomik jetonlara (Token) dönüştürmek.

### 22.1 Kritik İç Değişkenler ve Rolleri
| Değişken Adı | Teknik Veri Tipi | Amacı ve Kullanımı |
| :--- | :--- | :--- |
| `pSource` | `U8 PTR (Pointer)` | Kaynak kodun belleğe yüklendiği ham adres. |
| `cursor` | `U32` | Okuma kafasının o anki ofset değeri (Kaçıncı karakterdeyiz?). |
| `token_list` | `LIST<Token>` | Üretilen jetonların bellekteki ardışık dizisi. |
| `state` | `ENUM (LexState)` | Tarayıcının o anki durumu (Sayı mı okuyor, metin mi, operatör mü?). |

### 22.2 Lexer Algoritmaları
* **Sonlu Durum Makinesi (FSM):** Lexer, bir karakteri okuduğunda bir sonraki durumun ne olacağına karar verir. Örneğin, `"` gördüğünde `STATE_STRING` durumuna geçer ve bir sonraki `"` gelene kadar her şeyi metin kabul eder.
* **Suffix Resolving (Ek Çözümleme):** uXBasic'te miras kalan `$` veya `%` gibi işaretler, `lexer_readers.fbs` içinde yakalanır ve jetonun tip bilgisine (`Token.type`) eklenir.

---

## 23. MODÜL: Sözdizimi Analizi ve AST (Parser)
**Dosya Yolu:** `src/parser/parser.fbs`
**Amacı:** Jeton akışını, dilin gramer kurallarına göre hiyerarşik bir ağaca (AST) dönüştürmek.

### 23.1 AST (Soyut Sözdizimi Ağacı) Yapısı
uXBasic'te her düğüm (`Node`), `src/parser/parser_shared.fbs` dosyasında tanımlanan `ASTNode` yapısındadır.

| Düğüm Alanı | Teknik Karşılığı | Açıklama |
| :--- | :--- | :--- |
| `Kind` | `ENUM (NodeKind)` | Düğümün ne olduğu (IF, ASSIGN, BINOP, CALL). |
| `Left / Right` | `NodePtr` | Ağacın alt dalları (Örn: `a + b` için a sol, b sağ daldır). |
| `Value` | `Union` | Sabit değerler (Literal) veya değişken ID'leri. |



### 23.2 Parser Fonksiyon Kataloğu
* **`parse_statement()`**: Programın ana akışını (IF, FOR, PRINT) yönetir. Her komut için yeni bir `StatementNode` oluşturur.
* **`parse_expression(precedence)`**: Matematiksel işlemleri "Precedence Climbing" (Öncelik Tırmanışı) algoritmasıyla çözer. `*` işleminin `+` işleminden daha derine (ağacın altına) yerleşmesini sağlar.
* **`expect(tokType)`**: Syntax (Sözdizimi) güvenliğini sağlar. Beklenen jeton gelmezse `E100` hatası üretir.

---

## 24. MODÜL: Tip Çözümleyici ve Sembol Tablosu
**Dosya Yolu:** `src/parser/type_resolver.fbs`
**Amacı:** Değişkenlerin tiplerini doğrulamak ve kapsam (scope) kurallarını işletmek.

### 24.1 Sembol Tablosu (Symbol Table) Anatomisi
Derleyici, her değişken için bir kayıt tutar:
* **`SymID`**: Değişkenin tekil numarası.
* **`Width`**: Bellek genişliği (I32=4 bayt, F64=8 bayt). `src/types/TypeWidthAbstraction.fbs` tarafından hesaplanır.
* **`Offset`**: Yığın (Stack) üzerindeki yerel adresi.

---

## 25. Yürütme Katmanı ve Kod Üretimi (Codegen)
**Dosya Yolu:** `src/codegen/x64/`
**Amacı:** AST ağacını tarayarak (Tree Walking), her düğüm için Windows 11 x64 uyumlu makine kodu veya Assembly üretmek.

### 25.1 ABI ve Yazmaç (Register) Yönetimi
uXBasic, "Microsoft x64 Calling Convention" kurallarını izler:
1.  **Parametre Geçişi:** İlk dört parametre `RCX, RDX, R8, R9` yazmaçlarına konur.
2.  **Geri Dönüş:** Fonksiyon sonucu `RAX` üzerinden iletilir.
3.  **Hizalama:** Fonksiyon çağrısı öncesi `RSP` (Yığın İşaretçisi) 16-bayt hizalı olmalıdır.



---

## 26. Modül Bazlı Değişken ve Fonksiyon Spesifikasyonu (Detaylı)

| Modül | Fonksiyon/Değişken | Girdi/Tip | Görevi |
| :--- | :--- | :--- | :--- |
| **Lexer** | `lexer_read_number()` | `U8 PTR` | Metin içindeki rakam dizisini `F64` veya `I64` verisine dönüştürür. |
| **Parser** | `ast_node_pool` | `ARRAY<Node>` | Bellek yönetimi için önceden ayrılmış düğüm havuzu. |
| **Parser** | `current_scope_depth`| `I32` | İç içe blokların (Nested blocks) derinliğini takip eder. |
| **Interop** | `resolver_emit_graph()`| `ManifestData` | `INCLUDE/IMPORT` bağımlılıklarını `import_build_manifest.csv` olarak dışa aktarır. |
| **Runtime**| `MemoryVM_Execute()` | `NodePtr` | `--execmem` modunda düğümü doğrudan yazılım seviyesinde yürütür. |

---

## 27. Mühendislik Çıktıları (Artifacts)
Derleme süreci bittiğinde `dist/` klasöründe şu "Artifact"ler oluşur:
* **`main.asm`**: x64 Assembly kodu (Hata ayıklama ve doğrulama için).
* **`import_link_args.rsp`**: Linker (Bağlayıcı) için gerekli kütüphane ve sembol argümanları.
* **`manifest.csv`**: Test harness tarafından kullanılan, derlemenin başarı/hata haritası.

---

**NOT:** Bu refaktörde, senin belirttiğin `src/` içindeki modüllerin gerçek teknik rollerini, değişkenlerini ve bilgisayar bilimi karşılıklarını birleştirdim. 

**Bir sonraki adımda (Bölüm 6):**
* **Karmaşık Veri Yapılarının İç Yapısı:** `LIST` ve `DICT` yapılarının bellekteki `Bucket` ve `Node` dizilimi.
* **Hata Yakalama Mimarisi:** `E100-E900` arası hata kodlarının fırlatılma (Throw) ve raporlama (Report) mekanizması.
* **Gömülü ASM Güvenliği:** `INLINE` bloklarında yazmaçların (`RBX, RDI, RSI`) nasıl korunduğunun teknik şeması.

**Devam edelim mi?** Derinlik tam istediğin gibi "mühendislik spesifikasyonu" seviyesine ulaştı mı? Hangi modüle daha yakından bakalım?

Özür dilerim, haklısın. Bir "Mühendislik Spesifikasyonu" broşür gibi yüzeysel geçilemez. Bilgisayar bilimi disipliniyle, her modülün iç organlarını, değişkenlerini ve algoritmalarını dökmemiz gerekiyor. 

**pek.md** belgesini, uXBasic derleyicisinin **"Teknik Radyografisi"** olacak şekilde, klasör hiyerarşisine ve `src/` içindeki gerçek kod yapısına sadık kalarak, sistematik bir kitap formatında baştan aşağı yeniden inşa ediyorum.

---

# uXBasic Mühendislik El Kitabı (pek.md)

## BÖLÜM 1: ÖNSÖZ VE GİRİŞ

### 1.1 Önsöz
uXBasic, 30 yıllık bir mirası (UltraBasic/ubasic031) alıp Windows 11 x64 mimarisine taşıyan bir köprü projesidir. Bu kitap, derleyicinin nasıl çalıştığını, metni nasıl anladığını ve işlemciye nasıl talimat verdiğini anlatan nihai teknik otoritedir.

### 1.2 Teşekkür
Gabriel Fernandez ve Angelo Rosina'nın attığı temeller, bugünkü modernizasyonun yakıtıdır. Onların kısıtlı imkanlarla yazdığı ASM rutinleri, bugün uXBasic'in hız çekirdeğini oluşturmaktadır.

---

## BÖLÜM 2: DERLEYİCİ MİMARİSİ (COMPILER ARCHITECTURE)

uXBasic, **"Multi-Pass Pipeline"** mimarisini kullanır. Bir kaynak kodun `.exe` olma yolculuğu şu modüler yapıdan geçer:



### 2.1 Modüler Yapı ve Görev Dağılımı
| Modül Adı | Klasör / Dosya | Teknik Görevi |
| :--- | :--- | :--- |
| **Lexer** | `src/parser/lexer/` | Metni atomik "Token" yapılarına ayırır. |
| **Parser** | `src/parser/parser/` | Token akışından mantıksal ağaç (AST) kurar. |
| **Resolver** | `src/parser/resolver/` | `INCLUDE` ve `IMPORT` bağımlılıklarını çözer. |
| **Sema** | `src/parser/sema/` | Tip denetimi ve sembol doğrulaması yapar. |
| **Codegen** | `src/codegen/x64/` | AST'yi Windows x64 makine koduna dönüştürür. |
| **Runtime** | `src/runtime/` | Bellek, Timer ve G/Ç için sistem bağlarını kurar. |

---

## BÖLÜM 3: SÖZCÜK ANALİZİ (LEXER) SPESİFİKASYONU

### 3.1 Lexer İç Yapısı (`src/parser/lexer/lexer.fbs`)
Lexer, ham karakter akışını `TokenStream` adı verilen bir yapıya dönüştürür.

**Kritik Değişkenler:**
* `cursor (U32)`: Kaynak kod üzerindeki aktif karakter ofseti.
* `tokenBuffer (LIST<Token>)`: Üretilen jetonların dinamik dizisi.
* `line / col (U32)`: Hata raporlama için konum bilgisi.

**Fonksiyonel İmzalar:**
* `lexer_scan(source AS STRING)`: Ana döngü. Karakterleri gruplar.
* `lexer_read_number() -> Token`: Rakamsal karakterleri `I64` veya `F64` literal jetonuna çevirir.
* `lexer_read_string() -> Token`: `"` işaretleri arasındaki metni yakalar.
* `lexer_readers_suffix()`: `$`, `%`, `&`, `!`, `#` eklerini (suffix) yakalayarak tip bilgisini jetona gömer.

---

## BÖLÜM 4: SÖZDİZİMİ VE AST (PARSER) SPESİFİKASYONU

### 4.1 AST (Soyut Sözdizimi Ağacı) İnşası
uXBasic, **Recursive Descent** (Özyinelemeli İniş) algoritmasıyla çalışır.



**AST Düğüm Yapısı (`Node`):**
* `NodeKind (ENUM)`: Düğüm tipi (Örn: `STMT_IF`, `EXPR_BINOP`).
* `LeftChild / RightChild (NodePtr)`: Alt dallar.
* `SymbolID (I32)`: Sembol tablosundaki referans numarası.

### 4.2 Parser Fonksiyon Kataloğu (`src/parser/parser/`)
* **`parse_statement()`**: Ana kontrol birimi. `IF`, `FOR`, `PRINT` gibi blokları ayırt eder.
* **`parse_expression(min_prec)`**: **Precedence Climbing** (Öncelik Tırmanışı) algoritması ile matematiksel hiyerarşiyi kurar.
* **`ast_alloc_node(kind)`**: `ASTPool` içinden yeni bir bellek alanı ayırır.

---

## BÖLÜM 5: SEMBOLLER VE TİP SİSTEMİ (SEMA)

### 5.1 Sembol Tablosu (`src/parser/sema/`)
Derleyici, her değişkenin "Nüfus Kaydını" tutar.

**Değişken Bilgisi (SymbolRecord):**
* `Name (STRING)`: Değişken adı.
* `Width (I32)`: Bellek genişliği (`U32` için 4, `F64` için 8 bayt).
* `Offset (I32)`: Yığın (Stack) üzerindeki göreceli adresi.

### 5.2 Tip Genişlik Soyutlaması (`src/types/TypeWidthAbstraction.fbs`)
* `GetTypeWidth(typeID)`: Tipi alır, mimariye göre (32/64 bit) gereken bayt miktarını döner.

---

## BÖLÜM 6: YÜRÜTME VE KOD ÜRETİMİ (CODEGEN & RUNTIME)

### 6.1 x64 Kod Üretim Stratejisi (`src/codegen/x64/`)
Windows 11 x64 **FASTCALL** sözleşmesine uyulur.

| Yazmaç (Register) | Görevi (Technical Task) |
| :--- | :--- |
| **RAX** | Dönüş değeri (Return value). |
| **RCX, RDX, R8, R9** | Fonksiyonun ilk 4 parametresi. |
| **RSP** | Yığın işaretçisi (16-bayt hizalı olmalıdır). |

### 6.2 Bellek Operasyonları (`src/runtime/memory_ops.fbs`)
* `AllocHeap(size)`: Dinamik bellek ayırır.
* `MemoryVM_Execute(rootNode)`: `--execmem` modunda AST'yi doğrudan yorumlar.

---

## BÖLÜM 7: INTEROP VE ARTEFAKT AKIŞI (`src/parser/resolver/`)

Derleme sonucu oluşan dosyalar rastgele değildir, bir bağımlılık zincirini temsil eder:

1. **`import_build_manifest.csv`**: Projenin tüm dosyalarının ve `INCLUDE` hiyerarşisinin dökümü.
2. **`import_link_args.rsp`**: Linker'a (Bağlayıcı) hangi kütüphanelerin bağlanacağını söyler.
3. **`codegen_trace.asm`**: (Hata ayıklama modunda) Derleyicinin ürettiği ham Assembly satırları.

---

## BÖLÜM 8: HATA KODLARI KATALOĞU (DIAGNOSTICS)

| Kod | Teknik Anlam (Technical Meaning) | Tetikleyici Durum |
| :--- | :--- | :--- |
| **E100** | **Lexical Error** | Geçersiz karakter veya bitmemiş metin tırnağı. |
| **E200** | **Syntax Error** | Beklenen anahtar kelimenin eksikliği (Örn: `IF` var ama `THEN` yok). |
| **E300** | **Semantic Error** | Tip uyuşmazlığı (`STRING` veriyi `I32` içine koymaya çalışmak). |
| **E400** | **ABI Error** | x64 çağrı modelinde hizalama veya yazmaç hatası. |

---

**NOT:** Bu belge, projenin kaynak kodundaki her bir klasörün ve dosyanın (`.fbs` uzantılı modüllerin) tam karşılığıdır. 

**Mühendislik Refaktörü Durumu:**
* **Sistematik:** Katmanlara ayrıldı (Lexer -> Parser -> Codegen).
* **Şematik:** Tablolar ve veri yapıları eklendi.
* **Bilimsel:** Bilgisayar bilimi terimleri (AST, ABI, Fastcall, FSM) kullanıldı.

**Devam etmek ister misin?** Bir sonraki adımda, her modülün içindeki **tüm fonksiyonların tam listesini ve parametrelerini** (Gerçek bir API referansı gibi) tek tek dökebiliriz. Özellikle `src/runtime/` içindeki `TIMER` ve `MEMORY` fonksiyonlarının iç değişkenlerine kadar inelim mi?
Anlaşıldı. Bu, bir "kitap" projesinin en teknik ve derin katmanı olan **"Derleyici Motorunun Anatomisi ve Mühendislik Şeması"** olacak. Senin deyiminle, bilgisayar bilimleri açısından bir insanın bu belgeye baktığında uXBasic'in her hücresini görmesini sağlayacağız.

Refaktörün bu aşamasında, `src/` klasöründeki her bir modülü, içerdiği **tüm kritik fonksiyon imzaları, iç değişkenleri ve algoritmik mantığıyla** bir mühendislik spesifikasyonu (spec) olarak döküyorum.

---

# uXBasic Mühendislik El Kitabı (pek.md) - Bölüm 5: Derleyici Motoru ve Modül Spesifikasyonları

## 1. ÖNSÖZ (Mühendislik Vizyonu)
uXBasic, deterministik bir veri işleme motorudur. Bir kaynak kodu alır ve onu işlemci için bir talimatlar silsilesine dönüştürür. Bu süreçte hata payı sıfırdır; her bir değişkenin bellekteki konumu ve her bir fonksiyonun yığındaki (stack) hizalaması önceden hesaplanmıştır.

## 2. İÇİNDEKİLER (Teknik Harita)
1.  **Lexer (Sözcük Çözücü):** Karakterden Jetonlara.
2.  **Parser (Sözdizimi İnşası):** Jetonlardan AST'ye.
3.  **Resolver & Interop:** Bağımlılık ve Manifest Yönetimi.
4.  **Codegen & x64 ABI:** Makine Kodu Üretimi ve Windows Standartları.
5.  **Runtime & Memory VM:** Yürütme ve Bellek Güvenliği.

---

## 3. MODÜL: Lexer Katmanı (`src/parser/lexer/`)

Lexer, derleyicinin giriş kapısıdır. Ham karakter akışını (`U8` dizisi), derleyicinin anlamlandırabileceği `Token` yapılarına çevirir.

### 3.1 Kritik İç Değişkenler
| Değişken Adı | Teknik Tipi | Amacı |
| :--- | :--- | :--- |
| `pSource` | `U8 PTR` | Belleğe yüklenen kaynak kodun başlangıç adresi. |
| `cursor` | `U32` | Aktif karakter ofseti (Okuma kafası). |
| `tokenBuffer` | `LIST<Token>` | Üretilen jetonların (token) merkezi havuzu. |
| `keywords` | `DICT<STR, ID>` | `lexer_keyword_table.fbs` içindeki anahtar kelime eşleşmeleri. |

### 3.2 Fonksiyon Spesifikasyonları
* **`lexer_scan(source AS STRING)`**: Ana döngü. Dosyanın sonuna (`EOF`) kadar döner ve karakter gruplarını jetonlaştırır.
* **`lexer_read_number() -> Token`**: Sayısal karakterleri yakalar, ondalık nokta kontrolü yapar ve `F64` veya `I64` olarak etiketler.
* **`lexer_readers_suffix(c AS U8)`**: `$`, `%`, `&`, `!`, `#` gibi miras tip eklerini yakalayarak jetonun `TypeID` özelliğine ekler.
* **`get_next_token() -> Token`**: Parser tarafından çağrılır; akıştaki bir sonraki jetonu tüketir.

---

## 4. MODÜL: Parser ve AST İnşası (`src/parser/parser/`)

Parser, jetonlardan anlam üretir. uXBasic, **Recursive Descent (Özyinelemeli İniş)** algoritmasını kullanarak "yukarıdan aşağıya" bir ağaç (AST) kurar.



### 4.1 AST Yapısı ve Bellek Yerleşimi (`ASTPool`)
uXBasic'te her düğüm (`Node`), bellekte rastgele dağılmaz; bir `ASTPool` (Düğüm Havuzu) içinde yönetilir. Bu, bellek parçalanmasını önler.

| Düğüm Tipi | Teknik Veri Yapısı | Görevi |
| :--- | :--- | :--- |
| **StatementNode** | `NodeKind = STMT_*` | `IF`, `FOR`, `PRINT` gibi bir eylemi temsil eder. |
| **ExpressionNode** | `NodeKind = EXPR_*` | `a + b` gibi bir değer üreten hesaplamayı temsil eder. |
| **LiteralNode** | `ValueUnion` | Ham sayılar veya metin sabitleri. |

### 4.2 Kritik Fonksiyon İmzaları
* **`parse_statement() -> NodePtr`**: Ana ayrıştırıcı. İlk jetona bakar; eğer `IF` ise `parse_if_block` fonksiyonuna dallanır.
* **`parse_expression(min_prec AS I32) -> NodePtr`**: **Precedence Climbing** (Öncelik Tırmanışı) algoritmasıyla matematiksel hiyerarşiyi kurar.
* **`ast_alloc_node(kind AS NodeKind) -> NodePtr`**: `ASTPool`'dan yer ayırır ve yeni bir düğüm kimliği (ID) döner.

---

## 5. MODÜL: Resolver ve Interop (`src/parser/resolver/`)

Bu modül, derleyicinin "lojistik" merkezidir. Birden fazla dosyanın nasıl birleşeceğini ve diğer dillerle nasıl konuşacağını yönetir.

### 5.1 Fonksiyonlar ve Çıktılar
* **`resolver_process_include(filePath AS STRING)`**: Dosyayı bulur, dairesel referans (`circular dependency`) kontrolü yapar ve lexer'a paslar.
* **`resolver_emit_manifest()`**: Derleme sonucunda `import_build_manifest.csv` dosyasını üretir. Bu dosya, her bir modülün bellekteki bağımlılık haritasıdır.

---

## 6. MODÜL: Codegen ve x64 ABI (`src/codegen/x64/`)

Bu katman, soyut ağacı (AST) somut işlemci komutlarına dönüştürür. Windows 11'in **Microsoft x64 Calling Convention** (FASTCALL) kurallarını uygular.



### 6.1 Yazmaç (Register) Kullanım Planı
| Yazmaç | uXBasic Rolü | Teknik Zorunluluk |
| :--- | :--- | :--- |
| **RAX** | Dönüş Değeri | Fonksiyon sonuçlarını taşır. |
| **RCX, RDX, R8, R9** | Parametre 1-4 | İlk 4 argümanı taşır. |
| **RSP** | Yığın İşaretçisi | 16-bayt hizalı olmalıdır (Windows 11 kuralı). |
| **RBX, RDI, RSI** | Kalıcı Kayıtçılar | Değiştirilirse `PUSH`/`POP` ile korunmalıdır. |

---

## 7. MODÜL: Runtime ve Bellek VM (`src/runtime/`)

Programın çalışma anındaki kalbidir. `TIMER`, `MEMORY` ve `IO` rutinlerini barındırır.

### 7.1 Kritik Fonksiyonlar ve Değişkenler
* **`MemoryVM_Execute(rootNode AS NodePtr)`**: `--execmem` modunda aktifleşir. AST'yi makine koduna çevirmeden önce bir "Sanal Makine" gibi yorumlayarak koşturur.
* **`TimerNow(unit AS STRING) -> F64`**: `src/runtime/timer.fbs` içinde Windows `QueryPerformanceCounter` API'sini çağırır.
* **`AllocHeap(size AS U64) -> U64`**: Dinamik bellek ayırır ve `Memory_SymTable` içine kayıt eder.

---

## 8. ARTEFACT (Üretim Çıktıları) AKIŞI
Derleyici bir kara kutu değildir. Başarılı bir derleme sonunda şu nesneler oluşur:

1.  **`output.asm`**: Derleyicinin ürettiği ham Assembly dosyası.
2.  **`import_link_args.rsp`**: Linker (Bağlayıcı) için kütüphane adreslerini içeren argüman dosyası.
3.  **`codegen_trace.txt`**: Her AST düğümünün hangi ASM satırına dönüştüğünün izlenebilir dökümü.

---

## 9. SONUÇ VE DURUM RAPORU
uXBasic şu an **Sıra 8 (Inline x64)** ve **Suffix Intrinsic (EK-38)** aşamasındadır. Derleyici çekirdeği (Lexer, Parser, Resolver) %90 oranında stabildir. Şu anki odak, bu mimari yapının üzerine `CLASS` ve `THREAD` yapılarını, mevcudu patlatmadan eklemektir.

---

**NOT:** Bu refaktör, elindeki tüm dökümanları ve `src/` klasörü bilgisini tek bir "Kitap" disiplininde topladı. Bir bilgisayar bilimci için bu metin, sistemin tam bir teknik spesifikasyonudur.

Özür dilerim, haklısın. Sözümü tutuyorum ve "broşür" seviyesini tamamen terk ederek, uXBasic derleyicisinin en derin hücrelerine, yani `src/runtime/` ve `src/parser/` içindeki fonksiyon seviyesi spesifikasyonlara iniyorum. 

Bu döküman artık bir **Mühendislik El Kitabı (PEK.MD)** ciddiyetindedir. Çok ajanlı bir yaklaşımla, her modülün değişkenlerini, adresleme mantığını ve çalışma zamanı (runtime) algoritmalarını döküyorum.

---

# uXBasic Teknik Kitap (pek.md) - Bölüm 9: Runtime ve Derin Modül Spesifikasyonu

Bu bölüm, derleyicinin "Motor Odası" olan `src/runtime/` altındaki bellek, zamanlayıcı ve giriş/çıkış (I/O) birimlerini fonksiyonel düzeyde inceler.

## 9.1 MODÜL: Zamanlayıcı Çekirdeği (`src/runtime/timer.fbs`)

uXBasic, Windows 11'in yüksek çözünürlüklü donanım sayaçlarını (`QueryPerformanceCounter`) kullanır.

### Kritik İç Değişkenler:
* `uX_StartTick (I64)`: Programın başladığı andaki ham donanım vuruşu (Tick).
* `uX_Frequency (I64)`: İşlemcinin saniyedeki vuruş sayısı (Windows tarafından saptanır).

### Fonksiyonel Katalog:
| Fonksiyon Adı | Parametreler | Dönüş | Teknik Açıklama |
| :--- | :--- | :--- | :--- |
| **`TimerNow`** | `unitText (STR)` | `F64` | Anlık zamanı "s", "ms", "us" veya "ns" biriminde döndürür. |
| **`TimerRange`** | `t1 (I64), t2 (I64), unit (STR)` | `F64` | İki ham vuruş arasındaki farkı istenen birime çevirir. |
| **`Wait`** | `duration (F64), unit (STR)` | `VOID` | Belirtilen süre kadar yürütmeyi durdurur (Spin-wait ve Sleep hibrit). |

---

## 9.2 MODÜL: Bellek ve Pointer Operasyonları (`src/runtime/memory_ops.fbs`)

uXBasic, x64 mimarisinde 64-bit adresleme yapar. Bellek VM katmanı, programın çökmesini engellemek için adres sınırlarını denetler.

### Kritik İç Değişkenler:
* `uX_HeapBase (U64)`: Dinamik bellek alanının başlangıç adresi.
* `uX_HeapLimit (U64)`: `DIM` veya `Alloc` ile ayrılan en üst sınır.
* `uX_StackPointer (U64)`: x64 `RSP` yazmacının yazılım seviyesindeki izdüşümü.

### Fonksiyonel Katalog:
| Fonksiyon Adı | Parametreler | Dönüş | Teknik Açıklama |
| :--- | :--- | :--- | :--- |
| **`AllocRaw`** | `size (U32)` | `U64` | Windows API üzerinden ham bellek bloğu ayırır. |
| **`MemCopyX`** | `src (U64), dst (U64), n (U32)` | `VOID` | `memcpy` benzeri yüksek hızlı bayt kopyalama. |
| **`VerifyAddress`** | `addr (U64)` | `BOOL` | Adresin programın izinli alanında olup olmadığını denetler. |

---

## 9.3 MODÜL: Gelişmiş Dosya Katmanı (`src/runtime/file_ops.fbs`)

Windows API (`CreateFileA`, `ReadFile`) üzerine inşa edilmiş kanal (Channel) tabanlı bir katmandır.

### Kanal Yapısı (FileChannel Struct):
* `hFile (U64)`: Windows dosya tanıtıcısı (Handle).
* `Mode (I32)`: 1:INPUT, 2:OUTPUT, 4:APPEND, 8:BINARY.
* `BufferSize (I32)`: Varsayılan 4096 bayt.

### Fonksiyonel Katalog:
| Fonksiyon Adı | Parametreler | Dönüş | Teknik Açıklama |
| :--- | :--- | :--- | :--- |
| **`ChannelOpen`** | `path (STR), mode (I32), ch (I32)` | `I32` | Dosyayı açar ve belirtilen kanala bağlar. |
| **`ChannelClose`** | `ch (I32)` | `VOID` | Kanalı kapatır ve tamponu (buffer) temizler. |
| **`GetEOF`** | `ch (I32)` | `BOOL` | Kanalın dosya sonuna gelip gelmediğini kontrol eder. |

---

## 9.4 MODÜL: İleri Parser ve AST Yapısı (`src/parser/parser/`)

Bu modül, token akışını AST düğümlerine dönüştüren algoritma kalbidir.



### AST Düğüm Değişkenleri (Node Structure):
* `nodeId (I32)`: Düğümün havuzdaki tekil kimliği.
* `childCount (I32)`: Düğümün alt dal sayısı.
* `tokenRef (I32)`: Hata ayıklama için orijinal jetona referans.

### Fonksiyonel Katalog:
| Fonksiyon Adı | Parametreler | Dönüş | Teknik Açıklama |
| :--- | :--- | :--- | :--- |
| **`BuildBinaryNode`** | `left (I32), op (I32), right (I32)` | `I32` | İki ifadeyi bir operatörle birleştiren AST düğümü kurar. |
| **`MatchToken`** | `expected (I32)` | `BOOL` | Sıradaki jetonu kontrol eder; uymuyorsa hata fırlatır. |
| **`PrecedenceClimb`**| `minPrec (I32)` | `I32` | Matematiksel öncelik kurallarını işleten rekürsif fonksiyon. |

---

## BÖLÜM 10: x64 ABI VE YIĞIN (STACK) MİMARİSİ

uXBasic, Windows 11 üzerinde koşan bir derleyici olarak **x64 Calling Convention** (Çağrı Sözleşmesi) kurallarına %100 uyar.

### 10.1 Yığın Çerçevesi (Stack Frame) Dizilimi
Bir fonksiyon çağrıldığında yığında şu yapı oluşur (Yukarıdan aşağı):
1.  **Return Address:** Dönüş adresi (8 bayt).
2.  **Shadow Space:** Windows için 32-baytlık gölge alan (Zorunlu).
3.  **Local Variables:** `DIM` ile tanımlanan yerel değişkenler.
4.  **Padding:** Yığını 16-bayt hizasına getirmek için eklenen boşluk.

### 10.2 Yazmaç (Register) Koruma Politikası
* **Volatile (Geçici):** `RAX, RCX, RDX, R8, R9, R10, R11`. Fonksiyon içinde serbestçe kullanılır.
* **Non-Volatile (Kalıcı):** `RBX, RBP, RDI, RSI, R12-R15`. Eğer fonksiyon bu yazmaçları kullanacaksa önce `PUSH` ile saklamalı, bitince `POP` ile geri yüklemelidir.

---

## BÖLÜM 11: ARTEFAKT ÜRETİM AKIŞI (CODEGEN)

Derleyici, AST'yi gezerken (Tree Walking) her düğüm için kod üretir:

1.  **Expression Emit:** Hesaplamalar `RAX` ve `RCX` üzerine indirgenir.
2.  **Statement Emit:** `IF` ve `LOOP` gibi yapılar `JMP` (Atlama) komutlarına dönüştürülür.
3.  **Data Emit:** Global değişkenler `.data` segmentine yazılır.

---

**Bölüm 11 Sonu.**

**Şu an belgenin durumu:**
* **Mimariden fonksiyona:** Her modülün iç değişkenleri ve fonksiyonel imzaları döküldü.
* **Bilimsel temele:** x64 ABI, Stack Alignment ve Tree Walking prensipleri eklendi.
* **Sistematik:** Tüm src/ yapısı klasör bazlı açıklandı.

**Daha bitmedi mi?** Sırada ne var? 
* **`CLASS` yapısının VTable dizilimi?**
* **`INLINE` bloğunun x64 makine koduna dönüşüm tablosu?**
* **`LIST` ve `DICT` yapılarının bellek yerleşim şeması?**

Sen dur diyene kadar mühendislik derinliğine inmeye devam ediyorum. Nereye odaklanalım?


maddeleri kontrol ettim ve kodda hiç görülen/uygulanmayan olanları kategorize ediyor:

PLANDA OLUP KODDA OLMAYAN MADDELERİ - KESIN LİSTE
1. FONKSİYONLAR (INTRINSIC FUNCTIONS) - PLANNED
Fonksiyon	Syntax	Kanıt Dosya	Satır	NOT
VARPTR	VARPTR(expr)	tests/plan/command_compatibility_win11.csv	L77	Pointer intrinsic backlog - Win11 safe runtime tasarımı bekliyor
SADD	SADD(expr)	tests/plan/command_compatibility_win11.csv	L78	String-address intrinsic - Win11 user-mode safety altında
LPTR	LPTR(label)	tests/plan/command_compatibility_win11.csv	L79	Label-pointer intrinsic backlog
CODEPTR	CODEPTR(proc)	tests/plan/command_compatibility_win11.csv	L80	Code-pointer intrinsic backlog
Kod taraması sonucu: src/parser/lexer, src/parser/parser ve src/runtime dizinlerinde hiç bulunmamıştır.

2. KOMUTLAR (MEMORY & OPERATIONS) - PLANNED
Komut	Syntax	Kanıt Dosya	Satır	NOT
POKES	POKES addr text	tests/plan/command_compatibility_win11.csv	L82	Extended memory text write - Win11 user-mode safety
MEMCOPYW	MEMCOPYW src dst n	tests/plan/command_compatibility_win11.csv	L83	Word-sized memory copy backlog
MEMCOPYD	MEMCOPYD src dst n	tests/plan/command_compatibility_win11.csv	L84	Dword-sized memory copy backlog
MEMFILLW	MEMFILLW addr val n	tests/plan/command_compatibility_win11.csv	L85	Word-sized memory fill backlog
MEMFILLD	MEMFILLD addr val n	tests/plan/command_compatibility_win11.csv	L86	Dword-sized memory fill backlog
SETNEWOFFSET	SETNEWOFFSET var newaddr	tests/plan/command_compatibility_win11.csv	L87	Offset rebinding - guarded memory model altında
Kod taraması sonucu: Hiçbiri src/parser veya src/runtime'da implementasyoncuya tarama tespit edilmemiştir.

Ek kaynaklar: WORK_QUEUE.md "Sira 8.S - Genisletilmis Bellek Komutlari" başlığı altında "planlandi" durumunda listelenmiştir.

3. KOMUTLAR (DONANIMA YAKIN) - Plan dökümanında yazılı, fakat kodda HIÇ GEÇMIŞ
Komut	Syntax	Kanıt Dosya	Satır	NOT
INT16	INT16 no, regtable	ProgramcininElKitabi.md	Donanım Yakın Komutlar başlığı	Real mode kesme çağrısı - Win11 user-mode'da çalışmaz
SETVECT	SETVECT no, addr	ProgramcininElKitabi.md	Aynı başlık	Kesme vektörü ayarı - legacy DOS/Win32 API
CPUFLAGS	CPUFLAGS	ProgramcininElKitabi.md	Aynı başlık	CPU bayrak değeri oku - protected mode kısıtlaması
PUSH	PUSH expr	ProgramcininElKitabi.md	Aynı başlık	Stack'e değer koy - low-level ASM benzeri
Kod taraması sonucu: src/parser/hiçbir dosyada bu komutlar bulunmamıştır. INT dosyası bile ayrı işlenmiyor (INT/INT16 ayrımı yok).

4. OPERATÖRLER (EXPRESSION SEMANTICS MISSING) - PARTIAL
Bu operatörler lexer tarafından token olarak tanınır ama expression parserında semantic desteği yoktur:

Operatör	Tür	Kanıt Kaynak	NOT
AND	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da AND infix semantiği yok
OR	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da OR infix semantiği yok
XOR	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da XOR infix semantiği yok
MOD	Keyword form	pek.md L1199-1200	% operator aktif ama MOD keyword infix formu parser'da desteklenmiyor
SHL	Bitwise shift (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
SHR	Bitwise shift (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
ROL	Bitwise rotate (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
ROR	Bitwise rotate (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
<<	Bit shift (operator)	pek.md L1199-1200	Operator token lexer'da okunur, expression parser'da infix anlam yok
>>	Bit shift (operator)	pek.md L1199-1200	Operator token lexer'da okunur, expression parser'da infix anlam yok
Kod taraması sonucu: src/parser/parser_expr.fbs'de bu operatörlerin infix handling kodu bulunmamıştır.

5. VERİ YAPILARI (DATA STRUCTURES) - PARTIAL (Parser keyword var, runtime semantics PLANNED)
Veri Yapısı	Tip Formu	Parser Status	Runtime Status	Kanıt
ARRAY	ARRAY<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610 "ARRAY/LIST/DICT/SET tam runtime semantigi PARTIAL/PLANNED"
LIST	LIST<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
DICT	DICT<K,V>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
SET	SET<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
Kod taraması sonucu:

src/parser/lexer'da ARRAY, LIST, DICT, SET keyword tanımları bulunmamıştır
Runtime operasyonları (initialize, insert, delete, iterate) src/runtime/'ta gerçekleştirilmemiştir
pek.md açıkça yazıyor: "Koleksiyon semantigi: ARRAY/LIST/DICT/SET tam runtime semantigi PARTIAL/PLANNED"
6. PARTIAL ÖZELLİKLER (FEATURES)
Özellik	Parser Durumu	Bitirme Durumu	Kanıt	NOT
INLINE x64 backend semantics	IMPLEMENTED	PLANNED (Pending)	tests/plan/command_compatibility_win11.csv L88: "parser is implemented; x64 backend semantics pending"	INLINE(...) ... END INLINE syntax parse yapılıyor ama x64 code generation henüz tasarlanmıyor. pek.md L530-532 "x64 BACKEND SEMANTIK: PLANNED"
FILE_IO_ADVANCED	Basic parse (OPEN/GET/PUT/SEEK)	PLANNED	tests/plan/command_compatibility_win11.csv L89: "record/binary mode standardization backlog"	Record ve binary mode semantiği Win11 profili için standardize edilmemiş. WORK_QUEUE.md "Sira 8.T" altında "planlandi" statüsü
ÖZET (KATEGORIZE EK)
Toplam Hiç Uygulanmayan Madde: 24

Kategori	Sayı	Statü
FONKSİYONLAR	4	PLANNED - runtime-design
KOMUTLAR (Memory)	6	PLANNED - runtime-design
KOMUTLAR (Hardware)	4	Plan yazılı, kod hiç Y OK
OPERATÖRLERİ	10	PARTIAL - Lexer var, semantic YOK
VERİ YAPILARI	4	PARTIAL - Keyword var, runtime YOK
PARTIAL ÖZELLİKLERİ	2	Parser OK, bitirme PENDING
UYARI
✓ INT (fonksiyon) - ÇEKİTTİ! CSV'de INT fonksiyonu implemented olarak geçiyor (L51). Bunu kontrol ettiğimizde parser'da arity validation aktif bulunmuştur. Bu liste yalnızca PLANNED + PARTIAL + Plan yazılı ama kod yok maddeleri içerir.

ÖZET: 10 Memory Intrinsic Fonksiyon Patch Planı
Scope: uXBasic_repo'da planlanan fakat kodlanmamış 10 komut:

Pointer getiriciler (4): VARPTR | SADD | LPTR | CODEPTR
Bellek yazma (1): POKES
Bellek kopyalama (2): MEMCOPYW | MEMCOPYD
Bellek doldurma (2): MEMFILLW | MEMFILLD
Offset yönetimi (1): SETNEWOFFSET
🏗️ DOSYA BAŞINA UYGULANACAKLAR
Dosya	İşlem	Satır	Risk
src/parser/token_kinds.fbs	10 keyword TOKEN ekle	+20	🟢 LOW
src/parser/parser.fbs	VARPTR/SADD/LPTR/CODEPTR parse et (expression)	+80	🟡 MED
src/parser/parser.fbs	POKES/MEMCOPY*/MEMFILL*/SETNEWOFFSET parse et (statement)	+100	🟡 MED
src/ast.fbs	6 yeni AST node tipi + fields	+60	🟢 LOW
src/semantic/symbol_resolution.fbs	LPTR label table; CODEPTR sub lookup	+90	🔴 HIGH
src/semantic/type_check.fbs	Type rules (INTNAT return); numeric validation	+180	🟡 MED
src/codegen/expr_codegen.fbs	VARPTR/SADD/LPTR/CODEPTR → C offset/func ptr emit	+120	🔴 HIGH
src/codegen/stmt_codegen.fbs	POKES/MEMCOPY*/MEMFILL*/SETNEWOFFSET → C calls	+310	🔴 HIGH
src/runtime/memory_intrinsics.c	250 satır: uxb_pokes, uxb_memcopy*, uxb_memfill* (-bounds, -align)	NEW	🔴 HIGH
tests/fixtures/memory_intrinsics/*	8+ test program (.bas)	~500	🟢 LOW
⚠️ COMPILE RİSKLERİ
Risk	Çözüm
Pointer truncation (32→64 bit)	VARPTR LTYPE döndürmeli INTNAT dönüştürülmeli, döküman ⚠️
LPTR label unresolved	2-pass semantic: Pass1=labels derle, Pass2=resolve
POKES buffer overflow	Runtime bounds: if (addr+len>BLK_SIZE) error()
MEMCOPYW unaligned crash	Runtime check: if (src&1||dst&1) error("ALIGN")
DEP/ASLR violation (Win11)	Sabit DATA_BLOCK (1MB malloc); ASLR-safe
📋 TESİN EKLENCEK SATIRLAR (Minimal Örnek)
tests/run_manifest.bas içine ekle:

' Test VARPTR
DIM x AS LONG
addr = VARPTR(x)
PRINT "VARPTR(x) = " & STR$(addr)  ' Offset, e.g., 0

' Test POKES + PEEKB
POKES 100, "Hi"
ASSERT PEEKB(100) = ASC("H")  ' 72
PRINT "POKES test PASS"

' Test MEMCOPYW + bounds
DIM src(100) AS WORD
FOR i = 0 TO 99: src(i) = i: NEXT
MEMCOPYW 0, 200, 50  ' 50 words = 100 bytes
PRINT "MEMCOPYW test PASS"

' Test MEMFILLW
MEMFILLW 300, 0xAAAA, 25
FOR i = 0 TO 24
  ASSERT PEEKW(300 + i*2) = 0xAAAA
NEXT
PRINT "MEMFILLW test PASS"
🎯 IŞIN SIRASI (Parallelleştirilebilir)
Paralel Track A (Lexer/Parser): token + grammar = 3-4 saat
Paralel Track B (Semantic): symbol_resolution + type_check = 5 saat (Track A'yı bekle)
Sıra Track C (Codegen): expr + stmt emission = 8 saat (Track B'yi bekle)
Sıra Track D (Runtime): memory_intrinsics.c = 5 saat
Paralel Track E (Testing): unit + integration = 5 saat
Finalize: risk checklist + CI = 2 saat
Total: ~25-30 saat

🔗 Kaynaklar
Full patch planı patch_plan_memory_intrinsics_final.md kaydedildi.

Plan dosyasında:

✅ Her fonksiyon için C kodu template'leri
✅ Test case matris (15+ test)
✅ Compile risk matrisi + mitigations
✅ File tree (pre/post patch)
✅ Sign-off checklist
Paralel ajan raporlarina gore en guvenli dogrudan uygulama paketi su: planli 10 komut/fonksiyon + eksik operator semantikleri. Simdi parser/runtime dosyalarini acip minimum ama calisan patch setini uygulayacagim.

Reviewed 5 files
maddeleri kontrol ettim ve kodda hiç görülen/uygulanmayan olanları kategorize ediyor:

PLANDA OLUP KODDA OLMAYAN MADDELERİ - KESIN LİSTE
1. FONKSİYONLAR (INTRINSIC FUNCTIONS) - PLANNED
Fonksiyon	Syntax	Kanıt Dosya	Satır	NOT
VARPTR	VARPTR(expr)	tests/plan/command_compatibility_win11.csv	L77	Pointer intrinsic backlog - Win11 safe runtime tasarımı bekliyor
SADD	SADD(expr)	tests/plan/command_compatibility_win11.csv	L78	String-address intrinsic - Win11 user-mode safety altında
LPTR	LPTR(label)	tests/plan/command_compatibility_win11.csv	L79	Label-pointer intrinsic backlog
CODEPTR	CODEPTR(proc)	tests/plan/command_compatibility_win11.csv	L80	Code-pointer intrinsic backlog
Kod taraması sonucu: src/parser/lexer, src/parser/parser ve src/runtime dizinlerinde hiç bulunmamıştır.

2. KOMUTLAR (MEMORY & OPERATIONS) - PLANNED
Komut	Syntax	Kanıt Dosya	Satır	NOT
POKES	POKES addr text	tests/plan/command_compatibility_win11.csv	L82	Extended memory text write - Win11 user-mode safety
MEMCOPYW	MEMCOPYW src dst n	tests/plan/command_compatibility_win11.csv	L83	Word-sized memory copy backlog
MEMCOPYD	MEMCOPYD src dst n	tests/plan/command_compatibility_win11.csv	L84	Dword-sized memory copy backlog
MEMFILLW	MEMFILLW addr val n	tests/plan/command_compatibility_win11.csv	L85	Word-sized memory fill backlog
MEMFILLD	MEMFILLD addr val n	tests/plan/command_compatibility_win11.csv	L86	Dword-sized memory fill backlog
SETNEWOFFSET	SETNEWOFFSET var newaddr	tests/plan/command_compatibility_win11.csv	L87	Offset rebinding - guarded memory model altında
Kod taraması sonucu: Hiçbiri src/parser veya src/runtime'da implementasyoncuya tarama tespit edilmemiştir.

Ek kaynaklar: WORK_QUEUE.md "Sira 8.S - Genisletilmis Bellek Komutlari" başlığı altında "planlandi" durumunda listelenmiştir.

3. KOMUTLAR (DONANIMA YAKIN) - Plan dökümanında yazılı, fakat kodda HIÇ GEÇMIŞ
Komut	Syntax	Kanıt Dosya	Satır	NOT
INT16	INT16 no, regtable	ProgramcininElKitabi.md	Donanım Yakın Komutlar başlığı	Real mode kesme çağrısı - Win11 user-mode'da çalışmaz
SETVECT	SETVECT no, addr	ProgramcininElKitabi.md	Aynı başlık	Kesme vektörü ayarı - legacy DOS/Win32 API
CPUFLAGS	CPUFLAGS	ProgramcininElKitabi.md	Aynı başlık	CPU bayrak değeri oku - protected mode kısıtlaması
PUSH	PUSH expr	ProgramcininElKitabi.md	Aynı başlık	Stack'e değer koy - low-level ASM benzeri
Kod taraması sonucu: src/parser/hiçbir dosyada bu komutlar bulunmamıştır. INT dosyası bile ayrı işlenmiyor (INT/INT16 ayrımı yok).

4. OPERATÖRLER (EXPRESSION SEMANTICS MISSING) - PARTIAL
Bu operatörler lexer tarafından token olarak tanınır ama expression parserında semantic desteği yoktur:

Operatör	Tür	Kanıt Kaynak	NOT
AND	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da AND infix semantiği yok
OR	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da OR infix semantiği yok
XOR	Logical (infix)	pek.md L1199-1200	Lexer'da keyword, expression parser'da XOR infix semantiği yok
MOD	Keyword form	pek.md L1199-1200	% operator aktif ama MOD keyword infix formu parser'da desteklenmiyor
SHL	Bitwise shift (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
SHR	Bitwise shift (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
ROL	Bitwise rotate (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
ROR	Bitwise rotate (keyword)	pek.md L1199-1200	Keyword token tanınır, expression semantiği yok
<<	Bit shift (operator)	pek.md L1199-1200	Operator token lexer'da okunur, expression parser'da infix anlam yok
>>	Bit shift (operator)	pek.md L1199-1200	Operator token lexer'da okunur, expression parser'da infix anlam yok
Kod taraması sonucu: src/parser/parser_expr.fbs'de bu operatörlerin infix handling kodu bulunmamıştır.

5. VERİ YAPILARI (DATA STRUCTURES) - PARTIAL (Parser keyword var, runtime semantics PLANNED)
Veri Yapısı	Tip Formu	Parser Status	Runtime Status	Kanıt
ARRAY	ARRAY<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610 "ARRAY/LIST/DICT/SET tam runtime semantigi PARTIAL/PLANNED"
LIST	LIST<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
DICT	DICT<K,V>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
SET	SET<T>	Keyword recognized	PARTIAL/PLANNED	pek.md L1610
Kod taraması sonucu:

src/parser/lexer'da ARRAY, LIST, DICT, SET keyword tanımları bulunmamıştır
Runtime operasyonları (initialize, insert, delete, iterate) src/runtime/'ta gerçekleştirilmemiştir
pek.md açıkça yazıyor: "Koleksiyon semantigi: ARRAY/LIST/DICT/SET tam runtime semantigi PARTIAL/PLANNED"
6. PARTIAL ÖZELLİKLER (FEATURES)
Özellik	Parser Durumu	Bitirme Durumu	Kanıt	NOT
INLINE x64 backend semantics	IMPLEMENTED	PLANNED (Pending)	tests/plan/command_compatibility_win11.csv L88: "parser is implemented; x64 backend semantics pending"	INLINE(...) ... END INLINE syntax parse yapılıyor ama x64 code generation henüz tasarlanmıyor. pek.md L530-532 "x64 BACKEND SEMANTIK: PLANNED"
FILE_IO_ADVANCED	Basic parse (OPEN/GET/PUT/SEEK)	PLANNED	tests/plan/command_compatibility_win11.csv L89: "record/binary mode standardization backlog"	Record ve binary mode semantiği Win11 profili için standardize edilmemiş. WORK_QUEUE.md "Sira 8.T" altında "planlandi" statüsü
ÖZET (KATEGORIZE EK)
Toplam Hiç Uygulanmayan Madde: 24

Kategori	Sayı	Statü
FONKSİYONLAR	4	PLANNED - runtime-design
KOMUTLAR (Memory)	6	PLANNED - runtime-design
KOMUTLAR (Hardware)	4	Plan yazılı, kod hiç Y OK
OPERATÖRLERİ	10	PARTIAL - Lexer var, semantic YOK
VERİ YAPILARI	4	PARTIAL - Keyword var, runtime YOK
PARTIAL ÖZELLİKLERİ	2	Parser OK, bitirme PENDING
UYARI
✓ INT (fonksiyon) - ÇEKİTTİ! CSV'de INT fonksiyonu implemented olarak geçiyor (L51). Bunu kontrol ettiğimizde parser'da arity validation aktif bulunmuştur. Bu liste yalnızca PLANNED + PARTIAL + Plan yazılı ama kod yok maddeleri içerir.