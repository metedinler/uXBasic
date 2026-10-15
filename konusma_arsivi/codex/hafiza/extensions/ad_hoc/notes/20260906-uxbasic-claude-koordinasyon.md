# uXBasic / Claude koordinasyon kuralı

- Ortak iletişim dosyaları: `C:/Users/mete/Downloads/BasicOyunSource/UXBc_Clean/UXBc/uxb/ai_koordinasyon/DURUM.md` ve `SORULAR_CEVAPLAR.md`.
- Her çalışmanın başında bu iki dosya okunacak; sonunda çalışma alanı/durum güncellenecek.
- Claude'un CLAIM/Devam ediyor olarak işaretlediği dosyalara izinsiz girilmeyecek; Claude'un planladığı işler Codex tarafından üzerine alınmayacak.
- Claude ve Codex soruları aynı günlükte yanıtlayacak; gerekli yeni sorular en üste eklenecek.
- Kullanıcının bilmediği yeni koordinasyon dosyaları veya önemli çalışma kayıtları tespit edilirse kullanıcıya bildirilecek ve bu not güncellenecek.
- Dosya silme yapılmayacak; kullanıcı ayrıca onay vermedikçe yalnızca salt-okunur inceleme ve güvenli ekleme/düzenleme yapılacak.
- `uxm` ayrı dil; `uxb/uXBasic` ayrı kapsamdır. Downloads kararlarında ad/uzantı tek başına kanıt değildir.
- Silme adayı sırası: metadata ve boyut -> hash/diff -> içerik/referans -> yama uygulanma durumu -> build/test/runtime katkısı -> RAG gerekliliği -> kullanıcı açık onayı.
- RAG/Ollama belgeleri özgünleri korunarak `KEEP-RAG` olarak işaretlenecek; indeks tamamlanmadan veya model çalışmıyorken kaynak silinmeyecek.
- Klasör-ZIP eşleşmesinde tüm dosya yolları, boyutlar ve hash'ler aynı olmalı; klasörde tek bir ekstra dosya varsa klasör korunur.
- ZIP başka yere kopyalanıp farklı adlı bir klasöre açılmış olabilir; eşleştirme ada/konuma değil, dosya sayısı, toplam boyut, uzantı/yol imzası ve son içerik hash'lerine dayanacak.
