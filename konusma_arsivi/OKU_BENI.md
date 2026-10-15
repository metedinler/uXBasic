# Konuşma ve hafıza arşivi

Bu klasör, uXBasic geliştirmesinde çalışan yapay zekâ yardımcılarının konuşma ve hafıza kayıtlarının **yayın için hazırlanmış kopyalarıdır**. Yazarın 2026-10-15 kararıyla yayındadır; yalnız okumak ve başvurmak içindir, lisans vermez (bkz. `DESIGN-RIGHTS-RESERVED.md`).

| Klasör | İçerik |
|---|---|
| `claude/konusmalar/` | Claude Code konuşmalarının okunabilir dökümleri (`*.md`) ve ham kayıtları (`ham/`) |
| `claude/hafiza/` | Claude'un proje hafıza notları |
| `codex/hafiza/` | Codex'in hafıza notları (özet, ham notlar, oturum özetleri) |
| `chatgpt/` | Kaydedilmiş bir ChatGPT konuşma sayfası |

## Bu kopyalarda yapılan değişiklikler

Orijinal kayıtlar yazarın bilgisayarında olduğu gibi durur. Buradaki kopyalarda yalnız şunlar değiştirildi:

1. **Gizli anahtarlar silindi** (yapay zekâ hizmeti anahtarları, ortam değişkeni atamaları ve Bearer belirteçleri; 8 dosyada 58 değer). Yerlerinde `[GIZLI-SILINDI:<tür>]` yazar. GitHub'ın itibar koruması ilk denemede kaçırdığımız bir anahtarı yakaladı; tarama desenleri bunun üzerine genişletilip kopyalar baştan üretildi.
2. Yazarın kişisel e-posta adresi `[e-posta]` ile maskelendi (kayıtlarda 102 yer). Adres, kitap ve yardım iletisinde iletişim bilgisi olarak zaten yayındadır.
3. Dosya başına GitHub sınırı 100 MB'dır; bu kopyaların en büyüğü yaklaşık 85 MB'dır, parçalama gerekmedi.

## Dahil olmayanlar

Codex'in oturum günlükleri (yaklaşık 650 MB, tüm projeleri kapsar), kimlik ve ayar dosyaları (`auth.json`, `config.toml`), uygulama günlükleri, hesap dışa aktarımı olmayan ChatGPT içeriği ve Claude'un şu an yazılmakta olan canlı kayıt dosyaları.
