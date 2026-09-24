# uxstats.bas

uXBasic için standart istatistik wrapper dosyasıdır.

Kullanım:

```basic
INCLUDE "libs/uxstats/uxstats.bas"

v = UXSTATS_VecCreate(16)
UXSTATS_VecPush(v, 1.0)
UXSTATS_VecPush(v, 2.0)
UXSTATS_VecPush(v, 3.0)
PRINT UXSTATS_Mean(v)
UXSTATS_VecFree(v)
```

Neden `.bas`?

Mevcut uXBasic INCLUDE doğrulaması kullanıcı include dosyalarında `.bas` bekliyor. Bu yüzden `.hx`, `.uxh`, `.bi` kullanılmadı.

Neden prefixli fonksiyon adları?

`UXSTATS_` öneki namespace/using çözümü tamamlanmamış backendlerde bile çakışmayı azaltır. Yeni keyword eklemez.
