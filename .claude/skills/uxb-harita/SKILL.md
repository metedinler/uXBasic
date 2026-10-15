---
name: uxb-harita
description: UXBc/uXBasic kaynak haritası — bir rutinin (FUNCTION/SUB/metot), TYPE/CLASS'ın nerede tanımlı olduğunu, imzasını ve ne yaptığını büyük .fbs dosyalarını okumadan, az token ile bulmak için. uxb/src altında bir sembol ararken, "bu fonksiyon nerede / ne yapar / kim tanımlıyor" sorularında, bir değişikliğe başlamadan önce ilgili dosya:satır'ı bulmak için KULLAN.
---

# uXBasic kaynak haritası (düşük token)

**Önce yön:** derleme hattı, dört motorun farkları, "bir özellik hangi dosyalara dokunur" listesi ve testler için
aynı klasördeki `MIMARI.md`'yi oku (tek sayfa). Sonra aşağıdaki sembol haritasıyla tam `dosya:satır`'ı bul.
Haritayı ilk kez kullanıyorsan `EGITIM.md` (çalışma kuralları, soru→yol örnekleri, sık hatalar).

Harita, UxbRAG V4 araçlarının `uxb/src, include, libsx, runtime_ext, native, compiler` altındaki
FreeBASIC kaynaklarından ürettiği sembol envanteridir. Büyük dosyaları (memory_exec.fbs 4000+ satır vb.)
baştan okumak yerine önce burada ara, sonra kaynağın YALNIZ ilgili satır aralığını oku.

Kök: `C:\Users\mete\Downloads\BasicOyunSource\UXBc_Clean\UXBc\UxbRAG\UXB_HYBRID_RAG_V4_YORUMLU_JSON`
(aşağıda `<V4>`).

## 1. Güncellik kontrolü (her oturumda bir kez)
`<V4>\ajan_paketi\kapsam.md` başındaki satıra bak: "Haritadan sonra değişen kaynak dosya: N".
N büyükse ve aradığın dosya değişmiş olabilirse haritayı yenile (bkz. 4). Sonuç yine de satır numarası
kayabilir: kaynağı okumadan önce Grep ile adı doğrula.

## 2. Sembol arama (önce bu)
Grep aracıyla, `<V4>\ajan_paketi\rutinler.tsv` içinde satır başında adı ara:
- Kesin ad: desen `^ExecTaskReceiverInfo\t`
- Parça: desen `(?i)^[^\t]*TaskReceiver[^\t]*\t`
Sütunlar (TAB): ad · tür (`*` = Declare/prototip) · kapsayıcı · dosya · satır · modül paketi · amaç kaynağı · amaç · imza.
Tanım satırını (tür sütununda `*` olmayan) kullan; `dosya:satır` ile kaynağı `Read` + `offset/limit` ile oku.

Alternatif (TYPE alanları, sınıflar, sayılar):
`python tools\uxb_map_lookup.py symbol <ad> [--contains] [--kind FUNCTION|SUB|TYPE|FIELD...]`
(`<V4>` içinde çalıştır; `PYTHONIOENCODING=utf-8`).

## 3. Modül / tip / soru-cevap görünümü
- `<V4>\ajan_paketi\sss_dizini.tsv` + `sss\S*.md` — dosya başına Gemini soru-cevapları ("X nerede işlenir?"): bir işe
  başlarken önce ilgili dosyanın SSS'ine bak. Modül sayfalarında `> Rol:` satırı dosyanın özetidir.
- `<V4>\ajan_paketi\moduller\M*.md` — bir dosyanın bütün rutinleri (imza + amaç). Paket adı rutinler.tsv 6. sütunda.
- `<V4>\ajan_paketi\tipler\T*.md` — TYPE/ENUM/CLASS ve alanları.
- `<V4>\ajan_paketi\modul_dizini.tsv` — dosya başına katman, satır sayısı.

## Güven
- İmza, dosya, satır: kaynaktan okunur, güvenilir (harita güncelse).
- Amaç `yorum`: rutinin üstündeki yorum; yanlış rutine yapışmış olabilir.
- Amaç `llm`: yerel qwen2.5-coder:3b taslağı — DOĞRULANMAMIŞ; kısaltmaları uydurabilir. Karar vermeden kaynağı oku.
- Amaç `gemini` / `chatgpt` / `claude` / `kimi`: dış model taslağı (mimari + dosya imzalarıyla sorulur; daha
  isabetli) — yine DOĞRULANMAMIŞ. Doldurma: `<V4>\scripts\42_harita_doldur.bat` ya da
  `python tools\uxb_harita_doldur.py --saglayici gemini --is hepsi` (anahtarlar `%USERPROFILE%\.uxb\api_anahtarlari.env`;
  kota sağlayıcı başına; kaldığı yerden devam; ardından `uxb_ajan_paketi.py`).
- Haritada YOK: çağrı grafiği (kim çağırıyor → Grep `-w <ad>` uxb/src), C/C++/Python/PowerShell kaynakları,
  lexer anahtar sözcük yüzeyi (gerçek kaynak: `uxb/src/parser/lexer/lexer_keyword_table.fbs`).

## 4. Yenileme (kaynak çok değiştiyse)
`<V4>` içinde, sırayla (her biri ~3 dk, ~25 MB disk; önce boş disk ≥ 1 GB olduğunu kontrol et):
```
python tools\uxb_map_system.py --skip-modules --full-inventory --roots "uxb/src,uxb/include,uxb/libsx,uxb/runtime_ext,uxb/native,uxb/compiler"
python tools\uxb_ajan_paketi.py
```
(`scripts\41_ajan_paketi_yenile.bat` aynı işi yapar ama sonunda `pause` bekler — ajanlar doğrudan komutları çalıştırsın.)

Eksik amaçları yerel modelle doldurmak (uzun, kaldığı yerden devam eder, düşük öncelikte başlat):
`python tools\uxb_purpose_fill.py --max-minutes 240` → sonra paketi yenile (`uxb_ajan_paketi.py`).
Log: `<V4>\logs\amac_uret_*.log`.
