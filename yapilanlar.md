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

### f130059
- Mesaj: feat: bootstrap uXbasic with dynamic token buffer, real AST parser, and Win11 x64 roadmap
- Dosyalar:
	- .gitignore
	- .plan.md
	- README.md
	- UBASIC031_RAPOR.md
	- WORK_QUEUE.md
	- build.bat
	- build_32.bat
	- build_64.bat
	- build_matrix.bat
	- spec/LANGUAGE_CONTRACT.md
	- src/legacy/get_commands_port.fbs
	- src/main.bas
	- src/parser/ast.fbs
	- src/parser/lexer.fbs
	- src/parser/parser.fbs
	- src/parser/token_kinds.fbs
	- tests/manifest.csv
	- tests/run_manifest.bas
	- yapilanlar.md
