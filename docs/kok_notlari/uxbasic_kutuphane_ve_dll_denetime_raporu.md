# uXBasic 02.07 Kütüphane ve Runtime DLL Denetim Raporu

## 1. Denetim kapsamı

Bu rapor `uxb(02.07).zip` arşivindeki compiler çalıştırılabilirlerini, `include/modules`, `libsx`, `runtime_ext`, `src/runtime/native`, build betiklerini, dependency fetch/copy betiklerini ve DLL doctor araçlarını statik olarak karşılaştırır. Arşivde derlenmiş runtime DLL bulunmadığı için gerçek DLL import/export tablosu ve Windows üzerinde yükleme testi yapılamadı; bu noktalar build sonrasında yeniden doğrulanmalıdır.

## 2. Kesin sonuçlar

1. Arşivde `.dll`, `.lib` veya `.a` runtime ürünü yoktur. `dist/runtime_ext` kaynak ve betiklere rağmen boş durumdadır.
2. `bin/uxb.exe` ve `compiler/wrappers/uxb_main_wrapper_64.exe` gerçekte **PE32 Intel i386** dosyalarıdır. `uxb_main_wrapper_64.tmp.exe` ise **PE32+ x86-64** dosyasıdır.
3. Runtime extension build betikleri MSYS2 **UCRT64** GCC kullanır. Bu nedenle mevcut 32-bit interpreter EXE, üretilmesi hedeflenen 64-bit DLL'leri `LoadLibrary` ile yükleyemez.
4. `build_uxb_main_64.bat`, eski çıktı varsa varsayılan olarak derlemeyi atlar. Bu mekanizma 32-bit fakat adı `_64.exe` olan eski dosyanın kalmasına yol açmıştır.
5. `include/modules/*.uxmh` dosyalarının tamamı açıklama ve include guard'dan ibarettir; FUNCTION/SUB/DECLARE veya wrapper include etmez. Ayrıca yorumlarda `libs/...` yazarken gerçek wrapperlar `libsx/...` altındadır.
6. Eski wrapperların büyük bölümü compilerın zorunlu FFI sözleşmesine uymaz: kitaplık adı string literal değildir ve dönüş/imza belirteci yoktur.
7. EVENT/THREAD/PIPE/PARALEL için gerekli `uxb_runtime.dll` gerçek kaynağı ve ikilisi arşivde yoktur. Loader sembol çözer, bridge ise çözülen function pointerları çağırmadan başarı/fallback döndürür.
8. `uxb_bigfp.dll` build betiği yalnız MPFR dosyasını derler; arşivdeki BIGI/GMP ve `__uxb_rt_biginit` bridge kaynakları build'e katılmaz.
9. `uxmatrix` wrapperı `uxmatrix_solve_new`, `uxmatrix_inverse_new`, `uxmatrix_cholesky_new` sembollerini ister; bunlar header'da ilan edilmiş olsa da C uygulamasında bulunmaz.
10. `uxmath` wrapperı `uxmath.dll` yerine `uxmathcore.dll` çağırır; iki DLL'in sorumluluğu çakışmaktadır.

## 3. Compiler ve DLL mimarisi

| Dosya | Gerçek format | Sonuç |
| --- | --- | --- |
| bin/uxb.exe | PE32 / Intel i386 | 32-bit AST/MIR interpreter process |
| compiler/wrappers/uxb_main_wrapper_64.exe | PE32 / Intel i386 | Adı 64 olsa da 32-bit |
| compiler/wrappers/uxb_main_wrapper_64.tmp.exe | PE32+ / x86-64 | Gerçek 64-bit geçici ürün |
| runtime_ext build hedefleri | MSYS2 UCRT64 | Üretilecek DLL'ler 64-bit |

Windows kuralı kesindir: 32-bit bir süreç 64-bit DLL yükleyemez; 64-bit süreç de 32-bit DLL yükleyemez. Bu nedenle kütüphane testinden önce gerçek x64 compiler wrapper yeniden oluşturulmalıdır:

```bat
set UXB_FORCE_REBUILD=1
call uxb\compiler\scripts\build_uxb_main_64.bat force
```

Sonra PowerShell ile PE makinesi doğrulanmalıdır:

```powershell
dumpbin /headers uxb\compiler\wrappers\uxb_main_wrapper_64.exe | Select-String machine
```

## 4. Gerçek CALL(DLL) sözleşmesi

Parser `CALL(DLL, ...)` için en az şu yapıyı zorunlu tutar:

```uxbasic
sonuc = CALL(DLL, "kitaplik.dll", "sembol", I32, CDECL, argumanlar...)
```

Kitaplık ve sembol string literal olmalıdır. Geçerli dönüş/imza anahtarları: `VOID`, `I32`, `U64`, `F64`, `PTR`, `STRPTR`, `BYREF`, `BYVAL`; çağrı kuralları `CDECL` ve `STDCALL`dır. `I64` genel dil tipi olmasına rağmen bu CALL(DLL) semantic/MIR sözleşmesinde geçerli imza değildir.

### Çalışan biçime yakın örnekler

```uxbasic
DIM surum AS I32
surum = CALL(DLL, "uxmathcore.dll", "uxmath_version", I32, CDECL)

DIM rc AS I32
rc = CALL(DLL, "kernel32.dll", "Beep", I32, STDCALL, 880, 150)
```

Karma argüman tipleri string listesiyle verilebilir; fakat MIR kodu bu listeyi yalnız içinde virgül varsa tanır. Bu nedenle tek elemanlı `"PTR"` veya `"I32"` type-list bugün güvenilir değildir. Tek argümanlı farklı tipte dış fonksiyonlar için `DECLARE FUNCTION ... LIB ... ALIAS ...` biçimi daha güvenli bir geçici yoldur.

```uxbasic
DECLARE FUNCTION VecCount CDECL LIB "uxmathcore.dll" ALIAS "uxmath_vec_count" (BYVAL h AS PTR) AS I32
```

AST runtime FFI çağrıları en fazla dört argümanlıdır. MIR evaluator saf integer/pointer çağrılarda sekize kadar yol içerir; x64 mixed-F64 çağrılarda sınır dört argümandır. Bu nedenle wrapperlar backend bazında ayrıca test edilmelidir.

## 5. Wrapper denetimi

| Wrapper | CALL(DLL) sayısı | Biçim | Sonuç |
| --- | --- | --- | --- |
| uxaimath | 46 | Eski | DLL sabiti + imza yok |
| uxcollections | 27 | Eski | DLL sabiti + imza yok |
| uxdataframe | 31 | Eski | DLL sabiti + imza yok |
| uxdataset | 34 | Eski | DLL sabiti + imza yok |
| uxgraph | 30 | Eski | DLL sabiti + imza yok |
| uxllama | 17 | Eski | DLL sabiti + imza yok |
| uxllamax | 0 | Placeholder | Gerçek wrapper yok |
| uxmath | 9 | Yeniye yakın | uxmathcore.dll çağırıyor; tek tip-listesi sorunu |
| uxmathcore | 41 | Yeniye yakın | I64 imzaları ve tek tip-listesi sorunu |
| uxmatrix | 34 | Eski | Ayrıca üç wrapper sembolü C'de uygulanmamış |
| uxnn | 33 | Eski | DLL sabiti + imza yok |
| uxnn2 | 23 | Eski | DLL sabiti + imza yok |
| uxnn3 | 33 | Eski | DLL sabiti + imza yok |
| uxonnx | 21 | Eski | DLL sabiti + imza yok |
| uxonnx2 | 42 | Eski | DLL sabiti + imza yok |
| uxstats | 28 | Karışık | 27 yeniye yakın, 1 eski çağrı |
| uxstats2 | 56 | Yeniye yakın | Arity ve mixed F64 sınırları test edilmeli |
| uxtensor | 38 | Eski | DLL sabiti + imza yok |

Eski biçime örnek:

```uxbasic
RETURN CALL(DLL, UXTENSOR_DLL, "uxtensor_create2d_f64", rows, cols)
```

Kaynak sözleşmesine uygun hedef biçim şuna benzemelidir:

```uxbasic
RETURN CALL(DLL, "uxtensor.dll", "uxtensor_create2d_f64", PTR, CDECL, "I32,I32", rows, cols)
```

Bu yalnız sözdizimi düzeltmesidir. DLL exportunun varlığı, pointer genişliği, return ABI ve AST/MIR/x64 sonuçları ayrıca doğrulanmalıdır.

## 6. DLL ve bağımlılık matrisi

| DLL | Amaç | Harici bağımlılık | Arşiv durumu | Wrapper/bağlama durumu | Öncelik |
| --- | --- | --- | --- | --- | --- |
| uxb_runtime.dll | EVENT/THREAD/PIPE/PARALEL/SLOT/SHELL native runtime | Planlanan backend'e bağlı; önceki tasarımda oneTBB/Win32 adaydı | DLL yok, gerçek backend yok | Bridge fonksiyonları çoğunlukla stub/fallback | P0 |
| uxb_fp80.dll | F80 | libquadmath; muhtemel GCC runtime | Kaynak/betik var, DLL yok | Compiler extfp runtime yolu | P1 |
| uxb_fp128.dll | F128 | libquadmath; muhtemel GCC runtime | Kaynak/betik var, DLL yok | Compiler extfp runtime yolu | P1 |
| uxb_bigfp.dll | BIGF/BIGD/BALL; planlanan BIGI | MPFR, GMP ve GCC runtime | DLL yok | Build yalnız uxb_bigfp_mpfr.c dosyasını derliyor | P0 |
| uxmathcore.dll | Vektör/matematik çekirdeği | libm; GCC runtime imports build sonrası belirlenir | Kaynak/betik var, DLL yok | Yeni CALL(DLL) biçimine yakın; tek tip-listesi ve I64 sorunları var | P0 |
| uxmath.dll | Matematik | libm | Kaynak/betik var, DLL yok | libsx/uxmath wrapperı uxmath.dll yerine uxmathcore.dll çağırıyor | P2 |
| uxstats.dll | Temel istatistik | libm | Kaynak/betik var, DLL yok | Yeni biçime yakın; bir eski CONST-DLL çağrısı ve FFI sınırlamaları var | P1 |
| uxstats2.dll | İleri istatistik | libm | Kaynak/betik var, DLL yok | Yeni biçime yakın; AST 4 arg ve mixed-MIR sınırları etkileyebilir | P1 |
| uxdataset.dll | Dataset/batch/scaler | libm; kopyalama betiği GCC runtime adaylarını da kopyalıyor | Kaynak/betik var, DLL yok | 34 çağrının tamamı eski/geçersiz CALL(DLL) biçiminde | P0 |
| uxaimath.dll | Aktivasyonlar/AI matematiği | OpenBLAS yolunda libopenblas, gfortran, quadmath, GCC, winpthread, stdc++ | Kaynak/betik var, DLL yok | 46 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxcollections.dll | LIST/DICT/SET için GLib tabanlı harici kütüphane | GLib2 ve onun gerçek PE importları | Kaynak/betik var, DLL yok; dependency-copy betiği yok | 27 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxdataframe.dll | DataFrame/DuckDB | duckdb.dll | Kaynak/betik var, DLL ve duckdb.dll yok | 31 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxgraph.dll | Graf/igraph | igraph yolunda libigraph ve gerçek transitif importlar | Kaynak/betik var, DLL yok; igraph copy-deps yok | 30 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxllama.dll | Yerel LLM CLI köprüsü | llama-cli.exe, GGUF model; llama-cli'nin gerçek import DLL'leri | Kaynak/betik var; DLL, llama-cli ve model yok | 17 çağrının tamamı eski/geçersiz biçimde | P1 |
| uxmatrix.dll | Matris/OpenBLAS | OpenBLAS yolunda OpenBLAS transitif DLL'leri | Kaynak/betik var, DLL yok; copy-deps yok | 34 eski çağrı; solve_new/inverse_new/cholesky_new C uygulamasında yok | P0 |
| uxnn.dll | Sinir ağı/OpenBLAS | OpenBLAS yolunda OpenBLAS/GFortran/GCC DLL'leri | Kaynak/betik var, DLL yok | 33 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxnn2.dll | Sinir ağı eğitim | libm; -static-libgcc | Kaynak/betik var, DLL yok | 23 çağrının tamamı eski/geçersiz biçimde | P1 |
| uxnn3.dll | Dataset eğitimli sinir ağı | libm; olası GCC/winpthread imports | Kaynak/betik var, DLL yok | 33 çağrının tamamı eski/geçersiz biçimde | P1 |
| uxonnx.dll | ONNX Runtime temel | onnxruntime.dll (CPU paketi) | Kaynak/betik var; DLL ve onnxruntime yok | 21 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxonnx2.dll | ONNX Runtime gelişmiş | onnxruntime.dll; seçilirse provider DLL'leri | Kaynak/betik var; DLL ve onnxruntime yok | 42 çağrının tamamı eski/geçersiz biçimde | P0 |
| uxtensor.dll | Tensor/OpenBLAS | OpenBLAS yolunda OpenBLAS/GFortran/GCC DLL'leri | Kaynak/betik var, DLL yok | 38 çağrının tamamı eski/geçersiz biçimde | P0 |

## 7. Diğer gerekli DLL ve araçlar

| Grup | Birlikte dağıtılması gerekenler | Not |
| --- | --- | --- |
| OpenBLAS kullanan modüller | `libopenblas.dll`, `libgfortran-5.dll`, `libquadmath-0.dll`, `libgcc_s_seh-1.dll`, `libwinpthread-1.dll`, `libstdc++-6.dll` | Betiklerin kopyalamayı hedeflediği listedir; gerçek import tablosu build sonrasında esas alınmalıdır. |
| FP80/FP128 | `libquadmath-0.dll` ve gerçek importta görülen GCC runtime | Sadece ana DLL'i kopyalamak yeterli olmayabilir. |
| BIGFP | MSYS2 sürümüne göre MPFR/GMP DLL'leri; tipik adlar `libmpfr-6.dll`, `libgmp-10.dll` | Kesin dosya adını `objdump -p uxb_bigfp.dll` ile doğrula. |
| GLib collections | En az GLib DLL'i ve onun transitif PE importları | Projede otomatik copy-deps betiği yok; dosya adlarını tahminle sabitleme. |
| DuckDB | `duckdb.dll` | Fetch ve copy betikleri var. |
| igraph | igraph DLL'i ve transitif importları | Copy-deps betiği yok. |
| ONNX | `onnxruntime.dll`; GPU/DirectML/CUDA seçilirse ilgili provider DLL'leri | CPU zip fetch betikleri var. |
| Llama | `llama-cli.exe`, GGUF model ve llama-cli'nin import ettiği llama/ggml/runtime DLL'leri | Mevcut script yalnız belirli MinGW DLL'lerini kopyalıyor; recursive dependency kontrolü gerekli. |
| Windows sistem DLL'leri | `KERNEL32.dll`, `USER32.dll`, `ADVAPI32.dll`, `msvcrt.dll` | Compiler EXE bunları import ediyor; Windows ile gelir, uygulama paketine kopyalanmaz. |

## 8. Modül başlıklarının durumu

`include/modules/*.uxmh` dosyaları şu anda gerçek API başlığı değildir. Örneğin `uxstats.uxmh` yalnız guard ve yorum içerir; `uxstats` fonksiyonlarını ilan etmez ve `libsx/uxstats/uxstats.bas` dosyasını include etmez. Bu nedenle `INCLUDE "modules/uxstats.uxmh"` yazmak, DLL fonksiyonlarını kullanıma açmaz.

Gerekli düzeltme seçenekleri:

1. Her `.uxmh` içine gerçek `DECLARE FUNCTION` sözleşmeleri üretmek.
2. Ya da `.uxmh` dosyasının onarılmış `libsx/.../*.bas` wrapperını include etmesini sağlamak.
3. Header yorumlarındaki `libs/...` yollarını gerçek `libsx/...` yollarıyla eşleştirmek.
4. Header üreticisine boş API dosyasını PASS saymayan bir gate eklemek.

## 9. Build ve doctor betiklerinin eksikleri

- ADIM28 doctor eski ve yanlış source hint yollarına bakıyor; gerçek `runtime_ext/fp80`, `fp128`, `bigfp` yollarını bulamıyor.
- ADIM28 doğrudan `gcc -shared` çağırdığı için `-lquadmath`, `-lmpfr`, `-lgmp` link gereksinimlerini uygulamıyor.
- ADIM29 yalnız dosya varlığı/build exit code kontrol ediyor; PE mimarisi, export, import, transitif DLL, wrapper sözleşmesi ve smoke invocation kontrol etmiyor.
- `build_all_runtime_ext_dlls.bat`, ilk optional doğrudan kütüphane hatasında `warn_optional` etiketine atlayarak sonraki optional DLL'leri hiç denemiyor.
- Build çıktılarının 64-bit compiler ile gerçekten yüklenebildiğine dair ortak test yok.
- Kütüphane registry test klasörleri bildirse de arşivde modül bazlı runtime test paketlerinin tamamı görünmüyor.

## 10. Hedeflere göre kütüphane davranışı

| Hedef | Windows DLL kullanımı | Gerekli doğrulama |
| --- | --- | --- |
| AST interpreter | Compiler process DLL'i doğrudan yükler | Compiler ve DLL bitliği aynı olmalı; mevcut uxb.exe 32-bit. |
| MIR interpreter | MIR evaluator DLL'i doğrudan yükler | Bitlik, imza, arity ve mixed-F64 mask testi. |
| x64 native EXE | Üretilen 64-bit program DLL'i yükleyebilir | DLL'ler EXE yanında/PATH'te; export ve Win64 ABI doğru. |
| JavaScript | Windows DLL doğrudan kullanılamaz | JS karşılığı veya host RPC/bridge gerekir. |
| WAT/WASM | PE DLL yüklenemez | Kütüphane WASM'a derlenmeli veya host import tasarlanmalı. |
| Browser | Windows DLL doğrudan kullanılamaz | Fail-close, JS/WASM backend veya sunucu köprüsü. |

## 11. Önerilen onarım sırası

1. **P0 — Gerçek x64 compiler üret:** eski 32-bit `_64.exe` dosyasını force rebuild ile değiştir ve PE32+ doğrula.
2. **P0 — FFI sözleşmesini tekleştir:** `I64` desteği kararlaştırılsın; tek elemanlı type-list parserı düzeltinsin; AST/MIR/x64 arity kuralları aynılaştırılsın.
3. **P0 — Wrapper üreticisini düzelt:** string literal DLL, zorunlu imza, convention ve arg type listesi otomatik üretilsin.
4. **P0 — `uxb_runtime.dll` gerçek backendini ekle:** EVENT/THREAD/PIPE/PARALEL bridge function pointer üzerinden gerçek DLL'i çağırsın.
5. **P0 — BIGFP buildini tamamla:** BIGI ve biginit bridge kaynakları build'e katılsın; export testleri yazılsın.
6. **P0 — Eksik matrix exportlarını uygula veya wrapperdan kaldır.**
7. **P1 — Her DLL için export/import/architecture/smoke gate ekle.**
8. **P1 — Dependency deployment paketlerini tamamla:** özellikle GLib, igraph, matrix ve llama transitif bağımlılıkları.
9. **P1 — `.uxmh` başlıklarını gerçek API başlığına dönüştür.**
10. **P2 — JS/WASM karşılığı olmayan native kütüphaneleri backend matrixte açıkça unsupported olarak işaretle.**

## 12. Son hüküm

Kütüphane C kaynakları genel olarak ciddi bir başlangıç sağlar; ancak mevcut arşivde kütüphane sistemi uçtan uca çalışır kabul edilemez. Derlenmiş DLL yoktur, compiler/interpreter bitliği uyumsuzdur, headerlar boştur ve wrapperların çoğu parser sözleşmesini geçmez. Bu nedenle kılavuzda bu modüller hazır standart kütüphane olarak değil, **kaynağı bulunan fakat build, wrapper, dependency ve backend doğrulaması bekleyen runtime extensionlar** olarak anlatılmalıdır.