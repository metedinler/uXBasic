---
name: uxb-3motor
description: Bir uXBasic programını AST yorumlayıcı, MIR yorumlayıcı ve native x64 (isteğe bağlı legacy AST-x64) motorlarında çalıştırıp çıktıları yan yana karşılaştırır. Motorlar arası fark/hata ararken, bir düzeltmeyi doğrularken, "üç motorda dene", "önceden de var mıydı" sorularında KULLAN.
---

# Üç motorda çalıştır ve karşılaştır

```
.\tools\claude\uxb_run3.ps1 -File build\claude1_deneme.bas -Uxb .\bin\uxb_claude1_<sürüm>.exe [-Legacy] [-NativeRepeat 5] [-Workers 2]
```
Çıktı: `AST : ...`, `MIR : ...`, `x64 : ... [rc=0]` (satırlar ` | ` ile birleşik). Üçü aynı değilse bu bir hatadır.

Kullanım kalıpları:
- **Deneme programı:** `build\claude1_<konu>.bas` olarak yaz (Write aracı); kalıcı teste dönüşecekse `tests\<paket>\` altına taşı.
- **"Bizden mi, önceden mi?":** aynı dosyayı eski bir exe ile de koş (`bin\uxb_claude1_f2b.exe`, `bin\uxb_s134.exe`, `bin\uxb.exe`).
  Eskide de aynı hata varsa önceden vardır → SORUN_TAKIP'e ayrı S-xxx olarak kaydet.
- **Görev/eşzamanlılık:** `-NativeRepeat 5` (+ `-Workers 1|2|8`) native'de tekrarlı koşar; farklı sonuçlar `xN` sayılarıyla gruplanır.
- stdin bekleyen (INPUT) programı çalıştırma — takılır.
- Sonsuz PRINT döngüsü diski doldurabilir: deneme programlarını kısa tut.
