# uXBasic tek sorumlu konsolidasyonu

Tarih: 2026-10-06. Sorumlu: Codex. Mete'nin bu tarihteki talimatıyla eski
ajan paylaşımı sona ermiştir. Eski CLAIM ve devir kayıtları tarihsel kanıttır.
Kaynak ve belge silinmez. Mevcut değişiklikler korunur.

Bu belge tamamlanmış derleyici ilanı değildir. Kayıt, tasarım, kaynakta görülen
uygulama, başarılı gerçek çalıştırma ve açık ret birbirinden ayrılır.

## Okuma ve karşılaştırma

Kanonik kaynak `uxb/src`, runtime `uxb/native/uxb_runtime`, dil kütüphaneleri
`uxb/libsx`, kütüphane adaptörleri `uxb/runtime_ext` altındadır. Paket, yama,
GitHub yayını ve RAG kopyaları doğrudan kaynak yerine geçirilmez.

Başlangıçta DURUM, SORULAR_CEVAPLAR, SORUN_TAKIP ve karar defteri;
27/29 Eylül devirleri; 20/23/24 Eylül tasarım birleşimleri ve 28 Eylül yerel
uzman planı karşılaştırıldı. `docs`, varsa `doc`, `docs/tasarim`, `spec` ve kök
Markdown belgeleri içerik indeksine alındı; DOCX metinleri de çıkarıldı.
İndeks, bütün tarihsel iddiaların anlamsal olarak doğrulandığı anlamına gelmez.
PDF, eski DOC ve ZIP içeriği indeks kapsamı dışındadır.

Envanter: `reports/context_index/inventory.json`. Tam başlık konumları:
`reports/context_index/headings.tsv`. Sorun kayıtlarının başlık/ilk durum
alıntıları: `reports/context_index/issues.json`. Kısa durum alıntısı bir sorunun
sonradan kapanıp kapanmadığını kanıtlamaz; bütün bölüm ve ek kayıtlar okunur.

## Tasarım ile kaynak arasındaki başlıca açık sınırlar

| Konu | Kaynak ve önceki kanıt | Kalan kabul koşulu |
|---|---|---|
| S-112/S-134 kütüphane tipi | manifest, MIR provider, COPY/BYVAL/RETURN ve field/array yolları var; 29 Eylül kaydı 34 kontrol | nested managed field, BYREF/escape, sürümlü provider/package/dependency/capability ABI ve gerçek native/JS/WASM provider çalıştırması |
| S-113 tipli pointer | raw PTR bayt aritmetiği var; PTR TO T tasarımı kayıtlı | parser/type/layout/stride, typed dereference ve motor paritesi; F80 payload=10, depolama stride=16 kararını korumak |
| S-135 genel iterator | array/string/LIST/SET/DICT özel yolları var | ortak ITER_CREATE/NEXT/CLOSE, MAGIC ITER, CHAIN/ZIP ve kaynak/ömür kapanışı |
| S-136 meta/generator | ön işlemci komutları ve üreticiler var | sürümlü registry, normal kaynak üretimi, kaynak izi ve tekrar üretilebilir kabul testleri |
| S-146/S-030 görevler | senkron AST/MIR referansı, native worker havuzu ve Model D ilk halkası var | bütün kaynak türlerinin transfer/senkron/ömür sözleşmesi, yardımcı rutin iptali ve JS/WASM eşzamanlılık |
| S-150 web sayılar | WAT/WASM tamsayı yolu ve unsupported tanıları var | gerçek F32/F64 locals/parametre/dönüş/aritmetik/PRINT ve Node çalıştırma kanıtı |
| S-122/S-123 web çağrılar | WASM BYREF ve GOSUB için açık ret kaydı var | gerçek alias ABI ve dönüş adresi yığını; ret testini çalışan destek saymamak |
| S-153 yüzey matrisi | matris üreticilerinin elle yazılmış sınırlı satırlarına ilişkin açık denetim kaydı var | lexer/parser/builtin/type/provider kayıtlarından tam envanter ve her hedefte gerçek probe sonucu |
| S-169/S-191 FFI ölçeği | büyük raymath programında native çökme ve yorumlayıcı yavaşlığı kayıtlı | kök neden, çağrı sayısı ölçek ölçümü, büyük dosyada gerçek dört motor kabulü |
| S-157-L/S-159-L legacy | STRING sahipliği ve bazı aggregate yollarında açık sınırlar var | alias/depo/ömrü ve bütün değer kopyasını gerçek legacy çalıştırmayla doğrulamak |
| S-166 dönüş tipi | FUNCTION/THREAD return tipi denetimi için açık karar/uygulama sınırı var | deklarasyonla gerçek değer türünün uyumu ve bütün motorlarda aynı dönüşüm |

Yeni işler bu sınırlara bağlanır. Güncel probe sonuçları ve kaynak incelemesi,
eski genel başarı sayılarına üstün kanıttır. Bu tablodaki kayıtların çoğu taze
ölçüm gerektirir; önceki çalıştırma sayıları bugünkü başarı olarak sunulmaz.

## Bu çalışmanın uygulama halkası

S-170 matris dışa aktarması: kayıtlı çıktı kökü/oturum yolu kullanılıyor;
boş yol, açma, yazma ve kapatma hatası başarıya çevrilmiyor. Beş JSON dosyası
gerçekten okunuyor; yazılamayan hedefte başarısız çıkış sınanıyor. Bu değişiklik
S-153'teki tam kapsam sorununu kapatmaz.

S-181 EOF/LOF: MIR kanal-provider bağı kuruldu; native EOF doğruluğu -1/0
biçimine getirildi. Legacy EOF lookahead ve STRING dosya girdisi satırı tam
tüketiyor; son satırda fazladan tur, boş satır ve boşluk kaybı denetleniyor.

S-183 INSTR: üç argümanlı kaynak sırası ile native runtime ABI sırası eşlendi.
S-184 STRING: MIR/native tekrar yolu ve AST'de metin değişkeni karakteri eklendi;
sayısal karakter, metin karakteri, sıfır tekrar ve hata sınırları ortaklaştırıldı.

S-190 HEX/OCT/BIN: AST ve legacy yolları bağlandı. S-178 &B literali lexer'a
bağlandı; &O zaten bulunan yolla birlikte tekrar ölçülüyor.

S-172/S-173 SELECT CASE: açık range AST düğümü ve bütün alt sınır/üst sınır
yolları bağlandı. AST değer karşılaştırması metin ve sayıyı koruyor. MIR ve
legacy selector bir kez yakalanıyor; karşılaştırma sırasında selector'ı
değiştiren çağrılar ilk değeri değiştirmiyor. Legacy karşılaştırmalarında
signed/unsigned, metin ve F32/F64 ayrı doğru yollar kullanıyor.

SET numeric iterator gerilemesi: VAL gerçekten F64 döndüğü halde iç lowering
geçicisi tamsayı gibi işaretleniyordu. VAL/CLNG metadata'sı gerçek türlerle
eşlendi. Yeni dış sembollerde önek eşleşmesi yüzünden kısa adın bildiriminin
kaybolması da merkezi tam-satır extern kaydıyla giderildi.

## Az token ile devam etme

Kök `AGENTS.md` kısa yön bulma kaydıdır. Belge araması:
`python tools/maintenance/uxb_context_index.py search "konu" --chars 4000`
(`uxb/` çalışma dizininde). Belge değişince `build` ile indeks yenilenir.
Bu araç Python standart kütüphanesi/SQLite FTS5 kullanır; ağ, API anahtarı ve
başka bir model gerektirmez. Aynı içerik SHA256 ile bir kez aranır.

Semboller mevcut `UxbRAG/.../ajan_paketi/rutinler.tsv` ve modül dizininden
bulunur; canlı dosyadaki konum doğrulandıktan sonra ilgili bölüm okunur.
Harita ve paket yenilendi. Model üretimi amaç metinleri taslaktır; bu çalışmada
başka bir AI ortamı ya da amaç doldurma modeli başlatılmadı. GitNexus bağlantısı
yalnız başka bir repoyu listeliyordu; uXBasic indeksi olduğu varsayılmadı.
Mevcut araçlar bu arama işine yettiği için ek bir servis kurulması gerekmiyor.

Kısa bağlam kullanımı için gerekçe:
[OpenAI'nin skill/bağlam rehberi](https://developers.openai.com/blog/rethinking-skills-and-prompts-for-gpt-6-astra).
Bu yerel sistemin token tasarruf yüzdesi ölçülmüş değildir.

## Taze test kayıtları

İlk tam koşu: `reports/consolidation_20261006_baseline.md` ve `.log`.
Koşu sürerken ana `bin/uxb.exe` ve runtime değiştirilmez. Aday derleyiciler ve
runtime ayrı isim/klasörlerde sınanır. Native derlemenin başarılı olması,
üretilen programın başarılı çalıştırılması yerine sayılmaz.

Dar kabul: `tests/compiler_consolidation/run_consolidation_tests.py`;
matris dosyaları: `run_matrix_export_tests.py`. Her sonuç çıkış kodu,
beklenen/gerçek metin ve build çıktısıyla JSON'a yazılır. Corpus hakeminde
aynı çıktıyı üretip başarısız çıkan süreç artık geçti sayılmaz.

Son genis kosu: **1171/1171**, 24/24 paket, 1942 sn
(`reports/consolidation_20261006_verified_regression.md`). Bu kosuda yanlis
`string_fields` adi nedeniyle secilmeyen `string_lifetime` ayrica **21/21**
calistirildi. Kosucu artik bilinmeyen paket adinda hata veriyor. Iki raporun
kapsami ayri; eski regresyon turlariyla sayilar ust uste eklenmez.

Yeni `compiler_consolidation` paketi **83/83**: buyuk yerel frame, Win64 foreign
callback register korumasi, SELECT snapshot/mixed/unsigned, DIM tekrar
yurutme, ileri bildirim ve imza retleri, DEFINT araligi, PRINT sutunlari,
float yuvarlama ve typed PROPERTY dahil. Legacy BYREF calisir ilan edilmedi.
Kitap **92/98** beklentili ornek uc motorda; 32 ornekte beklenti yok. Onceki
ayni corpus sonucu 86/98 idi. Kalan alti: CONTINUE, STATIC yerel, ENUM tipi,
dar literal, MID atamasi, IFF.

S-169: iki native emitter stack sayfalarini RSP azaltmadan once yokluyor;
2048 yerelli probe 2/2 ve tam native raymath `RAYMATH_PASS`/exit=0. S-191
performans sorunu acik. S-192: callee-saved GPR'lar saklanip geri yukleniyor;
native callback eski 2 -> 0, legacy numeric callback eski 4 -> 0. SDL core
normal kullanici ortaminda DLL'ler ile **4/4**; sandbox PrefPath yazmasi
ortam kisitiydi (`consolidation_20261006_sdl_core_host_with_dlls.log`).

S-175: eski MSVCRT'nin cift yuvarlama farki UCRT ile giderildi; 10/3, 1/7,
STR ve F32 probe'u dort motorda, eski float_text paketi 14/14. S-186 PROPERTY
typed alan cozumune baglandi, dort motorda 3/7; STATIC yerel kismi acik.

Compiler SHA256: `08212216723B1F18C3566F53E43878E69D69433DDCCED90B635C80B6AAC61B2B`.
Runtime SHA256: `4796B660A75A99E503DAD9E0342DD6309FE19A080172D0EA58FE6F49C7AA6D33`.
Standart dort compiler ve dort runtime kopyasi ayni hash'tedir. Onceki
ikililer `reports/consolidation_20261006_before_publish` altinda korunur.
Paket raylib DLL'i bin ile esitlendi; eski paket kopyasi ayrica yedeklendi.

Mete'nin son yonlendirmesi: yeni uygulama planindan once onerilen cozumler,
alternatifler ve onceki kararlarla uyum bir belgede sunulacak. Yeni ana belge
`UXB_INCELEME_KARAR_ONERILERI_20261006_TR.md`. Arastirmada yeni S-193 hata
merkezi/i18n eksikleri, S-194 kullanici bellek uyarisi ve S-195 AST 257 degisken
abort'u kaydedildi. 257 probe'u onceki yedek compiler'da da exit=6; henuz
duzeltilmedi. Tum compiler'in tamamlandigi iddia edilmiyor.

Stack/ABI dayanak: [Microsoft x64 prolog](https://learn.microsoft.com/en-us/cpp/build/prolog-and-epilog?view=msvc-170).
Yuvarlama dayanak: [Microsoft printf](https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/printf-printf-l-wprintf-wprintf-l?view=msvc-170).
