---
name: uxb-tekdosya-kopru-egitim-20261007
description: "2026-10-07 durumu — tek tek-dosya klasörü, orkestratör paketleyici31 (-F egitim verisi), Opera köprüsü 0.2 + kopru_* sağlayıcıları, CPU LoRA eğitimi, güvenlik analizi gürültü düzeltmesi"
metadata:
  node_type: memory
  type: project
  originSessionId: b85b832d-c86f-49e6-b0a0-47af736f8686
  modified: 2026-10-07T17:30:35.691Z
---

**Güncelleme 2026-10-07 akşam:** docs\tasarim (22 dosya) okundu; kural belgesi artık FOR EACH≠DO EACH, tek `%%` + `REM %%ATTR/MIR`, Model D (SLOT≠TASK, otomatik senkron, LOCK), kütüphane tipi, PTR bayt aritmetiği bölümlerini [KARARLI]/[HEDEF] etiketiyle içeriyor. `MAGIC … END MAGIC` (END METHOD değil). Mete: şimdi hata düzeltme değil eğitim verisi doğru hazırlanacak; "karar gerekli" dediğim yalnız dış-AI politikasıydı. Yeni derleyicide CONTINUE/STATIC/MID=/ENUM tipi çalışıyor. 154 örnek: 119/122 geçti (kalan: call_api x64, magic_tostring, operator_magic_add = S-198).

Tek tek-dosya klasörü: `uxb\tekdosyaklsoru` (eskiler `UXBc\claude_arsiv\eski_belgeler`). Orkestratör: `UxbRAG\...\tools\Moduller\paketleyici31.py` (tek harfli anahtarlar; `-s` KB = 8192 Mete'nin kararı, `UXB_TEKDOSYA_KB=8192` api_anahtarlari.env'de; `-F` eğitim verisi; `-K` kod analizi).
API anahtar dosyası: `C:\Users\mete\.uxb\api_anahtarlari.env` (yedekler `.yedek_20261006/07`). Zincir: gemini,gemini2,omniroute,groq,kimi,chatgpt,claude,kopru_gemini,kopru_chatgpt,kopru_claude.

**Why:** Mete tüm sistemde tek klasör + tam otomatik (insan müdahalesiz) çalışma, API kotası bitince tarayıcı köprüsüne geçiş istiyor.
**How to apply:** köprü kodu `mete_prompt_bridge_mvp` (host.cmd python yolu düzeltildi — eski .venv yoktu, host hiç çalışmamıştı; 0.2 eklenti dosyaları diskte, Opera'da bir kez "yeniden yükle" gerekir: eklenti repo klasöründen yüklü, kimlik oakpbbmkcjbkelklpmfphgaincaifkpc). İstemci: `uxb_harita_doldur.py` içindeki `kopru_*` sağlayıcıları. Sağlık: `openclaw_uxb\uxb_ajan.py kopru`.
Eğitim: `tools\uxb_egitim.py` + venv `%USERPROFILE%\.uxb\egitim_venv`; CPU'da ~35 sn/örnek (0.5B); gerçek koşu `egitim_cikti\qwen05_uxb_v1` (resumable). Veri `tekdosyaklsoru\egitim`.
Bkz. [[uxb-kod-analiz-ve-rag-20261006]] (önceki durum).

**Güncelleme (07:00-08:00):** köprü 3 sağlayıcıda canlı (eklenti 0.2.5, otomatik yenileme; Claude için Opera "Tüm sitelerde"). Zincir: köprü -> ücretli API -> omniroute/groq. Panel+güvenli alan (`kum-kur`/`kum-dene`)+gerçek alan akışı S-083'te OpenClaw tarafından uçtan uca çalıştı; S-132 yarım kalan yama doğrulandı. Eğitim: CPU'da vazgeçildi, bulut GPU paketi `tekdosyaklsoru\egitim\bulut`. Tuzaklar: Start-Process uzun/çok satırlı argümanı böler (görev metni dosyadan: uxb_oturum -MesajDosyasi); ajan çıktı yok diye süreci öldürüyordu (artık canlı akış + AGENTS.md uyarısı).

**Güncelleme (öğleden sonra):** (1) Codex 09:14'te `uxb\ai_koordinasyon\AI_CALISMA_POLITIKASI.json` (external_ai_allowed=false) koydu; OpenClaw/köprü oturum betikleri (`uxb_oturum.ps1`, `uxb_harita_sonrasi.ps1`) buna uyar. Mete "yalnız S-196 için bir kerelik izin" dedi; politika DEĞİŞTİRİLMEDİ — başka dış AI işi için tekrar sor. (2) Eğitim belgeleri: `docs\kitaplar\UXBASIC_PROGRAMLAMA_KURALLARI.md` (üretici `tools\kitap\kural_belgesi_uret.py`, örnek grubu `docs\kitaplar\_ortak\ornekler\22_kurallar`, doğrulama `tools\kitap\ornek_dogrula.py --uxb bin\uxb_openclaw_S083.exe`); anahtar sözcük/kütüphane kartları `paketleyici31.py -F` (`RAGVeriHazirlayici.dil_kartlari_ekle`). Kılavuz (docs\tasarim) HEDEF tasarımdır, gerçekle çelişir (CALL(DLL) tam imza, DIM SHARED yok, MAGIC ... END MAGIC, OPERATOR yok). (3) Köprü: cevap protokolü artık bölüm işaretli düz metin (`###ALAN:ad`), JSON değil (`bolumlu_cevabi_coz`). (4) S-196 (yüzey kaydı eksikleri) gerçek alanda uygulandı (transaction 20261007_161526_462728), 16 paket doğrulaması sürüyordu (taban 825/825); sonuç `OPENCLAW_YAMA_GUNLUGU.md` + `openclaw_uxb\calisma\S-196_gercek_uygula.log`. (5) S-198: CALL(API) x64, STR(nesne) MAGIC TOSTRING, MAGIC ADD tip hatası.
