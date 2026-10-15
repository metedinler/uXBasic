# UXB S-485: örtük taban kurucu zinciri

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Sıfır-parametreli zincir uygulandı ve doğrulandı; parametreli zincir açık

## Kapsam

S-485, türetilmiş sınıf `NEW` edildiğinde taban sınıf kurucusunun AST ve MIR
yollarında atlanmasıyla oluşan motor farkını izliyordu. Bağlayıcı kural,
kurucuların tabandan türetilmiş sınıfa doğru çalışmasıdır. Bu halkada örtük
zincirin yalnızca güvenli ve açıkça belirlenebilir biçimi uygulandı:
taban kurucusu parametresizse otomatik çağrılır.

Parametreli taban kurucusuna türetilmiş sınıf argümanı geçirmek henüz örtük
olarak yapılmaz. Bu yolun söz dizimi ve canonical lowering'i S-487
(`SUPER(...)`) kapsamındadır.

## Uygulama

AST yürütücüsü `ExecInvokeClassCtorChain` ile sınıf tabanlarını derinlik
sınırı altında tabandan başlayarak gezer. Her taban için kurucu varsa ve
açık parametre sayısı sıfırsa aynı nesne alıcısıyla çağırır; parametreli
kurucuyu sessizce yanlış argümanla çağırmaz.

Canonical MIR bağlamına sınıf adı, taban sınıf adı, kurucu sembolü ve açık
parametre sayısı metadata'sı taşınır. `OBJECT_NEW` MIR yürütücüsü bu metadata
ile aynı taban-ilkesi zincirini kurar; metadata yoksa eski tek-kurucu geri
uyumluluk yolu korunur. AST-x64 yayıcısı da sınıf tabanlarını vtable
başlatmasından sonra aynı sıra ile çağırır.

Kaynaklar:

- `src/runtime/exec/exec_class_layout_helpers.fbs`
- `src/interpreter/common/interp_context.fbs`
- `src/semantic/semantic_to_canonical_mir_bridge.fbs`
- `src/interpreter/interpreter_public_api.fbs`
- `src/main_program_entry_part2.fbs`
- `src/interpreter/mir/mir_interp.fbs`
- `src/codegen/x64/helpers/x64_codegen_runtime_emit_helpers.fbs`

## Kanıt

`tests/oop_parity/constructor_inheritance_chain.uxb` üç kurucu sırası için
`BASE_CTOR` ardından `CHILD_CTOR` bekler. OOP parity koşusu:

```text
Toplam: 126   PASS: 126   FAIL: 0
```

Yeni fixture AST, canonical MIR, MIR-x64 ve legacy AST-x64'te geçti. Aynı
fixture JS/Node'da da iki satırı doğru sırada verdi. Ana derleme:

```text
build_64.ps1 -Force: exit 0
```

WAT/WASM fixture'ı sınıf gövdesindeki string `PRINT` nedeniyle mevcut
`WAT string linear-memory lowering is not implemented` kapısına takıldı; bu
sonuç S-485 başarısı olarak sayılmadı ve WAT string lowering için ayrı açık
olarak izlenmelidir.

## Açık sınır

- Parametreli taban kurucusu ve `SUPER(...)`: S-487.
- `THIS` doğrudan çağrı / `ME` sanal çağrı / niteliksiz çağrı ayrımı: S-484.
- Taban tipli değişken üzerinden gerçek nesne yıkıcısının seçilmesi: S-486.
