# UXBc Kütüphane Import Politikası

## Amaç

Ek kütüphane zipleri UXBc compiler çekirdeğini kirletmeden sisteme alınır.

## Klasör rolleri

```text
libs/<module>/                 uXBasiC wrapper/module kaynakları
uxb/runtime_ext/<module>/      C/C++/DLL runtime kaynakları
uxb/tests/<module>/            kütüphane testleri
uxb/docs/                      kütüphane belgeleri ve atlas CSV'leri
uxb/compiler/scripts/          build/smoke yardımcı scriptleri
uxb/include/modules/<module>.uxmh  header/arayüz dosyası
```

## Yasak

- Kütüphane importu `uxb/src` compiler çekirdeğini ezmeyecek.
- Çakışan dosya sessizce overwrite edilmeyecek.
- Aynı modülün farklı ziplerden geldiği durum raporlanacak.
- Dış bağımlılıkları olan runtime modülleri sahte PASS üretmeyecek.

## Çakışma politikası

Varsayılan:

```text
same_hash => skip
different_hash => retire old target then copy new file
```

Emekli kayıtları:

```text
uxb/_retired/library_import/YYYYMMDD_HHMMSS/<path>.zip
uxb/_retired/library_import/YYYYMMDD_HHMMSS/<path>.txt
```

TXT içinde neden emekli edildiği, yerine gelen zip ve hedef yol Türkçe yazılır.

## Header politikası

Her modül için otomatik `.uxmh` üretilir:

```text
uxb/include/modules/uxmath.uxmh
uxb/include/modules/uxmatrix.uxmh
...
```

Toplu header:

```text
uxb/include/libs.uxmh
```

`.uxmh` dosyaları side-effect içermeyen arayüz/header dosyalarıdır.

## IDE entegrasyonu

Kütüphane import sistemi IDE command contract'a şu komutları ekler:

```text
uxbasic.auditLibraries
uxbasic.importLibraries
uxbasic.buildLibraryRuntimes
uxbasic.runLibrarySmokes
```
