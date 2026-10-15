# uXBasic Programlayıcının Cep Kitabı

**Tek kitap sürümü:** `pck_tek_kitap.md`  
**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans durumu:** MIT Lisansı niyetiyle hazırlanmıştır.  
**Kaynak kabulü:** Bu dosya, `uxbasic kitap.zip` içindeki `pck*.md` ve `pck1<harf>.md` ailesinin bütün sürümlerini, ayrıca `uxb(30.05_4).zip` içindeki kaynak, araç, patch, readme, hook, wrapper ve kütüphane kayıtlarını esas alarak tek akışlı kitap hâline getirir.  

## Ön söz

uXBasic, eski BASIC rahatlığını modern derleyici fikriyle birleştirmeyi amaçlayan bir programlama dili ve derleyici ailesidir. Bu kitap komut ezberletmek için değil, genç programcının kafasında bir programın nasıl düşündüğünü canlandırmak için yazılmıştır. Bir komutun yalnız adını bilmek yetmez; o komutun ne zaman yazıldığını, programı hangi yola soktuğunu, hangi dosyayı ürettiğini, hangi dış kütüphaneye kapı açtığını ve hata olduğunda nasıl davranması gerektiğini de bilmek gerekir. Bu yüzden burada tablolar kısa ve temiz tutuldu, uzun açıklamalar ise sınıf başlıklarının altında örneklerle anlatıldı.

Bu metinde İngilizce bir terim gerektiğinde önce Türkçesi yazılır, sonra köşeli parantez içinde kısa açıklaması ve parantez içinde İngilizcesi verilir. Örneğin ara gösterim [komutların derleyici içindeki orta hâli] (MIR) biçiminde geçer. Amaç, gencin daha ilk okumada terimden korkmamasıdır. Dili öğrenirken şunu unutma: önce çalışan küçük program yazılır, sonra program büyütülür, sonra test edilir, sonra dış dünyaya açılır. Büyük sistemi tek hamlede kurmaya çalışan kişi çoğu zaman kendi kodunun altında kalır.

## Kullanım hakkı ve sorumluluk

Bu kitap ve örnekler eğitim, araştırma ve kişisel geliştirme amacıyla kullanılabilir. Lisans niyeti MIT Lisansı’dır: kaynak göstererek, değiştirerek, çoğaltarak ve kendi projende kullanarak çalışabilirsin. Buna karşılık bu metnin veya örnek programların kullanımından doğabilecek veri kaybı, yanlış sonuç, üretim zararı, güvenlik açığı, üçüncü taraf hizmet ücretleri, yapay zeka servis maliyeti veya donanım/yazılım bozulması kullanıcının kendi sorumluluğundadır. Dış kütüphane, sistem DLL’i, ağ bağlantısı, dosya silme, yapay zeka servisi ve deneysel derleyici hedefleri dikkatle kullanılmalıdır.

Bir sorun, katkı veya teşekkür için iletişim adresi: **zmetedinler@gmail.com**. Kitap sana fayda sağladıysa küçük destek göndermek istersen 50 TL, uluslararası kullanım veya proje desteği için 25 ABD doları tutarında katkı memnuniyetle karşılanır. IBAN veya ödeme bilgisi dağıtım dosyasında ayrıca belirtilmelidir; bu metinde örnek olarak boş bırakılmıştır.

## Bu tek kitap nasıl birleştirildi?

Eski ciltlerde aynı bilginin farklı yazımları vardı. Bazı tablolarda son sütunlarda aynı cümle tekrar ediyordu. Bu tek sürümde o cümleler kaldırıldı; yerine her satırda sözdizimi ve kısa görev bırakıldı. Uzun açıklamalar komut sınıflarının altına taşındı. Aynı paragrafın birden çok sürümü varsa en anlamlı olanı ana akışa alındı, eksik kalan bilgi ise ilgili bölümün içine eritildi. Böylece kitap beş ayrı not dosyası gibi değil, tek akışlı bir cep kitabı gibi okunur.

## İçindekiler

1. Başlangıç, dosyalar, lisans ve mimari  
2. Komutlar, ön-işleyici, veri tipleri, işleçler ve yerel fonksiyonlar  
3. Değişkenler, veri yapıları, nesne düzeni, hook, wrapper ve eşzamanlılık  
4. Kütüphaneler, fonksiyonlar, dış çalışma zamanı ve hata/test alışkanlığı  
5. Tarayıcı, JavaScript, WAT/WASM, REST, Flask, Llama, ChatGPT, Gemini ve bilimsel analiz  
6. Kaynaklardan eritilen ek notlar ve son içindekiler


## uXBasic kaynak ağacından gelen çalışma kararları

`uxb(30.05_4).zip` içinde derleyici yalnız bir dosyadan ibaret değildir. `src` klasörü dilin çalışan gövdesidir; `compiler/wrappers` sarmalayıcı [ana derleyiciyi güvenli girişten çağıran küçük kapı] (wrapper) dosyalarını taşır; `tools/control` test kapılarını, `tools/audit` yüzey ve sözleşme denetimlerini, `libs` ise kütüphane kayıtlarını taşır. Patch klasörlerinde görülen kararlar bu kitapta yama gibi değil, dilin normalleşmiş özelliği gibi anlatılır. Özellikle geniş ön-işleyici, büyük sayı ailesi, tarayıcı çıktısı, çalışma zamanı DLL doktoru, ADIM22 katman çıktı sözleşmesi ve ADIM25-27 kapanış kapıları bu yaklaşımın parçasıdır.

### Görülen patch aileleri

1. `Patch_Zips`
2. `UXB_10_ADIM5_FREEBASIC_PATCH`
3. `UXB_11_ADIM6_MIR_FREEBASIC_PATCH`
4. `UXB_12_ADIM7_INTERPRETER_RUNTIME_FREEBASIC_PATCH`
5. `UXB_13_ADIM8_BACKEND_X64_X86_FREEBASIC_PATCH`
6. `UXB_14_ADIM9_BACKEND_JS_WASM_BROWSER_FREEBASIC_PATCH (1)`
7. `UXB_15_ADIM10_FFI_LIBRARY_IMPORT_INCLUDE_FREEBASIC_PATCH`
8. `UXB_16_ADIM11_DIAGNOSTICS_SOURCE_MAPPING_JSON_FREEBASIC_PATCH`
9. `UXB_17_ADIM12_CLI_3_HARF_KOMUT_ZINCIRI_FREEBASIC_PATCH`
10. `UXB_18_ADIM13_TEST_SUITE_GATES_RELEASE_PATCH`
11. `UXB_19_20_21_CONTRACT_GATES_PATCH`
12. `UXB_22_FULL_LAYER_EXPECTED_TEST_SUITE_PATCH`
13. `UXB_23_LIFECYCLE_WEB_OUTPUT_BINDING_PATCH`
14. `UXB_24_JS_SOURCE_EMIT_FIX_PATCH`
15. `UXB_25_26_27_AST_MIR_WEB_CLI_CLOSE_PATCH`
16. `UXB_28_DERLEME_TEST_DLL_HAZIRLIK_PATCH`
17. `UXB_29_ALL_RUNTIME_EXT_DLL_DOCTOR_BUILD_PATCH`
18. `UXB_30_10STEP_CHAIN_TEST_SUITE_PATCH`
19. `UXB_31B_CANONICAL_SYNTAX_LAYER_PATCH`
20. `UXB_31_ADIM30_FAIL_FAMILY_FIXES_PATCH`
21. `UXB_33_PRELEXER_META_ARTIFACT_ENGINE_PATCH`
22. `UXB_34_EXTENDED_PREPROCESSOR_META_COMMANDS_PATCH`
23. `UXB_35_BIG_NUMBER_CANONICAL_PATCH`
24. `UXB_ADIM07_PATCH_FILES`
25. `UXB_ADIM08_PARSER_PATCH`
26. `UXB_ADIM09_AST_CONTRACT_PATCH (1)`

### Kütüphane kayıt özeti

Aşağıdaki tablo kaynak paketindeki `libs/uxb_library_registry.csv` dosyasından alınan kütüphane ailesini gösterir. Burada hepsinin çalıştığı varsayılır; kitap bu varsayımla komut ve fonksiyon örnekleri kurar.

```csv
zip,modules,runtime_ext,tests,doc_count,script_count,bytes,sha256
UXBc_uxaimath_module(1).zip,uxaimath;uxtensor,uxaimath;uxtensor,uxaimath;uxtensor,10,2,24019,82bc784d5ee09308bb9979377fe64cea8f865f9332dd1830bab860a0ea59971e
UXBc_uxcollections_glib_core(1).zip,uxcollections,uxcollections,uxcollections,2,1,9836,5e791fc0b144e72d12308c9639c1f20c86dcc8bf2e0435a89a7341bfffd31d50
UXBc_uxdataframe_duckdb_module(1).zip,uxdataframe,uxdataframe,uxdataframe,5,1,15536,50665398ebaa525a85dc1ebcdee9f8025b535791287055780bbe5a6c18a19d4a
UXBc_uxdataset_module(1).zip,uxdataset,uxdataset,uxdataset,5,1,11344,83b56dd7510a14ef3a10f0bbfe664030f6d48d21b0f1e85ed70075ee73f7df2b
UXBc_uxgraph_igraph_module(1).zip,uxgraph,uxgraph,uxgraph,3,1,10665,cd24b73ee905a8c641d01b90cfd2e99fb55b5ded2ea435b17792e92cde519f82
UXBc_uxllama_cpu_text_module(1).zip,uxllama;uxllamax,uxllama,uxllama,6,1,16283,0b6700fbdb5519f66ca6af058257237a86677d2fbefa61f71dc2a1e6e6bbcf45
UXBc_uxmath_ai_prompt1_math_core(1).zip,uxmath,uxmath,uxmath,3,1,12808,acdf55c43faaec74512294257b7da8ca6745188c35eb80ae255d3d7222a5db70
UXBc_uxmathcore_1A_corrected(1).zip,uxmath;uxmathcore,uxmathcore,uxmathcore,2,1,13293,0e79203c517c8ace35cf6bef995b6e64fdda5bff314eb4c44aa9bc074b5ea1f0
UXBc_uxmatrix_openblas_module(1).zip,uxmatrix,uxmatrix,uxmatrix,3,1,13335,bac2027b588318a9e9c8e6a2c5751da3b7fbe32408c100b69474fc100b2e5c4a
UXBc_uxnn2_training_module(1).zip,uxnn2,uxnn2,uxnn2,4,1,10835,f018c4420e11d993a4965e244e968df976219758644056b541ca4a747320b17d
UXBc_uxnn3_dataset_training_module(1).zip,uxnn3,uxnn3,uxnn3,5,1,14760,148363dd8246b2b7e7b9eff1c5abbde989fa89e90ca1470b1b8dd58e73a33afc
UXBc_uxnn_module(1).zip,uxaimath;uxnn;uxtensor,uxaimath;uxnn;uxtensor,uxaimath;uxnn;uxtensor,15,3,35409,24a06ded2f8ec435b0c2c90a63b1e1cc5a7eb2728e9068e0b4650c570fff54ef
UXBc_uxonnx2_advanced_runtime_module(1).zip,uxonnx2,uxonnx2,uxonnx2,5,1,15260,5f66963fa2490cc3d762bafe075129578ef1df8b2c20ca667222eced6fb07c00
UXBc_uxonnx_module(1).zip,uxonnx,uxonnx,uxonnx,5,1,12868,3c84ce57b863d6935c3067588cb47b6dc288b0fd31c7a58d8c57a4663afe9abb
UXBc_uxstats2_advanced_module(1).zip,uxstats,uxstats2,uxstats2,2,1,12663,38d28b99da2830067b451358726a05adb394e9af7a0e17ea255a3bf302c494e1
UXBc_uxstats_standard_module(1).zip,uxstats,uxstats,uxstats,2,1,12119,631f99fac377a4f7d03d1fc44cb8291ea547e819a8bffc8b6a7cd1dbbe7f4990
UXBc_uxtensor_openblas_module(1).zip,uxtensor,uxtensor,uxtensor,5,1,14686,fc3e3c070b1ea222c367784fc69352be3bc3f92eabd4a5ec4c8782823b195f7b
```


# Bölüm 1 — Başlangıç, Dosyalar ve Mimari


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

### Bölüm 1 kaynaklarından eklenen kısa notlar

# Başlangıç, Kullanım Hakkı, Dosyalar ve Mimari

## Ön söz

Bu kitap uXBasic'i yalnız komut listesi olarak değil, çalışan bir düşünme aracı olarak anlatır. Genç programcı için en önemli bilgi şudur: program, bilgisayara verilen emirlerin kuru dizisi değildir; veri toplama, karar verme, dış dünya ile konuşma ve sonucu ölçme düzenidir. uXBasic bu düzeni BASIC tadında okunur bir yüzeyle, C/C++/ASM ve DLL gücüyle, tarayıcı ve WebAssembly çıktısıyla birleştirmek için tasarlanmıştır. Burada geçen teknik sözcüklerde önce Türkçe ad verilir, gerekirse köşeli parantez içinde kısa açıklama ve parantez içinde İngilizce karşılığı yazılır. Örneğin kanca [derleyicinin bir aşamasına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [dış fonksiyonu uXBasic'e düzenli çağrı gibi gösteren ince katman] (wrapper) demektir.

Bu sürüm, `uxb(30.05_4).zip` içindeki son gerçek kaynak ağacı, patch/readme kararları, çalışma zamanı kütüphaneleri, araçlar, kanca ve sarmalayıcı klasörleri esas alınarak genişletildi. Kitapta bazı yama adları geçse bile bunlar artık “sonradan eklenecek parçalar” gibi değil, uXBasic'in normal programlama yüzeyi ve araç düzeni gibi anlatılır. Büyük sayı ailesi olan `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` ve `BIGINIT` bu nedenle normal dil/kütüphane yetenekleri olarak ele alınır. Her şeyin çalıştığı varsayılmıştır; bu kitap kullanıcının hayal gücünü tetiklemek için örnekleri gerçek kullanım senaryolarına bağlar.

## Kullanım hakkı, lisans ve sorumluluk

Bu kitap ve örnekler MIT lisansı anlayışıyla kullanılabilir. MIT lisansı; kodu inceleme, değiştirme, dağıtma, özel veya ticari projede kullanma özgürlüğü verir. Buna karşılık yazar, bu kitabın kullanımından doğabilecek veri kaybı, yanlış hesap, gelir kaybı, donanım sorunu, üçüncü taraf API ücretleri, sistem çökmesi veya hukuki sonuçlardan sorumlu değildir. Özellikle DLL, dosya silme, bellek yazma, ağ ve yapay zeka API kullanımlarında kullanıcı kendi ortamını, gizli anahtarlarını ve güvenlik sınırlarını korumalıdır.

Sorun, öneri veya destek için: `zmetedinler@gmail.com`. Kullanımdan memnun kalırsanız küçük destek için 50 TL veya 25 ABD doları göndermeniz sevinçle karşılanır. IBAN ve ödeme bilgileri dağıtım paketinin ticari sürümünde ayrıca verilebilir. Bu bilgi bağış niteliğindedir; kitabı kullanma hakkını sınırlamaz.

## Genç programcıya öğütler

Bir dili öğrenmenin yolu önce komut ezberlemek değildir. Önce “hangi veriyi alıyorum, bu veriye hangi kararı veriyorum, sonucu nereye yazıyorum?” sorusunu sormalısın. Her örneği çalıştırmadan önce kâğıda üç kutu çiz: giriş, işlem, çıkış. Giriş kullanıcıdan, dosyadan, sensörden, ağdan veya DLL'den gelebilir. İşlem; koşul, döngü, fonksiyon, veri yapısı ve kütüphane çağrısıdır. Çıkış; ekran, dosya, grafik, tarayıcı, API cevabı veya başka programa verilen veri olabilir. İyi programcı hata çıkmayacağını varsaymaz; hata çıkarsa ne yapacağını baştan yazar. uXBasic'te `TRY`, `ASSERT`, test kapıları, rapor dosyaları ve çıktı sözleşmeleri bu yüzden önemlidir.

## Dosya uzantıları

|Uzantı|Anlamı|Ne zaman kullanılır|Küçük örnek|
|---|---|---|---|
|`.uxb`|Ana uXBasic kaynak dosyası|Programın çalışacak ana gövdesi için|`main.uxb`|
|`.bas`|BASIC uyumlu kaynak|Eski BASIC örnekleri veya sade dosyalar için|`demo.bas`|
|`.uxbh`|uXBasic başlık/dahil dosyası|Ortak sabit, tip, DECLARE ve yordamları paylaşmak için|`dosya.uxbh`|
|`.uxmh`|uXBasic modül başlığı|Kütüphane modülü sarmalayıcıları için|`uxstats.uxmh`|
|`.json`|Yapılandırılmış çıktı|AST/MIR/rapor/manifest/test sonucu için|`mir.json`|
|`.js`|Tarayıcı JavaScript çıktısı|Tarayıcıda çalıştırmak için|`program.js`|
|`.wat`|WebAssembly metin çıktısı|WASM insan okunur ara çıktısı için|`program.wat`|
|`.wasm`|WebAssembly ikili çıktısı|Tarayıcı veya WASM çalışma zamanı için|`program.wasm`|
|`.asm`|Assembly çıktısı|x64/x86 veya gömülü hedefe yakın çıktı için|`program.asm`|
|`.exe`|Windows çalıştırılabilir dosya|Yerel program çıktısı için|`program.exe`|

## Mimari katmanlar

uXBasic mimarisi bir mutfak gibi düşünülebilir. Önce malzeme gelir: kaynak dosyası. Ön-işleyici [kaynak derlenmeden önce çalışan düzenleyici] (preprocessor) malzemeyi ayıklar; hedefe göre HTML, JS, WAT, varlık ve bildirim parçalarını hazırlar. Sözcükleyici [metni anlamlı parçalara bölen katman] (lexer) komutları, adları, sayıları ve işaretleri ayırır. Çözümleyici [komutları ağaç yapısına çeviren katman] (parser) artık “IF nerede başladı, FOR nerede bitti, FUNCTION ne döndürür?” gibi yapıyı kurar. Soyut söz ağacı [programın ağaç biçimindeki anlamlı iskeleti] (AST) bu yapıyı taşır. Anlam ve tip katmanı değişkenin ne olduğunu, hangi işlemin hangi tipe uygulanabileceğini ve dış çağrının imzasını denetler. Orta gösterim [hedeflerden bağımsız ara komut düzeni] (MIR), programı JS, WAT, x64, x86 veya yorumlayıcıya götürülebilecek ortak biçime indirir. Arka uç [son çıktı üretici] (backend) hedef dosyaları yazar. Çalışma zamanı [program çalışırken yardım eden kütüphane düzeni] (runtime) dosya, matematik, büyük sayı, yapay zeka, grafik ve dış dünya işlerini taşır.

## Kanca ve sarmalayıcı düşüncesi

Kanca (hook) derleyicinin bir aşamasına “beni de haberdar et” demenin güvenli yoludur. İyi kanca asıl işi bozmaz; yalnız izleme, rapor, ölçüm veya özel genişletme yapar. Sarmalayıcı (wrapper) ise dış dünyanın dağınık fonksiyonlarını uXBasic tarafında temiz bir çağrıya çevirir. Genç programcı şunu unutmasın: iyi sarmalayıcı, kötü kütüphaneyi bile okunur yapar; kötü sarmalayıcı, iyi kütüphaneyi anlaşılmaz yapar. Bu yüzden her DLL çağrısında `DECLARE`, `ALIAS`, `MODULE`, `NAMESPACE`, hata kontrolü ve kaynak kapatma düzeni birlikte düşünülür.

## Çıktılar ve raporlar

uXBasic yalnız program üretmez; aynı zamanda ürettiği programın kanıtını da verir. `tokens.json`, `ast.json`, `symbol_table.json`, `type_table.json`, `mir.json`, `program.js`, `program.wat`, `index.html`, `manifest.json`, `stdout.txt`, `stderr.txt` ve `runtime_trace.json` gibi çıktılar bunun parçalarıdır. Bir çıktı yoksa test kapısı bunu söylemelidir; çıktı uydurmak yasaktır. Genç programcı için ders şudur: gerçek programcılıkta “çalıştı gibi” değil, “kanıtıyla çalıştı” denir.

## Başlangıç, Haklar, Dosyalar, Mimari ve Çalışma Mantığı

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Destek notu:** Bu belge ve uXBasic çalışmaları faydalı olursa 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince buraya yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`.

## Kullanım hakkı ve sorumluluk sınırı

Bu cep kitabı uXBasic dilini öğrenmek, denemek ve geliştirmek isteyenler için hazırlanmıştır. Kaynak kodun MIT Lisansı ile dağıtıldığı varsayılmıştır. MIT Lisansı kısaca şunu söyler: kodu kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi işinizde kullanabilirsiniz; fakat lisans metnini ve telif bildirimini korumalısınız. Bu yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, sistem bozulması, yanlış DLL/API çağrısı veya yanlış bilimsel sonuçlardan belge yazarı sorumlu değildir. Deney, üretim, finans, sağlık, resmi işlem, güvenlik ve gerçek cihaz kontrolünde önce küçük test yapın.

## Ön söz

uXBasic, BASIC ailesinin kolay okunur yapısını, çağdaş derleyici [kaynak kodu makineye çeviren program] (compiler) katmanlarıyla birleştirmek için tasarlanmış bir dildir. Genç programcı için en önemli düşünce şudur: bir dili öğrenmek yalnız komut ezberlemek değildir. Komutun ne zaman kullanılacağını, verinin nereden geldiğini, bellekte nereye gittiğini, çıktı dosyasına nasıl döndüğünü ve hata olursa nerede yakalanacağını anlamaktır.

uXBasic ile amaç yalnız `PRINT "Merhaba"` yazmak değildir. Aynı dil ile dosya okuyabilir, veri analizi yapabilir, DLL çağırabilir, Windows API kullanabilir, C/C++/ASM dosyasını derleme zincirine alabilir, tarayıcı için JavaScript [tarayıcı dili] (JavaScript) üretebilir, WebAssembly metni [tarayıcıda hızlı çalışan ara çıktı] (WAT/WASM) çıkarabilir, yerel yapay zekaya veya bulut yapay zekaya mesaj gönderebilirsiniz.

## Genç programcıya öğütler

Önce küçük program yaz. Sonra aynı programı üç kez boz ve düzelt. Bir komutu gerçekten öğrendiğini anlamanın yolu onu hata alacak biçimde de denemektir. `DIM` ile değişken aç, yanlış tip ver, hata raporuna bak. `OPEN` ile dosya aç, sonra kapatmayı unut, davranışı izle. `IF` yaz, sonra `ELSE` kısmını boş bırak. Derleyici yazan kişinin aklı, hatayı erken yakalayan akıldır.

Programlama hilesi dediğimiz şey çoğu zaman kural dışı numara değildir. Doğru yerde küçük bir kayıt tutmaktır. Mesela bir derleyicide her komutun hangi dosyadan, hangi satırdan geldiğini saklarsan, hata mesajını çok daha iyi verirsin. Bir `symbol_table.json` [sembol tablosu çıktısı] üretirsen, programdaki bütün değişkenleri sonra test edebilirsin. Bu yüzden uXBasic yalnız dil değil, aynı zamanda izlenebilir bir derleme düzenidir.

## uXBasic dosyaları

|Uzantı|Anlam ve kullanım|
|---|---|
|.uxb|Ana uXBasic kaynak dosyası. Yeni programlar için önerilen uzantı.|
|.bas|BASIC kökenli kaynak. Uyumluluk ve kolay geçiş için kullanılır.|
|.uxmh|uXBasic başlık/modül dosyası. Son kaynak klasöründe gerçek başlık uzantısı budur.|
|.uxbh|Başlık dosyası adı olarak düşünülebilir; bu pakette asıl kullanılan biçim `.uxmh` olduğu için yeni işlerde `.uxmh` tercih edilir.|
|.uxcli|Komut satırı zincirini dosyaya yazmak için kullanılabilir.|
|.json|AST/MIR/rapor/gate çıktıları.|
|.js|Tarayıcıda çalışan JavaScript çıktısı.|
|.wat|WebAssembly metin çıktısı.|
|.asm/.nasm|Yerel makine kodu üretimi için assembly çıktısı.|


`.uxb` yeni uXBasic programının ana evidir. `.bas` eski BASIC alışkanlığını taşır. `.uxmh` başlık ve modül bildirimlerini tutar. Büyük projede ana program kısa kalır, ayrıntılar `.uxmh` ve kütüphane dosyalarına ayrılır. Bu bir kitap yazmaya benzer: ana bölümde konu akar, eklerde ayrıntı durur.

## Mimari katmanlar

|No|Katman|Görev|
|---|---|---|
|1|Kaynak dosya|`.uxb`, `.bas`, `.uxmh` dosyaları|
|2|Ön-işleyici [derleme öncesi düzenleyici] (preprocessor)|`%%DEFINE`, `%%INCLUDE`, şartlı derleme|
|3|Sözlükçü [kelime ayırıcı] (lexer)|metni anahtar kelime, sayı, metin, işaret parçalarına böler|
|4|Çözümleyici [cümle kurucu] (parser)|komutlardan ağaç kurar|
|5|AST [soyut sözdizim ağacı]|programın iskeleti|
|6|Anlam denetimi [semantic]|tip, kapsam, bildirim denetimi|
|7|HIR/MIR [ara temsil]|hedeflerden bağımsız ortak program şekli|
|8|Çalıştırıcı [yorumlayıcı] (interpreter)|programı derlemeden dener|
|9|Kod üretici [backend]|JS, WAT, NASM gibi çıktı üretir|
|10|Test kapısı [gate]|çıktılar gerçek mi, sözleşme tutuldu mu bakar|


İşlem sırası şöyledir: kaynak okunur, ön-işleyici çalışır, sözlükçü kelimeleri ayırır, çözümleyici ağacı kurar, anlam denetimi değişkenleri ve tipleri kontrol eder, ara temsil üretilir, istenirse yorumlayıcı çalıştırır, istenirse kod üretici hedef dosyayı yazar. Bu sıra bozulursa derleyici de şaşırır. Bu yüzden test kapıları her aşamada çıktı ister.

## Komut satırı ve kısa fiiller

Kullanım biçimi:

```powershell
uxb <fiil> kaynak.uxb [seçenekler]
uxb ast oyun.uxb --ast-json-out out/ast.json
uxb jsw webdemo.uxb --emit-js --json-out out/js_report.json
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

|Fiil|Görev|
|---|---|
|lex|kelimeye ayırır|
|par|parser dener|
|ast|AST döker|
|sem|anlam denetimi|
|hir|HIR üretir|
|mir|MIR üretir|
|int|yorumlayıcıda çalıştırır|
|x64|x64 çıktı üretir|
|x86|x86 hedefini dener/raporlar|
|jsw|JavaScript/Web hattı|
|wat|WAT/WASM hattı|
|bld|derleme zinciri|
|run|çalıştırma|
|chk|kontrol|
|fmt|biçimleme|
|map|harita/çıktı raporu|
|doc|belge üretimi|
|rel|sürüm/release|
|hlp|yardım|
|ver|sürüm bilgisi|


## Üretilen çıktı dosyaları

|Çıktı|Ne işe yarar|
|---|---|
|tokens.json|Sözlükçü çıktısı; kaynak kaç parçaya ayrıldı gösterir.|
|ast.json|Komut ağacı; parser doğru mu anlamak için kullanılır.|
|hir.json|Yüksek düzey ara temsil.|
|mir.json|Makineye daha yakın ara temsil.|
|program.js|Tarayıcı veya Node benzeri JS ortamı için çıktı.|
|program.wat|WebAssembly metin çıktısı.|
|index.html|Tarayıcı kabuğu.|
|program.asm|x64/x86 üretim hattı için assembly.|
|diagnostics.json|Hata/uyarı raporu.|
|gate.json|Test kapısı sonucu.|


Çıktı dosyası uydurulmamalıdır. Bir test geçiyorsa dosya gerçekten derleyici tarafından üretilmelidir. `program.js` içinde gerçek JavaScript, `program.wat` içinde gerçek WAT, `index.html` içinde gerçek tarayıcı kabuğu olmalıdır. Genç programcı için bu altın kuraldır: testin amacı kendini kandırmak değil, hatayı erken bulmaktır.

## Hata kodları

|Kod|Ad|
|---|---|
|0|OK|
|6101|VERIFY_BLOCK|
|6102|INTERPRETER_BLOCK|
|6103|TARGET|
|6104|POLICY|
|6105|EMIT|
|6106|RUNTIME|
|6107|EXTERNAL_TOOL|
|6108|COMPARE|
|6109|FILE|


Örnek hata okuma:

```text
6105 EMIT hatası: Kod üretici çıktı yazamadı.
6109 FILE hatası: Dosya yolu, izin veya yazma sorunu var.
```

## İlk örnek: tek dosyalık küçük program

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

Bu program beş temel işi öğretir: `MAIN` giriş noktasıdır, `DIM` değişken açar, `PRINT` çıktı verir, `INPUT` veri alır, `IF` karar verir. Programın amacı kullanıcıyı tanımak değildir; veri akışını öğretmektir. Veri klavyeden gelir, değişkende durur, şartla yorumlanır, ekrana döner.


# Bölüm 2 — Dil Yüzeyi, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Fonksiyonlar

# Anahtar Sözcükler, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

Bu ciltte tablo hücreleri kısa ve işe yarar tutuldu: sözdizimi ne yazacağını, görev ise komutun ne yaptığını söyler. Uzun anlatım tablonun altında sınıf başlıklarına ayrılmıştır. Böylece aynı cümle tekrarı yerine her komutun program yazarken nerede işe yaradığı görülür.

## Tüm anahtar sözcükler
|No|Sözcük|Sınıf|Sözdizimi|Görev|
|---|---|---|---|---|
|1|IF|Akış|IF koşul THEN komutlar ELSE komutlar END IF|Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.|
|2|THEN|Akış|IF koşul THEN komutlar|IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.|
|3|ELSE|Akış|IF koşul THEN ... ELSE ... END IF|IF koşulu yanlışsa çalışacak yedek yolu gösterir.|
|4|ELSEIF|Akış|IF a THEN ... ELSEIF b THEN ... ELSE ... END IF|Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.|
|5|END|Akış|END IF \| END SELECT \| END SUB \| END FUNCTION \| END CLASS \| END MODULE|Açılmış bloğu kapatır ve sınırını belli eder.|
|6|SELECT|Akış|SELECT CASE ifade ... CASE değer ... END SELECT|Tek bir değeri birçok olası değere göre dallandırır.|
|7|CASE|Akış|CASE değer \| CASE IS > değer \| CASE ELSE|SELECT içindeki tek seçeneği belirtir.|
|8|IS|Akış|CASE IS > değer \| CASE IS <= değer|CASE içinde karşılaştırmalı seçenek kurar.|
|9|TRY|Akış|TRY ... CATCH hata ... FINALLY ... END TRY|Hata çıkabilecek işi korumalı bölümde dener.|
|10|CATCH|Akış|CATCH hataAdi|TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.|
|11|FINALLY|Akış|FINALLY ...|Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.|
|12|THROW|Akış|THROW "hata metni"|Senin belirlediğin hatayı bilinçli olarak fırlatır.|
|13|ASSERT|Akış|ASSERT koşul|Test amacıyla bir koşulun doğru olmasını zorunlu tutar.|
|14|EVENT|Olay ve eşzamanlılık|EVENT OlayAdi|Daha sonra tetiklenecek olay adını bildirir.|
|15|THREAD|Olay ve eşzamanlılık|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar.|
|16|THREAD|Olay ve eşzamanlılık|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar. Eski metinlerde THREAT görülürse yazım hatası kabul edilir; yeni kodda THREAD kullanılır.|
|17|PARALEL|Olay ve eşzamanlılık|PARALEL GrupAdi ... END PARALEL|Birden fazla işi paralel görev ailesi olarak düzenler.|
|18|PIPE|Olay ve eşzamanlılık|PIPE Ad AS Tip|İki iş arasında veri taşıyan boru tanımlar.|
|19|SLOT|Olay ve eşzamanlılık|SLOT Ad ON Olay ... END SLOT|Bir olaya bağlı çalışacak kod yuvasını tanımlar.|
|20|ON|Olay ve eşzamanlılık|SLOT Ad ON Olay \| ON ERROR ...|Bir eylemi olaya veya duruma bağlar.|
|21|OFF|Olay ve eşzamanlılık|OFF Olay \| OFF SLOT Ad|Olay dinlemeyi veya bağlı tepkiyi kapatır.|
|22|TRIGGER|Olay ve eşzamanlılık|TRIGGER OlayAdi[, veri]|Bir olayı elle tetikler.|
|23|BYTE|Tipler|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|24|FOR|Akış|FOR sayac = ilk TO son STEP adim ... NEXT sayac|Sayaçlı döngü kurar.|
|25|TO|Akış|FOR i = başlangıç TO bitiş|Döngünün son değerini gösterir.|
|26|STEP|Akış|FOR i = ilk TO son STEP adim|Sayaç artışını veya azalışını belirler.|
|27|NEXT|Akış|NEXT sayac|FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.|
|28|DO|Akış|DO WHILE koşul ... LOOP \| DO ... LOOP UNTIL koşul|Koşullu döngü başlatır.|
|29|LOOP|Akış|LOOP \| LOOP UNTIL koşul|DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.|
|30|WHILE|Akış|DO WHILE koşul \| WHILE koşul ... WEND|Koşul doğru kaldığı sürece çalışmayı sürdürür.|
|31|UNTIL|Akış|LOOP UNTIL koşul|Koşul doğru olunca döngüyü bitirir.|
|32|EXIT|Akış|EXIT FOR \| EXIT DO \| EXIT FUNCTION \| EXIT SUB|İçinde bulunulan döngüden veya yordamdan erken çıkar.|
|33|EACH|Akış|FOR EACH eleman IN liste ... NEXT|Bir koleksiyonun elemanlarını tek tek dolaşır.|
|34|IN|Akış|FOR EACH x IN koleksiyon \| x IN liste|Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.|
|35|SUB|Yordam ve çağrı|SUB Ad(param AS Tip) ... END SUB|Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.|
|36|FUNCTION|Yordam ve çağrı|FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION|Değer döndüren hesap veya dönüştürme bloğu tanımlar.|
|37|DECLARE|Yordam ve çağrı|DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip|Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.|
|38|RETURN|Akış|RETURN değer|Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.|
|39|GOTO|Akış|GOTO etiket|Belirtilen etikete doğrudan atlar.|
|40|GOSUB|Akış|GOSUB etiket ... RETURN|Etikete gider ve RETURN ile geri döner.|
|41|CALL|Yordam ve çağrı|CALL Ad(argler) \| CALL(DLL,"dll","fonksiyon",argler) \| CALL(API,"ad",argler)|Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.|
|42|TYPE|Nesne ve tip bildirimi|TYPE Ad ... END TYPE|Kayıt biçiminde veri alanları toplar.|
|43|CLASS|Nesne ve tip bildirimi|CLASS Ad ... END CLASS|Veri ve davranışı aynı nesne kalıbında toplar.|
|44|INTERFACE|Nesne ve tip bildirimi|INTERFACE Ad ... END INTERFACE|Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.|
|45|IMPLEMENTS|Nesne ve tip bildirimi|CLASS Ad IMPLEMENTS Arayuz|Sınıfın arayüz sözleşmesini üstlendiğini belirtir.|
|46|METHOD|Nesne ve tip bildirimi|METHOD Ad(...) AS Tip|Sınıf içindeki işlevi tanımlar.|
|47|MAGIC|Nesne ve tip bildirimi|MAGIC <.Ad.>(...)|Sihirli yöntem tanımlar. Eski metinlerde SIHIRLIMETOT görülürse uyumluluk/yazım hatası kabul edilir; yeni kodda MAGIC kullanılır.|
|48|MAGIC|Nesne ve tip bildirimi|MAGIC Ad(...)|Sihirli yöntem için kısa/alternatif yazım sağlar.|
|49|VIRTUAL|Nesne ve tip bildirimi|VIRTUAL METHOD Ad(...)|Alt sınıfın değiştirebileceği yöntem bildirir.|
|50|OVERRIDE|Nesne ve tip bildirimi|OVERRIDE METHOD Ad(...)|Üst sınıftaki yöntemi bilinçli olarak değiştirir.|
|51|CONSTRUCTOR|Nesne ve tip bildirimi|CONSTRUCTOR(...)|Nesne oluşurken çalışan kurucu bölümdür.|
|52|DESTRUCTOR|Nesne ve tip bildirimi|DESTRUCTOR()|Nesne yok olurken temizlik yapar.|
|53|NEW|Nesne ve tip bildirimi|NEW Sinif(argler)|Yeni nesne oluşturur.|
|54|DELETE|Nesne ve tip bildirimi|DELETE nesne|Nesne/ayrılmış kaynağı bırakır.|
|55|DIM|Değişken ve bellek|DIM ad AS Tip|Yeni değişken, dizi veya nesne başvurusu bildirir.|
|56|REDIM|Değişken ve bellek|REDIM dizi(yeniBoyut)|Diziyi yeni boyuta taşır.|
|57|AS|Değişken ve bellek|ad AS Tip|Bir adın tipini belirtir.|
|58|CONST|Değişken ve bellek|CONST ad AS Tip = değer|Değişmeyen sabit tanımlar.|
|59|INCLUDE|Modül ve kaynak|INCLUDE "dosya.uxbh"|Başka uXBasic başlık/destek dosyasını kaynak içine katar.|
|60|IMPORT|Modül ve kaynak|IMPORT(C,"dosya.c") \| IMPORT(CPP,"dosya.cpp") \| IMPORT(ASM,"dosya.asm")|Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.|
|61|ABSTRACT|Nesne ve tip bildirimi|ABSTRACT CLASS Ad|Doğrudan üretilmeyen temel sınıf tanımlar.|
|62|FINAL|Nesne ve tip bildirimi|FINAL CLASS Ad \| FINAL METHOD Ad|Daha fazla miras/değiştirme yapılmasını engeller.|
|63|SEALED|Nesne ve tip bildirimi|SEALED CLASS Ad|Kapatılmış sınıf bildirir.|
|64|STATIC|Nesne ve tip bildirimi|STATIC alan AS Tip \| STATIC METHOD Ad|Sınıfa ait tek ortak alan/yöntem tanımlar.|
|65|PROPERTY|Nesne ve tip bildirimi|PROPERTY Ad AS Tip|Nesne alanını kontrollü özellik olarak tanımlar.|
|66|OPERATOR|Nesne ve tip bildirimi|OPERATOR +(a,b)|Sınıf için işlemci davranışı tanımlar.|
|67|MIXIN|Nesne ve tip bildirimi|MIXIN Ad|Bir sınıfa ek davranış karışımı ekler.|
|68|DECORATOR|Nesne ve tip bildirimi|DECORATOR Ad|Yordam/sınıf etrafına ek davranış sarar.|
|69|PUBLIC|Nesne ve tip bildirimi|PUBLIC ad|Dışarıdan erişilebilir üye bildirir.|
|70|PRIVATE|Nesne ve tip bildirimi|PRIVATE ad|Sadece kendi sınıf/modülü içinden erişilir.|
|71|PROTECTED|Nesne ve tip bildirimi|PROTECTED ad|Kendi sınıfı ve alt sınıflar erişir.|
|72|RESTRICTED|Nesne ve tip bildirimi|RESTRICTED ad|Daraltılmış erişim kuralı belirtir.|
|73|FRIEND|Nesne ve tip bildirimi|FRIEND MODULE Ad|Belirli modül/sınıfa özel erişim verir.|
|74|READONLY|Nesne ve tip bildirimi|READONLY ad AS Tip|Dışarıdan değiştirilemeyen okuma alanı bildirir.|
|75|MUTABLE|Nesne ve tip bildirimi|MUTABLE ad AS Tip|Normalde sabit bağlamda bile değişebilir alan belirtir.|
|76|IMMUTABLE|Nesne ve tip bildirimi|IMMUTABLE ad AS Tip|Değişmez veri/nesne niyeti belirtir.|
|77|MAIN|Modül ve kaynak|MAIN ... END MAIN|Programın ana giriş bölümünü belirtir.|
|78|NAMESPACE|Modül ve kaynak|NAMESPACE Ad ... END NAMESPACE|Adları çakışmadan ayıran alan açar.|
|79|MODULE|Modül ve kaynak|MODULE Ad ... END MODULE|Bir dosya veya iş ailesini modül olarak toplar.|
|80|USING|Modül ve kaynak|USING MODULE Ad \| USING NAMESPACE Ad|Bir modül/alan adını kısa kullanım için etkinleştirir.|
|81|ALIAS|Modül ve kaynak|ALIAS yeniAd = eskiAd \| ALIAS KISA AS uzunAd|Uzun çağrıya kısa veya yerel ad verir.|
|82|DEFINT|Varsayılan tip|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|83|DEFLNG|Varsayılan tip|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|84|DEFSNG|Varsayılan tip|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|85|DEFDBL|Varsayılan tip|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|86|DEFEXT|Varsayılan tip|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|87|DEFSTR|Varsayılan tip|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|88|DEFBYT|Varsayılan tip|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|
|89|PRINT|Girdi çıktı ve ekran|PRINT ifade[, ifade] \| PRINT #dosya, ifade|Ekrana veya dosyaya metin/sayı yazar.|
|90|INPUT|Girdi çıktı ve ekran|INPUT değişken \| INPUT #dosya, değişken|Kullanıcıdan veya dosyadan veri okur.|
|91|OPEN|Girdi çıktı ve ekran|OPEN "dosya" FOR INPUT\|OUTPUT\|APPEND AS #no|Dosyayı okuma/yazma/ekleme için açar.|
|92|CLOSE|Girdi çıktı ve ekran|CLOSE #no|Açık dosyayı kapatır.|
|93|GET|Girdi çıktı ve ekran|GET #no, konum, değişken|Dosyadan ham veri okur.|
|94|PUT|Girdi çıktı ve ekran|PUT #no, konum, değişken|Dosyaya ham veri yazar.|
|95|SEEK|Girdi çıktı ve ekran|SEEK #no, konum|Dosya okuma/yazma konumunu değiştirir.|
|96|CLS|Girdi çıktı ve ekran|CLS|Ekranı temizler.|
|97|COLOR|Girdi çıktı ve ekran|COLOR ön[, arka]|Yazı/arka plan rengini ayarlar.|
|98|LOCATE|Girdi çıktı ve ekran|LOCATE satır, sütun|Ekran imlecini konuma taşır.|
|99|AND|İşleç|a AND b|iki koşul/bit birlikte doğruysa doğru verir|
|100|OR|İşleç|a OR b|koşullardan biri doğruysa doğru verir|
|101|NOT|İşleç|NOT koşul|koşulu tersine çevirir|
|102|XOR|İşleç|a XOR b|yalnız biri doğruysa doğru verir veya bitlerde özel fark alır|
|103|MOD|İşleç|a MOD b|bölme kalanı verir|
|104|SHL|İşleç|a SHL b|bitleri sola kaydırır|
|105|SHR|İşleç|a SHR b|bitleri sağa kaydırır|
|106|ROL|İşleç|a ROL b|bitleri döndürerek sola kaydırır|
|107|ROR|İşleç|a ROR b|bitleri döndürerek sağa kaydırır|
|108|INLINE|Modül ve kaynak|INLINE C ... END INLINE \| INLINE ASM ... END INLINE|uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.|
|109|I8|Tipler|DIM ad AS I8|-128 ile 127 arasında işaretli 8 bit tam sayı tutar.|
|110|U8|Tipler|DIM ad AS U8|0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.|
|111|I16|Tipler|DIM ad AS I16|işaretli 16 bit tam sayı tutar.|
|112|U16|Tipler|DIM ad AS U16|işaretsiz 16 bit tam sayı tutar.|
|113|I32|Tipler|DIM ad AS I32|günlük sayaç ve indeksler için 32 bit tam sayı tutar.|
|114|U32|Tipler|DIM ad AS U32|negatif olmayan 32 bit sayı tutar.|
|115|I64|Tipler|DIM ad AS I64|büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.|
|116|U64|Tipler|DIM ad AS U64|çok büyük pozitif sayaçlar için 64 bit sayı tutar.|
|117|F32|Tipler|DIM ad AS F32|tek duyarlıklı ondalıklı sayı tutar.|
|118|F64|Tipler|DIM ad AS F64|çift duyarlıklı ondalıklı sayı tutar.|
|119|F80|Tipler|DIM ad AS F80|genişletilmiş kayan nokta sayı tutar.|
|120|F128|Tipler|DIM ad AS F128|128 bit yüksek duyarlıklı sayı tutar.|
|121|BIGF|Tipler|DIM ad AS BIGF|çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.|
|122|BIGD|Tipler|DIM ad AS BIGD|çok basamaklı ondalık sayı ailesidir.|
|123|BALL|Tipler|DIM ad AS BALL|aralık/top mantığıyla güvenli yaklaşık sayı tutar.|
|124|BOOLEAN|Tipler|DIM ad AS BOOLEAN|TRUE/FALSE doğru-yanlış değeri tutar.|
|125|STRING|Tipler|DIM ad AS STRING|metin tutar.|
|126|OBJECT|Tipler|DIM ad AS OBJECT|nesne başvurusu tutar.|
|127|PTR|Tipler|DIM ad AS PTR|ham adres veya dış kütüphane işaretçisi tutar.|
|128|STRPTR|Tipler|DIM ad AS STRPTR|metnin bellek adresini dış çağrıya verir.|
|129|BYREF|Yordam ve çağrı|param AS BYREF Tip \| BYREF param AS Tip|Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.|
|130|BYVAL|Yordam ve çağrı|BYVAL param AS Tip|Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.|
|131|CDECL|Yordam ve çağrı|DECLARE CDECL FUNCTION ...|C çağrı düzenini belirtir.|
|132|STDCALL|Yordam ve çağrı|DECLARE STDCALL FUNCTION ...|Windows çağrı düzenini belirtir.|
|133|ARRAY|Tipler|DIM ad AS ARRAY|sabit veya yeniden boyutlanabilir dizi tutar.|
|134|LIST|Tipler|DIM ad AS LIST|sıralı, büyüyebilen liste tutar.|
|135|DICT|Tipler|DIM ad AS DICT|anahtar/değer sözlüğü tutar.|
|136|SET|Tipler|DIM ad AS SET|tekrarsız küme tutar.|
|137|SETSTRINGSIZE|Yerel fonksiyon|sonuc = SETSTRINGSIZE metin, uzunluk|Metin değişkeni için istenen uzunlukta alan hazırlar.|
|138|TIMER|Yerel fonksiyon|sonuc = TIMER()|Geçen zamanı saniye türünden verir.|
|139|LOF|Yerel fonksiyon|sonuc = LOF(#no)|Açık dosyanın uzunluğunu verir.|
|140|EOF|Yerel fonksiyon|sonuc = EOF(#no)|Dosya sonuna gelinip gelinmediğini söyler.|
|141|LEN|Yerel fonksiyon|sonuc = LEN(metin)|Metnin veya verinin uzunluğunu verir.|
|142|MID|Yerel fonksiyon|sonuc = MID(metin, başla, uzunluk)|Metnin içinden parça alır.|
|143|STR|Yerel fonksiyon|sonuc = STR(sayi)|Sayıyı metne çevirir.|
|144|VAL|Yerel fonksiyon|sonuc = VAL(metin)|Metni sayıya çevirir.|
|145|ABS|Yerel fonksiyon|sonuc = ABS(x)|Mutlak değer alır.|
|146|INT|Yerel fonksiyon|sonuc = INT(x)|Ondalıklı sayının tam kısmını alır.|
|147|UCASE|Yerel fonksiyon|sonuc = UCASE(metin)|Metni büyük harfe çevirir.|
|148|LCASE|Yerel fonksiyon|sonuc = LCASE(metin)|Metni küçük harfe çevirir.|
|149|ASC|Yerel fonksiyon|sonuc = ASC(karakter)|Karakterin sayı kodunu verir.|
|150|CHR|Yerel fonksiyon|sonuc = CHR(kod)|Sayı kodundan karakter üretir.|
|151|LTRIM|Yerel fonksiyon|sonuc = LTRIM(metin)|Sol boşlukları temizler.|
|152|RTRIM|Yerel fonksiyon|sonuc = RTRIM(metin)|Sağ boşlukları temizler.|
|153|SPACE|Yerel fonksiyon|sonuc = SPACE(n)|Belirli sayıda boşluk üretir.|
|154|SGN|Yerel fonksiyon|sonuc = SGN(x)|Sayının işaretini verir.|
|155|SQRT|Yerel fonksiyon|sonuc = SQRT(x)|Karekök hesaplar.|
|156|SIN|Yerel fonksiyon|sonuc = SIN(x)|Sinüs hesaplar.|
|157|COS|Yerel fonksiyon|sonuc = COS(x)|Kosinüs hesaplar.|
|158|TAN|Yerel fonksiyon|sonuc = TAN(x)|Tanjant hesaplar.|
|159|ATN|Yerel fonksiyon|sonuc = ATN(x)|Arktanjant hesaplar.|
|160|EXP|Yerel fonksiyon|sonuc = EXP(x)|e üzeri x hesaplar.|
|161|LOG|Yerel fonksiyon|sonuc = LOG(x)|Doğal logaritma hesaplar.|
|162|INKEY|Yerel fonksiyon|sonuc = INKEY()|Basılmış tuşu beklemeden okur.|
|163|GETKEY|Yerel fonksiyon|sonuc = GETKEY()|Tuş bekler ve okur.|
|164|VARPTR|Yerel fonksiyon|sonuc = VARPTR(degisken)|Değişkenin bellek adresini verir.|
|165|SADD|Yerel fonksiyon|sonuc = SADD(metin)|Metin içeriğinin adresini verir.|
|166|LPTR|Yerel fonksiyon|sonuc = LPTR(degisken)|Uzun adres/işaretçi değeri verir.|
|167|CODEPTR|Yerel fonksiyon|sonuc = CODEPTR(yordam)|Yordamın kod adresini verir.|
|168|SIZEOF|Yerel fonksiyon|sonuc = SIZEOF(Tip\|degisken)|Tip veya değişken boyutunu bayt olarak verir.|
|169|OFFSETOF|Yerel fonksiyon|sonuc = OFFSETOF(Tip, alan)|Kayıt içindeki alanın başlangıç uzaklığını verir.|
|170|CINT|Yerel fonksiyon|sonuc = CINT(x)|Değeri tam sayıya çevirir.|
|171|CLNG|Yerel fonksiyon|sonuc = CLNG(x)|Değeri uzun tam sayıya çevirir.|
|172|CDBL|Yerel fonksiyon|sonuc = CDBL(x)|Değeri çift duyarlıklı sayıya çevirir.|
|173|CSNG|Yerel fonksiyon|sonuc = CSNG(x)|Değeri tek duyarlıklı sayıya çevirir.|
|174|FIX|Yerel fonksiyon|sonuc = FIX(x)|Ondalık kısmı keser.|
|175|SQR|Yerel fonksiyon|sonuc = SQR(x)|Karekök için BASIC uyumlu addır.|
|176|RND|Yerel fonksiyon|sonuc = RND()|Rastgele sayı üretir.|
|177|RANDOMIZE|Yerel fonksiyon|sonuc = RANDOMIZE [tohum]|Rastgele sayı üreticisini tohumlar.|
|178|PEEKB|Bellek ve düşük seviye|PEEKB adres[, değer[, uzunluk]]|Adresten bayt okur.|
|179|PEEKW|Bellek ve düşük seviye|PEEKW adres[, değer[, uzunluk]]|Adresten 16 bit sözcük okur.|
|180|PEEKD|Bellek ve düşük seviye|PEEKD adres[, değer[, uzunluk]]|Adresten 32 bit değer okur.|
|181|POKE|Bellek ve düşük seviye|POKE adres[, değer[, uzunluk]]|Adrese genel değer yazar.|
|182|POKEB|Bellek ve düşük seviye|POKEB adres[, değer[, uzunluk]]|Adrese bayt yazar.|
|183|POKEW|Bellek ve düşük seviye|POKEW adres[, değer[, uzunluk]]|Adrese 16 bit değer yazar.|
|184|POKED|Bellek ve düşük seviye|POKED adres[, değer[, uzunluk]]|Adrese 32 bit değer yazar.|
|185|POKES|Bellek ve düşük seviye|POKES adres[, değer[, uzunluk]]|Adrese metin/blok yazar.|
|186|MEMCOPYB|Bellek ve düşük seviye|MEMCOPYB adres[, değer[, uzunluk]]|Bayt blok kopyalar.|
|187|MEMCOPYW|Bellek ve düşük seviye|MEMCOPYW adres[, değer[, uzunluk]]|16 bit sözcük blok kopyalar.|
|188|MEMCOPYD|Bellek ve düşük seviye|MEMCOPYD adres[, değer[, uzunluk]]|32 bit blok kopyalar.|
|189|MEMFILLB|Bellek ve düşük seviye|MEMFILLB adres[, değer[, uzunluk]]|Belleği bayt değeriyle doldurur.|
|190|MEMFILLW|Bellek ve düşük seviye|MEMFILLW adres[, değer[, uzunluk]]|Belleği 16 bit değerle doldurur.|
|191|MEMFILLD|Bellek ve düşük seviye|MEMFILLD adres[, değer[, uzunluk]]|Belleği 32 bit değerle doldurur.|
|192|SETNEWOFFSET|Bellek ve düşük seviye|SETNEWOFFSET adres[, değer[, uzunluk]]|Yeni ayırma ofsetini belirler.|
|193|INC|Bellek ve düşük seviye|INC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri artırır.|
|194|DEC|Bellek ve düşük seviye|DEC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri azaltır.|
|195|ENUM|Listeleme|ENUM Ad ... END ENUM|Adlandırılmış sabitler grubu oluşturur.|

## Sınıflara göre komut anlatımı

### Akış

Akış komutları programın yol ayrımlarıdır. Bir genç programcı bu grubu iyi anlarsa programı çizgi film sahnesi gibi düşünebilir: bir sahnede karar verilir, başka sahnede tekrar yapılır, hata çıkarsa temizlik sahnesine geçilir. `IF`, `SELECT`, `FOR`, `DO`, `TRY` ve `RETURN` aynı ailenin farklı araçlarıdır. Veri ölçümleri, kullanıcı menüleri, dosya okuma döngüleri ve bilimsel hesaplar hep akışla yönetilir. Bu komutları kullanırken önce koşulu kısa yaz, sonra o koşulun neden var olduğunu yorumla açıkla. Döngü yazarken çıkış yolunu unutma; çıkış yolu olmayan döngü genç programcının ilk büyük tuzağıdır. Hata yakalamayı da akışın parçası say; çünkü gerçek programda dosya her zaman bulunmaz, API her zaman cevap vermez, kullanıcı her zaman beklediğin veriyi yazmaz.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|IF|IF koşul THEN komutlar ELSE komutlar END IF|Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.|
|THEN|IF koşul THEN komutlar|IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.|
|ELSE|IF koşul THEN ... ELSE ... END IF|IF koşulu yanlışsa çalışacak yedek yolu gösterir.|
|ELSEIF|IF a THEN ... ELSEIF b THEN ... ELSE ... END IF|Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.|
|END|END IF \| END SELECT \| END SUB \| END FUNCTION \| END CLASS \| END MODULE|Açılmış bloğu kapatır ve sınırını belli eder.|
|SELECT|SELECT CASE ifade ... CASE değer ... END SELECT|Tek bir değeri birçok olası değere göre dallandırır.|
|CASE|CASE değer \| CASE IS > değer \| CASE ELSE|SELECT içindeki tek seçeneği belirtir.|
|IS|CASE IS > değer \| CASE IS <= değer|CASE içinde karşılaştırmalı seçenek kurar.|
|TRY|TRY ... CATCH hata ... FINALLY ... END TRY|Hata çıkabilecek işi korumalı bölümde dener.|
|CATCH|CATCH hataAdi|TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.|
|FINALLY|FINALLY ...|Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.|
|THROW|THROW "hata metni"|Senin belirlediğin hatayı bilinçli olarak fırlatır.|
|ASSERT|ASSERT koşul|Test amacıyla bir koşulun doğru olmasını zorunlu tutar.|
|FOR|FOR sayac = ilk TO son STEP adim ... NEXT sayac|Sayaçlı döngü kurar.|
|TO|FOR i = başlangıç TO bitiş|Döngünün son değerini gösterir.|
|STEP|FOR i = ilk TO son STEP adim|Sayaç artışını veya azalışını belirler.|
|NEXT|NEXT sayac|FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.|
|DO|DO WHILE koşul ... LOOP \| DO ... LOOP UNTIL koşul|Koşullu döngü başlatır.|
|LOOP|LOOP \| LOOP UNTIL koşul|DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.|
|WHILE|DO WHILE koşul \| WHILE koşul ... WEND|Koşul doğru kaldığı sürece çalışmayı sürdürür.|
|UNTIL|LOOP UNTIL koşul|Koşul doğru olunca döngüyü bitirir.|
|EXIT|EXIT FOR \| EXIT DO \| EXIT FUNCTION \| EXIT SUB|İçinde bulunulan döngüden veya yordamdan erken çıkar.|
|EACH|FOR EACH eleman IN liste ... NEXT|Bir koleksiyonun elemanlarını tek tek dolaşır.|
|IN|FOR EACH x IN koleksiyon \| x IN liste|Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.|
|RETURN|RETURN değer|Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.|
|GOTO|GOTO etiket|Belirtilen etikete doğrudan atlar.|
|GOSUB|GOSUB etiket ... RETURN|Etikete gider ve RETURN ile geri döner.|

#### IF
**Sözdizimi:** `IF koşul THEN komutlar ELSE komutlar END IF`  
**Ne işe yarar:** Koşula bakar; doğru yolda ayrı, yanlış yolda ayrı komutlar çalıştırır.  
**Nerede kullanılır:** Karar vermen gereken her yerde kullanılır: kullanıcı yetkisi, ölçüm sınırı, dosya var mı, hata var mı, hedef tarayıcı mı gibi.

```uxbasic
IF ph < 6.5 THEN PRINT "asit" ELSE PRINT "normal" END IF
```
#### THEN
**Sözdizimi:** `IF koşul THEN komutlar`  
**Ne işe yarar:** IF koşulu doğru olduğunda başlayacak komut bölümünü gösterir.  
**Nerede kullanılır:** Tek başına program başlatmaz; IF satırındaki doğru dalı açar.

```uxbasic
IF sicaklik > 30 THEN PRINT "fan ac"
```
#### ELSE
**Sözdizimi:** `IF koşul THEN ... ELSE ... END IF`  
**Ne işe yarar:** IF koşulu yanlışsa çalışacak yedek yolu gösterir.  
**Nerede kullanılır:** Olumsuz durumun da planlı olmasını sağlar.

```uxbasic
IF stok > 0 THEN PRINT "sat" ELSE PRINT "siparis ver" END IF
```
#### ELSEIF
**Sözdizimi:** `IF a THEN ... ELSEIF b THEN ... ELSE ... END IF`  
**Ne işe yarar:** Birden çok koşulu sırayla dener; ilk doğru koşulun bölümünü çalıştırır.  
**Nerede kullanılır:** Çok sınıflı karar ağacı kurarken kullanılır.

```uxbasic
IF notu>=85 THEN PRINT "AA" ELSEIF notu>=70 THEN PRINT "BB" ELSE PRINT "CC" END IF
```
#### END
**Sözdizimi:** `END IF | END SELECT | END SUB | END FUNCTION | END CLASS | END MODULE`  
**Ne işe yarar:** Açılmış bloğu kapatır ve sınırını belli eder.  
**Nerede kullanılır:** Blokların birbirine karışmamasını sağlar.

```uxbasic
SUB Selam(): PRINT "merhaba": END SUB
```
#### SELECT
**Sözdizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`  
**Ne işe yarar:** Tek bir değeri birçok olası değere göre dallandırır.  
**Nerede kullanılır:** Menü, durum kodu, hedef adı, işlem türü gibi seçeneklerde IF zincirinden daha okunur.

```uxbasic
SELECT CASE secim
CASE 1: PRINT "basla"
CASE 2: PRINT "yardim"
END SELECT
```
#### CASE
**Sözdizimi:** `CASE değer | CASE IS > değer | CASE ELSE`  
**Ne işe yarar:** SELECT içindeki tek seçeneği belirtir.  
**Nerede kullanılır:** SELECT olmadan anlamı yoktur; bir sınıflandırma satırıdır.

```uxbasic
CASE IS > 100: PRINT "buyuk"
```
#### IS
**Sözdizimi:** `CASE IS > değer | CASE IS <= değer`  
**Ne işe yarar:** CASE içinde karşılaştırmalı seçenek kurar.  
**Nerede kullanılır:** Sadece eşitlik değil aralık/sınır denetimi gerektiğinde kullanılır.

```uxbasic
CASE IS <= 0: PRINT "gecersiz"
```
#### TRY
**Sözdizimi:** `TRY ... CATCH hata ... FINALLY ... END TRY`  
**Ne işe yarar:** Hata çıkabilecek işi korumalı bölümde dener.  
**Nerede kullanılır:** Dosya, ağ, DLL ve kullanıcı girdisi gibi bozulabilecek işlerde kullanılır.

```uxbasic
TRY
  OPEN "veri.csv" FOR INPUT AS #1
CATCH e
  PRINT "dosya acilamadi"
END TRY
```
#### CATCH
**Sözdizimi:** `CATCH hataAdi`  
**Ne işe yarar:** TRY içindeki hata yakalanırsa çalışacak bölümü başlatır.  
**Nerede kullanılır:** Programın çökmesini önler, hatayı anlaşılır mesaja çevirir.

```uxbasic
CATCH e: PRINT "hata: "; e
```
#### FINALLY
**Sözdizimi:** `FINALLY ...`  
**Ne işe yarar:** Hata olsa da olmasa da en son çalışacak temizlik bölümünü açar.  
**Nerede kullanılır:** Açılan dosyayı kapatmak, belleği bırakmak, bağlantıyı sonlandırmak için kullanılır.

```uxbasic
FINALLY: CLOSE #1
```
#### THROW
**Sözdizimi:** `THROW "hata metni"`  
**Ne işe yarar:** Senin belirlediğin hatayı bilinçli olarak fırlatır.  
**Nerede kullanılır:** Yanlış veri geldiğinde sessizce devam etmek yerine hatayı görünür yapar.

```uxbasic
IF yas < 0 THEN THROW "yas negatif olamaz"
```
#### ASSERT
**Sözdizimi:** `ASSERT koşul`  
**Ne işe yarar:** Test amacıyla bir koşulun doğru olmasını zorunlu tutar.  
**Nerede kullanılır:** Derleyici, kütüphane ve bilimsel hesap testlerinde beklenen sonucu korur.

```uxbasic
ASSERT toplam >= 0
```
#### FOR
**Sözdizimi:** `FOR sayac = ilk TO son STEP adim ... NEXT sayac`  
**Ne işe yarar:** Sayaçlı döngü kurar.  
**Nerede kullanılır:** Kaç kere çalışacağı belli olan işlerde kullanılır.

```uxbasic
FOR i = 1 TO 10 STEP 1
  PRINT i
NEXT i
```
#### TO
**Sözdizimi:** `FOR i = başlangıç TO bitiş`  
**Ne işe yarar:** Döngünün son değerini gösterir.  
**Nerede kullanılır:** FOR satırında hedef sınırı belirtir.

```uxbasic
FOR gun = 1 TO 30: PRINT gun: NEXT gun
```
#### STEP
**Sözdizimi:** `FOR i = ilk TO son STEP adim`  
**Ne işe yarar:** Sayaç artışını veya azalışını belirler.  
**Nerede kullanılır:** Atlamalı okuma, geri sayım, seyrek örnekleme işlerinde kullanılır.

```uxbasic
FOR i = 10 TO 0 STEP -2: PRINT i: NEXT i
```
#### NEXT
**Sözdizimi:** `NEXT sayac`  
**Ne işe yarar:** FOR döngüsünün sonunu ve sonraki adıma geçişini gösterir.  
**Nerede kullanılır:** Sayaçlı tekrarın kapanışıdır.

```uxbasic
NEXT i
```
#### DO
**Sözdizimi:** `DO WHILE koşul ... LOOP | DO ... LOOP UNTIL koşul`  
**Ne işe yarar:** Koşullu döngü başlatır.  
**Nerede kullanılır:** Kaç tekrar olacağı önceden bilinmeyen işlerde kullanılır.

```uxbasic
DO WHILE EOF(1)=0
  INPUT #1, satir
LOOP
```
#### LOOP
**Sözdizimi:** `LOOP | LOOP UNTIL koşul`  
**Ne işe yarar:** DO döngüsünü kapatır; gerekirse çıkış koşulunu taşır.  
**Nerede kullanılır:** Dosya sonuna kadar, tuş gelene kadar veya iş bitene kadar döndürür.

```uxbasic
LOOP UNTIL tus = "Q"
```
#### WHILE
**Sözdizimi:** `DO WHILE koşul | WHILE koşul ... WEND`  
**Ne işe yarar:** Koşul doğru kaldığı sürece çalışmayı sürdürür.  
**Nerede kullanılır:** Sürekli izleme, kuyruk boşalana kadar çalışma ve oyun döngüsünde kullanılır.

```uxbasic
DO WHILE pil > 20: PRINT pil: pil = pil - 1: LOOP
```
#### UNTIL
**Sözdizimi:** `LOOP UNTIL koşul`  
**Ne işe yarar:** Koşul doğru olunca döngüyü bitirir.  
**Nerede kullanılır:** En az bir kez çalışması gereken sorgularda kullanılır.

```uxbasic
LOOP UNTIL cevap = "EVET"
```
#### EXIT
**Sözdizimi:** `EXIT FOR | EXIT DO | EXIT FUNCTION | EXIT SUB`  
**Ne işe yarar:** İçinde bulunulan döngüden veya yordamdan erken çıkar.  
**Nerede kullanılır:** Gereksiz çalışmayı keser; özellikle arama ve hata durumunda işe yarar.

```uxbasic
IF hata THEN EXIT FOR
```
#### EACH
**Sözdizimi:** `FOR EACH eleman IN liste ... NEXT`  
**Ne işe yarar:** Bir koleksiyonun elemanlarını tek tek dolaşır.  
**Nerede kullanılır:** Liste, sözlük anahtarları ve veri satırları için okunur döngü kurar.

```uxbasic
FOR EACH ad IN isimler: PRINT ad: NEXT
```
#### IN
**Sözdizimi:** `FOR EACH x IN koleksiyon | x IN liste`  
**Ne işe yarar:** Bir elemanın hangi koleksiyondan geleceğini belirtir veya üyelik sınaması yapar.  
**Nerede kullanılır:** Koleksiyonla çalışan modern BASIC yazımını güçlendirir.

```uxbasic
FOR EACH v IN olcumler: PRINT v: NEXT
```
#### RETURN
**Sözdizimi:** `RETURN değer`  
**Ne işe yarar:** Fonksiyondan sonuç döndürür veya alt yordamdan geri döner.  
**Nerede kullanılır:** Hesap sonucunu çağıran yere verir.

```uxbasic
FUNCTION IkiKat(x AS I32) AS I32
  RETURN x*2
END FUNCTION
```
#### GOTO
**Sözdizimi:** `GOTO etiket`  
**Ne işe yarar:** Belirtilen etikete doğrudan atlar.  
**Nerede kullanılır:** Kısa kurtarma veya eski BASIC uyumluluğunda kullanılır; yeni kodda dikkatli kullanılmalıdır.

```uxbasic
GOTO Temizle
```
#### GOSUB
**Sözdizimi:** `GOSUB etiket ... RETURN`  
**Ne işe yarar:** Etikete gider ve RETURN ile geri döner.  
**Nerede kullanılır:** Eski BASIC alt yordam düzenini taşır; büyük kodda SUB daha temizdir.

```uxbasic
GOSUB YazBaslik
```
**Birlikte kullanım örneği — veri sınıflandırma:**
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

### Olay ve eşzamanlılık

Olay ve eşzamanlılık komutları, programın dış dünyadan gelen işaretlere tepki vermesini sağlar. GUI düğmesine basılması, tarayıcıda tıklama, sensörden veri gelmesi, zamanlayıcının dolması veya başka bir işin sonuç üretmesi olaydır. `EVENT` olayın adını koyar, `SLOT` o olaya verilecek tepkiyi taşır, `TRIGGER` olayı elle çalıştırır. `THREAD`, `PARALEL` ve `PIPE` programın tek sıra halinde değil, düzenli iş bölümüyle çalışmasına yardım eder. Burada hayal gücü şöyle gelişir: bir iş veri üretir, boruya koyar; ikinci iş borudan alır, hesaplar; üçüncü iş ekrana veya dosyaya yazar. Bu yapı GUI, tarayıcı, sensör, oyun, sunucu ve uzun hesaplamalarda kullanılır. Genç programcı için püf noktası şudur: eşzamanlı işlerde paylaşılan değişkeni gelişigüzel değiştirme; boru, olay ve kuyruk kullan.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|EVENT|EVENT OlayAdi|Daha sonra tetiklenecek olay adını bildirir.|
|THREAD|THREAD IsAdi ... END THREAD|Ayrı iş parçası olarak çalışacak işi tanımlar.|
|THREAT|THREAT IsAdi ... END THREAT|THREAD için eski/uyumluluk yazımı olarak ele alınır.|
|PARALEL|PARALEL GrupAdi ... END PARALEL|Birden fazla işi paralel görev ailesi olarak düzenler.|
|PIPE|PIPE Ad AS Tip|İki iş arasında veri taşıyan boru tanımlar.|
|SLOT|SLOT Ad ON Olay ... END SLOT|Bir olaya bağlı çalışacak kod yuvasını tanımlar.|
|ON|SLOT Ad ON Olay \| ON ERROR ...|Bir eylemi olaya veya duruma bağlar.|
|OFF|OFF Olay \| OFF SLOT Ad|Olay dinlemeyi veya bağlı tepkiyi kapatır.|
|TRIGGER|TRIGGER OlayAdi[, veri]|Bir olayı elle tetikler.|

#### EVENT
**Sözdizimi:** `EVENT OlayAdi`  
**Ne işe yarar:** Daha sonra tetiklenecek olay adını bildirir.  
**Nerede kullanılır:** GUI düğmesi, tarayıcı tıklaması, seri port verisi, zamanlayıcı ve sensör bildirimi için kullanılır.

```uxbasic
EVENT VeriGeldi
SLOT EkranaYaz ON VeriGeldi
  PRINT "veri geldi"
END SLOT
```
#### THREAD
**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne işe yarar:** Ayrı iş parçası olarak çalışacak işi tanımlar.  
**Nerede kullanılır:** Ekranı dondurmadan dosya okuma, ağ bekleme veya hesap yapma için kullanılır.

```uxbasic
THREAD ArkaPlan
  PRINT "uzun is"
END THREAD
```
#### THREAD ve eski THREAT yazımı
**Sözdizimi:** `THREAD IsAdi ... END THREAD`  
**Ne işe yarar:** Doğru ve yeni yazım `THREAD`tir; eski metinlerde görülen `THREAT` yazımı uyumluluk veya yazım hatası olarak değerlendirilir.  
**Nerede kullanılır:** Yeni programda `THREAD` yazılır. Eski dosya taşınırken `THREAT` görülürse önce anlamı korunur, sonra kaynak temizlenerek `THREAD` yapılır.

```uxbasic
THREAD ArkaPlanTemiz
  PRINT "eski THREAT yazimi temizlendi"
END THREAD
```
#### PARALEL
**Sözdizimi:** `PARALEL GrupAdi ... END PARALEL`  
**Ne işe yarar:** Birden fazla işi paralel görev ailesi olarak düzenler.  
**Nerede kullanılır:** Bağımsız hesaplar, veri dönüştürme ve tarayıcı işleri birlikte ilerlesin diye kullanılır.

```uxbasic
PARALEL Hesaplar
  CALL OrtalamaAl()
  CALL GrafikHazirla()
END PARALEL
```
#### PIPE
**Sözdizimi:** `PIPE Ad AS Tip`  
**Ne işe yarar:** İki iş arasında veri taşıyan boru tanımlar.  
**Nerede kullanılır:** Bir iş veri üretirken diğer işin tüketmesini sağlar.

```uxbasic
PIPE Olcumler AS F64
```
#### SLOT
**Sözdizimi:** `SLOT Ad ON Olay ... END SLOT`  
**Ne işe yarar:** Bir olaya bağlı çalışacak kod yuvasını tanımlar.  
**Nerede kullanılır:** Olay geldiğinde hangi işin yapılacağını gösterir.

```uxbasic
SLOT Kaydet ON VeriGeldi
  PRINT "kaydedildi"
END SLOT
```
#### ON
**Sözdizimi:** `SLOT Ad ON Olay | ON ERROR ...`  
**Ne işe yarar:** Bir eylemi olaya veya duruma bağlar.  
**Nerede kullanılır:** Bağlama cümlesidir; olayı ve tepkiyi birbirine bağlar.

```uxbasic
SLOT Tiklama ON ButonTiklandi
```
#### OFF
**Sözdizimi:** `OFF Olay | OFF SLOT Ad`  
**Ne işe yarar:** Olay dinlemeyi veya bağlı tepkiyi kapatır.  
**Nerede kullanılır:** Geçici durdurma, güvenli kapanış ve kaynak bırakma sırasında kullanılır.

```uxbasic
OFF VeriGeldi
```
#### TRIGGER
**Sözdizimi:** `TRIGGER OlayAdi[, veri]`  
**Ne işe yarar:** Bir olayı elle tetikler.  
**Nerede kullanılır:** Testte, GUI benzetiminde ve donanım gelmiş gibi davranmak istediğinde kullanılır.

```uxbasic
TRIGGER VeriGeldi, 42
```
**Birlikte kullanım örneği — sensör olayını ekrana ve dosyaya bağlama:**
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

### Yordam ve çağrı

Yordam ve çağrı komutları, programı küçük ve tekrar kullanılabilir parçalara böler. `SUB` sonuç döndürmeyen işi, `FUNCTION` sonuç döndüren hesabı taşır. `DECLARE` ve `CALL` ise dış dünyaya açılan kapıdır: Windows DLL, C kütüphanesi, REST köprüsü veya yerel yapay zeka sarmalayıcısı buradan çağrılır. Parametreyi kopya mı göndereceğin (`BYVAL`) yoksa değiştirilebilir adres gibi mi göndereceğin (`BYREF`) çoğu hatanın kaynağıdır. Dış çağrıda çağrı düzeni [fonksiyonun bellekte nasıl çağrıldığı] (calling convention) önemlidir; C tarafında `CDECL`, Windows tarafında çoğu eski API için `STDCALL` görülebilir. İyi genç programcı, her dış çağrıya küçük bir uXBasic fonksiyonu yazar ve programın geri kalanını DLL ayrıntısından korur.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|SUB|SUB Ad(param AS Tip) ... END SUB|Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.|
|FUNCTION|FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION|Değer döndüren hesap veya dönüştürme bloğu tanımlar.|
|DECLARE|DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip|Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.|
|CALL|CALL Ad(argler) \| CALL(DLL,"dll","fonksiyon",argler) \| CALL(API,"ad",argler)|Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.|
|BYREF|param AS BYREF Tip \| BYREF param AS Tip|Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.|
|BYVAL|BYVAL param AS Tip|Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.|
|CDECL|DECLARE CDECL FUNCTION ...|C çağrı düzenini belirtir.|
|STDCALL|DECLARE STDCALL FUNCTION ...|Windows çağrı düzenini belirtir.|

#### SUB
**Sözdizimi:** `SUB Ad(param AS Tip) ... END SUB`  
**Ne işe yarar:** Değer döndürmeyen tekrar kullanılabilir iş bloğu tanımlar.  
**Nerede kullanılır:** Yazdırma, kaydetme, ekran temizleme gibi sonuç döndürmeyen işlerde kullanılır.

```uxbasic
SUB BaslikYaz(): PRINT "RAPOR": END SUB
```
#### FUNCTION
**Sözdizimi:** `FUNCTION Ad(param AS Tip) AS Tip ... RETURN değer ... END FUNCTION`  
**Ne işe yarar:** Değer döndüren hesap veya dönüştürme bloğu tanımlar.  
**Nerede kullanılır:** Hesap, metin işleme, doğrulama ve kütüphane sarmalayıcılarında kullanılır.

```uxbasic
FUNCTION Kare(x AS F64) AS F64
  RETURN x*x
END FUNCTION
```
#### DECLARE
**Sözdizimi:** `DECLARE FUNCTION Ad LIB "dll" ALIAS "gercek_ad" (...) AS Tip`  
**Ne işe yarar:** Dış kütüphane fonksiyonunun uXBasic tarafındaki imzasını bildirir.  
**Nerede kullanılır:** DLL/API çağırmadan önce ad, parametre ve dönüş tipini netleştirir.

```uxbasic
DECLARE FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (BYVAL hwnd AS PTR, BYVAL text AS STRING, BYVAL title AS STRING, BYVAL tip AS I32) AS I32
```
#### CALL
**Sözdizimi:** `CALL Ad(argler) | CALL(DLL,"dll","fonksiyon",argler) | CALL(API,"ad",argler)`  
**Ne işe yarar:** Tanımlı yordamı, dış DLL fonksiyonunu veya API çağrısını çalıştırır.  
**Nerede kullanılır:** uXBasic’in çekirdeğini büyütmeden dış dünyaya açılma kapısıdır.

```uxbasic
CALL BaslikYaz()
```
#### BYREF
**Sözdizimi:** `param AS BYREF Tip | BYREF param AS Tip`  
**Ne işe yarar:** Parametrenin kendisini gönderir; fonksiyon değeri değiştirebilir.  
**Nerede kullanılır:** Dış kütüphane dönüş tamponları ve hızlı veri güncellemede kullanılır.

```uxbasic
SUB Artir(BYREF x AS I32): x = x + 1: END SUB
```
#### BYVAL
**Sözdizimi:** `BYVAL param AS Tip`  
**Ne işe yarar:** Parametrenin kopyasını gönderir; çağıranın değişkeni etkilenmez.  
**Nerede kullanılır:** DLL imzalarında ve güvenli çağrılarda önemlidir.

```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
```
#### CDECL
**Sözdizimi:** `DECLARE CDECL FUNCTION ...`  
**Ne işe yarar:** C çağrı düzenini belirtir.  
**Nerede kullanılır:** C/C++ kütüphanesiyle uyum için kullanılır.

```uxbasic
DECLARE CDECL FUNCTION sin LIB "msvcrt.dll" ALIAS "sin" (BYVAL x AS F64) AS F64
```
#### STDCALL
**Sözdizimi:** `DECLARE STDCALL FUNCTION ...`  
**Ne işe yarar:** Windows çağrı düzenini belirtir.  
**Nerede kullanılır:** Windows API tarafında sık kullanılır.

```uxbasic
DECLARE STDCALL FUNCTION MessageBox LIB "user32.dll" ALIAS "MessageBoxA" (...) AS I32
```
**Birlikte kullanım örneği — DLL çağrısını güvenli sarmalama:**
```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
  IF hz < 37 THEN RETURN FALSE
  sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
  IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE END IF
END FUNCTION
IF UyariSesi(880, 150) THEN PRINT "ses verildi" ELSE PRINT "ses hatasi" END IF
```

### Nesne ve tip bildirimi

Nesne ve tip bildirimi komutları büyük projede düzen kurar. `TYPE` yalnız veri alanlarını toplarken, `CLASS` veriyle davranışı aynı çatıya alır. `INTERFACE` sözleşme kurar: bu sınıf şu işleri yapmayı vaat eder. `PUBLIC`, `PRIVATE`, `PROTECTED` gibi erişim sözcükleri kimin neyi görebileceğini anlatır. `CONSTRUCTOR` nesne doğarken, `DESTRUCTOR` nesne giderken çalışır. `VIRTUAL` ve `OVERRIDE` aynı işin farklı sınıflarda farklı yapılmasını sağlar. Genç programcı için akıllı hile şudur: önce TYPE ile sade veri modelini kur, sonra gerçekten davranış gerekiyorsa CLASS'a geç; her şeyi sınıf yapma, ama sınıfsız da büyük sistem yazmaya çalışma.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|TYPE|TYPE Ad ... END TYPE|Kayıt biçiminde veri alanları toplar.|
|CLASS|CLASS Ad ... END CLASS|Veri ve davranışı aynı nesne kalıbında toplar.|
|INTERFACE|INTERFACE Ad ... END INTERFACE|Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.|
|IMPLEMENTS|CLASS Ad IMPLEMENTS Arayuz|Sınıfın arayüz sözleşmesini üstlendiğini belirtir.|
|METHOD|METHOD Ad(...) AS Tip|Sınıf içindeki işlevi tanımlar.|
|SIHIRLIMETOT|SIHIRLIMETOT Ad(...)|Özel davranışlı sihirli yöntem tanımlar.|
|MAGIC|MAGIC Ad(...)|Sihirli yöntem için kısa/alternatif yazım sağlar.|
|VIRTUAL|VIRTUAL METHOD Ad(...)|Alt sınıfın değiştirebileceği yöntem bildirir.|
|OVERRIDE|OVERRIDE METHOD Ad(...)|Üst sınıftaki yöntemi bilinçli olarak değiştirir.|
|CONSTRUCTOR|CONSTRUCTOR(...)|Nesne oluşurken çalışan kurucu bölümdür.|
|DESTRUCTOR|DESTRUCTOR()|Nesne yok olurken temizlik yapar.|
|NEW|NEW Sinif(argler)|Yeni nesne oluşturur.|
|DELETE|DELETE nesne|Nesne/ayrılmış kaynağı bırakır.|
|ABSTRACT|ABSTRACT CLASS Ad|Doğrudan üretilmeyen temel sınıf tanımlar.|
|FINAL|FINAL CLASS Ad \| FINAL METHOD Ad|Daha fazla miras/değiştirme yapılmasını engeller.|
|SEALED|SEALED CLASS Ad|Kapatılmış sınıf bildirir.|
|STATIC|STATIC alan AS Tip \| STATIC METHOD Ad|Sınıfa ait tek ortak alan/yöntem tanımlar.|
|PROPERTY|PROPERTY Ad AS Tip|Nesne alanını kontrollü özellik olarak tanımlar.|
|OPERATOR|OPERATOR +(a,b)|Sınıf için işlemci davranışı tanımlar.|
|MIXIN|MIXIN Ad|Bir sınıfa ek davranış karışımı ekler.|
|DECORATOR|DECORATOR Ad|Yordam/sınıf etrafına ek davranış sarar.|
|PUBLIC|PUBLIC ad|Dışarıdan erişilebilir üye bildirir.|
|PRIVATE|PRIVATE ad|Sadece kendi sınıf/modülü içinden erişilir.|
|PROTECTED|PROTECTED ad|Kendi sınıfı ve alt sınıflar erişir.|
|RESTRICTED|RESTRICTED ad|Daraltılmış erişim kuralı belirtir.|
|FRIEND|FRIEND MODULE Ad|Belirli modül/sınıfa özel erişim verir.|
|READONLY|READONLY ad AS Tip|Dışarıdan değiştirilemeyen okuma alanı bildirir.|
|MUTABLE|MUTABLE ad AS Tip|Normalde sabit bağlamda bile değişebilir alan belirtir.|
|IMMUTABLE|IMMUTABLE ad AS Tip|Değişmez veri/nesne niyeti belirtir.|

#### TYPE
**Sözdizimi:** `TYPE Ad ... END TYPE`  
**Ne işe yarar:** Kayıt biçiminde veri alanları toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
TYPE Nokta
  x AS F64
  y AS F64
END TYPE
```
#### CLASS
**Sözdizimi:** `CLASS Ad ... END CLASS`  
**Ne işe yarar:** Veri ve davranışı aynı nesne kalıbında toplar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CLASS Sensor
  PROPERTY Deger AS F64
END CLASS
```
#### INTERFACE
**Sözdizimi:** `INTERFACE Ad ... END INTERFACE`  
**Ne işe yarar:** Bir sınıfın yerine getireceği yöntem sözleşmesini tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
INTERFACE Okunur
  METHOD Oku() AS F64
END INTERFACE
```
#### IMPLEMENTS
**Sözdizimi:** `CLASS Ad IMPLEMENTS Arayuz`  
**Ne işe yarar:** Sınıfın arayüz sözleşmesini üstlendiğini belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CLASS Sensor IMPLEMENTS Okunur
```
#### METHOD
**Sözdizimi:** `METHOD Ad(...) AS Tip`  
**Ne işe yarar:** Sınıf içindeki işlevi tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
METHOD Oku() AS F64: RETURN Deger: END METHOD
```
#### MAGIC ve eski SIHIRLIMETOT yazımı
**Sözdizimi:** `SIHIRLIMETOT Ad(...)`  
**Ne işe yarar:** Özel davranışlı sihirli yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
SIHIRLIMETOT __str__() AS STRING
```
#### MAGIC
**Sözdizimi:** `MAGIC Ad(...)`  
**Ne işe yarar:** Sihirli yöntem için kısa/alternatif yazım sağlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MAGIC ToString() AS STRING
```
#### VIRTUAL
**Sözdizimi:** `VIRTUAL METHOD Ad(...)`  
**Ne işe yarar:** Alt sınıfın değiştirebileceği yöntem bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
VIRTUAL METHOD Ciz()
```
#### OVERRIDE
**Sözdizimi:** `OVERRIDE METHOD Ad(...)`  
**Ne işe yarar:** Üst sınıftaki yöntemi bilinçli olarak değiştirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
OVERRIDE METHOD Ciz()
```
#### CONSTRUCTOR
**Sözdizimi:** `CONSTRUCTOR(...)`  
**Ne işe yarar:** Nesne oluşurken çalışan kurucu bölümdür.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
CONSTRUCTOR(v AS F64): Deger=v: END CONSTRUCTOR
```
#### DESTRUCTOR
**Sözdizimi:** `DESTRUCTOR()`  
**Ne işe yarar:** Nesne yok olurken temizlik yapar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DESTRUCTOR(): PRINT "kapanis": END DESTRUCTOR
```
#### NEW
**Sözdizimi:** `NEW Sinif(argler)`  
**Ne işe yarar:** Yeni nesne oluşturur.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DIM s AS Sensor = NEW Sensor(12.5)
```
#### DELETE
**Sözdizimi:** `DELETE nesne`  
**Ne işe yarar:** Nesne/ayrılmış kaynağı bırakır.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DELETE s
```
#### ABSTRACT
**Sözdizimi:** `ABSTRACT CLASS Ad`  
**Ne işe yarar:** Doğrudan üretilmeyen temel sınıf tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
ABSTRACT CLASS Sekil
```
#### FINAL
**Sözdizimi:** `FINAL CLASS Ad | FINAL METHOD Ad`  
**Ne işe yarar:** Daha fazla miras/değiştirme yapılmasını engeller.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
FINAL METHOD Kimlik() AS STRING
```
#### SEALED
**Sözdizimi:** `SEALED CLASS Ad`  
**Ne işe yarar:** Kapatılmış sınıf bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
SEALED CLASS Ayar
```
#### STATIC
**Sözdizimi:** `STATIC alan AS Tip | STATIC METHOD Ad`  
**Ne işe yarar:** Sınıfa ait tek ortak alan/yöntem tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
STATIC Sayac AS I32
```
#### PROPERTY
**Sözdizimi:** `PROPERTY Ad AS Tip`  
**Ne işe yarar:** Nesne alanını kontrollü özellik olarak tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PROPERTY Ad AS STRING
```
#### OPERATOR
**Sözdizimi:** `OPERATOR +(a,b)`  
**Ne işe yarar:** Sınıf için işlemci davranışı tanımlar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
OPERATOR +(a AS Vektor, b AS Vektor)
```
#### MIXIN
**Sözdizimi:** `MIXIN Ad`  
**Ne işe yarar:** Bir sınıfa ek davranış karışımı ekler.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MIXIN Loglanabilir
```
#### DECORATOR
**Sözdizimi:** `DECORATOR Ad`  
**Ne işe yarar:** Yordam/sınıf etrafına ek davranış sarar.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
DECORATOR ZamanOlc
```
#### PUBLIC
**Sözdizimi:** `PUBLIC ad`  
**Ne işe yarar:** Dışarıdan erişilebilir üye bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PUBLIC METHOD Oku()
```
#### PRIVATE
**Sözdizimi:** `PRIVATE ad`  
**Ne işe yarar:** Sadece kendi sınıf/modülü içinden erişilir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PRIVATE hamDeger AS F64
```
#### PROTECTED
**Sözdizimi:** `PROTECTED ad`  
**Ne işe yarar:** Kendi sınıfı ve alt sınıflar erişir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
PROTECTED id AS I32
```
#### RESTRICTED
**Sözdizimi:** `RESTRICTED ad`  
**Ne işe yarar:** Daraltılmış erişim kuralı belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
RESTRICTED token AS STRING
```
#### FRIEND
**Sözdizimi:** `FRIEND MODULE Ad`  
**Ne işe yarar:** Belirli modül/sınıfa özel erişim verir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
FRIEND MODULE Testler
```
#### READONLY
**Sözdizimi:** `READONLY ad AS Tip`  
**Ne işe yarar:** Dışarıdan değiştirilemeyen okuma alanı bildirir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
READONLY Id AS I64
```
#### MUTABLE
**Sözdizimi:** `MUTABLE ad AS Tip`  
**Ne işe yarar:** Normalde sabit bağlamda bile değişebilir alan belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
MUTABLE Cache AS DICT
```
#### IMMUTABLE
**Sözdizimi:** `IMMUTABLE ad AS Tip`  
**Ne işe yarar:** Değişmez veri/nesne niyeti belirtir.  
**Nerede kullanılır:** Büyük projede veri ile o verinin davranışını birlikte tutmak için kullanılır.

```uxbasic
IMMUTABLE Ayar AS STRING
```
**Birlikte kullanım örneği — ölçüm nesnesi:**
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

### Değişken ve bellek

Değişken ve bellek komutları verinin adını, tipini ve yerini belirler. `DIM` bir kutu açar, `AS` kutunun türünü söyler, `CONST` değişmeyecek değeri korur, `REDIM` büyüyen diziye yeni yer açar. İyi programda değişken adı, ne tuttuğunu anlatır; `x` yerine `phDegeri`, `toplamAgirlik`, `satirSayisi` yazmak hatayı azaltır. Tip sınırı önemlidir: 0-255 arası için `U8`, günlük sayaç için `I32`, çok büyük dosya sayacı için `I64`, bilimsel ölçüm için `F64`, yüksek duyarlık için `BIGD` veya `BIGF` seçilir. Genç programcı erken öğrenmelidir: yanlış tip seçimi bazen hata vermez, sessizce yanlış sonuç üretir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DIM|DIM ad AS Tip|Yeni değişken, dizi veya nesne başvurusu bildirir.|
|REDIM|REDIM dizi(yeniBoyut)|Diziyi yeni boyuta taşır.|
|AS|ad AS Tip|Bir adın tipini belirtir.|
|CONST|CONST ad AS Tip = değer|Değişmeyen sabit tanımlar.|

#### DIM
**Sözdizimi:** `DIM ad AS Tip`  
**Ne işe yarar:** Yeni değişken, dizi veya nesne başvurusu bildirir.  
**Nerede kullanılır:** Her veri işi DIM ile başlar; ad, tip ve bellek düzeni görünür olur.

```uxbasic
DIM toplam AS F64
toplam = 0
```
#### REDIM
**Sözdizimi:** `REDIM dizi(yeniBoyut)`  
**Ne işe yarar:** Diziyi yeni boyuta taşır.  
**Nerede kullanılır:** Önceden eleman sayısı bilinmeyen veri girişlerinde kullanılır.

```uxbasic
REDIM olcum(100)
```
#### AS
**Sözdizimi:** `ad AS Tip`  
**Ne işe yarar:** Bir adın tipini belirtir.  
**Nerede kullanılır:** Okunurluk ve dış çağrı uyumu için kullanılır.

```uxbasic
DIM yas AS I32
```
#### CONST
**Sözdizimi:** `CONST ad AS Tip = değer`  
**Ne işe yarar:** Değişmeyen sabit tanımlar.  
**Nerede kullanılır:** Ayar, sınır ve fiziksel sabitlerde kullanılır.

```uxbasic
CONST PI AS F64 = 3.14159265
```
**Birlikte kullanım örneği — tip sınırı ve doğru değişken seçimi:**
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

### Tipler

Tip sözcükleri değişkenin içinde hangi tür veri tutulacağını belirler. Tam sayılar sayaç ve indeks için, ondalıklı sayılar ölçüm ve hesap için, metin tipi rapor ve kullanıcı girdisi için, koleksiyon tipleri çoklu veri için kullanılır. `PTR` ve `STRPTR` gibi işaretçi tipleri dış kütüphaneye bellek adresi vermek içindir; aceleyle kullanılmaz. `BIGF`, `BIGD`, `BALL`, `F80`, `F128` yüksek duyarlık ve özel matematik için düşünülür. Tip seçimi yalnız bellek konusu değildir; aynı zamanda niyet beyanıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|BYTE|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|I8|DIM ad AS I8|-128 ile 127 arasında işaretli 8 bit tam sayı tutar.|
|U8|DIM ad AS U8|0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.|
|I16|DIM ad AS I16|işaretli 16 bit tam sayı tutar.|
|U16|DIM ad AS U16|işaretsiz 16 bit tam sayı tutar.|
|I32|DIM ad AS I32|günlük sayaç ve indeksler için 32 bit tam sayı tutar.|
|U32|DIM ad AS U32|negatif olmayan 32 bit sayı tutar.|
|I64|DIM ad AS I64|büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.|
|U64|DIM ad AS U64|çok büyük pozitif sayaçlar için 64 bit sayı tutar.|
|F32|DIM ad AS F32|tek duyarlıklı ondalıklı sayı tutar.|
|F64|DIM ad AS F64|çift duyarlıklı ondalıklı sayı tutar.|
|F80|DIM ad AS F80|genişletilmiş kayan nokta sayı tutar.|
|F128|DIM ad AS F128|128 bit yüksek duyarlıklı sayı tutar.|
|BIGF|DIM ad AS BIGF|çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.|
|BIGD|DIM ad AS BIGD|çok basamaklı ondalık sayı ailesidir.|
|BALL|DIM ad AS BALL|aralık/top mantığıyla güvenli yaklaşık sayı tutar.|
|BOOLEAN|DIM ad AS BOOLEAN|TRUE/FALSE doğru-yanlış değeri tutar.|
|STRING|DIM ad AS STRING|metin tutar.|
|OBJECT|DIM ad AS OBJECT|nesne başvurusu tutar.|
|PTR|DIM ad AS PTR|ham adres veya dış kütüphane işaretçisi tutar.|
|STRPTR|DIM ad AS STRPTR|metnin bellek adresini dış çağrıya verir.|
|ARRAY|DIM ad AS ARRAY|sabit veya yeniden boyutlanabilir dizi tutar.|
|LIST|DIM ad AS LIST|sıralı, büyüyebilen liste tutar.|
|DICT|DIM ad AS DICT|anahtar/değer sözlüğü tutar.|
|SET|DIM ad AS SET|tekrarsız küme tutar.|

#### BYTE
**Sözdizimi:** `DIM ad AS BYTE`  
**Ne işe yarar:** tek baytlık ham veri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BYTE
PRINT deger
```
#### I8
**Sözdizimi:** `DIM ad AS I8`  
**Ne işe yarar:** -128 ile 127 arasında işaretli 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I8
PRINT deger
```
#### U8
**Sözdizimi:** `DIM ad AS U8`  
**Ne işe yarar:** 0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U8
PRINT deger
```
#### I16
**Sözdizimi:** `DIM ad AS I16`  
**Ne işe yarar:** işaretli 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I16
PRINT deger
```
#### U16
**Sözdizimi:** `DIM ad AS U16`  
**Ne işe yarar:** işaretsiz 16 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U16
PRINT deger
```
#### I32
**Sözdizimi:** `DIM ad AS I32`  
**Ne işe yarar:** günlük sayaç ve indeksler için 32 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I32
PRINT deger
```
#### U32
**Sözdizimi:** `DIM ad AS U32`  
**Ne işe yarar:** negatif olmayan 32 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U32
PRINT deger
```
#### I64
**Sözdizimi:** `DIM ad AS I64`  
**Ne işe yarar:** büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS I64
PRINT deger
```
#### U64
**Sözdizimi:** `DIM ad AS U64`  
**Ne işe yarar:** çok büyük pozitif sayaçlar için 64 bit sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS U64
PRINT deger
```
#### F32
**Sözdizimi:** `DIM ad AS F32`  
**Ne işe yarar:** tek duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F32
PRINT deger
```
#### F64
**Sözdizimi:** `DIM ad AS F64`  
**Ne işe yarar:** çift duyarlıklı ondalıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F64
PRINT deger
```
#### F80
**Sözdizimi:** `DIM ad AS F80`  
**Ne işe yarar:** genişletilmiş kayan nokta sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F80
PRINT deger
```
#### F128
**Sözdizimi:** `DIM ad AS F128`  
**Ne işe yarar:** 128 bit yüksek duyarlıklı sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS F128
PRINT deger
```
#### BIGF
**Sözdizimi:** `DIM ad AS BIGF`  
**Ne işe yarar:** çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BIGF
PRINT deger
```
#### BIGD
**Sözdizimi:** `DIM ad AS BIGD`  
**Ne işe yarar:** çok basamaklı ondalık sayı ailesidir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BIGD
PRINT deger
```
#### BALL
**Sözdizimi:** `DIM ad AS BALL`  
**Ne işe yarar:** aralık/top mantığıyla güvenli yaklaşık sayı tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BALL
PRINT deger
```
#### BOOLEAN
**Sözdizimi:** `DIM ad AS BOOLEAN`  
**Ne işe yarar:** TRUE/FALSE doğru-yanlış değeri tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS BOOLEAN
PRINT deger
```
#### STRING
**Sözdizimi:** `DIM ad AS STRING`  
**Ne işe yarar:** metin tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS STRING
PRINT deger
```
#### OBJECT
**Sözdizimi:** `DIM ad AS OBJECT`  
**Ne işe yarar:** nesne başvurusu tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS OBJECT
PRINT deger
```
#### PTR
**Sözdizimi:** `DIM ad AS PTR`  
**Ne işe yarar:** ham adres veya dış kütüphane işaretçisi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS PTR
PRINT deger
```
#### STRPTR
**Sözdizimi:** `DIM ad AS STRPTR`  
**Ne işe yarar:** metnin bellek adresini dış çağrıya verir.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS STRPTR
PRINT deger
```
#### ARRAY
**Sözdizimi:** `DIM ad AS ARRAY`  
**Ne işe yarar:** sabit veya yeniden boyutlanabilir dizi tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS ARRAY
PRINT deger
```
#### LIST
**Sözdizimi:** `DIM ad AS LIST`  
**Ne işe yarar:** sıralı, büyüyebilen liste tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS LIST
PRINT deger
```
#### DICT
**Sözdizimi:** `DIM ad AS DICT`  
**Ne işe yarar:** anahtar/değer sözlüğü tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS DICT
PRINT deger
```
#### SET
**Sözdizimi:** `DIM ad AS SET`  
**Ne işe yarar:** tekrarsız küme tutar.  
**Nerede kullanılır:** Değişken bildirirken, dış çağrı imzası yazarken ve veri yapısının eleman tipini seçerken kullanılır.

```uxbasic
DIM deger AS SET
PRINT deger
```
**Birlikte kullanım örneği — tip sınırı ve doğru değişken seçimi:**
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

### Varsayılan tip

Varsayılan tip komutları eski BASIC geleneğinden gelir. Harf aralığına göre değişken tipi seçer. Modern uXBasic kodunda açık `DIM ad AS Tip` daha okunur ve güvenlidir. Yine de eski kaynakları taşırken veya kısa deneme yazarken bu komutlar işe yarar. Genç programcı bunları tanımalı ama büyük projede açık tip yazmayı alışkanlık yapmalıdır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|DEFINT|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|DEFLNG|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|DEFSNG|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|DEFDBL|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|DEFEXT|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|DEFSTR|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|DEFBYT|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|

#### DEFINT
**Sözdizimi:** `DEFINT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFINT A-Z
DIM sayac
```
#### DEFLNG
**Sözdizimi:** `DEFLNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri I64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFLNG A-Z
DIM sayac
```
#### DEFSNG
**Sözdizimi:** `DEFSNG A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F32 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFSNG A-Z
DIM sayac
```
#### DEFDBL
**Sözdizimi:** `DEFDBL A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri F64 yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFDBL A-Z
DIM sayac
```
#### DEFEXT
**Sözdizimi:** `DEFEXT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri geniş ondalık yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFEXT A-Z
DIM sayac
```
#### DEFSTR
**Sözdizimi:** `DEFSTR A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri STRING yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFSTR A-Z
DIM sayac
```
#### DEFBYT
**Sözdizimi:** `DEFBYT A-Z`  
**Ne işe yarar:** harfle başlayan adsız tipleri BYTE yapar  
**Nerede kullanılır:** Eski BASIC tarzı kısa değişken adlarında tip varsayımı için kullanılır; yeni kodda açık AS daha güvenlidir.

```uxbasic
DEFBYT A-Z
DIM sayac
```

### Modül ve kaynak

Modül ve kaynak komutları büyük projeyi dosyalara böler. `INCLUDE` hazır başlık ve modül yüzeyini içeri alır, `IMPORT` C/C++/ASM kaynaklarını derleme işine bağlar, `NAMESPACE` ve `MODULE` ad karmaşasını önler. `USING` uzun adları kısa kullanmayı sağlar, `ALIAS` okunur adlar kurar. `INLINE` küçük dış dil parçalarını kaynak içinde taşır; ama büyük dış kod ayrı dosyada ve `IMPORT` ile daha temizdir. Genç programcı için kural: bir dosya çok uzadıysa önce modüle böl; aynı adlar çakışmaya başladıysa ad alanı aç; dış kütüphane çağrısı çirkinleştiyse sarmalayıcı yaz.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|INCLUDE|INCLUDE "dosya.uxbh"|Başka uXBasic başlık/destek dosyasını kaynak içine katar.|
|IMPORT|IMPORT(C,"dosya.c") \| IMPORT(CPP,"dosya.cpp") \| IMPORT(ASM,"dosya.asm")|Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.|
|MAIN|MAIN ... END MAIN|Programın ana giriş bölümünü belirtir.|
|NAMESPACE|NAMESPACE Ad ... END NAMESPACE|Adları çakışmadan ayıran alan açar.|
|MODULE|MODULE Ad ... END MODULE|Bir dosya veya iş ailesini modül olarak toplar.|
|USING|USING MODULE Ad \| USING NAMESPACE Ad|Bir modül/alan adını kısa kullanım için etkinleştirir.|
|ALIAS|ALIAS yeniAd = eskiAd \| ALIAS KISA AS uzunAd|Uzun çağrıya kısa veya yerel ad verir.|
|INLINE|INLINE C ... END INLINE \| INLINE ASM ... END INLINE|uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.|

#### INCLUDE
**Sözdizimi:** `INCLUDE "dosya.uxbh"`  
**Ne işe yarar:** Başka uXBasic başlık/destek dosyasını kaynak içine katar.  
**Nerede kullanılır:** Ortak yordamları, kütüphane imzalarını ve tip tanımlarını paylaşmak için kullanılır.

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
```
#### IMPORT
**Sözdizimi:** `IMPORT(C,"dosya.c") | IMPORT(CPP,"dosya.cpp") | IMPORT(ASM,"dosya.asm")`  
**Ne işe yarar:** Derleme zamanında C, C++ veya ASM kaynak dosyasını projeye bağlar.  
**Nerede kullanılır:** DLL değil kaynak ekleme işidir; dış çalışma zamanı ile çekirdeği büyütmeden güç verir.

```uxbasic
IMPORT(C,"runtime/hizli.c")
```
#### MAIN
**Sözdizimi:** `MAIN ... END MAIN`  
**Ne işe yarar:** Programın ana giriş bölümünü belirtir.  
**Nerede kullanılır:** Büyük projede nereden başlanacağını görünür yapar.

```uxbasic
MAIN
  PRINT "basladi"
END MAIN
```
#### NAMESPACE
**Sözdizimi:** `NAMESPACE Ad ... END NAMESPACE`  
**Ne işe yarar:** Adları çakışmadan ayıran alan açar.  
**Nerede kullanılır:** Aynı isimli fonksiyonları farklı alanlarda tutar.

```uxbasic
NAMESPACE Lab
  SUB Yaz(): PRINT "lab": END SUB
END NAMESPACE
```
#### MODULE
**Sözdizimi:** `MODULE Ad ... END MODULE`  
**Ne işe yarar:** Bir dosya veya iş ailesini modül olarak toplar.  
**Nerede kullanılır:** Kütüphane, araç ve büyük uygulama parçalarında kullanılır.

```uxbasic
MODULE Rapor
  SUB Baslik(): PRINT "RAPOR": END SUB
END MODULE
```
#### USING
**Sözdizimi:** `USING MODULE Ad | USING NAMESPACE Ad`  
**Ne işe yarar:** Bir modül/alan adını kısa kullanım için etkinleştirir.  
**Nerede kullanılır:** Sürekli uzun ad yazmayı azaltır; ama çakışma varsa tam ad kullanılır.

```uxbasic
USING MODULE uxstats
```
#### ALIAS
**Sözdizimi:** `ALIAS yeniAd = eskiAd | ALIAS KISA AS uzunAd`  
**Ne işe yarar:** Uzun çağrıya kısa veya yerel ad verir.  
**Nerede kullanılır:** Okunabilirlik ve dış kütüphane sarmalama için kullanılır.

```uxbasic
ALIAS ORT AS uxstats.mean
```
#### INLINE
**Sözdizimi:** `INLINE C ... END INLINE | INLINE ASM ... END INLINE`  
**Ne işe yarar:** uXBasic dosyası içinde küçük C/C++/ASM bölümü taşır.  
**Nerede kullanılır:** Kısa ve özel hızlandırma parçaları için kullanılır.

```uxbasic
INLINE C
  int hizli(int x){return x*x;}
END INLINE
```
**Birlikte kullanım örneği — modül ve dış kaynak düzeni:**
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

### Girdi çıktı ve ekran

Girdi çıktı komutları programın insanla, dosyayla ve terminalle konuşmasını sağlar. `PRINT` yalnız ekrana yazmaz; dosyaya rapor da yazabilir. `INPUT` kullanıcıdan veya dosyadan veri alır. `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK` dosya işlerinin temelidir. `CLS`, `COLOR`, `LOCATE` terminal arayüzünü düzenler. Programlamayı yeni öğrenen biri için dosya işlemleri çok öğreticidir; çünkü veri dışarıdan gelir, satır satır okunur, kontrol edilir, sonuç rapora yazılır. Her açılan dosyayı kapatmak, her okunan değeri doğrulamak ve her hatayı kullanıcıya anlaşılır söylemek gerekir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|PRINT|PRINT ifade[, ifade] \| PRINT #dosya, ifade|Ekrana veya dosyaya metin/sayı yazar.|
|INPUT|INPUT değişken \| INPUT #dosya, değişken|Kullanıcıdan veya dosyadan veri okur.|
|OPEN|OPEN "dosya" FOR INPUT\|OUTPUT\|APPEND AS #no|Dosyayı okuma/yazma/ekleme için açar.|
|CLOSE|CLOSE #no|Açık dosyayı kapatır.|
|GET|GET #no, konum, değişken|Dosyadan ham veri okur.|
|PUT|PUT #no, konum, değişken|Dosyaya ham veri yazar.|
|SEEK|SEEK #no, konum|Dosya okuma/yazma konumunu değiştirir.|
|CLS|CLS|Ekranı temizler.|
|COLOR|COLOR ön[, arka]|Yazı/arka plan rengini ayarlar.|
|LOCATE|LOCATE satır, sütun|Ekran imlecini konuma taşır.|

#### PRINT
**Sözdizimi:** `PRINT ifade[, ifade] | PRINT #dosya, ifade`  
**Ne işe yarar:** Ekrana veya dosyaya metin/sayı yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
PRINT "sonuc="; toplam
```
#### INPUT
**Sözdizimi:** `INPUT değişken | INPUT #dosya, değişken`  
**Ne işe yarar:** Kullanıcıdan veya dosyadan veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
INPUT yas
```
#### OPEN
**Sözdizimi:** `OPEN "dosya" FOR INPUT|OUTPUT|APPEND AS #no`  
**Ne işe yarar:** Dosyayı okuma/yazma/ekleme için açar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
OPEN "rapor.txt" FOR OUTPUT AS #1
```
#### CLOSE
**Sözdizimi:** `CLOSE #no`  
**Ne işe yarar:** Açık dosyayı kapatır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
CLOSE #1
```
#### GET
**Sözdizimi:** `GET #no, konum, değişken`  
**Ne işe yarar:** Dosyadan ham veri okur.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
GET #1, 1, b
```
#### PUT
**Sözdizimi:** `PUT #no, konum, değişken`  
**Ne işe yarar:** Dosyaya ham veri yazar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
PUT #1, 1, b
```
#### SEEK
**Sözdizimi:** `SEEK #no, konum`  
**Ne işe yarar:** Dosya okuma/yazma konumunu değiştirir.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
SEEK #1, 128
```
#### CLS
**Sözdizimi:** `CLS`  
**Ne işe yarar:** Ekranı temizler.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
CLS
```
#### COLOR
**Sözdizimi:** `COLOR ön[, arka]`  
**Ne işe yarar:** Yazı/arka plan rengini ayarlar.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
COLOR 10,0
```
#### LOCATE
**Sözdizimi:** `LOCATE satır, sütun`  
**Ne işe yarar:** Ekran imlecini konuma taşır.  
**Nerede kullanılır:** Dosya, terminal ekranı, günlük ve kullanıcı etkileşimi kurarken kullanılır.

```uxbasic
LOCATE 5,10: PRINT "menu"
```
**Birlikte kullanım örneği — belge oluşturma:**
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

### İşleç

İşleçler küçük görünür ama programın karar ve hesap kaslarıdır. `AND`, `OR`, `NOT` koşul birleştirir; `XOR` özel fark mantığı verir; `MOD` kalan hesabı yapar; `SHL`, `SHR`, `ROL`, `ROR` bit düzeyinde hızlı iş yapar. Genç programcı önce koşul işleçlerini öğrenmeli, sonra bit işleçlerine geçmelidir. Bit işleçleri bayrak, renk, donanım, sıkıştırma ve hızlı maske işlerinde işe yarar. Püf noktası: karmaşık koşulu tek satıra gömme; ara değişkenle adlandır, sonra IF içinde oku.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|AND|a AND b|iki koşul/bit birlikte doğruysa doğru verir|
|OR|a OR b|koşullardan biri doğruysa doğru verir|
|NOT|NOT koşul|koşulu tersine çevirir|
|XOR|a XOR b|yalnız biri doğruysa doğru verir veya bitlerde özel fark alır|
|MOD|a MOD b|bölme kalanı verir|
|SHL|a SHL b|bitleri sola kaydırır|
|SHR|a SHR b|bitleri sağa kaydırır|
|ROL|a ROL b|bitleri döndürerek sola kaydırır|
|ROR|a ROR b|bitleri döndürerek sağa kaydırır|

#### AND
**Sözdizimi:** `a AND b`  
**Ne işe yarar:** iki koşul/bit birlikte doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) AND TRUE THEN PRINT "kontrol"
```
#### OR
**Sözdizimi:** `a OR b`  
**Ne işe yarar:** koşullardan biri doğruysa doğru verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) OR TRUE THEN PRINT "kontrol"
```
#### NOT
**Sözdizimi:** `NOT koşul`  
**Ne işe yarar:** koşulu tersine çevirir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) AND TRUE THEN PRINT "kontrol"
```
#### XOR
**Sözdizimi:** `a XOR b`  
**Ne işe yarar:** yalnız biri doğruysa doğru verir veya bitlerde özel fark alır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) XOR TRUE THEN PRINT "kontrol"
```
#### MOD
**Sözdizimi:** `a MOD b`  
**Ne işe yarar:** bölme kalanı verir  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) MOD TRUE THEN PRINT "kontrol"
```
#### SHL
**Sözdizimi:** `a SHL b`  
**Ne işe yarar:** bitleri sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) SHL TRUE THEN PRINT "kontrol"
```
#### SHR
**Sözdizimi:** `a SHR b`  
**Ne işe yarar:** bitleri sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) SHR TRUE THEN PRINT "kontrol"
```
#### ROL
**Sözdizimi:** `a ROL b`  
**Ne işe yarar:** bitleri döndürerek sola kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) ROL TRUE THEN PRINT "kontrol"
```
#### ROR
**Sözdizimi:** `a ROR b`  
**Ne işe yarar:** bitleri döndürerek sağa kaydırır  
**Nerede kullanılır:** Koşul, maske, bayrak, düşük seviye kod ve hızlı hesap işlerinde kullanılır.

```uxbasic
IF (yas > 18) ROR TRUE THEN PRINT "kontrol"
```
**Birlikte kullanım örneği — bayrak ve koşul:**
```uxbasic
DIM yetki AS U32
yetki = 1 SHL 2
IF (yetki AND 4) <> 0 THEN PRINT "yazma izni var"
IF NOT (yetki = 0) THEN PRINT "en az bir izin var"
PRINT 17 MOD 5
```

### Yerel fonksiyon

Yerel fonksiyonlar küçük yardımcı makinelerdir. Metni parçalar, sayıyı dönüştürür, zamanı ölçer, dosya sonunu denetler, tuş okur, bellek adresi verir veya matematik hesaplar. Bunları tek tek ezberlemek yerine ailelere ayır: metin ailesi, sayı ailesi, trigonometri ailesi, dosya ailesi, klavye ailesi, bellek adresi ailesi. Genç programcı `VAL` ve `STR` ile veri dönüşümünü, `LEN` ve `MID` ile metin parçalamayı, `TIMER` ile hız ölçmeyi, `EOF` ile güvenli dosya döngüsünü erken öğrenmelidir. Fonksiyon sonucu her zaman bir değişkene alınabilir; böylece hata ayıklamak kolaylaşır.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|SETSTRINGSIZE|sonuc = SETSTRINGSIZE metin, uzunluk|Metin değişkeni için istenen uzunlukta alan hazırlar.|
|TIMER|sonuc = TIMER()|Geçen zamanı saniye türünden verir.|
|LOF|sonuc = LOF(#no)|Açık dosyanın uzunluğunu verir.|
|EOF|sonuc = EOF(#no)|Dosya sonuna gelinip gelinmediğini söyler.|
|LEN|sonuc = LEN(metin)|Metnin veya verinin uzunluğunu verir.|
|MID|sonuc = MID(metin, başla, uzunluk)|Metnin içinden parça alır.|
|STR|sonuc = STR(sayi)|Sayıyı metne çevirir.|
|VAL|sonuc = VAL(metin)|Metni sayıya çevirir.|
|ABS|sonuc = ABS(x)|Mutlak değer alır.|
|INT|sonuc = INT(x)|Ondalıklı sayının tam kısmını alır.|
|UCASE|sonuc = UCASE(metin)|Metni büyük harfe çevirir.|
|LCASE|sonuc = LCASE(metin)|Metni küçük harfe çevirir.|
|ASC|sonuc = ASC(karakter)|Karakterin sayı kodunu verir.|
|CHR|sonuc = CHR(kod)|Sayı kodundan karakter üretir.|
|LTRIM|sonuc = LTRIM(metin)|Sol boşlukları temizler.|
|RTRIM|sonuc = RTRIM(metin)|Sağ boşlukları temizler.|
|SPACE|sonuc = SPACE(n)|Belirli sayıda boşluk üretir.|
|SGN|sonuc = SGN(x)|Sayının işaretini verir.|
|SQRT|sonuc = SQRT(x)|Karekök hesaplar.|
|SIN|sonuc = SIN(x)|Sinüs hesaplar.|
|COS|sonuc = COS(x)|Kosinüs hesaplar.|
|TAN|sonuc = TAN(x)|Tanjant hesaplar.|
|ATN|sonuc = ATN(x)|Arktanjant hesaplar.|
|EXP|sonuc = EXP(x)|e üzeri x hesaplar.|
|LOG|sonuc = LOG(x)|Doğal logaritma hesaplar.|
|INKEY|sonuc = INKEY()|Basılmış tuşu beklemeden okur.|
|GETKEY|sonuc = GETKEY()|Tuş bekler ve okur.|
|VARPTR|sonuc = VARPTR(degisken)|Değişkenin bellek adresini verir.|
|SADD|sonuc = SADD(metin)|Metin içeriğinin adresini verir.|
|LPTR|sonuc = LPTR(degisken)|Uzun adres/işaretçi değeri verir.|
|CODEPTR|sonuc = CODEPTR(yordam)|Yordamın kod adresini verir.|
|SIZEOF|sonuc = SIZEOF(Tip\|degisken)|Tip veya değişken boyutunu bayt olarak verir.|
|OFFSETOF|sonuc = OFFSETOF(Tip, alan)|Kayıt içindeki alanın başlangıç uzaklığını verir.|
|CINT|sonuc = CINT(x)|Değeri tam sayıya çevirir.|
|CLNG|sonuc = CLNG(x)|Değeri uzun tam sayıya çevirir.|
|CDBL|sonuc = CDBL(x)|Değeri çift duyarlıklı sayıya çevirir.|
|CSNG|sonuc = CSNG(x)|Değeri tek duyarlıklı sayıya çevirir.|
|FIX|sonuc = FIX(x)|Ondalık kısmı keser.|
|SQR|sonuc = SQR(x)|Karekök için BASIC uyumlu addır.|
|RND|sonuc = RND()|Rastgele sayı üretir.|
|RANDOMIZE|sonuc = RANDOMIZE [tohum]|Rastgele sayı üreticisini tohumlar.|

#### SETSTRINGSIZE
**Sözdizimi:** `sonuc = SETSTRINGSIZE metin, uzunluk`  
**Ne işe yarar:** Metin değişkeni için istenen uzunlukta alan hazırlar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SETSTRINGSIZE metin, uzunluk
PRINT sonuc
```
#### TIMER
**Sözdizimi:** `sonuc = TIMER()`  
**Ne işe yarar:** Geçen zamanı saniye türünden verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = TIMER()
PRINT sonuc
```
#### LOF
**Sözdizimi:** `sonuc = LOF(#no)`  
**Ne işe yarar:** Açık dosyanın uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LOF(#no)
PRINT sonuc
```
#### EOF
**Sözdizimi:** `sonuc = EOF(#no)`  
**Ne işe yarar:** Dosya sonuna gelinip gelinmediğini söyler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = EOF(#no)
PRINT sonuc
```
#### LEN
**Sözdizimi:** `sonuc = LEN(metin)`  
**Ne işe yarar:** Metnin veya verinin uzunluğunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LEN(metin)
PRINT sonuc
```
#### MID
**Sözdizimi:** `sonuc = MID(metin, başla, uzunluk)`  
**Ne işe yarar:** Metnin içinden parça alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = MID(metin, başla, uzunluk)
PRINT sonuc
```
#### STR
**Sözdizimi:** `sonuc = STR(sayi)`  
**Ne işe yarar:** Sayıyı metne çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = STR(sayi)
PRINT sonuc
```
#### VAL
**Sözdizimi:** `sonuc = VAL(metin)`  
**Ne işe yarar:** Metni sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = VAL(metin)
PRINT sonuc
```
#### ABS
**Sözdizimi:** `sonuc = ABS(x)`  
**Ne işe yarar:** Mutlak değer alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ABS(x)
PRINT sonuc
```
#### INT
**Sözdizimi:** `sonuc = INT(x)`  
**Ne işe yarar:** Ondalıklı sayının tam kısmını alır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = INT(x)
PRINT sonuc
```
#### UCASE
**Sözdizimi:** `sonuc = UCASE(metin)`  
**Ne işe yarar:** Metni büyük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = UCASE(metin)
PRINT sonuc
```
#### LCASE
**Sözdizimi:** `sonuc = LCASE(metin)`  
**Ne işe yarar:** Metni küçük harfe çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LCASE(metin)
PRINT sonuc
```
#### ASC
**Sözdizimi:** `sonuc = ASC(karakter)`  
**Ne işe yarar:** Karakterin sayı kodunu verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ASC(karakter)
PRINT sonuc
```
#### CHR
**Sözdizimi:** `sonuc = CHR(kod)`  
**Ne işe yarar:** Sayı kodundan karakter üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CHR(kod)
PRINT sonuc
```
#### LTRIM
**Sözdizimi:** `sonuc = LTRIM(metin)`  
**Ne işe yarar:** Sol boşlukları temizler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LTRIM(metin)
PRINT sonuc
```
#### RTRIM
**Sözdizimi:** `sonuc = RTRIM(metin)`  
**Ne işe yarar:** Sağ boşlukları temizler.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RTRIM(metin)
PRINT sonuc
```
#### SPACE
**Sözdizimi:** `sonuc = SPACE(n)`  
**Ne işe yarar:** Belirli sayıda boşluk üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SPACE(n)
PRINT sonuc
```
#### SGN
**Sözdizimi:** `sonuc = SGN(x)`  
**Ne işe yarar:** Sayının işaretini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SGN(x)
PRINT sonuc
```
#### SQRT
**Sözdizimi:** `sonuc = SQRT(x)`  
**Ne işe yarar:** Karekök hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SQRT(x)
PRINT sonuc
```
#### SIN
**Sözdizimi:** `sonuc = SIN(x)`  
**Ne işe yarar:** Sinüs hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SIN(x)
PRINT sonuc
```
#### COS
**Sözdizimi:** `sonuc = COS(x)`  
**Ne işe yarar:** Kosinüs hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = COS(x)
PRINT sonuc
```
#### TAN
**Sözdizimi:** `sonuc = TAN(x)`  
**Ne işe yarar:** Tanjant hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = TAN(x)
PRINT sonuc
```
#### ATN
**Sözdizimi:** `sonuc = ATN(x)`  
**Ne işe yarar:** Arktanjant hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = ATN(x)
PRINT sonuc
```
#### EXP
**Sözdizimi:** `sonuc = EXP(x)`  
**Ne işe yarar:** e üzeri x hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = EXP(x)
PRINT sonuc
```
#### LOG
**Sözdizimi:** `sonuc = LOG(x)`  
**Ne işe yarar:** Doğal logaritma hesaplar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LOG(x)
PRINT sonuc
```
#### INKEY
**Sözdizimi:** `sonuc = INKEY()`  
**Ne işe yarar:** Basılmış tuşu beklemeden okur.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = INKEY()
PRINT sonuc
```
#### GETKEY
**Sözdizimi:** `sonuc = GETKEY()`  
**Ne işe yarar:** Tuş bekler ve okur.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = GETKEY()
PRINT sonuc
```
#### VARPTR
**Sözdizimi:** `sonuc = VARPTR(degisken)`  
**Ne işe yarar:** Değişkenin bellek adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = VARPTR(degisken)
PRINT sonuc
```
#### SADD
**Sözdizimi:** `sonuc = SADD(metin)`  
**Ne işe yarar:** Metin içeriğinin adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SADD(metin)
PRINT sonuc
```
#### LPTR
**Sözdizimi:** `sonuc = LPTR(degisken)`  
**Ne işe yarar:** Uzun adres/işaretçi değeri verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = LPTR(degisken)
PRINT sonuc
```
#### CODEPTR
**Sözdizimi:** `sonuc = CODEPTR(yordam)`  
**Ne işe yarar:** Yordamın kod adresini verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CODEPTR(yordam)
PRINT sonuc
```
#### SIZEOF
**Sözdizimi:** `sonuc = SIZEOF(Tip|degisken)`  
**Ne işe yarar:** Tip veya değişken boyutunu bayt olarak verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SIZEOF(Tip|degisken)
PRINT sonuc
```
#### OFFSETOF
**Sözdizimi:** `sonuc = OFFSETOF(Tip, alan)`  
**Ne işe yarar:** Kayıt içindeki alanın başlangıç uzaklığını verir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = OFFSETOF(Tip, alan)
PRINT sonuc
```
#### CINT
**Sözdizimi:** `sonuc = CINT(x)`  
**Ne işe yarar:** Değeri tam sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CINT(x)
PRINT sonuc
```
#### CLNG
**Sözdizimi:** `sonuc = CLNG(x)`  
**Ne işe yarar:** Değeri uzun tam sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CLNG(x)
PRINT sonuc
```
#### CDBL
**Sözdizimi:** `sonuc = CDBL(x)`  
**Ne işe yarar:** Değeri çift duyarlıklı sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CDBL(x)
PRINT sonuc
```
#### CSNG
**Sözdizimi:** `sonuc = CSNG(x)`  
**Ne işe yarar:** Değeri tek duyarlıklı sayıya çevirir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = CSNG(x)
PRINT sonuc
```
#### FIX
**Sözdizimi:** `sonuc = FIX(x)`  
**Ne işe yarar:** Ondalık kısmı keser.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = FIX(x)
PRINT sonuc
```
#### SQR
**Sözdizimi:** `sonuc = SQR(x)`  
**Ne işe yarar:** Karekök için BASIC uyumlu addır.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = SQR(x)
PRINT sonuc
```
#### RND
**Sözdizimi:** `sonuc = RND()`  
**Ne işe yarar:** Rastgele sayı üretir.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RND()
PRINT sonuc
```
#### RANDOMIZE
**Sözdizimi:** `sonuc = RANDOMIZE [tohum]`  
**Ne işe yarar:** Rastgele sayı üreticisini tohumlar.  
**Nerede kullanılır:** Metin, sayı, zaman, dosya, klavye, bellek adresi veya tip dönüşümü gerektiğinde kullanılır.

```uxbasic
sonuc = RANDOMIZE [tohum]
PRINT sonuc
```
**Birlikte kullanım örneği — metni sayıya çevirip raporlamak:**
```uxbasic
INPUT satir
satir = LTRIM(RTRIM(satir))
IF LEN(satir) > 0 THEN
  deger = VAL(satir)
  PRINT "karekok="; SQRT(ABS(deger))
  PRINT "metin="; STR(deger)
END IF
```

### Bellek ve düşük seviye

Bellek komutları güçlü ama keskin araçlardır. `PEEK` ailesi adresten okur, `POKE` ailesi adrese yazar, `MEMCOPY` veri taşır, `MEMFILL` alan doldurur, `INC` ve `DEC` değer artırıp azaltır. Bu komutlar derleyici, gömülü sistem, ikili dosya, hız isteyen tampon ve dış kütüphane köprülerinde işe yarar. Yeni başlayan biri bu komutları normal veri işi için değil, kontrollü deney için kullanmalıdır. Her bellek örneği önce küçük tamponla, sonra ASSERT ile, sonra raporla denenmelidir. Yanlış adres, yanlış uzunluk veya yanlış tip sessizce veri bozabilir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|PEEKB|PEEKB adres[, değer[, uzunluk]]|Adresten bayt okur.|
|PEEKW|PEEKW adres[, değer[, uzunluk]]|Adresten 16 bit sözcük okur.|
|PEEKD|PEEKD adres[, değer[, uzunluk]]|Adresten 32 bit değer okur.|
|POKE|POKE adres[, değer[, uzunluk]]|Adrese genel değer yazar.|
|POKEB|POKEB adres[, değer[, uzunluk]]|Adrese bayt yazar.|
|POKEW|POKEW adres[, değer[, uzunluk]]|Adrese 16 bit değer yazar.|
|POKED|POKED adres[, değer[, uzunluk]]|Adrese 32 bit değer yazar.|
|POKES|POKES adres[, değer[, uzunluk]]|Adrese metin/blok yazar.|
|MEMCOPYB|MEMCOPYB adres[, değer[, uzunluk]]|Bayt blok kopyalar.|
|MEMCOPYW|MEMCOPYW adres[, değer[, uzunluk]]|16 bit sözcük blok kopyalar.|
|MEMCOPYD|MEMCOPYD adres[, değer[, uzunluk]]|32 bit blok kopyalar.|
|MEMFILLB|MEMFILLB adres[, değer[, uzunluk]]|Belleği bayt değeriyle doldurur.|
|MEMFILLW|MEMFILLW adres[, değer[, uzunluk]]|Belleği 16 bit değerle doldurur.|
|MEMFILLD|MEMFILLD adres[, değer[, uzunluk]]|Belleği 32 bit değerle doldurur.|
|SETNEWOFFSET|SETNEWOFFSET adres[, değer[, uzunluk]]|Yeni ayırma ofsetini belirler.|
|INC|INC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri artırır.|
|DEC|DEC adres[, değer[, uzunluk]]|Sayıyı veya adresteki değeri azaltır.|

#### PEEKB
**Sözdizimi:** `PEEKB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten bayt okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKB adres, deger
```
#### PEEKW
**Sözdizimi:** `PEEKW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten 16 bit sözcük okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKW adres, deger
```
#### PEEKD
**Sözdizimi:** `PEEKD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adresten 32 bit değer okur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
PEEKD adres, deger
```
#### POKE
**Sözdizimi:** `POKE adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese genel değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKE adres, deger
```
#### POKEB
**Sözdizimi:** `POKEB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese bayt yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKEB adres, deger
```
#### POKEW
**Sözdizimi:** `POKEW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese 16 bit değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKEW adres, deger
```
#### POKED
**Sözdizimi:** `POKED adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese 32 bit değer yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKED adres, deger
```
#### POKES
**Sözdizimi:** `POKES adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Adrese metin/blok yazar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
POKES adres, deger
```
#### MEMCOPYB
**Sözdizimi:** `MEMCOPYB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Bayt blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYB adres, deger
```
#### MEMCOPYW
**Sözdizimi:** `MEMCOPYW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** 16 bit sözcük blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYW adres, deger
```
#### MEMCOPYD
**Sözdizimi:** `MEMCOPYD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** 32 bit blok kopyalar.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMCOPYD adres, deger
```
#### MEMFILLB
**Sözdizimi:** `MEMFILLB adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği bayt değeriyle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLB adres, deger
```
#### MEMFILLW
**Sözdizimi:** `MEMFILLW adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği 16 bit değerle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLW adres, deger
```
#### MEMFILLD
**Sözdizimi:** `MEMFILLD adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Belleği 32 bit değerle doldurur.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
MEMFILLD adres, deger
```
#### SETNEWOFFSET
**Sözdizimi:** `SETNEWOFFSET adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Yeni ayırma ofsetini belirler.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
SETNEWOFFSET adres, deger
```
#### INC
**Sözdizimi:** `INC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Sayıyı veya adresteki değeri artırır.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
INC adres, deger
```
#### DEC
**Sözdizimi:** `DEC adres[, değer[, uzunluk]]`  
**Ne işe yarar:** Sayıyı veya adresteki değeri azaltır.  
**Nerede kullanılır:** Donanım, hızlı tampon, derleyici çıktısı, ikili dosya ve dış kütüphane köprülerinde kullanılır; yanlış adres veri bozabilir.

```uxbasic
DEC adres, deger
```
**Birlikte kullanım örneği — küçük tampon fikri:**
```uxbasic
DIM adres AS PTR
DIM n AS I32
n = 10
adres = VARPTR(n)
POKED adres, 20
IF PEEKD(adres) = 20 THEN PRINT "tampon degisti"
INC n
DEC n
```

### Listeleme

Listeleme komutları sabit durumları adlandırır. Sayıya anlamlı ad vermek hatayı azaltır. Menü seçenekleri, hata kodları, durumlar ve renkler için çok yararlıdır. Genç programcı enum kullanarak `1`, `2`, `3` gibi sihirli sayıları temiz adlara dönüştürmelidir.

|Sözcük|Sözdizimi|Kısa görev|
|---|---|---|
|ENUM|ENUM Ad ... END ENUM|Adlandırılmış sabitler grubu oluşturur.|

#### ENUM
**Sözdizimi:** `ENUM Ad ... END ENUM`  
**Ne işe yarar:** Adlandırılmış sabitler grubu oluşturur.  
**Nerede kullanılır:** Durum, renk, komut kodu gibi sayısal sabitleri okunur adlara bağlar.

```uxbasic
ENUM Durum
  Hazir
  Calisiyor
  Hata
END ENUM
```

## Ön-işleyici komutları

Ön-işleyici komutları program çalışmadan önce çalışır. Kaynağın hangi parçasının derleneceğini, hangi hedefin üretileceğini, hangi HTML/JS/WAT/JSON varlığının paketleneceğini ve hangi güvenlik kuralının uygulanacağını belirler. Bu bölümdeki komutlar normal çalışma zamanı komutu değildir; derleme hazırlığı ve çıktı üretimi içindir.

|No|Komut|Sözdizimi|Görev|
|---|---|---|---|
|1|%%DEFINE|%%DEFINE ...|metinsel tanım veya doğru/yanlış derleme simgesi oluşturur|
|2|%%SET|%%SET ad = değer|üst bilgi değişkeni atar|
|3|%%ALIAS|%%ALIAS eski AS yeni|tek satırlık metin kısaltması kurar: %%ALIAS {old} AS {new}|
|4|%%MACRO|%%MACRO ...|tek satırlık makro veya makro fonksiyon kurar|
|5|%%IF|%%IF koşul ... %%ELIF ... %%ENDIF|koşula göre kaynak bölümünü seçer|
|6|%%IFC|%%IFC ...|metinsel koşul karşılaştırması yapar|
|7|%%FOR|%%FOR ...|derleme zamanında sayısal döngü üretir|
|8|%%FOREACH|%%FOREACH ...|derleme zamanında liste üzerinde döner|
|9|%%REPEAT|%%REPEAT ...|derleme zamanında sabit tekrar üretir|
|10|%%TARGET|%%TARGET js\|wasm\|browser\|native|etkin çıktı hedefini seçer|
|11|%%OUTDIR|%%OUTDIR ...|çıktı dizinini belirler|
|12|%%SECTION|%%SECTION ...|etkin çıktı bölümünü seçer|
|13|%%JS_BEGIN|%%JS_BEGIN ...|JavaScript bloğunu çıktı olarak toplar|
|14|%%JS_LINE|%%JS_LINE console.log("...")|tek JavaScript satırı ekler|
|15|%%JS_FILE|%%JS_FILE ...|dış JavaScript dosyasını kayda alır|
|16|%%WAT_BEGIN|%%WAT_BEGIN ...|WAT bloğunu çıktı olarak toplar|
|17|%%WAT_IMPORT|%%WAT_IMPORT ...|WAT tarafında dış ev sahibi çağrısı bildirir|
|18|%%WAT_EXPORT|%%WAT_EXPORT ...|WAT dışa açılan adını bildirir|
|19|%%WASM_HOST_JS_BEGIN|%%WASM_HOST_JS_BEGIN ...|WASM ev sahibi JavaScript köprüsünü toplar|
|20|%%HTML_BEGIN|%%HTML_BEGIN ...|HTML bloğunu veya dosyasını toplar|
|21|%%HTML_LINE|%%HTML_LINE ...|tek HTML satırı ekler|
|22|%%HTML_SCRIPT|%%HTML_SCRIPT ...|betik etiketi bilgisini üretir|
|23|%%HTML_STYLE|%%HTML_STYLE ...|biçim dosyası etiketi bilgisini üretir|
|24|%%CSS_BEGIN|%%CSS_BEGIN ...|CSS bloğunu veya dosyasını toplar|
|25|%%CSS_LINE|%%CSS_LINE ...|tek CSS satırı ekler|
|26|%%JSON_BEGIN|%%JSON_BEGIN ...|JSON bloğunu veya dosyasını toplar|
|27|%%JSON_SET|%%JSON_SET anahtar = değer|JSON anahtar/değer yazar|
|28|%%MANIFEST_SET|%%MANIFEST_SET ...|yapı bildirgesine anahtar/değer yazar|
|29|%%MANIFEST_REQUIRE|%%MANIFEST_REQUIRE ...|zorunlu çıktı veya bağlantı bildirir|
|30|%%MD_BEGIN|%%MD_BEGIN ...|Markdown bloğunu toplar|
|31|%%MD_FILE|%%MD_FILE ...|Markdown dosyasını kayda alır|
|32|%%ASSET_ROOT|%%ASSET_ROOT ...|varlık kök dizinini belirler|
|33|%%ASSET_COPY|%%ASSET_COPY ...|varlık dosyasını kopyalar veya kayda alır|
|34|%%ASSET_FILE|%%ASSET_FILE ...|genel varlık dosyasını kayda alır|
|35|%%ASSET_IMAGE|%%ASSET_IMAGE ...|görsel varlığı kayda alır|
|36|%%ASSET_AUDIO|%%ASSET_AUDIO ...|ses varlığı kayda alır|
|37|%%ALLOW_RAW_JS|%%ALLOW_RAW_JS ...|ham JavaScript yazmaya izin verir|
|38|%%ALLOW_RAW_WAT|%%ALLOW_RAW_WAT ...|ham WAT yazmaya izin verir|
|39|%%SAFE_PATHS|%%SAFE_PATHS ...|yol güvenliği kuralını belirler|
|40|%%REQUIRE_HOST_BINDING|%%REQUIRE_HOST_BINDING ...|WAT içe çağrıları için ev sahibi bağlantısı ister|
|41|%%ASSERT_META|%%ASSERT_META ...|koşul yanlışsa derleme sırasında hata verir|
|42|%%WARN_META|%%WARN_META ...|derleme sırasında uyarı üretir|
|43|%%IFN|%%IFN ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|44|%%ELIF|%%ELIF ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|45|%%PROFILE|%%PROFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|46|%%CONFIG_FILE|%%CONFIG_FILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|47|%%PATH_ALIAS|%%PATH_ALIAS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|48|%%LOCK_META|%%LOCK_META ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|49|%%DUMP_META|%%DUMP_META ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|50|%%SOURCE_MAP|%%SOURCE_MAP ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|51|%%EMITNOTE|%%EMITNOTE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|52|%%ENV|%%ENV ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|53|%%DEPRECATED|%%DEPRECATED ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|54|%%TEMPLATE_BEGIN|%%TEMPLATE_BEGIN ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|55|%%TEMPLATE_END|%%TEMPLATE_END ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|56|%%TEMPLATE_USE|%%TEMPLATE_USE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|57|%%MINIFY|%%MINIFY ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|58|%%FINGERPRINT_ASSETS|%%FINGERPRINT_ASSETS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|59|%%HASHFILE|%%HASHFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|60|%%COPY_DIR|%%COPY_DIR ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|61|%%EMBEDTEXT|%%EMBEDTEXT ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|62|%%EMBEDBASE64|%%EMBEDBASE64 ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|63|%%LICENSEFILE|%%LICENSEFILE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|64|%%HTMLIMAGE|%%HTMLIMAGE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|65|%%HTMLAUDIO|%%HTMLAUDIO ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|66|%%CSS_RULE|%%CSS_RULE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|67|%%CSS_IMPORT|%%CSS_IMPORT ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|68|%%MD_SAFE|%%MD_SAFE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|69|%%MD_CSS|%%MD_CSS ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|70|%%BREAK|%%BREAK ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|71|%%CONTINUE|%%CONTINUE ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|
|72|%%INFOMETA|%%INFOMETA ...|Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.|

### 1. %%DEFINE
metinsel tanım veya doğru/yanlış derleme simgesi oluşturur. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DEFINE DEBUG
%%IF DEBUG
PRINT "test modu"
%%ENDIF
```

### 2. %%SET
üst bilgi değişkeni atar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SET APP_NAME = "Deneme"
%%MANIFEST_SET name = ${APP_NAME}
```

### 3. %%ALIAS
tek satırlık metin kısaltması kurar: %%ALIAS {old} AS {new}. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALIAS ...
```

### 4. %%MACRO
tek satırlık makro veya makro fonksiyon kurar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MACRO ...
```

### 5. %%IF
koşula göre kaynak bölümünü seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IF ...
```

### 6. %%IFC
metinsel koşul karşılaştırması yapar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IFC ...
```

### 7. %%FOR
derleme zamanında sayısal döngü üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FOR ...
```

### 8. %%FOREACH
derleme zamanında liste üzerinde döner. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FOREACH ...
```

### 9. %%REPEAT
derleme zamanında sabit tekrar üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%REPEAT ...
```

### 10. %%TARGET
etkin çıktı hedefini seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
```

### 11. %%OUTDIR
çıktı dizinini belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%OUTDIR ...
```

### 12. %%SECTION
etkin çıktı bölümünü seçer. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SECTION ...
```

### 13. %%JS_BEGIN
JavaScript bloğunu çıktı olarak toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_BEGIN ...
```

### 14. %%JS_LINE
tek JavaScript satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_LINE console.log("uXBasic tarayici hazir");
```

### 15. %%JS_FILE
dış JavaScript dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JS_FILE ...
```

### 16. %%WAT_BEGIN
WAT bloğunu çıktı olarak toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_BEGIN ...
```

### 17. %%WAT_IMPORT
WAT tarafında dış ev sahibi çağrısı bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_IMPORT ux.print_i32 AS print_i32(i32)
```

### 18. %%WAT_EXPORT
WAT dışa açılan adını bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WAT_EXPORT ...
```

### 19. %%WASM_HOST_JS_BEGIN
WASM ev sahibi JavaScript köprüsünü toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WASM_HOST_JS_BEGIN ...
```

### 20. %%HTML_BEGIN
HTML bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_BEGIN ...
```

### 21. %%HTML_LINE
tek HTML satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_LINE <div id="app"></div>
```

### 22. %%HTML_SCRIPT
betik etiketi bilgisini üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_SCRIPT ...
```

### 23. %%HTML_STYLE
biçim dosyası etiketi bilgisini üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTML_STYLE ...
```

### 24. %%CSS_BEGIN
CSS bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_BEGIN ...
```

### 25. %%CSS_LINE
tek CSS satırı ekler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_LINE ...
```

### 26. %%JSON_BEGIN
JSON bloğunu veya dosyasını toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JSON_BEGIN ...
```

### 27. %%JSON_SET
JSON anahtar/değer yazar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%JSON_SET ...
```

### 28. %%MANIFEST_SET
yapı bildirgesine anahtar/değer yazar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MANIFEST_SET ...
```

### 29. %%MANIFEST_REQUIRE
zorunlu çıktı veya bağlantı bildirir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MANIFEST_REQUIRE ...
```

### 30. %%MD_BEGIN
Markdown bloğunu toplar. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_BEGIN ...
```

### 31. %%MD_FILE
Markdown dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_FILE ...
```

### 32. %%ASSET_ROOT
varlık kök dizinini belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_ROOT ...
```

### 33. %%ASSET_COPY
varlık dosyasını kopyalar veya kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_ROOT "assets"
%%ASSET_COPY "logo.png"
```

### 34. %%ASSET_FILE
genel varlık dosyasını kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_FILE ...
```

### 35. %%ASSET_IMAGE
görsel varlığı kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_IMAGE ...
```

### 36. %%ASSET_AUDIO
ses varlığı kayda alır. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSET_AUDIO ...
```

### 37. %%ALLOW_RAW_JS
ham JavaScript yazmaya izin verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALLOW_RAW_JS ...
```

### 38. %%ALLOW_RAW_WAT
ham WAT yazmaya izin verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ALLOW_RAW_WAT ...
```

### 39. %%SAFE_PATHS
yol güvenliği kuralını belirler. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SAFE_PATHS ...
```

### 40. %%REQUIRE_HOST_BINDING
WAT içe çağrıları için ev sahibi bağlantısı ister. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%REQUIRE_HOST_BINDING ...
```

### 41. %%ASSERT_META
koşul yanlışsa derleme sırasında hata verir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ASSERT_META TARGET <> ""
```

### 42. %%WARN_META
derleme sırasında uyarı üretir. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%WARN_META ...
```

### 43. %%IFN
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%IFN ...
```

### 44. %%ELIF
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ELIF ...
```

### 45. %%PROFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%PROFILE ...
```

### 46. %%CONFIG_FILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CONFIG_FILE ...
```

### 47. %%PATH_ALIAS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%PATH_ALIAS ...
```

### 48. %%LOCK_META
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%LOCK_META ...
```

### 49. %%DUMP_META
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DUMP_META ...
```

### 50. %%SOURCE_MAP
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%SOURCE_MAP ...
```

### 51. %%EMITNOTE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMITNOTE ...
```

### 52. %%ENV
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%ENV ...
```

### 53. %%DEPRECATED
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%DEPRECATED ...
```

### 54. %%TEMPLATE_BEGIN
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_BEGIN ...
```

### 55. %%TEMPLATE_END
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_END ...
```

### 56. %%TEMPLATE_USE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%TEMPLATE_USE ...
```

### 57. %%MINIFY
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MINIFY ...
```

### 58. %%FINGERPRINT_ASSETS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%FINGERPRINT_ASSETS ...
```

### 59. %%HASHFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HASHFILE ...
```

### 60. %%COPY_DIR
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%COPY_DIR ...
```

### 61. %%EMBEDTEXT
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMBEDTEXT ...
```

### 62. %%EMBEDBASE64
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%EMBEDBASE64 ...
```

### 63. %%LICENSEFILE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%LICENSEFILE ...
```

### 64. %%HTMLIMAGE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTMLIMAGE ...
```

### 65. %%HTMLAUDIO
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%HTMLAUDIO ...
```

### 66. %%CSS_RULE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_RULE ...
```

### 67. %%CSS_IMPORT
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CSS_IMPORT ...
```

### 68. %%MD_SAFE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_SAFE ...
```

### 69. %%MD_CSS
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%MD_CSS ...
```

### 70. %%BREAK
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%BREAK ...
```

### 71. %%CONTINUE
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%CONTINUE ...
```

### 72. %%INFOMETA
Ön-işleyiciye ait ek görev yapar; kaynak derlenmeden önce karar, çıktı veya varlık düzenler.. Bu komut kaynak dosyası derlenmeden önce karar vermek, çıktı dosyası hazırlamak veya hedefe özel ek parça üretmek için kullanılır.
```uxbasic
%%INFOMETA ...
```

## İşleçlerin toplu özeti
|İşleç|Sözdizimi|Görev|
|---|---|---|
|AND|a AND b|iki koşul/bit birlikte doğruysa doğru verir|
|OR|a OR b|koşullardan biri doğruysa doğru verir|
|NOT|NOT koşul|koşulu tersine çevirir|
|XOR|a XOR b|yalnız biri doğruysa doğru verir veya bitlerde özel fark alır|
|MOD|a MOD b|bölme kalanı verir|
|SHL|a SHL b|bitleri sola kaydırır|
|SHR|a SHR b|bitleri sağa kaydırır|
|ROL|a ROL b|bitleri döndürerek sola kaydırır|
|ROR|a ROR b|bitleri döndürerek sağa kaydırır|

## Veri tiplerinin toplu özeti
|Tip|Sözdizimi|Görev|
|---|---|---|
|BYTE|DIM ad AS BYTE|tek baytlık ham veri tutar.|
|DEFINT|DEFINT A-Z|harfle başlayan adsız tipleri I32 yapar|
|DEFLNG|DEFLNG A-Z|harfle başlayan adsız tipleri I64 yapar|
|DEFSNG|DEFSNG A-Z|harfle başlayan adsız tipleri F32 yapar|
|DEFDBL|DEFDBL A-Z|harfle başlayan adsız tipleri F64 yapar|
|DEFEXT|DEFEXT A-Z|harfle başlayan adsız tipleri geniş ondalık yapar|
|DEFSTR|DEFSTR A-Z|harfle başlayan adsız tipleri STRING yapar|
|DEFBYT|DEFBYT A-Z|harfle başlayan adsız tipleri BYTE yapar|
|I8|DIM ad AS I8|-128 ile 127 arasında işaretli 8 bit tam sayı tutar.|
|U8|DIM ad AS U8|0 ile 255 arasında işaretsiz 8 bit tam sayı tutar.|
|I16|DIM ad AS I16|işaretli 16 bit tam sayı tutar.|
|U16|DIM ad AS U16|işaretsiz 16 bit tam sayı tutar.|
|I32|DIM ad AS I32|günlük sayaç ve indeksler için 32 bit tam sayı tutar.|
|U32|DIM ad AS U32|negatif olmayan 32 bit sayı tutar.|
|I64|DIM ad AS I64|büyük sayaç ve dosya boyutu için 64 bit tam sayı tutar.|
|U64|DIM ad AS U64|çok büyük pozitif sayaçlar için 64 bit sayı tutar.|
|F32|DIM ad AS F32|tek duyarlıklı ondalıklı sayı tutar.|
|F64|DIM ad AS F64|çift duyarlıklı ondalıklı sayı tutar.|
|F80|DIM ad AS F80|genişletilmiş kayan nokta sayı tutar.|
|F128|DIM ad AS F128|128 bit yüksek duyarlıklı sayı tutar.|
|BIGF|DIM ad AS BIGF|çok büyük/yüksek duyarlıklı ikili kayan sayı ailesidir.|
|BIGD|DIM ad AS BIGD|çok basamaklı ondalık sayı ailesidir.|
|BALL|DIM ad AS BALL|aralık/top mantığıyla güvenli yaklaşık sayı tutar.|
|BOOLEAN|DIM ad AS BOOLEAN|TRUE/FALSE doğru-yanlış değeri tutar.|
|STRING|DIM ad AS STRING|metin tutar.|
|OBJECT|DIM ad AS OBJECT|nesne başvurusu tutar.|
|PTR|DIM ad AS PTR|ham adres veya dış kütüphane işaretçisi tutar.|
|STRPTR|DIM ad AS STRPTR|metnin bellek adresini dış çağrıya verir.|
|ARRAY|DIM ad AS ARRAY|sabit veya yeniden boyutlanabilir dizi tutar.|
|LIST|DIM ad AS LIST|sıralı, büyüyebilen liste tutar.|
|DICT|DIM ad AS DICT|anahtar/değer sözlüğü tutar.|
|SET|DIM ad AS SET|tekrarsız küme tutar.|



## Komut sınıfları için derin kullanım örnekleri

Aşağıdaki örnekler tabloyu ezberlemek için değil, komutların birlikte nasıl iş yaptığını görmek için yazıldı. Bir komut tek başına küçük görünür; gerçek programda ise en az beş komut aynı hedefe hizmet eder. `IF` karar verir, `FOR` tekrar eder, `FUNCTION` hesabı saklar, `TRY` hatayı yakalar, `PRINT` sonucu gösterir. Genç programcı bu düzeni görürse komutları ayrı taşlar gibi değil, bir makinenin dişlileri gibi düşünmeye başlar.

### Akış komutları birlikte nasıl düşünülür?

Akış komutları programın yol haritasını çizer. Sensörden gelen pH ölçümlerini düşün: önce dosya açılır, sonra satır satır okunur, sonra ölçüm aralığına göre karar verilir, sonra toplam ve alarm sayısı tutulur, en sonda rapor yazılır. Bu işte `OPEN`, `DO`, `INPUT`, `IF`, `ELSEIF`, `FOR`, `EXIT`, `TRY`, `CATCH`, `FINALLY`, `PRINT` birlikte çalışır. Hata çıkarsa program çökmek yerine CATCH bölümüne düşer. Dosya açıksa FINALLY ile kapatılır. Programın amacı yalnız “pH yazdırmak” değil, veri akışını güvenli biçimde yönetmektir.

```uxbasic
TRY
  OPEN "ph.csv" FOR INPUT AS #1
  DIM satir AS STRING
  DIM alarm AS I32 = 0
  DO WHILE NOT EOF(1)
    INPUT #1, satir
    DIM ph AS F64 = VAL(satir)
    IF ph < 6.5 THEN
      alarm = alarm + 1
      PRINT "asit uyarisi: "; ph
    ELSEIF ph > 8.5 THEN
      alarm = alarm + 1
      PRINT "bazik uyarisi: "; ph
    ELSE
      PRINT "normal: "; ph
    END IF
    IF alarm > 10 THEN EXIT DO
  LOOP
CATCH e
  PRINT "dosya veya veri hatasi"
FINALLY
  CLOSE #1
END TRY
```

### Olay ve eşzamanlılık komutları neyi değiştirir?

`EVENT`, `SLOT`, `TRIGGER`, `PIPE`, `THREAD`, `PARALEL`, `ON` ve `OFF` komutları programı sıradan satır akışından çıkarır. Artık program yalnız yukarıdan aşağıya koşmaz; bir olay gelince tepki verir. GUI düğmesi, tarayıcı tıklaması, seri porttan gelen ölçüm, zamanlayıcı ya da yapay zeka cevabı aynı mantıkla düşünülebilir. `EVENT VeriGeldi` adı bildirir; `SLOT Kaydet ON VeriGeldi` bu olay olduğunda ne yapılacağını anlatır. `PIPE` bir işin ürettiği veriyi başka işe taşır. `THREAD` arka planda bekleyen işi ekranı dondurmadan çalıştırır. `PARALEL` bağımsız işleri bir aile içinde birlikte yürütür.

```uxbasic
EVENT VeriGeldi
PIPE Olcum AS F64

SLOT EkranaYaz ON VeriGeldi
  INPUT Olcum
  PRINT "yeni olcum: "; Olcum
END SLOT

THREAD SeriPortDinle
  FOR i = 1 TO 5
    TRIGGER VeriGeldi, i * 1.25
  NEXT i
END THREAD

PARALEL ArkaPlan
  CALL SeriPortDinle()
  PRINT "ana ekran calismaya devam eder"
END PARALEL
```

### Yordam, fonksiyon ve dış çağrı nasıl düzenlenir?

Küçük programda her şeyi ana dosyaya yazmak kolay görünür. Program büyüdükçe aynı hesabı tekrar tekrar yazmak hata üretir. `SUB` değer döndürmeyen iş bloğudur; ekrana yazma, dosya kaydetme, hazırlık yapma gibi görevlerde kullanılır. `FUNCTION` sonuç döndürür; ortalama, dönüşüm, puan hesaplama gibi işlerde daha uygundur. `DECLARE`, `CALL`, `BYREF`, `BYVAL`, `CDECL` ve `STDCALL` dış dünyaya açılan kapıdır. Windows DLL, C kütüphanesi veya kendi yazdığın DLL çağrılacaksa önce imza bildirilir, sonra çağrı yapılır, sonuç kontrol edilir.

```uxbasic
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" _
  (BYVAL hwnd AS PTR, BYVAL text AS STRPTR, BYVAL title AS STRPTR, BYVAL flags AS I32) AS I32

FUNCTION Ortalama(a AS F64, b AS F64, c AS F64) AS F64
  RETURN (a + b + c) / 3
END FUNCTION

SUB Uyar(metin AS STRING)
  DIM r AS I32 = CALL(DLL, "user32.dll", "MessageBoxA", 0, STRPTR(metin), STRPTR("uXBasic"), 0)
  PRINT "pencere sonucu: "; r
END SUB

DIM o AS F64 = Ortalama(10, 12, 14)
IF o > 11 THEN CALL Uyar("ortalama yuksek") ELSE PRINT "normal"
```

### Nesne ve tip komutları neden vardır?

`TYPE` bir veri demetini bir araya getirir; balık adı, ağırlığı, yem miktarı aynı kaydın parçası olur. `CLASS` buna davranış ekler; yalnız veri değil, o verinin nasıl hesap yapacağını da sınıfın içine koyarsın. `CONSTRUCTOR` nesne doğarken, `DESTRUCTOR` yok olurken çalışır. `METHOD`, `PROPERTY`, `PUBLIC`, `PRIVATE`, `VIRTUAL`, `OVERRIDE`, `OPERATOR`, `MAGIC` gibi komutlar büyüyen projede düzen sağlar. Genç programcı nesneyi “kutunun içine veri koydum” diye değil, “bu kutu kendi işini biliyor” diye düşünmelidir.

```uxbasic
CLASS Tank
PRIVATE hacim AS F64
PUBLIC PROPERTY ad AS STRING

CONSTRUCTOR(yeniAd AS STRING, litre AS F64)
  ad = yeniAd
  hacim = litre
END CONSTRUCTOR

METHOD YemMiktari(orani AS F64) AS F64
  RETURN hacim * orani
END METHOD

MAGIC <.ToString.>() AS STRING
  RETURN ad + " tanki"
END MAGIC
END CLASS

DIM t AS Tank = NEW Tank("kuluçka", 500)
PRINT t.YemMiktari(0.02)
DELETE t
```

### Değişken, bellek ve veri yapısı nasıl seçilir?

`DIM` değişken açar; `CONST` değişmeyen değeri korur; `REDIM` büyüyen diziyi yeniden boyutlandırır. `ARRAY` sabit düzenli çok elemanlı yapı için, `LIST` büyüyen sıra için, `DICT` anahtar-değer ilişkisi için, `SET` tekrar etmeyen küme için uygundur. Genç programcı veri yapısını seçerken önce şu soruyu sorar: “Sıra önemli mi, isimle mi bulacağım, tekrarları atacak mıyım, boyut baştan belli mi?” Bilimsel ölçümde 2 boyutlu dizi tablo, 3 boyutlu dizi zamanlı tablo, 4 boyutlu dizi deney-kap-zaman-parametre, 5 boyutlu dizi deney-kap-zaman-parametre-tekrar biçiminde düşünülebilir.

```uxbasic
DIM olcum(3, 4, 2) AS F64
DIM etiketler AS LIST
DIM ortalama AS DICT
DIM benzersizGun AS SET
CONST limit AS F64 = 8.5

FOR gun = 1 TO 3
  FOR kap = 1 TO 4
    FOR tekrar = 1 TO 2
      olcum(gun, kap, tekrar) = 7.0 + gun * 0.1 + kap * 0.05
      IF olcum(gun, kap, tekrar) > limit THEN PRINT "uyari"
    NEXT tekrar
  NEXT kap
NEXT gun
```

### Modül, ad alanı, takma ad ve dış kaynak nasıl birleşir?

`INCLUDE` uXBasic başlık veya destek dosyasını içeri alır. `IMPORT(C,"dosya.c")`, `IMPORT(CPP,"dosya.cpp")`, `IMPORT(ASM,"dosya.asm")` derleme zamanı kaynak bağlar. `NAMESPACE` ad çakışmasını önler; `MODULE` bir iş ailesini toplar; `USING MODULE` kullanım alanını açar; `ALIAS` uzun adı kısa ada bağlar. Bu sistemin fikri şudur: çekirdek dil şişmez, dış kütüphane sisteme kontrollü kapıdan girer. Bir proje büyüdükçe her dosya tek başına bağırmaz; modül adlarıyla konuşur.

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
IMPORT(C, "src/native/hizli_toplam.c")
IMPORT(ASM, "src/native/hizli_kopya.asm")

NAMESPACE Bilim
MODULE Analiz
  ALIAS ORT = uxstats.mean
  FUNCTION Rapor(a AS F64, b AS F64) AS F64
    RETURN ORT(a, b)
  END FUNCTION
END MODULE
END NAMESPACE

USING MODULE Bilim.Analiz
PRINT Rapor(10.5, 11.2)
```

### Girdi, çıktı, dosya ve terminal akışı nasıl güvenli yazılır?

`PRINT`, `INPUT`, `OPEN`, `CLOSE`, `GET`, `PUT`, `SEEK`, `EOF`, `LOF`, `CLS`, `COLOR`, `LOCATE`, `INKEY`, `GETKEY` komutları programı kullanıcı ve dosya sistemiyle konuşturur. Dosya açınca kapatmak, yazmadan önce hedef yolu kontrol etmek, okurken dosya sonunu denetlemek gerekir. Terminalde kullanıcıdan sayı alınacaksa `VAL` dönüşümü yapılır ve beklenen aralık `IF` ile kontrol edilir. `INKEY` anlık tuş okur; oyun döngüsünde işe yarar. `GETKEY` bekler; menüde daha uygundur.

```uxbasic
CLS
COLOR 14, 0
LOCATE 1, 1
PRINT "CSV kayit programi"
OPEN "sonuc.csv" FOR OUTPUT AS #1
FOR i = 1 TO 5
  PRINT "deger gir: "
  INPUT deger
  IF VAL(deger) >= 0 THEN PRINT #1, deger ELSE PRINT "negatif gecildi"
NEXT i
CLOSE #1
PRINT "bitirmek icin tus"
DIM tus AS STRING = GETKEY()
```


# Bölüm 3 — Değişkenler, Veri Yapıları, Nesne, Hook, Wrapper ve Eşzamanlılık

# Değişkenler, Veri Yapıları, Nesne Düzeni, Kanca ve Eşzamanlılık

Bu cilt Cilt 2'deki komutları daha uzun program kalıplarına dönüştürür. Amaç, genç programcının `DIM`, `ARRAY`, `LIST`, `DICT`, `SET`, `CLASS`, `EVENT`, `PIPE`, `THREAD`, `PARALEL`, `SLOT`, kanca ve sarmalayıcı kavramlarını gerçek işlere bağlamasıdır.

## Değişken seçme rehberi
|İhtiyaç|Tip|Kullanım|
|---|---|---|
|Küçük sayaç|I32|FOR/NEXT, satır sayısı, menü seçimi|
|Büyük sayaç|I64|dosya boyutu, uzun kayıt sayısı|
|Ölçüm|F64|pH, sıcaklık, ağırlık, oran|
|Yüksek duyarlık|BIGD/BIGF/F128|finans, bilimsel hassas hesap, büyük matris|
|Metin|STRING|kullanıcı adı, dosya yolu, API cevabı|
|Ham veri|BYTE/U8/ARRAY|ikili dosya, resim, bellek tamponu|
|Nesne|OBJECT/CLASS|durum ve davranış bir arada|
|Adres|PTR/STRPTR|DLL, C fonksiyonu, bellek köprüsü|

## ARRAY — dizi
Dizi, aynı tipten çok sayıda değeri sıra numarasıyla tutar. Ölçüm listesi, görüntü pikseli, matris satırı, oyun haritası veya zaman serisi için kullanılır. Dizi kullanırken sınırı baştan düşün; sınır belirsizse `LIST`, çok boyut gerekiyorsa açık boyutlu `ARRAY` seç.
```uxbasic
DIM sicaklik(1 TO 7) AS F64
FOR gun = 1 TO 7
  INPUT sicaklik(gun)
NEXT gun
PRINT "3. gun="; sicaklik(3)
```
### 2, 3, 4 ve 5 boyutlu dizi fikri
```uxbasic
DIM tablo(1 TO 3, 1 TO 4) AS F64          ' 2 boyut: satır/sütun
DIM kup(1 TO 4, 1 TO 4, 1 TO 4) AS I32       ' 3 boyut: hacim
DIM deney(1 TO 2,1 TO 3,1 TO 4,1 TO 5) AS F64 ' 4 boyut: grup/gün/kap/ölçüm
DIM model(1 TO 2,1 TO 2,1 TO 2,1 TO 2,1 TO 2) AS F32 ' 5 boyut: küçük tensör
FOR g = 1 TO 2
  FOR gun = 1 TO 3
    deney(g, gun, 1, 1) = g * gun
  NEXT gun
NEXT g
PRINT deney(2,3,1,1)
```
## LIST — büyüyen liste
Liste, kaç eleman geleceğini bilmediğin durumlarda kullanılır. Kullanıcı satır satır veri girer, sensör ölçüm yollar, API sayfa sayfa cevap verir; sen listeye eklersin. Liste sıralıdır; aynı değer birden fazla kez bulunabilir.
```uxbasic
DIM adlar AS LIST OF STRING
LIST.ADD adlar, "Ali"
LIST.ADD adlar, "Ayse"
FOR EACH ad IN adlar
  PRINT UCASE(ad)
NEXT ad
```
## DICT — sözlük
Sözlük, anahtardan değere giden hızlı yoldur. Bir balığın adıyla ağırlığını, bir hata koduyla açıklamasını, bir API alanıyla değerini saklayabilirsin. Anahtar benzersizdir; aynı anahtar tekrar yazılırsa genellikle eski değer güncellenir.
```uxbasic
DIM stok AS DICT OF STRING, I32
DICT.SET stok, "yem", 25
DICT.SET stok, "kova", 3
IF DICT.HAS(stok, "yem") THEN PRINT DICT.GET(stok, "yem")
```
## SET — küme
Küme tekrarsız değer tutar. Bir dosyada kaç farklı tür adı geçti, kullanıcı hangi yetkilere sahip, hangi hata kodları görüldü gibi işlerde listeye göre daha temizdir.
```uxbasic
DIM turler AS SET OF STRING
SET.ADD turler, "alabalik"
SET.ADD turler, "alabalik"
SET.ADD turler, "sazan"
PRINT SET.COUNT(turler)
```
## Kanca [hook] ile geliştirme
Kanca, derleyici veya çalışma zamanı aşamasında asıl akışı bozmadan izleme ve ek davranış takma noktasıdır. uXBasic kaynak ağacında AST, HIR, MIR, çalışma zamanı ve kod üretimi için kanca dosyaları bulunur. Bunların temel fikri şudur: ana derleyici dosyasını her seferinde kirletme; ölçmek, raporlamak veya özel deneme yapmak için kanca çağrısını kullan. Kanca kodu varsayılan olarak sessiz olmalı, açıldığında rapor üretmelidir.
```uxbasic
%%DEFINE HOOK_TRACE
IF HOOK_TRACE THEN
  PRINT "MIR asamasi basladi"
END IF
PRINT "normal program akisi bozulmadi"
```
## Sarmalayıcı [wrapper] ile geliştirme
Sarmalayıcı, dış fonksiyonu genç programcının anlayacağı düzgün bir uXBasic fonksiyonuna çevirir. Örneğin `kernel32.dll` içindeki `Beep` doğrudan çağrılabilir; fakat bunu `UyariSesi` adlı fonksiyona sarmalarsan frekans kontrolü, hata mesajı ve test aynı yerde toplanır.
```uxbasic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (BYVAL hz AS I32, BYVAL ms AS I32) AS I32
FUNCTION UyariSesi(hz AS I32, ms AS I32) AS BOOLEAN
  IF hz < 37 OR hz > 32767 THEN RETURN FALSE
  IF ms <= 0 THEN RETURN FALSE
  sonuc = CALL(DLL, "kernel32.dll", "Beep", hz, ms)
  IF sonuc = 0 THEN RETURN FALSE ELSE RETURN TRUE END IF
END FUNCTION
PRINT UyariSesi(880, 200)
```
## EVENT, PIPE, THREAD, PARALEL, SLOT ile anlamlı sistem
Aşağıdaki örnek bir ölçüm sisteminin küçültülmüş modelidir. Olay adı tanımlanır, veri borusu kurulur, arka plan iş ölçüm üretir, yuva ekrana ve dosyaya yazar. GUI'de düğme basılması, tarayıcıda tıklama veya sensör verisi aynı mantıkla bağlanabilir.
```uxbasic
EVENT OlcumGeldi
PIPE OlcumBoru AS F64
THREAD SensorOku
  FOR i = 1 TO 5
    TRIGGER OlcumGeldi, i * 1.25
  NEXT i
END THREAD
SLOT Raporla ON OlcumGeldi
  INPUT deger
  PRINT "olcum="; deger
  OPEN "olcum.csv" FOR APPEND AS #1
  PRINT #1, STR(TIMER()) + ";" + STR(deger)
  CLOSE #1
END SLOT
PARALEL Calisma
  CALL SensorOku()
END PARALEL
```
## Her katman için 7 kısa örnek
### Ön-işleyici hedef seçimi
```uxbasic
%%TARGET browser
%%OUTDIR "dist/web"
%%HTML_LINE <pre id="uxb-console"></pre>
PRINT "tarayici cikisi"
```
### Kaynak dahil etme
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM x AS F64
x = 12.5
PRINT x
```
### Sözcük ve komut yüzeyi
```uxbasic
DIM yas AS I32
INPUT yas
IF yas >= 18 THEN PRINT "yetiskin" ELSE PRINT "genc" END IF
```
### Tip/anlam denetimi
```uxbasic
DIM toplam AS F64
DIM adet AS I32
ASSERT adet >= 0
IF adet > 0 THEN PRINT toplam/adet
```
### MIR/ara iş fikri
```uxbasic
FUNCTION Kare(x AS F64) AS F64
  RETURN x*x
END FUNCTION
PRINT Kare(4)
```
### JS tarayıcı hedefi
```uxbasic
%%TARGET js
PRINT "Bu metin program.js icinden tarayiciya gidebilir"
```
### WAT/WASM hedefi
```uxbasic
%%TARGET wasm
FUNCTION Topla(a AS I32, b AS I32) AS I32
  RETURN a + b
END FUNCTION
PRINT Topla(2,3)
```

## Bölüm 3 ek açıklama akışı

# Değişken, Bellek, Diziler, Veri Yapıları, Nesne ve Eşzamanlılık


## Değişken kuralları

Değişken, bellekte bir kutudur. Tip, bu kutunun nasıl okunacağını söyler. `I32` ile tutulan değer tam sayıdır; `F64` ile tutulan değer kesirli bilimsel sayıdır; `PTR` veya `U64` ile tutulan değer çoğu zaman dış kütüphane handle bilgisidir. Bir handle doğrudan sayı gibi görünür ama aslında dış DLL içindeki nesnenin anahtarıdır.
```uxbasic
DIM ad AS STRING
DIM yas AS I32
DIM sicaklik AS F64
DIM df AS U64
ad = "Mete"
yas = 25
sicaklik = 24.7
PRINT ad; " "; yas; " "; sicaklik
```
## 2, 3, 4 ve 5 boyutlu diziler

Dizi, aynı tipten çok sayıda kutuyu düzenli saklar. İki boyut tablo, üç boyut katmanlı tablo, dört boyut zamanlı hacim, beş boyut deney seti gibi düşünülebilir.
```uxbasic
' 2 boyut: ogrenci x ders not tablosu
DIM notlar(1 TO 3, 1 TO 4) AS F64
FOR ogr = 1 TO 3
    FOR ders = 1 TO 4
        notlar(ogr, ders) = ogr * 10 + ders
    NEXT ders
NEXT ogr
PRINT notlar(2, 3)
```
```uxbasic
' 3 boyut: gun x havuz x olcum
DIM su(1 TO 7, 1 TO 4, 1 TO 3) AS F64
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        su(gun, havuz, 1) = 7.5       ' pH
        su(gun, havuz, 2) = 24.0      ' sicaklik
        su(gun, havuz, 3) = 6.8       ' oksijen
    NEXT havuz
NEXT gun
PRINT su(3, 2, 3)
```
```uxbasic
' 4 boyut: yil x ay x istasyon x parametre
DIM izleme(2024 TO 2026, 1 TO 12, 1 TO 5, 1 TO 6) AS F64
izleme(2026, 5, 2, 1) = 8.1
PRINT izleme(2026, 5, 2, 1)
```
```uxbasic
' 5 boyut: deney x tekrar x zaman x organ x olcum
DIM deney(1 TO 2, 1 TO 3, 1 TO 10, 1 TO 4, 1 TO 5) AS F64
deney(1, 2, 5, 3, 4) = 0.875
PRINT deney(1, 2, 5, 3, 4)
```

## ARRAY, LIST, DICT, SET
|Yapı|Anlam|Ne zaman kullanılır|Dikkat|
|---|---|---|---|
|ARRAY|Sabit veya belirli boyutlu düzenli veri|Matris, tablo, deney ölçümü|indeks hatasına dikkat|
|LIST|Sırası önemli, uzunluğu büyüyen veri|günlük kayıt, hata listesi, öğrenci listesi|çok arama yapılacaksa DICT daha hızlıdır|
|DICT|Anahtar-değer veri|ayar, isimden puan bulma, JSON benzeri yapı|anahtar benzersiz olmalı|
|SET|Benzersiz değerler|tekrarları temizleme, etiket toplama|sıra garantisi bekleme|
```uxbasic
DIM isimler AS LIST
DIM puanlar AS DICT
DIM turler AS SET
LIST.ADD isimler, "Ali"
LIST.ADD isimler, "Ayse"
DICT.SET puanlar, "Ali", 82
DICT.SET puanlar, "Ayse", 91
SET.ADD turler, "alabalik"
SET.ADD turler, "alabalik"
PRINT DICT.GET(puanlar, "Ayse")
```

## Bellek ve pointer ailesi

`VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `PEEK*`, `POKE*`, `MEMCOPY*`, `MEMFILL*` komutları uXBasic'i sistem programlama tarafına taşır. Bu komutlar güçlüdür; yanlış adres verirsen veri bozarsın. Kural: önce küçük tamponda dene, sonra gerçek veriye uygula.
```uxbasic
DIM tampon(0 TO 15) AS BYTE
MEMFILLB VARPTR(tampon(0)), 0, 16
POKEB VARPTR(tampon(0)), 65
PRINT CHR(PEEKB(VARPTR(tampon(0))))
```

## Nesne yönelimli düzen

Sınıf [veri ve davranış kalıbı] (class), aynı veriyle çalışan yordamları aynı çatıya toplar. `PUBLIC`, `PRIVATE`, `PROTECTED`, `METHOD`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE` gibi sözcükler bu çatıyı kurar.
```uxbasic
CLASS Sensor
PUBLIC:
    DIM ad AS STRING
    DIM sonDeger AS F64
    CONSTRUCTOR Sensor(yeniAd AS STRING)
        ad = yeniAd
        sonDeger = 0
    END CONSTRUCTOR
    METHOD Oku(deger AS F64)
        sonDeger = deger
    END METHOD
    METHOD Yaz()
        PRINT ad; "="; sonDeger
    END METHOD
END CLASS
DIM s AS Sensor
s = NEW Sensor("pH")
s.Oku(7.8)
s.Yaz()
DELETE s
```

## EVENT, PIPE, THREAD, PARALEL, SLOT

Olay sistemi, bir programda “şu olursa bu çalışsın” demektir. `EVENT` olay adını, `SLOT` olaya bağlanan işi, `TRIGGER` olayı ateşlemeyi, `PIPE` veri yolunu, `THREAD` ayrı iş parçacığını, `PARALEL` eşzamanlı iş fikrini taşır.
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
```uxbasic
THREAD DosyaOkuyucu
    OPEN "olcum.csv" FOR INPUT AS #1
    INPUT #1, satir
    CLOSE #1
END THREAD
PARALEL Analiz
    PRINT "Ana program donmadan analiz basladi"
END PARALEL
```

## Veri yapılarının her biri için derin kullanım defteri

Bir veri yapısını öğrenmenin en iyi yolu, onu gerçek hayattaki kutuya benzetmektir. `ARRAY` numaralı raf, `LIST` uzayan liste, `DICT` etiketli çekmece, `SET` tekrar kabul etmeyen sepet, `OBJECT` davranışı olan varlık, `PTR` ise dış dünyadaki bir şeyin adres pusulasıdır.

### ARRAY: düzenli ve hızlı ölçüm tablosu

Sözdizimi: `DIM ad(alt TO ust, ...) AS tip`. Sabit ölçüm tablosu, matris, görüntü, deney planı ve oyun tahtası için uygundur.

```uxbasic
DIM ph(1 TO 7, 1 TO 4) AS F64
DIM gun AS I32
DIM havuz AS I32
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        ph(gun, havuz) = 7.2 + gun * 0.01 + havuz * 0.02
    NEXT havuz
NEXT gun
PRINT "3. gun 2. havuz pH="; ph(3, 2)
```

İpucu: İki boyutlu dizi tablo gibi okunur. Birinci indeks satır, ikinci indeks sütun gibi düşünülür. Bilimsel ölçümde indeksleri isimlendiremiyorsan yanına açıklayıcı sabit koy: `PH_COL = 1`, `TEMP_COL = 2`.

### 3 boyutlu ARRAY: zaman, yer, ölçüm

```uxbasic
DIM olcum(1 TO 30, 1 TO 6, 1 TO 3) AS F64
DIM g AS I32, h AS I32
FOR g = 1 TO 30
    FOR h = 1 TO 6
        olcum(g,h,1)=7.5
        olcum(g,h,2)=24.0
        olcum(g,h,3)=6.4
    NEXT h
NEXT g
PRINT olcum(10,3,2)
```

### 4 boyutlu ARRAY: zamanlı hacim

```uxbasic
DIM sensor(2026 TO 2027, 1 TO 12, 1 TO 31, 1 TO 8) AS F64
sensor(2026,5,30,1)=24.8
sensor(2026,5,30,2)=7.9
PRINT "Bugun sensor1="; sensor(2026,5,30,1)
```

### 5 boyutlu ARRAY: deney evreni

```uxbasic
DIM deneme(1 TO 3, 1 TO 5, 1 TO 4, 1 TO 10, 1 TO 6) AS F64
' grup, tekrar, tank, zaman, parametre
deneme(2,3,1,7,4)=0.912
PRINT "7. zamanda 4. parametre="; deneme(2,3,1,7,4)
```

### LIST: olay günlüğü ve büyüyen sıra

Sözdizimi: `DIM ad AS LIST`, `LIST.ADD ad, deger`, `LIST.GET(ad, sira)`. Uzunluğu sonradan belli olan şeylerde kullanılır.

```uxbasic
DIM loglar AS LIST
LIST.ADD loglar, "Basladi"
LIST.ADD loglar, "Veri okundu"
LIST.ADD loglar, "Rapor yazildi"
PRINT LIST.GET(loglar, 2)
```

Gerçek iş: hata günlüğü tut, testlerde hangi dosya geçti yaz, kullanıcıya son işlemleri göster. `ARRAY` kullanırsan başta boyut bilmen gerekir; `LIST` bu zorunluluğu kaldırır.

### DICT: adı bilinen değere hızlı ulaşma

Sözdizimi: `DIM ad AS DICT`, `DICT.SET ad, anahtar, deger`, `DICT.GET(ad, anahtar)`. Ayar, JSON benzeri veri, istasyon adı, kullanıcı rolü ve sembol tablosu için uygundur.

```uxbasic
DIM ayar AS DICT
DICT.SET ayar, "hedef", "browser"
DICT.SET ayar, "outdir", "dist/web"
DICT.SET ayar, "debug", "true"
PRINT "Hedef="; DICT.GET(ayar, "hedef")
```

Derleyici yazarken `DICT` altın değerindedir. Lexer bir kelime gördüğünde anahtar kelime mi diye `DICT` içinde arayabilir. Parser bir değişken gördüğünde sembol tablosuna `DICT.SET symbol, ad, tip` diyebilir.

### SET: tekrarları temizleyen sepet

Sözdizimi: `DIM ad AS SET`, `SET.ADD ad, deger`, `SET.HAS(ad, deger)`. Bir şeyi bir kez saymak istediğinde kullanılır.

```uxbasic
DIM turler AS SET
SET.ADD turler, "alabalik"
SET.ADD turler, "sazan"
SET.ADD turler, "alabalik"
IF SET.HAS(turler, "sazan") THEN PRINT "Sazan listede var"
```

İpucu: Bir CSV dosyasından gelen şehir adlarını temizlemek istiyorsan önce `SET`, sonra rapor için `LIST` kullan. Böylece hem tekrar gider hem sıralı yazdırırsın.

## Program içi tablolar: sembol, tip, sabit ve hata tabloları

uXBasic gibi bir derleyicide tablolar programın hafızasıdır. Sembol tablosu değişken adını tipe bağlar. Tip tablosu hangi tipin kaç bayt olduğunu tutar. Sabit tablosu tekrar eden metin ve sayıları saklar. Hata tablosu satır, sütun, kod ve açıklamayı bir arada taşır.

```uxbasic
DIM symbol AS DICT
DIM types AS DICT
DIM errors AS LIST
DICT.SET types, "I32", 4
DICT.SET types, "F64", 8
DICT.SET symbol, "sicaklik", "F64"
IF DICT.GET(symbol, "sicaklik") <> "F64" THEN LIST.ADD errors, "Tip uyumsuz"
PRINT "sicaklik tipi="; DICT.GET(symbol, "sicaklik")
```

Genç programcı için kural: Bir program büyüdükçe `IF` sayısını azaltmak için tablo kullan. Yüz satırlık `IF kelime = ...` zinciri yerine `DICT` ile anahtar aramak daha temizdir.

## Dosya ve dizin işleriyle gerçek belge üretimi

Dosya işlemleri programcının dış hafızasıdır. `OPEN` dosyayı açar, `PRINT #` yazar, `INPUT #` okur, `EOF` dosya sonunu sorar, `LOF` uzunluk verir, `SEEK` konum değiştirir, `CLOSE` kapatır.

```uxbasic
DIM satir AS STRING
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "uXBasic raporu"
PRINT #1, "pH=7.8"
CLOSE #1

OPEN "rapor.txt" FOR INPUT AS #2
WHILE NOT EOF(2)
    LINE INPUT #2, satir
    PRINT satir
WEND
CLOSE #2
```

Eklemeli yazma günlük için kullanılır:

```uxbasic
OPEN "log.txt" FOR APPEND AS #1
PRINT #1, TIMER(); " islem tamam"
CLOSE #1
```

## Nesne, namespace, module, alias, using module

`NAMESPACE` ad çakışmasını önler. `MODULE` bir iş ailesini toplar. `ALIAS` uzun adı kısa ada bağlar. `USING MODULE` o modülün adlarını görünür kılar. Büyük projede bunlar lüks değil, düzen şartıdır.

```uxbasic
NAMESPACE SuUrunleri
MODULE Yem
    FUNCTION Oran(ByVal protein AS F64, ByVal yag AS F64) AS F64
        RETURN protein / (protein + yag)
    END FUNCTION
END MODULE
END NAMESPACE

USING MODULE SuUrunleri.Yem
ALIAS RASYON_ORANI = Oran
PRINT RASYON_ORANI(42.0, 12.0)
```

Sözlük kuralı: Programın ana işini anlatan adlar uzun ve temiz olsun; sık kullanılan adlar `ALIAS` ile kısaltılsın. `x`, `y`, `z` sadece küçük matematik döngüsünde iyidir.

## Olay, boru, slot, iş parçacığı ve koşut çalışma

Olay sistemi, bir şey olduğunda başka bir işi çağırma biçimidir. `EVENT` olay adını tanımlar, `SLOT` olaya bağlanan işi tarif eder, `TRIGGER` olayı ateşler. `PIPE` iki işi birbirine veri borusuyla bağlar. `THREAD` ayrı iş parçacığı açar. `PARALEL` bağımsız işleri birlikte koşturmak için düşünülür.

```uxbasic
EVENT YeniOlcum
SLOT Yazdir ON YeniOlcum
    PRINT "Yeni olcum geldi"
END SLOT
TRIGGER YeniOlcum
```

Veri borusu örneği:

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

Koşut analiz örneği:

```uxbasic
PARALEL
    CALL HesaplaOrtalama()
    CALL HesaplaSapma()
    CALL RaporHazirla()
END PARALEL
PRINT "Uc is birlikte planlandi"
```

Yedi katmanlı düşünme ipucu: Lexer olay adını kelime yapar; parser olay düğümünü kurar; AST olay ağacını taşır; HIR düzenler; MIR çağrıya indirir; runtime olay tablosunu yürütür; backend hedefe göre JS, WAT veya native çağrı üretir.

## Katmanlara yönelik yedi küçük geliştirme örneği

1. **Lexer örneği:** Yeni kelime eklemeden önce onun başka yerde değişken adı olarak kullanılıp kullanılmadığını test et.
2. **Parser örneği:** Her yeni komut için en küçük programı yaz: `KOMUT`, `KOMUT + IF`, `KOMUT + LOOP`, `KOMUT + FUNCTION`, `KOMUT + HATA`.
3. **AST örneği:** Düğüm adını görevine göre koy; `PRINT_STMT` komuttur, `CALL_EXPR` değer döndürebilir.
4. **HIR örneği:** Şeker sözdizimini sade forma indir. `INC A` aslında `A = A + 1` gibi düşünülür.
5. **MIR örneği:** Backendlerin ortak anlayacağı işlem üret; JS ve WAT aynı MIR bilgisinden beslenir.
6. **Runtime örneği:** Dosya, bellek, olay ve DLL çağrısı burada gerçekten çalışır; hata kodu burada netleşir.
7. **Backend örneği:** Aynı programı `--emit-js`, `--emit-wat`, `--emit-x64-nasm` ile çıkar; sonuçlar farklı dosya ama aynı niyet olmalıdır.

## Değişkenler, Veri Yapıları, Nesne Düzeni, Dosya, Olay ve Dış Bağlantı

## Ana değişken düşüncesi

Değişken, programın kısa süreli hafızasıdır. Bir balık tartım çizelgesinde `agirlik`, `boy`, `tankNo`, `tarih` gibi adlar değişkendir. İyi değişken adı, yorum satırı okumadan anlam verir. `x` kısa deneme için olur; gerçek programda `gunlukYemMiktari` daha iyidir.

```basic
DIM tankNo AS I32
DIM balikSayisi AS I32
DIM ortalamaAgirlik AS F64
DIM notlar AS STRING
```

Değişken sınırı tipten gelir. `U8` 0..255 tutar; tank sayısı 300 olursa taşar. `I32` çoğu günlük sayı için güvenlidir. `F64` bilimsel hesaplarda iyi başlangıçtır. `BIGF`, `BIGD`, `F80`, `F128` uzun duyarlık gereken hesaplarda dış geniş sayı kütüphaneleriyle kullanılır.

## 1 boyutlu dizi

```basic
DIM sicaklik(7) AS F64
FOR i = 1 TO 7
    sicaklik(i) = 20.0 + i * 0.5
NEXT
PRINT sicaklik(3)
```

Bir boyutlu dizi defterde tek sütun gibidir. Gün gün sıcaklık, öğrenci notu, ölçüm listesi için kullanılır.

## 2 boyutlu dizi

```basic
DIM tablo(3, 4) AS F64
FOR satir = 1 TO 3
    FOR sutun = 1 TO 4
        tablo(satir, sutun) = satir * 10 + sutun
    NEXT
NEXT
PRINT tablo(2, 3)
```

İki boyut tablo gibidir: satır ve sütun. Laboratuvar denemesinde satır örnek, sütun ölçüm olabilir.

## 3 boyutlu dizi

```basic
DIM tankGunParam(4, 7, 3) AS F64
' tank, gun, parametre: 1=sicaklik 2=pH 3=oksijen
FOR tank = 1 TO 4
    FOR gun = 1 TO 7
        tankGunParam(tank, gun, 1) = 22.0
        tankGunParam(tank, gun, 2) = 7.4
        tankGunParam(tank, gun, 3) = 6.8
    NEXT
NEXT
```

Üç boyut kutu gibidir. Tank, gün, parametre gibi üç eksenli veriler için uygundur.

## 4 boyutlu dizi

```basic
DIM deney(2, 4, 7, 3) AS F64
' grup, tank, gun, parametre
FOR grup = 1 TO 2
    FOR tank = 1 TO 4
        FOR gun = 1 TO 7
            deney(grup, tank, gun, 1) = 20 + grup
        NEXT
    NEXT
NEXT
```

Dört boyutta ilk eksen deneme grubu olabilir. Böylece kontrol ve uygulama grupları ayrı tutulur.

## 5 boyutlu dizi

```basic
DIM buyukDeney(2, 3, 4, 7, 5) AS F64
' yil, lokasyon, tank, gun, parametre
buyukDeney(1, 2, 3, 4, 5) = 12.75
PRINT buyukDeney(1, 2, 3, 4, 5)
```

Beş boyut büyük bilimsel veride kullanılır. İpucu: beş boyuta çıktıysan mutlaka her eksenin anlamını yorum olarak yaz. Yoksa iki hafta sonra sen bile unutursun.

## ARRAY, LIST, DICT, SET

| Yapı | Ne zaman kullanılır | Örnek söz dizimi |
|---|---|---|
| ARRAY | Boyutu belli ve hızlı erişim gereken veri | `DIM a(100) AS F64` |
| LIST | Boyu büyüyen sıra listesi | `CALL uxcollections_list_push_f64(l, 3.14)` |
| DICT | Anahtar-değer sözlüğü | `CALL uxcollections_dict_set_f64(d, "pH", 7.2)` |
| SET | Tekrarsız değer kümesi | `CALL uxcollections_set_add(s, "tank1")` |

```basic
INCLUDE "modules/uxcollections.uxmh"
DIM liste AS PTR
liste = CALL uxcollections_list_new()
CALL uxcollections_list_push_f64(liste, 10.5)
CALL uxcollections_list_push_f64(liste, 11.0)
PRINT CALL uxcollections_list_count(liste)
CALL uxcollections_list_free(liste)
```

Liste sıra tutar, sözlük anlam tutar, küme tekrarları engeller. Derleyici yazarken `DICT` sembol tablosuna benzer: ad verirsin, karşılığında tip veya adres alırsın.

## TYPE ile kayıt

```basic
TYPE BalikOlcumu
    tank AS I32
    boy AS F64
    agirlik AS F64
END TYPE

DIM o AS BalikOlcumu
o.tank = 2
o.boy = 14.5
o.agirlik = 38.2
PRINT o.agirlik
```

`TYPE`, birden çok değeri tek ad altında toplar. CSV satırı, öğrenci, ürün, sensör kaydı için kullanılır.

## CLASS ile nesne

```basic
CLASS Tank
    DIM hacimLitre AS F64
    DIM balikSayisi AS I32

    METHOD Yogunluk() AS F64
        RETURN balikSayisi / hacimLitre
    END METHOD
END CLASS

DIM t AS Tank
t.hacimLitre = 1000
t.balikSayisi = 250
PRINT t.Yogunluk()
```

Sınıf [veri ve davranışı birleştiren yapı] (class), veriyi ve o verinin işini bir yerde tutar. `TYPE` defter satırı gibidir; `CLASS` küçük makine gibidir.

## NAMESPACE, MODULE, USING, ALIAS

```basic
NAMESPACE Bilim
    MODULE Istatistik
        FUNCTION Ortalama(a AS F64, b AS F64) AS F64
            RETURN (a + b) / 2
        END FUNCTION
    END MODULE
END NAMESPACE

USING Bilim
ALIAS ORT = Bilim.Istatistik.Ortalama
PRINT ORT(10, 20)
```

`NAMESPACE` ad çakışmasını önler. `MODULE` bir işi paketler. `USING` uzun yolu kısaltır. `ALIAS` eski adla yeni adı bağlar. Büyük projelerde bu dört komut temizlik sağlar.

## INCLUDE ve IMPORT

```basic
INCLUDE "core.uxmh"
INCLUDE "modules/uxstats.uxmh"
IMPORT(C, "src/native/hizli_toplam.c")
IMPORT(CPP, "src/native/grafik.cpp")
IMPORT(ASM, "src/native/kopyala.asm")
```

`INCLUDE` uXBasic başlık/kaynak parçası ekler. `IMPORT` derleme zamanında dış C/C++/ASM dosyasını zincire alır. DLL çağırmak için `IMPORT DLL` kullanılmaz; DLL için `DECLARE ... LIB ... ALIAS ...` veya `CALL(DLL,...)` yolu kullanılır.

## DLL ve Windows API

```basic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (freq AS I32, ms AS I32) AS I32
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32

CALL Beep(750, 300)
CALL MessageBoxA(0, "uXBasic calisiyor", "Bilgi", 0)
```

DLL çağırırken tip eşleşmesi hayatidir. Windows API yanlış parametreyle çağrılırsa program çökebilir. Önce küçük ve zararsız API ile dene. `Beep` iyi ilk örnektir.

## Dosya yazma, okuma, ekleme

```basic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Deney Raporu"
PRINT #1, "pH=7.4"
CLOSE #1

OPEN "rapor.txt" FOR APPEND AS #1
PRINT #1, "Yeni satir eklendi"
CLOSE #1

OPEN "rapor.txt" FOR INPUT AS #1
INPUT #1, satir
PRINT satir
CLOSE #1
```

Dosya açıldıysa kapat. Bu basit kuraldır. Dosyayı kapatmazsan veri tamponda kalabilir.

## Terminal ve dış programla iletişim

```basic
CALL(API, "system", "dir")
CALL(API, "system", "curl https://example.com")
```

Dış program çağırmak güçlüdür ama tehlikelidir. Kullanıcıdan aldığın metni doğrudan terminal komutuna ekleme. Önce izin verilen komut listesi yap.

## Olay, boru, iş parçacığı ve yuva

```basic
EVENT OlcumGeldi(tank AS I32, deger AS F64)

SLOT OlcumuYaz(tank AS I32, deger AS F64)
    PRINT "Tank=" + STR(tank) + " Deger=" + STR(deger)
END SLOT

ON OlcumGeldi CALL OlcumuYaz
TRIGGER OlcumGeldi(3, 7.25)
```

```basic
PIPE HamVeri TO Temizleyici
THREAD Temizleyici()
PARALEL
    CALL SensorOku()
    CALL AnalizYap()
END PARALEL
```

`EVENT` haber verir. `SLOT` haberi alır. `PIPE` veri taşır. `THREAD` aynı anda iş yapar. `PARALEL` işleri bölüştürür. İpucu: paylaşılan değişkene aynı anda yazdırma; önce her iş kendi sonucunu üretsin, sonra birleştir.


# Bölüm 4 — Kütüphaneler ve Dış Çalışma Zamanı

# Kütüphaneler ve Dış Çalışma Zamanı Fonksiyonları

Bu ciltte bütün kütüphanelerin çalıştığı varsayılır. Kütüphane kullanmanın ana kuralı şudur: önce dahil et, sonra handle veya değer üret, dönüşü kontrol et, işi yap, en sonda kaynağı kapat. Yeni komut eklemek yerine `INCLUDE`, `NAMESPACE`, `MODULE`, `ALIAS`, `USING`, `DECLARE`, `CALL(DLL,...)` ve sarmalayıcı dosyaları kullanılır.

|No|Kütüphane|Fonksiyon|Dahil etme|Görev alanı|
|---|---|---|---|---|
|1|bigfp|37|INCLUDE "include/modules/bigfp.uxmh"|Çok büyük ve çok hassas sayı ailesidir. BIGF ikili yüksek duyarlık, BIGD ondalık yüksek duyarlık, BALL ise aralık/top temelli güvenli yaklaşık hesap için kullanılır.|
|2|fp128|11|INCLUDE "include/modules/fp128.uxmh"|128 bit kayan nokta hesaplarını dış çalışma zamanı ile sağlar.|
|3|fp80|11|INCLUDE "include/modules/fp80.uxmh"|80 bit genişletilmiş kayan nokta hesaplarını dış çalışma zamanı ile sağlar.|
|4|uxaimath|41|INCLUDE "include/modules/uxaimath.uxmh"|Yapay zeka matematiği, aktivasyon, kayıp ve gradyan işlemleri sağlar.|
|5|uxcollections|0|INCLUDE "include/modules/uxcollections.uxmh"|LIST, DICT, SET gibi koleksiyonların çalışma zamanı tarafını sağlar.|
|6|uxdataframe|31|INCLUDE "include/modules/uxdataframe.uxmh"|CSV, Parquet, SQL benzeri tablo işlemleri ve veri çerçevesi yönetimi sağlar.|
|7|uxgraph|30|INCLUDE "include/modules/uxgraph.uxmh"|Düğüm-kenar yapıları, bağlantı, derece, yol ve ağ ölçümleri sağlar.|
|8|uxllama|18|INCLUDE "include/modules/uxllama.uxmh"|Yerel llama.cpp veya benzeri komut satırı modelini uXBasic üzerinden konuşturur.|
|9|uxmath|42|INCLUDE "include/modules/uxmath.uxmh"|Polinom, türev, integral, diferansiyel denklem ve sayısal matematik yardımcıları sağlar.|
|10|uxmathcore|66|INCLUDE "include/modules/uxmathcore.uxmh"|Tipli tampon, ham matematik belleği ve düşük seviye veri taşıma çekirdeği sağlar.|
|11|uxmatrix|43|INCLUDE "include/modules/uxmatrix.uxmh"|Matris oluşturma, okuma, yazma, çarpma, çözme ve doğrusal cebir sağlar.|
|12|uxnn|32|INCLUDE "include/modules/uxnn.uxmh"|Basit sinir ağı, nöron, katman ve eğitim yordamları sağlar.|
|13|uxnn2|23|INCLUDE "include/modules/uxnn2.uxmh"|Daha düzenli ağ, katman ve optimizer yüzeyi sağlar.|
|14|uxnn3|38|INCLUDE "include/modules/uxnn3.uxmh"|Veri kümesi, CSV yükleme, model eğitim ve kayıt düzenini genişletir.|
|15|uxonnx|22|INCLUDE "include/modules/uxonnx.uxmh"|ONNX modeli açma, tensör oluşturma ve çıkarım yapma köprüsüdür.|
|16|uxonnx2|43|INCLUDE "include/modules/uxonnx2.uxmh"|ONNX oturumlarını daha ayrıntılı tip, giriş/çıkış ve provider desteğiyle yönetir.|
|17|uxstats|40|INCLUDE "include/modules/uxstats.uxmh"|Temel tanımlayıcı istatistik ve vektör işlemleri sağlar.|
|18|uxstats2|56|INCLUDE "include/modules/uxstats2.uxmh"|Hipotez testleri, p değeri, korelasyon, kovaryans, T/F/Ki-kare gibi ileri istatistikleri sağlar.|
|19|uxtensor|44|INCLUDE "include/modules/uxtensor.uxmh"|1-5 boyutlu tensör, dilimleme, şekil, veri adresi ve temel tensor işlemleri sağlar.|

## 1. bigfp

Çok büyük ve çok hassas sayı ailesidir. BIGF ikili yüksek duyarlık, BIGD ondalık yüksek duyarlık, BALL ise aralık/top temelli güvenli yaklaşık hesap için kullanılır. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxb_big_runtime_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = bigfp.uxb_big_runtime_version(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_big_runtime_version",...)|
|2|uxb_bigf_handle_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = bigfp.uxb_bigf_handle_size(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_handle_size",...)|
|3|uxb_bigd_handle_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = bigfp.uxb_bigd_handle_size(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_handle_size",...)|
|4|uxb_ball_handle_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = bigfp.uxb_ball_handle_size(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_handle_size",...)|
|5|uxb_bigf_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = bigfp.uxb_bigf_init(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_init",...)|
|6|uxb_bigf_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = bigfp.uxb_bigf_free(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_free",...)|
|7|uxb_bigf_precision|Hesap duyarlılığını ayarlar veya okur; büyük sayı işlemlerinde kaç basamak güvenileceğini belirler.|sonuc = bigfp.uxb_bigf_precision(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_precision",...)|
|8|uxb_bigf_from_str|Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir.|sonuc = bigfp.uxb_bigf_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_from_str",...)|
|9|uxb_bigf_to_str|Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır.|sonuc = bigfp.uxb_bigf_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_to_str",...)|
|10|uxb_bigf_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = bigfp.uxb_bigf_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_copy",...)|
|11|uxb_bigf_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_bigf_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_add",...)|
|12|uxb_bigf_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_bigf_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_sub",...)|
|13|uxb_bigf_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_bigf_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_mul",...)|
|14|uxb_bigf_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_bigf_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_div",...)|
|15|uxb_bigf_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_bigf_cmp(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_cmp",...)|
|16|uxb_bigd_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = bigfp.uxb_bigd_init(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_init",...)|
|17|uxb_bigd_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = bigfp.uxb_bigd_free(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_free",...)|
|18|uxb_bigd_precision_digits|Ondalık duyarlılık için basamak sayısını ayarlar veya okur; para, ölçüm ve bilimsel hesapta yuvarlama hatasını azaltır.|sonuc = bigfp.uxb_bigd_precision_digits(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_precision_digits",...)|
|19|uxb_bigd_from_str|Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir.|sonuc = bigfp.uxb_bigd_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_from_str",...)|
|20|uxb_bigd_to_str|Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır.|sonuc = bigfp.uxb_bigd_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_to_str",...)|
|21|uxb_bigd_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = bigfp.uxb_bigd_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_copy",...)|
|22|uxb_bigd_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_bigd_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_add",...)|
|23|uxb_bigd_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_bigd_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_sub",...)|
|24|uxb_bigd_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_bigd_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_mul",...)|
|25|uxb_bigd_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_bigd_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_div",...)|
|26|uxb_bigd_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_bigd_cmp(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_cmp",...)|
|27|uxb_ball_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = bigfp.uxb_ball_init(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_init",...)|
|28|uxb_ball_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = bigfp.uxb_ball_free(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_free",...)|
|29|uxb_ball_precision|Hesap duyarlılığını ayarlar veya okur; büyük sayı işlemlerinde kaç basamak güvenileceğini belirler.|sonuc = bigfp.uxb_ball_precision(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_precision",...)|
|30|uxb_ball_from_str|Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir.|sonuc = bigfp.uxb_ball_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_from_str",...)|
|31|uxb_ball_to_str|Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır.|sonuc = bigfp.uxb_ball_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_to_str",...)|
|32|uxb_ball_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = bigfp.uxb_ball_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_copy",...)|
|33|uxb_ball_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_ball_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_add",...)|
|34|uxb_ball_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_ball_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_sub",...)|
|35|uxb_ball_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_ball_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_mul",...)|
|36|uxb_ball_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_ball_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_div",...)|
|37|uxb_ball_cmp_mid|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_ball_cmp_mid(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_cmp_mid",...)|

### bigfp fonksiyonlarını okuma yöntemi
- **1. `uxb_big_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxb_bigf_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxb_bigd_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxb_ball_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxb_bigf_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxb_bigf_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxb_bigf_precision`** — Hesap duyarlılığını ayarlar veya okur; büyük sayı işlemlerinde kaç basamak güvenileceğini belirler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxb_bigf_from_str`** — Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxb_bigf_to_str`** — Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxb_bigf_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxb_bigf_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxb_bigf_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxb_bigf_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxb_bigf_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxb_bigf_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxb_bigd_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxb_bigd_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxb_bigd_precision_digits`** — Ondalık duyarlılık için basamak sayısını ayarlar veya okur; para, ölçüm ve bilimsel hesapta yuvarlama hatasını azaltır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxb_bigd_from_str`** — Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxb_bigd_to_str`** — Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxb_bigd_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxb_bigd_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxb_bigd_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxb_bigd_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxb_bigd_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxb_bigd_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxb_ball_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxb_ball_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxb_ball_precision`** — Hesap duyarlılığını ayarlar veya okur; büyük sayı işlemlerinde kaç basamak güvenileceğini belirler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxb_ball_from_str`** — Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxb_ball_to_str`** — Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxb_ball_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxb_ball_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxb_ball_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxb_ball_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxb_ball_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxb_ball_cmp_mid`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/bigfp.uxmh"
DIM a AS BIGD(80)
DIM b AS BIGD(80)
DIM c AS BIGD(80)
a = BIGINIT("BIGD", "12345678901234567890.25", 80)
b = BIGINIT("BIGD", "0.75", 80)
c = a + b
IF c > a THEN PRINT "hassas toplama="; c
```

## 2. fp128

128 bit kayan nokta hesaplarını dış çalışma zamanı ile sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxb_f128_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = fp128.uxb_f128_size(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_size",...)|
|2|uxb_f128_storage_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = fp128.uxb_f128_storage_size(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_storage_size",...)|
|3|uxb_f128_zero|Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır.|sonuc = fp128.uxb_f128_zero(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_zero",...)|
|4|uxb_f128_from_str|Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir.|sonuc = fp128.uxb_f128_from_str(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_from_str",...)|
|5|uxb_f128_to_str|Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır.|sonuc = fp128.uxb_f128_to_str(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_to_str",...)|
|6|uxb_f128_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = fp128.uxb_f128_copy(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_copy",...)|
|7|uxb_f128_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = fp128.uxb_f128_add(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_add",...)|
|8|uxb_f128_sub|Çıkarma işlemi yapar.|sonuc = fp128.uxb_f128_sub(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_sub",...)|
|9|uxb_f128_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = fp128.uxb_f128_mul(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_mul",...)|
|10|uxb_f128_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = fp128.uxb_f128_div(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_div",...)|
|11|uxb_f128_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = fp128.uxb_f128_cmp(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_cmp",...)|

### fp128 fonksiyonlarını okuma yöntemi
- **1. `uxb_f128_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxb_f128_storage_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxb_f128_zero`** — Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxb_f128_from_str`** — Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxb_f128_to_str`** — Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxb_f128_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxb_f128_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxb_f128_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxb_f128_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxb_f128_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxb_f128_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/fp128.uxmh"
a = fp128.from_str("1.234567890123")
b = fp128.from_str("2.0")
c = fp128.mul(a,b)
PRINT fp128.to_str(c)
CALL fp128.free(a): CALL fp128.free(b): CALL fp128.free(c)
```

## 3. fp80

80 bit genişletilmiş kayan nokta hesaplarını dış çalışma zamanı ile sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxb_f80_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = fp80.uxb_f80_size(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_size",...)|
|2|uxb_f80_storage_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = fp80.uxb_f80_storage_size(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_storage_size",...)|
|3|uxb_f80_zero|Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır.|sonuc = fp80.uxb_f80_zero(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_zero",...)|
|4|uxb_f80_from_str|Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir.|sonuc = fp80.uxb_f80_from_str(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_from_str",...)|
|5|uxb_f80_to_str|Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır.|sonuc = fp80.uxb_f80_to_str(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_to_str",...)|
|6|uxb_f80_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = fp80.uxb_f80_copy(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_copy",...)|
|7|uxb_f80_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = fp80.uxb_f80_add(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_add",...)|
|8|uxb_f80_sub|Çıkarma işlemi yapar.|sonuc = fp80.uxb_f80_sub(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_sub",...)|
|9|uxb_f80_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = fp80.uxb_f80_mul(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_mul",...)|
|10|uxb_f80_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = fp80.uxb_f80_div(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_div",...)|
|11|uxb_f80_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = fp80.uxb_f80_cmp(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_cmp",...)|

### fp80 fonksiyonlarını okuma yöntemi
- **1. `uxb_f80_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxb_f80_storage_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxb_f80_zero`** — Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxb_f80_from_str`** — Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxb_f80_to_str`** — Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxb_f80_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxb_f80_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxb_f80_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxb_f80_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxb_f80_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxb_f80_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/fp80.uxmh"
a = fp80.from_str("1.234567890123")
b = fp80.from_str("2.0")
c = fp80.mul(a,b)
PRINT fp80.to_str(c)
CALL fp80.free(a): CALL fp80.free(b): CALL fp80.free(c)
```

## 4. uxaimath

Yapay zeka matematiği, aktivasyon, kayıp ve gradyan işlemleri sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxaimath_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxaimath.uxaimath_version(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_version",...)|
|2|uxaimath_backend|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_backend(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_backend",...)|
|3|uxaimath_seed|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_seed(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_seed",...)|
|4|uxaimath_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_sigmoid(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sigmoid",...)|
|5|uxaimath_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_relu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_relu",...)|
|6|uxaimath_leaky_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_leaky_relu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_leaky_relu",...)|
|7|uxaimath_elu|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_elu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_elu",...)|
|8|uxaimath_gelu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_gelu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_gelu",...)|
|9|uxaimath_swish|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_swish(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_swish",...)|
|10|uxaimath_softplus|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_softplus(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softplus",...)|
|11|uxaimath_leaky_relu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_leaky_relu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_leaky_relu_inplace_f64",...)|
|12|uxaimath_elu_inplace_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_elu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_elu_inplace_f64",...)|
|13|uxaimath_softmax_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_softmax_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softmax_f64",...)|
|14|uxaimath_softmax_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_softmax_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softmax_inplace_f64",...)|
|15|uxaimath_mse_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mse_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mse_f64",...)|
|16|uxaimath_mae_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mae_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mae_f64",...)|
|17|uxaimath_huber_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_huber_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_huber_f64",...)|
|18|uxaimath_bce_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_bce_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_bce_f64",...)|
|19|uxaimath_cce_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_cce_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_cce_f64",...)|
|20|uxaimath_mse_grad_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mse_grad_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mse_grad_f64",...)|
|21|uxaimath_bce_grad_f64|Öğrenme için türev/gradyan üretir.|sonuc = uxaimath.uxaimath_bce_grad_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_bce_grad_f64",...)|
|22|uxaimath_fill_zero_f64|Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır.|sonuc = uxaimath.uxaimath_fill_zero_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_zero_f64",...)|
|23|uxaimath_fill_one_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_fill_one_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_one_f64",...)|
|24|uxaimath_fill_uniform_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_fill_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_uniform_f64",...)|
|25|uxaimath_fill_normal_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxaimath.uxaimath_fill_normal_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_normal_f64",...)|
|26|uxaimath_xavier_uniform_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_xavier_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_xavier_uniform_f64",...)|
|27|uxaimath_he_uniform_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_he_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_he_uniform_f64",...)|
|28|uxaimath_clip_value_f64|p değeri hesaplar; sonucun rastlantıyla açıklanma olasılığını yorumlamak için kullanılır.|sonuc = uxaimath.uxaimath_clip_value_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_clip_value_f64",...)|
|29|uxaimath_clip_norm_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_clip_norm_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_clip_norm_f64",...)|
|30|uxaimath_sgd_update_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_sgd_update_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sgd_update_f64",...)|
|31|uxaimath_momentum_update_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_momentum_update_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_momentum_update_f64",...)|
|32|uxaimath_dense_forward_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_dense_forward_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_dense_forward_f64",...)|
|33|uxaimath_dense_batch_forward_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_dense_batch_forward_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_dense_batch_forward_f64",...)|
|34|uxaimath_argmax_f64|En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır.|sonuc = uxaimath.uxaimath_argmax_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_argmax_f64",...)|
|35|uxaimath_binary_accuracy_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_binary_accuracy_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_binary_accuracy_f64",...)|
|36|name|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.name(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","name",...)|
|37|uxaimath_sigmoid_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_sigmoid_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sigmoid_inplace_f64",...)|
|38|uxaimath_tanh_inplace_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_tanh_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_tanh_inplace_f64",...)|
|39|uxaimath_relu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_relu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_relu_inplace_f64",...)|
|40|uxaimath_gelu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_gelu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_gelu_inplace_f64",...)|
|41|uxaimath_swish_inplace_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxaimath.uxaimath_swish_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_swish_inplace_f64",...)|

### uxaimath fonksiyonlarını okuma yöntemi
- **1. `uxaimath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxaimath_backend`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxaimath_seed`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxaimath_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxaimath_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxaimath_leaky_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxaimath_elu`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxaimath_gelu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxaimath_swish`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxaimath_softplus`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxaimath_leaky_relu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxaimath_elu_inplace_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxaimath_softmax_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxaimath_softmax_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxaimath_mse_f64`** — Model hatası/kayıp değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxaimath_mae_f64`** — Model hatası/kayıp değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxaimath_huber_f64`** — Model hatası/kayıp değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxaimath_bce_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxaimath_cce_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxaimath_mse_grad_f64`** — Model hatası/kayıp değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxaimath_bce_grad_f64`** — Öğrenme için türev/gradyan üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxaimath_fill_zero_f64`** — Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxaimath_fill_one_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxaimath_fill_uniform_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxaimath_fill_normal_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxaimath_xavier_uniform_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxaimath_he_uniform_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxaimath_clip_value_f64`** — p değeri hesaplar; sonucun rastlantıyla açıklanma olasılığını yorumlamak için kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxaimath_clip_norm_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxaimath_sgd_update_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxaimath_momentum_update_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxaimath_dense_forward_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxaimath_dense_batch_forward_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxaimath_argmax_f64`** — En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxaimath_binary_accuracy_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `name`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxaimath_sigmoid_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxaimath_tanh_inplace_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxaimath_relu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxaimath_gelu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxaimath_swish_inplace_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
CALL uxnn.seed(42)
n = uxnn.neuron_create(3)
CALL uxnn.neuron_set_weight(n, 1, 0.5)
CALL uxnn.neuron_set_bias(n, 0.1)
y = uxnn.neuron_forward_ptr(n, VARPTR(giris))
PRINT y
CALL uxnn.neuron_free(n)
```

## 5. uxcollections

LIST, DICT, SET gibi koleksiyonların çalışma zamanı tarafını sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

Bu modül koleksiyon veya sarmalayıcı yüzeyi olarak kullanılır; fonksiyonlar uXBasic üst katmanında adlandırılmış olabilir. Kullanımda `LIST.ADD`, `DICT.SET`, `SET.ADD` gibi okunur adlar tercih edilir.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxcollections.uxmh"
USING MODULE uxcollections
' Nesne/handle açılır
' Fonksiyon çağrılır
' Sonuç kontrol edilir
PRINT "uxcollections kullanildi"
```

## 6. uxdataframe

CSV, Parquet, SQL benzeri tablo işlemleri ve veri çerçevesi yönetimi sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxdf_runtime_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxdataframe.uxdf_runtime_version(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_runtime_version",...)|
|2|uxdf_duckdb_available|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_duckdb_available(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_duckdb_available",...)|
|3|uxdf_duckdb_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxdataframe.uxdf_duckdb_version(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_duckdb_version",...)|
|4|uxdf_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxdataframe.uxdf_last_error(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_last_error",...)|
|5|uxdf_open_memory|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxdataframe.uxdf_open_memory(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_open_memory",...)|
|6|uxdf_open_database|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxdataframe.uxdf_open_database(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_open_database",...)|
|7|uxdf_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxdataframe.uxdf_free(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_free",...)|
|8|uxdf_load_csv|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxdataframe.uxdf_load_csv(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_load_csv",...)|
|9|uxdf_load_parquet|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxdataframe.uxdf_load_parquet(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_load_parquet",...)|
|10|uxdf_exec|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_exec(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_exec",...)|
|11|uxdf_query|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_query(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_query",...)|
|12|uxdf_row_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_row_count(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_row_count",...)|
|13|uxdf_col_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_col_count(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_col_count",...)|
|14|uxdf_col_name|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_col_name(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_col_name",...)|
|15|uxdf_get_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_get_f64(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_get_f64",...)|
|16|uxdf_get_text|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_get_text(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_get_text",...)|
|17|uxdf_head|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_head(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_head",...)|
|18|uxdf_select|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_select(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_select",...)|
|19|uxdf_filter|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_filter(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_filter",...)|
|20|uxdf_order_by|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_order_by(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_order_by",...)|
|21|uxdf_describe|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_describe(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_describe",...)|
|22|uxdf_group_mean|Ortalama hesaplar.|sonuc = uxdataframe.uxdf_group_mean(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_group_mean",...)|
|23|uxdf_join_inner|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxdataframe.uxdf_join_inner(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_join_inner",...)|
|24|uxdf_to_csv|CSV verisi okur, yazar veya tabloya çevirir; ayraç ve başlık satırı doğru seçilmelidir.|sonuc = uxdataframe.uxdf_to_csv(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_csv",...)|
|25|uxdf_to_parquet|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxdataframe.uxdf_to_parquet(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_parquet",...)|
|26|uxdf_to_f64_matrix|Matris işlemi veya matris özelliği üretir.|sonuc = uxdataframe.uxdf_to_f64_matrix(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_f64_matrix",...)|
|27|uxdf_matrix_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxdataframe.uxdf_matrix_free(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_free",...)|
|28|uxdf_matrix_rows|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_matrix_rows(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_rows",...)|
|29|uxdf_matrix_cols|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_matrix_cols(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_cols",...)|
|30|uxdf_matrix_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxdataframe.uxdf_matrix_data_ptr(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_data_ptr",...)|
|31|uxdf_matrix_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_matrix_get(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_get",...)|

### uxdataframe fonksiyonlarını okuma yöntemi
- **1. `uxdf_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxdf_duckdb_available`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxdf_duckdb_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxdf_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxdf_open_memory`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxdf_open_database`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxdf_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxdf_load_csv`** — Dış dosyadan veya kaynaktan veri yükler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxdf_load_parquet`** — Dış dosyadan veya kaynaktan veri yükler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxdf_exec`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxdf_query`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxdf_row_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxdf_col_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxdf_col_name`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxdf_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxdf_get_text`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxdf_head`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxdf_select`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxdf_filter`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxdf_order_by`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxdf_describe`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxdf_group_mean`** — Ortalama hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxdf_join_inner`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxdf_to_csv`** — CSV verisi okur, yazar veya tabloya çevirir; ayraç ve başlık satırı doğru seçilmelidir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxdf_to_parquet`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxdf_to_f64_matrix`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxdf_matrix_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxdf_matrix_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxdf_matrix_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxdf_matrix_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxdf_matrix_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxdataframe.uxmh"
db = uxdf.open_memory()
CALL uxdf.load_csv(db, "olcum.csv", "olcum")
sonuc = uxdf.query(db, "SELECT AVG(ph) FROM olcum")
PRINT uxdf.get_f64(sonuc, 1, 1)
CALL uxdf.free(db)
```

## 7. uxgraph

Düğüm-kenar yapıları, bağlantı, derece, yol ve ağ ölçümleri sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxgraph_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxgraph.uxgraph_create(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_create",...)|
|2|uxgraph_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxgraph.uxgraph_free(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_free",...)|
|3|uxgraph_add_vertex|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxgraph.uxgraph_add_vertex(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_add_vertex",...)|
|4|uxgraph_add_vertices|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxgraph.uxgraph_add_vertices(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_add_vertices",...)|
|5|uxgraph_add_edge|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxgraph.uxgraph_add_edge(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_add_edge",...)|
|6|uxgraph_vcount|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxgraph.uxgraph_vcount(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_vcount",...)|
|7|uxgraph_ecount|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxgraph.uxgraph_ecount(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_ecount",...)|
|8|uxgraph_is_directed|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_is_directed(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_is_directed",...)|
|9|uxgraph_has_edge|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_has_edge(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_has_edge",...)|
|10|uxgraph_degree|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_degree(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_degree",...)|
|11|uxgraph_in_degree|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_in_degree(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_in_degree",...)|
|12|uxgraph_out_degree|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_out_degree(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_out_degree",...)|
|13|uxgraph_density|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_density(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_density",...)|
|14|uxgraph_self_loops|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_self_loops(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_self_loops",...)|
|15|uxgraph_components_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxgraph.uxgraph_components_count(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_components_count",...)|
|16|uxgraph_is_connected|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_is_connected(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_is_connected",...)|
|17|uxgraph_shortest_distance|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_shortest_distance(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_shortest_distance",...)|
|18|uxgraph_path_exists|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxgraph.uxgraph_path_exists(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_path_exists",...)|
|19|uxgraph_triangle_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxgraph.uxgraph_triangle_count(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_triangle_count",...)|
|20|uxgraph_transitivity|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_transitivity(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_transitivity",...)|
|21|uxgraph_degree_vector|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_degree_vector(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_degree_vector",...)|
|22|uxgraph_bfs_distances|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_bfs_distances(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_bfs_distances",...)|
|23|uxgraph_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxgraph.uxgraph_vec_count(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_vec_count",...)|
|24|uxgraph_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxgraph.uxgraph_vec_get(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_vec_get",...)|
|25|uxgraph_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxgraph.uxgraph_vec_free(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_vec_free",...)|
|26|uxgraph_write_edgelist_csv|Veriyi dosyaya veya dış hedefe yazar.|sonuc = uxgraph.uxgraph_write_edgelist_csv(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_write_edgelist_csv",...)|
|27|uxgraph_read_edgelist_csv|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxgraph.uxgraph_read_edgelist_csv(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_read_edgelist_csv",...)|
|28|uxgraph_make_path|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxgraph.uxgraph_make_path(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_make_path",...)|
|29|uxgraph_make_cycle|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_make_cycle(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_make_cycle",...)|
|30|uxgraph_make_complete|Graf düğümü, kenarı, yol veya bağlantı özelliği işler.|sonuc = uxgraph.uxgraph_make_complete(...)  \|  sonuc = CALL(DLL,"uxgraph.dll","uxgraph_make_complete",...)|

### uxgraph fonksiyonlarını okuma yöntemi
- **1. `uxgraph_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxgraph_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxgraph_add_vertex`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxgraph_add_vertices`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxgraph_add_edge`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxgraph_vcount`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxgraph_ecount`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxgraph_is_directed`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxgraph_has_edge`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxgraph_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxgraph_in_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxgraph_out_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxgraph_density`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxgraph_self_loops`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxgraph_components_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxgraph_is_connected`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxgraph_shortest_distance`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxgraph_path_exists`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxgraph_triangle_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxgraph_transitivity`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxgraph_degree_vector`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxgraph_bfs_distances`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxgraph_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxgraph_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxgraph_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxgraph_write_edgelist_csv`** — Veriyi dosyaya veya dış hedefe yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxgraph_read_edgelist_csv`** — Dış dosyadan veya kaynaktan veri yükler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxgraph_make_path`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxgraph_make_cycle`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxgraph_make_complete`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxgraph.uxmh"
g = uxgraph.create(FALSE)
CALL uxgraph.add_vertex(g, "A")
CALL uxgraph.add_vertex(g, "B")
CALL uxgraph.add_edge(g, "A", "B")
IF uxgraph.path_exists(g,"A","B") THEN PRINT "bag var"
CALL uxgraph.free(g)
```

## 8. uxllama

Yerel llama.cpp veya benzeri komut satırı modelini uXBasic üzerinden konuşturur. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxllama_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxllama.uxllama_version(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_version",...)|
|2|uxllama_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxllama.uxllama_create(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_create",...)|
|3|uxllama_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxllama.uxllama_free(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_free",...)|
|4|uxllama_set_cli_path|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_cli_path(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_cli_path",...)|
|5|uxllama_set_model_path|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_model_path(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_model_path",...)|
|6|uxllama_set_threads|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_threads(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_threads",...)|
|7|uxllama_set_context|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_context(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_context",...)|
|8|uxllama_set_predict|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_predict(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_predict",...)|
|9|uxllama_set_temperature|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_temperature(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_temperature",...)|
|10|uxllama_set_top_p|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_top_p(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_top_p",...)|
|11|uxllama_set_top_k|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_top_k(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_top_k",...)|
|12|uxllama_set_seed|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_seed(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_seed",...)|
|13|uxllama_set_low_memory_profile|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxllama.uxllama_set_low_memory_profile(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_set_low_memory_profile",...)|
|14|uxllama_model_exists|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxllama.uxllama_model_exists(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_model_exists",...)|
|15|uxllama_prompt|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxllama.uxllama_prompt(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_prompt",...)|
|16|uxllama_prompt_file|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxllama.uxllama_prompt_file(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_prompt_file",...)|
|17|uxllama_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxllama.uxllama_last_error(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_last_error",...)|
|18|uxllama_last_command|Yerel dil modeliyle metin üretir veya soru-cevap yapar; model yolu ve bağlam sınırı kontrol edilir.|sonuc = uxllama.uxllama_last_command(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_last_command",...)|

### uxllama fonksiyonlarını okuma yöntemi
- **1. `uxllama_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxllama_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxllama_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxllama_set_cli_path`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxllama_set_model_path`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxllama_set_threads`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxllama_set_context`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxllama_set_predict`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxllama_set_temperature`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxllama_set_top_p`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxllama_set_top_k`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxllama_set_seed`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxllama_set_low_memory_profile`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxllama_model_exists`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxllama_prompt`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxllama_prompt_file`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxllama_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxllama_last_command`** — Yerel dil modeliyle metin üretir veya soru-cevap yapar; model yolu ve bağlam sınırı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
llm = uxllama.create()
CALL uxllama.set_cli_path(llm, "llama-cli.exe")
CALL uxllama.set_model_path(llm, "models/local.gguf")
cevap = uxllama.prompt(llm, "Bu veriyi kisa ozetle: pH=7.2, sicaklik=24")
PRINT cevap
CALL uxllama.free(llm)
```

## 9. uxmath

Polinom, türev, integral, diferansiyel denklem ve sayısal matematik yardımcıları sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxmath_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxmath.uxmath_version(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_version",...)|
|2|uxmath_vec_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmath.uxmath_vec_create(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_create",...)|
|3|uxmath_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmath.uxmath_vec_free(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_free",...)|
|4|uxmath_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_vec_push(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_push",...)|
|5|uxmath_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmath.uxmath_vec_set(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_set",...)|
|6|uxmath_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmath.uxmath_vec_get(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_get",...)|
|7|uxmath_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmath.uxmath_vec_count(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_count",...)|
|8|uxmath_vec_clear|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmath.uxmath_vec_clear(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_clear",...)|
|9|uxmath_vec_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_vec_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_data_ptr",...)|
|10|uxmath_poly_eval|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_eval(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_eval",...)|
|11|uxmath_poly_derivative_eval|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_derivative_eval(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_derivative_eval",...)|
|12|uxmath_poly_integral_eval|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_integral_eval(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_integral_eval",...)|
|13|uxmath_poly_derivative_coeff|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_derivative_coeff(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_derivative_coeff",...)|
|14|uxmath_poly_integral_coeff|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_integral_coeff(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_integral_coeff",...)|
|15|uxmath_poly_bisection|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_bisection(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_bisection",...)|
|16|uxmath_poly_newton|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_poly_newton(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_poly_newton",...)|
|17|uxmath_numeric_derivative_poly|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_numeric_derivative_poly(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_numeric_derivative_poly",...)|
|18|uxmath_integrate_poly_simpson|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmath.uxmath_integrate_poly_simpson(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_integrate_poly_simpson",...)|
|19|uxmath_ode_rk4_logistic|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmath.uxmath_ode_rk4_logistic(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_ode_rk4_logistic",...)|
|20|uxmath_ode_euler_logistic|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmath.uxmath_ode_euler_logistic(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_ode_euler_logistic",...)|
|21|uxmath_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_sigmoid(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_sigmoid",...)|
|22|uxmath_dsigmoid_from_output|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_dsigmoid_from_output(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_dsigmoid_from_output",...)|
|23|uxmath_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_relu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_relu",...)|
|24|uxmath_drelu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_drelu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_drelu",...)|
|25|uxmath_tanh_act|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmath.uxmath_tanh_act(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_tanh_act",...)|
|26|uxmath_dtanh_from_output|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmath.uxmath_dtanh_from_output(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_dtanh_from_output",...)|
|27|uxmath_vec_softmax|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_vec_softmax(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_softmax",...)|
|28|uxmath_mat_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmath.uxmath_mat_create(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_create",...)|
|29|uxmath_mat_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmath.uxmath_mat_free(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_free",...)|
|30|uxmath_mat_rows|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmath.uxmath_mat_rows(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_rows",...)|
|31|uxmath_mat_cols|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmath.uxmath_mat_cols(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_cols",...)|
|32|uxmath_mat_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmath.uxmath_mat_set(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_set",...)|
|33|uxmath_mat_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmath.uxmath_mat_get(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_get",...)|
|34|uxmath_mat_fill|Matris üzerinde işlem yapar; satır, sütun ve veri tipi uyumu gerekir.|sonuc = uxmath.uxmath_mat_fill(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_fill",...)|
|35|uxmath_mat_random_uniform|Matris üzerinde işlem yapar; satır, sütun ve veri tipi uyumu gerekir.|sonuc = uxmath.uxmath_mat_random_uniform(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_random_uniform",...)|
|36|uxmath_mat_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxmath.uxmath_mat_add(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_add",...)|
|37|uxmath_mat_sub|Çıkarma işlemi yapar.|sonuc = uxmath.uxmath_mat_sub(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_sub",...)|
|38|uxmath_mat_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmath.uxmath_mat_mul(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_mul",...)|
|39|uxmath_mat_transpose|Matris işlemi veya matris özelliği üretir.|sonuc = uxmath.uxmath_mat_transpose(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_transpose",...)|
|40|uxmath_mat_apply_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_mat_apply_sigmoid(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_apply_sigmoid",...)|
|41|uxmath_mat_apply_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_mat_apply_relu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_apply_relu",...)|
|42|uxmath_mat_vec_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmath.uxmath_mat_vec_mul(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_vec_mul",...)|

### uxmath fonksiyonlarını okuma yöntemi
- **1. `uxmath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxmath_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxmath_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxmath_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxmath_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxmath_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxmath_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxmath_vec_clear`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxmath_vec_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxmath_poly_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxmath_poly_derivative_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxmath_poly_integral_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxmath_poly_derivative_coeff`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxmath_poly_integral_coeff`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxmath_poly_bisection`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxmath_poly_newton`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxmath_numeric_derivative_poly`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxmath_integrate_poly_simpson`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxmath_ode_rk4_logistic`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxmath_ode_euler_logistic`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxmath_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxmath_dsigmoid_from_output`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxmath_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxmath_drelu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxmath_tanh_act`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxmath_dtanh_from_output`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxmath_vec_softmax`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxmath_mat_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxmath_mat_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxmath_mat_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxmath_mat_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxmath_mat_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxmath_mat_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxmath_mat_fill`** — Matris üzerinde işlem yapar; satır, sütun ve veri tipi uyumu gerekir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxmath_mat_random_uniform`** — Matris üzerinde işlem yapar; satır, sütun ve veri tipi uyumu gerekir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxmath_mat_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxmath_mat_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxmath_mat_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxmath_mat_transpose`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxmath_mat_apply_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxmath_mat_apply_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxmath_mat_vec_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmath.uxmh"
USING MODULE uxmath
' Nesne/handle açılır
' Fonksiyon çağrılır
' Sonuç kontrol edilir
PRINT "uxmath kullanildi"
```

## 10. uxmathcore

Tipli tampon, ham matematik belleği ve düşük seviye veri taşıma çekirdeği sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxmathcore_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxmathcore.uxmathcore_version(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_version",...)|
|2|uxmathcore_type_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_type_size(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_type_size",...)|
|3|uxmathcore_type_name|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_type_name(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_type_name",...)|
|4|uxmathcore_buffer_create_capacity|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmathcore_buffer_create_capacity(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_create_capacity",...)|
|5|uxmathcore_buffer_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmathcore_buffer_create(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_create",...)|
|6|uxmathcore_buffer_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmathcore.uxmathcore_buffer_free(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_free",...)|
|7|uxmathcore_buffer_type|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_type(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_type",...)|
|8|uxmathcore_buffer_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_count(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_count",...)|
|9|uxmathcore_buffer_capacity|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_capacity(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_capacity",...)|
|10|uxmathcore_buffer_elem_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_elem_size(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_elem_size",...)|
|11|uxmathcore_buffer_byte_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_byte_size(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_byte_size",...)|
|12|uxmathcore_buffer_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_data_ptr",...)|
|13|uxmathcore_buffer_clear|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clear(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clear",...)|
|14|uxmathcore_buffer_resize|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_resize(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_resize",...)|
|15|uxmathcore_buffer_reserve|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_reserve(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_reserve",...)|
|16|uxmathcore_buffer_fill_zero|Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır.|sonuc = uxmathcore.uxmathcore_buffer_fill_zero(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_zero",...)|
|17|uxmathcore_buffer_clone|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clone(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clone",...)|
|18|uxmathcore_buffer_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = uxmathcore.uxmathcore_buffer_copy(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy",...)|
|19|uxmathcore_buffer_slice|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_slice(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_slice",...)|
|20|uxmathcore_buffer_append|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_append(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_append",...)|
|21|uxmathcore_buffer_get_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_f64",...)|
|22|uxmathcore_buffer_set_f64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_f64",...)|
|23|uxmathcore_buffer_push_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_f64",...)|
|24|uxmathcore_buffer_fill_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_f64",...)|
|25|uxmathcore_buffer_get_i64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_i64",...)|
|26|uxmathcore_buffer_set_i64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_i64",...)|
|27|uxmathcore_buffer_push_i64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_i64",...)|
|28|uxmathcore_buffer_fill_i64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_i64",...)|
|29|uxmathcore_buffer_get_u64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_u64",...)|
|30|uxmathcore_buffer_set_u64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_u64",...)|
|31|uxmathcore_buffer_push_u64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_u64",...)|
|32|uxmathcore_buffer_fill_u64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_u64",...)|
|33|uxmathcore_buffer_get_byte|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_byte",...)|
|34|uxmathcore_buffer_set_byte|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_byte",...)|
|35|uxmathcore_buffer_push_byte|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_byte",...)|
|36|uxmathcore_buffer_copy_from_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_copy_from_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy_from_ptr",...)|
|37|uxmathcore_buffer_copy_to_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_copy_to_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy_to_ptr",...)|
|38|uxmathcore_buffer_cast|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_cast(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_cast",...)|
|39|uxmathcore_vec_add_f64|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxmathcore.uxmathcore_vec_add_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_add_f64",...)|
|40|uxmathcore_vec_sub_f64|Çıkarma işlemi yapar.|sonuc = uxmathcore.uxmathcore_vec_sub_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_sub_f64",...)|
|41|uxmathcore_vec_mul_f64|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmathcore.uxmathcore_vec_mul_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_mul_f64",...)|
|42|uxmathcore_vec_div_f64|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = uxmathcore.uxmathcore_vec_div_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_div_f64",...)|
|43|uxmathcore_vec_scale_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_scale_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_scale_f64",...)|
|44|uxmathcore_vec_axpy_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_axpy_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_axpy_f64",...)|
|45|uxmathcore_vec_dot_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_dot_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_dot_f64",...)|
|46|uxmathcore_vec_l1_norm_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l1_norm_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l1_norm_f64",...)|
|47|uxmathcore_vec_l2_norm_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l2_norm_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l2_norm_f64",...)|
|48|uxmathcore_vec_normalize_l2_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_vec_normalize_l2_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_normalize_l2_f64",...)|
|49|uxmathcore_vec_minmax_f64|En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır.|sonuc = uxmathcore.uxmathcore_vec_minmax_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_minmax_f64",...)|
|50|uxmath_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxmathcore.uxmath_version(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_version",...)|
|51|uxmath_vec_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmath_vec_create(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_create",...)|
|52|uxmath_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmathcore.uxmath_vec_free(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_free",...)|
|53|uxmath_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmath_vec_push(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_push",...)|
|54|uxmath_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmath_vec_set(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_set",...)|
|55|uxmath_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmath_vec_get(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_get",...)|
|56|uxmath_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmath_vec_count(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_count",...)|
|57|uxmath_vec_clear|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmath_vec_clear(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_clear",...)|
|58|uxmath_vec_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmath_vec_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_data_ptr",...)|
|59|uxmathcore_buffer_clone_handle|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clone_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clone_handle",...)|
|60|uxmathcore_buffer_slice_handle|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_slice_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_slice_handle",...)|
|61|uxmathcore_buffer_cast_handle|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_cast_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_cast_handle",...)|
|62|uxmathcore_vec_dot_f64_value|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_dot_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_dot_f64_value",...)|
|63|uxmathcore_vec_l1_norm_f64_value|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l1_norm_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l1_norm_f64_value",...)|
|64|uxmathcore_vec_l2_norm_f64_value|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l2_norm_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l2_norm_f64_value",...)|
|65|uxmathcore_vec_min_f64_value|En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır.|sonuc = uxmathcore.uxmathcore_vec_min_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_min_f64_value",...)|
|66|uxmathcore_vec_max_f64_value|En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır.|sonuc = uxmathcore.uxmathcore_vec_max_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_max_f64_value",...)|

### uxmathcore fonksiyonlarını okuma yöntemi
- **1. `uxmathcore_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxmathcore_type_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxmathcore_type_name`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxmathcore_buffer_create_capacity`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxmathcore_buffer_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxmathcore_buffer_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxmathcore_buffer_type`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxmathcore_buffer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxmathcore_buffer_capacity`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxmathcore_buffer_elem_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxmathcore_buffer_byte_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxmathcore_buffer_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxmathcore_buffer_clear`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxmathcore_buffer_resize`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxmathcore_buffer_reserve`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxmathcore_buffer_fill_zero`** — Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxmathcore_buffer_clone`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxmathcore_buffer_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxmathcore_buffer_slice`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxmathcore_buffer_append`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxmathcore_buffer_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxmathcore_buffer_set_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxmathcore_buffer_push_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxmathcore_buffer_fill_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxmathcore_buffer_get_i64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxmathcore_buffer_set_i64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxmathcore_buffer_push_i64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxmathcore_buffer_fill_i64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxmathcore_buffer_get_u64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxmathcore_buffer_set_u64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxmathcore_buffer_push_u64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxmathcore_buffer_fill_u64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxmathcore_buffer_get_byte`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxmathcore_buffer_set_byte`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxmathcore_buffer_push_byte`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxmathcore_buffer_copy_from_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxmathcore_buffer_copy_to_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxmathcore_buffer_cast`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxmathcore_vec_add_f64`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxmathcore_vec_sub_f64`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxmathcore_vec_mul_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxmathcore_vec_div_f64`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **43. `uxmathcore_vec_scale_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **44. `uxmathcore_vec_axpy_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **45. `uxmathcore_vec_dot_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **46. `uxmathcore_vec_l1_norm_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **47. `uxmathcore_vec_l2_norm_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **48. `uxmathcore_vec_normalize_l2_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **49. `uxmathcore_vec_minmax_f64`** — En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **50. `uxmath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **51. `uxmath_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **52. `uxmath_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **53. `uxmath_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **54. `uxmath_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **55. `uxmath_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **56. `uxmath_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **57. `uxmath_vec_clear`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **58. `uxmath_vec_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **59. `uxmathcore_buffer_clone_handle`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **60. `uxmathcore_buffer_slice_handle`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **61. `uxmathcore_buffer_cast_handle`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **62. `uxmathcore_vec_dot_f64_value`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **63. `uxmathcore_vec_l1_norm_f64_value`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **64. `uxmathcore_vec_l2_norm_f64_value`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **65. `uxmathcore_vec_min_f64_value`** — En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **66. `uxmathcore_vec_max_f64_value`** — En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmathcore.uxmh"
USING MODULE uxmathcore
' Nesne/handle açılır
' Fonksiyon çağrılır
' Sonuç kontrol edilir
PRINT "uxmathcore kullanildi"
```

## 11. uxmatrix

Matris oluşturma, okuma, yazma, çarpma, çözme ve doğrusal cebir sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxmatrix_runtime_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxmatrix.uxmatrix_runtime_version(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_runtime_version",...)|
|2|uxmatrix_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmatrix.uxmatrix_create(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_create",...)|
|3|uxmatrix_from_array|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_from_array(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_from_array",...)|
|4|uxmatrix_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmatrix.uxmatrix_free(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_free",...)|
|5|uxmatrix_rows|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmatrix.uxmatrix_rows(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_rows",...)|
|6|uxmatrix_cols|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmatrix.uxmatrix_cols(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_cols",...)|
|7|uxmatrix_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmatrix.uxmatrix_size(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_size",...)|
|8|uxmatrix_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmatrix.uxmatrix_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_data_ptr",...)|
|9|uxmatrix_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmatrix.uxmatrix_set(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_set",...)|
|10|uxmatrix_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmatrix.uxmatrix_get(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_get",...)|
|11|uxmatrix_fill|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_fill(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_fill",...)|
|12|uxmatrix_zero|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_zero(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_zero",...)|
|13|uxmatrix_eye|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_eye(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_eye",...)|
|14|uxmatrix_clone|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_clone(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_clone",...)|
|15|uxmatrix_transpose|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_transpose(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_transpose",...)|
|16|uxmatrix_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxmatrix.uxmatrix_add(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_add",...)|
|17|uxmatrix_sub|Çıkarma işlemi yapar.|sonuc = uxmatrix.uxmatrix_sub(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_sub",...)|
|18|uxmatrix_scale|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_scale(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_scale",...)|
|19|uxmatrix_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmatrix.uxmatrix_mul(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_mul",...)|
|20|uxmatrix_matvec|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_matvec(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_matvec",...)|
|21|uxmatrix_dot|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_dot(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_dot",...)|
|22|uxmatrix_norm_l1|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_norm_l1(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_norm_l1",...)|
|23|uxmatrix_norm_l2|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_norm_l2(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_norm_l2",...)|
|24|uxmatrix_norm_fro|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_norm_fro(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_norm_fro",...)|
|25|uxmatrix_trace|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_trace(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_trace",...)|
|26|uxmatrix_copy_to_array|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_copy_to_array(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_copy_to_array",...)|
|27|uxmatrix_copy_from_array|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_copy_from_array(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_copy_from_array",...)|
|28|uxmatrix_print|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmatrix.uxmatrix_print(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_print",...)|
|29|uxmatrix_solve|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_solve(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_solve",...)|
|30|uxmatrix_det|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_det(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_det",...)|
|31|uxmatrix_inverse|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_inverse(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_inverse",...)|
|32|uxmatrix_cholesky|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_cholesky(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_cholesky",...)|
|33|uxmatrix_qr|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_qr(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_qr",...)|
|34|uxmatrix_svd|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_svd(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_svd",...)|
|35|uxmatrix_eigen_symmetric|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_eigen_symmetric(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_eigen_symmetric",...)|
|36|uxmatrix_solve_new|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_solve_new(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_solve_new",...)|
|37|uxmatrix_inverse_new|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_inverse_new(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_inverse_new",...)|
|38|uxmatrix_cholesky_new|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_cholesky_new(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_cholesky_new",...)|
|39|uxmatrix_rank_svd|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmatrix.uxmatrix_rank_svd(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_rank_svd",...)|
|40|uxmatrix_cond2|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_cond2(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_cond2",...)|
|41|uxmatrix_blas_ddot|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_blas_ddot(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_blas_ddot",...)|
|42|uxmatrix_blas_daxpy|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_blas_daxpy(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_blas_daxpy",...)|
|43|uxmatrix_blas_dgemm_rowmajor|Matris işlemi veya matris özelliği üretir.|sonuc = uxmatrix.uxmatrix_blas_dgemm_rowmajor(...)  \|  sonuc = CALL(DLL,"uxmatrix.dll","uxmatrix_blas_dgemm_rowmajor",...)|

### uxmatrix fonksiyonlarını okuma yöntemi
- **1. `uxmatrix_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxmatrix_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxmatrix_from_array`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxmatrix_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxmatrix_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxmatrix_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxmatrix_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxmatrix_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxmatrix_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxmatrix_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxmatrix_fill`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxmatrix_zero`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxmatrix_eye`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxmatrix_clone`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxmatrix_transpose`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxmatrix_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxmatrix_sub`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxmatrix_scale`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxmatrix_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxmatrix_matvec`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxmatrix_dot`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxmatrix_norm_l1`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxmatrix_norm_l2`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxmatrix_norm_fro`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxmatrix_trace`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxmatrix_copy_to_array`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxmatrix_copy_from_array`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxmatrix_print`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxmatrix_solve`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxmatrix_det`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxmatrix_inverse`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxmatrix_cholesky`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxmatrix_qr`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxmatrix_svd`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxmatrix_eigen_symmetric`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxmatrix_solve_new`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxmatrix_inverse_new`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxmatrix_cholesky_new`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxmatrix_rank_svd`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxmatrix_cond2`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxmatrix_blas_ddot`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxmatrix_blas_daxpy`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **43. `uxmatrix_blas_dgemm_rowmajor`** — Matris işlemi veya matris özelliği üretir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmatrix.uxmh"
A = uxmatrix.create(2,2)
B = uxmatrix.eye(2)
CALL uxmatrix.set(A,1,1,3.0)
C = uxmatrix.mul(A,B)
PRINT uxmatrix.get(C,1,1)
CALL uxmatrix.free(A): CALL uxmatrix.free(B): CALL uxmatrix.free(C)
```

## 12. uxnn

Basit sinir ağı, nöron, katman ve eğitim yordamları sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxnn_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxnn.uxnn_version(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_version",...)|
|2|uxnn_backend|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn.uxnn_backend(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_backend",...)|
|3|uxnn_seed|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn.uxnn_seed(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_seed",...)|
|4|uxnn_act|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn.uxnn_act(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_act",...)|
|5|uxnn_neuron_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn.uxnn_neuron_create(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_create",...)|
|6|uxnn_neuron_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn.uxnn_neuron_free(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_free",...)|
|7|uxnn_neuron_set_weight|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn.uxnn_neuron_set_weight(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_set_weight",...)|
|8|uxnn_neuron_get_weight|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn.uxnn_neuron_get_weight(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_get_weight",...)|
|9|uxnn_neuron_set_bias|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn.uxnn_neuron_set_bias(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_set_bias",...)|
|10|uxnn_neuron_get_bias|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn.uxnn_neuron_get_bias(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_get_bias",...)|
|11|uxnn_neuron_forward_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_neuron_forward_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_neuron_forward_ptr",...)|
|12|uxnn_layer_dense_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn.uxnn_layer_dense_create(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_dense_create",...)|
|13|uxnn_layer_activation_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn.uxnn_layer_activation_create(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_activation_create",...)|
|14|uxnn_layer_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn.uxnn_layer_free(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_free",...)|
|15|uxnn_layer_input_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn.uxnn_layer_input_dim(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_input_dim",...)|
|16|uxnn_layer_output_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn.uxnn_layer_output_dim(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_output_dim",...)|
|17|uxnn_layer_set_weight|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn.uxnn_layer_set_weight(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_set_weight",...)|
|18|uxnn_layer_get_weight|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn.uxnn_layer_get_weight(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_get_weight",...)|
|19|uxnn_layer_set_bias|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn.uxnn_layer_set_bias(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_set_bias",...)|
|20|uxnn_layer_get_bias|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn.uxnn_layer_get_bias(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_get_bias",...)|
|21|uxnn_layer_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn.uxnn_layer_init(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_init",...)|
|22|uxnn_layer_forward_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_layer_forward_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_layer_forward_ptr",...)|
|23|uxnn_network_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn.uxnn_network_create(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_create",...)|
|24|uxnn_network_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn.uxnn_network_free(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_free",...)|
|25|uxnn_network_add_layer|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxnn.uxnn_network_add_layer(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_add_layer",...)|
|26|uxnn_network_layer_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn.uxnn_network_layer_count(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_layer_count",...)|
|27|uxnn_network_input_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn.uxnn_network_input_dim(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_input_dim",...)|
|28|uxnn_network_output_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn.uxnn_network_output_dim(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_output_dim",...)|
|29|uxnn_network_forward_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_network_forward_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_forward_ptr",...)|
|30|uxnn_network_predict_argmax_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_network_predict_argmax_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_predict_argmax_ptr",...)|
|31|uxnn_network_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_network_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_mse_ptr",...)|
|32|uxnn_network_train_mse_sgd_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn.uxnn_network_train_mse_sgd_ptr(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_network_train_mse_sgd_ptr",...)|

### uxnn fonksiyonlarını okuma yöntemi
- **1. `uxnn_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxnn_backend`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxnn_seed`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxnn_act`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxnn_neuron_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxnn_neuron_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxnn_neuron_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxnn_neuron_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxnn_neuron_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxnn_neuron_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxnn_neuron_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxnn_layer_dense_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxnn_layer_activation_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxnn_layer_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxnn_layer_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxnn_layer_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxnn_layer_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxnn_layer_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxnn_layer_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxnn_layer_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxnn_layer_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxnn_layer_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxnn_network_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxnn_network_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxnn_network_add_layer`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxnn_network_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxnn_network_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxnn_network_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxnn_network_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxnn_network_predict_argmax_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxnn_network_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxnn_network_train_mse_sgd_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
CALL uxnn.seed(42)
n = uxnn.neuron_create(3)
CALL uxnn.neuron_set_weight(n, 1, 0.5)
CALL uxnn.neuron_set_bias(n, 0.1)
y = uxnn.neuron_forward_ptr(n, VARPTR(giris))
PRINT y
CALL uxnn.neuron_free(n)
```

## 13. uxnn2

Daha düzenli ağ, katman ve optimizer yüzeyi sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxnn2_network_layer_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn2.uxnn2_network_layer_count(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_layer_count",...)|
|2|uxnn2_network_input_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn2.uxnn2_network_input_dim(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_input_dim",...)|
|3|uxnn2_network_output_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn2.uxnn2_network_output_dim(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_output_dim",...)|
|4|uxnn2_network_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn2.uxnn2_network_init(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_init",...)|
|5|uxnn2_set_optimizer|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn2.uxnn2_set_optimizer(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_set_optimizer",...)|
|6|uxnn2_set_optimizer_params|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn2.uxnn2_set_optimizer_params(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_set_optimizer_params",...)|
|7|uxnn2_forward_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_forward_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_forward_ptr",...)|
|8|uxnn2_loss_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_loss_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_loss_mse_ptr",...)|
|9|uxnn2_predict_argmax_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_predict_argmax_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_predict_argmax_ptr",...)|
|10|uxnn2_get_weight|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn2.uxnn2_get_weight(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_get_weight",...)|
|11|uxnn2_set_weight|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn2.uxnn2_set_weight(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_set_weight",...)|
|12|uxnn2_get_bias|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxnn2.uxnn2_get_bias(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_get_bias",...)|
|13|uxnn2_set_bias|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn2.uxnn2_set_bias(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_set_bias",...)|
|14|uxnn2_save|Veriyi dosyaya veya dış hedefe yazar.|sonuc = uxnn2.uxnn2_save(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_save",...)|
|15|uxnn2_load|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxnn2.uxnn2_load(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_load",...)|
|16|uxnn2_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxnn2.uxnn2_version(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_version",...)|
|17|uxnn2_backend|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn2.uxnn2_backend(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_backend",...)|
|18|uxnn2_seed|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn2.uxnn2_seed(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_seed",...)|
|19|uxnn2_network_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn2.uxnn2_network_create(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_create",...)|
|20|uxnn2_network_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn2.uxnn2_network_free(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_free",...)|
|21|uxnn2_network_add_dense|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxnn2.uxnn2_network_add_dense(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_add_dense",...)|
|22|uxnn2_train_sample_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_train_sample_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_train_sample_mse_ptr",...)|
|23|uxnn2_train_array_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_train_array_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_train_array_mse_ptr",...)|

### uxnn2 fonksiyonlarını okuma yöntemi
- **1. `uxnn2_network_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxnn2_network_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxnn2_network_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxnn2_network_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxnn2_set_optimizer`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxnn2_set_optimizer_params`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxnn2_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxnn2_loss_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxnn2_predict_argmax_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxnn2_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxnn2_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxnn2_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxnn2_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxnn2_save`** — Veriyi dosyaya veya dış hedefe yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxnn2_load`** — Dış dosyadan veya kaynaktan veri yükler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxnn2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxnn2_backend`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxnn2_seed`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxnn2_network_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxnn2_network_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxnn2_network_add_dense`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxnn2_train_sample_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxnn2_train_array_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
CALL uxnn.seed(42)
n = uxnn.neuron_create(3)
CALL uxnn.neuron_set_weight(n, 1, 0.5)
CALL uxnn.neuron_set_bias(n, 0.1)
y = uxnn.neuron_forward_ptr(n, VARPTR(giris))
PRINT y
CALL uxnn.neuron_free(n)
```

## 14. uxnn3

Veri kümesi, CSV yükleme, model eğitim ve kayıt düzenini genişletir. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxnn3_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxnn3.uxnn3_last_error(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_last_error",...)|
|2|uxnn3_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxnn3.uxnn3_version(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_version",...)|
|3|uxnn3_dataset_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn3.uxnn3_dataset_create(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_create",...)|
|4|uxnn3_dataset_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn3.uxnn3_dataset_free(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_free",...)|
|5|uxnn3_dataset_rows|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_rows(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_rows",...)|
|6|uxnn3_dataset_input_dim|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_input_dim(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_input_dim",...)|
|7|uxnn3_dataset_output_dim|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_output_dim(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_output_dim",...)|
|8|uxnn3_dataset_x_ptr|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_x_ptr(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_x_ptr",...)|
|9|uxnn3_dataset_y_ptr|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_y_ptr(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_y_ptr",...)|
|10|uxnn3_dataset_x_get|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_x_get(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_x_get",...)|
|11|uxnn3_dataset_y_get|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_y_get(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_y_get",...)|
|12|uxnn3_dataset_x_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_x_set(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_x_set",...)|
|13|uxnn3_dataset_y_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_y_set(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_y_set",...)|
|14|uxnn3_dataset_load_csv|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_load_csv(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_load_csv",...)|
|15|uxnn3_dataset_save_csv|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_save_csv(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_save_csv",...)|
|16|uxnn3_dataset_shuffle|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_shuffle(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_shuffle",...)|
|17|split_copy|Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler.|sonuc = uxnn3.split_copy(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","split_copy",...)|
|18|uxnn3_dataset_split_train|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_split_train(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_split_train",...)|
|19|uxnn3_dataset_split_test|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_split_test(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_split_test",...)|
|20|uxnn3_dataset_standardize_fit_transform|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_standardize_fit_transform(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_standardize_fit_transform",...)|
|21|uxnn3_dataset_minmax_fit_transform|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_dataset_minmax_fit_transform(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_dataset_minmax_fit_transform",...)|
|22|uxnn3_model_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn3.uxnn3_model_create(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_create",...)|
|23|uxnn3_model_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn3.uxnn3_model_free(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_free",...)|
|24|uxnn3_model_add_dense|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxnn3.uxnn3_model_add_dense(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_add_dense",...)|
|25|uxnn3_model_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn3.uxnn3_model_init(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_init",...)|
|26|uxnn3_model_set_optimizer|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxnn3.uxnn3_model_set_optimizer(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_set_optimizer",...)|
|27|uxnn3_model_layer_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn3.uxnn3_model_layer_count(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_layer_count",...)|
|28|uxnn3_model_output_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxnn3.uxnn3_model_output_dim(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_output_dim",...)|
|29|forward_internal|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxnn3.forward_internal(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","forward_internal",...)|
|30|uxnn3_model_forward1|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_forward1(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_forward1",...)|
|31|uxnn3_model_predict_dataset|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn3.uxnn3_model_predict_dataset(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_predict_dataset",...)|
|32|uxnn3_model_predict_argmax|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn3.uxnn3_model_predict_argmax(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_predict_argmax",...)|
|33|train_one|Model eğitimi yapar; veri, hedef, öğrenme oranı ve tur sayısı birlikte düşünülür.|sonuc = uxnn3.train_one(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","train_one",...)|
|34|uxnn3_model_train_dataset|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_train_dataset(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_train_dataset",...)|
|35|uxnn3_model_eval_mse|Model hatası/kayıp değeri hesaplar.|sonuc = uxnn3.uxnn3_model_eval_mse(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_eval_mse",...)|
|36|uxnn3_model_eval_binary_accuracy|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_eval_binary_accuracy(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_eval_binary_accuracy",...)|
|37|uxnn3_model_save|Veriyi dosyaya veya dış hedefe yazar.|sonuc = uxnn3.uxnn3_model_save(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_save",...)|
|38|uxnn3_model_load|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxnn3.uxnn3_model_load(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_load",...)|

### uxnn3 fonksiyonlarını okuma yöntemi
- **1. `uxnn3_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxnn3_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxnn3_dataset_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxnn3_dataset_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxnn3_dataset_rows`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxnn3_dataset_input_dim`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxnn3_dataset_output_dim`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxnn3_dataset_x_ptr`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxnn3_dataset_y_ptr`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxnn3_dataset_x_get`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxnn3_dataset_y_get`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxnn3_dataset_x_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxnn3_dataset_y_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxnn3_dataset_load_csv`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxnn3_dataset_save_csv`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxnn3_dataset_shuffle`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `split_copy`** — Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxnn3_dataset_split_train`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxnn3_dataset_split_test`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxnn3_dataset_standardize_fit_transform`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxnn3_dataset_minmax_fit_transform`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxnn3_model_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxnn3_model_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxnn3_model_add_dense`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxnn3_model_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxnn3_model_set_optimizer`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxnn3_model_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxnn3_model_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `forward_internal`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxnn3_model_forward1`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxnn3_model_predict_dataset`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxnn3_model_predict_argmax`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `train_one`** — Model eğitimi yapar; veri, hedef, öğrenme oranı ve tur sayısı birlikte düşünülür. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxnn3_model_train_dataset`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxnn3_model_eval_mse`** — Model hatası/kayıp değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxnn3_model_eval_binary_accuracy`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxnn3_model_save`** — Veriyi dosyaya veya dış hedefe yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxnn3_model_load`** — Dış dosyadan veya kaynaktan veri yükler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
CALL uxnn.seed(42)
n = uxnn.neuron_create(3)
CALL uxnn.neuron_set_weight(n, 1, 0.5)
CALL uxnn.neuron_set_bias(n, 0.1)
y = uxnn.neuron_forward_ptr(n, VARPTR(giris))
PRINT y
CALL uxnn.neuron_free(n)
```

## 15. uxonnx

ONNX modeli açma, tensör oluşturma ve çıkarım yapma köprüsüdür. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxonnx_global_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_global_init(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_global_init",...)|
|2|uxonnx_runtime_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxonnx.uxonnx_runtime_version(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_runtime_version",...)|
|3|uxonnx_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxonnx.uxonnx_last_error(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_last_error",...)|
|4|uxonnx_session_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_session_create(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_session_create",...)|
|5|uxonnx_session_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx.uxonnx_session_free(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_session_free",...)|
|6|uxonnx_input_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx.uxonnx_input_count(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_input_count",...)|
|7|uxonnx_output_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx.uxonnx_output_count(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_output_count",...)|
|8|uxonnx_input_name|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxonnx.uxonnx_input_name(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_input_name",...)|
|9|uxonnx_output_name|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxonnx.uxonnx_output_name(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_output_name",...)|
|10|uxonnx_tensor_create_f32|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_tensor_create_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_create_f32",...)|
|11|uxonnx_tensor_create_1d_f32|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_tensor_create_1d_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_create_1d_f32",...)|
|12|uxonnx_tensor_create_2d_f32|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_tensor_create_2d_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_create_2d_f32",...)|
|13|uxonnx_tensor_create_3d_f32|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_tensor_create_3d_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_create_3d_f32",...)|
|14|uxonnx_tensor_create_4d_f32|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx.uxonnx_tensor_create_4d_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_create_4d_f32",...)|
|15|uxonnx_tensor_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx.uxonnx_tensor_free(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_free",...)|
|16|uxonnx_tensor_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx.uxonnx_tensor_count(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_count",...)|
|17|uxonnx_tensor_rank|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx.uxonnx_tensor_rank(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_rank",...)|
|18|uxonnx_tensor_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx.uxonnx_tensor_dim(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_dim",...)|
|19|uxonnx_tensor_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxonnx.uxonnx_tensor_data_ptr(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_data_ptr",...)|
|20|uxonnx_tensor_set_f32|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxonnx.uxonnx_tensor_set_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_set_f32",...)|
|21|uxonnx_tensor_get_f32|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxonnx.uxonnx_tensor_get_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_tensor_get_f32",...)|
|22|uxonnx_run1_f32|Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir.|sonuc = uxonnx.uxonnx_run1_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_run1_f32",...)|

### uxonnx fonksiyonlarını okuma yöntemi
- **1. `uxonnx_global_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxonnx_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxonnx_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxonnx_session_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxonnx_session_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxonnx_input_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxonnx_output_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxonnx_input_name`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxonnx_output_name`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxonnx_tensor_create_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxonnx_tensor_create_1d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxonnx_tensor_create_2d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxonnx_tensor_create_3d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxonnx_tensor_create_4d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxonnx_tensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxonnx_tensor_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxonnx_tensor_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxonnx_tensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxonnx_tensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxonnx_tensor_set_f32`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxonnx_tensor_get_f32`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxonnx_run1_f32`** — Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxonnx.uxmh"
s = uxonnx.session_create("model.onnx")
IF s = 0 THEN PRINT uxonnx.last_error() ELSE PRINT "model acildi"
t = uxonnx.tensor_create_2d_f32(1, 4)
' giriş doldurulur, çıkarım çağrılır, sonuç okunur
CALL uxonnx.tensor_free(t)
CALL uxonnx.session_free(s)
```

## 16. uxonnx2

ONNX oturumlarını daha ayrıntılı tip, giriş/çıkış ve provider desteğiyle yönetir. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxonnx2_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxonnx2.uxonnx2_last_error(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_last_error",...)|
|2|uxonnx2_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_init(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_init",...)|
|3|uxonnx2_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxonnx2.uxonnx2_version(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_version",...)|
|4|uxonnx2_provider_available|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxonnx2.uxonnx2_provider_available(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_provider_available",...)|
|5|uxonnx2_session_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_session_create(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_create",...)|
|6|uxonnx2_session_create_advanced|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_session_create_advanced(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_create_advanced",...)|
|7|uxonnx2_session_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx2.uxonnx2_session_free(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_free",...)|
|8|uxonnx2_session_input_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_input_count(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_input_count",...)|
|9|uxonnx2_session_output_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_output_count(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_output_count",...)|
|10|uxonnx2_session_input_name|ONNX veya dış çalışma oturumu yönetir.|sonuc = uxonnx2.uxonnx2_session_input_name(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_input_name",...)|
|11|uxonnx2_session_output_name|ONNX veya dış çalışma oturumu yönetir.|sonuc = uxonnx2.uxonnx2_session_output_name(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_output_name",...)|
|12|uxonnx2_session_input_dtype|ONNX veya dış çalışma oturumu yönetir.|sonuc = uxonnx2.uxonnx2_session_input_dtype(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_input_dtype",...)|
|13|uxonnx2_session_output_dtype|ONNX veya dış çalışma oturumu yönetir.|sonuc = uxonnx2.uxonnx2_session_output_dtype(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_output_dtype",...)|
|14|uxonnx2_session_input_rank|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_input_rank(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_input_rank",...)|
|15|uxonnx2_session_output_rank|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_output_rank(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_output_rank",...)|
|16|uxonnx2_session_input_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_input_dim(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_input_dim",...)|
|17|uxonnx2_session_output_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_session_output_dim(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_session_output_dim",...)|
|18|uxonnx2_tensor_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_tensor_create(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_create",...)|
|19|uxonnx2_tensor_create_1d|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_tensor_create_1d(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_create_1d",...)|
|20|uxonnx2_tensor_create_2d|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_tensor_create_2d(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_create_2d",...)|
|21|uxonnx2_tensor_create_3d|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_tensor_create_3d(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_create_3d",...)|
|22|uxonnx2_tensor_create_4d|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_tensor_create_4d(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_create_4d",...)|
|23|uxonnx2_tensor_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx2.uxonnx2_tensor_free(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_free",...)|
|24|uxonnx2_tensor_dtype|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxonnx2.uxonnx2_tensor_dtype(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_dtype",...)|
|25|uxonnx2_tensor_rank|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_tensor_rank(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_rank",...)|
|26|uxonnx2_tensor_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_tensor_dim(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_dim",...)|
|27|uxonnx2_tensor_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_tensor_count(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_count",...)|
|28|uxonnx2_tensor_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxonnx2.uxonnx2_tensor_data_ptr(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_data_ptr",...)|
|29|uxonnx2_tensor_set_f64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxonnx2.uxonnx2_tensor_set_f64(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_set_f64",...)|
|30|uxonnx2_tensor_get_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxonnx2.uxonnx2_tensor_get_f64(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_get_f64",...)|
|31|uxonnx2_tensor_set_i64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxonnx2.uxonnx2_tensor_set_i64(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_set_i64",...)|
|32|uxonnx2_tensor_get_i64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxonnx2.uxonnx2_tensor_get_i64(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_get_i64",...)|
|33|uxonnx2_tensor_set_string|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxonnx2.uxonnx2_tensor_set_string(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_set_string",...)|
|34|uxonnx2_tensor_get_string|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxonnx2.uxonnx2_tensor_get_string(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_tensor_get_string",...)|
|35|uxonnx2_run_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxonnx2.uxonnx2_run_create(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_create",...)|
|36|uxonnx2_run_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx2.uxonnx2_run_free(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_free",...)|
|37|uxonnx2_run_add_input|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxonnx2.uxonnx2_run_add_input(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_add_input",...)|
|38|uxonnx2_run_add_output|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxonnx2.uxonnx2_run_add_output(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_add_output",...)|
|39|uxonnx2_run_execute|Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir.|sonuc = uxonnx2.uxonnx2_run_execute(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_execute",...)|
|40|uxonnx2_result_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx2.uxonnx2_result_free(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_free",...)|
|41|uxonnx2_result_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_result_count(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_count",...)|
|42|uxonnx2_result_tensor|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxonnx2.uxonnx2_result_tensor(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_tensor",...)|
|43|uxonnx2_run1|Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir.|sonuc = uxonnx2.uxonnx2_run1(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run1",...)|

### uxonnx2 fonksiyonlarını okuma yöntemi
- **1. `uxonnx2_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxonnx2_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxonnx2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxonnx2_provider_available`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxonnx2_session_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxonnx2_session_create_advanced`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxonnx2_session_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxonnx2_session_input_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxonnx2_session_output_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxonnx2_session_input_name`** — ONNX veya dış çalışma oturumu yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxonnx2_session_output_name`** — ONNX veya dış çalışma oturumu yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxonnx2_session_input_dtype`** — ONNX veya dış çalışma oturumu yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxonnx2_session_output_dtype`** — ONNX veya dış çalışma oturumu yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxonnx2_session_input_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxonnx2_session_output_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxonnx2_session_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxonnx2_session_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxonnx2_tensor_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxonnx2_tensor_create_1d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxonnx2_tensor_create_2d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxonnx2_tensor_create_3d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxonnx2_tensor_create_4d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxonnx2_tensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxonnx2_tensor_dtype`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxonnx2_tensor_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxonnx2_tensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxonnx2_tensor_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxonnx2_tensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxonnx2_tensor_set_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxonnx2_tensor_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxonnx2_tensor_set_i64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxonnx2_tensor_get_i64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxonnx2_tensor_set_string`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxonnx2_tensor_get_string`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxonnx2_run_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxonnx2_run_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxonnx2_run_add_input`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxonnx2_run_add_output`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxonnx2_run_execute`** — Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxonnx2_result_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxonnx2_result_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxonnx2_result_tensor`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **43. `uxonnx2_run1`** — Model veya hesaplama çalıştırır; giriş hazırlanır, sonuç okunur ve hata kodu kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxonnx.uxmh"
s = uxonnx.session_create("model.onnx")
IF s = 0 THEN PRINT uxonnx.last_error() ELSE PRINT "model acildi"
t = uxonnx.tensor_create_2d_f32(1, 4)
' giriş doldurulur, çıkarım çağrılır, sonuç okunur
CALL uxonnx.tensor_free(t)
CALL uxonnx.session_free(s)
```

## 17. uxstats

Temel tanımlayıcı istatistik ve vektör işlemleri sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxstats_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxstats.uxstats_version(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_version",...)|
|2|uxstats_vec_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxstats.uxstats_vec_create(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_create",...)|
|3|uxstats_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxstats.uxstats_vec_free(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_free",...)|
|4|uxstats_vec_clear|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_clear(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_clear",...)|
|5|uxstats_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxstats.uxstats_vec_count(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_count",...)|
|6|uxstats_vec_capacity|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_capacity(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_capacity",...)|
|7|uxstats_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats.uxstats_vec_push(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_push",...)|
|8|uxstats_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxstats.uxstats_vec_set(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_set",...)|
|9|uxstats_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxstats.uxstats_vec_get(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_get",...)|
|10|uxstats_sum_f64|Toplam değer hesaplar; üretim, maliyet, ağırlık ve sayım işlerinde kullanılır.|sonuc = uxstats.uxstats_sum_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_sum_f64",...)|
|11|uxstats_mean_f64|Ortalama hesaplar.|sonuc = uxstats.uxstats_mean_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_mean_f64",...)|
|12|uxstats_min_f64|En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır.|sonuc = uxstats.uxstats_min_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_min_f64",...)|
|13|uxstats_max_f64|En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır.|sonuc = uxstats.uxstats_max_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_max_f64",...)|
|14|uxstats_variance_pop_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_variance_pop_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_variance_pop_f64",...)|
|15|uxstats_variance_samp_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_variance_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_variance_samp_f64",...)|
|16|uxstats_stddev_pop_f64|Standart sapma hesaplar.|sonuc = uxstats.uxstats_stddev_pop_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_stddev_pop_f64",...)|
|17|uxstats_stddev_samp_f64|Standart sapma hesaplar.|sonuc = uxstats.uxstats_stddev_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_stddev_samp_f64",...)|
|18|uxstats_median_f64|Ortanca değer hesaplar.|sonuc = uxstats.uxstats_median_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_median_f64",...)|
|19|uxstats_percentile_f64|Yüzdelik değer hesaplar.|sonuc = uxstats.uxstats_percentile_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_percentile_f64",...)|
|20|uxstats_covariance_samp_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_covariance_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_covariance_samp_f64",...)|
|21|uxstats_correlation_f64|İki değişken arasındaki ilişki katsayısını hesaplar.|sonuc = uxstats.uxstats_correlation_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_correlation_f64",...)|
|22|uxstats_regression_slope_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_regression_slope_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_slope_f64",...)|
|23|uxstats_regression_intercept_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_regression_intercept_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_intercept_f64",...)|
|24|uxstats_regression_r2_f64|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_regression_r2_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_r2_f64",...)|
|25|uxstats_vec_sum|Toplam değer hesaplar; üretim, maliyet, ağırlık ve sayım işlerinde kullanılır.|sonuc = uxstats.uxstats_vec_sum(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_sum",...)|
|26|uxstats_vec_mean|Ortalama hesaplar.|sonuc = uxstats.uxstats_vec_mean(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_mean",...)|
|27|uxstats_vec_min|En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır.|sonuc = uxstats.uxstats_vec_min(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_min",...)|
|28|uxstats_vec_max|En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır.|sonuc = uxstats.uxstats_vec_max(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_max",...)|
|29|uxstats_vec_range|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_range(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_range",...)|
|30|uxstats_vec_variance_pop|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_variance_pop(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_variance_pop",...)|
|31|uxstats_vec_variance_samp|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_variance_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_variance_samp",...)|
|32|uxstats_vec_stddev_pop|Standart sapma hesaplar.|sonuc = uxstats.uxstats_vec_stddev_pop(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_stddev_pop",...)|
|33|uxstats_vec_stddev_samp|Standart sapma hesaplar.|sonuc = uxstats.uxstats_vec_stddev_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_stddev_samp",...)|
|34|uxstats_vec_median|Ortanca değer hesaplar.|sonuc = uxstats.uxstats_vec_median(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_median",...)|
|35|uxstats_vec_percentile|Yüzdelik değer hesaplar.|sonuc = uxstats.uxstats_vec_percentile(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_percentile",...)|
|36|uxstats_vec_covariance_samp|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_covariance_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_covariance_samp",...)|
|37|uxstats_vec_correlation|İki değişken arasındaki ilişki katsayısını hesaplar.|sonuc = uxstats.uxstats_vec_correlation(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_correlation",...)|
|38|uxstats_vec_regression_slope|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_slope(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_slope",...)|
|39|uxstats_vec_regression_intercept|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_intercept(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_intercept",...)|
|40|uxstats_vec_regression_r2|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_r2(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_r2",...)|

### uxstats fonksiyonlarını okuma yöntemi
- **1. `uxstats_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxstats_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxstats_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxstats_vec_clear`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxstats_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxstats_vec_capacity`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxstats_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxstats_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxstats_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxstats_sum_f64`** — Toplam değer hesaplar; üretim, maliyet, ağırlık ve sayım işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxstats_mean_f64`** — Ortalama hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxstats_min_f64`** — En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxstats_max_f64`** — En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxstats_variance_pop_f64`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxstats_variance_samp_f64`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxstats_stddev_pop_f64`** — Standart sapma hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxstats_stddev_samp_f64`** — Standart sapma hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxstats_median_f64`** — Ortanca değer hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxstats_percentile_f64`** — Yüzdelik değer hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxstats_covariance_samp_f64`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxstats_correlation_f64`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxstats_regression_slope_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxstats_regression_intercept_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxstats_regression_r2_f64`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxstats_vec_sum`** — Toplam değer hesaplar; üretim, maliyet, ağırlık ve sayım işlerinde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxstats_vec_mean`** — Ortalama hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxstats_vec_min`** — En küçük değeri bulur; alt sınır ve hata aralığı denetiminde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxstats_vec_max`** — En büyük değeri bulur; üst sınır ve alarm eşikleri için kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxstats_vec_range`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxstats_vec_variance_pop`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxstats_vec_variance_samp`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxstats_vec_stddev_pop`** — Standart sapma hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxstats_vec_stddev_samp`** — Standart sapma hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxstats_vec_median`** — Ortanca değer hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxstats_vec_percentile`** — Yüzdelik değer hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxstats_vec_covariance_samp`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxstats_vec_correlation`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxstats_vec_regression_slope`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxstats_vec_regression_intercept`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxstats_vec_regression_r2`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
USING MODULE uxstats
' Nesne/handle açılır
' Fonksiyon çağrılır
' Sonuç kontrol edilir
PRINT "uxstats kullanildi"
```

## 18. uxstats2

Hipotez testleri, p değeri, korelasyon, kovaryans, T/F/Ki-kare gibi ileri istatistikleri sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxstats2_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxstats2.uxstats2_version(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_version",...)|
|2|uxstats2_vec_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxstats2.uxstats2_vec_create(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_create",...)|
|3|uxstats2_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxstats2.uxstats2_vec_free(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_free",...)|
|4|uxstats2_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_vec_push(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_push",...)|
|5|uxstats2_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxstats2.uxstats2_vec_set(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_set",...)|
|6|uxstats2_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxstats2.uxstats2_vec_get(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_get",...)|
|7|uxstats2_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxstats2.uxstats2_vec_count(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vec_count",...)|
|8|uxstats2_covariance_samp|Varyans hesaplar.|sonuc = uxstats2.uxstats2_covariance_samp(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_covariance_samp",...)|
|9|uxstats2_correlation|İki değişken arasındaki ilişki katsayısını hesaplar.|sonuc = uxstats2.uxstats2_correlation(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_correlation",...)|
|10|uxstats2_normal_cdf|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_normal_cdf(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_normal_cdf",...)|
|11|uxstats2_normal_p2|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_normal_p2(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_normal_p2",...)|
|12|uxstats2_t_p2|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_t_p2(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_t_p2",...)|
|13|uxstats2_chisq_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_chisq_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_p",...)|
|14|uxstats2_f_p|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_f_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_f_p",...)|
|15|uxstats2_one_sample_t_stat|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_one_sample_t_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_t_stat",...)|
|16|uxstats2_one_sample_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_one_sample_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_t_p",...)|
|17|uxstats2_welch_t_stat|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_welch_t_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_welch_t_stat",...)|
|18|uxstats2_welch_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_welch_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_welch_t_p",...)|
|19|uxstats2_pooled_t_stat|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_pooled_t_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_pooled_t_stat",...)|
|20|uxstats2_pooled_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_pooled_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_pooled_t_p",...)|
|21|uxstats2_paired_t_stat|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_paired_t_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_paired_t_stat",...)|
|22|uxstats2_paired_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_paired_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_paired_t_p",...)|
|23|uxstats2_one_sample_z_stat|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_one_sample_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_z_stat",...)|
|24|uxstats2_one_sample_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_sample_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_z_p",...)|
|25|uxstats2_two_sample_z_stat|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_two_sample_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_sample_z_stat",...)|
|26|uxstats2_two_sample_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_sample_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_sample_z_p",...)|
|27|uxstats2_one_prop_z_stat|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_prop_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_prop_z_stat",...)|
|28|uxstats2_one_prop_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_prop_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_prop_z_p",...)|
|29|uxstats2_two_prop_z_stat|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_prop_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_prop_z_stat",...)|
|30|uxstats2_two_prop_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_prop_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_prop_z_p",...)|
|31|uxstats2_f_variance_stat|Varyans hesaplar.|sonuc = uxstats2.uxstats2_f_variance_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_f_variance_stat",...)|
|32|uxstats2_f_variance_p|Varyans hesaplar.|sonuc = uxstats2.uxstats2_f_variance_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_f_variance_p",...)|
|33|uxstats2_chisq_gof_stat|Ki-kare testi yapar; sınıflı veride beklenen ve gözlenen değerleri karşılaştırır.|sonuc = uxstats2.uxstats2_chisq_gof_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_gof_stat",...)|
|34|uxstats2_chisq_gof_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_chisq_gof_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_gof_p",...)|
|35|uxstats2_chisq_2x2_stat|Ki-kare testi yapar; sınıflı veride beklenen ve gözlenen değerleri karşılaştırır.|sonuc = uxstats2.uxstats2_chisq_2x2_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_2x2_stat",...)|
|36|uxstats2_chisq_2x2_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_chisq_2x2_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_2x2_p",...)|
|37|uxstats2_anova_oneway_f|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_anova_oneway_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_anova_oneway_f",...)|
|38|uxstats2_anova_oneway_p|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_anova_oneway_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_anova_oneway_p",...)|
|39|uxstats2_posthoc_tukey_q|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_posthoc_tukey_q(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_tukey_q",...)|
|40|uxstats2_posthoc_bonferroni_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_posthoc_bonferroni_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_bonferroni_t_p",...)|
|41|uxstats2_posthoc_scheffe_f|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_posthoc_scheffe_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_scheffe_f",...)|
|42|uxstats2_regression_slope|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_regression_slope(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_slope",...)|
|43|uxstats2_regression_intercept|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_regression_intercept(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_intercept",...)|
|44|uxstats2_regression_r2|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_regression_r2(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_r2",...)|
|45|uxstats2_regression_f|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_regression_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_f",...)|
|46|uxstats2_regression_f_p|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_regression_f_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_f_p",...)|
|47|uxstats2_vif_pair|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_vif_pair(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vif_pair",...)|
|48|uxstats2_durbin_watson|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_durbin_watson(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_durbin_watson",...)|
|49|uxstats2_breusch_godfrey_lm|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_breusch_godfrey_lm(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_breusch_godfrey_lm",...)|
|50|uxstats2_breusch_godfrey_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_breusch_godfrey_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_breusch_godfrey_p",...)|
|51|uxstats2_adf_stat|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_adf_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_adf_stat",...)|
|52|uxstats2_adf_p_approx|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_adf_p_approx(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_adf_p_approx",...)|
|53|uxstats2_ancova_binary_f|Kovaryans hesaplar; iki değişkenin birlikte değişim yönünü verir.|sonuc = uxstats2.uxstats2_ancova_binary_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_ancova_binary_f",...)|
|54|uxstats2_ancova_binary_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_ancova_binary_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_ancova_binary_p",...)|
|55|uxstats2_hotelling_t2_2d|Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir.|sonuc = uxstats2.uxstats2_hotelling_t2_2d(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_hotelling_t2_2d",...)|
|56|uxstats2_hotelling_p_2d|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_hotelling_p_2d(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_hotelling_p_2d",...)|

### uxstats2 fonksiyonlarını okuma yöntemi
- **1. `uxstats2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxstats2_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxstats2_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxstats2_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxstats2_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxstats2_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxstats2_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxstats2_covariance_samp`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxstats2_correlation`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxstats2_normal_cdf`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxstats2_normal_p2`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxstats2_t_p2`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxstats2_chisq_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxstats2_f_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxstats2_one_sample_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxstats2_one_sample_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxstats2_welch_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxstats2_welch_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxstats2_pooled_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxstats2_pooled_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxstats2_paired_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxstats2_paired_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxstats2_one_sample_z_stat`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxstats2_one_sample_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxstats2_two_sample_z_stat`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxstats2_two_sample_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxstats2_one_prop_z_stat`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxstats2_one_prop_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxstats2_two_prop_z_stat`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxstats2_two_prop_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxstats2_f_variance_stat`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxstats2_f_variance_p`** — Varyans hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxstats2_chisq_gof_stat`** — Ki-kare testi yapar; sınıflı veride beklenen ve gözlenen değerleri karşılaştırır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxstats2_chisq_gof_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxstats2_chisq_2x2_stat`** — Ki-kare testi yapar; sınıflı veride beklenen ve gözlenen değerleri karşılaştırır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxstats2_chisq_2x2_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxstats2_anova_oneway_f`** — F testi veya varyans analizi olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxstats2_anova_oneway_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxstats2_posthoc_tukey_q`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxstats2_posthoc_bonferroni_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxstats2_posthoc_scheffe_f`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxstats2_regression_slope`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **43. `uxstats2_regression_intercept`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **44. `uxstats2_regression_r2`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **45. `uxstats2_regression_f`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **46. `uxstats2_regression_f_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **47. `uxstats2_vif_pair`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **48. `uxstats2_durbin_watson`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **49. `uxstats2_breusch_godfrey_lm`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **50. `uxstats2_breusch_godfrey_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **51. `uxstats2_adf_stat`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **52. `uxstats2_adf_p_approx`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **53. `uxstats2_ancova_binary_f`** — Kovaryans hesaplar; iki değişkenin birlikte değişim yönünü verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **54. `uxstats2_ancova_binary_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **55. `uxstats2_hotelling_t2_2d`** — Fonksiyon adındaki işe göre veri alır, işler ve sonuç döndürür; çağrıdan sonra dönüş değeri, hata kodu ve kaynak kapatma adımı kontrol edilir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **56. `uxstats2_hotelling_p_2d`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxstats2.uxmh"
DIM grup1 AS LIST OF F64
DIM grup2 AS LIST OF F64
LIST.ADD grup1, 10.2: LIST.ADD grup1, 11.1: LIST.ADD grup1, 9.8
LIST.ADD grup2, 13.0: LIST.ADD grup2, 12.5: LIST.ADD grup2, 14.1
p = uxstats2.welch_t_p(grup1, grup2)
IF p < 0.05 THEN PRINT "fark anlamli" ELSE PRINT "fark belirsiz" END IF
```

## 19. uxtensor

1-5 boyutlu tensör, dilimleme, şekil, veri adresi ve temel tensor işlemleri sağlar. Bu kütüphanede güvenli kullanım sırası: dahil et, oturum/nesne aç, parametreleri yaz, işlemi çağır, sonucu oku, hata varsa `last_error` ailesine bak, en sonda `free` veya kapatma fonksiyonunu çalıştır.

|No|Fonksiyon|Ne yapar|Sözdizimi|
|---|---|---|---|
|1|uxtensor_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxtensor.uxtensor_version(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_version",...)|
|2|uxtensor_backend|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_backend(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_backend",...)|
|3|uxtensor_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxtensor.uxtensor_create(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_create",...)|
|4|uxtensor_create1d_f64|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxtensor.uxtensor_create1d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_create1d_f64",...)|
|5|uxtensor_create2d_f64|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxtensor.uxtensor_create2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_create2d_f64",...)|
|6|uxtensor_create3d_f64|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxtensor.uxtensor_create3d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_create3d_f64",...)|
|7|uxtensor_create4d_f64|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxtensor.uxtensor_create4d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_create4d_f64",...)|
|8|uxtensor_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxtensor.uxtensor_free(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_free",...)|
|9|uxtensor_clone|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_clone(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_clone",...)|
|10|uxtensor_reshape_copy|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_reshape_copy(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_reshape_copy",...)|
|11|uxtensor_slice_axis0_copy|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_slice_axis0_copy(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_slice_axis0_copy",...)|
|12|uxtensor_dtype|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_dtype(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_dtype",...)|
|13|uxtensor_ndim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxtensor.uxtensor_ndim(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_ndim",...)|
|14|uxtensor_dim|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxtensor.uxtensor_dim(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_dim",...)|
|15|uxtensor_stride|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_stride(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_stride",...)|
|16|uxtensor_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxtensor.uxtensor_size(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_size",...)|
|17|uxtensor_elem_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxtensor.uxtensor_elem_size(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_elem_size",...)|
|18|uxtensor_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxtensor.uxtensor_data_ptr(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_data_ptr",...)|
|19|uxtensor_fill_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_fill_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_fill_f64",...)|
|20|uxtensor_zero|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_zero(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_zero",...)|
|21|uxtensor_get_flat_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxtensor.uxtensor_get_flat_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_get_flat_f64",...)|
|22|uxtensor_set_flat_f64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxtensor.uxtensor_set_flat_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_set_flat_f64",...)|
|23|uxtensor_get2d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_get2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_get2d_f64",...)|
|24|uxtensor_set2d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_set2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_set2d_f64",...)|
|25|uxtensor_get3d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_get3d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_get3d_f64",...)|
|26|uxtensor_set3d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_set3d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_set3d_f64",...)|
|27|uxtensor_get4d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_get4d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_get4d_f64",...)|
|28|uxtensor_set4d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_set4d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_set4d_f64",...)|
|29|uxtensor_add_f64|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxtensor.uxtensor_add_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_add_f64",...)|
|30|uxtensor_sub_f64|Çıkarma işlemi yapar.|sonuc = uxtensor.uxtensor_sub_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_sub_f64",...)|
|31|uxtensor_mul_f64|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxtensor.uxtensor_mul_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_mul_f64",...)|
|32|uxtensor_div_f64|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = uxtensor.uxtensor_div_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_div_f64",...)|
|33|uxtensor_scale_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_scale_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_scale_f64",...)|
|34|uxtensor_sum_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_sum_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_sum_f64",...)|
|35|uxtensor_mean_f64|Ortalama hesaplar.|sonuc = uxtensor.uxtensor_mean_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_mean_f64",...)|
|36|uxtensor_blas_ddot|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_blas_ddot(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_blas_ddot",...)|
|37|uxtensor_blas_daxpy|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_blas_daxpy(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_blas_daxpy",...)|
|38|uxtensor_blas_dscal|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_blas_dscal(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_blas_dscal",...)|
|39|uxtensor_dot_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_dot_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_dot_f64",...)|
|40|uxtensor_norm2_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_norm2_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_norm2_f64",...)|
|41|uxtensor_blas_dgemm_rowmajor|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_blas_dgemm_rowmajor(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_blas_dgemm_rowmajor",...)|
|42|uxtensor_matmul2d_f64|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxtensor.uxtensor_matmul2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_matmul2d_f64",...)|
|43|uxtensor_transpose2d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_transpose2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_transpose2d_f64",...)|
|44|uxtensor_matvec2d_f64|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxtensor.uxtensor_matvec2d_f64(...)  \|  sonuc = CALL(DLL,"uxtensor.dll","uxtensor_matvec2d_f64",...)|

### uxtensor fonksiyonlarını okuma yöntemi
- **1. `uxtensor_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **2. `uxtensor_backend`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **3. `uxtensor_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **4. `uxtensor_create1d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **5. `uxtensor_create2d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **6. `uxtensor_create3d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **7. `uxtensor_create4d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **8. `uxtensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **9. `uxtensor_clone`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **10. `uxtensor_reshape_copy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **11. `uxtensor_slice_axis0_copy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **12. `uxtensor_dtype`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **13. `uxtensor_ndim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **14. `uxtensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **15. `uxtensor_stride`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **16. `uxtensor_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **17. `uxtensor_elem_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **18. `uxtensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **19. `uxtensor_fill_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **20. `uxtensor_zero`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **21. `uxtensor_get_flat_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **22. `uxtensor_set_flat_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **23. `uxtensor_get2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **24. `uxtensor_set2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **25. `uxtensor_get3d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **26. `uxtensor_set3d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **27. `uxtensor_get4d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **28. `uxtensor_set4d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **29. `uxtensor_add_f64`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **30. `uxtensor_sub_f64`** — Çıkarma işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **31. `uxtensor_mul_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **32. `uxtensor_div_f64`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **33. `uxtensor_scale_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **34. `uxtensor_sum_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **35. `uxtensor_mean_f64`** — Ortalama hesaplar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **36. `uxtensor_blas_ddot`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **37. `uxtensor_blas_daxpy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **38. `uxtensor_blas_dscal`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **39. `uxtensor_dot_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **40. `uxtensor_norm2_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **41. `uxtensor_blas_dgemm_rowmajor`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **42. `uxtensor_matmul2d_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **43. `uxtensor_transpose2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
- **44. `uxtensor_matvec2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanımda sonucu değişkene al; handle, sayı ve metin dönüşlerini ayrı ayrı denetle.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxtensor.uxmh"
t = uxtensor.create4d_f64(2,3,4,5)
CALL uxtensor.set(t, 1,1,1,1, 42.0)
PRINT uxtensor.get(t, 1,1,1,1)
CALL uxtensor.free(t)
```


# Bölüm 5 — Tarayıcı, JS, WAT/WASM, API, Yapay Zeka ve Bilimsel Analiz

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

## Bölüm 5 ek açıklama akışı

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


# Bölüm 6 — Kaynaklardan Eritilen Ek Notlar

Bu bölüm eski dosyalarda bulunan fakat ana akışta bire bir yer bulmayan özgün notları konu sırasına göre saklar. Eski tablolardaki tekrar eden son sütun cümleleri burada yeniden verilmez; onların yerine Bölüm 2 ve Bölüm 4 içindeki temiz tablolar kullanılır.

### Kaynak notu: `pck.md`

**Dosya adı:** `pck.md`  
**Amaç:** uXBasic öğrenmek, uXBasic ile program yazmak ve uXBasic derleyicisini geliştirmek isteyen genç programcıya cep kitabı vermek.  
**Kaynak gerçekliği:** Bu kitap, `uxb(30.05_3).zip` içindeki kaynak ağacı, lexer, parser, MIR, çalışma zamanı servis kataloğu, kütüphane kayıtları, VSCode belgeleri ve gate raporları taranarak hazırlandı.

### Kaynak notu: `pck.md`

Bu kitap eski kısa belgeler gibi yalnız liste değildir. Önce uXBasic’in ne olduğunu sade bir dille anlatır, sonra dilin komutlarını tabloya döker, sonra her tabloyu örneklerle öğretir, en sonunda da derleyici geliştiren kişiye çalışma yöntemi verir. İngilizce terim gerektiğinde Türkçe karşılık, köşeli parantez içinde açıklama ve parantez içinde İngilizcesi birlikte verilir.

### Kaynak notu: `pck.md`

- ADIM22 tam katman beklenen çıktı kapısı: **PASS / missing_layer_output_count=0 / surface_coverage_count=287**. Bu, temel katman çıktılarının gerçek dosya olarak üretildiğini gösteren güçlü işarettir.

### Kaynak notu: `pck.md`

- ADIM30 on adım zinciri mevcut raporu: **FAIL / fail_count=37 / missing_output_count=72 / placeholder_count=0**. Bu kitap öğretici cep kitabıdır; ADIM30 gibi daha geniş zincirlerde kalan işler varsa, bunlar geliştirme işidir.

### Kaynak notu: `pck.md`

- Çalışma zamanı servislerinde `JSON`, `REGEX`, `HTTP`, `OS`, `LLAMA`, `LUA`, `PROLOG`, `SQLITE`, `BROWSER`, `WEBGPU`, `CURL`, `ONNX` gibi kapılar katalogda görünür. Bunların hepsi dil yüzeyinden çağrılabilir bir tasarıma bağlanır; fakat her biri için gerçek sarmalayıcı [var olan işi çevreleyen ince bağlantı katmanı] (wrapper) ve test yazılmalıdır.

### Kaynak notu: `pck.md`

## Bu kitap yedi çalışma oturumu olarak okunmalı

### Kaynak notu: `pck.md`

uXBasic, BASIC dilinin sade okunurluğunu sistem programlama hedefleriyle birleştirmeye çalışan bir dildir. BASIC geleneğinde `PRINT`, `DIM`, `IF`, `FOR`, `SUB`, `FUNCTION` gibi kolay okunan komutlar vardır. uXBasic bu okunurluğu korurken dış kütüphane çağırma, DLL/API kullanma, C/C++/ASM dosyası içe alma, JavaScript üretme, WebAssembly metni üretme, x64 assembly üretme ve tarayıcıda çalışma gibi daha ileri hedeflere açılır.

### Kaynak notu: `pck.md`

Bir dili yalnız komut listesi zannetmek yanlıştır. Dil, yazdığın metni önce parçalara ayırır, sonra ağaca çevirir, sonra anlamını çözer, sonra ara dile indirir, sonra çalıştırır ya da başka hedefe kod üretir. uXBasic’in asıl değeri bu zinciri açık katmanlara ayırmasıdır. Bir genç programcı için en güzel taraf şudur: aynı programı önce yorumlayıcı [satırları veya ara temsili hemen çalıştıran katman] (interpreter) ile deneyebilir, sonra derleyici [programı başka makine diline veya hedef koda çeviren katman] (compiler) ile üretebilir.

### Kaynak notu: `pck.md`

uXBasic ile konsol programı, dosya işleyen araç, veri okuyan küçük analiz programı, Windows DLL kullanan sistem aracı, tarayıcıda çalışan küçük oyun, JavaScript çıktısı, WebAssembly metni, x64 assembly çıktısı ve ileride daha büyük bilimsel/istatistiksel yardımcılar yapılabilir. Ama her hedefin destek düzeyi aynı değildir. Bu yüzden programcı daima şu soruyu sorar: “Bu komut lexer tarafından tanınıyor mu, parser AST düğümü üretiyor mu, anlam katmanı kabul ediyor mu, MIR’e iniyor mu, hedef kod üreticisi bunu biliyor mu, runtime servisi var mı?”

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Bu örnekte `PRINT` ekrana yazar, `DIM` değişken tanımlar, `AS I32` değişkenin 32 bit işaretli tam sayı olduğunu söyler, `IF` ise karar verir. Kodun güzel tarafı, okuyan kişinin programın amacını tahmin edebilmesidir.

### Kaynak notu: `pck.md`

# 2. uXBasic mimarisi: genç programcı için sade anlatım

### Kaynak notu: `pck.md`

uXBasic kaynak ağacında bu katmanlar ayrı klasörler ve dosyalarla görünür. `src/parser` sözcükleyici ve ayrıştırıcı tarafını, `src/semantic` anlam ve MIR indirme tarafını, `src/mir` MIR modelini, `src/runtime` çalışma zamanı servislerini, `src/codegen/js` JavaScript üretimini, `src/codegen/wasm` WebAssembly metin üretimini, `src/backend` hedef bağlama akışını, `src/cli` komut satırı yönlendirmesini taşır. Bu ayrım yalnız düzen için değildir; hata bulurken de hayat kurtarır.

### Kaynak notu: `pck.md`

Bir uXBasic programının yolculuğu şöyledir:

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Bu zinciri ezberlemek yerine günlük kontrol cümlesi olarak kullan: “Bir özellik ekledim, peki her katmanda izi var mı?” Sadece lexer’a kelime eklemek dil özelliği eklemek değildir. Parser AST üretmezse kelime ölüdür. MIR’e inmiyorsa hedefler görmez. Runtime servisi yoksa çalışırken patlar.

### Kaynak notu: `pck.md`

Program, bilgisayara verilen sıradır. Değişken, adı olan kutudur. Tip, kutuya hangi tür değer konacağını söyler. Deyim, yapılacak işi anlatan satırdır. İfade, değer üreten parçadır. `5 + 3` bir ifadedir; `PRINT 5 + 3` bir deyimdir.

### Kaynak notu: `pck.md`

```uxbasic
DIM fiyat AS F64
DIM adet AS I32
DIM toplam AS F64
fiyat = 12.5
adet = 4
toplam = fiyat * adet
PRINT "Toplam="; toplam
```

### Kaynak notu: `pck.md`

Burada `F64` kesirli sayılar için güvenli seçimdir. `I32` genel tam sayıdır. `PRINT` içinde noktalı virgül kullanmak, BASIC geleneğinde yan yana yazdırma niyeti verir. Virgül ise alanlı yazdırma niyeti taşır.

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Döngü, aynı işi tekrarlar. Sayaçlı tekrar için `FOR`, koşullu tekrar için `DO` kullanılır:

### Kaynak notu: `pck.md`

```uxbasic
DIM i AS I32
DIM toplam AS I32
toplam = 0
FOR i = 1 TO 10 STEP 1
    toplam += i
NEXT
PRINT "1 den 10 a toplam="; toplam
```

### Kaynak notu: `pck.md`

Yordam [adı olan tekrar kullanılabilir kod parçası] (subroutine) yazmak için `SUB`, değer döndüren yordam yazmak için `FUNCTION` kullanılır:

### Kaynak notu: `pck.md`

SUB Baslik(yazi AS STRING)
    PRINT "==== "; yazi; " ===="
END SUB

### Kaynak notu: `pck.md`

# 4. Tam komut tablosu: parser dağıtımına göre gerçek yüzey

### Kaynak notu: `pck.md`

Aşağıdaki tablo, kaynakta `AddStatementDispatchEntry` ile gerçek ayrıştırıcı dağıtımına giren komutlardan hazırlanmıştır. Bu yüzden yalnız lexer’da görünen her sözcük değil, parser tarafından deyim olarak yakalanan komutlar esas alınmıştır.

### Kaynak notu: `pck.md`

### 4.1 Yazdırma, değişken, karar, döngü, yordam birlikte

### Kaynak notu: `pck.md`

```uxbasic
CONST LIMIT AS I32 = 5
DIM i AS I32
DIM kare AS I32

### Kaynak notu: `pck.md`

FUNCTION Hesapla(x AS I32) AS I32
    RETURN x * x
END FUNCTION

### Kaynak notu: `pck.md`

FOR i = 1 TO LIMIT
    kare = Hesapla(i)
    IF kare > 10 THEN
        PRINT "Buyuk kare: "; kare
    ELSE
        PRINT "Kucuk kare: "; kare
    END IF
NEXT
```

### Kaynak notu: `pck.md`

Bu örnekte beşten fazla komut birlikte çalışır: `CONST`, `DIM`, `FUNCTION`, `RETURN`, `FOR`, `IF`, `PRINT`, `NEXT`. Programın amacı sayıların karesini almak ve eşiğe göre yazdırmaktır. İpucu şudur: küçük fonksiyon yazmak aklı temizler. Döngünün içine uzun formül gömmek yerine `Hesapla` gibi ad koyarsan program okunur.

### Kaynak notu: `pck.md`

```uxbasic
DIM ad AS STRING
DIM satir AS STRING
ad = "rapor.txt"

### Kaynak notu: `pck.md`

OPEN ad FOR OUTPUT AS #1
PUT #1, 1, "uXBasic raporu"
CLOSE #1

### Kaynak notu: `pck.md`

OPEN ad FOR INPUT AS #1
GET #1, 1, satir
PRINT "Dosyadan gelen="; satir
CLOSE #1
```

### Kaynak notu: `pck.md`

Dosya işinde kural basittir: aç, işle, kapat. `OPEN` olmazsa dosya yolu yoktur. `PUT` yazmak, `GET` okumak içindir. `SEEK` ile konum değiştirilir. Hata yakalamayı güçlendirmek için dosya yolu, yetki, uzunluk ve son durum ayrıca raporlanmalıdır.

### Kaynak notu: `pck.md`

### 4.3 Bellek işleri: güçlü ama tehlikeli alan

### Kaynak notu: `pck.md`

```uxbasic
DIM adres AS U64
DIM deger AS U8
adres = 1024
deger = 65
POKEB adres, deger
PRINT "Bellege bayt yazildi"
```

### Kaynak notu: `pck.md`

Bellek komutları sistem programlama için önemlidir. Ama bellek komutu oyuncak değildir. Yanlış adrese yazmak programı bozabilir. Bu yüzden `POKEB`, `MEMCOPYB`, `MEMFILLB` gibi komutlarda önce hedef adresi, uzunluğu ve sınırı düşün. Derleyici yazarken buna “kapalı başarısızlık” [emin değilse çalışmayı durdurma] (fail closed) denir.

### Kaynak notu: `pck.md`

SLOT EkranaYaz(kod AS I32)
    PRINT "Tus kodu="; kod
END SLOT

### Kaynak notu: `pck.md`

ON EkranaYaz
TRIGGER TusBasildi(65)
OFF EkranaYaz
```

### Kaynak notu: `pck.md`

Kaynakta `EVENT`, `SLOT`, `ON`, `OFF`, `TRIGGER`, `PIPE`, `THREAD`, `PARALEL` yüzeyi vardır. Bu aile programı parçalara ayırmak için düşünülmelidir. Olay “bir şey oldu” demektir. Yuva “o şey olunca bu kod çalışsın” demektir. Boru “veri buradan oraya aksın” demektir. İş parçacığı [aynı program içinde ayrı çalışma kolu] (thread) ise eşzamanlılık işidir.

### Kaynak notu: `pck.md`

Ön-işleyici, program daha tokenlara ayrılmadan çalışır. Makro tanımlar, koşullu satır seçer, dosya ekler ve bazı blokları geçer. Bu katman özellikle çok hedefli program yazarken önemlidir. Aynı kaynak Windows için başka, tarayıcı için başka satır açabilir.

### Kaynak notu: `pck.md`

```uxbasic
%%DEFINE DEBUG 1
%%IF DEBUG
PRINT "Hata ayiklama acik"
%%ELSE
PRINT "Normal calisma"
%%ENDIF

### Kaynak notu: `pck.md`

%%MACRO KARE(X) ((X) * (X))
DIM a AS I32
a = KARE(7)
PRINT a
```

### Kaynak notu: `pck.md`

Makro, dikkatli kullanılmalıdır. Makro metin değiştirir; tip bilmez. Bu yüzden `KARE(X)` gövdesinde parantez kullanmak küçük ama zeki bir hiledir. `KARE(1+2)` yazılırsa `((1+2) * (1+2))` olur. Parantezsiz yazılsaydı işlem önceliği bozulabilirdi.

### Kaynak notu: `pck.md`

Tip seçimi programcının namusudur. Her şeyi `F64` yapmak kolay görünür ama belleği ve anlamı bozar. Her şeyi `I32` yapmak da kesirli hesabı yok eder. En iyi yol, verinin gerçek doğasına göre tip seçmektir.

### Kaynak notu: `pck.md`

```uxbasic
DIM sayac AS I32
DIM uzunluk AS U64
DIM sicaklik AS F64
DIM ad AS STRING
DIM dogruMu AS BOOLEAN

### Kaynak notu: `pck.md`

sayac = 10
uzunluk = 2048
sicaklik = 24.75
ad = "deney-1"
dogruMu = sayac > 0
PRINT ad; " sicaklik="; sicaklik
```

### Kaynak notu: `pck.md`

İpucu: Dosya boyu, adres ve uzunluk gibi negatif olmaması gereken değerlerde `U64` iyi seçimdir. Bilimsel ölçümde `F64` kullan. Ekran ve dosya metninde `STRING` kullan. DLL/API çağırırken `PTR` ve `STRPTR` gibi işaretçi tiplerini ancak ne yaptığını biliyorsan kullan.

### Kaynak notu: `pck.md`

Kod gerçekliği açısından `ARRAY`, `LIST`, `DICT`, `SET` lexer yüzeyinde vardır; AST/MIR zincirinde her hedef için destek seviyesi ayrıca doğrulanmalıdır. Bu yüzden cep kuralı şudur: dizi temel örneklerde daha güvenli alandır; liste/sözlük/küme için önce ilgili test dosyasını ve MIR çıktısını kontrol et.

### Kaynak notu: `pck.md`

```uxbasic
TYPE Olcum
    zaman AS F64
    sicaklik AS F64
    ph AS F64
END TYPE

### Kaynak notu: `pck.md`

DIM o AS Olcum
o.zaman = TIMER()
o.sicaklik = 25.1
o.ph = 7.8
PRINT "pH="; o.ph
```

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Sınıf, yalnız “havalı” olduğu için kullanılmaz. Aynı veriyi ve o veriye ait davranışı birlikte tutmak için kullanılır. `Sayac` sınıfı içinde değeri dışarıdan doğrudan oynatmak yerine `Artir` yöntemi kullanılır. Bu, büyük programlarda hatayı azaltır.

### Kaynak notu: `pck.md`

İşlem önceliğini ezberlemek yerine parantez kullan. Derleyici yazarken de aynı kural geçerlidir: belirsizliği okuyucuya bırakma.

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Bit işlemleri sistem programlamada kullanılır. Örneğin bir bayt içinde bayrak saklayabilirsin:

### Kaynak notu: `pck.md`

```uxbasic
DIM bayrak AS U8
bayrak = 0
bayrak = bayrak OR 1      ' birinci ozelligi ac
bayrak = bayrak OR 4      ' ucuncu biti ac
IF (bayrak AND 4) <> 0 THEN
    PRINT "Ucuncu bit acik"
END IF
```

### Kaynak notu: `pck.md`

Metin ve sayı fonksiyonlarını birlikte kullanma örneği:

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Bilimsel hesapta önce veriyi temizle, sonra sayıya çevir, sonra hesapla. Bu küçük sıra büyük hataları önler.

### Kaynak notu: `pck.md`

Aşağıdaki tablo, kaynakta `UXBRuntimeServiceCatalogAdd` çağrılarıyla görünen çalışma zamanı servislerinden üretilmiştir. Servis, dil komutunun gerçek dünyada iş yaptırdığı kapıdır. Örneğin `PRINT` komutu sonuçta `RT_PRINT` ailesine, dosya işleri `RT_FILE_*` ailesine, dış çağrılar `RT_DLL_CALL` ve `RT_API_CALL` ailesine bağlanır.

### Kaynak notu: `pck.md`

Burada hedefler önemlidir. Bir servis `X64` yazıyorsa Windows yerel tarafta düşünülür. `JS` ve `BROWSER` yazıyorsa JavaScript/tarayıcı hedefinde çalışabilecek kapı vardır. `WASM` yazıyorsa WebAssembly tarafında sözleşme düşünülmüştür. Programcı komut yazarken hedefini baştan bilmelidir.

### Kaynak notu: `pck.md`

Kütüphane kayıt tablosunda modüller, çalışma zamanı uzantıları ve test aileleri görünür. Bu kayıtlar, uXBasic’in dış dünyaya nasıl büyüyeceğini gösterir.

### Kaynak notu: `pck.md`

Bu modül adlarını birer sözleşme gibi düşün. `uxstats` istatistik için, `uxllama` yerel yapay zeka için, `uxdataframe` tablo verisi için, `uxgraph` graf için, `uxonnx` model çalıştırmak için, `uxmatrix` matris için kapı adıdır. Bir modül adı tek başına mucize değildir. Önce DLL veya dış araç, sonra sarmalayıcı, sonra uXBasic alias, sonra test gerekir.

### Kaynak notu: `pck.md`

Geliştirici için en önemli taktik şudur: aynı kaynak dosya için önce AST JSON, sonra HIR JSON, sonra MIR JSON, sonra hedef çıktı üret. Hata hangi katmanda çıkıyorsa orada dur. Derleyici geliştirmede rastgele düzeltme yapmak yerine katmanlı kanıt toplamak gerekir.

### Kaynak notu: `pck.md`

Dış kütüphane çağırmak, programın kendi kodu dışında hazırlanmış işlevleri kullanmasıdır. Dinamik bağlantı kütüphanesi [Windows üzerinde çalışırken yüklenen ikili kütüphane] (DLL) çağırırken üç şey gerekir: kütüphane adı, sembol adı ve imza. İmza, gönderilen ve dönen tiplerin sözleşmesidir. Kaynakta `CALL(DLL, ...)` ve `CALL(API, ...)` yüzeyi vardır.

### Kaynak notu: `pck.md`

```uxbasic
CALL(DLL, "KERNEL32.DLL", "GetTickCount", U64)
CALL(DLL, "USER32.DLL", "MessageBoxA", I32, STDCALL, 0, "Merhaba", "Baslik", 0)
```

### Kaynak notu: `pck.md`

Kod gerçekliği uyarısı: parser tarafında `CALL(DLL)` için en az kütüphane, sembol, imza ve argüman bekleyen doğrulama izleri vardır. İmza tokenları olarak `VOID`, `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`; çağrı düzeni olarak `CDECL`, `STDCALL` görülür. FFI imza ayrıştırıcı tarafında ayrıca `(I32,F64)->VOID` biçimli daha geniş imza metni desteği vardır. Geliştirici bu iki düzeyi tek sözleşmeye yaklaştırmalıdır.

### Kaynak notu: `pck.md`

DLL çağrısında üç altın kural vardır. Birincisi, mutlak yol verme; kütüphane adını güvenli tut. İkincisi, metin geçiriyorsan `STRPTR` mantığını bil. Üçüncüsü, `BYREF` kullanıyorsan gönderdiğin şey adreslenebilir değişken olmalı. Sabit ifadeye başvuru verilemez.

### Kaynak notu: `pck.md`

```uxbasic
IMPORT(C, "native/hizli_hesap.c")
IMPORT(CPP, "native/matris.cpp")
IMPORT(ASM, "native/hizli_rutin.asm")

### Kaynak notu: `pck.md`

DECLARE FUNCTION HizliTopla(a AS I32, b AS I32) AS I32
PRINT HizliTopla(3, 4)
```

### Kaynak notu: `pck.md`

Burada `IMPORT` dosyayı projeye bildirir, `DECLARE FUNCTION` ise uXBasic tarafındaki imzayı bildirir. Derleyici zinciri gerçek bağlama yapacaksa build aşamasında C derleyici, C++ derleyici veya assembler çağırmalıdır. Kaynakta toolchain kapsamı olarak FreeBASIC, NASM, GCC ve G++ izleri görünür.

### Kaynak notu: `pck.md`

```uxbasic
NAMESPACE Matematik
    FUNCTION IkiKat(x AS I32) AS I32
        RETURN x * 2
    END FUNCTION
END NAMESPACE

### Kaynak notu: `pck.md`

USING Matematik
ALIAS IK = Matematik.IkiKat
PRINT IK(21)
```

### Kaynak notu: `pck.md`

Ad alanı [isim çakışmasını önleyen bölge] (namespace) büyük projede aynı adlı fonksiyonların kavga etmesini engeller. Modül [birlikte taşınan işlev grubu] (module) bir iş ailesini toparlar. Alias [kısa ad] uzun çağrıyı okunur kılar. Using [kullanıma açma] sık kullanılan ad alanını görünür yapar.

### Kaynak notu: `pck.md`

# 14. REST, curl, Flask, yerel yapay zeka ve uzak yapay zeka

### Kaynak notu: `pck.md`

Temsili durum: uXBasic çekirdeğinde her uzak servis için ayrı komut açmak yerine `HTTP`, `CURL`, `SERVER`, `LLAMA` gibi çalışma zamanı servisleri ve dış kütüphane sarmalayıcıları kullanılır. Bu daha temizdir. Dil şişmez; kütüphane büyür.

### Kaynak notu: `pck.md`

```uxbasic
MODULE Ag
    DECLARE FUNCTION HttpPost(url AS STRING, body AS STRING) AS STRING
END MODULE

### Kaynak notu: `pck.md`

DIM cevap AS STRING
cevap = Ag.HttpPost("http://127.0.0.1:5000/tahmin", "{"x":42}")
PRINT cevap
```

### Kaynak notu: `pck.md`

Burada `HttpPost` gerçek uXBasic çekirdek komutu olmak zorunda değildir. Bir DLL, curl sarmalayıcısı, HTTP runtime servisi veya dış program köprüsü olabilir. Önemli olan uXBasic tarafında temiz imza tutmaktır: URL metin, gövde metin, cevap metin.

### Kaynak notu: `pck.md`

```uxbasic
MODULE Curl
    DECLARE FUNCTION PostJson(url AS STRING, json AS STRING) AS STRING
END MODULE

### Kaynak notu: `pck.md`

DIM sonuc AS STRING
sonuc = Curl.PostJson("http://127.0.0.1:8000/api", "{"soru":"merhaba"}")
PRINT sonuc
```

### Kaynak notu: `pck.md`

Yerel yapay zeka için `uxllama` ve `RT_LLAMA_CALL` aileleri düşünülür. Uzak yapay zeka için doğrudan özel ürün adıyla çekirdeğe komut eklemek yerine HTTP/REST kapısı kullanmak daha doğru olur. Böylece Google, başka bir bulut servisi veya kendi sunucun değişse bile uXBasic programı yalnız endpoint ve anahtar katmanını değiştirir.

### Kaynak notu: `pck.md`

```uxbasic
MODULE YerelZeka
    DECLARE FUNCTION Sor(model AS STRING, soru AS STRING) AS STRING
END MODULE

### Kaynak notu: `pck.md`

DIM yanit AS STRING
yanit = YerelZeka.Sor("yerel-model", "Bu veride aykiri deger var mi?")
PRINT yanit
```

### Kaynak notu: `pck.md`

İpucu: Yapay zeka çağrısını asla programın her satırına dağıtma. Bir `MODULE YerelZeka` aç, tüm çağrıları oradan geçir. Sonra hata kaydı, süre ölçümü, tekrar deneme ve anahtar saklama işlerini tek yerde çözersin.

### Kaynak notu: `pck.md`

# 15. Bilimsel veri, istatistik ve sahte değerlerle örnekler

### Kaynak notu: `pck.md`

Bilimsel program yazarken önce veri, sonra temizlik, sonra özet, sonra test gelir. Ortalama, varyans, standart sapma, z testi ve F testi gibi işlemler ezber formül değildir; verinin ne söylediğini ölçme yoludur.

### Kaynak notu: `pck.md`

```uxbasic
DIM n AS I32
DIM i AS I32
DIM x(1 TO 5) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM fark AS F64
DIM varyans AS F64

### Kaynak notu: `pck.md`

n = 5
x(1) = 10.2
x(2) = 11.1
x(3) = 9.8
x(4) = 10.9
x(5) = 10.5

### Kaynak notu: `pck.md`

toplam = 0
FOR i = 1 TO n
    toplam += x(i)
NEXT
ort = toplam / n

### Kaynak notu: `pck.md`

varyans = 0
FOR i = 1 TO n
    fark = x(i) - ort
    varyans += fark * fark
NEXT
varyans = varyans / (n - 1)
PRINT "Ortalama="; ort
PRINT "Varyans="; varyans
```

### Kaynak notu: `pck.md`

Z testi fikri: Bir örnek ortalaması bilinen toplum ortalamasından kaç standart hata uzakta?

### Kaynak notu: `pck.md`

```uxbasic
DIM ornekOrt AS F64
DIM toplumOrt AS F64
DIM sigma AS F64
DIM n AS F64
DIM z AS F64

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

F testi fikri: İki grubun varyansları birbirinden çok farklı mı?

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

Bu örneklerde kritik olan “p değeri hesabı” değil, akış mantığıdır. Gerçek istatistik modülü yazıldığında `uxstats` sarmalayıcısı F dağılımı, t dağılımı, z dağılımı, güven aralığı, ANOVA, korelasyon ve regresyon fonksiyonlarını taşımalıdır. Önce basit formülü elle yazmak programcıya ne yaptığını öğretir.

### Kaynak notu: `pck.md`

# 16. Tarayıcı, JavaScript, WebAssembly ve WebGPU hedefi

### Kaynak notu: `pck.md`

Tarayıcı hedefi, uXBasic programını web sayfasında çalıştırma fikridir. Kaynakta JavaScript üretici, tarayıcı bootstrap dosyaları, WebAssembly metin üretimi ve WebGPU servis adı görülür. Terimleri netleştirelim: JavaScript [tarayıcıların doğrudan çalıştırdığı dil] (JavaScript), WebAssembly [tarayıcıda düşük seviye ve hızlı ikili çalışma biçimi] (WebAssembly), WAT [WebAssembly metin biçimi] (WebAssembly Text), WebGPU [tarayıcıdan ekran kartına modern erişim] (WebGPU).

### Kaynak notu: `pck.md`

```uxbasic
PRINT "Tarayici konsoluna merhaba"
DIM x AS I32
x = 10
PRINT x * 2
```

### Kaynak notu: `pck.md`

Bu basit program JS çıktısına döndüğünde `program.js`, WAT çıktısına döndüğünde `program.wat`, tarayıcı kabuğuna döndüğünde `index.html` beklenir. ADIM22 raporunda bu dosyaların gerçek üretildiği görülmüştür. Ancak tarayıcıda gerçek çalışma için yol ayıracı, dosya yolu, wasm yükleme ve servis köprüleri ayrıca test edilmelidir.

### Kaynak notu: `pck.md`

# 17. Derleyici yazarken kullanılan zeki hileler

### Kaynak notu: `pck.md`

Bir derleyici projesinde en kötü alışkanlık “bir satır değiştirdim, oldu galiba” demektir. İyi alışkanlık “hangi katman kabul etti, hangi çıktı oluştu, hangi rapor temiz” demektir. uXBasic projesinin iyi tarafı kapı testleriyle düşünmesidir.

### Kaynak notu: `pck.md`

Kanca [belirli akış noktasında kayıt alma veya ek davranış] (hook) doğru kullanılırsa izleme aracıdır; yanlış kullanılırsa mimariyi sakatlar. Kanca, çekirdek davranışı değiştirmemeli; olayı kaydetmeli veya dışarıya haber vermelidir. Sarmalayıcı [var olan kodu temiz arayüzle çağıran katman] (wrapper) ise kirli dış dünyayı temiz uXBasic imzasına çevirir. Örneğin curl karmaşık olabilir ama uXBasic tarafında `Curl.PostJson(url, body)` sade görünmelidir.

### Kaynak notu: `pck.md`

Çıktı sözleşmesi hilesi: Test runner eksik dosyayı uydurmamalıdır. Derleyici dosyayı üretmiyorsa test kalmalıdır. Eski placeholder yaklaşımı kolay PASS verir ama programcıyı kandırır. Gerçek kalite, “dosya gerçekten var mı, içeriği gerçek mi, JSON bozuk mu, hedef kod çalışıyor mu” sorularından geçer.

### Kaynak notu: `pck.md`

Kaynak eşleme [üretilen hatayı kaynak satıra bağlama] (source mapping) genç programcının dostudur. Hata “MIR kırıldı” demek yerine “şu dosya, şu satır, şu komut” demelidir. Büyük projede hata mesajı ne kadar iyi ise geliştirme o kadar hızlıdır.

### Kaynak notu: `pck.md`

uXBasic programcısı hem kendi programını hem derleyiciyi test eder. Pozitif test “çalışması gereken çalışıyor mu?” sorusudur. Negatif test “hata vermesi gereken hata veriyor mu?” sorusudur. Sadece pozitif test yazmak yarım iştir.

### Kaynak notu: `pck.md`

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

### Kaynak notu: `pck.md`

```powershell
rg -n "GENERATED_PLACEHOLDER|placeholder|ensure_declared_outputs" uxb/tools/control
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim25_26_27_close_gates.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

### Kaynak notu: `pck.md`

Bu komutlar programın dili değildir; geliştiricinin kontrol aracıdır. Ama cep kitabında bulunmalıdır çünkü uXBasic gibi çok katmanlı projede “ben çalıştı sanıyorum” yerine “kapı geçti” demek gerekir.

### Kaynak notu: `pck.md`

# 19. Örnek mini proje: veri dosyasından özet rapor

### Kaynak notu: `pck.md`

CONST N AS I32 = 5
DIM i AS I32
DIM x(1 TO N) AS F64
DIM toplam AS F64
DIM ort AS F64
DIM enbuyuk AS F64

### Kaynak notu: `pck.md`

toplam = 0
enbuyuk = x(1)
FOR i = 1 TO N
    toplam += x(i)
    IF x(i) > enbuyuk THEN
        enbuyuk = x(i)
    END IF
NEXT
ort = toplam / N

### Kaynak notu: `pck.md`

OPEN "ozet.txt" FOR OUTPUT AS #1
PUT #1, 1, "Ortalama=" + STR(ort)
CLOSE #1

### Kaynak notu: `pck.md`

PRINT "Ortalama="; ort
PRINT "En buyuk="; enbuyuk
%%IF DEBUG
PRINT "DEBUG: N="; N
%%ENDIF
```

### Kaynak notu: `pck.md`

Bu programda ön-işleyici, sabit, dizi, döngü, karar, dosya yazma, metne çevirme ve yazdırma birlikte kullanılır. Programın amacı basittir: beş ölçümü özetlemek ve rapor dosyasına yazmak. Küçük görünen bu yapı, gerçek bilimsel programların çekirdeğidir.

### Kaynak notu: `pck.md`

# 20. uXBasic geliştiricisine son tavsiyeler

### Kaynak notu: `pck.md`

Bir: Dil çekirdeğini gereksiz büyütme. Her yeni dış iş için yeni anahtar kelime açmak yerine `MODULE`, `NAMESPACE`, `ALIAS`, `USING`, `CALL`, `IMPORT`, `DECLARE` ve çalışma zamanı servislerini kullan. Böylece dil sade kalır, kütüphane büyür.

### Kaynak notu: `pck.md`

İki: Güvenliği her yere yayma; doğru yere koy. DLL yolu, include yolu, bellek sınırı, dış çağrı imzası ve çıktı sözleşmesi güvenlik için doğru noktalardır. Her satıra korku koyarsan dil programcıyı boğar. Hiç kontrol koymazsan sistem çöker.

### Kaynak notu: `pck.md`

Üç: OOP [nesne yönelimli programlama] (object-oriented programming) geniş olmalı ama tutarlı olmalı. `CLASS`, `INTERFACE`, `METHOD`, `PROPERTY`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE`, `ABSTRACT`, `FINAL`, `SEALED` gibi yüzeyler ancak semantic, layout, MIR ve backend tarafında gerçek karşılık bulursa değerlidir.

### Kaynak notu: `pck.md`

Dört: Floating point [kesirli sayı hesabı] (floating point) için çekirdek küçük kalabilir; `F80`, `F128`, `BIGF`, `BIGD`, `BALL` gibi ağır işler dış DLL ile taşınabilir. Bu doğru mimaridir çünkü büyük sayı işi özel ve ağırdır.

### Kaynak notu: `pck.md`

Beş: Her yeni servis için test klasöründe yalnız o aşamanın geniş testlerini tut. Eski testleri yeni pakete tekrar doldurma. Yeni komut için tek tek test ve en az iki birleşik kullanım testi yaz.

### Kaynak notu: `pck.md`

Altı: Genç programcıya en değerli bilgi şudur: Bir programı çalıştırmak başka, bir sistemi doğru çalıştırmak başkadır. uXBasic gibi bir projede gerçek başarı, komutun lexer’dan başlayıp hedef çıktıya kadar dürüstçe izlenebilmesidir.

### Kaynak notu: `pck.md`

- Önce küçük program yaz: `PRINT`, `DIM`, `IF`, `FOR`.
- Sonra fonksiyon yaz: `FUNCTION`, `SUB`, `RETURN`.
- Sonra dosya kullan: `OPEN`, `PUT`, `GET`, `CLOSE`.
- Sonra tipleri ciddiye al: `I32`, `U64`, `F64`, `STRING`, `PTR`.
- Sonra dış dünyaya çık: `DECLARE`, `IMPORT`, `CALL(DLL)`, `CALL(API)`.
- Sonra katmanı izle: AST, HIR, MIR, runtime, backend.
- Sonra test yaz: pozitif, negatif, çıktı sözleşmesi.

### Kaynak notu: `pck.md`

Bu cep kitabını okuyan biri uXBasic’i yalnız “BASIC benzeri komutlar” diye değil, katmanlı ve büyütülebilir bir sistem programlama aracı olarak görmelidir.

### Kaynak notu: `pckd.md`

Bu ana dosya beş ciltlik kitabın kapısıdır. Bu sürümde tekrar eden tablo cümleleri temizlenmiş; her komut, fonksiyon, işleç, veri tipi, veri yapısı ve kütüphane için sözdizimi, kısa görev, kullanım yeri ve örnek yaklaşımı genişletilmiştir.

### Kaynak notu: `pckd.md`

Önceki sürümde bazı tablo satırlarında aynı açıklama tekrarlanıyordu. Bu sürümde o yaklaşım kaldırıldı. Tablo hücrelerinde doğrudan sözdizimi ve kısa görev yazıldı; uzun açıklamalar sınıf başlıklarına taşındı. `EVENT`, `SLOT`, `PIPE`, `THREAD`, `PARALEL`, `CALL`, `DECLARE`, `INCLUDE`, `IMPORT`, `BIGD`, `BIGF`, `BALL`, `LIST`, `DICT`, `SET`, JS ve WAT/WASM örnekleri daha somut hale getirildi.

### Kaynak notu: `pckg.md`

Önce Cilt 1'i baştan sona oku. Sonra Cilt 2'de komut tablosunu ezberlemeye çalışma; her gün on komut seçip küçük program yaz. Cilt 3 veri yönetimi içindir; dizileri ve koleksiyonları anlamadan büyük program yazılmaz. Cilt 4 dış kütüphane gücüdür; burada yeni komut eklemeden dilin büyümesini görürsün. Cilt 5 ise uXBasic'i dünyaya bağlar: tarayıcı, DLL, ağ, yapay zeka, WebAssembly ve test.

### Kaynak notu: `pckg.md`

## Genişletilmiş ciltlerin gerçek okuma sırası

### Kaynak notu: `pckg.md`

Bu cep kitabı beş cilt gibi okunmalıdır. İlk cilt, dili neden yazdığımızı, hangi haklarla kullanıldığını, hangi dosyanın ne işe yaradığını ve mimarinin nasıl katmanlandığını anlatır. İkinci cilt, dilin kelimelerini öğretir: komutlar, ön-işleyici komutları, tipler, işleçler ve yerel işlevler burada sözlük gibi değil, küçük örneklerle anlatılır. Üçüncü cilt, değişken, bellek, dizi, liste, sözlük, küme, nesne, olay, boru, iş parçacığı ve koşut çalışma alışkanlığını kazandırır. Dördüncü cilt, kütüphaneleri birer alet kutusu olarak ele alır; matematik, istatistik, çizge, veri çerçevesi, yapay sinir ağı, tensör, büyük sayı ve yerel yapay zeka kapıları burada büyütülür. Beşinci cilt ise dili dış dünyaya bağlar: tarayıcı, JavaScript çıktısı, WAT/WASM çıktısı, DLL, API, curl, Flask, ChatGPT, Gemini, Llama, dosya sistemi, terminal, test kapısı ve sürüm çıkarma burada toplanır.

### Kaynak notu: `pckg.md`

Bu sürümde `uxb(30.05_4)` çalışma ağacındaki kaynak, araç, patch, readme, hook, wrapper ve kütüphane izleri normal programın parçası kabul edilmiştir. Bu yüzden kitapta geçen `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT`, ön-işleyici meta komutları, tarayıcı varlık üretimi, DLL/API yolu, JS/WAT üretimi, çalışma zamanı kütüphaneleri ve test kapıları yama gibi değil, uXBasic programcısının günlük kullanabileceği dil özellikleri olarak anlatılır.

### Kaynak notu: `pckg.md`

1. **Cilt 1 — Başlangıç ve mimari:** önsöz, kullanım hakkı, MIT lisansı, sorumluluk reddi, dosya türleri, çıktı türleri, katman haritası, hook ve wrapper mantığı, geliştirici öğütleri.
2. **Cilt 2 — Dil yüzeyi:** anahtar kelimeler, komut tabloları, ön-işleyici komutları, veri tipleri, işleçler, yerel işlevler, küçük örnek kalıpları.
3. **Cilt 3 — Veri ve program yapısı:** değişken sınırları, diziler, çok boyutlu diziler, `ARRAY`, `LIST`, `DICT`, `SET`, pointer, bellek, nesne, namespace, module, alias, using module, olay ve eşzamanlılık.
4. **Cilt 4 — Kütüphaneler:** `uxmath`, `uxstats`, `uxstats2`, `uxmatrix`, `uxtensor`, `uxdataframe`, `uxgraph`, `uxcollections`, `uxnn`, `uxaimath`, `uxonnx`, `uxllama`, `fp80`, `fp128`, `bigfp`.
5. **Cilt 5 — Dış dünya ve örnekler:** Windows DLL, curl, REST, Flask, ChatGPT, Gemini, yerel Llama, JS üretimi, WAT/WASM, inline C/CPP/ASM, terminal, dosya sistemi, test, sürüm çıkarma.

### Kaynak notu: `pckn.md`

Bu ana dosya beş ciltlik cep kitabını gösterir.

### Kaynak notu: `pckn.md`

Bu sürüm `uxb(30.05_3).zip` içindeki son gerçek kaynak klasörü temel alınarak hazırlanmıştır. Kitap dili öğretici tutulmuş, uXBasic'in tüm kütüphanelerinin çalıştığı varsayılmıştır.

### Kaynak notu: `pck1d.md`

# Başlangıç, Kullanım Hakkı, Dosyalar ve Mimari

### Kaynak notu: `pck1d.md`

Bu kitap uXBasic'i yalnız komut listesi olarak değil, çalışan bir düşünme aracı olarak anlatır. Genç programcı için en önemli bilgi şudur: program, bilgisayara verilen emirlerin kuru dizisi değildir; veri toplama, karar verme, dış dünya ile konuşma ve sonucu ölçme düzenidir. uXBasic bu düzeni BASIC tadında okunur bir yüzeyle, C/C++/ASM ve DLL gücüyle, tarayıcı ve WebAssembly çıktısıyla birleştirmek için tasarlanmıştır. Burada geçen teknik sözcüklerde önce Türkçe ad verilir, gerekirse köşeli parantez içinde kısa açıklama ve parantez içinde İngilizce karşılığı yazılır. Örneğin kanca [derleyicinin bir aşamasına zarar vermeden ek davranış takma noktası] (hook), sarmalayıcı [dış fonksiyonu uXBasic'e düzenli çağrı gibi gösteren ince katman] (wrapper) demektir.

### Kaynak notu: `pck1d.md`

Bu sürüm, `uxb(30.05_4).zip` içindeki son gerçek kaynak ağacı, patch/readme kararları, çalışma zamanı kütüphaneleri, araçlar, kanca ve sarmalayıcı klasörleri esas alınarak genişletildi. Kitapta bazı yama adları geçse bile bunlar artık “sonradan eklenecek parçalar” gibi değil, uXBasic'in normal programlama yüzeyi ve araç düzeni gibi anlatılır. Büyük sayı ailesi olan `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL` ve `BIGINIT` bu nedenle normal dil/kütüphane yetenekleri olarak ele alınır. Her şeyin çalıştığı varsayılmıştır; bu kitap kullanıcının hayal gücünü tetiklemek için örnekleri gerçek kullanım senaryolarına bağlar.

### Kaynak notu: `pck1d.md`

Bu kitap ve örnekler MIT lisansı anlayışıyla kullanılabilir. MIT lisansı; kodu inceleme, değiştirme, dağıtma, özel veya ticari projede kullanma özgürlüğü verir. Buna karşılık yazar, bu kitabın kullanımından doğabilecek veri kaybı, yanlış hesap, gelir kaybı, donanım sorunu, üçüncü taraf API ücretleri, sistem çökmesi veya hukuki sonuçlardan sorumlu değildir. Özellikle DLL, dosya silme, bellek yazma, ağ ve yapay zeka API kullanımlarında kullanıcı kendi ortamını, gizli anahtarlarını ve güvenlik sınırlarını korumalıdır.

### Kaynak notu: `pck1d.md`

Sorun, öneri veya destek için: `zmetedinler@gmail.com`. Kullanımdan memnun kalırsanız küçük destek için 50 TL veya 25 ABD doları göndermeniz sevinçle karşılanır. IBAN ve ödeme bilgileri dağıtım paketinin ticari sürümünde ayrıca verilebilir. Bu bilgi bağış niteliğindedir; kitabı kullanma hakkını sınırlamaz.

### Kaynak notu: `pck1d.md`

Bir dili öğrenmenin yolu önce komut ezberlemek değildir. Önce “hangi veriyi alıyorum, bu veriye hangi kararı veriyorum, sonucu nereye yazıyorum?” sorusunu sormalısın. Her örneği çalıştırmadan önce kâğıda üç kutu çiz: giriş, işlem, çıkış. Giriş kullanıcıdan, dosyadan, sensörden, ağdan veya DLL'den gelebilir. İşlem; koşul, döngü, fonksiyon, veri yapısı ve kütüphane çağrısıdır. Çıkış; ekran, dosya, grafik, tarayıcı, API cevabı veya başka programa verilen veri olabilir. İyi programcı hata çıkmayacağını varsaymaz; hata çıkarsa ne yapacağını baştan yazar. uXBasic'te `TRY`, `ASSERT`, test kapıları, rapor dosyaları ve çıktı sözleşmeleri bu yüzden önemlidir.

### Kaynak notu: `pck1d.md`

uXBasic mimarisi bir mutfak gibi düşünülebilir. Önce malzeme gelir: kaynak dosyası. Ön-işleyici [kaynak derlenmeden önce çalışan düzenleyici] (preprocessor) malzemeyi ayıklar; hedefe göre HTML, JS, WAT, varlık ve bildirim parçalarını hazırlar. Sözcükleyici [metni anlamlı parçalara bölen katman] (lexer) komutları, adları, sayıları ve işaretleri ayırır. Çözümleyici [komutları ağaç yapısına çeviren katman] (parser) artık “IF nerede başladı, FOR nerede bitti, FUNCTION ne döndürür?” gibi yapıyı kurar. Soyut söz ağacı [programın ağaç biçimindeki anlamlı iskeleti] (AST) bu yapıyı taşır. Anlam ve tip katmanı değişkenin ne olduğunu, hangi işlemin hangi tipe uygulanabileceğini ve dış çağrının imzasını denetler. Orta gösterim [hedeflerden bağımsız ara komut düzeni] (MIR), programı JS, WAT, x64, x86 veya yorumlayıcıya götürülebilecek ortak biçime indirir. Arka uç [son çıktı üretici] (backend) hedef dosyaları yazar. Çalışma zamanı [program çalışırken yardım eden kütüphane düzeni] (runtime) dosya, matematik, büyük sayı, yapay zeka, grafik ve dış dünya işlerini taşır.

### Kaynak notu: `pck1d.md`

Kanca (hook) derleyicinin bir aşamasına “beni de haberdar et” demenin güvenli yoludur. İyi kanca asıl işi bozmaz; yalnız izleme, rapor, ölçüm veya özel genişletme yapar. Sarmalayıcı (wrapper) ise dış dünyanın dağınık fonksiyonlarını uXBasic tarafında temiz bir çağrıya çevirir. Genç programcı şunu unutmasın: iyi sarmalayıcı, kötü kütüphaneyi bile okunur yapar; kötü sarmalayıcı, iyi kütüphaneyi anlaşılmaz yapar. Bu yüzden her DLL çağrısında `DECLARE`, `ALIAS`, `MODULE`, `NAMESPACE`, hata kontrolü ve kaynak kapatma düzeni birlikte düşünülür.

### Kaynak notu: `pck1d.md`

uXBasic yalnız program üretmez; aynı zamanda ürettiği programın kanıtını da verir. `tokens.json`, `ast.json`, `symbol_table.json`, `type_table.json`, `mir.json`, `program.js`, `program.wat`, `index.html`, `manifest.json`, `stdout.txt`, `stderr.txt` ve `runtime_trace.json` gibi çıktılar bunun parçalarıdır. Bir çıktı yoksa test kapısı bunu söylemelidir; çıktı uydurmak yasaktır. Genç programcı için ders şudur: gerçek programcılıkta “çalıştı gibi” değil, “kanıtıyla çalıştı” denir.

### Kaynak notu: `pck1n.md`

## Başlangıç, Haklar, Dosyalar, Mimari ve Çalışma Mantığı

### Kaynak notu: `pck1n.md`

**Hazırlayan:** Zühtü Mete Dinler  
**İletişim:** zmetedinler@gmail.com  
**Lisans niyeti:** MIT Lisansı  
**Destek notu:** Bu belge ve uXBasic çalışmaları faydalı olursa 50 TL kullanım desteği veya 25$ bağış göndermeniz sevinç verir. IBAN bilgisi kesinleşince buraya yazılmalıdır: `IBAN: TR__ ____ ____ ____ ____ ____ __`.

### Kaynak notu: `pck1n.md`

Bu cep kitabı uXBasic dilini öğrenmek, denemek ve geliştirmek isteyenler için hazırlanmıştır. Kaynak kodun MIT Lisansı ile dağıtıldığı varsayılmıştır. MIT Lisansı kısaca şunu söyler: kodu kullanabilir, kopyalayabilir, değiştirebilir, birleştirebilir, yayımlayabilir ve kendi işinizde kullanabilirsiniz; fakat lisans metnini ve telif bildirimini korumalısınız. Bu yazılım ve belge **olduğu gibi** verilir. Kullanımdan doğabilecek veri kaybı, yanlış hesaplama, güvenlik açığı, ticari zarar, sistem bozulması, yanlış DLL/API çağrısı veya yanlış bilimsel sonuçlardan belge yazarı sorumlu değildir. Deney, üretim, finans, sağlık, resmi işlem, güvenlik ve gerçek cihaz kontrolünde önce küçük test yapın.

### Kaynak notu: `pck1n.md`

uXBasic, BASIC ailesinin kolay okunur yapısını, çağdaş derleyici [kaynak kodu makineye çeviren program] (compiler) katmanlarıyla birleştirmek için tasarlanmış bir dildir. Genç programcı için en önemli düşünce şudur: bir dili öğrenmek yalnız komut ezberlemek değildir. Komutun ne zaman kullanılacağını, verinin nereden geldiğini, bellekte nereye gittiğini, çıktı dosyasına nasıl döndüğünü ve hata olursa nerede yakalanacağını anlamaktır.

### Kaynak notu: `pck1n.md`

uXBasic ile amaç yalnız `PRINT "Merhaba"` yazmak değildir. Aynı dil ile dosya okuyabilir, veri analizi yapabilir, DLL çağırabilir, Windows API kullanabilir, C/C++/ASM dosyasını derleme zincirine alabilir, tarayıcı için JavaScript [tarayıcı dili] (JavaScript) üretebilir, WebAssembly metni [tarayıcıda hızlı çalışan ara çıktı] (WAT/WASM) çıkarabilir, yerel yapay zekaya veya bulut yapay zekaya mesaj gönderebilirsiniz.

### Kaynak notu: `pck1n.md`

Önce küçük program yaz. Sonra aynı programı üç kez boz ve düzelt. Bir komutu gerçekten öğrendiğini anlamanın yolu onu hata alacak biçimde de denemektir. `DIM` ile değişken aç, yanlış tip ver, hata raporuna bak. `OPEN` ile dosya aç, sonra kapatmayı unut, davranışı izle. `IF` yaz, sonra `ELSE` kısmını boş bırak. Derleyici yazan kişinin aklı, hatayı erken yakalayan akıldır.

### Kaynak notu: `pck1n.md`

Programlama hilesi dediğimiz şey çoğu zaman kural dışı numara değildir. Doğru yerde küçük bir kayıt tutmaktır. Mesela bir derleyicide her komutun hangi dosyadan, hangi satırdan geldiğini saklarsan, hata mesajını çok daha iyi verirsin. Bir `symbol_table.json` [sembol tablosu çıktısı] üretirsen, programdaki bütün değişkenleri sonra test edebilirsin. Bu yüzden uXBasic yalnız dil değil, aynı zamanda izlenebilir bir derleme düzenidir.

### Kaynak notu: `pck1n.md`

`.uxb` yeni uXBasic programının ana evidir. `.bas` eski BASIC alışkanlığını taşır. `.uxmh` başlık ve modül bildirimlerini tutar. Büyük projede ana program kısa kalır, ayrıntılar `.uxmh` ve kütüphane dosyalarına ayrılır. Bu bir kitap yazmaya benzer: ana bölümde konu akar, eklerde ayrıntı durur.

### Kaynak notu: `pck1n.md`

İşlem sırası şöyledir: kaynak okunur, ön-işleyici çalışır, sözlükçü kelimeleri ayırır, çözümleyici ağacı kurar, anlam denetimi değişkenleri ve tipleri kontrol eder, ara temsil üretilir, istenirse yorumlayıcı çalıştırır, istenirse kod üretici hedef dosyayı yazar. Bu sıra bozulursa derleyici de şaşırır. Bu yüzden test kapıları her aşamada çıktı ister.

### Kaynak notu: `pck1n.md`

```powershell
uxb <fiil> kaynak.uxb [seçenekler]
uxb ast oyun.uxb --ast-json-out out/ast.json
uxb jsw webdemo.uxb --emit-js --json-out out/js_report.json
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

### Kaynak notu: `pck1n.md`

Çıktı dosyası uydurulmamalıdır. Bir test geçiyorsa dosya gerçekten derleyici tarafından üretilmelidir. `program.js` içinde gerçek JavaScript, `program.wat` içinde gerçek WAT, `index.html` içinde gerçek tarayıcı kabuğu olmalıdır. Genç programcı için bu altın kuraldır: testin amacı kendini kandırmak değil, hatayı erken bulmaktır.

### Kaynak notu: `pck1n.md`

```text
6105 EMIT hatası: Kod üretici çıktı yazamadı.
6109 FILE hatası: Dosya yolu, izin veya yazma sorunu var.
```

### Kaynak notu: `pck1n.md`

```basic
MAIN
    DIM ad AS STRING
    DIM yas AS I32
    PRINT "Adini yaz"
    INPUT ad
    PRINT "Yasini yaz"
    INPUT yas

### Kaynak notu: `pck1n.md`

IF yas < 18 THEN
        PRINT ad + " henuz cok genc."
    ELSE
        PRINT ad + " artik buyuk projelere baslayabilir."
    END IF
END MAIN
```

### Kaynak notu: `pck1n.md`

Bu program beş temel işi öğretir: `MAIN` giriş noktasıdır, `DIM` değişken açar, `PRINT` çıktı verir, `INPUT` veri alır, `IF` karar verir. Programın amacı kullanıcıyı tanımak değildir; veri akışını öğretmektir. Veri klavyeden gelir, değişkende durur, şartla yorumlanır, ekrana döner.

### Kaynak notu: `pck2n.md`

## Dil Yüzeyi, Komutlar, Ön-İşleyici, Tipler, İşleçler ve Yerel Fonksiyonlar

### Kaynak notu: `pck2n.md`

Bu ciltte amaç komut ezberletmek değil, her komutun program içindeki yerini göstermektir. Önce anahtar kelimeleri görürsün; sonra gerçek parser dağıtımındaki komutlar gelir. Bir anahtar kelime lexer tarafından tanınıyor olabilir ama her hedefte aynı derinlikte işlenmeyebilir. Bu kitapta her şeyin çalıştığını varsayıyoruz; yine de iyi programcı her hedefte test alır.
## Anahtar kelime tablosu

### Kaynak notu: `pck2n.md`

**Görev:** Ekrana, dosyaya veya çalışma günlüğüne değer yazdırır. İlk denemelerde en çok kullanılan komuttur.

### Kaynak notu: `pck2n.md`

```basic
PRINT "Merhaba uXBasic"
PRINT 10 + 20
```

### Kaynak notu: `pck2n.md`

**Ne zaman kullanılır:** Programın o bölümünde veri akışını, karar noktasını, dış bağlantıyı veya kaynak yönetimini açık göstermek istediğinde kullanılır. Önce küçük örnekle dene; sonra aynı komutu dosya, kütüphane veya tarayıcı çıktısı içinde tekrar kullan.

### Kaynak notu: `pck2n.md`

**İpucu:** Bu komutu test ederken bir doğru, bir de bilerek yanlış örnek yaz. Derleyici sana hangi satırda neyin bozulduğunu söylüyorsa sistem sağlıklıdır.

### Kaynak notu: `pck2n.md`

**Görev:** C, C++, ASM veya başka ara kod parçasını kaynak içine yerleştirir.

### Kaynak notu: `pck2n.md`

**Görev:** İç yordamı, dış DLL/API çağrısını veya kayıtlı servisi çağırır.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `CALL ad(arg1, arg2)  veya CALL(DLL, "dll", "fonksiyon", ...)`

### Kaynak notu: `pck2n.md`

```basic
CALL Topla(3,4)
CALL(DLL, "kernel32.dll", "Beep", 750, 300)
```

### Kaynak notu: `pck2n.md`

**Görev:** Şarta göre iki yoldan birini seçtirir.

### Kaynak notu: `pck2n.md`

```basic
IF yas >= 18 THEN
    PRINT "Yetiskin"
ELSE
    PRINT "Genc"
END IF
```

### Kaynak notu: `pck2n.md`

**Görev:** Bir değeri birçok olasılığa göre dallandırır.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `SELECT CASE ifade ... CASE değer ... END SELECT`

### Kaynak notu: `pck2n.md`

```basic
SELECT CASE ifade ... CASE değer ... END SELECT
```

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `FOR i = başlangıç TO bitiş STEP adım ... NEXT`

### Kaynak notu: `pck2n.md`

**Görev:** Etikete doğrudan atlar; az kullanılmalıdır.

### Kaynak notu: `pck2n.md`

**Görev:** Eski BASIC tarzı alt bölüme gider, RETURN ile döner.

### Kaynak notu: `pck2n.md`

**Görev:** Fonksiyon veya GOSUB dönüşünü yapar.

### Kaynak notu: `pck2n.md`

**Görev:** Döngüden, yordamdan veya bloktan çıkar.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `END [IF|SELECT|TYPE|CLASS|NAMESPACE|MODULE]`

### Kaynak notu: `pck2n.md`

```basic
END [IF|SELECT|TYPE|CLASS|NAMESPACE|MODULE]
```

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `TRY ... CATCH e ... FINALLY ... END TRY`

### Kaynak notu: `pck2n.md`

```basic
TRY
    CALL RiskliIs()
CATCH e
    PRINT "Hata yakalandi"
END TRY
```

### Kaynak notu: `pck2n.md`

**Görev:** Bir şart doğru değilse testte hata üretir.

### Kaynak notu: `pck2n.md`

**Görev:** NEW ile açılmış nesne veya kaynağı bırakır.

### Kaynak notu: `pck2n.md`

**Görev:** Dış fonksiyon, DLL veya API bildirimini yapar.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `DECLARE FUNCTION ad LIB "dll" ALIAS "gerçek_ad" (...) AS tip`

### Kaynak notu: `pck2n.md`

```basic
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32
```

### Kaynak notu: `pck2n.md`

**Görev:** Geri değer döndürmeyen yordam tanımlar.

### Kaynak notu: `pck2n.md`

**Görev:** Geri değer döndüren yordam tanımlar.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `FUNCTION ad(parametreler) AS tip ... END FUNCTION`

### Kaynak notu: `pck2n.md`

```basic
FUNCTION ad(parametreler) AS tip ... END FUNCTION
```

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `DIM ad AS tip  veya DIM a(10,10) AS I32`

### Kaynak notu: `pck2n.md`

```basic
DIM toplam AS I32
DIM ad AS STRING
```

### Kaynak notu: `pck2n.md`

**Görev:** Dizinin boyutunu sonradan değiştirir.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `TYPE Ad ... alan AS tip ... END TYPE`

### Kaynak notu: `pck2n.md`

```basic
CLASS Balik
    DIM agirlik AS F64
END CLASS
```

### Kaynak notu: `pck2n.md`

**Görev:** Bu sözcük kendi bağlamındaki yapıyı kurar; kullanım biçimi hemen altındaki örnekte gösterilir.

### Kaynak notu: `pck2n.md`

**Görev:** Sınıfların uyması gereken sözleşmeyi tanımlar.

### Kaynak notu: `pck2n.md`

**Görev:** Ad çakışmasını önleyen ad alanı açar.

### Kaynak notu: `pck2n.md`

**Görev:** Bir işi yapan kod/kütüphane birimini tanımlar.

### Kaynak notu: `pck2n.md`

**Görev:** Programın ana giriş bölümünü belirtir.

### Kaynak notu: `pck2n.md`

**Görev:** Bir ad alanını veya modülü kısa adla kullanmaya açar.

### Kaynak notu: `pck2n.md`

**Görev:** Uzun bir adı kısa veya uyumlu başka bir ada bağlar.

### Kaynak notu: `pck2n.md`

**Görev:** Başka uXBasic başlık/kaynak dosyasını ekler.

### Kaynak notu: `pck2n.md`

```basic
INCLUDE "core.uxmh"
INCLUDE "modules/uxstats.uxmh"
```

### Kaynak notu: `pck2n.md`

**Görev:** Derleme zamanında C/C++/ASM gibi dış kaynak dosyasını projeye alır.

### Kaynak notu: `pck2n.md`

```basic
IMPORT(C, "kutuphane.c")
IMPORT(ASM, "hizli_rutin.asm")
```

### Kaynak notu: `pck2n.md`

```basic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Baslik"
CLOSE #1
```

### Kaynak notu: `pck2n.md`

```basic
OPEN "veri.bin" FOR BINARY AS #1
GET #1, , x
CLOSE #1
```

### Kaynak notu: `pck2n.md`

```basic
OPEN "veri.bin" FOR BINARY AS #1
PUT #1, , x
CLOSE #1
```

### Kaynak notu: `pck2n.md`

**Görev:** Nesne/bellek yerleşim ofsetini ayarlar.

### Kaynak notu: `pck2n.md`

**Söz dizimi:** `SETNEWOFFSET tipAdi, alanAdi, ofset`

### Kaynak notu: `pck2n.md`

```basic
EVENT VeriGeldi(deger AS I32)
SLOT Yaz(deger AS I32)
ON VeriGeldi CALL Yaz
TRIGGER VeriGeldi(42)
```

### Kaynak notu: `pck2n.md`

```basic
THREAD Hesapla(1000)
PRINT "Ana is devam ediyor"
```

### Kaynak notu: `pck2n.md`

**Görev:** Olayın bağlanacağı alıcı yuva tanımlar.

### Kaynak notu: `pck2n.md`

Derleme öncesi sabit tanımlar. Söz dizimi: `%%DEFINE ...`

### Kaynak notu: `pck2n.md`

```basic
%%DEFINE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

```basic
%%SET DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Derleme öncesi makro tanımlar. Söz dizimi: `%%MACRO ...`

### Kaynak notu: `pck2n.md`

```basic
%%MACRO DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

```basic
%%UNDEF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

```basic
%%IF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Karşılaştırmalı şartlı derleme yapar. Söz dizimi: `%%IFC ...`

### Kaynak notu: `pck2n.md`

```basic
%%IFC DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

```basic
%%ELSE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

```basic
%%ENDIF DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Derleme öncesi dosya ekler. Söz dizimi: `%%INCLUDE ...`

### Kaynak notu: `pck2n.md`

```basic
%%INCLUDE DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Derlemeyi burada bitirir. Söz dizimi: `%%ENDCOMP ...`

### Kaynak notu: `pck2n.md`

```basic
%%ENDCOMP DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Hata ile derlemeyi bitirir. Söz dizimi: `%%ERRORENDCOMP ...`

### Kaynak notu: `pck2n.md`

```basic
%%ERRORENDCOMP DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Platform bilgisi kullanır. Söz dizimi: `%%PLATFORM ...`

### Kaynak notu: `pck2n.md`

```basic
%%PLATFORM DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Hedef işletim sistemi seçer. Söz dizimi: `%%DESTOS ...`

### Kaynak notu: `pck2n.md`

```basic
%%DESTOS DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Sıfırlama davranışını değiştirir. Söz dizimi: `%%NOZEROVARS ...`

### Kaynak notu: `pck2n.md`

```basic
%%NOZEROVARS DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

Güvenli yığın ayarı yapar. Söz dizimi: `%%SECSTACK ...`

### Kaynak notu: `pck2n.md`

```basic
%%SECSTACK DEMO
PRINT "Derleme oncesi ayar denendi"
```

### Kaynak notu: `pck2n.md`

-128..127 küçük tamsayı. Kullanım: `DIM x AS I8`.

### Kaynak notu: `pck2n.md`

0..255 işaretsiz küçük tamsayı. Kullanım: `DIM x AS U8`.

### Kaynak notu: `pck2n.md`

genel amaç işaretsiz. Kullanım: `DIM x AS U32`.

### Kaynak notu: `pck2n.md`

tek duyarlıklı kesirli sayı. Kullanım: `DIM x AS F32`.

### Kaynak notu: `pck2n.md`

çift duyarlıklı kesirli sayı. Kullanım: `DIM x AS F64`.

### Kaynak notu: `pck2n.md`

çok geniş kayan nokta. Kullanım: `DIM x AS F128`.

### Kaynak notu: `pck2n.md`

çok büyük kesirli sayı. Kullanım: `DIM x AS BIGF`.

### Kaynak notu: `pck2n.md`

çok büyük ondalık sayı. Kullanım: `DIM x AS BIGD`.

### Kaynak notu: `pck2n.md`

çok büyük mantıksal/özel geniş tip. Kullanım: `DIM x AS BALL`.

### Kaynak notu: `pck2n.md`

toplama veya metin birleştirme. Küçük deneme:

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a + b
```

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a MOD b
```

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a AND b
```

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a SHL b
```

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a ROL b
```

### Kaynak notu: `pck2n.md`

adres veya özel birleştirme bağlamı. Küçük deneme:

### Kaynak notu: `pck2n.md`

```basic
DIM a AS I32
DIM b AS I32
a = 10
b = 3
PRINT a BYREF/BYVAL b
```

### Kaynak notu: `pck2n.md`

Bazı fonksiyonlar parametre ister, bazıları sistemden değer okur. Örneğin `TIMER` zamandan, `RND` rastgele sayı üretecinden, `LEN` metnin içinden bilgi alır.

### Kaynak notu: `pck3g.md`

# Değişken, Bellek, Diziler, Veri Yapıları, Nesne ve Eşzamanlılık

### Kaynak notu: `pck3g.md`

Değişken, bellekte bir kutudur. Tip, bu kutunun nasıl okunacağını söyler. `I32` ile tutulan değer tam sayıdır; `F64` ile tutulan değer kesirli bilimsel sayıdır; `PTR` veya `U64` ile tutulan değer çoğu zaman dış kütüphane handle bilgisidir. Bir handle doğrudan sayı gibi görünür ama aslında dış DLL içindeki nesnenin anahtarıdır.
```uxbasic
DIM ad AS STRING
DIM yas AS I32
DIM sicaklik AS F64
DIM df AS U64
ad = "Mete"
yas = 25
sicaklik = 24.7
PRINT ad; " "; yas; " "; sicaklik
```
## 2, 3, 4 ve 5 boyutlu diziler

### Kaynak notu: `pck3g.md`

Dizi, aynı tipten çok sayıda kutuyu düzenli saklar. İki boyut tablo, üç boyut katmanlı tablo, dört boyut zamanlı hacim, beş boyut deney seti gibi düşünülebilir.
```uxbasic
' 2 boyut: ogrenci x ders not tablosu
DIM notlar(1 TO 3, 1 TO 4) AS F64
FOR ogr = 1 TO 3
    FOR ders = 1 TO 4
        notlar(ogr, ders) = ogr * 10 + ders
    NEXT ders
NEXT ogr
PRINT notlar(2, 3)
```
```uxbasic
' 3 boyut: gun x havuz x olcum
DIM su(1 TO 7, 1 TO 4, 1 TO 3) AS F64
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        su(gun, havuz, 1) = 7.5       ' pH
        su(gun, havuz, 2) = 24.0      ' sicaklik
        su(gun, havuz, 3) = 6.8       ' oksijen
    NEXT havuz
NEXT gun
PRINT su(3, 2, 3)
```
```uxbasic
' 4 boyut: yil x ay x istasyon x parametre
DIM izleme(2024 TO 2026, 1 TO 12, 1 TO 5, 1 TO 6) AS F64
izleme(2026, 5, 2, 1) = 8.1
PRINT izleme(2026, 5, 2, 1)
```
```uxbasic
' 5 boyut: deney x tekrar x zaman x organ x olcum
DIM deney(1 TO 2, 1 TO 3, 1 TO 10, 1 TO 4, 1 TO 5) AS F64
deney(1, 2, 5, 3, 4) = 0.875
PRINT deney(1, 2, 5, 3, 4)
```

### Kaynak notu: `pck3g.md`

## ARRAY, LIST, DICT, SET
```uxbasic
DIM isimler AS LIST
DIM puanlar AS DICT
DIM turler AS SET
LIST.ADD isimler, "Ali"
LIST.ADD isimler, "Ayse"
DICT.SET puanlar, "Ali", 82
DICT.SET puanlar, "Ayse", 91
SET.ADD turler, "alabalik"
SET.ADD turler, "alabalik"
PRINT DICT.GET(puanlar, "Ayse")
```

### Kaynak notu: `pck3g.md`

`VARPTR`, `SADD`, `LPTR`, `CODEPTR`, `PEEK*`, `POKE*`, `MEMCOPY*`, `MEMFILL*` komutları uXBasic'i sistem programlama tarafına taşır. Bu komutlar güçlüdür; yanlış adres verirsen veri bozarsın. Kural: önce küçük tamponda dene, sonra gerçek veriye uygula.
```uxbasic
DIM tampon(0 TO 15) AS BYTE
MEMFILLB VARPTR(tampon(0)), 0, 16
POKEB VARPTR(tampon(0)), 65
PRINT CHR(PEEKB(VARPTR(tampon(0))))
```

### Kaynak notu: `pck3g.md`

Sınıf [veri ve davranış kalıbı] (class), aynı veriyle çalışan yordamları aynı çatıya toplar. `PUBLIC`, `PRIVATE`, `PROTECTED`, `METHOD`, `CONSTRUCTOR`, `DESTRUCTOR`, `VIRTUAL`, `OVERRIDE` gibi sözcükler bu çatıyı kurar.
```uxbasic
CLASS Sensor
PUBLIC:
    DIM ad AS STRING
    DIM sonDeger AS F64
    CONSTRUCTOR Sensor(yeniAd AS STRING)
        ad = yeniAd
        sonDeger = 0
    END CONSTRUCTOR
    METHOD Oku(deger AS F64)
        sonDeger = deger
    END METHOD
    METHOD Yaz()
        PRINT ad; "="; sonDeger
    END METHOD
END CLASS
DIM s AS Sensor
s = NEW Sensor("pH")
s.Oku(7.8)
s.Yaz()
DELETE s
```

### Kaynak notu: `pck3g.md`

Olay sistemi, bir programda “şu olursa bu çalışsın” demektir. `EVENT` olay adını, `SLOT` olaya bağlanan işi, `TRIGGER` olayı ateşlemeyi, `PIPE` veri yolunu, `THREAD` ayrı iş parçacığını, `PARALEL` eşzamanlı iş fikrini taşır.
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
```uxbasic
THREAD DosyaOkuyucu
    OPEN "olcum.csv" FOR INPUT AS #1
    INPUT #1, satir
    CLOSE #1
END THREAD
PARALEL Analiz
    PRINT "Ana program donmadan analiz basladi"
END PARALEL
```

### Kaynak notu: `pck3g.md`

## Veri yapılarının her biri için derin kullanım defteri

### Kaynak notu: `pck3g.md`

Bir veri yapısını öğrenmenin en iyi yolu, onu gerçek hayattaki kutuya benzetmektir. `ARRAY` numaralı raf, `LIST` uzayan liste, `DICT` etiketli çekmece, `SET` tekrar kabul etmeyen sepet, `OBJECT` davranışı olan varlık, `PTR` ise dış dünyadaki bir şeyin adres pusulasıdır.

### Kaynak notu: `pck3g.md`

Sözdizimi: `DIM ad(alt TO ust, ...) AS tip`. Sabit ölçüm tablosu, matris, görüntü, deney planı ve oyun tahtası için uygundur.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM ph(1 TO 7, 1 TO 4) AS F64
DIM gun AS I32
DIM havuz AS I32
FOR gun = 1 TO 7
    FOR havuz = 1 TO 4
        ph(gun, havuz) = 7.2 + gun * 0.01 + havuz * 0.02
    NEXT havuz
NEXT gun
PRINT "3. gun 2. havuz pH="; ph(3, 2)
```

### Kaynak notu: `pck3g.md`

İpucu: İki boyutlu dizi tablo gibi okunur. Birinci indeks satır, ikinci indeks sütun gibi düşünülür. Bilimsel ölçümde indeksleri isimlendiremiyorsan yanına açıklayıcı sabit koy: `PH_COL = 1`, `TEMP_COL = 2`.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM olcum(1 TO 30, 1 TO 6, 1 TO 3) AS F64
DIM g AS I32, h AS I32
FOR g = 1 TO 30
    FOR h = 1 TO 6
        olcum(g,h,1)=7.5
        olcum(g,h,2)=24.0
        olcum(g,h,3)=6.4
    NEXT h
NEXT g
PRINT olcum(10,3,2)
```

### Kaynak notu: `pck3g.md`

```uxbasic
DIM sensor(2026 TO 2027, 1 TO 12, 1 TO 31, 1 TO 8) AS F64
sensor(2026,5,30,1)=24.8
sensor(2026,5,30,2)=7.9
PRINT "Bugun sensor1="; sensor(2026,5,30,1)
```

### Kaynak notu: `pck3g.md`

```uxbasic
DIM deneme(1 TO 3, 1 TO 5, 1 TO 4, 1 TO 10, 1 TO 6) AS F64
' grup, tekrar, tank, zaman, parametre
deneme(2,3,1,7,4)=0.912
PRINT "7. zamanda 4. parametre="; deneme(2,3,1,7,4)
```

### Kaynak notu: `pck3g.md`

Sözdizimi: `DIM ad AS LIST`, `LIST.ADD ad, deger`, `LIST.GET(ad, sira)`. Uzunluğu sonradan belli olan şeylerde kullanılır.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM loglar AS LIST
LIST.ADD loglar, "Basladi"
LIST.ADD loglar, "Veri okundu"
LIST.ADD loglar, "Rapor yazildi"
PRINT LIST.GET(loglar, 2)
```

### Kaynak notu: `pck3g.md`

Gerçek iş: hata günlüğü tut, testlerde hangi dosya geçti yaz, kullanıcıya son işlemleri göster. `ARRAY` kullanırsan başta boyut bilmen gerekir; `LIST` bu zorunluluğu kaldırır.

### Kaynak notu: `pck3g.md`

Sözdizimi: `DIM ad AS DICT`, `DICT.SET ad, anahtar, deger`, `DICT.GET(ad, anahtar)`. Ayar, JSON benzeri veri, istasyon adı, kullanıcı rolü ve sembol tablosu için uygundur.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM ayar AS DICT
DICT.SET ayar, "hedef", "browser"
DICT.SET ayar, "outdir", "dist/web"
DICT.SET ayar, "debug", "true"
PRINT "Hedef="; DICT.GET(ayar, "hedef")
```

### Kaynak notu: `pck3g.md`

Derleyici yazarken `DICT` altın değerindedir. Lexer bir kelime gördüğünde anahtar kelime mi diye `DICT` içinde arayabilir. Parser bir değişken gördüğünde sembol tablosuna `DICT.SET symbol, ad, tip` diyebilir.

### Kaynak notu: `pck3g.md`

Sözdizimi: `DIM ad AS SET`, `SET.ADD ad, deger`, `SET.HAS(ad, deger)`. Bir şeyi bir kez saymak istediğinde kullanılır.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM turler AS SET
SET.ADD turler, "alabalik"
SET.ADD turler, "sazan"
SET.ADD turler, "alabalik"
IF SET.HAS(turler, "sazan") THEN PRINT "Sazan listede var"
```

### Kaynak notu: `pck3g.md`

İpucu: Bir CSV dosyasından gelen şehir adlarını temizlemek istiyorsan önce `SET`, sonra rapor için `LIST` kullan. Böylece hem tekrar gider hem sıralı yazdırırsın.

### Kaynak notu: `pck3g.md`

## Program içi tablolar: sembol, tip, sabit ve hata tabloları

### Kaynak notu: `pck3g.md`

uXBasic gibi bir derleyicide tablolar programın hafızasıdır. Sembol tablosu değişken adını tipe bağlar. Tip tablosu hangi tipin kaç bayt olduğunu tutar. Sabit tablosu tekrar eden metin ve sayıları saklar. Hata tablosu satır, sütun, kod ve açıklamayı bir arada taşır.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM symbol AS DICT
DIM types AS DICT
DIM errors AS LIST
DICT.SET types, "I32", 4
DICT.SET types, "F64", 8
DICT.SET symbol, "sicaklik", "F64"
IF DICT.GET(symbol, "sicaklik") <> "F64" THEN LIST.ADD errors, "Tip uyumsuz"
PRINT "sicaklik tipi="; DICT.GET(symbol, "sicaklik")
```

### Kaynak notu: `pck3g.md`

Genç programcı için kural: Bir program büyüdükçe `IF` sayısını azaltmak için tablo kullan. Yüz satırlık `IF kelime = ...` zinciri yerine `DICT` ile anahtar aramak daha temizdir.

### Kaynak notu: `pck3g.md`

## Dosya ve dizin işleriyle gerçek belge üretimi

### Kaynak notu: `pck3g.md`

Dosya işlemleri programcının dış hafızasıdır. `OPEN` dosyayı açar, `PRINT #` yazar, `INPUT #` okur, `EOF` dosya sonunu sorar, `LOF` uzunluk verir, `SEEK` konum değiştirir, `CLOSE` kapatır.

### Kaynak notu: `pck3g.md`

```uxbasic
DIM satir AS STRING
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "uXBasic raporu"
PRINT #1, "pH=7.8"
CLOSE #1

### Kaynak notu: `pck3g.md`

OPEN "rapor.txt" FOR INPUT AS #2
WHILE NOT EOF(2)
    LINE INPUT #2, satir
    PRINT satir
WEND
CLOSE #2
```

### Kaynak notu: `pck3g.md`

```uxbasic
OPEN "log.txt" FOR APPEND AS #1
PRINT #1, TIMER(); " islem tamam"
CLOSE #1
```

### Kaynak notu: `pck3g.md`

## Nesne, namespace, module, alias, using module

### Kaynak notu: `pck3g.md`

`NAMESPACE` ad çakışmasını önler. `MODULE` bir iş ailesini toplar. `ALIAS` uzun adı kısa ada bağlar. `USING MODULE` o modülün adlarını görünür kılar. Büyük projede bunlar lüks değil, düzen şartıdır.

### Kaynak notu: `pck3g.md`

```uxbasic
NAMESPACE SuUrunleri
MODULE Yem
    FUNCTION Oran(ByVal protein AS F64, ByVal yag AS F64) AS F64
        RETURN protein / (protein + yag)
    END FUNCTION
END MODULE
END NAMESPACE

### Kaynak notu: `pck3g.md`

USING MODULE SuUrunleri.Yem
ALIAS RASYON_ORANI = Oran
PRINT RASYON_ORANI(42.0, 12.0)
```

### Kaynak notu: `pck3g.md`

Sözlük kuralı: Programın ana işini anlatan adlar uzun ve temiz olsun; sık kullanılan adlar `ALIAS` ile kısaltılsın. `x`, `y`, `z` sadece küçük matematik döngüsünde iyidir.

### Kaynak notu: `pck3g.md`

## Olay, boru, slot, iş parçacığı ve koşut çalışma

### Kaynak notu: `pck3g.md`

Olay sistemi, bir şey olduğunda başka bir işi çağırma biçimidir. `EVENT` olay adını tanımlar, `SLOT` olaya bağlanan işi tarif eder, `TRIGGER` olayı ateşler. `PIPE` iki işi birbirine veri borusuyla bağlar. `THREAD` ayrı iş parçacığı açar. `PARALEL` bağımsız işleri birlikte koşturmak için düşünülür.

### Kaynak notu: `pck3g.md`

```uxbasic
EVENT YeniOlcum
SLOT Yazdir ON YeniOlcum
    PRINT "Yeni olcum geldi"
END SLOT
TRIGGER YeniOlcum
```

### Kaynak notu: `pck3g.md`

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

### Kaynak notu: `pck3g.md`

```uxbasic
PARALEL
    CALL HesaplaOrtalama()
    CALL HesaplaSapma()
    CALL RaporHazirla()
END PARALEL
PRINT "Uc is birlikte planlandi"
```

### Kaynak notu: `pck3g.md`

Yedi katmanlı düşünme ipucu: Lexer olay adını kelime yapar; parser olay düğümünü kurar; AST olay ağacını taşır; HIR düzenler; MIR çağrıya indirir; runtime olay tablosunu yürütür; backend hedefe göre JS, WAT veya native çağrı üretir.

### Kaynak notu: `pck3g.md`

## Katmanlara yönelik yedi küçük geliştirme örneği

### Kaynak notu: `pck3g.md`

1. **Lexer örneği:** Yeni kelime eklemeden önce onun başka yerde değişken adı olarak kullanılıp kullanılmadığını test et.
2. **Parser örneği:** Her yeni komut için en küçük programı yaz: `KOMUT`, `KOMUT + IF`, `KOMUT + LOOP`, `KOMUT + FUNCTION`, `KOMUT + HATA`.
3. **AST örneği:** Düğüm adını görevine göre koy; `PRINT_STMT` komuttur, `CALL_EXPR` değer döndürebilir.
4. **HIR örneği:** Şeker sözdizimini sade forma indir. `INC A` aslında `A = A + 1` gibi düşünülür.
5. **MIR örneği:** Backendlerin ortak anlayacağı işlem üret; JS ve WAT aynı MIR bilgisinden beslenir.
6. **Runtime örneği:** Dosya, bellek, olay ve DLL çağrısı burada gerçekten çalışır; hata kodu burada netleşir.
7. **Backend örneği:** Aynı programı `--emit-js`, `--emit-wat`, `--emit-x64-nasm` ile çıkar; sonuçlar farklı dosya ama aynı niyet olmalıdır.

### Kaynak notu: `pck3n.md`

## Değişkenler, Veri Yapıları, Nesne Düzeni, Dosya, Olay ve Dış Bağlantı

### Kaynak notu: `pck3n.md`

Değişken, programın kısa süreli hafızasıdır. Bir balık tartım çizelgesinde `agirlik`, `boy`, `tankNo`, `tarih` gibi adlar değişkendir. İyi değişken adı, yorum satırı okumadan anlam verir. `x` kısa deneme için olur; gerçek programda `gunlukYemMiktari` daha iyidir.

### Kaynak notu: `pck3n.md`

```basic
DIM tankNo AS I32
DIM balikSayisi AS I32
DIM ortalamaAgirlik AS F64
DIM notlar AS STRING
```

### Kaynak notu: `pck3n.md`

Değişken sınırı tipten gelir. `U8` 0..255 tutar; tank sayısı 300 olursa taşar. `I32` çoğu günlük sayı için güvenlidir. `F64` bilimsel hesaplarda iyi başlangıçtır. `BIGF`, `BIGD`, `F80`, `F128` uzun duyarlık gereken hesaplarda dış geniş sayı kütüphaneleriyle kullanılır.

### Kaynak notu: `pck3n.md`

```basic
DIM sicaklik(7) AS F64
FOR i = 1 TO 7
    sicaklik(i) = 20.0 + i * 0.5
NEXT
PRINT sicaklik(3)
```

### Kaynak notu: `pck3n.md`

Bir boyutlu dizi defterde tek sütun gibidir. Gün gün sıcaklık, öğrenci notu, ölçüm listesi için kullanılır.

### Kaynak notu: `pck3n.md`

```basic
DIM tablo(3, 4) AS F64
FOR satir = 1 TO 3
    FOR sutun = 1 TO 4
        tablo(satir, sutun) = satir * 10 + sutun
    NEXT
NEXT
PRINT tablo(2, 3)
```

### Kaynak notu: `pck3n.md`

İki boyut tablo gibidir: satır ve sütun. Laboratuvar denemesinde satır örnek, sütun ölçüm olabilir.

### Kaynak notu: `pck3n.md`

```basic
DIM tankGunParam(4, 7, 3) AS F64
' tank, gun, parametre: 1=sicaklik 2=pH 3=oksijen
FOR tank = 1 TO 4
    FOR gun = 1 TO 7
        tankGunParam(tank, gun, 1) = 22.0
        tankGunParam(tank, gun, 2) = 7.4
        tankGunParam(tank, gun, 3) = 6.8
    NEXT
NEXT
```

### Kaynak notu: `pck3n.md`

Üç boyut kutu gibidir. Tank, gün, parametre gibi üç eksenli veriler için uygundur.

### Kaynak notu: `pck3n.md`

```basic
DIM deney(2, 4, 7, 3) AS F64
' grup, tank, gun, parametre
FOR grup = 1 TO 2
    FOR tank = 1 TO 4
        FOR gun = 1 TO 7
            deney(grup, tank, gun, 1) = 20 + grup
        NEXT
    NEXT
NEXT
```

### Kaynak notu: `pck3n.md`

Dört boyutta ilk eksen deneme grubu olabilir. Böylece kontrol ve uygulama grupları ayrı tutulur.

### Kaynak notu: `pck3n.md`

```basic
DIM buyukDeney(2, 3, 4, 7, 5) AS F64
' yil, lokasyon, tank, gun, parametre
buyukDeney(1, 2, 3, 4, 5) = 12.75
PRINT buyukDeney(1, 2, 3, 4, 5)
```

### Kaynak notu: `pck3n.md`

Beş boyut büyük bilimsel veride kullanılır. İpucu: beş boyuta çıktıysan mutlaka her eksenin anlamını yorum olarak yaz. Yoksa iki hafta sonra sen bile unutursun.

### Kaynak notu: `pck3n.md`

```basic
INCLUDE "modules/uxcollections.uxmh"
DIM liste AS PTR
liste = CALL uxcollections_list_new()
CALL uxcollections_list_push_f64(liste, 10.5)
CALL uxcollections_list_push_f64(liste, 11.0)
PRINT CALL uxcollections_list_count(liste)
CALL uxcollections_list_free(liste)
```

### Kaynak notu: `pck3n.md`

Liste sıra tutar, sözlük anlam tutar, küme tekrarları engeller. Derleyici yazarken `DICT` sembol tablosuna benzer: ad verirsin, karşılığında tip veya adres alırsın.

### Kaynak notu: `pck3n.md`

```basic
TYPE BalikOlcumu
    tank AS I32
    boy AS F64
    agirlik AS F64
END TYPE

### Kaynak notu: `pck3n.md`

DIM o AS BalikOlcumu
o.tank = 2
o.boy = 14.5
o.agirlik = 38.2
PRINT o.agirlik
```

### Kaynak notu: `pck3n.md`

`TYPE`, birden çok değeri tek ad altında toplar. CSV satırı, öğrenci, ürün, sensör kaydı için kullanılır.

### Kaynak notu: `pck3n.md`

```basic
CLASS Tank
    DIM hacimLitre AS F64
    DIM balikSayisi AS I32

### Kaynak notu: `pck3n.md`

METHOD Yogunluk() AS F64
        RETURN balikSayisi / hacimLitre
    END METHOD
END CLASS

### Kaynak notu: `pck3n.md`

DIM t AS Tank
t.hacimLitre = 1000
t.balikSayisi = 250
PRINT t.Yogunluk()
```

### Kaynak notu: `pck3n.md`

Sınıf [veri ve davranışı birleştiren yapı] (class), veriyi ve o verinin işini bir yerde tutar. `TYPE` defter satırı gibidir; `CLASS` küçük makine gibidir.

### Kaynak notu: `pck3n.md`

```basic
NAMESPACE Bilim
    MODULE Istatistik
        FUNCTION Ortalama(a AS F64, b AS F64) AS F64
            RETURN (a + b) / 2
        END FUNCTION
    END MODULE
END NAMESPACE

### Kaynak notu: `pck3n.md`

USING Bilim
ALIAS ORT = Bilim.Istatistik.Ortalama
PRINT ORT(10, 20)
```

### Kaynak notu: `pck3n.md`

`NAMESPACE` ad çakışmasını önler. `MODULE` bir işi paketler. `USING` uzun yolu kısaltır. `ALIAS` eski adla yeni adı bağlar. Büyük projelerde bu dört komut temizlik sağlar.

### Kaynak notu: `pck3n.md`

```basic
INCLUDE "core.uxmh"
INCLUDE "modules/uxstats.uxmh"
IMPORT(C, "src/native/hizli_toplam.c")
IMPORT(CPP, "src/native/grafik.cpp")
IMPORT(ASM, "src/native/kopyala.asm")
```

### Kaynak notu: `pck3n.md`

`INCLUDE` uXBasic başlık/kaynak parçası ekler. `IMPORT` derleme zamanında dış C/C++/ASM dosyasını zincire alır. DLL çağırmak için `IMPORT DLL` kullanılmaz; DLL için `DECLARE ... LIB ... ALIAS ...` veya `CALL(DLL,...)` yolu kullanılır.

### Kaynak notu: `pck3n.md`

```basic
DECLARE FUNCTION Beep LIB "kernel32.dll" ALIAS "Beep" (freq AS I32, ms AS I32) AS I32
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (hwnd AS PTR, text AS STRING, title AS STRING, flags AS I32) AS I32

### Kaynak notu: `pck3n.md`

CALL Beep(750, 300)
CALL MessageBoxA(0, "uXBasic calisiyor", "Bilgi", 0)
```

### Kaynak notu: `pck3n.md`

DLL çağırırken tip eşleşmesi hayatidir. Windows API yanlış parametreyle çağrılırsa program çökebilir. Önce küçük ve zararsız API ile dene. `Beep` iyi ilk örnektir.

### Kaynak notu: `pck3n.md`

```basic
OPEN "rapor.txt" FOR OUTPUT AS #1
PRINT #1, "Deney Raporu"
PRINT #1, "pH=7.4"
CLOSE #1

### Kaynak notu: `pck3n.md`

OPEN "rapor.txt" FOR APPEND AS #1
PRINT #1, "Yeni satir eklendi"
CLOSE #1

### Kaynak notu: `pck3n.md`

OPEN "rapor.txt" FOR INPUT AS #1
INPUT #1, satir
PRINT satir
CLOSE #1
```

### Kaynak notu: `pck3n.md`

Dosya açıldıysa kapat. Bu basit kuraldır. Dosyayı kapatmazsan veri tamponda kalabilir.

### Kaynak notu: `pck3n.md`

```basic
CALL(API, "system", "dir")
CALL(API, "system", "curl https://example.com")
```

### Kaynak notu: `pck3n.md`

Dış program çağırmak güçlüdür ama tehlikelidir. Kullanıcıdan aldığın metni doğrudan terminal komutuna ekleme. Önce izin verilen komut listesi yap.

### Kaynak notu: `pck3n.md`

```basic
EVENT OlcumGeldi(tank AS I32, deger AS F64)

### Kaynak notu: `pck3n.md`

SLOT OlcumuYaz(tank AS I32, deger AS F64)
    PRINT "Tank=" + STR(tank) + " Deger=" + STR(deger)
END SLOT

### Kaynak notu: `pck3n.md`

ON OlcumGeldi CALL OlcumuYaz
TRIGGER OlcumGeldi(3, 7.25)
```

### Kaynak notu: `pck3n.md`

```basic
PIPE HamVeri TO Temizleyici
THREAD Temizleyici()
PARALEL
    CALL SensorOku()
    CALL AnalizYap()
END PARALEL
```

### Kaynak notu: `pck3n.md`

`EVENT` haber verir. `SLOT` haberi alır. `PIPE` veri taşır. `THREAD` aynı anda iş yapar. `PARALEL` işleri bölüştürür. İpucu: paylaşılan değişkene aynı anda yazdırma; önce her iş kendi sonucunu üretsin, sonra birleştir.

### Kaynak notu: `pck4g.md`

Bu cilt bütün kütüphanelerin çalıştığını varsayar. Kural değişmez: yeni anahtar sözcük eklemek yerine `INCLUDE`, `NAMESPACE`, `MODULE`, `ALIAS`, `USING`, `DECLARE`, `CALL(DLL,...)` ve sarmalayıcı dosyaları kullanılır.

### Kaynak notu: `pck4g.md`

## 1. bigfp
`bigfp` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

### Kaynak notu: `pck4g.md`

## 2. fp128
`fp128` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### fp128 fonksiyonlarının tek tek okunuşu
- **1. `uxb_f128_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp128.uxb_f128_size(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxb_f128_storage_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp128.uxb_f128_storage_size(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_storage_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxb_f128_zero`**: Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanım kalıbı: `sonuc = fp128.uxb_f128_zero(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_zero", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxb_f128_from_str`**: Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanım kalıbı: `sonuc = fp128.uxb_f128_from_str(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxb_f128_to_str`**: Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanım kalıbı: `sonuc = fp128.uxb_f128_to_str(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxb_f128_copy`**: Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanım kalıbı: `sonuc = fp128.uxb_f128_copy(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **7. `uxb_f128_add`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_add(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_add", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **8. `uxb_f128_sub`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_sub(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_sub", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **9. `uxb_f128_mul`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_mul(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_mul", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **10. `uxb_f128_div`**: Bölme yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_div(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_div", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **11. `uxb_f128_cmp`**: İki değeri karşılaştırır. Kullanım kalıbı: `sonuc = fp128.uxb_f128_cmp(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_cmp", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
### Anlamlı örnek
```uxbasic
DIM a AS BIGF(256)
DIM b AS BIGF(256)
DIM c AS BIGF(256)
a = BIGINIT("BIGF", "1.234567890123456789", 256)
b = BIGINIT("BIGF", "9.876543210987654321", 256)
c = a + b
PRINT c
```

### Kaynak notu: `pck4g.md`

## 3. fp80
`fp80` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### fp80 fonksiyonlarının tek tek okunuşu
- **1. `uxb_f80_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp80.uxb_f80_size(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxb_f80_storage_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp80.uxb_f80_storage_size(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_storage_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxb_f80_zero`**: Sıfır değerli büyük sayı veya kayan nokta nesnesi üretir; başlangıç değeri gereken hesaplarda kullanılır. Kullanım kalıbı: `sonuc = fp80.uxb_f80_zero(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_zero", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxb_f80_from_str`**: Metin olarak verilen sayıyı veya değeri kütüphane içi biçime çevirir; hatalı metin gelirse hata kodu kontrol edilir. Kullanım kalıbı: `sonuc = fp80.uxb_f80_from_str(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxb_f80_to_str`**: Kütüphane içindeki değeri okunabilir metne çevirir; rapor, dosya ve ekrana yazma işlerinde kullanılır. Kullanım kalıbı: `sonuc = fp80.uxb_f80_to_str(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxb_f80_copy`**: Bir handle, vektör, matris, tensör veya değeri güvenli şekilde kopyalar; aynı nesneyi yanlışlıkla ezmeyi önler. Kullanım kalıbı: `sonuc = fp80.uxb_f80_copy(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **7. `uxb_f80_add`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_add(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_add", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **8. `uxb_f80_sub`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_sub(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_sub", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **9. `uxb_f80_mul`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_mul(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_mul", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **10. `uxb_f80_div`**: Bölme yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_div(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_div", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **11. `uxb_f80_cmp`**: İki değeri karşılaştırır. Kullanım kalıbı: `sonuc = fp80.uxb_f80_cmp(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_cmp", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
### Anlamlı örnek
```uxbasic
DIM a AS BIGF(256)
DIM b AS BIGF(256)
DIM c AS BIGF(256)
a = BIGINIT("BIGF", "1.234567890123456789", 256)
b = BIGINIT("BIGF", "9.876543210987654321", 256)
c = a + b
PRINT c
```

### Kaynak notu: `pck4g.md`

## 4. uxaimath
`uxaimath` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxaimath fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxaimath.uxmh"
DIM h AS U64
h = uxaimath.Create()
IF h <> 0 THEN
    PRINT "uxaimath hazir"
END IF
uxaimath.Free(h)
```

### Kaynak notu: `pck4g.md`

## 5. uxcollections
`uxcollections` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxcollections fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxcollections.uxmh"
DIM h AS U64
h = uxcollections.Create()
IF h <> 0 THEN
    PRINT "uxcollections hazir"
END IF
uxcollections.Free(h)
```

### Kaynak notu: `pck4g.md`

## 6. uxdataframe
`uxdataframe` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxdataframe fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxdataframe.uxmh"
DIM df AS U64
df = uxdataframe.LoadCSV("olcum.csv", 1)
PRINT uxdataframe.RowCount(df)
PRINT uxdataframe.ColCount(df)
summary = uxdataframe.Describe(df)
uxdataframe.Free(summary)
uxdataframe.Free(df)
```

### Kaynak notu: `pck4g.md`

## 7. uxgraph
`uxgraph` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxgraph fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxgraph.uxmh"
DIM g AS U64
g = uxgraph.Create(5, 0)
uxgraph.AddEdge(g, 0, 1)
uxgraph.AddEdge(g, 1, 2)
PRINT uxgraph.ShortestDistance(g, 0, 2)
uxgraph.Free(g)
```

### Kaynak notu: `pck4g.md`

## 8. uxllama
`uxllama` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxllama fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
DIM llm AS U64
llm = uxllama.Create()
uxllama.SetCliPath(llm, "llama-cli.exe")
uxllama.SetModelPath(llm, "models/tiny.gguf")
uxllama.SetPredict(llm, 96)
PRINT uxllama.Prompt(llm, "Bir BASIC programi yaz")
uxllama.Free(llm)
```

### Kaynak notu: `pck4g.md`

## 9. uxmath
`uxmath` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxmath fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmath.uxmh"
DIM a AS U64
DIM b AS U64
a = uxmath.Create2D(2, 2)
b = uxmath.Create2D(2, 2)
uxmath.Set2D(a, 0, 0, 1.0)
uxmath.Set2D(a, 0, 1, 2.0)
PRINT uxmath.Get2D(a, 0, 1)
uxmath.Free(a)
uxmath.Free(b)
```

### Kaynak notu: `pck4g.md`

## 10. uxmathcore
`uxmathcore` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxmathcore fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmathcore.uxmh"
DIM a AS U64
DIM b AS U64
a = uxmathcore.Create2D(2, 2)
b = uxmathcore.Create2D(2, 2)
uxmathcore.Set2D(a, 0, 0, 1.0)
uxmathcore.Set2D(a, 0, 1, 2.0)
PRINT uxmathcore.Get2D(a, 0, 1)
uxmathcore.Free(a)
uxmathcore.Free(b)
```

### Kaynak notu: `pck4g.md`

## 11. uxmatrix
`uxmatrix` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxmatrix fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxmatrix.uxmh"
DIM a AS U64
DIM b AS U64
a = uxmatrix.Create2D(2, 2)
b = uxmatrix.Create2D(2, 2)
uxmatrix.Set2D(a, 0, 0, 1.0)
uxmatrix.Set2D(a, 0, 1, 2.0)
PRINT uxmatrix.Get2D(a, 0, 1)
uxmatrix.Free(a)
uxmatrix.Free(b)
```

### Kaynak notu: `pck4g.md`

## 12. uxnn
`uxnn` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxnn fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
DIM h AS U64
h = uxnn.Create()
IF h <> 0 THEN
    PRINT "uxnn hazir"
END IF
uxnn.Free(h)
```

### Kaynak notu: `pck4g.md`

## 13. uxnn2
`uxnn2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxnn2 fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn2.uxmh"
DIM h AS U64
h = uxnn2.Create()
IF h <> 0 THEN
    PRINT "uxnn2 hazir"
END IF
uxnn2.Free(h)
```

### Kaynak notu: `pck4g.md`

## 14. uxnn3
`uxnn3` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxnn3 fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxnn3.uxmh"
DIM h AS U64
h = uxnn3.Create()
IF h <> 0 THEN
    PRINT "uxnn3 hazir"
END IF
uxnn3.Free(h)
```

### Kaynak notu: `pck4g.md`

## 15. uxonnx
`uxonnx` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxonnx fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxonnx.uxmh"
DIM s AS U64
DIM x AS U64
s = uxonnx.SessionCreate("model.onnx")
x = uxonnx.TensorCreate1D(4)
uxonnx.TensorSetF64(x, 0, 1.0)
PRINT uxonnx.Run1(s, x)
uxonnx.TensorFree(x)
uxonnx.SessionFree(s)
```

### Kaynak notu: `pck4g.md`

## 16. uxonnx2
`uxonnx2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxonnx2 fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxonnx2.uxmh"
DIM s AS U64
DIM x AS U64
s = uxonnx2.SessionCreate("model.onnx")
x = uxonnx2.TensorCreate1D(4)
uxonnx2.TensorSetF64(x, 0, 1.0)
PRINT uxonnx2.Run1(s, x)
uxonnx2.TensorFree(x)
uxonnx2.SessionFree(s)
```

### Kaynak notu: `pck4g.md`

## 17. uxstats
`uxstats` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxstats fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM v AS U64
v = uxstats.VecCreate(32)
uxstats.VecPush(v, 12.0)
uxstats.VecPush(v, 15.0)
uxstats.VecPush(v, 18.0)
PRINT uxstats.VecMean(v)
PRINT uxstats.VecStdDevSamp(v)
uxstats.VecFree(v)
```

### Kaynak notu: `pck4g.md`

## 18. uxstats2
`uxstats2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

### uxstats2 fonksiyonlarının tek tek okunuşu
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM v AS U64
v = uxstats.VecCreate(32)
uxstats.VecPush(v, 12.0)
uxstats.VecPush(v, 15.0)
uxstats.VecPush(v, 18.0)
PRINT uxstats.VecMean(v)
PRINT uxstats.VecStdDevSamp(v)
uxstats.VecFree(v)
```

### Kaynak notu: `pck4g.md`

## 19. uxtensor
`uxtensor` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

### Kaynak notu: `pck4g.md`

## Ek: Kütüphaneleri tek tek kullanma defteri

### Kaynak notu: `pck4g.md`

Bu bölüm, kütüphane adlarını sadece liste olarak değil, günlük iş yapan aletler olarak öğretir. Kural şudur: Önce `INCLUDE`, sonra uygun değişken veya handle, sonra işlev çağrısı, sonra hata kontrolü, sonra serbest bırakma. Handle döndüren her kütüphane için `Free`, `Close` veya benzeri kapatma işlevi alışkanlık olmalıdır.

### Kaynak notu: `pck4g.md`

### uxcollections — liste, kuyruk, yığın, sözlük, küme

### Kaynak notu: `pck4g.md`

`uxcollections`, dil içi `LIST`, `DICT`, `SET` ruhunu dış çalışma zamanında daha büyük veri için taşır. Yığın son giren ilk çıkar mantığıdır; kuyruk ilk giren ilk çıkar mantığıdır; çift uçlu kuyruk baştan ve sondan işlem yapar.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxcollections.uxmh"
DIM q AS U64
DIM is AS STRING
q = uxcollections.QueueCreate()
uxcollections.QueuePush q, "tokens"
uxcollections.QueuePush q, "parser"
is = uxcollections.QueuePop(q)
PRINT "Siradaki is="; is
uxcollections.QueueFree q
```

### Kaynak notu: `pck4g.md`

### uxmathcore — ham tampon ve hızlı vektör işleri

### Kaynak notu: `pck4g.md`

`uxmathcore`, sayı dizilerini güvenli handle ile taşır. Büyük veriyi her seferinde BASIC dizisiyle döndürmek yerine tampon üzerinde işlem yapmak hızlıdır.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxmathcore.uxmh"
DIM v AS U64
v = uxmathcore.BufferCreateF64(1000)
uxmathcore.BufferFillF64 v, 1.5
PRINT "Toplam="; uxmathcore.VectorSumF64(v)
uxmathcore.BufferFree v
```

### Kaynak notu: `pck4g.md`

İpucu: 10 sayı için normal dizi yeterlidir; 10 milyon sayı için tampon kütüphanesi düşünülür.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxmath.uxmh"
DIM kok AS F64
DIM alan AS F64
kok = uxmath.Sqrt(144.0)
alan = uxmath.IntegrateSimpson("sin", 0.0, 3.14159, 1000)
PRINT "kok="; kok; " alan="; alan
```

### Kaynak notu: `pck4g.md`

Beş komutlu kullanım: `INCLUDE`, `DIM`, işlev çağrısı, `IF` hata kontrolü, `PRINT` raporu.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM x(1 TO 5) AS F64
x(1)=10 : x(2)=12 : x(3)=9 : x(4)=15 : x(5)=14
PRINT "Ortalama="; uxstats.Mean(VARPTR(x(1)), 5)
PRINT "StdSapma="; uxstats.StdDev(VARPTR(x(1)), 5)
```

### Kaynak notu: `pck4g.md`

Ne zaman kullanılır? Laboratuvar ölçümü, üretim kalite kontrolü, deney karşılaştırması, finansal seri özeti.

### Kaynak notu: `pck4g.md`

`uxstats2`, Z testi, T testi, F testi, ki-kare, varyans analizi, regresyon tanı testleri gibi işler içindir.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxstats2.uxmh"
DIM z AS F64
DIM p AS F64
z = uxstats2.ZTestMean(105.0, 100.0, 15.0, 36)
p = uxstats2.NormalPValue(z)
IF p < 0.05 THEN PRINT "Fark anlamli" ELSE PRINT "Fark zayif"
```

### Kaynak notu: `pck4g.md`

```uxbasic
DIM f AS F64
f = uxstats2.FTestVariance(12.4, 8.2, 20, 20)
PRINT "F orani="; f
```

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxmatrix.uxmh"
DIM A AS U64
DIM B AS U64
DIM C AS U64
A = uxmatrix.Create(2,2)
B = uxmatrix.Create(2,2)
uxmatrix.Set A, 1,1, 2.0
uxmatrix.Set A, 1,2, 3.0
C = uxmatrix.Mul(A,B)
PRINT "Matris carpimi handle="; C
uxmatrix.Free A : uxmatrix.Free B : uxmatrix.Free C
```

### Kaynak notu: `pck4g.md`

İpucu: Matris kütüphanesinde indeks düzenini baştan öğren. Bazı sistemler 0 tabanlı, bazıları 1 tabanlıdır; kitap örnekleri okunurluk için 1 tabanlı gösterir.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxtensor.uxmh"
DIM t AS U64
t = uxtensor.Create4D(2,3,4,5)
uxtensor.SetF64 t, 1,2,3,4, 0.875
PRINT uxtensor.GetF64(t,1,2,3,4)
uxtensor.Free t
```

### Kaynak notu: `pck4g.md`

Tensör, çok boyutlu dizinin dış kütüphane tarafındaki hızlı kardeşidir. Yapay sinir ağı, görüntü, zaman serisi ve bilimsel hacim verisinde kullanılır.

### Kaynak notu: `pck4g.md`

### uxdataframe — CSV, Parquet, SQL ve tablo analizi

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxdataframe.uxmh"
DIM db AS U64
DIM df AS U64
db = uxdataframe.OpenMemory()
df = uxdataframe.LoadCsv(db, "olcum.csv")
PRINT "Satir="; uxdataframe.RowCount(df)
PRINT "Sutun="; uxdataframe.ColCount(df)
CALL uxdataframe.Describe(df, "rapor.csv")
uxdataframe.Free df
```

### Kaynak notu: `pck4g.md`

Veri çerçevesi, Excel tablosunu programla yönetmek gibidir. Filtre, sıralama, grup ortalaması ve birleştirme işlerinde kullanılır.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxgraph.uxmh"
DIM g AS U64
g = uxgraph.Create(0)
uxgraph.AddVertex g, "A"
uxgraph.AddVertex g, "B"
uxgraph.AddEdge g, "A", "B"
PRINT "Bag var="; uxgraph.HasEdge(g,"A","B")
uxgraph.Free g
```

### Kaynak notu: `pck4g.md`

Çizge; şehir yolu, atıf ağı, sosyal ağ, dosya bağımlılığı, modül ilişkisi için kullanılır.

### Kaynak notu: `pck4g.md`

### uxaimath ve uxnn — yapay zeka matematiği ve sinir ağı

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxaimath.uxmh"
DIM y AS F64
y = uxaimath.Sigmoid(0.75)
PRINT "Sigmoid="; y
```

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxnn.uxmh"
DIM net AS U64
net = uxnn.NetworkCreate()
uxnn.AddDense net, 4, 8, "relu"
uxnn.AddDense net, 8, 1, "sigmoid"
CALL uxnn.TrainCsv(net, "egitim.csv", 100)
uxnn.Save net, "model.uxn"
uxnn.Free net
```

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxonnx.uxmh"
DIM s AS U64
s = uxonnx.SessionCreate("model.onnx")
CALL uxonnx.Run(s)
PRINT uxonnx.LastError()
uxonnx.SessionFree s
```

### Kaynak notu: `pck4g.md`

ONNX kapısı, Python tarafında eğitilmiş modeli uXBasic programında kullanma yoludur.

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/modules/uxllama.uxmh"
DIM bot AS U64
DIM cevap AS STRING
bot = uxllama.Create()
uxllama.SetModelPath bot, "models/llama.gguf"
uxllama.SetThreads bot, 4
cevap = uxllama.Prompt(bot, "uXBasic nedir, tek cumle soyle")
PRINT cevap
uxllama.Free bot
```

### Kaynak notu: `pck4g.md`

İpucu: Yerel modelde hız için bağlam boyutunu ve thread sayısını makineye göre ayarla. API anahtarı gerekmez ama model dosyası gerekir.

### Kaynak notu: `pck4g.md`

### fp80, fp128 ve bigfp — hassas sayı kütüphaneleri

### Kaynak notu: `pck4g.md`

```uxbasic
INCLUDE "include/extfp.uxmh"
DIM a AS F128
DIM b AS F128
a = F128_INIT("1.25")
b = F128_INIT("2.75")
PRINT F128_ADD(a,b)
```

### Kaynak notu: `pck4g.md`

Büyük hassasiyet kütüphanelerinde metinden başlatma önemlidir. Çünkü `3.1415926535` gibi değer önce normal `F64` olarak bozulursa yüksek hassasiyete bozuk taşınır. Bu yüzden `BIGINIT("BIGF", "3.1415926535", 256)` gibi metinden başlatma güvenlidir.

### Kaynak notu: `pck4g.md`

## Kütüphane kullanırken hata yakalama düzeni

### Kaynak notu: `pck4g.md`

```uxbasic
TRY
    INCLUDE "include/modules/uxdataframe.uxmh"
    DIM df AS U64
    df = uxdataframe.LoadCsvFile("veri.csv")
    IF df = 0 THEN THROW "CSV acilamadi"
    PRINT uxdataframe.RowCount(df)
CATCH e
    PRINT "Hata="; e
FINALLY
    PRINT "Islem bitti"
END TRY
```

### Kaynak notu: `pck4g.md`

Her kütüphane örneğinde beş adımı unutma: aç, hazırla, çalıştır, kontrol et, kapat.

### Kaynak notu: `pck4n.md`

## Kütüphaneler, Fonksiyon Tabloları ve Kullanım Yolları

### Kaynak notu: `pck4n.md`

Bu ciltte her kütüphane ayrı düşünülür. Kitap varsayımı şudur: kütüphanelerin kodları tamamdır ve değişmeden çalışır. Yine de iyi kullanım için üç kural vardır: başlığı ekle, doğru tipi ver, sonucu test et.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxstats.uxmh"
DIM sonuc AS F64
sonuc = CALL uxstats_mean_f64(adres, adet)
PRINT sonuc
```

### Kaynak notu: `pck4n.md`

```basic
DECLARE FUNCTION Fonksiyon LIB "kutuphane.dll" ALIAS "gercek_ad" (...) AS tip
sonuc = CALL Fonksiyon(...)
```
## `bigfp` — Çok büyük ve yüksek duyarlıklı sayı hesapları.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/bigfp.uxmh"
DIM h AS PTR
h = CALL bigfp_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "bigfp hazir"
```

### Kaynak notu: `pck4n.md`

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/fp128.uxmh"
DIM h AS PTR
h = CALL fp128_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fp128 hazir"
```

### Kaynak notu: `pck4n.md`

## `fp80` — 80 bit geniş kayan nokta işlemleri.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/fp80.uxmh"
DIM h AS PTR
h = CALL fp80_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fp80 hazir"
```

### Kaynak notu: `pck4n.md`

Bu klasörde başlık prototipi az veya ortak dosyaya bağlıdır. Kullanım için ilgili `.uxmh` başlığı eklenir.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/fpcommon.uxmh"
DIM h AS PTR
h = CALL fpcommon_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fpcommon hazir"
```

### Kaynak notu: `pck4n.md`

## `uxaimath` — Yapay zeka matematiği, aktivasyon, kayıp ve optimizasyon.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxaimath.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxaimath_sigmoid_f64(x)
```

### Kaynak notu: `pck4n.md`

## `uxcollections` — Liste, yığın, kuyruk, sözlük, küme, ağaç.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxcollections.uxmh"
DIM l AS PTR
l = CALL uxcollections_list_new()
CALL uxcollections_list_push_f64(l, 3.14)
CALL uxcollections_list_push_f64(l, 2.72)
PRINT CALL uxcollections_list_count(l)
CALL uxcollections_list_free(l)
```

### Kaynak notu: `pck4n.md`

## `uxdataframe` — Tablo/veri çerçevesi ve SQL benzeri veri işlemleri.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxdataframe.uxmh"
PRINT "uxdataframe kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

## `uxdataset` — Veri kümesi yükleme, ayırma ve toplu işleme.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxdataset.uxmh"
PRINT "uxdataset kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

## `uxgraph` — Graf, düğüm, kenar ve yol analizi.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxgraph.uxmh"
PRINT "uxgraph kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxllama.uxmh"
DIM ctx AS PTR
ctx = CALL uxllama_open("models/llama.gguf")
PRINT CALL uxllama_prompt(ctx, "Merhaba, uXBasic nedir?")
CALL uxllama_close(ctx)
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxmath.uxmh"
PRINT "uxmath kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

## `uxmathcore` — Çekirdek matematik ve hızlı sayısal işlemler.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxmathcore.uxmh"
PRINT "uxmathcore kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxmatrix.uxmh"
DIM A AS PTR
A = CALL uxmatrix_create(3, 3)
CALL uxmatrix_set(A, 1, 1, 1.0)
PRINT CALL uxmatrix_get(A, 1, 1)
CALL uxmatrix_free(A)
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxnn.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn_sigmoid_f64(x)
```

### Kaynak notu: `pck4n.md`

## `uxnn2` — Sinir ağı ikinci seviye işlemleri.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxnn2.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn2_sigmoid_f64(x)
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxnn3.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn3_sigmoid_f64(x)
```

### Kaynak notu: `pck4n.md`

## `uxonnx` — ONNX model yükleme/çalıştırma köprüsü.

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxonnx.uxmh"
PRINT "uxonnx kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxonnx2.uxmh"
PRINT "uxonnx2 kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxstats.uxmh"
DIM v AS PTR
v = CALL uxstats_vec_create()
CALL uxstats_vec_push(v, 10)
CALL uxstats_vec_push(v, 12)
CALL uxstats_vec_push(v, 14)
PRINT CALL uxstats_vec_mean(v)
CALL uxstats_vec_free(v)
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxstats2.uxmh"
DIM z AS F64
z = CALL uxstats2_one_sample_z(105.0, 100.0, 15.0, 36)
PRINT "Z=" + STR(z)
```

### Kaynak notu: `pck4n.md`

```basic
INCLUDE "modules/uxtensor.uxmh"
DIM t AS PTR
t = CALL uxtensor_create_3d(4, 7, 3)
CALL uxtensor_set_3d(t, 1, 2, 1, 7.4)
PRINT CALL uxtensor_get_3d(t, 1, 2, 1)
CALL uxtensor_free(t)
```

### Kaynak notu: `pck5g.md`

# Tarayıcı, JS, WAT/WASM, Dış Programlar, API, Yapay Zeka ve Gerçekçi Örnekler

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

1. `lex` ile sözcükler doğru mu bak. 2. `ast` ile ağaç oluştu mu bak. 3. `sem` ile tip ve kapsam doğru mu bak. 4. `mir` ile ara komut çıktı mı bak. 5. Hedefe göre `jsw`, `wat`, `x64` veya `int` çalıştır. 6. `run_adim22_full_layer_expected_suite.ps1` gibi gate ile eksik çıktı var mı bak. 7. Placeholder yoksa ve `missing_layer_output_count=0` ise çıktı gerçek kabul edilir.
```powershell
uxb lex main.uxb --tokens-json-out out/tokens.json
uxb ast main.uxb --ast-json-out out/ast.json
uxb mir main.uxb --mir-full-json-out out/mir.json
uxb jsw main.uxb --js-out dist/web/program.js --html-out dist/web/index.html
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
```

### Kaynak notu: `pck5g.md`

## Windows DLL kullanımı: sistemle kibar konuşmak

### Kaynak notu: `pck5g.md`

DLL çağırırken önce imza bildirilir. İmza yanlışsa program çalışsa bile yanlış sonuç verebilir. `ByVal` değeri doğrudan yollar; `ByRef` adres yollar; `ALIAS` dış DLL içindeki gerçek adı bağlar.

### Kaynak notu: `pck5g.md`

```uxbasic
DECLARE FUNCTION GetTickCount64 LIB "kernel32.dll" ALIAS "GetTickCount64" () AS U64
DECLARE FUNCTION MessageBoxA LIB "user32.dll" ALIAS "MessageBoxA" (ByVal hwnd AS PTR, ByVal text AS STRING, ByVal title AS STRING, ByVal flags AS U32) AS I32
DIM t AS U64
t = GetTickCount64()
PRINT "Windows acilisindan beri ms="; t
CALL MessageBoxA(0, "uXBasic DLL cagrisi calisti", "Bilgi", 0)
```

### Kaynak notu: `pck5g.md`

Kural: Windows API öğrenirken önce zararsız çağrılarla dene: saat oku, mesaj kutusu aç, dosya var mı bak. Bellek ayırma ve pencere döngüsü gibi işler ikinci aşamadır.

### Kaynak notu: `pck5g.md`

REST, uzak programa HTTP üzerinden istek gönderme biçimidir. curl, bu isteği yapan güçlü araçtır. uXBasic bunu DLL, dış program veya HTTP sarmalayıcı ile kullanır.

### Kaynak notu: `pck5g.md`

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM url AS STRING
DIM cevap AS STRING
url = "https://api.example.com/status"
cevap = uxhttp.Get(url)
IF LEN(cevap) = 0 THEN PRINT "Bos cevap" ELSE PRINT cevap
```

### Kaynak notu: `pck5g.md`

Başlık ve anahtar gereken yerde anahtarı kaynağa yazma:

### Kaynak notu: `pck5g.md`

```uxbasic
DIM key AS STRING
DIM body AS STRING
key = ENVIRON("APP_API_KEY")
body = "{""soru"":""pH kac?""}"
PRINT uxhttp.PostJsonAuth("https://api.example.com/ask", body, key)
```

### Kaynak notu: `pck5g.md`

## Flask API ile kendi Python servisini çağırmak

### Kaynak notu: `pck5g.md`

Flask tarafı küçük bir yerel sunucu olur. uXBasic tarafı ona `GET` veya `POST` yapar. Bu yöntemle Python kütüphanesi, uXBasic programına servis gibi bağlanır.

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

```uxbasic
INCLUDE "include/modules/uxhttp.uxmh"
DIM json AS STRING
json = uxhttp.Get("http://127.0.0.1:5000/olcum")
PRINT "Flask cevabi="; json
```

### Kaynak notu: `pck5g.md`

OpenAI tarafında model çağrısı için güncel ana yollardan biri Responses API kullanmaktır. Programcı, `model` ve `input` alanlarını gönderir; cevabı JSON olarak alır. Anahtar ortam değişkeninden okunur.

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

İpucu: Yapay zeka cevabını doğrudan çalıştırma. Önce dosyaya yaz, sonra test kapısından geçir. Böylece model güzel ama hatalı kod önerirse ana projeyi bozmaz.

### Kaynak notu: `pck5g.md`

Gemini tarafında standart içerik üretimi için `generateContent` kapısı, daha ajanlı/etkileşimli işler için Interactions API ayrı bir kapı gibi düşünülür. Kararlı üretimde önce standart üretim kapısını kullanmak daha güvenlidir.

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

Yerel modelin iyi yanı: özel dosyanı internete göndermeden çalışır. Kötü yanı: model dosyası büyük olur ve bilgisayarın gücüne bağlıdır.

### Kaynak notu: `pck5g.md`

`IMPORT(C,...)`, `IMPORT(CPP,...)`, `IMPORT(ASM,...)` derleme zamanında kaynak ekleme fikridir. DLL/API çağrısından farklıdır; burada amaç yerel kodu programa katmaktır.

### Kaynak notu: `pck5g.md`

```uxbasic
IMPORT(C, "native/hizli_toplam.c")
DECLARE FUNCTION hizli_toplam LIB "native.dll" ALIAS "hizli_toplam" (ByVal p AS PTR, ByVal n AS I32) AS F64
DIM a(0 TO 4) AS F64
a(0)=1 : a(1)=2 : a(2)=3 : a(3)=4 : a(4)=5
PRINT hizli_toplam(VARPTR(a(0)), 5)
```

### Kaynak notu: `pck5g.md`

```uxbasic
IMPORT(CPP, "native/filtre.cpp")
IMPORT(ASM, "native/memfill_fast.asm")
PRINT "Yerel C, C++ ve ASM kaynaklari derlemeye eklendi"
```

### Kaynak notu: `pck5g.md`

Aşağıdaki örnek JS çıktısından yararlanır; uXBasic hedefi belirler, HTML ve JS varlığını üretir, programcı tarayıcıda küçük ölçüm paneli görür.

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

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

### Kaynak notu: `pck5g.md`

İpucu: WAT tarafında çok küçük ve sık çalışan matematik çekirdekleri iyi adaydır. Dosya okuma, JSON işleme, kullanıcı arayüzü gibi işler JS veya runtime tarafında daha rahattır.

### Kaynak notu: `pck5g.md`

Program yazmak sadece kod yazmak değildir. Derleme ve test zinciri de programın parçasıdır. uXBasic tarafında beklenen dosya çıktıları üretilmeli; test runner dosya uydurmamalıdır.

### Kaynak notu: `pck5g.md`

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim22_full_layer_expected_suite.ps1 -NoRepair
powershell -NoProfile -ExecutionPolicy Bypass -File uxb/compiler/scripts/run_adim28_build_test_pipeline.ps1 -NoRepair
```

### Kaynak notu: `pck5g.md`

```uxbasic
ASSERT 2 + 2 = 4
ASSERT LEN("uxb") = 3
PRINT "Temel testler gecti"
```

### Kaynak notu: `pck5g.md`

Büyük örneği tek dosyada şişirmek yerine beş modüle böl:

### Kaynak notu: `pck5g.md`

```text
app.uxb              ana program
include/config.uxbh  sabitler ve ön-işleyici ayarları
modules/data.uxb     CSV/DF okuma
modules/analysis.uxb istatistik ve matris hesabı
modules/ui.uxb       terminal veya browser çıktı
```

### Kaynak notu: `pck5g.md`

```uxbasic
INCLUDE "include/config.uxbh"
INCLUDE "modules/data.uxb"
INCLUDE "modules/analysis.uxb"
INCLUDE "modules/ui.uxb"
CALL LoadData("olcum.csv")
CALL RunStats()
CALL ShowReport()
```

### Kaynak notu: `pck5g.md`

Bu düzen genç programcıya üç şey kazandırır: hata nerede anlaşılır, dosyalar büyüyünce korkutmaz, aynı modül başka projede tekrar kullanılır.

### Kaynak notu: `pck5g.md`

1. Önce dosya üret, sonra ekrana bas. Ekran kaybolur, dosya kalır.
2. Hataları `LIST` içine topla; ilk hatada kaçma, raporla.
3. Ayarları `DICT` ile taşı; yüz tane global değişken açma.
4. Yavaş fonksiyonu `TIMER` ile ölç; hisse göre değil süreye göre karar ver.
5. Aynı işi iki backendde dene: JS ve WAT aynı sonucu veriyorsa MIR hattın sağlamlaşır.
6. DLL çağrısına önce küçük değer ver; gerçek veriyi sonra bağla.
7. Yapay zekadan gelen kodu `sandbox` klasöründe test et; ana kaynak ağacına doğrudan yazma.

### Kaynak notu: `pck5n.md`

## Tarayıcı, WAT/WASM, REST, Flask, Yapay Zeka, Bilimsel Analiz ve Derleyici Hileleri

### Kaynak notu: `pck5n.md`

uXBasic JS çıktısı `program.js` üretir. Tarayıcı tarafında `ux_runtime.js`, `ux_canvas2d.js`, `ux_audio.js`, `ux_file.js`, `ux_ai_bridge.js`, `ux_wasm_bridge.js` gibi çalışma zamanı dosyaları kullanılır.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    PRINT "Tarayicidan merhaba"
    CALL(JS, "ux.canvas.clear", 0)
    CALL(JS, "ux.canvas.text", 20, 40, "uXBasic JS cikti")
END MAIN
```

### Kaynak notu: `pck5n.md`

```text
dist/web/program.js
index.html
runtime/browser/ux_runtime.js
```

### Kaynak notu: `pck5n.md`

İpucu: Tarayıcıda dosya yolu Windows gibi `dist\web\program.js` değil, çoğu zaman `dist/web/program.js` olarak daha güvenlidir.

### Kaynak notu: `pck5n.md`

WAT [WebAssembly metin biçimi] (WebAssembly Text) hızlı tarayıcı çalışması için ara çıktıdır.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    DIM a AS I32
    DIM b AS I32
    a = 40
    b = 2
    PRINT a + b
END MAIN
```

### Kaynak notu: `pck5n.md`

```powershell
uxb wat hizli.uxb --emit-wat --json-out out/wat_report.json
```

### Kaynak notu: `pck5n.md`

WAT çıktısı üretildiğinde ayrıca doğrulayıcıyla dene. Çünkü WAT söz dizimi küçük hatada bile yüklenmez.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    CALL(JS, "ux.canvas.init", "ekran", 800, 600)
    CALL(JS, "ux.canvas.rect", 10, 10, 200, 80)
    CALL(JS, "ux.canvas.text", 20, 50, "Tank 1")
    CALL(JS, "ux.audio.beep", 440, 200)
END MAIN
```

### Kaynak notu: `pck5n.md`

Bu örnek grafik, yazı ve sesi aynı anda gösterir. Gerçek oyun yazarken her karede tüm ekranı silmek yerine değişen bölgeyi çizmek daha hızlıdır.

### Kaynak notu: `pck5n.md`

REST API [web üzerinden veri alışverişi düzeni] (REST API) için en basit yol dış `curl` çağrısıdır.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    DIM komut AS STRING
    komut = "curl -s https://api.github.com"
    CALL(API, "system", komut)
END MAIN
```

### Kaynak notu: `pck5n.md`

Güvenlik ipucu: Kullanıcıdan gelen metni komuta doğrudan ekleme. Şöyle yapma:

### Kaynak notu: `pck5n.md`

```basic
' Tehlikeli
INPUT url
CALL(API, "system", "curl " + url)
```

### Kaynak notu: `pck5n.md`

Flask [Python ile küçük web sunucusu kurma aracı] (Flask) tarafı örnek:

### Kaynak notu: `pck5n.md`

```python
from flask import Flask, request, jsonify
app = Flask(__name__)

### Kaynak notu: `pck5n.md`

@app.post('/topla')
def topla():
    data = request.json
    return jsonify({'sonuc': data['a'] + data['b']})

### Kaynak notu: `pck5n.md`

```basic
MAIN
    CALL(API, "system", "curl -s -X POST http://127.0.0.1:5050/topla -H "Content-Type: application/json" -d "{\"a\":3,\"b\":4}"")
END MAIN
```

### Kaynak notu: `pck5n.md`

Bu yöntemle uXBasic dış dünyaya açılır. Ağ hatası, sunucu kapalı, JSON bozuk gibi durumları ayrı test et.

### Kaynak notu: `pck5n.md`

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

### Kaynak notu: `pck5n.md`

Yerel modelde hız ekran kartı, bellek ve model boyutuna bağlıdır. Büyük model daha iyi cevap verebilir ama daha yavaş çalışır.

### Kaynak notu: `pck5n.md`

OpenAI tarafında güncel metin üretim hattı Responses API üzerinden kurulabilir; resmi API başvurusunda `responses.create` uç noktası ve `model`, `input` gibi alanlar gösterilir. API anahtarını kaynak kodun içine yazma; ortam değişkeninden oku.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    DIM soru AS STRING
    soru = "uXBasic icin kisa bir ornek ver"
    CALL(API, "system", "curl https://api.openai.com/v1/responses -H "Authorization: Bearer %OPENAI_API_KEY%" -H "Content-Type: application/json" -d "{\"model\":\"gpt-5.2\",\"input\":\"" + soru + "\"}"")
END MAIN
```

### Kaynak notu: `pck5n.md`

Üretim ortamında `system` yerine özel HTTP kütüphanesi veya güvenli küçük bir aracı program kullan. Böylece anahtar günlük dosyasına düşmez.

### Kaynak notu: `pck5n.md`

Google Gemini için kararlı üretim kullanımında `generateContent` API desteklenir; yeni Interactions API çok adımlı araç kullanımı ve ajan iş akışları için önerilir ama beta olduğu için kırılma riski taşır.

### Kaynak notu: `pck5n.md`

```basic
MAIN
    DIM soru AS STRING
    soru = "uXBasic ile dizi ornegi ver"
    CALL(API, "system", "curl -s https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=%GEMINI_API_KEY% -H "Content-Type: application/json" -d "{\"contents\":[{\"parts\":[{\"text\":\"" + soru + "\"}]}]}"")
END MAIN
```

### Kaynak notu: `pck5n.md`

## Bilimsel veri: belge yazma, okuma ve analiz

### Kaynak notu: `pck5n.md`

MAIN
    DIM v AS PTR
    v = CALL uxstats_vec_create()
    CALL uxstats_vec_push(v, 10.2)
    CALL uxstats_vec_push(v, 11.4)
    CALL uxstats_vec_push(v, 9.8)
    CALL uxstats_vec_push(v, 12.1)

### Kaynak notu: `pck5n.md`

OPEN "analiz_raporu.txt" FOR OUTPUT AS #1
    PRINT #1, "Ortalama=" + STR(CALL uxstats_vec_mean(v))
    PRINT #1, "StdSapma=" + STR(CALL uxstats_vec_stddev(v))
    CLOSE #1

### Kaynak notu: `pck5n.md`

Z testi, örnek ortalamasını bilinen toplum ortalamasıyla karşılaştırmak için kullanılır. Toplum standart sapması biliniyorsa daha uygundur.

### Kaynak notu: `pck5n.md`

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

### Kaynak notu: `pck5n.md`

F testi iki varyansı karşılaştırır. Örneğin iki tank grubunda ağırlık değişkenliği farklı mı diye bakılır.

### Kaynak notu: `pck5n.md`

MAIN
    DIM f AS F64
    f = CALL uxstats2_f_variance(12.5, 20, 8.1, 18)
    PRINT "F=" + STR(f)
END MAIN
```

### Kaynak notu: `pck5n.md`

ANOVA [varyans çözümlemesi] (ANOVA) üç veya daha fazla grubun ortalamasını karşılaştırmak için kullanılır.

### Kaynak notu: `pck5n.md`

MAIN
    DIM sonuc AS PTR
    sonuc = CALL uxstats2_anova_oneway("gruplar.csv")
    PRINT CALL uxstats2_anova_summary(sonuc)
END MAIN
```

### Kaynak notu: `pck5n.md`

MAIN
    DIM df AS PTR
    df = CALL uxdataframe_load_csv("olcum.csv")
    PRINT CALL uxdataframe_row_count(df)
    PRINT CALL uxdataframe_col_count(df)
    CALL uxdataframe_describe(df, "rapor.csv")
    CALL uxdataframe_free(df)
END MAIN
```

### Kaynak notu: `pck5n.md`

1. **Her aşamada çıktı üret:** `tokens.json`, `ast.json`, `mir.json` yoksa nerede bozulduğunu bulamazsın.
2. **Placeholder üretme:** Eksik dosyayı uydurmak test değil, kandırmacadır.
3. **Kaynak konumu sakla:** Her AST düğümü satır/sütun bilsin.
4. **Sözleşme dosyası kullan:** Hangi komut hangi çıktıyı üretmeli, CSV/JSON ile yaz.
5. **Fail-close kullan:** Önemli kapı açıkça istenirse eksikte geçmesin.
6. **Sarmalayıcıyı ince tut:** DLL/API karmaşasını dil çekirdeğine doldurma; `DECLARE`, `CALL`, `ALIAS`, `MODULE` ile bağla.
7. **Kanca [araya giren ek nokta] (hook) az olsun:** Her yere hook koyarsan sistem izlenmez olur. Kanca yalnız ölçüm, rapor veya özel hedef gerektiğinde kullanılır.
8. **Büyük işi küçük kapılara böl:** ADIM22 çıktı sözleşmesi, ADIM25 AST/MIR, ADIM26 JS/WASM, ADIM27 CLI/backend gibi.

### Kaynak notu: `pck5n.md`

## Gerçekçi büyük örnek: tarayıcıda analiz ve yapay zeka

### Kaynak notu: `pck5n.md`

```basic
INCLUDE "modules/uxstats.uxmh"
INCLUDE "modules/uxllama.uxmh"

### Kaynak notu: `pck5n.md`

MAIN
    DIM v AS PTR
    DIM ort AS F64
    DIM model AS PTR
    DIM yorum AS STRING

### Kaynak notu: `pck5n.md`

v = CALL uxstats_vec_create()
    CALL uxstats_vec_push(v, 7.1)
    CALL uxstats_vec_push(v, 7.4)
    CALL uxstats_vec_push(v, 7.2)
    ort = CALL uxstats_vec_mean(v)

### Kaynak notu: `pck5n.md`

CALL(JS, "ux.canvas.init", "ekran", 640, 480)
    CALL(JS, "ux.canvas.text", 20, 40, "pH ortalamasi=" + STR(ort))

### Kaynak notu: `pck5n.md`

model = CALL uxllama_open("models/llama.gguf")
    IF model <> 0 THEN
        yorum = CALL uxllama_prompt(model, "pH ortalamasi " + STR(ort) + " olan bir tanki yorumla")
        PRINT yorum
        CALL uxllama_close(model)
    END IF

### Kaynak notu: `pck5n.md`

Bu örnek birçok katmanı birleştirir: kütüphane ekleme, vektör oluşturma, istatistik hesaplama, tarayıcıya yazı basma, yerel yapay zekaya yorumlatma, kaynak bırakma. İyi programcı böyle örnekleri parça parça kurar. Önce yalnız vektörü dene. Sonra istatistiği ekle. Sonra tarayıcıyı ekle. En son yapay zekayı bağla.

### Kaynak notu: `pck5n.md`

1. Kullanım hakkı ve sorumluluk sınırı  
2. Ön söz  
3. Genç programcıya öğütler  
4. uXBasic dosyaları  
5. Mimari katmanlar  
6. Komut satırı ve çıktı dosyaları  
7. Hata kodları  
8. İlk program

### Kaynak notu: `pck5n.md`

1. Anahtar kelime tablosu  
2. Parser komutları  
3. Her komutun görevi, söz dizimi ve örneği  
4. Ön-işleyici komutları  
5. Veri tipleri  
6. İşleçler  
7. Yerel fonksiyonlar

### Kaynak notu: `pck5n.md`

1. Değişkenler  
2. Çok boyutlu diziler  
3. ARRAY/LIST/DICT/SET  
4. TYPE ve CLASS  
5. NAMESPACE/MODULE/USING/ALIAS  
6. INCLUDE/IMPORT  
7. DLL ve Windows API  
8. Dosya, terminal, olay, thread, pipe, slot

### Kaynak notu: `pck5n.md`

1. Runtime genişletme kütüphaneleri  
2. Her kütüphanenin görev tablosu  
3. Fonksiyon prototipleri  
4. Küçük kullanım örnekleri  
5. Hata yakalama alışkanlığı

### Kaynak notu: `pck5n.md`

1. JS tarayıcı çıktısı  
2. WAT/WASM çıktısı  
3. Canvas/ses/girdi  
4. REST/curl/Flask  
5. Llama, OpenAI, Gemini  
6. Bilimsel analiz  
7. Derleyici hileleri  
8. Büyük birleşik örnek


# Son İçindekiler

- Ön söz, lisans ve sorumluluk
- uXBasic kaynak ağacından gelen kararlar
- Bölüm 1: Başlangıç, dosyalar, mimari, çıktılar ve genç programcıya öğütler
- Bölüm 2: Anahtar sözcükler, komut sınıfları, ön-işleyici, veri tipleri, işleçler, yerel fonksiyonlar
- Bölüm 3: Değişkenler, diziler, LIST, DICT, SET, nesne, hook, wrapper, EVENT, PIPE, THREAD, PARALEL ve SLOT
- Bölüm 4: bigfp, fp128, fp80, uxaimath, uxcollections, uxdataframe, uxgraph, uxllama, uxmath, uxmathcore, uxmatrix, uxnn, uxnn2, uxnn3, uxonnx, uxonnx2, uxstats, uxstats2 ve uxtensor
- Bölüm 5: JavaScript çıktısı, WAT/WASM çıktısı, REST, curl, Flask, yerel Llama, ChatGPT, Gemini, bilimsel testler ve 5 modüllü örnek proje
- Bölüm 6: Kaynaklardan eritilen ek notlar

# Son söz

uXBasic öğrenirken hedefin yalnız komut yazmak olmasın. Hedefin, bir fikri önce metne, sonra komuta, sonra ara gösterime, sonra çalışır çıktıya dönüştürmeyi öğrenmek olsun. Bir dosyayı okuyan, ölçümü kontrol eden, tablo kuran, hata yakalayan, tarayıcıda çalışan ve dış kütüphaneyle konuşan program yazabiliyorsan artık yalnız dil öğrenmiyorsun; sistem kurmayı öğreniyorsun.