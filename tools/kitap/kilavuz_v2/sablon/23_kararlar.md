# 23. Programlama kararları rehberi

Bir programı yazarken yüzlerce küçük karar verirsiniz: hangi veri yapısı, hangi hata yolu, hangi hedef, hangi kütüphane? Bu bölüm o kararları **maddeler hâlinde** toplar.
Her madde, kılavuzun ilgili bölümünde **gerçek derleyiciyle sınanmış** bir davranışa dayanır; dayandığı kayıt (`G-…`) maddenin içinde yazılıdır.

## 23.1 Bu bölüm nasıl kullanılır?

| Bakmak istediğiniz | Nereye? |
|---|---|
| Programa başlarken hangi soruları, hangi sırayla soracağım? | 23.2 |
| İki üç benzer seçenek arasında hangisini seçeceğim? | 23.3 |
| Bu kuralların altında hangi ilke var? | 23.4 |
| Bir konudaki bütün kararları sırayla görmek | 23.5 (bölüm bölüm) |
| Bir kararın gerekçesini ve örneğini görmek | Maddenin yanındaki bölüm numarası (örn. 8.10) |

Maddeler `K<bölüm>.<sıra>` ile numaralanır (örnek: `K8.2`). Numara bu belgenin bu sürümündeki **sırayı** gösterir; kalıcı başvuru için bölüm numarasını (8.10) ve maddenin ilk sözlerini kullanın.

> **Kural:** Kuşku duyduğunuzda **sessiz yanlışı değil açık reddi** seçin. Derleyicinin "yapamıyorum" demesi bir eksiktir ama dürüst bir eksiktir; yanlış sonucu sessizce vermesi (`≠`) en kötü durumdur (Bölüm 0.4). Bu yüzden aşağıdaki kararların çoğu, "derleyicinin sizi korumadığı yerde korumayı **siz** üstlenin" biçimindedir.

## 23.2 Karar sırası: bir programa başlarken

| Sıra | Soru | Neye karar verirsiniz? | Ayrıntı |
|---|---|---|---|
| 1 | Program nerede çalışacak? | Hedef: x64 (EXE), JS (tarayıcı/Node), WASM (küçük hesap çekirdeği). Hedefin desteklemediği özelliği baştan dışarıda bırakın | 1.3, 21 |
| 2 | Veri nasıl bir yapıda? | Dizi, `TYPE`, `LIST`, `DICT`, `SET`, `CLASS`; tipler ve dönüşümler | 4, 5, 10 |
| 3 | İş nasıl parçalanacak? | `SUB`/`FUNCTION`, özyineleme, sınıf, `BYREF` çıkışları | 8, 11 |
| 4 | Hata ve varsayımlar nasıl yönetilecek? | `THROW` + `TRY/CATCH`, `ASSERT`, önceden `IF` denetimi | 12 |
| 5 | Dış dünya ile nasıl konuşulacak? | Dosya, `SHELL`, DLL, kütüphane; her kütüphanenin hata bildirimi ayrı | 13, 16, 20 |
| 6 | İşler aynı anda mı yürüyecek? | `EVENT`, `PIPE`, `THREAD`, `PARALEL`, `SPAWN`; ortak veri koruması | 15 |
| 7 | Bellek elle yönetilecek mi? | `VIRTUAL` (varsayılan) ya da `NATIVE` | 14 |
| 8 | Derleme zamanında kod üretilecek mi? | Önişlemci (`%%`), meta (`REM %%`), kütüphane tipi | 17, 18, 19 |
| 9 | Nasıl doğrulanacak? | Önce AST'de, sonra MIR ve x64'te çalıştırıp çıktıyı karşılaştırın | 1.7, 2.11 |

## 23.3 Benzer seçenekler arasında karar tablosu

| İhtiyaç | Seçin | Kaçının | Bölüm |
|---|---|---|---|
| Yordam, işlev ya da metot çağırmak | **Parantezli** yazım: `Selam("Ayse")`, `Say()`, `o.Metot()`, `CALL Selam("Ayse")` (karar: parantez zorunludur) | Parantezsiz `Selam "Ayse"`, `Selam`, `Artir n`: 20261007'de sessizce hiçbir şey yapardı; 20261013 ve sonrasında `UXB_CALL_PAREN_REQUIRED` ile reddedilir (G-YORDAM-6) | 8 |
| Tek bir değer üretmek | `FUNCTION` + `RETURN` (her yol `RETURN` ile bitsin) | `SUB`'dan değer beklemek | 8 |
| Birden çok sonuç döndürmek | `BYREF` çıkış parametreleri | Kayıt döndüren işlev (G-VERI-3) | 8, 10 |
| Bir varlığın farklı tipli alanları | `TYPE`; alanları yordama ayrı geçirin | Kaydı değerle ya da `BYREF` geçirmek (G-VERI-6, G-VERI-2) | 10 |
| Aynı tipten sabit sayıda değer | Dizi; kopyayı döngüyle yapın | `b = a` ile dizi kopyası (G-VERI-4) | 5, 10 |
| Büyüyen, karışık tipli liste | `LIST` (`FOR EACH` ile tipli okuyun) | Metin değerini doğrudan `PRINT LISTGET(...)` (G-KOLEKSIYON-1) | 10 |
| Anahtardan değere eşleme | `DICT` (`DICTGET` ile okuyun) | Anahtar sırasına güvenmek | 10 |
| Benzersiz değerler kümesi | `SET` | Yinelenenleri elle ayıklamak | 10 |
| Veri + davranış | `CLASS`; her `NEW` için bir `DELETE` | Nesneyi `b = a` ile kopyalamak, `PRIVATE` alana güvenmek (G-NESNE-2) | 11 |
| Metot sözleşmesi | `INTERFACE` + `IMPLEMENTS` | `ABSTRACT`, `MIXIN` (yoktur, G-NESNE-6) | 11 |
| Beklenen, kurtarılabilir hata | `THROW` + `TRY/CATCH` | `CATCH e` (G-HATA-4), `TRY` içinde `RETURN` (G-HATA-1) | 12 |
| "Bu asla olmamalı" | `ASSERT` | Kullanıcı girdisini `ASSERT` ile doğrulamak | 12 |
| Çalışma anı hatası (sıfıra bölme, sınır) | Önceden `IF` / `LBOUND` denetimi | `TRY`'a güvenmek (yalnız AST yakalar, G-HATA-2) | 12 |
| Olaya tepki | `EVENT` + `TRIGGER` | Birden çok `SLOT` bağlayıp hepsinin çalışmasını beklemek (G-GOREV-11) | 15 |
| Değeri dönüştürüp hemen almak | `PIPE` + `TRIGGER PIPE` + `TASKOUT` | `PIPE`'ı işlev gibi çağırmak (G-GOREV-1) | 15 |
| Arka plan işi, sonucu sonra almak | `THREAD` + `SPAWN` + `TASK OF tip` + `JOIN` | Sonucu `TASKOUT` ile taşımak (G-GOREV-3) | 15 |
| Birden çok görevin ortak sayacı | `ATOMIC` | Çok deyimli güncelleme için `ATOMIC`'e güvenmek (yalnız tek işlemliktir) | 15 |
| Ortak veride çok deyimli güncelleme | `LOCK a, b` | Kilidi tutarken `JOIN` ile beklemek (`LOCK_DEADLOCK`) | 15 |
| Metin dosyası | `OPEN` / `PRINT #` / `INPUT #` / `CLOSE` | İkili dosya komutları (G-DOSYA-2), sayıyı sayı değişkenine okumak (G-DOSYA-1) | 13 |
| Dış komut çalıştırmak | `SHELL` + `OUTVAR` + `CODEVAR` (çıkış kodunu denetleyin) | Kullanıcı metnini `SHELL`'e vermek | 13 |
| Bellek erişimi | `VIRTUAL` + açık genişlikli `PEEKB/W/D/Q` | `NATIVE`'i gerekmeden kullanmak, `@x` (G-ISLEC-2) | 14 |
| Kütüphane çağrısı | Sonucu önce değişkene alıp denetleyin | Her kütüphanenin hata bildirimini aynı sanmak | 20 |
| Derleme zamanında kod üretimi | Önişlemci `%%` yönergeleri | Çalışma anında yapılabilecek işi önişlemciye yüklemek | 17 |

## 23.4 Kararların dayandığı ilkeler

| İlke (Bölüm 1.2) | Karar biçimindeki karşılığı |
|---|---|
| İlke 1: Tek anlam, çok hedef | Önce AST'de, sonra MIR ve x64'te çalıştırıp çıktıları karşılaştırın; ayrışma derleyici kusurudur ama Ek G'ye bakın |
| İlke 2: Sessiz hata yok, sahte iş yok | Derleyicinin sessiz kabul ettiği yerleri (12.5) kendiniz denetleyin; açık retleri (`◌`) sorun değil eksik sayın |
| İlke 3: Her şey açık | Boyutu adında yazan tipler, açık dönüşümler (`I32(x)`, `STR(n)`), önce `DIM` |
| İlke 4: İç içe kullanılabilirlik | Bir yapı ötekiyle çalışmıyorsa "olmaz" demeyin, ◇ HEDEF / ✖ SINIR etiketini arayın (Bölüm 22) |
| İlke 5: Küçük çekirdek, güçlü genişletme | Yeni tip gerektiğinde derleyiciye dokunmadan kütüphane tipi yazın (Bölüm 19) |
| İlke 6: Kanıt önce | "Çalışıyor" demeden önce çalıştırın; reddetme testinin geçmesi yetmez |

## 23.5 Bölüm bölüm karar maddeleri

{{KARARLAR:OZET}}

{{KARARLAR}}

## 23.6 Bağlayıcı dil ve çalışma kararları (kronoloji)

Bu belgenin hazırlığı sırasında geçerli olan, Mete'nin verdiği kararlardan kılavuzu doğrudan etkileyenler (ayrıntı `ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md` ve `DURUM.md` içindedir):

| Tarih | Karar | Kılavuzdaki yeri |
|---|---|---|
| 2026-10-07 | Altı yol (AST, MIR, MIR-x64, AST-x64, JS, WAT/WASM) **aynı dil davranışını** sağlamalıdır; açık ret güvenli bir ara durumdur ama eşlik kapanışı sayılmaz; sessiz başarı ve sahte iş kabul edilmez | 1.2, 1.3 |
| 2026-10-11 | Motor sadeleştirme önerisi (T09) uygulanmaz, altı yol korunur; tasarım dışı çalışma, katmana göre değişen sessiz başarı yerine **ortak tanı kodu**, ileti anlamı, çıkış durumu ve yapılandırılmış çıktı sözleşmesiyle bildirilir (S-409, S-410). **Uygulama durumu** (`20261014_0253` ile ölçüldü): yaşam döngülü kütüphane tipi (`TEXT_REF`) ve değer tipi `RATIONAL` MIR dışındaki beş yolda `UXB_LIBTYPE_PROVIDER_UNAVAILABLE` ortak koduyla derleme aşamasında reddedilir (S-410, S-499; `20261013_1704`'te `RATIONAL` kapsam dışıydı ve AST-x64 ile WASM'da yanlış sonuç veriyordu, G-KTIP-7); çalışma anı sağlayıcı kodlarının kaydı kısmen yapılandırıldı (G-HATA-13); kütüphane tiplerinin MIR dışında çalışması ◇ HEDEF'tir (G-KTIP-1). Eski AST-x64 yolunun sözleşmeyi çiğneyen kusurları (sessiz yanlış sonuç, çökme) ayrıca Bölüm 1.3'te listelidir | 1.3, 12.4, Ek F |
| 2026-10-15 | **OOP çok güçlü olacak**: uXBasic nesne yönelimli paradigmayla doğduğu için çoklu kalıtım ve karışım (`MIXIN`) dahil zengin OOP istenir; 15 Eylül önerisindeki "çoklu durum kalıtımı yoktur" maddesi geçersizdir. Ayrıntılar (A/B/C seçenekleri) karar bekliyor (S-555) | 11.10, 11.12 |
| 2026-10-15 | **`SUB` ve `FUNCTION` önden `DECLARE` ile bildirilmelidir**: ileri kullanımda `DECLARE` kuralı; bugün denetlenmiyor. Sıkı kural mı, uyarı mı: karar bekliyor (S-544) | 8.5, 15.3 |
| 2026-10-15 | Kanal yerine değişken ya da `TYPE` tutamacı, Python tarzı veri sabitleri, `DATA`/`READ`/`RESTORE`, `NONE`/`NODE` tipleri istendi; hepsi ◇ HEDEF olarak kayıtlı (S-548 … S-554, S-564) | 4.4, 10.5, 13.2 |
| 2026-10-15 | **Tasarım belgeleri, tüm dokümantasyon ve yapay zekâ konuşma/hafıza kayıtları GitHub'da yayınlanır**; yalnız okumak ve başvurmak içindir, lisans vermez (`DESIGN-RIGHTS-RESERVED.md`). 14 Ekim önerisindeki "tasarım belgeleri özel kalsın" maddesi geçersizdir. **Uygulandı:** `metedinler/uXBasic` deposunda `yayin/20261015` dalı (main'e birleştirmeyi Mete GitHub'da yapar). Konuşma arşivlerinde gerçek görünümlü hizmet anahtarları çıktı; yayın kopyalarında silindi, **yerel orijinaller değişmedi ve anahtarların yenilenmesi önerildi** | Ek I |
| 2026-10-15 | Dosya envanterindeki "temizle" kararları uygulandı, `.zip`/`.rar` dosyalarına ve "sor" satırlarına dokunulmadı: yaklaşık 35,5 GB boşaldı (C: 3,0 → 38,4 GB). Kök neden `S-117` (her `bld --build-x64` çıktı klasörüne çalışma zamanı DLL'leri kopyalanır, kapatan seçenek yok) düzelmediği için yer yeniden dolar (G-ARAC-7) | 2.5, Ek I |
| 2026-10-14 | **Eski AST-x64 dondurulmaz**: tüm motorlar gibi aynı dil davranışını verecek şekilde çalışacaktır. S-157-L'deki "legacy dondurulup STRING kullanan programlar açık redle mi karşılansın, yoksa düzeltilsin mi" sorusunun cevabı: düzeltilecek. Bu yolun bilinen sessiz yanlış ve çökme kusurları (S-524 … S-538, S-157-L, S-086, S-091) düzeltme kuyruğundadır; kusurlar kapanana dek yeni program için MIR-x64 yolu önerilir | 1.3, Ek K |
| 2026-10-11 | Bulunan her kusur ve sınır `SORUN_TAKIP.md`'ye **ayrı kayıt** olarak yazılır; testi geçecek biçimde gevşetmek çözüm sayılmaz, kitaptaki geçici yol yalnız gösterimdir | Ek G, Ek J |
| 2026-10-12 | **Parantezsiz çağrı çalışmamalı, derleyici parantez istemelidir**: `Selam "Ayse"` gibi bir yazım sessizce yok sayılmaz, açık derleme hatası verir (S-440). **Uygulandı:** 2026-10-13, Codex; 20261013 ve sonrası derlemelerde `UXB_CALL_PAREN_REQUIRED` | 8.1, 23.3 |
| 2026-10-13 | Mete'nin görev talimatı: derleme kırığı giderilmiş olmalı; kılavuzu bitirmek için `docs` altındaki **plan ve tasarım belgeleri** (OOP planı, motor sorumlulukları, WASM metin mimarisi, FP yol haritası, kütüphane politikaları, S-440 … S-445 belgeleri …) taranır, kodda olmayan her şey ◇ HEDEF ve ayrı kayıt olarak girer | Ek I, Ek G |
| 2026-10-13 | Kılavuz çalışma kuralı (karar değil, yöntem): gerilemeli bir derlemeyle referans ikili **değiştirilmez**; yeni ikilinin farkı Ek K'da ölçümle yazılır, gerileme kaydı (S-480) açılır, düzelince yeniden ölçülür | Ek K |
