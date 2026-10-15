# uXBasic Programlayıcının Cep Kitabı — Cilt 4
## Kütüphaneler, Fonksiyon Tabloları ve Kullanım Yolları

Bu ciltte her kütüphane ayrı düşünülür. Kitap varsayımı şudur: kütüphanelerin kodları tamamdır ve değişmeden çalışır. Yine de iyi kullanım için üç kural vardır: başlığı ekle, doğru tipi ver, sonucu test et.

Genel kullanım kalıbı:

```basic
INCLUDE "modules/uxstats.uxmh"
DIM sonuc AS F64
sonuc = CALL uxstats_mean_f64(adres, adet)
PRINT sonuc
```

Dış DLL kalıbı:

```basic
DECLARE FUNCTION Fonksiyon LIB "kutuphane.dll" ALIAS "gercek_ad" (...) AS tip
sonuc = CALL Fonksiyon(...)
```
## `bigfp` — Çok büyük ve yüksek duyarlıklı sayı hesapları.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|__declspec|__declspec(dllimport) int uxb_big_runtime_version(void)|
|2|__declspec|__declspec(dllimport) int uxb_bigf_handle_size(void)|
|3|__declspec|__declspec(dllimport) int uxb_bigd_handle_size(void)|
|4|__declspec|__declspec(dllimport) int uxb_ball_handle_size(void)|
|5|__declspec|__declspec(dllimport) void* uxb_bigf_init(int precision_bits)|
|6|__declspec|__declspec(dllimport) void uxb_bigf_free(void *handle)|
|7|__declspec|__declspec(dllimport) int uxb_bigf_precision(void *handle)|
|8|__declspec|__declspec(dllimport) void uxb_bigf_from_str(const char *src, void *handle)|
|9|__declspec|__declspec(dllimport) void uxb_bigf_to_str(void *handle, char *outBuf, int outBytes)|
|10|__declspec|__declspec(dllimport) void uxb_bigf_copy(void *src, void *outp)|
|11|__declspec|__declspec(dllimport) void uxb_bigf_add(void *a, void *b, void *outp)|
|12|__declspec|__declspec(dllimport) void uxb_bigf_sub(void *a, void *b, void *outp)|
|13|__declspec|__declspec(dllimport) void uxb_bigf_mul(void *a, void *b, void *outp)|
|14|__declspec|__declspec(dllimport) void uxb_bigf_div(void *a, void *b, void *outp)|
|15|__declspec|__declspec(dllimport) int uxb_bigf_cmp(void *a, void *b)|
|16|__declspec|__declspec(dllimport) void* uxb_bigd_init(int decimal_digits)|
|17|__declspec|__declspec(dllimport) void uxb_bigd_free(void *handle)|
|18|__declspec|__declspec(dllimport) int uxb_bigd_precision_digits(void *handle)|
|19|__declspec|__declspec(dllimport) void uxb_bigd_from_str(const char *src, void *handle)|
|20|__declspec|__declspec(dllimport) void uxb_bigd_to_str(void *handle, char *outBuf, int outBytes)|
|21|__declspec|__declspec(dllimport) void uxb_bigd_copy(void *src, void *outp)|
|22|__declspec|__declspec(dllimport) void uxb_bigd_add(void *a, void *b, void *outp)|
|23|__declspec|__declspec(dllimport) void uxb_bigd_sub(void *a, void *b, void *outp)|
|24|__declspec|__declspec(dllimport) void uxb_bigd_mul(void *a, void *b, void *outp)|
|25|__declspec|__declspec(dllimport) void uxb_bigd_div(void *a, void *b, void *outp)|
|26|__declspec|__declspec(dllimport) int uxb_bigd_cmp(void *a, void *b)|
|27|__declspec|__declspec(dllimport) void* uxb_ball_init(int precision_bits)|
|28|__declspec|__declspec(dllimport) void uxb_ball_free(void *handle)|
|29|__declspec|__declspec(dllimport) int uxb_ball_precision(void *handle)|
|30|__declspec|__declspec(dllimport) void uxb_ball_from_str(const char *src, void *handle)|
|31|__declspec|__declspec(dllimport) void uxb_ball_to_str(void *handle, char *outBuf, int outBytes)|
|32|__declspec|__declspec(dllimport) void uxb_ball_copy(void *src, void *outp)|
|33|__declspec|__declspec(dllimport) void uxb_ball_add(void *a, void *b, void *outp)|
|34|__declspec|__declspec(dllimport) void uxb_ball_sub(void *a, void *b, void *outp)|
|35|__declspec|__declspec(dllimport) void uxb_ball_mul(void *a, void *b, void *outp)|
|36|__declspec|__declspec(dllimport) void uxb_ball_div(void *a, void *b, void *outp)|
|37|__declspec|__declspec(dllimport) int uxb_ball_cmp_mid(void *a, void *b)|
### `bigfp` kullanım örneği

```basic
INCLUDE "modules/bigfp.uxmh"
DIM h AS PTR
h = CALL bigfp_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "bigfp hazir"
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `fp128` — 128 bit kayan nokta işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|__declspec|__declspec(dllimport) int uxb_f128_size(void)|
|2|__declspec|__declspec(dllimport) int uxb_f128_storage_size(void)|
|3|__declspec|__declspec(dllimport) void uxb_f128_zero(void *outp)|
|4|__declspec|__declspec(dllimport) void uxb_f128_from_str(const char *src, void *outp)|
|5|__declspec|__declspec(dllimport) void uxb_f128_to_str(const void *a, char *outBuf, int outBytes)|
|6|__declspec|__declspec(dllimport) void uxb_f128_copy(const void *src, void *outp)|
|7|__declspec|__declspec(dllimport) void uxb_f128_add(const void *a, const void *b, void *outp)|
|8|__declspec|__declspec(dllimport) void uxb_f128_sub(const void *a, const void *b, void *outp)|
|9|__declspec|__declspec(dllimport) void uxb_f128_mul(const void *a, const void *b, void *outp)|
|10|__declspec|__declspec(dllimport) void uxb_f128_div(const void *a, const void *b, void *outp)|
|11|__declspec|__declspec(dllimport) int uxb_f128_cmp(const void *a, const void *b)|
### `fp128` kullanım örneği

```basic
INCLUDE "modules/fp128.uxmh"
DIM h AS PTR
h = CALL fp128_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fp128 hazir"
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `fp80` — 80 bit geniş kayan nokta işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1||Declare Function uxb_f80_size CDecl Alias "uxb_f80_size" () As Integer|
|2||Declare Function uxb_f80_storage_size CDecl Alias "uxb_f80_storage_size" () As Integer|
|3||Declare Sub uxb_f80_zero CDecl Alias "uxb_f80_zero" (ByVal outp As Any Ptr)|
|4||Declare Sub uxb_f80_from_str CDecl Alias "uxb_f80_from_str" (ByVal src As ZString Ptr, ByVal outp As Any Ptr)|
|5||Declare Sub uxb_f80_to_str CDecl Alias "uxb_f80_to_str" (ByVal a As Any Ptr, ByVal outBuf As ZString Ptr, ByVal outBytes As Integer)|
|6||Declare Sub uxb_f80_copy CDecl Alias "uxb_f80_copy" (ByVal src As Any Ptr, ByVal outp As Any Ptr)|
|7||Declare Sub uxb_f80_add CDecl Alias "uxb_f80_add" (ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal outp As Any Ptr)|
|8||Declare Sub uxb_f80_sub CDecl Alias "uxb_f80_sub" (ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal outp As Any Ptr)|
|9||Declare Sub uxb_f80_mul CDecl Alias "uxb_f80_mul" (ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal outp As Any Ptr)|
|10||Declare Sub uxb_f80_div CDecl Alias "uxb_f80_div" (ByVal a As Any Ptr, ByVal b As Any Ptr, ByVal outp As Any Ptr)|
|11||Declare Function uxb_f80_cmp CDecl Alias "uxb_f80_cmp" (ByVal a As Any Ptr, ByVal b As Any Ptr) As Integer|
### `fp80` kullanım örneği

```basic
INCLUDE "modules/fp80.uxmh"
DIM h AS PTR
h = CALL fp80_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fp80 hazir"
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `fpcommon` — Geniş sayı ortak yardımcıları.

Bu klasörde başlık prototipi az veya ortak dosyaya bağlıdır. Kullanım için ilgili `.uxmh` başlığı eklenir.

### `fpcommon` kullanım örneği

```basic
INCLUDE "modules/fpcommon.uxmh"
DIM h AS PTR
h = CALL fpcommon_new()
' yüksek duyarlıklı sayı işlemleri burada yapılır
PRINT "fpcommon hazir"
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxaimath` — Yapay zeka matematiği, aktivasyon, kayıp ve optimizasyon.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxaimath_version|UXAI_API int uxaimath_version(void)|
|2|uxaimath_backend|UXAI_API const char* uxaimath_backend(void)|
|3|uxaimath_seed|UXAI_API void uxaimath_seed(uint64_t seed)|
|4|uxaimath_sigmoid|UXAI_API double uxaimath_sigmoid(double x)|
|5|uxaimath_relu|UXAI_API double uxaimath_relu(double x)|
|6|uxaimath_leaky_relu|UXAI_API double uxaimath_leaky_relu(double x, double alpha)|
|7|uxaimath_elu|UXAI_API double uxaimath_elu(double x, double alpha)|
|8|uxaimath_gelu|UXAI_API double uxaimath_gelu(double x)|
|9|uxaimath_swish|UXAI_API double uxaimath_swish(double x)|
|10|uxaimath_softplus|UXAI_API double uxaimath_softplus(double x)|
|11|uxaimath_sigmoid_inplace_f64|UXAI_API void uxaimath_sigmoid_inplace_f64(double* x, int64_t n)|
|12|uxaimath_tanh_inplace_f64|UXAI_API void uxaimath_tanh_inplace_f64(double* x, int64_t n)|
|13|uxaimath_relu_inplace_f64|UXAI_API void uxaimath_relu_inplace_f64(double* x, int64_t n)|
|14|uxaimath_leaky_relu_inplace_f64|UXAI_API void uxaimath_leaky_relu_inplace_f64(double* x, int64_t n, double alpha)|
|15|uxaimath_elu_inplace_f64|UXAI_API void uxaimath_elu_inplace_f64(double* x, int64_t n, double alpha)|
|16|uxaimath_gelu_inplace_f64|UXAI_API void uxaimath_gelu_inplace_f64(double* x, int64_t n)|
|17|uxaimath_swish_inplace_f64|UXAI_API void uxaimath_swish_inplace_f64(double* x, int64_t n)|
|18|uxaimath_softmax_f64|UXAI_API void uxaimath_softmax_f64(const double* x, double* out, int64_t n)|
|19|uxaimath_softmax_inplace_f64|UXAI_API void uxaimath_softmax_inplace_f64(double* x, int64_t n)|
|20|uxaimath_mse_f64|UXAI_API double uxaimath_mse_f64(const double* yt, const double* yp, int64_t n)|
|21|uxaimath_mae_f64|UXAI_API double uxaimath_mae_f64(const double* yt, const double* yp, int64_t n)|
|22|uxaimath_huber_f64|UXAI_API double uxaimath_huber_f64(const double* yt, const double* yp, int64_t n, double delta)|
|23|uxaimath_bce_f64|UXAI_API double uxaimath_bce_f64(const double* yt, const double* yp, int64_t n)|
|24|uxaimath_cce_f64|UXAI_API double uxaimath_cce_f64(const double* yt, const double* yp, int64_t n)|
|25|uxaimath_mse_grad_f64|UXAI_API void uxaimath_mse_grad_f64(const double* yt, const double* yp, double* out, int64_t n)|
|26|uxaimath_bce_grad_f64|UXAI_API void uxaimath_bce_grad_f64(const double* yt, const double* yp, double* out, int64_t n)|
|27|uxaimath_fill_zero_f64|UXAI_API void uxaimath_fill_zero_f64(double* x, int64_t n)|
|28|uxaimath_fill_one_f64|UXAI_API void uxaimath_fill_one_f64(double* x, int64_t n)|
|29|uxaimath_fill_uniform_f64|UXAI_API void uxaimath_fill_uniform_f64(double* x, int64_t n, double lo, double hi)|
|30|uxaimath_fill_normal_f64|UXAI_API void uxaimath_fill_normal_f64(double* x, int64_t n, double mean, double stddev)|
|31|uxaimath_xavier_uniform_f64|UXAI_API void uxaimath_xavier_uniform_f64(double* x, int64_t n, int64_t fan_in, int64_t fan_out)|
|32|uxaimath_he_uniform_f64|UXAI_API void uxaimath_he_uniform_f64(double* x, int64_t n, int64_t fan_in)|
|33|uxaimath_clip_value_f64|UXAI_API void uxaimath_clip_value_f64(double* x, int64_t n, double lo, double hi)|
|34|uxaimath_clip_norm_f64|UXAI_API void uxaimath_clip_norm_f64(double* x, int64_t n, double max_norm)|
|35|uxaimath_sgd_update_f64|UXAI_API void uxaimath_sgd_update_f64(double* param, const double* grad, int64_t n, double lr)|
|36|uxaimath_momentum_update_f64|UXAI_API void uxaimath_momentum_update_f64(double* param, const double* grad, double* velocity, int64_t n, double lr, double momentum)|
|37|uxaimath_dense_forward_f64|UXAI_API void uxaimath_dense_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t in_n, int64_t out_n)|
|38|uxaimath_dense_batch_forward_f64|UXAI_API void uxaimath_dense_batch_forward_f64(const double* x, const double* w, const double* b, double* y, int64_t batch, int64_t in_n, int64_t out_n)|
|39|uxaimath_argmax_f64|UXAI_API int64_t uxaimath_argmax_f64(const double* x, int64_t n)|
|40|uxaimath_binary_accuracy_f64|UXAI_API double uxaimath_binary_accuracy_f64(const double* yt, const double* yp, int64_t n, double threshold)|
### `uxaimath` kullanım örneği

```basic
INCLUDE "modules/uxaimath.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxaimath_sigmoid_f64(x)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxcollections` — Liste, yığın, kuyruk, sözlük, küme, ağaç.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|__declspec|__declspec(dllimport) int uxcollections_version(void)|
|2|__declspec|__declspec(dllimport) int uxcollections_uses_glib(void)|
|3|__declspec|__declspec(dllimport) void* uxc_list_new(void); __declspec(dllimport) void uxc_list_free(void*); __declspec(dllimport) int64_t uxc_list_count(void*)|
|4|__declspec|__declspec(dllimport) void uxc_list_push_f64(void*,double); __declspec(dllimport) double uxc_list_get_f64(void*,int64_t)|
|5|__declspec|__declspec(dllimport) void* uxc_stack_new(void); __declspec(dllimport) void uxc_stack_free(void*); __declspec(dllimport) void uxc_stack_push_f64(void*,double); __declspec(dllimport) double uxc_stack_pop_f64(void*)|
|6|__declspec|__declspec(dllimport) void* uxc_queue_new(void); __declspec(dllimport) void uxc_queue_free(void*); __declspec(dllimport) void uxc_queue_push_f64(void*,double); __declspec(dllimport) double uxc_queue_pop_f64(void*)|
|7|__declspec|__declspec(dllimport) void* uxc_set_new(void); __declspec(dllimport) void uxc_set_free(void*); __declspec(dllimport) void uxc_set_add(void*,const char*); __declspec(dllimport) int uxc_set_contains(void*,const char*)|
### `uxcollections` kullanım örneği

```basic
INCLUDE "modules/uxcollections.uxmh"
DIM l AS PTR
l = CALL uxcollections_list_new()
CALL uxcollections_list_push_f64(l, 3.14)
CALL uxcollections_list_push_f64(l, 2.72)
PRINT CALL uxcollections_list_count(l)
CALL uxcollections_list_free(l)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxdataframe` — Tablo/veri çerçevesi ve SQL benzeri veri işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxdf_runtime_version|UXDF_API int uxdf_runtime_version(void)|
|2|uxdf_duckdb_available|UXDF_API int uxdf_duckdb_available(void)|
|3|uxdf_duckdb_version|UXDF_API const char* uxdf_duckdb_version(void)|
|4|uxdf_last_error|UXDF_API const char* uxdf_last_error(void* df)|
|5|uxdf_open_memory|UXDF_API void* uxdf_open_memory(void)|
|6|uxdf_open_database|UXDF_API void* uxdf_open_database(const char* path)|
|7|uxdf_free|UXDF_API void uxdf_free(void* df)|
|8|uxdf_load_csv|UXDF_API void* uxdf_load_csv(const char* path, int header)|
|9|uxdf_load_parquet|UXDF_API void* uxdf_load_parquet(const char* path)|
|10|uxdf_exec|UXDF_API int uxdf_exec(void* df, const char* sql)|
|11|uxdf_query|UXDF_API void* uxdf_query(void* df, const char* sql)|
|12|uxdf_row_count|UXDF_API long long uxdf_row_count(void* df)|
|13|uxdf_col_count|UXDF_API int uxdf_col_count(void* df)|
|14|uxdf_col_name|UXDF_API const char* uxdf_col_name(void* df, int col)|
|15|uxdf_get_f64|UXDF_API double uxdf_get_f64(void* df, long long row, int col)|
|16|uxdf_get_text|UXDF_API const char* uxdf_get_text(void* df, long long row, int col)|
|17|uxdf_head|UXDF_API void* uxdf_head(void* df, long long n)|
|18|uxdf_select|UXDF_API void* uxdf_select(void* df, const char* columns)|
|19|uxdf_filter|UXDF_API void* uxdf_filter(void* df, const char* where_sql)|
|20|uxdf_order_by|UXDF_API void* uxdf_order_by(void* df, const char* order_sql)|
|21|uxdf_describe|UXDF_API void* uxdf_describe(void* df)|
|22|uxdf_group_mean|UXDF_API void* uxdf_group_mean(void* df, const char* group_col, const char* value_col)|
|23|uxdf_join_inner|UXDF_API void* uxdf_join_inner(void* left, void* right, const char* left_key, const char* right_key)|
|24|uxdf_to_csv|UXDF_API int uxdf_to_csv(void* df, const char* path)|
|25|uxdf_to_parquet|UXDF_API int uxdf_to_parquet(void* df, const char* path)|
|26|uxdf_to_f64_matrix|UXDF_API void* uxdf_to_f64_matrix(void* df)|
|27|uxdf_matrix_free|UXDF_API void uxdf_matrix_free(void* m)|
|28|uxdf_matrix_rows|UXDF_API long long uxdf_matrix_rows(void* m)|
|29|uxdf_matrix_cols|UXDF_API int uxdf_matrix_cols(void* m)|
|30|uxdf_matrix_data_ptr|UXDF_API double* uxdf_matrix_data_ptr(void* m)|
|31|uxdf_matrix_get|UXDF_API double uxdf_matrix_get(void* m, long long row, int col)|
### `uxdataframe` kullanım örneği

```basic
INCLUDE "modules/uxdataframe.uxmh"
PRINT "uxdataframe kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxdataset` — Veri kümesi yükleme, ayırma ve toplu işleme.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxdataset_version|UXD_EXPORT int uxdataset_version(void)|
|2|uxdataset_backend|UXD_EXPORT const char* uxdataset_backend(void)|
|3|uxdataset_create|UXD_EXPORT void* uxdataset_create(int rows, int input_dim, int target_dim)|
|4|uxdataset_free|UXD_EXPORT void uxdataset_free(void* ds)|
|5|uxdataset_clone|UXD_EXPORT void* uxdataset_clone(void* ds)|
|6|uxdataset_load_csv|UXD_EXPORT void* uxdataset_load_csv(const char* path, int input_dim, int target_dim, int has_header)|
|7|uxdataset_save_csv|UXD_EXPORT int uxdataset_save_csv(void* ds, const char* path)|
|8|uxdataset_row_count|UXD_EXPORT int uxdataset_row_count(void* ds)|
|9|uxdataset_input_dim|UXD_EXPORT int uxdataset_input_dim(void* ds)|
|10|uxdataset_target_dim|UXD_EXPORT int uxdataset_target_dim(void* ds)|
|11|uxdataset_x_ptr|UXD_EXPORT double* uxdataset_x_ptr(void* ds)|
|12|uxdataset_y_ptr|UXD_EXPORT double* uxdataset_y_ptr(void* ds)|
|13|uxdataset_get_x|UXD_EXPORT double uxdataset_get_x(void* ds, int row, int col)|
|14|uxdataset_set_x|UXD_EXPORT void uxdataset_set_x(void* ds, int row, int col, double value)|
|15|uxdataset_get_y|UXD_EXPORT double uxdataset_get_y(void* ds, int row, int col)|
|16|uxdataset_set_y|UXD_EXPORT void uxdataset_set_y(void* ds, int row, int col, double value)|
|17|uxdataset_shuffle|UXD_EXPORT void uxdataset_shuffle(void* ds, unsigned long long seed)|
|18|uxdataset_split_train|UXD_EXPORT void* uxdataset_split_train(void* ds, double train_ratio, unsigned long long seed)|
|19|uxdataset_split_test|UXD_EXPORT void* uxdataset_split_test(void* ds, double train_ratio, unsigned long long seed)|
|20|uxdataset_scaler_fit_standard|UXD_EXPORT void* uxdataset_scaler_fit_standard(void* ds)|
|21|uxdataset_scaler_fit_minmax|UXD_EXPORT void* uxdataset_scaler_fit_minmax(void* ds)|
|22|uxdataset_scaler_free|UXD_EXPORT void uxdataset_scaler_free(void* sc)|
|23|uxdataset_scaler_transform|UXD_EXPORT void uxdataset_scaler_transform(void* sc, void* ds)|
|24|uxdataset_scaler_inverse_transform|UXD_EXPORT void uxdataset_scaler_inverse_transform(void* sc, void* ds)|
|25|uxdataset_fill_missing_mean|UXD_EXPORT void uxdataset_fill_missing_mean(void* ds)|
|26|uxdataset_batch_create|UXD_EXPORT void* uxdataset_batch_create(void* ds, int batch_size, int shuffle, unsigned long long seed)|
|27|uxdataset_batch_free|UXD_EXPORT void uxdataset_batch_free(void* loader)|
|28|uxdataset_batch_reset|UXD_EXPORT void uxdataset_batch_reset(void* loader)|
|29|uxdataset_batch_next|UXD_EXPORT int uxdataset_batch_next(void* loader)|
|30|uxdataset_batch_rows|UXD_EXPORT int uxdataset_batch_rows(void* loader)|
|31|uxdataset_batch_x_ptr|UXD_EXPORT double* uxdataset_batch_x_ptr(void* loader)|
|32|uxdataset_batch_y_ptr|UXD_EXPORT double* uxdataset_batch_y_ptr(void* loader)|
|33|uxdataset_batch_get_x|UXD_EXPORT double uxdataset_batch_get_x(void* loader, int row, int col)|
|34|uxdataset_batch_get_y|UXD_EXPORT double uxdataset_batch_get_y(void* loader, int row, int col)|
### `uxdataset` kullanım örneği

```basic
INCLUDE "modules/uxdataset.uxmh"
PRINT "uxdataset kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxgraph` — Graf, düğüm, kenar ve yol analizi.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxgraph_create|UXG_API void* uxgraph_create(int vertices, int directed)|
|2|uxgraph_free|UXG_API void uxgraph_free(void* handle)|
|3|uxgraph_add_vertex|UXG_API int uxgraph_add_vertex(void* handle)|
|4|uxgraph_add_vertices|UXG_API int uxgraph_add_vertices(void* handle, int count)|
|5|uxgraph_add_edge|UXG_API int uxgraph_add_edge(void* handle, int from_v, int to_v)|
|6|uxgraph_vcount|UXG_API int uxgraph_vcount(void* handle)|
|7|uxgraph_ecount|UXG_API int uxgraph_ecount(void* handle)|
|8|uxgraph_is_directed|UXG_API int uxgraph_is_directed(void* handle)|
|9|uxgraph_has_edge|UXG_API int uxgraph_has_edge(void* handle, int from_v, int to_v)|
|10|uxgraph_degree|UXG_API int uxgraph_degree(void* handle, int v)|
|11|uxgraph_in_degree|UXG_API int uxgraph_in_degree(void* handle, int v)|
|12|uxgraph_out_degree|UXG_API int uxgraph_out_degree(void* handle, int v)|
|13|uxgraph_density|UXG_API double uxgraph_density(void* handle)|
|14|uxgraph_self_loops|UXG_API int uxgraph_self_loops(void* handle)|
|15|uxgraph_components_count|UXG_API int uxgraph_components_count(void* handle)|
|16|uxgraph_is_connected|UXG_API int uxgraph_is_connected(void* handle)|
|17|uxgraph_shortest_distance|UXG_API int uxgraph_shortest_distance(void* handle, int source, int target)|
|18|uxgraph_path_exists|UXG_API int uxgraph_path_exists(void* handle, int source, int target)|
|19|uxgraph_triangle_count|UXG_API int uxgraph_triangle_count(void* handle)|
|20|uxgraph_transitivity|UXG_API double uxgraph_transitivity(void* handle)|
|21|uxgraph_degree_vector|UXG_API void* uxgraph_degree_vector(void* handle, int mode)|
|22|uxgraph_bfs_distances|UXG_API void* uxgraph_bfs_distances(void* handle, int source)|
|23|uxgraph_vec_count|UXG_API int uxgraph_vec_count(void* vec_handle)|
|24|uxgraph_vec_get|UXG_API double uxgraph_vec_get(void* vec_handle, int index)|
|25|uxgraph_vec_free|UXG_API void uxgraph_vec_free(void* vec_handle)|
|26|uxgraph_write_edgelist_csv|UXG_API int uxgraph_write_edgelist_csv(void* handle, const char* path)|
|27|uxgraph_read_edgelist_csv|UXG_API void* uxgraph_read_edgelist_csv(const char* path, int directed)|
|28|uxgraph_make_path|UXG_API void* uxgraph_make_path(int vertices, int directed)|
|29|uxgraph_make_cycle|UXG_API void* uxgraph_make_cycle(int vertices, int directed)|
|30|uxgraph_make_complete|UXG_API void* uxgraph_make_complete(int vertices, int directed)|
### `uxgraph` kullanım örneği

```basic
INCLUDE "modules/uxgraph.uxmh"
PRINT "uxgraph kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxllama` — Yerel Llama/LLM köprüsü.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxllama_version|UXLLAMA_API int uxllama_version(void)|
|2|uxllama_create|UXLLAMA_API uxllama_handle uxllama_create(void)|
|3|uxllama_free|UXLLAMA_API void uxllama_free(uxllama_handle h)|
|4|uxllama_set_cli_path|UXLLAMA_API int uxllama_set_cli_path(uxllama_handle h, const char *path)|
|5|uxllama_set_model_path|UXLLAMA_API int uxllama_set_model_path(uxllama_handle h, const char *path)|
|6|uxllama_set_threads|UXLLAMA_API int uxllama_set_threads(uxllama_handle h, int threads)|
|7|uxllama_set_context|UXLLAMA_API int uxllama_set_context(uxllama_handle h, int ctx)|
|8|uxllama_set_predict|UXLLAMA_API int uxllama_set_predict(uxllama_handle h, int n_predict)|
|9|uxllama_set_temperature|UXLLAMA_API int uxllama_set_temperature(uxllama_handle h, double temp)|
|10|uxllama_set_top_p|UXLLAMA_API int uxllama_set_top_p(uxllama_handle h, double top_p)|
|11|uxllama_set_top_k|UXLLAMA_API int uxllama_set_top_k(uxllama_handle h, int top_k)|
|12|uxllama_set_seed|UXLLAMA_API int uxllama_set_seed(uxllama_handle h, int seed)|
|13|uxllama_set_low_memory_profile|UXLLAMA_API int uxllama_set_low_memory_profile(uxllama_handle h, int profile)|
|14|uxllama_model_exists|UXLLAMA_API int uxllama_model_exists(uxllama_handle h)|
|15|uxllama_prompt|UXLLAMA_API int uxllama_prompt(uxllama_handle h, const char *prompt, char *out_buf, int out_bytes)|
|16|uxllama_prompt_file|UXLLAMA_API int uxllama_prompt_file(uxllama_handle h, const char *prompt_file, char *out_buf, int out_bytes)|
|17|uxllama_last_error|UXLLAMA_API int uxllama_last_error(uxllama_handle h, char *out_buf, int out_bytes)|
|18|uxllama_last_command|UXLLAMA_API int uxllama_last_command(uxllama_handle h, char *out_buf, int out_bytes)|
### `uxllama` kullanım örneği

```basic
INCLUDE "modules/uxllama.uxmh"
DIM ctx AS PTR
ctx = CALL uxllama_open("models/llama.gguf")
PRINT CALL uxllama_prompt(ctx, "Merhaba, uXBasic nedir?")
CALL uxllama_close(ctx)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxmath` — Genel matematik kütüphanesi.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxmath_version|UXMATH_API int uxmath_version(void)|
|2|uxmath_vec_create|UXMATH_API void* uxmath_vec_create(int capacity)|
|3|uxmath_vec_free|UXMATH_API void uxmath_vec_free(void* h)|
|4|uxmath_vec_push|UXMATH_API int uxmath_vec_push(void* h, double v)|
|5|uxmath_vec_set|UXMATH_API int uxmath_vec_set(void* h, int idx, double v)|
|6|uxmath_vec_get|UXMATH_API double uxmath_vec_get(void* h, int idx)|
|7|uxmath_vec_count|UXMATH_API int uxmath_vec_count(void* h)|
|8|uxmath_vec_clear|UXMATH_API int uxmath_vec_clear(void* h)|
|9|uxmath_vec_data_ptr|UXMATH_API double* uxmath_vec_data_ptr(void* h)|
|10|uxmath_poly_eval|UXMATH_API double uxmath_poly_eval(void* coeffs, double x)|
|11|uxmath_poly_derivative_eval|UXMATH_API double uxmath_poly_derivative_eval(void* coeffs, double x)|
|12|uxmath_poly_integral_eval|UXMATH_API double uxmath_poly_integral_eval(void* coeffs, double a, double b)|
|13|uxmath_poly_derivative_coeff|UXMATH_API int uxmath_poly_derivative_coeff(void* coeffs, void* out_coeffs)|
|14|uxmath_poly_integral_coeff|UXMATH_API int uxmath_poly_integral_coeff(void* coeffs, void* out_coeffs, double c0)|
|15|uxmath_poly_bisection|UXMATH_API double uxmath_poly_bisection(void* coeffs, double a, double b, int max_iter, double tol)|
|16|uxmath_poly_newton|UXMATH_API double uxmath_poly_newton(void* coeffs, double x0, int max_iter, double tol)|
|17|uxmath_numeric_derivative_poly|UXMATH_API double uxmath_numeric_derivative_poly(void* coeffs, double x, double h)|
|18|uxmath_integrate_poly_simpson|UXMATH_API double uxmath_integrate_poly_simpson(void* coeffs, double a, double b, int n)|
|19|uxmath_ode_rk4_logistic|UXMATH_API double uxmath_ode_rk4_logistic(double y0, double r, double k, double t0, double t1, int steps)|
|20|uxmath_ode_euler_logistic|UXMATH_API double uxmath_ode_euler_logistic(double y0, double r, double k, double t0, double t1, int steps)|
|21|uxmath_sigmoid|UXMATH_API double uxmath_sigmoid(double x)|
|22|uxmath_dsigmoid_from_output|UXMATH_API double uxmath_dsigmoid_from_output(double y)|
|23|uxmath_relu|UXMATH_API double uxmath_relu(double x)|
|24|uxmath_drelu|UXMATH_API double uxmath_drelu(double x)|
|25|uxmath_tanh_act|UXMATH_API double uxmath_tanh_act(double x)|
|26|uxmath_dtanh_from_output|UXMATH_API double uxmath_dtanh_from_output(double y)|
|27|uxmath_vec_softmax|UXMATH_API int uxmath_vec_softmax(void* src, void* dst)|
|28|uxmath_mat_create|UXMATH_API void* uxmath_mat_create(int rows, int cols)|
|29|uxmath_mat_free|UXMATH_API void uxmath_mat_free(void* h)|
|30|uxmath_mat_rows|UXMATH_API int uxmath_mat_rows(void* h)|
|31|uxmath_mat_cols|UXMATH_API int uxmath_mat_cols(void* h)|
|32|uxmath_mat_set|UXMATH_API int uxmath_mat_set(void* h, int row, int col, double v)|
|33|uxmath_mat_get|UXMATH_API double uxmath_mat_get(void* h, int row, int col)|
|34|uxmath_mat_fill|UXMATH_API int uxmath_mat_fill(void* h, double v)|
|35|uxmath_mat_random_uniform|UXMATH_API int uxmath_mat_random_uniform(void* h, double lo, double hi, unsigned int seed)|
|36|uxmath_mat_add|UXMATH_API int uxmath_mat_add(void* a, void* b, void* out)|
|37|uxmath_mat_sub|UXMATH_API int uxmath_mat_sub(void* a, void* b, void* out)|
|38|uxmath_mat_mul|UXMATH_API int uxmath_mat_mul(void* a, void* b, void* out)|
|39|uxmath_mat_transpose|UXMATH_API int uxmath_mat_transpose(void* a, void* out)|
|40|uxmath_mat_apply_sigmoid|UXMATH_API int uxmath_mat_apply_sigmoid(void* a, void* out)|
|41|uxmath_mat_apply_relu|UXMATH_API int uxmath_mat_apply_relu(void* a, void* out)|
|42|uxmath_mat_vec_mul|UXMATH_API int uxmath_mat_vec_mul(void* m, void* v, void* out_vec)|
### `uxmath` kullanım örneği

```basic
INCLUDE "modules/uxmath.uxmh"
PRINT "uxmath kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxmathcore` — Çekirdek matematik ve hızlı sayısal işlemler.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxmathcore_version|UXMATHCORE_API int uxmathcore_version(void)|
|2|uxmathcore_type_size|UXMATHCORE_API int uxmathcore_type_size(int elem_type)|
|3|uxmathcore_type_name|UXMATHCORE_API const char* uxmathcore_type_name(int elem_type)|
|4|uxmathcore_buffer_create|UXMATHCORE_API void* uxmathcore_buffer_create(int elem_type, int count)|
|5|uxmathcore_buffer_create_capacity|UXMATHCORE_API void* uxmathcore_buffer_create_capacity(int elem_type, int count, int capacity)|
|6|uxmathcore_buffer_free|UXMATHCORE_API void uxmathcore_buffer_free(void* h)|
|7|uxmathcore_buffer_type|UXMATHCORE_API int uxmathcore_buffer_type(void* h)|
|8|uxmathcore_buffer_count|UXMATHCORE_API int uxmathcore_buffer_count(void* h)|
|9|uxmathcore_buffer_capacity|UXMATHCORE_API int uxmathcore_buffer_capacity(void* h)|
|10|uxmathcore_buffer_elem_size|UXMATHCORE_API int uxmathcore_buffer_elem_size(void* h)|
|11|uxmathcore_buffer_byte_size|UXMATHCORE_API long long uxmathcore_buffer_byte_size(void* h)|
|12|uxmathcore_buffer_data_ptr|UXMATHCORE_API void* uxmathcore_buffer_data_ptr(void* h)|
|13|uxmathcore_buffer_clear|UXMATHCORE_API int uxmathcore_buffer_clear(void* h)|
|14|uxmathcore_buffer_resize|UXMATHCORE_API int uxmathcore_buffer_resize(void* h, int count)|
|15|uxmathcore_buffer_reserve|UXMATHCORE_API int uxmathcore_buffer_reserve(void* h, int capacity)|
|16|uxmathcore_buffer_fill_zero|UXMATHCORE_API int uxmathcore_buffer_fill_zero(void* h)|
|17|uxmathcore_buffer_clone|UXMATHCORE_API int uxmathcore_buffer_clone(void* src, void** out_handle)|
|18|uxmathcore_buffer_copy|UXMATHCORE_API int uxmathcore_buffer_copy(void* src, void* dst)|
|19|uxmathcore_buffer_slice|UXMATHCORE_API int uxmathcore_buffer_slice(void* src, int start, int count, void** out_handle)|
|20|uxmathcore_buffer_append|UXMATHCORE_API int uxmathcore_buffer_append(void* dst, void* src)|
|21|uxmathcore_buffer_get_f64|UXMATHCORE_API int uxmathcore_buffer_get_f64(void* h, int index, double* out_value)|
|22|uxmathcore_buffer_set_f64|UXMATHCORE_API int uxmathcore_buffer_set_f64(void* h, int index, double value)|
|23|uxmathcore_buffer_push_f64|UXMATHCORE_API int uxmathcore_buffer_push_f64(void* h, double value)|
|24|uxmathcore_buffer_fill_f64|UXMATHCORE_API int uxmathcore_buffer_fill_f64(void* h, double value)|
|25|uxmathcore_buffer_get_i64|UXMATHCORE_API int uxmathcore_buffer_get_i64(void* h, int index, long long* out_value)|
|26|uxmathcore_buffer_set_i64|UXMATHCORE_API int uxmathcore_buffer_set_i64(void* h, int index, long long value)|
|27|uxmathcore_buffer_push_i64|UXMATHCORE_API int uxmathcore_buffer_push_i64(void* h, long long value)|
|28|uxmathcore_buffer_fill_i64|UXMATHCORE_API int uxmathcore_buffer_fill_i64(void* h, long long value)|
|29|uxmathcore_buffer_get_u64|UXMATHCORE_API int uxmathcore_buffer_get_u64(void* h, int index, unsigned long long* out_value)|
|30|uxmathcore_buffer_set_u64|UXMATHCORE_API int uxmathcore_buffer_set_u64(void* h, int index, unsigned long long value)|
|31|uxmathcore_buffer_push_u64|UXMATHCORE_API int uxmathcore_buffer_push_u64(void* h, unsigned long long value)|
|32|uxmathcore_buffer_fill_u64|UXMATHCORE_API int uxmathcore_buffer_fill_u64(void* h, unsigned long long value)|
|33|uxmathcore_buffer_get_byte|UXMATHCORE_API int uxmathcore_buffer_get_byte(void* h, int index, unsigned char* out_value)|
|34|uxmathcore_buffer_set_byte|UXMATHCORE_API int uxmathcore_buffer_set_byte(void* h, int index, unsigned char value)|
|35|uxmathcore_buffer_push_byte|UXMATHCORE_API int uxmathcore_buffer_push_byte(void* h, unsigned char value)|
|36|uxmathcore_buffer_copy_from_ptr|UXMATHCORE_API int uxmathcore_buffer_copy_from_ptr(void* h, const void* src, int elem_count)|
|37|uxmathcore_buffer_copy_to_ptr|UXMATHCORE_API int uxmathcore_buffer_copy_to_ptr(void* h, void* dst, int elem_count)|
|38|uxmathcore_buffer_cast|UXMATHCORE_API int uxmathcore_buffer_cast(void* src, int dst_type, void** out_handle)|
|39|uxmathcore_vec_add_f64|UXMATHCORE_API int uxmathcore_vec_add_f64(void* a, void* b, void* out)|
|40|uxmathcore_vec_sub_f64|UXMATHCORE_API int uxmathcore_vec_sub_f64(void* a, void* b, void* out)|
|41|uxmathcore_vec_mul_f64|UXMATHCORE_API int uxmathcore_vec_mul_f64(void* a, void* b, void* out)|
|42|uxmathcore_vec_div_f64|UXMATHCORE_API int uxmathcore_vec_div_f64(void* a, void* b, void* out)|
|43|uxmathcore_vec_scale_f64|UXMATHCORE_API int uxmathcore_vec_scale_f64(void* a, double scalar, void* out)|
|44|uxmathcore_vec_axpy_f64|UXMATHCORE_API int uxmathcore_vec_axpy_f64(double alpha, void* x, void* y, void* out)|
|45|uxmathcore_vec_dot_f64|UXMATHCORE_API int uxmathcore_vec_dot_f64(void* a, void* b, double* out_value)|
|46|uxmathcore_vec_l1_norm_f64|UXMATHCORE_API int uxmathcore_vec_l1_norm_f64(void* a, double* out_value)|
|47|uxmathcore_vec_l2_norm_f64|UXMATHCORE_API int uxmathcore_vec_l2_norm_f64(void* a, double* out_value)|
|48|uxmathcore_vec_normalize_l2_f64|UXMATHCORE_API int uxmathcore_vec_normalize_l2_f64(void* a, void* out)|
|49|uxmathcore_vec_minmax_f64|UXMATHCORE_API int uxmathcore_vec_minmax_f64(void* a, double* out_min, double* out_max)|
|50|uxmath_version|UXMATHCORE_API int uxmath_version(void)|
|51|uxmath_vec_create|UXMATHCORE_API void* uxmath_vec_create(int capacity)|
|52|uxmath_vec_free|UXMATHCORE_API void uxmath_vec_free(void* h)|
|53|uxmath_vec_push|UXMATHCORE_API int uxmath_vec_push(void* h, double v)|
|54|uxmath_vec_set|UXMATHCORE_API int uxmath_vec_set(void* h, int idx, double v)|
|55|uxmath_vec_get|UXMATHCORE_API double uxmath_vec_get(void* h, int idx)|
|56|uxmath_vec_count|UXMATHCORE_API int uxmath_vec_count(void* h)|
|57|uxmath_vec_clear|UXMATHCORE_API int uxmath_vec_clear(void* h)|
|58|uxmath_vec_data_ptr|UXMATHCORE_API double* uxmath_vec_data_ptr(void* h)|
|59|CALL|/* Convenience return-value wrappers for uXBasic CALL(DLL) usage. */|
|60|uxmathcore_buffer_clone_handle|UXMATHCORE_API void* uxmathcore_buffer_clone_handle(void* src)|
|61|uxmathcore_buffer_slice_handle|UXMATHCORE_API void* uxmathcore_buffer_slice_handle(void* src, int start, int count)|
|62|uxmathcore_buffer_cast_handle|UXMATHCORE_API void* uxmathcore_buffer_cast_handle(void* src, int dst_type)|
|63|uxmathcore_vec_dot_f64_value|UXMATHCORE_API double uxmathcore_vec_dot_f64_value(void* a, void* b)|
|64|uxmathcore_vec_l1_norm_f64_value|UXMATHCORE_API double uxmathcore_vec_l1_norm_f64_value(void* a)|
|65|uxmathcore_vec_l2_norm_f64_value|UXMATHCORE_API double uxmathcore_vec_l2_norm_f64_value(void* a)|
|66|uxmathcore_vec_min_f64_value|UXMATHCORE_API double uxmathcore_vec_min_f64_value(void* a)|
|67|uxmathcore_vec_max_f64_value|UXMATHCORE_API double uxmathcore_vec_max_f64_value(void* a)|
### `uxmathcore` kullanım örneği

```basic
INCLUDE "modules/uxmathcore.uxmh"
PRINT "uxmathcore kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxmatrix` — Matris hesapları.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxmatrix_runtime_version|UXMATRIX_API int uxmatrix_runtime_version(void)|
|2|uxmatrix_create|UXMATRIX_API UXMatrixHandle uxmatrix_create(int rows, int cols)|
|3|uxmatrix_from_array|UXMATRIX_API UXMatrixHandle uxmatrix_from_array(int rows, int cols, const double* data_row_major)|
|4|uxmatrix_free|UXMATRIX_API void uxmatrix_free(UXMatrixHandle h)|
|5|uxmatrix_rows|UXMATRIX_API int uxmatrix_rows(UXMatrixHandle h)|
|6|uxmatrix_cols|UXMATRIX_API int uxmatrix_cols(UXMatrixHandle h)|
|7|uxmatrix_size|UXMATRIX_API int uxmatrix_size(UXMatrixHandle h)|
|8|uxmatrix_data_ptr|UXMATRIX_API double* uxmatrix_data_ptr(UXMatrixHandle h)|
|9|uxmatrix_set|UXMATRIX_API int uxmatrix_set(UXMatrixHandle h, int r, int c, double v)|
|10|uxmatrix_get|UXMATRIX_API double uxmatrix_get(UXMatrixHandle h, int r, int c)|
|11|uxmatrix_fill|UXMATRIX_API int uxmatrix_fill(UXMatrixHandle h, double v)|
|12|uxmatrix_zero|UXMATRIX_API int uxmatrix_zero(UXMatrixHandle h)|
|13|uxmatrix_eye|UXMATRIX_API int uxmatrix_eye(UXMatrixHandle h)|
|14|uxmatrix_clone|UXMATRIX_API UXMatrixHandle uxmatrix_clone(UXMatrixHandle h)|
|15|uxmatrix_transpose|UXMATRIX_API UXMatrixHandle uxmatrix_transpose(UXMatrixHandle a)|
|16|uxmatrix_add|UXMATRIX_API UXMatrixHandle uxmatrix_add(UXMatrixHandle a, UXMatrixHandle b)|
|17|uxmatrix_sub|UXMATRIX_API UXMatrixHandle uxmatrix_sub(UXMatrixHandle a, UXMatrixHandle b)|
|18|uxmatrix_scale|UXMATRIX_API UXMatrixHandle uxmatrix_scale(UXMatrixHandle a, double s)|
|19|uxmatrix_mul|UXMATRIX_API UXMatrixHandle uxmatrix_mul(UXMatrixHandle a, UXMatrixHandle b)|
|20|uxmatrix_matvec|UXMATRIX_API UXMatrixHandle uxmatrix_matvec(UXMatrixHandle a, UXMatrixHandle x_colvec)|
|21|uxmatrix_dot|UXMATRIX_API double uxmatrix_dot(UXMatrixHandle a_colvec, UXMatrixHandle b_colvec)|
|22|uxmatrix_norm_l1|UXMATRIX_API double uxmatrix_norm_l1(UXMatrixHandle a)|
|23|uxmatrix_norm_l2|UXMATRIX_API double uxmatrix_norm_l2(UXMatrixHandle a)|
|24|uxmatrix_norm_fro|UXMATRIX_API double uxmatrix_norm_fro(UXMatrixHandle a)|
|25|uxmatrix_trace|UXMATRIX_API double uxmatrix_trace(UXMatrixHandle a)|
|26|uxmatrix_copy_to_array|UXMATRIX_API int uxmatrix_copy_to_array(UXMatrixHandle h, double* out, int max_count)|
|27|uxmatrix_copy_from_array|UXMATRIX_API int uxmatrix_copy_from_array(UXMatrixHandle h, const double* in, int count)|
|28|uxmatrix_print|UXMATRIX_API int uxmatrix_print(UXMatrixHandle h)|
|29|uxmatrix_solve|UXMATRIX_API int uxmatrix_solve(UXMatrixHandle a, UXMatrixHandle b, UXMatrixHandle* x_out)|
|30|uxmatrix_det|UXMATRIX_API double uxmatrix_det(UXMatrixHandle a)|
|31|uxmatrix_inverse|UXMATRIX_API int uxmatrix_inverse(UXMatrixHandle a, UXMatrixHandle* inv_out)|
|32|uxmatrix_cholesky|UXMATRIX_API int uxmatrix_cholesky(UXMatrixHandle a, UXMatrixHandle* lower_out)|
|33|uxmatrix_qr|UXMATRIX_API int uxmatrix_qr(UXMatrixHandle a, UXMatrixHandle* q_out, UXMatrixHandle* r_out)|
|34|uxmatrix_svd|UXMATRIX_API int uxmatrix_svd(UXMatrixHandle a, UXMatrixHandle* u_out, UXMatrixHandle* s_colvec_out, UXMatrixHandle* vt_out)|
|35|uxmatrix_eigen_symmetric|UXMATRIX_API int uxmatrix_eigen_symmetric(UXMatrixHandle a, UXMatrixHandle* values_colvec_out, UXMatrixHandle* vectors_out)|
|36|uxmatrix_solve_new|UXMATRIX_API UXMatrixHandle uxmatrix_solve_new(UXMatrixHandle a, UXMatrixHandle b)|
|37|uxmatrix_inverse_new|UXMATRIX_API UXMatrixHandle uxmatrix_inverse_new(UXMatrixHandle a)|
|38|uxmatrix_cholesky_new|UXMATRIX_API UXMatrixHandle uxmatrix_cholesky_new(UXMatrixHandle a)|
|39|uxmatrix_rank_svd|UXMATRIX_API int uxmatrix_rank_svd(UXMatrixHandle a, double tol)|
|40|uxmatrix_cond2|UXMATRIX_API double uxmatrix_cond2(UXMatrixHandle a)|
|41|uxmatrix_blas_ddot|UXMATRIX_API double uxmatrix_blas_ddot(int n, const double* x, int incx, const double* y, int incy)|
|42|uxmatrix_blas_daxpy|UXMATRIX_API int uxmatrix_blas_daxpy(int n, double alpha, const double* x, int incx, double* y, int incy)|
|43|uxmatrix_blas_dgemm_rowmajor|UXMATRIX_API int uxmatrix_blas_dgemm_rowmajor(int m, int n, int k, double alpha, const double* A, const double* B, double beta, double* C)|
### `uxmatrix` kullanım örneği

```basic
INCLUDE "modules/uxmatrix.uxmh"
DIM A AS PTR
A = CALL uxmatrix_create(3, 3)
CALL uxmatrix_set(A, 1, 1, 1.0)
PRINT CALL uxmatrix_get(A, 1, 1)
CALL uxmatrix_free(A)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxnn` — Sinir ağı temel işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxnn_version|UXNN_API int uxnn_version(void)|
|2|uxnn_backend|UXNN_API const char* uxnn_backend(void)|
|3|uxnn_seed|UXNN_API void uxnn_seed(unsigned long long seed)|
|4|uxnn_neuron_create|UXNN_API void* uxnn_neuron_create(int input_count, int activation)|
|5|uxnn_neuron_free|UXNN_API void uxnn_neuron_free(void* h)|
|6|uxnn_neuron_set_weight|UXNN_API void uxnn_neuron_set_weight(void* h, int idx, double v)|
|7|uxnn_neuron_get_weight|UXNN_API double uxnn_neuron_get_weight(void* h, int idx)|
|8|uxnn_neuron_set_bias|UXNN_API void uxnn_neuron_set_bias(void* h, double v)|
|9|uxnn_neuron_get_bias|UXNN_API double uxnn_neuron_get_bias(void* h)|
|10|uxnn_neuron_forward_ptr|UXNN_API double uxnn_neuron_forward_ptr(void* h, const double* input)|
|11|uxnn_layer_dense_create|UXNN_API void* uxnn_layer_dense_create(int input_dim, int output_dim, int activation)|
|12|uxnn_layer_activation_create|UXNN_API void* uxnn_layer_activation_create(int dim, int activation)|
|13|uxnn_layer_free|UXNN_API void uxnn_layer_free(void* layer)|
|14|uxnn_layer_input_dim|UXNN_API int uxnn_layer_input_dim(void* layer)|
|15|uxnn_layer_output_dim|UXNN_API int uxnn_layer_output_dim(void* layer)|
|16|uxnn_layer_set_weight|UXNN_API void uxnn_layer_set_weight(void* layer, int out_idx, int in_idx, double v)|
|17|uxnn_layer_get_weight|UXNN_API double uxnn_layer_get_weight(void* layer, int out_idx, int in_idx)|
|18|uxnn_layer_set_bias|UXNN_API void uxnn_layer_set_bias(void* layer, int out_idx, double v)|
|19|uxnn_layer_get_bias|UXNN_API double uxnn_layer_get_bias(void* layer, int out_idx)|
|20|uxnn_layer_init|UXNN_API void uxnn_layer_init(void* layer, int init_kind, double scale)|
|21|uxnn_layer_forward_ptr|UXNN_API void uxnn_layer_forward_ptr(void* layer, const double* input, double* output)|
|22|uxnn_network_create|UXNN_API void* uxnn_network_create(void)|
|23|uxnn_network_free|UXNN_API void uxnn_network_free(void* net)|
|24|uxnn_network_add_layer|UXNN_API int uxnn_network_add_layer(void* net, void* layer)|
|25|uxnn_network_layer_count|UXNN_API int uxnn_network_layer_count(void* net)|
|26|uxnn_network_input_dim|UXNN_API int uxnn_network_input_dim(void* net)|
|27|uxnn_network_output_dim|UXNN_API int uxnn_network_output_dim(void* net)|
|28|uxnn_network_forward_ptr|UXNN_API void uxnn_network_forward_ptr(void* net, const double* input, double* output)|
|29|uxnn_network_predict_argmax_ptr|UXNN_API int uxnn_network_predict_argmax_ptr(void* net, const double* input)|
|30|uxnn_network_mse_ptr|UXNN_API double uxnn_network_mse_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim)|
|31|uxnn_network_train_mse_sgd_ptr|UXNN_API double uxnn_network_train_mse_sgd_ptr(void* net, const double* x, const double* y, int sample_count, int input_dim, int output_dim, int epochs, double lr)|
### `uxnn` kullanım örneği

```basic
INCLUDE "modules/uxnn.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn_sigmoid_f64(x)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxnn2` — Sinir ağı ikinci seviye işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxnn2_version|UXNN2_EXPORT int uxnn2_version(void)|
|2|uxnn2_backend|UXNN2_EXPORT const char* uxnn2_backend(void)|
|3|uxnn2_seed|UXNN2_EXPORT void uxnn2_seed(unsigned long long seed)|
|4|uxnn2_network_create|UXNN2_EXPORT void* uxnn2_network_create(int input_dim)|
|5|uxnn2_network_free|UXNN2_EXPORT void uxnn2_network_free(void* net)|
|6|uxnn2_network_add_dense|UXNN2_EXPORT int uxnn2_network_add_dense(void* net, int output_dim, int activation)|
|7|uxnn2_network_layer_count|UXNN2_EXPORT int uxnn2_network_layer_count(void* net)|
|8|uxnn2_network_input_dim|UXNN2_EXPORT int uxnn2_network_input_dim(void* net)|
|9|uxnn2_network_output_dim|UXNN2_EXPORT int uxnn2_network_output_dim(void* net)|
|10|uxnn2_network_init|UXNN2_EXPORT void uxnn2_network_init(void* net, int init_kind, double scale)|
|11|uxnn2_set_optimizer|UXNN2_EXPORT void uxnn2_set_optimizer(void* net, int opt_kind, double learning_rate)|
|12|uxnn2_set_optimizer_params|UXNN2_EXPORT void uxnn2_set_optimizer_params(void* net, double beta1, double beta2, double epsilon, double weight_decay)|
|13|uxnn2_forward_ptr|UXNN2_EXPORT void uxnn2_forward_ptr(void* net, const double* input, double* output)|
|14|uxnn2_loss_mse_ptr|UXNN2_EXPORT double uxnn2_loss_mse_ptr(void* net, const double* input, const double* target)|
|15|uxnn2_train_sample_mse_ptr|UXNN2_EXPORT double uxnn2_train_sample_mse_ptr(void* net, const double* input, const double* target)|
|16|uxnn2_train_array_mse_ptr|UXNN2_EXPORT double uxnn2_train_array_mse_ptr(void* net, const double* x, const double* y, int sample_count, int epochs, int shuffle)|
|17|uxnn2_predict_argmax_ptr|UXNN2_EXPORT int uxnn2_predict_argmax_ptr(void* net, const double* input)|
|18|uxnn2_get_weight|UXNN2_EXPORT double uxnn2_get_weight(void* net, int layer_index, int out_index, int in_index)|
|19|uxnn2_set_weight|UXNN2_EXPORT void uxnn2_set_weight(void* net, int layer_index, int out_index, int in_index, double value)|
|20|uxnn2_get_bias|UXNN2_EXPORT double uxnn2_get_bias(void* net, int layer_index, int out_index)|
|21|uxnn2_set_bias|UXNN2_EXPORT void uxnn2_set_bias(void* net, int layer_index, int out_index, double value)|
|22|uxnn2_save|UXNN2_EXPORT int uxnn2_save(void* net, const char* path)|
|23|uxnn2_load|UXNN2_EXPORT void* uxnn2_load(const char* path)|
### `uxnn2` kullanım örneği

```basic
INCLUDE "modules/uxnn2.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn2_sigmoid_f64(x)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxnn3` — Sinir ağı ileri seviye işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxnn3_version|UXNN3_API int uxnn3_version(void)|
|2|uxnn3_last_error|UXNN3_API const char* uxnn3_last_error(void)|
|3|uxnn3_dataset_create|UXNN3_API void* uxnn3_dataset_create(int rows, int input_dim, int output_dim)|
|4|uxnn3_dataset_free|UXNN3_API void uxnn3_dataset_free(void* ds)|
|5|uxnn3_dataset_load_csv|UXNN3_API void* uxnn3_dataset_load_csv(const char* path, int input_dim, int output_dim, int has_header)|
|6|uxnn3_dataset_save_csv|UXNN3_API int uxnn3_dataset_save_csv(void* ds, const char* path, int include_header)|
|7|uxnn3_dataset_rows|UXNN3_API int uxnn3_dataset_rows(void* ds)|
|8|uxnn3_dataset_input_dim|UXNN3_API int uxnn3_dataset_input_dim(void* ds)|
|9|uxnn3_dataset_output_dim|UXNN3_API int uxnn3_dataset_output_dim(void* ds)|
|10|uxnn3_dataset_x_get|UXNN3_API double uxnn3_dataset_x_get(void* ds, int row, int col)|
|11|uxnn3_dataset_y_get|UXNN3_API double uxnn3_dataset_y_get(void* ds, int row, int col)|
|12|uxnn3_dataset_x_set|UXNN3_API int uxnn3_dataset_x_set(void* ds, int row, int col, double v)|
|13|uxnn3_dataset_y_set|UXNN3_API int uxnn3_dataset_y_set(void* ds, int row, int col, double v)|
|14|uxnn3_dataset_x_ptr|UXNN3_API double* uxnn3_dataset_x_ptr(void* ds)|
|15|uxnn3_dataset_y_ptr|UXNN3_API double* uxnn3_dataset_y_ptr(void* ds)|
|16|uxnn3_dataset_shuffle|UXNN3_API int uxnn3_dataset_shuffle(void* ds, unsigned int seed)|
|17|uxnn3_dataset_split_train|UXNN3_API void* uxnn3_dataset_split_train(void* ds, double train_ratio, unsigned int seed)|
|18|uxnn3_dataset_split_test|UXNN3_API void* uxnn3_dataset_split_test(void* ds, double train_ratio, unsigned int seed)|
|19|uxnn3_dataset_standardize_fit_transform|UXNN3_API int uxnn3_dataset_standardize_fit_transform(void* ds)|
|20|uxnn3_dataset_minmax_fit_transform|UXNN3_API int uxnn3_dataset_minmax_fit_transform(void* ds, double a, double b)|
|21|uxnn3_model_create|UXNN3_API void* uxnn3_model_create(int input_dim)|
|22|uxnn3_model_free|UXNN3_API void uxnn3_model_free(void* model)|
|23|uxnn3_model_add_dense|UXNN3_API int uxnn3_model_add_dense(void* model, int output_dim, int activation)|
|24|uxnn3_model_init|UXNN3_API int uxnn3_model_init(void* model, unsigned int seed, double scale)|
|25|uxnn3_model_set_optimizer|UXNN3_API int uxnn3_model_set_optimizer(void* model, int optimizer, double lr, double momentum)|
|26|uxnn3_model_layer_count|UXNN3_API int uxnn3_model_layer_count(void* model)|
|27|uxnn3_model_output_dim|UXNN3_API int uxnn3_model_output_dim(void* model)|
|28|uxnn3_model_forward1|UXNN3_API double uxnn3_model_forward1(void* model, const double* x, double* out)|
|29|uxnn3_model_predict_dataset|UXNN3_API double uxnn3_model_predict_dataset(void* model, void* ds, int row, double* out)|
|30|uxnn3_model_predict_argmax|UXNN3_API int uxnn3_model_predict_argmax(void* model, void* ds, int row)|
|31|uxnn3_model_train_dataset|UXNN3_API double uxnn3_model_train_dataset(void* model, void* ds, int epochs, int batch_size, int shuffle, unsigned int seed)|
|32|uxnn3_model_eval_mse|UXNN3_API double uxnn3_model_eval_mse(void* model, void* ds)|
|33|uxnn3_model_eval_binary_accuracy|UXNN3_API double uxnn3_model_eval_binary_accuracy(void* model, void* ds, double threshold)|
|34|uxnn3_model_save|UXNN3_API int uxnn3_model_save(void* model, const char* path)|
|35|uxnn3_model_load|UXNN3_API void* uxnn3_model_load(const char* path)|
### `uxnn3` kullanım örneği

```basic
INCLUDE "modules/uxnn3.uxmh"
DIM x AS F64
x = 0.75
PRINT CALL uxnn3_sigmoid_f64(x)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxonnx` — ONNX model yükleme/çalıştırma köprüsü.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxonnx_global_init|UXONNX_API int uxonnx_global_init(const char *runtime_dir)|
|2|uxonnx_runtime_version|UXONNX_API const char* uxonnx_runtime_version(void)|
|3|uxonnx_last_error|UXONNX_API const char* uxonnx_last_error(void *session_handle)|
|4|uxonnx_session_create|UXONNX_API void* uxonnx_session_create(const char *model_path, int intra_threads)|
|5|uxonnx_session_free|UXONNX_API void uxonnx_session_free(void *session_handle)|
|6|uxonnx_input_count|UXONNX_API long long uxonnx_input_count(void *session_handle)|
|7|uxonnx_output_count|UXONNX_API long long uxonnx_output_count(void *session_handle)|
|8|uxonnx_input_name|UXONNX_API const char* uxonnx_input_name(void *session_handle, long long index)|
|9|uxonnx_output_name|UXONNX_API const char* uxonnx_output_name(void *session_handle, long long index)|
|10|uxonnx_tensor_create_f32|UXONNX_API void* uxonnx_tensor_create_f32(const long long *shape, long long rank)|
|11|uxonnx_tensor_create_1d_f32|UXONNX_API void* uxonnx_tensor_create_1d_f32(long long n)|
|12|uxonnx_tensor_create_2d_f32|UXONNX_API void* uxonnx_tensor_create_2d_f32(long long r, long long c)|
|13|uxonnx_tensor_create_3d_f32|UXONNX_API void* uxonnx_tensor_create_3d_f32(long long a, long long b, long long c)|
|14|uxonnx_tensor_create_4d_f32|UXONNX_API void* uxonnx_tensor_create_4d_f32(long long a, long long b, long long c, long long d)|
|15|uxonnx_tensor_free|UXONNX_API void uxonnx_tensor_free(void *tensor_handle)|
|16|uxonnx_tensor_count|UXONNX_API long long uxonnx_tensor_count(void *tensor_handle)|
|17|uxonnx_tensor_rank|UXONNX_API long long uxonnx_tensor_rank(void *tensor_handle)|
|18|uxonnx_tensor_dim|UXONNX_API long long uxonnx_tensor_dim(void *tensor_handle, long long axis)|
|19|uxonnx_tensor_data_ptr|UXONNX_API float* uxonnx_tensor_data_ptr(void *tensor_handle)|
|20|uxonnx_tensor_set_f32|UXONNX_API void uxonnx_tensor_set_f32(void *tensor_handle, long long index, double value)|
|21|uxonnx_tensor_get_f32|UXONNX_API double uxonnx_tensor_get_f32(void *tensor_handle, long long index)|
|22|uxonnx_run1_f32|UXONNX_API void* uxonnx_run1_f32(void *session_handle, const char *input_name, void *input_tensor_handle, const char *output_name)|
### `uxonnx` kullanım örneği

```basic
INCLUDE "modules/uxonnx.uxmh"
PRINT "uxonnx kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxonnx2` — ONNX gelişmiş yardımcıları.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxonnx2_init|UXONNX2_API int uxonnx2_init(const char *runtime_dir)|
|2|uxonnx2_version|UXONNX2_API const char* uxonnx2_version(void)|
|3|uxonnx2_last_error|UXONNX2_API const char* uxonnx2_last_error(void)|
|4|uxonnx2_provider_available|UXONNX2_API int uxonnx2_provider_available(int provider)|
|5|uxonnx2_session_create|UXONNX2_API void* uxonnx2_session_create(const char *model_path)|
|6|uxonnx2_session_create_advanced|UXONNX2_API void* uxonnx2_session_create_advanced(const char *model_path, int provider, int intra_threads, int inter_threads, int graph_opt)|
|7|uxonnx2_session_free|UXONNX2_API void uxonnx2_session_free(void *session)|
|8|uxonnx2_session_input_count|UXONNX2_API long long uxonnx2_session_input_count(void *session)|
|9|uxonnx2_session_output_count|UXONNX2_API long long uxonnx2_session_output_count(void *session)|
|10|uxonnx2_session_input_name|UXONNX2_API const char* uxonnx2_session_input_name(void *session, long long idx)|
|11|uxonnx2_session_output_name|UXONNX2_API const char* uxonnx2_session_output_name(void *session, long long idx)|
|12|uxonnx2_session_input_dtype|UXONNX2_API int uxonnx2_session_input_dtype(void *session, long long idx)|
|13|uxonnx2_session_output_dtype|UXONNX2_API int uxonnx2_session_output_dtype(void *session, long long idx)|
|14|uxonnx2_session_input_rank|UXONNX2_API long long uxonnx2_session_input_rank(void *session, long long idx)|
|15|uxonnx2_session_output_rank|UXONNX2_API long long uxonnx2_session_output_rank(void *session, long long idx)|
|16|uxonnx2_session_input_dim|UXONNX2_API long long uxonnx2_session_input_dim(void *session, long long idx, long long axis)|
|17|uxonnx2_session_output_dim|UXONNX2_API long long uxonnx2_session_output_dim(void *session, long long idx, long long axis)|
|18|uxonnx2_tensor_create|UXONNX2_API void* uxonnx2_tensor_create(const long long *shape, long long rank, int dtype)|
|19|uxonnx2_tensor_create_1d|UXONNX2_API void* uxonnx2_tensor_create_1d(int dtype, long long n)|
|20|uxonnx2_tensor_create_2d|UXONNX2_API void* uxonnx2_tensor_create_2d(int dtype, long long r, long long c)|
|21|uxonnx2_tensor_create_3d|UXONNX2_API void* uxonnx2_tensor_create_3d(int dtype, long long a, long long b, long long c)|
|22|uxonnx2_tensor_create_4d|UXONNX2_API void* uxonnx2_tensor_create_4d(int dtype, long long a, long long b, long long c, long long d)|
|23|uxonnx2_tensor_free|UXONNX2_API void uxonnx2_tensor_free(void *tensor)|
|24|uxonnx2_tensor_dtype|UXONNX2_API int uxonnx2_tensor_dtype(void *tensor)|
|25|uxonnx2_tensor_rank|UXONNX2_API long long uxonnx2_tensor_rank(void *tensor)|
|26|uxonnx2_tensor_dim|UXONNX2_API long long uxonnx2_tensor_dim(void *tensor, long long axis)|
|27|uxonnx2_tensor_count|UXONNX2_API long long uxonnx2_tensor_count(void *tensor)|
|28|uxonnx2_tensor_data_ptr|UXONNX2_API void* uxonnx2_tensor_data_ptr(void *tensor)|
|29|uxonnx2_tensor_set_f64|UXONNX2_API void uxonnx2_tensor_set_f64(void *tensor, long long idx, double value)|
|30|uxonnx2_tensor_get_f64|UXONNX2_API double uxonnx2_tensor_get_f64(void *tensor, long long idx)|
|31|uxonnx2_tensor_set_i64|UXONNX2_API void uxonnx2_tensor_set_i64(void *tensor, long long idx, long long value)|
|32|uxonnx2_tensor_get_i64|UXONNX2_API long long uxonnx2_tensor_get_i64(void *tensor, long long idx)|
|33|uxonnx2_tensor_set_string|UXONNX2_API void uxonnx2_tensor_set_string(void *tensor, long long idx, const char *value)|
|34|uxonnx2_tensor_get_string|UXONNX2_API const char* uxonnx2_tensor_get_string(void *tensor, long long idx)|
|35|uxonnx2_run_create|UXONNX2_API void* uxonnx2_run_create(void *session)|
|36|uxonnx2_run_free|UXONNX2_API void uxonnx2_run_free(void *run)|
|37|uxonnx2_run_add_input|UXONNX2_API int uxonnx2_run_add_input(void *run, const char *name, void *tensor)|
|38|uxonnx2_run_add_output|UXONNX2_API int uxonnx2_run_add_output(void *run, const char *name)|
|39|uxonnx2_run_execute|UXONNX2_API void* uxonnx2_run_execute(void *run)|
|40|uxonnx2_result_free|UXONNX2_API void uxonnx2_result_free(void *result)|
|41|uxonnx2_result_count|UXONNX2_API long long uxonnx2_result_count(void *result)|
|42|uxonnx2_result_tensor|UXONNX2_API void* uxonnx2_result_tensor(void *result, long long idx)|
|43|uxonnx2_run1|UXONNX2_API void* uxonnx2_run1(void *session, const char *input_name, void *input_tensor, const char *output_name)|
### `uxonnx2` kullanım örneği

```basic
INCLUDE "modules/uxonnx2.uxmh"
PRINT "uxonnx2 kutuphanesi yuklendi"
' ilgili fonksiyonu CALL ile cagir.
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxstats` — Temel istatistik.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxstats_version|UXSTATS_IMPORT int uxstats_version(void)|
|2|uxstats_vec_create|UXSTATS_IMPORT void* uxstats_vec_create(int capacity)|
|3|uxstats_vec_free|UXSTATS_IMPORT void uxstats_vec_free(void *handle)|
|4|uxstats_vec_clear|UXSTATS_IMPORT void uxstats_vec_clear(void *handle)|
|5|uxstats_vec_count|UXSTATS_IMPORT int uxstats_vec_count(void *handle)|
|6|uxstats_vec_capacity|UXSTATS_IMPORT int uxstats_vec_capacity(void *handle)|
|7|uxstats_vec_push|UXSTATS_IMPORT int uxstats_vec_push(void *handle, double value)|
|8|uxstats_vec_set|UXSTATS_IMPORT int uxstats_vec_set(void *handle, int index, double value)|
|9|uxstats_vec_get|UXSTATS_IMPORT double uxstats_vec_get(void *handle, int index)|
|10|uxstats_vec_sum|UXSTATS_IMPORT double uxstats_vec_sum(void *handle)|
|11|uxstats_vec_mean|UXSTATS_IMPORT double uxstats_vec_mean(void *handle)|
|12|uxstats_vec_min|UXSTATS_IMPORT double uxstats_vec_min(void *handle)|
|13|uxstats_vec_max|UXSTATS_IMPORT double uxstats_vec_max(void *handle)|
|14|uxstats_vec_range|UXSTATS_IMPORT double uxstats_vec_range(void *handle)|
|15|uxstats_vec_variance_pop|UXSTATS_IMPORT double uxstats_vec_variance_pop(void *handle)|
|16|uxstats_vec_variance_samp|UXSTATS_IMPORT double uxstats_vec_variance_samp(void *handle)|
|17|uxstats_vec_stddev_pop|UXSTATS_IMPORT double uxstats_vec_stddev_pop(void *handle)|
|18|uxstats_vec_stddev_samp|UXSTATS_IMPORT double uxstats_vec_stddev_samp(void *handle)|
|19|uxstats_vec_median|UXSTATS_IMPORT double uxstats_vec_median(void *handle)|
|20|uxstats_vec_percentile|UXSTATS_IMPORT double uxstats_vec_percentile(void *handle, double p)|
|21|uxstats_vec_covariance_samp|UXSTATS_IMPORT double uxstats_vec_covariance_samp(void *hx, void *hy)|
|22|uxstats_vec_correlation|UXSTATS_IMPORT double uxstats_vec_correlation(void *hx, void *hy)|
|23|uxstats_vec_regression_slope|UXSTATS_IMPORT double uxstats_vec_regression_slope(void *hx, void *hy)|
|24|uxstats_vec_regression_intercept|UXSTATS_IMPORT double uxstats_vec_regression_intercept(void *hx, void *hy)|
|25|uxstats_vec_regression_r2|UXSTATS_IMPORT double uxstats_vec_regression_r2(void *hx, void *hy)|
|26|uxstats_mean_f64|UXSTATS_IMPORT double uxstats_mean_f64(const double *x, int n)|
|27|uxstats_stddev_samp_f64|UXSTATS_IMPORT double uxstats_stddev_samp_f64(const double *x, int n)|
### `uxstats` kullanım örneği

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

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxstats2` — İleri istatistik testleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|__declspec|__declspec(dllimport) int uxstats2_version(void)|
|2|__declspec|__declspec(dllimport) void* uxstats2_vec_create(int32_t capacity)|
|3|__declspec|__declspec(dllimport) void uxstats2_vec_free(void *h)|
|4|__declspec|__declspec(dllimport) int32_t uxstats2_vec_push(void *h, double value)|
|5|__declspec|__declspec(dllimport) int32_t uxstats2_vec_set(void *h, int32_t index, double value)|
|6|__declspec|__declspec(dllimport) double uxstats2_vec_get(void *h, int32_t index)|
|7|__declspec|__declspec(dllimport) int32_t uxstats2_vec_count(void *h)|
|8|__declspec|__declspec(dllimport) double uxstats2_one_sample_t_stat(void*h,double mu0)|
|9|__declspec|__declspec(dllimport) double uxstats2_one_sample_t_p(void*h,double mu0)|
|10|__declspec|__declspec(dllimport) double uxstats2_welch_t_stat(void*x,void*y)|
|11|__declspec|__declspec(dllimport) double uxstats2_welch_t_p(void*x,void*y)|
|12|__declspec|__declspec(dllimport) double uxstats2_pooled_t_stat(void*x,void*y)|
|13|__declspec|__declspec(dllimport) double uxstats2_pooled_t_p(void*x,void*y)|
|14|__declspec|__declspec(dllimport) double uxstats2_paired_t_stat(void*b,void*a)|
|15|__declspec|__declspec(dllimport) double uxstats2_paired_t_p(void*b,void*a)|
|16|__declspec|__declspec(dllimport) double uxstats2_one_sample_z_p(void*h,double mu0,double sigma)|
|17|__declspec|__declspec(dllimport) double uxstats2_two_sample_z_p(void*x,void*y,double sx,double sy)|
|18|__declspec|__declspec(dllimport) double uxstats2_one_prop_z_p(int32_t s,int32_t n,double p0)|
|19|__declspec|__declspec(dllimport) double uxstats2_two_prop_z_p(int32_t s1,int32_t n1,int32_t s2,int32_t n2)|
|20|__declspec|__declspec(dllimport) double uxstats2_f_variance_p(void*x,void*y)|
|21|__declspec|__declspec(dllimport) double uxstats2_chisq_gof_p(void*o,void*e)|
|22|__declspec|__declspec(dllimport) double uxstats2_chisq_2x2_p(double a,double b,double c,double d)|
|23|__declspec|__declspec(dllimport) double uxstats2_anova_oneway_f(void*v,void*g)|
|24|__declspec|__declspec(dllimport) double uxstats2_anova_oneway_p(void*v,void*g)|
|25|__declspec|__declspec(dllimport) double uxstats2_posthoc_bonferroni_t_p(void*v,void*g,double g1,double g2,int32_t comparisons)|
|26|__declspec|__declspec(dllimport) double uxstats2_posthoc_tukey_q(void*v,void*g,double g1,double g2)|
|27|__declspec|__declspec(dllimport) double uxstats2_posthoc_scheffe_f(void*v,void*g,double g1,double g2)|
|28|__declspec|__declspec(dllimport) double uxstats2_covariance_samp(void*x,void*y)|
|29|__declspec|__declspec(dllimport) double uxstats2_correlation(void*x,void*y)|
|30|__declspec|__declspec(dllimport) double uxstats2_regression_slope(void*x,void*y)|
|31|__declspec|__declspec(dllimport) double uxstats2_regression_intercept(void*x,void*y)|
|32|__declspec|__declspec(dllimport) double uxstats2_regression_r2(void*x,void*y)|
|33|__declspec|__declspec(dllimport) double uxstats2_regression_f_p(void*x,void*y)|
|34|__declspec|__declspec(dllimport) double uxstats2_vif_pair(void*x,void*y)|
|35|__declspec|__declspec(dllimport) double uxstats2_durbin_watson(void*e)|
|36|__declspec|__declspec(dllimport) double uxstats2_breusch_godfrey_p(void*e,int32_t lags)|
|37|__declspec|__declspec(dllimport) double uxstats2_adf_stat(void*y)|
|38|__declspec|__declspec(dllimport) double uxstats2_adf_p_approx(void*y)|
|39|__declspec|__declspec(dllimport) double uxstats2_ancova_binary_p(void*y,void*x,void*g,double g1,double g2)|
|40|__declspec|__declspec(dllimport) double uxstats2_hotelling_p_2d(void*x1,void*x2,void*g,double g1,double g2)|
### `uxstats2` kullanım örneği

```basic
INCLUDE "modules/uxstats2.uxmh"
DIM z AS F64
z = CALL uxstats2_one_sample_z(105.0, 100.0, 15.0, 36)
PRINT "Z=" + STR(z)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

## `uxtensor` — Çok boyutlu tensör işlemleri.

|No|Fonksiyon|Dış söz dizimi / prototip|
|---|---|---|
|1|uxtensor_version|UXTENSOR_API int uxtensor_version(void)|
|2|uxtensor_backend|UXTENSOR_API const char* uxtensor_backend(void)|
|3|uxtensor_create|UXTENSOR_API void* uxtensor_create(int dtype, int ndim, const long long* shape)|
|4|uxtensor_create1d_f64|UXTENSOR_API void* uxtensor_create1d_f64(long long n)|
|5|uxtensor_create2d_f64|UXTENSOR_API void* uxtensor_create2d_f64(long long rows, long long cols)|
|6|uxtensor_create3d_f64|UXTENSOR_API void* uxtensor_create3d_f64(long long a, long long b, long long c)|
|7|uxtensor_create4d_f64|UXTENSOR_API void* uxtensor_create4d_f64(long long a, long long b, long long c, long long d)|
|8|uxtensor_free|UXTENSOR_API void uxtensor_free(void* handle)|
|9|uxtensor_clone|UXTENSOR_API void* uxtensor_clone(void* handle)|
|10|uxtensor_reshape_copy|UXTENSOR_API void* uxtensor_reshape_copy(void* handle, int ndim, const long long* shape)|
|11|uxtensor_slice_axis0_copy|UXTENSOR_API void* uxtensor_slice_axis0_copy(void* handle, long long start, long long count)|
|12|uxtensor_dtype|UXTENSOR_API int uxtensor_dtype(void* handle)|
|13|uxtensor_ndim|UXTENSOR_API int uxtensor_ndim(void* handle)|
|14|uxtensor_dim|UXTENSOR_API long long uxtensor_dim(void* handle, int axis)|
|15|uxtensor_stride|UXTENSOR_API long long uxtensor_stride(void* handle, int axis)|
|16|uxtensor_size|UXTENSOR_API long long uxtensor_size(void* handle)|
|17|uxtensor_elem_size|UXTENSOR_API long long uxtensor_elem_size(void* handle)|
|18|uxtensor_data_ptr|UXTENSOR_API void* uxtensor_data_ptr(void* handle)|
|19|uxtensor_fill_f64|UXTENSOR_API int uxtensor_fill_f64(void* handle, double value)|
|20|uxtensor_zero|UXTENSOR_API int uxtensor_zero(void* handle)|
|21|uxtensor_get_flat_f64|UXTENSOR_API double uxtensor_get_flat_f64(void* handle, long long index)|
|22|uxtensor_set_flat_f64|UXTENSOR_API int uxtensor_set_flat_f64(void* handle, long long index, double value)|
|23|uxtensor_get2d_f64|UXTENSOR_API double uxtensor_get2d_f64(void* handle, long long r, long long c)|
|24|uxtensor_set2d_f64|UXTENSOR_API int uxtensor_set2d_f64(void* handle, long long r, long long c, double value)|
|25|uxtensor_get3d_f64|UXTENSOR_API double uxtensor_get3d_f64(void* handle, long long a, long long b, long long c)|
|26|uxtensor_set3d_f64|UXTENSOR_API int uxtensor_set3d_f64(void* handle, long long a, long long b, long long c, double value)|
|27|uxtensor_get4d_f64|UXTENSOR_API double uxtensor_get4d_f64(void* handle, long long a, long long b, long long c, long long d)|
|28|uxtensor_set4d_f64|UXTENSOR_API int uxtensor_set4d_f64(void* handle, long long a, long long b, long long c, long long d, double value)|
|29|uxtensor_add_f64|UXTENSOR_API void* uxtensor_add_f64(void* a, void* b)|
|30|uxtensor_sub_f64|UXTENSOR_API void* uxtensor_sub_f64(void* a, void* b)|
|31|uxtensor_mul_f64|UXTENSOR_API void* uxtensor_mul_f64(void* a, void* b)|
|32|uxtensor_div_f64|UXTENSOR_API void* uxtensor_div_f64(void* a, void* b)|
|33|uxtensor_scale_f64|UXTENSOR_API void* uxtensor_scale_f64(void* a, double scalar)|
|34|uxtensor_sum_f64|UXTENSOR_API double uxtensor_sum_f64(void* a)|
|35|uxtensor_mean_f64|UXTENSOR_API double uxtensor_mean_f64(void* a)|
|36|uxtensor_dot_f64|UXTENSOR_API double uxtensor_dot_f64(void* a, void* b)|
|37|uxtensor_norm2_f64|UXTENSOR_API double uxtensor_norm2_f64(void* a)|
|38|uxtensor_matmul2d_f64|UXTENSOR_API void* uxtensor_matmul2d_f64(void* a, void* b)|
|39|uxtensor_transpose2d_f64|UXTENSOR_API void* uxtensor_transpose2d_f64(void* a)|
|40|uxtensor_matvec2d_f64|UXTENSOR_API void* uxtensor_matvec2d_f64(void* a, void* x)|
|41|uxtensor_blas_ddot|UXTENSOR_API double uxtensor_blas_ddot(long long n, const double* x, long long incx, const double* y, long long incy)|
|42|uxtensor_blas_daxpy|UXTENSOR_API int uxtensor_blas_daxpy(long long n, double alpha, const double* x, long long incx, double* y, long long incy)|
|43|uxtensor_blas_dscal|UXTENSOR_API int uxtensor_blas_dscal(long long n, double alpha, double* x, long long incx)|
|44|uxtensor_blas_dgemm_rowmajor|UXTENSOR_API int uxtensor_blas_dgemm_rowmajor(long long m, long long n, long long k, double alpha, const double* a, const double* b, double beta, double* c)|
### `uxtensor` kullanım örneği

```basic
INCLUDE "modules/uxtensor.uxmh"
DIM t AS PTR
t = CALL uxtensor_create_3d(4, 7, 3)
CALL uxtensor_set_3d(t, 1, 2, 1, 7.4)
PRINT CALL uxtensor_get_3d(t, 1, 2, 1)
CALL uxtensor_free(t)
```

**Hata yakalama tekniği:** Fonksiyon adres veya tutamak [kaynak tanıtıcısı] (handle) döndürüyorsa `0` değerini hata kabul et. Sayısal sonuç döndürüyorsa önce küçük bilinen veriyle dene. Dosya açan veya model yükleyen fonksiyonda yolun varlığını ayrı kontrol et.

