# uXBasic Programlayıcının Cep Kitabı — Cilt 5
## Tarayıcı, WAT/WASM, REST, Flask, Yapay Zeka, Bilimsel Analiz ve Derleyici Hileleri

## Tarayıcı çıktısı: JS hattı

uXBasic JS çıktısı `program.js` üretir. Tarayıcı tarafında `ux_runtime.js`, `ux_canvas2d.js`, `ux_audio.js`, `ux_file.js`, `ux_ai_bridge.js`, `ux_wasm_bridge.js` gibi çalışma zamanı dosyaları kullanılır.

```basic
MAIN
    PRINT "Tarayicidan merhaba"
    CALL(JS, "ux.canvas.clear", 0)
    CALL(JS, "ux.canvas.text", 20, 40, "uXBasic JS cikti")
END MAIN
```

Beklenen çıktı:

```text
dist/web/program.js
index.html
runtime/browser/ux_runtime.js
```

İpucu: Tarayıcıda dosya yolu Windows gibi `dist\web\program.js` değil, çoğu zaman `dist/web/program.js` olarak daha güvenlidir.

## WAT/WASM hattı

WAT [WebAssembly metin biçimi] (WebAssembly Text) hızlı tarayıcı çalışması için ara çıktıdır.

```basic
MAIN
    DIM a AS I32
    DIM b AS I32
    a = 40
    b = 2
    PRINT a + b
END MAIN
```

Komut:

```powershell
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

WAT çıktısı üretildiğinde ayrıca doğrulayıcıyla dene. Çünkü WAT söz dizimi küçük hatada bile yüklenmez.

## Canvas, ses ve kullanıcı girdisi

```basic
MAIN
    CALL(JS, "ux.canvas.init", "ekran", 800, 600)
    CALL(JS, "ux.canvas.rect", 10, 10, 200, 80)
    CALL(JS, "ux.canvas.text", 20, 50, "Tank 1")
    CALL(JS, "ux.audio.beep", 440, 200)
END MAIN
```

Bu örnek grafik, yazı ve sesi aynı anda gösterir. Gerçek oyun yazarken her karede tüm ekranı silmek yerine değişen bölgeyi çizmek daha hızlıdır.

## REST API ve curl

REST API [web üzerinden veri alışverişi düzeni] (REST API) için en basit yol dış `curl` çağrısıdır.

```basic
MAIN
    DIM komut AS STRING
    komut = "curl -s https://api.github.com"
    CALL(API, "system", komut)
END MAIN
```

Güvenlik ipucu: Kullanıcıdan gelen metni komuta doğrudan ekleme. Şöyle yapma:

```basic
' Tehlikeli
INPUT url
CALL(API, "system", "curl " + url)
```

Önce izinli alan adı listesi oluştur.

## Flask API ile konuşma

Flask [Python ile küçük web sunucusu kurma aracı] (Flask) tarafı örnek:

```python
from flask import Flask, request, jsonify
app = Flask(__name__)

@app.post('/topla')
def topla():
    data = request.json
    return jsonify({'sonuc': data['a'] + data['b']})

app.run(port=5050)
```

uXBasic tarafı:

```basic
MAIN
    CALL(API, "system", "curl -s -X POST http://127.0.0.1:5050/topla -H "Content-Type: application/json" -d "{\"a\":3,\"b\":4}"")
END MAIN
```

Bu yöntemle uXBasic dış dünyaya açılır. Ağ hatası, sunucu kapalı, JSON bozuk gibi durumları ayrı test et.

## Yerel Llama ile mesajlaşma

```basic
INCLUDE "modules/uxllama.uxmh"

MAIN
    DIM model AS PTR
    DIM cevap AS STRING
    model = CALL uxllama_open("models/llama.gguf")
    IF model = 0 THEN
        PRINT "Model acilamadi"
        END
    END IF
    cevap = CALL uxllama_prompt(model, "Bana bir BASIC ornegi yaz")
    PRINT cevap
    CALL uxllama_close(model)
END MAIN
```

Yerel modelde hız ekran kartı, bellek ve model boyutuna bağlıdır. Büyük model daha iyi cevap verebilir ama daha yavaş çalışır.

## ChatGPT/OpenAI ile mesajlaşma

OpenAI tarafında güncel metin üretim hattı Responses API üzerinden kurulabilir; resmi API başvurusunda `responses.create` uç noktası ve `model`, `input` gibi alanlar gösterilir. API anahtarını kaynak kodun içine yazma; ortam değişkeninden oku.

```basic
MAIN
    DIM soru AS STRING
    soru = "uXBasic icin kisa bir ornek ver"
    CALL(API, "system", "curl https://api.openai.com/v1/responses -H "Authorization: Bearer %OPENAI_API_KEY%" -H "Content-Type: application/json" -d "{\"model\":\"gpt-5.2\",\"input\":\"" + soru + "\"}"")
END MAIN
```

Üretim ortamında `system` yerine özel HTTP kütüphanesi veya güvenli küçük bir aracı program kullan. Böylece anahtar günlük dosyasına düşmez.

## Google Gemini ile mesajlaşma

Google Gemini için kararlı üretim kullanımında `generateContent` API desteklenir; yeni Interactions API çok adımlı araç kullanımı ve ajan iş akışları için önerilir ama beta olduğu için kırılma riski taşır.

```basic
MAIN
    DIM soru AS STRING
    soru = "uXBasic ile dizi ornegi ver"
    CALL(API, "system", "curl -s https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=%GEMINI_API_KEY% -H "Content-Type: application/json" -d "{\"contents\":[{\"parts\":[{\"text\":\"" + soru + "\"}]}]}"")
END MAIN
```

## Bilimsel veri: belge yazma, okuma ve analiz

```basic
INCLUDE "modules/uxstats.uxmh"

MAIN
    DIM v AS PTR
    v = CALL uxstats_vec_create()
    CALL uxstats_vec_push(v, 10.2)
    CALL uxstats_vec_push(v, 11.4)
    CALL uxstats_vec_push(v, 9.8)
    CALL uxstats_vec_push(v, 12.1)

    OPEN "analiz_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "Ortalama=" + STR(CALL uxstats_vec_mean(v))
    PRINT #1, "StdSapma=" + STR(CALL uxstats_vec_stddev(v))
    CLOSE #1

    CALL uxstats_vec_free(v)
END MAIN
```

## Z testi

Z testi, örnek ortalamasını bilinen toplum ortalamasıyla karşılaştırmak için kullanılır. Toplum standart sapması biliniyorsa daha uygundur.

```basic
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM z AS F64
    z = CALL uxstats2_one_sample_z(105.0, 100.0, 15.0, 36)
    PRINT "Z skoru=" + STR(z)
    IF ABS(z) > 1.96 THEN
        PRINT "Yaklasik olarak anlamli fark olabilir"
    ELSE
        PRINT "Belirgin fark gorunmuyor"
    END IF
END MAIN
```

## F testi

F testi iki varyansı karşılaştırır. Örneğin iki tank grubunda ağırlık değişkenliği farklı mı diye bakılır.

```basic
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM f AS F64
    f = CALL uxstats2_f_variance(12.5, 20, 8.1, 18)
    PRINT "F=" + STR(f)
END MAIN
```

## ANOVA

ANOVA [varyans çözümlemesi] (ANOVA) üç veya daha fazla grubun ortalamasını karşılaştırmak için kullanılır.

```basic
INCLUDE "modules/uxstats2.uxmh"

MAIN
    DIM sonuc AS PTR
    sonuc = CALL uxstats2_anova_oneway("gruplar.csv")
    PRINT CALL uxstats2_anova_summary(sonuc)
END MAIN
```

## Veri çerçevesi ve CSV

```basic
INCLUDE "modules/uxdataframe.uxmh"

MAIN
    DIM df AS PTR
    df = CALL uxdataframe_load_csv("olcum.csv")
    PRINT CALL uxdataframe_row_count(df)
    PRINT CALL uxdataframe_col_count(df)
    CALL uxdataframe_describe(df, "rapor.csv")
    CALL uxdataframe_free(df)
END MAIN
```

## Derleyici yazarken zeka dolu hileler

1. **Her aşamada çıktı üret:** `tokens.json`, `ast.json`, `mir.json` yoksa nerede bozulduğunu bulamazsın.
2. **Placeholder üretme:** Eksik dosyayı uydurmak test değil, kandırmacadır.
3. **Kaynak konumu sakla:** Her AST düğümü satır/sütun bilsin.
4. **Sözleşme dosyası kullan:** Hangi komut hangi çıktıyı üretmeli, CSV/JSON ile yaz.
5. **Fail-close kullan:** Önemli kapı açıkça istenirse eksikte geçmesin.
6. **Sarmalayıcıyı ince tut:** DLL/API karmaşasını dil çekirdeğine doldurma; `DECLARE`, `CALL`, `ALIAS`, `MODULE` ile bağla.
7. **Kanca [araya giren ek nokta] (hook) az olsun:** Her yere hook koyarsan sistem izlenmez olur. Kanca yalnız ölçüm, rapor veya özel hedef gerektiğinde kullanılır.
8. **Büyük işi küçük kapılara böl:** ADIM22 çıktı sözleşmesi, ADIM25 AST/MIR, ADIM26 JS/WASM, ADIM27 CLI/backend gibi.

## Gerçekçi büyük örnek: tarayıcıda analiz ve yapay zeka

```basic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxllama.uxmh"

MAIN
    DIM v AS PTR
    DIM ort AS F64
    DIM model AS PTR
    DIM yorum AS STRING

    v = CALL uxstats_vec_create()
    CALL uxstats_vec_push(v, 7.1)
    CALL uxstats_vec_push(v, 7.4)
    CALL uxstats_vec_push(v, 7.2)
    ort = CALL uxstats_vec_mean(v)

    CALL(JS, "ux.canvas.init", "ekran", 640, 480)
    CALL(JS, "ux.canvas.text", 20, 40, "pH ortalamasi=" + STR(ort))

    model = CALL uxllama_open("models/llama.gguf")
    IF model <> 0 THEN
        yorum = CALL uxllama_prompt(model, "pH ortalamasi " + STR(ort) + " olan bir tanki yorumla")
        PRINT yorum
        CALL uxllama_close(model)
    END IF

    CALL uxstats_vec_free(v)
END MAIN
```

Bu örnek birçok katmanı birleştirir: kütüphane ekleme, vektör oluşturma, istatistik hesaplama, tarayıcıya yazı basma, yerel yapay zekaya yorumlatma, kaynak bırakma. İyi programcı böyle örnekleri parça parça kurar. Önce yalnız vektörü dene. Sonra istatistiği ekle. Sonra tarayıcıyı ekle. En son yapay zekayı bağla.

# İçindekiler

## Cilt 1

1. Kullanım hakkı ve sorumluluk sınırı  
2. Ön söz  
3. Genç programcıya öğütler  
4. uXBasic dosyaları  
5. Mimari katmanlar  
6. Komut satırı ve çıktı dosyaları  
7. Hata kodları  
8. İlk program

## Cilt 2

1. Anahtar kelime tablosu  
2. Parser komutları  
3. Her komutun görevi, söz dizimi ve örneği  
4. Ön-işleyici komutları  
5. Veri tipleri  
6. İşleçler  
7. Yerel fonksiyonlar

## Cilt 3

1. Değişkenler  
2. Çok boyutlu diziler  
3. ARRAY/LIST/DICT/SET  
4. TYPE ve CLASS  
5. NAMESPACE/MODULE/USING/ALIAS  
6. INCLUDE/IMPORT  
7. DLL ve Windows API  
8. Dosya, terminal, olay, thread, pipe, slot

## Cilt 4

1. Runtime genişletme kütüphaneleri  
2. Her kütüphanenin görev tablosu  
3. Fonksiyon prototipleri  
4. Küçük kullanım örnekleri  
5. Hata yakalama alışkanlığı

## Cilt 5

1. JS tarayıcı çıktısı  
2. WAT/WASM çıktısı  
3. Canvas/ses/girdi  
4. REST/curl/Flask  
5. Llama, OpenAI, Gemini  
6. Bilimsel analiz  
7. Derleyici hileleri  
8. Büyük birleşik örnek
