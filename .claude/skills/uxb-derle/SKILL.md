---
name: uxb-derle
description: uXBasic derleyicisini (FreeBASIC kaynaklarından) yeni bir sürüm adıyla bin\uxb_<ad>.exe olarak derler. src/ altında .fbs değiştirdikten sonra değişikliği denemek için, "derleyiciyi derle", "yeni exe üret", "f2g derle" gibi isteklerde KULLAN.
---

# uXBasic derleyicisini derle

```
.\tools\claude\uxb_build.ps1 -Name claude1_<sürüm>
```
- `<sürüm>`: bir öncekinin bir sonrakisi (ör. `f2f` → `f2g`). Hangi adların kullanıldığını `Get-ChildItem bin\uxb_claude1_*.exe`
  ile gör. Bir test/regresyon çalışırken KULLANDIĞI exe'yi yeniden derleme; yeni ad ver.
- Süre 3–5 dk. Çıktı `rc=0` ise başarılı; değilse ilk 15 hata satırı basılır (dosya(satır) error N: ...).
- Betik şunları reddeder: ana derleyici adları (`uxb`, `uxb_x64`...; onlar Codex'in), çalışmakta olan exe, aynı hedefe süren
  başka bir fbc64 derlemesi.
- `native/uxb_runtime/*.cpp` değiştiyse ayrıca: `.\native\uxb_runtime\build_runtime_dll.ps1` (bin\uxb_runtime.dll; önce eskisini
  `%TEMP%`'e yedekle).

Sık FreeBASIC derleme hataları:
- "Variable not declared, X" — X aynı dosyada daha aşağıda tanımlı: kullanımdan önce `Declare` ekle.
- IIf UDT döndüremez → `If` kullan; `Or`/`And` kısa devre yapmaz → `OrElse`/`AndAlso`.
- `base` ayrılmış sözcük; `Variant` yok.
