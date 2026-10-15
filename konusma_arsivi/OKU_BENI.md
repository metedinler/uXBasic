# Konuşma ve hafıza arşivi

Bu klasör, uXBasic geliştirmesinde çalışan yapay zekâ yardımcılarının konuşma ve hafıza kayıtlarının **yayın için hazırlanmış kopyalarıdır**. Yazarın 2026-10-15 kararıyla yayındadır; yalnız okumak ve başvurmak içindir, lisans vermez (bkz. `DESIGN-RIGHTS-RESERVED.md`).

| Klasör | İçerik |
|---|---|
| `claude/konusmalar/` | Claude Code konuşmalarının okunabilir dökümleri (`<tarih>_<oturum>.md`) ve ham kayıtları (`ham/*.jsonl`) |
| `claude/hafiza/` | Claude'un proje hafıza notları |
| `codex/hafiza/` | Codex'in hafıza notları (özet, ham notlar, oturum özetleri) |
| `chatgpt/` | Kaydedilmiş bir ChatGPT konuşma sayfası |

## Bu kopyalarda yapılan değişiklikler

Orijinal kayıtlar yazarın bilgisayarında olduğu gibi durur. Buradaki kopyalarda yalnız şunlar değiştirildi:

1. **Gizli anahtarlar silindi** (yapay zekâ hizmeti anahtarları, bağlantı dizesi parolaları, ortam değişkeni atamaları ve Bearer belirteçleri): 107 yer, 9 dosyada. Aynı değer birçok kez geçer ve bir kısmı tarama araçlarını sınamak için uydurulmuş örneklerdir. Yerlerinde `[GIZLI-SILINDI:<tür>]` yazar. GitHub'ın itibar koruması ilk denemede kaçırdığımız bir anahtarı yakaladı; tarama desenleri bunun üzerine genişletilip kopyalar baştan üretildi.
2. Yazarın kişisel e-posta adresi `[e-posta]` ile maskelendi (162 yer, 18 dosyada). Adres, kitap ve yardım iletisinde iletişim bilgisi olarak zaten yayındadır.
3. **100 MB sınırı:** GitHub dosya başına 100 MB'ı geçen dosyayı kabul etmez, büyük dosyaların yüklenmesi de kopabilir. Bu oturumun (`b85b832d-…`, 2026-10-07'den beri süren Kılavuz V2 çalışması) ham kaydı 121 MiB olduğu için satır sınırından **6 parçaya** (her biri en çok 44 MiB) bölündü: `claude/konusmalar/ham/b85b832d-c86f-49e6-b0a0-47af736f8686.part01.jsonl` … `.part06.jsonl` (ilki 44 MiB, sonrakiler 16 MiB'a kadar: zayıf bir yukarı yön bağlantısında yüklemeler kopuyordu). Sırayla art arda eklenince tam kayıt çıkar (Windows: `copy /b …part01.jsonl + …part02.jsonl + … (numara sırasıyla) tam.jsonl`; Linux ve macOS: `cat …part0*.jsonl > tam.jsonl`).
4. **Bu oturumun kaydı 2026-10-15T11:57:58.368Z (UTC) anına kadardır.** Oturum sürdüğü için sonraki bölümler yoktur. Okunur dökümü `claude/konusmalar/20261015_b85b832d.md`; yazarın arşiv betiğinin 2026-10-07'de aldığı eski anlık döküm `ham/20261007_b85b832d.onceki.md` olarak durur (betik bu oturumu o günden beri yenilememişti).

## Dahil olmayanlar

Codex'in oturum günlükleri (yaklaşık 650 MB, tüm projeleri kapsar), kimlik ve ayar dosyaları (`auth.json`, `config.toml`), uygulama günlükleri, Claude oturumlarının yan dosyaları (kaydedilmiş araç sonuçları, alt ajan kayıtları) ve hesap dışa aktarımı olmayan ChatGPT içeriği.
