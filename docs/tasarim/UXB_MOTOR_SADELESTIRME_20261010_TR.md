# uXBasic durum ve motor sadeleştirme değerlendirmesi

Tarih: 2026-10-10, Codex. Mimari bölümü öneridir; motor kaldırma veya kullanıcı
komutlarının davranışını değiştirme kararı alınmış değildir. Mete'nin son
mesajındaki durum ve mimari tartışması isteğine yanıt olarak hazırlanmıştır.

## Doğrulanmış çalışma durumu

Ana compiler `bin/uxb.exe` SHA256:
`6A0B179711F79FFFF8A2E2C4EB549AD7318DE94FE3EF890B1982397D219C2C2B`.
10 Ekim kontrolünde bu hash değişmemiştir. Önceki kabul
`reports/remediation_20261007_remaining/final_verification.json` içindedir:
25 paket kapsamındaki 1377/1377 kontrol, geniş U koşusu ile etkilenen V paket
tekrarlarının birleşimidir. Tek adayın bütün paketleri tek seferde geçtiği
iddia edilmez. Ret kontrolleri çalışan özellik desteği değildir.
SDL/raylib 44/44 dört motor; kitap 122/122 beklentili örneğin değer kanıtı
(ilk taskgroup 60 s timeout, aynı kaynak 180 s tekrarında geçti), 32 beklentisiz.
Bunlar tüm dilin altı motorda tamamlandığını göstermez.

Son ayrı web adayı `bin/uxb_codex_web_w_20261007.exe`, 8 Ekim derlemesi,
SHA256 `9EC93354C1FBFBAFA077942A06C9E1EC3263B8C666D9CEF0138056679CCA7940`.
JS/WASM etiket ve GOSUB kontrol akışını ortak bir hazırlama üzerinden üretir;
bare RETURN kaydı ayrı taşınır. JS çağrı başına dönüş listesi, WASM ise
VIRTUAL ve sequence scratch dışında bir kez ayrılan, yeniden kullanılan
64 KiB dönüş yığını kullanır. Aday ana yayına aktarılmamıştır.

Kanıt: `reports/remediation_20261007_web/control_w/results.json`, 3 program,
6 motor, **13/18**. JS ve WASM'de üç programın tamamı gerçek Node/WASM
çalıştırmasıyla geçti: sıralı çağrı, döngüde devam noktası, iç içe GOSUB/GOTO.
Kalan beş hücre:

| Program | Motor | Gözlenen sorun |
|---|---|---|
| loop_continuation | AST | 30 yerine 1, çıkış 0: yanlış sonuç |
| loop_continuation | AST-x64 | END_STMT açık reddi |
| nested_goto | MIR-x64 | Gerçek exe çalıştırması erişim ihlali 3221225477 (0xC0000005) |
| nested_goto | AST-x64 | END_STMT açık reddi |
| sequential | AST-x64 | END_STMT açık reddi |

Bu kabul GOSUB'un bütün bağlamlarını, taşma/istisna/iptal sözleşmesini veya
bütün web dil yüzeyini kapatmaz. İlk baseline koşusunda yeni testlerin iki
elle hesaplanmış beklentisi ve FOR bildirimi hatalıydı; native çıktı konumunu
koşucu da yanlış varsayıyordu. Bunlar düzeltildi. O ilk rapor parite kanıtı
olarak kullanılmaz ve korunur. Yukarıdaki 13/18 güncel oracle ve gerçek exe
çalıştırma konumuyla alınmıştır. Windows uyarısının nedeni bu tek erişim
ihlaliyle eşleştirilmiş sayılmaz; S-194 ayrı açık kalır.

## Harita ve kaynak kanıtı

GitNexus MCP `uxb` kaydı 1139 aktif dosya, 12111 düğüm, 30827 ilişki gösterir.
`tools/maintenance/uxb_gitnexus_index.mjs` mevcut GitNexus 1.4.5 motorunu kullanır;
başka AI çalıştırmaz, Claude talimat/hook dosyalarını değiştirmez. Kurulu
sürüm FreeBASIC'i doğrudan ayrıştırmadığından, canlı kaynaktan çıkarılan
FreeBASIC rutinleri ve sözcüksel çağrı adayları eklenmiştir. Aşırı yükleme,
makro, BYREF dolaylı yazma ve dinamik dispatch tam çözülmez. Harita bir
derleyici doğruluk kanıtı değildir; konumlar kaynakta doğrulanır.

`tekdosyaklsoru/kod_analiz/OZET.md`, rutin ve çağrı verileri de kullanılmıştır.
Modelin yazdığı amaç açıklamaları doğrulanmış semantik kabul edilmez.
10 Ekim kontrolünde beş kritik dosyanın harita hash'i canlı kaynakla eşleşti:
JS emitter, WASM emitter, mir_tail, mir_model, main_program_entry_part2.
Bu, tüm haritanın güncel olduğu iddiası değildir.

Kaynakta doğrulanan mimari:

- `src/semantic/mir_tail.fbs`, `MIRBuildModuleFromAST`: AST'den MIRModule
  oluşturur, tipleri işler, sync/exception geçişleri ve CFG doğrulaması yapar.
- `src/main_program_entry_part2.fbs`: AST yürütücüsünü ve canonical MIR
  yürütücüsünü ayrı çağırır; AST-x64 ayrı `GenerateX64Code` yoludur.
- `src/semantic/semantic_to_canonical_mir_bridge.fbs`:
  MIRModule → UXBMIRInstructionRecord dönüşümü. Native/JS/WASM üreticileri
  MIRModule kullanırken MIR yorumlayıcısının girişinde ayrıca bu temsil vardır.
- `src/semantic/mir_lower_stmt.fbs` ve `mir_lower_stmt_core_split.fbs`:
  üst seviye ve rutin gövdesinde aynı deyimler için tekrar eden indirgeme kodu
  vardır; son bare RETURN değişikliği bile iki yerde uygulanmıştır.
- `src/semantic/mir_evaluator*.fbs` içindeki `MIRRunModule` için doğrudan
  test tüketicileri vardır. CLI motoruyla aynı olduğu varsayılamaz.

## Önerilen sadeleştirme

AST ön uç olarak korunmalıdır: kaynak ağacı, kapsamlar, tür bağlama, sınıf
ve rutin yapısı, tanı konumları, REM %%ATTR ve AST JSON görünümü burada kalır.
AST'yi tamamen kaldırmak mevcut AST→MIR hattını yeniden yazmayı gerektirir.
AST ağacının bulunması, ayrıca bağımsız bir AST yürütücüsü veya AST-x64
üreticisi bulundurmayı zorunlu kılmaz.

| Bileşen | Önerilen rol |
|---|---|
| Parser + türlenmiş AST | Kalıcı ön uç ve meta bilgi kaynağı |
| AST→MIR | Üst seviye/rutin gövdesi için ortak tek indirgeme sözleşmesi |
| MIR veri modeli | Bütün yürütücü/üreticilerin aynı tip, kontrol akışı, sahiplik ve kaynak bilgisini tükettiği yetkili temsil |
| MIR yorumlayıcısı | Önce eksikleri kapanan, sonra varsayılan çalıştırma yolu |
| MIR-x64, JS, WAT/WASM | Ortak MIR'i kendi ABI/host hedeflerine çeviren üreticiler |
| AST yorumlayıcısı | Geçiş sırasında bağımsız karşılaştırma; daha sonra isteğe bağlı geliştirme/reference rolü |
| AST-x64 | Öncelikli emeklilik adayı; kullanım/özellik/test tüketicileri taşındıktan sonra ürün yolundan çıkarma |
| Ek MIR evaluator / AST API | Tüketici envanteriyle ortak yürütücüye adaptör; ayrı dil semantiği geliştirilmeyecek |

Hedef akış:
`kaynak → birleşik %% → parser/türlenmiş AST + REM %%ATTR → ortak MIR + REM %%MIR → MIR yorumlayıcısı / MIR-x64 / JS / WAT-WASM`.
Hedefe özgü ABI veya host indirgemeleri bu ortak sözleşmenin altında kalır.
Canlı JSON, meta bilgi ve compiler/interpreter öz farkındalığı korunur;
rapor her zaman gerçekte kullanılan motoru bildirir. AST komutunu gizlice
MIR'e yönlendirip bağımsız iki motor doğrulaması yapıldı denmez.

## Geçiş sınırı ve kabul

1. Sabit, önceden hesaplanmış oracle'larla açık farklar yeniden üretilir;
   crash ve yanlış sonuç önceliklidir. Aynı ortak hatayı taşıyan iki hedefin
   birbirine eşit olması tek başına doğru davranış sayılmaz.
2. MIR'in iki temsili için kayıpsız ortak model ve üst seviye/rutin indirgeme
   birleştirilir. Tip genişliği, işaretlilik, BYREF, kontrol akışı, exception,
   iterator kapanışı ve lifecycle bilgisi hedefe ulaşmadan kaybolmamalıdır.
3. MIR yorumlayıcısındaki işlev kapsamı, tanılar, canlı JSON ve kullanıcı
   komutları kabul edilir; varsayılan yürütme geçişi bundan sonra yapılır.
4. AST-x64 tüketicileri ve benzersiz davranışları taşınır. Emeklilik kararı
   verilirse rollback imkânıyla CLI/sürüm desteğinden çıkılır; dosya silinmez.
   AST reference yolu geçiş boyunca ortak oracle'lara ek doğrulama sağlar.

Bu yaklaşım aynı dil kuralını tekrar tekrar düzeltme yükünü azaltmayı amaçlar.
MIR, x64 ABI, web sayısal temsil, provider ve host yeteneklerindeki açıkları
kendiliğinden çözmez. Kesin token/zaman azalması yüzdesi ölçülmüş değildir.
Tam compiler kapanışı halen açık; bu belge yeni emeklilik kararı değildir.
