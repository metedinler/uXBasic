# UXB S-483 OOP semantik sınır kapıları

**Tarih:** 2026-10-13  
**Sahip:** Codex  
**Durum:** Kısmi uygulandı ve doğrulandı

## Kapsam

S-483, OOP hedef tasarımında sessiz kabul edilmemesi gereken üç yazımı bir
arada kaydetmişti: kalıtımda alan gizleme, kurucu içinden `ME` ile sanal metot
çağrısı ve parametreli taban kurucusunu `SUPER(...)` olmadan başlatma.

Bu halkada ilk iki davranış ortak semantik kapıya alındı. Üçüncü davranış
gerçek taban kurucu zinciri ve `SUPER(...)` söz dizimi gerektirdiği için S-485
ve S-487 ile birlikte açık bırakıldı.

## Uygulama

`SemValidateInheritedFieldHiding`, türetilmiş sınıfın doğrudan alan veya
özellik bildirimlerini taban sınıf zincirinde arar. Aynı ad bulunduğunda bütün
üretim yolları semantik aşamada şu ortak hata ailesini görür:

```text
semantic: CLASS field hides inherited member CHILD.X from BASE
```

`SemValidateConstructorMeVirtualCalls`, yalnız `CLASS_CONSTRUCTOR_DECL`
altındaki `CALL_EXPR` düğümünün doğrudan alıcısı `ME` olduğunda hata verir:

```text
semantic: ME virtual method call is not allowed in CONSTRUCTOR
```

Bu kontrol `ME.X` alan erişimini, normal metot çağrılarını ve kurucu dışındaki
`ME` kullanımını değiştirmez.

Kaynaklar:

- `src/semantic/semantic_pass.fbs`
- `src/semantic/semantic_pass_tail.fbs`

## Kanıt

`tests/oop_parity/neg_inherited_field_hiding.uxb` ve
`tests/oop_parity/neg_ctor_me_virtual.uxb` AST, canonical-MIR, native x64 ve
legacy AST-x64 yollarında ortak tanıyla reddedildi. OOP parity koşusu:

```text
Toplam: 122   PASS: 122   FAIL: 0
```

Pozitif `ctor_this_me` ve mevcut kalıtım alanı testleri de geçti.

## Açık devam halkası

- S-485: taban kurucunun AST/MIR'de gerçekten çalışması.
- S-487: parametreli taban kurucusu için açık `SUPER(...)` söz dizimi ve
  canonical lowering.
- S-484: `THIS` doğrudan, `ME` sanal ve niteliksiz çağrı ayrımının motorlar
  arasında eşitlenmesi.

