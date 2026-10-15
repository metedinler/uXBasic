# PCK belge güncellik notu — 27.07.2026

PCK klasöründeki eski ciltler ve tarihli analizler tarihsel kaynak olarak korunmuştur. İçerikleri topluca silinmemiş veya yeniden yazılmamıştır. Güncel ve üretimde bağlayıcı açıklamalar `docs_src/33`–`docs_src/36` bölümlerindedir.

- Güncel FFI sözleşmesi API 131 / ABI10 / en çok 10 argümandır.
- QuickJS runtime API sürümü 110’dur.
- Wasmtime dış runtime API sürümü 100 ve mevcut üretim profili core-i32’dir.
- Native MIR metin ilişkileri pointer adresiyle değil içerikle karşılaştırılır.
- Strict allow; hash ve gerçek Authenticode imza eşleşmesi ister.
- Report-only, politika reddini raporlar fakat yükleme veya ABI hatalarını başarıya dönüştürmez.
- Eski birleşik imza metni örnekleri yerine açık dönüş tipi, çağrı düzeni ve ayrı argüman tip listesi kullanılmalıdır.
