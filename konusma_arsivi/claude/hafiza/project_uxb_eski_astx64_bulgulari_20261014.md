---
name: uxb-eski-astx64-bulgulari-20261014
description: "Eski AST-x64 yolunda 2026-10-14'te bulunan kusurların kataloğa ve SORUN_TAKIP'a işlenmiş hâli (S-524…S-542), ölçüm yöntemi ve açık kalan iki örnek"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-14T14:21:24.133Z
---

2026-10-14: eski AST-x64 (`bld --build-x64 --x64-mode AST`) 0253 ve 20261007 ikilileriyle ölçüldü; **bulgular işlendi** (katalog `veri/sinirlar.txt`, `SORUN_TAKIP.md` S-524…S-542, kitap Bölüm 1.3 + 7.6 + 21 + Ek K, `ai_koordinasyon\DURUM.md` 15:50 girişi). Ham ilk kayıt: `uxb/ai_koordinasyon/CLAUDE_ESKI_ASTX64_BULGULAR_20261014.md` (en küçük programlarıyla).

**Why:** Mete'nin kuralı (2026-10-11): bulunan her yanlış ayrı SORUN_TAKIP kaydı olur; testi gevşetmek çözüm değil. Eski AST-x64 kusurlarının hepsi 20261007'de de aynıdır (gerileme değil). Karar (2026-10-11): eski yol korunur, sözleşmesi "MIR-x64 ile aynı sonuç; destek yoksa derleme zamanı yetenek hatası"; sessiz yanlış/çökme sözleşmeyi çiğner. **Karar (2026-10-14, Mete): eski AST-x64 dondurulmaz, tüm motorlar gibi çalışacak; açık ret ara durumdur, bkz [[feedback_eski_astx64_dondurulmaz_20261014]].** Sonradan açılan S-543 (MIR derin özyineleme sessiz erişim ihlali) ve S-535/539/540 (AST gerilemeleri) için bkz [[project_uxb_kilavuz_v2_20261008]].

**How to apply:** Eski AST-x64 sütununa güvenme; yeni program için MIR-x64 (`bld --build-x64`). Kusurlar kapanınca `iddia_eski_astx64` (14 vaka) ve `gerileme_sondalari.py` yeşile döner. ÇÖZÜLDÜ (aynı gün): `csv_model_egitimi` ve `dosya_butunluk_sikistirma` eski AST-x64'te düşüyordu çünkü metin işlemi sonuçları 32 yuvalık halkada tutulur ve birleştirmeyle atanan STRING değişkeni 32 işlemden sonra başka metne dönüşür (STR ise tek yuva); S-157-L/S-528 kapsamı bu kadar geniş. 20 örneğin hepsinin nedeni bilinir. Yama yöntemi (kök neden kanıtı): örnek kopyasında `DIM s AS STRING = "" + STR(n)` ve `x = 0 - x` yazıp eski AST-x64'te koştur (`scratchpad\yama_dene.py` fikri; kopyayı depoya yazma). Çalışma kuralı: yeni G numarası vermeden önce `sinirlar.txt`'te aile başına en büyük N'i denetle. İlgili: [[project_uxb_kilavuz_v2_20261008]], [[feedback_her_kusur_sorun_takibe]].
