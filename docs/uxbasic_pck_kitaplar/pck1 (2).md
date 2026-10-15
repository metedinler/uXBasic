# uXBasic Programlayıcının Cep Kitabı — Cilt 1
## Başlangıç, Kullanım Hakkı, Dosyalar, Mimari, Komut Satırı ve Ön-İşleyici

**Hazırlayan:** Zühtü Mete Dinler
**İletişim:** zmetedinler@gmail.com
**Lisans niyeti:** MIT Lisansı
**Kaynak kabulü:** Bu cilt `src(30.05_5).zip` gerçekliği ve yeni komut satırı sözleşmesi üstüne yazılmıştır. Her şeyin çalıştığı kabul edilmiştir.
**Destek notu:** Bu belge ve uXBasic çalışmaları faydalı olursa 50 TL kullanım desteği veya 25 ABD doları bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince resmi dağıtım metnine eklenmelidir: `IBAN: TR__ ____ ____ ____ ____ ____ __`.

## Kullanım hakkı ve sorumluluk sınırı

Bu cep kitabı uXBasic dilini öğrenmek, denemek, geliştirmek ve gerçek projelerde kullanmak isteyenler için hazırlanmıştır. Kaynak kodun ve örneklerin MIT Lisansı anlayışıyla dağıtıldığı varsayılmıştır. MIT Lisansı kısaca şunu söyler: kodu kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi işinizde kullanabilirsiniz; fakat lisans metnini ve telif bildirimini korumalısınız. Yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, sistem bozulması, yanlış DLL/API çağrısı, üçüncü taraf ücretleri, yanlış bilimsel yorum veya üretim hattı hatasından belge yazarı sorumlu değildir.

Gerçek cihaz, para, sağlık, resmi işlem, güvenlik, üretim hattı, elektriksel kontrol, kimyasal süreç, sunucu yönetimi ve kullanıcı verisi içeren işlerde önce küçük test yapılmalıdır. Derleyici doğru çalışsa bile yanlış veri, yanlış hedef, yanlış dış kütüphane veya yanlış API anahtarı sonucu bozabilir. Genç programcı için ilk meslek kuralı budur: çalıştırmadan önce yedek al, dağıtmadan önce test et, hata olursa hangi dosyaya bakacağını bil.

## Ön söz

uXBasic, BASIC ailesinin okunur yapısını çağdaş derleyici [kaynak kodu hedef çıktıya çeviren program] (compiler) katmanlarıyla birleştirmek için tasarlanmış bir dildir. Bu dilde amaç yalnız `PRINT "Merhaba"` yazmak değildir. Aynı kaynak düzeniyle dosya okuyabilir, veri analizi yapabilir, DLL çağırabilir, Windows API kullanabilir, C/C++/ASM dosyasını derleme zincirine alabilir, tarayıcı için JavaScript [tarayıcı dili] (JavaScript) üretebilir, WebAssembly metni [tarayıcıda hızlı çalışan ara çıktı] (WAT/WASM) çıkarabilir, yerel yapay zekaya veya bulut yapay zekaya mesaj gönderebilirsin.

Bu cilt başlangıç cildidir; fakat sadece “merhaba dünya” kitabı değildir. Burada dosya uzantılarını, komut satırını, çıktı sözleşmesini, katmanları, ön-işleyiciyi ve genç programcının büyük projeyi nasıl düzenleyeceğini öğrenirsin. Sonraki ciltlerde komutlar, veri tipleri, veri yapıları, kütüphaneler, dış çağrılar, tarayıcı ve bilimsel örnekler daha da büyütülecektir. Buradaki örnekler küçük parça gibi görünse bile her biri bir alışkanlık öğretir: giriş al, veriyi tut, hata ara, çıktı üret, rapora bak.

## Genç programcıya öğütler

Bir dili öğrenmenin yolu önce komut ezberlemek değildir. Önce “hangi veriyi alıyorum, bu veriye hangi kararı veriyorum, sonucu nereye yazıyorum?” sorusunu sormalısın. Her örneği çalıştırmadan önce kâğıda üç kutu çiz: giriş, işlem, çıkış. Giriş kullanıcıdan, dosyadan, sensörden, ağdan veya DLL’den gelebilir. İşlem; koşul, döngü, fonksiyon, veri yapısı ve kütüphane çağrısıdır. Çıkış; ekran, dosya, grafik, tarayıcı, API cevabı veya başka programa verilen veri olabilir.

Program büyüdükçe `IF` sayısı artıyorsa bu genellikle tasarım kokusudur. Yüz satırlık `IF kelime = ...` zinciri yerine `DICT` ile tablo kurmak daha temizdir. Menüleri, hata kodlarını, komut adlarını, üretim eşiklerini, laboratuvar sınırlarını ve kullanıcı yetkilerini tabloya koyarsan program hem okunur hem değiştirilebilir olur. Tablo yalnız Excel dosyası değildir; uXBasic içinde `ARRAY`, `LIST`, `DICT` ve `SET` de birer program içi tablodur. `ARRAY` sıralı ve sabit ölçülü veri için, `LIST` büyüyen sıra için, `DICT` anahtarla arama için, `SET` tekrarsız küme için seçilir.

Derleyici yazarken kullanılan zeki hilelerden biri “iz bırakma”dır. Programın hangi satırdan hangi ara temsile dönüştüğünü kaydedersen hata mesajı güçlenir. `tokens.json`, `ast.json`, `symbol_table.json`, `mir_full.json`, `runtime_trace.json` gibi çıktılar bu yüzden önemlidir. Bunlar sadece derleyicinin iç işi değildir; öğrencinin de öğretmenidir. Kendi kodunu bu raporlarla incelersen hangi komutun nasıl parçalandığını, hangi değişkenin nerede yaşadığını ve hangi hedefe ne üretildiğini görürsün.

# 1. uXBasic dosyaları ve çıktıları

| Uzantı | Anlam | Ne zaman kullanılır? | Küçük örnek |
|---|---|---|---|
| .uxb | Ana uXBasic kaynak dosyasıdır. | Yeni programın ana gövdesi burada tutulur. | `main.uxb` |
| .bas | BASIC kökenli kaynak dosyasıdır. | Eski BASIC örnekleri, geçiş kodları ve uyumluluk testlerinde kullanılır. | `demo.bas` |
| .uxmh | uXBasic modül/başlık dosyasıdır. | Ortak sabit, bildirim, makro ve kütüphane başlığı burada durur. | `ayarlar.uxmh` |
| .uxbh | Başlık dosyası adı olarak ayrılmış biçimdir. | Yeni işlerde `.uxmh` tercih edilir; eski metinlerde görülebilir. | `ortak.uxbh` |
| .uxcli | Komut satırı zincirini dosyaya yazmak için kullanılır. | Uzun build komutlarını tekrar çalıştırmak için saklarsın. | `build.uxcli` |
| .json | Rapor ve sözleşme dosyasıdır. | Token, AST, MIR, tip, hata, manifest ve gate çıktıları için kullanılır. | `out/ast.json` |
| .js | JavaScript çıktısıdır. | Tarayıcı veya Node tarafında çalışacak program gövdesidir. | `dist/program.js` |
| .wat | WebAssembly metin biçimidir. | WASM’a çevrilmeden önce insanın okuyacağı hızlı web çıktısıdır. | `dist/program.wat` |
| .wasm | WebAssembly ikili çıktısıdır. | Tarayıcı veya host içinde hızlı çalışan çekirdektir. | `dist/program.wasm` |
| .html | Tarayıcı sayfasıdır. | Üretilen JS/WASM dosyalarını yükleyen sayfa iskeletidir. | `dist/index.html` |
| .asm/.nasm | Assembly çıktısıdır. | x64/x86 hedefinde makine koduna giden metin adımdır. | `out/main.asm` |
| .exe | Windows çalıştırılabilir dosyasıdır. | Build başarılıysa kullanıcıya verilecek programdır. | `out/main.exe` |
| .log/.txt | Günlük ve düz metin çıktıdır. | Derleme, hata, stdout, stderr ve test izleri için kullanılır. | `out/build.log` |
| .csv/.parquet | Veri tablosu dosyasıdır. | Bilimsel ölçüm, üretim kalite ve veri analizi işlerinde kullanılır. | `data/olcum.csv` |

Dosya uzantısı seçmek küçük görünen ama büyük projeyi düzenleyen bir karardır. Ana programı `.uxb` içinde tutarsan kullanıcı nereden başlayacağını bilir. Ortak sabitleri `.uxmh` dosyasına ayırırsan beş farklı program aynı ayarı tekrar yazmaz. Çıktıları `out/` veya `dist/` altında toplarsan kaynak ile üretilen dosyalar birbirine karışmaz. Genç programcı için altın kural şudur: kaynak dosya elle yazılır, çıktı dosyası derleyici tarafından üretilir; ikisini aynı klasörde başıboş bırakma.

```uxbasic
' main.uxb — ilk düzenli program
%%INCLUDE "ayarlar.uxmh"
%%PROFILE "DEBUG"
%%TARGET JS
%%OUTDIR "dist/web"

MAIN
    DIM ad AS STRING
    DIM yas AS I32

    PRINT "Adini yaz:"
    INPUT ad
    PRINT "Yasini yaz:"
    INPUT yas

    IF yas >= 18 THEN
        PRINT ad + " uXBasic ile kendi aracini yazmaya baslayabilir."
    ELSE
        PRINT ad + " once kucuk alistirmalarla temel kurmali."
    END IF
END MAIN
```

Bu örnek kısa görünür ama içinde dosya düzeni, ön-işleyici, değişken, giriş, çıkış ve koşul vardır. `%%INCLUDE` ortak ayar dosyasını alır. `%%PROFILE` hangi çalışma düzeninde olduğunu bildirir. `%%TARGET` hedefi belirler. `MAIN` programın başlangıcıdır. `DIM` değişken açar, `INPUT` kullanıcıdan veri alır, `IF` karar verir, `PRINT` sonucu gösterir.

# 2. Mimari katmanlar

| No | Katman | Görevi | Öğrenci bu katmandan ne öğrenir? |
|---:|---|---|---|
| 1 | Kaynak dosya | `.uxb`, `.bas`, `.uxmh` dosyalarını tutar. | Programın asıl metninin nerede olduğunu öğrenir. |
| 2 | Ön-işleyici [derleme öncesi düzenleyici] (preprocessor) | `%%DEFINE`, `%%INCLUDE`, şartlı derleme ve varlık bildirimlerini işler. | Aynı kaynaktan farklı hedefler üretmeyi öğrenir. |
| 3 | Sözcükleyici [kelime ayırıcı] (lexer) | Metni anahtar kelime, sayı, metin ve işaret parçalarına böler. | Hatanın bazen daha cümle kurulmadan yakalandığını görür. |
| 4 | Çözümleyici [cümle kurucu] (parser) | Komutlardan ağaç kurar. | `IF`, `FOR`, `SUB`, `CLASS` gibi yapıların iskelete dönüştüğünü görür. |
| 5 | AST [soyut sözdizim ağacı] | Programın komut ağacını tutar. | Kodun makineye gitmeden önce nasıl temsil edildiğini öğrenir. |
| 6 | Anlam denetimi [tip ve kapsam denetimi] (semantic) | Değişken, tip, kapsam, fonksiyon ve dış çağrı uyumunu inceler. | Yanlış tip ve tanımsız ad hatalarını erken yakalamayı öğrenir. |
| 7 | HIR/MIR [ara temsil] | Hedeften bağımsız ortak program biçimini kurar. | Aynı programın JS, WAT ve x64’e nasıl gidebildiğini anlar. |
| 8 | Çalıştırıcı [yorumlayıcı] (interpreter) | Programı derlemeden deneyebilir. | Hızlı deneme ve eğitim için ara çalıştırmayı kullanır. |
| 9 | Kod üretici [arka uç] (backend) | JS, WAT, WASM, NASM, EXE gibi çıktıları üretir. | Hedef seçmenin gerçek dosya ürettiğini görür. |
| 10 | Test kapısı [doğrulama kapısı] (gate) | Çıktılar dolu mu, JSON okunuyor mu, sahte çıktı var mı denetler. | “Geçti” demeden önce kanıt istemeyi öğrenir. |

Bu katmanları bir fabrika hattı gibi düşün. Kaynak dosya ham maddedir. Ön-işleyici gereksiz veya hedef dışı parçaları ayıklar, gereken başlıkları ekler. Sözcükleyici kelimeleri ayırır. Çözümleyici cümleyi kurar. Anlam katmanı “bu değişken var mı, bu tip doğru mu?” diye sorar. Ara temsil bütün hedeflere ortak bir dil verir. Çalıştırıcı hızlı deneme yapar. Arka uç gerçek dosyayı üretir. Test kapısı ise paketin kandırmaca değil gerçek çıktı ürettiğini denetler.

## Mimari örnek: aynı dosyadan rapor, JS ve WAT üretmek
```powershell
uxb main.uxb --tokens-json-out out/tokens.json
uxb main.uxb --parser-json-out out/parser.json
uxb main.uxb --ast-json-out out/ast.json
uxb main.uxb --semantic-diagnostics-json-out out/semantic_diag.json
uxb main.uxb --mir-full-json-out out/mir_full.json
uxb main.uxb --js-out dist/program.js
uxb main.uxb --wat-out dist/program.wat
uxb main.uxb --html-out dist/index.html
uxb main.uxb --manifest-out dist/manifest.json
```

Bu komut dizisi aynı kaynağı dokuz farklı pencereden gösterir. `tokens.json` kelimeleri, `parser.json` cümle yapısını, `ast.json` komut ağacını, `semantic_diag.json` anlam hatalarını, `mir_full.json` hedeften bağımsız ara programı, `program.js` tarayıcı kodunu, `program.wat` WebAssembly metnini, `index.html` sayfa iskeletini, `manifest.json` paket fihristini verir. Genç programcı her derlemede yalnız ekrana bakarsa eksik öğrenir; rapora da bakarsa derleyicinin aklını görür.

# 3. Komut satırı: uzun seçenekler ve 3 harfli kısa fiiller

uXBasic komut satırı iki biçimi birlikte kullanır. Uzun biçim açık ve öğreticidir: `uxb main.uxb --tokens-json-out out/tokens.json`. Kısa fiil biçimi hızlıdır: `uxb tjs main.uxb --out out/tokens.json`. Kısa fiil üç harflidir; bir komutun terminalde sık kullanılmasını kolaylaştırır. Bu ciltte yalnız kullanılacak kanonik seçenekler yer alır. Tabloya alınan her `*-out` seçeneğinin gerçek dosya üretmesi beklenir; boş dosya, bozuk JSON, yer tutucu veya sahte çıktı doğru kabul edilmez.

## Genel komut satırı davranışı

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 1 | `--format-check` | `fmt` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --format-check` veya `uxb fmt main.uxb` | `yok / parametre` |
| 2 | `--help` | `hlp` | Derleyicinin yardım veya sürüm bilgisini gösterir; kurulumun çalıştığını hızlıca anlamak için kullanılır. | `uxb main.uxb --help` veya `uxb hlp main.uxb` | `yok / parametre` |
| 3 | `--version` | `ver` | Derleyicinin yardım veya sürüm bilgisini gösterir; kurulumun çalıştığını hızlıca anlamak için kullanılır. | `uxb main.uxb --version` veya `uxb ver main.uxb` | `yok / parametre` |
| 4 | `--target` | `tgt` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target` veya `uxb tgt main.uxb` | `yok / parametre` |
| 5 | `--stop-after` | `stp` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --stop-after` veya `uxb stp main.uxb` | `yok / parametre` |
| 7 | `--diag-format` | `dgf` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --diag-format` veya `uxb dgf main.uxb` | `yok / parametre` |
| 8 | `--error-limit` | `erl` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --error-limit` veya `uxb erl main.uxb` | `yok / parametre` |
| 15 | `--strict` | `str` | Daha sıkı denetim ister; genç programcıya hatayı erken gösterir. | `uxb main.uxb --strict` veya `uxb str main.uxb` | `yok / parametre` |
| 16 | `--time-passes` | `tim` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --time-passes` veya `uxb tim main.uxb` | `yok / parametre` |
| 19 | `--parse-only` | `par` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --parse-only` veya `uxb par main.uxb` | `yok / parametre` |
| 27 | `--codegen-source` | `cgs` | JavaScript [tarayıcı dili] çıktısı üretir; tarayıcı hedefinde programın çalışacak gövdesini verir. | `uxb cgs main.uxb --out out/codegen_source.txt` veya `uxb main.uxb --codegen-source out/codegen_source.txt` | `.c/.cpp/.asm/.js/.wat` |
| 66 | `--debug` | `dbg` | İzleme ve hata ayıklama bilgisini açar; hangi katmanda ne olduğunu görmeyi sağlar. | `uxb main.uxb --debug` veya `uxb dbg main.uxb` | `yok / parametre` |
| 68 | `--quiet` | `qui` | Gereksiz konuşmayı azaltır; betik içinde temiz çıktı almak için kullanılır. | `uxb main.uxb --quiet` veya `uxb qui main.uxb` | `yok / parametre` |
| 73 | `--message-lang` | `mlg` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --message-lang` veya `uxb mlg main.uxb` | `yok / parametre` |
| 74 | `--language` | `lng` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --language` veya `uxb lng main.uxb` | `yok / parametre` |
| 80 | `--interop` | `ino` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --interop` veya `uxb ino main.uxb` | `yok / parametre` |
| 83 | `--codegen` | `cod` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --codegen` veya `uxb cod main.uxb` | `yok / parametre` |
| 103 | `--extfp-strict` | `xfs` | Daha sıkı denetim ister; genç programcıya hatayı erken gösterir. | `uxb main.uxb --extfp-strict` veya `uxb xfs main.uxb` | `yok / parametre` |
| 104 | `--extfp-diagnostics` | `xfd` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --extfp-diagnostics` veya `uxb xfd main.uxb` | `yok / parametre` |
| 115 | `--extract-src` | `esr` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --extract-src` veya `uxb esr main.uxb` | `yok / parametre` |
| 116 | `--adim25-27-close-gate` | `a25` | Test kapısını çalıştırır; üretilen dosyaların gerçek, dolu ve sözleşmeye uygun olduğunu denetler. | `uxb main.uxb --adim25-27-close-gate` veya `uxb a25 main.uxb` | `yok / parametre` |
| 117 | `--adim25-26-27-close-gate` | `a27` | Test kapısını çalıştırır; üretilen dosyaların gerçek, dolu ve sözleşmeye uygun olduğunu denetler. | `uxb main.uxb --adim25-26-27-close-gate` veya `uxb a27 main.uxb` | `yok / parametre` |
| 119 | `--source` | `src` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --source` veya `uxb src main.uxb` | `yok / parametre` |

Bu grup derleme davranışını belirler. Hedef seçmek, sıkı denetim açmak, hata sınırı koymak ve çıktı biçimini seçmek günlük çalışma düzeninin temelidir.

## Ön-işleyici ve sözcük çıktı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 17 | `--debug-token-dump` | `tdp` | İzleme ve hata ayıklama bilgisini açar; hangi katmanda ne olduğunu görmeyi sağlar. | `uxb main.uxb --debug-token-dump` veya `uxb tdp main.uxb` | `yok / parametre` |
| 18 | `--token-json-out` | `tkj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb tkj main.uxb --out out/token_json_out.json` veya `uxb main.uxb --token-json-out out/token_json_out.json` | `.json` |
| 49 | `--tokens-json-out` | `tjs` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb tjs main.uxb --out out/tokens_json_out.json` veya `uxb main.uxb --tokens-json-out out/tokens_json_out.json` | `.json` |
| 50 | `--lexer-diagnostics-json-out` | `ldj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb ldj main.uxb --out out/lexer_diagnostics_json_out.json` veya `uxb main.uxb --lexer-diagnostics-json-out out/lexer_diagnostics_json_out.json` | `.json` |
| 51 | `--preprocessed-out` | `pre` | Belirtilen çıktı dosyasını üretir; dosya boş ve sahte olmamalıdır. | `uxb pre main.uxb --out out/preprocessed_out.uxb` veya `uxb main.uxb --preprocessed-out out/preprocessed_out.uxb` | `.bas/.uxb` |

Bu grup kaynak daha çözümleyiciye gitmeden önce ne olduğunu gösterir. `--preprocessed-out` ile `%%` komutlarının temizlenmiş hâlini alırsın. `--tokens-json-out` ile kelimeleri görürsün. Bir hata daha bu aşamada çıkıyorsa sorun genellikle tırnak, sayı biçimi, kapatılmamış metin veya güvenli olmayan include yoludur.

## Çözümleyici çıktı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 20 | `--parser-json-out` | `pjo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb pjo main.uxb --out out/parser_json_out.json` veya `uxb main.uxb --parser-json-out out/parser_json_out.json` | `.json` |
| 52 | `--parser-diagnostics-json-out` | `pdj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb pdj main.uxb --out out/parser_diagnostics_json_out.json` veya `uxb main.uxb --parser-diagnostics-json-out out/parser_diagnostics_json_out.json` | `.json` |

Bu grup komutların cümleye dönüşmesini inceler. Program `IF`, `FOR`, `SUB`, `CLASS`, `CALL`, `EVENT`, `PIPE` gibi yapıları doğru yazmış mı, çözümleyici burada belli eder. Parser çıktısı, “derleyici beni anlamadı mı, yoksa daha sonra mı hata çıktı?” sorusunu ayırır.

## Soyut ağaç ve sözleşme komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 13 | `--dump-ast` | `das` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --dump-ast` veya `uxb das main.uxb` | `yok / parametre` |
| 21 | `--ast-contract-check` | `acc` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --ast-contract-check` veya `uxb acc main.uxb` | `yok / parametre` |
| 22 | `--ast-json-out` | `ajo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb ajo main.uxb --out out/ast_json_out.json` veya `uxb main.uxb --ast-json-out out/ast_json_out.json` | `.json` |
| 96 | `--ast-contract-json-out` | `acj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb acj main.uxb --out out/ast_contract_json_out.json` veya `uxb main.uxb --ast-contract-json-out out/ast_contract_json_out.json` | `.json` |
| 97 | `--ast-contract-report-json-out` | `arj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb arj main.uxb --out out/ast_contract_report_json_out.json` veya `uxb main.uxb --ast-contract-report-json-out out/ast_contract_report_json_out.json` | `.json` |
| 98 | `--ast-contract-matrix-out` | `acm` | JavaScript [tarayıcı dili] çıktısı üretir; tarayıcı hedefinde programın çalışacak gövdesini verir. | `uxb acm main.uxb --out out/ast_contract_matrix_out.json` veya `uxb main.uxb --ast-contract-matrix-out out/ast_contract_matrix_out.json` | `.csv/.json` |
| 114 | `--validate-all-fail-fast` | `vff` | Test kapısını çalıştırır; üretilen dosyaların gerçek, dolu ve sözleşmeye uygun olduğunu denetler. | `uxb main.uxb --validate-all-fail-fast` veya `uxb vff main.uxb` | `yok / parametre` |

AST komutun ağaç biçimidir. Bir `IF` düğümünün koşulu, doğru kolu, yanlış kolu vardır. Bir `CALL` düğümünün hedefi ve argümanları vardır. AST raporu derleyici geliştiricisine, hangi komutun hangi düğüme gittiğini gösterir.

## Anlam, tip ve yüksek ara temsil komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 23 | `--semantic` | `sem` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --semantic` veya `uxb sem main.uxb` | `yok / parametre` |
| 24 | `--semantic-json-out` | `sjo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb sjo main.uxb --out out/semantic_json_out.json` veya `uxb main.uxb --semantic-json-out out/semantic_json_out.json` | `.json` |
| 25 | `--hir-json-out` | `hjo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb hjo main.uxb --out out/hir_json_out.json` veya `uxb main.uxb --hir-json-out out/hir_json_out.json` | `.json` |
| 53 | `--symbol-table-json-out` | `syj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb syj main.uxb --out out/symbol_table_json_out.json` veya `uxb main.uxb --symbol-table-json-out out/symbol_table_json_out.json` | `.json` |
| 54 | `--type-table-json-out` | `tyj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb tyj main.uxb --out out/type_table_json_out.json` veya `uxb main.uxb --type-table-json-out out/type_table_json_out.json` | `.json` |
| 55 | `--layout-report-json-out` | `lrj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb lrj main.uxb --out out/layout_report_json_out.json` veya `uxb main.uxb --layout-report-json-out out/layout_report_json_out.json` | `.json` |
| 56 | `--hir-inventory-json-out` | `hij` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb hij main.uxb --out out/hir_inventory_json_out.json` veya `uxb main.uxb --hir-inventory-json-out out/hir_inventory_json_out.json` | `.json` |
| 57 | `--semantic-diagnostics-json-out` | `sdj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb sdj main.uxb --out out/semantic_diagnostics_json_out.json` veya `uxb main.uxb --semantic-diagnostics-json-out out/semantic_diagnostics_json_out.json` | `.json` |

Anlam ve tip komutları “yazım doğru ama mantık doğru mu?” sorusunu sorar. Değişken tanımlı mı, fonksiyon dönüş tipi uyuyor mu, dış DLL imzası doğru mu, sınıf alanı görünür mü, `BIGD` ile `I32` yanlış yerde karışmış mı gibi konular bu aşamada görünür.

## Orta ara temsil ve doğrulama komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 14 | `--dump-mir` | `dmi` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --dump-mir` veya `uxb dmi main.uxb` | `yok / parametre` |
| 26 | `--mir-verify` | `mvf` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --mir-verify` veya `uxb mvf main.uxb` | `yok / parametre` |
| 28 | `--mir-full-json-out` | `mfj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mfj main.uxb --out out/mir_full_json_out.json` veya `uxb main.uxb --mir-full-json-out out/mir_full_json_out.json` | `.json` |
| 58 | `--mir-opt-report-json-out` | `mor` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mor main.uxb --out out/mir_opt_report_json_out.json` veya `uxb main.uxb --mir-opt-report-json-out out/mir_opt_report_json_out.json` | `.json` |
| 91 | `--mir-pipeline-json-out` | `mpj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mpj main.uxb --out out/mir_pipeline_json_out.json` veya `uxb main.uxb --mir-pipeline-json-out out/mir_pipeline_json_out.json` | `.json` |
| 92 | `--mir-opcodes-json-out` | `opj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb opj main.uxb --out out/mir_opcodes_json_out.json` veya `uxb main.uxb --mir-opcodes-json-out out/mir_opcodes_json_out.json` | `.json` |
| 93 | `--mir-surface-json-out` | `msj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb msj main.uxb --out out/mir_surface_json_out.json` veya `uxb main.uxb --mir-surface-json-out out/mir_surface_json_out.json` | `.json` |
| 94 | `--mir-module-json-out` | `mmj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mmj main.uxb --out out/mir_module_json_out.json` veya `uxb main.uxb --mir-module-json-out out/mir_module_json_out.json` | `.json` |
| 95 | `--mir-json-out` | `mij` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mij main.uxb --out out/mir_json_out.json` veya `uxb main.uxb --mir-json-out out/mir_json_out.json` | `.json` |
| 100 | `--mir-verify-json-out` | `mvj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb mvj main.uxb --out out/mir_verify_json_out.json` veya `uxb main.uxb --mir-verify-json-out out/mir_verify_json_out.json` | `.json` |
| 101 | `--enable-mir-x64-experimental` | `mx6` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --enable-mir-x64-experimental` veya `uxb mx6 main.uxb` | `yok / parametre` |

MIR komutları hedeften bağımsız ara programı gösterir. JS, WAT, x64 ve yorumlayıcı aynı kaynak programdan beslenecekse ortak zemin MIR’dir. MIR doğrulama komutları yanlış blok, bilinmeyen işlem, hatalı operand ve hedef desteği sorunlarını yakalar.

## Çalıştırıcı ve yorumlayıcı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 29 | `--execmem` | `exm` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --execmem` veya `uxb exm main.uxb` | `yok / parametre` |
| 30 | `--interpreter-backend` | `ibk` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --interpreter-backend` veya `uxb ibk main.uxb` | `yok / parametre` |
| 59 | `--stdout-out` | `sto` | Program çıktısı veya günlük metnini dosyaya yazar; otomatik testte okunur. | `uxb sto main.uxb --out out/stdout_out.txt` veya `uxb main.uxb --stdout-out out/stdout_out.txt` | `.txt` |
| 60 | `--stderr-out` | `ste` | Program çıktısı veya günlük metnini dosyaya yazar; otomatik testte okunur. | `uxb ste main.uxb --out out/stderr_out.txt` veya `uxb main.uxb --stderr-out out/stderr_out.txt` | `.txt` |
| 102 | `--enable-extfp-runtime` | `xfp` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --enable-extfp-runtime` veya `uxb xfp main.uxb` | `yok / parametre` |
| 105 | `--extfp-runtime-dir` | `xfr` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --extfp-runtime-dir` veya `uxb xfr main.uxb` | `yok / parametre` |
| 107 | `--console-mode` | `con` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --console-mode` veya `uxb con main.uxb` | `yok / parametre` |
| 108 | `--program-output-out` | `poo` | Program çıktısı veya günlük metnini dosyaya yazar; otomatik testte okunur. | `uxb poo main.uxb --out out/program_output_out.txt` veya `uxb main.uxb --program-output-out out/program_output_out.txt` | `.txt` |

Çalıştırıcı komutları programı üretmeden önce denemeye yarar. `stdout`, `stderr`, `runtime_trace` ve `program_output` dosyaları özellikle eğitim ve test için değerlidir. Çıktı dosyasına bakmak, terminalde kaçan satırı yakalamaktan daha güvenlidir.

## Yerel x64/x86 çıktı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 9 | `--emit-nasm` | `ens` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-nasm` veya `uxb ens main.uxb` | `yok / parametre` |
| 32 | `--emit-x64-nasm` | `x6e` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-x64-nasm` veya `uxb x6e main.uxb` | `yok / parametre` |
| 33 | `--emit-x64-nasm-out` | `x6o` | Assembly [işlemciye yakın metin kod] dosyası üretir; yerel çalıştırılabilir dosyaya giden yoldur. | `uxb x6o main.uxb --out out/emit_x64_nasm_out.asm` veya `uxb main.uxb --emit-x64-nasm-out out/emit_x64_nasm_out.asm` | `.asm/.nasm` |
| 34 | `--x64-codegen-policy-json-out` | `x6p` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb x6p main.uxb --out out/x64_codegen_policy_json_out.json` veya `uxb main.uxb --x64-codegen-policy-json-out out/x64_codegen_policy_json_out.json` | `.json` |
| 35 | `--emit-x86` | `x86` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-x86` veya `uxb x86 main.uxb` | `yok / parametre` |
| 39 | `--build-x64` | `bx6` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --build-x64` veya `uxb bx6 main.uxb` | `yok / parametre` |
| 40 | `--build-x64-out` | `bxo` | Windows çalıştırılabilir dosyasının hedef yolunu ve build sonucunu üretir. | `uxb bxo main.uxb --out out/build_x64_out.exe` veya `uxb main.uxb --build-x64-out out/build_x64_out.exe` | `.exe` |
| 81 | `--x64gen` | `x6g` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --x64gen` veya `uxb x6g main.uxb` | `yok / parametre` |
| 82 | `--target-x86` | `tx6` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target-x86` veya `uxb tx6 main.uxb` | `yok / parametre` |
| 84 | `--x64` | `x64` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --x64` veya `uxb x64 main.uxb` | `yok / parametre` |
| 87 | `--x64gen-out` | `xgo` | Assembly [işlemciye yakın metin kod] dosyası üretir; yerel çalıştırılabilir dosyaya giden yoldur. | `uxb xgo main.uxb --out out/x64gen_out.asm` veya `uxb main.uxb --x64gen-out out/x64gen_out.asm` | `.asm/.nasm` |

Yerel arka uç komutları x64/x86 hattına gider. Bu bölümde üretilen assembly veya exe çıktısı sistem programlama için önemlidir. Dış DLL ve Windows API çağrıları burada daha kritik olur; imza, çağrı düzeni ve tipler doğru yazılmalıdır.

## Tarayıcı, JavaScript ve WebAssembly çıktı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 6 | `--json-out` | `jsn` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb jsn main.uxb --out out/json_out.json` veya `uxb main.uxb --json-out out/json_out.json` | `.json` |
| 10 | `--emit-js` | `ejs` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-js` veya `uxb ejs main.uxb` | `yok / parametre` |
| 11 | `--emit-wat` | `ewt` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-wat` veya `uxb ewt main.uxb` | `yok / parametre` |
| 12 | `--emit-wasm` | `ewm` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-wasm` veya `uxb ewm main.uxb` | `yok / parametre` |
| 31 | `--run-report-json-out` | `rrj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb rrj main.uxb --out out/run_report_json_out.json` veya `uxb main.uxb --run-report-json-out out/run_report_json_out.json` | `.json` |
| 36 | `--backend-report-json-out` | `brj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb brj main.uxb --out out/backend_report_json_out.json` veya `uxb main.uxb --backend-report-json-out out/backend_report_json_out.json` | `.json` |
| 37 | `--js-out` | `jso` | JavaScript [tarayıcı dili] çıktısı üretir; tarayıcı hedefinde programın çalışacak gövdesini verir. | `uxb jso main.uxb --out out/js_out.js` veya `uxb main.uxb --js-out out/js_out.js` | `.js` |
| 38 | `--wasm-wat-out` | `wto` | WebAssembly metin [WASM’ın okunur biçimi] çıktısı üretir; sonraki adımda wasm ikilisine çevrilebilir. | `uxb wto main.uxb --out out/wasm_wat_out.wat` veya `uxb main.uxb --wasm-wat-out out/wasm_wat_out.wat` | `.wat` |
| 42 | `--validate-all-report-json-out` | `vaj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb vaj main.uxb --out out/validate_all_report_json_out.json` veya `uxb main.uxb --validate-all-report-json-out out/validate_all_report_json_out.json` | `.json` |
| 44 | `--source-map-json-out` | `smj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb smj main.uxb --out out/source_map_json_out.json` veya `uxb main.uxb --source-map-json-out out/source_map_json_out.json` | `.json` |
| 46 | `--doc-json-out` | `djo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb djo main.uxb --out out/doc_json_out.json` veya `uxb main.uxb --doc-json-out out/doc_json_out.json` | `.json` |
| 48 | `--release-json-out` | `rjo` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb rjo main.uxb --out out/release_json_out.json` veya `uxb main.uxb --release-json-out out/release_json_out.json` | `.json` |
| 61 | `--runtime-trace-json-out` | `rtj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb rtj main.uxb --out out/runtime_trace_json_out.json` veya `uxb main.uxb --runtime-trace-json-out out/runtime_trace_json_out.json` | `.json` |
| 62 | `--wat-out` | `wat` | WebAssembly metin [WASM’ın okunur biçimi] çıktısı üretir; sonraki adımda wasm ikilisine çevrilebilir. | `uxb wat main.uxb --out out/wat_out.wat` veya `uxb main.uxb --wat-out out/wat_out.wat` | `.wat` |
| 63 | `--wasm-out` | `wsm` | WebAssembly ikili çıktısı üretir; tarayıcı veya host ortamında çalıştırılır. | `uxb wsm main.uxb --out out/wasm_out.wasm` veya `uxb main.uxb --wasm-out out/wasm_out.wasm` | `.wasm` |
| 64 | `--html-out` | `htm` | Tarayıcıda açılacak HTML [sayfa iskeleti] dosyasını üretir. | `uxb htm main.uxb --out out/html_out.html` veya `uxb main.uxb --html-out out/html_out.html` | `.html` |
| 65 | `--manifest-out` | `man` | JavaScript [tarayıcı dili] çıktısı üretir; tarayıcı hedefinde programın çalışacak gövdesini verir. | `uxb man main.uxb --out out/manifest_out.json` veya `uxb main.uxb --manifest-out out/manifest_out.json` | `.json` |
| 75 | `--session-live-json-out` | `slj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb slj main.uxb --out out/session_live_json_out.json` veya `uxb main.uxb --session-live-json-out out/session_live_json_out.json` | `.json` |
| 76 | `--layer-timing-json-out` | `ltj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb ltj main.uxb --out out/layer_timing_json_out.json` veya `uxb main.uxb --layer-timing-json-out out/layer_timing_json_out.json` | `.json` |
| 78 | `--trace-json` | `tjx` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb tjx main.uxb --out out/trace_json.json` veya `uxb main.uxb --trace-json out/trace_json.json` | `.json` |
| 85 | `--target-js` | `tgj` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target-js` veya `uxb tgj main.uxb` | `yok / parametre` |
| 86 | `--target-browser` | `tbr` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target-browser` veya `uxb tbr main.uxb` | `yok / parametre` |
| 88 | `--ir-json-out` | `irj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb irj main.uxb --out out/ir_json_out.json` veya `uxb main.uxb --ir-json-out out/ir_json_out.json` | `.json` |
| 89 | `--inventory-json-out` | `inv` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb inv main.uxb --out out/inventory_json_out.json` veya `uxb main.uxb --inventory-json-out out/inventory_json_out.json` | `.json` |
| 90 | `--pipeline-json-out` | `pij` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb pij main.uxb --out out/pipeline_json_out.json` veya `uxb main.uxb --pipeline-json-out out/pipeline_json_out.json` | `.json` |
| 99 | `--artifact-report-json-out` | `afj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb afj main.uxb --out out/artifact_report_json_out.json` veya `uxb main.uxb --artifact-report-json-out out/artifact_report_json_out.json` | `.json` |
| 106 | `--extfp-policy-json-out` | `xfj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb xfj main.uxb --out out/extfp_policy_json_out.json` veya `uxb main.uxb --extfp-policy-json-out out/extfp_policy_json_out.json` | `.json` |
| 109 | `--program-output-json-out` | `poj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb poj main.uxb --out out/program_output_json_out.json` veya `uxb main.uxb --program-output-json-out out/program_output_json_out.json` | `.json` |
| 110 | `--final-screen-json-out` | `fsj` | İlgili katmanın raporunu JSON [anahtar-değerli taşınabilir rapor] dosyasına yazar; editör, test kapısı ve otomasyon bunu okur. | `uxb fsj main.uxb --out out/final_screen_json_out.json` veya `uxb main.uxb --final-screen-json-out out/final_screen_json_out.json` | `.json` |
| 111 | `--target-wat` | `twg` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target-wat` veya `uxb twg main.uxb` | `yok / parametre` |
| 112 | `--target-wasm` | `twm` | Derleyici hedefini seçer; aynı kaynak kodu JS, WAT, WASM, x64 veya x86 hattına yönlendirebilir. | `uxb main.uxb --target-wasm` veya `uxb twm main.uxb` | `yok / parametre` |
| 113 | `--emit-browser` | `ebr` | Seçilen arka uçtan hedef çıktı üretimini başlatır. | `uxb main.uxb --emit-browser` veya `uxb ebr main.uxb` | `yok / parametre` |
| 118 | `--wat2wasm` | `w2w` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --wat2wasm` veya `uxb w2w main.uxb` | `yok / parametre` |

Web komutları tarayıcı hedefini kurar. `program.js`, `program.wat`, `program.wasm`, `index.html`, `manifest.json` birlikte düşünülür. Bir web paketi yalnız JS dosyası değildir; HTML sayfası, varlıklar, host bağları ve manifest birlikte tutarlı olmalıdır.

## Araç, izleme, belge ve kapı komutları

| No | Uzun seçenek | 3 harf | Ne yapar? | Kullanım | Çıktı |
|---:|---|---:|---|---|---|
| 41 | `--validate-all` | `val` | Test kapısını çalıştırır; üretilen dosyaların gerçek, dolu ve sözleşmeye uygun olduğunu denetler. | `uxb main.uxb --validate-all` veya `uxb val main.uxb` | `yok / parametre` |
| 43 | `--source-map` | `smp` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --source-map` veya `uxb smp main.uxb` | `yok / parametre` |
| 45 | `--doc` | `doc` | Derleme hattının davranışını seçer veya belirli bir aşamadan sonra durmasını sağlar. | `uxb main.uxb --doc` veya `uxb doc main.uxb` | `yok / parametre` |
| 47 | `--release-gate` | `rel` | Test kapısını çalıştırır; üretilen dosyaların gerçek, dolu ve sözleşmeye uygun olduğunu denetler. | `uxb main.uxb --release-gate` veya `uxb rel main.uxb` | `yok / parametre` |
| 70 | `--trace` | `trc` | İzleme ve hata ayıklama bilgisini açar; hangi katmanda ne olduğunu görmeyi sağlar. | `uxb main.uxb --trace` veya `uxb trc main.uxb` | `yok / parametre` |
| 71 | `--log-out` | `log` | Derleme veya izleme günlüğünü yazar; hata ararken kullanılır. | `uxb log main.uxb --out out/log_out.log` veya `uxb main.uxb --log-out out/log_out.log` | `.log` |
| 72 | `--debug-log-out` | `dlo` | Derleme veya izleme günlüğünü yazar; hata ararken kullanılır. | `uxb dlo main.uxb --out out/debug_log_out.log` veya `uxb main.uxb --debug-log-out out/debug_log_out.log` | `.log` |
| 77 | `--hook-trace` | `htr` | İzleme ve hata ayıklama bilgisini açar; hangi katmanda ne olduğunu görmeyi sağlar. | `uxb main.uxb --hook-trace` veya `uxb htr main.uxb` | `yok / parametre` |

Araç ve kapı komutları geliştirme disiplinidir. Editör canlı hata gösterecekse JSON rapor ister. Release kapısı paketin sahte çıktı üretmediğini denetler. Büyük projede “bende çalışıyor” cümlesi yetmez; gate raporu gerekir.


## Komut satırıyla örnek BASIC dosyasını derleme ve çözümleyici çıktısı alma

```uxbasic
' parser_demo.uxb — çözümleyiciye çok farklı komut gösteren küçük dosya
%%DEFINE DEBUG 1
%%PROFILE "DEBUG"
%%TARGET JS

TYPE SensorKaydi
    ph AS F64
    sicaklik AS F64
    durum AS STRING
END TYPE

FUNCTION Etiketle(ph AS F64) AS STRING
    IF ph < 6.5 THEN
        RETURN "asidik"
    ELSEIF ph > 8.5 THEN
        RETURN "bazik"
    ELSE
        RETURN "normal"
    END IF
END FUNCTION

SUB YazKayit(k AS SensorKaydi)
    PRINT "pH=" + STR(k.ph) + " durum=" + k.durum
END SUB

MAIN
    DIM k AS SensorKaydi
    k.ph = 7.42
    k.sicaklik = 24.8
    k.durum = Etiketle(k.ph)
    YazKayit(k)

    FOR i = 1 TO 3
        IF i MOD 2 = 0 THEN
            PRINT "cift olcum"
        ELSE
            PRINT "tek olcum"
        END IF
    NEXT i
END MAIN
```
```powershell
uxb parser_demo.uxb --preprocessed-out out/parser_demo.pre.uxb
uxb parser_demo.uxb --tokens-json-out out/parser_demo.tokens.json
uxb parser_demo.uxb --parser-json-out out/parser_demo.parser.json
uxb parser_demo.uxb --ast-json-out out/parser_demo.ast.json
uxb parser_demo.uxb --semantic-diagnostics-json-out out/parser_demo.semantic.json
uxb parser_demo.uxb --mir-full-json-out out/parser_demo.mir.json
uxb parser_demo.uxb --js-out dist/parser_demo.js
```

Bu dosya çözümleyiciye `TYPE`, `FUNCTION`, `IF`, `ELSEIF`, `RETURN`, `SUB`, `MAIN`, `DIM`, alan ataması, fonksiyon çağrısı, alt yordam çağrısı, `FOR`, `MOD`, `PRINT` ve `NEXT` gösterir. Önce `preprocessed` çıktıya bakılır; `%%DEFINE`, `%%PROFILE`, `%%TARGET` gibi satırlar artık normal programa sızmamalıdır. Sonra token raporunda kelimeler görünür. Parser raporunda komutların cümleye dönüşüp dönüşmediği anlaşılır. AST raporu ağacı gösterir. Semantic raporu tiplerin doğru bağlandığını gösterir. MIR raporu hedeflerden bağımsız gövdeyi verir. JS çıktısı ise tarayıcı hedefinin gerçek dosyasıdır.

# 4. Ön-işleyici komutları

Ön-işleyici, program çalışmadan önce kaynak metni hazırlar. Bu yüzden `%%` komutları çalışma zamanı komutu değildir; kullanıcı ekranda `%%DEFINE` çalıştırmaz, derleyici kaynak dosyayı okurken onu değerlendirir. Ön-işleyiciyi iyi kullanan programcı aynı kaynaktan debug, release, tarayıcı, WAT, x64, bilimsel analiz veya eğitim paketi çıkarabilir. Kötü kullanan programcı ise kaynağı gizemli hâle getirir. Kural şudur: ön-işleyici ile hedef, yol, sabit, varlık ve paket bilgisi yönet; iş mantığını gereksiz yere meta katmana kaçırma.

| No | Komut | Sözdizimi | Ne yapar? |
|---:|---|---|---|
| 1 | `%%DEFINE` | `%%DEFINE AD DEGER` | Bir adın yerine derleme öncesinde değer koyar. Küçük sabitler, hedef seçimi ve sürüm adı için kullanılır. |
| 2 | `%%SET` | `%%SET AD = DEGER` | DEFINE gibi çalışır; sonucu meta bildirimlere de taşır. Yapılandırma değerini okunur biçimde saklar. |
| 3 | `%%MACRO` | `%%MACRO AD(p1,p2) = gövde` | Tekrarlanan kod parçasını parametreli kısaltmaya çevirir. Uzun sabit ifadeleri ve kalıp satırları azaltır. |
| 4 | `%%ALIAS` | `%%ALIAS {ESKI} AS {YENI}` | Kaynakta görünen kalıbı başka kalıba dönüştürür. Kısa sözdizimi kurmak veya eski adları yeni ada taşımak için kullanılır. |
| 5 | `%%UNDEF` | `%%UNDEF AD` | Daha önce tanımlanan makroyu siler. Aynı dosyada farklı bölümlere farklı kural uygulamak için kullanılır. |
| 6 | `%%IF` | `%%IF AD ... %%ELSE ... %%ENDIF` | Makro değerine göre kaynak satırlarını derlemeye alır veya çıkarır. |
| 7 | `%%IFN` | `%%IFN SAYI >= 10 ... %%ENDIF` | Sayısal karşılaştırma yapar. Boyut, sürüm, seviye, hedef ve kapasite için uygundur. |
| 8 | `%%IFC` | `%%IFC SOL, SAG ... %%ENDIF` | İki metin değerini karşılaştırır. Hedef işletim sistemi veya profil adına göre seçim yapılır. |
| 9 | `%%ELIF` | `%%ELIF koşul` | Birden çok seçenekli şartlı derleme kurar; uzun iç içe IF kalabalığını azaltır. |
| 10 | `%%ELSE` | `%%ELSE` | Önceki koşullar tutmazsa alınacak kaynak bölümünü açar. |
| 11 | `%%ENDIF` | `%%ENDIF` | Şartlı derleme bloğunu kapatır. Her IF ailesi için kapatma gerekir. |
| 12 | `%%INCLUDE` | `%%INCLUDE "dosya.uxmh"` | Başlık, sabit, ortak fonksiyon veya modül parçasını ana kaynağa ekler. |
| 13 | `%%PLATFORM` | `%%PLATFORM WINDOWS` | Derleyen makinenin platformu beklenenle uyuşmazsa hata verir; yanlış ortamda build almayı önler. |
| 14 | `%%DESTOS` | `%%DESTOS WINDOWS` | Hedef işletim sistemi adını makro olarak tutar. Kütüphane ve çıktı yolu seçiminde kullanılır. |
| 15 | `%%NOZEROVARS` | `%%NOZEROVARS ON` | Değişkenlerin sıfırlanma politikasını seçer. Hız ve güvenlik kararını açık yapar. |
| 16 | `%%SECSTACK` | `%%SECSTACK ON` | Güvenli yığın [geçici değer alanı] davranışını açar. Dış çağrı ve bellek işlerinde önemlidir. |
| 17 | `%%TARGET` | `%%TARGET JS|WAT|WASM|X64` | Derleme hedefini meta katmanda bildirir. Aynı kaynak farklı hedefler için farklı parça üretebilir. |
| 18 | `%%OUTDIR` | `%%OUTDIR "dist/web"` | Çıktı klasörünü bildirir. JS, WAT, HTML, manifest ve varlıkların birlikte durmasını sağlar. |
| 19 | `%%ASSET_ROOT` | `%%ASSET_ROOT "assets"` | Resim, ses, CSS ve ek dosyaların kök dizinini tanımlar. |
| 20 | `%%ASSET_FILE` | `%%ASSET_FILE "data.csv", "dist/data.csv"` | Bir dosyayı çıktı paketine varlık olarak ekler. |
| 21 | `%%ASSET_IMAGE` | `%%ASSET_IMAGE "logo.png", "dist/logo.png"` | Resim dosyasını tarayıcı paketine ekler. |
| 22 | `%%ASSET_AUDIO` | `%%ASSET_AUDIO "uyari.wav", "dist/uyari.wav"` | Ses dosyasını tarayıcı veya oyun paketine ekler. |
| 23 | `%%ASSET_REQUIRE` | `%%ASSET_REQUIRE "runtime.js"` | Olması zorunlu varlığı bildirir; eksikse kapı testte yakalar. |
| 24 | `%%MANIFEST_SET` | `%%MANIFEST_SET ad = deger` | Manifest [paket fihristi] içine anahtar-değer yazar. |
| 25 | `%%MANIFEST_REQUIRE` | `%%MANIFEST_REQUIRE ad = deger` | Manifestte bulunması zorunlu bilgiyi bildirir. |
| 26 | `%%WAT_IMPORT` | `%%WAT_IMPORT "env", "print_i32", print_i32, "i32->void"` | WAT/WASM tarafında dış fonksiyon çağrısı tanımlar. |
| 27 | `%%WAT_EXPORT` | `%%WAT_EXPORT main` | WAT/WASM içinde dışarı açılacak fonksiyonu bildirir. |
| 28 | `%%JS_LINE` | `%%JS_LINE console.log("hazir")` | Üretilen JS dosyasına tek satır ekler. |
| 29 | `%%HTML_LINE` | `%%HTML_LINE <div id="app"></div>` | Üretilen HTML gövdesine satır ekler. |
| 30 | `%%CSS_LINE` | `%%CSS_LINE body { font-family: sans-serif; }` | Üretilen CSS içine satır ekler. |
| 31 | `%%JSON_SET` | `%%JSON_SET "app.version", "1.0"` | JSON çıktı veya manifest için değer bildirir. |
| 32 | `%%ALLOW_RAW_JS` | `%%ALLOW_RAW_JS ON` | Ham JS eklemeye izin verir. Güvenlik bilinciyle kullanılmalıdır. |
| 33 | `%%ALLOW_RAW_WAT` | `%%ALLOW_RAW_WAT ON` | Ham WAT eklemeye izin verir. Hedef doğrulamasıyla birlikte kullanılmalıdır. |
| 34 | `%%SAFE_PATHS` | `%%SAFE_PATHS ON` | Dosya yollarında güvenli sınır ister; rastgele üst klasöre çıkmayı engeller. |
| 35 | `%%REQUIRE_HOST_BINDING` | `%%REQUIRE_HOST_BINDING ON` | WASM host bağlantıları eksikse build’in geçmesini engeller. |
| 36 | `%%ASSERT_META` | `%%ASSERT_META HEDEF_OK` | Derleme öncesi koşul tutmazsa hata verir. Yanlış yapılandırmayı erken durdurur. |
| 37 | `%%WARN_META` | `%%WARN_META "uyarı metni"` | Derlemeyi durdurmadan uyarı üretir. |
| 38 | `%%PROFILE` | `%%PROFILE "DEBUG"` | Debug, release, browser, bilimsel veya üretim profili gibi kurulum adını saklar. |
| 39 | `%%CONFIG_FILE` | `%%CONFIG_FILE "build.cfg"` | KEY=VALUE veya düz JSON benzeri ayar dosyasından değer okur. |
| 40 | `%%PATH_ALIAS` | `%%PATH_ALIAS "@data" AS "assets/data"` | Uzun yolları kısa takma ada bağlar. |
| 41 | `%%LOCK_META` | `%%LOCK_META API_MODE` | Bir meta değerin sonradan değişmesini engeller. |
| 42 | `%%DUMP_META` | `%%DUMP_META "out/meta.json"` | Ön-işleyici sonucunu JSON raporu olarak yazar. |
| 43 | `%%SOURCE_MAP` | `%%SOURCE_MAP "out/source_map.json"` | Kaynak satır eşlemesini kayda geçirir. |
| 44 | `%%ENV` | `%%ENV "PATH" AS SYS_PATH` | İşletim sistemi çevre değişkenini meta ada alır. |
| 45 | `%%HASHFILE` | `%%HASHFILE "data.csv" AS DATA_HASH` | Dosyanın değişip değişmediğini anlamak için özet değer üretir. |
| 46 | `%%COPY_DIR` | `%%COPY_DIR "assets" AS "dist/assets"` | Bir dizini çıktı paketine ekleme isteği bildirir. |
| 47 | `%%EMBEDTEXT` | `%%EMBEDTEXT "sablon.txt" AS SABLON` | Metin dosyasını kaynak içine gömülü değer olarak alır. |
| 48 | `%%EMBEDBASE64` | `%%EMBEDBASE64 "logo.png" AS LOGO64` | Küçük ikili dosyayı Base64 [metne çevrilmiş ikili veri] olarak gömer. |
| 49 | `%%LICENSEFILE` | `%%LICENSEFILE "LICENSE"` | Dağıtım paketine lisans dosyasını zorunlu varlık olarak ekler. |
| 50 | `%%HTMLIMAGE` | `%%HTMLIMAGE "logo", "logo.png"` | HTML çıktıya resim etiketi ve varlık bildirimi ekler. |
| 51 | `%%HTMLAUDIO` | `%%HTMLAUDIO "alarm", "alarm.wav"` | HTML çıktıya ses etiketi ve varlık bildirimi ekler. |
| 52 | `%%CSS_RULE` | `%%CSS_RULE "#app", "padding: 8px;"` | Seçici ve kuraldan CSS bloğu üretir. |
| 53 | `%%CSS_IMPORT` | `%%CSS_IMPORT "theme.css"` | CSS içine dış stil dosyası bağlantısı ekler. |
| 54 | `%%MD_SAFE` | `%%MD_SAFE ON` | Markdown [düz metin belge biçimi] üretiminde güvenli çıktı politikasını işaretler. |
| 55 | `%%MD_CSS` | `%%MD_CSS "style.css"` | Markdown/HTML belge çıktısında kullanılacak CSS dosyasını bildirir. |
| 56 | `%%INFOMETA` | `%%INFOMETA "not"` | Ön-işleyici günlüklerine bilgilendirme notu ekler. |
| 57 | `%%ENDCOMP` | `%%ENDCOMP` | Kaynak üretimini burada bitirir. |
| 58 | `%%ERRORENDCOMP` | `%%ERRORENDCOMP "sebep"` | Derlemeyi hata ile keser; zorunlu koşul bozulduğunda kullanılır. |

Ön-işleyici tablosunda aynı cümlenin tekrar etmemesi için her komutun gerçek görevi yazılmıştır. `%%DEFINE` sabit verir, `%%INCLUDE` dosya ekler, `%%TARGET` hedef seçer, `%%ASSET_IMAGE` resim varlığı bildirir, `%%WAT_IMPORT` WebAssembly dış çağrısını tanımlar. Bunların hepsi kaynak daha parser katmanına gitmeden önce çalışır.

# 5. Ön-işleyici örnekleri 15–21

Aşağıdaki örnekler küçük oyuncak parçalar değildir. Her biri en az birkaç farklı komutu birlikte kullanır ve gerçek bir çalışma alışkanlığı öğretir. Kodlar uXBasic sözdizimiyle yazılmıştır; amaç 1. ciltte ön-işleyici, dosya düzeni, CLI, veri tutma ve rapor üretme mantığını birlikte göstermektir.

## Örnek 15 — Profil seçen ve ortak başlık alan derleme

```uxbasic
' ornek15_profil.uxb
%%PROFILE "DEBUG"
%%DEFINE APP_NAME "KaliteDefteri"
%%DEFINE MAX_OLCUM 30
%%TARGET JS
%%OUTDIR "dist/ornek15"
%%INCLUDE "ortak_ayarlar.uxmh"
%%IF DEBUG
    %%WARN_META "Debug profili acik: ayrintili rapor uretilecek"
%%ELSE
    %%WARN_META "Release profili: kisa rapor uretilecek"
%%ENDIF

MAIN
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM olcum AS ARRAY[30] OF F64

    FOR i = 0 TO 29
        olcum[i] = 7.00 + (i MOD 5) * 0.08
        toplam = toplam + olcum[i]
    NEXT i

    ort = toplam / 30
    PRINT APP_NAME
    PRINT "Olcum sayisi=" + STR(MAX_OLCUM)
    PRINT "Ortalama pH=" + STR(ort)
END MAIN
```

Bu örnek profil seçmeyi öğretir. `%%PROFILE`, build düzenini adlandırır. `%%DEFINE`, program içinde kullanılacak sabitleri hazırlar. `%%TARGET` ve `%%OUTDIR`, çıktının nereye gideceğini söyler. `%%INCLUDE`, ortak ayarları alır. `%%IF` ile debug veya release notu üretilir. Program kısmında `ARRAY`, `FOR`, `MOD`, toplama, bölme ve `PRINT` birlikte kullanılır. Genç programcı burada şunu öğrenmelidir: profil bilgisi çalışma zamanında kullanıcıdan alınacak veri değildir; build sırasında seçilir.

```powershell
uxb ornek15_profil.uxb --preprocessed-out out/ornek15.pre.uxb
uxb ornek15_profil.uxb --tokens-json-out out/ornek15.tokens.json
uxb ornek15_profil.uxb --js-out dist/ornek15/program.js
uxb ornek15_profil.uxb --manifest-out dist/ornek15/manifest.json
```

## Örnek 16 — Parser alıştırması: farklı komut türlerini aynı dosyada denetleme

```uxbasic
' ornek16_parser_alistirma.uxb
%%DEFINE MOD_ADI "ParserAlistirma"
%%TARGET X64
%%OUTDIR "out/ornek16"
%%ASSERT_META MOD_ADI

TYPE Urun
    kod AS STRING
    agirlik AS F64
    kabul AS I32
END TYPE

FUNCTION KalitePuani(agirlik AS F64) AS I32
    IF agirlik >= 98.0 AND agirlik <= 102.0 THEN
        RETURN 100
    ELSEIF agirlik >= 95.0 AND agirlik <= 105.0 THEN
        RETURN 80
    ELSE
        RETURN 30
    END IF
END FUNCTION

MAIN
    DIM u AS Urun
    DIM puan AS I32
    u.kod = "A-100"
    u.agirlik = 104.2
    puan = KalitePuani(u.agirlik)

    SELECT CASE puan
    CASE 100
        u.kabul = 1
    CASE 80
        u.kabul = 1
    CASE ELSE
        u.kabul = 0
    END SELECT

    IF u.kabul = 1 THEN
        PRINT "Urun kabul: " + u.kod
    ELSE
        PRINT "Urun red: " + u.kod
    END IF
END MAIN
```

Bu örnek çözümleyicinin birçok komutu aynı kaynakta tanımasını sağlar. `TYPE` veri kaydı kurar. `FUNCTION` puan hesaplar. `IF/ELSEIF/ELSE` sınırları yorumlar. `SELECT CASE` puanı karara bağlar. `MAIN`, `DIM`, alan ataması ve `PRINT` programı tamamlar. Bu örneği derlerken yalnız çalıştırma sonucuna bakma; parser ve AST çıktısına bak. Genç programcı ağacı görürse kodun nasıl cümleye dönüştüğünü anlar.

```powershell
uxb ornek16_parser_alistirma.uxb --parser-json-out out/ornek16.parser.json
uxb ornek16_parser_alistirma.uxb --ast-json-out out/ornek16.ast.json
uxb ornek16_parser_alistirma.uxb --symbol-table-json-out out/ornek16.symbols.json
uxb ornek16_parser_alistirma.uxb --type-table-json-out out/ornek16.types.json
uxb ornek16_parser_alistirma.uxb --emit-x64-nasm-out out/ornek16.asm
```

## Örnek 17 — Tarayıcı paketi: HTML, CSS, resim, JS ve manifest

```uxbasic
' ornek17_browser_paket.uxb
%%PROFILE "BROWSER"
%%TARGET JS
%%OUTDIR "dist/ornek17"
%%ASSET_ROOT "assets"
%%ASSET_IMAGE "assets/logo.png", "dist/ornek17/logo.png"
%%ASSET_REQUIRE "ux_runtime.js"
%%MANIFEST_SET app.name = "uXBasic Sensor Panel"
%%MANIFEST_SET app.version = "1.0.0"
%%HTML_LINE <div id="app"></div>
%%CSS_RULE "#app", "font-family: sans-serif; padding: 12px;"
%%CSS_RULE ".ok", "color: green; font-weight: bold;"
%%JS_LINE console.log("uXBasic browser paketi yuklendi");

MAIN
    DIM ph AS F64
    DIM durum AS STRING
    ph = 7.38

    IF ph >= 6.5 AND ph <= 8.5 THEN
        durum = "ok"
    ELSE
        durum = "uyari"
    END IF

    PRINT "Tarayici paneli hazir"
    PRINT "pH=" + STR(ph) + " durum=" + durum
END MAIN
```

Bu örnek tarayıcı hedefinde programın yalnız `program.js` olmadığını gösterir. `%%ASSET_IMAGE`, resim varlığını paketler. `%%ASSET_REQUIRE`, zorunlu çalışma zamanı dosyasını bildirir. `%%MANIFEST_SET`, paket kimliğini yazar. `%%HTML_LINE` ve `%%CSS_RULE`, sayfa iskeletini kurar. Program kısmında pH değeri yorumlanır. Böylece ön-işleyici paket hazırlarken, uXBasic kodu iş mantığını taşır.

```powershell
uxb ornek17_browser_paket.uxb --js-out dist/ornek17/program.js
uxb ornek17_browser_paket.uxb --html-out dist/ornek17/index.html
uxb ornek17_browser_paket.uxb --manifest-out dist/ornek17/manifest.json
uxb ornek17_browser_paket.uxb --artifact-report-json-out out/ornek17.artifacts.json
uxb ornek17_browser_paket.uxb --validate-all-report-json-out out/ornek17.validate.json
```

## Örnek 18 — Laboratuvar ölçümü: pH defteri, sınır yorumu ve dosya özeti

```uxbasic
' ornek18_lab_ph.uxb
%%PROFILE "LAB"
%%TARGET X64
%%OUTDIR "out/lab"
%%CONFIG_FILE "lab.cfg"
%%HASHFILE "lab.cfg" AS LAB_CFG_HASH
%%DUMP_META "out/lab/meta.json"

MAIN
    DIM ph AS ARRAY[12] OF F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM dusuk AS I32
    DIM yuksek AS I32
    DIM normal AS I32

    ph[0]=7.12: ph[1]=7.31: ph[2]=6.88: ph[3]=8.62
    ph[4]=7.44: ph[5]=7.02: ph[6]=8.10: ph[7]=6.42
    ph[8]=7.55: ph[9]=7.76: ph[10]=8.90: ph[11]=7.20

    FOR i = 0 TO 11
        toplam = toplam + ph[i]
        IF ph[i] < 6.5 THEN
            dusuk = dusuk + 1
        ELSEIF ph[i] > 8.5 THEN
            yuksek = yuksek + 1
        ELSE
            normal = normal + 1
        END IF
    NEXT i

    ort = toplam / 12
    PRINT "Laboratuvar pH raporu"
    PRINT "Ortalama=" + STR(ort)
    PRINT "Dusuk=" + STR(dusuk) + " Normal=" + STR(normal) + " Yuksek=" + STR(yuksek)
    IF dusuk + yuksek > 0 THEN
        PRINT "Uyari: tekrar kalibrasyon ve ikinci olcum gerekli"
    ELSE
        PRINT "Seri kabul edilebilir aralikta"
    END IF
END MAIN
```

Burada laboratuvar ölçümü gerçek bir karar üretir. On iki pH değeri diziye konur. Döngü hem toplam alır hem sınır dışı değer sayar. `IF/ELSEIF/ELSE`, ölçümü sınıflandırır. Ortalama tek başına yeterli değildir; iki uç değer varsa ortalama normal çıksa bile seri şüpheli olabilir. Bu, bilimsel programlamada önemli bir ipucudur: tek özet sayıya güvenme, sınır dışı sayıyı da tut.

## Örnek 19 — Üretim kalite kontrolü: 30 veriyle hata analizi

```uxbasic
' ornek19_uretim_kalite.uxb
%%PROFILE "QC"
%%TARGET X64
%%OUTDIR "out/qc"
%%MANIFEST_SET report.kind = "quality-control"
%%SOURCE_MAP "out/qc/source_map.json"

MAIN
    DIM agirlik AS ARRAY[30] OF F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM sapmaToplam AS F64
    DIM varyans AS F64
    DIM s AS F64
    DIM hata AS I32
    DIM sinirAlt AS F64
    DIM sinirUst AS F64

    sinirAlt = 95.0
    sinirUst = 105.0

    agirlik[0]=99.8: agirlik[1]=100.2: agirlik[2]=101.1: agirlik[3]=98.9: agirlik[4]=104.8
    agirlik[5]=95.2: agirlik[6]=94.7: agirlik[7]=100.0: agirlik[8]=102.5: agirlik[9]=106.3
    agirlik[10]=97.9: agirlik[11]=99.1: agirlik[12]=101.6: agirlik[13]=103.2: agirlik[14]=96.4
    agirlik[15]=100.7: agirlik[16]=98.5: agirlik[17]=107.0: agirlik[18]=95.8: agirlik[19]=99.9
    agirlik[20]=101.0: agirlik[21]=102.1: agirlik[22]=93.9: agirlik[23]=104.0: agirlik[24]=100.4
    agirlik[25]=97.2: agirlik[26]=98.8: agirlik[27]=105.4: agirlik[28]=99.6: agirlik[29]=101.8

    FOR i = 0 TO 29
        toplam = toplam + agirlik[i]
        IF agirlik[i] < sinirAlt OR agirlik[i] > sinirUst THEN
            hata = hata + 1
        END IF
    NEXT i

    ort = toplam / 30

    FOR i = 0 TO 29
        sapmaToplam = sapmaToplam + (agirlik[i] - ort) * (agirlik[i] - ort)
    NEXT i

    varyans = sapmaToplam / 29
    s = SQRT(varyans)

    PRINT "Uretim kalite raporu"
    PRINT "Ortalama agirlik=" + STR(ort)
    PRINT "Standart sapma=" + STR(s)
    PRINT "Sinir disi adet=" + STR(hata)

    IF hata > 3 THEN
        PRINT "Karar: proses durdur, terazi ve dolum ayari kontrol et"
    ELSEIF s > 3.0 THEN
        PRINT "Karar: proses calisiyor ama dagilim genis, ayar yap"
    ELSE
        PRINT "Karar: seri kabul"
    END IF
END MAIN
```

Bu örnek üretim kalite kontrolünün temel mantığını gösterir. Otuz veri rastgele süs değildir; seri hakkında karar verir. Ortalama hedefe yakın olabilir ama sınır dışı ürün fazla ise seri reddedilir. Standart sapma [değerlerin ortalamadan ne kadar yayıldığını gösteren ölçü] yüksekse makine kararsız çalışıyor olabilir. Bu program, `ARRAY`, `FOR`, `IF`, `OR`, aritmetik, `SQRT`, sayaç, karar ve raporlama komutlarını birlikte kullanır. Kalite problemini yalnız tek ürün hatası gibi değil, süreç hatası gibi düşünmeyi öğretir.

## Örnek 20 — IF zinciri yerine tablo: LIST, DICT ve SET ile karar motoru

```uxbasic
' ornek20_tablo_karar.uxb
%%PROFILE "TABLE"
%%TARGET JS
%%OUTDIR "dist/table"

MAIN
    DIM komutlar AS DICT
    DIM roller AS SET
    DIM gunluk AS LIST
    DIM istek AS STRING
    DIM yetki AS STRING
    DIM sonuc AS STRING

    DICT_SET komutlar, "DERLE", "build"
    DICT_SET komutlar, "CALISTIR", "run"
    DICT_SET komutlar, "TEST", "validate"
    DICT_SET komutlar, "RAPOR", "report"

    SET_ADD roller, "ogrenci"
    SET_ADD roller, "gelistirici"
    SET_ADD roller, "yonetici"

    istek = "TEST"
    yetki = "gelistirici"

    IF SET_HAS(roller, yetki) THEN
        IF DICT_HAS(komutlar, istek) THEN
            sonuc = DICT_GET(komutlar, istek)
            LIST_PUSH gunluk, "Komut bulundu: " + istek + " => " + sonuc
        ELSE
            sonuc = "unknown"
            LIST_PUSH gunluk, "Bilinmeyen komut: " + istek
        END IF
    ELSE
        sonuc = "denied"
        LIST_PUSH gunluk, "Yetki yok: " + yetki
    END IF

    PRINT "Karar=" + sonuc
    PRINT LIST_GET(gunluk, 0)
END MAIN
```

Bu örnek yüz satırlık `IF istek = "DERLE" THEN ... ELSEIF ...` zinciri yerine tablo kurmayı öğretir. `DICT`, komut adını göreve bağlar. `SET`, geçerli rolleri tutar. `LIST`, olay günlüğünü sırayla saklar. Bu üç yapı birlikte küçük bir komut yönlendirici oluşturur. İşin zekâsı şuradadır: yeni komut eklemek için programın karar gövdesini büyütmezsin, tabloya yeni satır eklersin. Büyük sistemlerde bu yöntem parser, servis kataloğu, hata kodu ve CLI kayıtlarında çok işe yarar.

## Örnek 21 — Tampon [geçici veri alanı] ile çalışma: büyük veriyi güvenli handle ile taşımak

```uxbasic
' ornek21_tampon_handle.uxb
%%PROFILE "BUFFER"
%%TARGET X64
%%OUTDIR "out/buffer"
%%SECSTACK ON
%%NOZEROVARS ON

MAIN
    DIM buf AS I32
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM deger AS F64
    DIM esik AS F64
    DIM alarm AS I32

    esik = 80.0
    buf = BUFFER_CREATE(30, F64)

    FOR i = 0 TO 29
        deger = 72.0 + (i MOD 9) * 1.7
        BUFFER_SET_F64 buf, i, deger
    NEXT i

    FOR i = 0 TO 29
        deger = BUFFER_GET_F64(buf, i)
        toplam = toplam + deger
        IF deger > esik THEN
            alarm = alarm + 1
        END IF
    NEXT i

    ort = toplam / 30
    PRINT "Tampon ortalamasi=" + STR(ort)
    PRINT "Esik ustu adet=" + STR(alarm)

    BUFFER_FILL_F64 buf, 0.0
    BUFFER_FREE buf
END MAIN
```

“Sayı dizilerini güvenli handle ile taşır” cümlesi tek başına yetmez; bu örnek o cümleyi programa çevirir. `BUFFER_CREATE`, çalışma zamanında bir tampon açar ve sana bir handle [nesneyi temsil eden güvenli numara] verir. Program veriyi her seferinde büyük BASIC dizisi gibi kopyalamaz; `BUFFER_SET_F64` ve `BUFFER_GET_F64` ile tampon üstünde çalışır. Eşik üstü değerler sayılır, ortalama hesaplanır, iş bitince `BUFFER_FREE` ile alan kapatılır. Büyük veri, ses, görüntü, sensör akışı ve dış DLL işlerinde bu mantık önemlidir. Altın kural: handle açtıysan kapat; kapatmadan programdan çıkma.

# 6. Cilt 1 çalışma disiplini

Bu cildin sonunda bir genç programcı şu düzeni kazanmalıdır: dosyayı doğru uzantıyla aç, ön-işleyici ile hedefi ve paketi bildir, CLI ile ara raporları üret, çıktıların gerçek olduğunu denetle, küçük örnekleri laboratuvar ve üretim gibi gerçek sorunlara bağla. uXBasic’i yalnız bir dil gibi değil, bir üretim hattı gibi kullanırsan büyüyen projelerde kaybolmazsın.

Bir programda hata ararken şu sırayı izle: önce `--preprocessed-out` ile kaynak son hâlini gör, sonra `--tokens-json-out` ile kelimeleri incele, sonra `--parser-json-out` ve `--ast-json-out` ile cümle ağacını kontrol et, sonra `--semantic-diagnostics-json-out` ile tip ve kapsam sorunlarına bak, sonra `--mir-full-json-out` ile ara temsili denetle, en son hedef çıktıyı üret. Bu sıra seni tahmin yürütmekten kurtarır.

## Cilt 1 sonunda mini ödevler

1. `ornek15_profil.uxb` dosyasını `DEBUG` ve `RELEASE` profiliyle iki kez derle; oluşan ön-işlenmiş dosyaları karşılaştır.
2. `ornek16_parser_alistirma.uxb` için AST raporunda `IF`, `SELECT`, `FUNCTION` düğümlerini ara.
3. `ornek17_browser_paket.uxb` için manifest dosyasında resim ve runtime varlığını kontrol et.
4. `ornek18_lab_ph.uxb` içinde iki değeri sınır dışına çıkar; karar metni değişiyor mu bak.
5. `ornek19_uretim_kalite.uxb` içinde 30 veriden 5 tanesini bozuk yap; hata sayısı kararını yorumla.
6. `ornek20_tablo_karar.uxb` içine yeni `TEMIZLE` komutu ekle; IF zinciri büyümeden çalışmasını sağla.
7. `ornek21_tampon_handle.uxb` içinde `BUFFER_FREE` satırını bilerek kaldır; runtime trace raporunda kaynak sızıntısı yakalanıyor mu incele.

Bu ödevler basit alıştırma değil, meslek alışkanlığıdır. Hata üretmeden hata yakalamayı öğrenemezsin. Rapor okumadan derleyici mantığını öğrenemezsin. Tablo kurmadan büyük programı yönetemezsin. Tampon açıp kapatmadan bellek disiplinini anlayamazsın.
