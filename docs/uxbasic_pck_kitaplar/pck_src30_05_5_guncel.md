# uXBasic Programlayıcının Cep Kitabı — src(30.05_5) Birleşik Güncel Baskı

Bu kitap, daha önce üretilmiş `pck.md` ve `pck1*` … `pck5*` dosyalarındaki dağınık bilgi, tablo ve örnekleri tek akışta birleştirir. Bu baskıda `src(30.05_5).zip` kaynak ağacı son gerçeklik kabul edilmiştir; yamalarda görünen yeni kararlar artık “yama” değil, dilin normal çalışma yüzeyi gibi anlatılır. Kitap programlamayı az bilen bir genç programcıyı hedefler: önce anlam, sonra sözdizimi, sonra örnek ve en sonda derleyici geliştiricisinin bakış açısı verilir. İngilizce bir terim gerektiğinde Türkçesi ve kısa açıklamasıyla birlikte kullanılır.

## Kullanım hakkı, lisans ve sorumluluk

uXBasic kaynakları ve bu kitap MIT lisanslı bir çalışma gibi ele alınır. MIT lisansı, kodu kullanma, değiştirme, dağıtma, özel veya ticari projeye katma hakkı verir; buna karşılık yazarı yazılımın kullanılmasından doğacak doğrudan veya dolaylı zararlardan sorumlu tutmaz. Bu kitap eğitim ve geliştirme amacıyla hazırlanmıştır. Yanlış kullanım, güvenlik açığı, dış kütüphane hatası, veri kaybı, API masrafı, sistem hasarı veya üçüncü taraf lisans ihlali kullanıcının sorumluluğundadır. Sorun, öneri ve destek için `zmetedinler@gmail.com` adresine yazılabilir. Gönüllü destek olarak 50 TL kullanım katkısı veya 25 ABD doları bağış gönderilmesi memnuniyetle karşılanır; IBAN bilgisi proje sahibinin ayrıca paylaşacağı resmi metinde yer almalıdır.

## Son gerçeklik: src(30.05_5) ile gelen ana yüzey

| Alan | Bu baskıda nasıl kabul edildi? |
| --- | --- |
| Kaynak katmanı | Sözcükleyici, çözümleyici, ön-işleyici, anlam, MIR, çalışma zamanı, JS/WASM/x64/x86 kod üreticileri ayrı dosya ailelerine bölünmüş görünür. |
| ADIM41 komut satırı | Çıktı sözleşmesi ve kısa fiiller genişlemiştir; `--html-out`, `--manifest-out`, `--build-x64-out`, `--program-output-out` gibi yollar kitapta normal seçenek kabul edilir. |
| Büyük sayı ailesi | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `F80`, `F128` tipleri ve dış hassas sayı çalışma zamanı birlikte anlatılır. |
| Web ve WASM | JS üreteci, tarayıcı çalışma zamanı, WAT/WASM yazıcı, host import/export ve manifest/varlık sistemi birlikte kullanılacak şekilde işlenir. |
| Kütüphane servisleri | JSON, regex, HTTP, OS, Llama, Lua, Prolog, SQLite, browser, WebGPU, arşiv, ses, kripto, curl, grafik, image, ONNX, server ve stringx çağrıları çalışma zamanı servisi olarak anlatılır. |
| Kanca ve sarmalayıcı | Hook, wrapper, FFI, interop manifest ve native-only gate kavramları derleyici geliştiricisinin aracı olarak açıklanır. |

## İçindekiler

- 1. uXBasic nedir, dosyalar ve çıktılar
- 2. Mimari katmanlar
- 3. Dil yüzeyi: komutlar, fonksiyonlar, işleçler
- 4. Ön-işleyici
- 5. Veri tipleri ve veri yapıları
- 6. Çalışma zamanı servisleri ve kütüphaneler
- 7. Kanca, sarmalayıcı, dış çağrı ve derleyici geliştirme
- 8. Tarayıcı, JS, WAT/WASM ve API köprüleri
- 9. Bilimsel veri ve istatistik defteri
- 10. Eski dosyalardan yerleştirilen örnek defteri
- 11. Kaynak gerçekliği tabloları

# 1. uXBasic nedir, dosyalar ve çıktılar

uXBasic, BASIC ailesinin okunabilirliğini sistem programlama, tarayıcı çıktısı, dış kütüphane çağrısı ve çok katmanlı derleme fikriyle birleştiren bir dildir. Bir genç programcı için uXBasic’in en güzel tarafı şudur: ekrana yazı yazan küçük bir programla başlayıp aynı dil yüzeyiyle dosya işleyen, veri analiz eden, DLL çağıran, tarayıcıya JS üreten veya WAT/WASM çıktısı alan projeye doğru büyüyebilirsin. Burada amaç sadece “PRINT yaz, sonucu gör” değildir; kaynak kodun hangi aşamalardan geçerek gerçek programa dönüştüğünü de öğrenmektir.

| Uzantı | Anlamı ve kullanımı |
| --- | --- |
| `.uxb` | Ana program dosyasıdır. Doğrudan derlenir veya çalıştırılır. |
| `.uxbh` | Başlık ve ortak tanım dosyasıdır; `INCLUDE` veya ön-işleyici dahil etmesiyle kullanılır. |
| `.bas` | BASIC benzeri kaynak veya uyumluluk dosyasıdır; bazı testlerde ve geçişlerde kullanılır. |
| `.c`, `.cpp`, `.asm` | `IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)` ile derleme zamanında projeye bağlanan dış kaynaklardır. |
| `.json` | Token, AST, MIR, rapor, manifest, hata ve çıktı sözleşmesi dosyasıdır. |
| `.js` | Tarayıcı veya Node tarafında çalışacak JavaScript [tarayıcı dili] çıktısıdır. |
| `.wat` | WebAssembly metin biçimi [WASM’ın okunur hali] çıktısıdır. |
| `.wasm` | Tarayıcıda veya host ortamında çalışabilecek ikili WebAssembly çıktısıdır. |
| `.asm`/`.nasm` | x64/x86 için derleyici tarafından üretilen assembly [işlemciye yakın metin kod] çıktısıdır. |

```uxbasic
MAIN
    PRINT "Merhaba uXBasic"
    DIM yas AS I32
    INPUT yas
    IF yas >= 18 THEN
        PRINT "Kendi aracini yazmaya baslayabilirsin"
    ELSE
        PRINT "Once bol bol kucuk alistirma yap"
    END IF
END MAIN
```

Bu ilk örnekte `MAIN` programın başlangıç yerini gösterir, `PRINT` ekrana yazar, `DIM` değişken ayırır, `INPUT` kullanıcıdan değer alır, `IF` karar verir. Beş komut birlikte küçük ama gerçek bir program kurar: kullanıcıdan veri alınır, veri saklanır, koşul hesaplanır ve sonuç ekrana bildirilir.

## Komut satırı ve çıktı sözleşmesi

Komut satırı, derleyiciyle konuştuğun yerdir. `src(30.05_5)` içinde ADIM41 ile seçenek sayısı genişlemiştir. Bu seçenekleri ezberlemek yerine görevlerine göre düşün: kaynak okumak, ara rapor üretmek, hedef kod üretmek, çalıştırma raporu almak ve test kapısını işletmek.

| No | Seçenek | Görev |
| --- | --- | --- |
| 3 | --artifact-report-json-out | JavaScript çıktısı veya raporu üretir. |
| 4 | --ast-contract-check | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 5 | --ast-contract-json-out | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 6 | --ast-contract-matrix-out | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 7 | --ast-contract-report-json-out | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 8 | --ast-json-out | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 10 | --backend-report-json-out | JavaScript çıktısı veya raporu üretir. |
| 11 | --build-x64 | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 12 | --build-x64-out | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 16 | --debug | Hata ayıklama, izleme ve kanca kayıtlarını açar. |
| 17 | --debug-log-out | Belirtilen aşamanın rapor veya çıktı dosya yolunu verir. |
| 18 | --debug-token-dump | Hata ayıklama, izleme ve kanca kayıtlarını açar. |
| 21 | --doc-json-out | JavaScript çıktısı veya raporu üretir. |
| 22 | --dump-ast | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 23 | --dump-mir | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 24 | --emit-browser | Derleyicinin ilgili aşamasını kontrol eder. |
| 25 | --emit-js | JavaScript çıktısı veya raporu üretir. |
| 26 | --emit-nasm | Derleyicinin ilgili aşamasını kontrol eder. |
| 27 | --emit-wasm | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 28 | --emit-wat | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 29 | --emit-x64-nasm | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 30 | --emit-x64-nasm-out | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 31 | --emit-x86 | x86 hedef yüzeyini seçer veya denetler. |
| 33 | --enable-mir-x64-experimental | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 37 | --extfp-policy-json-out | JavaScript çıktısı veya raporu üretir. |
| 39 | --extfp-strict | Derleyicinin ilgili aşamasını kontrol eder. |
| 41 | --final-screen-json-out | JavaScript çıktısı veya raporu üretir. |
| 43 | --help | Yardım veya sürüm bilgisini gösterir. |
| 44 | --hir-inventory-json-out | JavaScript çıktısı veya raporu üretir. |
| 45 | --hir-json-out | JavaScript çıktısı veya raporu üretir. |
| 46 | --hook-trace | Hata ayıklama, izleme ve kanca kayıtlarını açar. |
| 47 | --html-out | Tarayıcı HTML kabuğunu üretir. |
| 48 | --interop | Derleyicinin ilgili aşamasını kontrol eder. |
| 50 | --inventory-json-out | JavaScript çıktısı veya raporu üretir. |
| 51 | --ir-json-out | JavaScript çıktısı veya raporu üretir. |
| 52 | --js-out | JavaScript çıktısı veya raporu üretir. |
| 53 | --json-out | JavaScript çıktısı veya raporu üretir. |
| 55 | --layer-timing-json-out | JavaScript çıktısı veya raporu üretir. |
| 56 | --layout-report-json-out | JavaScript çıktısı veya raporu üretir. |
| 57 | --lexer-diagnostics-json-out | JavaScript çıktısı veya raporu üretir. |
| 58 | --log-out | Belirtilen aşamanın rapor veya çıktı dosya yolunu verir. |
| 59 | --manifest-out | Paket/varlık manifest dosyasını üretir. |
| 61 | --mir-full-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 62 | --mir-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 63 | --mir-module-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 64 | --mir-opcodes-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 65 | --mir-opt-report-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 66 | --mir-pipeline-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 67 | --mir-surface-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 68 | --mir-verify | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 69 | --mir-verify-json-out | MIR [orta ara gösterim] raporu, doğrulaması veya çıktısı üretir. |
| 70 | --parse-only | Derleyicinin ilgili aşamasını kontrol eder. |
| 71 | --parser-diagnostics-json-out | JavaScript çıktısı veya raporu üretir. |
| 72 | --parser-json-out | JavaScript çıktısı veya raporu üretir. |
| 73 | --pipeline-json-out | JavaScript çıktısı veya raporu üretir. |
| 74 | --preprocessed-out | Belirtilen aşamanın rapor veya çıktı dosya yolunu verir. |
| 75 | --program-output-json-out | JavaScript çıktısı veya raporu üretir. |
| 76 | --program-output-out | Belirtilen aşamanın rapor veya çıktı dosya yolunu verir. |
| 78 | --release-gate | Kapı testleri ve yayın doğrulaması çalıştırır. |
| 79 | --release-json-out | JavaScript çıktısı veya raporu üretir. |
| 80 | --run-report-json-out | JavaScript çıktısı veya raporu üretir. |
| 81 | --runtime-trace-json-out | JavaScript çıktısı veya raporu üretir. |
| 82 | --semantic | Derleyicinin ilgili aşamasını kontrol eder. |
| 83 | --semantic-diagnostics-json-out | JavaScript çıktısı veya raporu üretir. |
| 84 | --semantic-json-out | JavaScript çıktısı veya raporu üretir. |
| 86 | --session-live-json-out | JavaScript çıktısı veya raporu üretir. |
| 90 | --source-map-json-out | JavaScript çıktısı veya raporu üretir. |
| 91 | --stderr-out | Programın standart çıktı/hata akışını dosyaya yazar. |
| 92 | --stdout-out | Programın standart çıktı/hata akışını dosyaya yazar. |
| 94 | --strict | Derleyicinin ilgili aşamasını kontrol eder. |
| 95 | --symbol-table-json-out | JavaScript çıktısı veya raporu üretir. |
| 96 | --target | Derleyicinin ilgili aşamasını kontrol eder. |
| 97 | --target-browser | Derleyicinin ilgili aşamasını kontrol eder. |
| 98 | --target-js | JavaScript çıktısı veya raporu üretir. |
| 99 | --target-wasm | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 100 | --target-wat | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 101 | --target-x86 | x86 hedef yüzeyini seçer veya denetler. |
| 103 | --token-json-out | JavaScript çıktısı veya raporu üretir. |
| 104 | --tokens-json-out | JavaScript çıktısı veya raporu üretir. |
| 105 | --trace | Hata ayıklama, izleme ve kanca kayıtlarını açar. |
| 106 | --trace-json | JavaScript çıktısı veya raporu üretir. |
| 107 | --type-table-json-out | JavaScript çıktısı veya raporu üretir. |
| 108 | --validate-all | Kapı testleri ve yayın doğrulaması çalıştırır. |
| 109 | --validate-all-fail-fast | AST [soyut sözdizimi ağacı] raporu veya denetimi üretir. |
| 110 | --validate-all-report-json-out | JavaScript çıktısı veya raporu üretir. |
| 111 | --version | Yardım veya sürüm bilgisini gösterir. |
| 112 | --wasm-out | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 113 | --wasm-wat-out | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 114 | --wat-out | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 115 | --wat2wasm | WAT/WASM çıktısı, köprüsü veya raporu üretir. |
| 116 | --x64 | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 117 | --x64-codegen-policy-json-out | JavaScript çıktısı veya raporu üretir. |
| 118 | --x64gen | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |
| 119 | --x64gen-out | x64 assembly/derleme hattını seçer veya çıktı yolunu verir. |

```powershell
uxb ast main.uxb --ast-json-out out/ast.json
uxb mir main.uxb --mir-json-out out/mir.json --mir-verify-json-out out/mir_gate.json
uxb jsw web.uxb --emit-js --js-out dist/web/program.js --html-out dist/web/index.html
uxb wat hizli.uxb --emit-wat --wat-out dist/wasm/program.wat --manifest-out dist/manifest.json
uxb run rapor.uxb --stdout-out out/stdout.txt --stderr-out out/stderr.txt --run-report-json-out out/run.json
```

# 2. Mimari katmanlar

Mimari, programın derleyici içinde geçtiği durakların adıdır. Bu adları bilmek genç programcıya iki üstünlük kazandırır: hata nerede doğduğunu anlarsın ve dili geliştirmek istediğinde hangi klasöre bakacağını bilirsin. uXBasic’te kaynak metin önce ön-işleyiciden geçer; sonra sözcükleyici [metni sözcüklere ayıran katman] kelimeleri ve işaretleri üretir; çözümleyici [komutları ağaç yapan katman] bunları AST’ye çevirir; anlam katmanı tip, kapsam ve isimleri denetler; MIR [orta ara gösterim] komutları hedeflerden bağımsız bir listeye indirir; arka uç [çıktı üreten katman] x64, x86, JS, WAT/WASM gibi hedefleri yazar; çalışma zamanı [program çalışırken gereken hizmetler] dosya, ekran, bellek, kütüphane ve servis çağrılarını taşır.

| Klasör | Görev |
| --- | --- |
| preprocessor | Derleme öncesi metni, makroyu, hedef seçimini ve varlık paketlemeyi hazırlar. |
| parser | Sözcükleri komut, ifade, sınıf, olay ve dış çağrı düğümlerine dönüştürür. |
| semantic | Tip, kapsam, kullanım ve katman uyumunu denetler. |
| symbols | Değişken, yordam, sınıf, sabit ve dış ad tablolarını tutar. |
| type_binding | Tip adlarını gerçek tip kurallarına bağlar. |
| layout | Sınıf, kayıt ve bellek alanlarını düzenler. |
| mir | Hedeften bağımsız orta işlem listesini kurar ve doğrular. |
| runtime | Program çalışırken ekran, dosya, bellek, servis ve kütüphane çağrılarını yürütür. |
| backend | Hedef seçimi, kapı, rapor ve native/web ayrımını yönetir. |
| codegen | JS, WAT/WASM, x64, x86 gibi somut çıktı metnini yazar. |
| cli | Komut satırı seçeneklerini, kısa fiilleri ve çıktı sözleşmesini okur. |
| build | C/C++/ASM içe aktarma, interop manifest ve derleme planını kurar. |
| target | Hedef desteği ve kısıtlarını tutar. |
| interpreter | AST/MIR çalıştırma ve deneme yürütmesini sağlar. |
| scope | Kapsam ve görünürlük ilişkilerini taşır. |
| surface | Dil yüzeyinin kapatılmasına yardım eden sözleşmeleri taşır. |
| common | Tanı, JSON, kaynak konumu ve ortak yardımcıları tutar. |

Bir hata gördüğünde önce hata türünü düşün: `LEX` veya ön-işleyici hatası metin ve makrodadır; `PARSER` hatası sözdizimindedir; `SEMANTIC` hatası tip veya isimdedir; `MIR` hatası ara işlem eksikliğidir; `BACKEND` veya `EMIT` hatası hedef çıktısıdır; `RUNTIME` hatası çalıştırma sırasında dosya, servis veya bellek çağrısıdır. Bu ayrım aceleyle her yere yama yapmanı engeller.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<h1>uXBasic katman testi</h1>
%%HTML_END

MAIN
    DIM mesaj AS STRING
    mesaj = "Ayni kaynak hem konsola hem tarayiciya gider"
    PRINT mesaj
END MAIN
```

# 3. Dil yüzeyi: komutlar, fonksiyonlar, işleçler

Bu bölümde tablo hücreleri boş tekrar cümleleri taşımaz; her satırda sözdizimi ve ne yaptığı vardır. Uzun açıklama, tablonun altında sınıf başlığı içinde verilir. Böylece tablo hızlı bakış için, metin öğrenme için kullanılır.

| No | Anahtar/fonksiyon | Sınıf | Sözdizimi | Kısa görev |
| --- | --- | --- | --- | --- |
| 1 | CASE | Akış ve karar | CASE değer / CASE IS > değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 2 | DO | Akış ve karar | DO WHILE koşul ... LOOP / DO ... LOOP UNTIL koşul | Koşula bağlı, açık uçlu tekrarları kurar. |
| 3 | EACH | Akış ve karar | FOR EACH öğe IN koleksiyon | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 4 | ELSE | Akış ve karar | ELSE komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 5 | ELSEIF | Akış ve karar | ELSEIF koşul THEN komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 6 | END | Akış ve karar | END IF / END SUB / END FUNCTION / END CLASS | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 7 | EXIT | Akış ve karar | EXIT FOR / EXIT DO / EXIT SUB | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 8 | FOR | Akış ve karar | FOR sayaç = başlangıç TO bitiş [STEP adım] ... NEXT | Sayısı belli olan tekrarları kurar. |
| 9 | GOSUB | Akış ve karar | GOSUB Etiket ... RETURN | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 10 | GOTO | Akış ve karar | GOTO Etiket | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 11 | IF | Akış ve karar | IF koşul THEN komut [ELSE komut] / IF koşul THEN ... ELSE ... END IF | Bir koşul doğruysa bir yolu, yanlışsa başka yolu çalıştırır. |
| 12 | IN | Akış ve karar | FOR EACH öğe IN koleksiyon | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 13 | IS | Akış ve karar | CASE IS > değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 14 | LOOP | Akış ve karar | LOOP / LOOP UNTIL koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 15 | NEXT | Akış ve karar | NEXT [sayaç] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 16 | RETURN | Akış ve karar | RETURN değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 17 | SELECT | Akış ve karar | SELECT CASE ifade ... END SELECT | Tek değişkenin birçok olası değerini düzenli şekilde ayırır. |
| 18 | STEP | Akış ve karar | FOR i = 1 TO 10 STEP 2 | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 19 | THEN | Akış ve karar | IF koşul THEN komut | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 20 | TO | Akış ve karar | FOR sayaç = a TO b | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 21 | UNTIL | Akış ve karar | LOOP UNTIL koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 22 | WEND | Akış ve karar | WHILE bloğunu kapatır | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 23 | WHILE | Akış ve karar | DO WHILE koşul / WHILE koşul ... WEND | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 24 | DEC | Bellek ve düşük seviye | DEC değişken[, adım] | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 25 | INC | Bellek ve düşük seviye | INC değişken[, adım] | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 26 | MEMCOPYB | Bellek ve düşük seviye | MEMCOPYB hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 27 | MEMCOPYD | Bellek ve düşük seviye | MEMCOPYD hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 28 | MEMCOPYW | Bellek ve düşük seviye | MEMCOPYW hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 29 | MEMFILLB | Bellek ve düşük seviye | MEMFILLB hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 30 | MEMFILLD | Bellek ve düşük seviye | MEMFILLD hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 31 | MEMFILLW | Bellek ve düşük seviye | MEMFILLW hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 32 | PEEKB | Bellek ve düşük seviye | PEEKB(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 33 | PEEKD | Bellek ve düşük seviye | PEEKD(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 34 | PEEKW | Bellek ve düşük seviye | PEEKW(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 35 | POKE | Bellek ve düşük seviye | POKE adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 36 | POKEB | Bellek ve düşük seviye | POKEB adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 37 | POKED | Bellek ve düşük seviye | POKED adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 38 | POKES | Bellek ve düşük seviye | POKES adres, metin | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 39 | POKEW | Bellek ve düşük seviye | POKEW adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 40 | SETNEWOFFSET | Bellek ve düşük seviye | SETNEWOFFSET adres | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. |
| 41 | ALIAS | Değişken, sabit ve kaynak örgüsü | ALIAS kısaAd = uzunAd | Uzun çağrılara kısa ve okunur ad verir. |
| 42 | AS | Değişken, sabit ve kaynak örgüsü | ad AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 43 | CONST | Değişken, sabit ve kaynak örgüsü | CONST Ad AS Tip = değer | Değişmeyen değer tanımlar. |
| 44 | DEFBYT | Değişken, sabit ve kaynak örgüsü | DEFBYT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 45 | DEFDBL | Değişken, sabit ve kaynak örgüsü | DEFDBL A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 46 | DEFEXT | Değişken, sabit ve kaynak örgüsü | DEFEXT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 47 | DEFINT | Değişken, sabit ve kaynak örgüsü | DEFINT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 48 | DEFLNG | Değişken, sabit ve kaynak örgüsü | DEFLNG A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 49 | DEFSNG | Değişken, sabit ve kaynak örgüsü | DEFSNG A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 50 | DEFSTR | Değişken, sabit ve kaynak örgüsü | DEFSTR A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 51 | DIM | Değişken, sabit ve kaynak örgüsü | DIM ad[(sınırlar)] AS Tip | Değişken veya dizi ayırır. |
| 52 | IMPORT | Değişken, sabit ve kaynak örgüsü | IMPORT(C\|CPP\|ASM, "dosya") | C, C++ veya ASM kaynak dosyasını derleme zamanında projeye bağlar. |
| 53 | INCLUDE | Değişken, sabit ve kaynak örgüsü | INCLUDE "dosya.uxbh" | Başlık/kütüphane kaynaklarını ana dosyaya katar. |
| 54 | MAIN | Değişken, sabit ve kaynak örgüsü | MAIN ... END MAIN | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 55 | MODULE | Değişken, sabit ve kaynak örgüsü | MODULE Ad ... END MODULE | Yordamları ve sabitleri ad alanlı dosya grubu gibi toplar. |
| 56 | NAMESPACE | Değişken, sabit ve kaynak örgüsü | NAMESPACE Ad ... END NAMESPACE | İsim çakışmasını engeller, uzun adlara düzen verir. |
| 57 | REDIM | Değişken, sabit ve kaynak örgüsü | REDIM dizi(yeniSınır) | Dizinin boyutunu yeniden kurar. |
| 58 | USING | Değişken, sabit ve kaynak örgüsü | USING ModülAdı | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 59 | CLOSE | Girdi, çıktı, ekran ve dosya | CLOSE #n | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 60 | CLS | Girdi, çıktı, ekran ve dosya | CLS | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 61 | COLOR | Girdi, çıktı, ekran ve dosya | COLOR ön[,arka] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 62 | GET | Girdi, çıktı, ekran ve dosya | GET #n, konum, değişken | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 63 | INPUT | Girdi, çıktı, ekran ve dosya | INPUT değişken / INPUT #dosya, değişken | Kullanıcıdan veya dosyadan değer okur. |
| 64 | LOCATE | Girdi, çıktı, ekran ve dosya | LOCATE satır, sütun | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 65 | OPEN | Girdi, çıktı, ekran ve dosya | OPEN "yol" FOR INPUT\|OUTPUT\|APPEND AS #n | Dosya bağlantısı açar. |
| 66 | PRINT | Girdi, çıktı, ekran ve dosya | PRINT ifade [; ifade] / PRINT #dosya, ifade | Ekrana veya dosyaya yazı/değer basar. |
| 67 | PUT | Girdi, çıktı, ekran ve dosya | PUT #n, konum, değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 68 | SEEK | Girdi, çıktı, ekran ve dosya | SEEK #n, konum | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 69 | ASSERT | Hata yakalama ve güvenli çıkış | ASSERT koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 70 | CATCH | Hata yakalama ve güvenli çıkış | CATCH hata | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 71 | FINALLY | Hata yakalama ve güvenli çıkış | FINALLY komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 72 | THROW | Hata yakalama ve güvenli çıkış | THROW "hata iletisi" | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 73 | TRY | Hata yakalama ve güvenli çıkış | TRY ... CATCH hata ... FINALLY ... END TRY | Hata çıkabilecek işi güvenli bölgeye alır. |
| 74 | ABSTRACT | Nesne ve tip tasarımı | ABSTRACT CLASS Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 75 | CLASS | Nesne ve tip tasarımı | CLASS Ad ... END CLASS | Veri ve davranışı tek ad altında toplar. |
| 76 | CONSTRUCTOR | Nesne ve tip tasarımı | CONSTRUCTOR(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 77 | DECORATOR | Nesne ve tip tasarımı | DECORATOR Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 78 | DELETE | Nesne ve tip tasarımı | DELETE nesne | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 79 | DESTRUCTOR | Nesne ve tip tasarımı | DESTRUCTOR() | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 80 | FINAL | Nesne ve tip tasarımı | FINAL CLASS Ad / FINAL METHOD | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 81 | FRIEND | Nesne ve tip tasarımı | FRIEND ModülAdı | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 82 | IMMUTABLE | Nesne ve tip tasarımı | IMMUTABLE alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 83 | IMPLEMENTS | Nesne ve tip tasarımı | CLASS Ad IMPLEMENTS Arayuz | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 84 | INTERFACE | Nesne ve tip tasarımı | INTERFACE Ad ... END INTERFACE | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 85 | MAGIC | Nesne ve tip tasarımı | MAGIC <.ad.>(...) | Nesnenin özel davranışlarını tanımlar. |
| 86 | METHOD | Nesne ve tip tasarımı | METHOD Ad(...) AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 87 | MIXIN | Nesne ve tip tasarımı | MIXIN Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 88 | MUTABLE | Nesne ve tip tasarımı | MUTABLE alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 89 | NEW | Nesne ve tip tasarımı | nesne = NEW Sınıf(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 90 | OPERATOR | Nesne ve tip tasarımı | OPERATOR +(...) AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 91 | OVERRIDE | Nesne ve tip tasarımı | OVERRIDE METHOD Ad(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 92 | PRIVATE | Nesne ve tip tasarımı | PRIVATE bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 93 | PROPERTY | Nesne ve tip tasarımı | PROPERTY Ad AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 94 | PROTECTED | Nesne ve tip tasarımı | PROTECTED bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 95 | PUBLIC | Nesne ve tip tasarımı | PUBLIC bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 96 | READONLY | Nesne ve tip tasarımı | READONLY alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 97 | RESTRICTED | Nesne ve tip tasarımı | RESTRICTED bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 98 | SEALED | Nesne ve tip tasarımı | SEALED CLASS Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 99 | STATIC | Nesne ve tip tasarımı | STATIC değişken / STATIC METHOD | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 100 | TYPE | Nesne ve tip tasarımı | TYPE Ad ... alan AS Tip ... END TYPE | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 101 | VIRTUAL | Nesne ve tip tasarımı | VIRTUAL METHOD Ad(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 102 | EVENT | Olay ve eşzamanlılık | EVENT OlayAdi[(parametreler)] | Programda “bir şey oldu” bilgisini adlandırır. |
| 103 | OFF | Olay ve eşzamanlılık | OFF OlayAdi | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 104 | ON | Olay ve eşzamanlılık | ON OlayAdi / SLOT ad ON olay | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 105 | PARALEL | Olay ve eşzamanlılık | PARALEL BlokAdi ... END PARALEL | Bağımsız işleri aynı anda planlamak için kullanılır. |
| 106 | PIPE | Olay ve eşzamanlılık | PIPE HatAdi AS Tip | Verinin bir aşamadan diğer aşamaya akacağı hattı tanımlar. |
| 107 | SLOT | Olay ve eşzamanlılık | SLOT YuvaAdi ON OlayAdi ... END SLOT | Bir olaya cevap veren yordam gövdesidir. |
| 108 | THREAD | Olay ve eşzamanlılık | THREAD IsAdi ... END THREAD | Uzun işi ana akışı kilitlemeden çalıştırmak için kullanılır. |
| 109 | TRIGGER | Olay ve eşzamanlılık | TRIGGER OlayAdi[, değer] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 110 | ARRAY | Veri tipleri ve yapıları | DIM ad AS ARRAY | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 111 | BALL | Veri tipleri ve yapıları | DIM ad AS BALL | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 112 | BIGD | Veri tipleri ve yapıları | DIM ad AS BIGD | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 113 | BIGF | Veri tipleri ve yapıları | DIM ad AS BIGF | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 114 | BIGI | Veri tipleri ve yapıları | DIM ad AS BIGI | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 115 | BIGINT | Veri tipleri ve yapıları | DIM ad AS BIGINT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 116 | BOOLEAN | Veri tipleri ve yapıları | DIM ad AS BOOLEAN | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 117 | BYTE | Veri tipleri ve yapıları | BYTE ... | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 118 | DICT | Veri tipleri ve yapıları | DIM ad AS DICT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 119 | F128 | Veri tipleri ve yapıları | DIM ad AS F128 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 120 | F32 | Veri tipleri ve yapıları | DIM ad AS F32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 121 | F64 | Veri tipleri ve yapıları | DIM ad AS F64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 122 | F80 | Veri tipleri ve yapıları | DIM ad AS F80 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 123 | I16 | Veri tipleri ve yapıları | DIM ad AS I16 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 124 | I32 | Veri tipleri ve yapıları | DIM ad AS I32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 125 | I64 | Veri tipleri ve yapıları | DIM ad AS I64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 126 | I8 | Veri tipleri ve yapıları | DIM ad AS I8 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 127 | LIST | Veri tipleri ve yapıları | DIM ad AS LIST | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 128 | OBJECT | Veri tipleri ve yapıları | DIM ad AS OBJECT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 129 | PTR | Veri tipleri ve yapıları | DIM ad AS PTR | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 130 | SET | Veri tipleri ve yapıları | DIM ad AS SET | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 131 | STRPTR | Veri tipleri ve yapıları | DIM ad AS STRPTR | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 132 | U16 | Veri tipleri ve yapıları | DIM ad AS U16 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 133 | U32 | Veri tipleri ve yapıları | DIM ad AS U32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 134 | U64 | Veri tipleri ve yapıları | DIM ad AS U64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 135 | U8 | Veri tipleri ve yapıları | DIM ad AS U8 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. |
| 136 | ABS | Yerel fonksiyonlar | ABS(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 137 | ASC | Yerel fonksiyonlar | ASC(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 138 | ATN | Yerel fonksiyonlar | ATN(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 139 | CDBL | Yerel fonksiyonlar | CDBL(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 140 | CHR | Yerel fonksiyonlar | CHR(kod) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 141 | CINT | Yerel fonksiyonlar | CINT(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 142 | CLNG | Yerel fonksiyonlar | CLNG(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 143 | CODEPTR | Yerel fonksiyonlar | CODEPTR(yordam) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 144 | COS | Yerel fonksiyonlar | COS(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 145 | CSNG | Yerel fonksiyonlar | CSNG(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 146 | EOF | Yerel fonksiyonlar | EOF(#n) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 147 | EXP | Yerel fonksiyonlar | EXP(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 148 | FIX | Yerel fonksiyonlar | FIX(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 149 | GETKEY | Yerel fonksiyonlar | GETKEY() | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 150 | INKEY | Yerel fonksiyonlar | INKEY([bekleme]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 151 | INT | Yerel fonksiyonlar | INT(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 152 | LCASE | Yerel fonksiyonlar | LCASE(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 153 | LEN | Yerel fonksiyonlar | LEN(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 154 | LOF | Yerel fonksiyonlar | LOF(#n) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 155 | LOG | Yerel fonksiyonlar | LOG(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 156 | LPTR | Yerel fonksiyonlar | LPTR(etiket) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 157 | LTRIM | Yerel fonksiyonlar | LTRIM(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 158 | MID | Yerel fonksiyonlar | MID(metin, başlangıç[, uzunluk]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 159 | OFFSETOF | Yerel fonksiyonlar | OFFSETOF(Tip, alan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 160 | RANDOMIZE | Yerel fonksiyonlar | RANDOMIZE [tohum] | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 161 | RND | Yerel fonksiyonlar | RND([tohum]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 162 | RTRIM | Yerel fonksiyonlar | RTRIM(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 163 | SADD | Yerel fonksiyonlar | SADD(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 164 | SETSTRINGSIZE | Yerel fonksiyonlar | SETSTRINGSIZE uzunluk | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 165 | SGN | Yerel fonksiyonlar | SGN(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 166 | SIN | Yerel fonksiyonlar | SIN(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 167 | SIZEOF | Yerel fonksiyonlar | SIZEOF(Tip veya değişken) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 168 | SPACE | Yerel fonksiyonlar | SPACE(adet) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 169 | SQR | Yerel fonksiyonlar | SQR(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 170 | SQRT | Yerel fonksiyonlar | SQRT(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 171 | STR | Yerel fonksiyonlar | STR(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 172 | STRING | Yerel fonksiyonlar | STRING(adet, karakter) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 173 | TAN | Yerel fonksiyonlar | TAN(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 174 | TIMER | Yerel fonksiyonlar | TIMER() | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 175 | UCASE | Yerel fonksiyonlar | UCASE(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 176 | VAL | Yerel fonksiyonlar | VAL(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 177 | VARPTR | Yerel fonksiyonlar | VARPTR(değişken) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. |
| 178 | BYREF | Yordam, çağrı ve dış bağlantı | parametre AS Tip BYREF | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 179 | BYVAL | Yordam, çağrı ve dış bağlantı | parametre AS Tip BYVAL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 180 | CALL | Yordam, çağrı ve dış bağlantı | CALL Ad(...) / CALL(DLL,...)/CALL(API,...) | Yordamı, DLL’i, API’yi veya servis çağrısını tetikler. |
| 181 | CDECL | Yordam, çağrı ve dış bağlantı | DECLARE ... CDECL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 182 | DECLARE | Yordam, çağrı ve dış bağlantı | DECLARE FUNCTION/SUB Ad(...) AS Tip LIB "dll" ALIAS "ad" | Dış DLL/API veya önceden tanımlı yordam imzasını bildirir. |
| 183 | FUNCTION | Yordam, çağrı ve dış bağlantı | FUNCTION Ad([parametre]) AS Tip ... END FUNCTION | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 184 | INLINE | Yordam, çağrı ve dış bağlantı | INLINE(C\|CPP\|ASM) ... END INLINE | Kısa C, C++ veya ASM parçasını kaynak içinde tutar. |
| 185 | STDCALL | Yordam, çağrı ve dış bağlantı | DECLARE ... STDCALL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 186 | SUB | Yordam, çağrı ve dış bağlantı | SUB Ad([parametre]) ... END SUB | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 187 | ENUM | Diğer | ENUM ... | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. |
| 188 | AND | İşleçler ve bit işlemleri | a AND b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 189 | MOD | İşleçler ve bit işlemleri | a MOD b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 190 | NOT | İşleçler ve bit işlemleri | NOT koşul | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 191 | OR | İşleçler ve bit işlemleri | a OR b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 192 | ROL | İşleçler ve bit işlemleri | a ROL bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 193 | ROR | İşleçler ve bit işlemleri | a ROR bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 194 | SHL | İşleçler ve bit işlemleri | a SHL bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 195 | SHR | İşleçler ve bit işlemleri | a SHR bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |
| 196 | XOR | İşleçler ve bit işlemleri | a XOR b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. |

## Akış ve karar

Akış komutları programın yol haritasıdır. Bir insanın “hava yağarsa şemsiye al, yağmazsa yürü” demesi gibi, program da koşula göre başka komut dizisine geçer. Döngüler aynı işi defalarca yapar; dosya satırlarını okumak, sensör ölçülerini toplamak, oyuncu hareketlerini güncellemek ve testleri sırayla yürütmek için kullanılır.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| IF | IF koşul THEN komut [ELSE komut] / IF koşul THEN ... ELSE ... END IF | Bir koşul doğruysa bir yolu, yanlışsa başka yolu çalıştırır. | `IF koşul THEN komut [ELSE komut]` |
| THEN | IF koşul THEN komut | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `IF koşul THEN komut` |
| ELSE | ELSE komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ELSE komutlar` |
| ELSEIF | ELSEIF koşul THEN komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ELSEIF koşul THEN komutlar` |
| END | END IF / END SUB / END FUNCTION / END CLASS | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `END IF` |
| SELECT | SELECT CASE ifade ... END SELECT | Tek değişkenin birçok olası değerini düzenli şekilde ayırır. | `SELECT CASE ifade ... END SELECT` |
| CASE | CASE değer / CASE IS > değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CASE değer` |
| IS | CASE IS > değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CASE IS > değer` |
| FOR | FOR sayaç = başlangıç TO bitiş [STEP adım] ... NEXT | Sayısı belli olan tekrarları kurar. | `FOR sayaç = başlangıç TO bitiş [STEP adım] ... NEXT` |
| TO | FOR sayaç = a TO b | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FOR sayaç = a TO b` |
| STEP | FOR i = 1 TO 10 STEP 2 | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FOR i = 1 TO 10 STEP 2` |
| NEXT | NEXT [sayaç] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `NEXT [sayaç]` |
| DO | DO WHILE koşul ... LOOP / DO ... LOOP UNTIL koşul | Koşula bağlı, açık uçlu tekrarları kurar. | `DO WHILE koşul ... LOOP` |
| LOOP | LOOP / LOOP UNTIL koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `LOOP` |
| WHILE | DO WHILE koşul / WHILE koşul ... WEND | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DO WHILE koşul` |
| WEND | WHILE bloğunu kapatır | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `WHILE bloğunu kapatır` |
| UNTIL | LOOP UNTIL koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `LOOP UNTIL koşul` |
| EXIT | EXIT FOR / EXIT DO / EXIT SUB | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `EXIT FOR` |
| EACH | FOR EACH öğe IN koleksiyon | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FOR EACH öğe IN koleksiyon` |
| IN | FOR EACH öğe IN koleksiyon | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FOR EACH öğe IN koleksiyon` |
| RETURN | RETURN değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `RETURN değer` |
| GOTO | GOTO Etiket | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `GOTO Etiket` |
| GOSUB | GOSUB Etiket ... RETURN | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `GOSUB Etiket ... RETURN` |

### Tekil kullanım notları

- **IF:** Bir koşul doğruysa bir yolu, yanlışsa başka yolu çalıştırır. Sözdizimi: `IF koşul THEN komut [ELSE komut] / IF koşul THEN ... ELSE ... END IF`. Küçük kullanım: `IF ph < 6.5 THEN PRINT "asit" ELSE PRINT "normal" END IF`

- **THEN:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `IF koşul THEN komut`. Küçük kullanım: `IF koşul THEN komut`

- **ELSE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ELSE komutlar`. Küçük kullanım: `ELSE komutlar`

- **ELSEIF:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ELSEIF koşul THEN komutlar`. Küçük kullanım: `ELSEIF koşul THEN komutlar`

- **END:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `END IF / END SUB / END FUNCTION / END CLASS`. Küçük kullanım: `END IF / END SUB / END FUNCTION / END CLASS`

- **SELECT:** Tek değişkenin birçok olası değerini düzenli şekilde ayırır. Sözdizimi: `SELECT CASE ifade ... END SELECT`. Küçük kullanım: `SELECT CASE ifade ... END SELECT`

- **CASE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CASE değer / CASE IS > değer`. Küçük kullanım: `CASE değer / CASE IS > değer`

- **IS:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CASE IS > değer`. Küçük kullanım: `CASE IS > değer`

- **FOR:** Sayısı belli olan tekrarları kurar. Sözdizimi: `FOR sayaç = başlangıç TO bitiş [STEP adım] ... NEXT`. Küçük kullanım: `FOR i = 1 TO 10 STEP 1: PRINT i: NEXT i`

- **TO:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FOR sayaç = a TO b`. Küçük kullanım: `FOR sayaç = a TO b`

- **STEP:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FOR i = 1 TO 10 STEP 2`. Küçük kullanım: `FOR i = 1 TO 10 STEP 2`

- **NEXT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `NEXT [sayaç]`. Küçük kullanım: `NEXT [sayaç]`

- **DO:** Koşula bağlı, açık uçlu tekrarları kurar. Sözdizimi: `DO WHILE koşul ... LOOP / DO ... LOOP UNTIL koşul`. Küçük kullanım: `DO WHILE koşul ... LOOP / DO ... LOOP UNTIL koşul`

- **LOOP:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `LOOP / LOOP UNTIL koşul`. Küçük kullanım: `LOOP / LOOP UNTIL koşul`

- **WHILE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DO WHILE koşul / WHILE koşul ... WEND`. Küçük kullanım: `DO WHILE koşul / WHILE koşul ... WEND`

- **WEND:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `WHILE bloğunu kapatır`. Küçük kullanım: `WHILE bloğunu kapatır`

- **UNTIL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `LOOP UNTIL koşul`. Küçük kullanım: `LOOP UNTIL koşul`

- **EXIT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `EXIT FOR / EXIT DO / EXIT SUB`. Küçük kullanım: `EXIT FOR / EXIT DO / EXIT SUB`

- **EACH:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FOR EACH öğe IN koleksiyon`. Küçük kullanım: `FOR EACH öğe IN koleksiyon`

- **IN:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FOR EACH öğe IN koleksiyon`. Küçük kullanım: `FOR EACH öğe IN koleksiyon`

- **RETURN:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `RETURN değer`. Küçük kullanım: `RETURN değer`

- **GOTO:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `GOTO Etiket`. Küçük kullanım: `GOTO Etiket`

- **GOSUB:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `GOSUB Etiket ... RETURN`. Küçük kullanım: `GOSUB Etiket ... RETURN`

### Birlikte kullanım örneği

```uxbasic
DIM toplam AS F64
DIM adet AS I32
DIM i AS I32
FOR i = 1 TO 5 STEP 1
    INPUT olcum
    IF olcum < 0 THEN EXIT FOR ELSE toplam = toplam + olcum
    adet = adet + 1
NEXT i
IF adet > 0 THEN PRINT "ortalama="; toplam / adet ELSE PRINT "veri yok" END IF
```

## Hata yakalama ve güvenli çıkış

Hata yakalama, programın çökmeden düzgün tepki vermesidir. Dosya bulunmayabilir, ağ kesilebilir, dış DLL yanıt vermeyebilir, veri negatif gelebilir. `TRY`, riskli işi bir kutuya alır; `CATCH` sorunu yakalar; `FINALLY` temizlik işini yapar; `THROW` bilerek hata fırlatır; `ASSERT` geliştirme sırasında beklenen koşulu denetler.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| TRY | TRY ... CATCH hata ... FINALLY ... END TRY | Hata çıkabilecek işi güvenli bölgeye alır. | `TRY ... CATCH hata ... FINALLY ... END TRY` |
| CATCH | CATCH hata | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CATCH hata` |
| FINALLY | FINALLY komutlar | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FINALLY komutlar` |
| THROW | THROW "hata iletisi" | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `THROW "hata iletisi"` |
| ASSERT | ASSERT koşul | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ASSERT koşul` |

### Tekil kullanım notları

- **TRY:** Hata çıkabilecek işi güvenli bölgeye alır. Sözdizimi: `TRY ... CATCH hata ... FINALLY ... END TRY`. Küçük kullanım: `TRY: OPEN "veri.csv" FOR INPUT AS #1: CATCH e: PRINT "acilamadi": END TRY`

- **CATCH:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CATCH hata`. Küçük kullanım: `CATCH hata`

- **FINALLY:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FINALLY komutlar`. Küçük kullanım: `FINALLY komutlar`

- **THROW:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `THROW "hata iletisi"`. Küçük kullanım: `THROW "hata iletisi"`

- **ASSERT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ASSERT koşul`. Küçük kullanım: `ASSERT koşul`

### Birlikte kullanım örneği

```uxbasic
TRY
    OPEN "veri.csv" FOR INPUT AS #1
    INPUT #1, satir
    ASSERT LEN(satir) > 0
CATCH hata
    PRINT "Dosya veya veri hatasi: "; hata
FINALLY
    CLOSE #1
END TRY
```

## Olay ve eşzamanlılık

Olay ve eşzamanlılık komutları, programı tek çizgili defter olmaktan çıkarıp yaşayan sisteme dönüştürür. Tuşa basılması, dosyanın gelmesi, sensörden veri alınması, zamanlayıcının dolması bir olaydır. Boru veriyi taşır, yuva olaya cevap verir, iş parçacığı uzun işi arkada yapar, koşut blok bağımsız işleri birlikte planlar.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| EVENT | EVENT OlayAdi[(parametreler)] | Programda “bir şey oldu” bilgisini adlandırır. | `EVENT OlayAdi[(parametreler)]` |
| THREAD | THREAD IsAdi ... END THREAD | Uzun işi ana akışı kilitlemeden çalıştırmak için kullanılır. | `THREAD IsAdi ... END THREAD` |
| PARALEL | PARALEL BlokAdi ... END PARALEL | Bağımsız işleri aynı anda planlamak için kullanılır. | `PARALEL BlokAdi ... END PARALEL` |
| PIPE | PIPE HatAdi AS Tip | Verinin bir aşamadan diğer aşamaya akacağı hattı tanımlar. | `PIPE HatAdi AS Tip` |
| SLOT | SLOT YuvaAdi ON OlayAdi ... END SLOT | Bir olaya cevap veren yordam gövdesidir. | `SLOT YuvaAdi ON OlayAdi ... END SLOT` |
| ON | ON OlayAdi / SLOT ad ON olay | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ON OlayAdi` |
| OFF | OFF OlayAdi | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `OFF OlayAdi` |
| TRIGGER | TRIGGER OlayAdi[, değer] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `TRIGGER OlayAdi[, değer]` |

### Tekil kullanım notları

- **EVENT:** Programda “bir şey oldu” bilgisini adlandırır. Sözdizimi: `EVENT OlayAdi[(parametreler)]`. Küçük kullanım: `EVENT VeriGeldi: TRIGGER VeriGeldi, 42`

- **THREAD:** Uzun işi ana akışı kilitlemeden çalıştırmak için kullanılır. Sözdizimi: `THREAD IsAdi ... END THREAD`. Küçük kullanım: `THREAD ArkaPlan: PRINT "uzun is": END THREAD`

- **PARALEL:** Bağımsız işleri aynı anda planlamak için kullanılır. Sözdizimi: `PARALEL BlokAdi ... END PARALEL`. Küçük kullanım: `PARALEL Isler: CALL Oku(): CALL Hesapla(): END PARALEL`

- **PIPE:** Verinin bir aşamadan diğer aşamaya akacağı hattı tanımlar. Sözdizimi: `PIPE HatAdi AS Tip`. Küçük kullanım: `PIPE HatAdi AS Tip`

- **SLOT:** Bir olaya cevap veren yordam gövdesidir. Sözdizimi: `SLOT YuvaAdi ON OlayAdi ... END SLOT`. Küçük kullanım: `SLOT Kaydet ON VeriGeldi: PRINT "kaydedildi": END SLOT`

- **ON:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ON OlayAdi / SLOT ad ON olay`. Küçük kullanım: `ON OlayAdi / SLOT ad ON olay`

- **OFF:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `OFF OlayAdi`. Küçük kullanım: `OFF OlayAdi`

- **TRIGGER:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `TRIGGER OlayAdi[, değer]`. Küçük kullanım: `TRIGGER OlayAdi[, değer]`

### Birlikte kullanım örneği

```uxbasic
EVENT VeriGeldi(deger AS F64)
PIPE OlcumHatti AS F64
SLOT Kaydet ON VeriGeldi
    OPEN "olcum.log" FOR APPEND AS #1
    PRINT #1, STR(TIMER()) + ";" + STR(deger)
    CLOSE #1
END SLOT
THREAD SensorOku
    TRIGGER VeriGeldi, 7.42
END THREAD
PARALEL Saha
    CALL SensorOku()
    CALL Raporla()
END PARALEL
```

## Yordam, çağrı ve dış bağlantı

Yordamlar tekrar eden işleri adlandırır. Bir kez yazdığın hesaplama, farklı yerlerde çağrılır. Dış bağlantı komutları uXBasic’i tek başına kapalı bir dil olmaktan çıkarıp Windows DLL, C/C++/ASM, REST köprüsü ve yerel yapay zeka gibi kaynaklarla konuşturur.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| SUB | SUB Ad([parametre]) ... END SUB | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `SUB Ad([parametre]) ... END SUB` |
| FUNCTION | FUNCTION Ad([parametre]) AS Tip ... END FUNCTION | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FUNCTION Ad([parametre]) AS Tip ... END FUNCTION` |
| DECLARE | DECLARE FUNCTION/SUB Ad(...) AS Tip LIB "dll" ALIAS "ad" | Dış DLL/API veya önceden tanımlı yordam imzasını bildirir. | `DECLARE FUNCTION/SUB Ad(...) AS Tip LIB "dll" ALIAS "ad"` |
| CALL | CALL Ad(...) / CALL(DLL,...)/CALL(API,...) | Yordamı, DLL’i, API’yi veya servis çağrısını tetikler. | `CALL Ad(...)` |
| BYREF | parametre AS Tip BYREF | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `parametre AS Tip BYREF` |
| BYVAL | parametre AS Tip BYVAL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `parametre AS Tip BYVAL` |
| CDECL | DECLARE ... CDECL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DECLARE ... CDECL` |
| STDCALL | DECLARE ... STDCALL | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DECLARE ... STDCALL` |
| INLINE | INLINE(C\|CPP\|ASM) ... END INLINE | Kısa C, C++ veya ASM parçasını kaynak içinde tutar. | `INLINE(C\|CPP\|ASM) ... END INLINE` |

### Tekil kullanım notları

- **SUB:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `SUB Ad([parametre]) ... END SUB`. Küçük kullanım: `SUB Baslik(): PRINT "RAPOR": END SUB`

- **FUNCTION:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FUNCTION Ad([parametre]) AS Tip ... END FUNCTION`. Küçük kullanım: `FUNCTION Kare(x AS F64) AS F64: RETURN x*x: END FUNCTION`

- **DECLARE:** Dış DLL/API veya önceden tanımlı yordam imzasını bildirir. Sözdizimi: `DECLARE FUNCTION/SUB Ad(...) AS Tip LIB "dll" ALIAS "ad"`. Küçük kullanım: `DECLARE FUNCTION GetTickCount() AS U32 LIB "kernel32.dll" ALIAS "GetTickCount"`

- **CALL:** Yordamı, DLL’i, API’yi veya servis çağrısını tetikler. Sözdizimi: `CALL Ad(...) / CALL(DLL,...)/CALL(API,...)`. Küçük kullanım: `CALL Ad(...) / CALL(DLL,...)/CALL(API,...)`

- **BYREF:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `parametre AS Tip BYREF`. Küçük kullanım: `parametre AS Tip BYREF`

- **BYVAL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `parametre AS Tip BYVAL`. Küçük kullanım: `parametre AS Tip BYVAL`

- **CDECL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DECLARE ... CDECL`. Küçük kullanım: `DECLARE ... CDECL`

- **STDCALL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DECLARE ... STDCALL`. Küçük kullanım: `DECLARE ... STDCALL`

- **INLINE:** Kısa C, C++ veya ASM parçasını kaynak içinde tutar. Sözdizimi: `INLINE(C|CPP|ASM) ... END INLINE`. Küçük kullanım: `INLINE(C|CPP|ASM) ... END INLINE`

### Birlikte kullanım örneği

```uxbasic
IMPORT(C, "native/hizli_topla.c")
DECLARE FUNCTION HizliTopla(a AS I32, b AS I32) AS I32
FUNCTION GuvenliToplam(a AS I32, b AS I32) AS I32
    RETURN HizliTopla(a, b)
END FUNCTION
CALL(DLL, "USER32.DLL", "MessageBoxA", I32, STDCALL, 0, "Bitti", "uXBasic", 0)
PRINT GuvenliToplam(3, 4)
```

## Nesne ve tip tasarımı

Nesne ve tip komutları büyük programın iskeletidir. Ölçüm kaydı, oyuncu, pencere, derleyici düğümü veya yapay zeka modeli gibi şeyler sadece değer değil, davranış da taşır. Sınıf, arayüz, özellik, yöntem, kurucu, yıkıcı ve sihirli yöntemlerle bunu düzenlersin.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| TYPE | TYPE Ad ... alan AS Tip ... END TYPE | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `TYPE Ad ... alan AS Tip ... END TYPE` |
| CLASS | CLASS Ad ... END CLASS | Veri ve davranışı tek ad altında toplar. | `CLASS Ad ... END CLASS` |
| INTERFACE | INTERFACE Ad ... END INTERFACE | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `INTERFACE Ad ... END INTERFACE` |
| IMPLEMENTS | CLASS Ad IMPLEMENTS Arayuz | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CLASS Ad IMPLEMENTS Arayuz` |
| METHOD | METHOD Ad(...) AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `METHOD Ad(...) AS Tip` |
| MAGIC | MAGIC <.ad.>(...) | Nesnenin özel davranışlarını tanımlar. | `MAGIC <.ad.>(...)` |
| VIRTUAL | VIRTUAL METHOD Ad(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `VIRTUAL METHOD Ad(...)` |
| OVERRIDE | OVERRIDE METHOD Ad(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `OVERRIDE METHOD Ad(...)` |
| CONSTRUCTOR | CONSTRUCTOR(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CONSTRUCTOR(...)` |
| DESTRUCTOR | DESTRUCTOR() | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DESTRUCTOR()` |
| NEW | nesne = NEW Sınıf(...) | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `nesne = NEW Sınıf(...)` |
| DELETE | DELETE nesne | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DELETE nesne` |
| ABSTRACT | ABSTRACT CLASS Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ABSTRACT CLASS Ad` |
| FINAL | FINAL CLASS Ad / FINAL METHOD | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FINAL CLASS Ad` |
| SEALED | SEALED CLASS Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `SEALED CLASS Ad` |
| STATIC | STATIC değişken / STATIC METHOD | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `STATIC değişken` |
| PROPERTY | PROPERTY Ad AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `PROPERTY Ad AS Tip` |
| OPERATOR | OPERATOR +(...) AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `OPERATOR +(...) AS Tip` |
| MIXIN | MIXIN Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `MIXIN Ad` |
| DECORATOR | DECORATOR Ad | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DECORATOR Ad` |
| PUBLIC | PUBLIC bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `PUBLIC bölüm` |
| PRIVATE | PRIVATE bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `PRIVATE bölüm` |
| PROTECTED | PROTECTED bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `PROTECTED bölüm` |
| RESTRICTED | RESTRICTED bölüm | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `RESTRICTED bölüm` |
| FRIEND | FRIEND ModülAdı | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `FRIEND ModülAdı` |
| READONLY | READONLY alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `READONLY alan AS Tip` |
| MUTABLE | MUTABLE alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `MUTABLE alan AS Tip` |
| IMMUTABLE | IMMUTABLE alan AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `IMMUTABLE alan AS Tip` |

### Tekil kullanım notları

- **TYPE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `TYPE Ad ... alan AS Tip ... END TYPE`. Küçük kullanım: `TYPE Ad ... alan AS Tip ... END TYPE`

- **CLASS:** Veri ve davranışı tek ad altında toplar. Sözdizimi: `CLASS Ad ... END CLASS`. Küçük kullanım: `CLASS Sayac: PUBLIC METHOD Artir(): END METHOD: END CLASS`

- **INTERFACE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `INTERFACE Ad ... END INTERFACE`. Küçük kullanım: `INTERFACE Ad ... END INTERFACE`

- **IMPLEMENTS:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CLASS Ad IMPLEMENTS Arayuz`. Küçük kullanım: `CLASS Ad IMPLEMENTS Arayuz`

- **METHOD:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `METHOD Ad(...) AS Tip`. Küçük kullanım: `METHOD Ad(...) AS Tip`

- **MAGIC:** Nesnenin özel davranışlarını tanımlar. Sözdizimi: `MAGIC <.ad.>(...)`. Küçük kullanım: `MAGIC <.ad.>(...)`

- **VIRTUAL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `VIRTUAL METHOD Ad(...)`. Küçük kullanım: `VIRTUAL METHOD Ad(...)`

- **OVERRIDE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `OVERRIDE METHOD Ad(...)`. Küçük kullanım: `OVERRIDE METHOD Ad(...)`

- **CONSTRUCTOR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CONSTRUCTOR(...)`. Küçük kullanım: `CONSTRUCTOR(...)`

- **DESTRUCTOR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DESTRUCTOR()`. Küçük kullanım: `DESTRUCTOR()`

- **NEW:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `nesne = NEW Sınıf(...)`. Küçük kullanım: `nesne = NEW Sınıf(...)`

- **DELETE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DELETE nesne`. Küçük kullanım: `DELETE nesne`

- **ABSTRACT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ABSTRACT CLASS Ad`. Küçük kullanım: `ABSTRACT CLASS Ad`

- **FINAL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FINAL CLASS Ad / FINAL METHOD`. Küçük kullanım: `FINAL CLASS Ad / FINAL METHOD`

- **SEALED:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `SEALED CLASS Ad`. Küçük kullanım: `SEALED CLASS Ad`

- **STATIC:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `STATIC değişken / STATIC METHOD`. Küçük kullanım: `STATIC değişken / STATIC METHOD`

- **PROPERTY:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `PROPERTY Ad AS Tip`. Küçük kullanım: `PROPERTY Ad AS Tip`

- **OPERATOR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `OPERATOR +(...) AS Tip`. Küçük kullanım: `OPERATOR +(...) AS Tip`

- **MIXIN:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `MIXIN Ad`. Küçük kullanım: `MIXIN Ad`

- **DECORATOR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DECORATOR Ad`. Küçük kullanım: `DECORATOR Ad`

- **PUBLIC:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `PUBLIC bölüm`. Küçük kullanım: `PUBLIC bölüm`

- **PRIVATE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `PRIVATE bölüm`. Küçük kullanım: `PRIVATE bölüm`

- **PROTECTED:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `PROTECTED bölüm`. Küçük kullanım: `PROTECTED bölüm`

- **RESTRICTED:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `RESTRICTED bölüm`. Küçük kullanım: `RESTRICTED bölüm`

- **FRIEND:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `FRIEND ModülAdı`. Küçük kullanım: `FRIEND ModülAdı`

- **READONLY:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `READONLY alan AS Tip`. Küçük kullanım: `READONLY alan AS Tip`

- **MUTABLE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `MUTABLE alan AS Tip`. Küçük kullanım: `MUTABLE alan AS Tip`

- **IMMUTABLE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `IMMUTABLE alan AS Tip`. Küçük kullanım: `IMMUTABLE alan AS Tip`

### Birlikte kullanım örneği

```uxbasic
TYPE Olcum
    zaman AS F64
    ph AS F64
END TYPE
CLASS Rapor
PRIVATE
    adet AS I32
PUBLIC
    CONSTRUCTOR(): adet = 0: END CONSTRUCTOR
    METHOD Ekle(o AS Olcum)
        adet = adet + 1
        PRINT "olcum="; o.ph
    END METHOD
END CLASS
```

## Değişken, sabit ve kaynak örgüsü

Değişkenler programın hafızasıdır. Sabitler değişmemesi gereken değerleri korur. Kaynak örgüsü ise dosyaları, modülleri, ad alanlarını ve kısa adları düzenler. Büyük projede tek dosya kahramanlık değildir; asıl güç iyi bölünmüş dosyadadır.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| DIM | DIM ad[(sınırlar)] AS Tip | Değişken veya dizi ayırır. | `DIM ad[(sınırlar)] AS Tip` |
| REDIM | REDIM dizi(yeniSınır) | Dizinin boyutunu yeniden kurar. | `REDIM dizi(yeniSınır)` |
| AS | ad AS Tip | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `ad AS Tip` |
| CONST | CONST Ad AS Tip = değer | Değişmeyen değer tanımlar. | `CONST Ad AS Tip = değer` |
| INCLUDE | INCLUDE "dosya.uxbh" | Başlık/kütüphane kaynaklarını ana dosyaya katar. | `INCLUDE "dosya.uxbh"` |
| IMPORT | IMPORT(C\|CPP\|ASM, "dosya") | C, C++ veya ASM kaynak dosyasını derleme zamanında projeye bağlar. | `IMPORT(C\|CPP\|ASM, "dosya")` |
| MAIN | MAIN ... END MAIN | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `MAIN ... END MAIN` |
| NAMESPACE | NAMESPACE Ad ... END NAMESPACE | İsim çakışmasını engeller, uzun adlara düzen verir. | `NAMESPACE Ad ... END NAMESPACE` |
| MODULE | MODULE Ad ... END MODULE | Yordamları ve sabitleri ad alanlı dosya grubu gibi toplar. | `MODULE Ad ... END MODULE` |
| USING | USING ModülAdı | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `USING ModülAdı` |
| ALIAS | ALIAS kısaAd = uzunAd | Uzun çağrılara kısa ve okunur ad verir. | `ALIAS kısaAd = uzunAd` |
| DEFINT | DEFINT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFINT A-Z` |
| DEFLNG | DEFLNG A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFLNG A-Z` |
| DEFSNG | DEFSNG A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFSNG A-Z` |
| DEFDBL | DEFDBL A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFDBL A-Z` |
| DEFEXT | DEFEXT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFEXT A-Z` |
| DEFSTR | DEFSTR A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFSTR A-Z` |
| DEFBYT | DEFBYT A-Z | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `DEFBYT A-Z` |

### Tekil kullanım notları

- **DIM:** Değişken veya dizi ayırır. Sözdizimi: `DIM ad[(sınırlar)] AS Tip`. Küçük kullanım: `DIM sicaklik AS F64`

- **REDIM:** Dizinin boyutunu yeniden kurar. Sözdizimi: `REDIM dizi(yeniSınır)`. Küçük kullanım: `REDIM dizi(yeniSınır)`

- **AS:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `ad AS Tip`. Küçük kullanım: `ad AS Tip`

- **CONST:** Değişmeyen değer tanımlar. Sözdizimi: `CONST Ad AS Tip = değer`. Küçük kullanım: `CONST Ad AS Tip = değer`

- **INCLUDE:** Başlık/kütüphane kaynaklarını ana dosyaya katar. Sözdizimi: `INCLUDE "dosya.uxbh"`. Küçük kullanım: `INCLUDE "dosya.uxbh"`

- **IMPORT:** C, C++ veya ASM kaynak dosyasını derleme zamanında projeye bağlar. Sözdizimi: `IMPORT(C|CPP|ASM, "dosya")`. Küçük kullanım: `IMPORT(C|CPP|ASM, "dosya")`

- **MAIN:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `MAIN ... END MAIN`. Küçük kullanım: `MAIN ... END MAIN`

- **NAMESPACE:** İsim çakışmasını engeller, uzun adlara düzen verir. Sözdizimi: `NAMESPACE Ad ... END NAMESPACE`. Küçük kullanım: `NAMESPACE Ad ... END NAMESPACE`

- **MODULE:** Yordamları ve sabitleri ad alanlı dosya grubu gibi toplar. Sözdizimi: `MODULE Ad ... END MODULE`. Küçük kullanım: `MODULE Ad ... END MODULE`

- **USING:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `USING ModülAdı`. Küçük kullanım: `USING ModülAdı`

- **ALIAS:** Uzun çağrılara kısa ve okunur ad verir. Sözdizimi: `ALIAS kısaAd = uzunAd`. Küçük kullanım: `ALIAS kısaAd = uzunAd`

- **DEFINT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFINT A-Z`. Küçük kullanım: `DEFINT A-Z`

- **DEFLNG:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFLNG A-Z`. Küçük kullanım: `DEFLNG A-Z`

- **DEFSNG:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFSNG A-Z`. Küçük kullanım: `DEFSNG A-Z`

- **DEFDBL:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFDBL A-Z`. Küçük kullanım: `DEFDBL A-Z`

- **DEFEXT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFEXT A-Z`. Küçük kullanım: `DEFEXT A-Z`

- **DEFSTR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFSTR A-Z`. Küçük kullanım: `DEFSTR A-Z`

- **DEFBYT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `DEFBYT A-Z`. Küçük kullanım: `DEFBYT A-Z`

### Birlikte kullanım örneği

```uxbasic
INCLUDE "istatistik.uxbh"
IMPORT(CPP, "native/matris.cpp")
NAMESPACE Saha
    CONST LIMIT AS I32 = 100
    DIM toplam AS F64
END NAMESPACE
USING Saha
ALIAS L = Saha.LIMIT
PRINT L
```

## Girdi, çıktı, ekran ve dosya

Girdi-çıktı komutları programı dış dünya ile konuşturur. Kullanıcıdan değer alır, ekrana yazar, dosya açar, rapor üretir, kayıt okur, konum değiştirir ve ekranı düzenler.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| PRINT | PRINT ifade [; ifade] / PRINT #dosya, ifade | Ekrana veya dosyaya yazı/değer basar. | `PRINT ifade [; ifade]` |
| INPUT | INPUT değişken / INPUT #dosya, değişken | Kullanıcıdan veya dosyadan değer okur. | `INPUT değişken` |
| OPEN | OPEN "yol" FOR INPUT\|OUTPUT\|APPEND AS #n | Dosya bağlantısı açar. | `OPEN "yol" FOR INPUT\|OUTPUT\|APPEND AS #n` |
| CLOSE | CLOSE #n | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CLOSE #n` |
| GET | GET #n, konum, değişken | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `GET #n, konum, değişken` |
| PUT | PUT #n, konum, değer | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `PUT #n, konum, değer` |
| SEEK | SEEK #n, konum | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `SEEK #n, konum` |
| CLS | CLS | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `CLS` |
| COLOR | COLOR ön[,arka] | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `COLOR ön[,arka]` |
| LOCATE | LOCATE satır, sütun | Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. | `LOCATE satır, sütun` |

### Tekil kullanım notları

- **PRINT:** Ekrana veya dosyaya yazı/değer basar. Sözdizimi: `PRINT ifade [; ifade] / PRINT #dosya, ifade`. Küçük kullanım: `PRINT "sonuc="; toplam`

- **INPUT:** Kullanıcıdan veya dosyadan değer okur. Sözdizimi: `INPUT değişken / INPUT #dosya, değişken`. Küçük kullanım: `INPUT değişken / INPUT #dosya, değişken`

- **OPEN:** Dosya bağlantısı açar. Sözdizimi: `OPEN "yol" FOR INPUT|OUTPUT|APPEND AS #n`. Küçük kullanım: `OPEN "rapor.txt" FOR OUTPUT AS #1`

- **CLOSE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CLOSE #n`. Küçük kullanım: `CLOSE #n`

- **GET:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `GET #n, konum, değişken`. Küçük kullanım: `GET #n, konum, değişken`

- **PUT:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `PUT #n, konum, değer`. Küçük kullanım: `PUT #n, konum, değer`

- **SEEK:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `SEEK #n, konum`. Küçük kullanım: `SEEK #n, konum`

- **CLS:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `CLS`. Küçük kullanım: `CLS`

- **COLOR:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `COLOR ön[,arka]`. Küçük kullanım: `COLOR ön[,arka]`

- **LOCATE:** Programın bu sınıftaki görevini açıkça kurar ve okunur hâle getirir. Sözdizimi: `LOCATE satır, sütun`. Küçük kullanım: `LOCATE satır, sütun`

### Birlikte kullanım örneği

```uxbasic
CLS
COLOR 10, 0
LOCATE 2, 4
PRINT "Rapor basliyor"
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "baslik;deger"
PUT #1, 1, "ph;7.2"
CLOSE #1
```

## İşleçler ve bit işlemleri

İşleçler küçük görünen ama programın matematik ve mantık kasıdır. Karşılaştırma, kalan, bit kaydırma ve mantıksal birleştirme özellikle derleyici, grafik, ağ paketi ve bayrak alanlarında çok işe yarar.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| AND | a AND b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a AND b` |
| OR | a OR b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a OR b` |
| NOT | NOT koşul | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `NOT koşul` |
| XOR | a XOR b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a XOR b` |
| MOD | a MOD b | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a MOD b` |
| SHL | a SHL bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a SHL bit` |
| SHR | a SHR bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a SHR bit` |
| ROL | a ROL bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a ROL bit` |
| ROR | a ROR bit | İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. | `a ROR bit` |

### Tekil kullanım notları

- **AND:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a AND b`. Küçük kullanım: `a AND b`

- **OR:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a OR b`. Küçük kullanım: `a OR b`

- **NOT:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `NOT koşul`. Küçük kullanım: `NOT koşul`

- **XOR:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a XOR b`. Küçük kullanım: `a XOR b`

- **MOD:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a MOD b`. Küçük kullanım: `a MOD b`

- **SHL:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a SHL bit`. Küçük kullanım: `a SHL bit`

- **SHR:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a SHR bit`. Küçük kullanım: `a SHR bit`

- **ROL:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a ROL bit`. Küçük kullanım: `a ROL bit`

- **ROR:** İki değer arasında mantık, aritmetik kalanı veya bit düzeyi işlem yapar. Sözdizimi: `a ROR bit`. Küçük kullanım: `a ROR bit`

### Birlikte kullanım örneği

```uxbasic
DIM bayrak AS U8
bayrak = 0
bayrak = bayrak OR 1
bayrak = bayrak OR 4
IF (bayrak AND 4) <> 0 THEN PRINT "ucuncu bit acik"
PRINT "kalan="; 17 MOD 5
PRINT "kaydir="; 1 SHL 3
```

## Yerel fonksiyonlar

Yerel fonksiyonlar günlük işlerin hazır alet kutusudur: metin uzunluğu, sayı çevirme, trigonometrik hesap, rastgele sayı, tuş okuma, adres öğrenme ve tip boyutu gibi işler burada toplanır.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| SETSTRINGSIZE | SETSTRINGSIZE uzunluk | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SETSTRINGSIZE uzunluk` |
| TIMER | TIMER() | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `TIMER()` |
| LOF | LOF(#n) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LOF(#n)` |
| EOF | EOF(#n) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `EOF(#n)` |
| LEN | LEN(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LEN(metin)` |
| MID | MID(metin, başlangıç[, uzunluk]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `MID(metin, başlangıç[, uzunluk])` |
| STR | STR(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `STR(sayı)` |
| VAL | VAL(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `VAL(metin)` |
| ABS | ABS(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `ABS(sayı)` |
| INT | INT(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `INT(sayı)` |
| UCASE | UCASE(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `UCASE(metin)` |
| LCASE | LCASE(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LCASE(metin)` |
| ASC | ASC(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `ASC(metin)` |
| CHR | CHR(kod) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CHR(kod)` |
| LTRIM | LTRIM(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LTRIM(metin)` |
| RTRIM | RTRIM(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `RTRIM(metin)` |
| STRING | STRING(adet, karakter) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `STRING(adet, karakter)` |
| SPACE | SPACE(adet) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SPACE(adet)` |
| SGN | SGN(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SGN(sayı)` |
| SQRT | SQRT(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SQRT(sayı)` |
| SQR | SQR(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SQR(sayı)` |
| SIN | SIN(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SIN(radyan)` |
| COS | COS(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `COS(radyan)` |
| TAN | TAN(radyan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `TAN(radyan)` |
| ATN | ATN(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `ATN(sayı)` |
| EXP | EXP(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `EXP(sayı)` |
| LOG | LOG(sayı) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LOG(sayı)` |
| INKEY | INKEY([bekleme]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `INKEY([bekleme])` |
| GETKEY | GETKEY() | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `GETKEY()` |
| VARPTR | VARPTR(değişken) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `VARPTR(değişken)` |
| SADD | SADD(metin) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SADD(metin)` |
| LPTR | LPTR(etiket) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `LPTR(etiket)` |
| CODEPTR | CODEPTR(yordam) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CODEPTR(yordam)` |
| SIZEOF | SIZEOF(Tip veya değişken) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `SIZEOF(Tip veya değişken)` |
| OFFSETOF | OFFSETOF(Tip, alan) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `OFFSETOF(Tip, alan)` |
| CINT | CINT(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CINT(değer)` |
| CLNG | CLNG(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CLNG(değer)` |
| CDBL | CDBL(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CDBL(değer)` |
| CSNG | CSNG(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `CSNG(değer)` |
| FIX | FIX(değer) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `FIX(değer)` |
| RND | RND([tohum]) | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `RND([tohum])` |
| RANDOMIZE | RANDOMIZE [tohum] | Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. | `RANDOMIZE [tohum]` |

### Tekil kullanım notları

- **SETSTRINGSIZE:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SETSTRINGSIZE uzunluk`. Küçük kullanım: `PRINT SETSTRINGSIZE uzunluk`

- **TIMER:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `TIMER()`. Küçük kullanım: `PRINT TIMER()`

- **LOF:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LOF(#n)`. Küçük kullanım: `PRINT LOF(#n)`

- **EOF:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `EOF(#n)`. Küçük kullanım: `PRINT EOF(#n)`

- **LEN:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LEN(metin)`. Küçük kullanım: `PRINT LEN(metin)`

- **MID:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `MID(metin, başlangıç[, uzunluk])`. Küçük kullanım: `PRINT MID(metin, başlangıç[, uzunluk])`

- **STR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `STR(sayı)`. Küçük kullanım: `PRINT STR(sayı)`

- **VAL:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `VAL(metin)`. Küçük kullanım: `PRINT VAL(metin)`

- **ABS:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `ABS(sayı)`. Küçük kullanım: `PRINT ABS(sayı)`

- **INT:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `INT(sayı)`. Küçük kullanım: `PRINT INT(sayı)`

- **UCASE:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `UCASE(metin)`. Küçük kullanım: `PRINT UCASE(metin)`

- **LCASE:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LCASE(metin)`. Küçük kullanım: `PRINT LCASE(metin)`

- **ASC:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `ASC(metin)`. Küçük kullanım: `PRINT ASC(metin)`

- **CHR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CHR(kod)`. Küçük kullanım: `PRINT CHR(kod)`

- **LTRIM:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LTRIM(metin)`. Küçük kullanım: `PRINT LTRIM(metin)`

- **RTRIM:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `RTRIM(metin)`. Küçük kullanım: `PRINT RTRIM(metin)`

- **STRING:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `STRING(adet, karakter)`. Küçük kullanım: `DIM deger AS STRING`

- **SPACE:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SPACE(adet)`. Küçük kullanım: `PRINT SPACE(adet)`

- **SGN:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SGN(sayı)`. Küçük kullanım: `PRINT SGN(sayı)`

- **SQRT:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SQRT(sayı)`. Küçük kullanım: `PRINT SQRT(sayı)`

- **SQR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SQR(sayı)`. Küçük kullanım: `PRINT SQR(sayı)`

- **SIN:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SIN(radyan)`. Küçük kullanım: `PRINT SIN(radyan)`

- **COS:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `COS(radyan)`. Küçük kullanım: `PRINT COS(radyan)`

- **TAN:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `TAN(radyan)`. Küçük kullanım: `PRINT TAN(radyan)`

- **ATN:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `ATN(sayı)`. Küçük kullanım: `PRINT ATN(sayı)`

- **EXP:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `EXP(sayı)`. Küçük kullanım: `PRINT EXP(sayı)`

- **LOG:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LOG(sayı)`. Küçük kullanım: `PRINT LOG(sayı)`

- **INKEY:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `INKEY([bekleme])`. Küçük kullanım: `PRINT INKEY([bekleme])`

- **GETKEY:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `GETKEY()`. Küçük kullanım: `PRINT GETKEY()`

- **VARPTR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `VARPTR(değişken)`. Küçük kullanım: `PRINT VARPTR(değişken)`

- **SADD:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SADD(metin)`. Küçük kullanım: `PRINT SADD(metin)`

- **LPTR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `LPTR(etiket)`. Küçük kullanım: `PRINT LPTR(etiket)`

- **CODEPTR:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CODEPTR(yordam)`. Küçük kullanım: `PRINT CODEPTR(yordam)`

- **SIZEOF:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `SIZEOF(Tip veya değişken)`. Küçük kullanım: `PRINT SIZEOF(Tip veya değişken)`

- **OFFSETOF:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `OFFSETOF(Tip, alan)`. Küçük kullanım: `PRINT OFFSETOF(Tip, alan)`

- **CINT:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CINT(değer)`. Küçük kullanım: `PRINT CINT(değer)`

- **CLNG:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CLNG(değer)`. Küçük kullanım: `PRINT CLNG(değer)`

- **CDBL:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CDBL(değer)`. Küçük kullanım: `PRINT CDBL(değer)`

- **CSNG:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `CSNG(değer)`. Küçük kullanım: `PRINT CSNG(değer)`

- **FIX:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `FIX(değer)`. Küçük kullanım: `PRINT FIX(değer)`

- **RND:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `RND([tohum])`. Küçük kullanım: `PRINT RND([tohum])`

- **RANDOMIZE:** Hesap, metin, zaman, dosya veya adres bilgisini değer olarak döndürür. Sözdizimi: `RANDOMIZE [tohum]`. Küçük kullanım: `PRINT RANDOMIZE [tohum]`

### Birlikte kullanım örneği

```uxbasic
DIM ham AS STRING
DIM sayi AS F64
ham = "  42.50  "
sayi = VAL(LTRIM(RTRIM(ham)))
PRINT "kok="; SQRT(sayi)
PRINT "buyuk="; UCASE("uxbasic")
PRINT "saat="; TIMER()
```

## Bellek ve düşük seviye

Düşük seviye komutlar, dikkatli kullanıldığında dilin sistem programlama tarafını açar. Belleğe doğrudan yazmak, bayt taşımak, alan doldurmak ve adresle çalışmak güçlüdür; yanlış adres seçilirse hata da güçlü olur.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| PEEKB | PEEKB(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `PEEKB(adres)` |
| PEEKW | PEEKW(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `PEEKW(adres)` |
| PEEKD | PEEKD(adres) | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `PEEKD(adres)` |
| POKE | POKE adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `POKE adres, değer` |
| POKEB | POKEB adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `POKEB adres, değer` |
| POKEW | POKEW adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `POKEW adres, değer` |
| POKED | POKED adres, değer | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `POKED adres, değer` |
| POKES | POKES adres, metin | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `POKES adres, metin` |
| MEMCOPYB | MEMCOPYB hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMCOPYB hedef, kaynak, adet` |
| MEMCOPYW | MEMCOPYW hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMCOPYW hedef, kaynak, adet` |
| MEMCOPYD | MEMCOPYD hedef, kaynak, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMCOPYD hedef, kaynak, adet` |
| MEMFILLB | MEMFILLB hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMFILLB hedef, değer, adet` |
| MEMFILLW | MEMFILLW hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMFILLW hedef, değer, adet` |
| MEMFILLD | MEMFILLD hedef, değer, adet | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `MEMFILLD hedef, değer, adet` |
| SETNEWOFFSET | SETNEWOFFSET adres | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `SETNEWOFFSET adres` |
| INC | INC değişken[, adım] | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `INC değişken[, adım]` |
| DEC | DEC değişken[, adım] | Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. | `DEC değişken[, adım]` |

### Tekil kullanım notları

- **PEEKB:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `PEEKB(adres)`. Küçük kullanım: `PRINT PEEKB(adres)`

- **PEEKW:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `PEEKW(adres)`. Küçük kullanım: `PRINT PEEKW(adres)`

- **PEEKD:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `PEEKD(adres)`. Küçük kullanım: `PRINT PEEKD(adres)`

- **POKE:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `POKE adres, değer`. Küçük kullanım: `POKE adres, değer`

- **POKEB:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `POKEB adres, değer`. Küçük kullanım: `POKEB adres, değer`

- **POKEW:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `POKEW adres, değer`. Küçük kullanım: `POKEW adres, değer`

- **POKED:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `POKED adres, değer`. Küçük kullanım: `POKED adres, değer`

- **POKES:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `POKES adres, metin`. Küçük kullanım: `POKES adres, metin`

- **MEMCOPYB:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMCOPYB hedef, kaynak, adet`. Küçük kullanım: `MEMCOPYB hedef, kaynak, adet`

- **MEMCOPYW:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMCOPYW hedef, kaynak, adet`. Küçük kullanım: `MEMCOPYW hedef, kaynak, adet`

- **MEMCOPYD:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMCOPYD hedef, kaynak, adet`. Küçük kullanım: `MEMCOPYD hedef, kaynak, adet`

- **MEMFILLB:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMFILLB hedef, değer, adet`. Küçük kullanım: `MEMFILLB hedef, değer, adet`

- **MEMFILLW:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMFILLW hedef, değer, adet`. Küçük kullanım: `MEMFILLW hedef, değer, adet`

- **MEMFILLD:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `MEMFILLD hedef, değer, adet`. Küçük kullanım: `MEMFILLD hedef, değer, adet`

- **SETNEWOFFSET:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `SETNEWOFFSET adres`. Küçük kullanım: `SETNEWOFFSET adres`

- **INC:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `INC değişken[, adım]`. Küçük kullanım: `INC değişken[, adım]`

- **DEC:** Bellek adresi, bayt/kelime/dword ve ham veri taşıma işlerinde kullanılır. Sözdizimi: `DEC değişken[, adım]`. Küçük kullanım: `DEC değişken[, adım]`

### Birlikte kullanım örneği

```uxbasic
DIM adres AS U64
adres = 1024
POKEB adres, 65
PRINT CHR(PEEKB(adres))
MEMFILLB adres, 0, 16
INC adres, 16
DEC adres, 8
```

## Veri tipleri ve yapıları

Tipler verinin bedeni, veri yapıları düzenidir. Sayı mı tutuyorsun, metin mi, nesne mi, dizi mi, sözlük mü? Doğru seçim programı hızlı, okunur ve güvenli yapar.

| Öğe | Sözdizimi | Anlam | Kısa örnek kalıbı |
| --- | --- | --- | --- |
| BYTE | BYTE ... | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `BYTE ...` |
| I8 | DIM ad AS I8 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS I8` |
| U8 | DIM ad AS U8 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS U8` |
| I16 | DIM ad AS I16 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS I16` |
| U16 | DIM ad AS U16 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS U16` |
| I32 | DIM ad AS I32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS I32` |
| U32 | DIM ad AS U32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS U32` |
| I64 | DIM ad AS I64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS I64` |
| U64 | DIM ad AS U64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS U64` |
| F32 | DIM ad AS F32 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS F32` |
| F64 | DIM ad AS F64 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS F64` |
| F80 | DIM ad AS F80 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS F80` |
| F128 | DIM ad AS F128 | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS F128` |
| BIGF | DIM ad AS BIGF | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BIGF` |
| BIGD | DIM ad AS BIGD | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BIGD` |
| BALL | DIM ad AS BALL | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BALL` |
| BIGI | DIM ad AS BIGI | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BIGI` |
| BIGINT | DIM ad AS BIGINT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BIGINT` |
| BOOLEAN | DIM ad AS BOOLEAN | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS BOOLEAN` |
| OBJECT | DIM ad AS OBJECT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS OBJECT` |
| PTR | DIM ad AS PTR | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS PTR` |
| STRPTR | DIM ad AS STRPTR | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS STRPTR` |
| ARRAY | DIM ad AS ARRAY | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS ARRAY` |
| LIST | DIM ad AS LIST | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS LIST` |
| DICT | DIM ad AS DICT | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS DICT` |
| SET | DIM ad AS SET | Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. | `DIM ad AS SET` |

### Tekil kullanım notları

- **BYTE:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `BYTE ...`. Küçük kullanım: `BYTE ...`

- **I8:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS I8`. Küçük kullanım: `DIM ad AS I8`

- **U8:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS U8`. Küçük kullanım: `DIM ad AS U8`

- **I16:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS I16`. Küçük kullanım: `DIM ad AS I16`

- **U16:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS U16`. Küçük kullanım: `DIM ad AS U16`

- **I32:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS I32`. Küçük kullanım: `DIM deger AS I32`

- **U32:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS U32`. Küçük kullanım: `DIM ad AS U32`

- **I64:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS I64`. Küçük kullanım: `DIM ad AS I64`

- **U64:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS U64`. Küçük kullanım: `DIM ad AS U64`

- **F32:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS F32`. Küçük kullanım: `DIM ad AS F32`

- **F64:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS F64`. Küçük kullanım: `DIM deger AS F64`

- **F80:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS F80`. Küçük kullanım: `DIM ad AS F80`

- **F128:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS F128`. Küçük kullanım: `DIM ad AS F128`

- **BIGF:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BIGF`. Küçük kullanım: `DIM deger AS BIGF`

- **BIGD:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BIGD`. Küçük kullanım: `DIM deger AS BIGD`

- **BALL:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BALL`. Küçük kullanım: `DIM deger AS BALL`

- **BIGI:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BIGI`. Küçük kullanım: `DIM ad AS BIGI`

- **BIGINT:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BIGINT`. Küçük kullanım: `DIM deger AS BIGINT`

- **BOOLEAN:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS BOOLEAN`. Küçük kullanım: `DIM deger AS BOOLEAN`

- **OBJECT:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS OBJECT`. Küçük kullanım: `DIM ad AS OBJECT`

- **PTR:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS PTR`. Küçük kullanım: `DIM ad AS PTR`

- **STRPTR:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS STRPTR`. Küçük kullanım: `DIM ad AS STRPTR`

- **ARRAY:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS ARRAY`. Küçük kullanım: `DIM deger AS ARRAY`

- **LIST:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS LIST`. Küçük kullanım: `DIM deger AS LIST`

- **DICT:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS DICT`. Küçük kullanım: `DIM deger AS DICT`

- **SET:** Değişkenin bellekte nasıl tutulacağını ve hangi değerleri alacağını belirler. Sözdizimi: `DIM ad AS SET`. Küçük kullanım: `DIM deger AS SET`

### Birlikte kullanım örneği

```uxbasic
DIM x AS I32
DIM y AS F64
DIM ad AS STRING
DIM ok AS BOOLEAN
x = 12
y = 3.5
ad = "saha"
ok = y > 0
PRINT ad; x; y; ok
```

# 4. Ön-işleyici

Ön-işleyici, program çalışmadan önce kaynak metni hazırlayan ustadır. Aynı `.uxb` dosyasından hem konsol hem tarayıcı hedefi üretmek, HTML satırı eklemek, varlık kopyalamak, güvenlik kapısı koymak, WAT import bildirmek veya manifest oluşturmak burada başlar. `src(30.05_5)` içinde ADIM33/34 kararları ve ADIM41 çıktı sözleşmesi bu yapıyı büyütür.

| No | Komut | Sözdizimi | Görev |
| --- | --- | --- | --- |
| 1 | %%ALIAS | %%ALIAS {uzun} AS {kısa} | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 2 | %%ALLOW_RAW_JS | %%ALLOW_RAW_JS ON\|OFF | Güvenlik ve doğrulama sınırını belirler. |
| 3 | %%ALLOW_RAW_WAT | %%ALLOW_RAW_WAT ON\|OFF | Güvenlik ve doğrulama sınırını belirler. |
| 4 | %%ASSERT | %%ASSERT ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 5 | %%ASSERT_META | %%ASSERT_META koşul | Güvenlik ve doğrulama sınırını belirler. |
| 6 | %%ASSET_AUDIO | %%ASSET_AUDIO "ses.ogg" AS "id" | Tarayıcı veya paket çıktısına varlık ekler. |
| 7 | %%ASSET_COPY | %%ASSET_COPY "kaynak" AS "hedef" | Tarayıcı veya paket çıktısına varlık ekler. |
| 8 | %%ASSET_FILE | %%ASSET_FILE "dosya" | Tarayıcı veya paket çıktısına varlık ekler. |
| 9 | %%ASSET_IMAGE | %%ASSET_IMAGE "resim.png" AS "id" | Tarayıcı veya paket çıktısına varlık ekler. |
| 10 | %%ASSET_REQUIRE | %%ASSET_REQUIRE "dosya" | Tarayıcı veya paket çıktısına varlık ekler. |
| 11 | %%ASSET_ROOT | %%ASSET_ROOT "assets" | Tarayıcı veya paket çıktısına varlık ekler. |
| 12 | %%BREAK | %%BREAK | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 13 | %%CONFIG_FILE | %%CONFIG_FILE "ayar.json" | Dosya ve yol düzenini kurar. |
| 14 | %%CONTINUE | %%CONTINUE | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 15 | %%COPY_DIR | %%COPY_DIR "src" AS "dst" | Dosya ve yol düzenini kurar. |
| 16 | %%CSS_BEGIN | %%CSS_BEGIN | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 17 | %%CSS_END | %%CSS_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 18 | %%CSS_IMPORT | %%CSS_IMPORT "stil.css" | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 19 | %%CSS_LINE | %%CSS_LINE "css" | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 20 | %%CSS_RULE | %%CSS_RULE seçici { ... } | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 21 | %%DEFINE | %%DEFINE AD değer | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 22 | %%DEPRECATED | %%DEPRECATED "açıklama" | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 23 | %%DESTOS | %%DESTOS WINDOWS\|LINUX | Hedef işletim sistemi ve çalışma güvenliği ayarlarını bildirir. |
| 24 | %%DUMP_META | %%DUMP_META "meta.json" | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 25 | %%ELIF | %%ELIF koşul | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 26 | %%ELSE | %%ELSE | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 27 | %%EMBEDBASE64 | %%EMBEDBASE64 "dosya" AS AD | Tarayıcı veya paket çıktısına varlık ekler. |
| 28 | %%EMBEDTEXT | %%EMBEDTEXT "dosya" AS AD | Tarayıcı veya paket çıktısına varlık ekler. |
| 29 | %%EMITNOTE | %%EMITNOTE "not" | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 30 | %%ENDCOMP | %%ENDCOMP | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 31 | %%ENDFOR | %%ENDFOR | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 32 | %%ENDIF | %%ENDIF | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 33 | %%ENDSECTION | %%ENDSECTION | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 34 | %%ENV | %%ENV AD | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 35 | %%ERROR | %%ERROR ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 36 | %%ERRORENDCOMP | %%ERRORENDCOMP "ileti" | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 37 | %%EVAL | %%EVAL ... | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 38 | %%EXPANDLIMIT | %%EXPANDLIMIT 10000 | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 39 | %%EXTENSION | %%EXTENSION ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 40 | %%FINGERPRINT_ASSETS | %%FINGERPRINT_ASSETS ON\|OFF | Tarayıcı veya paket çıktısına varlık ekler. |
| 41 | %%FOR | %%FOR ad = başlangıç TO bitiş | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 42 | %%FOREACH | %%FOREACH ad IN liste | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 43 | %%HASHFILE | %%HASHFILE "dosya" AS AD | Tarayıcı veya paket çıktısına varlık ekler. |
| 44 | %%HTMLAUDIO | %%HTMLAUDIO "ses.ogg" AS "id" | Tarayıcı veya paket çıktısına varlık ekler. |
| 45 | %%HTMLIMAGE | %%HTMLIMAGE "resim.png" AS "id" | Tarayıcı veya paket çıktısına varlık ekler. |
| 46 | %%HTML_BEGIN | %%HTML_BEGIN "index.html" BODY | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 47 | %%HTML_END | %%HTML_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 48 | %%HTML_LINE | %%HTML_LINE "html" | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 49 | %%IF | %%IF koşul | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 50 | %%IFC | %%IFC koşul | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 51 | %%IFN | %%IFN sayısal_koşul | Kaynağın hangi bölümünün derlemeye gireceğini seçer. |
| 52 | %%INCLUDE | %%INCLUDE "dosya" | Dosya ve yol düzenini kurar. |
| 53 | %%INFOMETA | %%INFOMETA "bilgi" | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 54 | %%INJECT_ASM | %%INJECT_ASM ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 55 | %%INJECT_JS | %%INJECT_JS ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 56 | %%INLINE | %%INLINE ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 57 | %%JSON_ARRAY_BEGIN | %%JSON_ARRAY_BEGIN ad | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 58 | %%JSON_ARRAY_END | %%JSON_ARRAY_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 59 | %%JSON_BEGIN | %%JSON_BEGIN | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 60 | %%JSON_END | %%JSON_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 61 | %%JSON_SET | %%JSON_SET anahtar değer | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 62 | %%JS_BEGIN | %%JS_BEGIN [ad] | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 63 | %%JS_END | %%JS_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 64 | %%JS_LINE | %%JS_LINE "kod" | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 65 | %%LICENSEFILE | %%LICENSEFILE "LICENSE" | Dosya ve yol düzenini kurar. |
| 66 | %%LINK_DLL | %%LINK_DLL ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 67 | %%LINK_WASM | %%LINK_WASM ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 68 | %%LOCK_META | %%LOCK_META ad | Güvenlik ve doğrulama sınırını belirler. |
| 69 | %%MACRO | %%MACRO AD(P) gövde | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 70 | %%MANIFEST_REQUIRE | %%MANIFEST_REQUIRE anahtar | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 71 | %%MANIFEST_SET | %%MANIFEST_SET anahtar değer | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 72 | %%MD_BEGIN | %%MD_BEGIN | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 73 | %%MD_CSS | %%MD_CSS "stil.css" | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 74 | %%MD_END | %%MD_END | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 75 | %%MD_SAFE | %%MD_SAFE ON\|OFF | Üretilen web/JSON/Markdown çıktısına satır veya blok ekler. |
| 76 | %%MINIFY | %%MINIFY JS\|CSS\|HTML | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 77 | %%NEXTMETA | %%NEXTMETA | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 78 | %%NOZEROVARS | %%NOZEROVARS ON\|OFF | Hedef işletim sistemi ve çalışma güvenliği ayarlarını bildirir. |
| 79 | %%NO_MANGLE | %%NO_MANGLE ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 80 | %%OUTDIR | %%OUTDIR "dist" | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 81 | %%PATH_ALIAS | %%PATH_ALIAS @ad = "yol" | Dosya ve yol düzenini kurar. |
| 82 | %%PLATFORM | %%PLATFORM WINDOWS\|LINUX | Hedef işletim sistemi ve çalışma güvenliği ayarlarını bildirir. |
| 83 | %%PROFILE | %%PROFILE ad | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 84 | %%REPEAT | %%REPEAT | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 85 | %%REQUIRE_HOST_BINDING | %%REQUIRE_HOST_BINDING ON\|OFF | Güvenlik ve doğrulama sınırını belirler. |
| 86 | %%SAFE_PATHS | %%SAFE_PATHS ON\|OFF | Güvenlik ve doğrulama sınırını belirler. |
| 87 | %%SECSTACK | %%SECSTACK ON\|OFF | Hedef işletim sistemi ve çalışma güvenliği ayarlarını bildirir. |
| 88 | %%SECTION | %%SECTION AD | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 89 | %%SET | %%SET AD = değer | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 90 | %%SOURCE_MAP | %%SOURCE_MAP "map.json" | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 91 | %%TARGET | %%TARGET JS\|WASM\|X64\|BROWSER | Çıktı hedefi, paket kimliği, rapor ve üretim politikasını belirler. |
| 92 | %%TEMPLATE_BEGIN | %%TEMPLATE_BEGIN ad | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 93 | %%TEMPLATE_END | %%TEMPLATE_END | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 94 | %%TEMPLATE_USE | %%TEMPLATE_USE ad | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 95 | %%UNDEF | %%UNDEF AD | Derleme zamanında ad, değer, kısa yol veya hesaplanmış metin üretir. |
| 96 | %%UNTILMETA | %%UNTILMETA koşul | Tekrarlı meta üretim için ayrılmış/planlı komut ailesidir. |
| 97 | %%WARNING | %%WARNING ... | Ön-işleyici çıktısını yönlendiren meta komuttur. |
| 98 | %%WARN_META | %%WARN_META "uyarı" | Güvenlik ve doğrulama sınırını belirler. |
| 99 | %%WASM_HOST_JS_BEGIN | %%WASM_HOST_JS_BEGIN | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 100 | %%WASM_HOST_JS_END | %%WASM_HOST_JS_END | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 101 | %%WAT_BEGIN | %%WAT_BEGIN [ad] | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 102 | %%WAT_END | %%WAT_END | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 103 | %%WAT_EXPORT | %%WAT_EXPORT ad | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 104 | %%WAT_FUNC_BEGIN | %%WAT_FUNC_BEGIN ad | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 105 | %%WAT_FUNC_END | %%WAT_FUNC_END | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |
| 106 | %%WAT_IMPORT | %%WAT_IMPORT modül ad imza | WAT/WASM tarafına ham köprü, dış işlev veya gövde ekler. |

Ön-işleyici kullanırken en iyi alışkanlık, hedef seçimini dosyanın başında açık yazmak, raw JS/WAT gibi ham kod kapılarını bilerek açmak, varlık yollarını tek kökten yönetmek ve manifest içine sürüm/amaç bilgisi koymaktır. Aşağıdaki örnek tek kaynaktan web kabuğu, JS satırı, varlık ve manifest üretir.

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%ASSET_ROOT "assets"
%%MANIFEST_SET app "SahaRaporu"
%%ASSET_IMAGE "logo.png" AS "logo"
%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Saha Raporu</h1>
<img id="logo" src="assets/logo.png">
%%HTML_END
%%JS_LINE "console.log('uXBasic web hedefi hazir')"

MAIN
    PRINT "Web ve konsol cikti sozlesmesi hazir"
END MAIN
```

```uxbasic
%%TARGET WASM
%%ALLOW_RAW_WAT ON
%%WAT_IMPORT "ux" "print_i32" "(func $ux_print_i32 (param i32))"
%%WAT_EXPORT "MAIN"
MAIN
    PRINT 42
END MAIN
```

# 5. Veri tipleri ve veri yapıları

Tip seçimi, programın karakteridir. Küçük sayaç için `I32`, büyük dosya uzunluğu için `U64`, bilimsel ölçüm için `F64`, çok hassas hesap için `F80/F128/BIGF/BIGD`, dev tam sayı için `BIGINT`, doğru/yanlış için `BOOLEAN`, metin için `STRING`, nesne için `OBJECT`, adres için `PTR/STRPTR` kullanılır. `ARRAY` düzenli tablo, `LIST` büyüyen sıra, `DICT` anahtarlı sözlük, `SET` tekrarsız kümedir.

| No | Tip | Anlam | Kullanım |
| --- | --- | --- | --- |
| 1 | VOID | Değer döndürmeyen yordam tipi. | DIM ad AS VOID |
| 2 | ANY | Genel değer taşıma türü; dış servislerde kullanılır. | DIM ad AS ANY |
| 3 | PTR | Ham adres tutar. | DIM ad AS PTR |
| 4 | STRPTR | Metnin adresini tutar. | DIM ad AS STRPTR |
| 5 | WSTRPTR | Geniş karakter metin adresi tutar. | DIM ad AS WSTRPTR |
| 6 | BYREF | Parametreyi kopyalamadan, asıl değişkene bağlar. | DIM ad AS BYREF |
| 7 | BYVAL | Parametreyi değer kopyası olarak gönderir. | DIM ad AS BYVAL |
| 8 | I8 | -128..127 arası işaretli 8 bit tam sayı. | DIM ad AS I8 |
| 9 | U8 | 0..255 arası işaretsiz 8 bit tam sayı. | DIM ad AS U8 |
| 10 | I16 | İşaretli 16 bit tam sayı. | DIM ad AS I16 |
| 11 | U16 | İşaretsiz 16 bit tam sayı. | DIM ad AS U16 |
| 12 | I32 | Günlük sayaç ve tam sayı için ana tip. | DIM ad AS I32 |
| 13 | U32 | Negatif olmayan 32 bit sayı. | DIM ad AS U32 |
| 14 | I64 | Büyük tam sayı, dosya boyutu ve sayaç. | DIM ad AS I64 |
| 15 | U64 | Büyük adres ve negatif olmayan uzun sayı. | DIM ad AS U64 |
| 16 | F32 | Tek duyarlıklı kayan nokta. | DIM ad AS F32 |
| 17 | F64 | Genel bilimsel hesap için çift duyarlıklı sayı. | DIM ad AS F64 |
| 18 | F80 | 80 bit geniş kayan nokta; yüksek duyarlık. | DIM ad AS F80 |
| 19 | F128 | 128 bit kayan nokta; çok hassas hesap. | DIM ad AS F128 |
| 20 | BIGF | Keyfi büyüklükte kayan sayı. | DIM ad AS BIGF |
| 21 | BIGD | Büyük ondalık/finansal duyarlık. | DIM ad AS BIGD |
| 22 | BALL | Büyük mantık/bit alanı ve boolean ailesi. | DIM ad AS BALL |
| 23 | BIGI | Büyük tam sayı takma adı. | DIM ad AS BIGI |
| 24 | BIGINT | Çok büyük tam sayı. | DIM ad AS BIGINT |
| 25 | EXTENDED | Kaynakta tanınan tip veya takma addır. | DIM ad AS EXTENDED |
| 26 | EXT | Kaynakta tanınan tip veya takma addır. | DIM ad AS EXT |
| 27 | BOOLEAN | Doğru/yanlış değeri. | DIM ad AS BOOLEAN |
| 28 | STRING | Metin. | DIM ad AS STRING |
| 29 | OBJECT | Nesne referansı. | DIM ad AS OBJECT |
| 30 | ARRAY | Sabit düzenli dizi. | DIM ad AS ARRAY |
| 31 | LIST | Büyüyebilen liste. | DIM ad AS LIST |
| 32 | DICT | Anahtar-değer sözlüğü. | DIM ad AS DICT |
| 33 | SET | Tekrarsız küme. | DIM ad AS SET |
| 34 | FLOAT128 | Kaynakta tanınan tip veya takma addır. | DIM ad AS FLOAT128 |
| 35 | QUAD | Kaynakta tanınan tip veya takma addır. | DIM ad AS QUAD |
| 36 | BIGFLOAT | Kaynakta tanınan tip veya takma addır. | DIM ad AS BIGFLOAT |
| 37 | BIGDECIMAL | Kaynakta tanınan tip veya takma addır. | DIM ad AS BIGDECIMAL |
| 38 | BIG_INTEGER | Kaynakta tanınan tip veya takma addır. | DIM ad AS BIG_INTEGER |
| 39 | DOUBLE | Kaynakta tanınan tip veya takma addır. | DIM ad AS DOUBLE |
| 40 | DBL | Kaynakta tanınan tip veya takma addır. | DIM ad AS DBL |
| 41 | DBLE | Kaynakta tanınan tip veya takma addır. | DIM ad AS DBLE |
| 42 | SINGLE | Kaynakta tanınan tip veya takma addır. | DIM ad AS SINGLE |
| 43 | SNG | Kaynakta tanınan tip veya takma addır. | DIM ad AS SNG |
| 44 | SNGLE | Kaynakta tanınan tip veya takma addır. | DIM ad AS SNGLE |
| 45 | INTEGER | Kaynakta tanınan tip veya takma addır. | DIM ad AS INTEGER |
| 46 | INT | Kaynakta tanınan tip veya takma addır. | DIM ad AS INT |

### Çok boyutlu dizi örnekleri

```uxbasic
DIM gunluk(1 TO 7) AS F64
DIM istasyon(1 TO 10, 1 TO 3) AS F64
DIM deney(1 TO 4, 1 TO 10, 1 TO 3) AS F64
DIM hacim(1 TO 12, 1 TO 5, 1 TO 20, 1 TO 20) AS F64
DIM evren(1 TO 2, 1 TO 3, 1 TO 4, 1 TO 5, 1 TO 6) AS BIGF

gunluk(1) = 7.2
istasyon(2, 1) = 24.5
deney(1, 3, 2) = 8.1
hacim(1, 1, 10, 10) = 0.42
evren(1, 2, 3, 4, 5) = BIGF("123456789.987654321")
PRINT "veri hazir"
```

2 boyutlu dizi satır-sütun tablosudur; 3 boyutlu dizi zaman-istasyon-parametre gibi düşünülür; 4 boyutlu dizi zamanlı hacim veya görüntü dizisi olabilir; 5 boyutlu dizi deney tasarımında tür, doz, zaman, tekrar ve ölçüm gibi eksenleri ayırır. Çok boyutlu dizide hile şudur: her eksene gerçek dünyadaki bir anlam vermezsen dizi çöp kutusuna döner.

```uxbasic
DIM isimler AS LIST
DIM puanlar AS DICT
DIM benzersiz AS SET
LIST_ADD isimler, "Ali"
LIST_ADD isimler, "Ayse"
DICT_SET puanlar, "Ali", 85
DICT_SET puanlar, "Ayse", 91
SET_ADD benzersiz, "ph"
SET_ADD benzersiz, "ph"
PRINT "ogrenci="; LIST_GET(isimler, 1)
PRINT "puan="; DICT_GET(puanlar, "Ayse")
PRINT "tekil alan="; SET_COUNT(benzersiz)
```

# 6. Çalışma zamanı servisleri ve kütüphaneler

Çalışma zamanı servisi, program çalışırken dış dünyaya uzanan kapıdır. Ekrana yazmak, dosya açmak, belleğe yazmak, DLL çağırmak, JSON işlemek, HTTP isteği atmak, yerel Llama’ya sormak veya tarayıcı canvasına çizmek bu servislerin işidir. Aşağıdaki tablo `src(30.05_5)` servis kataloğundan çıkarılmıştır.

| No | Servis | İmza | Hedef | Görev |
| --- | --- | --- | --- | --- |
| 1 | RT_PRINT | VOID(ANY) | X64,JS,WASM,BROWSER | Ekrana veya host çıktısına değer yollar. |
| 2 | RT_INPUT | STRING() | X64,JS,BROWSER | Kullanıcı/host girişi okur. |
| 3 | RT_CLS | VOID() | X64,JS,WASM,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 4 | RT_COLOR | VOID(I32,I32) | X64,JS,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 5 | RT_LOCATE | VOID(I32,I32) | X64,JS,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 6 | RT_STR_LEN | I64(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 7 | RT_STR_CONCAT | STRING(STRING,STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 8 | RT_STR_LEFT | STRING(STRING,I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 9 | RT_STR_RIGHT | STRING(STRING,I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 10 | RT_STR_MID | STRING(STRING,I64,I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 11 | RT_STR_COMPARE | I64(STRING,STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 12 | RT_STR_TO_UPPER | STRING(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 13 | RT_STR_TO_LOWER | STRING(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 14 | RT_STR_TRIM | STRING(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 15 | RT_STR_LTRIM | STRING(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 16 | RT_STR_RTRIM | STRING(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 17 | RT_STR_SPACE | STRING(I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 18 | RT_STR_ASC | I64(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 19 | RT_STR_CHR | STRING(I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 20 | RT_STR_VAL | F64(STRING) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 21 | RT_STR_STR | STRING(I64) | X64,JS,WASM,BROWSER | Metin işleme ailesidir. |
| 22 | RT_MATH_ABS | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 23 | RT_MATH_SQRT | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 24 | RT_MATH_SIN | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 25 | RT_MATH_COS | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 26 | RT_MATH_TAN | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 27 | RT_MATH_ATN | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 28 | RT_MATH_LOG | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 29 | RT_MATH_EXP | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 30 | RT_MATH_SGN | I64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 31 | RT_MATH_FIX | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 32 | RT_MATH_INT | F64(F64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 33 | RT_RANDOMIZE | VOID(I64) | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 34 | RT_RND | F64() | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 35 | RT_TIMER | F64() | X64,JS,WASM,BROWSER | Matematik, rastgelelik veya zaman hizmetidir. |
| 36 | RT_PEEK | I64(I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 37 | RT_POKE | VOID(I64,I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 38 | RT_MEM_LOAD | I64(I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 39 | RT_MEM_STORE | VOID(I64,I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 40 | RT_MEM_COPY | VOID(I64,I64,I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 41 | RT_MEM_FILL | VOID(I64,I64,I64) | X64,JS,WASM,BROWSER | Bellek okuma/yazma/taşıma hizmetidir. |
| 42 | RT_FILE_OPEN | HANDLE(STRING,STRING) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 43 | RT_FILE_CLOSE | VOID(HANDLE) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 44 | RT_FILE_READ | STRING(HANDLE,I64) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 45 | RT_FILE_WRITE | I64(HANDLE,STRING) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 46 | RT_FILE_SEEK | I64(HANDLE,I64) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 47 | RT_FILE_DELETE | I64(STRING) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 48 | RT_FILE_EOF | I64(HANDLE) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 49 | RT_FILE_LOF | I64(HANDLE) | X64 | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 50 | RT_DLL_LOAD | HANDLE(STRING) | X64 | Dış native kod çağrısıdır. |
| 51 | RT_DLL_CALL | ANY(STRING,STRING,ANY) | X64 | Dış native kod çağrısıdır. |
| 52 | RT_API_CALL | ANY(STRING,STRING,ANY) | X64 | Dış native kod çağrısıdır. |
| 53 | RT_INLINE_NATIVE | ANY(STRING) | X64 | Dış native kod çağrısıdır. |
| 54 | RT_LIBRARY_CALL | ANY(STRING,ANY) | X64,JS,WASM,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 55 | RT_JSON_CALL | ANY(STRING,ANY) | X64,JS,WASM,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 56 | RT_REGEX_CALL | ANY(STRING,STRING) | X64,JS,WASM,BROWSER | Genel kütüphane/dış servis çağrısıdır. |
| 57 | RT_HTTP_CALL | ANY(STRING,ANY) | X64,JS,BROWSER | Ağ ve REST çağrısı hizmetidir. |
| 58 | RT_OS_CALL | ANY(STRING,ANY) | X64 | Genel kütüphane/dış servis çağrısıdır. |
| 59 | RT_LLAMA_CALL | ANY(STRING,ANY) | X64 | Yerel Llama modeliyle konuşma hizmetidir. |
| 60 | RT_LUA_CALL | ANY(STRING,ANY) | X64 | Genel kütüphane/dış servis çağrısıdır. |
| 61 | RT_PROLOG_CALL | ANY(STRING,ANY) | X64 | Genel kütüphane/dış servis çağrısıdır. |
| 62 | RT_SQLITE_CALL | ANY(STRING,ANY) | X64 | Genel kütüphane/dış servis çağrısıdır. |
| 63 | RT_BROWSER_CANVAS | ANY(STRING,ANY) | JS,BROWSER | Tarayıcı ve web hedefi hizmetidir. |
| 64 | RT_BROWSER_AUDIO | ANY(STRING,ANY) | JS,BROWSER | Tarayıcı ve web hedefi hizmetidir. |
| 65 | RT_BROWSER_INPUT | ANY(STRING,ANY) | JS,BROWSER | Kullanıcı/host girişi okur. |
| 66 | RT_BROWSER_FILE | ANY(STRING,ANY) | JS,BROWSER | Dosya açma, okuma, yazma, konumlama veya silme hizmetidir. |
| 67 | RT_BROWSER_FETCH | ANY(STRING,ANY) | JS,BROWSER | Tarayıcı ve web hedefi hizmetidir. |
| 68 | RT_WEBGPU_CALL | ANY(STRING,ANY) | JS,BROWSER | Tarayıcı ve web hedefi hizmetidir. |
| 69 | RT_WASM_IMPORT_CALL | ANY(STRING,ANY) | WASM,BROWSER | WASM-host köprüsüdür. |
| 70 | RT_WASM_EXPORT_CALL | ANY(STRING,ANY) | WASM,BROWSER | WASM-host köprüsüdür. |
| 71 | RT_HOST_CALL | ANY(STRING,ANY) | JS,WASM,BROWSER | WASM-host köprüsüdür. |
| 72 | RT_EXTFP_CALL | ANY(STRING,ANY) | X64 | Genel kütüphane/dış servis çağrısıdır. |

Servis çağırırken sıralama şudur: önce kullanılacak kütüphaneyi veya DLL’i bildir, sonra parametre tiplerini açık yaz, sonra dönüş değerini kontrol et, hata varsa `TRY/CATCH` veya rapor dosyasıyla yakala. Aşağıdaki örnekler hepsinin çalıştığı varsayımıyla yazılmıştır.

```uxbasic
MODULE Json
    DECLARE FUNCTION Parse(metin AS STRING) AS OBJECT
    DECLARE FUNCTION Get(obj AS OBJECT, yol AS STRING) AS STRING
END MODULE

DIM obj AS OBJECT
obj = Json.Parse("{""ph"":7.2,""sicaklik"":24.5}")
PRINT Json.Get(obj, "ph")
```

```uxbasic
MODULE Http
    DECLARE FUNCTION Get(url AS STRING) AS STRING
    DECLARE FUNCTION PostJson(url AS STRING, body AS STRING) AS STRING
END MODULE

DIM cevap AS STRING
cevap = Http.PostJson("http://127.0.0.1:5000/tahmin", "{""x"":42}")
PRINT cevap
```

## Kütüphane aileleri

| Kütüphane | Ne yapar? | Tipik çağrı |
| --- | --- | --- |
| bigfp | BIGF/BIGD/BIGINT hesapları; taşma korkusu olan bilimsel ve finansal hesaplarda kullanılır. | BIGF("1.23") + BIGF("4.56") |
| fp80 | 80 bit geniş kayan nokta; x87 benzeri hassas ara hesaplar. | DIM x AS F80 |
| fp128 | 128 bit kayan nokta; yüksek duyarlık gereken analizler. | DIM y AS F128 |
| uxmath | Temel matematik, trigonometrik ve yardımcı hesaplar. | SIN, COS, LOG, EXP |
| uxmathcore | Hızlı vektör/tampon ve çekirdek sayısal iş. | VECTOR_DOT, BUFFER_SUM |
| uxstats | Ortalama, varyans, Z/T/F testi, ANOVA gibi istatistikler. | ZTEST, FTEST, ANOVA |
| uxstats2 | İleri istatistik ve ek testler. | REGRESSION, CORR |
| uxmatrix | Matris oluşturma, çarpma, ters alma. | MATRIX_MUL |
| uxtensor | Çok boyutlu tensör işlemleri. | TENSOR_SHAPE |
| uxdataframe | CSV/SQL/Parquet benzeri tablo işlemleri. | DF_READCSV |
| uxcollections | Liste, yığın, kuyruk, sözlük, küme. | LIST_ADD, DICT_SET |
| uxgraph | Düğüm, kenar, yol ve graf analizi. | GRAPH_PATH |
| uxnn/uxnn2/uxnn3 | Sinir ağı katmanı, aktivasyon ve eğitim. | NN_FORWARD |
| uxaimath | Yapay zeka matematiği, kayıp ve optimizasyon. | SOFTMAX, LOSS |
| uxonnx/uxonnx2 | ONNX model yükleme ve çıkarım. | ONNX_RUN |
| uxllama | Yerel Llama modeli ile metin üretimi. | LLAMA_ASK |

```uxbasic
MODULE Stats
    DECLARE FUNCTION Mean(x AS ARRAY) AS F64
    DECLARE FUNCTION Variance(x AS ARRAY) AS F64
    DECLARE FUNCTION ZTest(ort AS F64, mu AS F64, sigma AS F64, n AS I32) AS F64
END MODULE

DIM x(1 TO 5) AS F64
x(1)=10.1: x(2)=10.5: x(3)=9.8: x(4)=10.2: x(5)=10.4
DIM ort AS F64
ort = Stats.Mean(x)
PRINT "z="; Stats.ZTest(ort, 10.0, 0.5, 5)
```

# 7. Kanca, sarmalayıcı, dış çağrı ve derleyici geliştirme

Kanca [belirli aşamada araya giren izleme/geliştirme noktası] ve sarmalayıcı [dış işlevi güvenli ve okunur adla sunan katman] derleyici geliştiricisinin iki akıllı hilesidir. Kanca asıl akışı bozmaz; sadece “şu aşamaya geldim, şu düğüm üretildi, şu MIR op çıktı” der. Sarmalayıcı ise karmaşık DLL/API imzasını genç programcının anlayacağı komuta çevirir.

```uxbasic
MODULE Win
    DECLARE FUNCTION MessageBox(hwnd AS U64, text AS STRING, title AS STRING, flags AS U32) AS I32 LIB "USER32.DLL" ALIAS "MessageBoxA" STDCALL
END MODULE

SUB Bilgi(metin AS STRING)
    CALL Win.MessageBox(0, metin, "uXBasic", 0)
END SUB

CALL Bilgi("Sarmalayici sayesinde DLL cagrisi okunur oldu")
```

```uxbasic
IMPORT(C, "native/hizli_hesap.c")
IMPORT(CPP, "native/matris.cpp")
IMPORT(ASM, "native/hizli_rutin.asm")

DECLARE FUNCTION HizliTopla(a AS I32, b AS I32) AS I32
DECLARE FUNCTION MatrisCarp(a AS PTR, b AS PTR, c AS PTR, n AS I32) AS I32
PRINT HizliTopla(12, 30)
```

Dış çağrıda sırayı bozma: önce kaynak veya DLL adı, sonra çağrı biçimi, sonra parametreler, sonra dönüş tipi. `CDECL` ve `STDCALL` çağrı düzenidir; Windows API çoğunlukla `STDCALL`, C kütüphaneleri çoğunlukla `CDECL` ister. Yanlış çağrı düzeni, doğru fonksiyonu bile hatalı çalıştırabilir.

# 8. Tarayıcı, JS, WAT/WASM ve API köprüleri

Tarayıcı hedefi, uXBasic kaynağını web sayfasına taşır. JS çıktısı kullanıcı arayüzünü, WAT/WASM çıktısı hızlı hesap çekirdeğini, manifest varlık listesini, HTML kabuğu ise programın göründüğü yüzeyi kurar. `src(30.05_5)` içinde JS runtime, wasm loader, host import/export ve web coverage gate dosyaları bu hattın normal parçasıdır.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<canvas id="saha" width="640" height="360"></canvas>
<pre id="uxb-console"></pre>
%%HTML_END
%%JS_LINE "const c=document.getElementById('saha').getContext('2d');"
%%JS_LINE "c.fillText('uXBasic JS ciktisi',20,30);"

MAIN
    PRINT "Tarayici programi basladi"
END MAIN
```

```uxbasic
%%TARGET WASM
%%WAT_IMPORT "ux" "print_i32" "(func $ux_print_i32 (param i32))"
MAIN
    DIM toplam AS I32
    toplam = 0
    FOR i = 1 TO 100
        toplam = toplam + i
    NEXT i
    PRINT toplam
END MAIN
```

OpenAI/ChatGPT ile uzak model çağrısı için kitapta mantık şu şekilde verilir: API anahtarı kaynak kod içine gömülmez, ortam değişkeninden okunur; istek JSON olarak hazırlanır; yanıt JSON’dan çıkarılır; hata kodu kontrol edilir. OpenAI tarafında Responses API, model yanıtı üretmek için kullanılan ana API yüzeylerinden biridir. Gemini tarafında `generateContent` tek yanıtlı üretim, Interactions API ise daha ajanlı ve çok adımlı iş akışları için önerilen yeni yüzeydir.

```uxbasic
MODULE OpenAI
    DECLARE FUNCTION Response(model AS STRING, soru AS STRING) AS STRING
END MODULE

DIM yanit AS STRING
yanit = OpenAI.Response("gpt-5.2", "Bu saha verisindeki en riskli nokta nedir?")
PRINT yanit
```

```uxbasic
MODULE Gemini
    DECLARE FUNCTION Generate(model AS STRING, soru AS STRING) AS STRING
END MODULE

PRINT Gemini.Generate("gemini-3.5-flash", "Bu pH degerlerini yorumla")
```

```uxbasic
MODULE Llama
    DECLARE FUNCTION Ask(modelPath AS STRING, prompt AS STRING) AS STRING
END MODULE

DIM ozet AS STRING
ozet = Llama.Ask("models/yerel.gguf", "Kisa bir laboratuvar raporu yaz")
PRINT ozet
```

# 9. Bilimsel veri ve istatistik defteri

Bilimsel programda veri önce okunur, sonra temizlenir, sonra özetlenir, sonra test edilir. Z testi, örnek ortalamanın bilinen toplum ortalamasından ne kadar uzak olduğunu standart hata ile ölçer. F testi iki varyansın oranına bakar. T testi küçük örneklerde ortalama farkını değerlendirir. ANOVA [varyans çözümlemesi] üç veya daha fazla grubun ortalamalarını birlikte karşılaştırır. Bu testlerin gerçek bilimsel yorumu için varsayımlar, örnek büyüklüğü, dağılım ve deney tasarımı da düşünülmelidir.

```uxbasic
DIM x(1 TO 6) AS F64
x(1)=10.1: x(2)=10.4: x(3)=9.9: x(4)=10.2: x(5)=10.8: x(6)=10.3
DIM toplam AS F64
DIM ort AS F64
FOR i = 1 TO 6
    toplam = toplam + x(i)
NEXT i
ort = toplam / 6
PRINT "ortalama="; ort

DIM toplumOrt AS F64
toplumOrt = 10.0
DIM sigma AS F64
sigma = 0.5
DIM z AS F64
z = (ort - toplumOrt) / (sigma / SQRT(6))
PRINT "Z testi="; z
```

```uxbasic
DIM var1 AS F64
DIM var2 AS F64
DIM f AS F64
var1 = 2.40
var2 = 1.20
IF var1 >= var2 THEN
    f = var1 / var2
ELSE
    f = var2 / var1
END IF
PRINT "F orani="; f
IF f > 4 THEN PRINT "varyans farki buyuk olabilir" ELSE PRINT "varyanslar yakin" END IF
```

# 10. Eski dosyalardan yerleştirilen örnek defteri

Bu bölüm, önceki `pck` dosyalarında yazılmış ama tek kitap akışında kaybolmaması gereken örnekleri konu başlıklarına yerleştirir. Aynı örnek tekrar tekrar yazılmaz; benzer örnekler bir başlık altında tutulur.

## Ön-işleyici ve hedef seçimi

### Örnek 1

```text
.uxb kaynak
  -> ön-işleyici: %%DEFINE, %%INCLUDE, %%IF gibi satırları çözer
  -> sözcükleyici: PRINT, "metin", 123, + gibi tokenlar üretir
  -> ayrıştırıcı: PRINT_STMT, IF_STMT, CALL_DLL_STMT gibi AST düğümleri üretir
  -> anlam katmanı: değişken var mı, tip uyuyor mu, kapsam doğru mu bakar
  -> HIR ve düzen: sınıf, kayıt, alan, bellek düzeni bilgilerini çıkarır
  -> MIR: LOAD_CONST, STORE_VAR, PRINT, CALL_DLL gibi ara işlemler üretir
  -> doğrulayıcı: eksik hedef, bozuk düğüm, kırık yol var mı denetler
  -> çalışma zamanı veya hedef üretici: AST/MIR yorumlar, JS/WAT/x64 üretir
```

### Örnek 2

```uxbasic
%%DEFINE DEBUG 1
%%IF DEBUG
PRINT "Hata ayiklama acik"
%%ELSE
PRINT "Normal calisma"
%%ENDIF

%%MACRO KARE(X) ((X) * (X))
DIM a AS I32
a = KARE(7)
PRINT a
```

### Örnek 3

```uxbasic
%%DEFINE DEBUG 1

CONST N AS I32 = 5
DIM i AS I32
DIM x(1 TO N) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM enbuyuk AS F64

x(1) = 12.1
x(2) = 11.8
x(3) = 12.5
x(4) = 10.9
x(5) = 12.0

toplam = 0
enbuyuk = x(1)
FOR i = 1 TO N
    toplam += x(i)
    IF x(i) > enbuyuk THEN
        enbuyuk = x(i)
    END IF
NEXT
ort = toplam / N

OPEN "ozet.txt" FOR OUTPUT AS #1
PUT #1, 1, "Ortalama=" + STR(ort)
CLOSE #1

PRINT "Ortalama="; ort
PRINT "En buyuk="; enbuyuk
%%IF DEBUG
PRINT "DEBUG: N="; N
%%ENDIF
```

### Örnek 4

```uxbasic
%%SET APP = "SahaRaporu"
%%PROFILE WEB_DEBUG
%%HTML_BEGIN "index.html" BODY
<h1>{{APP}}</h1>
%%HTML_END
PRINT "Konsol raporu da uretildi"
```

### Örnek 5

```uxbasic
%%TARGET BROWSER
%%JS_LINE "console.log('uXBasic JS cikti calisti')"
PRINT "Bu kaynak JS ve HTML cikti uretebilir"
```

### Örnek 6

```uxbasic
%%DEFINE DEBUG
%%IF DEBUG
PRINT "test modu"
%%ENDIF
```

### Örnek 7

```uxbasic
%%SET APP_NAME = "Deneme"
%%MANIFEST_SET name = ${APP_NAME}
```

### Örnek 8

```uxbasic
%%ALIAS ...
```

### Örnek 9

```uxbasic
%%MACRO ...
```

### Örnek 10

```uxbasic
%%IF ...
```

### Örnek 11

```uxbasic
%%IFC ...
```

### Örnek 12

```uxbasic
%%FOR ...
```

### Örnek 13

```uxbasic
%%FOREACH ...
```

### Örnek 14

```uxbasic
%%REPEAT ...
```

### Örnek 15

```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
```

### Örnek 16

```uxbasic
%%OUTDIR ...
```

### Örnek 17

```uxbasic
%%SECTION ...
```

### Örnek 18

```uxbasic
%%JS_BEGIN ...
```

### Örnek 19

```uxbasic
%%JS_LINE console.log("uXBasic tarayici hazir");
```

### Örnek 20

```uxbasic
%%JS_FILE ...
```

### Örnek 21

```uxbasic
%%WAT_BEGIN ...
```

### Örnek 22

```uxbasic
%%WAT_IMPORT ux.print_i32 AS print_i32(i32)
```

### Örnek 23

```uxbasic
%%WAT_EXPORT ...
```

### Örnek 24

```uxbasic
%%WASM_HOST_JS_BEGIN ...
```

### Örnek 25

```uxbasic
%%HTML_BEGIN ...
```

### Örnek 26

```uxbasic
%%HTML_LINE <div id="app"></div>
```

### Örnek 27

```uxbasic
%%HTML_SCRIPT ...
```

### Örnek 28

```uxbasic
%%HTML_STYLE ...
```

### Örnek 29

```uxbasic
%%CSS_BEGIN ...
```

### Örnek 30

```uxbasic
%%CSS_LINE ...
```

_Bu konuda 95 benzer küçük örnek daha vardı; tekrar oluşturmamak için aynı mantığın farklı değerlerle uygulanacağı not edildi._

## Akış, döngü ve hata yakalama

### Örnek 1

```uxbasic
PRINT "Merhaba uXBasic"
DIM yas AS I32
yas = 18
IF yas >= 18 THEN
    PRINT "Program yazmaya baslayabilirsin"
ELSE
    PRINT "Once temel alistirma yap"
END IF
```

### Örnek 2

```uxbasic
DIM notu AS I32
notu = 72
IF notu >= 85 THEN
    PRINT "Pekiyi"
ELSEIF notu >= 60 THEN
    PRINT "Gecti"
ELSE
    PRINT "Kaldi"
END IF
```

### Örnek 3

```uxbasic
DIM i AS I32
DIM toplam AS I32
toplam = 0
FOR i = 1 TO 10 STEP 1
    toplam += i
NEXT
PRINT "1 den 10 a toplam="; toplam
```

### Örnek 4

```uxbasic
CONST LIMIT AS I32 = 5
DIM i AS I32
DIM kare AS I32

FUNCTION Hesapla(x AS I32) AS I32
    RETURN x * x
END FUNCTION

FOR i = 1 TO LIMIT
    kare = Hesapla(i)
    IF kare > 10 THEN
        PRINT "Buyuk kare: "; kare
    ELSE
        PRINT "Kucuk kare: "; kare
    END IF
NEXT
```

### Örnek 5

```uxbasic
DIM ad AS STRING
DIM satir AS STRING
ad = "rapor.txt"

OPEN ad FOR OUTPUT AS #1
PUT #1, 1, "uXBasic raporu"
CLOSE #1

OPEN ad FOR INPUT AS #1
GET #1, 1, satir
PRINT "Dosyadan gelen="; satir
CLOSE #1
```

### Örnek 6

```uxbasic
DIM a AS I32
DIM b AS I32
DIM c AS I32
a = 5
b = 2
c = (a + b) * 3
IF (c >= 20) AND (a <> b) THEN
    PRINT "Kosul saglandi"
END IF
```

### Örnek 7

```uxbasic
DIM bayrak AS U8
bayrak = 0
bayrak = bayrak OR 1      ' birinci ozelligi ac
bayrak = bayrak OR 4      ' ucuncu biti ac
IF (bayrak AND 4) <> 0 THEN
    PRINT "Ucuncu bit acik"
END IF
```

### Örnek 8

```uxbasic
DIM n AS I32
DIM i AS I32
DIM x(1 TO 5) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM fark AS F64
DIM varyans AS F64

n = 5
x(1) = 10.2
x(2) = 11.1
x(3) = 9.8
x(4) = 10.9
x(5) = 10.5

toplam = 0
FOR i = 1 TO n
    toplam += x(i)
NEXT
ort = toplam / n

varyans = 0
FOR i = 1 TO n
    fark = x(i) - ort
    varyans += fark * fark
NEXT
varyans = varyans / (n - 1)
PRINT "Ortalama="; ort
PRINT "Varyans="; varyans
```

### Örnek 9

```uxbasic
DIM ornekOrt AS F64
DIM toplumOrt AS F64
DIM sigma AS F64
DIM n AS F64
DIM z AS F64

ornekOrt = 10.50
toplumOrt = 10.00
sigma = 1.20
n = 25
z = (ornekOrt - toplumOrt) / (sigma / SQRT(n))
PRINT "Z degeri="; z
IF ABS(z) > 1.96 THEN
    PRINT "Yaklasik olarak %5 duzeyinde fark olabilir"
ELSE
    PRINT "Guclu fark gorunmuyor"
END IF
```

### Örnek 10

```uxbasic
DIM var1 AS F64
DIM var2 AS F64
DIM f AS F64
var1 = 2.40
var2 = 1.20
IF var1 >= var2 THEN
    f = var1 / var2
ELSE
    f = var2 / var1
END IF
PRINT "F orani="; f
IF f > 3.0 THEN
    PRINT "Varyanslar arasinda dikkat cekici fark olabilir"
ELSE
    PRINT "Varyans farki zayif gorunuyor"
END IF
```

### Örnek 11

```uxbasic
TRY
    OPEN "veri.txt" FOR INPUT AS #1
    PRINT "Dosya acildi"
CATCH hata
    PRINT "Dosya acilamadi"
FINALLY
    CLOSE #1
END TRY
```

### Örnek 12

```uxbasic
DIM toplam AS I32
FOR i = 1 TO 5
    toplam = toplam + i
NEXT i
IF toplam > 10 THEN PRINT "gecer" ELSE PRINT "kalir" END IF
```

### Örnek 13

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Gunluk sonuc"
PRINT #1, 42
CLOSE #1
```

### Örnek 14

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

### Örnek 15

```uxbasic
IF ph < 6.5 THEN PRINT "asit" ELSE PRINT "normal" END IF
```

### Örnek 16

```uxbasic
IF sicaklik > 30 THEN PRINT "fan ac"
```

### Örnek 17

```uxbasic
IF stok > 0 THEN PRINT "sat" ELSE PRINT "siparis ver" END IF
```

### Örnek 18

```uxbasic
IF notu>=85 THEN PRINT "AA" ELSEIF notu>=70 THEN PRINT "BB" ELSE PRINT "CC" END IF
```

### Örnek 19

```uxbasic
SELECT CASE secim
CASE 1: PRINT "basla"
CASE 2: PRINT "yardim"
END SELECT
```

### Örnek 20

```uxbasic
TRY
  OPEN "veri.csv" FOR INPUT AS #1
CATCH e
  PRINT "dosya acilamadi"
END TRY
```

### Örnek 21

```uxbasic
CATCH e: PRINT "hata: "; e
```

### Örnek 22

```uxbasic
FINALLY: CLOSE #1
```

### Örnek 23

```uxbasic
IF yas < 0 THEN THROW "yas negatif olamaz"
```

### Örnek 24

```uxbasic
ASSERT toplam >= 0
```

### Örnek 25

```uxbasic
FOR i = 1 TO 10 STEP 1
  PRINT i
NEXT i
```

### Örnek 26

```uxbasic
FOR gun = 1 TO 30: PRINT gun: NEXT gun
```

### Örnek 27

```uxbasic
FOR i = 10 TO 0 STEP -2: PRINT i: NEXT i
```

### Örnek 28

```uxbasic
DO WHILE EOF(1)=0
  INPUT #1, satir
LOOP
```

### Örnek 29

```uxbasic
DO WHILE pil > 20: PRINT pil: pil = pil - 1: LOOP
```

### Örnek 30

```uxbasic
IF hata THEN EXIT FOR
```

### Örnek 31

```uxbasic
FOR EACH ad IN isimler: PRINT ad: NEXT
```

### Örnek 32

```uxbasic
FOR EACH v IN olcumler: PRINT v: NEXT
```

### Örnek 33

```uxbasic
DIM toplam AS F64
DIM adet AS I32
FOR i = 1 TO 5 STEP 1
  INPUT olcum
  IF olcum < 0 THEN EXIT FOR ELSE toplam = toplam + olcum
  adet = adet + 1
NEXT i
IF adet > 0 THEN PRINT "ortalama="; toplam/adet ELSE PRINT "veri yok" END IF
```

### Örnek 34

```uxbasic
EVENT VeriGeldi
PIPE OlcumHatti AS F64
SLOT EkranaYaz ON VeriGeldi
  INPUT yeniDeger
  PRINT "yeni olcum="; yeniDeger
  OPEN "olcum.log" FOR APPEND AS #1
  PRINT #1, STR(TIMER()) + ";" + STR(yeniDeger)
  CLOSE #1
END SLOT
TRIGGER VeriGeldi
```

### Örnek 35

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
  IF hz < 37 THEN RETURN FALSE
  sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
  IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE END IF
END FUNCTION
IF UyariSesi(880, 150) THEN PRINT "ses verildi" ELSE PRINT "ses hatasi" END IF
```

### Örnek 36

```uxbasic
CLASS Olcum
  PUBLIC PROPERTY Ad AS STRING
  PRIVATE PROPERTY Deger AS F64
  CONSTRUCTOR(a AS STRING, d AS F64)
    Ad = a: Deger = d
  END CONSTRUCTOR
  METHOD GecerliMi() AS BOOLEAN
    IF Deger >= 0 THEN RETURN TRUE ELSE RETURN FALSE END IF
  END METHOD
END CLASS
DIM o AS Olcum = NEW Olcum("pH", 7.2)
IF o.GecerliMi() THEN PRINT "gecerli"
```

### Örnek 37

```uxbasic
CONST MAX_SATIR AS I32 = 1000
DIM satirSayisi AS I32
DIM ph AS F64
DIM etiket AS STRING
DIM hassas AS BIGD(80)
etiket = "deneme-1"
ph = 7.15
IF ph >= 6.5 AND ph <= 8.5 THEN PRINT etiket; " uygun"
```

### Örnek 38

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
```

### Örnek 39

```uxbasic
CLS
COLOR 10, 0
LOCATE 1, 1: PRINT "Rapor hazirlaniyor"
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "baslik;deger"
PRINT #1, "ph;7.2"
CLOSE #1
PRINT "rapor yazildi"
```

### Örnek 40

```uxbasic
IF (yas > 18) AND TRUE THEN PRINT "kontrol"
```

### Örnek 41

```uxbasic
IF (yas > 18) OR TRUE THEN PRINT "kontrol"
```

### Örnek 42

```uxbasic
IF (yas > 18) XOR TRUE THEN PRINT "kontrol"
```

### Örnek 43

```uxbasic
IF (yas > 18) MOD TRUE THEN PRINT "kontrol"
```

### Örnek 44

```uxbasic
IF (yas > 18) SHL TRUE THEN PRINT "kontrol"
```

### Örnek 45

```uxbasic
IF (yas > 18) SHR TRUE THEN PRINT "kontrol"
```

_Bu konuda 71 benzer küçük örnek daha vardı; tekrar oluşturmamak için aynı mantığın farklı değerlerle uygulanacağı not edildi._

## Yordam, modül ve dış çağrı

### Örnek 1

```uxbasic
FUNCTION Kare(x AS F64) AS F64
    RETURN x * x
END FUNCTION

SUB Baslik(yazi AS STRING)
    PRINT "==== "; yazi; " ===="
END SUB

Baslik("Deneme")
PRINT Kare(5)
```

### Örnek 2

```uxbasic
CALL(DLL, "KERNEL32.DLL", "GetTickCount", U64)
CALL(DLL, "USER32.DLL", "MessageBoxA", I32, STDCALL, 0, "Merhaba", "Baslik", 0)
```

### Örnek 3

```uxbasic
IMPORT(C, "native/hizli_hesap.c")
IMPORT(CPP, "native/matris.cpp")
IMPORT(ASM, "native/hizli_rutin.asm")

DECLARE FUNCTION HizliTopla(a AS I32, b AS I32) AS I32
PRINT HizliTopla(3, 4)
```

### Örnek 4

```uxbasic
NAMESPACE Matematik
    FUNCTION IkiKat(x AS I32) AS I32
        RETURN x * 2
    END FUNCTION
END NAMESPACE

USING Matematik
ALIAS IK = Matematik.IkiKat
PRINT IK(21)
```

### Örnek 5

```uxbasic
MODULE Ag
    DECLARE FUNCTION HttpPost(url AS STRING, body AS STRING) AS STRING
END MODULE

DIM cevap AS STRING
cevap = Ag.HttpPost("http://127.0.0.1:5000/tahmin", "{"x":42}")
PRINT cevap
```

### Örnek 6

```uxbasic
MODULE Curl
    DECLARE FUNCTION PostJson(url AS STRING, json AS STRING) AS STRING
END MODULE

DIM sonuc AS STRING
sonuc = Curl.PostJson("http://127.0.0.1:8000/api", "{"soru":"merhaba"}")
PRINT sonuc
```

### Örnek 7

```uxbasic
MODULE YerelZeka
    DECLARE FUNCTION Sor(model AS STRING, soru AS STRING) AS STRING
END MODULE

DIM yanit AS STRING
yanit = YerelZeka.Sor("yerel-model", "Bu veride aykiri deger var mi?")
PRINT yanit
```

### Örnek 8

```powershell
rg -n "GENERATED_PLACEHOLDER|placeholder|ensure_declared_outputs" uxb/tools/control
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim25_26_27_close_gates.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

### Örnek 9

```uxbasic
FUNCTION Kare(x AS F64) AS F64
    RETURN x * x
END FUNCTION
DIM alan AS F64
alan = Kare(12.5)
PRINT alan
```

### Örnek 10

```uxbasic
SUB Selam(): PRINT "merhaba": END SUB
```

### Örnek 11

```uxbasic
FUNCTION IkiKat(x AS I32) AS I32
  RETURN x*2
END FUNCTION
```

### Örnek 12

```uxbasic
GOSUB YazBaslik
```

### Örnek 13

```uxbasic
SUB BaslikYaz(): PRINT "RAPOR": END SUB
```

### Örnek 14

```uxbasic
FUNCTION Kare(x AS F64) AS F64
  RETURN x*x
END FUNCTION
```

### Örnek 15

```uxbasic
DECLARE FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (BYVAL hwnd AS PTR, BYVAL text AS STRING, BYVAL title AS STRING, BYVAL tip AS I32) AS I32
```

### Örnek 16

```uxbasic
SUB Artir(BYREF x AS I32): x = x + 1: END SUB
```

### Örnek 17

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
```

### Örnek 18

```uxbasic
DECLARE CDECL FUNCTION sin LIB "msvcrt.dll" ALIAS "sin" (BYVAL x AS F64) AS F64
```

### Örnek 19

```uxbasic
DECLARE STDCALL FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (...) AS I32
```

### Örnek 20

```uxbasic
FRIEND MODULE Testler
```

### Örnek 21

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
```

### Örnek 22

```uxbasic
IMPORT(C,"runtime/hizli.c")
```

### Örnek 23

```uxbasic
NAMESPACE Lab
  SUB Yaz(): PRINT "lab": END SUB
END NAMESPACE
```

### Örnek 24

```uxbasic
MODULE Rapor
  SUB Baslik(): PRINT "RAPOR": END SUB
END MODULE
```

### Örnek 25

```uxbasic
USING MODULE uxstats
```

### Örnek 26

```uxbasic
ALIAS ORT AS uxstats.mean
```

### Örnek 27

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
IMPORT(C, "runtime_ext/kucuk_hizlandirici.c")
NAMESPACE Lab
  ALIAS ORT AS uxstats_mean_f64
  SUB RaporYaz()
    PRINT "Laboratuvar raporu"
  END SUB
END NAMESPACE
USING NAMESPACE Lab
CALL RaporYaz()
```

### Örnek 28

```uxbasic
' SUB komutu bağlama göre kullanılır
```

### Örnek 29

```uxbasic
' FUNCTION komutu bağlama göre kullanılır
```

### Örnek 30

```uxbasic
' DECLARE komutu bağlama göre kullanılır
```

### Örnek 31

```uxbasic
' GOSUB komutu bağlama göre kullanılır
```

### Örnek 32

```uxbasic
CALL(DLL, "user32.dll", "MessageBeep", 0)
```

### Örnek 33

```uxbasic
IMPORT(C, "src/native/hizli_toplam.c")
```

### Örnek 34

```uxbasic
' NAMESPACE komutu bağlama göre kullanılır
```

### Örnek 35

```uxbasic
' MODULE komutu bağlama göre kullanılır
```

### Örnek 36

```uxbasic
' USING komutu bağlama göre kullanılır
```

### Örnek 37

```uxbasic
' ALIAS komutu bağlama göre kullanılır
```

### Örnek 38

```basic
CALL Topla(3,4)
CALL(DLL, "kernel32.dll", "Beep", 750, 300)
```

### Örnek 39

```basic
GOSUB etiket
```

### Örnek 40

```basic
EXIT FOR|DO|SUB|FUNCTION
```

### Örnek 41

```basic
END [IF|SELECT|TYPE|CLASS|NAMESPACE|MODULE]
```

### Örnek 42

```basic
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32
```

### Örnek 43

```basic
SUB ad(parametreler) ... END SUB
```

### Örnek 44

```basic
FUNCTION ad(parametreler) AS tip ... END FUNCTION
```

### Örnek 45

```basic
NAMESPACE Ad ... END NAMESPACE
```

_Bu konuda 100 benzer küçük örnek daha vardı; tekrar oluşturmamak için aynı mantığın farklı değerlerle uygulanacağı not edildi._

## Dosya, dizin ve rapor üretimi

### Örnek 1

```uxbasic
CLOSE #1
```

### Örnek 2

```uxbasic
GET #1, 1, b
```

### Örnek 3

```uxbasic
PUT #1, 1, b
```

### Örnek 4

```uxbasic
sonuc = LOF(#no)
PRINT sonuc
```

### Örnek 5

```uxbasic
sonuc = EOF(#no)
PRINT sonuc
```

### Örnek 6

```uxbasic
sonuc = SIZEOF(Tip|degisken)
PRINT sonuc
```

### Örnek 7

```uxbasic
' OPEN komutu bağlama göre kullanılır
```

### Örnek 8

```uxbasic
' CLOSE komutu bağlama göre kullanılır
```

### Örnek 9

```uxbasic
PRINT LOF(deger)
```

### Örnek 10

```uxbasic
PRINT EOF(deger)
```

### Örnek 11

```uxbasic
PRINT SIZEOF(deger)
```

### Örnek 12

```basic
PRINT LOF(10)
```

### Örnek 13

```basic
PRINT EOF(10)
```

### Örnek 14

```basic
PRINT SIZEOF(10)
```

## Olay, boru, iş parçacığı ve yuva

### Örnek 1

```uxbasic
EVENT TusBasildi(kod AS I32)

SLOT EkranaYaz(kod AS I32)
    PRINT "Tus kodu="; kod
END SLOT

ON EkranaYaz
TRIGGER TusBasildi(65)
OFF EkranaYaz
```

### Örnek 2

```uxbasic
EVENT VeriGeldi
SLOT EkranaYaz ON VeriGeldi
  PRINT "veri geldi"
END SLOT
```

### Örnek 3

```uxbasic
THREAD ArkaPlan
  PRINT "uzun is"
END THREAD
```

### Örnek 4

```uxbasic
PARALEL Hesaplar
  CALL OrtalamaAl()
  CALL GrafikHazirla()
END PARALEL
```

### Örnek 5

```uxbasic
PIPE Olcumler AS F64
```

### Örnek 6

```uxbasic
SLOT Kaydet ON VeriGeldi
  PRINT "kaydedildi"
END SLOT
```

### Örnek 7

```uxbasic
SLOT Tiklama ON ButonTiklandi
```

### Örnek 8

```uxbasic
TRIGGER VeriGeldi, 42
```

### Örnek 9

```uxbasic
' EVENT komutu bağlama göre kullanılır
```

### Örnek 10

```uxbasic
' THREAD komutu bağlama göre kullanılır
```

### Örnek 11

```uxbasic
' PARALEL komutu bağlama göre kullanılır
```

### Örnek 12

```uxbasic
' PIPE komutu bağlama göre kullanılır
```

### Örnek 13

```uxbasic
' SLOT komutu bağlama göre kullanılır
```

### Örnek 14

```uxbasic
' ON komutu bağlama göre kullanılır
```

### Örnek 15

```uxbasic
' TRIGGER komutu bağlama göre kullanılır
```

### Örnek 16

```basic
EVENT VeriGeldi(deger AS I32)
SLOT Yaz(deger AS I32)
ON VeriGeldi CALL Yaz
TRIGGER VeriGeldi(42)
```

### Örnek 17

```basic
THREAD Hesapla(1000)
PRINT "Ana is devam ediyor"
```

### Örnek 18

```basic
PARALEL ... END PARALEL
```

### Örnek 19

```basic
PIPE sensorVerisi TO analizci
```

### Örnek 20

```basic
SLOT ad(parametreler)
```

### Örnek 21

```basic
ON eventAdi CALL slotAdi
```

### Örnek 22

```basic
OFF eventAdi
```

### Örnek 23

```basic
TRIGGER eventAdi(args)
```

### Örnek 24

```uxbasic
EVENT VeriGeldi
PIPE OlcumAkisi AS F64
SLOT Yazdir ON VeriGeldi
    DIM v AS F64
    v = PIPE.READ(OlcumAkisi)
    PRINT "Yeni olcum="; v
END SLOT
PIPE.WRITE OlcumAkisi, 7.42
TRIGGER VeriGeldi
```

### Örnek 25

```uxbasic
EVENT YeniOlcum
SLOT Yazdir ON YeniOlcum
    PRINT "Yeni olcum geldi"
END SLOT
TRIGGER YeniOlcum
```

### Örnek 26

```uxbasic
PIPE OlcumBoru AS STRING
THREAD Uretici
    PIPE.WRITE OlcumBoru, "ph=7.8"
END THREAD
THREAD Tuketici
    DIM gelen AS STRING
    gelen = PIPE.READ(OlcumBoru)
    PRINT gelen
END THREAD
```

### Örnek 27

```uxbasic
PARALEL
    CALL HesaplaOrtalama()
    CALL HesaplaSapma()
    CALL RaporHazirla()
END PARALEL
PRINT "Uc is birlikte planlandi"
```

### Örnek 28

```basic
EVENT OlcumGeldi(tank AS I32, deger AS F64)

SLOT OlcumuYaz(tank AS I32, deger AS F64)
    PRINT "Tank=" + STR(tank) + " Deger=" + STR(deger)
END SLOT

ON OlcumGeldi CALL OlcumuYaz
TRIGGER OlcumGeldi(3, 7.25)
```

### Örnek 29

```basic
PIPE HamVeri TO Temizleyici
THREAD Temizleyici()
PARALEL
    CALL SensorOku()
    CALL AnalizYap()
END PARALEL
```

### Örnek 30

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

## Veri yapıları ve çok boyutlu diziler

### Örnek 1

```uxbasic
DIM fiyat AS F64
DIM adet AS I32
DIM toplam AS F64
fiyat = 12.5
adet = 4
toplam = fiyat * adet
PRINT "Toplam="; toplam
```

### Örnek 2

```uxbasic
DIM adres AS U64
DIM deger AS U8
adres = 1024
deger = 65
POKEB adres, deger
PRINT "Bellege bayt yazildi"
```

### Örnek 3

```uxbasic
DIM sayac AS I32
DIM uzunluk AS U64
DIM sicaklik AS F64
DIM ad AS STRING
DIM dogruMu AS BOOLEAN

sayac = 10
uzunluk = 2048
sicaklik = 24.75
ad = "deney-1"
dogruMu = sayac > 0
PRINT ad; " sicaklik="; sicaklik
```

### Örnek 4

```uxbasic
TYPE Olcum
    zaman AS F64
    sicaklik AS F64
    ph AS F64
END TYPE

DIM o AS Olcum
o.zaman = TIMER()
o.sicaklik = 25.1
o.ph = 7.8
PRINT "pH="; o.ph
```

### Örnek 5

```uxbasic
DIM ham AS STRING
DIM temiz AS STRING
DIM sayi AS F64
ham = "  42.50  "
temiz = LTRIM(RTRIM(ham))
sayi = VAL(temiz)
PRINT "Karekoku="; SQRT(sayi)
PRINT "Buyuk harf="; UCASE("uxbasic")
```

### Örnek 6

```uxbasic
PRINT "Tarayici konsoluna merhaba"
DIM x AS I32
x = 10
PRINT x * 2
```

### Örnek 7

```uxbasic
DIM adet AS I32
adet = 5
PRINT "Adet="; adet
```

### Örnek 8

```uxbasic
DIM a AS I32
DIM b AS I32
a = 7
b = a * 3 + 1
PRINT b
```

### Örnek 9

```uxbasic
DIM s AS Sensor = NEW Sensor(12.5)
```

### Örnek 10

```uxbasic
MUTABLE Cache AS DICT
```

### Örnek 11

```uxbasic
DIM toplam AS F64
toplam = 0
```

### Örnek 12

```uxbasic
REDIM olcum(100)
```

### Örnek 13

```uxbasic
DIM yas AS I32
```

### Örnek 14

```uxbasic
DIM deger AS BYTE
PRINT deger
```

### Örnek 15

```uxbasic
DIM deger AS I8
PRINT deger
```

### Örnek 16

```uxbasic
DIM deger AS U8
PRINT deger
```

### Örnek 17

```uxbasic
DIM deger AS I16
PRINT deger
```

### Örnek 18

```uxbasic
DIM deger AS U16
PRINT deger
```

### Örnek 19

```uxbasic
DIM deger AS I32
PRINT deger
```

### Örnek 20

```uxbasic
DIM deger AS U32
PRINT deger
```

### Örnek 21

```uxbasic
DIM deger AS I64
PRINT deger
```

### Örnek 22

```uxbasic
DIM deger AS U64
PRINT deger
```

### Örnek 23

```uxbasic
DIM deger AS F32
PRINT deger
```

### Örnek 24

```uxbasic
DIM deger AS F64
PRINT deger
```

### Örnek 25

```uxbasic
DIM deger AS F80
PRINT deger
```

### Örnek 26

```uxbasic
DIM deger AS F128
PRINT deger
```

### Örnek 27

```uxbasic
DIM deger AS BIGF
PRINT deger
```

### Örnek 28

```uxbasic
DIM deger AS BIGD
PRINT deger
```

### Örnek 29

```uxbasic
DIM deger AS BALL
PRINT deger
```

### Örnek 30

```uxbasic
DIM deger AS BOOLEAN
PRINT deger
```

### Örnek 31

```uxbasic
DIM deger AS STRING
PRINT deger
```

### Örnek 32

```uxbasic
DIM deger AS OBJECT
PRINT deger
```

### Örnek 33

```uxbasic
DIM deger AS PTR
PRINT deger
```

### Örnek 34

```uxbasic
DIM deger AS STRPTR
PRINT deger
```

### Örnek 35

```uxbasic
DIM deger AS ARRAY
PRINT deger
```

### Örnek 36

```uxbasic
DIM deger AS LIST
PRINT deger
```

### Örnek 37

```uxbasic
DIM deger AS DICT
PRINT deger
```

### Örnek 38

```uxbasic
DIM deger AS SET
PRINT deger
```

### Örnek 39

```uxbasic
DEFINT A-Z
DIM sayac
```

### Örnek 40

```uxbasic
DEFLNG A-Z
DIM sayac
```

### Örnek 41

```uxbasic
DEFSNG A-Z
DIM sayac
```

### Örnek 42

```uxbasic
DEFDBL A-Z
DIM sayac
```

### Örnek 43

```uxbasic
DEFEXT A-Z
DIM sayac
```

### Örnek 44

```uxbasic
DEFSTR A-Z
DIM sayac
```

### Örnek 45

```uxbasic
DEFBYT A-Z
DIM sayac
```

_Bu konuda 96 benzer küçük örnek daha vardı; tekrar oluşturmamak için aynı mantığın farklı değerlerle uygulanacağı not edildi._

## Tarayıcı, JS, WAT/WASM ve API

### Örnek 1

```uxbasic
' Derleyici içi düşünce örneği
UXB_AST_HOOK_STAGE("ParseProgram basladi")
UXB_MIR_HOOK_STAGE("PRINT_STMT MIR'e indiriliyor")
UXB_CODEGEN_HOOK_STAGE("JS backend program.js yaziyor")
```

### Örnek 2

```powershell
uxb <fiil> kaynak.uxb [seçenekler]
uxb ast oyun.uxb --ast-json-out out/ast.json
uxb jsw webdemo.uxb --emit-js --json-out out/js_report.json
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

### Örnek 3

```uxbasic
RESTRICTED token AS STRING
```

### Örnek 4

```uxbasic
' RESTRICTED komutu bağlama göre kullanılır
```

### Örnek 5

```uxbasic
' Flask tarafinda Python dosyasi fikri:
' from flask import Flask, jsonify
' app = Flask(__name__)
' @app.get("/olcum")
' def olcum(): return jsonify({"ph":7.8,"sicaklik":24.1})
```

### Örnek 6

```powershell
uxb lex main.uxb --tokens-json-out out/tokens.json
uxb ast main.uxb --ast-json-out out/ast.json
uxb mir main.uxb --mir-full-json-out out/mir.json
uxb jsw main.uxb --js-out dist/web/program.js --html-out dist/web/index.html
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
```

### Örnek 7

```python
from flask import Flask, jsonify, request
app = Flask(__name__)
@app.get('/olcum')
def olcum():
    return jsonify({'ph': 7.82, 'sicaklik': 24.4, 'oksijen': 6.8})
@app.post('/ztest')
def ztest():
    data = request.get_json()
    return jsonify({'z': 1.96, 'p': 0.049})
app.run(port=5000)
```

### Örnek 8

```text
dist/web/program.js
index.html
runtime/browser/ux_runtime.js
```

### Örnek 9

```powershell
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

### Örnek 10

```python
from flask import Flask, request, jsonify
app = Flask(__name__)

@app.post('/topla')
def topla():
    data = request.json
    return jsonify({'sonuc': data['a'] + data['b']})

app.run(port=5050)
```

## İstatistik, matematik ve bilimsel analiz

### Örnek 1

```uxbasic
OFF VeriGeldi
```

### Örnek 2

```uxbasic
sonuc = TIMER()
PRINT sonuc
```

### Örnek 3

```uxbasic
sonuc = SQRT(x)
PRINT sonuc
```

### Örnek 4

```uxbasic
sonuc = SIN(x)
PRINT sonuc
```

### Örnek 5

```uxbasic
sonuc = COS(x)
PRINT sonuc
```

### Örnek 6

```uxbasic
sonuc = RND()
PRINT sonuc
```

### Örnek 7

```uxbasic
' OFF komutu bağlama göre kullanılır
```

### Örnek 8

```uxbasic
PRINT TIMER(deger)
```

### Örnek 9

```uxbasic
PRINT SQRT(deger)
```

### Örnek 10

```uxbasic
PRINT SIN(deger)
```

### Örnek 11

```uxbasic
PRINT COS(deger)
```

### Örnek 12

```uxbasic
PRINT RND(deger)
```

### Örnek 13

```basic
INPUTF "%d", sayi
```

### Örnek 14

```basic
RANDOMIZE TIMER
PRINT RND()
```

### Örnek 15

```basic
PRINT TIMER(10)
```

### Örnek 16

```basic
PRINT SQRT(10)
```

### Örnek 17

```basic
PRINT SIN(10)
```

### Örnek 18

```basic
PRINT RND(10)
```

## Diğer kısa örnekler

### Örnek 1

```uxbasic
CLASS Sayac
PRIVATE
    deger AS I32
PUBLIC
    CONSTRUCTOR()
        deger = 0
    END CONSTRUCTOR
    METHOD Artir()
        deger += 1
    END METHOD
    PROPERTY Deger AS I32
        GET
            RETURN deger
        END GET
    END PROPERTY
END CLASS
```

### Örnek 2

```text
6105 EMIT hatası: Kod üretici çıktı yazamadı.
6109 FILE hatası: Dosya yolu, izin veya yazma sorunu var.
```

### Örnek 3

```uxbasic
CASE IS > 100: PRINT "buyuk"
```

### Örnek 4

```uxbasic
CASE IS <= 0: PRINT "gecersiz"
```

### Örnek 5

```uxbasic
NEXT i
```

### Örnek 6

```uxbasic
LOOP UNTIL tus = "Q"
```

### Örnek 7

```uxbasic
LOOP UNTIL cevap = "EVET"
```

### Örnek 8

```uxbasic
GOTO Temizle
```

### Örnek 9

```uxbasic
THREAD EskiYazim
  PRINT "uyumlu is"
END THREAD
```

### Örnek 10

```uxbasic
CALL BaslikYaz()
```

### Örnek 11

```uxbasic
TYPE Nokta
  x AS F64
  y AS F64
END TYPE
```

### Örnek 12

```uxbasic
CLASS Sensor
  PROPERTY Deger AS F64
END CLASS
```

### Örnek 13

```uxbasic
INTERFACE Okunur
  METHOD Oku() AS F64
END INTERFACE
```

### Örnek 14

```uxbasic
CLASS Sensor IMPLEMENTS Okunur
```

### Örnek 15

```uxbasic
METHOD Oku() AS F64: RETURN Deger: END METHOD
```

### Örnek 16

```uxbasic
MAGIC __str__() AS STRING
```

### Örnek 17

```uxbasic
MAGIC ToString() AS STRING
```

### Örnek 18

```uxbasic
VIRTUAL METHOD Ciz()
```

### Örnek 19

```uxbasic
OVERRIDE METHOD Ciz()
```

### Örnek 20

```uxbasic
CONSTRUCTOR(v AS F64): Deger=v: END CONSTRUCTOR
```

### Örnek 21

```uxbasic
DESTRUCTOR(): PRINT "kapanis": END DESTRUCTOR
```

### Örnek 22

```uxbasic
DELETE s
```

### Örnek 23

```uxbasic
ABSTRACT CLASS Sekil
```

### Örnek 24

```uxbasic
FINAL METHOD Kimlik() AS STRING
```

### Örnek 25

```uxbasic
SEALED CLASS Ayar
```

### Örnek 26

```uxbasic
STATIC Sayac AS I32
```

### Örnek 27

```uxbasic
PROPERTY Ad AS STRING
```

### Örnek 28

```uxbasic
OPERATOR +(a AS Vektor, b AS Vektor)
```

### Örnek 29

```uxbasic
MIXIN Loglanabilir
```

### Örnek 30

```uxbasic
DECORATOR ZamanOlc
```

_Bu konuda 236 benzer küçük örnek daha vardı; tekrar oluşturmamak için aynı mantığın farklı değerlerle uygulanacağı not edildi._

# 11. Kaynak gerçekliği tabloları

Aşağıdaki tablolar doğrudan `src(30.05_5)` dosya adları, komut satırı seçenekleri, servis kataloğu ve işlev adlarından derlenmiş yardımcı haritalardır. Bunlar öğrenme için değil, geliştiriciye hızlı yön buldurmak için konmuştur.

## AST düğüm aileleri

| No | AST düğümü |
| --- | --- |
| 1 | ALIAS_STMT |
| 2 | ALIAS_TARGET |
| 3 | ASSERT_STMT |
| 4 | ASSIGN_STMT |
| 5 | BINARY |
| 6 | BLOCK |
| 7 | BOOLEAN |
| 8 | CALL_EXPR |
| 9 | CALL_STMT |
| 10 | CASE_BLOCK |
| 11 | CASE_ELSE |
| 12 | CASE_IS_VALUE |
| 13 | CAST_EXPR |
| 14 | CATCH_PART |
| 15 | CLASS_ACCESS |
| 16 | CLASS_BASE_REF |
| 17 | CLASS_CONSTRUCTOR_DECL |
| 18 | CLASS_DECORATOR_REF |
| 19 | CLASS_DESTRUCTOR_DECL |
| 20 | CLASS_FIELD |
| 21 | CLASS_FIELD_FLAG |
| 22 | CLASS_FLAG |
| 23 | CLASS_FRIEND_STMT |
| 24 | CLASS_IMPLEMENTS_REF |
| 25 | CLASS_METHOD_DECL |
| 26 | CLASS_METHOD_FLAG |
| 27 | CLASS_MIXIN_REF |
| 28 | CLASS_OPERATOR_DECL |
| 29 | CLASS_PROPERTY_DECL |
| 30 | CLASS_PROPERTY_FLAG |
| 31 | CLASS_PROPERTY_GET_STMT |
| 32 | CLASS_PROPERTY_SET_STMT |
| 33 | CLASS_STMT |
| 34 | CLOSE_STMT |
| 35 | CLS_STMT |
| 36 | COLOR_STMT |
| 37 | CONST_DECL |
| 38 | CONST_STMT |
| 39 | DECLARE_FUNCTION_STMT |
| 40 | DECLARE_SUB_STMT |
| 41 | DEFTYPE_STMT |
| 42 | DELETE_STMT |
| 43 | DIM_BOUNDS |
| 44 | DIM_DECL |
| 45 | DIM_STMT |
| 46 | DO_EACH_STMT |
| 47 | DO_STMT |
| 48 | EACH_BODY |
| 49 | EACH_ITEMS |
| 50 | ELSEIF_PART |
| 51 | ELSE_PART |
| 52 | END_STMT |
| 53 | EVENT_STMT |
| 54 | EXIT_STMT |
| 55 | EXPR_STMT |
| 56 | FIELD_EXPR |
| 57 | FINALLY_PART |
| 58 | FOR_EACH_STMT |
| 59 | FOR_STMT |
| 60 | FRIEND_ITEM |
| 61 | FUNCTION_STMT |
| 62 | GET_STMT |
| 63 | GOSUB_STMT |
| 64 | GOTO_STMT |
| 65 | IDENTIFIER |
| 66 | IF_STMT |
| 67 | IMPORT_STMT |
| 68 | INCDEC_EXPR |
| 69 | INCDEC_STMT |
| 70 | INCLUDE_STMT |
| 71 | INDEX_EXPR |
| 72 | INIT_EXPR |
| 73 | INLINE_STMT |
| 74 | INPUTF_STMT |
| 75 | INPUT_FILE_STMT |
| 76 | INPUT_STMT |
| 77 | INTERFACE_METHOD_DECL |
| 78 | INTERFACE_STMT |
| 79 | KEYWORD_REF |
| 80 | LABEL_STMT |
| 81 | LOCATE_STMT |
| 82 | MAIN_STMT |
| 83 | MEMBER_EXPR |
| 84 | MEMCOPYB_STMT |
| 85 | MEMCOPYD_STMT |
| 86 | MEMCOPYW_STMT |
| 87 | MEMFILLB_STMT |
| 88 | MEMFILLD_STMT |
| 89 | MEMFILLW_STMT |
| 90 | MODE_REF |
| 91 | MODULE_STMT |
| 92 | NAMESPACE_STMT |
| 93 | NEW_EXPR |
| 94 | NUMBER |
| 95 | OPEN_STMT |
| 96 | PARALEL_STMT |
| 97 | PARAM_DECL |
| 98 | PIPE_STMT |
| 99 | POKEB_STMT |
| 100 | POKED_STMT |
| 101 | POKES_STMT |
| 102 | POKEW_STMT |
| 103 | PRINT_FILE_STMT |
| 104 | PRINT_ITEM |
| 105 | PRINT_STMT |
| 106 | PROGRAM |
| 107 | PROMPT_EXPR |
| 108 | PUT_STMT |
| 109 | RANDOMIZE_STMT |
| 110 | RANGE_EXPR |
| 111 | REDIM_DECL |
| 112 | REDIM_STMT |
| 113 | RETURN_STMT |
| 114 | RETURN_TYPE |
| 115 | SEEK_STMT |
| 116 | SELECT_STMT |
| 117 | SETNEWOFFSET_STMT |
| 118 | SETSTRINGSIZE_STMT |
| 119 | SIZEOF_EXPR |
| 120 | SLOT_CONTROL_STMT |
| 121 | SLOT_HEADER_ARGS |
| 122 | SLOT_STMT |
| 123 | STRING |
| 124 | SUB_STMT |
| 125 | TERNARY_EXPR |
| 126 | THREAD_STMT |
| 127 | THROW_STMT |
| 128 | TRIGGER_STMT |
| 129 | TRY_BODY |
| 130 | TRY_STMT |
| 131 | TYPE_FIELD |
| 132 | TYPE_REF |
| 133 | TYPE_STMT |
| 134 | UNARY |
| 135 | USING_ITEM |
| 136 | USING_STMT |

## MIR ve çıktı hattı adları

| No | İşlem/ad |
| --- | --- |
| 1 | ARRAY |
| 2 | ASSERT_STMT |
| 3 | BIN |
| 4 | BINARY |
| 5 | CALL |
| 6 | CALL_API |
| 7 | CALL_DLL |
| 8 | CALL_EXPR |
| 9 | CALL_STMT |
| 10 | CALL_USER |
| 11 | CLASS_CONSTRUCTOR_DECL |
| 12 | CLASS_FIELD |
| 13 | CLASS_FIELD_FLAG |
| 14 | CONST |
| 15 | CONSTRUCTOR |
| 16 | CONST_DECL |
| 17 | CONST_STMT |
| 18 | FIELD_EXPR |
| 19 | IMPORT_STMT |
| 20 | LOAD_CONST |
| 21 | LOAD_FIELD |
| 22 | LOAD_INDEXED |
| 23 | LOAD_VAR |
| 24 | LOWER_TO_BROWSER_CALL |
| 25 | LOWER_TO_MIR |
| 26 | LOWER_TO_RUNTIME_CALL |
| 27 | MEMBER_EXPR |
| 28 | MEMCOPY |
| 29 | MEMCOPYB |
| 30 | MEMCOPYB_STMT |
| 31 | MEMCOPYD |
| 32 | MEMCOPYD_STMT |
| 33 | MEMCOPYW |
| 34 | MEMCOPYW_STMT |
| 35 | MEMFILL |
| 36 | MEMFILLB |
| 37 | MEMFILLB_STMT |
| 38 | MEMFILLD |
| 39 | MEMFILLD_STMT |
| 40 | MEMFILLW |
| 41 | MEMFILLW_STMT |
| 42 | MEMORY |
| 43 | MIR |
| 44 | MIR_ |
| 45 | MIR_ABS |
| 46 | MIR_ADD |
| 47 | MIR_ADDR_OF |
| 48 | MIR_ADD_ASSIGN |
| 49 | MIR_AND |
| 50 | MIR_AND_ASSIGN |
| 51 | MIR_ARITH |
| 52 | MIR_ARRAY_LOAD |
| 53 | MIR_ARRAY_NEW |
| 54 | MIR_ARRAY_STORE |
| 55 | MIR_ASC |
| 56 | MIR_ASSERT |
| 57 | MIR_ATN |
| 58 | MIR_BAND |
| 59 | MIR_BIGINIT |
| 60 | MIR_BIN |
| 61 | MIR_BNOT |
| 62 | MIR_BOR |
| 63 | MIR_BREAK |
| 64 | MIR_BROKEN_NODE |
| 65 | MIR_BROWSER_CALL |
| 66 | MIR_BUILTIN |
| 67 | MIR_BXOR |
| 68 | MIR_CALL |
| 69 | MIR_CALL_API |
| 70 | MIR_CALL_BUILTIN |
| 71 | MIR_CALL_DLL |
| 72 | MIR_CALL_EXTERNAL |
| 73 | MIR_CALL_RUNTIME |
| 74 | MIR_CASE |
| 75 | MIR_CASE_ELSE |
| 76 | MIR_CAST |
| 77 | MIR_CATCH_BEGIN |
| 78 | MIR_CDBL |
| 79 | MIR_CHR |
| 80 | MIR_CINT |
| 81 | MIR_CLASS_DECL |
| 82 | MIR_CLNG |
| 83 | MIR_CLS |
| 84 | MIR_CODEPTR |
| 85 | MIR_COERCE |
| 86 | MIR_COLOR |
| 87 | MIR_CONST |
| 88 | MIR_CONSTRUCTOR_DECL |
| 89 | MIR_CONTINUE |
| 90 | MIR_CONTROL |
| 91 | MIR_COS |
| 92 | MIR_CSNG |
| 93 | MIR_DEC |
| 94 | MIR_DECORATOR |
| 95 | MIR_DELETE_OBJECT |
| 96 | MIR_DESTRUCTOR_DECL |
| 97 | MIR_DIAGNOSTIC_ONLY |
| 98 | MIR_DIV |
| 99 | MIR_DIV_ASSIGN |
| 100 | MIR_EQ |
| 101 | MIR_EXCEPTION |
| 102 | MIR_EXP |
| 103 | MIR_EXPR |
| 104 | MIR_EXTFP_CALL |
| 105 | MIR_FADD |
| 106 | MIR_FAIL_CLOSED |
| 107 | MIR_FCMP |
| 108 | MIR_FDIV |
| 109 | MIR_FIELD_LOAD |
| 110 | MIR_FIELD_STORE |
| 111 | MIR_FILE |
| 112 | MIR_FILE_CLOSE |
| 113 | MIR_FILE_DELETE |
| 114 | MIR_FILE_EOF |
| 115 | MIR_FILE_LOF |
| 116 | MIR_FILE_OPEN |
| 117 | MIR_FILE_READ |
| 118 | MIR_FILE_SEEK |
| 119 | MIR_FILE_WRITE |
| 120 | MIR_FINALLY_BEGIN |
| 121 | MIR_FIX |
| 122 | MIR_FMUL |
| 123 | MIR_FNEG |
| 124 | MIR_FOR_EACH_BEGIN |
| 125 | MIR_FOR_EACH_NEXT |
| 126 | MIR_FSUB |
| 127 | MIR_FUNCTION_BEGIN |
| 128 | MIR_FUNCTION_END |
| 129 | MIR_GE |
| 130 | MIR_GLOBAL_DECL |
| 131 | MIR_GOSUB |
| 132 | MIR_GOTO |
| 133 | MIR_GT |
| 134 | MIR_HEX |
| 135 | MIR_HOST_CALL |
| 136 | MIR_IDIV |
| 137 | MIR_IDIV_ASSIGN |
| 138 | MIR_IMPLEMENTS_DECL |
| 139 | MIR_INC |
| 140 | MIR_INPUT |
| 141 | MIR_INSTR |
| 142 | MIR_INT |
| 143 | MIR_INTERFACE_DECL |
| 144 | MIR_INVALID |
| 145 | MIR_JMP |
| 146 | MIR_JMP_IF_FALSE |
| 147 | MIR_JMP_IF_TRUE |
| 148 | MIR_JSON |
| 149 | MIR_JS_CALL |
| 150 | MIR_LABEL |
| 151 | MIR_LCASE |
| 152 | MIR_LE |
| 153 | MIR_LEN |
| 154 | MIR_LIBRARY_CALL |
| 155 | MIR_LOAD |
| 156 | MIR_LOAD_CONST |
| 157 | MIR_LOAD_GLOBAL |
| 158 | MIR_LOAD_LOCAL |
| 159 | MIR_LOCAL_DECL |
| 160 | MIR_LOCATE |
| 161 | MIR_LOG |
| 162 | MIR_LOOP_BEGIN |
| 163 | MIR_LOOP_END |
| 164 | MIR_LOWERING |
| 165 | MIR_LPTR |
| 166 | MIR_LT |
| 167 | MIR_LTRIM |
| 168 | MIR_MAGIC |
| 169 | MIR_MEMORY |
| 170 | MIR_MEM_COPY |
| 171 | MIR_MEM_FILL |
| 172 | MIR_MEM_LOAD |
| 173 | MIR_MEM_STORE |
| 174 | MIR_META |
| 175 | MIR_METADATA_ONLY |
| 176 | MIR_METHOD_DECL |
| 177 | MIR_MIXIN |
| 178 | MIR_MOD |
| 179 | MIR_MODULE_BEGIN |
| 180 | MIR_MODULE_END |

## Kaynak klasörlerine göre işlev sayısı

| Klasör | İşlev sayısı | İlk örnekler |
| --- | --- | --- |
| backend | 73 | UXBBackendCliArgsInit, UXBBackendCliArgsAnyNativeBackendRequested, UXBBackendContextFromCliArgs, UXBBackendDiagnosticPushNativeOnly, UXBBackendSourceMapAddArtifact, UXBBackendTargetIsWebAdim15, UXBBackendNativeOnlyDiagnosticAdim15, UXBBackendNativeOnlyDiagnosticJsonAdim15 |
| build | 67 | InteropSetInit, InteropSetEnsure, InteropSetContainsCI, InteropSetAddCI, InteropManifestInit, TrimQuotePair, ApplyToolchainKeyValue, InteropToolchainApplyEnv |
| cli | 61 | UXBCliArgListInit, UXBCliArgListAdd, UXBCliLower, UXBCliRouteInit, UXBCliStateInit, UXBCliIsOption, UXBCliIsResponseFile, UXBCliNormalizeKey |
| codegen | 717 | UXBAdim14BrowserBaseName, UXBAdim14BrowserJsonEscape, UXBAdim14BrowserWriteFile, UXBAdim14WriteBrowserManifest, UXBAdim14WriteBrowserHtmlShell, UXBAdim14BrowserBackendEmit, UXBJsBackendEmitModule, UXBJsEmitDecisionForOpcode |
| common | 54 | UXBAdim16GateInit, UXBAdim16GateError, UXBAdim16RunDiagnosticsGate, UXBAdim16GateJson, UXBAdim16WriteGateReports, UXBDiagnosticSeverityName, UXBDiagnosticListInit, UXBDiagnosticEnsureCapacity |
| interpreter | 144 | UXBAstInterpRegisterRoutinesWalk, UXBAstInterpRun, UXBAstInterpRunRoutine, UXBAstInterpExecCall, UXBAstInterpExecBlockChildren, UXBAstInterpExecIf, UXBAstInterpExecControl, UXBAstInterpExecDecl |
| layout | 21 | UXBStep3WasmValueType, UXBStep3WasmNeedsHostImport, UXBStep3Win64ArgRegister, UXBStep3Win64ReturnRegister, UXBStep3Win64StackFrameSize, UXBStep3X86ArgLocation, UXBStep3ArrayStride, UXBStep3ArrayTotalBytes |
| legacy | 1 | LegacyGetCommands |
| main_backend_close_gate_adim27.fbs | 3 | UXBMainCloseGateResultInitAdim27, UXBMainCloseGateAppendErrorAdim27, UXBMainRunAstMirWebCliCloseGatesAdim27 |
| main_cli_bridge_adim41.fbs | 1 | UXBNormalizeCliArgAdim41 |
| main_output_contract_bridge.fbs | 12 | UXBOutputContractInit, UXBOutputContractReadCli, UXBOutputPathRequested, UXBOutputWriteText, UXBOutputSimpleJson, UXBOutputContractAfterLexer, UXBOutputContractAfterParser, UXBOutputContractSemanticSnapshotJson |
| main_output_contract_bridge_adim41_ext.fbs | 1 | UXBWriteCliOutputAdim41 |
| mir | 60 | UXBMIRBuilderMakeConst, UXBMIRBuilderMakeBinary, UXBMIRContextInit, UXBMIRContextNextTemp, UXBMIRContextNextBlock, UXBMIRInstructionMake, UXBMIROperandMake, UXBMIRStep4NormalizeOpcode |
| parser | 602 | ASTPoolInit, ASTEnsureCapacity, ASTInferFamily, ASTNewNode, ASTNewTypedNode, ASTAddChild, ASTAddRoleChild, ASTSetLeft |
| preprocessor | 15 | UXBMetaTrimQuotes34, UXBMetaJsonEsc34, UXBMetaHtmlEsc34, UXBMetaFnv1aFileHash34, UXBMetaBase64Encode34, UXBMetaReadBinaryFile34, UXBPreMetaJsonEscape, PreprocessResultInit |
| runtime | 553 | UXBMessageBusInit, UXBNormalizeMessageLanguage, UXBMessageLanguageSupported, UXBMessageBusSetLanguage, UXBMessageBusLanguage, UXBMessageBusSetLogPath, UXBMessageBusAppend, UXBMessageText |
| scope | 5 | UXBStep3ScopeAllowsDeclaration, UXBStep3ScopeReset, UXBStep3ScopeCurrent, UXBStep3ScopePush, UXBStep3ScopePop |
| semantic | 597 | SemStep2ContractStatus, SemStep2ContractHandler, SemStep2ExprContract, SemStep2TypeObjectContract, SemStep2ControlContract, SemStep2ErrorContract, SemStep2RuntimeContract, SemStep2NativeContract |
| surface | 13 | UXBSurfaceIsLayerRuntime, UXBSurfaceLayerStatus, UXBSurfaceFinalDecision, UXBSurfaceMirOpcode, UXBSurfaceRuntimeService, UXBSurfaceX64EmitKind, UXBSurfaceLayerJson, UXBSurfaceKnownCount |
| symbols | 31 | UXBScopeCount, UXBScopeIsValid, UXBScopeParent, UXBScopeName, UXBScopeKind, UXBScopeDepth, UXBSymHashOf, UXBSymHashReset |
| target | 1 | UXBStep3TargetStatus |
| type_binding | 52 | UXBStep3CanExplicitCast, UXBStep3CheckAssignment, UXBStep3CheckAssignableNodeKind, UXBStep3CheckCallArgCount, UXBStep3BuiltinReturnType, UXBStep3CheckReturnType, UXBStep3CheckStatementType, UXBStep3RequireCoercion |

# 12. Birleştirilmiş kısa notlar

Önceki dosyalardaki yararlı ama tekrar etmeyen kısa notlar burada temizlenmiş şekilde tutulur. Boş tekrar cümleleri ve “kaynak notu” satırları çıkarılmıştır.

## Not 1

**Dosya adı:** `pck.md`  
**Amaç:** uXBasic öğrenmek, uXBasic ile program yazmak ve uXBasic derleyicisini geliştirmek isteyen genç programcıya cep kitabı vermek.  
**Kaynak gerçekliği:** Bu kitap, `uxb(30.05_3).zip` içindeki kaynak ağacı, lexer, parser, MIR, çalışma zamanı servis kataloğu, kütüphane kayıtları, VSCode belgeleri ve gate raporları taranarak hazırlandı.

## Not 2

Bu kitap eski kısa belgeler gibi yalnız liste değildir. Önce uXBasic’in ne olduğunu sade bir dille anlatır, sonra dilin komutlarını tabloya döker, sonra her tabloyu örneklerle öğretir, en sonunda da derleyici geliştiren kişiye çalışma yöntemi verir. İngilizce terim gerektiğinde Türkçe karşılık, köşeli parantez içinde açıklama ve parantez içinde İngilizcesi birlikte verilir.

## Not 3

- ADIM22 tam katman beklenen çıktı kapısı: **PASS / missing_layer_output_count=0 / surface_coverage_count=287**. Bu, temel katman çıktılarının gerçek dosya olarak üretildiğini gösteren güçlü işarettir.

## Not 4

- ADIM30 on adım zinciri mevcut raporu: **FAIL / fail_count=37 / missing_output_count=72 / placeholder_count=0**. Bu kitap öğretici cep kitabıdır; ADIM30 gibi daha geniş zincirlerde kalan işler varsa, bunlar geliştirme işidir.

## Not 5

- Çalışma zamanı servislerinde `JSON`, `REGEX`, `HTTP`, `OS`, `LLAMA`, `LUA`, `PROLOG`, `SQLITE`, `BROWSER`, `WEBGPU`, `CURL`, `ONNX` gibi kapılar katalogda görünür. Bunların hepsi dil yüzeyinden çağrılabilir bir tasarıma bağlanır; fakat her biri için gerçek sarmalayıcı [var olan işi çevreleyen ince bağlantı katmanı] (wrapper) ve test yazılmalıdır.

## Not 6

uXBasic, BASIC dilinin sade okunurluğunu sistem programlama hedefleriyle birleştirmeye çalışan bir dildir. BASIC geleneğinde `PRINT`, `DIM`, `IF`, `FOR`, `SUB`, `FUNCTION` gibi kolay okunan komutlar vardır. uXBasic bu okunurluğu korurken dış kütüphane çağırma, DLL/API kullanma, C/C++/ASM dosyası içe alma, JavaScript üretme, WebAssembly metni üretme, x64 assembly üretme ve tarayıcıda çalışma gibi daha ileri hedeflere açılır.

## Not 7

Bir dili yalnız komut listesi zannetmek yanlıştır. Dil, yazdığın metni önce parçalara ayırır, sonra ağaca çevirir, sonra anlamını çözer, sonra ara dile indirir, sonra çalıştırır ya da başka hedefe kod üretir. uXBasic’in asıl değeri bu zinciri açık katmanlara ayırmasıdır. Bir genç programcı için en güzel taraf şudur: aynı programı önce yorumlayıcı [satırları veya ara temsili hemen çalıştıran katman] (interpreter) ile deneyebilir, sonra derleyici [programı başka makine diline veya hedef koda çeviren katman] (compiler) ile üretebilir.

## Not 8

uXBasic ile konsol programı, dosya işleyen araç, veri okuyan küçük analiz programı, Windows DLL kullanan sistem aracı, tarayıcıda çalışan küçük oyun, JavaScript çıktısı, WebAssembly metni, x64 assembly çıktısı ve ileride daha büyük bilimsel/istatistiksel yardımcılar yapılabilir. Ama her hedefin destek düzeyi aynı değildir. Bu yüzden programcı daima şu soruyu sorar: “Bu komut lexer tarafından tanınıyor mu, parser AST düğümü üretiyor mu, anlam katmanı kabul ediyor mu, MIR’e iniyor mu, hedef kod üreticisi bunu biliyor mu, runtime servisi var mı?”

## Not 9

Bu örnekte `PRINT` ekrana yazar, `DIM` değişken tanımlar, `AS I32` değişkenin 32 bit işaretli tam sayı olduğunu söyler, `IF` ise karar verir. Kodun güzel tarafı, okuyan kişinin programın amacını tahmin edebilmesidir.

## Not 10

uXBasic kaynak ağacında bu katmanlar ayrı klasörler ve dosyalarla görünür. `src/parser` sözcükleyici ve ayrıştırıcı tarafını, `src/semantic` anlam ve MIR indirme tarafını, `src/mir` MIR modelini, `src/runtime` çalışma zamanı servislerini, `src/codegen/js` JavaScript üretimini, `src/codegen/wasm` WebAssembly metin üretimini, `src/backend` hedef bağlama akışını, `src/cli` komut satırı yönlendirmesini taşır. Bu ayrım yalnız düzen için değildir; hata bulurken de hayat kurtarır.

## Not 11

Bu zinciri ezberlemek yerine günlük kontrol cümlesi olarak kullan: “Bir özellik ekledim, peki her katmanda izi var mı?” Sadece lexer’a kelime eklemek dil özelliği eklemek değildir. Parser AST üretmezse kelime ölüdür. MIR’e inmiyorsa hedefler görmez. Runtime servisi yoksa çalışırken patlar.

## Not 12

Program, bilgisayara verilen sıradır. Değişken, adı olan kutudur. Tip, kutuya hangi tür değer konacağını söyler. Deyim, yapılacak işi anlatan satırdır. İfade, değer üreten parçadır. `5 + 3` bir ifadedir; `PRINT 5 + 3` bir deyimdir.

## Not 13

Burada `F64` kesirli sayılar için güvenli seçimdir. `I32` genel tam sayıdır. `PRINT` içinde noktalı virgül kullanmak, BASIC geleneğinde yan yana yazdırma niyeti verir. Virgül ise alanlı yazdırma niyeti taşır.

## Not 14

Döngü, aynı işi tekrarlar. Sayaçlı tekrar için `FOR`, koşullu tekrar için `DO` kullanılır:

## Not 15

Yordam [adı olan tekrar kullanılabilir kod parçası] (subroutine) yazmak için `SUB`, değer döndüren yordam yazmak için `FUNCTION` kullanılır:

## Not 16

Aşağıdaki tablo, kaynakta `AddStatementDispatchEntry` ile gerçek ayrıştırıcı dağıtımına giren komutlardan hazırlanmıştır. Bu yüzden yalnız lexer’da görünen her sözcük değil, parser tarafından deyim olarak yakalanan komutlar esas alınmıştır.

## Not 17

Bu örnekte beşten fazla komut birlikte çalışır: `CONST`, `DIM`, `FUNCTION`, `RETURN`, `FOR`, `IF`, `PRINT`, `NEXT`. Programın amacı sayıların karesini almak ve eşiğe göre yazdırmaktır. İpucu şudur: küçük fonksiyon yazmak aklı temizler. Döngünün içine uzun formül gömmek yerine `Hesapla` gibi ad koyarsan program okunur.

## Not 18

Dosya işinde kural basittir: aç, işle, kapat. `OPEN` olmazsa dosya yolu yoktur. `PUT` yazmak, `GET` okumak içindir. `SEEK` ile konum değiştirilir. Hata yakalamayı güçlendirmek için dosya yolu, yetki, uzunluk ve son durum ayrıca raporlanmalıdır.

## Not 19

Bellek komutları sistem programlama için önemlidir. Ama bellek komutu oyuncak değildir. Yanlış adrese yazmak programı bozabilir. Bu yüzden `POKEB`, `MEMCOPYB`, `MEMFILLB` gibi komutlarda önce hedef adresi, uzunluğu ve sınırı düşün. Derleyici yazarken buna “kapalı başarısızlık” [emin değilse çalışmayı durdurma] (fail closed) denir.

## Not 20

Kaynakta `EVENT`, `SLOT`, `ON`, `OFF`, `TRIGGER`, `PIPE`, `THREAD`, `PARALEL` yüzeyi vardır. Bu aile programı parçalara ayırmak için düşünülmelidir. Olay “bir şey oldu” demektir. Yuva “o şey olunca bu kod çalışsın” demektir. Boru “veri buradan oraya aksın” demektir. İş parçacığı [aynı program içinde ayrı çalışma kolu] (thread) ise eşzamanlılık işidir.

## Not 21

Ön-işleyici, program daha tokenlara ayrılmadan çalışır. Makro tanımlar, koşullu satır seçer, dosya ekler ve bazı blokları geçer. Bu katman özellikle çok hedefli program yazarken önemlidir. Aynı kaynak Windows için başka, tarayıcı için başka satır açabilir.

## Not 22

Makro, dikkatli kullanılmalıdır. Makro metin değiştirir; tip bilmez. Bu yüzden `KARE(X)` gövdesinde parantez kullanmak küçük ama zeki bir hiledir. `KARE(1+2)` yazılırsa `((1+2) * (1+2))` olur. Parantezsiz yazılsaydı işlem önceliği bozulabilirdi.

## Not 23

Tip seçimi programcının namusudur. Her şeyi `F64` yapmak kolay görünür ama belleği ve anlamı bozar. Her şeyi `I32` yapmak da kesirli hesabı yok eder. En iyi yol, verinin gerçek doğasına göre tip seçmektir.

## Not 24

İpucu: Dosya boyu, adres ve uzunluk gibi negatif olmaması gereken değerlerde `U64` iyi seçimdir. Bilimsel ölçümde `F64` kullan. Ekran ve dosya metninde `STRING` kullan. DLL/API çağırırken `PTR` ve `STRPTR` gibi işaretçi tiplerini ancak ne yaptığını biliyorsan kullan.

## Not 25

Kod gerçekliği açısından `ARRAY`, `LIST`, `DICT`, `SET` lexer yüzeyinde vardır; AST/MIR zincirinde her hedef için destek seviyesi ayrıca doğrulanmalıdır. Bu yüzden cep kuralı şudur: dizi temel örneklerde daha güvenli alandır; liste/sözlük/küme için önce ilgili test dosyasını ve MIR çıktısını kontrol et.

## Not 26

Sınıf, yalnız “havalı” olduğu için kullanılmaz. Aynı veriyi ve o veriye ait davranışı birlikte tutmak için kullanılır. `Sayac` sınıfı içinde değeri dışarıdan doğrudan oynatmak yerine `Artir` yöntemi kullanılır. Bu, büyük programlarda hatayı azaltır.

## Not 27

İşlem önceliğini ezberlemek yerine parantez kullan. Derleyici yazarken de aynı kural geçerlidir: belirsizliği okuyucuya bırakma.

## Not 28

Bit işlemleri sistem programlamada kullanılır. Örneğin bir bayt içinde bayrak saklayabilirsin:

## Not 29

Metin ve sayı fonksiyonlarını birlikte kullanma örneği:

## Not 30

Bilimsel hesapta önce veriyi temizle, sonra sayıya çevir, sonra hesapla. Bu küçük sıra büyük hataları önler.

## Not 31

Aşağıdaki tablo, kaynakta `UXBRuntimeServiceCatalogAdd` çağrılarıyla görünen çalışma zamanı servislerinden üretilmiştir. Servis, dil komutunun gerçek dünyada iş yaptırdığı kapıdır. Örneğin `PRINT` komutu sonuçta `RT_PRINT` ailesine, dosya işleri `RT_FILE_*` ailesine, dış çağrılar `RT_DLL_CALL` ve `RT_API_CALL` ailesine bağlanır.

## Not 32

Burada hedefler önemlidir. Bir servis `X64` yazıyorsa Windows yerel tarafta düşünülür. `JS` ve `BROWSER` yazıyorsa JavaScript/tarayıcı hedefinde çalışabilecek kapı vardır. `WASM` yazıyorsa WebAssembly tarafında sözleşme düşünülmüştür. Programcı komut yazarken hedefini baştan bilmelidir.

## Not 33

Kütüphane kayıt tablosunda modüller, çalışma zamanı uzantıları ve test aileleri görünür. Bu kayıtlar, uXBasic’in dış dünyaya nasıl büyüyeceğini gösterir.

## Not 34

Bu modül adlarını birer sözleşme gibi düşün. `uxstats` istatistik için, `uxllama` yerel yapay zeka için, `uxdataframe` tablo verisi için, `uxgraph` graf için, `uxonnx` model çalıştırmak için, `uxmatrix` matris için kapı adıdır. Bir modül adı tek başına mucize değildir. Önce DLL veya dış araç, sonra sarmalayıcı, sonra uXBasic alias, sonra test gerekir.

## Not 35

Geliştirici için en önemli taktik şudur: aynı kaynak dosya için önce AST JSON, sonra HIR JSON, sonra MIR JSON, sonra hedef çıktı üret. Hata hangi katmanda çıkıyorsa orada dur. Derleyici geliştirmede rastgele düzeltme yapmak yerine katmanlı kanıt toplamak gerekir.

## Not 36

Dış kütüphane çağırmak, programın kendi kodu dışında hazırlanmış işlevleri kullanmasıdır. Dinamik bağlantı kütüphanesi [Windows üzerinde çalışırken yüklenen ikili kütüphane] (DLL) çağırırken üç şey gerekir: kütüphane adı, sembol adı ve imza. İmza, gönderilen ve dönen tiplerin sözleşmesidir. Kaynakta `CALL(DLL, ...)` ve `CALL(API, ...)` yüzeyi vardır.

## Not 37

Kod gerçekliği uyarısı: parser tarafında `CALL(DLL)` için en az kütüphane, sembol, imza ve argüman bekleyen doğrulama izleri vardır. İmza tokenları olarak `VOID`, `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`; çağrı düzeni olarak `CDECL`, `STDCALL` görülür. FFI imza ayrıştırıcı tarafında ayrıca `(I32,F64)->VOID` biçimli daha geniş imza metni desteği vardır. Geliştirici bu iki düzeyi tek sözleşmeye yaklaştırmalıdır.

## Not 38

DLL çağrısında üç altın kural vardır. Birincisi, mutlak yol verme; kütüphane adını güvenli tut. İkincisi, metin geçiriyorsan `STRPTR` mantığını bil. Üçüncüsü, `BYREF` kullanıyorsan gönderdiğin şey adreslenebilir değişken olmalı. Sabit ifadeye başvuru verilemez.

## Not 39

Burada `IMPORT` dosyayı projeye bildirir, `DECLARE FUNCTION` ise uXBasic tarafındaki imzayı bildirir. Derleyici zinciri gerçek bağlama yapacaksa build aşamasında C derleyici, C++ derleyici veya assembler çağırmalıdır. Kaynakta toolchain kapsamı olarak FreeBASIC, NASM, GCC ve G++ izleri görünür.

## Not 40

Ad alanı [isim çakışmasını önleyen bölge] (namespace) büyük projede aynı adlı fonksiyonların kavga etmesini engeller. Modül [birlikte taşınan işlev grubu] (module) bir iş ailesini toparlar. Alias [kısa ad] uzun çağrıyı okunur kılar. Using [kullanıma açma] sık kullanılan ad alanını görünür yapar.

## Not 41

Temsili durum: uXBasic çekirdeğinde her uzak servis için ayrı komut açmak yerine `HTTP`, `CURL`, `SERVER`, `LLAMA` gibi çalışma zamanı servisleri ve dış kütüphane sarmalayıcıları kullanılır. Bu daha temizdir. Dil şişmez; kütüphane büyür.

## Not 42

Burada `HttpPost` gerçek uXBasic çekirdek komutu olmak zorunda değildir. Bir DLL, curl sarmalayıcısı, HTTP runtime servisi veya dış program köprüsü olabilir. Önemli olan uXBasic tarafında temiz imza tutmaktır: URL metin, gövde metin, cevap metin.

## Not 43

Yerel yapay zeka için `uxllama` ve `RT_LLAMA_CALL` aileleri düşünülür. Uzak yapay zeka için doğrudan özel ürün adıyla çekirdeğe komut eklemek yerine HTTP/REST kapısı kullanmak daha doğru olur. Böylece Google, başka bir bulut servisi veya kendi sunucun değişse bile uXBasic programı yalnız endpoint ve anahtar katmanını değiştirir.

## Not 44

İpucu: Yapay zeka çağrısını asla programın her satırına dağıtma. Bir `MODULE YerelZeka` aç, tüm çağrıları oradan geçir. Sonra hata kaydı, süre ölçümü, tekrar deneme ve anahtar saklama işlerini tek yerde çözersin.

## Not 45

Bilimsel program yazarken önce veri, sonra temizlik, sonra özet, sonra test gelir. Ortalama, varyans, standart sapma, z testi ve F testi gibi işlemler ezber formül değildir; verinin ne söylediğini ölçme yoludur.

## Not 46

Z testi fikri: Bir örnek ortalaması bilinen toplum ortalamasından kaç standart hata uzakta?

## Not 47

F testi fikri: İki grubun varyansları birbirinden çok farklı mı?

## Not 48

Bu örneklerde kritik olan “p değeri hesabı” değil, akış mantığıdır. Gerçek istatistik modülü yazıldığında `uxstats` sarmalayıcısı F dağılımı, t dağılımı, z dağılımı, güven aralığı, ANOVA, korelasyon ve regresyon fonksiyonlarını taşımalıdır. Önce basit formülü elle yazmak programcıya ne yaptığını öğretir.

## Not 49

Tarayıcı hedefi, uXBasic programını web sayfasında çalıştırma fikridir. Kaynakta JavaScript üretici, tarayıcı bootstrap dosyaları, WebAssembly metin üretimi ve WebGPU servis adı görülür. Terimleri netleştirelim: JavaScript [tarayıcıların doğrudan çalıştırdığı dil] (JavaScript), WebAssembly [tarayıcıda düşük seviye ve hızlı ikili çalışma biçimi] (WebAssembly), WAT [WebAssembly metin biçimi] (WebAssembly Text), WebGPU [tarayıcıdan ekran kartına modern erişim] (WebGPU).

## Not 50

Bu basit program JS çıktısına döndüğünde `program.js`, WAT çıktısına döndüğünde `program.wat`, tarayıcı kabuğuna döndüğünde `index.html` beklenir. ADIM22 raporunda bu dosyaların gerçek üretildiği görülmüştür. Ancak tarayıcıda gerçek çalışma için yol ayıracı, dosya yolu, wasm yükleme ve servis köprüleri ayrıca test edilmelidir.

## Not 51

Bir derleyici projesinde en kötü alışkanlık “bir satır değiştirdim, oldu galiba” demektir. İyi alışkanlık “hangi katman kabul etti, hangi çıktı oluştu, hangi rapor temiz” demektir. uXBasic projesinin iyi tarafı kapı testleriyle düşünmesidir.

## Not 52

Kanca [belirli akış noktasında kayıt alma veya ek davranış] (hook) doğru kullanılırsa izleme aracıdır; yanlış kullanılırsa mimariyi sakatlar. Kanca, çekirdek davranışı değiştirmemeli; olayı kaydetmeli veya dışarıya haber vermelidir. Sarmalayıcı [var olan kodu temiz arayüzle çağıran katman] (wrapper) ise kirli dış dünyayı temiz uXBasic imzasına çevirir. Örneğin curl karmaşık olabilir ama uXBasic tarafında `Curl.PostJson(url, body)` sade görünmelidir.

## Not 53

Çıktı sözleşmesi hilesi: Test runner eksik dosyayı uydurmamalıdır. Derleyici dosyayı üretmiyorsa test kalmalıdır. Eski placeholder yaklaşımı kolay PASS verir ama programcıyı kandırır. Gerçek kalite, “dosya gerçekten var mı, içeriği gerçek mi, JSON bozuk mu, hedef kod çalışıyor mu” sorularından geçer.

## Not 54

Kaynak eşleme [üretilen hatayı kaynak satıra bağlama] (source mapping) genç programcının dostudur. Hata “MIR kırıldı” demek yerine “şu dosya, şu satır, şu komut” demelidir. Büyük projede hata mesajı ne kadar iyi ise geliştirme o kadar hızlıdır.

## Not 55

uXBasic programcısı hem kendi programını hem derleyiciyi test eder. Pozitif test “çalışması gereken çalışıyor mu?” sorusudur. Negatif test “hata vermesi gereken hata veriyor mu?” sorusudur. Sadece pozitif test yazmak yarım iştir.

## Not 56

Bu komutlar programın dili değildir; geliştiricinin kontrol aracıdır. Ama cep kitabında bulunmalıdır çünkü uXBasic gibi çok katmanlı projede “ben çalıştı sanıyorum” yerine “kapı geçti” demek gerekir.

## Not 57

Bu programda ön-işleyici, sabit, dizi, döngü, karar, dosya yazma, metne çevirme ve yazdırma birlikte kullanılır. Programın amacı basittir: beş ölçümü özetlemek ve rapor dosyasına yazmak. Küçük görünen bu yapı, gerçek bilimsel programların çekirdeğidir.

## Not 58

Bir: Dil çekirdeğini gereksiz büyütme. Her yeni dış iş için yeni anahtar kelime açmak yerine `MODULE`, `NAMESPACE`, `ALIAS`, `USING`, `CALL`, `IMPORT`, `DECLARE` ve çalışma zamanı servislerini kullan. Böylece dil sade kalır, kütüphane büyür.

## Not 59

İki: Güvenliği her yere yayma; doğru yere koy. DLL yolu, include yolu, bellek sınırı, dış çağrı imzası ve çıktı sözleşmesi güvenlik için doğru noktalardır. Her satıra korku koyarsan dil programcıyı boğar. Hiç kontrol koymazsan sistem çöker.

## Not 60

Üç: OOP [nesne yönelimli programlama] (object-oriented programming) geniş olmalı ama tutarlı olmalı. `CLASS`, `INTERFACE`, `METHOD`, `PROPERTY`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE`, `ABSTRACT`, `FINAL`, `SEALED` gibi yüzeyler ancak semantic, layout, MIR ve backend tarafında gerçek karşılık bulursa değerlidir.

## Not 61

Dört: Floating point [kesirli sayı hesabı] (floating point) için çekirdek küçük kalabilir; `F80`, `F128`, `BIGF`, `BIGD`, `BALL` gibi ağır işler dış DLL ile taşınabilir. Bu doğru mimaridir çünkü büyük sayı işi özel ve ağırdır.

## Not 62

Beş: Her yeni servis için test klasöründe yalnız o aşamanın geniş testlerini tut. Eski testleri yeni pakete tekrar doldurma. Yeni komut için tek tek test ve en az iki birleşik kullanım testi yaz.

## Not 63

Altı: Genç programcıya en değerli bilgi şudur: Bir programı çalıştırmak başka, bir sistemi doğru çalıştırmak başkadır. uXBasic gibi bir projede gerçek başarı, komutun lexer’dan başlayıp hedef çıktıya kadar dürüstçe izlenebilmesidir.

## Not 64

- Önce küçük program yaz: `PRINT`, `DIM`, `IF`, `FOR`.
- Sonra fonksiyon yaz: `FUNCTION`, `SUB`, `RETURN`.
- Sonra dosya kullan: `OPEN`, `PUT`, `GET`, `CLOSE`.
- Sonra tipleri ciddiye al: `I32`, `U64`, `F64`, `STRING`, `PTR`.
- Sonra dış dünyaya çık: `DECLARE`, `IMPORT`, `CALL(DLL)`, `CALL(API)`.
- Sonra katmanı izle: AST, HIR, MIR, runtime, backend.
- Sonra test yaz: pozitif, negatif, çıktı sözleşmesi.

## Not 65

Bu cep kitabını okuyan biri uXBasic’i yalnız “BASIC benzeri komutlar” diye değil, katmanlı ve büyütülebilir bir sistem programlama aracı olarak görmelidir.

## Not 66

Bu kitap uXBasic'i yalnız komut listesi olarak değil, çalışan bir düşünme aracı olarak anlatır. Genç programcı için en önemli bilgi şudur: program, bilgisayara verilen emirlerin kuru dizisi değildir; veri toplama, karar verme, dış dünya ile konuşma ve sonucu ölçme düzenidir. uXBasic bu düzeni BASIC tadında okunur bir yüzeyle, C/C++/ASM ve DLL gücüyle, tarayıcı ve WebAssembly çıktısıyla birleştirmek için tasarlanmıştır. Burada geçen teknik sözcüklerde önce Türkçe ad verilir, gerekirse köşeli parantez içinde kısa açıklama ve parantez içinde İngilizce karşılığı yazılır. Örneğin kanca [derleyicinin bir aşamasına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [dış fonksiyonu uXBasic'e düzenli çağrı gibi gösteren ince katman] (wrapper) demektir.

## Not 67

Bu sürüm, `uxb(30.05_4).zip` içindeki son gerçek kaynak ağacı, patch/readme kararları, çalışma zamanı kütüphaneleri, araçlar, kanca ve sarmalayıcı klasörleri esas alınarak genişletildi. Kitapta bazı yama adları geçse bile bunlar artık “sonradan eklenecek parçalar” gibi değil, uXBasic'in normal programlama yüzeyi ve araç düzeni gibi anlatılır. Büyük sayı ailesi olan `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` ve `BIGINIT` bu nedenle normal dil/kütüphane yetenekleri olarak ele alınır. Her şeyin çalıştığı varsayılmıştır; bu kitap kullanıcının hayal gücünü tetiklemek için örnekleri gerçek kullanım senaryolarına bağlar.

## Not 68

Bu kitap ve örnekler MIT lisansı anlayışıyla kullanılabilir. MIT lisansı; kodu inceleme, değiştirme, dağıtma, özel veya ticari projede kullanma özgürlüğü verir. Buna karşılık yazar, bu kitabın kullanımından doğabilecek veri kaybı, yanlış hesap, gelir kaybı, donanım sorunu, üçüncü taraf API ücretleri, sistem çökmesi veya hukuki sonuçlardan sorumlu değildir. Özellikle DLL, dosya silme, bellek yazma, ağ ve yapay zeka API kullanımlarında kullanıcı kendi ortamını, gizli anahtarlarını ve güvenlik sınırlarını korumalıdır.

## Not 69

Sorun, öneri veya destek için: `zmetedinler@gmail.com`. Kullanımdan memnun kalırsanız küçük destek için 50 TL veya 25 ABD doları göndermeniz sevinçle karşılanır. IBAN ve ödeme bilgileri dağıtım paketinin ticari sürümünde ayrıca verilebilir. Bu bilgi bağış niteliğindedir; kitabı kullanma hakkını sınırlamaz.

## Not 70

Bir dili öğrenmenin yolu önce komut ezberlemek değildir. Önce “hangi veriyi alıyorum, bu veriye hangi kararı veriyorum, sonucu nereye yazıyorum?” sorusunu sormalısın. Her örneği çalıştırmadan önce kâğıda üç kutu çiz: giriş, işlem, çıkış. Giriş kullanıcıdan, dosyadan, sensörden, ağdan veya DLL'den gelebilir. İşlem; koşul, döngü, fonksiyon, veri yapısı ve kütüphane çağrısıdır. Çıkış; ekran, dosya, grafik, tarayıcı, API cevabı veya başka programa verilen veri olabilir. İyi programcı hata çıkmayacağını varsaymaz; hata çıkarsa ne yapacağını baştan yazar. uXBasic'te `TRY`, `ASSERT`, test kapıları, rapor dosyaları ve çıktı sözleşmeleri bu yüzden önemlidir.

## Not 71

uXBasic mimarisi bir mutfak gibi düşünülebilir. Önce malzeme gelir: kaynak dosyası. Ön-işleyici [kaynak derlenmeden önce çalışan düzenleyici] (preprocessor) malzemeyi ayıklar; hedefe göre HTML, JS, WAT, varlık ve bildirim parçalarını hazırlar. Sözcükleyici [metni anlamlı parçalara bölen katman] (lexer) komutları, adları, sayıları ve işaretleri ayırır. Çözümleyici [komutları ağaç yapısına çeviren katman] (parser) artık “IF nerede başladı, FOR nerede bitti, FUNCTION ne döndürür?” gibi yapıyı kurar. Soyut söz ağacı [programın ağaç biçimindeki anlamlı iskeleti] (AST) bu yapıyı taşır. Anlam ve tip katmanı değişkenin ne olduğunu, hangi işlemin hangi tipe uygulanabileceğini ve dış çağrının imzasını denetler. Orta gösterim [hedeflerden bağımsız ara komut düzeni] (MIR), programı JS, WAT, x64, x86 veya yorumlayıcıya götürülebilecek ortak biçime indirir. Arka uç [son çıktı üretici] (backend) hedef dosyaları yazar. Çalışma zamanı [program çalışırken yardım eden kütüphane düzeni] (runtime) dosya, matematik, büyük sayı, yapay zeka, grafik ve dış dünya işlerini taşır.

## Not 72

Kanca (hook) derleyicinin bir aşamasına “beni de haberdar et” demenin güvenli yoludur. İyi kanca asıl işi bozmaz; yalnız izleme, rapor, ölçüm veya özel genişletme yapar. Sarmalayıcı (wrapper) ise dış dünyanın dağınık fonksiyonlarını uXBasic tarafında temiz bir çağrıya çevirir. Genç programcı şunu unutmasın: iyi sarmalayıcı, kötü kütüphaneyi bile okunur yapar; kötü sarmalayıcı, iyi kütüphaneyi anlaşılmaz yapar. Bu yüzden her DLL çağrısında `DECLARE`, `ALIAS`, `MODULE`, `NAMESPACE`, hata kontrolü ve kaynak kapatma düzeni birlikte düşünülür.

## Not 73

uXBasic yalnız program üretmez; aynı zamanda ürettiği programın kanıtını da verir. `tokens.json`, `ast.json`, `symbol_table.json`, `type_table.json`, `mir.json`, `program.js`, `program.wat`, `index.html`, `manifest.json`, `stdout.txt`, `stderr.txt` ve `runtime_trace.json` gibi çıktılar bunun parçalarıdır. Bir çıktı yoksa test kapısı bunu söylemelidir; çıktı uydurmak yasaktır. Genç programcı için ders şudur: gerçek programcılıkta “çalıştı gibi” değil, “kanıtıyla çalıştı” denir.

## Not 74

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Kaynak kabulü:** Bu genişletilmiş sürüm, `uxb(30.05_4).zip` son kaynak gerçekliği, `30.05_3` içindeki önceki gerçeklik notları, patch/readme/tools/kütüphane klasörleri ve önceki `pck*.md` çalışması üzerine kurulmuştur. Bu kitapta patch olarak görünen ADIM33, ADIM34, ADIM35 kararları da normal program özelliği kabul edilmiştir.

## Not 75

MIT Lisansı şunu anlatır: Bu kodu ve belgeyi kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi projenize katabilirsiniz. Lisans metnini ve telif bilgisini korumalısınız. Yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, yanlış DLL/API çağrısı, hatalı bilimsel sonuç, yanlış istatistik yorumu veya sistem bozulmasından yazar sorumlu değildir. Gerçek cihaz, para, sağlık, resmi işlem, üretim hattı ve güvenlik işlerinde önce küçük test, sonra yedek, sonra onaylı çalışma yapılmalıdır.

## Not 76

Bu çalışmadan fayda görürseniz gönüllü destek olarak 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince bu satıra yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`. Destek zorunlu değildir; amaç geliştirme emeğini sürdürebilmektir.

## Not 77

uXBasic'i öğrenmenin en doğru yolu, dili bir komut listesi değil bir üretim düzeni olarak görmektir. Kaynağı yazarsın, ön-işleyici gerekirse kaynak üretir, sözcükleyici parçalar, ayrıştırıcı ağaç kurar, anlam katmanı tipleri denetler, ara temsil oluşur, çalışma zamanı veya arka uç programı gerçek dünyaya bağlar.

## Not 78

Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

## Not 79

Kanca [akışa takılan izleme noktası] (hook), ana işi bozmadan katmanın içine bakmak için kullanılır. `compiler/hooks` altında AST, HIR, MIR, runtime ve codegen için ayrı hook dosyaları vardır. Varsayılan hooklar kapalıdır; bu iyi bir disiplindir. Çünkü derleyici önce sessiz ve temiz çalışmalı, izleme yalnız gerektiğinde açılmalıdır.

## Not 80

Sarmalayıcı [karmaşık işi kolay çağıran katman] (wrapper), dosyaları tek büyük karmaşaya çevirmeden toplar. `compiler/wrappers` içindeki frontend, AST, HIR, MIR, runtime ve codegen bundle dosyaları hangi katmanın hangi gerçek dosyaları içerdiğini gösterir.
|No|Dosya|Görev|
|---|---|---|
|1|uxb_ast_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|2|uxb_codegen_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|3|uxb_global_noop_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|4|uxb_hir_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|5|uxb_mir_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|6|uxb_runtime_hook.fbs|Hook dosyası; katman izleme amacı taşır|
|7|uxb_ast_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|
|8|uxb_codegen_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|
|9|uxb_frontend_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|
|10|uxb_hir_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|
|11|uxb_main_wrapper.bas|Wrapper dosyası; katman dosyalarını toplar|
|12|uxb_main_wrapper.c|Wrapper dosyası; katman dosyalarını toplar|
|14|uxb_mir_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|
|15|uxb_runtime_bundle_wrapper.fbs|Wrapper dosyası; katman dosyalarını toplar|

## Not 81

Bir hata bütün programı bozuyorsa hook açıp her satıra `PRINT` koymak yerine katman giriş/çıkışını işaretlersin. AST katmanı doğruysa parser sağlamdır. MIR bozuksa anlam veya indirme katmanına bakarsın. Runtime bozuksa arka uç değil, çalışma zamanı sorgulanır.

## Not 82

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Destek notu:** Bu belge ve uXBasic çalışmaları faydalı olursa 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince buraya yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`.

## Not 83

Bu cep kitabı uXBasic dilini öğrenmek, denemek ve geliştirmek isteyenler için hazırlanmıştır. Kaynak kodun MIT Lisansı ile dağıtıldığı varsayılmıştır. MIT Lisansı kısaca şunu söyler: kodu kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi işinizde kullanabilirsiniz; fakat lisans metnini ve telif bildirimini korumalısınız. Bu yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, sistem bozulması, yanlış DLL/API çağrısı veya yanlış bilimsel sonuçlardan belge yazarı sorumlu değildir. Deney, üretim, finans, sağlık, resmi işlem, güvenlik ve gerçek cihaz kontrolünde önce küçük test yapın.

## Not 84

uXBasic, BASIC ailesinin kolay okunur yapısını, çağdaş derleyici [kaynak kodu makineye çeviren program] (compiler) katmanlarıyla birleştirmek için tasarlanmış bir dildir. Genç programcı için en önemli düşünce şudur: bir dili öğrenmek yalnız komut ezberlemek değildir. Komutun ne zaman kullanılacağını, verinin nereden geldiğini, bellekte nereye gittiğini, çıktı dosyasına nasıl döndüğünü ve hata olursa nerede yakalanacağını anlamaktır.

## Not 85

uXBasic ile amaç yalnız `PRINT "Merhaba"` yazmak değildir. Aynı dil ile dosya okuyabilir, veri analizi yapabilir, DLL çağırabilir, Windows API kullanabilir, C/C++/ASM dosyasını derleme zincirine alabilir, tarayıcı için JavaScript [tarayıcı dili] (JavaScript) üretebilir, WebAssembly metni [tarayıcıda hızlı çalışan ara çıktı] (WAT/WASM) çıkarabilir, yerel yapay zekaya veya bulut yapay zekaya mesaj gönderebilirsiniz.

## Not 86

Önce küçük program yaz. Sonra aynı programı üç kez boz ve düzelt. Bir komutu gerçekten öğrendiğini anlamanın yolu onu hata alacak biçimde de denemektir. `DIM` ile değişken aç, yanlış tip ver, hata raporuna bak. `OPEN` ile dosya aç, sonra kapatmayı unut, davranışı izle. `IF` yaz, sonra `ELSE` kısmını boş bırak. Derleyici yazan kişinin aklı, hatayı erken yakalayan akıldır.

## Not 87

Programlama hilesi dediğimiz şey çoğu zaman kural dışı numara değildir. Doğru yerde küçük bir kayıt tutmaktır. Mesela bir derleyicide her komutun hangi dosyadan, hangi satırdan geldiğini saklarsan, hata mesajını çok daha iyi verirsin. Bir `symbol_table.json` [sembol tablosu çıktısı] üretirsen, programdaki bütün değişkenleri sonra test edebilirsin. Bu yüzden uXBasic yalnız dil değil, aynı zamanda izlenebilir bir derleme düzenidir.

## Not 88

`.uxb` yeni uXBasic programının ana evidir. `.bas` eski BASIC alışkanlığını taşır. `.uxmh` başlık ve modül bildirimlerini tutar. Büyük projede ana program kısa kalır, ayrıntılar `.uxmh` ve kütüphane dosyalarına ayrılır. Bu bir kitap yazmaya benzer: ana bölümde konu akar, eklerde ayrıntı durur.

## Not 89

İşlem sırası şöyledir: kaynak okunur, ön-işleyici çalışır, sözlükçü kelimeleri ayırır, çözümleyici ağacı kurar, anlam denetimi değişkenleri ve tipleri kontrol eder, ara temsil üretilir, istenirse yorumlayıcı çalıştırır, istenirse kod üretici hedef dosyayı yazar. Bu sıra bozulursa derleyici de şaşırır. Bu yüzden test kapıları her aşamada çıktı ister.

## Not 90

Çıktı dosyası uydurulmamalıdır. Bir test geçiyorsa dosya gerçekten derleyici tarafından üretilmelidir. `program.js` içinde gerçek JavaScript, `program.wat` içinde gerçek WAT, `index.html` içinde gerçek tarayıcı kabuğu olmalıdır. Genç programcı için bu altın kuraldır: testin amacı kendini kandırmak değil, hatayı erken bulmaktır.

## Not 91

Bu program beş temel işi öğretir: `MAIN` giriş noktasıdır, `DIM` değişken açar, `PRINT` çıktı verir, `INPUT` veri alır, `IF` karar verir. Programın amacı kullanıcıyı tanımak değildir; veri akışını öğretmektir. Veri klavyeden gelir, değişkende durur, şartla yorumlanır, ekrana döner.

## Not 92

Bu ciltte tablo hücreleri kısa ve işe yarar tutuldu: sözdizimi ne yazacağını, görev ise komutun ne yaptığını söyler. Uzun anlatım tablonun altında sınıf başlıklarına ayrılmıştır. Böylece aynı cümle tekrarı yerine her komutun program yazarken nerede işe yaradığı görülür.

## Not 93

Akış komutları programın yol ayrımlarıdır. Bir genç programcı bu grubu iyi anlarsa programı çizgi film sahnesi gibi düşünebilir: bir sahnede karar verilir, başka sahnede tekrar yapılır, hata çıkarsa temizlik sahnesine geçilir. `IF`, `SELECT`, `FOR`, `DO`, `TRY` ve `RETURN` aynı ailenin farklı araçlarıdır. Veri ölçümleri, kullanıcı menüleri, dosya okuma döngüleri ve bilimsel hesaplar hep akışla yönetilir. Bu komutları kullanırken önce koşulu kısa yaz, sonra o koşulun neden var olduğunu yorumla açıkla. Döngü yazarken çıkış yolunu unutma; çıkış yolu olmayan döngü genç programcının ilk büyük tuzağıdır. Hata yakalamayı da akışın parçası say; çünkü gerçek programda dosya her zaman bulunmaz, API her zaman cevap vermez, kullanıcı her zaman beklediğin veriyi yazmaz.

## Not 94

**Sözdizimi:** `IF koşul THEN komutlar ELSE komutlar END IF`  
**Ne işe yarar:** Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.  
**Nerede kullanılır:** Karar vermen gereken her yerde kullanılır: kullanıcı yetkisi, ölçüm sınırı, dosya var mı, hata var mı, hedef tarayıcı mı gibi.

## Not 95

**Sözdizimi:** `IF koşul THEN komutlar`  
**Ne işe yarar:** IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.  
**Nerede kullanılır:** Tek başına program başlatmaz; IF satırındaki doğru dalı açar.

## Not 96

**Sözdizimi:** `IF koşul THEN ... ELSE ... END IF`  
**Ne işe yarar:** IF koşulu yanlışsa çalışacak yedek yolu gösterir.  
**Nerede kullanılır:** Olumsuz durumun da planlı olmasını sağlar.

## Not 97

**Sözdizimi:** `IF a THEN ... ELSEIF b THEN ... ELSE ... END IF`  
**Ne işe yarar:** Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.  
**Nerede kullanılır:** Çok sınıflı karar ağacı kurarken kullanılır.

## Not 98

**Sözdizimi:** `END IF | END SELECT | END SUB | END FUNCTION | END CLASS | END MODULE`  
**Ne işe yarar:** Açılmış bloğu kapatır ve sınırını belli eder.  
**Nerede kullanılır:** Blokların birbirine karışmamasını sağlar.

## Not 99

**Sözdizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`  
**Ne işe yarar:** Tek bir değeri birçok olası değere göre dallandırır.  
**Nerede kullanılır:** Menü, durum kodu, hedef adı, işlem türü gibi seçeneklerde IF zincirinden daha okunur.

## Not 100

**Sözdizimi:** `CASE değer | CASE IS > değer | CASE ELSE`  
**Ne işe yarar:** SELECT içindeki tek seçeneği belirtir.  
**Nerede kullanılır:** SELECT olmadan anlamı yoktur; bir sınıflandırma satırıdır.

## Not 101

**Sözdizimi:** `CASE IS > değer | CASE IS <= değer`  
**Ne işe yarar:** CASE içinde karşılaştırmalı seçenek kurar.  
**Nerede kullanılır:** Sadece eşitlik değil aralık/sınır denetimi gerektiğinde kullanılır.

## Not 102

**Sözdizimi:** `TRY ... CATCH hata ... FINALLY ... END TRY`  
**Ne işe yarar:** Hata çıkabilecek işi korumalı bölümde dener.  
**Nerede kullanılır:** Dosya, ağ, DLL ve kullanıcı girdisi gibi bozulabilecek işlerde kullanılır.

## Not 103

**Sözdizimi:** `CATCH hataAdi`  
**Ne işe yarar:** TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.  
**Nerede kullanılır:** Programın çökmesini önler, hatayı anlaşılır mesaja çevirir.

## Not 104

**Sözdizimi:** `FINALLY ...`  
**Ne işe yarar:** Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.  
**Nerede kullanılır:** Açılan dosyayı kapatmak, belleği bırakmak, bağlantıyı sonlandırmak için kullanılır.

## Not 105

**Sözdizimi:** `THROW "hata metni"`  
**Ne işe yarar:** Senin belirlediğin hatayı bilinçli olarak fırlatır.  
**Nerede kullanılır:** Yanlış veri geldiğinde sessizce devam etmek yerine hatayı görünür yapar.

## Not 106

**Sözdizimi:** `ASSERT koşul`  
**Ne işe yarar:** Test amacıyla bir koşulun doğru olmasını zorunlu tutar.  
**Nerede kullanılır:** Derleyici, kütüphane ve bilimsel hesap testlerinde beklenen sonucu korur.

## Not 107

**Sözdizimi:** `FOR sayac = ilk TO son STEP adim ... NEXT sayac`  
**Ne işe yarar:** Sayaçlı döngü kurar.  
**Nerede kullanılır:** Kaç kere çalışacağı belli olan işlerde kullanılır.

## Not 108

**Sözdizimi:** `FOR i = başlangıç TO bitiş`  
**Ne işe yarar:** Döngünün son değerini gösterir.  
**Nerede kullanılır:** FOR satırında hedef sınırı belirtir.

## Not 109

**Sözdizimi:** `FOR i = ilk TO son STEP adim`  
**Ne işe yarar:** Sayaç artışını veya azalışını belirler.  
**Nerede kullanılır:** Atlamalı okuma, geri sayım, seyrek örnekleme işlerinde kullanılır.

## Not 110

**Sözdizimi:** `NEXT sayac`  
**Ne işe yarar:** FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.  
**Nerede kullanılır:** Sayaçlı tekrarın kapanışıdır.

## Not 111

**Sözdizimi:** `DO WHILE koşul ... LOOP | DO ... LOOP UNTIL koşul`  
**Ne işe yarar:** Koşullu döngü başlatır.  
**Nerede kullanılır:** Kaç tekrar olacağı önceden bilinmeyen işlerde kullanılır.

## Not 112

**Sözdizimi:** `LOOP | LOOP UNTIL koşul`  
**Ne işe yarar:** DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.  
**Nerede kullanılır:** Dosya sonuna kadar, tuş gelene kadar veya iş bitene kadar döndürür.

## Not 113

**Sözdizimi:** `DO WHILE koşul | WHILE koşul ... WEND`  
**Ne işe yarar:** Koşul doğru kaldığı sürece çalışmayı sürdürür.  
**Nerede kullanılır:** Sürekli izleme, kuyruk boşalana kadar çalışma ve oyun döngüsünde kullanılır.

## Not 114

**Sözdizimi:** `LOOP UNTIL koşul`  
**Ne işe yarar:** Koşul doğru olunca döngüyü bitirir.  
**Nerede kullanılır:** En az bir kez çalışması gereken sorgularda kullanılır.

## Not 115

**Sözdizimi:** `EXIT FOR | EXIT DO | EXIT FUNCTION | EXIT SUB`  
**Ne işe yarar:** İçinde bulunulan döngüden veya yordamdan erken çıkar.  
**Nerede kullanılır:** Gereksiz çalışmayı keser; özellikle arama ve hata durumunda işe yarar.

## Not 116

**Sözdizimi:** `FOR EACH eleman IN liste ... NEXT`  
**Ne işe yarar:** Bir koleksiyonun elemanlarını tek tek dolaşır.  
**Nerede kullanılır:** Liste, sözlük anahtarları ve veri satırları için okunur döngü kurar.

## Not 117

**Sözdizimi:** `FOR EACH x IN koleksiyon | x IN liste`  
**Ne işe yarar:** Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.  
**Nerede kullanılır:** Koleksiyonla çalışan modern BASIC yazımını güçlendirir.

## Not 118

**Sözdizimi:** `RETURN değer`  
**Ne işe yarar:** Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.  
**Nerede kullanılır:** Hesap sonucunu çağıran yere verir.

## Not 119

**Sözdizimi:** `GOTO etiket`  
**Ne işe yarar:** Belirtilen etikete doğrudan atlar.  
**Nerede kullanılır:** Kısa kurtarma veya eski BASIC uyumluluğunda kullanılır; yeni kodda dikkatli kullanılmalıdır.

## Not 120

**Sözdizimi:** `GOSUB etiket ... RETURN`  
**Ne işe yarar:** Etikete gider ve RETURN ile geri döner.  
**Nerede kullanılır:** Eski BASIC alt yordam düzenini taşır; büyük kodda SUB daha temizdir.

## Not 121

**Birlikte kullanım örneği — veri sınıflandırma:**

## Not 122

Olay ve eşzamanlılık komutları, programın dış dünyadan gelen işaretlere tepki vermesini sağlar. GUI düğmesine basılması, tarayıcıda tıklama, sensörden veri gelmesi, zamanlayıcının dolması veya başka bir işin sonuç üretmesi olaydır. `EVENT` olayın adını koyar, `SLOT` o olaya verilecek tepkiyi taşır, `TRIGGER` olayı elle çalıştırır. `THREAD`, `PARALEL` ve `PIPE` programın tek sıra halinde değil, düzenli iş bölümüyle çalışmasına yardım eder. Burada hayal gücü şöyle gelişir: bir iş veri üretir, boruya koyar; ikinci iş borudan alır, hesaplar; üçüncü iş ekrana veya dosyaya yazar. Bu yapı GUI, tarayıcı, sensör, oyun, sunucu ve uzun hesaplamalarda kullanılır. Genç programcı için püf noktası şudur: eşzamanlı işlerde paylaşılan değişkeni gelişigüzel değiştirme; boru, olay ve kuyruk kullan.

## Not 123

**Sözdizimi:** `EVENT OlayAdi`  
**Ne işe yarar:** Daha sonra tetiklenecek olay adını bildirir.  
**Nerede kullanılır:** GUI düğmesi, tarayıcı tıklaması, seri port verisi, zamanlayıcı ve sensör bildirimi için kullanılır.

## Not 124

**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne işe yarar:** Ayrı iş parçası olarak çalışacak işi tanımlar.  
**Nerede kullanılır:** Ekranı dondurmadan dosya okuma, ağ bekleme veya hesap yapma için kullanılır.

## Not 125

**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne işe yarar:** THREAD için eski/uyumluluk yazımı olarak ele alınır.  
**Nerede kullanılır:** Eski dosyalarda kalmış yazımı kırmadan taşımak için kullanılır.

## Not 126

**Sözdizimi:** `PARALEL GrupAdi ... END PARALEL`  
**Ne işe yarar:** Birden fazla işi paralel görev ailesi olarak düzenler.  
**Nerede kullanılır:** Bağımsız hesaplar, veri dönüştürme ve tarayıcı işleri birlikte ilerlesin diye kullanılır.

## Not 127

**Sözdizimi:** `PIPE Ad AS Tip`  
**Ne işe yarar:** İki iş arasında veri taşıyan boru tanımlar.  
**Nerede kullanılır:** Bir iş veri üretirken diğer işin tüketmesini sağlar.

## Not 128

**Sözdizimi:** `SLOT Ad ON Olay ... END SLOT`  
**Ne işe yarar:** Bir olaya bağlı çalışacak kod yuvasını tanımlar.  
**Nerede kullanılır:** Olay geldiğinde hangi işin yapılacağını gösterir.

## Not 129

**Sözdizimi:** `SLOT Ad ON Olay | ON ERROR ...`  
**Ne işe yarar:** Bir eylemi olaya veya duruma bağlar.  
**Nerede kullanılır:** Bağlama cümlesidir; olayı ve tepkiyi birbirine bağlar.

## Not 130

**Sözdizimi:** `OFF Olay | OFF SLOT Ad`  
**Ne işe yarar:** Olay dinlemeyi veya bağlı tepkiyi kapatır.  
**Nerede kullanılır:** Geçici durdurma, güvenli kapanış ve kaynak bırakma sırasında kullanılır.

## Not 131

**Sözdizimi:** `TRIGGER OlayAdi[, veri]`  
**Ne işe yarar:** Bir olayı elle tetikler.  
**Nerede kullanılır:** Testte, GUI benzetiminde ve donanım gelmiş gibi davranmak istediğinde kullanılır.

## Not 132

**Birlikte kullanım örneği — sensör olayını ekrana ve dosyaya bağlama:**

## Not 133

Yordam ve çağrı komutları, programı küçük ve tekrar kullanılabilir parçalara böler. `SUB` sonuç döndürmeyen işi, `FUNCTION` sonuç döndüren hesabı taşır. `DECLARE` ve `CALL` ise dış dünyaya açılan kapıdır: Windows DLL, C kütüphanesi, REST köprüsü veya yerel yapay zeka sarmalayıcısı buradan çağrılır. Parametreyi kopya mı göndereceğin (`BYVAL`) yoksa değiştirilebilir adres gibi mi göndereceğin (`BYREF`) çoğu hatanın kaynağıdır. Dış çağrıda çağrı düzeni [fonksiyonun bellekte nasıl çağrıldığı] (calling convention) önemlidir; C tarafında `CDECL`, Windows tarafında çoğu eski API için `STDCALL` görülebilir. İyi genç programcı, her dış çağrıya küçük bir uXBasic fonksiyonu yazar ve programın geri kalanını DLL ayrıntısından korur.

## Not 134

**Sözdizimi:** `SUB Ad(param AS Tip) ... END SUB`  
**Ne işe yarar:** Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.  
**Nerede kullanılır:** Yazdırma, kaydetme, ekran temizleme gibi sonuç döndürmeyen işlerde kullanılır.

## Not 135

**Sözdizimi:** `FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION`  
**Ne işe yarar:** Değer döndüren hesap veya dönüştürme bloğu tanımlar.  
**Nerede kullanılır:** Hesap, metin işleme, doğrulama ve kütüphane sarmalayıcılarında kullanılır.

## Not 136

**Sözdizimi:** `DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip`  
**Ne işe yarar:** Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.  
**Nerede kullanılır:** DLL/API çağırmadan önce ad, parametre ve dönüş tipini netleştirir.

## Not 137

**Sözdizimi:** `CALL Ad(argler) | CALL(DLL,"dll","fonksiyon",argler) | CALL(API,"ad",argler)`  
**Ne işe yarar:** Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.  
**Nerede kullanılır:** uXBasic’in çekirdeğini büyütmeden dış dünyaya açılma kapısıdır.

## Not 138

**Sözdizimi:** `param AS BYREF Tip | BYREF param AS Tip`  
**Ne işe yarar:** Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.  
**Nerede kullanılır:** Dış kütüphane dönüş tamponları ve hızlı veri güncellemede kullanılır.

## Not 139

**Sözdizimi:** `BYVAL param AS Tip`  
**Ne işe yarar:** Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.  
**Nerede kullanılır:** DLL imzalarında ve güvenli çağrılarda önemlidir.

## Not 140

**Sözdizimi:** `DECLARE CDECL FUNCTION ...`  
**Ne işe yarar:** C çağrı düzenini belirtir.  
**Nerede kullanılır:** C/C++ kütüphanesiyle uyum için kullanılır.

## Not 141

**Sözdizimi:** `DECLARE STDCALL FUNCTION ...`  
**Ne işe yarar:** Windows çağrı düzenini belirtir.  
**Nerede kullanılır:** Windows API tarafında sık kullanılır.

## Not 142

**Birlikte kullanım örneği — DLL çağrısını güvenli sarmalama:**

## Not 143

Nesne ve tip bildirimi komutları büyük projede düzen kurar. `TYPE` yalnız veri alanlarını toplarken, `CLASS` veriyle davranışı aynı çatıya alır. `INTERFACE` sözleşme kurar: bu sınıf şu işleri yapmayı vaat eder. `PUBLIC`, `PRIVATE`, `PROTECTED` gibi erişim sözcükleri kimin neyi görebileceğini anlatır. `CONSTRUCTOR` nesne doğarken, `DESTRUCTOR` nesne giderken çalışır. `VIRTUAL` ve `OVERRIDE` aynı işin farklı sınıflarda farklı yapılmasını sağlar. Genç programcı için akıllı hile şudur: önce TYPE ile sade veri modelini kur, sonra gerçekten davranış gerekiyorsa CLASS'a geç; her şeyi sınıf yapma, ama sınıfsız da büyük sistem yazmaya çalışma.

## Not 144

**Sözdizimi:** `TYPE Ad ... END TYPE`  
**Ne işe yarar:** Kayıt biçiminde veri alanları toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 145

**Sözdizimi:** `CLASS Ad ... END CLASS`  
**Ne işe yarar:** Veri ve davranışı aynı nesne kalıbında toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 146

**Sözdizimi:** `INTERFACE Ad ... END INTERFACE`  
**Ne işe yarar:** Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 147

**Sözdizimi:** `CLASS Ad IMPLEMENTS Arayuz`  
**Ne işe yarar:** Sınıfın arayüz sözleşmesini üstlendiğini belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 148

**Sözdizimi:** `METHOD Ad(...) AS Tip`  
**Ne işe yarar:** Sınıf içindeki işlevi tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 149

**Sözdizimi:** `MAGIC Ad(...)`  
**Ne işe yarar:** Özel davranışlı sihirli yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 150

**Sözdizimi:** `MAGIC Ad(...)`  
**Ne işe yarar:** Sihirli yöntem için kısa/alternatif yazım sağlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 151

**Sözdizimi:** `VIRTUAL METHOD Ad(...)`  
**Ne işe yarar:** Alt sınıfın değiştirebileceği yöntem bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 152

**Sözdizimi:** `OVERRIDE METHOD Ad(...)`  
**Ne işe yarar:** Üst sınıftaki yöntemi bilinçli olarak değiştirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 153

**Sözdizimi:** `CONSTRUCTOR(...)`  
**Ne işe yarar:** Nesne oluşurken çalışan kurucu bölümdür.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 154

**Sözdizimi:** `DESTRUCTOR()`  
**Ne işe yarar:** Nesne yok olurken temizlik yapar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 155

**Sözdizimi:** `NEW Sinif(argler)`  
**Ne işe yarar:** Yeni nesne oluşturur.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 156

**Sözdizimi:** `DELETE nesne`  
**Ne işe yarar:** Nesne/ayrılmış kaynağı bırakır.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 157

**Sözdizimi:** `ABSTRACT CLASS Ad`  
**Ne işe yarar:** Doğrudan üretilmeyen temel sınıf tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 158

**Sözdizimi:** `FINAL CLASS Ad | FINAL METHOD Ad`  
**Ne işe yarar:** Daha fazla miras/değiştirme yapılmasını engeller.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 159

**Sözdizimi:** `SEALED CLASS Ad`  
**Ne işe yarar:** Kapatılmış sınıf bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 160

**Sözdizimi:** `STATIC alan AS Tip | STATIC METHOD Ad`  
**Ne işe yarar:** Sınıfa ait tek ortak alan/yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 161

**Sözdizimi:** `PROPERTY Ad AS Tip`  
**Ne işe yarar:** Nesne alanını kontrollü özellik olarak tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 162

**Sözdizimi:** `OPERATOR +(a,b)`  
**Ne işe yarar:** Sınıf için işlemci davranışı tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 163

**Sözdizimi:** `MIXIN Ad`  
**Ne işe yarar:** Bir sınıfa ek davranış karışımı ekler.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 164

**Sözdizimi:** `DECORATOR Ad`  
**Ne işe yarar:** Yordam/sınıf etrafına ek davranış sarar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 165

**Sözdizimi:** `PUBLIC ad`  
**Ne işe yarar:** Dışarıdan erişilebilir üye bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 166

**Sözdizimi:** `PRIVATE ad`  
**Ne işe yarar:** Sadece kendi sınıf/modülü içinden erişilir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 167

**Sözdizimi:** `PROTECTED ad`  
**Ne işe yarar:** Kendi sınıfı ve alt sınıflar erişir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 168

**Sözdizimi:** `RESTRICTED ad`  
**Ne işe yarar:** Daraltılmış erişim kuralı belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 169

**Sözdizimi:** `FRIEND MODULE Ad`  
**Ne işe yarar:** Belirli modül/sınıfa özel erişim verir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 170

**Sözdizimi:** `READONLY ad AS Tip`  
**Ne işe yarar:** Dışarıdan değiştirilemeyen okuma alanı bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 171

**Sözdizimi:** `MUTABLE ad AS Tip`  
**Ne işe yarar:** Normalde sabit bağlamda bile değişebilir alan belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 172

**Sözdizimi:** `IMMUTABLE ad AS Tip`  
**Ne işe yarar:** Değişmez veri/nesne niyeti belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

## Not 173

**Birlikte kullanım örneği — ölçüm nesnesi:**

## Not 174

Değişken ve bellek komutları verinin adını, tipini ve yerini belirler. `DIM` bir kutu açar, `AS` kutunun türünü söyler, `CONST` değişmeyecek değeri korur, `REDIM` büyüyen diziye yeni yer açar. İyi programda değişken adı, ne tuttuğunu anlatır; `x` yerine `phDegeri`, `toplamAgirlik`, `satirSayisi` yazmak hatayı azaltır. Tip sınırı önemlidir: 0-255 arası için `U8`, günlük sayaç için `I32`, çok büyük dosya sayacı için `I64`, bilimsel ölçüm için `F64`, yüksek duyarlık için `BIGD` veya `BIGF` seçilir. Genç programcı erken öğrenmelidir: yanlış tip seçimi bazen hata vermez, sessizce yanlış sonuç üretir.

## Not 175

**Sözdizimi:** `DIM ad AS Tip`  
**Ne işe yarar:** Yeni değişken, dizi veya nesne başvurusu bildirir.  
**Nerede kullanılır:** Her veri işi DIM ile başlar; ad, tip ve bellek düzeni görünür olur.

## Not 176

**Sözdizimi:** `REDIM dizi(yeniBoyut)`  
**Ne işe yarar:** Diziyi yeni boyuta taşır.  
**Nerede kullanılır:** Önceden eleman sayısı bilinmeyen veri girişlerinde kullanılır.

## Not 177

**Sözdizimi:** `ad AS Tip`  
**Ne işe yarar:** Bir adın tipini belirtir.  
**Nerede kullanılır:** Okunurluk ve dış çağrı uyumu için kullanılır.

## Not 178

**Sözdizimi:** `CONST ad AS Tip = değer`  
**Ne işe yarar:** Değişmeyen sabit tanımlar.  
**Nerede kullanılır:** Ayar, sınır ve fiziksel sabitlerde kullanılır.

## Not 179

**Birlikte kullanım örneği — tip sınırı ve doğru değişken seçimi:**

## Not 180

Tip sözcükleri değişkenin içinde hangi tür veri tutulacağını belirler. Tam sayılar sayaç ve indeks için, ondalıklı sayılar ölçüm ve hesap için, metin tipi rapor ve kullanıcı girdisi için, koleksiyon tipleri çoklu veri için kullanılır. `PTR` ve `STRPTR` gibi işaretçi tipleri dış kütüphaneye bellek adresi vermek içindir; aceleyle kullanılmaz. `BIGF`, `BIGD`, `BALL`, `F80`, `F128` yüksek duyarlık ve özel matematik için düşünülür. Tip seçimi yalnız bellek konusu değildir; aynı zamanda niyet beyanıdır.

## Not 181

**Sözdizimi:** `DIM ad AS BYTE`  
**Ne işe yarar:** tek baytlık ham veri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 182

**Sözdizimi:** `DIM ad AS I8`  
**Ne işe yarar:** -128 ile 127 arasında işaretli 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 183

**Sözdizimi:** `DIM ad AS U8`  
**Ne işe yarar:** 0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 184

**Sözdizimi:** `DIM ad AS I16`  
**Ne işe yarar:** işaretli 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 185

**Sözdizimi:** `DIM ad AS U16`  
**Ne işe yarar:** işaretsiz 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 186

**Sözdizimi:** `DIM ad AS I32`  
**Ne işe yarar:** günlük sayaç ve indeksler için 32 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 187

**Sözdizimi:** `DIM ad AS U32`  
**Ne işe yarar:** negatif olmayan 32 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 188

**Sözdizimi:** `DIM ad AS I64`  
**Ne işe yarar:** büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 189

**Sözdizimi:** `DIM ad AS U64`  
**Ne işe yarar:** çok büyük pozitif sayaçlar için 64 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 190

**Sözdizimi:** `DIM ad AS F32`  
**Ne işe yarar:** tek duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 191

**Sözdizimi:** `DIM ad AS F64`  
**Ne işe yarar:** çift duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 192

**Sözdizimi:** `DIM ad AS F80`  
**Ne işe yarar:** genişletilmiş kayan nokta sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 193

**Sözdizimi:** `DIM ad AS F128`  
**Ne işe yarar:** 128 bit yüksek duyarlıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 194

**Sözdizimi:** `DIM ad AS BIGF`  
**Ne işe yarar:** çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 195

**Sözdizimi:** `DIM ad AS BIGD`  
**Ne işe yarar:** çok basamaklı ondalık sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 196

**Sözdizimi:** `DIM ad AS BALL`  
**Ne işe yarar:** aralık/top mantığıyla güvenli yaklaşık sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 197

**Sözdizimi:** `DIM ad AS BOOLEAN`  
**Ne işe yarar:** TRUE/FALSE doğru-yanlış değeri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 198

**Sözdizimi:** `DIM ad AS STRING`  
**Ne işe yarar:** metin tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 199

**Sözdizimi:** `DIM ad AS OBJECT`  
**Ne işe yarar:** nesne başvurusu tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 200

**Sözdizimi:** `DIM ad AS PTR`  
**Ne işe yarar:** ham adres veya dış kütüphane işaretçisi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 201

**Sözdizimi:** `DIM ad AS STRPTR`  
**Ne işe yarar:** metnin bellek adresini dış çağrıya verir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 202

**Sözdizimi:** `DIM ad AS ARRAY`  
**Ne işe yarar:** sabit veya yeniden boyutlanabilir dizi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 203

**Sözdizimi:** `DIM ad AS LIST`  
**Ne işe yarar:** sıralı, büyüyebilen liste tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 204

**Sözdizimi:** `DIM ad AS DICT`  
**Ne işe yarar:** anahtar/değer sözlüğü tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 205

**Sözdizimi:** `DIM ad AS SET`  
**Ne işe yarar:** tekrarsız küme tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

## Not 206

Varsayılan tip komutları eski BASIC geleneğinden gelir. Harf aralığına göre değişken tipi seçer. Modern uXBasic kodunda açık `DIM ad AS Tip` daha okunur ve güvenlidir. Yine de eski kaynakları taşırken veya kısa deneme yazarken bu komutlar işe yarar. Genç programcı bunları tanımalı ama büyük projede açık tip yazmayı alışkanlık yapmalıdır.

## Not 207

**Sözdizimi:** `DEFINT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 208

**Sözdizimi:** `DEFLNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 209

**Sözdizimi:** `DEFSNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 210

**Sözdizimi:** `DEFDBL A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 211

**Sözdizimi:** `DEFEXT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri geniş ondalık yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 212

**Sözdizimi:** `DEFSTR A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri STRING yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 213

**Sözdizimi:** `DEFBYT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri BYTE yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

## Not 214

Modül ve kaynak komutları büyük projeyi dosyalara böler. `INCLUDE` hazır başlık ve modül yüzeyini içeri alır, `IMPORT` C/C++/ASM kaynaklarını derleme işine bağlar, `NAMESPACE` ve `MODULE` ad karmaşasını önler. `USING` uzun adları kısa kullanmayı sağlar, `ALIAS` okunur adlar kurar. `INLINE` küçük dış dil parçalarını kaynak içinde taşır; ama büyük dış kod ayrı dosyada ve `IMPORT` ile daha temizdir. Genç programcı için kural: bir dosya çok uzadıysa önce modüle böl; aynı adlar çakışmaya başladıysa ad alanı aç; dış kütüphane çağrısı çirkinleştiyse sarmalayıcı yaz.

## Not 215

**Sözdizimi:** `INCLUDE "dosya.uxbh"`  
**Ne işe yarar:** Başka uXBasic başlık/destek dosyasını kaynak içine katar.  
**Nerede kullanılır:** Ortak yordamları, kütüphane imzalarını ve tip tanımlarını paylaşmak için kullanılır.

## Not 216

**Sözdizimi:** `IMPORT(C,"dosya.c") | IMPORT(CPP,"dosya.cpp") | IMPORT(ASM,"dosya.asm")`  
**Ne işe yarar:** Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.  
**Nerede kullanılır:** DLL değil kaynak ekleme işidir; dış çalışma zamanı ile çekirdeği büyütmeden güç verir.

## Not 217

**Sözdizimi:** `MAIN ... END MAIN`  
**Ne işe yarar:** Programın ana giriş bölümünü belirtir.  
**Nerede kullanılır:** Büyük projede nereden başlanacağını görünür yapar.

## Not 218

**Sözdizimi:** `NAMESPACE Ad ... END NAMESPACE`  
**Ne işe yarar:** Adları çakışmadan ayıran alan açar.  
**Nerede kullanılır:** Aynı isimli fonksiyonları farklı alanlarda tutar.

## Not 219

**Sözdizimi:** `MODULE Ad ... END MODULE`  
**Ne işe yarar:** Bir dosya veya iş ailesini modül olarak toplar.  
**Nerede kullanılır:** Kütüphane, araç ve büyük uygulama parçalarında kullanılır.

## Not 220

**Sözdizimi:** `USING MODULE Ad | USING NAMESPACE Ad`  
**Ne işe yarar:** Bir modül/alan adını kısa kullanım için etkinleştirir.  
**Nerede kullanılır:** Sürekli uzun ad yazmayı azaltır; ama çakışma varsa tam ad kullanılır.

## Not 221

**Sözdizimi:** `ALIAS yeniAd = eskiAd | ALIAS KISA AS uzunAd`  
**Ne işe yarar:** Uzun çağrıya kısa veya yerel ad verir.  
**Nerede kullanılır:** Okunabilirlik ve dış kütüphane sarmalama için kullanılır.

## Not 222

**Sözdizimi:** `INLINE C ... END INLINE | INLINE ASM ... END INLINE`  
**Ne işe yarar:** uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.  
**Nerede kullanılır:** Kısa ve özel hızlandırma parçaları için kullanılır.

## Not 223

**Birlikte kullanım örneği — modül ve dış kaynak düzeni:**

## Not 224

Girdi çıktı komutları programın insanla, dosyayla ve terminalle konuşmasını sağlar. `PRINT` yalnız ekrana yazmaz; dosyaya rapor da yazabilir. `INPUT` kullanıcıdan veya dosyadan veri alır. `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` dosya işlerinin temelidir. `CLS`, `COLOR`, `LOCATE` terminal arayüzünü düzenler. Programlamayı yeni öğrenen biri için dosya işlemleri çok öğreticidir; çünkü veri dışarıdan gelir, satır satır okunur, kontrol edilir, sonuç rapora yazılır. Her açılan dosyayı kapatmak, her okunan değeri doğrulamak ve her hatayı kullanıcıya anlaşılır söylemek gerekir.

## Not 225

**Sözdizimi:** `PRINT ifade[, ifade] | PRINT #dosya, ifade`  
**Ne işe yarar:** Ekrana veya dosyaya metin/sayı yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 226

**Sözdizimi:** `INPUT değişken | INPUT #dosya, değişken`  
**Ne işe yarar:** Kullanıcıdan veya dosyadan veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 227

**Sözdizimi:** `OPEN "dosya" FOR INPUT|OUTPUT|APPEND AS #no`  
**Ne işe yarar:** Dosyayı okuma/yazma/ekleme için açar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 228

**Sözdizimi:** `CLOSE #no`  
**Ne işe yarar:** Açık dosyayı kapatır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 229

**Sözdizimi:** `GET #no, konum, değişken`  
**Ne işe yarar:** Dosyadan ham veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 230

**Sözdizimi:** `PUT #no, konum, değişken`  
**Ne işe yarar:** Dosyaya ham veri yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 231

**Sözdizimi:** `SEEK #no, konum`  
**Ne işe yarar:** Dosya okuma/yazma konumunu değiştirir.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 232

**Sözdizimi:** `CLS`  
**Ne işe yarar:** Ekranı temizler.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 233

**Sözdizimi:** `COLOR ön[, arka]`  
**Ne işe yarar:** Yazı/arka plan rengini ayarlar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 234

**Sözdizimi:** `LOCATE satır, sütun`  
**Ne işe yarar:** Ekran imlecini konuma taşır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

## Not 235

**Birlikte kullanım örneği — belge oluşturma:**

## Not 236

İşleçler küçük görünür ama programın karar ve hesap kaslarıdır. `AND`, `OR`, `NOT` koşul birleştirir; `XOR` özel fark mantığı verir; `MOD` kalan hesabı yapar; `SHL`, `SHR`, `ROL`, `ROR` bit düzeyinde hızlı iş yapar. Genç programcı önce koşul işleçlerini öğrenmeli, sonra bit işleçlerine geçmelidir. Bit işleçleri bayrak, renk, donanım, sıkıştırma ve hızlı maske işlerinde işe yarar. Püf noktası: karmaşık koşulu tek satıra gömme; ara değişkenle adlandır, sonra IF içinde oku.

## Not 237

**Sözdizimi:** `a AND b`  
**Ne işe yarar:** iki koşul/bit birlikte doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 238

**Sözdizimi:** `a OR b`  
**Ne işe yarar:** koşullardan biri doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 239

**Sözdizimi:** `NOT koşul`  
**Ne işe yarar:** koşulu tersine çevirir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 240

**Sözdizimi:** `a XOR b`  
**Ne işe yarar:** yalnız biri doğruysa doğru verir veya bitlerde özel fark alır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 241

**Sözdizimi:** `a MOD b`  
**Ne işe yarar:** bölme kalanı verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 242

**Sözdizimi:** `a SHL b`  
**Ne işe yarar:** bitleri sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 243

**Sözdizimi:** `a SHR b`  
**Ne işe yarar:** bitleri sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 244

**Sözdizimi:** `a ROL b`  
**Ne işe yarar:** bitleri döndürerek sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 245

**Sözdizimi:** `a ROR b`  
**Ne işe yarar:** bitleri döndürerek sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

## Not 246

**Birlikte kullanım örneği — bayrak ve koşul:**

## Not 247

Yerel fonksiyonlar küçük yardımcı makinelerdir. Metni parçalar, sayıyı dönüştürür, zamanı ölçer, dosya sonunu denetler, tuş okur, bellek adresi verir veya matematik hesaplar. Bunları tek tek ezberlemek yerine ailelere ayır: metin ailesi, sayı ailesi, trigonometri ailesi, dosya ailesi, klavye ailesi, bellek adresi ailesi. Genç programcı `VAL` ve `STR` ile veri dönüşümünü, `LEN` ve `MID` ile metin parçalamayı, `TIMER` ile hız ölçmeyi, `EOF` ile güvenli dosya döngüsünü erken öğrenmelidir. Fonksiyon sonucu her zaman bir değişkene alınabilir; böylece hata ayıklamak kolaylaşır.

## Not 248

**Sözdizimi:** `sonuc = SETSTRINGSIZE metin, uzunluk`  
**Ne işe yarar:** Metin değişkeni için istenen uzunlukta alan hazırlar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 249

**Sözdizimi:** `sonuc = TIMER()`  
**Ne işe yarar:** Geçen zamanı saniye türünden verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 250

**Sözdizimi:** `sonuc = LOF(#no)`  
**Ne işe yarar:** Açık dosyanın uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 251

**Sözdizimi:** `sonuc = EOF(#no)`  
**Ne işe yarar:** Dosya sonuna gelinip gelinmediğini söyler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 252

**Sözdizimi:** `sonuc = LEN(metin)`  
**Ne işe yarar:** Metnin veya verinin uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 253

**Sözdizimi:** `sonuc = MID(metin, başla, uzunluk)`  
**Ne işe yarar:** Metnin içinden parça alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 254

**Sözdizimi:** `sonuc = STR(sayi)`  
**Ne işe yarar:** Sayıyı metne çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 255

**Sözdizimi:** `sonuc = VAL(metin)`  
**Ne işe yarar:** Metni sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 256

**Sözdizimi:** `sonuc = ABS(x)`  
**Ne işe yarar:** Mutlak değer alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 257

**Sözdizimi:** `sonuc = INT(x)`  
**Ne işe yarar:** Ondalıklı sayının tam kısmını alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 258

**Sözdizimi:** `sonuc = UCASE(metin)`  
**Ne işe yarar:** Metni büyük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 259

**Sözdizimi:** `sonuc = LCASE(metin)`  
**Ne işe yarar:** Metni küçük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

## Not 260

**Sözdizimi:** `sonuc = ASC(karakter)`  
**Ne işe yarar:** Karakterin sayı kodunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

# Son söz

uXBasic’i öğrenirken amaç bütün komutları ezberlemek değildir. Amaç, hangi işi hangi aileyle çözeceğini bilmektir: akış için IF/FOR/DO, veri için DIM/TYPE/CLASS, dış dünya için DECLARE/CALL/IMPORT, web için ön-işleyici ve JS/WASM hattı, bilimsel iş için ARRAY/LIST/DICT/SET ve istatistik kütüphaneleri. Genç programcı için en büyük sır şudur: çalışan küçük örneği yaz, sonra onu modüle böl, sonra test kapısı koy, sonra dış dünyaya aç. Büyük sistemler böyle büyür.
