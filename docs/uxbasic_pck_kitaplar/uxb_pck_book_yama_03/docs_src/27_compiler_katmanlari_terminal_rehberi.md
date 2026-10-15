# 27. Derleyici Katmanlarından Sonuç Üreten Terminal Rehberi

uXBasic kitabı yalnızca komutların ne işe yaradığını anlatmaz; derleyicinin her katmanından nasıl çıktı alınacağını da gösterir. Çünkü modern bir dilde hata aramak, yalnızca programı çalıştırıp ekrana bakmak değildir. Kaynak dosyanın preprocess sonrası hâlini, token listesini, AST ağacını, HIR/MIR çıktısını, yorumlayıcı sonucunu ve hedef kod üretimini ayrı ayrı görmek gerekir. Bu bölüm, uXBasic kaynak dosyasını derleyici hattının her basamağından geçirip sonuç üreten terminal komutlarını verir.

Bu bölümdeki komutlar uXBasic kök klasöründe çalıştırılır. Örneklerde `.inook_layer_demo.uxb` adında küçük bir deneme dosyası oluşturulur ve bütün çıktılar `reportsook_layersook_layer_demo` altına yazılır. Böylece derleyici kaynaklarına dokunulmaz; yalnızca rapor, JSON, TXT, ASM, JS ve WAT gibi çıktı dosyaları üretilir.

## 27.1. Ortak hazırlık

Önce çıktı klasörleri hazırlanır ve deneme programı yazılır:

```powershell id="xpl3b1"
$Root = (Get-Location).Path
$Out  = Join-Path $Root "reports\book_layers\book_layer_demo"
New-Item -ItemType Directory -Force -Path $Out | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Root "bin") | Out-Null

@'
%%SET MOD = "KITAP"
%%IF MOD == "KITAP"
PRINT "PREPROCESS_OK"
%%ENDIF

DIM a AS I32 = 10
DIM b AS I32 = 20
DIM toplam AS I32

toplam = a + b

IF toplam >= 30 THEN
    PRINT "TOPLAM_OK"
ELSE
    PRINT "TOPLAM_HATA"
END IF

FUNCTION IkiKat(x AS I32) AS I32
    RETURN x * 2
END FUNCTION

PRINT IkiKat(toplam)
'@ | Set-Content -Encoding UTF8 .\bin\book_layer_demo.uxb
```

Bu program özellikle küçük tutulur. İçinde preprocess koşulu, değişken, atama, aritmetik ifade, `IF`, `FUNCTION`, `RETURN` ve `PRINT` bulunur. Böylece derleyicinin ön yüzü, AST, MIR ve yorumlayıcı hattı aynı dosya üzerinde görülebilir.

## 27.2. Derleyiciyi üretmek

Derleyici daha önce üretilmiş olsa bile kitap çalışmasında ilk kapı derlemedir:

```powershell id="fpg7uo"
.\build_64.bat 2>&1 | Tee-Object -FilePath .\build_64_error.log
```

Beklenen durum, `bin\uxb.exe` dosyasının oluşması ve derleme sonunda hata kalmamasıdır. Bu komut, kitapta anlatılan bütün terminal örneklerinin temelidir. Derleyici yoksa sonraki katmanlardan çıktı alınamaz.

## 27.3. Preprocessor A/B çıktısı almak

Preprocessor, kaynak dosya lexer katmanına gitmeden önce metni hazırlar. `%%SET`, `%%IF`, `%%TARGET`, `%%HTML_BEGIN`, `%%JS_BEGIN` gibi yönergeler bu aşamada anlam kazanır. uXBasic içinde A ve B preprocessor yolları vardır. A mevcut ana hat, B ise genişletilmiş blok ve hedef işleme hattı olarak düşünülür.

A hattı için:

```powershell id="zadv3c"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --preprocessed-out "$Out\01_preprocessed_A.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_A.json"
```

B hattı için:

```powershell id="3bd3vl"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp B `
  --preprocessed-out "$Out\01_preprocessed_B.uxb" `
  --preprocess-result-json-out "$Out\01_preprocess_B.json"
```

Bu iki komutun ürettiği `preprocessed` dosyaları karşılaştırıldığında preprocess katmanının kaynak üzerindeki etkisi görülür. `PREPROCESS_OK` satırı koşul doğruysa kaynakta kalır; koşul kapalıysa çıkarılır. Bu sayede kitapta anlatılan `%%IF` ve `%%SET` yalnızca teorik kalmaz.

## 27.4. Lexer ve token çıktısı almak

Lexer, kaynak metni dilin tanıdığı küçük parçalara böler. `PRINT`, `DIM`, `AS`, `I32`, sayı, metin, operatör ve parantez artık metin değil token olur.

```powershell id="jmkep7"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --pp A `
  --debug-token-dump `
  --tokens-json-out "$Out\02_tokens.json" `
  --lexer-diagnostics-json-out "$Out\02_lexer_diag.json" `
  --preprocessed-out "$Out\02_preprocessed.uxb"
```

Bu çıktı özellikle anahtar kelime kitabı hazırlanırken değerlidir. Bir sözcük lexer tarafından keyword olarak tanınmıyorsa sonraki katmanlarda komut gibi davranamaz. Bu yüzden anahtar kelime cheat sheetleri hazırlanırken lexer yüzeyiyle karşılaştırma yapılır.

## 27.5. Parser ve AST çıktısı almak

Parser, token listesinden anlam ağacı kurar. `IF` artık düz metin değil, koşulu, doğru kolu ve yanlış kolu olan bir AST düğümüdür. `FUNCTION` gövdesi, parametreleri ve dönüş tipiyle birlikte AST içinde temsil edilir.

```powershell id="mver6y"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --parse-only `
  --ast-json-out "$Out\03_ast.json" `
  --parser-diagnostics-json-out "$Out\03_parser_diag.json"
```

AST çıktısı, kitabın komut anlatımında “bu komut kaynakta nasıl görünür, derleyici içinde hangi yapıya dönüşür?” sorusuna cevap verir. Örneğin `PRINT IkiKat(toplam)` satırı parser açısından iç içe çağrı ve çıktı komutunun birleşimidir.

## 27.6. AST sözleşme ve AST yorumlayıcı hattı

AST yalnızca yazdırılacak bir JSON değildir; uXBasic’te AST yorumlayıcı doğrudan bu ağaç üzerinden çalışabilir. Bu yol özellikle kaynak anlamını hızlı denemek için kullanılır.

```powershell id="m7t6a0"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --ast-contract-check `
  --ast-json-out "$Out\04_ast_contract_ast.json" `
  --ast-contract-json-out "$Out\04_ast_contract.json" `
  --ast-contract-matrix-out "$Out\04_ast_contract_matrix.json"
```

AST yorumlayıcı ile çalıştırma:

```powershell id="wmwp1q"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend AST `
  --stdout-out "$Out\05_ast_stdout.txt" `
  --stderr-out "$Out\05_ast_stderr.txt" `
  --run-report-json-out "$Out\05_ast_run_report.json"
```

Beklenen program çıktısı:

```text id="o2nifv"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu çıktı, kaynak kodun AST yolundan çalıştırıldığını gösterir. Kitapta `AST çalışır` demek yerine, bu komutla AST yorumlayıcı sonucu üretilir.

## 27.7. Semantic ve HIR çıktısı almak

Semantic katman isimleri, tipleri, kapsamı ve çağrıları anlamlandırır. `toplam = a + b` satırında `a`, `b` ve `toplam` değişkenlerinin tanımlı olup olmadığı; `IkiKat(toplam)` çağrısında parametre uyumu bu katmanda anlam kazanır.

```powershell id="nyixic"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --semantic `
  --hir-json-out "$Out\06_hir.json" `
  --hir-inventory-json-out "$Out\06_hir_inventory.json"
```

HIR çıktısı, AST ile MIR arasındaki yüksek seviyeli ara katmandır. Kitapta tip, scope, fonksiyon ve çağrı anlatılırken semantic/HIR hattı bu yüzden ayrıca gösterilir.

## 27.8. MIR üretmek ve doğrulamak

MIR, hedef üretim omurgasıdır. AST kaynak anlamını taşır; MIR ise bu anlamı backendlerin daha kolay kullanacağı ara forma indirir. MIR yorumlayıcı, JS/WAT/WASM ve x64 üretim hattı bu düzeyden destek alır.

```powershell id="un8sq1"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --mir-verify `
  --mir-json-out "$Out\07_mir.json" `
  --mir-full-json-out "$Out\07_mir_full.json" `
  --mir-opcodes-json-out "$Out\07_mir_opcodes.json" `
  --mir-surface-json-out "$Out\07_mir_surface.json" `
  --mir-verify-json-out "$Out\07_mir_verify.json" `
  --mir-opt-report-json-out "$Out\07_mir_opt_report.json"
```

MIR çıktısı incelendiğinde `PRINT`, aritmetik işlem, koşullu dallanma ve fonksiyon çağrısı gibi yapılar artık backendin kullanacağı daha düz bir temsil hâline gelir.

## 27.9. MIR yorumlayıcı ile çalıştırmak

AST yorumlayıcı kaynak anlam ağacını çalıştırırken, MIR yorumlayıcı ara temsil üzerinden çalışır. Aynı program iki yorumlayıcıda da aynı sonucu üretmelidir.

```powershell id="5h3v0v"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend MIR `
  --mir-exec-result-json-out "$Out\08_mir_exec_result.json" `
  --mir-live-json-out "$Out\08_mir_live.json" `
  --mir-stdout-out "$Out\08_mir_stdout.txt" `
  --mir-stderr-out "$Out\08_mir_stderr.txt" `
  --mir-program-output-out "$Out\08_mir_program_output.txt" `
  --run-report-json-out "$Out\08_mir_run_report.json"
```

Beklenen program çıktısı yine aynıdır:

```text id="fmncdu"
PREPROCESS_OK
TOPLAM_OK
60
```

Bu eşitlik önemlidir. AST ve MIR aynı kaynak anlamını farklı yürütme yollarından doğrular.

## 27.10. AST ve MIR birlikte çalıştırmak

Karşılaştırmalı denetim için iki yorumlayıcı aynı komutla birlikte istenebilir:

```powershell id="9xsl20"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --execmem `
  --interpreter-backend BOTH `
  --stdout-out "$Out\09_both_stdout.txt" `
  --stderr-out "$Out\09_both_stderr.txt" `
  --run-report-json-out "$Out\09_both_run_report.json"
```

Bu komut kitap örneklerinin kalite kapısı için kullanışlıdır. Aynı örnek AST ve MIR tarafında tutarlıysa belgeye alınması daha güvenli olur.

## 27.11. x64 NASM çıktısı üretmek

x64 kod üretimi MIR seviyesindedir; AST’den kaynak anlamı ve yüksek seviye bilgi desteği alabilir. Ama üretim hattının omurgası MIR’dir.

```powershell id="qjdske"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --emit-x64-nasm `
  --emit-x64-nasm-out "$Out\10_book_layer_demo_x64.asm" `
  --backend-report-json-out "$Out\10_x64_backend_report.json"
```

Bu komut native assembly artefact üretir. Burada amaç programı hemen EXE yapmak değil, MIR’den x64 üretim yolunu görünür kılmaktır.

## 27.12. x64 build hattı

x64 build hattı için çıktı klasörü verilir:

```powershell id="df6bup"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --codegen-source MIR `
  --x64-mode MIR `
  --build-x64 `
  --build-x64-out "$Out\x64_build" `
  --backend-report-json-out "$Out\11_x64_build_report.json"
```

Bu komut, sistemde gerekli assembler/linker zinciri varsa native üretime ilerler. Kitapta bu bölüm anlatılırken “x64 MIR’den yürür” cümlesi bu komutla somutlanır.

## 27.13. JS hedefi üretmek

JS üretimi de MIR destekli backend hattındadır. Program browser veya JS çalışma zamanı için dışarıya dosya olarak verilebilir.

```powershell id="bckgsh"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-js `
  --js-out "$Out\12_program.js" `
  --js-runtime-out "$Out\12_uxb_runtime.js" `
  --backend-report-json-out "$Out\12_js_backend_report.json"
```

Bu çıktı, klasik BASIC kodunun JS hedefinde nasıl temsil edilebileceğini gösterir. Hedef JS olduğunda raw JS blokları yalnız güvenli hedef bağlamında kullanılmalıdır.

## 27.14. WAT/WASM hedefi üretmek

WAT, WebAssembly’nin metin biçimidir. uXBasic WAT/WASM hedefinde MIR tabanlı üretim hattından yararlanır.

```powershell id="2v7n3m"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wat `
  --wat-out "$Out\13_program.wat" `
  --backend-report-json-out "$Out\13_wat_backend_report.json"
```

WASM çıktısı için:

```powershell id="y09ysj"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-wasm `
  --wasm-out "$Out\14_program.wasm" `
  --backend-report-json-out "$Out\14_wasm_backend_report.json"
```

WAT/WASM örnekleri kitapta yalnız web teknolojisi diye değil, derleyicinin hedefe inme gücü olarak anlatılır.

## 27.15. Browser artefact üretmek

Browser hedefi HTML, JS runtime ve isteğe göre WASM dosyalarını birlikte düşünebilir.

```powershell id="hxz66u"
.\bin\uxb.exe .\bin\book_layer_demo.uxb `
  --emit-browser `
  --html-out "$Out\15_index.html" `
  --js-out "$Out\15_program.js" `
  --js-runtime-out "$Out\15_uxb_runtime.js" `
  --backend-report-json-out "$Out\15_browser_backend_report.json"
```

Bu komut, uXBasic’in yalnız konsol dili değil, hedef üreten bir dil olduğunu gösterir.

## 27.16. Project pack doğrulaması

Kitapta anlatılan ana omurga `xtestx/project_packs` ile bağlanır. Bu paketler dil yüzeyinin birlikte çalışmasını gösterir.

```powershell id="kdcdt5"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe
```

Odaklı bir paket çalıştırmak için:

```powershell id="gnltwh"
python xtestx\_runners\run_xtestx_project_packs.py --root . --tests xtestx --uxb .\bin\uxb.exe --only pack_30_full_integration_project
```

Kitabın her yeni örneği bu disipline yaklaşmalıdır: kaynak dosya, beklenen çıktı, rapor klasörü ve gerekirse JSON artefact.

## 27.17. Kaynak yüzeyi ve otomatik kitap eklerini üretmek

Kitap eklerinde keyword, statement dispatch, runtime service ve CLI option yüzeyleri otomatik çıkarılır:

```powershell id="6qmdew"
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
```

Ardından tek kitap yeniden üretilir:

```powershell id="3hq2ai"
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Bu iki komut, belgenin kaynak kodla bağlantısını korur. Kitap yalnız elle yazılmış bir metin değildir; kaynak yüzeyinden beslenen bir teknik belgedir.

## 27.18. Katman çıktılarının anlamı

| Çıktı | Katman | Ne Gösterir? |
|---|---|---|
| `preprocessed.uxb` | Preprocessor | Derleyiciye girecek son kaynak metni |
| `tokens.json` | Lexer | Keyword, sayı, string, operatör ve sembol parçaları |
| `ast.json` | Parser / AST | Kaynak anlam ağacı |
| `hir.json` | Semantic / HIR | Tip, kapsam ve yüksek seviye temsil |
| `mir.json` | MIR | Backend ve MIR yorumlayıcı omurgası |
| `mir_opcodes.json` | MIR opcode | Ara temsil komut aileleri |
| `ast_stdout.txt` | AST interpreter | AST üzerinden çalışma sonucu |
| `mir_program_output.txt` | MIR interpreter | MIR üzerinden çalışma sonucu |
| `program.js` | JS backend | JS hedef çıktısı |
| `program.wat` | WAT backend | WebAssembly text çıktısı |
| `program.wasm` | WASM backend | Binary WebAssembly çıktısı |
| `book_layer_demo_x64.asm` | x64 backend | MIR tabanlı native assembly çıktısı |

Bu tablo, kitabın teknik doğruluk ilkesini özetler. uXBasic’te bir komut yalnız kaynak satırı değildir; derleyici hattında birden fazla artefact üretir. Resmî teknik kitap bu artefactların adını, yerini ve görevini açıkça göstermelidir.
