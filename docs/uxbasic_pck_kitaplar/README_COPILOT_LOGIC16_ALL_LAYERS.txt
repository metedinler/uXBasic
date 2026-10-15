# Copilot uygulama talimatı — uXBasic Logic16 tüm katman yaması

Bu paket, önceki operatör yamalarının üstüne uygulanır. Önce şu dosyayı oku:

`docs/UXB_LOGIC16_OPERATOR_ALL_LAYERS_KESIN_KARAR.txt`

Uygulama sırası:

1. Lexer keyword tablosuna TRUE/FALSE ve Logic16 keywordlerini ekle.
2. Lexer operator reader içine `==` ve `**=` ekle.
3. Parser operator contract dosyasını yeni öncelik tablosuyla değiştir.
4. parser_expr.fbs içinde:
   - TRUE/FALSE -> BOOLEAN AST node.
   - `=` relation/equality olarak parse edilecek.
   - expression assignment listesinden `=` çıkarılacak.
   - `**`, `**=`, `^`, `^=` kararları uygulanacak.
   - Logic16 op seviyeleri eklenecek.
   - UNARY node left ve right aynı operandı gösterecek.
   - TERNARY tüketiciler left/firstChild/right modeline göre düzeltilecek.
5. AST interpreter, MIR lowering, MIR evaluator, MIR interpreter, JS/WASM/x64 codegen ve surface bridge dosyalarına snippets içindeki kararları uygula.
6. `ID_A`, `ID_B`, `NOT_A`, `NOT_B` resmi yazım değildir; kitap/test/eğitim verisi için `IDA`, `IDB`, `NOTA`, `NOTB` kullan.
7. Testleri ekle ve çalıştır. Placeholder üretme. Test runner çıktı uydurmasın.

Beklenen ana sonuçlar:

- `TRUE` ve `FALSE` normal kaynakta literal çalışır.
- `IF a = b THEN` PASS.
- `IF a == b THEN` PASS.
- `a = b` satır başında atama olarak kalır.
- `A NAND B`, `A IMP B`, `A XNOR B`, `A IDA B`, `A NOTB B` parse/MIR/interpreter/codegen hattında tanınır.
- `^` XOR, `**` POW olur.
- `&` bit AND olur; STR_CONCAT değildir.
