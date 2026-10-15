# 24. Büyük programlar: parçaları birleştirmek

Önceki bölümler dili **parça parça** anlattı. Gerçek bir program ise parçaların birlikte çalışmasıdır: bir veri modeli, iş kuralları, hata yönetimi, çıktı ve sınama. Bu bölümde iki orta büyüklükte program baştan sona anlatılır;
ikisi de gerçek derleyicide AST, MIR ve x64 motorlarında **aynı çıktıyı** verir. Sonra büyük programları dosyalara bölmenin yolu ve hangi bölümlerde başka büyük örnekler olduğu gösterilir.

## 24.1 Büyük bir programı nasıl kurarsınız?

| Adım | Soru | Bu kılavuzda |
|---|---|---|
| 1. Veriyi seçin | Hangi yapı hangi veriyi tutacak? | Bölüm 10 (seçim rehberi), Bölüm 22.4 (iç içe yapılar) |
| 2. Kuralları işlevlere ayırın | Her kural tek bir `SUB`/`FUNCTION` olsun | Bölüm 8 |
| 3. Hatayı baştan düşünün | Beklenen hata `THROW`, varsayım `ASSERT` | Bölüm 12 |
| 4. Çıktıyı ayırın | Hesap ve yazdırma ayrı yordamlarda | Bölüm 9, 13 |
| 5. Hedefi seçin | Yalnız yerel mi, JS de mi? | Bölüm 21 |
| 6. Sınayın | Üç yerel motorda aynı çıktı | Bölüm 1.7, 2.11 |

## 24.2 Program 1: kitap ödünç sistemi

Üç kitaplı küçük bir kütüphane. Kitaplar bir **`TYPE` kayıt dizisinde**, ad → sıra eşlemesi ve üye başına ödünç sayısı **`DICT`**'lerde tutulur. Kurallar üç `THROW` ile korunur: bilinmeyen kitap, stok yok, üye başına iki kitap sınırı.
`Dene` yordamı her işlemi `TRY/CATCH` ile sarar; atılan değer `CATCH`'te alınamadığından (G-HATA-4) hata metni genel bir değişkenle (`sonHata`) taşınır. Sonda kitaplar popülerliğe göre sıralanır ve bir tablo yazdırılır.

{{ORNEK:67_kv_buyuk_program/odunc_sistemi|baslik=Kitap ödünç sistemi}}

Bu programda **bilerek** yapılan seçimler, her biri bir sınırdan kaçınır:

| Seçim | Neden? |
|---|---|
| Kayıt dizisi en başta bildirilir | Programda `ASSERT`/`TRY` var; x64'te çağrıdan sonra `DIM dizi(n)` derlenmez (G-DIL-10) |
| Kayıt dizisine hep değişken indisle yazılır (`kitaplar(kitapSayisi).ad = …`) | Sabit indisle yazıp okumak x64 ve JS'te derlenmez (G-VERI-7) |
| Sıralamada kayıtlar alan alan takas edilir | `kitaplar(j) = kitaplar(j + 1)` AST'de etkisizdir (G-VERI-1) |
| `DICTGET` sonucu `CINT(...)` ile sayıya çevrilir | Sözlük değerleri `OBJECT` döner (Bölüm 10.5) |
| Hata metni genel değişkende taşınır | `CATCH` atılan değeri vermez (G-HATA-4) |
| Üyeler ve kitaplar için sınıf yerine kayıt + sözlük | Sınıf içinde sınıf/kayıt alanı sessiz yanlış verir (G-NESNE-10, G-NESNE-11) |
| JS hedeflenmez | Kayıt dizisi alanına yazma JS'te yürütme anında reddedilir (G-JS-7) |

## 24.3 Program 2: özyinelemeli ifade hesaplayıcı

`"2+3*4"`, `"(2+3)*4"`, `"-(1+2)*3"` gibi metin ifadelerini hesaplar. Dilbilgisi üç basamaktır: `Toplam` (`+`, `-`) `Terim`'leri, `Terim` (`*`, `/`) `Carpan`'ları toplar, `Carpan` bir sayıyı, bir eksi işaretini ya da **parantez içinde yeni bir `Toplam`**'ı çözer.
`Carpan`'dan `Toplam`'a geri dönüş **karşılıklı özyinelemedir**. Metin `MID` ile karakter karakter okunur, konum genel bir değişkende durur. Bozuk ifadeler (`7/0`, `2+`, `(1+2`, `3 $ 4`) açık hata iletisi verir.

{{ORNEK:67_kv_buyuk_program/ifade_hesaplayici|baslik=Özyinelemeli iniş ayrıştırıcıyla ifade hesaplayıcı}}

| Teknik | Not |
|---|---|
| Karşılıklı özyineleme | `Toplam` → `Terim` → `Carpan` → `Toplam`; `DECLARE` yazılmaz (Bölüm 8.4) |
| Karakter karşılaştırması | `c >= "0" AND c <= "9"` metin karşılaştırmasıdır; üç motorda aynı çalışır |
| Ondalık sayı | Tam kısım basamak basamak, kesir `olcek` ile toplanır (`1.5+2.25 = 3.75`) |
| Hata taşıma | `THROW` en içteki işlevde, `TRY/CATCH` yalnız en dışta (`Hesapla`) |
| JS | Bir yordamdan fırlatılan hata çağıranın `TRY`'ıyla yakalanmaz (G-JS-2). `20261007`'de JS `7/0 = undefined` yazıp devam ederdi; `20261013_1514` ve sonrasında yakalanmayan hata `uXBasic runtime error: bolme` yazar, program durur ve çıkış kodu `1` olur (S-444) |

## 24.4 Başka büyük örnekler nerede?

| Konu | Örnek | Bölüm |
|---|---|---|
| Çok modüllü program (`MODULE`, `USING`, nitelikli çağrı) | `61_kv_modul/stok_moduller` | Bölüm 16.2 |
| Altı yapı bir arada: sınıf, özyineleme, `PIPE`, `EVENT`, `THREAD`, `PARALEL`, `ATOMIC` | `66_kv_ic_ice/paradigmalar_birlikte` | Bölüm 22.6 |
| Altı aşamalı kütüphane hattı (JSON → regex → sözlük → istatistik → karar) | `66_kv_ic_ice/kutuphane_dil_zinciri` | Bölüm 22.8 |
| Özyinelemeli görev ağacı | `53_kv_gorev/paralel_fibonacci` | Bölüm 15.4 |
| Veri bilimi: CSV'den model eğitimi | `64_kv_kutuphane/csv_model_egitimi` | Bölüm 20.4 |
| Sinir ağı, tensör, matris, istatistik, zaman, regresyon örnekleri | `64_kv_kutuphane/…` | Bölüm 20.4 |
| uXBasic modülünü DLL yapmak, sınıf kodu üretmek | `dis/uxbdll_ile_dll`, `dis/uxclazz_uretici` | Bölüm 16.9 |
| Derleyiciyi besleyen araçlar (API belgesi, sınama koşucusu) | `meta/ast_api_belgesi`, `meta/test_kosucu_uret` | Bölüm 18.6 |
| Tarayıcıda çalışan program | `web_ornekleri/kare_sayfa.html`, `kare_wasm.html` | Bölüm 21.4, 21.5 |

> **Eski örnek projeler hakkında uyarı (✖ G-BELGE-1).** `docs/uxbasic_5_cilt/examples/projects` altındaki `kargo_merkezi` ve `hibrit_pano` projeleri bu kılavuzun ikilisinde **çalışmaz**: `kargo_merkezi` eski söz dizimini kullanır (`%%PP A`, parametreli `PIPE … OUTPUT`, `CALL LISTADD(…)`) ve
> `semantic-step3: missing type at ast=144 kind=IDENT` ile çıkış 1 verir; `hibrit_pano` AST'de `unsupported call SCREEN`, MIR'de `RT_LIBRARY_CALL` bağlı değil hatasıyla düşer.
> Yeni kodda bu biçimleri yazmayın (⌛ ESKİ); bu kılavuzdaki doğrulanmış örnekleri temel alın.

## 24.5 Büyük programlarla ilgili programlama kararları

* **Önce veri modelini çizin**, sonra işlevleri yazın: hangi veri `TYPE` kayıt dizisinde, hangisi `DICT`/`LIST`'te duracak? Yapıyı seçerken Bölüm 22.4'teki ✖ ve ◌ satırlarından kaçının.
* **Her kuralı tek bir yordama koyun**; hesap ile yazdırmayı ayırın. Böylece aynı kuralı sınamak ve başka bir hedefe taşımak kolaylaşır.
* **Beklenen hataları `THROW`, bozulmaması gereken varsayımları `ASSERT` ile** yazın ve `TRY/CATCH`'i yalnız işlemin en dışında kurun; hata metnini genel bir değişkende taşıyın (G-HATA-4).
* **Dizileri programın en başında bildirin**; `ASSERT`/`TRY` kullanan x64 programlarında çağrıdan sonra `DIM dizi(n)` yazmayın (G-DIL-10).
* Kayıt dizisine **değişken indisle** yazın ve okuyun; kayıtları takas ederken **alanları tek tek** takas edin (G-VERI-7, G-VERI-1).
* Büyük programı **üç yerel motorda** (AST, MIR, x64) çalıştırıp çıktıları karşılaştırın; biri ayrışıyorsa 22.11'deki ve Ek G'deki sınırlara bakın.
* Çok büyük programları `INCLUDE` ile dosyalara bölün, ortak sabitleri modülün **dışında** tanımlayın (G-MODUL-1) ve ad çakışması ihtimali olan yerde nitelikli çağrı (`Modul.Islev()`) yazın.
* **Her büyük programın bir sınama sürümü olsun**: beklenen çıktıyı `'=` satırlarıyla dosyanın başına yazın; kılavuzdaki her örnek bu biçimle doğrulanır.
