# uXBasic Profesyonel Kitaplığı

Bu dizin uXBasic'i kullanmak ve FreeBASIC ile geliştirmek isteyenler için beş
ciltlik kaynak odaklı kitaplığı içerir. Kitaplık, önceki kılavuzların yeniden
düzenlenmiş özeti değildir. Dil ve derleyici sözleşmesi doğrudan `src`,
`libsx`, `runtime_ext`, `tests` ve `xtestx` kaynaklarından çıkarılmıştır.

## Ciltler

| Cilt | Kitap | Ana okur |
|---|---|---|
| I | [Dil, Tip Sistemi ve Araç Zinciri](cilt_1_dil_tip_sistemi_ve_arac_zinciri.md) | uXBasic programcısı |
| II | [Veri Yapıları, Paradigmalar, OOP ve Görevler](cilt_2_veri_yapilari_paradigmalar_oop_gorevler.md) | Uygulama geliştiricisi |
| III | [FreeBASIC ile Derleyici Geliştirme](cilt_3_freebasic_ile_derleyici_gelistirme.md) | Derleyici geliştiricisi |
| IV | [Native Entegrasyon ve Standart Kütüphaneler](cilt_4_native_entegrasyon_ve_kutuphaneler.md) | Sistem ve veri uygulaması geliştiricisi |
| V | [Uygulamalı Büyük Projeler ve Sürüm Mühendisliği](cilt_5_buyuk_projeler_ve_surum_muhendisligi.md) | Takım lideri ve ileri kullanıcı |

## Bilgi güven düzeyi

Kitaplarda üç tür bilgi birbirinden ayrılır:

| İşaret | Anlam |
|---|---|
| **K** | Kaynak kodda lexer/parser/semantik/runtime veya backend uygulaması var. |
| **T** | Kaynağa ek olarak pozitif/negatif test veya bu kitaplığın çalışan örneği var. |
| **S** | Dilin olması gereken sözleşmesi. Mevcut derleyicide kusur görülmüşse düzeltme kapısına alınır. |

Bir anahtar sözcüğün lexer tablosunda bulunması tek başına çalışma kanıtı
değildir. Bir özelliğin “çalışıyor” sayılması için en azından ilgili parser ve
semantik yolunun; yürütülebilir özelliklerde ayrıca AST/MIR yorumlayıcı veya
hedef backend yolunun doğrulanması gerekir.

## Kaynak önceliği

Çelişki olduğunda aşağıdaki sıra kullanılır:

1. `src` ve derlemeye giren FreeBASIC include zinciri.
2. `libsx`, `runtime_ext` ve gerçek DLL dışa aktarımları.
3. Pozitif ve negatif `tests`/`xtestx` vakaları.
4. `bin/uxb.exe` ile yeniden üretilen artifact ve çalışma sonucu.
5. Eski kılavuzlar, `pck_books` belgeleri ve arşivler.

Eski belge yalnız anlatım ve tarihsel karar kaynağıdır. Kaynakla çelişen eski
sözdizimi bu seriye taşınmaz.

## Örnek kaynaklar

Tam programlar [examples](examples) ağacındadır. Kitap içinde kısa sözdizimi
parçaları bulunur; çalıştırılabilir örneklerin asıl kopyası bu ağaçtadır.

| Dizin | İçerik |
|---|---|
| `examples/cilt1` | Tipler, operatörler, önişlemci |
| `examples/cilt2` | Saf fonksiyon, özyineleme, koleksiyon, OOP |
| `examples/cilt3` | Pipeline ve sayısal WAT/WASM modülü |
| `examples/cilt4` | INLINE, IMPORT ve Windows FFI |
| `examples/projects/kargo_merkezi` | Aşamalı native/yorumlayıcı projesi |
| `examples/projects/hibrit_pano` | JS/Canvas ve WAT/WASM projesi |

## Doğrulama ilkesi

Bir komutun başarı kodu tek başına yeterli değildir. Doğrulama şu kanıtları
birlikte arar:

- beklenen `ASSERT` sonuçları ve ayırt edici program çıktısı;
- istenen JSON, ASM, JS, HTML, WAT veya WASM dosyasının gerçekten oluşması;
- JSON dosyasının ayrıştırılması;
- ASM/JS/WAT çıktısında beklenen işlev veya çağrı izinin bulunması;
- üretilen JS/WASM'ın gerçek çalışma ortamında çağrılması;
- negatif testte beklenen tanı ve sıfır olmayan çıkış kodu.

Test sonuçları `reports` altında zaman damgalı olarak tutulur. Kitapta
“geçti” denilen örnek, bu kanıtlardan birine bağlanmalıdır.

## Kapsam sınırları

- uXBasic'in genel değişken adlarında `$`, `%`, `!` gibi tip son ekleri yoktur.
- `#` işareti yalnız dosya kanallarında `PRINT #` ve `INPUT #` gibi biçimlerde
  kullanılır.
- Genel kullanıcı tipi adları `I8..I64`, `U8..U64`, `F32`, `F64`, genişletilmiş
  sayılar ve yapı/nesne tipleridir.
- `F8` ve `F16` genel dil tipi değildir.
- `THREAD` ve `PARALEL` geçerli yazımlardır; benzer İngilizce yazımlar otomatik
  eş ad değildir.
- `|>` ifade operatörü ile `PIPE ... END PIPE` görev bloğu farklı yapılardır.
- `INLINE` başlığı `(arch, assembler, kind, policy)` sözleşmesidir.
- C, C++ ve ASM kaynak birimleri `IMPORT(C|CPP|ASM, yol)` ile eklenir; bunlar
  `INLINE` başlığının yerine geçmez.

## Okuma yolları

Yeni bir uXBasic programcısı I, II, IV ve V. cilt sırasını izlemelidir.
Derleyici geliştiricisi I. cildin araç zinciri bölümlerinden sonra III. cildi,
ardından IV. cildin ABI ve kütüphane bölümlerini okumalıdır.

