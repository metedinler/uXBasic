---
name: her-kusur-sorun-takibe
description: "Mete'nin 2026-10-11 kuralı: bulunan HER kusur/sınır SORUN_TAKIP.md'ye ayrı S-kaydı olarak yazılır; testi geçecek biçimde gevşetmek çözüm değildir; kitaptaki geçici yol yalnız gösterim"
metadata:
  node_type: memory
  type: feedback
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-11T00:32:40.732Z
---

Bulduğum her yanlış (sessiz hata, motorlar arası fark, açık ret, eksik özellik, yavaşlık) ve kitap/örnek yazarken çıkan her sınırlama **hemen ve ayrı ayrı** `ai_koordinasyon/SORUN_TAKIP.md`'ye S-numaralı kayıt olarak yazılır ("daima"). Sonradan sırayla düzeltilecekler.

**Why:** Mete'ye göre "hedeflenen sistem" belgesi, tasarım belgelerinde olup uXBasic kodunda olmayan her şeyi içermeli; kusurlar kitapta kaybolursa düzeltme planı kaybolur. Testi sorunu geçecek biçimde değiştirmek sorunu çözmez.

**How to apply:**
- Yeni kusur → önce `tools/kitap/kilavuz_v2/veri/sinirlar.txt`'ye G-kaydı ekle, sonra `python tools/kitap/kilavuz_v2/sorun_takibe_isle.py` çalıştır (yalnız eşlemesi olmayanları S-numarasıyla SORUN_TAKIP'a yazar; eşleme `veri/sorun_eslemesi.txt`, sıra dizini `ai_koordinasyon/KILAVUZ_V2_SORUN_DIZINI.md`). Tek tek derin inceleme yapılan kusur için `sorun-kaydi` skill'iyle elle yaz (kök neden, düzeltme önerisi) ve eşleme dosyasına `G-xxx = S-nnn` ekle.
- Kitapta geçici çözüm göstermek için örnekte değişiklik yapmak serbest; ama gerçek (olması gereken) test, komutun görevi ve planlanan hedef kayıtta/kitapta yazılı olmalı. Hiçbir testi/beklentiyi geçsin diye gevşetme.
- Tasarım belgelerinde olup kodda olmayan her şey kılavuzda ◇ HEDEF olarak yer almalı.
- 2026-10-11: sinirlar.txt'nin 169 kaydı S-205…S-373 (özet kayıt S-204) olarak işlendi; S-203 = G-DIL-10 (x64 ASSERT + çağrıdan sonra DIM dizi).
Bkz. [[uxb-kilavuz-v2-20261008]].
