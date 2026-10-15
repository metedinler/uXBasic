# uXBasic Programlayıcının Cep Kitabı — Cilt 1
# Başlangıç, Kullanım Hakkı, Dosyalar ve Mimari

## Ön söz

Bu kitap uXBasic'i yalnız komut listesi olarak değil, çalışan bir düşünme aracı olarak anlatır. Genç programcı için en önemli bilgi şudur: program, bilgisayara verilen emirlerin kuru dizisi değildir; veri toplama, karar verme, dış dünya ile konuşma ve sonucu ölçme düzenidir. uXBasic bu düzeni BASIC tadında okunur bir yüzeyle, C/C++/ASM ve DLL gücüyle, tarayıcı ve WebAssembly çıktısıyla birleştirmek için tasarlanmıştır. Burada geçen teknik sözcüklerde önce Türkçe ad verilir, gerekirse köşeli parantez içinde kısa açıklama ve parantez içinde İngilizce karşılığı yazılır. Örneğin kanca [derleyicinin bir aşamasına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [dış fonksiyonu uXBasic'e düzenli çağrı gibi gösteren ince katman] (wrapper) demektir.

Bu sürüm, `uxb(30.05_4).zip` içindeki son gerçek kaynak ağacı, patch/readme kararları, çalışma zamanı kütüphaneleri, araçlar, kanca ve sarmalayıcı klasörleri esas alınarak genişletildi. Kitapta bazı yama adları geçse bile bunlar artık “sonradan eklenecek parçalar” gibi değil, uXBasic'in normal programlama yüzeyi ve araç düzeni gibi anlatılır. Büyük sayı ailesi olan `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` ve `BIGINIT` bu nedenle normal dil/kütüphane yetenekleri olarak ele alınır. Her şeyin çalıştığı varsayılmıştır; bu kitap kullanıcının hayal gücünü tetiklemek için örnekleri gerçek kullanım senaryolarına bağlar.

## Kullanım hakkı, lisans ve sorumluluk

Bu kitap ve örnekler MIT lisansı anlayışıyla kullanılabilir. MIT lisansı; kodu inceleme, değiştirme, dağıtma, özel veya ticari projede kullanma özgürlüğü verir. Buna karşılık yazar, bu kitabın kullanımından doğabilecek veri kaybı, yanlış hesap, gelir kaybı, donanım sorunu, üçüncü taraf API ücretleri, sistem çökmesi veya hukuki sonuçlardan sorumlu değildir. Özellikle DLL, dosya silme, bellek yazma, ağ ve yapay zeka API kullanımlarında kullanıcı kendi ortamını, gizli anahtarlarını ve güvenlik sınırlarını korumalıdır.

Sorun, öneri veya destek için: `zmetedinler@gmail.com`. Kullanımdan memnun kalırsanız küçük destek için 50 TL veya 25 ABD doları göndermeniz sevinçle karşılanır. IBAN ve ödeme bilgileri dağıtım paketinin ticari sürümünde ayrıca verilebilir. Bu bilgi bağış niteliğindedir; kitabı kullanma hakkını sınırlamaz.

## Genç programcıya öğütler

Bir dili öğrenmenin yolu önce komut ezberlemek değildir. Önce “hangi veriyi alıyorum, bu veriye hangi kararı veriyorum, sonucu nereye yazıyorum?” sorusunu sormalısın. Her örneği çalıştırmadan önce kâğıda üç kutu çiz: giriş, işlem, çıkış. Giriş kullanıcıdan, dosyadan, sensörden, ağdan veya DLL'den gelebilir. İşlem; koşul, döngü, fonksiyon, veri yapısı ve kütüphane çağrısıdır. Çıkış; ekran, dosya, grafik, tarayıcı, API cevabı veya başka programa verilen veri olabilir. İyi programcı hata çıkmayacağını varsaymaz; hata çıkarsa ne yapacağını baştan yazar. uXBasic'te `TRY`, `ASSERT`, test kapıları, rapor dosyaları ve çıktı sözleşmeleri bu yüzden önemlidir.

## Dosya uzantıları

|Uzantı|Anlamı|Ne zaman kullanılır|Küçük örnek|
|---|---|---|---|
|`.uxb`|Ana uXBasic kaynak dosyası|Programın çalışacak ana gövdesi için|`main.uxb`|
|`.bas`|BASIC uyumlu kaynak|Eski BASIC örnekleri veya sade dosyalar için|`demo.bas`|
|`.uxbh`|uXBasic başlık/dahil dosyası|Ortak sabit, tip, DECLARE ve yordamları paylaşmak için|`dosya.uxbh`|
|`.uxmh`|uXBasic modül başlığı|Kütüphane modülü sarmalayıcıları için|`uxstats.uxmh`|
|`.json`|Yapılandırılmış çıktı|AST/MIR/rapor/manifest/test sonucu için|`mir.json`|
|`.js`|Tarayıcı JavaScript çıktısı|Tarayıcıda çalıştırmak için|`program.js`|
|`.wat`|WebAssembly metin çıktısı|WASM insan okunur ara çıktısı için|`program.wat`|
|`.wasm`|WebAssembly ikili çıktısı|Tarayıcı veya WASM çalışma zamanı için|`program.wasm`|
|`.asm`|Assembly çıktısı|x64/x86 veya gömülü hedefe yakın çıktı için|`program.asm`|
|`.exe`|Windows çalıştırılabilir dosya|Yerel program çıktısı için|`program.exe`|

## Mimari katmanlar

uXBasic mimarisi bir mutfak gibi düşünülebilir. Önce malzeme gelir: kaynak dosyası. Ön-işleyici [kaynak derlenmeden önce çalışan düzenleyici] (preprocessor) malzemeyi ayıklar; hedefe göre HTML, JS, WAT, varlık ve bildirim parçalarını hazırlar. Sözcükleyici [metni anlamlı parçalara bölen katman] (lexer) komutları, adları, sayıları ve işaretleri ayırır. Çözümleyici [komutları ağaç yapısına çeviren katman] (parser) artık “IF nerede başladı, FOR nerede bitti, FUNCTION ne döndürür?” gibi yapıyı kurar. Soyut söz ağacı [programın ağaç biçimindeki anlamlı iskeleti] (AST) bu yapıyı taşır. Anlam ve tip katmanı değişkenin ne olduğunu, hangi işlemin hangi tipe uygulanabileceğini ve dış çağrının imzasını denetler. Orta gösterim [hedeflerden bağımsız ara komut düzeni] (MIR), programı JS, WAT, x64, x86 veya yorumlayıcıya götürülebilecek ortak biçime indirir. Arka uç [son çıktı üretici] (backend) hedef dosyaları yazar. Çalışma zamanı [program çalışırken yardım eden kütüphane düzeni] (runtime) dosya, matematik, büyük sayı, yapay zeka, grafik ve dış dünya işlerini taşır.

## Kanca ve sarmalayıcı düşüncesi

Kanca (hook) derleyicinin bir aşamasına “beni de haberdar et” demenin güvenli yoludur. İyi kanca asıl işi bozmaz; yalnız izleme, rapor, ölçüm veya özel genişletme yapar. Sarmalayıcı (wrapper) ise dış dünyanın dağınık fonksiyonlarını uXBasic tarafında temiz bir çağrıya çevirir. Genç programcı şunu unutmasın: iyi sarmalayıcı, kötü kütüphaneyi bile okunur yapar; kötü sarmalayıcı, iyi kütüphaneyi anlaşılmaz yapar. Bu yüzden her DLL çağrısında `DECLARE`, `ALIAS`, `MODULE`, `NAMESPACE`, hata kontrolü ve kaynak kapatma düzeni birlikte düşünülür.

## Çıktılar ve raporlar

uXBasic yalnız program üretmez; aynı zamanda ürettiği programın kanıtını da verir. `tokens.json`, `ast.json`, `symbol_table.json`, `type_table.json`, `mir.json`, `program.js`, `program.wat`, `index.html`, `manifest.json`, `stdout.txt`, `stderr.txt` ve `runtime_trace.json` gibi çıktılar bunun parçalarıdır. Bir çıktı yoksa test kapısı bunu söylemelidir; çıktı uydurmak yasaktır. Genç programcı için ders şudur: gerçek programcılıkta “çalıştı gibi” değil, “kanıtıyla çalıştı” denir.
