# Cilt IV: Native Entegrasyon ve Standart Kütüphaneler

## Kitabın amacı

Bu cilt uXBasic programını Windows API, dış DLL, C/C++/ASM birimi, Python ve
standart bilimsel runtime'larla birleştirir. Her entegrasyonda dört konu
birlikte ele alınır:

1. kaynak sözdizimi;
2. Win64 ABI ve tip hizası;
3. tutacak/kaynak yaşam döngüsü;
4. paketleme ve gerçek çalışma testi.

## 1. Native sınırın temel kuralları

Bir dış çağrı güvenli sayılmadan önce:

- DLL gerçekten bulunmalı;
- sembol bulunmalı;
- dönüş tipi doğru olmalı;
- argüman tipi/sırası doğru olmalı;
- calling convention hedefle uyumlu olmalı;
- en çok 10 kullanıcı argümanı uygulanmalı;
- pointer yaşam süresi çağrı boyunca geçerli olmalı;
- hata kodu veya son hata alınmalı;
- allowlist politikası açık olmalı.

Yanlış ABI bazen hemen çökmez. Kayıt veya stack bozulması sonraki çağrıda
ortaya çıkabilir; bu nedenle tek çağrılı smoke testi yeterli değildir.

## 2. Win64 tip eşlemesi

| uXBasic | C/C++ karşılığı | Win64 taşıma |
|---|---|---|
| `I8` | `int8_t` | integer register/stack |
| `U8` | `uint8_t` | integer register/stack |
| `I16` | `int16_t` | integer register/stack |
| `U16` | `uint16_t` | integer register/stack |
| `I32` | `int32_t` | 32 bit |
| `U32` | `uint32_t` | 32 bit |
| `I64` | `int64_t` | 64 bit |
| `U64` | `uint64_t` veya tutacak | 64 bit |
| `F32` | `float` | XMM |
| `F64` | `double` | XMM |
| `PTR` | `void *` | 64 bit pointer |
| `STRPTR` | `const char *` | UTF-8/ANSI sözleşmesine göre |
| `WSTRPTR` | `const wchar_t *` | Windows wide string |
| `VOID` | `void` | dönüş yok |

`STRING` uXBasic runtime nesnesidir. DLL imzasında çoğunlukla `STRPTR`
üzerinden aktarılır.

## 3. CALL'ın üç anlamı

### 3.1 Normal yordam çağrısı

```text
sonuc = Topla(3, 4)
CALL Topla(3, 4)
CALL(Topla, 3, 4)
```

### 3.2 DLL

```text
sonuc = CALL(DLL, "kitaplik.dll", "sembol", I32, CDECL, "I32,I32", a, b)
```

### 3.3 Windows/API

```text
tick = CALL(API, "kernel32", "GetTickCount", U32, STDCALL)
```

`CALL(API,...)` Windows API çözümleyici yolunu, `CALL(DLL,...)` genel DLL
yolunu kullanır. Her ikisi de ifade içinde sonuç döndürebilir veya deyim
olarak çağrılabilir.

## 4. ABI10 çağrı biçimi

Kanonik geniş biçim:

```text
CALL(
    DLL,
    kutuphane,
    sembol,
    donusTipi,
    cagriDuzeni,
    "argTipi1,argTipi2,...",
    arg1,
    arg2
)
```

Örnek:

```text
sonuc = CALL(
    DLL,
    "msvcrt.dll",
    "pow",
    F64,
    CDECL,
    "F64,F64",
    2.0,
    3.0
)
```

İmza string'i özellikle karışık integer/kayan nokta veya pointer
çağrılarında zorunlu tutulmalıdır. Sıfır argümanlı çağrıda atlanabilir:

```text
tick = CALL(DLL, "kernel32.dll", "GetTickCount", U32, STDCALL)
```

## 5. DECLARE FUNCTION

Statik dış bildirim:

```text
DECLARE FUNCTION DisTopla _
    LIB "hesap.dll" _
    ALIAS "hesap_topla_i32" _
    (BYVAL a AS I32, BYVAL b AS I32) AS I32
```

Calling convention:

```text
DECLARE FUNCTION puts CDECL _
    LIB "msvcrt.dll" _
    ALIAS "puts" _
    (BYVAL metin AS STRPTR) AS I32
```

`LIB` yüklenen dosyayı, `ALIAS` gerçek export adını, uXBasic yordam adı ise
kullanıcı yüzeyini belirler.

## 6. Allowlist ve fail-close

Runtime varsayılan politika dosyası:

```text
build/manual/config/ffi_allowlist.txt
```

Dosya başlığı:

```text
UXB_FFI_ALLOWLIST_V1
```

Temel satır:

```text
DLL|SYMBOL|RETURN_TYPE
```

Geniş kayıtta calling convention, hash ve signer bilgisi de doğrulanabilir.
Politika modları:

- `REPORT_ONLY`: kararı raporlar; çağrıya izin verilebilir.
- `ENFORCE`: izin verilmeyen çağrıyı durdurur.

Bir sürüm paketinde mod, policy yolu ve karar JSON/log içinde görünmelidir.
Rapor modundaki bir deny uyarısını “allowlist geçti” diye yorumlamak yanlıştır.

## 7. Windows API örneği

Tam kaynak:
[examples/cilt4/03_ffi_winapi.uxb](examples/cilt4/03_ffi_winapi.uxb)

Program:

- `GetTickCount` sonucunu `U32` alır;
- `Sleep` çağrısını dönüşsüz yapar;
- ikinci tick'in ilkinden küçük olmadığını doğrular;
- AST ve MIR FFI yollarında çalıştırılabilir.

Bu örnek dağıtım politikasında `kernel32` sembollerinin allowlist kaydıyla
birlikte kullanılmalıdır.

## 8. INLINE

Kanonik başlık:

```text
INLINE("x64","nasm","sub","abi=win64;preserve=rbx,rsi,rdi,r12,r13,r14,r15;stack=16;shadow=32")
mov rax, 7
END INLINE
```

Dört alan:

| Sıra | Alan | Örnek |
|---:|---|---|
| 1 | `arch` | `x64` |
| 2 | `assembler` | `nasm` |
| 3 | `kind` | `sub` |
| 4 | `policy` | ABI, preserve, stack, shadow |

Bu sözleşme `(arch, assembler, kind, policy)`dir. Kod adı, giriş ve çıkış
listesi şeklinde yeniden yorumlanmaz.

Tam kaynak:
[examples/cilt4/01_inline_x64.uxb](examples/cilt4/01_inline_x64.uxb)

### 8.1 INLINE doğrulaması

x64 inline validator şunları denetlemelidir:

- arch ve assembler;
- Win64 ABI;
- korunacak kayıt listesi;
- 16 byte stack hizası;
- 32 byte shadow space;
- `call` varsa gerekli policy;
- `END INLINE`;
- hedef dışı kullanım.

Inline gövdeyi yorumlayıcının çalıştırmaması doğaldır; x64 emitter'ın gövdeyi
doğru yere koyması ve oluşan object/EXE'nin çalışması gerekir.

## 9. IMPORT ile C, C++ ve ASM

```text
IMPORT(C, "native/bolge_kodu.c")
IMPORT(CPP, "native/agirlik_katsayisi.cpp")
IMPORT(ASM, "native/koli_topla.asm")
```

Tam örnek:
[examples/cilt4/02_import_native.uxb](examples/cilt4/02_import_native.uxb)

Native birimler:

- [bolge_kodu.c](examples/cilt4/native/bolge_kodu.c)
- [agirlik_katsayisi.cpp](examples/cilt4/native/agirlik_katsayisi.cpp)
- [koli_topla.asm](examples/cilt4/native/koli_topla.asm)

### 9.1 IMPORT ile INLINE farkı

`INLINE`, uXBasic kaynağındaki doğrulanan NASM bloğudur.

`IMPORT`:

1. dış kaynak dosyasını build planına kaydeder;
2. uzantı/dil eşleşmesini doğrular;
3. kullanıcı ayarlı NASM/GCC/G++ yolunu kullanır;
4. object üretir;
5. uXBasic object ve runtime DLL'leriyle bağlar;
6. tek EXE veya tanımlı paket üretir.

C/C++ kodu `INLINE(c,...)` biçimiyle uydurulmaz.

## 10. C/C++ export disiplini

C:

```c
#include <stdint.h>

int32_t bolge_kodu(int32_t il)
{
    return 1000 + il;
}
```

C++:

```cpp
extern "C" double agirlik_katsayisi(double agirlik, double katsayi)
{
    return agirlik * katsayi;
}
```

`extern "C"` C++ name mangling'i kaldırır. Export biçimi DLL veya doğrudan
object link stratejisine göre build script'inde belirlenir.

## 11. NASM Win64 birimi

```nasm
global koli_topla
section .text
koli_topla:
    mov eax, ecx
    add eax, edx
    ret
```

İlk iki `I32` argümanı ECX ve EDX ile gelir; `I32` sonuç EAX'tadır. Callee
korunan kayıtları kullanıyorsa geri yüklemelidir.

## 12. Geniş kayan nokta runtime'ları

Aktif dış runtime dizinleri:

- `runtime_ext/fp80`
- `runtime_ext/fp128`
- `runtime_ext/bigfp`
- `runtime_ext/fpcommon`

Kullanıcı yüzeyi:

```text
DIM x AS F80
x = F80("1.234567890123456789")
```

Benzer biçimde `F128`, `BIGF`, `BIGD`, `BALL` constructor işlevleri ilgili
runtime tipini döndürür.

Gerekli testler:

- parse ve tip;
- DLL yükleme;
- toplama/çıkarma/çarpma/bölme;
- karşılaştırma;
- string dönüşüm;
- hassasiyet ve yuvarlama;
- handle serbest bırakma;
- eksik DLL'de açık hata;
- x64 program paketinde DLL bulunması.

## 13. Standart kütüphane sistemi

Genel kullanım:

```text
INCLUDE "include/modules/uxmatrix.uxmh"
```

Başlık, gerçek wrapper kaynağını ekler:

```text
INCLUDE "libsx/uxmatrix/uxmatrix.bas"
```

Wrapper:

- namespace sağlar;
- `CALL(DLL,...)` imzasını tek yerde tutar;
- `U64/PTR` tutacaklarını kullanıcıya verir;
- `Free` işlevini açar.

## 14. Aktif standart kütüphane envanteri

| Başlık | Runtime | Alan |
|---|---|---|
| `uxaimath.uxmh` | `uxaimath.dll` | aktivasyon, loss, optimizer |
| `uxcollections.uxmh` | `uxcollections.dll` | GLib koleksiyonları |
| `uxdataframe.uxmh` | `uxdataframe.dll` | DuckDB dataframe |
| `uxdataset.uxmh` | `uxdataset.dll` | ML veri kümesi |
| `uxgraph.uxmh` | `uxgraph.dll` | igraph tabanlı grafik |
| `uxllama.uxmh` | `uxllama.dll`/CLI | yerel metin modeli |
| `uxllamax.uxmh` | `uxllama` runtime | geniş wrapper |
| `uxmath.uxmh` | `uxmath.dll` | vektör çekirdeği |
| `uxmathcore.uxmh` | `uxmathcore.dll` | tipli buffer/vektör |
| `uxmatrix.uxmh` | `uxmatrix.dll` | matris/OpenBLAS |
| `uxnn.uxmh` | `uxnn.dll` | katman/ağ çıkarım ve eğitim |
| `uxnn2.uxmh` | `uxnn2.dll` | model eğitim/saklama |
| `uxnn3.uxmh` | `uxnn3.dll` | dataset ile eğitim |
| `uxonnx.uxmh` | `uxonnx.dll` | ONNX session/tensor |
| `uxonnx2.uxmh` | `uxonnx2.dll` | gelişmiş ONNX |
| `uxpython.uxmh` | `uxpython.dll` | gömülü Python köprüsü |
| `uxstats.uxmh` | `uxstats.dll` | temel istatistik |
| `uxstats2.uxmh` | `uxstats2.dll` | ileri testler |
| `uxtensor.uxmh` | `uxtensor.dll` | N boyutlu tensor |

Aktif `libsx`, `include/modules` ve `runtime_ext` ağacında Lua veya Prolog
genel başlığı yoktur. Eski belge veya planlarda geçmesi, dağıtılabilir standart
kütüphane olduğu anlamına gelmez. Bu modüller yeniden eklenecekse aynı header,
wrapper, runtime, build, test ve paket sözleşmesinden geçmelidir.

## 15. uxmath ve uxmathcore

`uxmath` vektör API'si:

- `UXMATH_Version`
- `UXMATH_VecCreate`, `VecFree`
- `VecCount`, `VecDataPtr`
- `VecPush`, `VecGet`, `VecSet`, `VecClear`

`uxmathcore` tipli buffer:

- `UXMC_BufferCreate`, `BufferCreateCapacity`, `BufferFree`;
- `BufferCount`, `Capacity`, `ByteSize`, `ElemSize`, `Type`;
- `Reserve`, `Resize`, `Append`, `Slice`, `Clone`, `Cast`;
- `PushByte/I64/U64/F64`, `Get/Set`;
- `VecAdd/Sub/Mul/Div`, `Dot`, `Axpy`, norm, min/max, scale.

Tip sabitleri `UXMC_TYPE_I8..U64` ve `UXMC_TYPE_F32/F64` wrapper
fonksiyonlarıyla alınır.

## 16. uxcollections

API aileleri:

| Yapı | Oluştur/kapat | İşlem |
|---|---|---|
| list | `ListNew`, `ListFree` | `ListCount`, `ListPushF64`, `ListGetF64` |
| stack | `StackNew`, `StackFree` | `StackPushF64`, `StackPopF64` |
| queue | `QueueNew`, `QueueFree` | `QueuePushF64`, `QueuePopF64` |
| dict | `DictNew`, `DictFree` | `DictSetF64`, `DictGetF64`, `DictHas` |
| set | `SetNew`, `SetFree` | `SetAdd`, `SetContains` |
| tree | `TreeNew`, `TreeFree` | `TreeSetF64`, `TreeGetF64` |

Kural:

```text
DIM h AS U64
h = uxcollections.ListNew()
ASSERT h <> 0
' işlemler
CALL uxcollections.ListFree(h)
h = 0
```

## 17. uxdataframe ve DuckDB

`uxdataframe` doğrudan uXBasic çekirdek `DICT/LIST` sistemi değildir.
DuckDB destekli native dataframe tutacağıdır.

### 17.1 Oturum

- `OpenMemory()`
- `OpenDatabase(path)`
- `Free(df)`
- `RuntimeVersion()`
- `DuckDBAvailable()`
- `DuckDBVersion()`
- `LastError(df)`

### 17.2 Veri alma ve SQL

- `LoadCSV(path, header)`
- `LoadParquet(path)`
- `Exec(df, sql)`
- `Query(df, sql)`
- `RowCount`, `ColCount`, `ColName`
- `GetF64`, `GetText`

### 17.3 Dönüşümler

- `Head`
- `SelectCols`
- `Filter`
- `OrderBy`
- `Describe`
- `GroupMean`
- `JoinInner`
- `ToCSV`
- `ToParquet`

### 17.4 Matris köprüsü

- `ToF64Matrix`
- `MatrixRows`, `MatrixCols`
- `MatrixGet`, `MatrixDataPtr`
- `MatrixFree`

Örnek akış:

```text
INCLUDE "include/modules/uxdataframe.uxmh"

DIM db AS U64
DIM sonuc AS U64
db = uxdataframe.OpenMemory()
ASSERT db <> 0

CALL uxdataframe.Exec(db, "CREATE TABLE sevkiyat(kod INTEGER, sure DOUBLE)")
CALL uxdataframe.Exec(db, "INSERT INTO sevkiyat VALUES (1, 12.5), (2, 18.0)")
sonuc = uxdataframe.Query(db, "SELECT AVG(sure) FROM sevkiyat")
ASSERT sonuc <> 0
PRINT uxdataframe.GetF64(sonuc, 0, 0)

CALL uxdataframe.Free(sonuc)
CALL uxdataframe.Free(db)
```

Her SQL çağrısından sonra sıfır/nonzero sözleşmesi ve `LastError`
denetlenmelidir.

## 18. uxdataset

Temel API:

- `Create`, `Clone`, `Free`;
- `RowCount`, `InputDim`, `TargetDim`;
- `GetX/SetX`, `GetY/SetY`, `XPtr/YPtr`;
- `LoadCSV`, `SaveCSV`;
- `Shuffle`;
- `SplitTrain`, `SplitTest`;
- `FillMissingMean`;
- standard/minmax scaler create-fit-transform-inverse-free;
- batch create/next/reset/rows/pointer/free.

Dataset tutacağı ile tensor veya dataframe tutacağı aynı değildir. Dönüşüm
API'si olmadan pointer'ı başka modüle vermek yasaktır.

## 19. uxstats ve uxstats2

`uxstats`:

- sum, min, max, range;
- mean, median, percentile;
- population/sample variance ve stddev;
- covariance ve correlation;
- linear regression slope/intercept/R2;
- vektör create/push/get/set/free.

`uxstats2`:

- one/two sample Z ve T;
- Welch, pooled, paired test;
- proportion testleri;
- F variance;
- ANOVA/ANCOVA ve post-hoc;
- chi-square;
- regression F;
- Durbin-Watson, Breusch-Godfrey;
- ADF;
- Hotelling T2;
- VIF.

İstatistik API'si sonuç sayısı yanında örneklem büyüklüğü, serbestlik derecesi
ve veri doğrulamasını da denetlemelidir.

## 20. uxmatrix

API grupları:

- yaşam: `Create`, `Clone`, `Free`;
- şekil: `Rows`, `Cols`, `Size`, `DataPtr`;
- erişim: `Get`, `Set`, `Fill`, `Zero`, `Eye`;
- aritmetik: `Add`, `Sub`, `Scale`, `Mul`, `Dot`, `MatVec`;
- dönüşüm: `Transpose`;
- norm/iz: `NormFro`, `NormL1`, `NormL2`, `Trace`;
- lineer cebir: `Det`, `Inverse`, `Solve`, `Cholesky`, `QR`, `SVD`,
  `EigenSymmetric`, `RankSVD`, `Cond2`.

Boyut uyuşmazlığı sıfır matrisle devam etmemeli; `LastError` veya açık dönüş
kodu vermelidir.

## 21. uxtensor

Oluşturma:

- `Create1D`, `Create2D`, `Create3D`, `Create4D`
- `Clone`, `Free`

Bilgi:

- `NDim`, `Dim`, `Stride`, `Size`, `DType`, `ElemSize`, `DataPtr`

Erişim:

- `GetFlat/SetFlat`
- `Get2D/3D/4D`, `Set2D/3D/4D`

İşlem:

- `Add`, `Subtract`, `Multiply`, `Divide`;
- `Scale`, `Sum`, `Mean`, `Norm2`;
- `Dot`, `MatVec`, `MatMul`;
- `Transpose2D`, `SliceAxis0`;
- `Fill`, `Zero`.

## 22. uxaimath

Aktivasyon:

`ReLU`, `LeakyReLU`, `Sigmoid`, `GELU`, `ELU`, `Softplus`, `Swish`,
pointer ve tensor varyantları.

Kayıp/metrik:

`MSE`, `MAE`, `Huber`, `BinaryCrossEntropy`,
`CategoricalCrossEntropy`, `BinaryAccuracy`.

Eğitim yardımcıları:

`MSEGrad`, `BCEGrad`, `SGDUpdate`, `MomentumUpdate`, `ClipNorm`,
`ClipValue`, Xavier/He, uniform/normal fill.

Dense:

`DenseForward`, `DenseBatchForward`, `ArgMax`, `Softmax`.

## 23. uxnn, uxnn2 ve uxnn3

`uxnn` düşük seviye neuron/layer/network:

- neuron create/get/set/forward/free;
- dense/activation layer create/init/forward/free;
- network create/add/forward/train/predict/free.

`uxnn2` model düzeyi:

- `NetworkCreate`, `AddDense`, `Init`;
- `ForwardPtr`, `PredictArgmaxPtr`;
- sample/array MSE eğitim;
- optimizer seçimi/parametreleri;
- ağırlık/bias erişimi;
- `Save`, `Load`, `NetworkFree`.

`uxnn3` dataset odaklı:

- model ve dataset oluşturma;
- CSV yükleme/saklama;
- split, shuffle, standardize/minmax;
- `TrainDataset`;
- `EvalMSE`, `EvalBinaryAccuracy`;
- `PredictArgMax`;
- model saklama/yükleme.

## 24. uxonnx ve uxonnx2

`uxonnx`:

- runtime `Init`, `Version`, `LastError`;
- `SessionCreate/SessionFree`;
- input/output ad ve sayı;
- 1D..4D tensor;
- tensor rank/dim/count/data/get/set/free;
- `Run1`.

`uxonnx2` ek olarak:

- provider sorgulama;
- advanced session;
- input/output rank, dim, dtype;
- F64, I64 ve string tensor;
- çok giriş/çıkışlı run builder;
- result set ve tensor erişimi.

ONNX model dosyası, provider DLL'leri ve runtime sürümü paket manifestinde
yer almalıdır.

## 25. uxgraph

Graf oluşturma:

- `Create`, `Free`;
- `AddVertex`, `AddVertices`, `AddEdge`;
- `MakePath`, `MakeCycle`, `MakeComplete`;
- `ReadEdgeListCSV`, `WriteEdgeListCSV`.

Sorgu/analiz:

- `VCount`, `ECount`, `IsDirected`, `HasEdge`;
- degree/in/out degree ve degree vector;
- shortest distance, BFS distances, path exists;
- components, connected;
- density, transitivity, triangle, self-loop.

Vektör sonuçları `VecCount/VecGet/VecFree` ile yönetilir.

## 26. uxllama ve uxllamax

Akış:

1. `Create`;
2. CLI ve model yolunu ayarla;
3. context, predict, temperature, seed, thread, top-k/top-p;
4. `Prompt` veya `PromptFile`;
5. `LastCommand/LastError`;
6. `Free`.

`LowMemoryProfile` hazır ayar uygular. `ModelExists` gerçek model dosyasını
denetler.

Llama testi, uygun GGUF model dosyası yoksa koşullu olarak “çalışmadı” diye
raporlanır; model olmadan yalnız wrapper çağrı izi gerçek inference kanıtı
değildir.

## 27. Python köprüsü

Genel başlık:

```text
INCLUDE "include/modules/uxpython.uxmh"
```

Sistem kaynakları ayrıca `UXB_010_UXPYTHON_SYSTEM` paketinde bulunur; aktif
genel wrapper `libsx/uxpython/uxpython.bas` ile karşılaştırılır.

### 27.1 Oturum açma

```text
DIM flags AS I32
DIM py AS U64
flags = PythonFlagIsolated() OR PythonFlagIgnoreEnvironment()
py = PythonOpen(pythonHome, venvPath, modulePath, flags)
ASSERT py <> 0
ASSERT PythonReady(py) <> 0
```

Flag'ler:

- `PythonFlagIsolated() = 1`
- `PythonFlagIgnoreEnvironment() = 2`
- `PythonFlagNoSite() = 4`

Yollar kullanıcı/proje yapılandırmasından gelmelidir; taşınabilir kitap
örneğinde makineye özel sabit yol gömülmez.

### 27.2 Modül ve çağrı

Kolay yol:

```text
sonuc = PythonCallModule(
    py,
    "math",
    "sqrt",
    "[81]",
    "{}"
)
ASSERT sonuc <> 0
PRINT PythonFloat(py, sonuc)
CALL PythonRelease(py, sonuc)
```

Nesne yolu:

- `PythonImport`
- `PythonGet`
- `PythonCall`
- `PythonInt`, `PythonFloat`, `PythonString`, `PythonJson`
- `PythonRelease`

### 27.3 Kapanış

Her Python object handle `PythonRelease` ile; session `PythonClose` ile
kapatılır. Son süreç kapanışında `PythonShutdown` kullanılabilir.

Hata:

```text
IF sonuc = 0 THEN
    PRINT PythonError(py)
END IF
```

## 28. Python list/dict/set/tuple/dataframe

Python koleksiyonları JSON argüman ve JSON sonuç köprüsüyle taşınabilir:

```text
sonuc = PythonCallModule(py, "modulum", "isle", _
    "[[1,2,3], {""bolge"":""EGE""}]", "{}")
PRINT PythonJson(py, sonuc)
```

Bu değerler uXBasic çekirdek `LIST/DICT/SET` tutacağı değildir. Dönüşüm:

1. Python tarafında JSON'a serileştir;
2. `PythonJson` ile string al;
3. uXBasic JSON/parser veya dataframe katmanında açıkça çöz.

Python `pandas.DataFrame` ayrı Python oturumunda kullanılabilir.
uXBasic'in standart `uxdataframe` sistemi ise DuckDB runtime'ıdır. İki
dataframe uygulaması aynı ad altında gizlice birbirinin yerine geçmez.

## 29. Kütüphane geliştirme standardı

Yeni standart modül için zorunlu parçalar:

1. `include/modules/<ad>.uxmh`;
2. `libsx/<ad>/<ad>.bas`;
3. `runtime_ext/<ad>` gerçek kaynak ve build script'i;
4. C ABI header;
5. export envanteri;
6. allowlist kaydı;
7. pozitif ve negatif test;
8. DLL yükleme ve gerçek sonuç probe'u;
9. kaynak/paket manifesti;
10. bu ciltte kullanım ve yaşam döngüsü.

Wrapper'daki her işlev gerçek export'a bağlanmalıdır. Sabit değer döndüren
geçici gövde standart kütüphane sayılmaz.

## 30. Kütüphane test kapısı

Her modül için:

- DLL var ve mimarisi x64;
- bağımlı DLL'ler çözüldü;
- `Version/RuntimeVersion` gerçek değer;
- en az bir hesaplama sonucu;
- yanlış handle;
- boyut/argüman hatası;
- `LastError`;
- kaynak serbest bırakma;
- tekrar aç/kapat;
- çoklu oturum;
- eksik model/veri dosyası;
- allowlist enforce

test edilir.

## 31. Paketleme

Dağıtım paketi:

- uygulama EXE/JS/WASM;
- gerekli runtime DLL'leri;
- GCC/NASM yalnız kullanıcı sistemi istiyorsa yol ayarı;
- model/veri dosyaları;
- allowlist;
- lisanslar;
- manifest ve hash;
- çalıştırma script'i;
- sürüm raporu

içerir.

DLL'nin geliştirici makinesinde PATH üzerinde bulunması, paketin bağımsız
çalıştığını kanıtlamaz. Temiz bir dizinde veya temiz Windows kullanıcı
ortamında test yapılır.

## 32. Cilt sonu kontrol listesi

- FFI dönüş ve argüman tipleri C header ile birebir mi?
- ABI10 sınırında argüman kesilmeden hata veriliyor mu?
- Win64 stack ve register kuralı doğrulandı mı?
- INLINE başlığı dört alanlı doğru sözleşme mi?
- C/C++/ASM dosyaları IMPORT build planına gerçekten girdi mi?
- Allowlist modu ve kararı raporda mı?
- Her native handle uygun `Free/Release/Close` ile kapanıyor mu?
- DuckDB dataframe ile Python dataframe ayrıldı mı?
- Python yolları proje ayarından mı geliyor?
- Llama testi gerçek model yoksa açıkça koşullu mu?
- Aktif kaynakta olmayan modül standart kütüphane diye belgelenmedi mi?

