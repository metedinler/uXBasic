# Downloads envanteri, silme adayları ve RAG koruma kuralları

Bu belge `C:\Users\mete\Downloads` ve alt klasörleri için geçerlidir. Amaç veri kaybetmeden, çalışan uXBasic ortamını bozmadan ve Ollama RAG eğitim belgelerini koruyarak adayları kanıtla sınıflandırmaktır.

## 1. Dil ve kapsam ayrımı

- `uxm`, ayrı bir dil/projedir; uXBasic sınıflandırmasına katılmaz.
- `uxb`, `UXBc`, `uXBasic`, `UXSTAR`, `uxotcc`, `UXClazz` ve bunların kaynak/yama/test/belgeleri uXBasic kapsamındadır.
- `PDSX` sarmalayıcıları, yalnızca gerçek uXBasic bağımlılığı ve kullanım amacı doğrulanırsa uXBasic ile ilişkilendirilir.
- Tanım yalnızca dosya adına göre yapılmaz; içerik, arşiv manifesti, kaynak referansı ve kullanım izleri incelenir.

## 2. Durum etiketleri

`KEEP-CANONICAL`: Güncel kaynak, çalışır build/runtime girdisi, uygulanmış yama veya gerekli belge.

`KEEP-RAG`: Ollama eğitim/RAG için seçilmiş özgün belge veya doğrulanmış tekil kopya.

`KEEP-REFERENCE`: Tarihî yama, rapor, test çıktısı veya karşılaştırma için gerekli kayıt.

`REVIEW-DUPLICATE`: Aynı içerik olabileceği düşünülen; hash/diff bekleyen kopya.

`REVIEW-OBSOLETE`: Eski olduğu düşünülen; yama uygulanması ve build/test katkısı henüz doğrulanmamış dosya.

`REVIEW-UNRELATED`: uXBasic/UXM dışı görünen; içerik ve referans kontrolü tamamlanmamış dosya.

`DELETE-APPROVED`: Yalnızca kullanıcı açıkça onayladıktan sonra silinebilir. Bu etiket otomatik verilmez.

## 3. Silme adayı oluşturma zorunlulukları

Bir dosya veya klasör ancak aşağıdaki bütün kanıtlar toplandıktan sonra `REVIEW-*` olabilir; doğrudan silinemez:

1. Tam yol, dosya türü, boyut, oluşturulma/değiştirilme/erişim tarihleri kaydedilir.
2. Aynı boyuttaki ve benzer adlı dosyalar SHA-256 ile karşılaştırılır.
3. Arşivler açılmadan silinmez; arşiv içeriği dosya yolu, boyut ve hash ile klasör içeriğiyle karşılaştırılır.
4. `.md`, `.txt`, `.doc`, `.docx`, `.pdf`, kod ve test dosyalarının içeriği okunur; yalnız uzantıya göre karar verilmez.
5. Yamanın mevcut `uxb/src` ve ilgili klasörlere uygulanıp uygulanmadığı aranır. Uygulanmamış veya yalnızca belge olarak kalmış yama korunur.
6. Dosyanın güncel derlemeye, runtime'a, test runner'a, dağıtım paketine, script'e veya manifest'e katkısı kontrol edilir.
7. Python/PowerShell/BAT/test dosyalarının çağıranları, import'ları ve referansları aranır.
8. `.vscode` ve benzeri gizli klasörler ayar, görev, extension veya build girdisi içerip içermediği incelenmeden aday gösterilmez.
9. RAG manifestleri, indeks listeleri ve eğitim kaynaklarıyla çapraz kontrol yapılır.
10. Karar kanıtı ve belirsizlik nedeni rapora yazılır. Belirsizlik varsa `KEEP-REFERENCE` seçilir.

## 4. Klasör ile ZIP aynıysa

- Klasör ve ZIP'in her dosyası karşılaştırılır; yalnız toplam boyut veya dosya adı yeterli değildir.
- ZIP açılabiliyor, tüm dosya yolları/boyutları/hash'leri eşleşiyor ve klasörde fazladan dosya yoksa klasör `REVIEW-DUPLICATE` olur.
- ZIP'te olmayan tek bir klasör dosyası bile varsa klasör korunur; eksik dosya ayrıca raporlanır.
- ZIP bozuksa veya üretim tarihi/içeriği belirsizse klasör korunur.
- ZIP'in farklı adla kopyalanmış veya başka klasöre açılmış olması göz ardı edilmez. Aynı ada/konuma sahip olma zorunluluğu yoktur.
- Yeniden adlandırılmış klasörler için önce dosya sayısı, toplam boyut, uzantı dağılımı ve göreli yol imzası; ardından dosya içerik hash'leri karşılaştırılır.
- ZIP içeriğiyle klasörün yalnızca bir alt klasör kökü veya üst klasör adı farklıysa bu fark normalize edilerek yeniden karşılaştırılır.
- Ucuz imza eşleşmiyorsa klasör silme adayı yapılmaz; imza eşleşmesi tek başına da silme kanıtı değildir.

## 5. Ollama RAG koruma kuralları

- Ollama için seçilecek belgeler `KEEP-RAG` ile işaretlenir; özgün belgeler silinmez.
- Birebir kopyalar hash ile tekilleştirilir, fakat en eski/özgün dosya ve tüm metadata korunur.
- Aynı konunun farklı sürümleri diff ile karşılaştırılır; yeni belge eskisinin üzerine doğrudan yazılmaz.
- RAG manifestinde kaynak yol, dil, konu, sürüm/tarih, hash, içerik türü ve seçilme nedeni tutulur.
- İndeksleme maliyetini azaltmak için yalnız doğrulanmış tekil içerik indekslenir; kaynak arşiv ve belgeler ayrı korunur.
- Ollama çalışmıyorsa veya indeks tamamlanmamışsa hiçbir RAG kaynağı silinmez.

## 6. Kullanıcı onayı ve işlem güvenliği

- Bu çalışma boyunca silme/taşıma yapılmaz.
- Son raporda her aday için tam yol, neden, korunacak yedek, hash/diff sonucu ve yama/build/RAG etkisi gösterilir.
- Kullanıcı açıkça onaylamadan hiçbir `DELETE-APPROVED` işlemi uygulanmaz.
- Onay verilse bile önce geri alınabilir arşivleme/karantina ve işlem günlüğü tercih edilir.
- Aktif Claude/Codex alanları, mevcut uXBasic kaynak ağacı, çalışma zamanı DLL'leri ve yedekler kullanıcı onayı olmadan değiştirilemez.

## 7. Envanter çıktıları

Detaylı araç `inventorymake.py` şu alanları üretir: tam/bağıl yol, boyut, uzantı, oluşturulma/değiştirilme/erişim zamanı, kategori, kategori gerekçesi ve isteğe bağlı SHA-256. Raporlar `inventory_downloads` altında tutulur; silme işlemi içermez.
