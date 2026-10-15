# uXBasic PCK Kitap Yaması 03

Bu yama, uXBasic resmî teknik kitabını son genişletme dalgasıyla büyütür. Derleyici kaynaklarına dokunmaz. `docs_src`, `docs_examples` ve `tools/docs` altına belge, örnek ve yardımcı komut dosyaları ekler.

Eklenen ana bölümler:

- Derleyici katmanlarından sonuç üreten terminal rehberi
- On ayrı proje programı
- Nihai komut/fonksiyon/operatör/veri tipi/veri yapısı referansı
- Preprocessor A/B ve hedefli derleme bölümü
- Backend ve artefact üretim rehberi
- Test disiplini ve belge kalite kapısı
- Nihai hızlı başvuru cheat sheet

Uygulama:

```powershell
Expand-Archive .\uxb_pck_book_yama_03.zip -DestinationPath .\_pck_book_yama_03 -Force
.\_pck_book_yama_03\uxb_pck_book_yama_03\UYGULA_PCK_KITAP_YAMA_03.ps1 -Root .
```

Kitabı yeniden üretmek:

```powershell
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --md-out docs_build\generated
python tools\docs\build_uxbasic_pck_book.py --root . --include-generated
```

Katman çıktıları üretmek:

```powershell
.\tools\docs\run_book_layer_outputs.ps1 -Root .
```

Kitap proje örneklerini çalıştırmak:

```powershell
.\tools\docs\run_book_project_examples.ps1 -Root . -Backend AST
.\tools\docs\run_book_project_examples.ps1 -Root . -Backend MIR
```
