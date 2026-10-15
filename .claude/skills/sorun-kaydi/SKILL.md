---
name: sorun-kaydi
description: ai_koordinasyon/SORUN_TAKIP.md'ye standart biçimde yeni bir S-xxx kaydı ekler ya da mevcut kaydın durumunu günceller. Yeni bir hata bulunduğunda, bir hata kapandığında, karar beklenen bir soru çıktığında KULLAN.
---

# SORUN_TAKIP kaydı

1. Sıradaki numara: `Select-String -Path ai_koordinasyon\SORUN_TAKIP.md -Pattern '^## S-\d+'` → en büyük numara + 1
   (başka ajanlar da yazar; eklemeden hemen önce tekrar bak).
2. Yeni kaydı dosyanın sonundaki Codex/ek bölümlerinden ÖNCE, son S-xxx kaydının arkasına Edit ile ekle. Biçim:
   ```
   ## S-NNN — <tek satır: belirti, hangi motor(lar)>
   **Bulundu:** <YYYY-AA-GG> (<ajan>, <hangi iş sırasında>) · **Durum:** `ACIK|YAPILDI|KISMEN|KARAR-BEKLIYOR` · <önceden var mı: hangi eski exe'de denendi>
   <En küçük yeniden üretim programı ve her motorun çıktısı: AST `...`, MIR `...`, native `...`; doğrusu hangisi ve neden.>
   **Kök neden:** <dosya/fonksiyon düzeyinde>.
   **Düzeltme:** <ne değişti, hangi dosyalar>. Testler: `tests/<paket>/<ad>` (<n/n>).
   ```
3. Durum güncellemesi: yalnız `**Durum:**` alanını ve (varsa) `**Düzeltme:**` satırını değiştir; eski metni silme.
4. Legacy AST-x64'e özgü açık ret: kayıt numarasına `-L` eki (ör. `S-167-L`) ve tanı metninde aynı etiket.
5. Karar gerektiren (dil anlamı değişiyor) konularda seçenekleri + önerini yaz, `KARAR-BEKLIYOR` yap ve Mete'ye sade Türkçe sor.
