# uXBasic Programlayıcının Cep Kitabı — Cilt 4
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
|7|uxb_bigf_precision|Dağılım olasılığı veya p değeri hesaplar.|sonuc = bigfp.uxb_bigf_precision(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_precision",...)|
|8|uxb_bigf_from_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigf_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_from_str",...)|
|9|uxb_bigf_to_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigf_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_to_str",...)|
|10|uxb_bigf_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigf_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_copy",...)|
|11|uxb_bigf_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_bigf_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_add",...)|
|12|uxb_bigf_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_bigf_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_sub",...)|
|13|uxb_bigf_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_bigf_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_mul",...)|
|14|uxb_bigf_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_bigf_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_div",...)|
|15|uxb_bigf_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_bigf_cmp(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigf_cmp",...)|
|16|uxb_bigd_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = bigfp.uxb_bigd_init(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_init",...)|
|17|uxb_bigd_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = bigfp.uxb_bigd_free(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_free",...)|
|18|uxb_bigd_precision_digits|Dağılım olasılığı veya p değeri hesaplar.|sonuc = bigfp.uxb_bigd_precision_digits(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_precision_digits",...)|
|19|uxb_bigd_from_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigd_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_from_str",...)|
|20|uxb_bigd_to_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigd_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_to_str",...)|
|21|uxb_bigd_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_bigd_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_copy",...)|
|22|uxb_bigd_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_bigd_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_add",...)|
|23|uxb_bigd_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_bigd_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_sub",...)|
|24|uxb_bigd_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_bigd_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_mul",...)|
|25|uxb_bigd_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_bigd_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_div",...)|
|26|uxb_bigd_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_bigd_cmp(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_bigd_cmp",...)|
|27|uxb_ball_init|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = bigfp.uxb_ball_init(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_init",...)|
|28|uxb_ball_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = bigfp.uxb_ball_free(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_free",...)|
|29|uxb_ball_precision|Dağılım olasılığı veya p değeri hesaplar.|sonuc = bigfp.uxb_ball_precision(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_precision",...)|
|30|uxb_ball_from_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_ball_from_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_from_str",...)|
|31|uxb_ball_to_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_ball_to_str(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_to_str",...)|
|32|uxb_ball_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = bigfp.uxb_ball_copy(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_copy",...)|
|33|uxb_ball_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = bigfp.uxb_ball_add(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_add",...)|
|34|uxb_ball_sub|Çıkarma işlemi yapar.|sonuc = bigfp.uxb_ball_sub(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_sub",...)|
|35|uxb_ball_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = bigfp.uxb_ball_mul(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_mul",...)|
|36|uxb_ball_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = bigfp.uxb_ball_div(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_div",...)|
|37|uxb_ball_cmp_mid|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = bigfp.uxb_ball_cmp_mid(...)  \|  sonuc = CALL(DLL,"bigfp.dll","uxb_ball_cmp_mid",...)|

### bigfp fonksiyonlarını okuma yöntemi
- **1. `uxb_big_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxb_bigf_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxb_bigd_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxb_ball_handle_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxb_bigf_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxb_bigf_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxb_bigf_precision`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxb_bigf_from_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxb_bigf_to_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxb_bigf_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxb_bigf_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxb_bigf_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxb_bigf_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxb_bigf_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxb_bigf_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxb_bigd_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxb_bigd_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxb_bigd_precision_digits`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxb_bigd_from_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxb_bigd_to_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxb_bigd_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxb_bigd_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxb_bigd_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxb_bigd_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxb_bigd_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxb_bigd_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxb_ball_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxb_ball_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxb_ball_precision`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxb_ball_from_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxb_ball_to_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxb_ball_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxb_ball_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxb_ball_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxb_ball_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxb_ball_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxb_ball_cmp_mid`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|3|uxb_f128_zero|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp128.uxb_f128_zero(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_zero",...)|
|4|uxb_f128_from_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp128.uxb_f128_from_str(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_from_str",...)|
|5|uxb_f128_to_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp128.uxb_f128_to_str(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_to_str",...)|
|6|uxb_f128_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp128.uxb_f128_copy(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_copy",...)|
|7|uxb_f128_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = fp128.uxb_f128_add(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_add",...)|
|8|uxb_f128_sub|Çıkarma işlemi yapar.|sonuc = fp128.uxb_f128_sub(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_sub",...)|
|9|uxb_f128_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = fp128.uxb_f128_mul(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_mul",...)|
|10|uxb_f128_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = fp128.uxb_f128_div(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_div",...)|
|11|uxb_f128_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = fp128.uxb_f128_cmp(...)  \|  sonuc = CALL(DLL,"fp128.dll","uxb_f128_cmp",...)|

### fp128 fonksiyonlarını okuma yöntemi
- **1. `uxb_f128_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxb_f128_storage_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxb_f128_zero`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxb_f128_from_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxb_f128_to_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxb_f128_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxb_f128_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxb_f128_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxb_f128_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxb_f128_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxb_f128_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|3|uxb_f80_zero|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp80.uxb_f80_zero(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_zero",...)|
|4|uxb_f80_from_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp80.uxb_f80_from_str(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_from_str",...)|
|5|uxb_f80_to_str|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp80.uxb_f80_to_str(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_to_str",...)|
|6|uxb_f80_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = fp80.uxb_f80_copy(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_copy",...)|
|7|uxb_f80_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = fp80.uxb_f80_add(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_add",...)|
|8|uxb_f80_sub|Çıkarma işlemi yapar.|sonuc = fp80.uxb_f80_sub(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_sub",...)|
|9|uxb_f80_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = fp80.uxb_f80_mul(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_mul",...)|
|10|uxb_f80_div|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = fp80.uxb_f80_div(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_div",...)|
|11|uxb_f80_cmp|İki değeri karşılaştırır; sonuç karar akışında kullanılır.|sonuc = fp80.uxb_f80_cmp(...)  \|  sonuc = CALL(DLL,"fp80.dll","uxb_f80_cmp",...)|

### fp80 fonksiyonlarını okuma yöntemi
- **1. `uxb_f80_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxb_f80_storage_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxb_f80_zero`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxb_f80_from_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxb_f80_to_str`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxb_f80_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxb_f80_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxb_f80_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxb_f80_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxb_f80_div`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxb_f80_cmp`** — İki değeri karşılaştırır; sonuç karar akışında kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|2|uxaimath_backend|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_backend(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_backend",...)|
|3|uxaimath_seed|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_seed(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_seed",...)|
|4|uxaimath_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_sigmoid(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sigmoid",...)|
|5|uxaimath_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_relu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_relu",...)|
|6|uxaimath_leaky_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_leaky_relu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_leaky_relu",...)|
|7|uxaimath_elu|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_elu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_elu",...)|
|8|uxaimath_gelu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_gelu(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_gelu",...)|
|9|uxaimath_swish|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_swish(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_swish",...)|
|10|uxaimath_softplus|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_softplus(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softplus",...)|
|11|uxaimath_leaky_relu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_leaky_relu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_leaky_relu_inplace_f64",...)|
|12|uxaimath_elu_inplace_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_elu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_elu_inplace_f64",...)|
|13|uxaimath_softmax_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_softmax_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softmax_f64",...)|
|14|uxaimath_softmax_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_softmax_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_softmax_inplace_f64",...)|
|15|uxaimath_mse_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mse_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mse_f64",...)|
|16|uxaimath_mae_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mae_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mae_f64",...)|
|17|uxaimath_huber_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_huber_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_huber_f64",...)|
|18|uxaimath_bce_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_bce_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_bce_f64",...)|
|19|uxaimath_cce_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_cce_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_cce_f64",...)|
|20|uxaimath_mse_grad_f64|Model hatası/kayıp değeri hesaplar.|sonuc = uxaimath.uxaimath_mse_grad_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_mse_grad_f64",...)|
|21|uxaimath_bce_grad_f64|Öğrenme için türev/gradyan üretir.|sonuc = uxaimath.uxaimath_bce_grad_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_bce_grad_f64",...)|
|22|uxaimath_fill_zero_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_fill_zero_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_zero_f64",...)|
|23|uxaimath_fill_one_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_fill_one_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_one_f64",...)|
|24|uxaimath_fill_uniform_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_fill_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_uniform_f64",...)|
|25|uxaimath_fill_normal_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxaimath.uxaimath_fill_normal_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_fill_normal_f64",...)|
|26|uxaimath_xavier_uniform_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_xavier_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_xavier_uniform_f64",...)|
|27|uxaimath_he_uniform_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_he_uniform_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_he_uniform_f64",...)|
|28|uxaimath_clip_value_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_clip_value_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_clip_value_f64",...)|
|29|uxaimath_clip_norm_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_clip_norm_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_clip_norm_f64",...)|
|30|uxaimath_sgd_update_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_sgd_update_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sgd_update_f64",...)|
|31|uxaimath_momentum_update_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_momentum_update_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_momentum_update_f64",...)|
|32|uxaimath_dense_forward_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_dense_forward_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_dense_forward_f64",...)|
|33|uxaimath_dense_batch_forward_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_dense_batch_forward_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_dense_batch_forward_f64",...)|
|34|uxaimath_argmax_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_argmax_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_argmax_f64",...)|
|35|uxaimath_binary_accuracy_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_binary_accuracy_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_binary_accuracy_f64",...)|
|36|name|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.name(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","name",...)|
|37|uxaimath_sigmoid_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_sigmoid_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_sigmoid_inplace_f64",...)|
|38|uxaimath_tanh_inplace_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_tanh_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_tanh_inplace_f64",...)|
|39|uxaimath_relu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_relu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_relu_inplace_f64",...)|
|40|uxaimath_gelu_inplace_f64|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxaimath.uxaimath_gelu_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_gelu_inplace_f64",...)|
|41|uxaimath_swish_inplace_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxaimath.uxaimath_swish_inplace_f64(...)  \|  sonuc = CALL(DLL,"uxaimath.dll","uxaimath_swish_inplace_f64",...)|

### uxaimath fonksiyonlarını okuma yöntemi
- **1. `uxaimath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxaimath_backend`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxaimath_seed`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxaimath_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxaimath_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxaimath_leaky_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxaimath_elu`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxaimath_gelu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxaimath_swish`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxaimath_softplus`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxaimath_leaky_relu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxaimath_elu_inplace_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxaimath_softmax_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxaimath_softmax_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxaimath_mse_f64`** — Model hatası/kayıp değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxaimath_mae_f64`** — Model hatası/kayıp değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxaimath_huber_f64`** — Model hatası/kayıp değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxaimath_bce_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxaimath_cce_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxaimath_mse_grad_f64`** — Model hatası/kayıp değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxaimath_bce_grad_f64`** — Öğrenme için türev/gradyan üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxaimath_fill_zero_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxaimath_fill_one_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxaimath_fill_uniform_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxaimath_fill_normal_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxaimath_xavier_uniform_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxaimath_he_uniform_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxaimath_clip_value_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxaimath_clip_norm_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxaimath_sgd_update_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxaimath_momentum_update_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxaimath_dense_forward_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxaimath_dense_batch_forward_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxaimath_argmax_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxaimath_binary_accuracy_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `name`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxaimath_sigmoid_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxaimath_tanh_inplace_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxaimath_relu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxaimath_gelu_inplace_f64`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxaimath_swish_inplace_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|2|uxdf_duckdb_available|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_duckdb_available(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_duckdb_available",...)|
|3|uxdf_duckdb_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxdataframe.uxdf_duckdb_version(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_duckdb_version",...)|
|4|uxdf_last_error|Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur.|sonuc = uxdataframe.uxdf_last_error(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_last_error",...)|
|5|uxdf_open_memory|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxdataframe.uxdf_open_memory(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_open_memory",...)|
|6|uxdf_open_database|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxdataframe.uxdf_open_database(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_open_database",...)|
|7|uxdf_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxdataframe.uxdf_free(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_free",...)|
|8|uxdf_load_csv|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxdataframe.uxdf_load_csv(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_load_csv",...)|
|9|uxdf_load_parquet|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxdataframe.uxdf_load_parquet(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_load_parquet",...)|
|10|uxdf_exec|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_exec(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_exec",...)|
|11|uxdf_query|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_query(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_query",...)|
|12|uxdf_row_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_row_count(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_row_count",...)|
|13|uxdf_col_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_col_count(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_col_count",...)|
|14|uxdf_col_name|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_col_name(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_col_name",...)|
|15|uxdf_get_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_get_f64(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_get_f64",...)|
|16|uxdf_get_text|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_get_text(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_get_text",...)|
|17|uxdf_head|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_head(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_head",...)|
|18|uxdf_select|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_select(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_select",...)|
|19|uxdf_filter|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_filter(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_filter",...)|
|20|uxdf_order_by|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_order_by(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_order_by",...)|
|21|uxdf_describe|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_describe(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_describe",...)|
|22|uxdf_group_mean|Ortalama hesaplar.|sonuc = uxdataframe.uxdf_group_mean(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_group_mean",...)|
|23|uxdf_join_inner|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_join_inner(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_join_inner",...)|
|24|uxdf_to_csv|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxdataframe.uxdf_to_csv(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_csv",...)|
|25|uxdf_to_parquet|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxdataframe.uxdf_to_parquet(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_parquet",...)|
|26|uxdf_to_f64_matrix|Matris işlemi veya matris özelliği üretir.|sonuc = uxdataframe.uxdf_to_f64_matrix(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_to_f64_matrix",...)|
|27|uxdf_matrix_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxdataframe.uxdf_matrix_free(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_free",...)|
|28|uxdf_matrix_rows|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_matrix_rows(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_rows",...)|
|29|uxdf_matrix_cols|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxdataframe.uxdf_matrix_cols(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_cols",...)|
|30|uxdf_matrix_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxdataframe.uxdf_matrix_data_ptr(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_data_ptr",...)|
|31|uxdf_matrix_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxdataframe.uxdf_matrix_get(...)  \|  sonuc = CALL(DLL,"uxdataframe.dll","uxdf_matrix_get",...)|

### uxdataframe fonksiyonlarını okuma yöntemi
- **1. `uxdf_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxdf_duckdb_available`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxdf_duckdb_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxdf_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxdf_open_memory`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxdf_open_database`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxdf_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxdf_load_csv`** — Dış dosyadan veya kaynaktan veri yükler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxdf_load_parquet`** — Dış dosyadan veya kaynaktan veri yükler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxdf_exec`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxdf_query`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxdf_row_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxdf_col_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxdf_col_name`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxdf_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxdf_get_text`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxdf_head`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxdf_select`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxdf_filter`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxdf_order_by`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxdf_describe`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxdf_group_mean`** — Ortalama hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxdf_join_inner`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxdf_to_csv`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxdf_to_parquet`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxdf_to_f64_matrix`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxdf_matrix_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxdf_matrix_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxdf_matrix_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxdf_matrix_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxdf_matrix_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
- **1. `uxgraph_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxgraph_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxgraph_add_vertex`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxgraph_add_vertices`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxgraph_add_edge`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxgraph_vcount`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxgraph_ecount`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxgraph_is_directed`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxgraph_has_edge`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxgraph_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxgraph_in_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxgraph_out_degree`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxgraph_density`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxgraph_self_loops`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxgraph_components_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxgraph_is_connected`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxgraph_shortest_distance`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxgraph_path_exists`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxgraph_triangle_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxgraph_transitivity`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxgraph_degree_vector`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxgraph_bfs_distances`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxgraph_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxgraph_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxgraph_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxgraph_write_edgelist_csv`** — Veriyi dosyaya veya dış hedefe yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxgraph_read_edgelist_csv`** — Dış dosyadan veya kaynaktan veri yükler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxgraph_make_path`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxgraph_make_cycle`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxgraph_make_complete`** — Graf düğümü, kenarı, yol veya bağlantı özelliği işler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|18|uxllama_last_command|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxllama.uxllama_last_command(...)  \|  sonuc = CALL(DLL,"uxllama.dll","uxllama_last_command",...)|

### uxllama fonksiyonlarını okuma yöntemi
- **1. `uxllama_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxllama_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxllama_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxllama_set_cli_path`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxllama_set_model_path`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxllama_set_threads`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxllama_set_context`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxllama_set_predict`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxllama_set_temperature`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxllama_set_top_p`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxllama_set_top_k`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxllama_set_seed`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxllama_set_low_memory_profile`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxllama_model_exists`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxllama_prompt`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxllama_prompt_file`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxllama_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxllama_last_command`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|8|uxmath_vec_clear|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_vec_clear(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_clear",...)|
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
|19|uxmath_ode_rk4_logistic|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_ode_rk4_logistic(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_ode_rk4_logistic",...)|
|20|uxmath_ode_euler_logistic|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_ode_euler_logistic(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_ode_euler_logistic",...)|
|21|uxmath_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_sigmoid(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_sigmoid",...)|
|22|uxmath_dsigmoid_from_output|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_dsigmoid_from_output(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_dsigmoid_from_output",...)|
|23|uxmath_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_relu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_relu",...)|
|24|uxmath_drelu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_drelu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_drelu",...)|
|25|uxmath_tanh_act|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_tanh_act(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_tanh_act",...)|
|26|uxmath_dtanh_from_output|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_dtanh_from_output(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_dtanh_from_output",...)|
|27|uxmath_vec_softmax|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_vec_softmax(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_vec_softmax",...)|
|28|uxmath_mat_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmath.uxmath_mat_create(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_create",...)|
|29|uxmath_mat_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmath.uxmath_mat_free(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_free",...)|
|30|uxmath_mat_rows|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmath.uxmath_mat_rows(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_rows",...)|
|31|uxmath_mat_cols|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmath.uxmath_mat_cols(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_cols",...)|
|32|uxmath_mat_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmath.uxmath_mat_set(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_set",...)|
|33|uxmath_mat_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmath.uxmath_mat_get(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_get",...)|
|34|uxmath_mat_fill|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_mat_fill(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_fill",...)|
|35|uxmath_mat_random_uniform|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmath.uxmath_mat_random_uniform(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_random_uniform",...)|
|36|uxmath_mat_add|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxmath.uxmath_mat_add(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_add",...)|
|37|uxmath_mat_sub|Çıkarma işlemi yapar.|sonuc = uxmath.uxmath_mat_sub(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_sub",...)|
|38|uxmath_mat_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmath.uxmath_mat_mul(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_mul",...)|
|39|uxmath_mat_transpose|Matris işlemi veya matris özelliği üretir.|sonuc = uxmath.uxmath_mat_transpose(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_transpose",...)|
|40|uxmath_mat_apply_sigmoid|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_mat_apply_sigmoid(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_apply_sigmoid",...)|
|41|uxmath_mat_apply_relu|Yapay sinir ağı aktivasyon işlemi yapar.|sonuc = uxmath.uxmath_mat_apply_relu(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_apply_relu",...)|
|42|uxmath_mat_vec_mul|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmath.uxmath_mat_vec_mul(...)  \|  sonuc = CALL(DLL,"uxmath.dll","uxmath_mat_vec_mul",...)|

### uxmath fonksiyonlarını okuma yöntemi
- **1. `uxmath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxmath_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxmath_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxmath_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxmath_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxmath_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxmath_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxmath_vec_clear`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxmath_vec_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxmath_poly_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxmath_poly_derivative_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxmath_poly_integral_eval`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxmath_poly_derivative_coeff`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxmath_poly_integral_coeff`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxmath_poly_bisection`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxmath_poly_newton`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxmath_numeric_derivative_poly`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxmath_integrate_poly_simpson`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxmath_ode_rk4_logistic`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxmath_ode_euler_logistic`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxmath_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxmath_dsigmoid_from_output`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxmath_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxmath_drelu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxmath_tanh_act`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxmath_dtanh_from_output`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxmath_vec_softmax`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxmath_mat_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxmath_mat_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxmath_mat_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxmath_mat_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxmath_mat_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxmath_mat_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxmath_mat_fill`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxmath_mat_random_uniform`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxmath_mat_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxmath_mat_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxmath_mat_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxmath_mat_transpose`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxmath_mat_apply_sigmoid`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxmath_mat_apply_relu`** — Yapay sinir ağı aktivasyon işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxmath_mat_vec_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|3|uxmathcore_type_name|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_type_name(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_type_name",...)|
|4|uxmathcore_buffer_create_capacity|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmathcore_buffer_create_capacity(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_create_capacity",...)|
|5|uxmathcore_buffer_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmathcore_buffer_create(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_create",...)|
|6|uxmathcore_buffer_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmathcore.uxmathcore_buffer_free(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_free",...)|
|7|uxmathcore_buffer_type|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_type(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_type",...)|
|8|uxmathcore_buffer_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_count(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_count",...)|
|9|uxmathcore_buffer_capacity|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_capacity(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_capacity",...)|
|10|uxmathcore_buffer_elem_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_elem_size(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_elem_size",...)|
|11|uxmathcore_buffer_byte_size|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_byte_size(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_byte_size",...)|
|12|uxmathcore_buffer_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_data_ptr",...)|
|13|uxmathcore_buffer_clear|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clear(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clear",...)|
|14|uxmathcore_buffer_resize|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmathcore_buffer_resize(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_resize",...)|
|15|uxmathcore_buffer_reserve|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_reserve(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_reserve",...)|
|16|uxmathcore_buffer_fill_zero|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_zero(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_zero",...)|
|17|uxmathcore_buffer_clone|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clone(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clone",...)|
|18|uxmathcore_buffer_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_copy(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy",...)|
|19|uxmathcore_buffer_slice|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_slice(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_slice",...)|
|20|uxmathcore_buffer_append|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_append(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_append",...)|
|21|uxmathcore_buffer_get_f64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_f64",...)|
|22|uxmathcore_buffer_set_f64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_f64",...)|
|23|uxmathcore_buffer_push_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_f64",...)|
|24|uxmathcore_buffer_fill_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_f64",...)|
|25|uxmathcore_buffer_get_i64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_i64",...)|
|26|uxmathcore_buffer_set_i64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_i64",...)|
|27|uxmathcore_buffer_push_i64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_i64",...)|
|28|uxmathcore_buffer_fill_i64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_i64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_i64",...)|
|29|uxmathcore_buffer_get_u64|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_u64",...)|
|30|uxmathcore_buffer_set_u64|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_u64",...)|
|31|uxmathcore_buffer_push_u64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_u64",...)|
|32|uxmathcore_buffer_fill_u64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_fill_u64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_fill_u64",...)|
|33|uxmathcore_buffer_get_byte|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmathcore_buffer_get_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_get_byte",...)|
|34|uxmathcore_buffer_set_byte|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmathcore_buffer_set_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_set_byte",...)|
|35|uxmathcore_buffer_push_byte|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_push_byte(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_push_byte",...)|
|36|uxmathcore_buffer_copy_from_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_copy_from_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy_from_ptr",...)|
|37|uxmathcore_buffer_copy_to_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_buffer_copy_to_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_copy_to_ptr",...)|
|38|uxmathcore_buffer_cast|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_cast(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_cast",...)|
|39|uxmathcore_vec_add_f64|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxmathcore.uxmathcore_vec_add_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_add_f64",...)|
|40|uxmathcore_vec_sub_f64|Çıkarma işlemi yapar.|sonuc = uxmathcore.uxmathcore_vec_sub_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_sub_f64",...)|
|41|uxmathcore_vec_mul_f64|Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar.|sonuc = uxmathcore.uxmathcore_vec_mul_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_mul_f64",...)|
|42|uxmathcore_vec_div_f64|Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister.|sonuc = uxmathcore.uxmathcore_vec_div_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_div_f64",...)|
|43|uxmathcore_vec_scale_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_scale_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_scale_f64",...)|
|44|uxmathcore_vec_axpy_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_axpy_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_axpy_f64",...)|
|45|uxmathcore_vec_dot_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_dot_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_dot_f64",...)|
|46|uxmathcore_vec_l1_norm_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l1_norm_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l1_norm_f64",...)|
|47|uxmathcore_vec_l2_norm_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l2_norm_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l2_norm_f64",...)|
|48|uxmathcore_vec_normalize_l2_f64|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmathcore_vec_normalize_l2_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_normalize_l2_f64",...)|
|49|uxmathcore_vec_minmax_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_minmax_f64(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_minmax_f64",...)|
|50|uxmath_version|Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır.|sonuc = uxmathcore.uxmath_version(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_version",...)|
|51|uxmath_vec_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxmathcore.uxmath_vec_create(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_create",...)|
|52|uxmath_vec_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxmathcore.uxmath_vec_free(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_free",...)|
|53|uxmath_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmath_vec_push(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_push",...)|
|54|uxmath_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxmathcore.uxmath_vec_set(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_set",...)|
|55|uxmath_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxmathcore.uxmath_vec_get(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_get",...)|
|56|uxmath_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxmathcore.uxmath_vec_count(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_count",...)|
|57|uxmath_vec_clear|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmath_vec_clear(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_clear",...)|
|58|uxmath_vec_data_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxmathcore.uxmath_vec_data_ptr(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmath_vec_data_ptr",...)|
|59|uxmathcore_buffer_clone_handle|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_clone_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_clone_handle",...)|
|60|uxmathcore_buffer_slice_handle|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_slice_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_slice_handle",...)|
|61|uxmathcore_buffer_cast_handle|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_buffer_cast_handle(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_buffer_cast_handle",...)|
|62|uxmathcore_vec_dot_f64_value|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_dot_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_dot_f64_value",...)|
|63|uxmathcore_vec_l1_norm_f64_value|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l1_norm_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l1_norm_f64_value",...)|
|64|uxmathcore_vec_l2_norm_f64_value|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_l2_norm_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_l2_norm_f64_value",...)|
|65|uxmathcore_vec_min_f64_value|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_min_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_min_f64_value",...)|
|66|uxmathcore_vec_max_f64_value|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxmathcore.uxmathcore_vec_max_f64_value(...)  \|  sonuc = CALL(DLL,"uxmathcore.dll","uxmathcore_vec_max_f64_value",...)|

### uxmathcore fonksiyonlarını okuma yöntemi
- **1. `uxmathcore_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxmathcore_type_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxmathcore_type_name`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxmathcore_buffer_create_capacity`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxmathcore_buffer_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxmathcore_buffer_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxmathcore_buffer_type`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxmathcore_buffer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxmathcore_buffer_capacity`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxmathcore_buffer_elem_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxmathcore_buffer_byte_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxmathcore_buffer_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxmathcore_buffer_clear`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxmathcore_buffer_resize`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxmathcore_buffer_reserve`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxmathcore_buffer_fill_zero`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxmathcore_buffer_clone`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxmathcore_buffer_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxmathcore_buffer_slice`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxmathcore_buffer_append`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxmathcore_buffer_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxmathcore_buffer_set_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxmathcore_buffer_push_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxmathcore_buffer_fill_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxmathcore_buffer_get_i64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxmathcore_buffer_set_i64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxmathcore_buffer_push_i64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxmathcore_buffer_fill_i64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxmathcore_buffer_get_u64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxmathcore_buffer_set_u64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxmathcore_buffer_push_u64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxmathcore_buffer_fill_u64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxmathcore_buffer_get_byte`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxmathcore_buffer_set_byte`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxmathcore_buffer_push_byte`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxmathcore_buffer_copy_from_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxmathcore_buffer_copy_to_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxmathcore_buffer_cast`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxmathcore_vec_add_f64`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxmathcore_vec_sub_f64`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxmathcore_vec_mul_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxmathcore_vec_div_f64`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **43. `uxmathcore_vec_scale_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **44. `uxmathcore_vec_axpy_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **45. `uxmathcore_vec_dot_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **46. `uxmathcore_vec_l1_norm_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **47. `uxmathcore_vec_l2_norm_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **48. `uxmathcore_vec_normalize_l2_f64`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **49. `uxmathcore_vec_minmax_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **50. `uxmath_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **51. `uxmath_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **52. `uxmath_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **53. `uxmath_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **54. `uxmath_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **55. `uxmath_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **56. `uxmath_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **57. `uxmath_vec_clear`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **58. `uxmath_vec_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **59. `uxmathcore_buffer_clone_handle`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **60. `uxmathcore_buffer_slice_handle`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **61. `uxmathcore_buffer_cast_handle`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **62. `uxmathcore_vec_dot_f64_value`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **63. `uxmathcore_vec_l1_norm_f64_value`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **64. `uxmathcore_vec_l2_norm_f64_value`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **65. `uxmathcore_vec_min_f64_value`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **66. `uxmathcore_vec_max_f64_value`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
- **1. `uxmatrix_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxmatrix_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxmatrix_from_array`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxmatrix_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxmatrix_rows`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxmatrix_cols`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxmatrix_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxmatrix_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxmatrix_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxmatrix_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxmatrix_fill`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxmatrix_zero`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxmatrix_eye`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxmatrix_clone`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxmatrix_transpose`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxmatrix_add`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxmatrix_sub`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxmatrix_scale`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxmatrix_mul`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxmatrix_matvec`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxmatrix_dot`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxmatrix_norm_l1`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxmatrix_norm_l2`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxmatrix_norm_fro`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxmatrix_trace`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxmatrix_copy_to_array`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxmatrix_copy_from_array`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxmatrix_print`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxmatrix_solve`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxmatrix_det`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxmatrix_inverse`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxmatrix_cholesky`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxmatrix_qr`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxmatrix_svd`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxmatrix_eigen_symmetric`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxmatrix_solve_new`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxmatrix_inverse_new`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxmatrix_cholesky_new`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxmatrix_rank_svd`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxmatrix_cond2`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxmatrix_blas_ddot`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxmatrix_blas_daxpy`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **43. `uxmatrix_blas_dgemm_rowmajor`** — Matris işlemi veya matris özelliği üretir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|2|uxnn_backend|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn.uxnn_backend(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_backend",...)|
|3|uxnn_seed|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn.uxnn_seed(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_seed",...)|
|4|uxnn_act|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn.uxnn_act(...)  \|  sonuc = CALL(DLL,"uxnn.dll","uxnn_act",...)|
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
- **1. `uxnn_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxnn_backend`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxnn_seed`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxnn_act`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxnn_neuron_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxnn_neuron_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxnn_neuron_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxnn_neuron_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxnn_neuron_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxnn_neuron_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxnn_neuron_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxnn_layer_dense_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxnn_layer_activation_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxnn_layer_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxnn_layer_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxnn_layer_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxnn_layer_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxnn_layer_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxnn_layer_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxnn_layer_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxnn_layer_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxnn_layer_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxnn_network_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxnn_network_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxnn_network_add_layer`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxnn_network_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxnn_network_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxnn_network_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxnn_network_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxnn_network_predict_argmax_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxnn_network_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxnn_network_train_mse_sgd_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|17|uxnn2_backend|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn2.uxnn2_backend(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_backend",...)|
|18|uxnn2_seed|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn2.uxnn2_seed(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_seed",...)|
|19|uxnn2_network_create|Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır.|sonuc = uxnn2.uxnn2_network_create(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_create",...)|
|20|uxnn2_network_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxnn2.uxnn2_network_free(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_free",...)|
|21|uxnn2_network_add_dense|Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar.|sonuc = uxnn2.uxnn2_network_add_dense(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_network_add_dense",...)|
|22|uxnn2_train_sample_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_train_sample_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_train_sample_mse_ptr",...)|
|23|uxnn2_train_array_mse_ptr|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn2.uxnn2_train_array_mse_ptr(...)  \|  sonuc = CALL(DLL,"uxnn2.dll","uxnn2_train_array_mse_ptr",...)|

### uxnn2 fonksiyonlarını okuma yöntemi
- **1. `uxnn2_network_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxnn2_network_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxnn2_network_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxnn2_network_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxnn2_set_optimizer`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxnn2_set_optimizer_params`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxnn2_forward_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxnn2_loss_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxnn2_predict_argmax_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxnn2_get_weight`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxnn2_set_weight`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxnn2_get_bias`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxnn2_set_bias`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxnn2_save`** — Veriyi dosyaya veya dış hedefe yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxnn2_load`** — Dış dosyadan veya kaynaktan veri yükler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxnn2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxnn2_backend`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxnn2_seed`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxnn2_network_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxnn2_network_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxnn2_network_add_dense`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxnn2_train_sample_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxnn2_train_array_mse_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|17|split_copy|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn3.split_copy(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","split_copy",...)|
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
|29|forward_internal|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn3.forward_internal(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","forward_internal",...)|
|30|uxnn3_model_forward1|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_forward1(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_forward1",...)|
|31|uxnn3_model_predict_dataset|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn3.uxnn3_model_predict_dataset(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_predict_dataset",...)|
|32|uxnn3_model_predict_argmax|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxnn3.uxnn3_model_predict_argmax(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_predict_argmax",...)|
|33|train_one|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxnn3.train_one(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","train_one",...)|
|34|uxnn3_model_train_dataset|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_train_dataset(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_train_dataset",...)|
|35|uxnn3_model_eval_mse|Model hatası/kayıp değeri hesaplar.|sonuc = uxnn3.uxnn3_model_eval_mse(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_eval_mse",...)|
|36|uxnn3_model_eval_binary_accuracy|Model yolu, model varlığı veya model durumu ile ilgilenir.|sonuc = uxnn3.uxnn3_model_eval_binary_accuracy(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_eval_binary_accuracy",...)|
|37|uxnn3_model_save|Veriyi dosyaya veya dış hedefe yazar.|sonuc = uxnn3.uxnn3_model_save(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_save",...)|
|38|uxnn3_model_load|Dış dosyadan veya kaynaktan veri yükler.|sonuc = uxnn3.uxnn3_model_load(...)  \|  sonuc = CALL(DLL,"uxnn3.dll","uxnn3_model_load",...)|

### uxnn3 fonksiyonlarını okuma yöntemi
- **1. `uxnn3_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxnn3_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxnn3_dataset_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxnn3_dataset_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxnn3_dataset_rows`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxnn3_dataset_input_dim`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxnn3_dataset_output_dim`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxnn3_dataset_x_ptr`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxnn3_dataset_y_ptr`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxnn3_dataset_x_get`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxnn3_dataset_y_get`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxnn3_dataset_x_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxnn3_dataset_y_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxnn3_dataset_load_csv`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxnn3_dataset_save_csv`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxnn3_dataset_shuffle`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `split_copy`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxnn3_dataset_split_train`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxnn3_dataset_split_test`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxnn3_dataset_standardize_fit_transform`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxnn3_dataset_minmax_fit_transform`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxnn3_model_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxnn3_model_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxnn3_model_add_dense`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxnn3_model_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxnn3_model_set_optimizer`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxnn3_model_layer_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxnn3_model_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `forward_internal`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxnn3_model_forward1`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxnn3_model_predict_dataset`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxnn3_model_predict_argmax`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `train_one`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxnn3_model_train_dataset`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxnn3_model_eval_mse`** — Model hatası/kayıp değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxnn3_model_eval_binary_accuracy`** — Model yolu, model varlığı veya model durumu ile ilgilenir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxnn3_model_save`** — Veriyi dosyaya veya dış hedefe yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxnn3_model_load`** — Dış dosyadan veya kaynaktan veri yükler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|8|uxonnx_input_name|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxonnx.uxonnx_input_name(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_input_name",...)|
|9|uxonnx_output_name|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxonnx.uxonnx_output_name(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_output_name",...)|
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
|22|uxonnx_run1_f32|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxonnx.uxonnx_run1_f32(...)  \|  sonuc = CALL(DLL,"uxonnx.dll","uxonnx_run1_f32",...)|

### uxonnx fonksiyonlarını okuma yöntemi
- **1. `uxonnx_global_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxonnx_runtime_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxonnx_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxonnx_session_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxonnx_session_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxonnx_input_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxonnx_output_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxonnx_input_name`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxonnx_output_name`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxonnx_tensor_create_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxonnx_tensor_create_1d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxonnx_tensor_create_2d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxonnx_tensor_create_3d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxonnx_tensor_create_4d_f32`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxonnx_tensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxonnx_tensor_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxonnx_tensor_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxonnx_tensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxonnx_tensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxonnx_tensor_set_f32`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxonnx_tensor_get_f32`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxonnx_run1_f32`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|39|uxonnx2_run_execute|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxonnx2.uxonnx2_run_execute(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run_execute",...)|
|40|uxonnx2_result_free|Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler.|sonuc = uxonnx2.uxonnx2_result_free(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_free",...)|
|41|uxonnx2_result_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxonnx2.uxonnx2_result_count(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_count",...)|
|42|uxonnx2_result_tensor|Çok boyutlu tensör oluşturur, okur veya yönetir.|sonuc = uxonnx2.uxonnx2_result_tensor(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_result_tensor",...)|
|43|uxonnx2_run1|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxonnx2.uxonnx2_run1(...)  \|  sonuc = CALL(DLL,"uxonnx2.dll","uxonnx2_run1",...)|

### uxonnx2 fonksiyonlarını okuma yöntemi
- **1. `uxonnx2_last_error`** — Son hata mesajını verir; başarısız çağrıdan hemen sonra okunur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxonnx2_init`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxonnx2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxonnx2_provider_available`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxonnx2_session_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxonnx2_session_create_advanced`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxonnx2_session_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxonnx2_session_input_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxonnx2_session_output_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxonnx2_session_input_name`** — ONNX veya dış çalışma oturumu yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxonnx2_session_output_name`** — ONNX veya dış çalışma oturumu yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxonnx2_session_input_dtype`** — ONNX veya dış çalışma oturumu yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxonnx2_session_output_dtype`** — ONNX veya dış çalışma oturumu yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxonnx2_session_input_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxonnx2_session_output_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxonnx2_session_input_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxonnx2_session_output_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxonnx2_tensor_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxonnx2_tensor_create_1d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxonnx2_tensor_create_2d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxonnx2_tensor_create_3d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxonnx2_tensor_create_4d`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxonnx2_tensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxonnx2_tensor_dtype`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxonnx2_tensor_rank`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxonnx2_tensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxonnx2_tensor_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxonnx2_tensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxonnx2_tensor_set_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxonnx2_tensor_get_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxonnx2_tensor_set_i64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxonnx2_tensor_get_i64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxonnx2_tensor_set_string`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxonnx2_tensor_get_string`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxonnx2_run_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxonnx2_run_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxonnx2_run_add_input`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxonnx2_run_add_output`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxonnx2_run_execute`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxonnx2_result_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxonnx2_result_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxonnx2_result_tensor`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **43. `uxonnx2_run1`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|4|uxstats_vec_clear|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_clear(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_clear",...)|
|5|uxstats_vec_count|Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir.|sonuc = uxstats.uxstats_vec_count(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_count",...)|
|6|uxstats_vec_capacity|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_capacity(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_capacity",...)|
|7|uxstats_vec_push|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats.uxstats_vec_push(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_push",...)|
|8|uxstats_vec_set|Ayar, hücre, ağırlık veya parametre yazar.|sonuc = uxstats.uxstats_vec_set(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_set",...)|
|9|uxstats_vec_get|Ayar, hücre, ağırlık veya parametre okur.|sonuc = uxstats.uxstats_vec_get(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_get",...)|
|10|uxstats_sum_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_sum_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_sum_f64",...)|
|11|uxstats_mean_f64|Ortalama hesaplar.|sonuc = uxstats.uxstats_mean_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_mean_f64",...)|
|12|uxstats_min_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_min_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_min_f64",...)|
|13|uxstats_max_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_max_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_max_f64",...)|
|14|uxstats_variance_pop_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_variance_pop_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_variance_pop_f64",...)|
|15|uxstats_variance_samp_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_variance_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_variance_samp_f64",...)|
|16|uxstats_stddev_pop_f64|Standart sapma hesaplar.|sonuc = uxstats.uxstats_stddev_pop_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_stddev_pop_f64",...)|
|17|uxstats_stddev_samp_f64|Standart sapma hesaplar.|sonuc = uxstats.uxstats_stddev_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_stddev_samp_f64",...)|
|18|uxstats_median_f64|Ortanca değer hesaplar.|sonuc = uxstats.uxstats_median_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_median_f64",...)|
|19|uxstats_percentile_f64|Yüzdelik değer hesaplar.|sonuc = uxstats.uxstats_percentile_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_percentile_f64",...)|
|20|uxstats_covariance_samp_f64|Varyans hesaplar.|sonuc = uxstats.uxstats_covariance_samp_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_covariance_samp_f64",...)|
|21|uxstats_correlation_f64|İki değişken arasındaki ilişki katsayısını hesaplar.|sonuc = uxstats.uxstats_correlation_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_correlation_f64",...)|
|22|uxstats_regression_slope_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_regression_slope_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_slope_f64",...)|
|23|uxstats_regression_intercept_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_regression_intercept_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_intercept_f64",...)|
|24|uxstats_regression_r2_f64|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_regression_r2_f64(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_regression_r2_f64",...)|
|25|uxstats_vec_sum|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_sum(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_sum",...)|
|26|uxstats_vec_mean|Ortalama hesaplar.|sonuc = uxstats.uxstats_vec_mean(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_mean",...)|
|27|uxstats_vec_min|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_min(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_min",...)|
|28|uxstats_vec_max|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_max(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_max",...)|
|29|uxstats_vec_range|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_range(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_range",...)|
|30|uxstats_vec_variance_pop|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_variance_pop(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_variance_pop",...)|
|31|uxstats_vec_variance_samp|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_variance_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_variance_samp",...)|
|32|uxstats_vec_stddev_pop|Standart sapma hesaplar.|sonuc = uxstats.uxstats_vec_stddev_pop(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_stddev_pop",...)|
|33|uxstats_vec_stddev_samp|Standart sapma hesaplar.|sonuc = uxstats.uxstats_vec_stddev_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_stddev_samp",...)|
|34|uxstats_vec_median|Ortanca değer hesaplar.|sonuc = uxstats.uxstats_vec_median(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_median",...)|
|35|uxstats_vec_percentile|Yüzdelik değer hesaplar.|sonuc = uxstats.uxstats_vec_percentile(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_percentile",...)|
|36|uxstats_vec_covariance_samp|Varyans hesaplar.|sonuc = uxstats.uxstats_vec_covariance_samp(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_covariance_samp",...)|
|37|uxstats_vec_correlation|İki değişken arasındaki ilişki katsayısını hesaplar.|sonuc = uxstats.uxstats_vec_correlation(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_correlation",...)|
|38|uxstats_vec_regression_slope|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_slope(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_slope",...)|
|39|uxstats_vec_regression_intercept|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_intercept(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_intercept",...)|
|40|uxstats_vec_regression_r2|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats.uxstats_vec_regression_r2(...)  \|  sonuc = CALL(DLL,"uxstats.dll","uxstats_vec_regression_r2",...)|

### uxstats fonksiyonlarını okuma yöntemi
- **1. `uxstats_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxstats_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxstats_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxstats_vec_clear`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxstats_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxstats_vec_capacity`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxstats_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxstats_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxstats_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxstats_sum_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxstats_mean_f64`** — Ortalama hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxstats_min_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxstats_max_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxstats_variance_pop_f64`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxstats_variance_samp_f64`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxstats_stddev_pop_f64`** — Standart sapma hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxstats_stddev_samp_f64`** — Standart sapma hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxstats_median_f64`** — Ortanca değer hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxstats_percentile_f64`** — Yüzdelik değer hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxstats_covariance_samp_f64`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxstats_correlation_f64`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxstats_regression_slope_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxstats_regression_intercept_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxstats_regression_r2_f64`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxstats_vec_sum`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxstats_vec_mean`** — Ortalama hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxstats_vec_min`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxstats_vec_max`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxstats_vec_range`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxstats_vec_variance_pop`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxstats_vec_variance_samp`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxstats_vec_stddev_pop`** — Standart sapma hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxstats_vec_stddev_samp`** — Standart sapma hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxstats_vec_median`** — Ortanca değer hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxstats_vec_percentile`** — Yüzdelik değer hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxstats_vec_covariance_samp`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxstats_vec_correlation`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxstats_vec_regression_slope`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxstats_vec_regression_intercept`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxstats_vec_regression_r2`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
|23|uxstats2_one_sample_z_stat|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_one_sample_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_z_stat",...)|
|24|uxstats2_one_sample_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_sample_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_sample_z_p",...)|
|25|uxstats2_two_sample_z_stat|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_two_sample_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_sample_z_stat",...)|
|26|uxstats2_two_sample_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_sample_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_sample_z_p",...)|
|27|uxstats2_one_prop_z_stat|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_prop_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_prop_z_stat",...)|
|28|uxstats2_one_prop_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_one_prop_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_one_prop_z_p",...)|
|29|uxstats2_two_prop_z_stat|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_prop_z_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_prop_z_stat",...)|
|30|uxstats2_two_prop_z_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_two_prop_z_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_two_prop_z_p",...)|
|31|uxstats2_f_variance_stat|Varyans hesaplar.|sonuc = uxstats2.uxstats2_f_variance_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_f_variance_stat",...)|
|32|uxstats2_f_variance_p|Varyans hesaplar.|sonuc = uxstats2.uxstats2_f_variance_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_f_variance_p",...)|
|33|uxstats2_chisq_gof_stat|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_chisq_gof_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_gof_stat",...)|
|34|uxstats2_chisq_gof_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_chisq_gof_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_gof_p",...)|
|35|uxstats2_chisq_2x2_stat|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_chisq_2x2_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_2x2_stat",...)|
|36|uxstats2_chisq_2x2_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_chisq_2x2_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_chisq_2x2_p",...)|
|37|uxstats2_anova_oneway_f|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_anova_oneway_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_anova_oneway_f",...)|
|38|uxstats2_anova_oneway_p|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_anova_oneway_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_anova_oneway_p",...)|
|39|uxstats2_posthoc_tukey_q|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_posthoc_tukey_q(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_tukey_q",...)|
|40|uxstats2_posthoc_bonferroni_t_p|T testi istatistiği veya olasılığı hesaplar.|sonuc = uxstats2.uxstats2_posthoc_bonferroni_t_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_bonferroni_t_p",...)|
|41|uxstats2_posthoc_scheffe_f|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_posthoc_scheffe_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_posthoc_scheffe_f",...)|
|42|uxstats2_regression_slope|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_regression_slope(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_slope",...)|
|43|uxstats2_regression_intercept|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_regression_intercept(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_intercept",...)|
|44|uxstats2_regression_r2|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_regression_r2(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_r2",...)|
|45|uxstats2_regression_f|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_regression_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_f",...)|
|46|uxstats2_regression_f_p|F testi veya varyans analizi olasılığı hesaplar.|sonuc = uxstats2.uxstats2_regression_f_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_regression_f_p",...)|
|47|uxstats2_vif_pair|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_vif_pair(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_vif_pair",...)|
|48|uxstats2_durbin_watson|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_durbin_watson(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_durbin_watson",...)|
|49|uxstats2_breusch_godfrey_lm|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_breusch_godfrey_lm(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_breusch_godfrey_lm",...)|
|50|uxstats2_breusch_godfrey_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_breusch_godfrey_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_breusch_godfrey_p",...)|
|51|uxstats2_adf_stat|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_adf_stat(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_adf_stat",...)|
|52|uxstats2_adf_p_approx|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_adf_p_approx(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_adf_p_approx",...)|
|53|uxstats2_ancova_binary_f|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_ancova_binary_f(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_ancova_binary_f",...)|
|54|uxstats2_ancova_binary_p|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_ancova_binary_p(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_ancova_binary_p",...)|
|55|uxstats2_hotelling_t2_2d|Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir.|sonuc = uxstats2.uxstats2_hotelling_t2_2d(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_hotelling_t2_2d",...)|
|56|uxstats2_hotelling_p_2d|Dağılım olasılığı veya p değeri hesaplar.|sonuc = uxstats2.uxstats2_hotelling_p_2d(...)  \|  sonuc = CALL(DLL,"uxstats2.dll","uxstats2_hotelling_p_2d",...)|

### uxstats2 fonksiyonlarını okuma yöntemi
- **1. `uxstats2_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxstats2_vec_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxstats2_vec_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxstats2_vec_push`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxstats2_vec_set`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxstats2_vec_get`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxstats2_vec_count`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxstats2_covariance_samp`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxstats2_correlation`** — İki değişken arasındaki ilişki katsayısını hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxstats2_normal_cdf`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxstats2_normal_p2`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxstats2_t_p2`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxstats2_chisq_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxstats2_f_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxstats2_one_sample_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxstats2_one_sample_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxstats2_welch_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxstats2_welch_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxstats2_pooled_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxstats2_pooled_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxstats2_paired_t_stat`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxstats2_paired_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxstats2_one_sample_z_stat`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxstats2_one_sample_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxstats2_two_sample_z_stat`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxstats2_two_sample_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxstats2_one_prop_z_stat`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxstats2_one_prop_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxstats2_two_prop_z_stat`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxstats2_two_prop_z_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxstats2_f_variance_stat`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxstats2_f_variance_p`** — Varyans hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxstats2_chisq_gof_stat`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxstats2_chisq_gof_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxstats2_chisq_2x2_stat`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxstats2_chisq_2x2_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxstats2_anova_oneway_f`** — F testi veya varyans analizi olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxstats2_anova_oneway_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxstats2_posthoc_tukey_q`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxstats2_posthoc_bonferroni_t_p`** — T testi istatistiği veya olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxstats2_posthoc_scheffe_f`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxstats2_regression_slope`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **43. `uxstats2_regression_intercept`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **44. `uxstats2_regression_r2`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **45. `uxstats2_regression_f`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **46. `uxstats2_regression_f_p`** — F testi veya varyans analizi olasılığı hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **47. `uxstats2_vif_pair`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **48. `uxstats2_durbin_watson`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **49. `uxstats2_breusch_godfrey_lm`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **50. `uxstats2_breusch_godfrey_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **51. `uxstats2_adf_stat`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **52. `uxstats2_adf_p_approx`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **53. `uxstats2_ancova_binary_f`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **54. `uxstats2_ancova_binary_p`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **55. `uxstats2_hotelling_t2_2d`** — Kütüphanenin kendi alanındaki yardımcı işi yapar; çağrıdan sonra dönüş değeri ve hata durumu kontrol edilir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **56. `uxstats2_hotelling_p_2d`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
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
- **1. `uxtensor_version`** — Kütüphane sürüm bilgisini verir; uyumluluk kontrolünde kullanılır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **2. `uxtensor_backend`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **3. `uxtensor_create`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **4. `uxtensor_create1d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **5. `uxtensor_create2d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **6. `uxtensor_create3d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **7. `uxtensor_create4d_f64`** — Yeni çalışma nesnesi, oturum, veri kümesi veya tampon açar; dönen handle saklanır. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **8. `uxtensor_free`** — Açılmış handle, oturum veya belleği kapatır; kaynak sızıntısını önler. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **9. `uxtensor_clone`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **10. `uxtensor_reshape_copy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **11. `uxtensor_slice_axis0_copy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **12. `uxtensor_dtype`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **13. `uxtensor_ndim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **14. `uxtensor_dim`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **15. `uxtensor_stride`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **16. `uxtensor_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **17. `uxtensor_elem_size`** — Boyut, satır, sütun, derece veya eleman sayısı bilgisini verir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **18. `uxtensor_data_ptr`** — Dağılım olasılığı veya p değeri hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **19. `uxtensor_fill_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **20. `uxtensor_zero`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **21. `uxtensor_get_flat_f64`** — Ayar, hücre, ağırlık veya parametre okur. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **22. `uxtensor_set_flat_f64`** — Ayar, hücre, ağırlık veya parametre yazar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **23. `uxtensor_get2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **24. `uxtensor_set2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **25. `uxtensor_get3d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **26. `uxtensor_set3d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **27. `uxtensor_get4d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **28. `uxtensor_set4d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **29. `uxtensor_add_f64`** — Toplama, kenar ekleme, eleman ekleme veya model parçası ekleme işi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **30. `uxtensor_sub_f64`** — Çıkarma işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **31. `uxtensor_mul_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **32. `uxtensor_div_f64`** — Bölme işlemi yapar; sıfıra bölmeye karşı kontrol ister. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **33. `uxtensor_scale_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **34. `uxtensor_sum_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **35. `uxtensor_mean_f64`** — Ortalama hesaplar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **36. `uxtensor_blas_ddot`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **37. `uxtensor_blas_daxpy`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **38. `uxtensor_blas_dscal`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **39. `uxtensor_dot_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **40. `uxtensor_norm2_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **41. `uxtensor_blas_dgemm_rowmajor`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **42. `uxtensor_matmul2d_f64`** — Çarpma, matris çarpımı veya doğrusal cebir işlemi yapar. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **43. `uxtensor_transpose2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
- **44. `uxtensor_matvec2d_f64`** — Çok boyutlu tensör oluşturur, okur veya yönetir. Kullanırken dönüş değerini bir değişkene al; değer handle ise sıfır/null kontrolü yap, sayıysa beklenen aralıkta mı bak, metinse boş mu kontrol et.
### Anlamlı örnek
```uxbasic
INCLUDE "include/modules/uxtensor.uxmh"
t = uxtensor.create4d_f64(2,3,4,5)
CALL uxtensor.set(t, 1,1,1,1, 42.0)
PRINT uxtensor.get(t, 1,1,1,1)
CALL uxtensor.free(t)
```

