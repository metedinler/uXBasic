# Eski AST-x64 yolu: ölçüm ve bulgular (Claude, 2026-10-14 12:00–13:15)

Durum: **işlendi (2026-10-14, öğleden sonra).** Bu dosyadaki kusurlar kılavuz kataloğuna (`tools/kitap/kilavuz_v2/veri/sinirlar.txt`, Ek G) ve `SORUN_TAKIP.md`'ye ayrı kayıt olarak girdi: S-524 … S-531, S-533, S-534, S-536, S-538 (eski AST-x64), S-532, S-537, S-541 (AST ve ortak), S-535, S-539, S-540 (AST gerilemeleri, model paketlerinde bulundu), S-542 (test koşucusu). Eşleme: `veri/sorun_eslemesi.txt`. Aşağıdaki metin ilk ham kayıttır; kayıtlı hâli ve güncel durum SORUN_TAKIP'tadır. Kılavuz: Bölüm 1.3 "Eski AST-x64 yolunun ölçülen durumu", 7.6, 21, Ek K.
Ölçülen ikililer: `bin\uxb_kilavuz_20261014_0253.exe` (referans) ve `bin\uxb_kilavuz_20261007.exe`. Aşağıdaki kusurların **hepsi 20261007'de de aynıdır** (gerileme değil, eski kusur).
Hiçbir kaynak dosyaya (`src/`) dokunulmadı; yalnız `bld --build-x64 --x64-mode AST` ile derlenip çalıştırıldı.

## 1. Ölçüm sayıları

282 kılavuz örneği eski AST-x64 ile (0253): GEÇTİ 175 · ACIK_RET 42 · BEKLENTI_YOK 27 · FARKLI 14 · HATA 24.
`48_kv_veri/kayit_siralama` paralel koşu gürültüsüdür (iki ikiliyle tek tek 3/3 geçer) → gerçek: GEÇTİ 176, HATA 23.
GEÇTİ olmayan 107 örnek 20261007 ile de koşuldu: 19 değişen; gerçek olanlar yalnız `rational_harmonik` (FARKLI → açık ret, S-499 iyileşmesi) ve `kutuphane_dil_zinciri` (zaman aşımı → açık ret); gerisi geçici yol ve çöp adres farkı.
303 iddia vakası (eski AST-x64, 10-07 ↔ 0253): 8 değişiklik, **hepsi iyileşme** (MAGIC AND/OR/XOR `0` → `4`/`12`/`8` doğru; `5 + "a"` ve bilinmeyen FFI tipi açık ret; `swap`/`sleep`/`with` parantezsiz çağrı `UXB_CALL_PAREN_REQUIRED`).
Ham sonuçlar: `docs/kitaplar/_ortak/ornek_sonuclari_astx64_20261014_0253.json` (282), `.../ornek_sonuclari_astx64_20261007_secili.json` (107), CLI taraması `.../cli_tarama_raporu_20261014_0253.json`.

## 2. Açık ret grupları (66 örnek, derleme aşamasında)

| Adet | İleti / neden |
|---|---|
| 13 | `build_all.bat failed`; gerçek neden `build_all.stderr.txt` içinde: NASM `symbol 'trim'/'atn'/'CDBL'/'dictset'/'dictlen'/'dictget'/'dicthas'/'dict_new'/'list_new'/'setadd'/'setlen'/'topla'/'__uxb_slot_cb_1'/'__uxb_ffi_arg_*' not defined`, bağlayıcı `undefined reference to uxb_f80_from_str/uxb_f80_to_str` |
| 10 | SPAWN/TASK/TASKGROUP desteklenmiyor (kalıcı sınır) |
| 5 / 5 / 3 / 1 | rutinden atılan istisna / `DIM ATOMIC` / `LOCK` / `MUTEX` desteklenmiyor |
| 2 | `BYREF` desteklenmiyor |
| 4 + 2 | çok boyutlu dizi elemanına atama (`assignment target must be identifier/index/field`) ve `LBOUND/UBOUND` (REDIM'li ya da çok boyutlu dizi) |
| 5 | `FOR EACH` LIST/STRING/DICT için `no native x64 iterator ABI yet` |
| 5 | `interface/virtual method slot not found`, `cannot use CALL_EXPR as float`, boş iletili `x64 build basarisiz:`, `unsupported AST node kind=END_STMT` (GOSUB/RETURN), `kind=NUMBER` |
| 1 | `RATIONAL` → `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` (doğru) |

## 3. Sessiz yanlış ve çökme kusurları (önerilen katalog kimlikleri)

Her birinin en küçük programı aşağıdadır; `bin\uxb_kilavuz_20261014_0253.exe bld p.uxb --build-x64 --x64-mode AST --build-x64-out p.exe` sonra `p.exe`.

1. **G-ISLEC-11 (SESSİZ): `F64`/`F32` değişkende tekli eksi bit düzenini tamsayı olarak eksiltir.**
   `DIM x AS F64 = -2.5` / `x = -x` / `PRINT x` → `4.610560118520545e+18` (beklenen `2.5`). `PRINT -a` (`a = 2.5`) → `-4612811918334230528`; `F32` → `-1075838976`; `-e(0)`, `-(a + 1)`, `ABS(-a)`, `RETURN -v` de bozuk. Doğru: tamsayı `-c`, sabit `-2.5`, `0 - a`, `a * -1`. Diğer beş yol doğru. Çözüm: `0 - x`.
2. **G-ISLEC-12 (SESSİZ, eski S-086):** `DIM a AS I32 = 7` / `DIM b AS I32 = 2` / `PRINT a / b` → `3` (diğerleri `3.5`); `c = a / b` ile `F64` değişkene atanınca `3.5` doğru. `PRINT CDBL(a)` derlenmez (`symbol CDBL not defined`). `DIM u AS U64 = 18446744073709551615` / `f = u` → `-1`.
3. **G-ISLEC-13 (ÇÖKME):** içinde `PRINT` (ya da `PRINT` yapan `SUB` çağrısı) olan bir işlev tamsayı ikili işlemin **sağ** işleneniyse program iletisiz çöker (`0xC0000005`, hiçbir çıktı yok).
   `FUNCTION Yn(d AS I32) AS I32 : PRINT d : RETURN d : END FUNCTION` / `DIM r AS I32` / `r = 6 + Yn(3)` / `PRINT r` → diğer yollar `3`, `9`. Aynı: `0 AND`, `6 *`, `5 >`, `Yn(1) + Yn(2)`. Çökmeyen: işlev sol işlenen, `F64` toplama, `ANDALSO`, `IFF`, `LEN/SQR/STR` içeren işlev, sonucu önce değişkene almak. Örnek: `44_kv_isleclar/secim_kisa_devre`.
4. **G-TIP-28 (SESSİZ): rutin içindeki yerel tamsayı değişken ondalık işlemde bit düzeni olarak okunur.**
   `FUNCTION Ff() AS F64 : DIM v AS F64 = 0.95 : DIM k AS I64 = 10000 : RETURN v * k` → `4.693623635491842e-320` (beklenen `9500`); `v + k` → `0.95`; `v / k` → `inf`; yerel `I32` ile `1.8e+185`. Aynı kod ana programda, `MAIN` içinde, genel değişkenle ya da parametreyle doğru. Örnek: `64_kv_kutuphane/gsl_hesap_defteri`.
5. **G-YORDAM-7 (SESSİZ): yerel değişken sıfırlanmaz, önceki çağrının yığın değerini taşır.**
   `SUB Kirlet()` dört yerel `99` yazar; sonra `FUNCTION Oku() AS I32 : DIM n AS I32 : RETURN n` → `99` (beklenen `0`); `F64` yerel `6.95e-310`. Örnek: `44_kv_isleclar/bit_sayma` ilk çağrıda `32767`.
6. **G-METIN-6 (SESSİZ, eski S-157-L, ACIK 2026-09-26) — KAPSAMI SONRADAN GENİŞLEDİ:** `STR(...)` sonucu tek yuvadadır (bir sonraki `STR` ezer); birleştirme ve `LEFT` sonucu 32 yuvalık halkadadır: birleştirmeyle atanan `STRING` değişkeni 32 metin işleminden sonra başka metne dönüşür (`a = "abc" + "def"` + 40 tur `t = "x" + "y"` → `PRINT a` `xy`). İlk tanım (STR, kütüphane sonucu) şöyleydi:
   `DIM a AS STRING = STR(5000)` / `DIM b AS STRING = STR(4)` / `PRINT a` → `4` (beklenen `5000`); `a = STR(111)`, `b = STR(222)`, `a <> b` → `ayni`; `FUNCTION F(n AS I32) AS STRING : RETURN STR(n)` ile `a = F(1234)`, `b = F(5)` → `a` = `5`. Birleştirme (`"x" + STR(1)`), `LEFT`, `RIGHT` kopyalar, doğru. Çözüm: `"" + STR(n)`.
   **Yama ile doğrulandı** (`""` + kopya ve `0 - x` yamasıyla eski AST-x64'te GEÇTİ): `istatistik_regresyon`, `matris_denklem`, `tensor_not_analizi`, `maliyet_ve_buyume`, `sinir_agi_xor`, `gsl_geri_cagri_integral`, `tampon_goruntu`, `ayar_gunluk_surec` (`uxconfig.GetString` kopyası). Aynı kalıp: `ilk_adim` (`a <> b` yanlış → "iki uuid farkli" satırı yok).
7. **G-DOSYA-7 (ÇÖKME):** `OPEN "d.txt" FOR OUTPUT AS #1` / `PRINT #1, 10` → çöker. `PRINT #1, n` (`I32` değişken), `PRINT #1, "a"; 5` de çöker; `PRINT #1, "abc"`, `PRINT #1, STR(10)`, `PRINT #1, 2.5`, metin değişkeni çalışır. Örnek: `51_kv_dosya/dosya_toplam`.
8. **G-DOSYA-8 (FARK):** satır sonu `LF` (diğerleri `CR LF`): `PRINT #1, "abc"` sonra `LOF` → `4` (diğerleri `5`); iki satır `6` / `8`. Kitap `LOF` için "CR+LF dahil" der. Örnek: `11_io/lof`.
9. **G-VERI-13 (SESSİZ + ÇÖKME): `REDIM` ile büyütülen dizi gerçekte büyümez, yeni elemanlar komşu belleğe yazar.**
   `DIM z AS I32 = 123` / `DIM e(0 TO 1) AS I32` / `DIM y AS I32 = 456` / `REDIM PRESERVE e(0 TO 4) AS I32` / `FOR i = 0 TO 4 : e(i) = i * 10 : NEXT` → sonra `PRINT e(3)`, `PRINT e(4)`, `PRINT y` → `3`, `4`, `20` (beklenen `30`, `40`, `456`; sayılar yerleşime göre değişir, ör. başka bir programda `31`, `4`, `123`, `20`). `e(3) = 8` sonrası `PRINT e(0); " "; e(1)` ayırıcı metin sabitini bozar (`567 8`). Yerel dizide `REDIM`: çıktı doğru, **SUB çıkışında çöker**. `UBOUND` REDIM'li dizide açıkça reddedilir. Örnek: `15_tipler/const_dim_redim` (`7<TAB>09`).
10. **G-AKIS-3 (SESSİZ): `F64` `FOR` sayacı tamsayı gibi artırılır.** `DIM x AS F64` / `FOR x = -2 TO 2 : PRINT x : NEXT` → `-nan -nan 0 4.9e-324 9.9e-324`; `STEP 0.5` sonsuz döngü (zaman aşımı). AST'de ondalık adım G-AKIS-1. Örnek: `ai_siniflandirici_cikisi` (yamadan sonra da bu yüzden FARKLI).
11. **G-MODUL-5 (SESSİZ): `MODULE` içi değişken okunamaz.** `MODULE Depo : DIM adet AS I32 : SUB Koy(n AS I32) : adet = n : END SUB : FUNCTION Say() AS I32 : RETURN adet : END FUNCTION : END MODULE` / `MAIN : Depo.Koy(10) : PRINT Depo.Say() : END MAIN` → `140696778254814` (adres benzeri, her çalıştırmada değişir; beklenen `10`). `DIM adet AS I32 = 5` okuması `0`. Modülsüz genel değişken doğru. Örnek: `61_kv_modul/stok_moduller`.
12. **G-HATA-14 (AÇIK):** desteklenmeyen yerleşik ve özellikler assembler ya da bağlayıcı hatasıyla bildirilir; kullanıcı yalnız `build_all.bat failed with exit code 1` görür (bkz. 2. bölüm, 13 örnek). Beklenen: bu bölümdeki gibi anlaşılır "desteklenmiyor" iletisi.
13. **G-TIP-1 güncellemesi (SESSİZ):** `BIGINT` programı eski AST-x64'te reddedilmez, çöp yazar (`buyuk_sayi_bigint`: `2277928407372 | -449071402122793328 | 4555856880280`; MIR hep `0`, MIR-x64 derlenmez, WASM reddeder).

## 4. (ÇÖZÜLDÜ, aynı gün) `csv_model_egitimi` ve `dosya_butunluk_sikistirma`: neden eski AST-x64 metin halkası (G-METIN-6, S-528) — metin işlemi sonuçları 32 yuvalık halkada tutulur, birleştirmeyle atanan değişken 32 işlemden sonra başka metne dönüşür; yolu kullanımdan önce yeniden atayınca ya da metin döngüsünü yoldan önce yapınca ikisi de geçer. Aşağıdaki özgün bisect notu tarihsel kayıttır.

`64_kv_kutuphane/csv_model_egitimi` ("ASSERT failed: CSV yazilamadi") ve `64_kv_kutuphane/dosya_butunluk_sikistirma` ("yazilan bayt: -1") STR/kopya yamasıyla da düzelmiyor. En küçük yeniden üretim (eski AST-x64 `yazilan bayt: -1`, MIR-x64 `7692`):

```
INCLUDE "include/modules/uxfs.uxmh"
INCLUDE "include/modules/uxsystem.uxmh"
MAIN
    DIM klasor AS STRING
    DIM dosya AS STRING
    DIM metin AS STRING = ""
    DIM i AS I32
    DIM rc AS I32
    DIM boyut AS I64
    klasor = uxsystem.TempDirectory() + "\uxb_bis_v1"
    dosya = klasor + "\veri.txt"
    rc = uxfs.CreateDirectory(klasor)
    FOR i = 1 TO 200
        metin = metin + "satir " + STR(i) + ": uXBasic sikistirma denemesi" + CHR(10)
    NEXT
    rc = uxfs.WriteAllText(dosya, metin)
    boyut = uxfs.FileSize(dosya)
    PRINT "yazilan bayt: "; boyut
    rc = uxfs.DeleteFile(dosya)
    rc = uxfs.RemoveDirectory(klasor)
END MAIN
```

Elenenler: uzunluk sınırı (3000–20000 karakter doğru), `WriteAllText`/`FileSize` tek başına, `I64` değişkene atama, kimlik (`NewUuid`) ile klasör adı. Bu programda `"abc"` yazılınca doğru; 200 satırlık `metin` ile `-1`. Sıradaki adım: `rc` ve `dosya` değerlerini yazdırarak hangi çağrının başarısız olduğunu bulmak.

## 5. Yapılacaklar (sırayla) — 1, 2 ve 3. maddeler yapıldı (aşağıdaki özgün liste ilk yazımdır)

1. Bu dosyadaki 1–13 numaralı kusurları `tools/kitap/kilavuz_v2/veri/sinirlar.txt` içine `KAYIT :: Etkilenen :: Tür :: Ne olur? :: Ne yapmalı?` biçiminde ekle (önce `python` ile aile başına en büyük numarayı denetle: G-ISLEC en büyük 10, G-TIP 27, G-YORDAM 6, G-METIN 5, G-DOSYA 6, G-VERI 12, G-AKIS 2, G-MODUL 4, G-HATA 13).
2. `sorun_takibe_isle.py` BULUNDU/DENENEN/ILGILI sözlüklerine ekle (ILGILI: G-ISLEC-12 → S-086; G-METIN-6 → S-157, S-157-L; G-HATA-14 → S-091, S-461) ve çalıştırarak S-524'ten başlayan kayıtları oluştur; G-TIP-1 için S-214'e "Güncelleme" notu.
3. `sablon/01_ilkeler.md` 1.3'e "Eski AST-x64 yolunun ölçülen durumu" alt bölümü (bu dosyanın 1–3. bölümleri), `sablon/90_ekler.md` Ek K.1 "ölçülen" ve K.4 satırları; `python tools/kitap/kilavuz_v2/uret.py --sert` + `tablo_denetle.py` + `python tools/maintenance/uxb_context_index.py build`.
4. Ölçüm hattı (`ardisik5.ps1`) CLI adımını bitirdi; model testleri (`gorunum\model_0253.md`) sürüyor ya da disk bekçisi durdurdu. CLI için `cli_fark.py` (10-07 raporu ↔ 0253) ile Bölüm 2.8 ve S-464 doğrulaması; model sonucunu Ek K'ya.
5. S-523 (AST gerilemesi) Codex'te açık; yeni Codex derlemesi çıkarsa (`bin\uxb.exe` 02:53'ten farklı olunca) `gerileme_sondalari.py` ile kapanışları değer düzeyinde bağımsız doğrula.
