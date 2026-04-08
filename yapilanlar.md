# Yapilanlar

## 2026-04-08

### Cok Ajanli Calisma Notlari
- Explore ajanindan gercek AST MVP tasarim ciktilari alindi.
- Explore ajanindan Windows 11 x64 assembler/refaktor fazlama ciktilari alindi.
- Bu ciktilar `.plan.md` ve `WORK_QUEUE.md` dosyalarina append-only yaklasimla yerlestirildi.

### Kod Tarafi
- Dinamik token kapasite yonetimi eklendi.
- Gercek AST node havuzu (`ASTPool`) eklendi.
- Parser, expression precedence ve statement tabanli AST uretir hale getirildi.
- Ana giris, AST dump verisi basacak sekilde guncellendi.

### Plan ve Kuyruk Guncellemeleri
- `.plan.md` icine EK-8 (Gercek AST + Dinamik Token) eklendi.
- `.plan.md` icine EK-9 (Windows 11 x64 assembler/refaktor onceligi) eklendi.
- `WORK_QUEUE.md` durumlari guncellendi; yeni sira 6-8 maddeleri acildi.

### Derleme ve Test
- `build.bat src\\main.bas` dogrulandi.
- `build.bat tests\\run_manifest.bas` dogrulandi.
- `tests\\run_manifest.exe` ile smoke test gecisi alindi.

## Commit Kaydi
- Bu bolum commit atildikca hash + dosya listesi ile guncellenecek.
