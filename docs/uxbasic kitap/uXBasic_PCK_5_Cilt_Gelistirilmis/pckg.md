
# uXBasic Programlayıcının Cep Kitabı

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Kaynak kabulü:** Bu genişletilmiş sürüm, `uxb(30.05_4).zip` son kaynak gerçekliği, `30.05_3` içindeki önceki gerçeklik notları, patch/readme/tools/kütüphane klasörleri ve önceki `pck*.md` çalışması üzerine kurulmuştur. Bu kitapta patch olarak görünen ADIM33, ADIM34, ADIM35 kararları da normal program özelliği kabul edilmiştir.

## Kullanım hakkı, sorumluluk ve destek

MIT Lisansı şunu anlatır: Bu kodu ve belgeyi kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi projenize katabilirsiniz. Lisans metnini ve telif bilgisini korumalısınız. Yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, yanlış DLL/API çağrısı, hatalı bilimsel sonuç, yanlış istatistik yorumu veya sistem bozulmasından yazar sorumlu değildir. Gerçek cihaz, para, sağlık, resmi işlem, üretim hattı ve güvenlik işlerinde önce küçük test, sonra yedek, sonra onaylı çalışma yapılmalıdır.

Bu çalışmadan fayda görürseniz gönüllü destek olarak 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince bu satıra yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`. Destek zorunlu değildir; amaç geliştirme emeğini sürdürebilmektir.

## İçindekiler

|Cilt|Dosya|Konu|
|---|---|---|
|1|`pck1.md`|Başlangıç, dosyalar, çıktı türleri, mimari, hook, wrapper, araçlar, test kapıları|
|2|`pck2.md`|Anahtar sözcükler, komutlar, ön-işleyici, veri tipleri, işleçler, yerel fonksiyonlar|
|3|`pck3.md`|Değişkenler, sınırlar, diziler, LIST/DICT/SET/ARRAY, OOP, olay, pipe, thread, bellek|
|4|`pck4.md`|Kütüphaneler: math, stats, tensor, matrix, dataset, dataframe, graph, llama, onnx, büyük sayı|
|5|`pck5.md`|Tarayıcı, JS, WAT/WASM, Windows DLL, REST/curl/Flask, ChatGPT, Gemini, örnek projeler, test düzeni|

## Kitabın okuma sırası

Önce Cilt 1'i baştan sona oku. Sonra Cilt 2'de komut tablosunu ezberlemeye çalışma; her gün on komut seçip küçük program yaz. Cilt 3 veri yönetimi içindir; dizileri ve koleksiyonları anlamadan büyük program yazılmaz. Cilt 4 dış kütüphane gücüdür; burada yeni komut eklemeden dilin büyümesini görürsün. Cilt 5 ise uXBasic'i dünyaya bağlar: tarayıcı, DLL, ağ, yapay zeka, WebAssembly ve test.

## Kısa sözlük

|Türkçe|Açıklama|İngilizce|
|---|---|---|
|ön-işleyici|kaynak kod derlenmeden önce çalışan metin ve üretim katmanı|preprocessor|
|sözcükleyici|kaynak metni anahtar sözcük, sayı, metin ve işaret parçalarına böler|lexer|
|ayrıştırıcı|parçaları program ağacına çevirir|parser|
|soyut sözdizim ağacı|programın ağaç biçimli iç modeli|abstract syntax tree, AST|
|anlam çözümleme|tip, kapsam, değişken ve çağrı denetimi|semantic analysis|
|orta ara temsil|hedeflerden bağımsız ara komut dizisi|middle intermediate representation, MIR|
|çalışma zamanı|program çalışırken dosya, bellek, DLL, ekran, ağ gibi işleri yürüten katman|runtime|
|arka uç|JS, WAT, x64 gibi hedef çıktı üreten katman|backend|
|kanca|akışın içine izleme veya ek davranış takılan nokta|hook|
|sarmalayıcı|karmaşık dış işi kolay çağrılan ince arayüze çeviren dosya|wrapper|
|test kapısı|çıktıların gerçek ve sözleşmeye uygun olduğunu denetleyen sınav|gate|

## Genişletilmiş ciltlerin gerçek okuma sırası

Bu cep kitabı beş cilt gibi okunmalıdır. İlk cilt, dili neden yazdığımızı, hangi haklarla kullanıldığını, hangi dosyanın ne işe yaradığını ve mimarinin nasıl katmanlandığını anlatır. İkinci cilt, dilin kelimelerini öğretir: komutlar, ön-işleyici komutları, tipler, işleçler ve yerel işlevler burada sözlük gibi değil, küçük örneklerle anlatılır. Üçüncü cilt, değişken, bellek, dizi, liste, sözlük, küme, nesne, olay, boru, iş parçacığı ve koşut çalışma alışkanlığını kazandırır. Dördüncü cilt, kütüphaneleri birer alet kutusu olarak ele alır; matematik, istatistik, çizge, veri çerçevesi, yapay sinir ağı, tensör, büyük sayı ve yerel yapay zeka kapıları burada büyütülür. Beşinci cilt ise dili dış dünyaya bağlar: tarayıcı, JavaScript çıktısı, WAT/WASM çıktısı, DLL, API, curl, Flask, ChatGPT, Gemini, Llama, dosya sistemi, terminal, test kapısı ve sürüm çıkarma burada toplanır.

Bu sürümde `uxb(30.05_4)` çalışma ağacındaki kaynak, araç, patch, readme, hook, wrapper ve kütüphane izleri normal programın parçası kabul edilmiştir. Bu yüzden kitapta geçen `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT`, ön-işleyici meta komutları, tarayıcı varlık üretimi, DLL/API yolu, JS/WAT üretimi, çalışma zamanı kütüphaneleri ve test kapıları yama gibi değil, uXBasic programcısının günlük kullanabileceği dil özellikleri olarak anlatılır.

### Kısaltılmış içindekiler

1. **Cilt 1 — Başlangıç ve mimari:** önsöz, kullanım hakkı, MIT lisansı, sorumluluk reddi, dosya türleri, çıktı türleri, katman haritası, hook ve wrapper mantığı, geliştirici öğütleri.
2. **Cilt 2 — Dil yüzeyi:** anahtar kelimeler, komut tabloları, ön-işleyici komutları, veri tipleri, işleçler, yerel işlevler, küçük örnek kalıpları.
3. **Cilt 3 — Veri ve program yapısı:** değişken sınırları, diziler, çok boyutlu diziler, `ARRAY`, `LIST`, `DICT`, `SET`, pointer, bellek, nesne, namespace, module, alias, using module, olay ve eşzamanlılık.
4. **Cilt 4 — Kütüphaneler:** `uxmath`, `uxstats`, `uxstats2`, `uxmatrix`, `uxtensor`, `uxdataframe`, `uxgraph`, `uxcollections`, `uxnn`, `uxaimath`, `uxonnx`, `uxllama`, `fp80`, `fp128`, `bigfp`.
5. **Cilt 5 — Dış dünya ve örnekler:** Windows DLL, curl, REST, Flask, ChatGPT, Gemini, yerel Llama, JS üretimi, WAT/WASM, inline C/CPP/ASM, terminal, dosya sistemi, test, sürüm çıkarma.
