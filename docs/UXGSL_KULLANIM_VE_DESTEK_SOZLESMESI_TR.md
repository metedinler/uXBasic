# UXGSL: uXBasic için GNU Scientific Library desteği

UXGSL, GNU Scientific Library (GSL) 2.8'i uXBasic projelerine iki açık katman
olarak sunar. Amaç, örneklerde çalışan ancak gerçek projede davranışı belirsiz
bir sarmalayıcı değil; hangi çağrının desteklendiği, başarısızlıkta ne yaptığı
ve ham C API'sinin ne zaman kullanılacağı belli bir kütüphane sağlamaktır.

## Hızlı başlangıç

```basic
INCLUDE "include/modules/uxgsl.uxmh"

MAIN
    DIM values AS U64

    values = uxgsl.VectorCreate(3)
    IF values = 0 THEN
        PRINT "UXGSL error: " + uxgsl.LastError()
    ELSE
        uxgsl.VectorSet(values, 0, 10.0)
        uxgsl.VectorSet(values, 1, 20.0)
        uxgsl.VectorSet(values, 2, 30.0)
        PRINT uxgsl.VectorMean(values)
        uxgsl.VectorFree(values)
    END IF
END MAIN
```

Önce çalışma ortamını doğrulayın:

```basic
ASSERT uxgsl.ApiVersion() = 106
ASSERT uxgsl.Available() = 1
ASSERT uxgsl.SelfTest() = 1
PRINT uxgsl.GslVersion()
```

## Destek sözleşmesi

| Katman | Durum | Kullanım sözü |
|---|---|---|
| Tipli UXGSL yüzeyi | Kararlı v106 | Bu belgede listelenen fonksiyonlar, C-ABI10 imzaları ve hata davranışları desteklenir. |
| GSL/CBlas ham erişimi | Gelişmiş API | Kurulu DLL'deki her export bulunabilir ve `uxcapi` ile çağrı nesnesi oluşturulabilir. İmza, struct yerleşimi, callback ve sahiplik bilgisi çağıranın sorumluluğundadır. |
| Header'dan üretilmiş kontrollü scalar binding | v102 | 177 özel-fonksiyon adapter'ı, doğrulanmış `*_e` GSL çağrısıyla durum kodunu korur. Struct/callback ağırlıklı header'lar otomatik ve güvenli kabul edilmez. |
| JS/WASM'da yerel GSL | Henüz desteklenmiyor | Bu sürüm Windows x64/UCRT64 yerel DLL dağıtımına yöneliktir. |

Ham erişimin kapsamı, [gsl_exports.json](../runtime_ext/uxgsl/gsl_exports.json)
kataloğunda makine tarafından doğrulanır: kurulu `libgsl-28.dll` ve
`libgslcblas-0.dll` içindeki semboller. Bu katalog **fonksiyon imzası kataloğu
değildir**. Bir export'un görünmesi, onun otomatik tipli BASIC sarmalayıcısı
olduğu anlamına gelmez.

## Tipli API

`uxgsl` namespace'i şu doğrudan ve güvenli API'leri sunar:

- Çalışma ortamı: `ApiVersion`, `Available`, `GslVersion`, `SelfTest`
- Özel fonksiyonlar: `BesselJ0`, `BesselJ1`, `BesselY0`, `Gamma`, `LnGamma`,
  `Erf`, `GaussianPdf`
- Rastgelelik: `RngCreate`, `RngFree`, `RngUniform`, `RngGaussian`
- Double vector: `VectorCreate`, `VectorFree`, `VectorSize`, `VectorSet`,
  `VectorGet`, `VectorMean`, `VectorStandardDeviation`, `VectorVariance`
- Double matrix: `MatrixCreate`, `MatrixFree`, `MatrixRows`, `MatrixColumns`,
  `MatrixSet`, `MatrixGet`, `MatrixSetZero`, `MatrixSetIdentity`,
  `MatrixMultiply`
- Sayısal integrasyon: `IntegrationWorkspaceCreate`, `IntegrationWorkspaceFree`,
  `IntegrateQag`, `LastEstimatedError`
- Callback tabanlı kök bulma: `RootBisectionCreate`, `RootBisectionFree`,
  `RootBisectionSet`, `RootBisectionIterate`, `RootBisectionRoot`,
  `RootBisectionLower`, `RootBisectionUpper`, `RootBisectionIntervalConverged`
- Complex: `ComplexCreate`, `ComplexFree`, `ComplexReal`, `ComplexImaginary`,
  `ComplexAbs`, `ComplexAdd`, `ComplexMultiply`
- Durum/hata: `LastStatus`, `LastGslStatus`, `LastError`, `StatusText`

Ek olarak v102, kurulu GSL public header'larından otomatik üretilen 177
kontrollü scalar özel-fonksiyon binding'i sunar. Adları `Sf` ile başlar;
örneğin `SfBesselJn(2, x)`, `SfAiryZeroAi(1)` ve `SfChi(x)`. Her biri doğrudan
değer döndüren GSL fonksiyonunu değil, header'da doğrulanmış `*_e` karşılığını
kullanır; bu nedenle `LastStatus` GSL domain/range sonucunu taşır. Kaynak ve
üretim kararı [gsl_header_api.json](../runtime_ext/uxgsl/gsl_header_api.json)
içinde denetlenebilir.

Üretim, derleme süresini gereksiz büyütmemek için GSL ailelerine bölünmüştür.
Örneğin Bessel ailesini kullanmak için:

```basic
INCLUDE "include/modules/uxgsl_generated/gsl_sf_bessel.uxmh"
```

Tüm üretilmiş scalar ailelerini bilinçli olarak açmak gerekirse önce temel
`uxgsl.uxmh`, ardından `libsx/uxgsl/generated/uxgsl_scalar_auto.bas` umbrella
dosyası kullanılabilir; normal projelerde dar aile başlıkları önerilir.

uXBasic büyük/küçük harfe duyarsız olduğu için, GSL'de yalnız harf
büyüklüğüyle ayrılan iki C sembolü aynı BASIC adına dönüşemez. Bu nadir
durumlarda üretici, ham C sembolünün büyük harf bilgisini içeren `_Gsl...`
son ekini otomatik ekler; karar metadata dosyasında `case_disambiguated` ile
görülür. Hiçbir export sessizce ezilmez.

Vector ve RNG handle'ları opaktır: onları sayı olarak saklayabilirsiniz ama
aritmetik yapmayın, farklı UXGSL işlemlerinin türüne karıştırmayın veya ham GSL
pointer'ı olarak tipli API'ye vermeyin.

Matrix handle'ı da opaktır ve hem GSL `gsl_matrix` yapısının hem de onun
backing buffer'ının tek sahibidir. Koordinatlar sıfır tabanlıdır. `MatrixMultiply`
yalnızca `A.columns = B.rows` ve çıktı boyutu `A.rows x B.columns` olduğunda
çalışır; çıktı handle'ı girişlerden biri olamaz. Böylece C tarafındaki struct
yerleşimi ve output buffer çağırana sızmaz:

```basic
DIM a AS U64
DIM b AS U64
DIM product AS U64

a = uxgsl.MatrixCreate(2, 2)
b = uxgsl.MatrixCreate(2, 2)
product = uxgsl.MatrixCreate(2, 2)
ASSERT uxgsl.MatrixSetIdentity(a) = 1
ASSERT uxgsl.MatrixSet(b, 0, 0, 3.0) = 1
ASSERT uxgsl.MatrixSet(b, 1, 1, 4.0) = 1
ASSERT uxgsl.MatrixMultiply(a, b, product) = 1
ASSERT uxgsl.MatrixGet(product, 1, 1) = 4.0
uxgsl.MatrixFree(a): a = 0
uxgsl.MatrixFree(b): b = 0
uxgsl.MatrixFree(product): product = 0
```

v105 ile native x64 `CODEPTR`, gerçek yordam etiketini verir; böylece
uXBasic `FUNCTION f(x AS F64) AS F64` yordamı gerçek senkron C ABI callback
olarak GSL'e geçirilebilir. v106 bu temeli callback'i birden fazla çağrı
boyunca saklayan sahiplikli bisection kök çözücüsüyle genişletir. `IntegrateQag`
sahipliği UXGSL'de olan workspace kullanır; callback yalnız çağrı boyunca
geçerli kalmalıdır. `RootBisection` ise callback adresini `Set` ile `Free`
arasındaki bütün yinelemeler boyunca saklar; yordam ve ürettiği kod bu süre
boyunca geçerli olmalıdır. Mevcut `uxcapi.CallbackNew` olay kuyruğu callback'i
değildir ve hiçbirine verilmez. `limit`, `IntegrationWorkspaceCreate(limit)`
ile ayırılan kapasiteyi aşamaz; böyle bir çağrı GSL'e geçirilmeden durum `1`
ile reddedilir.

Tam bir BASIC kök bulma örneği:

```basic
FUNCTION SqrtTwoResidual(x AS F64) AS F64
    RETURN x * x - 2.0
END FUNCTION

DIM solver AS U64
DIM callbackAddress AS PTR
DIM i AS I32

callbackAddress = CODEPTR(SqrtTwoResidual)
solver = uxgsl.RootBisectionCreate()
ASSERT uxgsl.RootBisectionSet(solver, callbackAddress, 0, 1.0, 2.0) = 1
FOR i = 1 TO 64
    ASSERT uxgsl.RootBisectionIterate(solver) = 1
NEXT i
ASSERT uxgsl.RootBisectionIntervalConverged(solver, 0.000000000001, 0.000000000001) = 1
PRINT uxgsl.RootBisectionRoot(solver)
uxgsl.RootBisectionFree(solver): solver = 0
```

Complex değerler de opak handle'dır; `ComplexAdd` ve `ComplexMultiply` ayrı
bir output handle ister. Bu kural C `gsl_complex` yerleşimini ve sonuç buffer
sahipliğini BASIC programından gizler.

## Hata modeli ve kaynak sahipliği

Sonuç üreten her tipli UXGSL çağrısı çağıran iş parçacığındaki durum değerini
yeniler; `LastStatus`, `LastGslStatus`, `LastError`, `StatusText` ve
`LastEstimatedError` yalnız sorgudur ve değeri değiştirmez.
Başarı değeri `0` olur. Hata veren `F64` fonksiyonları `NaN`
döndürür; uXBasic'te NaN denetimi `value <> value` şeklindedir. Handle üreten
fonksiyonlar başarısızlıkta `0`, doğrulama yapan işlemler ise `0` veya `NaN`
döndürür. Ayrıntıyı hemen ardından alın:

```basic
DIM result AS F64
result = uxgsl.GaussianPdf(0.0, 0.0)
IF result <> result THEN
    PRINT uxgsl.LastError()
    ASSERT uxgsl.LastStatus() = 1
END IF
```

Durum kodları:

| Kod | Anlam |
|---:|---|
| `0` | İşlem başarılı. |
| `1` | Geçersiz parametre veya yetersiz veri. |
| `2` | Yerel bellek ayrılamadı. |
| `3` | Handle sıfır, yanlış türde veya daha önce bırakılmış. |
| `4` | Vector indeksi sınır dışında. |
| `5` | GSL matematiksel tanım kümesi hatası. |
| `6` | GSL taşma/alt-taşma ya da sayısal aralık hatası. |
| `7` | Yukarıdakilere girmeyen GSL hatası. |
| `8` | Matrix boyutları uyumsuz veya çıktı giriş ile aynı handle. |
| `9` | Sıfır ya da senkron C ABI'ye uymayan callback adresi. |

`LastGslStatus`, yalnız GSL'in ürettiği son durum kodunu taşır. UXGSL'in kendi
handle veya parametre hatasında GSL kodu önceki başarılı değer olabilir; asıl
uygulama kararı için `LastStatus` kullanılır.

Her başarılı `RngCreate` için tam bir `RngFree`, her başarılı `VectorCreate`
için tam bir `VectorFree` çağrısı yapılmalıdır. Ardından BASIC değişkenini
hemen `0` yapın; serbest bırakılmış eski pointer'ı hiçbir UXGSL çağrısına
vermeyin. Sıfır, yanlış türde veya hiç oluşturulmamış handle tipli façade
tarafından durum kodu `3` ile reddedilir. Bazı AST yürütme yolları eski bir
pointer token'ını DLL'e ulaşmadan önce ayrıca reddeder; bu nedenle “free'den
sonra kullan” hiçbir backend'de desteklenen bir işlem değildir. Bir handle aynı
anda birden çok iş parçacığı tarafından kullanılmamalıdır. Handle sahiplik
kayıtları DLL içinde eşzamanlı korunur; bu, farklı handle'ların oluşturulup
serbest bırakılmasını güvenli tutar, ancak aynı handle için eşzamanlı erişim
sözleşmesi sağlamaz.

## Ham GSL ve CBlas API'si

Tipli yüzeyde henüz bulunmayan bir GSL çağrısı için `uxcapi` kaçış kapısı
mevcuttur. Önce export adının katalogda yer aldığını doğrulayın; sonra doğru C
imzasını GSL resmi header'ından alın ve çağrı nesnesini açıkça serbest bırakın.

```basic
INCLUDE "include/modules/uxgsl.uxmh"

DIM callHandle AS U64
DIM result AS F64

callHandle = uxgsl.GslCallNew("gsl_sf_bessel_J0", uxcapi.KIND_F64, 0, 1)
ASSERT callHandle <> 0
ASSERT uxcapi.ArgF64(callHandle, 0.0) = 1
ASSERT uxcapi.Invoke(callHandle) = 1
result = uxcapi.ResultF64(callHandle)
uxcapi.CallFree(callHandle)
```

Callback, struct/union, complex değer, `size_t`, fonksiyon-pointer ve
GSL'in sahiplik devri yapan API'leri ham katmanda ileri düzey kullanımdır.
Matrix bunun bilinçli istisnasıdır: v103'te struct, backing buffer, boyut ve
çıktı sahipliği UXGSL tarafından yönetilir. `uxcapi` callback aracı bir dış
çağrıyı senkron BASIC yordamına yönlendirmez; argümanları olay kuyruğuna
yazar ve yapılandırılmış varsayılan dönüş değerini verir. Bu nedenle
`uxcapi.CallbackNew`, `IntegrateQag` veya `RootBisectionSet` için geçerli bir
alternatif değildir; bu iki güvenli UXGSL façade'i yalnız native x64 `CODEPTR`
yordam adresini kabul eder.
Bu sınır kasıtlıdır: yanlış imzalı çağrı belleği bozabileceğinden, belirsiz
kolaylık yerine denetlenebilir bir kaçış kapısı sağlanır.

## Dağıtım ve doğrulama

Windows x64 yerel derlemede `uxgsl.dll`, `libgsl-28.dll` ve
`libgslcblas-0.dll` programın yanında bulunmalıdır. Kütüphane yapım aracı bunu
`bin` ve dağıtım klasörlerine basamaklar. Geliştirici makinesinde GSL 2.8
UCRT64 paketi ve MSYS2 UCRT64 GCC kullanılmaktadır; bağımlılık betiği:

```text
runtime_ext/uxgsl/fetch_uxgsl_deps_msys2.bat
```

Sürüm kapısı en az şunları çalıştırmalıdır:

```text
tests/libraries/uxgsl/uxgsl_smoke.uxb
tests/libraries/uxgsl/uxgsl_safety_smoke.uxb
tests/libraries/uxgsl/uxgsl_full_abi_smoke.uxb
tests/libraries/uxgsl/uxgsl_matrix_smoke.uxb
tests/libraries/uxgsl/uxgsl_matrix_native_smoke.c
tests/libraries/uxgsl/uxgsl_complex_smoke.uxb
tests/libraries/uxgsl/uxgsl_basic_callback_smoke.uxb
tests/libraries/uxgsl/uxgsl_basic_root_bisection_smoke.uxb
```

İlki tipli API'nin temel işlevlerini, ikincisi hata ve serbest-bırakma
sözleşmesini, üçüncüsü ise tipli yüzeyin dışındaki gerçek bir GSL exportunu ve
CBlas sembol çözümlemesini; dördüncüsü matrix struct/buffer sahipliği, boyut
ve output sözleşmesini sınar. Native C smoke aynı DLL sınırında integration,
complex ve bisection sahipliğini de doğrular. Son iki smoke, sırasıyla tek
çağrılık integrasyon callback'ini ve callback'i 64 yineleme boyunca saklayan
bisection çözücüsünü gerçek x64 BASIC yordamıyla çalıştırır.

## Açık yol haritası

1. GSL public header'larından enum, sabit, struct ve sahiplik metadata'sını
   zenginleştirmek; mevcut prototype/export kataloğunu korumak.
2. Diğer güvenli struct aileleri, türev isteyen kök çözücüleri ve complex
   sonuçlar için ownership-aware façade'ler eklemek; v101-v106 yüzeyleri
   geriye uyumlu kalacak.
3. Kullanıcı verisi taşıyan ve çok-parametreli BASIC callback imzaları için
   açık ABI sözleşmesi ve ayrı regresyon matrisi eklemek.
4. Uygun GSL alt kümeleri için JS/WASM dağıtım stratejisi ayrıca tasarlanacak;
   yerel DLL desteği varmış gibi ilan edilmeyecek.

Bu yol haritası, “5.685 export erişilebilir” gerçeğini saklamadan, bunun
“5.685 tipli ve kolay BASIC fonksiyonu hazır” anlamına gelmediğini açıkça
belirtir. UXGSL'nin itibarı, sınırlarını dürüstçe tanımlayıp her sürümde
ölçülebilir biçimde genişletmesinden gelir.
