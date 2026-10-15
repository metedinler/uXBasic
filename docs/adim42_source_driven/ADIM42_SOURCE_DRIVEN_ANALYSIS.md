# ADIM42 — src(30.05_4) Kaynak Odaklı ADIM36 Tamir Analizi

Bu analiz `src(30.05_4).zip` içindeki gerçek `src` klasörüne göre hazırlanmıştır.

## Kısa hüküm

Önceki yamaların tamamı işlenmemiş. Kaynakta bazı izler var ama ADIM36 kırmızılarını kapatacak ana parçalar hâlâ eksik veya yarım:

- ADIM41 CLI registry/output contract **yok**.
- ADIM33/34 preprocessor modeli **var ama meta-loop ve block capture eksik**.
- ADIM35 BIG number kararları **kısmen var ama type precision/BIGINIT return inference eksik**.
- ADIM37/38 include/WEND/file mode izleri **kısmen var**.
- ADIM40 kök düzeltmeleri **source içinde tam uygulanmamış**.

Güvenilir son rapor durumuna göre çekirdek sağlam kalıyor:

```text
ADIM30 PASS
ADIM32B strict PASS
ADIM36 FAIL
ADIM36 fail_count 135 civarı, missing_output_count 276 civarı
```

Bu yama ADIM36'nın en çok fail üreten köklerini kapatmak için kaynak odaklı hazırlanmıştır.

## P0 kökler

1. `INCLUDE` sembol görünürlüğü  
   `%%INCLUDE` preprocessor genişletiyor ama normal BASIC `INCLUDE "x.uxbh"` parser node olarak kalıyor. Included dosyadaki alias/const/function ana derleme stream'ine girmediği için `unknown symbol` oluşuyor.

2. String builtins  
   `UCASE/LCASE/MID` helper izleri var; fakat AST/MIR çağrı yolları tam değil. `LEFT/RIGHT/INSTR/TRIM` MIR ve runtime dispatch'e net bağlanmalı.

3. Array index lvalue  
   Parser `A(i)` formunu `CALL_EXPR` gibi temsil edebiliyor. Genel `CALL_EXPR` writable yapılmamalı; sadece callee array variable ise writable kabul edilmeli.

4. Recursive function type inference  
   `CALL_EXPR` builtin değilse `TYPE_OBJECT` dönüyor. Function symbol return type erken kaydedilmediği için `FACT(N-1)` gibi çağrılarda `numeric operands required` oluşuyor.

5. File I/O roundtrip  
   `INPUT_FILE_STMT` var; ama `OPEN FOR INPUT` mode state, `INPUT #` target ve string suffix davranışı güçlendirilmeli.

6. BIG number  
   `BIGINIT` surface/MIR/JS izleri var. Fakat `BIGF(256)`, `BIGD(80)`, `BALL(256)` precision suffix ve `BIGINIT(kind,...)` dönüş tipi semantic'te tamamlanmalı.

## Yasaklar

- `THREAT`, `PARALLEL`, `SIHIRLIMETOT` geri eklenmeyecek.
- `IMPORT DLL/API/LIB` eklenmeyecek.
- `TYPE_OBJECT -> RHS assignment fallback` geri getirilmeyecek.
- Genel `CALL_EXPR` writable yapılmayacak.
- Placeholder artifact üretilmeyecek.

## Uygulama sırası

1. ADIM41 CLI dosyaları eksikse tekrar uygula.
2. Plain INCLUDE pre-lexer genişletmesi.
3. String builtins AST/MIR route.
4. Array index lvalue.
5. Recursive function return type.
6. File I/O `INPUT #` roundtrip.
7. BIG number canonical inference.
8. Preprocessor `FOREACH/ENDFOREACH`, `IFN/ELIF`, raw JS/WASM block capture.
9. Negative gate fail-close.
10. ADIM36 → ADIM32B → ADIM30 koş.
