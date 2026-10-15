# uXBasic Programlayıcının Cep Kitabı — Cilt 5
# Tarayıcı, JS, WAT/WASM, API, Yerel ve Uzak Yapay Zeka, İstatistik Uygulamaları

Bu cilt programı dış dünyaya çıkarır. Tarayıcı çıktısı için JavaScript [tarayıcıda çalışan betik dili] (JavaScript), WAT [WebAssembly metin gösterimi] (WebAssembly Text) ve WASM [tarayıcı/çalışma zamanı için ikili ara hedef] (WebAssembly) kullanılır. ChatGPT/OpenAI örneği güncel Responses API çizgisini, Gemini örneği klasik `generateContent` ile yeni Interactions API ayrımını dikkate alan bir köprü fikri olarak anlatılır. Gizli anahtar hiçbir zaman kaynak dosyasına düz yazılmamalı; ortam değişkeni veya güvenli yerel köprü kullanılmalıdır.

## Tarayıcı için JS çıktısı
```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
%%HTML_LINE <canvas id="saha" width="640" height="360"></canvas>
%%JS_LINE const ctx = document.getElementById("saha").getContext("2d");
%%JS_LINE ctx.fillText("uXBasic JS cikisi", 20, 30);
MAIN
  PRINT "Tarayici programi basladi"
END MAIN
```
Bu örnekte uXBasic tarafı hedefi tarayıcı seçer, HTML içine tuval [çizim alanı] (canvas) ekler, JavaScript satırıyla çizim bağlamını alır ve programın ana kısmı konsola çıktı verir. Genç programcı için püf noktası: tarayıcı çıktısında dosya yolları Windows ters eğik çizgisiyle değil, web yolu gibi `/` ile düşünülmelidir.

## WAT/WASM çıktısından faydalanma
```uxbasic
%%TARGET wasm
%%WAT_IMPORT ux.print_i32 AS print_i32(i32)
FUNCTION Topla(a AS I32, b AS I32) AS I32
  RETURN a + b
END FUNCTION
MAIN
  PRINT Topla(20, 22)
END MAIN
```
WASM hedefi hesap çekirdeğini tarayıcıya veya başka ev sahibi ortama taşımak içindir. Metin gösterimi olan WAT, derleyicinin ne ürettiğini okumayı kolaylaştırır. Büyük uygulamada kullanıcı arayüzü JS tarafında, hızlı hesap WASM tarafında durabilir.

## REST ve curl mantığı
```uxbasic
DECLARE FUNCTION HttpPost LIB "uxcurl.dll" ALIAS "uxcurl_post" (BYVAL url AS STRING, BYVAL body AS STRING) AS STRING
FUNCTION ApiyeGonder(url AS STRING, mesaj AS STRING) AS STRING
  IF LEN(url) = 0 THEN RETURN "URL yok"
  cevap = CALL(DLL, "uxcurl.dll", "uxcurl_post", url, mesaj)
  IF LEN(cevap) = 0 THEN RETURN "bos cevap"
  RETURN cevap
END FUNCTION
PRINT ApiyeGonder("http://localhost:5000/olcum", "{"ph":7.2}")
```
REST [HTTP üzerinden kaynakla konuşma düzeni] (Representational State Transfer) çağrılarında üç şey önemlidir: adres, gövde ve cevap. uXBasic tarafında bunu sarmalayıcı fonksiyonla toplarsan gizli anahtar, hata kontrolü ve günlük yazımı tek yerde kalır.

## Flask API ile yerel köprü
```uxbasic
DECLARE FUNCTION LocalPost LIB "uxcurl.dll" ALIAS "uxcurl_post" (BYVAL url AS STRING, BYVAL body AS STRING) AS STRING
json = "{"komut":"ortalama","veri":[1,2,3,4]}"
cevap = LocalPost("http://127.0.0.1:5000/analyze", json)
PRINT cevap
```
Flask [Python ile küçük web sunucusu kurma aracı] (Flask) uXBasic için ara köprü olabilir. Python tarafında ağır veri bilimi, uXBasic tarafında dosya, derleme, GUI veya sistem komutları çalışabilir. Bu ayrım genç programcıya şunu öğretir: her işi tek dile sıkıştırma, ama aradaki sözleşmeyi JSON ile net tut.

## Yerel Llama ile konuşma
```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
llm = uxllama.create()
CALL uxllama.set_cli_path(llm, "llama-cli.exe")
CALL uxllama.set_model_path(llm, "models/yerel.gguf")
CALL uxllama.set_threads(llm, 4)
cevap = uxllama.prompt(llm, "Bir laboratuvar raporu icin pH=7.2 degerini yorumla.")
PRINT cevap
CALL uxllama.free(llm)
```
Yerel model kullanmanın avantajı verinin bilgisayardan çıkmamasıdır. Dezavantajı donanım, bellek ve model dosyası yönetimidir. uXBasic burada modeli doğrudan içine gömmek zorunda değildir; `uxllama` sarmalayıcısı komut satırı aracını düzenli fonksiyon gibi çağırır.

## ChatGPT/OpenAI ile mesajlaşma köprüsü
```uxbasic
DECLARE FUNCTION HttpPostAuth LIB "uxcurl.dll" ALIAS "uxcurl_post_auth" (BYVAL url AS STRING, BYVAL token AS STRING, BYVAL body AS STRING) AS STRING
FUNCTION ChatGPTSor(metin AS STRING) AS STRING
  token = ENV("OPENAI_API_KEY")
  body = "{"model":"gpt-5.2","input":"" + metin + ""}"
  cevap = HttpPostAuth("https://api.openai.com/v1/responses", token, body)
  RETURN cevap
END FUNCTION
PRINT ChatGPTSor("uXBasic icin bir test fikri ver")
```
Burada gizli anahtar `ENV` ile ortamdan alınır; kaynak dosyasına yazılmaz. Uzak API kullanırken ücret, kota, kişisel veri ve hata cevabı kontrol edilmelidir.

## Gemini ile mesajlaşma köprüsü
```uxbasic
DECLARE FUNCTION HttpPostAuth LIB "uxcurl.dll" ALIAS "uxcurl_post_auth" (BYVAL url AS STRING, BYVAL token AS STRING, BYVAL body AS STRING) AS STRING
FUNCTION GeminiSor(metin AS STRING) AS STRING
  token = ENV("GEMINI_API_KEY")
  body = "{"contents":[{"parts":[{"text":"" + metin + ""}]}]}"
  cevap = HttpPostAuth("https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent", token, body)
  RETURN cevap
END FUNCTION
PRINT GeminiSor("Kisa bir veri temizleme plani yaz")
```
Gemini tarafında klasik `generateContent` çağrısı varlığını korurken yeni Interactions API daha ajanlı ve çok turlu işler için düşünülür. uXBasic tarafında bu ayrım sarmalayıcı içinde saklanır; programın geri kalanı `GeminiSor` gibi temiz bir fonksiyon çağırır.

## Bilimsel sahte veriyle Z testi, T testi ve F testi
```uxbasic
INCLUDE "include/modules/uxstats2.uxmh"
DIM kontrol AS LIST OF F64
DIM deneme AS LIST OF F64
FOR i = 1 TO 20
  LIST.ADD kontrol, 10 + RND()
  LIST.ADD deneme, 11 + RND()
NEXT i
pT = uxstats2.welch_t_p(kontrol, deneme)
pF = uxstats2.f_p(VAR(kontrol), VAR(deneme), 19, 19)
IF pT < 0.05 THEN PRINT "ortalama farki olabilir" ELSE PRINT "ortalama farki kanitlanamadi" END IF
IF pF < 0.05 THEN PRINT "varyanslar farkli olabilir" ELSE PRINT "varyans farki kanitlanamadi" END IF
```
Z testi büyük örneklem ve bilinen standart sapma fikrine dayanır. T testi küçük örneklemde iki ortalama veya tek ortalama için kullanılır. F testi iki varyansı veya varyans analizini sınar. Genç programcı p değerini sihirli karar sanmamalıdır; veri kalitesi, örneklem düzeni ve ölçüm hatası da düşünülmelidir.

## 5 modüllü örnek proje düzeni
```uxbasic
' main.uxb
INCLUDE "model.uxbh"
INCLUDE "veri.uxbh"
INCLUDE "analiz.uxbh"
INCLUDE "rapor.uxbh"
CALL VeriOku("olcum.csv")
CALL AnalizYap()
CALL RaporYaz("rapor.html")
```
Ayrı modüllerle çalışmak, 200 satırlık dosyaları yönetilebilir yapar. `model.uxbh` tipleri, `veri.uxbh` dosya okumayı, `analiz.uxbh` istatistiği, `rapor.uxbh` çıktıyı, `main.uxb` ise iş sırasını taşır.
