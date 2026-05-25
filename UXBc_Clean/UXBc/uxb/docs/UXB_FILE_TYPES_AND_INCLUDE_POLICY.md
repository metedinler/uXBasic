# UXBc Dosya Türleri ve Include Politikası

## Amaç

UXBc üç kaynak türünü okuyabilir hale gelmelidir:

```text
.bas   Ana program veya normal BASIC kaynak dosyası
.uxm   uXBasiC modül dosyası
.uxmh  uXBasiC header dosyası
```

## .bas

Ana program veya normal kaynak dosyasıdır.

İçerebilir:

- tüm executable statement'lar
- DIM / TYPE / CLASS
- PRINT / INPUT / OPEN / CALL
- INCLUDE
- IMPORT
- FUNCTION / SUB

## .uxm

Modül dosyasıdır.

İçerebilir:

- namespace/module alanı
- FUNCTION / SUB
- TYPE / CLASS
- sabitler
- private/public üyeler
- executable initialization bloğu ancak açıkça izin verilirse

## .uxmh

Header dosyasıdır.

Temiz okuma ve bağımlılık yönetimi içindir.

İçerebilir:

- DECLARE SUB / FUNCTION
- TYPE declaration
- CLASS forward declaration
- CONST
- ENUM
- ALIAS
- USING
- NAMESPACE declaration
- IMPORT declaration
- INCLUDE başka header
- FFI signature declaration
- EXTFP runtime declarations

İçermemesi gerekenler:

- serbest executable PRINT/INPUT/LOOP statement
- dosya açma/yazma gibi runtime side-effect
- ana program gövdesi

## Include kuralları

```basic
INCLUDE "core.uxmh"
INCLUDE "math.uxm"
INCLUDE "program_part.bas"
```

Üç dosya türünde de dilin komutları parse edilebilir. Fakat semantic policy, `.uxmh` içinde side-effect statement görürse diagnostic vermelidir:

```text
UXMH_HEADER_SIDE_EFFECT_NOT_ALLOWED
```

## Neden .uxmh?

C/C++ header mantığını uXBasiC'e taşımak için:

```text
arayüz bildirimi
tip sözleşmesi
FFI sözleşmesi
modül public yüzeyi
```

kaynak gövdesinden ayrılır.

## Gelecek CLI

```text
--source-kind auto|bas|uxm|uxmh
--include-path <path>
--emit-header-surface-json-out <path>
```

Bu adımda sadece tasarım ve örnek header dosyaları eklenir. Copilot semantic policy'yi sonraki adımda bağlayacaktır.
