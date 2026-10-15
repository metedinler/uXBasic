---
name: anlatim-iddialari-da-sinanir
description: "Kılavuz yazarken tablolardaki/anlatımdaki iddialar (örnek kod olmayanlar) da dört motorda çalıştırılarak sınanır; hatırdan/V1'den kopyalanan cümleye güvenme"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-11T23:29:36.252Z
---

Kılavuzda doğrulanmış örnek bloklarının DIŞINDA kalan her cümle/tablo satırı (söz dizimi biçimi, "yoktur/vardır", "aynı iş", hata iletisi metni, hangi motorda çalışır) ayrıca çalıştırılarak sınanır.

**Why:** 2026-10-12'de "Parantezsiz çağrı `Selam "Ayse"` çalışır" ve "`S x` ile `CALL S(x)` aynı iş" cümlelerimin YANLIŞ olduğu çıktı (dört motorda da sessiz no-op); aynı turda `CONST`'ın yazılabilir olduğu, `UNION` üst üste bindirmenin yalnız AST'de çalıştığı, "dosya yoksa OPEN hata verir"in x64'te yanlış olduğu, bilinmeyen CALL(DLL) tip simgesinin x64'te çöp ürettiği ortaya çıktı. Örnek kodu geçse bile anlatım cümlesi yanlış kalabiliyor. Mete: sessiz hata/sahte iş olmasın, kitap gerçeği yazsın.

**How to apply:** İddiayı JSON'a yaz ({ifade veya kod, beklenen, yoksay:[motor]}) ve scratchpad `iddia_denetle.py` ile AST/MIR/x64/JS'te koştur (`"beklenen": "HATA"` = herhangi bir ret/hata). Fark çıkarsa: önce `sinirlar.txt`'ye G-kaydı + `sorun_takibe_isle.py`, sonra şablondaki cümleyi düzelt. Hata beklenen programın GERÇEKTEN hata verdiğini de sına (sessiz hataların çoğu "reddedilmesi gereken programın çalışması"). Test dosyasında önce kendi sözdizimini örneklerden kopyala (yoksa kendi hatanı bulgu sanırsın: `t.JOIN` yerine `t.JOIN()`, `PUBLIC` ayrı satır).
Bkz. [[uxb-kilavuz-v2-20261008]], [[her-kusur-sorun-takibe]].
