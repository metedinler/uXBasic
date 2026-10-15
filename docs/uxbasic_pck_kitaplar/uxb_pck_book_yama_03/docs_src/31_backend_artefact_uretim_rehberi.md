# 31. Backend ve Artefact Üretim Rehberi

uXBasic’in güçlü tarafı yalnız kaynak kodu yorumlamak değildir. Aynı kaynak, hedefe göre farklı artefactlar üretebilir. Bu bölümde AST, MIR, runtime ve backend ilişkisi üzerinden JS, WAT/WASM ve x64 üretim hattı anlatılır.

Ana ilke değişmez:

```text id="og7vwe"
AST kaynak anlamını taşır.
MIR hedef üretim omurgasıdır.
AST interpreter AST üzerinden çalışır.
MIR interpreter MIR üzerinden çalışır.
JS, WAT/WASM ve x64 üretimi MIR seviyesinden destek alır.
x64 kod üretimi MIR seviyesindedir; AST kaynak anlamıyla yardımcı olur.
```

## 31.1. AST ve MIR farkını örnekle görmek

Kaynak kod:

```basic id="tz59ck"
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

AST bu kodu kaynak anlamına yakın taşır: değişken tanımı, atama, ifade ve `PRINT` düğümü vardır. MIR ise hedef üreticinin daha kolay kullanacağı ara işlemler üretir: değer yükleme, toplama, çıktı servisine gönderme gibi daha düz bir yapı oluşur.

AST çıktısı almak:

```powershell id="mwj187"
.\bin\uxb.exe .\bin\demo.uxb --parse-only --ast-json-out reports\ast.json
```

MIR çıktısı almak:

```powershell id="3h6m94"
.\bin\uxb.exe .\bin\demo.uxb --mir-verify --mir-json-out reports\mir.json --mir-opcodes-json-out reports\mir_opcodes.json
```

Bu iki çıktı aynı programı farklı gözle gösterir. Kitapta derleyici mimarisi anlatılırken bu fark temel alınır.

## 31.2. AST interpreter ve MIR interpreter

AST yorumlayıcı doğrudan AST üzerinden yürür:

```powershell id="21bo9j"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend AST --stdout-out reports\ast_stdout.txt
```

MIR yorumlayıcı MIR üzerinden yürür:

```powershell id="u63ngh"
.\bin\uxb.exe .\bin\demo.uxb --execmem --interpreter-backend MIR --mir-program-output-out reports\mir_output.txt
```

İkisi aynı çıktıyı üretmelidir. Fark, yürütme yolundadır.

## 31.3. JS hedefi

JS hedefi için:

```powershell id="w85572"
.\bin\uxb.exe .\bin\demo.uxb --emit-js --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Bu komut JS dosyası üretir. JS hedefi anlatılırken iki ayrı yol karıştırılmaz: uXBasic komutlarının JS’e çevrilmesi ayrı, preprocess ile raw JS bloğu yazılması ayrıdır.

## 31.4. Browser hedefi

Browser hedefi HTML ve JS artefactlarını birlikte düşünebilir:

```powershell id="6ekqty"
.\bin\uxb.exe .\bin\demo.uxb --emit-browser --html-out dist\index.html --js-out dist\program.js --js-runtime-out dist\uxb_runtime.js
```

Preprocessor web bloklarıyla birlikte örnek:

```basic id="01qeps"
%%TARGET WEB
%%OUTDIR "dist/browser_demo"

%%HTML_BEGIN "index.html" BODY
<h1>uXBasic Browser</h1>
%%HTML_END

%%JS_BEGIN "program.js" RUNTIME
console.log("BROWSER_OK");
%%JS_END

PRINT "WEB_ROUTE"
```

## 31.5. WAT/WASM hedefi

WAT üretmek:

```powershell id="ieha43"
.\bin\uxb.exe .\bin\demo.uxb --emit-wat --wat-out dist\program.wat
```

WASM üretmek:

```powershell id="3c9qzr"
.\bin\uxb.exe .\bin\demo.uxb --emit-wasm --wasm-out dist\program.wasm
```

WAT/WASM hedefi, uXBasic’in web ve taşınabilir çalışma hedeflerine uzanan yüzüdür. MIR bu hedeflere inme noktasında ana omurgadır.

## 31.6. x64 hedefi

x64 NASM üretmek:

```powershell id="4xe3wn"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --emit-x64-nasm --emit-x64-nasm-out dist\demo_x64.asm
```

x64 build denemesi:

```powershell id="q8ug04"
.\bin\uxb.exe .\bin\demo.uxb --codegen-source MIR --x64-mode MIR --build-x64 --build-x64-out dist\x64_build
```

Bu komutlar kitapta native hedef anlatılırken kullanılmalıdır. x64 üretiminde ana fikir, kaynak kodun önce MIR’e inmesi ve x64 üreticinin bu MIR bilgisinden assembly üretmesidir.

## 31.7. Artefact klasör düzeni

Kitap örneklerinde çıktıların dağılmaması için şu düzen önerilir:

```text id="lsm0r7"
reports/
  book_layers/
    demo_adı/
      frontend/
      ast/
      hir/
      mir/
      execution/
      backend/

dist/
  demo_adı/
    program.js
    program.wat
    program.wasm
    demo_x64.asm
    index.html
```

Bu düzen, kullanıcıya “çıktı nereye gitti?” sorusunun cevabını verir.
