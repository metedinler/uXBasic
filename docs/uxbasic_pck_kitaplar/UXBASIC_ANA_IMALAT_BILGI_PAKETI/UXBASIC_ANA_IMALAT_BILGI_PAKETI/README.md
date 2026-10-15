# UXBasic Ana İmalat Bilgi Paketi

Bu paket, 29.05 sonrası uXBasic üretim hattını yeniden kurmak için hazırlanmış **bilgi ve karar arşividir**. Kaynak kodu tekrar üretmek için değil; hangi kararın, hangi ZIP/yama/belge hattından geldiğini kaybetmemek için kullanılır.

## Paket kapsamı

- `00_ANA_BELGELER/`: Ana imalat şartnamesi ve kesin karar dosyaları.
- `01_KRONOLOJI_VE_KURTARMA/`: 30.05–31.05 kaynak ZIP kronolojisi ve kurtarma notları.
- `02_MIMARI_KATMAN_MATRISLERI/`: Özelliklerin lexer, preprocessor, parser, AST, semantic, MIR, runtime ve backend bağlantıları.
- `03_YUZEY_PREPROCESSOR_LEXER/`: Aktif keyword listesi ve yüzey sözleşmesi.
- `04_KAYNAK_BELGE_ARSIVI/`: 28.05 kitap/belge/PCK niteliğindeki dokümanlar ve repo `.codex` bağlamları.
- `05_MEVCUT_RAPORLAR/`: Bu konuşmada ve önceki kurtarma akışında üretilmiş analiz raporları.
- `06_MANIFESTLER/`: ZIP ve dosya manifestleri.
- `07_KURULUM_DOGRULAMA/`: Bundan sonra kullanılacak doğrulama/kontrol yönergeleri.

## Altın kaynak sırası

1. **Kitap/PCK referans hattı:** `uxb(28.05_1).zip` içindeki `docs/` matrisi ve `uXBasic_repo2.zip` içindeki `.codex` bağlamları.
2. **Aktif kaynak evrimi:** 30.05 saat 20 sonrası `src(30.05_4)` → `src(30.05_5)` → `src(31.05_0)` → `src(31.05_3)`.
3. **Kurtarma hattı:** `src_31_05_3_ADIM50_RECOVERED.zip` → `src_31_05_3_ADIM50_CANONICAL_V1.zip` → `src_31_05_3_ADIM50_MASTER_V2.zip`.

## Kesin uyarı

Bu paket içinde gizli token/anahtar barındıran ham terminal kayıtları bilinçli olarak konmamıştır. Copilot/Raptor incelemesi sadece temiz rapor olarak eklendi.
