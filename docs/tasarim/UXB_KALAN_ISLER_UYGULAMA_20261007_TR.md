# uXBasic — kalan işlerin uygulama kaydı, 2026-10-07

Mete'nin “uygulamada kalan işleri de tamamla, önerilere göre devam et” talimatıyla
2026-10-06 karar önerileri uygulanıyor. Bu kayıt önceki araştırmayı ve kanıtları
tamamlar; bütün derleyicinin tamamlandığı anlamına gelmez. Geliştirme sorumlusu Codex.

## Doğrulanan sonuçlar

| Konu | Değişiklik | Gerçek çalışma kanıtı |
| --- | --- | --- |
| D03 / S-174 CONTINUE | Ayrı AST düğümü; en yakın veya FOR/DO/WHILE ile seçilmiş döngünün artış/koşul/sonraki öğe hedefi; FINALLY ve LOCK geçişleri | Altı motorda normal/iç içe döngüler; AST/MIR/native'de dizi, LIST, Unicode metin ve kilit; FINALLY dört motorda. `core_h.json` ve `scopes_j.json` |
| D04 / S-186 STATIC | Rutin başına ayrı tipli global depo; kilitle korunan ilk kullanım; aynı bildirimin birden fazla değişkeni; mevcut global yaşam döngüsü ve Model D erişimi | Tek sefer başlangıç, tekrar çağrı, özyineleme, STRING ve aynı adın farklı rutinlerde kullanımı dört motorda. Sekiz görev, 800 artırma: son değer 901; ilk değer hesaplama sayısı 1. `core_h.json` |
| D05 / S-189 ENUM tipi | Ayrıştırıcı tür kaydı, nominal kimlik, seçilen tamsayı boyutu/hizası, türlendirilmiş parametre ve dönüş; tam U64 sabit ayrıştırma ve aralık denetimi | I8, I32, U32 ve U64 maksimum değeri dört motorda; farklı ENUM ataması ve taban aralığı taşması kontrollü ret. `core_h.json` |
| D06 / S-182 MID ataması | Yazılabilir atama; bir paylaşılan STRING dönüşümü; indeks ve sınıf alıcısı için tek değerlendirme; boş/kısa/uzun replacement ve hedef sınırı | Değişken, TYPE alanı ve dizi dört motorda; BYREF AST/MIR/native. Yan etkili dört argüman tam dört kez çalıştı. Alıcı değiştirilse de ilk nesnenin alanı güncellendi; alıcı fonksiyonu bir kez çağrıldı. `core_h.json`, `scopes_j.json` |
| D01 / S-176 dönüşüm | Tip adıyla tamsayı dönüşümü keser; dar tip bitlerini korur; unsigned üst yarı signed host dönüşümüne doğrudan verilmez | `float_integer_casts`: I32(2.7)=2, negatif/dar/64 bit değerler; U64(2^63) doğru. CINT/CLNG yuvarlama, FIX kesme, INT aşağı yuvarlama dört motorda. `core_h.json` |
| H01-H03 / S-193 | CLI hata sınırı ayrıştırıcı ve tanı listesine bağlandı; tekrar sayısı korunarak sınır uygulanıyor; gerçek JSON Schema ve gömülü dağıtım üretimi | `diagnostics_i.json`: 27/27. Sınır 1/2/4, geçersiz sınırlar, çift dil, kaynak bilgisi, katalog, log hatası, yedekli rotasyon, kayıp native host; şema gerçek kaydı kabul edip eksik dil/yanlış kaynak/yanlış şiddeti reddetti |

Kitap ölçümü: `reports/remediation_20261007_remaining/book_h.json`.
130 dosyanın çıktı beklentisi bulunan **98/98** örneği AST, MIR ve native x64'te
geçti. Diğer 32 örnekte çıktı beklentisi bulunmuyor; bunlar ölçülmüş özellik kabulü
sayılmadı. Önceki 94/98 kaydı korunuyor.

`reports/remediation_20261007_remaining/language_i.json`: geniş dil kümesi **199/199**.
Bu aday, daha sonra eklenen sınıf STATIC kapsamı ve sayısal koşul testlerini
içermiyor; bu uç durumlar sonraki adaylarla ayrıca sınanıyor.

## Uygulama sırasında bulunan ek hatalar

- STRING `+=` AST'de sayıya dönüyordu; eski native yol tamsayı toplamı yapıp
  erişim ihlaline gidebiliyordu. Metin birleştirme yolları düzeltildi.
- Eski native LEFT/RIGHT/MID geçici metinleri ortak tamponu tekrar kullanıyordu.
  İç içe çağrıda önceki sonuç değişiyordu. Kalıcı sonuç üreten ortak runtime
  işlevlerine bağlandı; metin alanlarının çıkarılan tipi AST'ye yazılıyor.
- MIR/native'de iki argümanlı MID çağrısının işleyicisi eksikti. Atlanan uzunluk
  açık “kalan metin” değeriyle üç argümanlı runtime çağrısına indirgeniyor.
- Sınıf metodunun ilk STATIC deyimi yeni sınıf alanı gibi yorumlanıyordu.
  Bildirim biçimini koruyarak açık END METHOD/FUNCTION/SUB öncesindeki yerel
  STATIC için gövde ayrımı eklendi; ek kabul testi sürüyor.
- AST'nin dar koşul değerlendiricisi tipli dönüşümün farklı yolunu kullanıyordu;
  doğrudan F64 çağrılı koşul hata veriyordu. Koşul tek kez değer olarak hesaplanıyor.
  Eski native kesirli IF/DO/WHILE koşulları da düzeltiliyor.
- FINALLY kaynak bağlamının, terk edilen iç döngü ve IF bağlamından ayrılması
  gerekiyor. Döngü/IF/TRY/LOCK yığınları korunup geçiş sırasında doğru bağlam
  kullanılıyor; iç içe FINALLY kabulü genişletiliyor.

## Kapanmamış kapsamlar

Bu çalışma skalar/metin STATIC ve mevcut koleksiyon kontrol akışını doğruladı.
LIBTYPE sağlayıcılarının STATIC başlangıç/yıkım sözleşmeleri, iç içe managed
değerler ve iterator kaynaklarının geçiş anındaki bırakılması T01/T05 ile birlikte
ayrıca ölçülmeli. ENUM ad alanları ve açık ENUM dönüşümlerinin tüm yüzeyi,
NaN/sonsuz/aralık dışı native tamsayı dönüşümleri henüz genel kabul almadı.

Önceki belgedeki T01-T14 kapsamı korunuyor: LIBTYPE yaşam döngüsü ve manifest
sürümleri; typed PTR TO; F80 payload/stride; iterator protokolü; meta birleştirme;
görev aktarımı ve web görevleri; JOINALL LIST; web i64/float/BYREF/GOSUB;
MIR metadata eşliği; kaynak temelli yüzey matrisi; legacy sınırları; dağıtım;
büyük kaynak performansı. Başarılı ret testleri çalışan özellik sayılmıyor.

S-194: Windows'taki uyarının tam olay kaydı bulunmadan bilgisayar belleğinin
bozulduğu veya sorunun tamamen çözüldüğü söylenemez. Bulunan erişim ihlali ve
kapasite hataları ayrı süreç kanıtlarıyla izleniyor. Önceki kayıtlar silinmedi.

## Tanı şeması bakımı

Kaynak: `docs/schemas/uxb.diagnostics.v1.schema.json`.
`tools/maintenance/generate_diagnostic_schema.py`, şemayı compiler içine
`src/common/diagnostic_schema_data.fbs` olarak gömer; dağıtım sırasında dosya
yerini bulmaya bağımlılık oluşmaz. Mevcut şema metadata alanları korunmuştur.
[JSON Schema 2020-12 tanımı](https://json-schema.org/draft/2020-12/json-schema-core)
esas alınmıştır. Yerel `jsonschema` doğrulayıcısı hazır olduğu için yeni paket
kurulmasına gerek duyulmadı.

## Yayın durumu

Ana executable bu kayıt yazılırken önceki doğrulanmış yayındır. Yeni adaylar
`bin/uxb_remaining_*_20261007.exe` olarak ayrı derlendi. Son kaynakla resmi
`build_64.ps1 -Force`, geniş regresyon ve yayın/hash kontrolü tamamlanmadan
yeni aday ana yayın olarak işaretlenmeyecek. Sonuçlar bu bölüme eklenecek.


### Ek kabul turu

`scopes_k.json`: 19/19. Sınıf metodu ve THREAD içindeki STATIC, sınıf alıcılı
MID, sayısal IF/DO/WHILE koşulları ve FINALLY'nin döngü/IF bağlamı doğrulandı.
`enums_l_ready.json`: 15/16; kalan native hata ENUM dizi elemanı/parametresi
metadatasının unsigned/signed türünü kaybetmesiydi. Dizinin payload'ı doğru,
okuma ve yazdırma türü yanlış kalıyordu. Bu son bağ Source'ta tamamlanıyor;
sonraki adayla yeni ölçüm ve geniş regresyon yapılacak. `TYPE_` ile başlayan
kullanıcı tür adları dört motorda korundu; açık ENUM dönüşümü de dört motorda
geçti. Hatalı ilk turlar, düzeltme öncesi kanıt olarak saklanıyor.


### Son aday kabulü

`acceptance_n.json`: 36/36; `diagnostics_n.json`: 27/27. ENUM dizisi ve dizi
parametresi signed/unsigned payload'ını doğru okuyor; U64 maksimum eleman ve
parametre aynı değeri yazdırıyor. Açık ENUM dönüşümü dört motorda; nominal
kimlik korunuyor. Aday compiler SHA256:
`28B4203ADDC42B7D1B41B6281279F74AA669BBCDEB7FC5A241FF5FD24EE811B9`.
`source_candidate_n.json`: 574 FreeBASIC kaynak dosyası, compiler'dan yeni kaynak
yok. Önceki ana compiler `1E036E83...1393752` ve runtime/variant yedekleri
`published_before_remaining/manifest.json` ile korunmuştur. Resmi ana derleme ve
geniş regresyon başlatılıyor; sonuç gelmeden genel tamamlanma iddiası yok.

### Ek kayıtların devralınması ve kütüphane kabulü

S-198 kural örneklerinde kayıtlı üç sorun ana binary ile yeniden üretildi:
`book_rules_baseline.json` 12/15. API metadata başlangıcı aday O'da düzeldi;
STR/MAGIC ve operatör denemelerinin O/P/Q/S sonuçları korunuyor. S turu API
4/4, TYPE_ adları 4/4, geniş MAGIC denemesi AST'de geçti; diğer üç motorda
VALUE alanının yanlışlıkla yerel sayılması görünür oldu. VALUE istisnası yalnız
PROPERTY SET kapsamına indirildi; bu son değişiklik T adayıyla doğrulanacak.
Hazırlanmış AST çağrılarında parametrenin bildirilen sınıf türü korunuyor;
MIR'da fonksiyon sonucunun alıcı tipi ortak type inference ile bulunuyor.

STRING bileşik atama kaydı **S-200** olarak ayrıldı; tarihsel S-198 kaydı
korundu. Önceki başlık çakışması bu eşlemeyle giderildi.

SDL UnpackR/G/B/A sonuçları 0..255 olmasına rağmen I64 ifadeyi I32 döndürüyordu.
D02 açık dönüşüm kararı korunarak dört RETURN'e I32 eklendi; eski kaynak
`fixture_migrations/uxsdl3_before_explicit_return.bas` içinde duruyor.
`sdl_core_explicit_return.log` AST/MIR 2/2; native yollar çalışma dizinine
bağımlı DLL aramasıyla 127 verdi. Derleyici konumu ve paket kökü fallback'i
T adayına eklendi; temiz geçici klasörde yeniden kabul gerekli.

SDL/raylib süreçleri geçici çalışma dizininde, zaman sınırı ve gerçek çıkış
koduyla yürütülüyor. Typed-task raporları ayrı koşu klasörlerine yazılıyor;
önceki çalışma kanıtları silinmiyor. Sistem geçici klasörü dışına otomatik
silme reddediliyor. Bu koşucu değişiklikleri çalışan özellik sayısı değildir.

Düzeltme: öneri belgesindeki ortak iterator başlığı **T04**, yüzey matrisi
**T10**, performans ve ifade sırası **T12**, dağıtım **T13**, düşük token
çalışma **T14** olarak izlenir. LIBTYPE/iterator açıkları T01/T04'tür.

### Son kaynak yayını ve ek kabul — 2026-10-07 Codex

Son dört compiler kopyası SHA256
`B81C7BBADDE5DAA000A0821FD6B73D7B11A9522DC85308B949E448ECAAB70DC1`.
Resmi build_final_u çıkış 0; sayısal sınır sabitinin FreeBASIC uyarısı bilimsel
sayı yazımıyla giderildi. Son aday U `C7B9E9BA...CBA26BC9`; kaynak snapshot'ı
`source_final_u.json`: 574 FreeBASIC dosya, adaydan yeni kaynak yok.

S-198 ek kabulü `magic_u.json` 12/12: API metadata, MAGIC ADD/SUB, sınıf
parametresi/dönüşü, STRING ve I32 TOSTRING, fonksiyon alıcısının tek çağrısı,
TYPE_ adı ve VALUE alanı dört motorda. S-201 temiz geçici dizin SDL core 4/4;
raylib 3D ve image 4/4. Diğer kütüphane örnekleri ayrı sınırlı süreçlerde
sürüyor. Genel LIBTYPE/OOP yaşam döngüsü kapanışı iddia edilmiyor.

Kitap taraması artık eklenen 22_kurallar ve 23_tasarim grupları dahil 154 dosya:
`book_final_u.json` 121/122 beklentili örnek, 32 beklentisiz. Tek düşen taskgroup
MIR süre aşımı (60 saniye). Aynı kaynak ana compiler ile 180 saniye sınırında
AST/MIR/native 30000/çıkış 0 verdi (`book_taskgroup_repeat.json`). Beklenti veya
program azaltılmadı. Birleştirilmiş kanıt 122 beklentili örneğin değerini doğrular;
ilk turun süre aşımı silinmez ve T12 performans kabulü sayılmaz.

`fault_u_growth/capture.json`: 1024 değişkenlik büyüme, 228 bellek örneği,
çıkış 0, 50.97 saniye, tepe çalışma kümesi 134148096 bayt. S-194'teki Windows
uyarısının tam metni/kodu kullanıcıya asenkron soruldu. Bu süreç ölçümü Windows
uyarısının nedenini veya bütün programlarda sızıntı yokluğunu kanıtlamaz.

Ara regresyon 17 paket/1083 kontrol temizdi; ek kaynak düzeltmeleri sonrası
kendi test süreçleri durdurulup rapor `regression_interim_preserved.json` ile
korundu. Son ana compiler'da 25 model paketi `regression_final_u.md` için yeniden
koşuyor; SDL/raylib 11 örnek/44 motor ayrı `libraries_u.json` kabulüne bağlanıyor.
Tamamlanmadan toplam başarı oranı veya genel compiler kapanışı verilmez.

### Kaynak temelli kabul envanteri

`tools/maintenance/uxb_acceptance_inventory.py` kaynak kayıtlarından otomatik
JSON/CSV üretir. Son çıktı `reports/remediation_20261007_remaining/acceptance_inventory`:
239 lexer anahtar sözcüğü, 318 yüzey kaydı, 88 deyim yönlendirmesi, 77 typed
builtin ve 2174 kütüphane bildirimi; toplam 2896 **kayıt**. Aynı sözcük farklı
kategorilerde bulunabilir; bu sayı ayrı çalışan özellik sayısı değildir.
Her kayıtta kaynak dosyası, satır ve hash bulunur. Altı motorun hücreleri
UNMEASURED başlar. Kayıt/ALL politikası PASS sayılmaz; bütün bir programın
geçmesi içindeki her token'a destek yazmaz. Builtin çıkarımı gerçek defterin
77 sayısıyla kontrol edildi. Type/provider/operator/protokol envanteri ve
özellik bazlı gerçek kanıt bağları açık: T10'un tamamı kapanmış sayılmaz.

### Geniş kabulde çıkan S-202

Son ana U compiler'daki task_model 189/192: üç kontrol TYPE_TASK kanonik
metadata nedeniyle düştü; diğer paket sonuçları ayrı izleniyor. Kullanıcı
TYPE_ sınıf adlarını korurken TASK/TASKGROUP'in iç damgaları iki MIR yolunda
açıkça canonical adlarına çevriliyor. V adayı hazır olunca görev paketinin
aynı program/beklentiyle tekrarı ve yeni ana derleme yapılacak. U turu
tamamlanmış başarılı yayın olarak gösterilmiyor; düşen rapor korunuyor.

## Son yayın ve kapsamlı kabul kaydı

Son ana dört compiler kopyası:
`6A0B179711F79FFFF8A2E2C4EB549AD7318DE94FE3EF890B1982397D219C2C2B`.
Aday V: `728B654FE024F38E515FDDD7CB05730B799AFD92EE5C8B6269F7738FE77701AF`.
Resmi build_final_v çıkış 0; 574 FreeBASIC kaynak hash'i eşleşiyor, adaydan yeni
kaynak yok. Runtime C4E57609...CFFB617 değişmedi; önceki varyant kabulü korunur.

`acceptance_final.md` / `final_verification.json`: **1377/1377 model kontrolü,
25 paket kapsamı**. Bu, U geniş turu ve son iki dosyalık TASK metadata
 değişikliğinin etkilediği V tekrarının birleşimidir. V'de yedi paket **682/682**;
tek V turunda 25 paket çalıştırıldığı söylenmez. U turu 1374/1377 olarak
korunur; üç TYPE_TASK hatası V'de aynı program ve beklentiyle düzeldi.
Ana V'de doğrudan görev dönüşü 4/4, kontrol koşucusu da çıkış 0.

Kütüphaneler: **44/44**, SDL sekiz/raylib üç örnek, dört motor; U compiler ve
aynı runtime. Son iki metadata satırı dışında kaynak değişmedi. Kitap:
**122/122 beklentili örneğin değer kanıtı**, 32 beklentisiz. İlk tur 121/122
(60 s taskgroup MIR timeout), aynı program 180 s tekrarında geçti; ilk kayıt
silinmedi. Eğitim belgesi 113/113 örnekle yeniden üretildi, eski belge arşivde.

Başarılı ret kontrolleri gerçek özellik desteği sayılmaz. Süre aşımı tekrarı
T12 performans kapanışı değildir. D01 native nonfinite/sınır davranışı,
H01-H03 üretici çevirileri/nihai oturum durumu, T01-T14'ün tam yüzeyi ve
S-194 uyarı eşleştirmesi açık. T10 envanteri 2896 kaynak kaydıdır; ölçülmemiş
hücrelerde PASS üretilmez. Genel compiler hedefi tamamlandı işareti verilmedi.
