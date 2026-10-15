# uXBasic Programlayıcının Cep Kitabı — Cilt 5
## Tarayıcı, JS, WAT/WASM, API, Yapay Zeka, Bilimsel Analiz ve Son Ustalık Defteri

Bu cilt, ilk dört cildin üstüne kurulur. Birinci ciltte dosya ve mimariyi, ikinci ciltte komut sınıflarını, üçüncü ciltte değişkenleri ve veri yapılarını, dördüncü ciltte kütüphaneleri gördün. Beşinci ciltte artık uXBasic programını dış dünyaya çıkarıyoruz: tarayıcıya sayfa üretiyoruz, JavaScript [tarayıcı dili] (JavaScript) çıktısını kullanıyoruz, WebAssembly metni [tarayıcıda hızlı çalışacak programın okunur biçimi] (WAT) ve WebAssembly ikilisi [tarayıcıda hızlı çalışan ikili dosya] (WASM) üretiyoruz, REST API [web üzerinden veri alışverişi düzeni] (REST API) ile konuşuyoruz, Flask [Python ile küçük web sunucusu kurma aracı] (Flask) gibi dış sunuculara bağlanıyoruz, yerel Llama modeliyle ve bulut yapay zeka servisleriyle mesajlaşıyoruz, bilimsel veri analizi yapıyoruz.

Bu ciltte her şeyin çalıştığı varsayılmıştır. Yani `uxbrowser`, `uxhttp`, `uxjson`, `uxllama`, `uxstats`, `uxstats2`, `uxdataframe`, `uxmatrix`, `uxtensor`, `uxgraph`, `uxonnx`, `uxserver`, `uxcrypto`, `uxarchive`, `uxstringx` ve benzeri kütüphaneler normal programlama yüzeyinin parçası gibi ele alınır. Ama genç programcı şunu unutmasın: bir kütüphane çalışıyor diye onu dikkatsiz kullanmak doğru değildir. Ağ çağrısı hata verebilir, yapay zeka yanıtı boş dönebilir, dosya yazılamayabilir, tarayıcı yolu yanlış olabilir, sayısal analizde yanlış test seçilebilir. İyi programcı, sonucu yalnız üretmez; sonucu denetler, kaydeder, yorumlar ve hata olursa güvenli çıkar.

---

# 1. Web hedefi ne demektir?

Web hedefi, uXBasic kaynak dosyasının tarayıcıda çalışan bir çıktıya dönüştürülmesidir. Bu hedefte genellikle birkaç dosya birlikte oluşur: `program.js`, `program.wat`, `program.wasm`, `index.html`, `manifest.json`, `ux_runtime.js`, `ux_wasm_bridge.js`, `ux_canvas2d.js`, `ux_audio.js`, `ux_ai_bridge.js`. Bir genç programcı için web hedefinin güzelliği şudur: yazdığın BASIC benzeri kaynak kod, tarayıcıda grafik, ses, tuş, fare ve yapay zeka bağlantısı olan küçük bir uygulamaya dönüşebilir.

## Web çıktı dosyaları

| Dosya | Görevi | Ne zaman bakılır? | Küçük kullanım notu |
|---|---|---|---|
| `program.js` | uXBasic kaynak kodunun JavaScript çıktısıdır. | Tarayıcıda program çalışmıyorsa ilk bakılacak dosyalardan biridir. | Gerçek kod içermeli; boş veya yer tutucu olmamalıdır. |
| `program.wat` | WASM için okunur metin çıktısıdır. | Hızlı çekirdek veya düşük seviye hedef denenecekse incelenir. | Parantez dengesi ve dış çağrı adları önemlidir. |
| `program.wasm` | Tarayıcıda veya WASM host ortamında çalışan ikili çıktıdır. | WAT doğrulandıktan sonra kullanılır. | Doğrudan okunmaz; köprü dosyasıyla yüklenir. |
| `index.html` | Tarayıcı kabuğudur. | Sayfa açılmıyorsa, yol ve script etiketleri buradan kontrol edilir. | Web yolunda `/` kullanmak güvenlidir. |
| `manifest.json` | Hangi dosyalar üretildi, hangi hedefler var, bunu bildirir. | Yayın paketi hazırlanırken bakılır. | Test kapısı manifest ile dosya varlığını karşılaştırır. |
| `runtime_trace.json` | Çalışma zamanı olaylarını kaydeder. | Program çalıştı ama beklenen sonucu vermediyse kullanılır. | Hangi çağrı ne zaman oldu, görmek için önemlidir. |
| `program_output.json` | Program çıktısının yapılandırılmış biçimidir. | VSCode, web paneli veya otomatik test bunu okuyabilir. | Ekrana basılan metin makinece okunur hale gelir. |

## Web CLI komutları

| Uzun seçenek | 3 harfli kısa komut | Görev | Örnek |
|---|---:|---|---|
| `--emit-js` | `ejs` | JavaScript üretimini açar. | `uxb ejs main.uxb --out dist/web/program.js` |
| `--js-out` | `jso` | JavaScript çıktı yolunu verir. | `uxb jso main.uxb --out dist/web/program.js` |
| `--emit-wat` | `ewt` | WAT üretimini açar. | `uxb ewt main.uxb --out dist/wasm/program.wat` |
| `--wat-out` | `wat` | WAT çıktı yolunu verir. | `uxb wat main.uxb --out dist/wasm/program.wat` |
| `--emit-wasm` | `ewm` | WASM üretimini açar. | `uxb ewm main.uxb --out dist/wasm/program.wasm` |
| `--wasm-out` | `wsm` | WASM çıktı yolunu verir. | `uxb wsm main.uxb --out dist/wasm/program.wasm` |
| `--html-out` | `htm` | HTML kabuk dosyasını üretir. | `uxb htm main.uxb --out dist/web/index.html` |
| `--manifest-out` | `man` | Manifest dosyasını üretir. | `uxb man main.uxb --out dist/web/manifest.json` |
| `--backend-report-json-out` | `brj` | Hedef arka uç raporunu üretir. | `uxb brj main.uxb --out out/backend.json` |
| `--artifact-report-json-out` | `afj` | Üretilen varlıkların raporunu üretir. | `uxb afj main.uxb --out out/artifacts.json` |
| `--runtime-trace-json-out` | `rtj` | Çalışma zamanı izini üretir. | `uxb rtj main.uxb --out out/runtime_trace.json` |

Bu komutları ayrı ayrı ezberleme. Mantığı şudur: `emit` üretimi açar, `out` yol söyler, `report` kanıt üretir, `trace` çalışma anını izler. Bir web programını temiz üretmek için yalnız `program.js` yetmez; `index.html`, `manifest.json`, rapor ve gerekirse çalışma izi de gerekir.

## Büyük örnek 1 — Aynı kaynaktan tarayıcı paneli ve rapor

```uxbasic
%%TARGET BROWSER
%%ASSET "assets/logo.png" AS "logo.png"
%%HTML_BEGIN "index.html" BODY
<div id="app">
  <canvas id="ekran" width="900" height="520"></canvas>
  <pre id="rapor"></pre>
</div>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM ph(1 TO 12) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM dusuk AS I32
    DIM yuksek AS I32

    ph(1)=7.10: ph(2)=7.18: ph(3)=7.25: ph(4)=6.92
    ph(5)=7.05: ph(6)=7.40: ph(7)=7.33: ph(8)=7.12
    ph(9)=6.80: ph(10)=7.22: ph(11)=7.36: ph(12)=7.08

    toplam = 0
    FOR i = 1 TO 12
        toplam = toplam + ph(i)
        IF ph(i) < 6.90 THEN dusuk = dusuk + 1
        IF ph(i) > 7.35 THEN yuksek = yuksek + 1
    NEXT i
    ort = toplam / 12

    CALL uxbrowser_canvas_init("ekran", 900, 520)
    CALL uxbrowser_canvas_clear("#ffffff")
    CALL uxbrowser_canvas_text(30, 40, "uXBasic Tarayici Kalite Paneli")
    CALL uxbrowser_canvas_text(30, 80, "pH ortalamasi: " + STR(ort))

    FOR i = 1 TO 12
        CALL uxbrowser_canvas_rect(30 + i*60, 300 - CINT(ph(i)*20), 30, CINT(ph(i)*20))
    NEXT i

    IF dusuk > 0 OR yuksek > 0 THEN
        CALL uxbrowser_dom_set_text("rapor", "Uyari: sinir disi olcum var. Dusuk=" + STR(dusuk) + " Yuksek=" + STR(yuksek))
    ELSE
        CALL uxbrowser_dom_set_text("rapor", "Tum olcumler kabul araliginda.")
    END IF
END MAIN
```

Bu programda ön-işleyici hedefi belirler, HTML gövdesi hazırlar, varlık dosyası bağlar. Program tarafında dizi, döngü, koşul, istatistik, grafik çizimi ve metin güncelleme birlikte çalışır. Genç programcı için püf noktası şudur: tarayıcı programı yazarken önce sayfada tek yazı göster, sonra grafik ekle, sonra veri hesapla, en son rapor üret. Her şeyi aynı anda kurarsan hata nerede çıktı anlamazsın.

Derleme örneği:

```powershell
uxb ejs kalite_panel.uxb --js-out dist/web/program.js --html-out dist/web/index.html --manifest-out dist/web/manifest.json --backend-report-json-out out/backend.json
```

---

# 2. Tarayıcı çalışma zamanı fonksiyonları

Tarayıcı çalışma zamanı, uXBasic programının tarayıcı içindeki gözü, eli ve kulağıdır. Tuş, fare, çizim, ses, yerel depolama, dosya seçme, zamanlayıcı ve WASM köprüsü bu ailede düşünülür. Aşağıdaki tablo, cilt 5 içinde kullanılan fonksiyon yüzeyini gösterir.

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxbrowser_canvas_init` | `CALL uxbrowser_canvas_init(id, genişlik, yükseklik)` | Tuval [çizim alanı] (canvas) hazırlar. |
| `uxbrowser_canvas_clear` | `CALL uxbrowser_canvas_clear(renk)` | Tuvali belirtilen renkle temizler. |
| `uxbrowser_canvas_text` | `CALL uxbrowser_canvas_text(x, y, metin)` | Tuvale yazı yazar. |
| `uxbrowser_canvas_rect` | `CALL uxbrowser_canvas_rect(x, y, w, h)` | Dikdörtgen çizer; çubuk grafik ve panel için kullanılır. |
| `uxbrowser_canvas_line` | `CALL uxbrowser_canvas_line(x1, y1, x2, y2)` | Çizgi çizer; grafik ekseni veya bağlantı için kullanılır. |
| `uxbrowser_dom_set_text` | `CALL uxbrowser_dom_set_text(id, metin)` | HTML öğesinin metnini değiştirir. |
| `uxbrowser_local_set` | `CALL uxbrowser_local_set(anahtar, değer)` | Tarayıcı yerel belleğine metin kaydeder. |
| `uxbrowser_local_get` | `değer = CALL uxbrowser_local_get(anahtar)` | Tarayıcı yerel belleğinden metin okur. |
| `uxbrowser_audio_beep` | `CALL uxbrowser_audio_beep(frekans, ms)` | Kısa ses üretir. |
| `uxbrowser_timer_every` | `CALL uxbrowser_timer_every(ms, olay)` | Belirli aralıklarla olay tetikler. |

## Tekil kullanım notları

`uxbrowser_canvas_init`, çizim alanının var olduğunu varsaymaz; önce onu hazırlar. Bunu çağırmadan dikdörtgen veya yazı çizmeye çalışırsan hedef alan yoktur. Küçük örnek: `CALL uxbrowser_canvas_init("ekran", 640, 480)`.

`uxbrowser_canvas_clear`, her karede eski resmi temizlemek için kullanılır. Oyun veya canlı grafik yazarken temizleme ve yeniden çizme sırası önemlidir. Küçük örnek: `CALL uxbrowser_canvas_clear("#000000")`.

`uxbrowser_canvas_text`, sayısal sonucu kullanıcıya göstermek için en hızlı yoldur. Bilimsel ölçüm panelinde, hata mesajında ve eğitim örneğinde kullanılır. Küçük örnek: `CALL uxbrowser_canvas_text(20, 30, "Ortalama=" + STR(ort))`.

`uxbrowser_dom_set_text`, tuval yerine HTML öğesini günceller. Rapor, günlük, sonuç kutusu ve açıklama alanı için daha uygundur. Küçük örnek: `CALL uxbrowser_dom_set_text("rapor", "İşlem bitti")`.

`uxbrowser_local_set` ve `uxbrowser_local_get`, küçük ayarları tarayıcıda saklar. Kullanıcı tema seçimi, son dosya adı, son model adı gibi veriler burada tutulabilir. Büyük veri için dosya veya IndexedDB benzeri yapı gerekir.

## Büyük örnek 2 — Tarayıcıda canlı tank izleme

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "tank.html" BODY
<canvas id="ekran" width="900" height="500"></canvas>
<pre id="gunluk"></pre>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"

EVENT OlcumGeldi
PIPE PhHatti AS F64

SLOT PanelGuncelle ON OlcumGeldi
    DIM ph AS F64
    DIM renk AS STRING
    ph = CALL PhHatti.Read()

    IF ph < 6.8 THEN
        renk = "#ffdddd"
    ELSEIF ph > 7.6 THEN
        renk = "#ddddff"
    ELSE
        renk = "#ddffdd"
    END IF

    CALL uxbrowser_canvas_clear(renk)
    CALL uxbrowser_canvas_text(30, 40, "Tank pH: " + STR(ph))
    CALL uxbrowser_canvas_rect(30, 120, CINT(ph * 80), 40)
    CALL uxbrowser_dom_set_text("gunluk", "Son olcum: " + STR(ph) + " zaman=" + STR(TIMER()))
    CALL uxbrowser_local_set("son_ph", STR(ph))
END SLOT

THREAD SensorBenzetimi
    DIM i AS I32
    DIM ph AS F64
    FOR i = 1 TO 20
        ph = 6.7 + RND() * 1.1
        CALL PhHatti.Write(ph)
        TRIGGER OlcumGeldi
    NEXT i
END THREAD

MAIN
    RANDOMIZE TIMER()
    CALL uxbrowser_canvas_init("ekran", 900, 500)
    CALL SensorBenzetimi()
END MAIN
```

Bu örnekte `EVENT`, `PIPE`, `SLOT`, `THREAD`, `IF`, `ELSEIF`, `FOR`, `RND`, `TIMER`, `CALL`, `STR` ve tarayıcı fonksiyonları birlikte çalışır. Önemli hile şudur: ölçüm doğrudan ekrana yazılmaz; önce boruya girer, sonra olay tetiklenir, sonra slot günceller. Böylece ileride aynı ölçümü dosyaya, grafiğe veya yapay zekaya göndermek istersen ana sensör kodunu bozmazsın.

---

# 3. WAT/WASM hedefi

WASM hedefi, uXBasic’in hızlı ve taşınabilir çekirdek üretme yoludur. Tarayıcıdaki JavaScript tarafı ekrana, DOM’a, dosyaya ve yapay zekaya daha kolay ulaşır; WASM tarafı ise hesapta güçlüdür. Genç programcı için doğru ayrım şudur: çizim, düğme, ağ ve dosya işini JS köprüsüne bırak; yoğun matris, istatistik, sinir ağı veya simülasyon hesabını WASM çekirdeğine taşı.

## WAT/WASM fonksiyon ve çıktı tablosu

| Öğe | Sözdizimi | Görev |
|---|---|---|
| `--emit-wat` | `uxb ewt kaynak.uxb --out program.wat` | WAT üretimini açar. |
| `--wat-out` | `uxb wat kaynak.uxb --out program.wat` | WAT dosya yolunu verir. |
| `--emit-wasm` | `uxb ewm kaynak.uxb --out program.wasm` | WASM üretimini açar. |
| `--wasm-out` | `uxb wsm kaynak.uxb --out program.wasm` | WASM dosya yolunu verir. |
| `--wat2wasm` | `uxb w2w program.wat --out program.wasm` | WAT dosyasını WASM’a çevirir. |
| `ux_wasm_load` | `wasm = CALL ux_wasm_load("program.wasm")` | WASM modülünü yükler. |
| `ux_wasm_call` | `sonuc = CALL ux_wasm_call(wasm, "Fonksiyon", argler)` | WASM içindeki fonksiyonu çağırır. |

## Tekil kullanım notları

WAT üretimi, hatayı görebileceğin aşamadır. WAT metin olduğu için fonksiyon adı, dış çağrı adı, parametre ve yerel değişkenlerin nasıl yazıldığını inceleyebilirsin. WASM ikili olduğu için hata ayıklamak daha zordur; önce WAT doğrula, sonra WASM’a çevir.

WASM tarafında string [metin] taşımak, sayısal değer taşımaktan daha zordur. Bu yüzden ilk WASM örneklerini `I32`, `F64`, dizi ve matris hesabıyla kur. Metin, JSON, HTTP ve DOM işini JS tarafında tut. Bu ayrım programı hem hızlı hem anlaşılır yapar.

## Büyük örnek 3 — WASM çekirdeğinde yem dönüşüm hesabı

```uxbasic
%%TARGET WASM

FUNCTION Fcr(yemKg AS F64, artisKg AS F64) AS F64
    IF artisKg <= 0 THEN RETURN -1
    RETURN yemKg / artisKg
END FUNCTION

FUNCTION RiskPuani(fcr AS F64, olumOrani AS F64, phSapma AS F64) AS F64
    DIM puan AS F64
    puan = 0
    IF fcr > 1.40 THEN puan = puan + 30
    IF olumOrani > 2.0 THEN puan = puan + 35
    IF ABS(phSapma) > 0.4 THEN puan = puan + 25
    IF fcr < 0 THEN puan = 100
    RETURN puan
END FUNCTION

MAIN
    DIM f AS F64
    DIM risk AS F64
    f = Fcr(1350.0, 980.0)
    risk = RiskPuani(f, 1.8, 0.22)
    PRINT "FCR=" + STR(f)
    PRINT "Risk=" + STR(risk)
END MAIN
```

Komut zinciri:

```powershell
uxb ewt fcr.uxb --wat-out dist/wasm/fcr.wat --mir-verify-json-out out/mir_verify.json
uxb w2w dist/wasm/fcr.wat --out dist/wasm/fcr.wasm
uxb htm fcr.uxb --html-out dist/web/fcr.html --manifest-out dist/web/manifest.json
```

Bu örnek genç programcıya hedef ayrımını öğretir. Hesap çekirdeği WASM’a uygundur çünkü girişler sayısal, sonuçlar sayısaldır. Aynı hesabın grafiği ve kullanıcı arayüzü tarayıcı JS tarafında yapılır. Böylece ağır iş ile görüntü işi ayrılır.

---

# 4. REST, curl ve Flask köprüsü

REST API, bir programın başka programa web üzerinden soru sormasıdır. uXBasic tarafında iki yol düşünebilirsin: doğrudan `uxhttp` kütüphanesiyle çağırmak veya `curl` gibi dış aracı güvenli sarmalayıcıyla çalıştırmak. Üretim işinde anahtarı ve URL’yi kaynak içine gömmek doğru değildir; ortam değişkeni, ayar dosyası veya güvenli küçük aracı kullan.

## HTTP/REST fonksiyonları

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxhttp_get` | `cevap = CALL uxhttp_get(url)` | HTTP GET isteği yapar. |
| `uxhttp_post_json` | `cevap = CALL uxhttp_post_json(url, json)` | JSON gövdeli POST isteği yapar. |
| `uxhttp_set_header` | `CALL uxhttp_set_header(h, ad, değer)` | İstek başlığı ekler. |
| `uxjson_parse` | `doc = CALL uxjson_parse(metin)` | JSON metnini belgeye çevirir. |
| `uxjson_get` | `değer = CALL uxjson_get(doc, yol)` | JSON içinden alan okur. |
| `uxjson_stringify` | `metin = CALL uxjson_stringify(doc)` | JSON belgeyi metne çevirir. |
| `uxcurl_exec` | `cevap = CALL uxcurl_exec(komut)` | curl tabanlı güvenli sarmalayıcı çalıştırır. |

## Tekil kullanım notları

`uxhttp_get`, veri çekmek için kullanılır: hava durumu, döviz, yerel sunucu durumu, model listesi gibi. Yanıt her zaman beklediğin biçimde gelmeyebilir; önce boş mu, sonra JSON mu kontrol et.

`uxhttp_post_json`, veri göndermek için kullanılır: Flask sunucusuna ölçüm, yapay zekaya prompt, kendi REST servisine analiz isteği. Gönderdiğin JSON içinde tırnak işaretlerini doğru kaçırmak önemlidir.

`uxjson_parse`, cevabı metin olmaktan çıkarıp alan alan okuyabileceğin belgeye dönüştürür. Büyük hile şudur: API yanıtını doğrudan ekrana basma; önce JSON’dan gerekli alanı çek, sonra kullanıcıya sade rapor ver.

## Büyük örnek 4 — Flask kalite servisiyle konuşma

Dış Flask sunucusu şu işi yapıyor varsayılır: uXBasic’ten gelen 30 üretim ölçüsünü alır, ortalama, standart sapma ve risk sınıfı döndürür. uXBasic tarafı istemcidir.

```uxbasic
INCLUDE "modules/uxhttp.uxmh"
INCLUDE "modules/uxjson.uxmh"
INCLUDE "modules/uxstats.uxmh"

FUNCTION VeriJsonYap() AS STRING
    DIM j AS STRING
    j = "{\"hat\":\"A1\",\"olcum\":["
    FOR i = 1 TO 30
        DIM deger AS F64
        deger = 98.0 + RND() * 5.0
        j = j + STR(deger)
        IF i < 30 THEN j = j + ","
    NEXT i
    j = j + "]}"
    RETURN j
END FUNCTION

MAIN
    RANDOMIZE TIMER()
    DIM istek AS STRING
    DIM cevap AS STRING
    DIM doc AS PTR
    DIM risk AS STRING
    DIM ort AS F64

    istek = VeriJsonYap()
    cevap = CALL uxhttp_post_json("http://127.0.0.1:5050/kalite", istek)

    IF LEN(cevap) = 0 THEN
        PRINT "Sunucu cevap vermedi"
        END
    END IF

    doc = CALL uxjson_parse(cevap)
    ort = VAL(CALL uxjson_get(doc, "$.ortalama"))
    risk = CALL uxjson_get(doc, "$.risk")

    PRINT "Flask kalite servisi sonucu"
    PRINT "Ortalama=" + STR(ort)
    PRINT "Risk=" + risk

    IF risk = "YUKSEK" THEN
        PRINT "Uretim hatti durdurulup kalibrasyon kontrolu yapilmali."
    ELSE
        PRINT "Hat izlenmeye devam edebilir."
    END IF
END MAIN
```

Bu örnek, dış programla konuşmanın düzenini öğretir. Önce veri hazırlanır, sonra POST yapılır, sonra boş yanıt kontrol edilir, sonra JSON ayrıştırılır, sonra alanlar okunur, en son yorum yapılır. Zeka dolu hile şudur: API yanıtını programın geri kalanına ham metin olarak taşımak yerine `risk`, `ortalama`, `uyarı` gibi anlamlı değişkenlere ayır. Böylece hem test kolaylaşır hem hata mesajı güzelleşir.

---

# 5. Yerel Llama ile çalışma

Yerel Llama, internet olmadan kendi bilgisayarında çalışan dil modelidir. uXBasic tarafında `uxllama` kütüphanesi model açma, prompt gönderme, yanıt alma ve kapatma işini taşır. Yerel modelin iyi tarafı gizlilik ve maliyettir; kötü tarafı hız, bellek ve model dosyası boyutudur.

## Llama fonksiyonları

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxllama_open` | `model = CALL uxllama_open("model.gguf")` | GGUF modelini açar. |
| `uxllama_prompt` | `cevap = CALL uxllama_prompt(model, soru)` | Modele tek soru gönderir. |
| `uxllama_prompt_json` | `json = CALL uxllama_prompt_json(model, soru, sema)` | JSON biçimli yanıt ister. |
| `uxllama_set_param` | `CALL uxllama_set_param(model, ad, değer)` | Sıcaklık, üst örnekleme gibi ayarları yapar. |
| `uxllama_close` | `CALL uxllama_close(model)` | Model kaynağını kapatır. |

## Tekil kullanım notları

`uxllama_open`, ağır bir çağrıdır; her soru için model açıp kapatma. Modeli program başında aç, soruları gönder, program sonunda kapat. Bu, dosyayı her satırda açıp kapatmamak gibidir.

`uxllama_prompt`, serbest metin yanıtı için uygundur. Ama üretim programında serbest metin zor işlenir. Bu yüzden rapor özeti, açıklama, kullanıcıya tavsiye gibi yerlerde kullan.

`uxllama_prompt_json`, makineyle tekrar işlenecek yanıtlar için daha iyidir. Örneğin “risk: düşük/orta/yüksek, neden: ..., öneri: ...” gibi alanlar istenebilir.

## Büyük örnek 5 — Yerel Llama ile laboratuvar raporu yorumlatma

```uxbasic
INCLUDE "modules/uxllama.uxmh"
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM ph(1 TO 12) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM minv AS F64
    DIM maxv AS F64
    DIM model AS PTR
    DIM prompt AS STRING
    DIM yorum AS STRING

    ph(1)=7.12: ph(2)=7.18: ph(3)=7.31: ph(4)=7.44
    ph(5)=7.02: ph(6)=6.88: ph(7)=7.20: ph(8)=7.29
    ph(9)=7.33: ph(10)=7.09: ph(11)=7.15: ph(12)=7.50

    minv = ph(1): maxv = ph(1)
    FOR i = 1 TO 12
        toplam = toplam + ph(i)
        IF ph(i) < minv THEN minv = ph(i)
        IF ph(i) > maxv THEN maxv = ph(i)
    NEXT i
    ort = toplam / 12

    model = CALL uxllama_open("models/lab_assistant.gguf")
    IF model = 0 THEN
        PRINT "Model acilamadi; yalniz sayisal rapor yaziliyor."
        PRINT "Ortalama=" + STR(ort) + " Min=" + STR(minv) + " Max=" + STR(maxv)
        END
    END IF

    prompt = "Bir su urunleri laboratuvarinda pH ortalamasi " + STR(ort)
    prompt = prompt + ", minimum " + STR(minv) + ", maksimum " + STR(maxv)
    prompt = prompt + ". Kisa risk yorumu ve 3 pratik oneri yaz."

    yorum = CALL uxllama_prompt(model, prompt)
    PRINT "Sayisal ozet: ort=" + STR(ort) + " min=" + STR(minv) + " max=" + STR(maxv)
    PRINT "Yapay zeka yorumu:"
    PRINT yorum

    CALL uxllama_close(model)
END MAIN
```

Bu örnekte yapay zeka hesabı yapmaz; hesabı uXBasic yapar. Yapay zeka yorumu yapar. Bu ayrım çok önemlidir. Genç programcı şu kuralı öğrenmeli: kesin sayısal hesap makine mantığıyla yapılır; açıklama, özet, rapor dili ve öneri yapay zekaya bırakılabilir. Böylece yanlış sayısal yanıt riskini azaltırsın.

---

# 6. ChatGPT/OpenAI ile mesajlaşma

Bulut yapay zeka kullanırken API anahtarını kaynak kodun içine yazma. `OPENAI_API_KEY` gibi ortam değişkeninden oku veya güvenli aracı servis kullan. uXBasic tarafında `uxhttp` ile doğrudan istek yapabilir ya da `uxai` gibi sarmalayıcı kütüphane kullanabilirsin. Modern kullanımda yanıt üretimi için model adı ve giriş metni gönderilir; yanıt JSON olarak alınır.

## OpenAI/ChatGPT fonksiyon yüzeyi

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxai_openai_set_key_from_env` | `CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")` | API anahtarını ortam değişkeninden alır. |
| `uxai_openai_response` | `cevap = CALL uxai_openai_response(model, girdi)` | Tek yanıt üretir. |
| `uxai_openai_response_json` | `json = CALL uxai_openai_response_json(model, girdi, sema)` | JSON biçimli yanıt ister. |
| `uxai_openai_cost_guard` | `CALL uxai_openai_cost_guard(enCokToken, enCokDeneme)` | Maliyet ve tekrar sınırı koyar. |
| `uxai_openai_save_log` | `CALL uxai_openai_save_log(yol)` | İstek/yanıt özetini güvenli günlükler. |

## Tekil kullanım notları

`uxai_openai_set_key_from_env`, güvenlik için önemlidir. Anahtarı kaynak içine yazarsan GitHub’a yanlışlıkla yüklendiğinde hesabın zarar görebilir. Ortam değişkeni kullanmak en basit güvenli alışkanlıktır.

`uxai_openai_response`, kullanıcıya açıklama, özet, kod taslağı, rapor dili üretmek için kullanılır. Hassas veri gönderirken dikkat et; gerçek kişi verisi, ticari sır veya API anahtarı prompt içine konmaz.

`uxai_openai_response_json`, programın tekrar okuyacağı yanıtlar için kullanılır. Örneğin kalite kontrol yorumunun `risk`, `neden`, `oneriler` alanlarıyla dönmesi istenebilir.

## Büyük örnek 6 — ChatGPT ile üretim kalite raporu yazdırma

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxai.uxmh"
INCLUDE "modules/uxjson.uxmh"

MAIN
    DIM olcum(1 TO 30) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM sapma AS F64
    DIM limitAlt AS F64
    DIM limitUst AS F64
    DIM hata AS I32
    DIM prompt AS STRING
    DIM cevap AS STRING

    limitAlt = 96.0
    limitUst = 104.0
    RANDOMIZE 2026

    FOR i = 1 TO 30
        olcum(i) = 98.0 + RND() * 8.0
        toplam = toplam + olcum(i)
        IF olcum(i) < limitAlt OR olcum(i) > limitUst THEN hata = hata + 1
    NEXT i
    ort = toplam / 30

    sapma = 0
    FOR i = 1 TO 30
        sapma = sapma + (olcum(i)-ort) * (olcum(i)-ort)
    NEXT i
    sapma = SQRT(sapma / 29)

    prompt = "30 uretim olcumu icin ortalama=" + STR(ort)
    prompt = prompt + ", standart sapma=" + STR(sapma)
    prompt = prompt + ", limit disi adet=" + STR(hata)
    prompt = prompt + ". Kisa, teknik ve uygulanabilir kalite raporu yaz."

    CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")
    CALL uxai_openai_cost_guard(1200, 1)
    cevap = CALL uxai_openai_response("OPENAI_MODEL", prompt)

    OPEN "kalite_ai_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "uXBasic sayisal ozet"
    PRINT #1, "Ortalama=" + STR(ort)
    PRINT #1, "StdSapma=" + STR(sapma)
    PRINT #1, "Limit disi=" + STR(hata)
    PRINT #1, "Yapay zeka yorumu:"
    PRINT #1, cevap
    CLOSE #1

    PRINT "Rapor yazildi: kalite_ai_raporu.txt"
END MAIN
```

Bu örnek, yapay zekayı doğru yerde kullanmayı öğretir. Ölçüm üretimi, ortalama, standart sapma ve hata sayımı uXBasic tarafındadır. Yapay zeka yalnız rapor dilini güçlendirir. Zeka dolu çözüm şudur: yapay zekadan “hesapla” değil, “hesapladığım sonucu anlaşılır rapora çevir” istenir.

---

# 7. Google Gemini ile mesajlaşma

Gemini tarafında iki yaklaşım vardır. Klasik `generateContent` tarzı tek veya basit çok turlu içerik üretmek için uygundur. Daha yeni etkileşim [çok adımlı konuşma ve araç akışı] (Interactions API) yaklaşımı ise ajan, araç kullanımı, sunucu taraflı geçmiş ve uzun iş akışları için düşünülür. uXBasic tarafında bu farkı sarmalayıcı gizleyebilir: sen `uxai_gemini_generate` veya `uxai_gemini_interaction` çağırırsın; ayrıntı kütüphane içinde kalır.

## Gemini fonksiyon yüzeyi

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxai_gemini_set_key_from_env` | `CALL uxai_gemini_set_key_from_env("GEMINI_API_KEY")` | API anahtarını ortam değişkeninden alır. |
| `uxai_gemini_generate` | `cevap = CALL uxai_gemini_generate(model, girdi)` | generateContent çizgisinde yanıt üretir. |
| `uxai_gemini_json` | `json = CALL uxai_gemini_json(model, girdi, sema)` | Yapılandırılmış JSON yanıt ister. |
| `uxai_gemini_interaction` | `id = CALL uxai_gemini_interaction(model, girdi)` | Çok adımlı etkileşim başlatır. |
| `uxai_gemini_continue` | `cevap = CALL uxai_gemini_continue(id, girdi)` | Önceki etkileşimden devam eder. |

## Büyük örnek 7 — Gemini ile tabloyu sınıflandırma

```uxbasic
INCLUDE "modules/uxai.uxmh"
INCLUDE "modules/uxjson.uxmh"

MAIN
    DIM veri AS STRING
    DIM sema AS STRING
    DIM cevap AS STRING
    DIM doc AS PTR
    DIM risk AS STRING
    DIM neden AS STRING

    veri = "TankA pH=7.1 DO=8.2 Sicaklik=19.4; "
    veri = veri + "TankB pH=6.5 DO=5.1 Sicaklik=23.0; "
    veri = veri + "TankC pH=7.3 DO=7.8 Sicaklik=20.2"

    sema = "{risk:string, neden:string, acil_oneri:string}"

    CALL uxai_gemini_set_key_from_env("GEMINI_API_KEY")
    cevap = CALL uxai_gemini_json("GEMINI_MODEL", "Bu su kalitesi ozetini siniflandir: " + veri, sema)

    doc = CALL uxjson_parse(cevap)
    risk = CALL uxjson_get(doc, "$.risk")
    neden = CALL uxjson_get(doc, "$.neden")

    PRINT "Gemini risk=" + risk
    PRINT "Neden=" + neden

    IF risk = "YUKSEK" THEN
        PRINT "Acil kontrol: oksijen ve sicaklik."
    ELSE
        PRINT "Rutin izleme yeterli."
    END IF
END MAIN
```

Burada yine kural aynıdır: yapay zeka sınıflandırır ve yorumlar; program karar zincirini temiz şekilde uygular. Yanıtı JSON istemek büyük bir hiledir. Serbest metin insan için iyidir, JSON program için iyidir.

---

# 8. Bilimsel analiz defteri

Bilimsel analizde en büyük hata, testi ezberleyip yanlış yerde kullanmaktır. Z testi, t testi, F testi, ANOVA, korelasyon, regresyon, ki-kare, normal dağılım kontrolü ve güven aralığı farklı sorulara cevap verir. uXBasic tarafında `uxstats` ve `uxstats2` fonksiyonları bu işi taşır. Genç programcı her analizden önce şu soruyu sorar: “Ben ortalama mı karşılaştırıyorum, varyans mı karşılaştırıyorum, ilişki mi arıyorum, sınıf sayısı mı sayıyorum?”

## Analiz fonksiyonları tablosu

| Fonksiyon | Sözdizimi | Ne zaman kullanılır? |
|---|---|---|
| `uxstats_vec_create` | `v = CALL uxstats_vec_create()` | Sayısal veri listesi açar. |
| `uxstats_vec_push` | `CALL uxstats_vec_push(v, değer)` | Listeye ölçüm ekler. |
| `uxstats_vec_mean` | `ort = CALL uxstats_vec_mean(v)` | Ortalama hesaplar. |
| `uxstats_vec_stddev` | `sd = CALL uxstats_vec_stddev(v)` | Standart sapma hesaplar. |
| `uxstats_vec_min` | `mn = CALL uxstats_vec_min(v)` | En küçük değeri verir. |
| `uxstats_vec_max` | `mx = CALL uxstats_vec_max(v)` | En büyük değeri verir. |
| `uxstats2_one_sample_z` | `z = CALL uxstats2_one_sample_z(ort, mu, sigma, n)` | Örnek ortalamasını bilinen toplum ortalamasıyla karşılaştırır. |
| `uxstats2_t_independent` | `t = CALL uxstats2_t_independent(v1, v2)` | İki bağımsız grubun ortalamasını karşılaştırır. |
| `uxstats2_f_variance` | `f = CALL uxstats2_f_variance(var1, n1, var2, n2)` | İki varyansı karşılaştırır. |
| `uxstats2_anova_oneway` | `sonuc = CALL uxstats2_anova_oneway(dosya)` | Üç veya daha fazla grubun ortalamasını karşılaştırır. |
| `uxstats2_corr` | `r = CALL uxstats2_corr(x, y)` | İki değişken arasındaki doğrusal ilişkiyi ölçer. |
| `uxstats2_regression` | `m = CALL uxstats2_regression(x, y)` | Bir değişkenle diğerini tahmin eder. |
| `uxstats2_chisq` | `x2 = CALL uxstats2_chisq(gozlenen, beklenen)` | Sayım verilerinde beklenen/gerçek farkını inceler. |

## Hangi test neye cevap verir?

Z testi, toplum standart sapması biliniyorsa ve örnek ortalamasının beklenen ortalamadan farkını sormak istiyorsan kullanılır. T testi, toplum standart sapması bilinmediğinde veya iki grup ortalaması karşılaştırıldığında daha yaygındır. F testi iki grubun değişkenliği farklı mı diye sorar. ANOVA üç veya daha fazla grup ortalaması arasında fark var mı diye bakar. Korelasyon iki değişken birlikte artıyor mu, azalıyor mu diye bakar. Regresyon bir değişkenden diğerini tahmin etmeye çalışır. Ki-kare testi sayım tablolarında beklenen ile gözlenen sayıların uyumunu inceler.

## Büyük örnek 8 — 30 verilik üretim kalite kontrolü

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM agirlik(1 TO 30) AS F64
    DIM i AS I32
    DIM toplam AS F64
    DIM ort AS F64
    DIM sd AS F64
    DIM alt AS F64
    DIM ust AS F64
    DIM limitDisi AS I32
    DIM z AS F64

    alt = 95.0
    ust = 105.0
    RANDOMIZE 42

    FOR i = 1 TO 30
        agirlik(i) = 96.0 + RND() * 11.0
        toplam = toplam + agirlik(i)
        IF agirlik(i) < alt OR agirlik(i) > ust THEN limitDisi = limitDisi + 1
    NEXT i

    ort = toplam / 30
    sd = 0
    FOR i = 1 TO 30
        sd = sd + (agirlik(i)-ort) * (agirlik(i)-ort)
    NEXT i
    sd = SQRT(sd / 29)

    z = CALL uxstats2_one_sample_z(ort, 100.0, 3.0, 30)

    PRINT "Uretim kalite kontrol raporu"
    PRINT "Ortalama=" + STR(ort)
    PRINT "StdSapma=" + STR(sd)
    PRINT "Limit disi adet=" + STR(limitDisi)
    PRINT "Z=" + STR(z)

    IF limitDisi > 2 THEN
        PRINT "HATA ANALIZI: limit disi urun sayisi yuksek. Makine ayari kontrol edilmeli."
    ELSEIF ABS(z) > 1.96 THEN
        PRINT "HATA ANALIZI: ortalama hedef degerden anlamli sapmis olabilir."
    ELSEIF sd > 4.0 THEN
        PRINT "HATA ANALIZI: uretim dagilimi genis. Hammadde veya dozaj dalgalaniyor olabilir."
    ELSE
        PRINT "YORUM: uretim kabul edilebilir gorunuyor."
    END IF
END MAIN
```

Bu örnek basit gibi görünür ama gerçek üretim düşüncesini öğretir. Tek başına ortalama yeterli değildir; standart sapma ve limit dışı adet de gerekir. Zeka dolu çözüm şudur: hata mesajını tek koşula bağlama. Önce en ağır sorunu yakala, sonra ortalama kayması, sonra değişkenlik, en son normal sonuç.

## Büyük örnek 9 — İki yem denemesini F testi ve t testiyle karşılaştırma

```uxbasic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM yemA AS PTR
    DIM yemB AS PTR
    DIM i AS I32
    DIM a AS F64
    DIM b AS F64
    DIM f AS F64
    DIM t AS F64
    DIM yorum AS STRING

    yemA = CALL uxstats_vec_create()
    yemB = CALL uxstats_vec_create()

    FOR i = 1 TO 15
        CALL uxstats_vec_push(yemA, 1.20 + RND()*0.20)
        CALL uxstats_vec_push(yemB, 1.28 + RND()*0.35)
    NEXT i

    a = CALL uxstats_vec_mean(yemA)
    b = CALL uxstats_vec_mean(yemB)
    f = CALL uxstats2_f_variance(CALL uxstats_vec_var(yemA), 15, CALL uxstats_vec_var(yemB), 15)
    t = CALL uxstats2_t_independent(yemA, yemB)

    PRINT "Yem A ort=" + STR(a)
    PRINT "Yem B ort=" + STR(b)
    PRINT "F varyans=" + STR(f)
    PRINT "T ortalama=" + STR(t)

    IF f > 2.5 THEN
        yorum = "Yem gruplarinin degiskenligi farkli olabilir; once varyans farkini raporla."
    ELSEIF ABS(t) > 2.05 THEN
        yorum = "Ortalama farki dikkat cekici; biyolojik ve ekonomik anlamini incele."
    ELSE
        yorum = "Belirgin fark gorunmuyor; daha cok tekrar gerekebilir."
    END IF
    PRINT yorum

    CALL uxstats_vec_free(yemA)
    CALL uxstats_vec_free(yemB)
END MAIN
```

Burada F testi ve t testi birlikte düşünülür. Önce değişkenlik çok farklı mı diye bakarsın; sonra ortalama farkını yorumlarsın. Genç programcı için ders: istatistik tek sayı değildir, karar zinciridir.

---

# 9. Veri çerçevesi, SQL ve dosya üretimi

Veri çerçevesi [satır ve sütunlardan oluşan tablo] (dataframe), CSV veya Parquet gibi dosyaları program içinde tablo gibi kullanmayı sağlar. `uxdataframe` ve `uxdataset` büyük veriyi doğrudan BASIC dizisine doldurmak yerine handle [kaynak tutamacı] üzerinden taşır. Bu daha hızlı ve daha güvenlidir.

## Veri fonksiyonları

| Fonksiyon | Sözdizimi | Görev |
|---|---|---|
| `uxdataframe_load_csv` | `df = CALL uxdataframe_load_csv("veri.csv")` | CSV dosyasını tablo olarak açar. |
| `uxdataframe_row_count` | `n = CALL uxdataframe_row_count(df)` | Satır sayısını verir. |
| `uxdataframe_col_count` | `m = CALL uxdataframe_col_count(df)` | Sütun sayısını verir. |
| `uxdataframe_filter` | `df2 = CALL uxdataframe_filter(df, koşul)` | Satır süzer. |
| `uxdataframe_group_mean` | `rapor = CALL uxdataframe_group_mean(df, grup, alan)` | Grup ortalaması alır. |
| `uxdataframe_to_csv` | `CALL uxdataframe_to_csv(df, "rapor.csv")` | Tabloyu CSV olarak yazar. |
| `uxdataframe_free` | `CALL uxdataframe_free(df)` | Tablo kaynağını kapatır. |
| `uxsqlite_query` | `tablo = CALL uxsqlite_query(db, sql)` | SQLite sorgusu çalıştırır. |

## Büyük örnek 10 — CSV’den rapora, rapordan HTML’e

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "rapor.html" BODY
<h1>Uretim Veri Raporu</h1>
<pre id="ozet"></pre>
%%HTML_END

INCLUDE "modules/uxdataframe.uxmh"
INCLUDE "modules/uxbrowser.uxmh"

MAIN
    DIM df AS PTR
    DIM temiz AS PTR
    DIM n AS I32
    DIM m AS I32
    DIM ort AS F64
    DIM rapor AS STRING

    df = CALL uxdataframe_load_csv("uretim.csv")
    IF df = 0 THEN
        PRINT "CSV acilamadi"
        END
    END IF

    n = CALL uxdataframe_row_count(df)
    m = CALL uxdataframe_col_count(df)
    temiz = CALL uxdataframe_filter(df, "durum='OK'")
    ort = CALL uxdataframe_mean(temiz, "agirlik")

    rapor = "Satir=" + STR(n) + " Sutun=" + STR(m) + CHR(10)
    rapor = rapor + "OK agirlik ortalamasi=" + STR(ort)

    CALL uxdataframe_to_csv(temiz, "temiz_uretim.csv")
    CALL uxbrowser_dom_set_text("ozet", rapor)
    PRINT rapor

    CALL uxdataframe_free(temiz)
    CALL uxdataframe_free(df)
END MAIN
```

Bu örnekte tabloyu BASIC dizisine tek tek taşımıyoruz. `df` bir handle’dır; tabloyu temsil eder. Filtreleme ve ortalama kütüphane tarafında yapılır. Bu büyük veri için daha doğru yoldur. Kullanıcıya öğüt: küçük veride dizi iyidir, büyük veride handle ve kütüphane fonksiyonu iyidir.

---

# 10. Derleyici geliştiricisi için zeka dolu hileler

Bu cilt yalnız program yazmayı değil, derleyici geliştirme alışkanlığını da öğretir. uXBasic gibi bir dilde en büyük tehlike, özellik eklediğini sanıp yalnız anahtar kelime eklemektir. Gerçek özellik, lexer’dan başlar, parser düğümüne gider, AST sözleşmesi tutar, anlam katmanı bilir, MIR indirir, backend hedefe yazar, runtime çalıştırır, CLI rapor üretir, test kapısı kanıtlar.

## Hile tablosu

| Hile | Ne yapar? | Neden zekicedir? |
|---|---|---|
| Çıktı sözleşmesi | Hangi komut hangi dosyayı üretmeli, önceden yazar. | Test uydurmayı engeller. |
| Kaynak konumu taşıma | Her düğüm satır/sütun bilgisini taşır. | Hata mesajını insani yapar. |
| JSON ara rapor | Token, AST, MIR, sembol ve tip tabloları dışarı verilir. | VSCode ve test araçları derleyiciyi okuyabilir. |
| Hook azlığı | Sadece önemli noktalara kanca koyulur. | İzleme sistemi çöplüğe dönmez. |
| Wrapper inceliği | Dış kütüphane karmaşası tek yerde saklanır. | Dil çekirdeği şişmez. |
| Fail-close kapı | Kritik kapı istenirse eksikte geçmez. | “Çalıştı gibi” dönemini bitirir. |
| Önce küçük hedef | Önce PRINT ve IF, sonra dosya, sonra JS, sonra WASM. | Hatanın kaynağı dar kalır. |

## Büyük örnek 11 — Kaynak dosyadan tüm kanıtları üretme

```powershell
uxb tjs main.uxb --out out/tokens.json
uxb pjo main.uxb --out out/parser.json
uxb ajo main.uxb --out out/ast.json
uxb syj main.uxb --out out/symbol_table.json
uxb tyj main.uxb --out out/type_table.json
uxb mfj main.uxb --out out/mir_full.json
uxb mvj main.uxb --out out/mir_verify.json
uxb jso main.uxb --out dist/web/program.js
uxb wat main.uxb --out dist/wasm/program.wat
uxb htm main.uxb --out dist/web/index.html
uxb man main.uxb --out dist/web/manifest.json
uxb rrj main.uxb --out out/run_report.json
```

Bu komutlar bir gencin elindeki büyüteçtir. Kaynağın kelimeye, ağaca, sembol tablosuna, tipe, MIR’e, JS’e, WAT’a ve HTML’e nasıl dönüştüğünü gösterir. Böyle çalışan kişi yalnız kullanıcı değil, derleyici geliştiricisi olur.

---

# 11. Son büyük birleşik örnek — Web paneli, istatistik, yapay zeka ve rapor

Aşağıdaki örnek tek dosyada birçok fikri birleştirir. Satır sayısı çok uzatılmadı ama iş mantığı gerçektir: ölçümler alınır, kalite istatistiği hesaplanır, tarayıcı paneline yazılır, yerel veya bulut yapay zekaya yorumlatılır, dosyaya rapor üretilir.

```uxbasic
%%TARGET BROWSER
%%HTML_BEGIN "index.html" BODY
<canvas id="ekran" width="960" height="540"></canvas>
<pre id="rapor"></pre>
%%HTML_END

INCLUDE "modules/uxbrowser.uxmh"
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxai.uxmh"

FUNCTION KaliteRisk(ort AS F64, sd AS F64, hata AS I32) AS STRING
    IF hata > 3 THEN RETURN "YUKSEK"
    IF ABS(ort - 100.0) > 2.0 THEN RETURN "ORTA"
    IF sd > 3.5 THEN RETURN "ORTA"
    RETURN "DUSUK"
END FUNCTION

MAIN
    DIM v AS PTR
    DIM i AS I32
    DIM deger AS F64
    DIM ort AS F64
    DIM sd AS F64
    DIM hata AS I32
    DIM risk AS STRING
    DIM prompt AS STRING
    DIM yorum AS STRING

    RANDOMIZE TIMER()
    v = CALL uxstats_vec_create()

    FOR i = 1 TO 30
        deger = 96.0 + RND() * 9.0
        CALL uxstats_vec_push(v, deger)
        IF deger < 96.0 OR deger > 104.0 THEN hata = hata + 1
    NEXT i

    ort = CALL uxstats_vec_mean(v)
    sd = CALL uxstats_vec_stddev(v)
    risk = KaliteRisk(ort, sd, hata)

    CALL uxbrowser_canvas_init("ekran", 960, 540)
    CALL uxbrowser_canvas_clear("#ffffff")
    CALL uxbrowser_canvas_text(30, 40, "uXBasic Akilli Kalite Paneli")
    CALL uxbrowser_canvas_text(30, 80, "Ortalama=" + STR(ort))
    CALL uxbrowser_canvas_text(30, 110, "StdSapma=" + STR(sd))
    CALL uxbrowser_canvas_text(30, 140, "Risk=" + risk)

    prompt = "30 uretim olcumu: ortalama=" + STR(ort)
    prompt = prompt + ", standart sapma=" + STR(sd)
    prompt = prompt + ", limit disi=" + STR(hata)
    prompt = prompt + ", risk=" + risk + ". Kisa teknik yorum ve 3 oneri ver."

    CALL uxai_openai_set_key_from_env("OPENAI_API_KEY")
    yorum = CALL uxai_openai_response("OPENAI_MODEL", prompt)
    IF LEN(yorum) = 0 THEN yorum = "Yapay zeka yaniti alinamadi; sayisal rapor gecerlidir."

    CALL uxbrowser_dom_set_text("rapor", yorum)

    OPEN "son_kalite_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "Ortalama=" + STR(ort)
    PRINT #1, "StdSapma=" + STR(sd)
    PRINT #1, "LimitDisi=" + STR(hata)
    PRINT #1, "Risk=" + risk
    PRINT #1, yorum
    CLOSE #1

    CALL uxstats_vec_free(v)
END MAIN
```

Bu örneğin çalışma mantığı şöyledir: veri önce istatistik vektörüne girer, sonra sayısal değerler hesaplanır, sonra risk fonksiyonu karar verir, sonra tarayıcı paneli güncellenir, sonra yapay zeka rapor dili üretir, son olarak rapor dosyaya yazılır. Kodun iyi tarafı, her görev küçük bir bölüme ayrılmıştır. `KaliteRisk` karar verir, ana program veri ve çıktı akışını yönetir, kütüphaneler istatistik ve yapay zeka işini taşır.

Genç programcı için son öğüt: bir programı büyütmenin doğru yolu satır eklemek değil, sorumluluk ayırmaktır. Hesap başka yerde, görüntü başka yerde, yapay zeka başka yerde, dosya başka yerde durursa program büyür ama dağılmaz. uXBasic’in dili, kütüphaneleri, hook ve wrapper düzeni bu yüzden birlikte düşünülmelidir.

---

# Cilt 5 kısa içindekiler

1. Web hedefi ve çıktı dosyaları
2. Tarayıcı çalışma zamanı fonksiyonları
3. WAT/WASM hedefi
4. REST, curl ve Flask köprüsü
5. Yerel Llama ile çalışma
6. ChatGPT/OpenAI ile mesajlaşma
7. Google Gemini ile mesajlaşma
8. Bilimsel analiz defteri
9. Veri çerçevesi, SQL ve dosya üretimi
10. Derleyici geliştiricisi için zeka dolu hileler
11. Web paneli, istatistik, yapay zeka ve rapor birleşik örneği
