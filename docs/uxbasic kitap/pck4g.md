# uXBasic Programlayıcının Cep Kitabı — Cilt 4
# Kütüphaneler ve Dış Çalışma Zamanı Fonksiyonları

Bu cilt bütün kütüphanelerin çalıştığını varsayar. Kural değişmez: yeni anahtar sözcük eklemek yerine `INCLUDE`, `NAMESPACE`, `MODULE`, `ALIAS`, `USING`, `DECLARE`, `CALL(DLL,...)` ve sarmalayıcı dosyaları kullanılır.

|No|Kütüphane|Fonksiyon sayısı|Dahil etme|Çağırma mantığı|
|---|---|---|---|---|
|1|bigfp|37|INCLUDE "include/modules/bigfp.uxmh"|bigfp.Fonksiyon(...) veya CALL(DLL,"bigfp.dll",...)|
|2|fp128|11|INCLUDE "include/modules/fp128.uxmh"|fp128.Fonksiyon(...) veya CALL(DLL,"fp128.dll",...)|
|3|fp80|11|INCLUDE "include/modules/fp80.uxmh"|fp80.Fonksiyon(...) veya CALL(DLL,"fp80.dll",...)|
|4|uxaimath|0|INCLUDE "include/modules/uxaimath.uxmh"|uxaimath.Fonksiyon(...) veya CALL(DLL,"uxaimath.dll",...)|
|5|uxcollections|0|INCLUDE "include/modules/uxcollections.uxmh"|uxcollections.Fonksiyon(...) veya CALL(DLL,"uxcollections.dll",...)|
|6|uxdataframe|0|INCLUDE "include/modules/uxdataframe.uxmh"|uxdataframe.Fonksiyon(...) veya CALL(DLL,"uxdataframe.dll",...)|
|7|uxgraph|0|INCLUDE "include/modules/uxgraph.uxmh"|uxgraph.Fonksiyon(...) veya CALL(DLL,"uxgraph.dll",...)|
|8|uxllama|0|INCLUDE "include/modules/uxllama.uxmh"|uxllama.Fonksiyon(...) veya CALL(DLL,"uxllama.dll",...)|
|9|uxmath|0|INCLUDE "include/modules/uxmath.uxmh"|uxmath.Fonksiyon(...) veya CALL(DLL,"uxmath.dll",...)|
|10|uxmathcore|0|INCLUDE "include/modules/uxmathcore.uxmh"|uxmathcore.Fonksiyon(...) veya CALL(DLL,"uxmathcore.dll",...)|
|11|uxmatrix|0|INCLUDE "include/modules/uxmatrix.uxmh"|uxmatrix.Fonksiyon(...) veya CALL(DLL,"uxmatrix.dll",...)|
|12|uxnn|0|INCLUDE "include/modules/uxnn.uxmh"|uxnn.Fonksiyon(...) veya CALL(DLL,"uxnn.dll",...)|
|13|uxnn2|0|INCLUDE "include/modules/uxnn2.uxmh"|uxnn2.Fonksiyon(...) veya CALL(DLL,"uxnn2.dll",...)|
|14|uxnn3|0|INCLUDE "include/modules/uxnn3.uxmh"|uxnn3.Fonksiyon(...) veya CALL(DLL,"uxnn3.dll",...)|
|15|uxonnx|0|INCLUDE "include/modules/uxonnx.uxmh"|uxonnx.Fonksiyon(...) veya CALL(DLL,"uxonnx.dll",...)|
|16|uxonnx2|0|INCLUDE "include/modules/uxonnx2.uxmh"|uxonnx2.Fonksiyon(...) veya CALL(DLL,"uxonnx2.dll",...)|
|17|uxstats|0|INCLUDE "include/modules/uxstats.uxmh"|uxstats.Fonksiyon(...) veya CALL(DLL,"uxstats.dll",...)|
|18|uxstats2|0|INCLUDE "include/modules/uxstats2.uxmh"|uxstats2.Fonksiyon(...) veya CALL(DLL,"uxstats2.dll",...)|
|19|uxtensor|44|INCLUDE "include/modules/uxtensor.uxmh"|uxtensor.Fonksiyon(...) veya CALL(DLL,"uxtensor.dll",...)|
## 1. bigfp
`bigfp` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
|1|uxb_big_runtime_version|Modülün sürüm bilgisini döndürür.|sonuc = bigfp.uxb_big_runtime_version(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_big_runtime_version", ...)|
|2|uxb_bigf_handle_size|Boyut, adet veya şekil bilgisini verir.|sonuc = bigfp.uxb_bigf_handle_size(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_handle_size", ...)|
|3|uxb_bigd_handle_size|Boyut, adet veya şekil bilgisini verir.|sonuc = bigfp.uxb_bigd_handle_size(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_handle_size", ...)|
|4|uxb_ball_handle_size|Boyut, adet veya şekil bilgisini verir.|sonuc = bigfp.uxb_ball_handle_size(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_handle_size", ...)|
|5|uxb_bigf_init|Yeni handle/nesne/bellek alanı açar.|sonuc = bigfp.uxb_bigf_init(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_init", ...)|
|6|uxb_bigf_free|Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır.|sonuc = bigfp.uxb_bigf_free(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_free", ...)|
|7|uxb_bigf_precision|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigf_precision(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_precision", ...)|
|8|uxb_bigf_from_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigf_from_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_from_str", ...)|
|9|uxb_bigf_to_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigf_to_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_to_str", ...)|
|10|uxb_bigf_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigf_copy(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_copy", ...)|
|11|uxb_bigf_add|Toplama veya ekleme yapar.|sonuc = bigfp.uxb_bigf_add(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_add", ...)|
|12|uxb_bigf_sub|Çıkarma yapar.|sonuc = bigfp.uxb_bigf_sub(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_sub", ...)|
|13|uxb_bigf_mul|Çarpma veya matris çarpımı yapar.|sonuc = bigfp.uxb_bigf_mul(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_mul", ...)|
|14|uxb_bigf_div|Bölme yapar.|sonuc = bigfp.uxb_bigf_div(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_div", ...)|
|15|uxb_bigf_cmp|İki değeri karşılaştırır.|sonuc = bigfp.uxb_bigf_cmp(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_cmp", ...)|
|16|uxb_bigd_init|Yeni handle/nesne/bellek alanı açar.|sonuc = bigfp.uxb_bigd_init(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_init", ...)|
|17|uxb_bigd_free|Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır.|sonuc = bigfp.uxb_bigd_free(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_free", ...)|
|18|uxb_bigd_precision_digits|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigd_precision_digits(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_precision_digits", ...)|
|19|uxb_bigd_from_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigd_from_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_from_str", ...)|
|20|uxb_bigd_to_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigd_to_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_to_str", ...)|
|21|uxb_bigd_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_bigd_copy(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_copy", ...)|
|22|uxb_bigd_add|Toplama veya ekleme yapar.|sonuc = bigfp.uxb_bigd_add(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_add", ...)|
|23|uxb_bigd_sub|Çıkarma yapar.|sonuc = bigfp.uxb_bigd_sub(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_sub", ...)|
|24|uxb_bigd_mul|Çarpma veya matris çarpımı yapar.|sonuc = bigfp.uxb_bigd_mul(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_mul", ...)|
|25|uxb_bigd_div|Bölme yapar.|sonuc = bigfp.uxb_bigd_div(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_div", ...)|
|26|uxb_bigd_cmp|İki değeri karşılaştırır.|sonuc = bigfp.uxb_bigd_cmp(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_cmp", ...)|
|27|uxb_ball_init|Yeni handle/nesne/bellek alanı açar.|sonuc = bigfp.uxb_ball_init(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_init", ...)|
|28|uxb_ball_free|Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır.|sonuc = bigfp.uxb_ball_free(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_free", ...)|
|29|uxb_ball_precision|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_ball_precision(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_precision", ...)|
|30|uxb_ball_from_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_ball_from_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_from_str", ...)|
|31|uxb_ball_to_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_ball_to_str(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_to_str", ...)|
|32|uxb_ball_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = bigfp.uxb_ball_copy(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_copy", ...)|
|33|uxb_ball_add|Toplama veya ekleme yapar.|sonuc = bigfp.uxb_ball_add(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_add", ...)|
|34|uxb_ball_sub|Çıkarma yapar.|sonuc = bigfp.uxb_ball_sub(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_sub", ...)|
|35|uxb_ball_mul|Çarpma veya matris çarpımı yapar.|sonuc = bigfp.uxb_ball_mul(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_mul", ...)|
|36|uxb_ball_div|Bölme yapar.|sonuc = bigfp.uxb_ball_div(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_div", ...)|
|37|uxb_ball_cmp_mid|İki değeri karşılaştırır.|sonuc = bigfp.uxb_ball_cmp_mid(...)  \|  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_cmp_mid", ...)|
### bigfp fonksiyonlarının tek tek okunuşu
- **1. `uxb_big_runtime_version`**: Modülün sürüm bilgisini döndürür. Kullanım kalıbı: `sonuc = bigfp.uxb_big_runtime_version(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_big_runtime_version", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxb_bigf_handle_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_handle_size(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_handle_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxb_bigd_handle_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_handle_size(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_handle_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxb_ball_handle_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_handle_size(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_handle_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxb_bigf_init`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_init(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_init", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxb_bigf_free`**: Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_free(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_free", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **7. `uxb_bigf_precision`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_precision(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_precision", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **8. `uxb_bigf_from_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_from_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **9. `uxb_bigf_to_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_to_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **10. `uxb_bigf_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_copy(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **11. `uxb_bigf_add`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_add(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_add", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **12. `uxb_bigf_sub`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_sub(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_sub", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **13. `uxb_bigf_mul`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_mul(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_mul", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **14. `uxb_bigf_div`**: Bölme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_div(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_div", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **15. `uxb_bigf_cmp`**: İki değeri karşılaştırır. Kullanım kalıbı: `sonuc = bigfp.uxb_bigf_cmp(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigf_cmp", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **16. `uxb_bigd_init`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_init(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_init", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **17. `uxb_bigd_free`**: Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_free(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_free", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **18. `uxb_bigd_precision_digits`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_precision_digits(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_precision_digits", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **19. `uxb_bigd_from_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_from_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **20. `uxb_bigd_to_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_to_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **21. `uxb_bigd_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_copy(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **22. `uxb_bigd_add`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_add(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_add", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **23. `uxb_bigd_sub`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_sub(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_sub", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **24. `uxb_bigd_mul`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_mul(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_mul", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **25. `uxb_bigd_div`**: Bölme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_div(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_div", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **26. `uxb_bigd_cmp`**: İki değeri karşılaştırır. Kullanım kalıbı: `sonuc = bigfp.uxb_bigd_cmp(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_bigd_cmp", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **27. `uxb_ball_init`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_init(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_init", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **28. `uxb_ball_free`**: Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_free(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_free", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **29. `uxb_ball_precision`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_precision(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_precision", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **30. `uxb_ball_from_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_from_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **31. `uxb_ball_to_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_to_str(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **32. `uxb_ball_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_copy(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **33. `uxb_ball_add`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_add(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_add", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **34. `uxb_ball_sub`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_sub(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_sub", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **35. `uxb_ball_mul`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_mul(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_mul", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **36. `uxb_ball_div`**: Bölme yapar. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_div(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_div", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **37. `uxb_ball_cmp_mid`**: İki değeri karşılaştırır. Kullanım kalıbı: `sonuc = bigfp.uxb_ball_cmp_mid(...)  |  sonuc = CALL(DLL, "bigfp.dll", "uxb_ball_cmp_mid", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 2. fp128
`fp128` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
|1|uxb_f128_size|Boyut, adet veya şekil bilgisini verir.|sonuc = fp128.uxb_f128_size(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_size", ...)|
|2|uxb_f128_storage_size|Boyut, adet veya şekil bilgisini verir.|sonuc = fp128.uxb_f128_storage_size(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_storage_size", ...)|
|3|uxb_f128_zero|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp128.uxb_f128_zero(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_zero", ...)|
|4|uxb_f128_from_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp128.uxb_f128_from_str(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_from_str", ...)|
|5|uxb_f128_to_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp128.uxb_f128_to_str(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_to_str", ...)|
|6|uxb_f128_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp128.uxb_f128_copy(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_copy", ...)|
|7|uxb_f128_add|Toplama veya ekleme yapar.|sonuc = fp128.uxb_f128_add(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_add", ...)|
|8|uxb_f128_sub|Çıkarma yapar.|sonuc = fp128.uxb_f128_sub(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_sub", ...)|
|9|uxb_f128_mul|Çarpma veya matris çarpımı yapar.|sonuc = fp128.uxb_f128_mul(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_mul", ...)|
|10|uxb_f128_div|Bölme yapar.|sonuc = fp128.uxb_f128_div(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_div", ...)|
|11|uxb_f128_cmp|İki değeri karşılaştırır.|sonuc = fp128.uxb_f128_cmp(...)  \|  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_cmp", ...)|
### fp128 fonksiyonlarının tek tek okunuşu
- **1. `uxb_f128_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp128.uxb_f128_size(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxb_f128_storage_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp128.uxb_f128_storage_size(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_storage_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxb_f128_zero`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_zero(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_zero", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxb_f128_from_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_from_str(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxb_f128_to_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_to_str(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxb_f128_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp128.uxb_f128_copy(...)  |  sonuc = CALL(DLL, "fp128.dll", "uxb_f128_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 3. fp80
`fp80` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
|1|uxb_f80_size|Boyut, adet veya şekil bilgisini verir.|sonuc = fp80.uxb_f80_size(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_size", ...)|
|2|uxb_f80_storage_size|Boyut, adet veya şekil bilgisini verir.|sonuc = fp80.uxb_f80_storage_size(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_storage_size", ...)|
|3|uxb_f80_zero|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp80.uxb_f80_zero(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_zero", ...)|
|4|uxb_f80_from_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp80.uxb_f80_from_str(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_from_str", ...)|
|5|uxb_f80_to_str|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp80.uxb_f80_to_str(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_to_str", ...)|
|6|uxb_f80_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = fp80.uxb_f80_copy(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_copy", ...)|
|7|uxb_f80_add|Toplama veya ekleme yapar.|sonuc = fp80.uxb_f80_add(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_add", ...)|
|8|uxb_f80_sub|Çıkarma yapar.|sonuc = fp80.uxb_f80_sub(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_sub", ...)|
|9|uxb_f80_mul|Çarpma veya matris çarpımı yapar.|sonuc = fp80.uxb_f80_mul(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_mul", ...)|
|10|uxb_f80_div|Bölme yapar.|sonuc = fp80.uxb_f80_div(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_div", ...)|
|11|uxb_f80_cmp|İki değeri karşılaştırır.|sonuc = fp80.uxb_f80_cmp(...)  \|  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_cmp", ...)|
### fp80 fonksiyonlarının tek tek okunuşu
- **1. `uxb_f80_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp80.uxb_f80_size(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxb_f80_storage_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = fp80.uxb_f80_storage_size(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_storage_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxb_f80_zero`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_zero(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_zero", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxb_f80_from_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_from_str(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_from_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxb_f80_to_str`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_to_str(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_to_str", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxb_f80_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = fp80.uxb_f80_copy(...)  |  sonuc = CALL(DLL, "fp80.dll", "uxb_f80_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 4. uxaimath
`uxaimath` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 5. uxcollections
`uxcollections` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 6. uxdataframe
`uxdataframe` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 7. uxgraph
`uxgraph` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 8. uxllama
`uxllama` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 9. uxmath
`uxmath` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 10. uxmathcore
`uxmathcore` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 11. uxmatrix
`uxmatrix` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 12. uxnn
`uxnn` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 13. uxnn2
`uxnn2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 14. uxnn3
`uxnn3` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 15. uxonnx
`uxonnx` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 16. uxonnx2
`uxonnx2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 17. uxstats
`uxstats` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 18. uxstats2
`uxstats2` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
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

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## 19. uxtensor
`uxtensor` modülü dış çalışma zamanı kütüphanesidir. uXBasic tarafında handle ve wrapper ile çağrılır. Büyük veri, matematik, yapay zeka, grafik, tablo veya özel sayı işleri için yeni komut eklemeden dilin gücünü artırır.

|No|Fonksiyon|Görev|Sözdizimi|
|---|---|---|---|
|1|uxtensor_version|Modülün sürüm bilgisini döndürür.|sonuc = uxtensor.uxtensor_version(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_version", ...)|
|2|uxtensor_backend|Arka uç kütüphanesinin durumunu bildirir.|sonuc = uxtensor.uxtensor_backend(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_backend", ...)|
|3|uxtensor_create|Yeni handle/nesne/bellek alanı açar.|sonuc = uxtensor.uxtensor_create(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create", ...)|
|4|uxtensor_create1d_f64|Yeni handle/nesne/bellek alanı açar.|sonuc = uxtensor.uxtensor_create1d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create1d_f64", ...)|
|5|uxtensor_create2d_f64|Yeni handle/nesne/bellek alanı açar.|sonuc = uxtensor.uxtensor_create2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create2d_f64", ...)|
|6|uxtensor_create3d_f64|Yeni handle/nesne/bellek alanı açar.|sonuc = uxtensor.uxtensor_create3d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create3d_f64", ...)|
|7|uxtensor_create4d_f64|Yeni handle/nesne/bellek alanı açar.|sonuc = uxtensor.uxtensor_create4d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create4d_f64", ...)|
|8|uxtensor_free|Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır.|sonuc = uxtensor.uxtensor_free(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_free", ...)|
|9|uxtensor_clone|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_clone(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_clone", ...)|
|10|uxtensor_reshape_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_reshape_copy(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_reshape_copy", ...)|
|11|uxtensor_slice_axis0_copy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_slice_axis0_copy(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_slice_axis0_copy", ...)|
|12|uxtensor_dtype|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_dtype(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dtype", ...)|
|13|uxtensor_ndim|Boyut, adet veya şekil bilgisini verir.|sonuc = uxtensor.uxtensor_ndim(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_ndim", ...)|
|14|uxtensor_dim|Boyut, adet veya şekil bilgisini verir.|sonuc = uxtensor.uxtensor_dim(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dim", ...)|
|15|uxtensor_stride|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_stride(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_stride", ...)|
|16|uxtensor_size|Boyut, adet veya şekil bilgisini verir.|sonuc = uxtensor.uxtensor_size(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_size", ...)|
|17|uxtensor_elem_size|Boyut, adet veya şekil bilgisini verir.|sonuc = uxtensor.uxtensor_elem_size(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_elem_size", ...)|
|18|uxtensor_data_ptr|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_data_ptr(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_data_ptr", ...)|
|19|uxtensor_fill_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_fill_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_fill_f64", ...)|
|20|uxtensor_zero|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_zero(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_zero", ...)|
|21|uxtensor_get_flat_f64|Veri, parametre veya ayar okur.|sonuc = uxtensor.uxtensor_get_flat_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get_flat_f64", ...)|
|22|uxtensor_set_flat_f64|Veri, parametre veya ayar yazar.|sonuc = uxtensor.uxtensor_set_flat_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set_flat_f64", ...)|
|23|uxtensor_get2d_f64|Veri, parametre veya ayar okur.|sonuc = uxtensor.uxtensor_get2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get2d_f64", ...)|
|24|uxtensor_set2d_f64|Veri, parametre veya ayar yazar.|sonuc = uxtensor.uxtensor_set2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set2d_f64", ...)|
|25|uxtensor_get3d_f64|Veri, parametre veya ayar okur.|sonuc = uxtensor.uxtensor_get3d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get3d_f64", ...)|
|26|uxtensor_set3d_f64|Veri, parametre veya ayar yazar.|sonuc = uxtensor.uxtensor_set3d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set3d_f64", ...)|
|27|uxtensor_get4d_f64|Veri, parametre veya ayar okur.|sonuc = uxtensor.uxtensor_get4d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get4d_f64", ...)|
|28|uxtensor_set4d_f64|Veri, parametre veya ayar yazar.|sonuc = uxtensor.uxtensor_set4d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set4d_f64", ...)|
|29|uxtensor_add_f64|Toplama veya ekleme yapar.|sonuc = uxtensor.uxtensor_add_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_add_f64", ...)|
|30|uxtensor_sub_f64|Çıkarma yapar.|sonuc = uxtensor.uxtensor_sub_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_sub_f64", ...)|
|31|uxtensor_mul_f64|Çarpma veya matris çarpımı yapar.|sonuc = uxtensor.uxtensor_mul_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_mul_f64", ...)|
|32|uxtensor_div_f64|Bölme yapar.|sonuc = uxtensor.uxtensor_div_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_div_f64", ...)|
|33|uxtensor_scale_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_scale_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_scale_f64", ...)|
|34|uxtensor_sum_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_sum_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_sum_f64", ...)|
|35|uxtensor_mean_f64|Ortalama hesaplar.|sonuc = uxtensor.uxtensor_mean_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_mean_f64", ...)|
|36|uxtensor_blas_ddot|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_blas_ddot(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_ddot", ...)|
|37|uxtensor_blas_daxpy|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_blas_daxpy(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_daxpy", ...)|
|38|uxtensor_blas_dscal|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_blas_dscal(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_dscal", ...)|
|39|uxtensor_dot_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_dot_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dot_f64", ...)|
|40|uxtensor_norm2_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_norm2_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_norm2_f64", ...)|
|41|uxtensor_blas_dgemm_rowmajor|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_blas_dgemm_rowmajor(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_dgemm_rowmajor", ...)|
|42|uxtensor_matmul2d_f64|Çarpma veya matris çarpımı yapar.|sonuc = uxtensor.uxtensor_matmul2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_matmul2d_f64", ...)|
|43|uxtensor_transpose2d_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_transpose2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_transpose2d_f64", ...)|
|44|uxtensor_matvec2d_f64|Modülün kendi alanındaki yardımcı işlemi yapar.|sonuc = uxtensor.uxtensor_matvec2d_f64(...)  \|  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_matvec2d_f64", ...)|
### uxtensor fonksiyonlarının tek tek okunuşu
- **1. `uxtensor_version`**: Modülün sürüm bilgisini döndürür. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_version(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_version", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **2. `uxtensor_backend`**: Arka uç kütüphanesinin durumunu bildirir. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_backend(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_backend", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **3. `uxtensor_create`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_create(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **4. `uxtensor_create1d_f64`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_create1d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create1d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **5. `uxtensor_create2d_f64`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_create2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **6. `uxtensor_create3d_f64`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_create3d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create3d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **7. `uxtensor_create4d_f64`**: Yeni handle/nesne/bellek alanı açar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_create4d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_create4d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **8. `uxtensor_free`**: Açılan handle veya belleği geri bırakır; her create/init sonunda çağrılmalıdır. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_free(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_free", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **9. `uxtensor_clone`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_clone(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_clone", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **10. `uxtensor_reshape_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_reshape_copy(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_reshape_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **11. `uxtensor_slice_axis0_copy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_slice_axis0_copy(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_slice_axis0_copy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **12. `uxtensor_dtype`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_dtype(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dtype", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **13. `uxtensor_ndim`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_ndim(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_ndim", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **14. `uxtensor_dim`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_dim(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dim", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **15. `uxtensor_stride`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_stride(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_stride", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **16. `uxtensor_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_size(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **17. `uxtensor_elem_size`**: Boyut, adet veya şekil bilgisini verir. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_elem_size(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_elem_size", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **18. `uxtensor_data_ptr`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_data_ptr(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_data_ptr", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **19. `uxtensor_fill_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_fill_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_fill_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **20. `uxtensor_zero`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_zero(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_zero", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **21. `uxtensor_get_flat_f64`**: Veri, parametre veya ayar okur. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_get_flat_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get_flat_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **22. `uxtensor_set_flat_f64`**: Veri, parametre veya ayar yazar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_set_flat_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set_flat_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **23. `uxtensor_get2d_f64`**: Veri, parametre veya ayar okur. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_get2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **24. `uxtensor_set2d_f64`**: Veri, parametre veya ayar yazar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_set2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **25. `uxtensor_get3d_f64`**: Veri, parametre veya ayar okur. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_get3d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get3d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **26. `uxtensor_set3d_f64`**: Veri, parametre veya ayar yazar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_set3d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set3d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **27. `uxtensor_get4d_f64`**: Veri, parametre veya ayar okur. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_get4d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_get4d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **28. `uxtensor_set4d_f64`**: Veri, parametre veya ayar yazar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_set4d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_set4d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **29. `uxtensor_add_f64`**: Toplama veya ekleme yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_add_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_add_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **30. `uxtensor_sub_f64`**: Çıkarma yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_sub_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_sub_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **31. `uxtensor_mul_f64`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_mul_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_mul_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **32. `uxtensor_div_f64`**: Bölme yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_div_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_div_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **33. `uxtensor_scale_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_scale_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_scale_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **34. `uxtensor_sum_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_sum_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_sum_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **35. `uxtensor_mean_f64`**: Ortalama hesaplar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_mean_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_mean_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **36. `uxtensor_blas_ddot`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_blas_ddot(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_ddot", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **37. `uxtensor_blas_daxpy`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_blas_daxpy(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_daxpy", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **38. `uxtensor_blas_dscal`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_blas_dscal(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_dscal", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **39. `uxtensor_dot_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_dot_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_dot_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **40. `uxtensor_norm2_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_norm2_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_norm2_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **41. `uxtensor_blas_dgemm_rowmajor`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_blas_dgemm_rowmajor(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_blas_dgemm_rowmajor", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **42. `uxtensor_matmul2d_f64`**: Çarpma veya matris çarpımı yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_matmul2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_matmul2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **43. `uxtensor_transpose2d_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_transpose2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_transpose2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
- **44. `uxtensor_matvec2d_f64`**: Modülün kendi alanındaki yardımcı işlemi yapar. Kullanım kalıbı: `sonuc = uxtensor.uxtensor_matvec2d_f64(...)  |  sonuc = CALL(DLL, "uxtensor.dll", "uxtensor_matvec2d_f64", ...)`. Hata yakalama için handle dönüşünü sıfır mı, sayı dönüşünü geçerli mi, `last_error` ailesi varsa mesajı ne diye kontrol et.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxtensor.uxmh"
DIM a AS U64
DIM b AS U64
a = uxtensor.Create2D(2, 2)
b = uxtensor.Create2D(2, 2)
uxtensor.Set2D(a, 0, 0, 1.0)
uxtensor.Set2D(a, 0, 1, 2.0)
PRINT uxtensor.Get2D(a, 0, 1)
uxtensor.Free(a)
uxtensor.Free(b)
```

Bu örnek birden fazla komutu birlikte kullanır: `INCLUDE`, `DIM`, atama, `IF` veya `PRINT`, dış kütüphane çağrısı ve kaynak serbest bırakma. Kütüphane kullanımında asıl incelik, açtığını kapatmak ve hata değerini hemen kontrol etmektir.

## Ek: Kütüphaneleri tek tek kullanma defteri

Bu bölüm, kütüphane adlarını sadece liste olarak değil, günlük iş yapan aletler olarak öğretir. Kural şudur: Önce `INCLUDE`, sonra uygun değişken veya handle, sonra işlev çağrısı, sonra hata kontrolü, sonra serbest bırakma. Handle döndüren her kütüphane için `Free`, `Close` veya benzeri kapatma işlevi alışkanlık olmalıdır.

### uxcollections — liste, kuyruk, yığın, sözlük, küme

`uxcollections`, dil içi `LIST`, `DICT`, `SET` ruhunu dış çalışma zamanında daha büyük veri için taşır. Yığın son giren ilk çıkar mantığıdır; kuyruk ilk giren ilk çıkar mantığıdır; çift uçlu kuyruk baştan ve sondan işlem yapar.

|Aile|Tipik işlev|Görev|Sözdizimi fikri|
|---|---|---|---|
|List|`ListCreate`, `ListAdd`, `ListGet`, `ListCount`, `ListFree`|uzayan sıra|`h = uxcollections.ListCreate()`|
|Stack|`StackPush`, `StackPop`, `StackCount`|geri alma, çağrı yığını|`StackPush h, deger`|
|Queue|`QueuePush`, `QueuePop`|iş kuyruğu|`QueuePush h, "is"`|
|Deque|`DequePushFront`, `DequePushBack`|iki uçlu akış|`DequePushBack h, veri`|
|Dict|`DictSet`, `DictGet`, `DictHas`|anahtar-değer|`DictSet h, "ad", "Mete"`|
|Set|`SetAdd`, `SetHas`, `SetCount`|benzersiz değer|`SetAdd h, "etiket"`|
|Tree|`TreeInsert`, `TreeFind`, `TreeWalk`|sıralı arama|`TreeInsert h, key, value`|

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

### uxmathcore — ham tampon ve hızlı vektör işleri

`uxmathcore`, sayı dizilerini güvenli handle ile taşır. Büyük veriyi her seferinde BASIC dizisiyle döndürmek yerine tampon üzerinde işlem yapmak hızlıdır.

```uxbasic
INCLUDE "include/modules/uxmathcore.uxmh"
DIM v AS U64
v = uxmathcore.BufferCreateF64(1000)
uxmathcore.BufferFillF64 v, 1.5
PRINT "Toplam="; uxmathcore.VectorSumF64(v)
uxmathcore.BufferFree v
```

İpucu: 10 sayı için normal dizi yeterlidir; 10 milyon sayı için tampon kütüphanesi düşünülür.

### uxmath — sayısal yöntem, kök ve integral

```uxbasic
INCLUDE "include/modules/uxmath.uxmh"
DIM kok AS F64
DIM alan AS F64
kok = uxmath.Sqrt(144.0)
alan = uxmath.IntegrateSimpson("sin", 0.0, 3.14159, 1000)
PRINT "kok="; kok; " alan="; alan
```

Beş komutlu kullanım: `INCLUDE`, `DIM`, işlev çağrısı, `IF` hata kontrolü, `PRINT` raporu.

### uxstats — temel istatistik

```uxbasic
INCLUDE "include/modules/uxstats.uxmh"
DIM x(1 TO 5) AS F64
x(1)=10 : x(2)=12 : x(3)=9 : x(4)=15 : x(5)=14
PRINT "Ortalama="; uxstats.Mean(VARPTR(x(1)), 5)
PRINT "StdSapma="; uxstats.StdDev(VARPTR(x(1)), 5)
```

Ne zaman kullanılır? Laboratuvar ölçümü, üretim kalite kontrolü, deney karşılaştırması, finansal seri özeti.

### uxstats2 — ileri testler

`uxstats2`, Z testi, T testi, F testi, ki-kare, varyans analizi, regresyon tanı testleri gibi işler içindir.

```uxbasic
INCLUDE "include/modules/uxstats2.uxmh"
DIM z AS F64
DIM p AS F64
z = uxstats2.ZTestMean(105.0, 100.0, 15.0, 36)
p = uxstats2.NormalPValue(z)
IF p < 0.05 THEN PRINT "Fark anlamli" ELSE PRINT "Fark zayif"
```

F testi iki varyansı karşılaştırır:

```uxbasic
DIM f AS F64
f = uxstats2.FTestVariance(12.4, 8.2, 20, 20)
PRINT "F orani="; f
```

### uxmatrix — matris cebiri

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

İpucu: Matris kütüphanesinde indeks düzenini baştan öğren. Bazı sistemler 0 tabanlı, bazıları 1 tabanlıdır; kitap örnekleri okunurluk için 1 tabanlı gösterir.

### uxtensor — 1D, 2D, 3D, 4D bilimsel bloklar

```uxbasic
INCLUDE "include/modules/uxtensor.uxmh"
DIM t AS U64
t = uxtensor.Create4D(2,3,4,5)
uxtensor.SetF64 t, 1,2,3,4, 0.875
PRINT uxtensor.GetF64(t,1,2,3,4)
uxtensor.Free t
```

Tensör, çok boyutlu dizinin dış kütüphane tarafındaki hızlı kardeşidir. Yapay sinir ağı, görüntü, zaman serisi ve bilimsel hacim verisinde kullanılır.

### uxdataframe — CSV, Parquet, SQL ve tablo analizi

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

Veri çerçevesi, Excel tablosunu programla yönetmek gibidir. Filtre, sıralama, grup ortalaması ve birleştirme işlerinde kullanılır.

### uxgraph — çizge, ağ ve yol arama

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

Çizge; şehir yolu, atıf ağı, sosyal ağ, dosya bağımlılığı, modül ilişkisi için kullanılır.

### uxaimath ve uxnn — yapay zeka matematiği ve sinir ağı

```uxbasic
INCLUDE "include/modules/uxaimath.uxmh"
DIM y AS F64
y = uxaimath.Sigmoid(0.75)
PRINT "Sigmoid="; y
```

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

### uxonnx — dış model çalıştırma

```uxbasic
INCLUDE "include/modules/uxonnx.uxmh"
DIM s AS U64
s = uxonnx.SessionCreate("model.onnx")
CALL uxonnx.Run(s)
PRINT uxonnx.LastError()
uxonnx.SessionFree s
```

ONNX kapısı, Python tarafında eğitilmiş modeli uXBasic programında kullanma yoludur.

### uxllama — yerel Llama ile konuşma

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

İpucu: Yerel modelde hız için bağlam boyutunu ve thread sayısını makineye göre ayarla. API anahtarı gerekmez ama model dosyası gerekir.

### fp80, fp128 ve bigfp — hassas sayı kütüphaneleri

```uxbasic
INCLUDE "include/extfp.uxmh"
DIM a AS F128
DIM b AS F128
a = F128_INIT("1.25")
b = F128_INIT("2.75")
PRINT F128_ADD(a,b)
```

Büyük hassasiyet kütüphanelerinde metinden başlatma önemlidir. Çünkü `3.1415926535` gibi değer önce normal `F64` olarak bozulursa yüksek hassasiyete bozuk taşınır. Bu yüzden `BIGINIT("BIGF", "3.1415926535", 256)` gibi metinden başlatma güvenlidir.

## Kütüphane kullanırken hata yakalama düzeni

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

Her kütüphane örneğinde beş adımı unutma: aç, hazırla, çalıştır, kontrol et, kapat.
