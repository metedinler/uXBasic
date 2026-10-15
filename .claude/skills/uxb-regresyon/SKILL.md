---
name: uxb-regresyon
description: uXBasic model test paketlerinin tamamını ya da seçilenlerini koşar, düşen kontrolleri listeler ve düşüşün bu değişiklikten mi yoksa önceden mi geldiğini ayırır. Bir düzeltme bitince, "regresyon koş", "testleri çalıştır", "hangi paketler düşüyor" isteklerinde KULLAN.
---

# Regresyon

1. Koşu (tam koşu ≈1 saat → `run_in_background: true`, timeout 600000):
   ```
   .\tools\claude\uxb_regression.ps1 -Uxb .\bin\uxb_claude1_<sürüm>.exe [-Only task_sync,routine_scope]
   ```
   Paket adları: `tests\run_all_model_tests.ps1` içindeki `$suites` listesi. Rapor ve günlük `build\claude_reports\` altına yazılır.
2. Düşen her kontrol için sınıflandır:
   - **Beklenen boş / koşucu biçimi:** `.contains.txt` `ALL=` mı, `MOTOR=` mı; koşucu onu okuyor mu.
   - **Önceden var:** `uxb-3motor` ile aynı test dosyasını eski exe ile koş; aynı hata → bu değişiklikten değil.
   - **Ortam:** DLL eski mi (`GetProcAddress failed` → `runtime_ext` kaynağı DLL'den yeni mi), disk dolu mu.
   - **Gerçek regresyon:** yalnız yeni exe'de düşüyor → düzelt, sonra yalnız o paketi `-Only` ile yeniden koş.
3. Sonucu `ai_koordinasyon/SORUN_TAKIP.md`'ye yaz (bkz. `sorun-kaydi` skill'i): toplam/geçen, düşenlerin sınıfı ve yapılan.

Not: koşu sırasında aynı exe'yi yeniden derleme. Test klasörüne yeni test eklemeden önce paketin `expected\_engines.txt`'ine bak.
