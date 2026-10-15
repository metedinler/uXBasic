
# uXBasic Programlayıcının Cep Kitabı — Cilt 1

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Kaynak kabulü:** Bu genişletilmiş sürüm, `uxb(30.05_4).zip` son kaynak gerçekliği, `30.05_3` içindeki önceki gerçeklik notları, patch/readme/tools/kütüphane klasörleri ve önceki `pck*.md` çalışması üzerine kurulmuştur. Bu kitapta patch olarak görünen ADIM33, ADIM34, ADIM35 kararları da normal program özelliği kabul edilmiştir.

## Kullanım hakkı, sorumluluk ve destek

MIT Lisansı şunu anlatır: Bu kodu ve belgeyi kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi projenize katabilirsiniz. Lisans metnini ve telif bilgisini korumalısınız. Yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, yanlış DLL/API çağrısı, hatalı bilimsel sonuç, yanlış istatistik yorumu veya sistem bozulmasından yazar sorumlu değildir. Gerçek cihaz, para, sağlık, resmi işlem, üretim hattı ve güvenlik işlerinde önce küçük test, sonra yedek, sonra onaylı çalışma yapılmalıdır.

Bu çalışmadan fayda görürseniz gönüllü destek olarak 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince bu satıra yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`. Destek zorunlu değildir; amaç geliştirme emeğini sürdürebilmektir.

# Başlangıç, Dosyalar, Mimari ve Çalışma Disiplini

uXBasic'i öğrenmenin en doğru yolu, dili bir komut listesi değil bir üretim düzeni olarak görmektir. Kaynağı yazarsın, ön-işleyici gerekirse kaynak üretir, sözcükleyici parçalar, ayrıştırıcı ağaç kurar, anlam katmanı tipleri denetler, ara temsil oluşur, çalışma zamanı veya arka uç programı gerçek dünyaya bağlar.

## Dosya uzantıları ve çıktılar
|Uzantı|Anlam|Ne zaman kullanılır|
|---|---|---|
|.uxb|Ana uXBasic kaynak dosyası. Yeni program için ilk tercih.|Programın ana gövdesi|
|.bas|BASIC kökenli kaynak. Eski kod veya uyumluluk için.|Geçiş ve örnek|
|.uxmh|uXBasic modül/başlık dosyası. INCLUDE ile alınır.|Kütüphane başlığı|
|.uxbh|Başlık fikri için ayrılmış ad. Bu pakette `.uxmh` gerçek yoldur.|Uyumluluk notu|
|.json|AST, MIR, symbol, type, gate, manifest raporu.|Denetim çıktısı|
|.js|Tarayıcı veya Node tarafında çalışan JavaScript çıktısı.|Web hedefi|
|.wat|WebAssembly metin biçimi. wasm'a çevrilebilir.|Hızlı web hedefi|
|.wasm|Tarayıcıda çalışan ikili WebAssembly.|Çalıştırılabilir web çekirdeği|
|.asm/.nasm|Yerel makine koduna giden assembly çıktı.|Sistem programlama|
|.dll|Dış kütüphane. CALL/DECLARE ile çağrılır.|Genişleme|
|.csv/.parquet|Veri tablosu dosyaları.|Analiz ve veri bilimi|


## Komut satırı çıktıları

uXBasic komut satırı yalnız çalıştırmak için değildir; öğrenmek için de kullanılır. Bir genç programcı `--tokens-json-out`, `--ast-json-out`, `--mir-full-json-out` gibi seçeneklerle kendi yazdığı programın iç organlarını görebilir. Bu, derleyici yazmayı öğrenmenin kısa yoludur.
|No|Seçenek|Görev|Kısa örnek|
|---|---|---|---|
|1|--format-check|Çıktı veya denetim seçeneği|uxb ast main.uxb --format-check out/rapor.json|
|2|--help|Çıktı veya denetim seçeneği|uxb ast main.uxb --help out/rapor.json|
|3|--version|Çıktı veya denetim seçeneği|uxb ast main.uxb --version out/rapor.json|
|4|--target|Hedef çıktı seçer|uxb ast main.uxb --target out/rapor.json|
|5|--stop-after|Çıktı veya denetim seçeneği|uxb ast main.uxb --stop-after out/rapor.json|
|6|--json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --json-out out/rapor.json|
|7|--diag-format|Çıktı veya denetim seçeneği|uxb ast main.uxb --diag-format out/rapor.json|
|8|--error-limit|Hata/uyarı raporu üretir|uxb ast main.uxb --error-limit out/rapor.json|
|9|--emit-nasm|Hedef çıktı seçer|uxb ast main.uxb --emit-nasm out/rapor.json|
|10|--emit-js|Web/JS/WASM çıktısı|uxb ast main.uxb --emit-js out/rapor.json|
|11|--emit-wat|Web/JS/WASM çıktısı|uxb ast main.uxb --emit-wat out/rapor.json|
|12|--emit-wasm|Web/JS/WASM çıktısı|uxb ast main.uxb --emit-wasm out/rapor.json|
|13|--dump-ast|AST katmanı raporu|uxb ast main.uxb --dump-ast out/rapor.json|
|14|--dump-mir|MIR katmanı raporu|uxb ast main.uxb --dump-mir out/rapor.json|
|15|--strict|Çıktı veya denetim seçeneği|uxb ast main.uxb --strict out/rapor.json|
|16|--time-passes|Çıktı veya denetim seçeneği|uxb ast main.uxb --time-passes out/rapor.json|
|17|--debug-token-dump|Çıktı veya denetim seçeneği|uxb ast main.uxb --debug-token-dump out/rapor.json|
|18|--token-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --token-json-out out/rapor.json|
|19|--parse-only|Çıktı veya denetim seçeneği|uxb ast main.uxb --parse-only out/rapor.json|
|20|--parser-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --parser-json-out out/rapor.json|
|21|--ast-contract-check|AST katmanı raporu|uxb ast main.uxb --ast-contract-check out/rapor.json|
|22|--ast-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --ast-json-out out/rapor.json|
|23|--semantic|Çıktı veya denetim seçeneği|uxb ast main.uxb --semantic out/rapor.json|
|24|--semantic-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --semantic-json-out out/rapor.json|
|25|--hir-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --hir-json-out out/rapor.json|
|26|--mir-verify|MIR katmanı raporu|uxb ast main.uxb --mir-verify out/rapor.json|
|27|--codegen-source|Çıktı veya denetim seçeneği|uxb ast main.uxb --codegen-source out/rapor.json|
|28|--mir-full-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-full-json-out out/rapor.json|
|29|--execmem|Çıktı veya denetim seçeneği|uxb ast main.uxb --execmem out/rapor.json|
|30|--interpreter-backend|Çıktı veya denetim seçeneği|uxb ast main.uxb --interpreter-backend out/rapor.json|
|31|--run-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --run-report-json-out out/rapor.json|
|32|--emit-x64-nasm|Hedef çıktı seçer|uxb ast main.uxb --emit-x64-nasm out/rapor.json|
|33|--emit-x64-nasm-out|Hedef çıktı seçer|uxb ast main.uxb --emit-x64-nasm-out out/rapor.json|
|34|--x64-codegen-policy-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --x64-codegen-policy-json-out out/rapor.json|
|35|--emit-x86|Hedef çıktı seçer|uxb ast main.uxb --emit-x86 out/rapor.json|
|36|--backend-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --backend-report-json-out out/rapor.json|
|37|--js-out|Web/JS/WASM çıktısı|uxb ast main.uxb --js-out out/rapor.json|
|38|--wasm-wat-out|Web/JS/WASM çıktısı|uxb ast main.uxb --wasm-wat-out out/rapor.json|
|39|--build-x64|Çıktı veya denetim seçeneği|uxb ast main.uxb --build-x64 out/rapor.json|
|40|--build-x64-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --build-x64-out out/rapor.json|
|41|--validate-all|Çıktı veya denetim seçeneği|uxb ast main.uxb --validate-all out/rapor.json|
|42|--validate-all-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --validate-all-report-json-out out/rapor.json|
|43|--source-map|Çıktı veya denetim seçeneği|uxb ast main.uxb --source-map out/rapor.json|
|44|--source-map-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --source-map-json-out out/rapor.json|
|45|--doc|Çıktı veya denetim seçeneği|uxb ast main.uxb --doc out/rapor.json|
|46|--doc-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --doc-json-out out/rapor.json|
|47|--release-gate|Çıktı veya denetim seçeneği|uxb ast main.uxb --release-gate out/rapor.json|
|48|--release-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --release-json-out out/rapor.json|
|49|--tokens-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --tokens-json-out out/rapor.json|
|50|--lexer-diagnostics-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --lexer-diagnostics-json-out out/rapor.json|
|51|--preprocessed-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --preprocessed-out out/rapor.json|
|52|--parser-diagnostics-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --parser-diagnostics-json-out out/rapor.json|
|53|--symbol-table-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --symbol-table-json-out out/rapor.json|
|54|--type-table-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --type-table-json-out out/rapor.json|
|55|--layout-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --layout-report-json-out out/rapor.json|
|56|--hir-inventory-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --hir-inventory-json-out out/rapor.json|
|57|--semantic-diagnostics-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --semantic-diagnostics-json-out out/rapor.json|
|58|--mir-opt-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-opt-report-json-out out/rapor.json|
|59|--stdout-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --stdout-out out/rapor.json|
|60|--stderr-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --stderr-out out/rapor.json|
|61|--runtime-trace-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --runtime-trace-json-out out/rapor.json|
|62|--wat-out|Web/JS/WASM çıktısı|uxb ast main.uxb --wat-out out/rapor.json|
|63|--wasm-out|Web/JS/WASM çıktısı|uxb ast main.uxb --wasm-out out/rapor.json|
|64|--html-out|Web/JS/WASM çıktısı|uxb ast main.uxb --html-out out/rapor.json|
|65|--manifest-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --manifest-out out/rapor.json|
|66|--debug|Çıktı veya denetim seçeneği|uxb ast main.uxb --debug out/rapor.json|
|67|--ayikla|Çıktı veya denetim seçeneği|uxb ast main.uxb --ayikla out/rapor.json|
|68|--quiet|Çıktı veya denetim seçeneği|uxb ast main.uxb --quiet out/rapor.json|
|69|--sessiz|Çıktı veya denetim seçeneği|uxb ast main.uxb --sessiz out/rapor.json|
|70|--trace|Çıktı veya denetim seçeneği|uxb ast main.uxb --trace out/rapor.json|
|71|--log-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --log-out out/rapor.json|
|72|--debug-log-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --debug-log-out out/rapor.json|
|73|--message-lang|Çıktı veya denetim seçeneği|uxb ast main.uxb --message-lang out/rapor.json|
|74|--language|Çıktı veya denetim seçeneği|uxb ast main.uxb --language out/rapor.json|
|75|--session-live-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --session-live-json-out out/rapor.json|
|76|--layer-timing-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --layer-timing-json-out out/rapor.json|
|77|--hook-trace|Çıktı veya denetim seçeneği|uxb ast main.uxb --hook-trace out/rapor.json|
|78|--trace-json|Web/JS/WASM çıktısı|uxb ast main.uxb --trace-json out/rapor.json|
|79|--semantik|Çıktı veya denetim seçeneği|uxb ast main.uxb --semantik out/rapor.json|
|80|--interop|Çıktı veya denetim seçeneği|uxb ast main.uxb --interop out/rapor.json|
|81|--x64gen|Çıktı veya denetim seçeneği|uxb ast main.uxb --x64gen out/rapor.json|
|82|--target-x86|Hedef çıktı seçer|uxb ast main.uxb --target-x86 out/rapor.json|
|83|--codegen|Çıktı veya denetim seçeneği|uxb ast main.uxb --codegen out/rapor.json|
|84|--x64|Çıktı veya denetim seçeneği|uxb ast main.uxb --x64 out/rapor.json|
|85|--target-js|Web/JS/WASM çıktısı|uxb ast main.uxb --target-js out/rapor.json|
|86|--target-browser|Web/JS/WASM çıktısı|uxb ast main.uxb --target-browser out/rapor.json|
|87|--x64gen-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --x64gen-out out/rapor.json|
|88|--ir-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --ir-json-out out/rapor.json|
|89|--inventory-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --inventory-json-out out/rapor.json|
|90|--pipeline-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --pipeline-json-out out/rapor.json|
|91|--mir-pipeline-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-pipeline-json-out out/rapor.json|
|92|--mir-opcodes-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-opcodes-json-out out/rapor.json|
|93|--mir-surface-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-surface-json-out out/rapor.json|
|94|--mir-module-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-module-json-out out/rapor.json|
|95|--mir-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-json-out out/rapor.json|
|96|--ast-contract-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --ast-contract-json-out out/rapor.json|
|97|--ast-contract-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --ast-contract-report-json-out out/rapor.json|
|98|--ast-contract-matrix-out|AST katmanı raporu|uxb ast main.uxb --ast-contract-matrix-out out/rapor.json|
|99|--artifact-report-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --artifact-report-json-out out/rapor.json|
|100|--mir-verify-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --mir-verify-json-out out/rapor.json|
|101|--enable-mir-x64-experimental|MIR katmanı raporu|uxb ast main.uxb --enable-mir-x64-experimental out/rapor.json|
|102|--enable-extfp-runtime|Çıktı veya denetim seçeneği|uxb ast main.uxb --enable-extfp-runtime out/rapor.json|
|103|--extfp-strict|Çıktı veya denetim seçeneği|uxb ast main.uxb --extfp-strict out/rapor.json|
|104|--extfp-diagnostics|Hata/uyarı raporu üretir|uxb ast main.uxb --extfp-diagnostics out/rapor.json|
|105|--extfp-runtime-dir|Çıktı veya denetim seçeneği|uxb ast main.uxb --extfp-runtime-dir out/rapor.json|
|106|--extfp-policy-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --extfp-policy-json-out out/rapor.json|
|107|--console-mode|Çıktı veya denetim seçeneği|uxb ast main.uxb --console-mode out/rapor.json|
|108|--program-output-out|Çıktı veya denetim seçeneği|uxb ast main.uxb --program-output-out out/rapor.json|
|109|--program-output-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --program-output-json-out out/rapor.json|
|110|--final-screen-json-out|Web/JS/WASM çıktısı|uxb ast main.uxb --final-screen-json-out out/rapor.json|
|111|--target-wat|Web/JS/WASM çıktısı|uxb ast main.uxb --target-wat out/rapor.json|
|112|--target-wasm|Web/JS/WASM çıktısı|uxb ast main.uxb --target-wasm out/rapor.json|
|113|--emit-browser|Web/JS/WASM çıktısı|uxb ast main.uxb --emit-browser out/rapor.json|
|114|--validate-all-fail-fast|AST katmanı raporu|uxb ast main.uxb --validate-all-fail-fast out/rapor.json|
|115|--extract-src|Çıktı veya denetim seçeneği|uxb ast main.uxb --extract-src out/rapor.json|
|116|--adim25-27-close-gate|Çıktı veya denetim seçeneği|uxb ast main.uxb --adim25-27-close-gate out/rapor.json|
|117|--adim25-26-27-close-gate|Çıktı veya denetim seçeneği|uxb ast main.uxb --adim25-26-27-close-gate out/rapor.json|
|118|--wat2wasm|Web/JS/WASM çıktısı|uxb ast main.uxb --wat2wasm out/rapor.json|
|119|--source|Çıktı veya denetim seçeneği|uxb ast main.uxb --source out/rapor.json|


## Mimari katmanlar
|No|Katman|Görev|Akılda kalacak cümle|
|---|---|---|---|
|1|Ön-işleyici|`%%` ile başlayan komutları, makroları, hedef dosya bloklarını işler.|Kaynak daha lexer görmeden düzenlenir.|
|2|Sözcükleyici [kelime ayırıcı] (lexer)|Anahtar sözcükleri, metinleri, sayıları, işaretleri çıkarır.|`PRINT` artık düz metin değil token olur.|
|3|Ayrıştırıcı [cümle kurucu] (parser)|Tokenları AST düğümlerine çevirir.|`IF` artık `IF_STMT` olur.|
|4|AST|Programın ağaç hali.|Her komutun çocukları, satırı, konumu tutulur.|
|5|Anlam katmanı|Tip ve kapsam denetimi yapar.|`DIM a AS I32` sonrası `a` bilinir.|
|6|HIR/MIR|Programı hedeflerden bağımsız ara dile indirir.|JS, x64 ve yorumlayıcı aynı özü kullanır.|
|7|Çalışma zamanı|Dosya, bellek, DLL, ekran, runtime servisleri.|`PRINT`, `OPEN`, `CALL(DLL)` burada hayata değer.|
|8|Arka uç [kod üretici] (backend)|JS, WAT, NASM, browser çıktısı üretir.|Program başka dünyalara çevrilir.|
|9|Test kapıları|Eksik, sahte veya bozuk çıktı var mı bakar.|Placeholder yasak; gerçek çıktı gerekir.|
### Katman örneği: Ön-işleyici ile tek kaynaktan iki hedef
```uxbasic
%%SET APP = "SahaRaporu"
%%PROFILE WEB_DEBUG
%%HTML_BEGIN "index.html" BODY
<h1>{{APP}}</h1>
%%HTML_END
PRINT "Konsol raporu da uretildi"
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: Lexer katmanı için küçük kaynak
```uxbasic
DIM adet AS I32
adet = 5
PRINT "Adet="; adet
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: Parser katmanında karar ve döngü
```uxbasic
DIM toplam AS I32
FOR i = 1 TO 5
    toplam = toplam + i
NEXT i
IF toplam > 10 THEN PRINT "gecer" ELSE PRINT "kalir" END IF
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: Anlam katmanı için tipli yordam
```uxbasic
FUNCTION Kare(x AS F64) AS F64
    RETURN x * x
END FUNCTION
DIM alan AS F64
alan = Kare(12.5)
PRINT alan
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: MIR mantığı için basit işlem zinciri
```uxbasic
DIM a AS I32
DIM b AS I32
a = 7
b = a * 3 + 1
PRINT b
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: Runtime ile dosya çıktısı
```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Gunluk sonuc"
PRINT #1, 42
CLOSE #1
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.

### Katman örneği: Backend için tarayıcı hedefi
```uxbasic
%%TARGET BROWSER
%%JS_LINE "console.log('uXBasic JS cikti calisti')"
PRINT "Bu kaynak JS ve HTML cikti uretebilir"
```
Bu örnekte en az beş farklı dil öğesi birlikte çalışır: değişken, komut, ifade, çıktı ve hedef/denetim fikri. Öğrenme hilesi, örneği önce çalıştırmak, sonra bir satırı bozup hatanın hangi katmandan geldiğini izlemektir.


## Hook ve wrapper düzeni

Kanca [akışa takılan izleme noktası] (hook), ana işi bozmadan katmanın içine bakmak için kullanılır. `compiler/hooks` altında AST, HIR, MIR, runtime ve codegen için ayrı hook dosyaları vardır. Varsayılan hooklar kapalıdır; bu iyi bir disiplindir. Çünkü derleyici önce sessiz ve temiz çalışmalı, izleme yalnız gerektiğinde açılmalıdır.

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

### Hook kullanma tekniği

Bir hata bütün programı bozuyorsa hook açıp her satıra `PRINT` koymak yerine katman giriş/çıkışını işaretlersin. AST katmanı doğruysa parser sağlamdır. MIR bozuksa anlam veya indirme katmanına bakarsın. Runtime bozuksa arka uç değil, çalışma zamanı sorgulanır.

```uxbasic
' Derleyici içi düşünce örneği
UXB_AST_HOOK_STAGE("ParseProgram basladi")
UXB_MIR_HOOK_STAGE("PRINT_STMT MIR'e indiriliyor")
UXB_CODEGEN_HOOK_STAGE("JS backend program.js yaziyor")
```

## Araçlar ve test kapıları

Araç klasörleri derleyicinin vicdanıdır. Test runner çıktı uydurmaz; komutu çalıştırır, gerçek dosya var mı bakar. Genç programcı için kural: bir özellik yazdıysan, onu ölçen küçük bir araç da yaz.
|No|Klasör|Araç|Görev|
|---|---|---|---|
|1|tools/audit|uxb_ast_contract_audit.py|denetim/test/kurulum aracı|
|2|tools/audit|uxb_ast_contract_build_matrix.py|denetim/test/kurulum aracı|
|3|tools/audit|uxb_ast_contract_collect_contract_nodes.py|denetim/test/kurulum aracı|
|4|tools/audit|uxb_ast_contract_collect_handlers.py|denetim/test/kurulum aracı|
|5|tools/audit|uxb_ast_contract_collect_parser_nodes.py|denetim/test/kurulum aracı|
|6|tools/audit|uxb_ast_contract_fake_status_scan.py|denetim/test/kurulum aracı|
|7|tools/audit|uxb_ast_contract_gate.py|denetim/test/kurulum aracı|
|8|tools/audit|uxb_build_keyword_layer_matrix.py|denetim/test/kurulum aracı|
|9|tools/audit|uxb_collect_ast_surface.py|denetim/test/kurulum aracı|
|10|tools/audit|uxb_collect_layer_handlers.py|denetim/test/kurulum aracı|
|11|tools/audit|uxb_collect_lexer_surface.py|denetim/test/kurulum aracı|
|12|tools/audit|uxb_collect_parser_surface.py|denetim/test/kurulum aracı|
|13|tools/audit|uxb_keyword_layer_gate.py|denetim/test/kurulum aracı|
|14|tools/audit|uxb_no_fake_status_gate.py|denetim/test/kurulum aracı|
|15|tools/audit|uxb_step1_surface_core.py|denetim/test/kurulum aracı|
|16|tools/control|uxb_10step_chain_runner.py|denetim/test/kurulum aracı|
|17|tools/control|uxb_adim2_lexer_gate.py|denetim/test/kurulum aracı|
|18|tools/control|uxb_adim32b_strict_runner.py|denetim/test/kurulum aracı|
|19|tools/control|uxb_adim3_parser_gate.py|denetim/test/kurulum aracı|
|20|tools/control|uxb_copilot_task_boundary_gate.py|denetim/test/kurulum aracı|
|21|tools/control|uxb_expected_actual_compare.py|denetim/test/kurulum aracı|
|22|tools/control|uxb_layer_output_contract_gate.py|denetim/test/kurulum aracı|
|23|tools/control|uxb_run_layer_tests.py|denetim/test/kurulum aracı|
|24|tools/control|uxb_surface_lifecycle_matrix.py|denetim/test/kurulum aracı|
|25|tools/control|uxb_surface_route_matrix_contract_gate.py|denetim/test/kurulum aracı|
|26|tools/control|uxb_surface_test_generator.py|denetim/test/kurulum aracı|
|27|compiler/scripts|audit_uxb_library_bundle.bat|denetim/test/kurulum aracı|
|28|compiler/scripts|build_imported_library_runtimes.bat|denetim/test/kurulum aracı|
|29|compiler/scripts|build_uxb_main_64.bat|denetim/test/kurulum aracı|
|30|compiler/scripts|create_step7_release_candidate.bat|denetim/test/kurulum aracı|
|31|compiler/scripts|create_wasm_publish_release.bat|denetim/test/kurulum aracı|
|32|compiler/scripts|import_uxb_library_bundle.bat|denetim/test/kurulum aracı|
|33|compiler/scripts|open_latest_reports.bat|denetim/test/kurulum aracı|
|34|compiler/scripts|organize_artifacts.ps1|denetim/test/kurulum aracı|
|35|compiler/scripts|run_adim04_ast_contract_gate.ps1|denetim/test/kurulum aracı|
|36|compiler/scripts|run_adim07_lexer_preprocessor.ps1|denetim/test/kurulum aracı|
|37|compiler/scripts|run_adim08_parser_gate.ps1|denetim/test/kurulum aracı|
|38|compiler/scripts|run_adim10_semantic_step5_gate.ps1|denetim/test/kurulum aracı|
|39|compiler/scripts|run_adim11_mir_gate.ps1|denetim/test/kurulum aracı|
|40|compiler/scripts|run_adim12_runtime_gate.ps1|denetim/test/kurulum aracı|
|41|compiler/scripts|run_adim13_backend_gate.ps1|denetim/test/kurulum aracı|
|42|compiler/scripts|run_adim14_backend_web_gate.ps1|denetim/test/kurulum aracı|
|43|compiler/scripts|run_adim15_ffi_library_import_gate.ps1|denetim/test/kurulum aracı|
|44|compiler/scripts|run_adim16_diagnostics_source_mapping_gate.ps1|denetim/test/kurulum aracı|
|45|compiler/scripts|run_adim17_cli_gate.ps1|denetim/test/kurulum aracı|
|46|compiler/scripts|run_adim18_test_suite_release_gate.ps1|denetim/test/kurulum aracı|
|47|compiler/scripts|run_adim19_20_21_contract_gates.ps1|denetim/test/kurulum aracı|
|48|compiler/scripts|run_adim19_surface_route_matrix_contract_gate.ps1|denetim/test/kurulum aracı|
|49|compiler/scripts|run_adim20_layer_output_contract_gate.ps1|denetim/test/kurulum aracı|
|50|compiler/scripts|run_adim21_copilot_task_boundary_gate.ps1|denetim/test/kurulum aracı|
|51|compiler/scripts|run_adim22_full_layer_expected_suite.ps1|denetim/test/kurulum aracı|
|52|compiler/scripts|run_adim23_lifecycle_web_output_binding_gate.ps1|denetim/test/kurulum aracı|
|53|compiler/scripts|run_adim24_js_source_emit_fix_gate.ps1|denetim/test/kurulum aracı|
|54|compiler/scripts|run_adim25_26_27_close_gates.ps1|denetim/test/kurulum aracı|
|55|compiler/scripts|run_adim28_build_test_pipeline.ps1|denetim/test/kurulum aracı|
|56|compiler/scripts|run_adim28_runtime_dll_doctor.ps1|denetim/test/kurulum aracı|
|57|compiler/scripts|run_adim2_differential_gate.bat|denetim/test/kurulum aracı|
|58|compiler/scripts|run_adim2_toolchain_gate.bat|denetim/test/kurulum aracı|
|59|compiler/scripts|run_adim30_10step_chain_suite.ps1|denetim/test/kurulum aracı|
|60|compiler/scripts|run_adim31_after_patch_check.ps1|denetim/test/kurulum aracı|
|61|compiler/scripts|run_adim31b_canonical_check.ps1|denetim/test/kurulum aracı|
|62|compiler/scripts|run_adim32_force_rebuild_adim30.ps1|denetim/test/kurulum aracı|
|63|compiler/scripts|run_adim32b_strict_pass.ps1|denetim/test/kurulum aracı|
|64|compiler/scripts|run_browser_from_source.bat|denetim/test/kurulum aracı|
|65|compiler/scripts|run_browser_hybrid_pro_smoke.bat|denetim/test/kurulum aracı|
|66|compiler/scripts|run_browser_hybrid_smoke.bat|denetim/test/kurulum aracı|
|67|compiler/scripts|run_browser_js_smoke.bat|denetim/test/kurulum aracı|
|68|compiler/scripts|run_browser_json_build.bat|denetim/test/kurulum aracı|
|69|compiler/scripts|run_browser_surface_contract.bat|denetim/test/kurulum aracı|
|70|compiler/scripts|run_browser_toolchain_install.bat|denetim/test/kurulum aracı|
|71|compiler/scripts|run_emit_js_transpiler.bat|denetim/test/kurulum aracı|
|72|compiler/scripts|run_emit_mir_x64_asm.bat|denetim/test/kurulum aracı|
|73|compiler/scripts|run_emit_wasm_backend.bat|denetim/test/kurulum aracı|
|74|compiler/scripts|run_emit_x64_ast_asm.bat|denetim/test/kurulum aracı|
|75|compiler/scripts|run_emit_x86_codegen_artifacts.bat|denetim/test/kurulum aracı|
|76|compiler/scripts|run_extfp_codegen_smoke.bat|denetim/test/kurulum aracı|
|77|compiler/scripts|run_full_fp_runtime_smoke.bat|denetim/test/kurulum aracı|
|78|compiler/scripts|run_imported_library_smokes.bat|denetim/test/kurulum aracı|
|79|compiler/scripts|run_keyword_layer_matrix.bat|denetim/test/kurulum aracı|
|80|compiler/scripts|run_language_surface_full_matrix.bat|denetim/test/kurulum aracı|
|81|compiler/scripts|run_layer_json.ps1|denetim/test/kurulum aracı|
|82|compiler/scripts|run_localhost_bridge.bat|denetim/test/kurulum aracı|
|83|compiler/scripts|run_mir_x64_completion_smoke.bat|denetim/test/kurulum aracı|
|84|compiler/scripts|run_mir_x64_prompt3_smoke.bat|denetim/test/kurulum aracı|
|85|compiler/scripts|run_mir_x64_surface_audit.bat|denetim/test/kurulum aracı|
|86|compiler/scripts|run_prompt0_baseline.bat|denetim/test/kurulum aracı|
|87|compiler/scripts|run_release_gate.bat|denetim/test/kurulum aracı|
|88|compiler/scripts|run_stage4_apply_full_safe.bat|denetim/test/kurulum aracı|
|89|compiler/scripts|run_stage4_apply_move_tests.bat|denetim/test/kurulum aracı|
|90|compiler/scripts|run_stage4_audit.bat|denetim/test/kurulum aracı|
|91|compiler/scripts|run_step1_surface_gate.bat|denetim/test/kurulum aracı|
|92|compiler/scripts|run_step1_surface_matrix.bat|denetim/test/kurulum aracı|
|93|compiler/scripts|run_step2_ast_contract_gate.bat|denetim/test/kurulum aracı|
|94|compiler/scripts|run_step2_ast_contract_matrix.bat|denetim/test/kurulum aracı|
|95|compiler/scripts|run_step2_ast_json_smoke.bat|denetim/test/kurulum aracı|
|96|compiler/scripts|run_step2_mir_lowering_cli_audit.bat|denetim/test/kurulum aracı|
|97|compiler/scripts|run_step3_all.bat|denetim/test/kurulum aracı|
|98|compiler/scripts|run_step3_project_runner.bat|denetim/test/kurulum aracı|
|99|compiler/scripts|run_step3_semantic_type_layout_gate.bat|denetim/test/kurulum aracı|
|100|compiler/scripts|run_step4_type_class_ffi_audit.bat|denetim/test/kurulum aracı|
|101|compiler/scripts|run_step5_final_close.bat|denetim/test/kurulum aracı|
|102|compiler/scripts|run_step5_fp_completion_audit.bat|denetim/test/kurulum aracı|
|103|compiler/scripts|run_step6_release_gate.bat|denetim/test/kurulum aracı|
|104|compiler/scripts|run_step7_final_gate.bat|denetim/test/kurulum aracı|
|105|compiler/scripts|run_surface_suite.bat|denetim/test/kurulum aracı|
|106|compiler/scripts|run_uxaimath_smoke.bat|denetim/test/kurulum aracı|
|107|compiler/scripts|run_uxb_ast_alias_overlay.bat|denetim/test/kurulum aracı|
|108|compiler/scripts|run_uxb_mir_alias_overlay.bat|denetim/test/kurulum aracı|
|109|compiler/scripts|run_uxcollections_smoke.bat|denetim/test/kurulum aracı|
|110|compiler/scripts|run_uxdataframe_smoke.bat|denetim/test/kurulum aracı|
|111|compiler/scripts|run_uxdataset_smoke.bat|denetim/test/kurulum aracı|
|112|compiler/scripts|run_uxgraph_smoke.bat|denetim/test/kurulum aracı|
|113|compiler/scripts|run_uxllama_smoke.bat|denetim/test/kurulum aracı|
|114|compiler/scripts|run_uxmath_smoke.bat|denetim/test/kurulum aracı|
|115|compiler/scripts|run_uxmathcore_smoke.bat|denetim/test/kurulum aracı|
|116|compiler/scripts|run_uxmatrix_smoke.bat|denetim/test/kurulum aracı|
|117|compiler/scripts|run_uxnn2_smoke.bat|denetim/test/kurulum aracı|
|118|compiler/scripts|run_uxnn3_smoke.bat|denetim/test/kurulum aracı|
|119|compiler/scripts|run_uxnn_smoke.bat|denetim/test/kurulum aracı|
|120|compiler/scripts|run_uxonnx2_smoke.bat|denetim/test/kurulum aracı|
|121|compiler/scripts|run_uxonnx_smoke.bat|denetim/test/kurulum aracı|
|122|compiler/scripts|run_uxstats2_smoke.bat|denetim/test/kurulum aracı|
|123|compiler/scripts|run_uxstats_smoke.bat|denetim/test/kurulum aracı|
|124|compiler/scripts|run_uxtensor_smoke.bat|denetim/test/kurulum aracı|
|125|compiler/scripts|run_wasm_smoke.bat|denetim/test/kurulum aracı|
|126|compiler/scripts|run_webgpu_smoke.bat|denetim/test/kurulum aracı|
|127|compiler/scripts|run_workspace_clean_guard.bat|denetim/test/kurulum aracı|
|128|compiler/scripts|uxb_switchboard.ps1|denetim/test/kurulum aracı|
|129|compiler/scripts|workspace_root_helpers.ps1|denetim/test/kurulum aracı|
|130|tools/release|uxb_release_gate.py|denetim/test/kurulum aracı|
