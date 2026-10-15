# Project Pack Örnek Kütüphanesi

uXBasic kitabının örnekleri boşlukta yazılmaz. Ana örnek havuzu `xtestx/project_packs` dizinidir. Bu dizindeki her pack, dilin bir ailesini temsil eder. Kitapta komut anlatılırken önce bu packlerdeki çalışan örnekler aranır; gerekirse örnek geliştirilir ama kaynak sözdizimiyle uyum korunur.

Project pack sistemi kitabın güvenilirliğini artırır. Çünkü okuyucu yalnız anlatı görmez; o anlatının test ailesindeki karşılığını da görür. `pack_01` temel sayısal akışı, `pack_02` operatörleri, `pack_05` akış kontrolünü, `pack_25` iç içe fonksiyon çağrılarını, `pack_30` ise tam entegrasyon fikrini gösterir.

Aşağıdaki tablo, kitapta kullanılacak ana omurgayı gösterir.

| Pack | Kitapta Kullanıldığı Yer | Görev |
|---|---|---|
| `pack_01_core_numeric_flow` | İlk programlar, `DIM`, `AS`, atama, `PRINT` | Çekirdek sayısal akış kurar. |
| `pack_02_operators_logic_bit` | Operatör bölümü | Aritmetik, mantıksal ve bit düzeyi işlemleri gösterir. |
| `pack_03_strings_builtins` | String fonksiyonları | `LEN`, `MID`, `UCASE`, `LCASE`, `STR`, `VAL` gibi fonksiyon ailesini besler. |
| `pack_04_arrays_index_lvalue` | Dizi ve indeksleme | Dizi elemanına yazma, okuma ve lvalue davranışını gösterir. |
| `pack_05_control_flow_if_for` | `IF`, `FOR`, döngü ve karar | Koşul ve tekrar yapılarını birleştirir. |
| `pack_06_functions_recursion_include` | Fonksiyon, rekürsiyon, include | Fonksiyon çağrısı ve kendini çağırma mantığını gösterir. |
| `pack_07_type_record_structures` | `TYPE` ve kayıt | Alan erişimi ve kayıt tipi fikrini anlatır. |
| `pack_08_namespace_using_alias` | Namespace ve alias | İsim alanı, kısa ad ve kullanım rotasını gösterir. |
| `pack_09_class_oop_magic` | `CLASS`, `MAGIC`, OOP | Nesne yüzeyi ve özel davranış sözleşmesini gösterir. |
| `pack_10_file_io_channels` | Dosya işlemleri | `OPEN`, `PRINT #`, `INPUT #`, `CLOSE` ailesini anlatır. |
| `pack_11_preprocessor_meta` | Preprocessor temel | Meta değişken, koşul ve çıktı fikrini besler. |
| `pack_12_preprocessor_include_foreach` | Include ve foreach | Preprocess döngüsü ve başlık ekleme fikrini gösterir. |
| `pack_13_import_c_cpp_asm` | `IMPORT(C/CPP/ASM)` | Derleme zamanı dış kaynak ekleme kararını gösterir. |
| `pack_14_ffi_winapi_routes` | FFI, DLL, WinAPI | `DECLARE LIB ALIAS` ve dış çağrı rotasını anlatır. |
| `pack_15_science_external_routes` | Bilimsel dış rota | JSON, regex, REST, hesap kütüphanesi gibi dış bağlantı fikrini besler. |
| `pack_16_big_extfp_canonical` | Büyük sayı | `BIGI`, `BIGINT`, `BIGD`, `BIGF`, `BALL`, `BIGINIT` ailesini gösterir. |
| `pack_17_memory_ptr_intrinsics` | Bellek ve pointer | `PEEK`, `POKE`, `PTR`, `SIZEOF` gibi düşük seviye yüzeyi gösterir. |
| `pack_18_event_thread_pipe_slot` | Modern akış | `EVENT`, `THREAD`, `PIPE`, `SLOT`, `PARALEL` ailesini gösterir. |
| `pack_19_browser_wasm_webgpu_route` | Web ve WASM | Browser, JS/WAT/WASM hedef rotasını gösterir. |
| `pack_20_module_main_using` | Module ve main | Modül, giriş noktası ve using mantığını gösterir. |
| `pack_21_input_line_file` | Dosya okuma | Satır ve dosya girdi ailesini gösterir. |
| `pack_22_error_try_catch_surface` | Hata yakalama | `TRY`, `CATCH`, `FINALLY`, `THROW`, `ASSERT` yüzeyini gösterir. |
| `pack_23_data_structures_list_dict_set` | Koleksiyonlar | `ARRAY`, `LIST`, `DICT`, `SET` veri yapısı yüzeyini gösterir. |
| `pack_24_math_time_random_surface` | Matematik ve zaman | `ABS`, `INT`, `SGN`, `SQR`, `RND`, `TIMER` ailesini gösterir. |
| `pack_25_nested_calls_expressions` | İç içe çağrı | Fonksiyon çağrılarının ifade ağacı içinde birleşmesini gösterir. |
| `pack_26_negative_raw_js_gate` | Güvenlik kapısı | Hedefsiz raw JS kullanımının kapatılmasını gösterir. |
| `pack_27_negative_include_cycle` | Include güvenliği | Döngüsel include durumunun yakalanmasını gösterir. |
| `pack_28_negative_semantic_unknown_symbol` | Semantic denetim | Bilinmeyen sembolün yakalanmasını gösterir. |
| `pack_29_negative_wrong_keywords` | Kanonik keyword | Yanlış keywordlerin reddedilmesini gösterir. |
| `pack_30_full_integration_project` | Tam entegrasyon | Birçok dil ailesini tek kaynakta birleştirir. |

Kitapta her örnek şu üç soruyu cevaplamalıdır:

```text
Bu örnek hangi komutu öğretiyor?
Bu örnek hangi önceki bilgiyi kullanıyor?
Bu örnek okuyucuyu hangi sonraki konuya hazırlıyor?
```

Örneğin `pack_01` yalnız `PRINT` örneği değildir. `DIM`, `AS`, atama, aritmetik ifade ve çıktı gözlemini aynı anda gösterir. Bu nedenle ilk bölümde kullanılır. `pack_25` ise fonksiyonlar bölümünün ileri kısmında kullanılır; çünkü iç içe çağrı, önce fonksiyon ve ifade mantığı öğrenilmeden verilirse okuyucuyu yorar.

Kitap örnekleri gerektiğinde testten daha açıklayıcı hâle getirilir. Fakat bu geliştirme kaynak sözleşmesini bozmaz. Testteki örnek kısa olabilir; kitapta aynı örnek açıklama değişkenleriyle genişletilebilir. Önemli olan syntaxın uXBasic kaynak gerçekliğiyle uyumlu kalmasıdır.

Örnek geliştirme ilkesi:

```basic
DIM a AS I32 = 10
DIM b AS I32 = 20
PRINT a + b
```

Bu test örneği kitapta şöyle büyütülebilir:

```basic
DIM yem AS I32 = 120
DIM balik AS I32 = 40
DIM oran AS I32

oran = yem / balik
PRINT oran
```

Beklenen çıktı:

```text
3
```

Burada komutlar değişmez; yalnız örnek okuyucunun zihninde daha canlı bir probleme bağlanır.
