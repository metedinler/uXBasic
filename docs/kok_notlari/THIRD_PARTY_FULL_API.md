# Resmî C Kütüphanesi Sağlayıcıları

Bu sistem rastgele DLL indirme sitelerini kullanmaz. Varsayılan sağlayıcı,
MSYS2 UCRT64 resmî ikili paket deposudur. `pacman` bağımlılık çözümleme,
paket veritabanı, paket hash doğrulaması ve kurulu dosya bütünlük denetimini
yapar.

| uXBasic modülü | Motor | MSYS2 UCRT64 paketi | Lisans |
|---|---|---|---|
| `uxsqlite` | SQLite | `mingw-w64-ucrt-x86_64-sqlite3` | Public Domain |
| `uxhttp` | libcurl/WinSSL | `mingw-w64-ucrt-x86_64-curl-winssl` | curl/MIT |
| `uxjson` | json-c | `mingw-w64-ucrt-x86_64-json-c` | MIT |
| `uxregex` | PCRE2 8-bit | `mingw-w64-ucrt-x86_64-pcre2` | BSD-3-Clause |
| `uxcompress` | Zstandard/ZDICT | `mingw-w64-ucrt-x86_64-zstd` | BSD-3-Clause veya GPL-2.0-or-later |
| `uxarchive` | libarchive | `mingw-w64-ucrt-x86_64-libarchive` | BSD-2-Clause |
| `uxcrypto` | libsodium | `mingw-w64-ucrt-x86_64-libsodium` | ISC |
| `uxcapi` | libffi | `mingw-w64-ucrt-x86_64-libffi` | MIT |

## Güvenlik kapıları

Build sırasında:

1. Paket yalnız resmî pacman adıyla kurulur.
2. `pacman -Q` ile kurulu sürüm kaydedilir.
3. `pacman -Qkk` ile kurulu paket dosyaları denetlenir.
4. DLL export tablosu public header ile karşılaştırılır.
5. Bütün üretilen ve dağıtılan DLL'ler PE32+ x64 olarak doğrulanır.
6. Geçişli import DLL'leri `objdump` ile bulunur.
7. Her runtime dosyasının SHA-256 değeri manifestte saklanır.
8. Header'da olup DLL'de olmayan public fonksiyon varsa build PASS vermez.

Paket sürümleri belgeye sabitlenmez. Güncel kurulu sürüm ve hashler gerçek build
sonunda `reports/libraries/c_full/<zaman>/runtime_manifest.json` içine yazılır.
