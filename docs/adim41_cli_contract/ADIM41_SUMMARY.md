# ADIM41 CLI Full Contract Patch

## Amaç

119 CLI seçeneğinin tümü için:

- uzun seçenek
- 3 harfli kısa komut
- kaldırılan Türkçe alias guard'ı
- çıktı uzantısı
- çıktı doğrulama kuralı
- VSCode kullanım ihtimali
- main bağlantı sözleşmesi

tek kayıt altında tutulur.

## Sayılar

| Ölçüt | Sayı |
|---|---:|
| Toplam seçenek | 119 |
| Türkçe kaldırılacak alias | 3 |
| JSON ağırlıklı output | 44 |
| Dosya output bekleyen | 59 |
| VSCode/dolaylı kullanılan | 27 |

## Türkçe alias kararı

| Kaldırılacak | Kullanılacak |
|---|---|
| `--ayikla` | `--debug` |
| `--sessiz` | `--quiet` |
| `--semantik` | `--semantic` |

## Ana bağlantı

```text
CLI registry
  -> short alias resolver
  -> output contract
  -> main output bridge
  -> gerçek stage writer
  -> file validator
```
