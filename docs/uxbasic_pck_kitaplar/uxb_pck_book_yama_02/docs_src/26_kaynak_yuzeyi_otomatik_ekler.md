# Kaynak Yüzeyi ve Otomatik Ekler

uXBasic kitabı elle yazılmış paragraflardan oluşur; fakat kitabın referans ekleri yalnız elle tutulmamalıdır. Çünkü kaynak kod değiştikçe keyword listesi, statement dispatch yüzeyi, runtime servisleri, CLI seçenekleri ve project pack örnekleri de değişebilir. Bu nedenle kitap üretim hattında otomatik ek çıkarıcı bulunur.

Otomatik çıkarıcı şu dosyaları okur:

```text
src/parser/lexer/lexer_keyword_table.fbs
src/parser/parser/parser_stmt_registry.fbs
src/runtime/services/runtime_service_ids.fbs
src/cli/cli_registry_adim41.fbs
xtestx/project_packs/_expected/project_pack_manifest.json
```

Bu dosyalardan şu çıktılar üretilir:

```text
docs_build/book_source_surface.json
docs_build/generated/keyword_surface.md
docs_build/generated/statement_dispatch_surface.md
docs_build/generated/runtime_service_surface.md
docs_build/generated/cli_option_surface.md
docs_build/generated/project_pack_examples.md
```

Bu otomatik eklerin amacı ana kitabın yerini almak değildir. Ana kitap, komutları öğretici dille anlatır. Otomatik ekler ise kaynak yüzeyinin eksiksiz kontrolünü sağlar. Böylece kitapta `PRINT` komutu anlatılırken açıklama insan eliyle yazılır; fakat keyword listesi ve dispatch listesi kaynak koddan çekildiği için eksik kalmaz.

Kullanım:

```powershell
python tools\docs\extract_uxbasic_book_sources.py --root . --out docs_build\book_source_surface.json --generated-dir docs_build\generated
python tools\docs\build_uxbasic_pck_book.py --root . --out docs_build\uxbasic_resmi_teknik_kitap_12_06_1.md --include-generated
```

Bu iki komut birlikte çalıştığında önce kaynak yüzeyi çıkarılır, sonra kitap tek Markdown dosyasına derlenir.

Kitap üretim hattı şu ilkeye bağlıdır:

```text
Anlatım elle yazılır.
Referans yüzeyi kaynak koddan çekilir.
Örnek havuzu project packlerden beslenir.
Son kitap tek dosyada toplanır.
```

Bu ilke, kitabı hem okunabilir hem de güncellenebilir yapar.
