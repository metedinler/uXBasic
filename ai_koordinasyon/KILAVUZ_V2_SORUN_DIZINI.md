# Kılavuz V2 sorun dizini (önerilen düzeltme sırası)

Bu dosya `python tools/kitap/kilavuz_v2/sorun_takibe_isle.py` ile üretilir; kaynağı `tools/kitap/kilavuz_v2/veri/sinirlar.txt` kataloğudur.
Her satırın ayrıntısı `SORUN_TAKIP.md` içindeki S-numaralı kayıttadır. Sıra: önce yanlış sonuç veren (SESSİZ), sonra çökme, motorlar arası fark, açık ret, eksik özellik, yavaşlık.

| Tür | Kayıt sayısı | Anlamı |
|---|---|---|
| SESSİZ | 158 | yanlış sonuç ya da hatasız kabul (İlke 2'yi çiğner) |
| ÇÖKME | 9 | tanımsız davranış (yığın bozulması, erişim ihlali) |
| FARK | 57 | motorlar farklı davranır (İlke 1'i çiğner) |
| AÇIK | 62 | açık hata verir ama istenen davranış bu değildir |
| EKSİK | 73 | tasarımda olan özellik kodda yok |
| YAVAŞ | 3 | doğru çalışır ama kullanılabilirliği sınırlayacak kadar yavaştır |

| Sıra | Sorun | Kılavuz kaydı | Tür | Etkilenen | Belirti |
|---|---|---|---|---|---|
| 1 | S-530 | G-AKIS-3 | SESSİZ | eski AST-x64 | `F64` `FOR` sayacı tamsayı gibi artırılır; hata ve uyarı yoktur |
| 2 | S-532 | G-AKIS-4 | SESSİZ | AST | Bir döngünün (`FOR`, `DO WHILE`, `WHILE … WEND`) içinden `GOSUB` çağrılırsa AST'de … |
| 3 | S-447 | G-CLI-10 | SESSİZ | --semantic-json-out, --symbol-table-json-out, --type-table-json-out, --layout-report-json-out, --semantic-types-json-out, --hir-json-out, --hir-inventory-json-out, --ir-json-out, --inventory-json-out, --type-cast-report-json-out | Yardım metni bunları ayrı raporlar olarak anlatır (sembol tablosu, tip matrisi, yerleşim … |
| 4 | S-448 | G-CLI-12 | SESSİZ | UXB_ASM_PATH, UXB_LINK_PATH, UXB_CC_PATH, UXB_CXX_PATH | `uxb bld` bu değişkenleri okuyup `interop\toolchain.env.bat` dosyasına yazar; ama aynı … |
| 5 | S-449 | G-CLI-13 | SESSİZ | UXB_TARGET_ARCH | `UXB_TARGET_ARCH=x86` `toolchain.env.bat` dosyasına yazılır ama `uxb bld` yine x64 EXE … |
| 6 | S-450 | G-CLI-14 | SESSİZ | tests\run_all_model_tests.ps1 -ReportPath | Mutlak yol verilince rapor yazılamaz (`Join-Path $root $ReportPath` geçersiz bir yol … |
| 7 | S-451 | G-CLI-15 | SESSİZ | build_64.ps1, UXB_BUILD_X86 | Kökteki `build_64.ps1`, alttaki betiğe her zaman `-SkipX86` geçirir; bu yüzden … |
| 8 | S-453 | G-CLI-16 | SESSİZ | --manifest-out | `jsw` fiiliyle `--emit-browser` olmadan `--manifest-out dosya.json` verilirse dosya … |
| 9 | S-454 | G-CLI-17 | SESSİZ | --backend-matrix-json-out, --backend-report-json-out | İkisi de adıyla ve açıklamasıyla ("hangi yüzeyin hangi hedefte desteklendiğini gösteren … |
| 10 | S-455 | G-CLI-19 | SESSİZ | --diag-format (geçersiz değer) | `--diag-format xyz` gibi tanınmayan bir değer hata vermeden metin kipine düşer (çıkış 0, … |
| 11 | S-205 | G-CLI-2 | SESSİZ | map, doc, rel | `--source-map-json-out`, `--doc-json-out`, `--release-json-out` ve `map`, `doc`, `rel` … |
| 12 | S-462 | G-CLI-23 | SESSİZ | --program-output-out, --program-output-json-out, --final-screen-json-out | Programı çalıştırmayan fiillerde (`lex`, `par`, `ast`, `sem`, `hir`, `mir`, `x64`, `bld`, … |
| 13 | S-463 | G-CLI-25 | SESSİZ | --parser-json-out, --error-summary-json-out, --active-bind-plan-txt-out, --x64-ast-report-json-out | Her fiil ve bağlamda (hatalı program, `--parse-only`, `--x64-mode AST`, `bld` dahil) hata … |
| 14 | S-464 | G-CLI-26 | SESSİZ | --interpreter-backend BOTH | AST ve MIR yorumlayıcısını birlikte çalıştırıp karşılaştırır; ama sonuçlar ayrışsa bile … |
| 15 | S-465 | G-CLI-27 | SESSİZ | --format-check, --strict, --time-passes, --parse-only, --ast-contract-check, --trace, --hook-trace, --trace-json, --enable-extfp-runtime, --extfp-strict, --extfp-diagnostics, --validate-all-fail-fast, --emit-nasm | Hata vermeden kabul edilir ve hiçbir etkisi yoktur: altı fiilde (`run`, `x64`, `jsw`, … |
| 16 | S-469 | G-CLI-30 | SESSİZ | --codegen-source, --x64gen-out | `--codegen-source xyz` geçersiz değeri reddetmez (`x64` fiilinde `AST`, `MIR` ve `xyz` … |
| 17 | S-476 | G-CLI-32 | SESSİZ | bilinmeyen fiil, fiilsiz çağrı | Yazım hatalı ya da eksik fiil (`uxb rnu k.uxb`, `uxb mtx k.uxb`, `uxb k.uxb`) tek satır … |
| 18 | S-477 | G-CLI-33 | SESSİZ | wat --emit-wasm (--wasm-out yok) | `--wasm-out` verilmezse `.wasm` ikilisi ve `run_wasm.js` hiç yazılmaz; hata ya da uyarı … |
| 19 | S-206 | G-CLI-4 | SESSİZ | --dump-ast, --dump-mir, --debug-token-dump | Yardım metni "terminale basar" der; terminale hiçbir şey yazılmaz, yalnız JSON dosyaları … |
| 20 | S-207 | G-CLI-5 | SESSİZ | --stop-after, --target | İkisi de her değeri (uydurma `xyz` bile) sessizce kabul eder ve etkisizdir; aşamayı ve … |
| 21 | S-208 | G-CLI-6 | SESSİZ | --sessiz, --ayikla | Yardım metni anar ama bu adlar kayıtlı değildir; INFO satırları basılmaya sürer |
| 22 | S-209 | G-CLI-9 | SESSİZ | --json-out | Hata vermeden hiçbir dosya yazmaz |
| 23 | S-441 | G-DIL-12 | SESSİZ | tüm motorlar | **`CONST` değerine yazmak hata vermez:** `A = 4`, `A += 1`, yordam içinde `A = 99` ve … |
| 24 | S-459 | G-DIL-14 | SESSİZ | AST, MIR, x64, JS | **Kısmen kapandı (20261014_0253 ve sonrası; S-459):** ondalık sayı ile metin karışımı … |
| 25 | S-521 | G-DIL-16 | SESSİZ | AST, MIR, MIR-x64, eski AST-x64, JS | `STRING` değişkene sayıyı **bileşik atamayla** eklemek (`s += 7`) … |
| 26 | S-562 | G-DIL-18 | SESSİZ | 0x önekli sayı (altı yol) | `0x1F` biçimi hata vermez ve yanlış değer üretir: `DIM a AS I32 = 0x1F`, `PRINT a` → AST, … |
| 27 | S-210 | G-DIL-4 | SESSİZ | AST | İlk değeri verilmeyen `STRING` değişken AST'de `0` ile başlar; MIR ve x64'te boş metindir |
| 28 | S-211 | G-DIL-5 | SESSİZ | üç motor | Eksik ifade (`PRINT (1 +`, `PRINT 1 +`) hata vermez, boş satır yazar, çıkış kodu 0'dır |
| 29 | S-212 | G-DIL-6 | SESSİZ | MIR, x64 | Aynı değişkeni iki kez `DIM` etmek yalnız AST'de "duplicate variable" hatasıdır; MIR ve … |
| 30 | S-213 | G-DIL-8 | SESSİZ | AST, MIR, JS (tamsayı); x64'te çöker | **Kısmen kapandı (20261014_0253 ve sonrası; S-459, S-460):** `5 + "a"` ve `"a" + 5` dahil … |
| 31 | S-272 | G-DIS-1 | SESSİZ | AST, MIR, x64 | `IMPORT(C, "yol")`, `IMPORT(CPP, …)`, `IMPORT(ASM, …)` yalnız yolu çözer ve doğrular … |
| 32 | S-445 | G-DIS-11 | SESSİZ | x64 (FARK: AST, MIR) | `CALL(DLL, …)` tip listesinde bilinmeyen bir simge (`"BILINMEZ"`) AST'de çalışma anında … |
| 33 | S-273 | G-DIS-7 | SESSİZ | x64 | `"F64"` olarak bildirilen argümana tamsayı verilirse (`CALL(DLL, …, "F64", 4)` ya da … |
| 34 | S-434 | G-DOSYA-5 | SESSİZ | x64 (FARK: AST, MIR) | Olmayan dosyayı `OPEN … FOR INPUT` ile açmak ve olmayan bir klasöre `OPEN … FOR OUTPUT` … |
| 35 | S-240 | G-GOREV-10 | SESSİZ | AST, MIR, x64 | `TASK OF I32` tutamacıyla aritmetik (`a + 1`) derleme hatası vermez; tutamaç sayısını … |
| 36 | S-241 | G-GOREV-11 | SESSİZ | AST, MIR, x64 | Bir `EVENT`'e birden çok `SLOT` bağlandığında işleyici bir kez çalışır (tasarım: her … |
| 37 | S-238 | G-GOREV-3 | SESSİZ | AST, MIR, x64 | `THREAD` içinde `TASKOUT = …` yazıp dışarıda `PRINT TASKOUT` okumak AST'de hata, MIR'de … |
| 38 | S-239 | G-GOREV-4 | SESSİZ | AST, MIR, x64 | Aynı SLOT numarasının iki kez kullanılması kabul edilir (tasarım: derleme hatası) |
| 39 | S-456 | G-HATA-10 | SESSİZ | AST, MIR (tanı kodu ve katmanı) | Her tanının kodu ve katmanı, ileti metnindeki sözcüklerin sıralı alt dize aramasıyla … |
| 40 | S-498 | G-HATA-11 | SESSİZ | AST, MIR (yapılandırılmış tanı dosyaları) | **Kapandı (20261013_2052 ve sonrası; S-498):** AST ve MIR çalışma anı hataları artık … |
| 41 | S-432 | G-HATA-6 | SESSİZ | JS | Sınır dışı erişim JS'te hata vermez: dizi okuma `0` döndürür, dizi yazma sessizce yok … |
| 42 | S-433 | G-HATA-8 | SESSİZ | JS | Tamsayı sıfıra bölme JS'te hata vermez: `5 \ 0` → `inf`, `5 MOD 0` → `nan`; program … |
| 43 | S-219 | G-ISLEC-1 | SESSİZ | AST, MIR, x64 | **Kapandı (20261014_0253 ve sonrası; S-219), WASM ve bileşik biçim hariç:** `ROL`/`ROR` … |
| 44 | S-520 | G-ISLEC-10 | SESSİZ | AST, MIR, MIR-x64, eski AST-x64, JS | `ROL=` ve `ROR=` bileşik atamaları döndürme değil kaydırma yapar ve açık yazımla (`a = a …` |
| 45 | S-524 | G-ISLEC-11 | SESSİZ | eski AST-x64 | `F64` ya da `F32` **değişkenin** tekli eksisi (`-x`) bit düzenini tamsayı gibi eksiltir; … |
| 46 | S-525 | G-ISLEC-12 | SESSİZ | eski AST-x64 | İki tamsayı değişkenin bölümü ondalık olması gerekirken tamsayı bölme yapar |
| 47 | S-417 | G-ISLEC-5 | SESSİZ | x64 | **Kapandı (20261013_2209 ve sonrası; S-505 ile birlikte S-417):** `-(z = 0)` (`z` … |
| 48 | S-497 | G-ISLEC-7 | SESSİZ | AST, MIR, x64, JS | Bir `TYPE` ya da `CLASS` **alanına** atanan ve en üst düzeyi `AND`, `OR`, `XOR` ya da … |
| 49 | S-504 | G-ISLEC-8 | SESSİZ | MIR-x64 (varsayılan x64 yolu) | **Kapandı (doğrudan kullanım 20261013_2052'de, `AND`/`OR` ile bileşik kullanım … |
| 50 | S-242 | G-JS-1 | SESSİZ | JS | `&H`, `&O`, `&B` sabitleri `undefined` yazdırır |
| 51 | S-249 | G-JS-12 | SESSİZ | JS | Sınıf alanındaki `DICT` (kurucuda `DICT_NEW()` ile üretilmiş): iki `DICTSET` sonrası … |
| 52 | S-412 | G-JS-13 | SESSİZ | JS | Bir `METHOD` içinde sınıf alanına yazmak (çıplak ad ya da `THIS.`) JS'te alanı bozar: … |
| 53 | S-444 | G-JS-14 | SESSİZ | JS | **Yakalanmayan `THROW` ve başarısız `ASSERT` JS'te programı iletisiz ve başarı koduyla … |
| 54 | S-243 | G-JS-2 | SESSİZ | JS | Bir yordamdan fırlatılan `THROW`, çağıranın `TRY`'ı tarafından yakalanmaz (beklenen … |
| 55 | S-244 | G-JS-3 | SESSİZ | JS | `INTERFACE` üzerinden çağrılan metot `nan` döndürür (beklenen 14) |
| 56 | S-245 | G-JS-4 | SESSİZ | JS | `I64`/`U64` değerler `Number`'a düşer: 9223372036854775807 → 9.223372036854776e+18; … |
| 57 | S-246 | G-JS-5 | SESSİZ | JS | `DICT`/`SET` sorgularında `TRUE` değeri -1 yerine `1` yazdırılır |
| 58 | S-247 | G-JS-6 | SESSİZ | JS | `INSTR(başlangıç, …)` başlangıç verilince 0 döner (beklenen 4) |
| 59 | S-248 | G-JS-9 | SESSİZ | JS | **Kapandı (20261014_0253 ve sonrası; kaynak kaydı bulunamadı):** `GOTO` ile ileri ve geri … |
| 60 | S-221 | G-KOLEKSIYON-3 | SESSİZ | AST, MIR, x64, JS | `FOR EACH v IN ifade` ifade bir değişken değilse (`LISTGET(dis, 0)` ya da nesne alanı … |
| 61 | S-222 | G-KOLEKSIYON-5 | SESSİZ | AST, MIR, x64, JS | `LISTADD(l, kayit)` ile `LIST` içine `TYPE` kaydı koymak hata vermez, ama `FOR EACH q IN …` |
| 62 | S-269 | G-KTIP-2 | SESSİZ | AST | **Kapandı (20261013_2052 ve sonrası; S-499):** AST `RATIONAL` programını artık ondalık … |
| 63 | S-474 | G-KTIP-6 | SESSİZ | AST | **Kapandı (20261013_2052 ve sonrası; S-499):** AST `RATIONAL` içeren programı (`TYPE` … |
| 64 | S-499 | G-KTIP-7 | SESSİZ | AST-x64, WAT/WASM | **Kapandı (20261013_2052 ve sonrası; S-499):** AST-x64 ve WASM dahil MIR dışındaki bütün … |
| 65 | S-256 | G-KUT-1 | SESSİZ | AST, MIR, x64 | `uxpath` işlevlerinden `FileName`, `DirectoryName`, `Stem`, `IsInside` ayırıcılı yollarda … |
| 66 | S-260 | G-KUT-11 | SESSİZ | AST, MIR, x64 | `uxhttp` dönüş değerleri tek tip değildir: `SetUrl`/`SetMethod`/`AddHeader`/`SetBody` … |
| 67 | S-261 | G-KUT-12 | SESSİZ | AST, MIR, x64 | `uxjsruntime`: `JsBootstrapUxb` çağrılmadan `JsResultJson` sessizce boş metin döndürür … |
| 68 | S-262 | G-KUT-13 | SESSİZ | AST, MIR, x64 | `uxpython`: `PythonInt` int64'e sığmayan sayıda (örn |
| 69 | S-263 | G-KUT-15 | SESSİZ | AST, MIR, x64 | `uxstats2`: geçersiz girdi çoğu işlevde `nan` verir (boş vektör, serbestlik derecesi 0 ya … |
| 70 | S-264 | G-KUT-16 | SESSİZ | AST, MIR, x64 | `uxmathcore`: tamponun tipine sığmayan değer sessizce bozulur (I32 tamponuna `3000000000` … |
| 71 | S-265 | G-KUT-17 | SESSİZ | AST, MIR, x64 | `uxnn3`: `Init` ve `TrainDataset`'e aynı tohum verilse de aynı işlemde ikinci kez … |
| 72 | S-266 | G-KUT-19 | SESSİZ | AST, MIR, x64 | `uxmath`: `UXMATH_VecSet(v, 9, x)` vektörün sonundan ötesine yazarsa vektörü sessizce … |
| 73 | S-267 | G-KUT-20 | SESSİZ | AST, MIR, x64 | `uxuuid` yalnız Windows GUID biçimini, yani süslü parantezli `{8-4-4-4-12}` yazımını … |
| 74 | S-268 | G-KUT-22 | SESSİZ | AST, MIR, x64 | `uxregex.Compile` geçersiz desende ve `uxsqlite.Open` açılamayan dosyada `0` döner, ama … |
| 75 | S-257 | G-KUT-6 | SESSİZ | AST, MIR, x64 | `uxtensor`: hatalı boyutta (`Create2D(0, 3)`, `Create1D(-5)`) ya da uyumsuz işlemde (2x3 … |
| 76 | S-258 | G-KUT-7 | SESSİZ | AST, MIR, x64 | `uxdatetime.ParseUtc` yalnız `YYYY-AA-GGTSS:DD:SSZ` biçimini ve üç haneli `.mmm` kesrini … |
| 77 | S-259 | G-KUT-8 | SESSİZ | AST, MIR, x64 | `uxdatetime`: 1970'ten önceki tarihlerde `ParseUtc` çöp sayı döndürür … |
| 78 | S-286 | G-META-1 | SESSİZ | tüm motorlar | `REM %%ATTR …` ve `REM %%MIR …` satırları yalnız yorumdur: ad yanlış da yazılsa (`REM …` |
| 79 | S-220 | G-METIN-4 | SESSİZ | AST | `INSTR` sonucu AST'de metin gibi davranır: `k = INSTR(1, "abc", "b")` sonra `k + 6` → … |
| 80 | S-528 | G-METIN-6 | SESSİZ | eski AST-x64 | Metin işlemlerinin sonucu geçici bir halkada tutulur ve `STRING` değişkeni kopya değil o … |
| 81 | S-270 | G-MODUL-1 | SESSİZ | AST, MIR, x64 | `CONST` bir `MODULE` içinde tanımlanıp aynı modülün işlevinde okunursa AST "Tanımlanmamış … |
| 82 | S-271 | G-MODUL-3 | SESSİZ | AST, MIR, x64 | Aynı adlı işlev iki modülde varsa ve ikisi de `USING` ile açıldıysa çağrı hata vermez, … |
| 83 | S-531 | G-MODUL-5 | SESSİZ | eski AST-x64 | `MODULE` içinde bildirilen değişkenin değeri okunamaz, adres benzeri bir sayı gelir; hata … |
| 84 | S-231 | G-NESNE-1 | SESSİZ | AST, MIR | `STATIC` üye: AST "field root variable missing" hatası verir, MIR `0` yazar, x64 doğru … |
| 85 | S-235 | G-NESNE-10 | SESSİZ | AST, MIR, x64, JS | Sınıf tipli alan (bir sınıfın içinde başka sınıf tipli `DIM m AS Motor`): `THIS.m = NEW …` |
| 86 | S-236 | G-NESNE-11 | SESSİZ | MIR, x64, JS | Sınıf içindeki `TYPE` alanına **metot içinden** erişim: AST doğru (`30`, `12`); MIR … |
| 87 | S-375 | G-NESNE-13 | SESSİZ | AST | Nesne listesini taban tipli bir döngü değişkeniyle gezmek (`DIM s AS Sekil` .. |
| 88 | S-378 | G-NESNE-14 | SESSİZ | AST, MIR, x64 | Tanınmayan `MAGIC` adı hata vermez: `MAGIC BU_YOK() … END MAGIC` ve `MAGIC ITER() … END …` |
| 89 | S-379 | G-NESNE-17 | SESSİZ | AST | Sınıfın `BOOLEAN` alanını `STR(alan)` ile metne çevirmek AST'de `255` verir (MIR, x64 ve … |
| 90 | S-411 | G-NESNE-18 | SESSİZ | MIR, x64, JS | `PRIVATE` bölümünde kısa `PROPERTY ad AS T` bildirimi sınıfın metotlarında çıplak adla … |
| 91 | S-232 | G-NESNE-2 | SESSİZ | AST, MIR, x64 | `PRIVATE` ve `PROTECTED` alanlara dışarıdan erişim denetlenmez (`k.gizli = 5` çalışır) |
| 92 | S-431 | G-NESNE-20 | SESSİZ | MIR, JS | `DELETE o` sonrasında `o.v` okumak MIR'de silinmiş nesnenin eski değerini verir (`3`); JS … |
| 93 | S-443 | G-NESNE-21 | SESSİZ | AST, MIR, x64, JS | Derleyicinin tanıdığı ama çalışmayan `MAGIC` kancaları: `MAGIC AND`, `OR`, `XOR` ile `c = …` |
| 94 | S-472 | G-NESNE-22 | SESSİZ | AST, MIR, x64, JS | `DELETE` yalnız verilen değişkeni boşaltır ve yıkıcıyı çalıştırır; aynı nesneye başka bir … |
| 95 | S-483 | G-NESNE-28 | SESSİZ | AST, MIR, x64, JS | OOP tasarımının hata saydığı yazımlar bugün sessizce kabul edilir (OOP planı §3.3, §5, … |
| 96 | S-523 | G-NESNE-29 | SESSİZ | AST | **Gerileme:** `MAGIC TOSTRING()` tanımlı bir sınıfın sayısal dönüşlü metodunun sonucu bir … |
| 97 | S-233 | G-NESNE-4 | SESSİZ | AST, MIR, x64 | Nesneyi doğrudan `PRINT n` ile yazdırmak motorlara göre `0`, `OBJECT#0` ya da çöp sayı … |
| 98 | S-234 | G-NESNE-8 | SESSİZ | x64 | `VIRTUAL METHOD … AS F64` x64'te `0`/çöp döndürür; ondalıklı alana tamsayı sabiti (`d.en …` |
| 99 | S-237 | G-NESNE-9 | SESSİZ | AST | Bir işlevin ya da MAGIC işlecin döndürdüğü nesne AST'de ardışık çağrılar arasında … |
| 100 | S-274 | G-ONISLEM-1 | SESSİZ | önişlemci | `%%IF` yalnız şunları bilir: `TRUE`/`FALSE`, sayı, makro adı (değeri 0 değilse doğru) ve … |
| 101 | S-283 | G-ONISLEM-14 | SESSİZ | önişlemci | Web/paket bildirimleri (`BUNDLE_*`, `AUTHOR`, `LICENSE`, `SANDBOX_ROOT`, `BROWSER_ENTRY`, … |
| 102 | S-284 | G-ONISLEM-16 | SESSİZ | önişlemci | Blok yönergelerinin gövdesinde (`HTML_BEGIN` … ) `{{AD}}` makroları açılmaz; gövde olduğu … |
| 103 | S-285 | G-ONISLEM-17 | SESSİZ | önişlemci | `NOZEROVARS`, `SECSTACK`, `DEPRECATED`, `SOURCE_MAP`, `WARN_META`, `INFOMETA` ve … |
| 104 | S-280 | G-ONISLEM-18 | SESSİZ | önişlemci | `%%OUTDIR` ve `%%TARGET WEB` ile bile `jsw --emit-browser` çıktıyı … |
| 105 | S-275 | G-ONISLEM-2 | SESSİZ | önişlemci | Döngü değişkeni `%%AD` biçiminde yazılırsa, adı bir yönerge adının başıyla çakışan … |
| 106 | S-282 | G-ONISLEM-20 | SESSİZ | önişlemci | Yönerge satırının sonuna yazılan `'` yorumu makro değerine girer: `%%DEFINE X 3 ' not` … |
| 107 | S-276 | G-ONISLEM-3 | SESSİZ | önişlemci | Dengesiz `%%IF` / `%%ELSE` / `%%ENDIF` (eksik ya da fazladan `%%ENDIF`, tek başına … |
| 108 | S-277 | G-ONISLEM-4 | SESSİZ | önişlemci | `%%CONFIG_FILE` dosyayı bulamazsa derlemeyi durdurmaz; yalnız önişlemci tanı listesine … |
| 109 | S-278 | G-ONISLEM-5 | SESSİZ | önişlemci | `%%LOCK_META` kilidini bozan `%%SET`/`%%DEFINE` reddedilir ama yalnız tanı listesine … |
| 110 | S-279 | G-ONISLEM-6 | SESSİZ | önişlemci | `%%PATH_ALIAS`, `%%OUTDIR`, `%%ASSET_ROOT`, `%%COPY_DIR`, `%%ASSET_*`, `%%LICENSEFILE`, … |
| 111 | S-281 | G-ONISLEM-7 | SESSİZ | önişlemci | `%%ASSET_COPY "a" "b"` (boşlukla ayrılmış) hata vermez ama iki yolu tek kaynak gibi okur; … |
| 112 | S-214 | G-TIP-1 | SESSİZ | AST, MIR, x64, eski AST-x64 (BIGINT) | `DIM g AS BIGINT = 1` ile başlatılan değişken `I64` gibi davranır (25! → … |
| 113 | S-415 | G-TIP-10 | SESSİZ | MIR, x64 | `F128` değişkenine ondalık değer atamak MIR ve x64'te kesir kısmını sessizce atar: `a = …` |
| 114 | S-416 | G-TIP-11 | SESSİZ | MIR, x64 | `BIGF`, `BIGD` ve `BALL` değişkenleri sıradan sayı atamasıyla kullanılınca: MIR'de çıplak … |
| 115 | S-078 | G-TIP-14 | SESSİZ | AST, MIR, x64, JS | Yalnız sabitlerden oluşan tamsayı ifadesi derleme anında **ondalık sayıyla** katlanır, … |
| 116 | S-502 | G-TIP-16 | SESSİZ | AST-x64 | **Kapandı (20261013_2306 ve sonrası; S-502):** eski AST-x64 yolunda `F32` dizi elemanı … |
| 117 | S-506 | G-TIP-17 | SESSİZ | AST | **Kapandı (20261013_2224 ve sonrası; S-506):** `I8` … `U64` dönüşümleri AST'de ondalığı … |
| 118 | S-509 | G-TIP-19 | SESSİZ | MIR-x64 | **Kapandı (20261014_0253; S-509):** `F32` dizi elemanını okuyan ifadeler MIR-x64'te … |
| 119 | S-215 | G-TIP-2 | SESSİZ | JS | `I32` taşması sarmaz (2147483647 + 1 → 2147483648) |
| 120 | S-510 | G-TIP-20 | SESSİZ | MIR | **Kapandı (20261014_0253; S-510), yordam içindeki yerel değişken hariç:** MIR `F32` … |
| 121 | S-511 | G-TIP-21 | SESSİZ | MIR-x64 | **Kapandı (20261014_0253; S-511), `TYPE` alanı hariç:** `F32(x)` sonucu MIR-x64'te … |
| 122 | S-512 | G-TIP-22 | SESSİZ | AST-x64 | **Kapandı (20261014_0253; S-512):** eski AST-x64 yolunda `DIM t AS F32 = d` biçimi artık … |
| 123 | S-515 | G-TIP-23 | SESSİZ | MIR | Bir yordamın (`SUB`/`FUNCTION`) **içindeki yerel** `F32` değişkene yazılan değer MIR … |
| 124 | S-516 | G-TIP-24 | SESSİZ | MIR-x64 | `F32` **alanı** (`TYPE` üyesi) aritmetik işlenen olunca MIR-x64'te (yerel x64) bozulur; … |
| 125 | S-517 | G-TIP-25 | SESSİZ | MIR-x64, JS | Bir yordam içinden **genel** `F32` değişkene yapılan atama MIR-x64 ve JS'te tek duyarlığa … |
| 126 | S-518 | G-TIP-26 | SESSİZ | JS | `BYVAL` `F32` parametreye giren değer JS'te tek duyarlığa yuvarlanmaz: `SUB B(BYVAL p AS …` |
| 127 | S-526 | G-TIP-28 | SESSİZ | eski AST-x64 | Bir rutinin (`SUB`/`FUNCTION`) **içinde bildirilen** tamsayı değişken (`I32`, `I64`) … |
| 128 | S-216 | G-TIP-3 | SESSİZ | WASM | `U32` alt taşması işaretli yazdırılır (0 - 1 → -1; beklenen 4294967295) |
| 129 | S-217 | G-TIP-5 | SESSİZ | JS | `CINT(3.5)` 3, `INT(-3.1)` -3 verir (yerel motorlar 4 ve -4): yuvarlama ve taban yerine … |
| 130 | S-218 | G-TIP-6 | SESSİZ | üç motor | Eski tip adları kabul edilir (LONG, INTEGER → I32; SHORT → I16; BYTE → I8; UBYTE → U8; … |
| 131 | S-377 | G-TIP-7 | SESSİZ | AST, MIR, x64 | Tipli işaretçi yazımı `DIM p AS PTR TO I32` hata vermez ama ham `PTR` gibi davranır: `p + …` |
| 132 | S-442 | G-VERI-11 | SESSİZ | MIR, JS (x64: AÇIK) | **`UNION` alanları yalnız AST'de aynı belleği paylaşır:** `u.i = 258` sonra `u.b` (U8) … |
| 133 | S-529 | G-VERI-13 | SESSİZ | eski AST-x64 | `REDIM` ile büyütülen dizi gerçekte büyümez; yeni elemanlar komşu değişkenlerin ve metin … |
| 134 | S-227 | G-VERI-3 | SESSİZ | AST, MIR, x64 | `FUNCTION … AS TYPE` (kayıt döndüren işlev): alanlar sıfırlanır; hiçbir motorda doğru … |
| 135 | S-228 | G-VERI-4 | SESSİZ | AST, x64 | Tüm diziyi kopyalama `b = a`: MIR kopyalar, AST ve x64 kopyalamaz |
| 136 | S-229 | G-VERI-6 | SESSİZ | AST, MIR, JS, x64 | Kaydı bir işleve **değerle** geçirmek (`FUNCTION T(p AS N) AS I32: RETURN p.x + p.y`, … |
| 137 | S-230 | G-VERI-9 | SESSİZ | AST, MIR, x64, JS | Kayıt (`TYPE`) içinde sınıf tipli alan (`m AS Motor`): `k.m = NEW Motor(90)` ya da yerel … |
| 138 | S-250 | G-WASM-1 | SESSİZ | WASM | `NEW` ile oluşturulan nesnenin alanları `0` okunur (beklenen 33 / 66) |
| 139 | S-418 | G-WASM-16 | SESSİZ | WASM | Tamsayı **değişkenlerle** `/` ve `**`: `PRINT a / b` (7 / 2) ve `PRINT a ** b` (7 ** 2) … |
| 140 | S-419 | G-WASM-17 | SESSİZ | WASM | `NOT x` ve `~x` bit tersi değil mantıksal değil gibi çalışır: `NOT 0` → `1` (beklenen … |
| 141 | S-420 | G-WASM-18 | SESSİZ | WASM | Karşılaştırma, `&&` ve `ANDALSO` sonucu doğruysa `1` verir (öbür dört motor `-1`): `PRINT …` |
| 142 | S-421 | G-WASM-19 | SESSİZ | WASM | `SGN(x)` boş satır ve `0` yazar (beklenen `-1`, `0`, `1`); tanımsız ya da gerçeklenmemiş … |
| 143 | S-251 | G-WASM-2 | SESSİZ | WASM | `PRINT a, b` virgül bölgesini uygulamaz, iki ayrı satır yazar |
| 144 | S-422 | G-WASM-20 | SESSİZ | WASM | `F128`, `BIGINT`, `BIGF`, `BIGD` ve `BALL` değişkenleri WASM'da reddedilmez, `i32` gibi … |
| 145 | S-513 | G-WASM-21 | SESSİZ | WASM | `SHR` (sağa kaydırma) işaretsiz tamsayı tiplerinde (`U8`, `U16`, `U32`) hep `0` verir; … |
| 146 | S-514 | G-WASM-22 | SESSİZ | WASM | `ROL` ve `ROR` (bit döndürme) WASM'da hiçbir tamsayı tipiyle çalışmaz, hep `0` verir; … |
| 147 | S-545 | G-WASM-23 | SESSİZ | WASM | Tanımsız bir işlev ya da `SUB` çağrısı WASM'da derleme hatası vermez ve sessizce hiçbir … |
| 148 | S-252 | G-WASM-3 | SESSİZ | WASM | `DICT` ve `SET` boş satırlar ve `0` yazar |
| 149 | S-253 | G-WASM-4 | SESSİZ | WASM | `HEX`/`OCT`/`BIN` metin işlevleri boş ya da `0` üretir |
| 150 | S-254 | G-WASM-5 | SESSİZ | WASM | `ATOMIC` işlemleri boş ya da `0` üretir |
| 151 | S-255 | G-WASM-6 | SESSİZ | WASM | `MAGIC` ile tanımlı nesne işleçleri (`+`, `AND`, `OR`, `XOR`) `0` döndürür; hata ve uyarı … |
| 152 | S-223 | G-YORDAM-1 | SESSİZ | AST, MIR, x64, JS | Aşırı yükleme (aynı ad, farklı parametre sayısı): AST "duplicate routine" der, MIR ve JS … |
| 153 | S-224 | G-YORDAM-2 | SESSİZ | AST, MIR, x64 | `RETURN`'süz biten `FUNCTION`: AST ve MIR `0`, x64 rastgele bir değer döndürür |
| 154 | S-225 | G-YORDAM-3 | SESSİZ | AST, MIR, x64 | `I32` parametreye metin vermek (`P("a")`) hata değildir: AST ve MIR `0`, x64 çöp sayı … |
| 155 | S-226 | G-YORDAM-4 | SESSİZ | AST, MIR, x64 | `I32` parametreye `2.5` vermek: AST ve MIR sessizce keser (2), x64 `0` kullanır; oysa … |
| 156 | S-440 | G-YORDAM-6 | SESSİZ | AST, MIR, x64, JS | **Parantezsiz `SUB` çağrısı sessizce hiçbir şey yapmaz:** `Selam`, `Selam "Ayse"`, `Yaz …` |
| 157 | S-527 | G-YORDAM-7 | SESSİZ | eski AST-x64 | Rutin içindeki yerel değişken sıfırlanmaz, önceki çağrıdan kalan yığın değerini taşır; … |
| 158 | S-544 | G-YORDAM-9 | SESSİZ | SUB, FUNCTION (altı yol) | `SUB` ve `FUNCTION`, tanımdan önce `DECLARE` olmadan çağrılabilir; derleyici bunu … |
| 159 | S-466 | G-CLI-22 | ÇÖKME | --parser-surface-contract-json-out | Göreli ya da klasörlü yolla verilince (`--parser-surface-contract-json-out e.json`) ve … |
| 160 | S-467 | G-CLI-28 | ÇÖKME | --interop | `run` dışındaki fiillerde (`x64`, `bld`, `jsw`, `wat`, `mir`) derleyicinin kendisi … |
| 161 | S-460 | G-DIL-13 | ÇÖKME | x64 | **Kısmen kapandı (20261014_0253 ve sonrası; S-460):** x64'ün çöktüğü biçimlerin (`5 + …` |
| 162 | S-535 | G-DIS-13 | ÇÖKME | AST | **Gerileme:** AST'de `CALL(DLL, …)` bağımsız değişkeni olarak boş metin (`""`) geçirmek … |
| 163 | S-534 | G-DOSYA-7 | ÇÖKME | eski AST-x64 | `PRINT #n` ile tamsayı yazmak erişim ihlaliyle çöker (çıkış `3221225477`, hiçbir çıktı … |
| 164 | S-533 | G-ISLEC-13 | ÇÖKME | eski AST-x64 | İçinde `PRINT` (ya da `PRINT` yapan bir `SUB` çağrısı) olan bir işlevin çağrısı tamsayı … |
| 165 | S-507 | G-KTIP-8 | ÇÖKME | AST-x64 | **Kapandı (20261013_2052 ve sonrası; S-499 kapısıyla):** `RATIONAL` programı AST-x64'te … |
| 166 | S-287 | G-KUT-9 | ÇÖKME | MIR, x64 | `uxnn`: `NetworkAddLayer` ile ağa eklenen katmanın sahibi ağdır |
| 167 | S-543 | G-YORDAM-8 | ÇÖKME | MIR | **Gerileme (20261014_0253):** MIR yorumlayıcıda derinliği 50'yi aşan özyineleme programı … |
| 168 | S-294 | G-AKIS-1 | FARK | AST | `FOR x = 0 TO 1 STEP 0.25` (ondalıklı sayaç): AST "FOR step cannot be zero" der; MIR ve … |
| 169 | S-295 | G-AKIS-2 | FARK | AST ↔ MIR, x64 | `FOR i = 1 TO n` gövdesinde `n` değişirse AST bitişi bir kez hesaplar (BASIC anlamı); MIR … |
| 170 | S-537 | G-AKIS-5 | FARK | AST, MIR, MIR-x64, eski AST-x64, JS, WASM | Önceden `GOSUB` yapılmamış bir `RETURN` yollara göre farklı davranır |
| 171 | S-161 | G-DIL-15 | FARK | AST (öbür dört motordan farklı) | Aynı ifadede bir genel değişkenin okunması ile o değişkeni değiştiren bir işlev çağrısı … |
| 172 | S-288 | G-DIL-9 | FARK | AST | Yerleşik işlevle aynı adı taşıyan kullanıcı işlevi (`FUNCTION Left`) AST'de yerleşiğe … |
| 173 | S-380 | G-DIS-10 | FARK | AST ↔ MIR, x64 | `CALL(DLL, "C:\yol\x.dll", …)` mutlak yol: AST "CALL(DLL) library must not be absolute … |
| 174 | S-491 | G-DIS-12 | FARK | AST, MIR ↔ x64 | DLL'den dönen `PTR` değeri yorumlayıcılarda 31 bitlik **etiketli bir tutamaçtır**, x64'te … |
| 175 | S-315 | G-DIS-3 | FARK | AST, MIR, x64 | `CALL(DLL)` izin listesi (`build/manual/config/ffi_allowlist.txt`, başlık … |
| 176 | S-316 | G-DIS-5 | FARK | AST, MIR, x64 | Argümansız DLL işlevinde tip listesi **hiç yazılmaz** (`CALL(DLL, "d", "f", I32, …` |
| 177 | S-317 | G-DIS-9 | FARK | AST, MIR | DLL'den dönen işaretçiye sayı eklemek (`taban + satir * 32`) yalnız x64'te çalışır; AST … |
| 178 | S-303 | G-DOSYA-1 | FARK | AST, x64 | `INPUT #n, sayiDegiskeni`: AST yalnız tamsayı okur, x64'te sayı değişkenine okuma bozuktur |
| 179 | S-304 | G-DOSYA-2 | FARK | MIR, x64 | İkili dosya (`FOR BINARY`, `GET`, `PUT`, `SEEK`) yalnız AST'de çalışır; MIR … |
| 180 | S-305 | G-DOSYA-3 | FARK | AST ↔ MIR, x64 | Kanalsız `CLOSE`: AST kabul eder, MIR "CLOSE channel required" der, x64 derlemez |
| 181 | S-536 | G-DOSYA-8 | FARK | eski AST-x64 | `PRINT #n` satırları `LF` ile sonlandırır; öteki yollar `CR LF` yazar (kitap örneği `LOF` … |
| 182 | S-306 | G-GOREV-1 | FARK | MIR, x64 | `PIPE`'ı işlev gibi çağırmak (`PRINT Ikile(3)`) yalnız AST'de çalışır; MIR … |
| 183 | S-307 | G-GOREV-5 | FARK | MIR, x64 | `SLOT … OFF` başlangıç durumunu yalnız AST uygular; MIR ve x64 yok sayar |
| 184 | S-308 | G-GOREV-8 | FARK | MIR, x64 | Görev hatası `JOIN`'de MIR ve x64'te ölümcüldür (program durur); AST'de `TRY` ile … |
| 185 | S-309 | G-GOREV-9 | FARK | AST, MIR, x64 | `ERRORTEXT` metninin tam biçimi motora göre değişir (AST satır ve rutin bilgisi ekler) |
| 186 | S-300 | G-HATA-1 | FARK | MIR, x64 | `TRY` içindeki `RETURN`: AST `FINALLY`'yi çalıştırır, MIR ve x64 çalıştırmaz |
| 187 | S-500 | G-HATA-13 | FARK | CLI, tüm motorlar (tanı kayıt biçimi) | **Kısmen kapandı (20261014_0253; S-500):** çalışma anı üç kodun (`MISSING`, … |
| 188 | S-301 | G-HATA-2 | FARK | MIR, x64 | Çalışma anı hataları (dizi sınırı, sıfıra bölme, boş nesne) `TRY` ile yalnız AST'de … |
| 189 | S-302 | G-HATA-3 | FARK | MIR, x64 | `CATCH` içinden yeniden `THROW` edilirse aynı `TRY`'ın `FINALLY` bloğu MIR ve x64'te … |
| 190 | S-437 | G-HATA-5 | FARK | AST, MIR ↔ x64, JS | Ondalık alan hataları: `f / 0` (F64), `SQR(-1)` ve `LOG(0)` AST ve MIR'de çalışma anı … |
| 191 | S-438 | G-HATA-7 | FARK | tüm motorlar | Aynı çalışma anı hatası için çıkış kodu ve ileti motora göre değişir: AST çıkış 5, MIR … |
| 192 | S-439 | G-HATA-9 | FARK | x64 | Tamsayı sıfıra bölmede (`5 \ 0`, `5 MOD 0`) x64 hiçbir ileti yazmadan çıkış kodu 2 ile … |
| 193 | S-435 | G-ISLEC-6 | FARK | x64 | `1 SHL s` (`s` bir `I32` değişken, 40): AST, MIR ve JS `1099511627776` (64 bit sonuç) … |
| 194 | S-505 | G-ISLEC-9 | FARK | AST, MIR, x64, JS | **Kapandı (MIR yorumlayıcı 20261013_2144'te, MIR-x64 20261013_2209'da; S-505):** … |
| 195 | S-293 | G-KOLEKSIYON-1 | FARK | AST, MIR, x64 | `LISTADD(l, "elma")` sonra `PRINT LISTGET(l, 1)`: AST `0`, MIR doğru, x64 çöp sayı yazar … |
| 196 | S-312 | G-KUT-10 | FARK | AST, MIR, x64 | Kapatılmış tutamacın yeniden kullanılması: AST ve MIR açık hata verir (`stale or invalid …` |
| 197 | S-313 | G-KUT-21 | FARK | AST | `uxllama` sarmalayıcısında `Prompt` ve `PromptFile` işlevlerinin parametre adları … |
| 198 | S-311 | G-KUT-4 | FARK | x64 | Üçüncü taraf DLL'lere bağımlı kütüphaneler (DuckDB için `duckdb.dll`, SDL3, raylib, curl … |
| 199 | S-290 | G-METIN-1 | FARK | AST, MIR, x64 | `MID(s, 0, n)`: AST "MID start must be >= 1" hatası verir, MIR boş metin, x64 "ab" … |
| 200 | S-291 | G-METIN-2 | FARK | x64 | `VAL("&HFF")`: AST ve MIR 255, x64 0 verir |
| 201 | S-292 | G-METIN-3 | FARK | AST, MIR, x64 | `INSTR(s, "b", 3)` (başlangıç sonda) AST ve MIR'de 0 verir, x64'te ikinci değer yazılmaz; … |
| 202 | S-436 | G-METIN-5 | FARK | JS | `VAL("abc")` AST, MIR ve x64'te `0`, JS'te `nan` verir |
| 203 | S-314 | G-MODUL-4 | FARK | AST, MIR, x64 | Modül içindeki `CLASS` `USING` ile kullanılınca AST "missing runtime vtable" der, MIR ve … |
| 204 | S-414 | G-NESNE-19 | FARK | AST ↔ MIR, x64 | `RESTRICTED` bölümündeki metoda dışarıdan çağrı AST'de çalışma anı hatasıdır ("access … |
| 205 | S-473 | G-NESNE-23 | FARK | AST, MIR, x64, JS | Yıkıcının kaç kez çalışacağı motora göre değişir: aynı değişkene iki kez `DELETE` yazınca … |
| 206 | S-484 | G-NESNE-24 | FARK | AST (öbür üç motordan farklı) | Taban sınıfın bir metodunun içinden sanal bir metot çağrılınca sonuç motora göre değişir |
| 207 | S-485 | G-NESNE-25 | FARK | AST, MIR (x64 ve JS'ten farklı) | Kalıtımda taban sınıfın kurucusu AST ve MIR'de **hiç çalışmaz**, x64 ve JS'te çalışır |
| 208 | S-486 | G-NESNE-26 | FARK | AST (MIR, x64 ve JS'ten farklı) | Taban tipli değişkenle tutulan türetilmiş nesneyi silmek (`DIM x AS A = NEW B()` ardından … |
| 209 | S-299 | G-NESNE-3 | FARK | MIR, x64 | Yalnız okunur `PROPERTY … GET`: AST yazmayı "property SET accessor denied" ile reddeder; … |
| 210 | S-547 | G-NESNE-36 | FARK | INSTANCEOF (AST dışı) | `INSTANCEOF(nesne, Sinif)` yalnız AST'de çalışır (`-1`); MIR çalışma anı hatası verir … |
| 211 | S-319 | G-ONISLEM-12 | FARK | önişlemci | Döngü sınırı sabit 100 000 turdur (`PREPROCESSOR_FOR_ITERATION_LIMIT`); `%%EXPANDLIMIT` … |
| 212 | S-320 | G-ONISLEM-13 | FARK | önişlemci | `%%CONFIG_FILE` ve `%%EMBEDTEXT` yolu **derleyicinin çalıştığı klasöre** göre çözülür; … |
| 213 | S-321 | G-ONISLEM-15 | FARK | önişlemci | Komutlar iki kümeye ayrılmıştır: A (varsayılan) ve B (web/paket) |
| 214 | S-318 | G-ONISLEM-8 | FARK | önişlemci | `%%DEFINE` ve `%%SET` değerin başındaki ve sonundaki çift tırnağı atar (`%%DEFINE ADI …` |
| 215 | S-446 | G-TIP-13 | FARK | AST, MIR, x64, JS | **Kapandı (20261013_2333 ve 20261014_0253; S-446):** `F32` bildirim başlangıcı, atama, … |
| 216 | S-503 | G-TIP-15 | FARK | AST, MIR, x64, JS (F32 başlangıç değeri ve dizi elemanı) | **Kapandı (20261014_0253 ve sonrası; S-503):** `F32` dizi elemanı yazımı ve okuması beş … |
| 217 | S-519 | G-TIP-27 | FARK | AST | `F32` aritmetik **ara sonucu** AST'de tek duyarlığa yuvarlanmaz, öteki dört yol yuvarlar: … |
| 218 | S-289 | G-TIP-4 | FARK | AST, MIR, x64 ↔ JS | `STRING` bir UTF-8 bayt dizisidir: `LEN("çğaö")` = 7 (JS'te 4); `LEFT`, `MID`, `ASC`, … |
| 219 | S-297 | G-VERI-1 | FARK | AST, x64 | Kayıt dizisinde eleman takası (`t = k(j)`, `k(j) = k(j+1)`): AST'de etkisiz, MIR doğru, … |
| 220 | S-546 | G-VERI-17 | FARK | VARPTR (kayıt dizisi) | Kayıt (`TYPE`) dizisinin adresinden eleman alanına yazmak motorlara göre değişir |
| 221 | S-298 | G-VERI-2 | FARK | MIR, JS, x64 | `BYREF` kayıt parametresi (`SUB Art(BYREF p AS N)` içinde `p.x = p.x + 1`): AST doğru … |
| 222 | S-310 | G-WASM-11 | FARK | WASM (node ve tarayıcı) | `ux_wasm_runtime.js` sayıyı yazdırırken `process` tanımlıysa (node) doğrudan standart … |
| 223 | S-423 | G-WASM-13 | FARK | WASM | Sanal bellek sınırının (1 MiB) dışına yazmak ya da okumak: AST (çıkış kodu 5), MIR (13), … |
| 224 | S-296 | G-YORDAM-5 | FARK | AST, MIR, x64 | Özyineleme derinliği: AST 100'den az ("call stack limit exceeded"), MIR 50'den az … |
| 225 | S-383 | G-ARAC-1 | AÇIK | uxbdll | `tools/uxbdll/uxbdll.py` derleyicinin bugünkü x64 çıktısında rutin etiketlerinin … |
| 226 | S-384 | G-ARAC-2 | AÇIK | uxclazz | `tools/uxclazz/uxclazz.py` ürettiği kodu hiç gerçek derleyiciyle derlememiştir (araç … |
| 227 | S-413 | G-ARAC-4 | AÇIK | x64 derleme (uxbdll modülleri) | Üst düzey deyimi olmayan bir modülde hiçbir yerde başvurulmayan ve parametreden … |
| 228 | S-542 | G-ARAC-6 | AÇIK | tests\run_all_model_tests.ps1 | `-ReportPath` olarak **mutlak** yol verilince betik bütün paketleri koşturur ama rapor … |
| 229 | S-478 | G-BELGE-1 | AÇIK | docs\uxbasic_5_cilt\examples\projects | İki eski örnek proje kılavuz ikilisinde çalışmaz |
| 230 | S-322 | G-CLI-1 | AÇIK | mir | Program parametreli bir işlev içeriyorsa `uxb mir` "type: unknown symbol: x" ile düşer |
| 231 | S-452 | G-CLI-11 | AÇIK | kaynak yolu (olmayan dosya, kaynak verilmemesi) | Var olmayan kaynak dosya (uzantısı `.uxb` bile olsa) ve hiç kaynak verilmemesi … |
| 232 | S-457 | G-CLI-18 | AÇIK | --diag-format json | Çıktı tek bir JSON belgesi değil, ayraçsız art arda yazılmış JSON nesneleridir (dizi … |
| 233 | S-461 | G-CLI-21 | AÇIK | bld --build-x64-out (yalın dosya adı) | Klasör bileşeni olmayan EXE yolu (`--build-x64-out ilk.exe`, `.\ilk.exe`) çıkış 14 ve … |
| 234 | S-470 | G-CLI-29 | AÇIK | --out-root, --artifact-root, --run-id | Var olmayan ve adı **tam iki karakter** olan göreli çıktı kökü oluşturulamaz: `--out-root …` |
| 235 | S-323 | G-CLI-3 | AÇIK | chk | `tools\run_validate_all_gate.ps1` aranır; dosya `tool_py\tools\` altında olduğu için fiil … |
| 236 | S-324 | G-CLI-7 | AÇIK | hlp --verbose | "Bilinmeyen CLI seçeneği: --verbose" ile reddedilir; oysa yardım metni bunu önerir |
| 237 | S-325 | G-CLI-8 | AÇIK | @dosya.uxcli | Yanıt dosyası "Desteklenmeyen kaynak dosya uzantisi: .uxcli" ile reddedilir (kod yazılı … |
| 238 | S-326 | G-DIL-1 | AÇIK | x64 | `DIM dizi(SABIT_AD - 1)`: x64 yalnız sayısal sabit sınır kabul eder ("DIM array bounds … |
| 239 | S-203 | G-DIL-10 | AÇIK | x64 | Programın herhangi bir yerinde `ASSERT`, `TRY` ya da `THROW` varsa ve bir yordamda `DIM …` |
| 240 | S-540 | G-DIL-17 | AÇIK | AST | **Gerileme:** AST 1024'ten fazla değişkeni olan programı reddeder: `exec: variable …` |
| 241 | S-327 | G-DIL-2 | AÇIK | üç motor | Blok yorum `/' … '/` yok ("statement parse failed near OP('/')") |
| 242 | S-328 | G-DIL-3 | AÇIK | üç motor | `? ifade` kısayolu yüzey kaydında vardır ama çözümleyici reddeder ("statement parse … |
| 243 | S-329 | G-DIL-7 | AÇIK | AST, MIR, JS, eski AST-x64 (WASM için G-WASM-23) | Tanımsız işlev çağrısı (`PRINT Bilinmeyen(3)`) AST ve MIR'de ancak çalışma anında hata … |
| 244 | S-355 | G-DIS-2 | AÇIK | AST, MIR, x64 | `DECLARE FUNCTION f LIB "x.dll" ALIAS "f" (…)` yalnız bildirimdir: bildirilen adı … |
| 245 | S-356 | G-DIS-4 | AÇIK | x64 derleme | `uxb bld … --interop` FreeBASIC çalışma anı hatasıyla çöker ("Aborting due to runtime … |
| 246 | S-357 | G-DIS-6 | AÇIK | AST, MIR, x64 | `INLINE` blokları hiçbir motorda çalışan sonuç vermez: başlık ve ilke denetimi gerçektir … |
| 247 | S-358 | G-DIS-8 | AÇIK | AST, MIR | `CODEPTR(Fonksiyon)` bir uXBasic işlevinin gerçek makine kodu adresini verir (C … |
| 248 | S-338 | G-GOREV-2 | AÇIK | AST, MIR, x64 | `PIPE` kendini çağıramaz ("numeric operands required"); `THREAD` doğrudan çağrılamaz … |
| 249 | S-339 | G-GOREV-6 | AÇIK | JS | Hiçbir görev yapısı çalışmaz; ret derlemede değil yürütme anında gelir: "UXB host binding … |
| 250 | S-340 | G-GOREV-7 | AÇIK | WASM | Görev yapıları açıkça reddedilir (metin ve görev altyapısı yok) |
| 251 | S-538 | G-HATA-14 | AÇIK | eski AST-x64 | Eski AST-x64 desteklemediği yerleşik ve özellikleri anlaşılır bir "desteklenmiyor" … |
| 252 | S-330 | G-ISLEC-2 | AÇIK | AST, x64 | `@x` adres işleci çalışmaz (AST "NATIVE PEEKD out of range", x64 derlenmez); `x AND= 3`, … |
| 253 | S-425 | G-ISLEC-3 | AÇIK | x64, JS, WASM | Tekli `+x` ve `!x` bir **değişken** işlenenle x64, JS ve WASM'da derlenmez ("ADIM25 … |
| 254 | S-426 | G-ISLEC-4 | AÇIK | tüm motorlar | Bir karşılaştırmanın sonucunu doğrudan `-`, `*`, `/` ya da `**` işlecinin işleneni yapmak … |
| 255 | S-343 | G-JS-10 | AÇIK | JS | `NATIVE` sınıflı `PEEK`/`POKE`/`MEMFILL`/`MEMCOPY` (ön ek ya da `AUTO` ile `PTR` … |
| 256 | S-341 | G-JS-7 | AÇIK | JS | Derlemede ret yerine **yürütme anında** "UXB host binding missing: X": dosya G/Ç … |
| 257 | S-342 | G-JS-8 | AÇIK | JS | `PRINT a, b` (virgül bölgesi) yürütme anında "host binding missing: PRINT_SEP_COMMA" … |
| 258 | S-331 | G-KOLEKSIYON-4 | AÇIK | AST, MIR, x64, JS | Koleksiyon tipli dizi elemanı (`DIM dz(2) AS LIST`) ve sınıf alanı (`DIM urunler AS LIST` … |
| 259 | S-352 | G-KTIP-1 | AÇIK | x64, JS, WASM, AST | Kütüphane tiplerinin sağlayıcısı (RATIONAL, TEXT_VALUE, TEXT_REF …) yalnız MIR'dedir |
| 260 | S-353 | G-KTIP-4 | AÇIK | x64 derleme | `LIBTYPE` bildirimli programı x64'e derlerken `uxb bld` yığın taşmasıyla çöker ("Aborting … |
| 261 | S-351 | G-KUT-14 | AÇIK | AST, MIR, x64 | `uxaimath`: kaynaktaki yorum tensör köprüsünün isteğe bağlı olduğunu söylese de … |
| 262 | S-348 | G-KUT-2 | AÇIK | x64 | `uxlogic.dll` içinde `uxlogic_prolog_query_ex` dışa aktarılmamıştır, ama sarmalayıcı bu … |
| 263 | S-349 | G-KUT-3 | AÇIK | tüm motorlar | `uxcapi.dll` yüklenemiyor (`WinError 127: Belirtilen yordam bulunamadı`, bir bağımlılık … |
| 264 | S-350 | G-KUT-5 | AÇIK | AST, MIR, x64 | Kütüphane işlev adıyla aynı adlı değişken (büyük/küçük harf farksız) atama hatası verir: … |
| 265 | S-354 | G-MODUL-2 | AÇIK | AST, MIR, x64 | İç içe `MODULE`/`NAMESPACE` (`Dis.Ic.F()`, `Dis.Ic.v`) çalışmaz: AST "field root variable … |
| 266 | S-539 | G-MODUL-6 | AÇIK | AST | **Gerileme:** AST'de `NAMESPACE`/`MODULE` içinde bildirilen **dizi** değişkenine … |
| 267 | S-541 | G-MODUL-7 | AÇIK | AST, MIR, MIR-x64, JS | `NAMESPACE`/`MODULE` içindeki bir işlevde, o ad alanının **dizi** elemanı doğrudan atama … |
| 268 | S-337 | G-NESNE-12 | AÇIK | AST, MIR, x64, JS | Sınıf içinde dizi alanı (`DIM d(3) AS I32`) tanımlanır ama metot içinde `d(i) = v` … |
| 269 | S-381 | G-NESNE-15 | AÇIK | AST, MIR, x64 | Tasarım kılavuzundaki `OPERATOR +(o AS T) AS T … END OPERATOR` bloğu ayrıştırılır ama … |
| 270 | S-382 | G-NESNE-16 | AÇIK | AST, MIR, x64 | Aynı sınıfın iki metodunda aynı adlı ama farklı tipli parametre geçerli programı … |
| 271 | S-335 | G-NESNE-5 | AÇIK | AST, MIR, x64 | `RETURN THIS` ile kendi tipini döndürmek (yöntem zinciri) "explicit cast TYPE_OBJECT to … |
| 272 | S-336 | G-NESNE-7 | AÇIK | MIR | Orta sınıfın `OVERRIDE`'ını alt-alt sınıfta yeniden yazmadan kullanmak MIR'de "MIR method … |
| 273 | S-424 | G-TIP-12 | AÇIK | MIR, x64, JS, WASM | `F80` aritmetiği (`+`, `*`, `/` …) yalnız AST'de çalışır; MIR, x64, JS ve WASM'da … |
| 274 | S-508 | G-TIP-18 | AÇIK | AST, MIR, x64, JS | **Kapandı (20261014_0253 ve sonrası; S-508):** `FIX(x)` değişkene atanır (`I32`, `I64`, … |
| 275 | S-103 | G-VERI-12 | AÇIK | x64, JS | `TYPE` elemanlı dizi parametresi (`SUB Dolas(arr AS Pt[])`, `Pt` bir `TYPE`) yalnız AST … |
| 276 | S-332 | G-VERI-5 | AÇIK | AST, MIR, x64 | `UNION` içinde dizi alanı (`bayt(3) AS U8`) "method call on a null object reference" … |
| 277 | S-333 | G-VERI-7 | AÇIK | x64, JS | Kayıt dizisinde alanı **sabit indisle** atayıp **sabit indisle** okumak (`d(0).a = 1` … |
| 278 | S-334 | G-VERI-8 | AÇIK | AST, MIR, x64, JS | Kaydın içinde kayıt dizisi alanı (`TYPE Sekil: kose(3) AS Nokta`) "assignment requires … |
| 279 | S-347 | G-WASM-10 | AÇIK | WASM | uXBasic'in ürettiği her WASM modülü, kullanılmasalar bile dört `ux` içe aktarması taşır … |
| 280 | S-427 | G-WASM-12 | AÇIK | WASM | Skaler `BYREF` parametre derlemede reddedilir ("WASM backend does not support BYREF … |
| 281 | S-428 | G-WASM-14 | AÇIK | WASM | 8 baytlık (`Q`) bellek erişimi (`PEEKQ`/`POKEQ`) derlemede reddedilir ("WASM … |
| 282 | S-429 | G-WASM-15 | AÇIK | WASM | `PTR` tipine dönüşüm (`PTR(100)`) "WASM CAST target type is not supported by the i32 … |
| 283 | S-563 | G-WASM-24 | AÇIK | WASM | Tek başına duran onaltılık, ikili ya da sekizli sabit WASM'da derlenmez: `PRINT &H44`, … |
| 284 | S-344 | G-WASM-7 | AÇIK | WASM | Ondalıklı değer (F32, F64, F80) yoktur; derlemede açıkça reddedilir ("WASM backend does … |
| 285 | S-345 | G-WASM-8 | AÇIK | WASM | Metin (`STRING`) için doğrusal bellek yoktur; derlemede açıkça reddedilir ("WAT string … |
| 286 | S-346 | G-WASM-9 | AÇIK | WASM | Geçersiz WAT üreten durumlar (hata derleyicide değil, dış araçta `wat2wasm`'da görünür): … |
| 287 | S-390 | G-ARAC-3 | EKSİK | uxclazz | UXClazz yalnız bir kaynak üreticisidir; `CLAZZ` satırı derleyiciye doğrudan verilirse … |
| 288 | S-493 | G-ARAC-5 | EKSİK | araçlar | Politika belgelerinin atıf yaptığı üç Python aracı kaynak ağacında yoktur: … |
| 289 | S-117 | G-ARAC-7 | EKSİK | bld --build-x64 (çıktı klasörü) | x64 derlemesi her çıktı klasörüne yaklaşık 6,5 MB çalışma zamanı DLL'si kopyalar ve bunu … |
| 290 | S-458 | G-CLI-20 | EKSİK | uxb çıkış akışları | Derleyicinin bütün iletileri (`INFO`, `ERROR`, tanılar) ve çalıştırılan programın çıktısı … |
| 291 | S-468 | G-CLI-24 | EKSİK | rapor JSON'ları (24 seçenek) | Kayıt ölçütü "schema/status alanı olacak" der; ama şu çıktıların ikisi de yoktur: … |
| 292 | S-471 | G-CLI-31 | EKSİK | aynı içeriği yazan seçenekler | Yardım metni ayrı raporlar vaat eder ama şu gruplar bayt bayt aynı dosyayı yazar: … |
| 293 | S-385 | G-DIL-11 | EKSİK | üç motor + JS | `ERASE dizi` deyimi yoktur ("unknown symbol: erase"); tasarım belgeleri `REDIM`/`ERASE` … |
| 294 | S-549 | G-DOSYA-10 | EKSİK | dosya kanalları (altı yol) | Tipli dosya tutamacı yoktur; kanal yalnız sayıdır |
| 295 | S-362 | G-DOSYA-4 | EKSİK | üç motor | `LINE INPUT`, `FREEFILE`, `KILL`, `MKDIR`, `NAME`, `DIR`, `WRITE #` yoktur |
| 296 | S-494 | G-DOSYA-6 | EKSİK | AST, MIR, x64, JS | `INPUTF [#]kanal, hedef[, …]` deyimi (dil yüzeyi analizi, 2026-07-02: deyim kaydında … |
| 297 | S-548 | G-DOSYA-9 | EKSİK | dosya kanalları (altı yol) | `FREEFILE` yoktur: `DIM f AS I32 = FREEFILE` altı yolda `type: unknown symbol` ile … |
| 298 | S-376 | G-GOREV-12 | EKSİK | üç motor + JS | Kütüphane tipi görev sınırından geçemez: `THREAD … AS RATIONAL` ve `DIM t AS TASK OF …` |
| 299 | S-501 | G-HATA-12 | EKSİK | tüm motorlar (Türkçe tanı iletileri) | Türkçe tanı metinleri Türkçe harfsiz, ASCII'ye indirgenmiş yazılır: ç→c, ğ→g, ı→i, ö→o, … |
| 300 | S-361 | G-HATA-4 | EKSİK | üç motor | `CATCH e` biçimi hata değerini bir değişkene vermez; `ERR`, `ERRORTEXT` gibi yerleşik … |
| 301 | S-391 | G-HEDEF-1 | EKSİK | üç motor + JS + WASM | Tasarım (20.09 PTR/6502 belgeleri, 23.09 kararları): `ADDR(taban, indeks, ölçek, …` |
| 302 | S-400 | G-HEDEF-10 | EKSİK | üç motor + JS + WASM | Tasarım (S-146 Model D, adım 6): dış (FFI) işlevler için iş parçacığı üst verisi: … |
| 303 | S-401 | G-HEDEF-11 | EKSİK | üç motor + JS + WASM | Tasarım (S-146 Model D, adım 7): işaretçilerin ve MemoryRef bölgelerinin görevler arası … |
| 304 | S-402 | G-HEDEF-12 | EKSİK | JS, WASM | Tasarım (S-030 faz 3-4, 18.09 yüzey matrisi, S-146 D5): JS'te Worker havuzu ve … |
| 305 | S-403 | G-HEDEF-13 | EKSİK | üç motor + JS + WASM | Tasarım (20.09 ve 23.09 kütüphane tipi belgeleri, UBASIC karşılaştırması): `COMPLEX`, … |
| 306 | S-404 | G-HEDEF-14 | EKSİK | üç motor + JS + WASM | Tasarım (23.09 kararları, Halka C-D): kütüphane tipi paket standardı … |
| 307 | S-405 | G-HEDEF-15 | EKSİK | önişlemci | Tasarım (23.09 kararları Halka G, S-136): üretici (generator) kayıt defteri: `%%DERIVE …` |
| 308 | S-406 | G-HEDEF-16 | EKSİK | önişlemci | Tasarım (24.09 web köprüsü ve yama kararları): … |
| 309 | S-407 | G-HEDEF-17 | EKSİK | JS, WASM | Tasarım (18.09 yüzey matrisi, "zorunlu kapanış kuralı", S-153, S-118): her yüzey öğesi … |
| 310 | S-408 | G-HEDEF-18 | EKSİK | JS, WASM | Tasarım (18.09 yüzey matrisi, 2026-10-06 karar önerisi T08): JS'te `I64`/`U64` için … |
| 311 | S-409 | G-HEDEF-19 | EKSİK | üç motor + JS + WASM | KARAR (Mete, 2026-10-11, bağlayıcı): 2026-10-10 motor sadeleştirme önerisi (T09: iki MIR … |
| 312 | S-392 | G-HEDEF-2 | EKSİK | üç motor + JS + WASM | Tasarım (V1 kılavuz §11): UXClazz üst katmanı (`CLAZZ …` |
| 313 | S-410 | G-HEDEF-20 | EKSİK | CLI, tüm motorlar | Tasarım (2026-10-06 karar önerileri H01-H03, S-193): tek yapılandırılmış tanı kaydı … |
| 314 | S-430 | G-HEDEF-21 | EKSİK | x64, JS, WASM | Tasarım (20.09 JS/WASM kütüphane tipi arka uçları belgesi, 47 modül taraması): bir … |
| 315 | S-475 | G-HEDEF-22 | EKSİK | x64 | Üretilen x64 EXE bağımsız (tek dosyalık) değildir: en küçük program bile (`PRINT 42`, 64 … |
| 316 | S-481 | G-HEDEF-23 | EKSİK | WASM | Tasarım önerisi (`uXBasic WASM hedefi Metinler için doğrusal bellek mimarisi.md`, … |
| 317 | S-482 | G-HEDEF-24 | EKSİK | AST, MIR, x64, JS, WASM | Tasarım önerisi (aynı belge, "Türkçe karakterler ve LEN meselesi"): `LEN` Unicode kod … |
| 318 | S-488 | G-HEDEF-25 | EKSİK | üç motor + JS + WASM | Tasarım (15.09 OOP hedef tasarımı ve uygulama planı, §3–§10; belge "tasarım önerisi … |
| 319 | S-490 | G-HEDEF-26 | EKSİK | AST, MIR, x64, JS, WASM | Tasarım izi (15.09 tüm sistem kod denetimi; OOP planı §3.3): genel lambda / kapanış … |
| 320 | S-492 | G-HEDEF-27 | EKSİK | AST, MIR, x64, JS, WASM | Tasarım (`docs/UXB_FILE_TYPES_AND_INCLUDE_POLICY.md`, 2026-05-25): üç kaynak türü vardır: … |
| 321 | S-495 | G-HEDEF-28 | EKSİK | MIR, x64, JS, WASM | Tasarım (`docs/FP_EXTENSION_ROADMAP_AFTER_STAGE4.md`): `F80` korunur ve harici bir kayan … |
| 322 | S-496 | G-HEDEF-29 | EKSİK | AST, MIR, x64 | Kütüphane yol haritalarında (`docs/UX*_ROADMAP.md`, 2026-05-25) "sonraki paket" diye … |
| 323 | S-393 | G-HEDEF-3 | EKSİK | üç motor + JS + WASM | Tasarım (V1 kılavuz §10): `PROPERTY Ad AS T GET … END GET SET(v) … END SET` blok biçimi |
| 324 | S-522 | G-HEDEF-30 | EKSİK | üç motor + JS + WASM | Tasarım … |
| 325 | S-394 | G-HEDEF-4 | EKSİK | üç motor + JS + WASM | Tasarım (15.09 OOP planı, 24.09 uzlaştırma denetimi): genel (generic) tipler … |
| 326 | S-395 | G-HEDEF-5 | EKSİK | üç motor + JS + WASM | Tasarım (24.09 görev kararları): `DECLARE THREAD`, `DECLARE EVENT`, `DECLARE PIPE`, … |
| 327 | S-396 | G-HEDEF-6 | EKSİK | üç motor + JS + WASM | Tasarım (24.09 görev kararları): `TRIGGER SlotAdı, arg`, `TRIGGER SLOT 3, arg`, `ON SLOT …` |
| 328 | S-397 | G-HEDEF-7 | EKSİK | üç motor + JS + WASM | Tasarım (24.09 görev kararları, K1–K8): `KILL TASK t`, `PAUSE TASK t`, `RESUME TASK t` … |
| 329 | S-398 | G-HEDEF-8 | EKSİK | üç motor + JS + WASM | Tasarım (S-146 Model D, adım 4): `DIM SHARED x AS T` (genel ve yerel), `BYSHARED` … |
| 330 | S-399 | G-HEDEF-9 | EKSİK | üç motor + JS + WASM | Tasarım (S-146 Model D, adım 5): `LIST`, `DICT`, `SET`, dizi, `CLASS` nesnesi ve … |
| 331 | S-363 | G-JS-11 | EKSİK | JS (tarayıcı) | `uxb jsw --emit-browser` HTML kabuğuna `<pre id="uxb-console"></pre>` yazar ama hiçbir … |
| 332 | S-359 | G-KOLEKSIYON-2 | EKSİK | üç motor + JS | `LISTGET`/`DICTGET` sonucunu `LIST`, `DICT`, `SET`, nesne ya da kayıt değişkenine atamak … |
| 333 | S-388 | G-KOLEKSIYON-6 | EKSİK | AST, MIR, x64, JS | Ortak yineleyici sözleşmesi (`ITER_CREATE/NEXT/CLOSE`), `MAGIC ITER`, `FOR EACH x IN …` |
| 334 | S-365 | G-KTIP-3 | EKSİK | AST, MIR, x64 | Kesir sabiti ve kurucu yoktur: `a = 1 / 3`, `a = 2.5`, `RATIONAL(1, 3)`, … |
| 335 | S-366 | G-KTIP-5 | EKSİK | tüm motorlar | Genel `CLONE`/`RETAIN`/`DROP` indirgemesi yoktur: dinamik yüklü bir manifest … |
| 336 | S-364 | G-KUT-18 | EKSİK | AST, MIR, x64 | `uxarchive` (libarchive 3.8.7): dosya ya da klasör adında Latin-1 dışındaki harfler (ğ, … |
| 337 | S-489 | G-KUT-23 | EKSİK | x64 (AST, MIR) | Pencere ve oyun kütüphanelerinin yazılmamış yüzeyleri vardır |
| 338 | S-487 | G-NESNE-27 | EKSİK | AST, MIR, x64, JS | Tabana kurucu çağrısı `SUPER(değer)` yoktur ve motorlar anlamlı bir ileti vermez: AST … |
| 339 | S-555 | G-NESNE-30 | EKSİK | CLASS ... EXTENDS (altı yol) | Çoklu kalıtım yoktur: `CLASS C EXTENDS A, B` altı yolda ayrıştırma hatasıyla reddedilir |
| 340 | S-556 | G-NESNE-31 | EKSİK | INTERFACE ... EXTENDS (altı yol) | Arayüz mirası yoktur: `INTERFACE IB EXTENDS IA` altı yolda ayrıştırma hatasıyla … |
| 341 | S-557 | G-NESNE-32 | EKSİK | iç içe sınıf (altı yol) | Bir sınıfın içinde başka sınıf tanımlamak (`CLASS Dis`, içinde `CLASS Ic … END CLASS`) … |
| 342 | S-558 | G-NESNE-33 | EKSİK | sınıf sabiti (altı yol) | Sınıf içinde `CONST` (`CLASS K`, içinde `CONST SINIR = 10`) altı yolda ayrıştırma … |
| 343 | S-559 | G-NESNE-34 | EKSİK | arayüzde gövdeli metot (altı yol) | Arayüzde varsayılan metot gövdesi yazılamaz: `INTERFACE IA` içinde `METHOD F() AS I32` ve … |
| 344 | S-560 | G-NESNE-35 | EKSİK | kurucu aşırı yükleme (altı yol) | Bir sınıfta birden çok `CONSTRUCTOR` tanımlanamaz: parametresiz `CONSTRUCTOR()` ile … |
| 345 | S-360 | G-NESNE-6 | EKSİK | üç motor | `ABSTRACT`, `FINAL`, `SEALED` ve `MIXIN` ayrıştırıcıda tanınmaz |
| 346 | S-369 | G-ONISLEM-10 | EKSİK | önişlemci | `%%EVAL AD = ifade` hesap yapmaz; yalnız sayı sabitini ya da bir makro değerini kopyalar … |
| 347 | S-370 | G-ONISLEM-11 | EKSİK | önişlemci | `%%NEXTMETA` ve `%%UNTILMETA` tanınır ama döngü kapatmaz; `%%FOREACH` için `"a,b"` … |
| 348 | S-368 | G-ONISLEM-19 | EKSİK | önişlemci | Makrolar dosya sınırını aşmaz: katılan dosyada tanımlanan makro katan dosyada, katan … |
| 349 | S-367 | G-ONISLEM-9 | EKSİK | önişlemci | Makro değeri ya da gövdesi içindeki başka makro adları açılmaz (tek geçiş): `%%DEFINE B …` |
| 350 | S-553 | G-TIP-29 | EKSİK | NAN, INF (altı yol) | `NAN` ve `INF` sabiti, `ISNAN()` ve `ISINF()` işlevi yoktur: `PRINT NAN` `type: unknown …` |
| 351 | S-554 | G-TIP-30 | EKSİK | NONE, NODE tip adları (altı yol) | `NONE` ve `NODE` tip adı olarak tanınmaz (`unknown type: NONE`, `unknown type: NODE`) ve … |
| 352 | S-564 | G-TIP-31 | EKSİK | NULL, NOTHING, NIL (altı yol) | `NULL`, `NOTHING` ve `NIL` boş değer sabitleri yüzeyde yoktur: `PRINT NULL`, `DIM p AS …` |
| 353 | S-386 | G-TIP-8 | EKSİK | üç motor + JS | Tasarımdaki 35 kanonik tipten `FUNCTION_PTR`, `DLL_HANDLE`, `FILE_HANDLE`, `JS_OBJECT`, … |
| 354 | S-387 | G-TIP-9 | EKSİK | AST, MIR, x64, JS | Geniş sayı ailesi yalnız AST'de kısmen çalışır: `F128("1.5")` AST'de "unsupported call … |
| 355 | S-389 | G-VERI-10 | EKSİK | üç motor + JS | Tasarım kılavuzundaki STRUCT yazımı (gövdede `ABI CDECL`, `PACK 8`, `ALIGN 8` satırları) … |
| 356 | S-550 | G-VERI-14 | EKSİK | DATA, READ, RESTORE (altı yol) | `DATA`, `READ` ve `RESTORE` deyimleri yoktur: `DATA 10, 20, 30`, `READ a` ve `RESTORE` … |
| 357 | S-551 | G-VERI-15 | EKSİK | sabit biçimleri (altı yol) | Python tarzı sabitler yoktur: dizi, `LIST`, `DICT`, `SET` ve demet değerini kaynakta … |
| 358 | S-552 | G-VERI-16 | EKSİK | TUPLE, DATAFRAME (altı yol) | `TUPLE` ve `DATAFRAME` çekirdek tipi yoktur: `DIM df AS DATAFRAME` `unknown type: …` |
| 359 | S-561 | G-YORDAM-10 | EKSİK | SUB, FUNCTION parametreleri (altı yol) | Varsayılan (isteğe bağlı) parametre değeri yoktur: `FUNCTION Topla(a AS I32, b AS I32 = …` |
| 360 | S-371 | G-HIZ-1 | YAVAŞ | AST, MIR | Yorumlayıcılar yerel koddan çok yavaştır ve birbirlerinden de farklıdır |
| 361 | S-372 | G-HIZ-2 | YAVAŞ | AST, MIR | Kütüphane (DLL) çağrıları yorumlayıcılarda pahalıdır: 100 çağrı AST'de ≈ 9 sn (çağrı … |
| 362 | S-373 | G-HIZ-3 | YAVAŞ | AST, MIR, x64 derleme | Kütüphane başlığı yükleme süresi işlev sayısıyla orantılı artar |
