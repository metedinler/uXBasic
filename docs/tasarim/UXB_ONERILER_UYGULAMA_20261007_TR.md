# uXBasic — önerilerin uygulanması, 7 Ekim 2026

Bu kayıt, `UXB_INCELEME_KARAR_ONERILERI_20261006_TR.md` belgesinin uygulama sonucudur.
Mete'nin “sorunları çözmeye önerilenlerle devam et” talimatı önerilen yönü
yetkilendirir. Önceki kararlar korunur; belgede anlatılan alternatifler seçilmiş
sayılmaz. Genel compiler tamamlama hedefi hâlâ açıktır.

## Yapılan değişiklikler

| Alan | Sonuç | Sınır |
|---|---|---|
| B01 / S-195 | AST değişkenleri 256 hücrelik sabit adresli sayfalarda saklanıyor; gerektiğinde yeni sayfa ekleniyor. Hücre adresleri değişmediği için VARPTR ve BYREF bağlantıları korunuyor. | Değişken tablosu için düzeltme; diğer bütün tablolardaki kapasite sınırlarının kaldırıldığı anlamına gelmez. Gerçek bellek tükenmesi ayrıca zorlanmadı. |
| H01 | Yapılandırılmış tanının kodu, iki mesajı ve kaynak konumu doğrudan hata merkezine aktarılıyor. Aynı kayıt tekrar geldiğinde tek hata sayılıyor, tekrar sayısı saklanıyor. | Eski metin üreten bütün katmanlar henüz yapılandırılmış üreticiye taşınmadı. |
| H02 | `--diag-format json` uyumluluk hata yolunda JSON üretiyor; iki dil ve seçilen görünüm korunuyor. UTF-8 katalog girdileri eski kodu gerçekten değiştiriyor. Editör görünümü seçilen dili kullanıyor. | Eski ayrıntı metinlerinin tamamı çevrilmedi; şablon parametreleri ve eksik çeviri denetimi tamamlanmadı. |
| H03 | Özel hata günlüğünün adı korunuyor. Bilinmeyen kaynak konumu 0:0 / `known=false`. Günlük açılamadığında işlem çıkış 22 ile duruyor. Rotasyon eski `.bak` dosyalarını değiştirmiyor. Bağlanmamış yerel host çağrısı sabit kodla çıkış 1 veriyor. | Tek nihai oturum manifesti, bütün çocuk süreçlerin abort/timeout bağları ve gerçek şema doğrulaması henüz tamamlanmadı. |
| D01 / S-176 | Aralığa sığan sabit tamsayı literalleri I8/U8/I16/U16/I32/U32/I64/U64 hedefe atanabiliyor. Aralık dışı literal reddediliyor; değişken daraltması açık dönüşüm istiyor. İşaretli literaller sabit katlamada Double'a çevrilmiyor. | Ondalıktan tamsayıya tip adı dönüşümü, CINT/CLNG, NaN/inf ve U64 dönüşüm sınırları için kalan eşitlik çalışması açık. BOOL ve BIGINT bu literal istisnasına dahil değil. |
| D02 / S-166 | Açık RETURN ifadeleri bildirilen rutin türüne karşı atama kuralıyla denetleniyor. Sayısal dönüşüm MIR'da açık taşınıyor; AST RETURN_TYPE düğümünü okuyor ve F32 çağrı sonucunu doğru hassasiyetle yazıyor. | Her aggregate/LIBTYPE dönüşü için kapsamlı kabul tamamlandı sayılmaz. |
| D07 / S-185 | Üç argümanlı IFF çağrısı ortak tembel koşul ifadesine indirgeniyor. Yalnız seçilen dal çalışıyor; ortak sayısal tür taşınıyor; metin sonucu korunuyor. Infix IFF mantıksal eşdeğerlik olarak kalıyor. Argüman sayısı hatasının TR/EN kodu ve konumu aynı. | Kütüphane tipi/aggregate dal sahipliği ayrıca ölçülmeli. |
| WASM | Küçük tamsayı ve BOOL çevrimleri gerçek WASM işlemlerine dönüştürülüyor. Desteklenmeyen çevrim türü sessiz host çağrısına gönderilmiyor. | WASM i64/F32/F64 modelinin genel tamamlanması ayrı açık iş. |
| Runtime dağıtımı | std/libuv/tbb/auto/full varyantları aynı güncel C++ kaynağından yeniden derlendi; gerçek paralel callback, F64 ABI ve başarısız host çıkışı sınandı. | Bu kabul, bütün kütüphane paketlerinin bütün API'lerinin tamamlandığı anlamına gelmez. |
| Tek sahiplik ve bağlam | Otomatik bekçi/ajan oturumu girişleri proje politikasına bağlandı; dış AI başlatma engeli sınandı. Yerel belge indeksi ve kaynak haritası kullanılıyor. | Başka bir AI ortamı bu çalışmada çağrılmadı. Model tarafından yazılmış harita amaçları kaynak kanıtı yerine kullanılmadı. |

Gece kaydedilmiş S-083 tek satırlık IF ve S-132 F32 yamaları korunarak
derlemeye alındı. Tek dal çalışması için ayrıca gerçek kabul programı eklendi.

## Kabul kanıtları

Kontroller farklı derleme turlarına aittir. Örtüşen turlar toplanarak yeni bir
başarı oranı üretilmez. Beklenen reddetme kontrolleri, çalışan özellik olarak
sayılmaz.

| Ölçüm | Sonuç | Kayıt |
|---|---|---|
| Sayfalı değişken tablosu: 1.024 global, 1.500 yerel, BYREF ve VARPTR | 5/5 | `reports/remediation_20261007/stable_cells.json` |
| Değişken tablosunun ilk regresyonu | 560/560, 8 paket | `cells_regression.md` |
| Eski abort'un 255/256/257 değişkenle yeniden çalıştırılması | Üçü de çıkış 0 | `capacity_255`, `capacity_256`, `capacity_257` altındaki `capture.json` |
| Sabit literal sınırları, geçerli ve yanlış RETURN | 32/32, dört motor | `type_acceptance_verified.json` |
| Günlük/JSON/UTF-8/editör/tekrar/rotasyon/host çağrısı | 19/19; IFF argüman sayısı dahil | `diagnostics_iff.json` |
| Küçük tamsayı, dar sonuç ve açık çevrimler | 6/6; AST, MIR, iki yerel motor, JS, gerçek WASM | `web_literals_verified.json` |
| IFF tembellik, yan etki, seçilmeyen hatalı dal, metin/float ve arity | 14/14 | `iff_acceptance_checked.json` |
| Kitabın dar tamsayı örneği | AST/MIR/yerel geçti | `book_narrow.json` |
| Kitabın IFF örneği | AST/MIR/yerel geçti; ayrıca beklentisiz yoklama kaydı | `book_iff.json` |
| Kitabın bütün 130 örneği | 94/98 beklentili örnek üç motorda geçti; 32 beklentisiz | `book_examples_final.json`, `book_examples_final.log` |
| Beş runtime varyantı | 10/10; gerçek callback ve F64 ABI, bağlanmamış çağrı çıkış 1 | `runtime_variants.json` |
| Son ana derleyicide geniş regresyon | 1276/1276; 25/25 paket; 2210 saniye | `final_regression.md`, `final_regression.log` |
| Son konsolidasyon bölümü | 167/167: 145 dil/çalıştırma, 3 matris, 19 tanı | `reports/compiler_consolidation/20261007_104043_1494/` |

İlk IFF testinde eski yerel arka uç metin yerine adres, ondalık yerine tamsayı
yazdı. Tip damgalarının okunması ve koşullu float üretimi düzeltildi; aynı
programın beklentisi değiştirilmeden 14/14 geçti. İlk WASM testinde küçük rutin
sonucu 127 yerine 0 çıktı; gerçek CAST üretimiyle aynı test 6/6 geçti.

Geniş regresyonda `tests/task_model/iso_pure_body.uxb` eski RETURN denetiminin
boşluğuna dayanıyordu: ABS nedeniyle F64 türündeki toplamı I32 sonuçlu THREAD'den
örtük döndürüyordu. Önerilen D02 kuralıyla reddedilmesi doğrudur. Örneğe açık
I32 dönüşümü eklendi; çıktı beklentisi korunuyor. Önceki kaynak
`fixture_migrations/iso_pure_body_before.uxb` dosyasında saklandı. İlk düşen
regresyon kaydı korunur, sonraki doğrulama ayrı kaydedilir.

İlk geniş tur 1245/1249 idi: tek eski görev örneği dört motorda yeni RETURN
kuralıyla reddedildi. Örnek taşındıktan sonraki turda native sonuç 0 çıktı;
bu gerçek MIR tür hatası beklenti değiştirilmeden düzeltildi. Son geniş tur
güncel kaynak ve güncel örnekle 1276/1276 geçti. Eski düşen raporlar korunur.

Örneğin taşınması ayrıca MIR'da bir uyuşmazlığı görünür yaptı: tür bağlayıcının
F64 tanımladığı ABS, tamsayı argümanla MIR'da tamsayı üretiliyordu. Üstündeki
açık I32 dönüşümü tamsayı bitlerini Double gibi okuyup 0 veriyordu. ABS sonucu
ve onu içeren aritmetik artık kayıt defterindeki F64 türünü taşıyor.
`typed_builtin_arithmetic` için beklenti dört motorda aynı kalıyor.
Gerçek görev programı da son ana derleyicide `1ayQ1-1` / `15`, çıkış 0 verdi;
`pure_body_verified_capture/capture.json` süreci ve çıktıyı kaydeder.

## Derleme ve geri dönüş

Resmî `build_64.ps1 -Force` yolu kullanıldı. İzole adaylar ve önceki dağıtım
dosyaları ayrı tutuldu. Ana dört compiler kopyası ile runtime/import library
yedekleri `reports/remediation_20261007/published_previous/manifest.json`
altındadır. Dosya silinmedi ve önceki kaynak değişiklikleri sıfırlanmadı.

Son yayın ve kaynak/test karmalarının özeti
`reports/remediation_20261007/final_verification.json` dosyasındadır.

Son compiler SHA256: `1E036E83C2FACE94732D08B67D9D1F487751BE5199666A556493A270D1393752`.
Ana runtime SHA256: `C4E57609D1B37064FF74C8E4D2DF77B741E662B75A766BE1AE7EB7713CFFB617`.
Varyantların ayrı hash ve yedekleri `variant_publication.json` dosyasındadır.
Test koşucusu sonraki çalışmalarda her paket sonunda küçük bir
`.progress.json` kaydı yazar; tam terminal çıktısını tekrar taramak gerekmez.

## Açık işler

- D03 CONTINUE, D04 STATIC yerel, D05 adlandırılmış ENUM ve D06 MID ataması.
  Son kitap ölçümündeki dört başarısız beklentili örnek de bu dört başlığa ait.
- D01 tip adıyla ondalık dönüşüm ile CINT/CLNG davranışlarının bütün motorlarda
  eşitlenmesi; NaN/inf ve U64 sınırlarının ölçülmesi.
- H01–H03 için kalan üretici göçü, ayrıntı çevirileri, parametreli mesajlar,
  hata limiti, gerçek JSON şeması ve tek nihai oturum durumu.
- Önceden kabul edilmiş LIBTYPE yaşam döngüsü ve görev aktarımı,
  typed PTR, F80 düzeni, iterator protokolü, birleşik meta zinciri,
  JOINALL LIST, web görevleri/BYREF/GOSUB ve MIR metadata kapsamı.
- Kaynaktan türetilen yüzey matrisi, gerçek başarı kanıtlarının matrise
  bağlanması, S-196 kayıt/kapı eksikleri ve S-191 ölçek performansı.
- S-194: kullanıcının Windows bellek uyarısının tam olayı henüz
  ilişkilendirilmedi. S-195 düzeltildi diye bu uyarı kapanmış sayılmaz.

S-196 bu araştırma sırasında koordinasyon defterinde görülen ek kayıttır;
kayıt korunmuştur. Bu belgenin kanıtları kapsam dışındaki açık maddeleri
tamamlanmış göstermez.
