# Codex 1 — kimlik, kapsam ve tam planın yeri

Mete'nin 2026-09-15 tarihli talimatı: bu oturum bundan sonra **Codex 1** olarak çalışır. Codex 2, Claude 1 ve Claude 2 ayrı oturumlardır.

Kullanıcı OOP tasarımının uygulanmasını istedi. Tam tasarım metni korunmuştur:

- [OOP hedef tasarımı, 16 bölüm ve P0–P10 paketleri](../docs/OOP_HEDEF_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md).
- [Claude'un OOP dışındaki açık işler planı](../docs/UXB_ACIK_ISLER_TASARIM_VE_UYGULAMA_PLANI_20260915_TR.md).

İlk belge THIS/ME/SUPER görev ayrımını, tür/kopyalama/ömür sözleşmesini, trait/decorator aşamalarını, UXClazz profillerini, FFI sınırını, tasarım sorularını, bağımlılık sırasını ve kabul matrisini tam olarak içerir. Yeni kısa notlar bu metnin yerine geçmez. Tasarımın tamamı uygulanmış değildir; uygulama kanıtı ayrıca kaydedilir.

## Devam eden kapsam

1. Sistem genelinde kaynak ve kütüphane denetimi, açık bulguların eski kayıtlarla uzlaştırılması. Kanıt dizini: `reports/system_audit_20260915`.
2. P0/P1 başlangıcı: UXClazz isim üretimi, case-insensitive çakışma ve sessiz DERIVE hataları.
3. OOP çağrılarında somut doğrulanmış hatalar. Codex 2'nin aritmetik/Logic16/compound assignment alanı korunur; ortak dosyada gerekirse dar fonksiyon sahipliği belirtilir.

Diğer oturumlara tanıtım ortak DURUM ve SORULAR_CEVAPLAR günlüklerine yazılır. Bu, dosya üzerinden bildirimdir; karşı tarafın okuduğu teyit edilmeden teslim alındığı söylenmez.

## Denetim sırasında kesinleşen önemli düzeltme

S-058'in `UInteger=32 bit` gerekçesi mevcut x64 FreeBASIC host için yanlıştır. Yerel derlenmiş ölçümde Integer=8, UInteger=8, Long=4, LongInt=8, pointer=8 bayt; CUInt(4294967297)=4294967297. uXBasic dilindeki INTEGER=I32 ile derleyicinin yazıldığı FreeBASIC'teki Integer karıştırılmamalıdır. Kanıt: `reports/system_audit_20260915/host_width.bas` ve `host_width.txt`.

## Güncelleme kuralı

Her uygulama için değişen dosyalar, gerçek test sonucu ve kalan sınır yazılır. İnceleme, kaynak taraması, derlenmiş test ve mevcut binary testi birbirinden ayrılır. Derleyiciyi yeniden üretmeden yeni kaynakta test geçtiği iddia edilmez. Aktif CLAIM alanı devralınmaz.

## 2026-09-15 uygulama sonucu

- `tools/uxclazz/uxclazz.py`: case-insensitive sınıf/alan/trait/üretilen üye çakışmaları ve bilinmeyen `DERIVE` artık iki kaynak satırıyla reddediliyor. `tests/uxclazz_codex1/test_generated_names.py`: 8/8 PASS.
- `src/parser/ast_enum_lookup.fbs`: semantic gate'in çözdüğü ENUM değerini ortak okuyucuya taşıyor. MIR lowering, AST-x64 expression ve route coverage bu sabit yolu kullanıyor. İzole `uxb_codex1_oop.new2.exe` ile AST/MIR/JS/MIR-x64/AST-x64 `Mode.ON=1` verdi.
- `runtime_ext/uxlogic/uxlogic.c`: Lua candidate handle, exclusive load lock, rollback ve pointer temizleme eklendi. Gerçek DLL testi 4/4 PASS; başarısız ilk yükleme artık sonraki çağrıyı sahte başarıya çevirmiyor.
- `docs/UXB_TUM_SISTEM_KOD_DENETIMI_20260915_CODEX1_TR.md` ve `reports/system_audit_20260915/ENVANTER_VE_OLCUM_EKLERI_CODEX1.md`: bütün klasör/kütüphane/issue sayımı, paradigmalar, motor matrisi ve Claude kayıtlarının kanıtlı uzlaştırması saklandı.

### Bilinçli olarak tamamlanmayan OOP parçaları

`THIS/ME/SUPER` lexical/direct/virtual/base ayrımı, upcast/interface cast, ortak MethodId/vtable, constructor/destructor lifetime, native/AST-direct BYREF alias ve tüm motorlarda virtual/compound parity hâlâ açık. İlk receiver türleme denemesi mevcut AST owner bilgisinin erken aşamada bulunmaması nedeniyle geri alındı; bu geri alma bilinçli regresyon önleme kararıdır. Bu parçalar planın P2–P6 paketlerine bağlıdır ve gerçek çok motorlu kabul testleri olmadan tamamlandı sayılmayacaktır.
