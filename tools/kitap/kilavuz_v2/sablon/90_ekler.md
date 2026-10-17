# Ekler

Bu bölüm başvuru içindir: dizinler, tablolar ve kaynaklar. Her tablo, mümkün olduğunca, **derleyicinin kendi kaynağından ya da raporundan** üretilir; elle yazılmış bir liste kaynağa göre eskiyebilir, üretilmiş liste eskimez.

## Ek A. Anahtar sözcük dizini

{{ANAHTAR_SOZCUKLER}}

## Ek B. Yerleşik işlev dizini

Aşağıdaki liste derleyicinin **tip kayıt defterinden** (`uxb sem … --type-infer-report-csv-out`) alınmıştır: derleyici bu işlevlerin dönüş tipini ve argüman biçimini bilir ve yanlış kullanımı derleme anında reddeder.
"Hedef" sütunu işlevin hangi motorlarda hazır olduğunu gösterir: `tüm hedefler` her motorda, `yerel` yalnız yerel (x64, AST, MIR) motorlarda, `konsol çalışma zamanı` konsol/dosya hizmeti olan motorlarda, `geniş sayı çalışma zamanı` yalnız geniş sayı kütüphanesiyle çalışır.
Argüman sütunundaki `(1)` tek argüman demektir, köşeli parantez isteğe bağlıdır.

{{YERLESIK_ISLEVLER}}

### Tip kaydında olmayan ama çalışan yerleşik yüzey

| Yazım | Bölüm | Ne yapar? |
|---|---|---|
| `HEX(n)`, `OCT(n)`, `BIN(n)` | 9 | Sayıyı 16'lık, 8'lik, 2'lik metne çevirir |
| `FIX(x)` | 4 | Sıfıra doğru keser |
| `SPACE(n)` | 9 | `n` boşluklu metin |
| `STRING(n, karakter)` | 9 | Karakteri `n` kez yineler (JS'te yürütme anında reddedilir, G-JS-7) |
| `IFF(koşul, a, b)` | 6 | Koşula göre `a` ya da `b`; yalnız seçilen dal hesaplanır (AST, MIR, x64 ve JS'te sınandı) |
| `a IFF b` | 6 | Aynı sözcüğün işleç biçimi: `XNOR` ile aynıdır (`5 IFF 3` = -7) |
| `RANDOMIZE [tohum]` | 9 | Rastgele sayı üretecini tohumlar (JS'te yürütme anında reddedilir, G-JS-7) |
| `INKEY`, `GETKEY` | 13 | Tuş okur (etkileşimli; otomatik sınamada çalıştırılmaz) |
| `PEEKS`, `POKES`, `POKE`, `POKEB/W/D/Q` | 14 | Belleğe metin/değer yazar, metin okur |
| `MEMCOPYB/W/D/Q`, `MEMFILLB/W/D/Q` | 14 | Bellek bloğu kopyalar/doldurur (adet = eleman sayısı) |
| `INC x`, `DEC x` | 5 | Değişkeni 1 artırır/azaltır (`INC x, 5` ayrıştırılamaz, G-ISLEC-2) |
| `I8(x)` … `U64(x)`, `F32(x)`, `F64(x)`, `BOOLEAN(x)` | 4 | Tip adıyla açık dönüşüm |
| `INSTANCEOF(nesne, Sinif)` | 11 | Yalnız AST'de |

## Ek C. Önişlemci yönerge dizini

{{ONISLEMCI_DIZINI}}

## Ek D. İşleç önceliği

Öncelik tablosu (yüksekten düşüğe) ve her satırın gerçek çalıştırmayla çıkarılmış kanıtı **Bölüm 6.7**'dedir. Kısaca (11 düzey): parantez/çağrı/indeks → tekli (`-x`, `+x`, `NOT`, `~`, `!`) → `**` → `* / \ MOD %` → `+ -` → `SHL SHR << >>` → karşılaştırma → `AND & && ANDALSO` → `XOR ^` → `OR | || ORELSE` → `? :`.
`NAND`, `NOR`, `XNOR`, `NXOR`, `EQV`, `EQA`, `IMP`, `CIMP`, `NIMP`, `NCIMP`, `IDA`, `IDB`, `NOTA`, `NOTB`, `ROL`, `ROR`, `|>` ve `IFF` işleçlerinin önceliği **sınanmamıştır**; bunlarla **parantez yazın**.

## Ek E. Komut satırı başvurusu

| Konu | Nerede? |
|---|---|
| Üç harfli fiiller (`lex`, `par`, `ast`, `sem`, `hir`, `mir`, `int`, `run`, `x64`, `bld`, `jsw`, `wat`, `chk`, `fmt`, `map`, `doc`, `rel`, `hlp`, `ver`) | Bölüm 2.7.1 |
| Sık kullanılan komut tarifleri | Bölüm 2.7.2 |
| Bütün seçenekler (kayıt defterinden, eksiksiz) | Bölüm 2.8 |
| Ortam değişkenleri | Bölüm 2.9 |
| Çıkış kodları | Bölüm 1.6 |
| Derleyiciyi FreeBASIC ile derleme | Bölüm 2.3 |
| Çalışma zamanı DLL'ini derleme | Bölüm 2.4 |
| Çıktı klasörü | Bölüm 1.5 |

## Ek F. Sık karşılaşılan tanı iletileri

Aşağıdaki iletilerin hepsi bu kılavuzun hazırlığında gerçek derleyicide görülmüştür. "Ne yapmalı?" sütunu ilgili bölüme gönderir.

| İleti (kısaltılmış) | Katman | Anlamı | Bölüm |
|---|---|---|---|
| `unknown symbol: x` | anlam çözümleme | Tanımsız ad | 12.4 |
| `assignment requires explicit cast TYPE_A to TYPE_B` | anlam çözümleme | Dönüşüm açık yazılmalı (koleksiyondan geri alırken yazımı yoktur, G-KOLEKSIYON-2) | 4.7, 10 |
| `variable K conflicts with CLASS K` | anlam çözümleme | Sınıf ve değişken aynı ad uzayında | 11.2 |
| `DELETE target must be DIM variable` | anlam çözümleme | `DELETE` yalnız `DIM` ile bildirilmiş değişken alır | 11.2 |
| `PRIVATE method … cannot be called from outside its class` | anlam çözümleme | Özel metoda dışarıdan çağrı | 11.3 |
| `META_UNKNOWN_DIRECTIVE: AD` | önişlemci | Bilinmeyen `%%` yönergesi (çıkış 2) | 17.11 |
| `META_NEEDS_PP_B` | önişlemci | Yönerge `%%PP B` ister | 17.3 |
| `henuz uygulanmadi: S-146 adim N` | anlam çözümleme | Model D'nin uygulanmamış adımı | 15.11 |
| `SELF_DEADLOCK`, `LOCK_DEADLOCK`, `TASK_WAIT_CYCLE` | çalışma anı | Kilit/görev bekleme tanıları | 15.7 |
| `readonly/immutable field assignment denied X` | çalışma anı (AST) / derleme (MIR, x64) | `READONLY`/`IMMUTABLE` alana yazma | 11 |
| `MIR x64 arrays: … array not declared: A` | x64 üretimi | `ASSERT`/`TRY` varken çağrıdan sonra `DIM dizi(n)` (G-DIL-10) | 5.7, 12.7 |
| `ADIM25 AST->MIR coverage failed: DELETE_STMT` | x64 üretimi | Hiç başvurulmayan rutinde `DELETE` (G-ARAC-4) | 16.9 |
| `CALL(DLL) library must not be absolute path (9208)` | çalışma anı (AST) | Mutlak DLL yolu (G-DIS-10) | 16.6 |
| `UXB host binding missing: X` | çalışma anı (JS) | Özelliğin JS karşılığı yok | 21.4 |
| `NATIVE_ONLY_UNSUPPORTED_ON_JS` | derleme (JS) | Yerel bellek yüzeyi JS'te yok | 14.7 |
| `UXB_RUNTIME_HOST_UNBOUND: MIR host call is not bound: X` | çalışma anı (x64) | Geniş sayı kurucusunun konak bağı yok (G-TIP-9) | 4.4 |
| `WAT string linear-memory lowering is not implemented` | derleme (WASM) | WASM'da metin yok (G-WASM-8) | 21.5 |
| `WASM backend does not support floating-point values` | derleme (WASM) | WASM'da ondalık yok (G-WASM-7) | 21.5 |
| `unknown type: X [canonical=X]` | ayrıştırma | Tasarımda olup kodda olmayan tip adı (G-TIP-8) | 4.10 |
| `invalid collection handle` | çalışma anı | Koleksiyon alanı/elemanı üretilmemiş (G-KOLEKSIYON-4) | 10.5 |
| `call stack limit exceeded` (AST); `Aborting : stack overflow` (MIR, `20261013_2333` ve öncesi; `20261014_0253`'te ileti yok, çökme: G-YORDAM-8) | çalışma anı | Özyineleme çok derin (G-YORDAM-5) | 8.4 |
| `step limit exceeded (--max-steps N)` | çalışma anı | Yorumlayıcı adım sınırı | 2.7.2 |
| `semantic-step3: type: numeric operands required` | anlam çözümleme | Karşılaştırma sonucu `-`, `*`, `/`, `**` işleneni yapılmış (G-ISLEC-4) | 6.9 |
| `ADIM25/26/27 close gate failed: … UNARY` | kapanış kapısı (çıkış 27) | Değişkenle tekli `+x` / `!x` x64, JS, WASM'da (G-ISLEC-3) | 6.9 |
| `MAIN is reserved for the MAIN … END MAIN program-entry block and cannot name a SUB` | anlam çözümleme | `SUB MAIN()` yazılmış | 3.2, 8 |
| `no matching overload for P with N argument(s)` | anlam çözümleme | Argüman sayısı yordam imzasına uymuyor | 8.2 |
| `EXIT: expected FOR, DO, WHILE, IF, or statement end` | ayrıştırma | `EXIT SUB` / `EXIT FUNCTION` yoktur | 7.4, 8.3 |
| `missing THEN` | ayrıştırma | `IF` satırında `THEN` unutulmuş | 7.2 |
| `CALL: missing (` | ayrıştırma | `CALL Selam` parantezsiz yazılmış | 8.1 |
| `integer literal out of range for TYPE_I8: 300` | anlam çözümleme | Sabit tipin aralığına sığmıyor | 4.2 |
| `TASK uzerinde bilinmeyen alan: join` | anlam çözümleme / çalışma anı | `t.JOIN` parantezsiz yazılmış (`t.JOIN()` olmalı) | 15.6 |
| `TRIGGER hedefi ad olmali` | anlam çözümleme | `TRIGGER`'dan sonra görev adı yerine ifade yazılmış | 15.5 |
| `mir: F80 arithmetic not supported` | MIR üretimi (çıkış 11) | `F80` aritmetiği AST dışında (G-TIP-12) | 4.3 |
| `WASM backend does not support BYREF parameter …` | web arka uç (çıkış 23) | Skaler `BYREF` WASM'da (G-WASM-12) | 8, 21.5 |
| `WASM CAST target type is not supported by the i32 model: PTR` | web arka uç (çıkış 23) | `PTR(…)`, `I64(…)`, `F64(…)` dönüşümü WASM'da (G-WASM-15) | 14.7 |
| `WASM VIRTUAL total size … exceeds the 1 MiB linear-memory sandbox` | web arka uç (çıkış 23) | WASM'da 1 MiB'tan büyük `VIRTUAL boyut` | 14.1, 14.7 |
| `Bilinmeyen CLI secenegi: --xyz` | komut satırı (çıkış 20) | Tanınmayan seçenek | 2.7 |
| `Desteklenmeyen kaynak dosya uzantisi: .txt` | komut satırı (çıkış 2) | Kaynak uzantısı `.uxb`/`.bas`/`.uxm` değil | 3.1 |

### Ortak tanı kodları (`20261014_0253` ile ölçüldü)

Aşağıdaki kodlar 2026-10-11 kararından (S-410) ve sonraki düzeltmelerden çıkmıştır; `20261007` kılavuz ikilisinde yoktu. İlk dördü **kütüphane tipi sağlayıcı hataları** içindir (Bölüm 12.4), sonuncusu **STRING ile sayının örtük karışımı** içindir (Bölüm 1.2 İlke 3 ve 12.5). Öteki hedef farkları bu tablodaki gibi ortak kodla bildirilmez.

| Kod | Ne zaman, hangi çıkışla? | `all_diagnostics.json` kaydı | Bölüm |
|---|---|---|---|
| `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` | Yaşam döngülü kütüphane tipi (`TEXT_REF`) ya da `RATIONAL` AST, AST-x64, MIR-x64, yerel x64, JS, WAT ve WASM'da kullanılınca, derleme zamanında (çıkış 1) | Var: `layer = library_type`, `phase = target_validation` | 12.4, 19.2 |
| `UXB_LIBTYPE_PROVIDER_MISSING` | MIR çalışırken manifestin `mir_provider` adı kayıtlı değilse (çıkış 13) | Var: `layer = library_type`, `phase = provider_call` | 12.4, 19.6 |
| `UXB_LIBTYPE_PROVIDER_TYPE_MISMATCH` | MIR çalışırken sağlayıcı kayıtlı ama bu tipi desteklemiyorsa (çıkış 13) | Var: `phase = provider_call` | 12.4, 19.6 |
| `UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE` | MIR çalışırken sağlayıcı tipi destekliyor ama bu işlemi desteklemiyorsa (örnek: `RATIONAL.CMP(a, b)`; çıkış 13) | Var: `phase = provider_call` | 12.4 |
| `UXB_MIXED_STRING_NUMERIC` | Bir ikili işlemde bir işlenen `STRING`, öbürü sayısalsa (`5 + "a"`, `n = "5"`, `"a" < 5`); derleme zamanında (çıkış 1), altı yolda aynı ileti: "string and numeric operands cannot be mixed; use STR or VAL". `STRING += sayı` bu kapıdan **geçer** (✖ G-DIL-16) | Var | 1.2, 12.5 |

`20261013_2224` ve öncesinde çalışma anı kayıtlarının iletisi ham kod metniydi, ipucu "compiler failure diagnostic" idi ve `OPERATION_UNAVAILABLE` yoktu; `UXB_MIXED_STRING_NUMERIC` ise `20261014_0253` derlemesinde geldi (S-459, S-460).

## Ek G. Bilinen sınırlar kataloğu

Bu katalog, kılavuzun hazırlığı sırasında gerçek derleyicide bulunan **bütün kusurları, eksikleri ve tasarım–kod farklarını** tek tek listeler. Her satırın `Sorun takip` sütunundaki numara, `ai_koordinasyon/SORUN_TAKIP.md` içindeki ayrı kayda gider;
kayıtlar önerilen düzeltme sırasıyla numaralanmıştır (`ai_koordinasyon/KILAVUZ_V2_SORUN_DIZINI.md`). **"Ne yapmalı?" sütunundaki geçici yollar sorunu çözmez**; yalnız çalışan bir yol gösterir. Testleri geçecek biçimde gevşetmek bir kusuru kapatmaz.
`HEDEF` alanı, tasarım belgelerinde olup kodda bulunmayan her şeyi toplar.
`Sorun takip` sütunundaki durum, kitabın **üretildiği andaki** `SORUN_TAKIP.md` durumudur: **✔ kapandı** = düzeltme kaynakta yapıldı ve doğrulandı (Codex'in kendi sınaması ya da bu kılavuzun bağımsız ölçümü; ikincisi Ek K.4'te yazılıdır); **◐ kısmen** = bir bölümü düzeldi; **açık** = düzeltme yok; **karar bekliyor** = dil anlamı değişeceği için Mete'nin kararı gerekir. Kitabın ölçtüğü derleyici (bu belgenin ilk sayfasındaki ikili) o düzeltmeyi içermiyorsa sorun orada hâlâ görünür; "Ne olur?" sütunu hangi derlemede ne gözlendiğini ayrıca yazar.

**Ölçüm kapsamı.** Kayıtların "Ne olur?" gözlemlerinin çoğu 2026-10-07/08'de `20261007` ile yapıldı. Referans ikili `20261014_0253` ile 1837 vakalık külliyat yeniden koşturuldu (her kaydın en küçük programı külliyattadır): vakaların %91,1'i hiçbir motorda değişmedi ve değişen 151 vakanın hepsi Ek K.5'te açıklanmıştır. Yani külliyatın kapsadığı kayıtlar referansta da aynen geçerlidir, kapananlar ve yeni bulunanlar ise "Kapandı …" ya da "Kısmen kapandı …" öneki ve Ek K ile işaretlidir. Külliyatın kapsamadığı kayıtlar için gözlem `20261007`'dir; sütun bunu yazar. Referans ikiliyle ayrıca şunlar ölçüldü ve sonuçları Ek K'dadır: depodaki **tam model paketleri** (46 paket, 1605/1610 kontrol), **eski AST-x64** yolu (282 örnek, 303 iddia vakası), **külliyatın tamamı WASM motorunda** (1863 vaka) ve CLI taraması (91 seçenek, 46 bayrak). Bu ölçümler S-524 … S-543 arası yirmi yeni kayıt ve birkaç eski kaydın durum değişikliğini getirdi; kitabın kendi düz metni de birkaç yerde bayatlamıştı ve düzeltildi (Bölüm 7.6 `GOTO`/`GOSUB`, 8.4 özyineleme sınırı, `-(karşılaştırma)`, `UNION`, yerel değişken sıfırlama, JS çıkış kodu).

{{SINIRLAR}}

## Ek H. Sözlük

| Terim | Anlamı |
|---|---|
| AST | Soyut sözdizimi ağacı: programın yapısını ağaç olarak tutan ara biçim |
| MIR | Orta düzey ara kod: bütün hedeflerin ortak girdisi |
| Motor | Programı çalıştıran yol: AST, MIR yorumlayıcısı, x64, JS, WASM |
| Eşlik | Aynı programın bütün motorlarda aynı sonucu vermesi |
| Kapalı başarısızlık | Emin olmadığı şeyi yapmayıp nedenini söyleyerek durma |
| Sessiz hata | Yanlış sonuç üretip hata vermeme (en kötü durum) |
| Açık ret | Derleyicinin "bunu yapamıyorum" deyip nedenini yazması |
| Tutamaç | Bir nesneyi/kaynağı gösteren opak sayı; üzerinde işlem yapılmaz |
| Kayıt (`TYPE`) | Farklı tipte alanları bir araya getiren değer tipi |
| Sınıf (`CLASS`) | Veri + davranış; atama aynı nesneye ikinci ad verir (referans) |
| Görev (`TASK`) | `SPAWN` ile başlatılan bir çalışmanın tutamacı |
| Model D | Ortak veriye otomatik güvenli erişim kararı (Bölüm 15.7) |
| Kütüphane tipi | Derleyiciyi değiştirmeden eklenen tip (`RATIONAL` gibi) |
| Önişlemci | Kaynağı ayrıştırmadan önce yazan `%%` komutları sistemi |
| Meta | Programın kendisini anlatan bilgi (`REM %%ATTR` hedefi) |
| FFI | Başka dilde yazılmış işlevi çağırma (`CALL(DLL)`) |
| Yapıt (artifact) | Derlemenin ürettiği dosya: `.asm`, `.obj`, `.exe`, `.js`, `.wasm` |
| Kapsam kapısı | Derleyicinin iç aşamalarını denetleyen kontrol (örn. ADIM25) |
| Kaynak üretici | Girdiden uXBasic kaynağı yazan araç (`UXClazz`) |
| Teslim sınıfı | Bir özelliğin hedefte nasıl gerçekleştiği (`DIRECT`, `HOST_PROVIDER` …) |

## Ek I. Kaynaklar, sürüm ve üretim

| Konu | Bilgi |
|---|---|
| Doğrulamada kullanılan derleyici | {{SURUM}} |
| Eşlik özeti | {{ESLIK_TOPLAM}} |
| Bu belgenin üretimi | `python tools/kitap/kilavuz_v2/uret.py` (bölümler `tools/kitap/kilavuz_v2/sablon`, veri `veri/`, örnekler `docs/kitaplar/_ortak/ornekler`) |
| Örnek doğrulama | `python tools/kitap/ornek_dogrula.py --uxb bin\uxb_kilavuz_20261014_0253.exe --web --is 4 --sonuc docs\kitaplar\_ortak\ornek_sonuclari_web_20261014_0253.json` (281 örnek, yaklaşık 30 dakika; zaman aşımına düşen hücreler `--ad <örnek>` ile boş makinede yeniden koşturulur) |
| Araç örnekleri doğrulama | `python tools/kitap/arac_dogrula.py --uxb bin\uxb_kilavuz_20261014_0253.exe` (11 araç örneği, yaklaşık 3,5 dakika) |
| CLI seçenek ölçümü | `python tools/kitap/kilavuz_v2/yoklama/cli_secenek_tarama.py --uxb bin\uxb_kilavuz_20261014_0253.exe --cikti %TEMP%\cli_tarama` (her seçeneği tek başına, her fiille ölçer; 2.8 ve Ek G'deki G-CLI kayıtlarının kaynağıdır, yeni ikilide tekrarlanır) |
| Vaka külliyatı ve sürüm farkı | `python tools/kitap/kilavuz_v2/yoklama/vaka_kos.py kos --uxb <ikili> --cikti <json>` anlatım iddialarının ve Ek G kayıtlarının küçük programlarını (1837 vaka) AST, MIR, x64 ve JS'te koşturup anlık görüntü yazar; `vaka_kos.py fark eski.json yeni.json` iki derleyici sürümünü karşılaştırır. Yardımcılar: `fark_sinifla.py` (BOZULDU / DUZELDI / CIKTI / ILETI sınıflaması), `goster.py` (görüntüyü motor sütunlarıyla yazar), `iddia_beklenen.py` (kılavuzun beklenen değerleriyle karşılaştırır). Ek K'nın kaynağıdır |
| Derleme betiği ve DLL denemesi | Gerçek ağaca dokunmadan: yalıtılmış kopya kökte `build_64.ps1`; `native\uxb_runtime\build_runtime_dll.ps1 -OutputDirectory <geçici> -SkipPublish` (2.3, 2.4) |
| Sorun takip dizini | `ai_koordinasyon/SORUN_TAKIP.md`, `ai_koordinasyon/KILAVUZ_V2_SORUN_DIZINI.md` |
| Kataloğu SORUN_TAKIP'a işleme | `python tools/kitap/kilavuz_v2/sorun_takibe_isle.py` |
| Belgelerin GitHub'daki yeri | `https://github.com/metedinler/uXBasic`, dal `yayin/20261015` (2026-10-15'ten beri): bu kılavuz `docs/tasarim/`, sorun kaydı ve karar defteri `ai_koordinasyon/`, belirtimler `spec/`, üretici araçlar `tools/kitap/`, konuşma ve hafıza kayıtları `konusma_arsivi/` altındadır. Hepsi yalnız okumak içindir, lisans vermez; konuşma kayıtlarında gizli anahtarlar silinmiştir (`konusma_arsivi/OKU_BENI.md`) |

### Tasarım belgeleri ve kılavuzdaki karşılıkları

Bu kılavuz, `docs/tasarim` altındaki belgelerin **hedef sözleşmesini** bugünkü derleyiciyle karşılaştırır. Her belgenin içeriği ilgili bölümde ya anlatılır ya da ◇ HEDEF olarak işaretlenir; kodda olmayan her şey Ek G'nin `HEDEF` alanında kayıtlıdır.

| Belge | Ana konusu | Kılavuzda |
|---|---|---|
| `uXBasic_Hedeflenen_Sistem_ve_Kullanma_Kilavuzu_TR_2026-09-24 (1).md` | Önceki hedef kılavuzu (V1) | Bütün kılavuz; farklar 22.6, 21.9, 11, 16.9 |
| `uxbasic bellek tasarimi  ve coklu is modeli yeni gelistirmeler 24.09.26.md` | Görev, SLOT, TASK, bellek, meta/web kararları (uzun konuşma kaydı) | 14, 15, 17, 18, 21 |
| `UXB_S146_GOREV_PAYLASIMLI_VERI_ONERISI_20260925_TR.md` | Görevler arası paylaşılan veri, Model D | 15.7, 15.11 |
| `UXB_20260923_SISTEM_TASARIM_KARARLARI_MEVCUT_DURUM_VE_IS_PLANI_TR.md` | Ana kimlik, kütüphane tipi, iterator, işaretçi | 7.5, 14, 19 |
| `UXB_KARAR_DENETIMI_VE_BIRLESIK_KALAN_ISLER_20260924_TR.md` | Karar denetimi, kalan işler | 15, 19, Ek G |
| `UXB_KOD_TASARIM_UZLASTIRMA_DENETIMI_20260924_TR.md` | Tasarım ile kod karşılaştırması | Ek G (`HEDEF` alanı) |
| `UXB_INCELEME_KARAR_ONERILERI_20261006_TR.md` | D01–D07 dil kararları, T01–T14 tamamlama halkaları | 4, 7, 9, 12, Ek G |
| `UXB_KALAN_ISLER_UYGULAMA_20261007_TR.md` | Uygulanan kararlar (CONTINUE, STATIC, ENUM, MID, tanı) | 4, 5, 7, 9, 12 |
| `UXB_MOTOR_SADELESTIRME_20261010_TR.md` | Motor sadeleştirme önerisi; **2026-10-11'de Mete tarafından reddedildi**, altı yol korunur | 1.3 (G-HEDEF-19) |
| `UXB_S404_MANIFEST_PAKET_STANDARDI_20261011_TR.md` | Kütüphane tipi manifest paket standardı: kısmen uygulandı | 19.6 (G-HEDEF-14) |
| `UXB_S410_LIBTYPE_TANI_DIKEY_HALKA_20261011_TR.md` | Kütüphane tipi sağlayıcı hatalarının ortak tanı kodu | 12.4, 19.6, Ek F (G-HEDEF-20) |
| `UXB_S440_ORtak_Cagri_Tanisi_20261013_TR.md` | Parantezsiz çağrının ortak tanı koduyla (`UXB_CALL_PAREN_REQUIRED`) reddi; Mete'nin 2026-10-12 kararının uygulaması | 8.1, Ek K (G-YORDAM-6) |
| `UXB_S441_CONST_YAZMA_TANI_DIKEYI_20261013_TR.md` | `CONST` yazma tanısı `UXB_CONST_ASSIGNMENT`: doğrudan / bileşik / `INCDEC` / `BYREF` yazma, kapsam duyarlı denetim (yerel `DIM` gölgeler) | 5.2, Ek K (G-DIL-12) |
| `UXB_S442_UNION_ORTAK_BELLEK_MIR_20261013_TR.md` | `UNION` ortak belleği: `MIR_UNION_FIELD_LOAD` / `MIR_UNION_FIELD_STORE`, MIR yorumlayıcı / x64 / JS / WAT karşılıkları; WASM'da yalnız ofset 0, 1/2/4 bayt | 10.3, Ek K (G-VERI-11) |
| `UXB_S443_MAGIC_BITWISE_OPERATOR_MIR_COVERAGE_20261013_TR.md` | Aşırı yüklenmiş `MAGIC AND` / `OR` / `XOR` için ADIM25 kapsam sözleşmesi | 11.7, Ek K (G-NESNE-21) |
| `UXB_S444_JS_UNCAUGHT_EXCEPTION_BOUNDARY_20261013_TR.md` | JS'te yakalanmayan `THROW` ve başarısız `ASSERT`: hata iletisi ve sıfırdan farklı çıkış | 12.1, Ek K (G-JS-14) |
| `UXB_S445_DLL_ARGUMENT_TYPE_LIST_TANI_20261013_TR.md` | `CALL(DLL)` bilinmeyen argüman tip simgesi: ortak `UXB_FFI_ARGUMENT_TYPE_LIST` tanısı | 16.6, Ek K (G-DIS-11) |
| `UXB_S446_F32_MOTOR_PARITY_20261013_TR.md` | `F32` tek duyarlık sözleşmesi: saklama sınırında yuvarlama, yedi anlamlı hane yazdırma; AST, MIR, MIR-x64 ve JS; WASM kapsam dışı. Fixture yalnız atama biçimini sınar (kalan farklar G-TIP-15, G-TIP-16) | 4.3, Ek K (G-TIP-13, G-TIP-15) |
| `UXB_S480_AST_GERILEME_GERI_BAGLAMA_20261013_TR.md` | AST gerilemesinin (çok boyutlu dizi, sınır dışı yazma, `I32(FLOAT)`, `CONTINUE`, 256+ değişken, DLL tutamacı) geri bağlanması | Ek K (S-480) |
| `UXB_S483_OOP_SEMANTIK_GUARD_20261013_TR.md` | OOP semantik kapıları: kalıtımda alan gizleme ve kurucu içinde `ME` ile sanal çağrı ortak tanıyla reddedilir; taban kurucusu (S-485) ve `SUPER(...)` (S-487) açık | 11.10, Ek G (G-NESNE-24) |
| `uXBasic_18_09_JS_WASM_Tam_Yuzey_Matrisi.md` | JS/WASM yüzey matrisi, teslim sınıfları | 21.9, Ek A, Ek B |
| `uXBasic WASM hedefi Metinler için doğrusal bellek mimarisi.md` | WASM'da metin: UTF-8, 16 baytlık tanımlayıcı, `UX_STR_*` çalışma zamanı, `LEN`/`BYTELEN` önerisi. Belge kendisini doğrulanmış uygulama değil **öneri** olarak niteler | 21.9 (G-HEDEF-23, G-HEDEF-24) |
| `UXB_META_PREPROCESSOR_MIR_YENIDEN_YAPILANDIRMA_20260924.md` | Birleşik önişlemci ve `REM %%` meta | 17, 18 |
| `docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md` | OOP hedef sözleşmesi (öneri v1): `THIS`/`ME`/`SUPER` ayrımı, kalıtım ve erişim, özellik/işleç, trait ve dekoratör, nesne ömrü, `UXClazz` profilleri, uygulama paketleri P0–P10 | 11.10 (G-HEDEF-4, G-HEDEF-25, G-NESNE-24 … G-NESNE-28) |
| `docs/FP_EXTENSION_ROADMAP_AFTER_STAGE4.md` | `F80` korunur ve harici kayan nokta çalışma zamanı, `F128`, `BIGF`/`BIGD` duyarlık söz dizimi, `{…}` ham sabit, terfi matrisi, `TO_BIGF()`, `BALL` | 4.4 (G-HEDEF-28) |
| `docs/UX*_ROADMAP.md`, `docs/UX*_MODULE.md`, `docs/UXAI_4_PROMPT_ROADMAP.md` | Kütüphane modül tanımları ve "sonraki paket" yol haritaları (`uxnn*`, `uxaimath`, `uxdataframe`, `uxonnx*`, `uxllamax`, `uxmatrix`, `uxtensor`, `uxgraph`, `uxcollections`) | 20.5, 20.8 (G-HEDEF-29) |
| `docs/UXB_FILE_TYPES_AND_INCLUDE_POLICY.md` | Kaynak türleri `.bas` / `.uxm` / `.uxmh`, başlık dosyasında yan etki yasağı (`UXMH_HEADER_SIDE_EFFECT_NOT_ALLOWED`), planlı CLI seçenekleri | 3, G-HEDEF-27 |
| `docs/KEYWORD_LAYER_MATRIX_POLICY.md` | Anahtar sözcük × katman matrisinin sekiz karar durumu; üretici ve kapı araçları | 21.9 (G-ARAC-5) |
| `docs/UXB_LIBRARY_IMPORT_POLICY.md`, `docs/LIBRARY_SYSTEM_STANDARD_TR.md` | Kütüphane zip'lerinin içe alınması, çakışma politikası, kanonik klasörler, tek komutla üretim, “hazır” sayılma kanıtları | 20.1 |
| `docs/LIBRARY_ABI10_TR.md` | `CALL(DLL)` kanonik biçimi (en çok 10 parametre), `uxffi.dll` yorumlayıcı köprüsü, `PTR` tutamacı, x64 çağrı kuralı | 16.6 (G-DIS-12) |
| `docs/hata_merkezi_ve_raporlama_politikasi_20260606.md` | Çıktı kökü `build/<çalıştırma>/<dosya_tipi>/`, merkezi hata günlüğü, dosya silmeme kuralı | 1.5 |
| `docs/MOTOR_SORUMLULUK_VE_PARITE_SOZLESMESI_20260916_CODEX1.md` | Altı motorun rolü, tekil otorite (ayrıştırıcı, anlam çözümleme, kanonik MIR, ortak çalışma zamanı sözleşmesi, yetenek kapısı), her yeni komut için zorunlu kayıt | 1.3 |
| `UXB_TASARIM_UBASIC_UXBASIC_TIP_SISTEMI_KARSILASTIRMA_20260920_TR.md` | UBASIC ile tip sistemi karşılaştırması | 4.4, 19.6 (G-HEDEF-13) |
| `docs/UXCLAZZ_UXBDLL_MIMARI_VE_KULLANIM_KILAVUZU_TR.md` | `UXClazz`, `uxbdll`, `uxclz` | 16.9, 20 |
| `UXB_BIRINCI_SINIF_KUTUPHANE_TIPI_TASARIM_PAKETI_20260920_TR.md` | Birinci sınıf kütüphane tipi: asgari sözleşme, kanonik MIR ilkesi, ilk aday paketler, `PTR`/typed pointer özeti | 19.1, 19.3, 19.6 |
| `UXB_TASARIM_KUTUPHANE_TIPI_CEKIRDEK_TIPI_AYRIMI_20260920_TR.md` | Çekirdek tip ile kütüphane tipi ayrımı, üç katmanlı mimari, `INLINE` son çare | 19.1, 19.6 (G-DIS-6) |
| `UXB_TASARIM_JS_WASM_KUTUPHANE_TIPI_BACKENDLER_20260920_TR.md` | JS ve WAT/WASM'ın kütüphane tipi hedefi olması; modül sağlayıcıları; WASM bellek kuralı | 14.7, 19.6, 20.3 (G-HEDEF-21), 21.5, 21.9 |
| `UXB_S134_LIBRARY_TYPE_LIFECYCLE_20260923_TR.md` | Yaşam döngüsü modelleri, sağlayıcı tip bağı, B1–B6 kanıtları | 19.3, 19.4 |
| `UXB_TASARIM_F80_MEMORYREF_AUTO_KARARLARI_20260920_TR.md` | F80 boyutu, skaler `VARPTR`, `AUTO`, `MemoryRef`, `VARPTR(dizi(i))`, `SIZEOF(dizi)`, dizi parametresi, `MEMFILL*`, WASM sanal bellek sınırı, yineleyici, `PRINT` boşaltma | 4.3, 7.5, 8, 14.1–14.7 |
| `UXB_TASARIM_PTR_BYTE_ARITMETIGI_VE_ARRAY_STRIDE_20260920_TR.md` | Bayt tabanlı `PTR` aritmetiği, `elementStride` | 14.4 |
| `UXB_TASARIM_TYPED_POINTER_VE_RAW_PTR_20260920_TR.md` | Tipli işaretçi `PTR TO T` ve ham `PTR` birlikteliği | 14.4 (S-113, G-TIP-7) |
| `UXB_TASARIM_6502_ADRESLEME_VE_PTR_ARITMETIGI_20260920_TR.md` | 6502 adresleme düşünce deneyi, dolaylı adresleme, `ADDR` | 14.4, 14.5 (G-HEDEF-1) |
| `spec/NESTED_MEMORY_LAYOUT_SPEC.md` | Yuvalanmış `TYPE`/dizi bellek yerleşimi, `SIZEOF`, `OFFSETOF(yol)`, hizalama ve dolgu, etkin adres formülü (10 Nisan, "Proposed") | 14.5 (G-VERI-17) |
| `UXB_S030_FAZ2A_NATIVE_ASYNC_PLANI_20260925_TR.md` | Yerel eşzamanlı çalışma planı | 15.8 |
| `UXB_TEK_SORUMLU_KONSOLIDASYON_20261006_TR.md`, `UXB_ONERILER_UYGULAMA_20261007_TR.md`, `UXB_YEREL_UZMAN_PLANI_20260928_TR.md` | Çalışma düzeni, öneri uygulamaları, yerel uzman | Ek G (ilgili kayıtlar) |
| `UXB_GENEL_VERI_TIPI_VERI_YAPISI_VE_BIRINCI_SINIF_KUTUPHANE_TIPI_SISTEMI_20261014_TR.md` | Birleşik tip sözleşmesi (`TypeDescriptor v2`, `StorageDescriptor`, `MemoryRef`, kanonik UTF-8, `TASK OF T`); "uygulanmış / kısmen uygulanmış / kapanmamış" ayrımı ve uygulama sırası | 19.6 (G-HEDEF-30), 4.3, 14.4 |
| `UXB_S134_B3_LIFECYCLE_LOWERING_20261014_TR.md`, `UXB_S134_B4_1_PROVIDER_OPERATION_ABI_20261014_TR.md`, `UXB_S134_B4_2_PROVIDER_CAPABILITY_METADATA_20261014_TR.md` | Yaşam döngüsü indirgemesi; işlem sağlayıcı kapısı (`UXB_LIBTYPE_PROVIDER_OPERATION_UNAVAILABLE`); yetenek üstverisi kapısı | 12.4, 19.4, 19.6, Ek F |
| `UXB_S500_LIBTYPE_TANI_SOZLESMESI_20261014_TR.md` | Kütüphane tipi tanı sözleşmesi (`layer`, `phase`, ipucu, `related_surface`) | 12.4, Ek F (G-HATA-13) |
| `UXB_S459_S460_KARISIK_STRING_SAYI_TIP_KAPISI_20261014_TR.md` | Sayı ile `STRING` karışımı kapısı (`UXB_MIXED_STRING_NUMERIC`) | 1.2, 12.5, Ek F (G-DIL-16) |
| `UXB_S219_ROTATE_WIDTH_20261014_TR.md` | `ROL`/`ROR` genişlik sözleşmesi | 6.4 (G-ISLEC-1, G-ISLEC-10, G-WASM-22) |
| `UXB_S502_F32_ARRAY_DIRECT_20261014_TR.md`, `UXB_S503_F32_STORAGE_20261014_TR.md`, `UXB_S510_S511_S512_F32_DEGER_PARITESI_20261014_TR.md` | `F32` dizi okuma, saklama yuvarlaması ve değer paritesi sözleşmesi | 4.3 (G-TIP-13 … G-TIP-27) |
| `UXB_S508_FIX_TYPE_20261014_TR.md` | `FIX(x)` statik tür kuralı | 4.7 (G-TIP-18) |
| `UXB_S464_BOTH_KARSILASTIRMA_KAPISI_20261014_TR.md` | `--interpreter-backend BOTH` karşılaştırma kapısı (`UXB_INTERPRETER_COMPARE_MISMATCH`, çıkış 25) | 2 (CLI), 1.6 |
| `UXB_S550_S551_DATA_READ_RESTORE_VE_VERI_SABITLERI_20261015_TR.md` | Etiketli `DATA` / `READ` / `RESTORE` (BASIC tarzı) ve Python tarzı veri sabitleri (dizi, `LIST`, `DICT`, `SET`); Mete'nin 2026-10-15 kararı, tasarım onaylı, uygulanmadı | 10.5 (G-VERI-14, G-VERI-15) |
| `UXB_S544_S549_S564_DECLARE_DOSYA_TUTAMACI_NULL_20261015_TR.md` | Sıkı `DECLARE` kuralı, `FILE_HANDLE` ve `FREEFILE`, `NULL` / `NOTHING`; `NONE` / `NODE` eklenmez; çoklu kalıtım son onay bekliyor | 8.5, 13.2, 4.4, 11.12 (G-YORDAM-9, G-DOSYA-9, G-DOSYA-10, G-TIP-30, G-TIP-31) |
| `UXB OPP SISTEMI TASARIM VE TARTISMALARI.md` | Mete'nin OOP tasarım konuşması: çoklu kalıtım, `THIS` / `ME` / `SUPER[Taban]`, karışımlar, motorlara indirgeme, eksik ve deneysel özellikler | 11.13 (G-HEDEF-31 … G-HEDEF-40) |
| `uXBasic_OOP_Tam_Sistem_Denetimi_2026-10-16.md` | OOP kaynak denetimi (K-01 … K-12, P0 … P3); her bulgu altı yolda denendi, sonuç 11.13.1'de | 11.13 (G-NESNE-37, G-JS-15, G-JS-16, G-WASM-26, G-TIP-32, G-HIZ-4) |
| `UXB_S555_COKLU_KALITIM_B_VE_CAKISMA_DENETIMI_20261016_TR.md` | Çoklu kalıtım (B), çakışma çözüm cümleleri, tanı kodları, aşamalar M0 … M3, kabul testleri T1 … T20 | 11.12, 11.13 (G-NESNE-30, G-HEDEF-40) |
| `ai_koordinasyon/OOP_DUZELTME_PLANI_20261016.md` | OOP düzeltme planı: bulguların doğrulanması, iş paketleri F1 … P4, bu turda yapılan düzeltmeler | 11.13 |

## Ek J. Sorunların düzeltme sırası

Bu kılavuzda anılan her kusur, `ai_koordinasyon/SORUN_TAKIP.md` içinde **ayrı bir S-numarasıyla** kayıtlıdır ve numara sırası önerilen düzeltme sırasıdır: önce yanlış sonuç veren (SESSİZ), sonra çökme (ÇÖKME), sonra motorlar arası fark (FARK), açık ret (AÇIK), eksik özellik (EKSİK) ve yavaşlık (YAVAŞ).
Düzeltme kuralı: kayıttaki program yeni bir model testi olarak eklenir ve dört motorda hedef davranışı vermelidir; **testi geçecek biçimde gevşetmek ya da beklentiyi değiştirmek düzeltme sayılmaz**. Bir kusur düzeltilince Ek G'deki satır, ilgili bölümdeki ✖ işareti ve karar maddeleri güncellenir.

## Ek K. Derleyici sürümleri arası farklar: 20261007'den 20261014_0253'e

Bu kılavuzun örnekleri ve bütün Ek G kayıtları `bin\uxb_kilavuz_20261014_0253.exe` ile (**referans ikili**) ölçüldü. Kılavuzun ilk sürümü `bin\uxb_kilavuz_20261007.exe` ile yazılmıştı; Codex 2026-10-13 ve 2026-10-14'te kaynakta S-440 … S-446, S-479, S-480, S-498 … S-512 ve S-219, S-459, S-460, S-500 değişikliklerini yaptı ve 14 kez yeni ikili derledi. Bu ek, o derlemelerin `20261007`'ye göre **ölçülmüş farkını** verir. Bir **anlık görüntüdür**: yeni bir derleme çıktığında K.6'daki komutlarla yeniden ölçülmelidir.

**Referans ikili nasıl seçildi?** Kural: referans, açık bir **gerileme** (daha önce doğru olan bir şeyin bozulması) taşıyan derlemeye geçirilmez; böylece "tüm örnekler geçti" cümlesi gerilemeli bir derlemeyle yazılmaz. Gün içinde iki derleme bu yüzden elendi: `20261013_1704` (MIR-x64'te ondalık karşılaştırmanın değeri bozuktu, S-504; AST'de `I32` dışındaki tamsayı dönüşümleri yuvarlıyordu, S-506) ve `20261013_2333` (MIR-x64'te `F32` dizi elemanının okunması bozulmuştu, S-509). İlk aday `20261013_2224` oldu (iki gerileme de kapanmıştı): 281 örnek, 1837 vakalık külliyat ve altı yolda `RATIONAL` matrisi onunla ölçüldü. 2026-10-14 02:53'te çıkan `20261014_0253` ise S-219, S-508, S-509 … S-512, S-459, S-460 ve S-500'ü de kapattığı için ölçüm onunla yenilendi; `2224` ölçümleri ara kayıt olarak K.1'de durur.

**Bilinçli istisna.** `20261014_0253` beş açık gerileme taşır. Dördü AST'dedir, `20261013` 12:37'den beri vardır ve `20261007`'de doğruydu; beşincisi yalnız `0253`'te görünür: MIR yorumlayıcıda derinliği 50'yi aşan özyineleme artık `Aborting : stack overflow` (çıkış 4) yerine iletisiz çöker (S-543, G-YORDAM-8; külliyatta 6 vaka, `vaka_derin`). AST gerilemeleri: `MAGIC TOSTRING` tanımlı bir sınıfın metot sonucunu değişkene yazmak `0` verir (S-523, G-NESNE-29); `NAMESPACE`/`MODULE` içindeki diziye nitelikli erişim hata verir (S-539, G-MODUL-6); 1024'ten fazla değişkenli program reddedilir (S-540, G-DIL-17); FFI'ye boş metin geçirmek AST'yi `segmentation violation` ile durdurur (S-535, G-DIS-13). S-523 ölçümün sonunda bir araç örneği (`uxclazz_uretici.py`) düşünce, öteki üçü tam model paketi koşusunda (`tests\run_all_model_tests.ps1`: 46 paketin 4'ü, 5 kontrol) bulundu. Kitabın 197 örneğinin hiçbirini düşürmezler, çünkü hiçbiri bu birleşimleri kullanmaz. Referans bu yüzden değiştirilmedi: kural "gerilemeyi **gizleyen** derlemeye geçmemektir", ve bu gerilemeler Bölüm 11'de, Ek G'de, K.3'te ve K.4'te açıkça yazılıdır. Codex düzeltince `gerileme_sondalari.py` (sondalar S-523, S-535, S-539, S-540, S-543) ilk bakışta yakalar.

### K.1 Ölçülen derlemeler

| Derleme | Saat | SHA256 (ilk 8) | Ölçülen |
|---|---|---|---|
| `uxb_kilavuz_20261013.exe` | 12:37 | `4D373871` | 1688 vakalık külliyat × 4 motor (tam); iddia beklenenleri; S-480 belirtileri |
| `uxb_kilavuz_20261013_1341.exe` | 13:41 | `87067822` | S-480 belirtileri; `RATIONAL` programının AST-x64 ve WASM'da ilk kez reddedilmeyip yanlış sonuç vermesi (G-KTIP-7) |
| `uxb_kilavuz_20261013_1514.exe` | 15:14 | `3BDB6D75` | 281 örnek (AST, MIR, x64, JS, WASM); S-443 / S-444 / S-445 düzeltmeleri; S-480 belirtileri |
| `uxb_kilavuz_20261013_1614.exe` | 16:14 | `4CBFFA9B` | S-410 (yedi hedef); S-480 belirtileri; model testlerinin ilk on paketi |
| `uxb_kilavuz_20261013_1704.exe` | 17:04 | `20BF7CFA` | 1837 vakalık külliyat × 4 motor (tam); iddia beklenenleri; 281 örnek (AST, MIR, x64, JS, WASM); altı yolda `RATIONAL` matrisi; `F32`, `UNION`, `ALIGN`, tamsayı dönüşümü ve `FIX` probları; S-480 belirtileri A–F |
| `uxb_kilavuz_20261013_1808.exe` | 18:08 | `C8AE5E3B` | yalnız S-504 programı (hâlâ bozuk) |
| `uxb_kilavuz_20261013_2052.exe` | 20:52 | `737CFBB6` | `gerileme_sondalari.py`; `RATIONAL` altı yol matrisi (14 vaka) |
| `uxb_kilavuz_20261013_2107.exe` | 21:07 | `01E741A2` | sondalar; 281 örnek (AST, MIR, x64, JS, WASM) |
| `uxb_kilavuz_20261013_2144.exe` | 21:44 | `609CF0EB` | sondalar (bileşik karşılaştırma dahil); S-500 / S-505 durumu |
| `uxb_kilavuz_20261013_2209.exe` | 22:09 | `B7BD3E3A` | sondalar; S-505 (MIR-x64) durumu |
| `uxb_kilavuz_20261013_2224.exe` | 22:24 | `864E7CF3` | 281 örnek (AST, MIR, x64, JS, WASM; boş makinede beş hücre yeniden); 1837 vakalık külliyat × 4 motor (tam; 10-07 ile fark K.5'te); altı yolda `RATIONAL` matrisi; sondalar (S-506 kapandı) |
| `uxb_kilavuz_20261013_2306.exe` | 23:06 | `A5309952` | sondalar (S-502 kapandı, S-503 kısmen) |
| `uxb_kilavuz_20261013_2333.exe` | 23:33 | `65DA235C` | sondalar; yeni gerileme S-509 (MIR-x64 `F32` dizi okuması) ve yazdırma düzeyinde gizlenen üç `F32` kusuru (S-510 … S-512) bu derlemede bulundu |
| `uxb_kilavuz_20261014_0253.exe` | 02:53 | `696A4FD2` | **referans:** 281 örnek + 1 yeni (`bit_dondurme`; AST, MIR, x64, JS, WASM; boş makinede dört hücre yeniden); 1837 vakalık külliyat × 4 motor (tam; 10-07 ile fark K.5'te) ve külliyatın tamamı WASM motorunda (K.5); iddia beklenenleri (1024/1039) ile yeni `iddia_akis` (GOSUB/GOTO/RETURN, 12 vaka) ve `iddia_eski_astx64` (15 vaka); altı yolda `RATIONAL` matrisi (17 program); 35 değer düzeyinde sonda (`gerileme_sondalari.py`); CLI tarifleri (31 komut, `20261007` ile aynı çıkış kodu ve iletiler) ve CLI taraması (91 dosya çıktılı seçenek, 46 bayrak, altı fiil: `20261007` ile 0 değişiklik); eski AST-x64 (282 örnek, 303 iddia vakası, GEÇTİ olmayan 107 örnek `20261007` ile); **tam model paketleri** (46 paket, 1605/1610 kontrol, 108 dakika); 11 araç örneği (10'u geçer, biri S-523 nedeniyle düşer); `mutex`, `paralel_asal_sayim` ve `taskgroup` kararlılığı (10/10, MIR); `F32` bağlam matrisi, WASM bit işleçleri, `ROL=`, karışık `STRING`, `FIX`, provider tanı kodları için hedefli değer düzeyi ölçümleri |

### K.2 Düzelenler

| Kayıt | G-kaydı | Ne değişti? | Ölçüm |
|---|---|---|---|
| S-440 | G-YORDAM-6 | Parantezsiz çağrı (yordam, işlev, metot) `UXB_CALL_PAREN_REQUIRED` ile ayrıştırmada reddedilir; önişlemci çıktısını ayrıştıran `lex` aşamasında da. Mete'nin 2026-10-12 kararının uygulaması | 46 vaka; 4 motorda reddedilir |
| S-441 | G-DIL-12 | `CONST`'a doğrudan, bileşik ya da `BYREF` ile yazmak `UXB_CONST_ASSIGNMENT` ile reddedilir; yerel `DIM` gölgelemesi serbest | 6 vaka × 4 motor; gölgeleme vakası dört motorda `5 / 3` |
| S-442 | G-VERI-11 | `UNION` alanları MIR, MIR-x64 ve JS'te de ortak bellek (`MIR_UNION_FIELD_LOAD/STORE`); WAT/WASM'da 1, 2 ve 4 baytlık tamsayı alanlar | 5 vaka; 4 alan çifti × 3 motor AST ile aynı; WASM'da `u.tam = 258` sonra `u.bay` → `2`, `I64` alanı `UNION_FIELD_STORE` iletisiyle reddedilir |
| S-443 | G-NESNE-21 | Aşırı yüklenmiş `MAGIC AND/OR/XOR` x64 ve JS'te derlenir ve dört motorda `4` verir (`12 AND 4`) | 2 fixture × 4 motor; 4 külliyat vakası. **Aynı kapının gevşemesi K.4'teki yan etkileri doğurdu** (G-KTIP-7, G-KTIP-8, G-ISLEC-1) |
| S-444 | G-JS-14 | JS'te yakalanmayan `THROW` / `ASSERT` ileti yazar ve çıkış kodu `1` olur | 9 vaka (JS) |
| S-445 | G-DIS-11 | `CALL(DLL)` bilinmeyen tip simgesi ayrıştırmada `UXB_FFI_ARGUMENT_TYPE_LIST` ile reddedilir; x64 artık çöp değer döndürmez | 2 vaka |
| S-123 (kısmen) | G-JS-9 ve G-JS-7'nin `GOSUB` kısmı | `GOSUB`, `RETURN` ve etiketli `GOTO` (ileri ve geri) JS'te ve WASM'da (metinsiz programlarda) çalışır; `20261007`'de JS `host binding missing: GOSUB`/`LABEL` ile düşer, ileri `GOTO` zaman aşımına uğrar, WASM "does not support GOSUB/RETURN" ile reddeder ya da geçersiz WAT üretirdi | `gosub_return`, `goto_etiket` kitap örnekleri JS'te geçti (2 vaka); `iddia_akis` 12 vaka: 20261007 35/71 → 0253 56/71; Bölüm 7.6. **Kalan:** `tests\wasm_model\neg_gosub_refused` bayat (ret bekliyor) |
| S-410 | G-HEDEF-20 | Kütüphane tipi sağlayıcı hataları ortak kodla bildirilir: `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` yedi hedefte çıkış 1 ve yapılandırılmış kayıtla; çalışma anı üç kod (`MISSING`, `TYPE_MISMATCH` ve `0253`'te gelen `OPERATION_UNAVAILABLE`) MIR'de çıkış 13 | Bölüm 12.4, Ek F; `tests\library_type_contract` 38/38 (20261007: 30/38) |
| S-498 | G-HATA-11 | AST ve MIR çalışma anı hataları `all_diagnostics.json` ve `vscode_diagnostics.json` dosyalarına yazılır (yerel x64, JS ve WASM çalışma anı hataları ayrı süreçte oluştuğundan yazılmaz) | `THROW 5` için `diagnostics` kaydı 1 (AST ve MIR) |
| S-499, S-507 | G-KTIP-2, -6, -7, -8 | `RATIONAL` programı MIR dışındaki beş yolda `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile derleme aşamasında reddedilir: AST artık ondalık hesaplamaz, AST-x64 ve WASM yanlış sonuç vermez, AST-x64'te sıfıra bölme EXE'yi çökertmez | altı yol × 17 program (Bölüm 19.2) |
| S-504, S-505 | G-ISLEC-8, -9 | Ondalık karşılaştırmanın değeri (`PRINT x >= 0`, `AND`/`OR` ile bileşik) ve `-(karşılaştırma)` MIR-x64 dahil beş yolda doğru | sondalar; `rnd_randomize`, `ondalik_hassasiyet` örnekleri |
| S-506 | G-TIP-17 | `I8`, `I16`, `I64`, `U8`, `U16`, `U32`, `U64` dönüşümü AST'de ondalığı keser (`I64(3.9)` → `3`) | `bilesik_faiz` örneği; sonda |
| S-446, S-502, S-503, S-509 … S-512 | G-TIP-13, -15, -16, -19 … -22 | `F32` değer paritesi: bildirim başlangıcı, atama, `F64`→`F32`, `F32(x)` sonucu aritmetikte, dizi elemanı yazma ve okuma, `DIM t AS F32 = d` — beş yolda tek duyarlığa yuvarlanır (WASM `F32`'yi hiç taşımaz) | Bölüm 4.3 tablosu; değer düzeyinde (çıkarma ile) ölçüldü |
| S-219 | G-ISLEC-1 | `ROL`/`ROR` tipin genişliğinde döndürür (`U8 129 ROL 1` → `3`); AST, MIR, x64 ve JS aynı sonucu verir | Bölüm 6.4 örneği `bit_dondurme`; `U8`, `U16`, `U32`, `I32` |
| S-508 | G-TIP-18 | `FIX(x)` sonucu değişkene atanır, aritmetiğe ve `I32(...)` içine girer | 11 kullanım biçimi × altı yol |
| S-459, S-460 (kısmen) | G-DIL-8, -13, -14 | Sayı ile `STRING` karışımı altı yolda `UXB_MIXED_STRING_NUMERIC` ile reddedilir (14 biçim); **bileşik atama `s += 7` hariç** (G-DIL-16) | 14 negatif + 6 pozitif biçim × altı yol |
| S-500 (kısmen) | G-HATA-13 | Çalışma anı kodlarının JSON kaydı yapılandırılmıştır: iki dilli ileti, ipucu, `related_surface`; `phase = provider_call` | Bölüm 12.4 |
| S-480 | — | AST gerilemesinin A, B, C, D, E ve F belirtileri kapandı; **G belirtisi (`MAGIC TOSTRING` tanımlı sınıfta metot sonucu, S-523) ve model paketlerinin bulduğu H, I, J belirtileri (S-539 NAMESPACE dizisi, S-540 1024 değişken, S-535 FFI boş metin) açık**; kayıt bu yüzden `KISMEN-YAPILDI-DOGRULANDI`'ya çekildi | K.3 |
| S-479 | — | Ana derleme (`build_64.ps1 -Force`) yeniden hatasız biter | on dört ikili üretildi |

### K.3 S-480 gerilemesi: A–F kapandı, G–J açık

12:37 ile 16:14 arasındaki dört derlemede **yalnız AST yorumlayıcıda** altı belirti vardı (MIR ve x64 etkilenmemişti). Kök neden SORUN_TAKIP S-480'de: çalışma ağacındaki üç AST çalışma zamanı dosyası HEAD'in gerisindeydi. `17:04`'ten itibaren durum (G belirtisi ölçümün sonunda, H, I ve J tam model paketi koşusunda bulundu):

| # | Belirti | Küçük program | 20261007 | 12:37 … 16:14 (AST) | 20261014_0253 (AST) |
|---|---|---|---|---|---|
| A | Çok boyutlu dizi | `DIM m(2, 3) AS I32 : m(1, 2) = 42 : PRINT m(1, 2)` | `42` | `exec: assign lhs must be ident, indexed array, or field` | `42` ✔ |
| B | Sınır dışı dizi erişimi | `DIM a(3) AS I32 : a(0) = 5 : a(9) = 7 : PRINT a(0)` | `array index out of bounds A` | `7` (hata yok, çıkış 0; başka hücre ezilir) | `array index out of bounds A` (çıkış 5) ✔ |
| C | Ondalık → tamsayı dönüşümü sıfıra doğru keser | `PRINT I32(-3.9)` ve `I64(3.9)` | `-3` / `3` | `-4` / `4` | `-3` / `3` ✔ (`I8` … `U64` dönüşümleri `20261013_2224`'ten beri; S-506) |
| D | `CONTINUE` | `FOR` içinde `IF i = 2 THEN CONTINUE` | toplam `13` | `exec: EXIT used outside matching loop` | toplam `13` ✔ |
| E | 256'dan fazla değişken | 257 `DIM` satırı | `257` | ham FreeBASIC hatası (`Aborting due to runtime error 6 …`) | `257` (dört motorda) ✔ |
| F | DLL'den dönen tutamacı DLL'e geri vermek | `l = uxcollections.ListNew()` sonra `uxcollections.ListPushI64(l, 5)` | çalışır | `CALL(DLL) PTR requires pointer/integer argument` | çalışır ✔ |
| G | `MAGIC TOSTRING` tanımlı sınıfta `F64` dönüşlü metodun sonucunu değişkene yazmak | `b = f.GetB()` sonra `PRINT b` (`GetB` `2.5` döndürür) | `2.5` | `0` | **`0` ✖** (S-523, G-NESNE-29; `20261013` 12:37'den beri) |
| H | `NAMESPACE`/`MODULE` içindeki **diziye** nitelikli erişim | `NAMESPACE sayac : DIM kutu(3) AS I32 : END NAMESPACE`, `sayac.kutu(2) = 7`, `PRINT sayac.kutu(2)` | `7` | `exec: assign lhs must be ident, indexed array, or field` | **aynı hata ✖** (S-539, G-MODUL-6; model testi `task_sync/namespace_shared_vars`) |
| I | 1024'ten fazla değişken | 1025 `DIM` satırı ve `PRINT v1024` | `1024` (2000 değişkende de çalışır) | ham `runtime error 6` | **`exec: variable storage capacity exceeded (max 1024)` ✖** (S-540, G-DIL-17; model testi `compiler_consolidation/stable_cells_byref_pointer`) |
| J | FFI'ye boş metin (`""`) geçirmek | `CALL(DLL, "kernel32.dll", "IsBadStringPtrA", I32, STDCALL, "STRPTR,U64", e, 16)` | `0` (S-145 düzeltmesi) | `1`, sonra `segmentation violation` | **aynı ✖** (S-535, G-DIS-13; model testi `language_guards/ffi_empty_string_is_real`) |

**Kitap örneklerine etkisi:** 16:14 ve öncesinde AST'de 28 örnek düşerdi (23 kütüphane, 2 çok boyutlu dizi, 1 `CONTINUE`, 2 `I32` yuvarlama). `20261014_0253`'te bu nedenle AST'de düşen kitap örneği yoktur; ama G belirtisi araç örneklerinden birini düşürür (`uxclazz_uretici.py`: AST `boy = 0`, `metin = 0`, `esit = 0`; MIR ve x64 doğru). H, I ve J'yi kitap örnekleri sınamaz (hiçbiri ad alanı dizisi, 1024'ten fazla değişken ya da FFI'ye boş metin kullanmaz); onları depodaki **model paketleri** yakaladı: `tests\run_all_model_tests.ps1` ile 46 paketin 4'ünde 5 kontrol düşer (1605/1610): üçü H, I ve J, ikisi `neg_gosub_refused` (WASM ve JS; test bayat, S-123). `20261007`'de üç AST testi de geçiyordu.

### K.4 Yeni derlemelerde bulunan kusurlar ve son durumları

Aşağıdakilerin hepsi SORUN_TAKIP'ta ayrı kayıttır. **Gerileme** = `20261007`'de doğruydu, yeni derlemede bozulmuş; **açık ret → sessiz** = `20261007`'de derleyici açıkça reddederdi, kapı gevşeyince artık reddetmeyip yanlış sonuç veriyor; **gizli** = yazdırma düzeyindeki ilk kapanış sınaması kusuru yakalamadı, değer düzeyinde (çıkarma ile) bulundu.

**Kapananlar** (bu kılavuzun ölçümüyle bağımsız doğrulandı):

| Kayıt | G-kaydı | Yol | Ne oluyordu? | Ne zamandan beri? | Kapandığı derleme |
|---|---|---|---|---|---|
| S-504 | G-ISLEC-8 | MIR-x64 | **Gerileme:** ondalık işlenenli karşılaştırmanın değeri yanlış: `PRINT x >= 0` → `nan`. `rnd_randomize`, `ondalik_hassasiyet` örnekleri düşerdi | 17:04 | `2052` (doğrudan), `2144` (`AND`/`OR` ile bileşik) |
| S-506 | G-TIP-17 | AST | **Gerileme:** `I8` … `U64` dönüşümü ondalığı yuvarlar (`bilesik_faiz` örneği) | 12:37 | `2224` |
| S-499 | G-KTIP-7 | AST-x64, WASM | **Açık ret → sessiz:** `RATIONAL` yanlış sonuç yazar (`3/2` → `1` / `0`) | 13:41 | `2052` |
| S-507 | G-KTIP-8 | AST-x64 | **Açık ret → çökme:** `RATIONAL` sıfıra bölme EXE'yi iletisiz çökertir | 13:41 | `2052` |
| S-498 | G-HATA-11 | AST, MIR | Çalışma anı hataları tanı dosyalarına yazılmaz | `20261007` | `2052` |
| S-505 | G-ISLEC-9 | MIR, MIR-x64 | `-(karşılaştırma)` dört yolda farklı sonuç verir | `20261007` | `2144` (MIR), `2209` (MIR-x64) |
| S-502 | G-TIP-16 | AST-x64 | `F32` dizi elemanı doğrudan `PRINT` edilince `0` yazar | `20261007` | `2306` |
| S-503 | G-TIP-15 | MIR, MIR-x64, JS, AST | `F32` dizi elemanı ve bildirim başlangıcı yuvarlanmaz | 17:04 | `2333` (MIR, JS, AST), `0253` (MIR-x64) |
| S-509 | G-TIP-19 | MIR-x64 | **Gerileme:** `F32` dizi elemanını okuyan her ifade çöp verir | 23:33 (`2306` doğruydu) | `0253` |
| S-446, S-510 … S-512 | G-TIP-13, -20, -21, -22 | tüm yollar | **Gizli:** `F32` değeri MIR'de yuvarlanmaz (G-TIP-20); `F32(x)` sonucu MIR-x64'te aritmetikte bozulur (G-TIP-21); `DIM t AS F32 = d` eski AST-x64'te bozulur (G-TIP-22) | `20261007` | `0253` |
| S-219 | G-ISLEC-1 | AST, MIR, x64, JS | **Açık ret → sessiz** (17:04'te): `ROL`/`ROR` dört yolda dört sonuç; öncesinde dar tiplerde kaydırma gibi çalışırdı | `20261007` | `0253` (WASM ve bileşik biçim hariç, aşağıda) |
| S-508 | G-TIP-18 | tüm motorlar | `FIX(x)` sonucu değişkene atanamaz, aritmetiğe girmez (`TYPE_OBJECT`) | `20261007` | `0253` |

**Açık kalanlar** (referans ikilide görünür; her biri ayrı kayıt):

| Kayıt | G-kaydı | Yol | Ne oluyor? | Ne zamandan beri? | Durum (`0253`) |
|---|---|---|---|---|---|
| S-523 | G-NESNE-29 | AST | **Gerileme:** `MAGIC TOSTRING` tanımlı sınıfın sayısal dönüşlü metodunun sonucu değişkene yazılınca `0` olur (`b = f.GetB()`); `UXClazz` ile üretilen her `DERIVE TOSTRING` sınıfı etkilenir | 12:37 (`20261007` doğruydu) | ✖ **açık gerileme** |
| S-539 | G-MODUL-6 | AST | **Gerileme:** `NAMESPACE`/`MODULE` içindeki diziye nitelikli erişim (`sayac.kutu(2) = 7`) hata verir; skaler ve `STRING` çalışır | 12:37 (`20261007` doğruydu) | ✖ **açık gerileme** (model testi `namespace_shared_vars`) |
| S-540 | G-DIL-17 | AST | **Gerileme:** 1024'ten fazla değişkenli program `exec: variable storage capacity exceeded (max 1024)` ile reddedilir | 12:37 (`20261007`'de 2000 değişken çalışırdı) | ✖ **açık gerileme** (model testi `stable_cells_byref_pointer`) |
| S-535 | G-DIS-13 | AST | **Gerileme:** FFI'ye boş metin geçirmek `segmentation violation` ile durdurur (S-145'in izi kayıp) | 12:37 (`20261007` doğruydu) | ✖ **açık gerileme** (model testi `ffi_empty_string_is_real`) |
| S-543 | G-YORDAM-8 | MIR | **Gerileme:** derinliği 50'yi aşan özyineleme iletisiz erişim ihlaliyle çöker (`Aborting : stack overflow`, çıkış 4 yerine); külliyatta 6 vaka | 0253 (`2333` ve öncesi doğruydu) | ✖ **açık gerileme** |
| S-513 | G-WASM-21 | WASM | `SHR` işaretsiz tiplerde (`U8`, `U16`, `U32`) hep `0` verir | `20261007` | ✖ açık |
| S-514 | G-WASM-22 | WASM | `ROL`/`ROR` hiçbir tiple çalışmaz, `0` verir; Codex'in S-219 kapanışındaki `WAT/WASM artifact` denetimi WASM'ı çalıştırmadığı için görmedi | `20261007` | ✖ açık |
| S-520 | G-ISLEC-10 | tüm yollar | `ROL=`/`ROR=` bileşik atamaları döndürme değil kaydırma yapar (`a ROL= 1` → `2`, beklenen `3`) | `20261007` | ✖ açık |
| S-521 | G-DIL-16 | tüm yollar | `STRING` değişkene sayıyı `+=` ile eklemek `UXB_MIXED_STRING_NUMERIC` kapısından geçer; x64 çöker | `20261007` | ✖ açık (S-459, S-460 kısmen) |
| S-515 | G-TIP-23 | MIR | Yordam içindeki yerel `F32` değişkene yazma tek duyarlığa yuvarlanmaz | `20261007` | ✖ açık |
| S-516 | G-TIP-24 | MIR-x64 | `F32` `TYPE` alanı aritmetik işlenen olunca bozulur (`r.v + 1` → `2.5`) | `20261007` | ✖ açık |
| S-517 | G-TIP-25 | MIR-x64, JS | Yordam içinden genel `F32` değişkene atama yuvarlanmaz | `20261007` | ✖ açık |
| S-518 | G-TIP-26 | JS | `BYVAL` `F32` parametre yuvarlanmaz | `20261007` | ✖ açık |
| S-519 | G-TIP-27 | AST | `F32` aritmetik ara sonucu yuvarlanmaz, öteki dört yol yuvarlar | `20261007` | ✖ açık |
| S-500 | G-HATA-13 | CLI | Metin satırı ile JSON iletisi aynı cümle değil; hedef adı üç gruba indirgenir; VS Code dosyasında bilinmeyen konum | S-410'dan beri | ◐ kısmen (çalışma anı üç kodun kaydı yapılandırıldı) |
| S-501 | G-HATA-12 | CLI | Türkçe tanı iletileri Türkçe harfsiz yazılır | `20261007` | karar bekliyor (Mete) |

**Ortak örüntü 1 — kapı gevşemesi.** G-KTIP-7, G-KTIP-8 ve G-ISLEC-1 aynı nedenden doğdu: AST→MIR kapsam kapısı (`ADIM25/26/27`) gevşetilince, daha önce **açıkça reddedilen** programlar derlenmeye başladı ve sağlayıcısı ya da gerçek karşılığı olmayan yollarda sessizce yanlış çalıştı. Bir kapıyı gevşetmek, ardında yanlış sonuç bekleyen programları görünür kılar; bu yüzden kapı değişikliğinden sonra yalnız "düzelenler" değil, "daha önce reddedilen ama artık geçenler" de ölçülür (K.6).

**Ortak örüntü 2 — sınama düzeyi.** `F32` kayıtlarının (G-TIP-13, -20 … -27) ve `ROL`/`ROR` kaydının (G-ISLEC-1) ilk kapanışları kusurları **gizledi**, çünkü sınama gerçek hesabı değil görüntüyü ölçüyordu: `PRINT f` yuvarlayan ve yuvarlamayan motorda aynı `1.677722e+07` yazar, yalnız `f - 16777216` ayırır; `ROL`/`ROR` için WASM'da üretilen `.wasm` dosyasının varlığı denetlendi, çalıştırılmadı. Kural: **bir kapanışı değer düzeyinde ve her yolda gerçekten çalıştırarak sınayın** (K.6). Bu kılavuzun kendisi de bir kez aynı hataya düştü: S-446'yı yazdırma düzeyindeki ölçümle kapattı, çıkarma ile açtı.

**Ortak örüntü 3 — örnek kümesi yetmez, model paketleri gerekir.** Kitabın 197 örneği ve 1837 vakalık külliyat, depoda 46 paketle sınanan alanın küçük bir bölümünü kapsar. H, I ve J belirtileri ile bayat `neg_gosub_refused` yalnız model paketlerinde göründü; `GOSUB` ve `GOTO` anlatımındaki bayatlama da (Bölüm 7.6) ancak oradan fark edildi. Kural: bir ikili aday olunca örnek ve külliyat ölçümüne **tam model paketi koşusu** eklenir (K.6; 108 dakika, build klasörlerinde birkaç GB).

**Bu ölçümde bulunan eski kusurlar.** Aşağıdakilerin hepsi `20261007`'de de aynıdır (gerileme değil); hepsi SORUN_TAKIP'ta ayrı kayıttır. Eski AST-x64 yoluna özgü olanların anlatımı Bölüm 1.3'tedir.

| Kayıt | G-kaydı | Yol | Kısaca |
|---|---|---|---|
| S-524 | G-ISLEC-11 | eski AST-x64 | `F64`/`F32` değişkende tekli eksi bit düzenini eksiltir (`x = -x` → `4.6e+18`) |
| S-525 | G-ISLEC-12 | eski AST-x64 | `I32 / I32` tamsayı bölümü verir (`3`), `CDBL` yok (eski S-086) |
| S-533 | G-ISLEC-13 | eski AST-x64 | İçinde `PRINT` olan işlev tamsayı işlemin sağ işleneniyse program çöker |
| S-526 | G-TIP-28 | eski AST-x64 | Rutin içindeki yerel tamsayı ondalık işlemde bit düzeniyle okunur |
| S-527 | G-YORDAM-7 | eski AST-x64 | Yerel değişken sıfırlanmaz |
| S-528 | G-METIN-6 | eski AST-x64 | Metin işlemlerinin sonucu geçici halkada tutulur (`STR` tek yuva, birleştirme ve `LEFT` 32 yuva); değişken kopya değil yuvayı gösterir, yuva yeniden kullanılınca başka metne dönüşür (eski S-157-L) |
| S-529 | G-VERI-13 | eski AST-x64 | `REDIM` ile büyütülen dizi büyümez, komşu belleği bozar |
| S-530 | G-AKIS-3 | eski AST-x64 | `F64` `FOR` sayacı tamsayı gibi artar |
| S-531 | G-MODUL-5 | eski AST-x64 | `MODULE` içindeki değişken okunamaz |
| S-534 | G-DOSYA-7 | eski AST-x64 | `PRINT #n, tamsayı` çöker |
| S-536 | G-DOSYA-8 | eski AST-x64 | Satır sonu `LF` (`LOF` `4`, öteki yollar `5`) |
| S-538 | G-HATA-14 | eski AST-x64 | Desteklenmeyen yerleşikler assembler ya da bağlayıcı hatası olarak bildirilir |
| S-532 | G-AKIS-4 | AST | Döngü içindeki `GOSUB`'tan `RETURN` döngüyü de bitirir |
| S-537 | G-AKIS-5 | AST, MIR, MIR-x64, eski AST-x64, JS, WASM | `GOSUB`'suz `RETURN`: AST hata verir, MIR, MIR-x64, JS ve WASM sessizce biter, eski AST-x64 çöker |
| S-541 | G-MODUL-7 | AST, MIR, MIR-x64, JS | `NAMESPACE`/`MODULE` dizi elemanı doğrudan atama ya da `RETURN` kaynağıysa `TYPE_OBJECT` sanılır |

### K.5 Değişmeyenler ve değişenlerin nedeni

1688 ortak vakanın 1537'sinde (%91,1) hiçbir motorda sonuç değişmedi: külliyatın kapsadığı Ek G kayıtlarının K.2 ve K.4'te anılanlar dışındakileri `20261014_0253`'te de aynen geçerlidir. Külliyata bu arada 149 yeni vaka eklendi (1837 vaka). Değişen 151 vakanın nedenleri (bir vaka tek nedene yazılır; ilk çıkarımda yedi MIR özyineleme vakası "ileti metni" sayılmıştı, ayrı satıra alındı):

| Neden | Vaka | Niteliği |
|---|---|---|
| S-440 parantezsiz çağrı reddi (`lex` dahil) | 46 | bilinçli |
| `RATIONAL` programı MIR dışında `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ile reddedilir (S-499, S-410) | 21 | bilinçli (açık ret) |
| Sayı ile `STRING` karışımı `UXB_MIXED_STRING_NUMERIC` ile reddedilir (S-459, S-460) | 20 | bilinçli (açık ret) |
| Yalnız ayrıştırma hatası sayısı ya da FFI ileti metni | 5 | ileti metni |
| MIR derin özyineleme (`vaka_derin`, `ozyine_derin`): `Aborting : stack overflow` (çıkış 4) yerine iletisiz erişim ihlali (S-543, G-YORDAM-8) | 7 | **gerileme** |
| Zaman aşımı, bellek adresi ya da geçici dosya yarışı gürültüsü | 15 | ölçüm gürültüsü: `20261007` ölçümü yük altındaydı (8), x64 çıktısı bellek adresi yazar ve her çalıştırmada değişir (6), ham FreeBASIC "file not found" bir yarıştı (1); tek başına koşturunca geçer |
| S-444 JS yakalanmayan istisna iletisi | 9 | bilinçli |
| S-441 `CONST` yazma reddi | 6 | bilinçli |
| S-442 `UNION` ortak bellek | 5 | düzelme |
| S-443 `MAGIC AND/OR/XOR` | 4 | düzelme |
| S-446 `F32` yazdırma ve yuvarlama | 3 | düzelme |
| S-219 `ROL`/`ROR` döndürme | 3 | düzelme |
| S-445 DLL tip listesi | 2 | bilinçli |
| JS `GOSUB`, geriye `GOTO` ve ileriye `GOTO` (eskiden zaman aşımı) | 3 | düzelme |
| S-505 `-(karşılaştırma)` | 1 | düzelme |
| Kapanış kapısı gevşedi (`TASK_SPAWN`) | 1 | açık ret → başka sonuç |

**Açıklanamayan vaka kalmadı.** Bu sonuca iki ölçüm hatası düzeltilerek varıldı: (1) `20261013_2224` ölçümünde yedi `INPUT` hücresi zaman aşımına düşmüştü, çünkü külliyat koşucusu alt sürecin standart girdisini kapatmıyordu (kapatılınca `20261007` ile `2224` aynı sonucu verdi); (2) sınıflayıcı tek başına tamsayı olan x64 çıktılarını ve `RATIONAL` ret iletilerini tanımıyordu. Bu paragraf ilk yazıldığında üçüncü bir hata gözden kaçmıştı: derin özyinelemede MIR'in `Aborting : stack overflow` (çıkış 4) yerine iletisiz çöküşe geçmesi (7 vaka) "ileti metni" sayılmıştı; model paketlerinin ve WASM farkının ardından bütün kategoriler yeniden gözden geçirilince ayrı bir **gerileme** satırına (S-543) alındı. Sınıflayıcıya o kategori eklendi; kalan kategorilerin üyeleri tek tek görüldü.

**İddia denetimi** (1039 beklenen değer, 4 motor): `20261007`'de 1005, `20261014_0253`'te **1024** geçer. Düzelen 19 hücre: `MAGIC AND/OR/XOR` (12), `5 + "a"` (3; artık beklendiği gibi reddedilir), `UNION` üst üste (MIR, x64), `F32` 7 hane (JS), bilinmeyen DLL tipi (x64); yeni bozulan yok. Kalan 15 sapmanın hepsi `20261007`'den beri aynıdır ve Ek G'de kayıtlıdır: `MAGIC CALL` (MIR, x64 ve JS'te `a(3)` çağrısı bağlanmaz) ve eski tip adlarının `SIZEOF` içinde reddi (`LONG`, `DOUBLE`, `SHORT`, `BYTE`; 12 hücre; G-TIP-6, G-TIP-13).

Bu denetim sırasında dört iddia **kendi hatası** yüzünden sapıyordu ve düzeltildi: `PRINT` virgül bölgesi beklentisi 14 değil 13 boşluktu (bölge 14 karakterdir, kitap örneği `11_io/print_virgul` aynı sonucu verir); kurucu argümanlı sınıf iddiasında değişken adı sınıf adıyla çakışıyordu (tip ve değişken adları aynı ad uzayındadır); `%%ENV "PATH"` iddiası uzun bir yol dizisini `%%IF` koşulu yapıyordu (sayısal `NUMBER_OF_PROCESSORS` ile çalışır); `5 + "a"` iddiasının beklentisi tasarım kararı gereği `5a`'dan `HATA`'ya çevrildi (S-459). İddiayı düzeltmek derleyiciyi aklamak değildir: düzeltilen üç iddia `20261007`'de de aynı sonucu alıyordu, yani beklenti yanlış yazılmıştı; her düzeltme iddia dosyasında `not` alanıyla gerekçelendirildi.

**Kitap örnekleri (196 ortak örnek):**

| Motor | 20261007'de geçen | 20261014_0253'te geçen | Fark |
|---|---|---|---|
| AST | 193 | 193 | — |
| MIR | 194 | 194 | — |
| x64 | 193 | 193 | — |
| JS | 110 | 112 | `gosub_return`, `goto_etiket` düzeldi |
| WASM | 21 | 21 | — |
| AST, MIR ve x64'ün üçünde | 191 | 191 | — |

Kitaba bu arada bir örnek daha girdi (`44_kv_isleclar/bit_dondurme`: `ROL`/`ROR`); AST, MIR, x64 ve JS'te geçer, WASM `0` yazar (S-514). Beklenen motorlarda geçen: 197/197. Yük altında `mutex`, `paralel_asal_sayim`, `taskgroup` (MIR) ve `gsl_hesap_defteri`, `koleksiyonlar_karma`, `ai_siniflandirici_cikisi` (AST) zaman aşımına düşebilir; makine boşken tek başına koşturulunca hepsi geçer (AST'deki iki kütüphane örneği 75–95 saniye sürer, G-HIZ-2). `mutex`, `paralel_asal_sayim` ve `taskgroup` MIR'de on kez art arda koşturuldu: `20261007` ve `20261014_0253`'te on koşunun hepsi aynı sonucu verdi (aralıklı takılma gözlenmedi).

**Eski AST-x64 (`vaka_kos.py … --motor x64a`).** 303 iddia vakasında `20261007` ile `20261014_0253` arasında 8 vaka değişti ve hepsi iyileşti: `MAGIC AND/OR/XOR` (`0` yerine `4`, `12`, `8`), `5 + "a"` ve bilinmeyen FFI tipi artık açık ret, parantezsiz `swap`, `sleep`, `with` çağrısı `UXB_CALL_PAREN_REQUIRED` ile reddedilir. Örneklerde GEÇTİ olmayan 107 örnek iki ikiliyle koşuldu: 19 değişim, gerçek olanlar `rational_harmonik` (yanlış sonuç → açık ret, S-499) ve `kutuphane_dil_zinciri` (zaman aşımı → açık ret). Bu ölçümde bulunan eski AST-x64 kusurları (K.4'teki ikinci tablo) `20261007`'de de aynıdır; anlatımı Bölüm 1.3'tedir.

**CLI taraması.** 91 dosya çıktılı seçenek ve 46 bayrak, altı fiilde (`run`, `x64`, `jsw`, `wat`, `mir`, `bld`): `20261007` ile `20261014_0253` arasında çıkış kodu ya da üretilen dosya kümesi bakımından **0 değişiklik**. Bölüm 2.8 ve G-CLI kayıtları `0253`'te de aynen geçerlidir.

**WASM külliyat farkı** (1863 vaka, yalnız WASM motoru; bu ölçümde külliyata 26 vaka eklendi). 132 vakada sonuç değişti (bir vaka tek sınıfa yazılır):

| Sınıf | Vaka | Niteliği |
|---|---|---|
| Yine reddedilir, yalnız ileti metni değişti (S-440 parantez iletisi, S-459 ve S-460 karışık tür kapısı, S-499 `RATIONAL` kapısı) | 97 | bilinçli |
| Eskiden reddediliyordu, şimdi çalışır ve beklenen sonucu verir: 10'u yeni `iddia_akis` vakaları (`GOSUB`, `GOTO`), ikisi eski külliyattan (`UNION` üst üste, geriye `GOTO`) | 12 | düzelme (Bölüm 7.6) |
| Çalışıp yanlış sonuç veriyordu, şimdi açıkça reddedilir (`CONST` yazma 4, `RATIONAL` 3, alan gizleme 1, parantezsiz çağrı 1) | 9 | bilinçli (açık ret) |
| Zaten çalışıyordu, yanlıştı; şimdi AST ile aynı sonucu verir (`TYPE` alanında `AND`/`OR`/`XOR`, bileşik atama) | 6 | düzelme |
| Açık ret idi, şimdi `0` yazar: `MAGIC AND` (3), `ROL`/`ROR` (3) | 6 | **açık ret → sessiz yanlış** (G-WASM-6, G-WASM-22; K.4 ortak örüntü 1) |
| Koşul sonucunu alana yazmak: WASM `1` verir (AST `-1`); eskiden `0` verirdi | 2 | eski kusur, değer değişti |

**WASM'da gerileme yoktur:** `20261007`'de AST ile aynı sonucu veren hiçbir vaka bozulmadı. WASM'ın derlediği vakaların 431'i AST ile aynı, 196'sı farklı sonuç verir (`G-WASM-1 … -22` kayıtları), 1194'ü açıkça reddedilir (ondalık sayı 49+19, metin yüzlerce, `RATIONAL` 21, karışık tür 20, `NATIVE_ONLY_UNSUPPORTED_ON_WASM` 15).

**Model paketleri** (`tests\run_all_model_tests.ps1`, yalnız `20261014_0253` ile; 46 paket, 6501 saniye). 1605/1610 kontrol geçti, 42 paket temiz, 4 paketin her birinde bir ya da iki kontrol düştü: `compiler_consolidation` 267/268 (AST `stable_cells_byref_pointer`, S-540), `language_guards` 107/108 (AST `ffi_empty_string_is_real`, S-535), `task_sync` 111/112 (AST `namespace_shared_vars`, S-539), `wasm_model` 55/57 (`neg_gosub_refused` WASM ve JS için: test bayat, S-123). Üç AST testi `20261007`'de geçiyordu (K.3 H, I, J).

### K.6 Yeniden ölçme

```text
python tools\kitap\kilavuz_v2\yoklama\vaka_kos.py kos --uxb bin\<yeni>.exe --cikti yeni.json
python tools\kitap\kilavuz_v2\yoklama\vaka_kos.py fark eski.json yeni.json
python tools\kitap\kilavuz_v2\yoklama\fark_sinifla.py eski.json yeni.json BOZULDU --motor AST
python tools\kitap\kilavuz_v2\yoklama\iddia_beklenen.py yeni.json --ayrinti
python tools\kitap\ornek_dogrula.py --uxb bin\<yeni>.exe --web --is 4 --sonuc yeni_ornek.json
python tools\kitap\kilavuz_v2\yoklama\ornek_fark.py yeni_ornek.json --sadece-kitap --ayrinti
python tools\kitap\kilavuz_v2\yoklama\yol_matrisi.py --uxb bin\<yeni>.exe --dosya program.uxb
python tools\kitap\kilavuz_v2\yoklama\ornek_astx64.py --uxb bin\<yeni>.exe --sonuc astx64.json
python tools\kitap\kilavuz_v2\yoklama\vaka_kos.py kos --uxb bin\<yeni>.exe --motor x64a --sadece .iddia.json --cikti x64a.json
python tools\kitap\kilavuz_v2\yoklama\vaka_kos.py kos --uxb bin\<yeni>.exe --motor WASM --cikti wasm.json
.\tests\run_all_model_tests.ps1 -Uxb .\bin\<yeni>.exe -ReportPath build\model_rapor.md
```

Model paketleri 46 paket için yaklaşık 108 dakika sürer ve çok sayıda `build\<tarih>` klasörü bırakır (birkaç GB; disk izlenmelidir). `-ReportPath` **göreli** olmalıdır: betik yolu kök klasöre ekler, mutlak yol verilirse paketler koşar ama rapor dosyası yazılamaz (günlüğün sonunda `WriteAllText` hatası görünür; G-ARAC-6).

Tam külliyat (1837 vaka × 4 motor) makine boşken yaklaşık 100 dakika, 281 örnek yaklaşık 30 dakika sürer; `yol_matrisi.py` bir programı altı yolda (AST, MIR, MIR-x64, eski AST-x64, JS, WASM) yan yana koşturur. Gürültüden ayırmak için tek başına geçen ya da düşen hücre makine boşken yeniden koşturulur. Külliyat koşucusu alt sürecin standart girdisini kapatır (`INPUT` içeren vakalar bekleyip zaman aşımına düşmesin; bu `20261013_2224` ölçümünde yedi hücreyi yanıltmıştı). Ölçüm sırasında her koşu bir `build\<tarih>` ağacı bırakabilir: `cli_secenek_tarama.py` bu yüzden her koşudan sonra kendi klasörünü siler (`--sakla` ile saklanır; saklanırsa yaklaşık 1 GB tutar); model testleri ise yüzlerce klasör bırakır, disk izlenmelidir.

`python tools\kitap\kilavuz_v2\yoklama\gerileme_sondalari.py --uxb bin\<yeni>.exe` bu ekte anılan kusurları altı yolda beş dakikada yoklar (K.4'teki durum sütununun kaynağı; 35 sonda); yeni bir Codex derlemesi için ilk bakış budur, tam ölçüm (yukarıdaki komutlar) yalnız aday derlemede yapılır. Sondalar **değer düzeyinde** yazılmıştır (çıkarma, gerçek WASM çalıştırması, bileşik atama); yeni bir kusur bulunduğunda önce buraya sonda eklenir.

**Referansı değiştirme koşulu.** Referans ikili şu üçü birlikte sağlanınca değiştirilir: (1) K.4'te **gerileme** diye işaretli açık kayıt yok ya da her biri kitapta açıkça anlatılmış (şimdi S-523, S-535, S-539, S-540 ve S-543 bu ikinci durumdadır); (2) vaka farkında açıklanamayan hücre yok; (3) kitap örnekleri beklenen motorlarda geçiyor. Ölçüm başlayan ikili **dondurulur**: ölçüm sürerken çıkan yeni derlemeler yalnız sondalarla izlenir ve K.1'e yazılır, referansı değiştirmez; aksi hâlde hareketli bir hedefin peşinde ölçüm hiç bitmez.
