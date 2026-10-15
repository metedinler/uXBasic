# Üçüncü Taraf C Motorları

| Motor | Beklenen kaynak | Lisans | Dağıtım biçimi |
|---|---|---|---|
| SQLite | MSYS2 UCRT64 `sqlite3` | Public Domain | DLL + import library |
| libcurl | MSYS2 UCRT64 `curl` | curl/MIT benzeri | DLL + bağımlılıkları |
| yyjson 0.12.0 | Resmî GitHub tag arşivi | MIT | `uxjson.dll` içine gömülü |
| PCRE2 | MSYS2 UCRT64 `pcre2` | BSD-3-Clause | `libpcre2-8-0.dll` |
| Zstandard | MSYS2 UCRT64 `zstd` | BSD-3-Clause/GPL çift lisans | DLL |
| libarchive | MSYS2 UCRT64 `libarchive` | BSD-2-Clause | DLL + bağımlılıkları |
| libsodium | MSYS2 UCRT64 `libsodium` | ISC | DLL |

Build sonunda kurulu gerçek sürümler
`reports/libraries/cbase/<zaman>/cbase_runtime_manifest.json` dosyasına yazılır.
