# uXBasic Hedeflenen Sistem ve Kullanma Kılavuzu

**Sürüm 2 · @@TARIH@@ · Ana başvuru belgesi**

> Bu belge uXBasic'in **bugün çalışan** hâlini ile **tasarım kararlarıyla hedeflenen** hâlini aynı yerde, ama birbirine
> karıştırmadan anlatır. Her kod örneği gerçek derleyicide çalıştırılmış, çıktısı karşılaştırılmıştır. Çalışmayan ya da henüz
> yapılmamış bir şey "çalışıyor" diye yazılmaz; yapılmamış olan, **◇ HEDEF** etiketiyle ayrıca gösterilir.

| Konu | Bilgi |
|---|---|
| Dil | uXBasic: BASIC soyundan gelen, açık tipli, tek kaynaktan çok hedefe derlenen bir dil |
| Derleyici | uXBasic Compiler v1.06, komut satırı arayüzü "Adim12" |
| Geliştirici | Zuhtu Mete DINLER |
| Lisans | MIT, 2026 |
| Doğrulamada kullanılan derleyici | {{SURUM}} |
| Doğrulama kapsamı | Bütün kod örnekleri (AST, MIR, x64; JS ve WASM ayrıca). Bunun dışında 3, 4, 5, 7–13 ve 15–17. bölümlerdeki **tablo ve anlatım iddiaları** da (yazım biçimleri, "yoktur/vardır", hata iletileri, motor farkları) dört motorda ayrıca sınanmış; yanlış çıkanlar düzeltilip Ek G'ye yazılmıştır. 2, 6, 14 ve 18–22. bölümlerin iddiaları kısmen sınanmıştır (kaynağın kendi kayıt defterinden üretilen ya da örneklerle desteklenen yerler dışında kalanlar ? DENENMEDİ etiketi taşır) |
| Önceki ikililer | Kılavuzun ilk sürümü `bin\uxb_kilavuz_20261007.exe` ile yazıldı. Codex'in 2026-10-13 ve 2026-10-14 derlemeleri (`bin\uxb_kilavuz_20261013*.exe`, `bin\uxb_kilavuz_20261014_0253.exe`) ayrıca ölçüldü; **referans artık `20261014_0253`'tür**. İki ikili arasındaki farklar, kapanan ve yeni açılan kayıtlar (S-440 … S-523) ve ölçüm yöntemi Ek K'dadır; referansta açık bir AST gerilemesi vardır (S-523, `MAGIC TOSTRING` tanımlı sınıfta metot sonucu) ve her yerde açıkça yazılıdır |
| Kimler için | 17-25 yaş arası, programlamaya yeni başlayandan ileri düzeye |
| Karar kaynakları | `docs/tasarim` altındaki tasarım belgeleri (liste: Ek I) |
| Bu belgenin üretimi | `python tools/kitap/kilavuz_v2/uret.py` (örnekler her üretimde sonuç dosyalarından doldurulur) |

---

## 0.1 Bu belge ne işe yarar?

uXBasic'te iki şey aynı anda gelişiyor: **dil** (neler yazılabilir) ve **derleyici** (yazılanı hangi hedefte nasıl çalıştırır).
Bu ikisi her zaman aynı hızda ilerlemez. Bu yüzden bu belge iki soruyu ayrı ayrı yanıtlar:

1. **Ne yazılabilir ve nasıl çalışır?** → Bölüm 3'ten itibaren, her özellik için amaç, yazım, örnek ve benzerlerinden farkı.
2. **Hangi hedefte ne kadarı gerçekten çalışıyor?** → Her örneğin altındaki *motor durumu* satırı ve Ek G'deki bilinen sınırlar.

Bu belge, bundan sonraki geliştirmenin **temel başvurusudur**: bir davranış burada yazılıysa derleyici ona uymak zorundadır;
derleyici başka türlü davranıyorsa ya bu belge ya da derleyici düzeltilir, ama fark sessizce bırakılmaz.

## 0.2 Nasıl okunur?

| Hâlin | Önerilen yol |
|---|---|
| Programlamaya yeni başladın | Bölüm 0 → 1 → 3 → 4 → 5 → 6 → 7 → 8 sırasıyla oku, her örneği kendin çalıştır |
| Başka bir dil biliyorsun | Bölüm 1 (ilkeler), sonra 4, 6, 8 ve 15 (görevler); farklar tablolarına bak |
| Derleyiciyi geliştireceksin | Bölüm 1, 2, 17, 18, 21, 23 ve Ek G; her bölümdeki ◇ HEDEF ve ✖ SINIR satırları yapılacak işleri gösterir |
| Hızlıca bir komutu arıyorsun | Ek A (anahtar sözcük dizini), Ek B (işlev dizini), Ek C (önişlemci dizini) |

Her bölüm aynı sırayı izler: **Amaç → Yazım → Örnek → Benzerlerinden farkı → Dikkat edilecekler**.
Önce kısa tablolarla genel bakış verilir, sonra orta ve ileri düzey örneklere geçilir.

## 0.3 Etiketler

| Etiket | Anlamı |
|---|---|
| ✔ ÇALIŞIYOR | Bu belgedeki bir örnekle gerçek derleyicide denendi; hangi motorlarda geçtiği örneğin altında yazar |
| ◐ KISMEN | Bir bölümü çalışıyor, sınırı yazılı |
| ◇ HEDEF | Tasarım kararı var; derleyicide henüz yok (derleyici ya açıkça reddeder ya da tanımaz) |
| ✖ SINIR | Bilinen hata ya da eksik; Ek G'de numarasıyla anılır |
| ⌛ ESKİ | Eski uyumluluk biçimi; yeni kodda kullanılmaz |
| ? DENENMEDİ | Kaynakta var, bu belge yazılırken örnekle sınanmadı |

## 0.4 Motorlar ve durum simgeleri

uXBasic programı beş farklı yolla çalıştırılabilir. Buna **motor** ya da **hedef** denir.

| Motor | Kısaca | Nasıl çalıştırılır |
|---|---|---|
| **AST** | Sözdizimi ağacını doğrudan yürüten yorumlayıcı. Dilin **referans davranışı** burada okunur | `uxb run dosya.uxb` |
| **MIR** | Ara kodu (MIR) yürüten yorumlayıcı | `uxb run dosya.uxb --interpreter-backend MIR` |
| **x64** | MIR'den yerel Windows programı (EXE) üretir | `uxb bld dosya.uxb --build-x64 --build-x64-out cikti\dosya.exe` |
| **JS** | MIR'den JavaScript üretir; `node` ile ya da tarayıcıda çalışır | `uxb jsw dosya.uxb --js-out dosya.js` |
| **WASM** | MIR'den WAT metni, oradan WebAssembly üretir | `uxb wat dosya.uxb --emit-wasm --wasm-out dosya.wasm` |

Bir örneğin altında şöyle bir satır görürsün:

*Motor durumu: AST ✔ · MIR ✔ · x64 ✔ · JS ✔ · WASM ◌*

| Simge | Anlamı |
|---|---|
| ✔ | Beklenen çıktıyı birebir verdi |
| ◌ | **Açık ret**: derleyici "bunu yapamıyorum" dedi ve nedenini yazdı. Bu bir eksiktir ama **dürüst** bir eksiktir |
| ✖y | **Yürütme hatası**: kod üretildi, çalışırken eksik bir bağ yüzünden durdu (yine gürültülü) |
| ✖ | Derleme ya da çalışma hatası |
| ≠ | Çalıştı ama **yanlış çıktı** verdi. Bu en kötü durumdur (sessiz hata); Ek G'ye yazılır |
| — | Bu motorda denenmedi |

> **Kural:** Bir örnek ◌ ile bitiyorsa sorun yok, eksik var demektir. ≠ ile bitiyorsa derleyicide hata var demektir.

Eski AST-x64 ("legacy") yolu da vardır (`--x64-mode AST`) ve 2026-10-11 kararıyla **korunur**. Görev sistemi gibi yeni özellikleri bugün **açıkça reddeder**;
bu ret bir ara durumdur (hedef, altı yolun aynı dil davranışını vermesidir) ve eşlik kapanışı sayılmaz. Bu belgede ayrı bir sütun olarak izlenmez.

## 0.5 Hızlı başlangıç

İlk programımız: bir değişken, bir metin ve bir hesap.

{{ORNEK:40_kv_baslangic/ilk_program}}

Çalıştırmak için dosyayı `ilk.uxb` adıyla kaydedip şunu yazarız:

```
uxb run ilk.uxb
```

Aynı programı yerel bir EXE'ye çevirmek için:

```
uxb bld ilk.uxb --build-x64 --build-x64-out cikti\ilk.exe
cikti\ilk.exe
```

EXE adının önüne bir klasör yazın (`cikti\ilk.exe`); klasör yoksa derleyici oluşturur. Yalın `ilk.exe` yazarsanız `bld` çıkış 14 ile düşer (✖ G-CLI-21). Klasörde EXE'nin yanında çalışma zamanı DLL'leri de bulunur (Bölüm 2.5).

Tarayıcıda çalışacak JavaScript üretmek için:

```
uxb jsw ilk.uxb --js-out ilk.js
node ilk.js
```

Program büyüdüğünde başlangıç noktasını `MAIN ... END MAIN` ile belirtebiliriz. `MAIN` dışında tanımlı yordamlar
ve işlevler önce yazılır:

{{ORNEK:40_kv_baslangic/ilk_program_main}}

### Aynı kaynak, beş hedef

Yalnızca tamsayı ve döngü kullanan bir program, beş motorun hepsinde aynı çıktıyı verir. Aşağıdaki program 30'a kadar
asal sayıları yazar:

{{ORNEK:40_kv_baslangic/asal_bes_motor}}

Metin yazdıran ilk programımız ise WASM'da **◌ açık ret** ile biter, çünkü WASM hedefinde metin için doğrusal bellek
desteği henüz yazılmamıştır. Derleyici bunu sessizce yanlış yapmak yerine açıkça söyler:

```
ERROR: web backend pipeline basarisiz: WAT string linear-memory lowering is not implemented; refusing fake null handle for "..."
```

İşte bu belgenin her yerinde göreceğin ilke budur: **yapamıyorsa söyler, yapıyorsa doğru yapar.** Bu ilke Bölüm 1'de ayrıntılı anlatılır.

## 0.6 Kısa sözlük

| Terim | Anlamı |
|---|---|
| Deyim (statement) | Tek başına çalışan satır: `PRINT 3`, `DIM a AS I32` |
| İfade (expression) | Değer üreten yazım: `a * 2 + 1` |
| İşleç (operator) | İfadeyi birleştiren işaret ya da sözcük: `+`, `MOD`, `AND` |
| İşlev (function) | Değer döndüren altprogram: `FUNCTION` |
| Yordam (sub) | Değer döndürmeyen altprogram: `SUB` |
| Sözcük çözümleme (lexer) | Kaynağı sözcüklere (belirteçlere) ayıran aşama |
| Çözümleyici (parser) | Sözcüklerden sözdizimi ağacı (AST) kuran aşama |
| Anlam çözümleme (semantic) | Tip, kapsam, ad çözümü ve yerleşimi denetleyen aşama |
| MIR | Orta düzey ara kod: tüm hedeflerin ortak girdisi |
| Önişlemci | Kaynak metni, derlemeden **önce** değiştiren/üreten `%%` komutları sistemi |
| Meta komut | Programın kendisini tanımlayan `REM %%` satırları |
| Tanı (diagnostic) | Derleyicinin verdiği hata ya da uyarı iletisi |
| Kapalı başarısızlık (fail-closed) | Emin olmadığı şeyi yapmayıp reddetme |
| Eşlik (parity) | Aynı programın bütün motorlarda aynı sonucu vermesi |
| Tutamaç (handle) | Bir nesneyi/göreve işaret eden opak değer; sayı gibi işlem yapılmaz |

## 0.7 Başlangıç için programlama kararları

* **İlk programı `uxb run` ile çalıştırın**, sonra EXE'ye çevirin. Her yeni özelliği en az iki motorda çalıştırıp çıktıyı karşılaştırmak, hem programınızı hem derleyiciyi sınar.
* Her örneğin altındaki **motor durumu satırını okuyun**: `◌` bir sorun değildir (derleyici dürüstçe reddetmiştir), `≠` derleyicide kusur demektir.
* Belgede **◇ HEDEF** yazan biçimi bugünkü programda kullanmayın; **✖ SINIR** yazan yerde verilen geçici çözümü uygulayın.
* Programınızı `MAIN ... END MAIN` ile başlatın; yordam ve işlevleri `MAIN`'in dışında tanımlayın, okunaklılık için çağrıdan önce yazın.
* Metin yazdıran bir programı WASM'a derlemeyi denemeyin: WASM şimdilik yalnız tamsayı hesap çekirdekleri içindir (Bölüm 21).
* Bu belgedeki örnekleri **kopyalayıp değiştirerek** öğrenin; her değişiklikten sonra çıktıyı örneğin altında yazılı olan çıktıyla karşılaştırın.
