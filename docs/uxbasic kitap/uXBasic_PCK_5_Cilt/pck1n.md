# uXBasic Programlayıcının Cep Kitabı — Cilt 1
## Başlangıç, Haklar, Dosyalar, Mimari ve Çalışma Mantığı

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Destek notu:** Bu belge ve uXBasic çalışmaları faydalı olursa 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince buraya yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`.

## Kullanım hakkı ve sorumluluk sınırı

Bu cep kitabı uXBasic dilini öğrenmek, denemek ve geliştirmek isteyenler için hazırlanmıştır. Kaynak kodun MIT Lisansı ile dağıtıldığı varsayılmıştır. MIT Lisansı kısaca şunu söyler: kodu kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi işinizde kullanabilirsiniz; fakat lisans metnini ve telif bildirimini korumalısınız. Bu yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, sistem bozulması, yanlış DLL/API çağrısı veya yanlış bilimsel sonuçlardan belge yazarı sorumlu değildir. Deney, üretim, finans, sağlık, resmi işlem, güvenlik ve gerçek cihaz kontrolünde önce küçük test yapın.

## Ön söz

uXBasic, BASIC ailesinin kolay okunur yapısını, çağdaş derleyici [kaynak kodu makineye çeviren program] (compiler) katmanlarıyla birleştirmek için tasarlanmış bir dildir. Genç programcı için en önemli düşünce şudur: bir dili öğrenmek yalnız komut ezberlemek değildir. Komutun ne zaman kullanılacağını, verinin nereden geldiğini, bellekte nereye gittiğini, çıktı dosyasına nasıl döndüğünü ve hata olursa nerede yakalanacağını anlamaktır.

uXBasic ile amaç yalnız `PRINT "Merhaba"` yazmak değildir. Aynı dil ile dosya okuyabilir, veri analizi yapabilir, DLL çağırabilir, Windows API kullanabilir, C/C++/ASM dosyasını derleme zincirine alabilir, tarayıcı için JavaScript [tarayıcı dili] (JavaScript) üretebilir, WebAssembly metni [tarayıcıda hızlı çalışan ara çıktı] (WAT/WASM) çıkarabilir, yerel yapay zekaya veya bulut yapay zekaya mesaj gönderebilirsiniz.

## Genç programcıya öğütler

Önce küçük program yaz. Sonra aynı programı üç kez boz ve düzelt. Bir komutu gerçekten öğrendiğini anlamanın yolu onu hata alacak biçimde de denemektir. `DIM` ile değişken aç, yanlış tip ver, hata raporuna bak. `OPEN` ile dosya aç, sonra kapatmayı unut, davranışı izle. `IF` yaz, sonra `ELSE` kısmını boş bırak. Derleyici yazan kişinin aklı, hatayı erken yakalayan akıldır.

Programlama hilesi dediğimiz şey çoğu zaman kural dışı numara değildir. Doğru yerde küçük bir kayıt tutmaktır. Mesela bir derleyicide her komutun hangi dosyadan, hangi satırdan geldiğini saklarsan, hata mesajını çok daha iyi verirsin. Bir `symbol_table.json` [sembol tablosu çıktısı] üretirsen, programdaki bütün değişkenleri sonra test edebilirsin. Bu yüzden uXBasic yalnız dil değil, aynı zamanda izlenebilir bir derleme düzenidir.

## uXBasic dosyaları

|Uzantı|Anlam ve kullanım|
|---|---|
|.uxb|Ana uXBasic kaynak dosyası. Yeni programlar için önerilen uzantı.|
|.bas|BASIC kökenli kaynak. Uyumluluk ve kolay geçiş için kullanılır.|
|.uxmh|uXBasic başlık/modül dosyası. Son kaynak klasöründe gerçek başlık uzantısı budur.|
|.uxbh|Başlık dosyası adı olarak düşünülebilir; bu pakette asıl kullanılan biçim `.uxmh` olduğu için yeni işlerde `.uxmh` tercih edilir.|
|.uxcli|Komut satırı zincirini dosyaya yazmak için kullanılabilir.|
|.json|AST/MIR/rapor/gate çıktıları.|
|.js|Tarayıcıda çalışan JavaScript çıktısı.|
|.wat|WebAssembly metin çıktısı.|
|.asm/.nasm|Yerel makine kodu üretimi için assembly çıktısı.|


`.uxb` yeni uXBasic programının ana evidir. `.bas` eski BASIC alışkanlığını taşır. `.uxmh` başlık ve modül bildirimlerini tutar. Büyük projede ana program kısa kalır, ayrıntılar `.uxmh` ve kütüphane dosyalarına ayrılır. Bu bir kitap yazmaya benzer: ana bölümde konu akar, eklerde ayrıntı durur.

## Mimari katmanlar

|No|Katman|Görev|
|---|---|---|
|1|Kaynak dosya|`.uxb`, `.bas`, `.uxmh` dosyaları|
|2|Ön-işleyici [derleme öncesi düzenleyici] (preprocessor)|`%%DEFINE`, `%%INCLUDE`, şartlı derleme|
|3|Sözlükçü [kelime ayırıcı] (lexer)|metni anahtar kelime, sayı, metin, işaret parçalarına böler|
|4|Çözümleyici [cümle kurucu] (parser)|komutlardan ağaç kurar|
|5|AST [soyut sözdizim ağacı]|programın iskeleti|
|6|Anlam denetimi [semantic]|tip, kapsam, bildirim denetimi|
|7|HIR/MIR [ara temsil]|hedeflerden bağımsız ortak program şekli|
|8|Çalıştırıcı [yorumlayıcı] (interpreter)|programı derlemeden dener|
|9|Kod üretici [backend]|JS, WAT, NASM gibi çıktı üretir|
|10|Test kapısı [gate]|çıktılar gerçek mi, sözleşme tutuldu mu bakar|


İşlem sırası şöyledir: kaynak okunur, ön-işleyici çalışır, sözlükçü kelimeleri ayırır, çözümleyici ağacı kurar, anlam denetimi değişkenleri ve tipleri kontrol eder, ara temsil üretilir, istenirse yorumlayıcı çalıştırır, istenirse kod üretici hedef dosyayı yazar. Bu sıra bozulursa derleyici de şaşırır. Bu yüzden test kapıları her aşamada çıktı ister.

## Komut satırı ve kısa fiiller

Kullanım biçimi:

```powershell
uxb <fiil> kaynak.uxb [seçenekler]
uxb ast oyun.uxb --ast-json-out out/ast.json
uxb jsw webdemo.uxb --emit-js --json-out out/js_report.json
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

|Fiil|Görev|
|---|---|
|lex|kelimeye ayırır|
|par|parser dener|
|ast|AST döker|
|sem|anlam denetimi|
|hir|HIR üretir|
|mir|MIR üretir|
|int|yorumlayıcıda çalıştırır|
|x64|x64 çıktı üretir|
|x86|x86 hedefini dener/raporlar|
|jsw|JavaScript/Web hattı|
|wat|WAT/WASM hattı|
|bld|derleme zinciri|
|run|çalıştırma|
|chk|kontrol|
|fmt|biçimleme|
|map|harita/çıktı raporu|
|doc|belge üretimi|
|rel|sürüm/release|
|hlp|yardım|
|ver|sürüm bilgisi|


## Üretilen çıktı dosyaları

|Çıktı|Ne işe yarar|
|---|---|
|tokens.json|Sözlükçü çıktısı; kaynak kaç parçaya ayrıldı gösterir.|
|ast.json|Komut ağacı; parser doğru mu anlamak için kullanılır.|
|hir.json|Yüksek düzey ara temsil.|
|mir.json|Makineye daha yakın ara temsil.|
|program.js|Tarayıcı veya Node benzeri JS ortamı için çıktı.|
|program.wat|WebAssembly metin çıktısı.|
|index.html|Tarayıcı kabuğu.|
|program.asm|x64/x86 üretim hattı için assembly.|
|diagnostics.json|Hata/uyarı raporu.|
|gate.json|Test kapısı sonucu.|


Çıktı dosyası uydurulmamalıdır. Bir test geçiyorsa dosya gerçekten derleyici tarafından üretilmelidir. `program.js` içinde gerçek JavaScript, `program.wat` içinde gerçek WAT, `index.html` içinde gerçek tarayıcı kabuğu olmalıdır. Genç programcı için bu altın kuraldır: testin amacı kendini kandırmak değil, hatayı erken bulmaktır.

## Hata kodları

|Kod|Ad|
|---|---|
|0|OK|
|6101|VERIFY_BLOCK|
|6102|INTERPRETER_BLOCK|
|6103|TARGET|
|6104|POLICY|
|6105|EMIT|
|6106|RUNTIME|
|6107|EXTERNAL_TOOL|
|6108|COMPARE|
|6109|FILE|


Örnek hata okuma:

```text
6105 EMIT hatası: Kod üretici çıktı yazamadı.
6109 FILE hatası: Dosya yolu, izin veya yazma sorunu var.
```

## İlk örnek: tek dosyalık küçük program

```basic
MAIN
    DIM ad AS STRING
    DIM yas AS I32
    PRINT "Adini yaz"
    INPUT ad
    PRINT "Yasini yaz"
    INPUT yas

    IF yas < 18 THEN
        PRINT ad + " henuz cok genc."
    ELSE
        PRINT ad + " artik buyuk projelere baslayabilir."
    END IF
END MAIN
```

Bu program beş temel işi öğretir: `MAIN` giriş noktasıdır, `DIM` değişken açar, `PRINT` çıktı verir, `INPUT` veri alır, `IF` karar verir. Programın amacı kullanıcıyı tanımak değildir; veri akışını öğretmektir. Veri klavyeden gelir, değişkende durur, şartla yorumlanır, ekrana döner.
