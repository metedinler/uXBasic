# Codex -> Claude Calisma Surumu ve Devir Kaydi

Tarih: 2026-09-25
Sahip: Codex
Paylasim hedefi: Claude 1 / Claude 2 ve Antigravity koordinasyonu

## 1. Calisma Surumu

- Depo: `uxb`
- Git HEAD: `fd42dee`
- Calisma agaci: kirli; Claude'un TASK/SPAWN degisiklikleri ve diger ajan
  degisiklikleri korunuyor. Commit veya stage yapilmadi.
- Taze derleyici: `bin/uxb.exe`
- Derleyici SHA256: `FF4ECFAB6633308E83CE882EFF3A06232B732D1532A2DF625ADC1A6A32208852`
- Derleyici son yazilma zamani: `2026-09-25 02:02:31`
- Aktif Claude `CLAIM` / `Devam ediyor` dosyalarina dokunulmadi.

Bu kayit, Claude'un kendi aktif alaninin yerine gecmez. Kaynak sahipligi
`ai_koordinasyon/DURUM.md` ve mevcut CLAIM kayitlarinda kalir.

## 2. Bu Turda Tamamlananlar

### S-148: DIM ilk deger tipi

`src/semantic/semantic_step3_gate.fbs` icindeki `DIM INIT_EXPR` yolu normal
`UXBStep3CheckAssignment` kapisina baglandi. Artik `DIM bad AS I32 = "text"`
ve `DIM bad AS STRING = 42` semantic olarak reddedilir; gecerli ilk degerler
kabul edilir.

### S-149 ve S-030 Faz 1B: TASK OF T ve canonical MIR

Claude'un parser/semantic/runtime degisiklikleri guncel ikiliyle korundu ve
dogrulandi. `TASK OF T` tipsiz TASK ile birlikte kalir. Canonical MIR adlari:

`TASK_SPAWN`, `TASK_WAIT`, `TASK_JOIN`, `TASK_CANCEL`, `TASK_STATUS`,
`TASK_RESULT`, `TASK_ERROR`, `TASK_GROUP_CREATE`, `TASK_GROUP_ADD`,
`TASK_GROUP_JOIN`.

`tests/task_model/run_task_model_tests.ps1 -Uxb .\\bin\\uxb.exe`:

- 27 program x 4 motor = **108/108 PASS**
- MIR senkron referans olarak calisir.
- Native x64 ve legacy AST-x64 TASK icin K7 geregi temiz red verir.
- Gercek native async, JS Worker ve WASM gorev yurutmesi bu kapanisa dahil degildir.

### S-134: Birinci sinif kutuphane tipi B2 mevcut kabul paketi

Codex, aktif MIR assignment yolunda managed value COPY metadata'sini
`src/semantic/mir_lower_stmt_core_split.fbs` icine bagladi. Boylece `b=a`
value bagimsizligi ve clone-limit vektoru gecti.

`RATIONAL_REFERENCE` MIR saglayicisi manifestte ilan edilen
`VALUE/BITCOPY/NONE` lifecycle icin `COPY`, `CLONE` ve `TOSTRING` cagri
vektorlerini destekliyor. RATIONAL `RETAIN` veya `DROP` ilan etmedigi icin
bu iki cagri kaynak yuzeyinde kabul edilmiyor.

`tests/library_type_contract/run_library_type_tests.ps1`:

- **30/30 PASS**
- Compiler SHA256 yukaridaki taze `bin/uxb.exe` hash'idir.

Bu sonuc genel S-134 kapanisi degildir. `REFERENCE/RETAIN/PROVIDER`,
field/BYREF/escape omru, genel lifecycle lowering'i ve gercek JS/WASM/native
provider parity'si aciktir.

Ek uzlastirma: S-112 erken manifest tip adi gorunurlugu da guncel ikilide
uygulanmistir. `DYNAMIC_PAYLOAD` parser'dan gecip semantic kapida
`library type lifecycle lowering unavailable` olarak kontrollu reddedilir;
artik parser seviyesinde `unknown type` ile durmaz. Pozitif provider testi B3/B4
kapsamindadir.

## 3. Claude'dan Beklenen Uzlastirma

1. S-030 Faz 1B ve S-149 kaydini canonical MIR 108/108 kanitiyla uyumlu kabul
   et; eski "canonical MIR henuz yok" satirlarini tarihsel ara durum olarak
   isaretle.
2. `src/interpreter/mir/mir_interp_task.fbs` ve TASK lowering alaninda yeni
   degisiklik yapmadan once S-146 karar kaydini kontrol et.
3. Native async, JS Worker ve WASM gorev yurutmesini Faz 1B senkron referans
   kabulunden ayri tut; temiz red ile gercek destek arasindaki ayrimi koru.
4. TASK alaninda yeni bir bulgu cikarsa once `SORUN_TAKIP.md`ye yeni S-numarasi
   veya mevcut S-030 alt maddesiyle kanit ekle; Codex'in S-134 dosyalarini
   devralma.

## 4. Antigravity ve Gemini Siniri

- Antigravity: JS/WAT/WASM provider, Worker/host yetenegi, fail-fast ve S-153
  gercek yuzey matrisi.
- Gemini: bu tur icin guncel aktif claim yok; tarihsel kayitlar kanit olarak
  korunuyor.
- Codex: S-134 lifecycle sozlesmesi, MIR provider kabul vektorleri, S-148 ve
  belge uzlastirmasi.

## 5. Bagli Belgeler

- `ai_koordinasyon/PLAN_BIRINCI_SINIF_KUTUPHANE_TIPI_20260925_TR.md`
- `ai_koordinasyon/SORUN_TAKIP.md` S-134, S-148, S-149, S-030
- `docs/tasarim/UXB_KOD_TASARIM_UZLASTIRMA_DENETIMI_20260924_TR.md`
- `docs/tasarim/UXB_KARAR_DENETIMI_VE_BIRLESIK_KALAN_ISLER_20260924_TR.md`

Claude'un bu kaydi okuduktan sonra kendi aktif gunlugunde yalnızca sahip
oldugu TASK/SPAWN alaninin durumunu ve varsa yeni kaniti bildirmesi yeterlidir.
