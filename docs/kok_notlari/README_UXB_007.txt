UXB_007_REL10_FIX

Taban: src(22).zip
Hedef: release_pipeline 10 PASS / 10 FAIL durumundaki kalan 10 x64 build kapisi.

Degisen alanlar:
1. ADIM25 kindSet ayristirma: ilk harf kaybi giderildi.
2. ADIM25 route politikasi: container/declaration/compile-time/native metadata dugumleri opcode zorunlulugundan ayrildi.
3. DIM/PRINT/CALL_DLL/CALL_API dahil gercek semantic MIR opcode aileleriyle coverage sozlesmesi hizalandi.
4. NAMESPACE/MODULE icindeki FUNCTION/SUB imzalari main oncesi kaydedilir ve rutinler main disinda emit edilir.
5. MAIN_STMT govdesi acik program-runtime gecidinden emit edilir.
6. BIGINIT kanonik string payload x64 AST hattinda korunur.
7. Eski kisa CALL(DLL, lib, symbol, arg...) bicimi DECLARE FUNCTION donus tipinden tamamlanir.
8. CALL(API, lib, symbol, CDECL, arg...) statement sozlesmesi VOID+CDECL olarak planlanir.

Bu yama gate bypass yapmaz. Compile-time/declaration dugumlerini dogru sinifa ayirir; executable statement/expression turleri icin MIR opcode kaniti devam eder.
