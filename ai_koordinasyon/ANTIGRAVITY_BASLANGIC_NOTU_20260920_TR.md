# Antigravity için başlangıç notu (Claude 1, 2026-09-20)

Bu depoda dört yapay zekâ ve Mete birlikte çalışır: Codex (1/2/3), Claude 1 (ben), Claude 2 ve sen (Antigravity).
Mete programcı DEĞİLDİR: raporlar/cevaplar **Türkçe (doğru diyakritiklerle)**, jargon sade anlatılarak yazılır.

## Önce oku (bu sırayla)
1. `ai_koordinasyon/KARAR_VE_GOREV_DEFTERI.md` — yürürlükteki kararlar (eski madde silinmez, tarihli yenisi eklenir).
2. `ai_koordinasyon/DURUM.md` — kim ne yaptı (sona ekle, mevcut satırı bozma).
3. `ai_koordinasyon/SORUN_TAKIP.md` — her bulgu bir `S-nnn`; durum kelimeleri: YAPILDI-DOGRULANDI / KISMEN-YAPILDI / ACIK / KARAR-BEKLIYOR.
4. `ai_koordinasyon/CLAUDE1_20260920_ISLER_VE_SORUN_DURUMU_TR.md` — bugünün özeti; `SORULAR_CEVAPLAR.md` — soru/cevap arşivi.
Yeni S numarası almadan önce SORUN_TAKIP'ta en yüksek numarayı `Grep` ile kontrol et (bugün iki oturum aynı numarayı aldı: S-112).

## Temel kurallar
- **Dört motor aynı sonucu vermeli:** AST yorumlayıcı (`uxb run`), canonical-MIR (`uxb run --interpreter-backend MIR`), native MIR-x64 (`uxb bld`), legacy AST-x64 (`uxb bld --x64-mode AST`); JS/WASM ayrıca. Kök nedeni bul, tüm motorlarda düzelt; yer tutucu/sahte kod yok.
- **Karar gerektiren tasarım sorularını sessizce verme:** `KARAR-BEKLIYOR` olarak yaz, Mete'ye sor.
- **Doğrulama = gerçek derle + çalıştır.** Kod okumak yetmez (bugün "okuyunca doğru sandım" iki kez yanıltıcı çıktı).
- Sürüm/yedek yok (git kullanılamıyor): silme yerine taşı; `build\` silme kuralı için `KARAR_VE_GOREV_DEFTERI.md` son maddesine bak.

## Derleme ve test
- Derleyiciyi derle (≈90–140 sn): `.\compiler\scripts\build_uxb_main_64.ps1 -Root . -Force` → `bin\uxb.exe`. Başkası aynı anda derliyor olabilir: `Get-Process fbc64,as,ld` bak, ortak `bin\uxb.exe`'yi ezmemeye dikkat.
- **Tüm dil-davranış paketleri tek komut:** `.\tests\run_all_model_tests.ps1` (10 paket, 342 kontrol; `-Only oop_parity,iterators` ile seçili). Çıktı klasörlerini geçici `--out-root` altına yönlendirip siler.
- Toplu deneylerde `uxb ... --out-root <geçici klasör>` kullan; aksi halde her çağrı `build\<zaman>` altına ~1,7 MB yazar (FFI'li yerel derlemede +53 MB). Disk C: sınırlı (bir ara 0,02 GB'a düştü).
- Uzun/sonsuz olabilecek her denemeye zaman aşımı koy; işin bitince açtığın süreçleri kapat (`uxb`, `program.exe`, `gdb`, arka plan `pwsh`).
- Ölçüm için duvar saati değil `Process.TotalProcessorTime` (CPU sn) kullan — makine paylaşımlı.

## PowerShell tuzakları
- Bu makinede Bash yok, PowerShell 7 var. Komutta "erase" kelimesi geçerse araç komutu topluca reddeder; metin dosyalarını Edit/Write ile yaz.
- Çift tırnaklı dizgede `` `b `` geri-silme karakteridir (`build\` yollarında dikkat: tek tırnaklı/here-string kullan).
- `uxb help`, `uxb version` artık çalışır (aynı `--help`/`--version`).

## Başka kim neye dokunuyor?
- Codex: birinci sınıf kütüphane tipleri (S-112..S-115, `src/semantic/library_type_contract.fbs`, `type_infer_expr.fbs`).
- Claude 1: dil davranış eşitliği, ABI, dizi/OOP/iteratör testleri, MIR yorumlayıcı ve ön uç performansı (S-109, S-111), test koşucusu (S-072).
- Bir dosyayı düzenlemeden önce `LastWriteTime` bak; başkasının bugün değiştirdiği dosyada küçük ve hedefli düzenleme yap.

Sorun olursa ya da bilmediğin bir şey varsa `SORULAR_CEVAPLAR.md` sonuna soru olarak ekle; bilenler cevaplar (Mete ayrıca yönlendirir).
