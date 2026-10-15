# Codex — Kod ve Tasarım Uzlaştırma Kaydı

Tarih: 2026-09-24  
Kapsam: güncel planların, Claude/Antigravity/Gemini kayıtlarının ve canlı
`uxb` kodunun çapraz denetimi.

## Sonuç

Denetim raporu:

`docs/tasarim/UXB_KOD_TASARIM_UZLASTIRMA_DENETIMI_20260924_TR.md`

Bu turda S-148 semantic kapısı Codex tarafından düzeltildi; S-149'un parser/
semantic/runtime ve canonical MIR halkası Claude'un canlı değişiklikleriyle
taze ikili üzerinde doğrulandı. Claude'un aktif CLAIM dosyalarına,
Antigravity'nin JS/WAT/WASM alanına ve Gemini adına açılmış tarihsel kayıtlara
dokunulmadı.

## Doğrulanan Açıklar

### S-148 — DIM initializer tipi atlıyor

`src/semantic/mir_lower_stmt_core_split.fbs` içindeki `DIM_STMT`/`INIT_EXPR`
yolu, `MIRLowerExprNode` sonrasında doğrudan `STORE_VAR` üretiyor. Normal
atamadaki `UXBStep3CheckAssignment` çağrısı yok.

Probe: `tests/coordination_20260924/s148_dim_initializer_type_probe.uxb`

```basic
DIM bad AS I32 = "text"
DIM ok AS STRING = 42
```

Ortak `bin/uxb.exe sem` bu programı kabul etti. MIR JSON'da STRING→I32 ve
I64→STRING uyumsuz STORE_VAR'lar, boş diagnostics ile üretildi. Bu kayıt
**YAPILDI-DOGRULANDI:** `semantic_step3_gate.fbs` içine `DIM INIT_EXPR` için
normal `UXBStep3CheckAssignment` kapısı eklendi. Taze `bin/uxb.exe` ile
`STRING -> I32` ve `I32 -> STRING` ilk değerleri exit 1 ve açık semantic
tanıyla reddediliyor; geçerli `I32`/`STRING` ilk değerleri exit 0. Mevcut
`TASK -> I32` negatif testi de korunuyor.

### S-149 — TASK sonucunun statik tipi yok

Canlı type binding yalnız `TYPE_TASK` ve `TYPE_TASKGROUP` içeriyor. Normal
`.RESULT`/`.JOIN()` `TYPE_OBJECT` fallback'ine düşüyor. `TASK OF T` parser,
metadata ve inference kodu bulunamadı.

Mete'nin uygulama talimatıyla mevcut tipsiz `TASK` korunarak güvenli yol
`TASK OF T` olarak kabul edildi. Claude'un canlı diff'i parser, semantic,
`.RESULT/.JOIN()` inference ve AST/MIR yorumlayıcı ilk dönüş yolunu uyguluyor.
Taze ikiliyle typed kabul, tipsiz kaynak reddi, yanlış tip reddi ve
typed→tipsiz geriye dönük aktarım doğrulandı. Canonical MIR senkron referans
halkası `tests/task_model` içinde 27 program x 4 motor = 108/108 ile doğrulandı;
native/legacy motorlar K7 gereği temiz red veriyor. Gerçek native async, JS
Worker ve WASM görev yürütmesi sonraki hedef halkalarıdır.

## Birinci Sınıf Kütüphane Tipi Durumu

| Katman | Durum |
|---|---|
| Manifest/registry/provider alanları | Yapıldı ve test edildi. |
| RATIONAL canonical MIR provider | Yapıldı; MIR kapsamı kanıtlı. |
| VALUE/BITCOPY/NONE lifecycle | Yapıldı; lifecycle unit 41 kontrol, güncel library contract paketi 30/30. |
| Genel CLONE/RETAIN/DROP lowering | Açık. |
| JS/WASM/native provider yürütmesi | Manifest adı var, gerçek parity açık. |
| COMPLEX/POLYNOMIAL/MATRIX paketleri | Tasarım adayı, kodda yok. |

“Manifestte provider alanı var” ile “hedefte provider çalışıyor” ayrı durum
kelimeleriyle tutulacaktır.

## Ajan Durumu

- **Claude:** S-030 Faz 1B canonical MIR ve S-149 `TASK OF T` parser/semantic/MIR
  halkası 108/108 ile doğrulandı. S-148 bulgusu düzeltildi ve
  taze ikiliyle doğrulandı.
- **Antigravity:** JS/WAT/WASM provider, SLOT_DEF, fail-fast, Worker/host ve
  gerçek runner parity. S-153 matrix şu an ölçüm üretmediği için açık.
- **Gemini:** güncel aktif claim bulunamadı; yalnız 16.09 tarihli recursive DIM
  ve collection kayıtları tarihsel kanıt olarak tutuluyor.
- **Codex:** library type manifest/lifecycle, bu uzlaştırma ve S-148 için
  ortak semantic kapı koordinasyonu. Claude'un aktif dosyaları devralınmadı.

## Belge Çelişkileri

1. Uzun 24.09 tasarım metnindeki eski `TASKOUT(t)`/`WAIT t` önerileri ile
   K1–K8'deki `.RESULT/.JOIN()` ve `TASKGROUP` yüzeyi aynı anda bağlayıcı
   olamaz. K1–K8 güncel karar, eski metin tarihçe olarak etiketlenmelidir.
2. AST Faz 1 kapanışı, dört motor/canonical MIR/native/JS/WASM kapanışı değildir.
3. Raw PTR ve 6502 adresleme uygulanmış tasarım kararıdır; `PTR TO T` S-113
   olarak açıktır.
4. `FOR EACH x IN 10,20,30` değer listesi korunmuştur; iterable `IN a,b`
   bilinçli olarak reddedilir. `CHAIN/ZIP` S-135 işidir.
5. OOP temel parity kapanışları ileri OOP hedeflerinin tamamlandığı anlamına
   gelmez.

## Sonraki İş Kaydı

1. S-134 genel CLONE/RETAIN/DROP lowering'i, alan/BYREF/escape omru ve
   provider parity'si.
2. S-030 Faz 2 native gercek async ve S-146 paylasimli veri kararlarinin
   kilitlenmesi.
3. Antigravity sahipliginde JS Worker, WASM gorev yolu ve fail-fast/provider
   kabul vektorleri.
4. S-147 JOINALL sonuc/hata sirasi ve desteklenen motor kabulü.
5. S-153 gerçek yüzey ölçüm matrisi.

Kapanış ölçütü: her madde için kaynak yolu, tam test komutu, çıkış kodu,
beklenen/gerçek sonuç ve bilinen dışlamalar birlikte yazılmadan “tamamlandı”
etiketi kullanılmayacaktır.
