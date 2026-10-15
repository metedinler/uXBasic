# uXBasic Programlayıcının Cep Kitabı — Cilt 5
# Tarayıcı, JS, WAT/WASM, Dış Programlar, API, Yapay Zeka ve Gerçekçi Örnekler


## Dış dünya ile konuşma mantığı

uXBasic dış dünyaya dört kapıdan çıkar: `DECLARE ... LIB ... ALIAS` ile imza bildirir, `CALL(DLL,...)` veya `CALL(API,...)` ile çağırır, `IMPORT(C/CPP/ASM,...)` ile derleme zamanında yerel dosya ekler, `%%JS_BEGIN`, `%%HTML_BEGIN`, `%%WAT_BEGIN` ile tarayıcı varlığı üretir. Bu düzen dilin çekirdeğini şişirmeden büyümesini sağlar.
```uxbasic
DECLARE FUNCTION MessageBeep LIB "user32.dll" ALIAS "MessageBeep" (ByVal uType AS U32) AS I32
DIM ok AS I32
ok = MessageBeep(0)
PRINT "Windows ses cagrisi="; ok
```
```uxbasic
IMPORT(C, "native/toplam.c")
DECLARE FUNCTION hizli_toplam LIB "toplam.dll" ALIAS "hizli_toplam" (ByVal ptr AS PTR, ByVal n AS I32) AS F64
DIM a(0 TO 3) AS F64
a(0)=1 : a(1)=2 : a(2)=3 : a(3)=4
PRINT hizli_toplam(VARPTR(a(0)), 4)
```
## JS ve tarayıcı çıktısı
```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%HTML_BEGIN "index.html" BODY
<!doctype html>
<html><body><canvas id="sahne" width="320" height="200"></canvas><script src="program.js"></script></body></html>
%%HTML_END
%%JS_BEGIN "program.js" BODY
const c = document.getElementById('sahne');
const g = c.getContext('2d');
g.fillText('uXBasic tarayici cikti', 20, 40);
%%JS_END
PRINT "Browser paketi uretildi"
```
## WAT/WASM çıktısı
```uxbasic
%%TARGET WASM
%%WAT_BEGIN "math.wat" BODY
(module
  (func $topla (param $a i32) (param $b i32) (result i32)
    local.get $a
    local.get $b
    i32.add)
  (export "topla" (func $topla)))
%%WAT_END
PRINT "WAT modulu hazir"
```
## REST, curl ve Flask API
```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM cevap AS STRING
cevap = uxhttp.Get("http://127.0.0.1:5000/olcum")
PRINT cevap
```
```uxbasic
' Flask tarafinda Python dosyasi fikri:
' from flask import Flask, jsonify
' app = Flask(__name__)
' @app.get("/olcum")
' def olcum(): return jsonify({"ph":7.8,"sicaklik":24.1})
```
## ChatGPT/OpenAI ile mesajlaşma

OpenAI tarafında güncel ana hat, Responses API ile modele `model` ve `input` göndermektir. uXBasic bunu doğrudan HTTP sarmalayıcıyla veya curl DLL/komut köprüsüyle yapabilir. Anahtar kod içine yazılmaz; ortam değişkeninden okunur.
```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM key AS STRING
DIM body AS STRING
DIM cevap AS STRING
key = ENVIRON("OPENAI_API_KEY")
body = "{"model":"gpt-5.5","input":"uXBasic icin 5 satirlik ornek yaz"}"
cevap = uxhttp.PostJsonAuth("https://api.openai.com/v1/responses", body, key)
PRINT cevap
```
## Gemini ile mesajlaşma

Gemini tarafında kararlı üretim için `generateContent` uç noktası kullanılabilir; yeni etkileşim işleri için Interactions API ayrı bir kapı olarak düşünülür.
```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM gkey AS STRING
gkey = ENVIRON("GEMINI_API_KEY")
body = "{"contents":[{"parts":[{"text":"BASIC ile veri analizi ornegi ver"}]}]}"
cevap = uxhttp.PostJson("https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=" + gkey, body)
PRINT cevap
```
## Yerel Llama ile çalışma
```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
DIM bot AS U64
bot = uxllama.Create()
uxllama.SetCliPath(bot, "llama-cli.exe")
uxllama.SetModelPath(bot, "models/yerel.gguf")
uxllama.SetThreads(bot, 2)
uxllama.SetContext(bot, 1024)
PRINT uxllama.Prompt(bot, "Bir laboratuvar raporu sablonu yaz")
uxllama.Free(bot)
```
## Bilimsel sahte veri ile Z testi, F testi ve ANOVA
```uxbasic
INCLUDE "include/modules/uxstats2.uxmh"
DIM kontrol AS U64
DIM deneme AS U64
kontrol = uxstats2.VecCreate(16)
deneme = uxstats2.VecCreate(16)
FOR i = 1 TO 8
    uxstats2.VecPush(kontrol, 10.0 + i * 0.2)
    uxstats2.VecPush(deneme, 11.0 + i * 0.3)
NEXT i
PRINT "Welch t p="; uxstats2.WelchTP(kontrol, deneme)
PRINT "F varyans p="; uxstats2.FVarianceP(kontrol, deneme)
uxstats2.VecFree(kontrol)
uxstats2.VecFree(deneme)
```
## Beş modüllü örnek proje: saha verisi -> analiz -> grafik -> yapay zeka raporu -> web
### mod_veri.uxmh
```uxbasic
SUB VeriDoldur(v AS U64)
    FOR i = 1 TO 20
        uxstats.VecPush(v, 7.0 + RND() * 0.8)
    NEXT i
END SUB
```
### mod_analiz.uxmh
```uxbasic
FUNCTION OrtalamaRapor(v AS U64) AS STRING
    RETURN "Ortalama=" + STR(uxstats.VecMean(v))
END FUNCTION
```
### mod_grafik.uxmh
```uxbasic
SUB GrafikHazirla()
    %%JS_LINE "console.log('grafik verisi hazir')"
END SUB
```
### mod_ai.uxmh
```uxbasic
FUNCTION AiYorum(metin AS STRING) AS STRING
    RETURN uxllama.Prompt(bot, metin)
END FUNCTION
```
### main.uxb
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
INCLUDE "include/modules/uxllama.uxmh"
INCLUDE "mod_veri.uxmh"
INCLUDE "mod_analiz.uxmh"
INCLUDE "mod_grafik.uxmh"
INCLUDE "mod_ai.uxmh"
DIM v AS U64
v = uxstats.VecCreate(64)
VeriDoldur(v)
PRINT OrtalamaRapor(v)
GrafikHazirla()
uxstats.VecFree(v)
```

## Test ve hata yakalama sırası

1. `lex` ile sözcükler doğru mu bak. 2. `ast` ile ağaç oluştu mu bak. 3. `sem` ile tip ve kapsam doğru mu bak. 4. `mir` ile ara komut çıktı mı bak. 5. Hedefe göre `jsw`, `wat`, `x64` veya `int` çalıştır. 6. `run_adim22_full_layer_expected_suite.ps1` gibi gate ile eksik çıktı var mı bak. 7. Placeholder yoksa ve `missing_layer_output_count=0` ise çıktı gerçek kabul edilir.
```powershell
uxb lex main.uxb --tokens-json-out out/tokens.json
uxb ast main.uxb --ast-json-out out/ast.json
uxb mir main.uxb --mir-full-json-out out/mir.json
uxb jsw main.uxb --js-out dist/web/program.js --html-out dist/web/index.html
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
```

## Windows DLL kullanımı: sistemle kibar konuşmak

DLL çağırırken önce imza bildirilir. İmza yanlışsa program çalışsa bile yanlış sonuç verebilir. `ByVal` değeri doğrudan yollar; `ByRef` adres yollar; `ALIAS` dış DLL içindeki gerçek adı bağlar.

```uxbasic
DECLARE FUNCTION GetTickCount64 LIB "kernel32.dll" ALIAS "GetTickCount64" () AS U64
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (ByVal hwnd AS PTR, ByVal text AS STRING, ByVal title AS STRING, ByVal flags AS U32) AS I32
DIM t AS U64
t = GetTickCount64()
PRINT "Windows acilisindan beri ms="; t
CALL MessageBoxA(0, "uXBasic DLL cagrisi calisti", "Bilgi", 0)
```

Kural: Windows API öğrenirken önce zararsız çağrılarla dene: saat oku, mesaj kutusu aç, dosya var mı bak. Bellek ayırma ve pencere döngüsü gibi işler ikinci aşamadır.

## curl ve REST API ile veri alma

REST, uzak programa HTTP üzerinden istek gönderme biçimidir. curl, bu isteği yapan güçlü araçtır. uXBasic bunu DLL, dış program veya HTTP sarmalayıcı ile kullanır.

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM url AS STRING
DIM cevap AS STRING
url = "https://api.example.com/status"
cevap = uxhttp.Get(url)
IF LEN(cevap) = 0 THEN PRINT "Bos cevap" ELSE PRINT cevap
```

Başlık ve anahtar gereken yerde anahtarı kaynağa yazma:

```uxbasic
DIM key AS STRING
DIM body AS STRING
key = ENVIRON("APP_API_KEY")
body = "{""soru"":""pH kac?""}"
PRINT uxhttp.PostJsonAuth("https://api.example.com/ask", body, key)
```

## Flask API ile kendi Python servisini çağırmak

Flask tarafı küçük bir yerel sunucu olur. uXBasic tarafı ona `GET` veya `POST` yapar. Bu yöntemle Python kütüphanesi, uXBasic programına servis gibi bağlanır.

Python servis fikri:

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

uXBasic çağrısı:

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM json AS STRING
json = uxhttp.Get("http://127.0.0.1:5000/olcum")
PRINT "Flask cevabi="; json
```

## ChatGPT ile mesajlaşma örneği

OpenAI tarafında model çağrısı için güncel ana yollardan biri Responses API kullanmaktır. Programcı, `model` ve `input` alanlarını gönderir; cevabı JSON olarak alır. Anahtar ortam değişkeninden okunur.

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM key AS STRING
DIM body AS STRING
DIM cevap AS STRING
key = ENVIRON("OPENAI_API_KEY")
body = "{""model"":""gpt-5.5"",""input"":""uXBasic ile dosya okuma ornegi yaz""}"
cevap = uxhttp.PostJsonBearer("https://api.openai.com/v1/responses", body, key)
IF LEN(cevap) = 0 THEN PRINT "OpenAI cevabi bos" ELSE PRINT cevap
```

İpucu: Yapay zeka cevabını doğrudan çalıştırma. Önce dosyaya yaz, sonra test kapısından geçir. Böylece model güzel ama hatalı kod önerirse ana projeyi bozmaz.

## Gemini ile mesajlaşma örneği

Gemini tarafında standart içerik üretimi için `generateContent` kapısı, daha ajanlı/etkileşimli işler için Interactions API ayrı bir kapı gibi düşünülür. Kararlı üretimde önce standart üretim kapısını kullanmak daha güvenlidir.

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM key AS STRING
DIM url AS STRING
DIM body AS STRING
key = ENVIRON("GEMINI_API_KEY")
url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=" + key
body = "{""contents"":[{""parts"":[{""text"":""uXBasic icin 3 satirlik ornek ver""}]}]}"
PRINT uxhttp.PostJson(url, body)
```

## Yerel Llama ile özel asistan yapmak

```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
DIM bot AS U64
DIM cevap AS STRING
bot = uxllama.Create()
uxllama.SetCliPath bot, "tools/llama-cli.exe"
uxllama.SetModelPath bot, "models/qwen.gguf"
uxllama.SetContext bot, 4096
uxllama.SetThreads bot, 4
cevap = uxllama.Prompt(bot, "Bu hata mesajini sade Turkce acikla: MIR_NOT_READY")
PRINT cevap
uxllama.Free bot
```

Yerel modelin iyi yanı: özel dosyanı internete göndermeden çalışır. Kötü yanı: model dosyası büyük olur ve bilgisayarın gücüne bağlıdır.

## Inline C, C++ ve ASM dosyası bağlamak

`IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)` derleme zamanında kaynak ekleme fikridir. DLL/API çağrısından farklıdır; burada amaç yerel kodu programa katmaktır.

```uxbasic
IMPORT(C, "native/hizli_toplam.c")
DECLARE FUNCTION hizli_toplam LIB "native.dll" ALIAS "hizli_toplam" (ByVal p AS PTR, ByVal n AS I32) AS F64
DIM a(0 TO 4) AS F64
a(0)=1 : a(1)=2 : a(2)=3 : a(3)=4 : a(4)=5
PRINT hizli_toplam(VARPTR(a(0)), 5)
```

```uxbasic
IMPORT(CPP, "native/filtre.cpp")
IMPORT(ASM, "native/memfill_fast.asm")
PRINT "Yerel C, C++ ve ASM kaynaklari derlemeye eklendi"
```

## Tarayıcı için gerçek mini uygulama

Aşağıdaki örnek JS çıktısından yararlanır; uXBasic hedefi belirler, HTML ve JS varlığını üretir, programcı tarayıcıda küçük ölçüm paneli görür.

```uxbasic
%%TARGET BROWSER
%%OUTDIR "dist/web"
%%HTML_BEGIN "index.html" BODY
<!doctype html><html><body>
<h3>uXBasic Havuz Paneli</h3>
<canvas id="c" width="420" height="180"></canvas>
<script src="program.js"></script>
</body></html>
%%HTML_END
%%JS_BEGIN "program.js" BODY
const c=document.getElementById('c'), g=c.getContext('2d');
const ph=7.82, temp=24.4, oxy=6.8;
g.fillText(`pH=${ph} Sicaklik=${temp} Oksijen=${oxy}`,20,40);
g.fillRect(20,70,ph*30,20);
%%JS_END
PRINT "Tarayici paneli uretildi"
```

## WAT/WASM ile küçük hızlı fonksiyon

```uxbasic
%%TARGET WASM
%%WAT_BEGIN "ortalama.wat" BODY
(module
  (func $ort2 (param $a f64) (param $b f64) (result f64)
    local.get $a
    local.get $b
    f64.add
    f64.const 2
    f64.div)
  (export "ort2" (func $ort2)))
%%WAT_END
PRINT "WASM ortalama fonksiyonu hazir"
```

İpucu: WAT tarafında çok küçük ve sık çalışan matematik çekirdekleri iyi adaydır. Dosya okuma, JSON işleme, kullanıcı arayüzü gibi işler JS veya runtime tarafında daha rahattır.

## Terminal, araç ve test kapısı kullanımı

Program yazmak sadece kod yazmak değildir. Derleme ve test zinciri de programın parçasıdır. uXBasic tarafında beklenen dosya çıktıları üretilmeli; test runner dosya uydurmamalıdır.

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

uXBasic içinde test düşüncesi:

```uxbasic
ASSERT 2 + 2 = 4
ASSERT LEN("uxb") = 3
PRINT "Temel testler gecti"
```

## Beş modüllü örnek proje iskeleti

Büyük örneği tek dosyada şişirmek yerine beş modüle böl:

```text
app.uxb              ana program
include/config.uxbh  sabitler ve ön-işleyici ayarları
modules/data.uxb     CSV/DF okuma
modules/analysis.uxb istatistik ve matris hesabı
modules/ui.uxb       terminal veya browser çıktı
```

Ana program:

```uxbasic
INCLUDE "include/config.uxbh"
INCLUDE "modules/data.uxb"
INCLUDE "modules/analysis.uxb"
INCLUDE "modules/ui.uxb"
CALL LoadData("olcum.csv")
CALL RunStats()
CALL ShowReport()
```

Bu düzen genç programcıya üç şey kazandırır: hata nerede anlaşılır, dosyalar büyüyünce korkutmaz, aynı modül başka projede tekrar kullanılır.

## Gerçek hayat programlama hileleri

1. Önce dosya üret, sonra ekrana bas. Ekran kaybolur, dosya kalır.
2. Hataları `LIST` içine topla; ilk hatada kaçma, raporla.
3. Ayarları `DICT` ile taşı; yüz tane global değişken açma.
4. Yavaş fonksiyonu `TIMER` ile ölç; hisse göre değil süreye göre karar ver.
5. Aynı işi iki backendde dene: JS ve WAT aynı sonucu veriyorsa MIR hattın sağlamlaşır.
6. DLL çağrısına önce küçük değer ver; gerçek veriyi sonra bağla.
7. Yapay zekadan gelen kodu `sandbox` klasöründe test et; ana kaynak ağacına doğrudan yazma.
