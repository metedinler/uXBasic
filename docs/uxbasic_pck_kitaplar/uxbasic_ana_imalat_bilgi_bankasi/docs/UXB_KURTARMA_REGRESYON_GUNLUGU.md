# UXB Kurtarma ve Regresyon Günlüğü

Bu dosya, 31.05 tarihli ADIM36/ADIM45 snapshot ve raporlardan çıkarılan ana olayı özetler.

## Zaman akışı

- 01:37 ADIM36: Build geçiyor, fail yüksek. RND, string/file, PTR/import ve negatif testler açık.
- 04:05 ADIM45: Fail azalıyor. Ana pozitif kırılma PTR unknown type.
- 07:27 ADIM36: En iyi test sonucu olarak görünmüştü; fail 12, eksik çıktı 10 seviyesine düşmüştü.
- 20:42 ADIM36: Build kırılıyor. `lexer_preprocess.fbs` ve `type_infer_expr.fbs` tarafında FreeBASIC derleme hataları.
- 21:18 ADIM36: Büyük semantic/type regresyonu. Temel DIM/IDENT/BINARY tip alamıyor.
- 21:35 ADIM36: AST contract regresyonu ekleniyor. `ROLE_LIST node must not use left/right`.
- 21:40 ADIM36: Build fail/skip. Gerçek test koşulamıyor.
- 22:01 Manual snapshot: düzeltme öncesi eski durum; güvenli taban olarak kullanılamaz.
- 22:05 ADIM43 apply report: bazı yamalar OK; ama manuel takip isteyen büyük işler kalmış.

## ADIM43 manuel takip listesi

- `%%FOREACH/%%ENDFOREACH` gerçek block expansion motoru.
- Raw JS/WAT/HTML/CSS payload capture.
- ADIM36 negative gate fail-close runner.
- Array lvalue backend/MIR lowering tam zinciri.
- Recursive type inference tam kapsam.
- BIGI GMP/DLL runtime gerçek motoru.

## Kurtarma ilkesi

Güvenli snapshot yoksa hedef eskiye dönmek değil, mevcut kaynakta önce build almak, sonra çekirdek testleri sırayla ayağa kaldırmaktır:

1. Build.
2. Core arithmetic.
3. Operator precedence.
4. String functions.
5. IF/LOOP.
6. ARRAY lvalue.
7. ADIM36 negative fail-close.
8. Full surface parity gate.
