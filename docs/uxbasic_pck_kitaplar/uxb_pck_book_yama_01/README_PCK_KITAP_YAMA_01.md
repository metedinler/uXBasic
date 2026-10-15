# uXBasic PCK Kitap Yaması 01

Bu yama derleyici kaynaklarına dokunmaz. Yalnızca resmî teknik kitap üretim hattını ekler.

## İçerik

- `docs_src/`: kitap parçaları ve 20 adımlık yazım planı
- `docs_src/cheat_sheets/`: keyword, statement dispatch, runtime service ve CLI hızlı başvuru ekleri
- `tools/docs/build_uxbasic_pck_book.py`: parçaları tek Markdown kitaba birleştirir
- `tools/docs/extract_uxbasic_book_sources.py`: kaynak yüzeyinden kitap için JSON çıkarır
- `docs_build/uxbasic_resmi_teknik_kitap_12_06_1.md`: üretilmiş ilk tek kitap dosyası

## Uygulama

uXBasic kök klasöründe:

```powershell
Expand-Archive .\uxb_pck_book_yama_01.zip -DestinationPath .\_pck_book_yama_01 -Force
.\_pck_book_yama_01\uxb_pck_book_yama_01\UYGULA_PCK_KITAP_YAMA_01.ps1 -Root .
```

## Kitabı yeniden üretme

```powershell
python tools\docs\build_uxbasic_pck_book.py --root . --out docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md
```

## Kaynak yüzeyi çıkarma

```powershell
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json
```
