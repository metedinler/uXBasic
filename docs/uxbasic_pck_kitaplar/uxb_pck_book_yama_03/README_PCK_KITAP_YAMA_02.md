# uXBasic PCK Kitap Yaması 02

Bu yama, 01 numaralı kitap yamasını genişletir. Derleyici kaynak kodunu değiştirmez; yalnızca `docs_src`, `docs_build` ve `tools/docs` altındaki belge üretim hattını günceller.

## Uygulama

```powershell
Expand-Archive .\uxb_pck_book_yama_02.zip -DestinationPath .\_pck_book_yama_02 -Force
.\_pck_book_yama_02\uxb_pck_book_yama_02\UYGULA_PCK_KITAP_YAMA_02.ps1 -Root .
```

## Üretilenler

- `docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md`
- `docs_build\book_source_surface.json`
- `docs_build\generated\keyword_surface.md`
- `docs_build\generated\statement_dispatch_surface.md`
- `docs_build\generated\runtime_service_surface.md`
- `docs_build\generated\cli_option_surface.md`
- `docs_build\generated\project_pack_examples.md`

## Ana ekler

- Komut referansı yazım sistemi genişletildi.
- `PRINT`, `DIM`, `CONST`, `INPUT`, `CLS`, `COLOR`, `LOCATE`, `INKEY`, `GETKEY` için kitap dili kuruldu.
- Operatör bölümü precedence, bağlayıcılık ve Logic16 yüzeyiyle büyütüldü.
- Preprocessor bölümü `%%SET`, `%%IF`, `%%FOREACH`, `%%TARGET`, HTML/JS/WAT/ASSET/MANIFEST aileleriyle genişletildi.
- Project pack örnek havuzu otomatik üretilir hale getirildi.
